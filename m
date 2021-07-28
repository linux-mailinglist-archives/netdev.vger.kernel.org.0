Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B3B3D8AC1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhG1Jhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:37:37 -0400
Received: from mail-bn1nam07on2100.outbound.protection.outlook.com ([40.107.212.100]:59207
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231322AbhG1Jhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:37:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpAVg4p4hvquIYmsTMg1RZjQr1pQvUfK6QLwUvhxLy/ZJRUyDeYLv2e0ugq1kdGYgE0kAsQMWlqlrt5HUUnFQCMUEBBB00iU8dstKYX0KZ/soyNhXcejTQcKa0/vEKfnt5GpXDNaQ0wWZn36TvDTT/mYyinH8cgbru2aVaLlBkb+TPsdhX364feXRxZh4y3mP0A+TULYsY2yvbhcmJbMFP/JH9X0tQMRMoBVdA0FCVKFRBd8hiIRMlQoq2wEZAfsRPO0ptPeAq7QXvMAqO9mYjYNvsgS7W108grtU2ouqollWYEeq+O6OtbUtNmIYn0l36hFd/OPzppm9wUarI/hbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brwECbCqFC359Kfh1RA+iiXquT25LjE76lk1tHzFyfI=;
 b=J3HAQth6iKQ+m98e8hiBMXJyY0/TcTlMObluLGkoi9lJodLwPyWNIiFAH75c/o322Ch06OpqziV1PgyfgikJGq58ig2V+JW5cmN0YWmwViYk2z0obkl51ePtScR5ELKuYL/X3qIW6AFhaCOGJWq9FPLRNhkJmSXPfeKDoPBulJviDPpUuDEdJwEbAQ93dc9AQE3qeFiZUqscJxzFadFrzOfb0CvfrShq/UnrLPlQTaPIbmWRqaPtKKkbasOcEg5AtJh796/nCHLYyL84SfQWnYkECKeyWz/rEdEB6s8UlfvwY1M5JbL42FO4PbogiLIFd3lkrqRqPwCisFdKl92Mrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brwECbCqFC359Kfh1RA+iiXquT25LjE76lk1tHzFyfI=;
 b=uMdMrlPpR+coFMF9swUoffJrPy/yj176nOx6c2OhFs+Vy/KIEVzRs8/HcqFqWfGNrFl/WZEIPLcGQeaQTgExESRCrZUBFER7DJXJRji0dZ5p6sraimS7lt3SifMS1brepbxXY/+o6tcexyNU2++97H7PCj4nKJnZn1fYXFT+cWA=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB4052.namprd13.prod.outlook.com (2603:10b6:5:2a1::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.7; Wed, 28 Jul 2021 09:37:32 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::3c5f:ccfc:c008:b4aa]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::3c5f:ccfc:c008:b4aa%3]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 09:37:32 +0000
Subject: Re: [PATCH net-next] nfp: flower-ct: fix error return code in
 nfp_fl_ct_add_offload()
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        yinjun.zhang@corigine.com, dan.carpenter@oracle.com
References: <20210728091631.2421865-1-yangyingliang@huawei.com>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <0776b133-91f0-33ef-edc9-8f275798d44b@corigine.com>
Date:   Wed, 28 Jul 2021 11:36:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210728091631.2421865-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.1.2.53] (105.30.25.75) by LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Wed, 28 Jul 2021 09:37:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4996265-6822-43c4-03f4-08d951ab52e4
X-MS-TrafficTypeDiagnostic: DM6PR13MB4052:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR13MB40521508C62920D68061424C88EA9@DM6PR13MB4052.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QO3zvbjj156R36jPspigMgkSUq++0dT6Gd9cg6dOk2eJq+1ao2fS6bHhR1JYLCgFmnNOdqCVp79kGa7AZVz+rxbiwshQ/Fsy0i0/KfmYo57A1DXlgvs2fKDks4iiG43KS4/cgS6BXyJLpLtruQMXzJYabI9SNyz2viNgCPhuY2BmO7Eh7bmvAxHT2qzrei0JzkkkPceXOjWfIGlvpwdIRDqKcHFhkauH55uDVxrX9VQTIOxyhB9rRRbo+Y53e8b0Ax2uf9KDNfsB7IIDBI2IEFCSDG1nd9Xlhk0YB0B33n3lAiT2T1vBHN0DJXLoRngi+ngeCm5h7NLJ+1Lad+jlCJbrDNe0NfA2UFTm/F1sWmDlLzuLdgka3Bqx9WYjOv5Y56PV31rSS6Dl2PTqC5g9Npy2ms3SZqAk1fHDBU326lC45lUyArVn8jbm1EWk9upkAyzOyvOhOog+R+7sts8fqrn6+z0ijEfzVUvoHVCamaxsOU/k//Om7XUAttrcQ5n13zlh5lpLWgeMd8MoDBnMEe5qEJzYsSi8x91uftBaqvdCyWO3rAraJuhQdbFPP5aEiTdgFYhgASGfRz9zI0HkvYcMdhAFvEbLxg/CEPL8fYrBOlsX4WVC0FDCOIyCaXsvhXScpATkWcJq+BdkOTtHkT34wEJYqr7sqNkkHJ7mZcCNdCvZP0GB97VOcrSDZEewLwd8KrAlT9mH62WPudgVy8XmjNzGoJlVaRIhAS1AyTuYWZr8/ll2uPuGTu5lShcBQlIuDvRhmES6/Yd8DekbXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(396003)(366004)(31686004)(2906002)(52116002)(2616005)(8936002)(53546011)(186003)(956004)(6666004)(83380400001)(36756003)(44832011)(4326008)(26005)(31696002)(478600001)(8676002)(86362001)(38100700002)(38350700002)(66946007)(16576012)(316002)(5660300002)(6486002)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejVrbGpTOHJweXB4NzBIdkNNUzdpT2hxcWxYTG1qTUVBblhWOVpFOTljZVl2?=
 =?utf-8?B?Tm4zY0hCWHRoNktVNVh2UDBRamJBWHNCcFk4NVQ3OGJYd1lJYm8xcGgwL0RF?=
 =?utf-8?B?ZlVIbW12M2pKdXJ0UGhCWXk4KzFsRVdkNy8yNmFmdzFENnFhQ2tpN1lHeUw3?=
 =?utf-8?B?OHFtUWNLNVhINHRQbDFacDh5QTFzUis4MnJJQVRTWWd1R3lHSk04TE1SSHF1?=
 =?utf-8?B?ZE4zWUZlMXRmK1pZMkRrNUIwdmFVVnNkNmhiRXBidEFEakxEWUMrdm9FeU1H?=
 =?utf-8?B?MmFFelZIMlp2QjZNekdDRXlYc1VhUlV4NEhvK0ZYd3BmSmlVK0h3eEtoUXJu?=
 =?utf-8?B?VzV2VTYyb3JWU0RtMUc4SnJGWVVBMi80OEdBTHJQeDVUcUZLeE1RdzN3c1hJ?=
 =?utf-8?B?dlZWMWo3QUtzSmZDN0xTT3dxZXgzSWQ0NStaREZTZ2tydjVycUdpNnFSRnd3?=
 =?utf-8?B?Tm04cFA0K2dtVXhBQWJSVitXOUxUS3FqN3JEMTIxNnBjclhoSUJ3akx4RnhB?=
 =?utf-8?B?M01LeDRKL3gwOElGeXNuWkEwQmZDbyt6WHNqWTAvN2JtUWVqa2U0L1I1TEhs?=
 =?utf-8?B?c2tLd2FJcjBpSXJxc0VqLzNxRGo0M2R3dVM4VWlRcndTTWFiU0lYREtzTHJX?=
 =?utf-8?B?TjIrOWV6Y2hKclJMYldmaDdsZWlSYnFYaVFSejZvVFJBc1ZRVFVVUG00VUtM?=
 =?utf-8?B?dHZLeGIycWN5RkFHZG1oWlI0ZHVJVWMxekVMQ0g4Ym1CekVVM2pDcWI4Y1FM?=
 =?utf-8?B?OHFyT1hUaVlMNEVrR21VM3VlbGNteE9FeE9VOGF4RStLajJEcEV1bktrZ1lC?=
 =?utf-8?B?SjY0dmxQNE5SN0JPdjdJL3paQW5MakpKd0hLWkp4MStaOG5laitoSFNjQUw4?=
 =?utf-8?B?UDhqaks2MFFSYXhBUjNuQXd4djUrWjZ2S0NzK0ZHRTZBZy9tYWQrWFFkU1hT?=
 =?utf-8?B?Q0pwRkNjOVhUYUJNWlFiN2ZpZlBmdzhYc1dhdk5TcGpKSU5VZjR1eFRWc1FF?=
 =?utf-8?B?MFpYYStvYWxoTGMwTkt4dE5PdWVOTmY4RElRem5UaWhHUWNraVk3S0oxeE1B?=
 =?utf-8?B?Vk5TY1p3d2srNW5RM2hkNzl1bW05WUJhQVFJMldFY1pvVGxDc2hOOXU3VFl5?=
 =?utf-8?B?Z25KOUtxbk9sOEY5NGV1alM1Z0VJVWc1NTJCZlFId2VLcSs2Ri9rNlg4L3Zv?=
 =?utf-8?B?QXErN0UzTEtCS29uMGorcXpZV1l6QzEzanBLbFA5WnJNN3FvSzRZMXQ4d0hF?=
 =?utf-8?B?V3JZTi95SkxWNHVEZVRFLzNSbmJHd0tsY0FmNnZaN09tYXpHeE93K1NKZ2Z4?=
 =?utf-8?B?RGhHWTY3T2ZZYTNKWWdtZVJQWXBLT0V1SlIyMndsazVsSEVsdGN6ODhXUGR6?=
 =?utf-8?B?dGptTmhVNCtjdE5yUHlwN2tLek9nR2dvYUxrWjd2U3QyZ29Bdm9pSnUvcEdI?=
 =?utf-8?B?TUFBV0ljU1BpLzhWTXZwNzY5M2x0MGN4MFIvK2lUQ2dRNUlxNTZ4R3ZrZEll?=
 =?utf-8?B?anFYNnZIclRrbE42UTY0d05pampjM1NRQngxM3BUcjBtbFlxdzJQR0NCYmRS?=
 =?utf-8?B?T0RROXF6Tlg0dEFjczd1dk91Y09COE4ya0JvVldLRzQ1YnAxVU5hNzZ6bmtx?=
 =?utf-8?B?RjVrbnZ0d3djNEpEcHZFajFoVHZaa1kzNVdzU09QdDZrNnpReVg4T2dLcjdC?=
 =?utf-8?B?cFNqTUpuMXc5MXJ2VkE4eGNuZlYzYlZ4OHRidkQvalZkOEkxNFBzRzhVV3lv?=
 =?utf-8?Q?EddhTrmpkYCyA4QMvS1glY7pHgEbJ65zmcjKvy5?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4996265-6822-43c4-03f4-08d951ab52e4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:37:32.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9sTb2tnWZS+m/xzGMrqV//AdURuoUJFQnxmLV4bzVm1ffVyUBqLmOZjVCcbTkgVgcYkRoBrOA7qnqKdFTDNNDK9ONw1wnyECiiKg1MkJxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/07/28 11:16, Yang Yingliang wrote:
> If nfp_tunnel_add_ipv6_off() fails, it should return error code
> in nfp_fl_ct_add_offload().
> 
> Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Ah, thanks Yang, I was just preparing a patch for this myself. This was first reported by
Dan Carpenter <dan.carpenter@oracle.com> on 26 Jul 2021 (added to CC).

	'Hello Louis Peens,

	The patch 5a2b93041646: "nfp: flower-ct: compile match sections of
	flow_payload" from Jul 22, 2021, leads to the following static
	checker warning:
	.....'

I'm not sure what the usual procedure would be for this, I would think adding
another "Reported-by" line would be sufficient?

Anyway, for the patch itself the change looks good to me, thanks:
Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/conntrack.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> index 1ac3b65df600..bfd7d1c35076 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> @@ -710,8 +710,10 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
>  			dst = &gre_match->ipv6.dst;
>  
>  			entry = nfp_tunnel_add_ipv6_off(priv->app, dst);
> -			if (!entry)
> +			if (!entry) {
> +				err = -ENOMEM;
>  				goto ct_offload_err;
> +			}
>  
>  			flow_pay->nfp_tun_ipv6 = entry;
>  		} else {
> @@ -760,8 +762,10 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
>  			dst = &udp_match->ipv6.dst;
>  
>  			entry = nfp_tunnel_add_ipv6_off(priv->app, dst);
> -			if (!entry)
> +			if (!entry) {
> +				err = -ENOMEM;
>  				goto ct_offload_err;
> +			}
>  
>  			flow_pay->nfp_tun_ipv6 = entry;
>  		} else {
> 
