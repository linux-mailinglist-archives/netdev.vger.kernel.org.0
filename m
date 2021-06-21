Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0863AE2AC
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 07:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhFUFRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 01:17:37 -0400
Received: from mail-dm6nam11on2107.outbound.protection.outlook.com ([40.107.223.107]:48513
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229747AbhFUFRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 01:17:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrDX2Pj+Q73F118JaQh4NWCuR2w5yuvZsxf4ln6Tbj+jFCxmWTLyaAxfbwMJpR84CF8a7hiLOmNkKhY9jknqLXu3hRPv17o0GUoq7sA6kLjwCZsNbJehX21UOfHCn9JaTUmZVjciaG2FQckxOnfTqc6ifqgcOCLbB0pWI4WcNJqngQPPosJaVviaBtexoYRrBQBvQvCKwuqOkvRSCb7QkJiXRp0G9a+CTyP77tRG+wjC0JYtmIFcX9475NyrLdfQ9f9nI0fat/s66He7IOlCPUMI9w3tQF9gqstbNnM6RrBeCjwe46gtwgUXNAT9C4RZGRIU8dK2XRuigoovkFrF1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrbkJUyWwWfz31wTBDlzfFFOQuu7tt5MagSntHzFHj4=;
 b=LkUbw0+Sl+ug2Ls3gkABNykfMp3xqq7jQ+csmTLCbg//hxn/A4I++JzaG6ez6rwpy/oNAQzU105T1VHHpzQgjfIsemhNjR6njBZAYnIp3+OQO5DT3wNpRf7j2ahy1R3jk1Z2hZilDYHQ5mHQmV7S/0qEWw6yKiH5oD/K1X/T7VFdkKwFYLzXRTP7L9/4GeCxZTtgEdr3I1wrM1ZY1IcDvut9Wj1khbJNlQ70BwF4o7g2cvwUVvQzzEIQk8hwZ0xvm4NI9bQOPONaH7gNBnlFUetqRmpaUz7jUBEFkbNTE5wNPbHr/cGkfVb3rupzpYIPkqoQn9jNBsq1B290mcqSIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrbkJUyWwWfz31wTBDlzfFFOQuu7tt5MagSntHzFHj4=;
 b=bjjNBI4a6qO7NT/TGx8lOWRV4DpM/Mizltv8Gqx2OdVslzsqAt5RTRsm4snk+0Uqwt7KMLUV6z1cY6aBpDJoUgbbDgxPDBdtbLxl+N5rdAuSVue6PEWUO36/8kHRso4mbmyvUbccQQicb37zDl8TBd+O4mJDGSP9pQT2SCGMw2E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM5PR1301MB1947.namprd13.prod.outlook.com (2603:10b6:4:36::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.16; Mon, 21 Jun 2021 05:15:19 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::3c5f:ccfc:c008:b4aa]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::3c5f:ccfc:c008:b4aa%3]) with mapi id 15.20.4264.017; Mon, 21 Jun 2021
 05:15:18 +0000
Subject: Re: [PATCH net-next] nfp: flower-ct: check for error in
 nfp_fl_ct_offload_nft_flow()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YM321r7Enw8sGj0X@mwanda>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <94d89b59-fe5b-d959-e2f0-9e42ebf73636@corigine.com>
Date:   Mon, 21 Jun 2021 07:15:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YM321r7Enw8sGj0X@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [105.30.25.75]
X-ClientProxiedBy: LNXP265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::25) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.1.2.53] (105.30.25.75) by LNXP265CA0085.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Mon, 21 Jun 2021 05:15:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 028ac35c-7b88-4a05-4a49-08d934738f98
X-MS-TrafficTypeDiagnostic: DM5PR1301MB1947:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1301MB194790C34CEBC0C0CCDC7142880A9@DM5PR1301MB1947.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ztqr7WRNteaDgAl53IP+WII0mC53WN89pXMjGZie0FKlXrTOQgylW4HYUDMwQnU7haw6Pc5RuG1dSX0+mLbXcEWcQ9d9HSLaZFlr3kBkSk6XI1xoCVHn7GkoYNscpjee5T/4D07EASa7tDEMbph8SuBeEoEkKSJcwsnvJm5TUidGJRfNHvOHCjdNjkMVibAS8zr/T5YYvXHsUk+D8dn+y1D1VxtzRBFyLF9qWf61MB30IaJz1Xr7ZmGJA0/exJj1m5rBbskt0hUbaj3zrUXezv0SRDMxvR6KxqZAG+uvv/q8t6rECpmqx3zNPVSlJC7OvXzqqtT0lJ0bcH9L45YhS2ahL6IEsGU54PN9Ab9LG/Mdzri/Bkf9fG+2sLmPknaOoApr2hQwRKU+4Te89c/53JZE28E4RJkrdgGpR0LmmRcNAnARErM82TWHV8+PINkiqtYmAzB2t2von7JN2T++4K+a/B9d8WzEzMQvNlx6xn9Gk5+Lka7UR5Pxa63E5l8GZvbIhYwxNDtWPLZpEljq9Gzx8T+njQZ+UWCyEjNPC78RddcCcH/N/kT/Yk7EPa+hIuZJoueTeUG7UgaXiPJN/es8LBkU4fW119geHtr5rvFVAvxEMtApZgJxiTKb8Rz0yOVqexZ8HE0BNv3gJ7VN5qdFeo24sPF1PJenLmmex4iuDpBOJofVzG0DJreG8fKoHjfy21Ma3jdjpSb0LRvHSLDxg9BO0tPQ8okGVo4ZKRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(396003)(136003)(366004)(478600001)(6486002)(4326008)(83380400001)(86362001)(2906002)(31686004)(66946007)(54906003)(186003)(44832011)(53546011)(38100700002)(66476007)(66556008)(6666004)(52116002)(36756003)(6636002)(16576012)(38350700002)(110136005)(316002)(26005)(2616005)(31696002)(16526019)(8936002)(8676002)(5660300002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2pSUkNEYkwwQmZkaHp2Vm5TelRmZ21zWVA2UmtlOVR2clE0YUx1OUZQWTBF?=
 =?utf-8?B?aURWT2JmZmJ1d3BkTDdLaFF1aTRtdWlkZlNHdEJrOC9aaE1mWUlkU0g5STNx?=
 =?utf-8?B?WVRkb3l6MVlyMDd5YXhhQlZORnZzR3VXTXRJZCtHWEM3WWRZc05VWEl1dG9N?=
 =?utf-8?B?SlZ2ajJnSFZjSEJWc1JnVzk2M0hXbUJjb1draWsxTDM2OHBiSjdOdFV6SGtV?=
 =?utf-8?B?Y1hpNjVvZW9tZnUzZzc3SFpNdURzTDNHaWNWMFliS1JkLzdndHJxdmRXOXRz?=
 =?utf-8?B?TmxaaExBMUFKRTZuTU9MQmZFRktlQldVUThKdWRSL0ZYSG1ucDV4TURWRUF6?=
 =?utf-8?B?YzU4ZlYvN0dRbVJJdU5NbU95SVJ3b0M3QklUWWI3QkU4bnUyc25XZmtGRzNP?=
 =?utf-8?B?a3dEeFNRckxVdEJ0STlSWVUvckJFMTIwb0FFUWpUTUhtZmN4US9FT0JrTFgy?=
 =?utf-8?B?d1F6Um5YSDVVT1JGQ09RVUMyN1c1S0FSMGwwR2o0MUFXaWl3SFJVOUZvYit0?=
 =?utf-8?B?am1WSVBMdjJYT0tDK3B1SmFSK1hjY3B5c2FPNG9jZTFKWkgya0Vnc2ZYcG5S?=
 =?utf-8?B?aVpPazY4VVhtZTlPWksrSVo5bm5DZTg0RFl0eFNoTmgyZFYvNytjWEp3bUVK?=
 =?utf-8?B?d2tUNGxVeW9XbDNSaEFZRERjRUpTenRTU1hncVZ5Tit6NEdsV0dMN1B1MExR?=
 =?utf-8?B?ZXhjWFhSRC9NNEdROTdDZmpRNHBFeStnZStGcUMxNXZmUFhQWi9waHQrc0NY?=
 =?utf-8?B?NHU5NGNLdGcvR0IxQzNkNEp0RHdqTmVCM3FPcW4xL016U3Y1eVpya1c1bGph?=
 =?utf-8?B?akN1MVFCczB4YXlsNFg5bHltank2aVdhSmdJNGZ5VDU3UXBIejZ3UXlZWUtn?=
 =?utf-8?B?MFlQYTN1WTZBZEVPRWsvYi9uUVFFVXE3dW1ZQ1doRUE3a2lVQ05Vd21hZ3VN?=
 =?utf-8?B?dEhZdjBSNkVGa3dRY2NLT2FLTlZYK2dOUVp3aWhOUVROM0JSTzdDcnoxNDN4?=
 =?utf-8?B?dlJ0S1crZGNCdklpRitlbEdPTUNvdFBkT2JzalNyUzJBZHZCU0VZRFF0L1Fk?=
 =?utf-8?B?RDUvc3ZLd0s0enZJWFJnUFhoeDBZSGhIZ3JnM0pUczNYQ2x4UU9SbXRWUWxZ?=
 =?utf-8?B?ZEJ5NU1ldEhqYWFzMmRKUW4vdFQ5RGhkcWo5ejN2K0t1OHZCOGNEMFQvbzUr?=
 =?utf-8?B?TkZuNjN2YzZvTlQ1aVNyQ29KVUNWTzBGWEswd3NraFFqZXVFRU5YSXFybnBU?=
 =?utf-8?B?U3R0ZnNWSTNmOTFFeW4xZDdYZStLelNaRUFjY3paSnM1SlJOM3ZvRk9VYjFF?=
 =?utf-8?B?RkFHVkt1SkxzUWljVzBkaUFQNGNsbXFjV1JwZitnMWVEb3VaZVZWaGt4SHZm?=
 =?utf-8?B?WTc1SnIwNGxoSlRGUmcvQndiVHgrcHcxc25DcDU2S0F3SWwxeWw1RjZSN0dI?=
 =?utf-8?B?VUZmYWNBN083ejgwS2Y1RTMyVDlISXZtWkQzS2FXOFBwMU9PZjdra28rZ0lR?=
 =?utf-8?B?TVkvNnVzd1lJS3d3Q0xpZkJ0WkVKSW9ITWxnVHlzeVVocHRkNWhFdGVZcUNC?=
 =?utf-8?B?QXFKZmFiT1pMc0p5U3N3S0hpajBqZlgrNXdrL25kVWdhbkFtUUUzTjRsOUZ3?=
 =?utf-8?B?eU1nNFFpM3VnSEhZYkZoekVMMGFSWGc2N04rR0ZHQTdxcXpOQmNyb2QzM3k0?=
 =?utf-8?B?alRmQnlEQkFiOTRtcVJCQjl4cWFrbXd6SmR5cHVtY201bWM3RkNacHQzUE9B?=
 =?utf-8?Q?dqQ0cHUdv2xt2sZJphSJ0puoCEwtiR+UjKlMAgg?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028ac35c-7b88-4a05-4a49-08d934738f98
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 05:15:18.6440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o2nTtiP1w0LE05O7fNfUrZo1nWsuBI/poNouyoHVIcvYJ+v7Dea6mPUQirJcpvabZPNjuqRDF36iDYaDE/AIsLEIbYIW621bkrvVH05jz30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB1947
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/06/19 15:53, Dan Carpenter wrote:
> The nfp_fl_ct_add_flow() function can fail so we need to check for
> failure.
> 
> Fixes: 95255017e0a8 ("nfp: flower-ct: add nft flows to nft list")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Ah, of course, thank you.
Reviewed-by: Louis Peens <louis.peens@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/conntrack.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> index 9ea77bb3b69c..273d529d43c2 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> @@ -1067,6 +1067,8 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
>  						    nfp_ct_map_params);
>  		if (!ct_map_ent) {
>  			ct_entry = nfp_fl_ct_add_flow(zt, NULL, flow, true, extack);
> +			if (IS_ERR(ct_entry))
> +				return PTR_ERR(ct_entry);
>  			ct_entry->type = CT_TYPE_NFT;
>  			list_add(&ct_entry->list_node, &zt->nft_flows_list);
>  			zt->nft_flows_count++;
> 
