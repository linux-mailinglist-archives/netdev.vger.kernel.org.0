Return-Path: <netdev+bounces-2620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB8C702BAD
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 762481C20B12
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EC7C2DD;
	Mon, 15 May 2023 11:41:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7FBE7E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:41:11 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2113.outbound.protection.outlook.com [40.107.93.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6674C5255;
	Mon, 15 May 2023 04:40:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azP0/X0MDzTe7ampB2moVkFn0aeXRc3ZpSS/uxyWMISfqdIg0BPFhgPq8UOfJKHSmbpTTjQJ6RrsyLD7x9m4l5wy3NhX6bNFMaRLSAUKuoDvl3hDQh/RjC+WqWCFV5/kzESidweJKkkAQX0bEImJo7pviJ/yudfefpY7Z4ccXP+7vKWGpXBNVjV228HQjx57gP9gXzuvIqw0Hn3cU3OBA/GF7FG2H8FGfFucsSDyF2R5RubRDPgT97DcOKzrxJVCMqpzuKe1VxaJESVBCCwOmEL1ftxvHaMFw9Aq66rJHHFs1UsWuyNiH91J2r1iA24u/kmr6dSHAFREUsek1Ceumg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cizbgrs3Zu+HwFgqYGUXUyi5nMAnBf0KxqdcyY5ztE4=;
 b=Bw2DGWgXaVvyIl/qfehaU6aByJ0QtCevDCoSjPyXkwc0zZyR8ml2a64wGcQPBsoDZBb3Y2F0qnfQLYukWTDy3Pn41VitSkm36ykhuy0wTmAIBS6VYPlYHnxrKCYCnVDDF7IgtmcU5Y4WJG7oWQ131NPi1RWGodl/97H2J7gM1Buw3Ec7V/TtSgWKxy8aYbRm1DnOi+FrB2RttAAq7+LY5aDdipTVOj5eNkZw93vhoPr2to2sTpMTjdKJofCoRL+E7nSfFmlAJO0G5Xv+/gkGZYsJhXhqvXHxR38Nh/zEXBepRpeItqGVHi7Z4wmo/d5IlnEejog5Q0Rskj8j5phDpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cizbgrs3Zu+HwFgqYGUXUyi5nMAnBf0KxqdcyY5ztE4=;
 b=OX1UhJiM/1N2OeWwPhMK4TXMlfCM1dkeV7MrUvKluiOzBU+NtihQMIxV3IM4BdISCv+DM6T0l6g3Qf14z9l431Wd+cZEW2xEJIhvVSM5ZEllbH60DoO43heyWl6m+ANT3dvy7cnC6NruB0dkCOFp9wwngUJx9SLCoVagC4KFaag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3804.namprd13.prod.outlook.com (2603:10b6:5:245::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 11:40:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:40:47 +0000
Date: Mon, 15 May 2023 13:40:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Thierry Escande <thierry.escande@collabora.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfx: llcp: fix possible use of uninitialized variable in
 nfc_llcp_send_connect()
Message-ID: <ZGIaOYaSTDUqUrAB@corigine.com>
References: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
 <06bba9db-25ff-a82b-803a-f9ae0519d293@linaro.org>
 <ZGCb2CNcEDtDtPRR@corigine.com>
 <4c163376-ce89-786d-3c76-4f10ae818e7a@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c163376-ce89-786d-3c76-4f10ae818e7a@linaro.org>
X-ClientProxiedBy: AS4P191CA0028.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3804:EE_
X-MS-Office365-Filtering-Correlation-Id: eb2c3219-5979-41e8-9d8d-08db553939df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TJb4Q+VVRtfsyC99+WsKYGtFNGXxoNDbcmalIq5qGoAw+Krmr1PzxO3TlZ3fcUcaT8h3laJ97EnYRmJiXJ/QdOtmseAAssjIr/UJQ1Ioo6fTKr3SOpsGtmK/4VwVErvnpAc51TW644biZabTgBaDvJLVUq1xfOGH395/y5eEo8A1vtMB/PLFdl7OepTfDQfh54tsGpbmIlqXdyvJLKU8tU4eWixkdHrwW2tUn9bxMIuKwNJHBphDqfWkB5e2RUz7W9/fiNlaWUxYmzwh3UCVyHV/GIVsgDiWFn+WDpOqiXOmdUDxUOQXEPb10ulo4GeqNvRB85Qgk2MVl/MdTYlnJRhYE12300qqLB+UDhTJ81m6KmwoLI0DrhMufNIKYXH42L9kHj/+Vis+aRtY8gqoaJWkJgmQB1kWyC4FBgACP37r4Q2fl6IMvBDnOL1OIRkSIiBvKW1PYUZJb0u397lh0sEITgwxcejuFlwsj36V6+Cg006hpkNCvjaX5MVnmt27FLbJb2rpv+GOigxdocJuIoOhdnRjC/kkLSUvrnGuGBXi+xxSmM2dpF1YjCrrthBN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(376002)(396003)(366004)(451199021)(83380400001)(66476007)(66556008)(66946007)(2616005)(6486002)(6512007)(6506007)(53546011)(478600001)(54906003)(6666004)(186003)(44832011)(86362001)(8676002)(8936002)(5660300002)(2906002)(36756003)(41300700001)(4326008)(6916009)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qllE5D1JUIKjwKixOuD4TG+RCzxe4W/1k751lGbS8j7so4ivE4/iVN8lrQEf?=
 =?us-ascii?Q?0uHt6S1vHWobV7n08Gt//VJM2nA/g6xwP0MnrkovkKJxFkoiIsY1lPIhaiAt?=
 =?us-ascii?Q?pGO8aADByicd1ugIIvGcF7TVR3yWvUbP5mlCKnOVJhPZjiv47vO/+Bt6/dDN?=
 =?us-ascii?Q?R/7ITIX94B25RmRhQ1yuBuoDSziTHEBAQEpwackG2qfY+A8Gs2nnoPSzwRJY?=
 =?us-ascii?Q?SSURB2FNDd3eaETnouPdXCAH20K0aQW9bE+QVkPsYToFfoT69HBESqShsZm9?=
 =?us-ascii?Q?N8zvUj0258WjpLrBHXd6u/vsm9B78OhcFWnAuaU+Gz7fATRklG9/WYtBNIHa?=
 =?us-ascii?Q?92chMEPg1M/cOfjKFGtsyiKw7oKstrRiLJUBWtwqThMlgvy8ej7t4s1ZkFtG?=
 =?us-ascii?Q?BcmDDIQCxScDms8VMsP6IvIe9cP/OeF2NItf2Zqweao+fP5piv8rRGn22onm?=
 =?us-ascii?Q?pd7tUz0+ZDF2E2dIsWgb9yPq3OwjiKR2c+XxaqCdRj16rbWBDAkPewGGfLfk?=
 =?us-ascii?Q?JOzN+98wpH68XS+r9FaRhYvWQbx0toBjmIaeDpKtxqFOsQcGHkaZgc0Of5Jw?=
 =?us-ascii?Q?BzOAg1yKVxR4TiM3BqgE359+TgLnQZ9OhcMtc0khCZZwcBFGp+P95DdvKbau?=
 =?us-ascii?Q?1Oa6WZUJLPFu/+SttaqoG7cOjzjC4rq1GEwA3BgEmZNoUl0h2Gi2JJSLPedC?=
 =?us-ascii?Q?U0lCZIJQVZpZBhEeEqXKBgzskEv7mOK8e9bz/zugPuTfyE0rjL558IQJJztb?=
 =?us-ascii?Q?0T3UHUoC7i/nIEUWp2ZirtAsOHOAY3WneVPdl+14DxzlLJm2mGT0+13RQh8I?=
 =?us-ascii?Q?Ev/OzGaGwuCbwv6p1BUqPBQxFLDFLmZ5Ls7I+qd/c35QVMwQP3qt+Joxm3kk?=
 =?us-ascii?Q?NUt6SDIlLX8UYRPV+HEod9tngfBOOwOzdewxZytI1+McY0Ugd+qhFUJ7RUx6?=
 =?us-ascii?Q?6JfE20Xt7A6QXI59JV9+Hcm2zgU/0DVCL2x8x/RFI9vl9fnFsaGuqJBFE9vJ?=
 =?us-ascii?Q?dx61n5BnvZ1AscrS1Uvt5GnExP9WKJoNLmsgb0GgH0DIcQpPuT3UGY7PVM9B?=
 =?us-ascii?Q?v/+L5vj97QNXdu7rwRBhACyBWDUZ1sjQLnt07vsbgAUy2KTwrxWZNzfGbyQa?=
 =?us-ascii?Q?ciQb+7yd0DsdlaLr1HdBpVrZDKM2Bca8H/HD9aJz0eGKU5zdyDRKOuZTmD1n?=
 =?us-ascii?Q?d5fIhv7DyJO+BipvWtdRZwstJqca0IlyJG+VdsJk9TmXbWPvwUkhPvLMSaFt?=
 =?us-ascii?Q?x7e7oTwDGPhY1IQuL+3yumqkNH5dD40x3lqwrpjllKiIxAqf+sByx+g+YP+r?=
 =?us-ascii?Q?pgj86ERB+jsHPtNMtWP5Ptgw4z0GBU7krrsYW3SXwovhGwn/URPEzAyDKEDf?=
 =?us-ascii?Q?gtR9YNsVVa+ElgYxYbnGnwO9aCezmLkBJeMSHZ/gyUOt9yY1STBHkVKfzMEW?=
 =?us-ascii?Q?NhF/fCNlB2E83FN4xggUo4kyKHUirgLTifBpLmcUrgcxpCXWJUb1sZ1Ilrq7?=
 =?us-ascii?Q?b6yK+vQOdCSBv/NMSu1EmH724d1IZyw8IDCke7Z0UFbvbpeOiTNhvhD7tDo2?=
 =?us-ascii?Q?cZ3VsfR6QXyb+q/eS03gMYU7s1w+wpSq8ENGht/0nasfJDIke4/TXzEvl/bt?=
 =?us-ascii?Q?N73gqgmbI6YzUfccXU3SjPLVI6vZdnZzECPFwNvA16NptTg9l4GsXeFGjDBU?=
 =?us-ascii?Q?bHEKJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2c3219-5979-41e8-9d8d-08db553939df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 11:40:47.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEN/fNGEqYzpAwvIAmg4KTOxl8ziobr+9VLnP699r79JvVeCkkB9hqUaEhD6Ouwepvc3/FJJ10EUxb8iXUIack/9ohTdeavTMd12Ir+LMnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3804
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 11:15:40AM +0200, Krzysztof Kozlowski wrote:
> On 14/05/2023 10:29, Simon Horman wrote:
> > On Sat, May 13, 2023 at 01:51:12PM +0200, Krzysztof Kozlowski wrote:
> >> On 13/05/2023 13:49, Krzysztof Kozlowski wrote:
> >>> If sock->service_name is NULL, the local variable
> >>> service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
> >>> later leading to using value frmo the stack.  Smatch warning:
> >>>
> >>>   net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.
> >>
> >> Eh, typo in subject prefix. V2 in shortly...
> > 
> > Also, s/frmo/from/
> > 
> > And please consider moving local variables towards reverse xmas tree -
> > longest line to shortest - order for networking code.
> 
> They were not ordered in the first place, so you prefer me to re-shuffle
> all of them (a bit independent change)?

My slight preference is to move them towards being ordered.
Maybe that is not practical in this case.

As you point out, they are currently out of order.
And if you think re-shuffling can be done, without excess churn,
I think that would be fine.

Given the current state of the code, reverse xmas tree is much more of a
suggestion than a requirement form my side.

