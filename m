Return-Path: <netdev+bounces-5155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBDB70FD55
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 251F61C20B84
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AE72069A;
	Wed, 24 May 2023 17:58:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C551C76B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:58:05 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21EB98
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:58:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lnx/UfhHvJ6wnvsfCpJywoGD2i9VGuB1zGX5eZ/w4IIHGeiyAHu9VucaRD111ZMZl6gx4ytlEui3mlZv9s8BuuXmSyK6QsX7AGigWZOCG02Ky6cxQjX8Qrs1j1SyOAE9/vFivm1jwY7S/k2CQCDLmnAIwHGRx80HNCS/GiEZd16JtRGh4Rdz6CK4fAoE7pF1aNSvZIxRM7w2JsRzuDsYVbXmmyHLMs2FaleGqE/V6FD8zk2i9W28PqQd11jgUltAkiIV/P3fyZ1Iq0gB4VTtmB/DSzyZnrzaoW6yOM0i3nqqQQUAw6taQIPOu1ZZrsvypSITZ0PKP6mFb4l/q+11Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkG9J7UnOtlyiuVWLSQC2K5Nx0eosJH76Sm7En9AXNk=;
 b=U6sT8IGp8VQ0l2WcA4tpauPXafLT4Jb7d954MUR/7jgkoMDseRp5t/L3gfpNa0BFsoGi/pdVDzoUB5f6Dat1zWVen8LhZr3CnO44T2gTODfru14Eh+RyFd02hVKk/ZZVBkS2ojMoXt9YW6zW36Bzso8wyNKyeEI0lcSNIY+uMeqz9AETzG59M2Id7EqgkokFXZsv17FAoRoUS0/cb0qEKiDovc4gDnnyptyfudAj48LkXOszDdTlDLG8JdLqvXdw8WsiThuUr+hVSIn2eD14lC2k40kotrkEkqgrMaqsKbANRKFqNnKBUZGI3pOmKJHOx10tMReQScv02Gx7xpKF8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkG9J7UnOtlyiuVWLSQC2K5Nx0eosJH76Sm7En9AXNk=;
 b=W6QvhvDBI0jr4WBdKEb3dZ9Er59KHO753z/PwivDxAXYwSwI9Qz7dF6YQeZTvJrbTu880dSgEa4L52yEJflrnKrxVnnF4o8xmXrxK+GIYDsM3g/5u6dTgqv9GWfDKeh90bu32Qwefxet0UeO6avtmDldIspnE4H/dAZ926qzg4o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CY5PR12MB6372.namprd12.prod.outlook.com (2603:10b6:930:e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 17:57:59 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::e90e:337f:e012:aeb2]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::e90e:337f:e012:aeb2%7]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 17:57:58 +0000
Message-ID: <24213696-eb18-90ad-8e96-1c26bc1136aa@amd.com>
Date: Wed, 24 May 2023 18:57:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [patch net-next 08/15] sfc: register devlink port with ops
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc: kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-9-jiri@resnulli.us>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <20230524121836.2070879-9-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0092.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::13) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|CY5PR12MB6372:EE_
X-MS-Office365-Filtering-Correlation-Id: 5abb3c5f-5ccc-4e42-2c59-08db5c8068a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sZ7ELUcajLZdBK+9UnnIryJISSAbUBv0S7RGgZVrT1tFOhzvYX9M4bs5f6Iq4lySbLr5N51qP4S0jQHBogIdK9KNyzWOOJb/+4p27YgJXVlJ58JvkO6E/NJbo8hBrDRUaHsQvjEMnxAM7yeY/iPZhfIbpWdr1+LfTZqR5ZAWItp0z+UgDKHHVJggOF6mNf9rdzi97qOsoN7OtNNcDwFicZIhlYJyGX8EgXyB0Ba6vj4uZR0G1K7LIfah8UA93MJoqgI7UIcO3YM72NCU8tTVa7EX0rqhrsbcboIEg8mqk4VFd5eswtOIbU3gUTIumq00idYrl5WUBHmnQDphMe1NJk5iCE7oh1OoaGGGETGQtxPXGKn9/qOdwYVOuIH4yakVYm+rR4m7k3S0y1Jjb1GzdePhy4AyrAeEl2X6e64FDHQoTn0S/RTaYIm1tizuECug37086CfTO+JmhAtVQ4AwO34ILK2rI/5Iao7u/WIhLIeyYSpEgtirNBqOHIiS86Y7qTOhU47xWFQAuynloS5UaI0chW+k3nJOyhC8ixrLdlS/lhfLkIYKI0gBGBJMkdhV5PdJ+0tnop7PBcwA4xqSaMOKkTn27NGDYe0ctWXK3LX0R4+rHg6SNIwNS34l2RHEUBEWV+zKpRL2T9oef2Qc5g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199021)(6486002)(31686004)(316002)(41300700001)(66946007)(6666004)(66556008)(4326008)(66476007)(478600001)(38100700002)(8936002)(8676002)(5660300002)(7416002)(83380400001)(36756003)(31696002)(53546011)(2616005)(26005)(6512007)(186003)(2906002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym9CK3J1b0xYb2FGbE1YbTl0aGpGR0hqcEtMUE1OeXIrT0RKYWdLZHFjVHdO?=
 =?utf-8?B?WjNtdFJ6NWpPM3BseEV5c25Lc0xJN1VBcmhLTVY5alQzL3pyNHF1ZkxsY3pC?=
 =?utf-8?B?a0RHUGpwWFBKcGU2N0tBSDJNUkJLdGN4YUh4U0lNT2ppeTFoZjZrV0pqTU9O?=
 =?utf-8?B?ZHpoSzRkM0pheVVPbzFscG9TeUIwbkZlTVJ0OVVFUmk1dThBalgxTXRxVVdl?=
 =?utf-8?B?eVR1Ym52aHFGdU9FODJLV2w5TUxuYmJvRW9QNnJsSWM2bzUrWTVJTXJyTzg3?=
 =?utf-8?B?aXU3SXFTSHNTR0ZGSEtwVytMZGNDZGNJM2tNRnlLcHJYSWRzeTlWc3daT29l?=
 =?utf-8?B?b2NEUUJpYnZtSGZadWQ2aTlYMnBTYjFKS0xSekY4Mzl3TzBSZC96OTVDZXBQ?=
 =?utf-8?B?TkRRZnpETThxeWZQUjFDSk1zT2ttWnRVSTdJKzU1aW9NbHpaaVBKNkNmc3pB?=
 =?utf-8?B?dzJBOU1OSjdPeFBZZWZKSS90cnVvbTkrYk1Ea2MvbkF4WlppRU42Z0pDUUVk?=
 =?utf-8?B?VG9iREF4cW9zZUF5NWk4MFFEcDNIVzNKbkd0RmdSamxWZDd4NHNMMmZ4YnBt?=
 =?utf-8?B?QjFuNENOSi91a2NRYktlYTJqakIxNGdUN09ieEtZdVNVTitQeG5hTDFOcXR6?=
 =?utf-8?B?dXBIcXN3LzBHVnJtNWZ4N1VIcDVuMnZPRnpxbnovQU1lak5heWlFUllhb21F?=
 =?utf-8?B?Mm1wTVRHNnppVFlwZE9ySHc2Y251bm9wdjBCeW5tZDd0Nm1zRitvSk1qdnpQ?=
 =?utf-8?B?ajdTZ0tZSEF0RFpLYTNMbkkrMDlhNGVHNkNRT3Zlc05UTWlUNXFjV2ZaR054?=
 =?utf-8?B?bGRWWHFhbWtkeDBzN0V2SXM0SHN0aHMxSmdmNzlsdU1ud1Z0Zy9VVHk3S3Zu?=
 =?utf-8?B?Ti9kNG9UOTFiaVg2RjhXbUQwUnVoaUNnVHBzTFVwbVllbDdVWUxFcys0U0pv?=
 =?utf-8?B?WTk4NzhIOXZXczZldE5QSCtROHFSUmNPOUlwNDFMK2l4RmJKUndnbmdUMklR?=
 =?utf-8?B?aWxlc1dIcUhmRHlKUzFFajVkU2kwUjd5cnRpTytSREpVYVQ5SzdJdVhTS2Fs?=
 =?utf-8?B?UFI5SlZXcW5Ma3pFUXNoQUJ0RVBUTmRWQjM1NmkxZzZBT0NaY1UrNUlGbDds?=
 =?utf-8?B?UkhDWjV5czlEa0s0U1Ywdzl0YUpWVUZ1T1U3a1dCTFZ4UEhLWDBzaGRORmNO?=
 =?utf-8?B?Y2txSWFmSk10MHFNSzVaaFJYOFRjQkNKVUJOMjNSaFg4SW1oQ1ZsMjdteE8y?=
 =?utf-8?B?WTBSeDJYOUJQSkdLVnl2VjZIL1FwYjN1UFVYOExGUkZUdEhCczVkRk82Slg0?=
 =?utf-8?B?SmY0RzBTR0k2NzJtSHhTc0JzM1VvTS9KRmY3RjdLbzhNdnhvRms3ektnM0RI?=
 =?utf-8?B?ZC9lR1p2V0dnMmYya1ZUSGNNdDdxUStiajdacUU1eE8zalFkeGJ0aXJCTTNj?=
 =?utf-8?B?QWdWZWFkbDdXUDRkaVhoNzlDR1NYQkpQVy8zYkRCYWZzOWI2UlpBZGxVRnA5?=
 =?utf-8?B?UkR5NG4zVzRvaUhvZlhDZmRId3Y4VHE4aVVyOHlMMkh3TzdVbXBvTnYvdlIz?=
 =?utf-8?B?Z1YzNXJsb2c5bk85QUErZ0ZpNkhEeGdwRGJNYkpOUkQxK3JzZVFUSzkwb09i?=
 =?utf-8?B?Z0ZUallob1JIRWZnVG5JQlMrcWlVZ1ExMzhGTU05a25BazNjaXAwdWVjTHNF?=
 =?utf-8?B?TkpHTEkrSVJnZDJqajdmY0plR2RDVG82NEZnd1dRV2Z5alJvelUxVHdCLzlZ?=
 =?utf-8?B?MXZGRHJTMDRML0t4ZFN4L3lUbURlOW00SFA1TzVSWEYwZUJMSEdYZTNUd2sv?=
 =?utf-8?B?cGoyb29qRzVGVVprUDdqZEtxWWNET0ZwMzNnbzIwT2dtdFYrMWt1TWJhN0p5?=
 =?utf-8?B?NU5rNExGdHArTHZaQjJOK2Fua1JIT2hneTZkN3VROVAvaWhmWmNSVWJreWxp?=
 =?utf-8?B?bm10M2VzOUNxR3hnOW9LZE04WmlaUlVraXBQOXNBQk9pSEpRMmpaVEJpb1N1?=
 =?utf-8?B?R1pvc2wraGJSbkw0eHVUVnJ2SFg5ZElGZ0FvZ285QnRUcDgwR2NMSWhzWFdL?=
 =?utf-8?B?aFRIRm1OQVBRY2RiVHA4dE1nR3BVZlJMUGhjWjFiZnBiWGZ1REg1V1YvMUhC?=
 =?utf-8?Q?t3hwADpWjk7a/MXqcocU1LKAF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abb3c5f-5ccc-4e42-2c59-08db5c8068a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 17:57:58.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gY2INh9THYfmchLVyKrVWfSpRJJAkxDEZw26DpZkPm7cq76hw8ka+VbS4bJ0zUZGpCj1wADCJdlCufkZuS4umg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6372
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jiri,

On 5/24/23 13:18, Jiri Pirko wrote:
> CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.
>
>
> From: Jiri Pirko <jiri@nvidia.com>
>
> Use newly introduce devlink port registration function variant and
> register devlink port passing ops.
>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>   drivers/net/ethernet/sfc/efx_devlink.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index 381b805659d3..f93437757ba3 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -25,6 +25,10 @@ struct efx_devlink {
>   };
>
>   #ifdef CONFIG_SFC_SRIOV
> +
> +static const struct devlink_port_ops sfc_devlink_port_ops = {
> +};
> +

We can have devlink port without SRIOV, so we need this outside the 
previous ifdef.

Apart from that, it looks OK. I'll test it and report back.

>   static void efx_devlink_del_port(struct devlink_port *dl_port)
>   {
>          if (!dl_port)
> @@ -57,7 +61,9 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>
>          mport->dl_port.index = mport->mport_id;
>
> -       return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
> +       return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
> +                                          mport->mport_id,
> +                                          &sfc_devlink_port_ops);
>   }
>
>   static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
> --
> 2.39.2
>
>

