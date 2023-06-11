Return-Path: <netdev+bounces-9873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E3C72B032
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 06:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 965DD2813CB
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 04:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF9517E5;
	Sun, 11 Jun 2023 04:16:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748FB139B
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 04:16:03 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758C8134
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 21:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+BIvrPwhbDC3cOkZIovsP/ZO6JiYgkZC3CiVXr3tbE2Vz32X2smdYhD2hIUD6YcVNwEEftGWNngrerHS423jWD4kuHbYnclKEBhZNiSQG/RpMnn3NdVi9Zx/wWf9qxJJp8fycLXLqzGX21IXm76DWYggcDEPXVYQlHR4Bp0WBnnDMQXCs1/gb90BREw4bMmqfYsZeODipoZyBve+6KFuXcklsPIprVKH5iNOiHFFaRuDvHcW5YBigzCVBkhzsGIdSIaxhmmTMhKgRJRQjqOMhN+lRktF0CEsuOgjVnukN7QR8xb847BEHotX3+ZH0gj7mj1yqCsmoqjL2vDAdi2Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oMGGi7VTVyL2bxx7VfKdEPRopqfKc9CkZxRq4R4hjs=;
 b=Kel352vmPT71DJhbuR77587Dzp1L3+/5HkiHHSOi6dnKbcAG6wnT/wWErfQ0YgZJ0PZ4gndGdGTE9BVZhQmTMj5dhKn+mXzjhTi9MkSJy/F4XydgBGfOmvBEPx+7s22tf0q7z381oT8/7u6YAZwajK9y26iAnKkreWwZLbPv9n7HszHRiWQ1xcHgKJa7Btu+b8eMwRXh34L3evY8yEmVwqZDGt5SGyfaiblMVJzIToljMoBeiozDP7kfu705UXGiMLTNDmktEenEJuU6YPT/CU1geWEi2uCVDOKM61APWCnH0IuBA7BzxqtnEf1rOXdYkyg6L/76ozSJ7MkoUCikdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oMGGi7VTVyL2bxx7VfKdEPRopqfKc9CkZxRq4R4hjs=;
 b=mw/1aJ/jcvR0y86Uc9eAUPm4Q224sX2VuhzrZYeFGATDBGF9qEqRT/qAxFuH4YDmbyL+5fOU3i7cTAW8UFlpQlSr5P11o+w+/fQQfSbllujryJ0a+NC/J9kW4slC3b/GVtx1xedmNlvZBPXHuAjNPsrmUh1q1eqsvJqiyvtSeeChYnp7ANFnI4fasGoEr1N9SNASepkfYFQLjogn2+KchaVIOzaUQkLzG/SAnsKKSdELkBFtWDZacsUGe0Fjkd8reEBfTarQRWlQ58+2sMSya/QdHpKbV7ZDOOWIpemieRQj0fBTpr1PmAc4nMIHOslthOUqz5eprf9L8PGAM2OX9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Sun, 11 Jun 2023 04:15:59 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::6e9f:b7db:74b:b379]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::6e9f:b7db:74b:b379%7]) with mapi id 15.20.6477.028; Sun, 11 Jun 2023
 04:15:59 +0000
Date: Sat, 10 Jun 2023 21:15:57 -0700
From: Saeed Mahameed <saeedm@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <ZIVKfT97Ua0Xo93M@x130>
References: <20230610014254.343576-1-saeed@kernel.org>
 <20230610014254.343576-15-saeed@kernel.org>
 <20230610000123.04c3a32f@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230610000123.04c3a32f@kernel.org>
X-ClientProxiedBy: BY5PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:a03:180::47) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: 343e8442-0b77-44ef-3f53-08db6a328f95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PKCLb2H4rL4UIsmGENb5HIzSS0JAgYZqhlwTME+cD+IuRk23LYBksyP6YGPggfLuUtCg8E/hJn1dYj4CXBhKh/6J4/aKbSckALfwo0u38IS5Tl0vnVp9TON//0Qtk7ExROmXh/sdtW0+SjG/tWTpK3Uyhot89gdn2PE9WyzPJiE1+KsYdW/SZmKHqigJXcxj9W7GZT/fvh5m131/nkHD84jqe9DDunrvHVyejguxMxFNw8HNjQK1rmljOh53M9xo0ey1PUPXS+56Zug6a+kSyHpQXWlmGwyuc8RT+bNhWac4ErQALcbmgJPAXIhJXjkQBvKHCTvlDm/OXHES3+tmCCGFlK1nGC/46gu6qERFWjluEuS7EdEDcI0LERuGRh5DMGQ7+lyx+H8YasTHt6gda0rgyzvt1FI2MYJQG+NtQ2TxkVyzJVRjfm+cbQ7vzTo7y6wmWw8C3Sks0BIAhOMSGoGX+l2QhyGjKjgj5Cq+wiOOAJDIyPpwJdXzPI5iUdKSyBHSJgJ3vjrX9v8uFq7EFbuFqekLofbrRlgDIkzrJ0Vf/8nwEikW8RfxdweVKuNs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(107886003)(6486002)(83380400001)(38100700002)(86362001)(33716001)(9686003)(6506007)(6512007)(26005)(186003)(2906002)(5660300002)(54906003)(8676002)(8936002)(316002)(41300700001)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yw6gSWwnkkW1LPPELf6aTDCB7qF9VL/Q/VK0KUk+LWi1amS2htQ51IlcbunA?=
 =?us-ascii?Q?D2Fg4Vniv0AaeNh9k8SUqv6PG+fO0Hmj1y6LklPKUyfUORQD6h9rfZINy3L2?=
 =?us-ascii?Q?HLBLTCCIYl9Hodof0XmyldY2IsEHeBIA3/4rXU69maU54JjEYSrSq2R11A1Q?=
 =?us-ascii?Q?uYg0imzzhhj8A+VFoTYOPPLunR0Fty5Bl5h3lODYxy40gOkjP7uxwEplqKIm?=
 =?us-ascii?Q?652HaH/FymJO+ivoAH8Tkia6Qn71tk2gH2AG1/qulInKN059iVu4IR6rY2jY?=
 =?us-ascii?Q?g0FWVVbp2CMEND1ijAMggLQk5JzGbiuQe5zK4Cl9lsFW4NjCLTV+HEb1DeNk?=
 =?us-ascii?Q?JXYMQCWsR/yxJzoRedt06F2pcmCPdlDhS/BlbQrHI2Fzhd6jl/fwzSFCphLh?=
 =?us-ascii?Q?HJyCRuGM4hCoaCEIyTtDxEzhzrOtajK1QwpQue3pa1pEqJlInE/QLEpsv2Jg?=
 =?us-ascii?Q?tfNsnUnMleFWc7SMtLzHiFnZMl47HpK8hhYXUTaWdpn/iham6fj2QJ6N69vJ?=
 =?us-ascii?Q?Cas319E2HM+hVuyz/cvLty1kARNCHTJuMbTX2HwzxFmsOG3nwCw2dNuPREpy?=
 =?us-ascii?Q?3R9G5ctTCOKaJhw55Kk0Ntee0EZLBF5Q71KnLNbezhtCvSZCZ5Ff/RQ9SBrF?=
 =?us-ascii?Q?LVTTw483U029Vii7+Qmjo1dEj37x/O7bJjfXmgpe2rfd1W9kWK+WukmvLySW?=
 =?us-ascii?Q?UHh/bW+eQu3loxwxgLrpTd8dPS8y1jQvT9lvgHfEW/Gw/yN/V0FAVDDSnpiQ?=
 =?us-ascii?Q?REbLDVtxK7SHe2ccXPsRQSmOPX/7aG8YcXOPTC9mNbn6wzW6W5Wxn972fhJ/?=
 =?us-ascii?Q?YDVRyOeN7eDTA/uLrAAZnnS29X+QLYI5vIyxhrCC00F+cALhI7sDiBnCe2kz?=
 =?us-ascii?Q?WRfQh1kmD+u4ZrRrc1kWcVBllzm0Gvu0jxNdBaXLGNBr01Oo/GbTKkHZMjbn?=
 =?us-ascii?Q?iV6lue8hiI6GP2kfCF+RUJaizZLoDjBmEVp41axbDXe0fXp9wfDZatgOeANm?=
 =?us-ascii?Q?cZ/eIi4h2RTiKvPGf1MSTkvwHwJKqx86+XLiA957qPKSXH9E8fwZoWJ0wt0F?=
 =?us-ascii?Q?HhePzyvgxNqkTbll41xdtdgRAsRt9HIfBvxC7BFqIQqmO/eNMvKLWn5VXoyK?=
 =?us-ascii?Q?t2YTbz77u4Nln1oeNxeua0dp2syH9BceCYPn7eGaC6o7U/MUU0mQdK6hrceu?=
 =?us-ascii?Q?1iFNCuhG8aJDTOpEP+iqboiWswfisxHjIgK4aBNgcIq+/vIeZ8ObQHnxnKb7?=
 =?us-ascii?Q?qAFs08cHogPM05F5hsZ75wK0NQt2uCISMYfez/9tr3Ls0fHZPBZ+G/n33yWL?=
 =?us-ascii?Q?xCdzZ46SQp1KKYg6s83Kz2hk4mDkNfn+z4QOm76+4a0PF3ZfGiNYPAAcT/s7?=
 =?us-ascii?Q?6eEWx28sPYoVnJt5RvMvuAgwSiFsFU9JgJr4oQRzyHOpyFTHGidsrOZu7umW?=
 =?us-ascii?Q?kbljBkGYqd6crXRlxieZWswI80vmCYM9MizNiSl/57gdKU1g68+7LKTzifxZ?=
 =?us-ascii?Q?ArWNBaKed8FzVamPfoT9vUz2DZMxSFkBDe2yUnEm6/YlEhtGGi8DPDV6hAm5?=
 =?us-ascii?Q?uSDwCaeHaReR/4qdJz7h3vkz/5fYyUwRwbSYsh/G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343e8442-0b77-44ef-3f53-08db6a328f95
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 04:15:59.4856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfChaHhcu3RVDEhECXRqTZ14Dc/z52VEc646tLCkz660JPJSJJjvRaQZ7JkHIYgCVDIaPVkmX/DihecXK4rCCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10 Jun 00:01, Jakub Kicinski wrote:
>On Fri,  9 Jun 2023 18:42:53 -0700 Saeed Mahameed wrote:
>> In case user wants to configure the SFs, for example: to use only vdpa
>> functionality, he needs to fully probe a SF, configure what he wants,
>> and afterward reload the SF.
>>
>> In order to save the time of the reload, local SFs will probe without
>> any auxiliary sub-device, so that the SFs can be configured prior to
>> its full probe.
>
>I feel like we talked about this at least twice already, and I keep
>saying that the features should be specified when the device is
>spawned. Am I misremembering?
>

I think we did talk about this, but after internal research we prefer to
avoid adding additional knobs, unless you insist :) .. 
I think we already did a research and we feel that all of our users are
going to re-configure the SF anyway, so why not make all SFs start with
"blank state" ?

>Will this patch not surprise existing users? You're changing the

I think we already checked, the feature is still not widely known.
Let me double check.

>defaults. Does "local" mean on the IPU? Also "lightweight" feels
>uncomfortably close to marketing language.
>

That wasn't out intention, poor choice of words, will reword to "blank SF"

>> The defaults of the enable_* devlink params of these SFs are set to
>> false.
>>
>> Usage example:
>
>Is this a real example? Because we have..
>
>> Create SF:
>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>
>sfnum 11 here
>

This an arbitrary user index.

>> $ devlink port function set pci/0000:08:00.0/32768 \
>
>then port is 32768
>

This is the actual HW port index, our SFs indexing start with an offset.

>>                hw_addr 00:00:00:00:00:11 state active
>>
>> Enable ETH auxiliary device:
>> $ devlink dev param set auxiliary/mlx5_core.sf.1 \
>
>and instance is sf.1
>

This was the first SF aux dev to be created on the system. :/

It's a mess ha...
  
Maybe we need to set the SF aux device index the same as the user index.
But the HW/port index will always be different, otherwise we will need a map
inside the driver.


