Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1B4EE0D9
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiCaSqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiCaSqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:46:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F5E62A23
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:44:25 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22VHPW0q001326
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:44:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=dDOyHN/nO2VGn2JFN6wnwFeqGv/BmYHvIiXHmJwotlo=;
 b=lVkZZH1OvfyhZu33LynzEb/MnfbBBtO+sl2ajdUbQ8gRnK5daBMQh/pq7qiSKSXB7hmg
 LP21BsFdRf/93Tl8dQ1Su1DRdKR/AfchSfUOucXZMAz11wquRUN/cWuErL2AMyen9zuE
 HPoIbzqTkegObZvJNQL5VkjkQWDcPQu1tB4= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f5gpcgx94-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:44:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRSOjVM3wFnvD1R+1CEVuFS/HwYGLN9c9DkrKTIAJ4g3D3cg2NTdK/tZ+gfx76HYKtU8vIOejYcYNK1cLGrDtVypAEcd/DfNYG9ti2eJo8OdX03yJlb5royDYaxvTsLD8HB5m/RNlC45C0u9hbCv9iFCMbZThy8eYeDgBfLX3Gq/gCo4jR0pUe+3R6Sdl8bCRcjpPi5Cswd3W4AgdouT+Uv/p4q2Kt28verIG8MgXziwZkRqM1d6mH1YFr7fUle7IZ++5NUMFhdavYS7h742XrzlKRxbNCihyd5qnfPTqViC1kLk56rRX9JgTm+96aoVE/dz240HwAd469VHFwqlNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDOyHN/nO2VGn2JFN6wnwFeqGv/BmYHvIiXHmJwotlo=;
 b=Otza81IjrunCxjt++tmxZe7rWtlNmBAbcXUvXD43Px9hGOaauxB4AakBFP/8yO5nd3E3A3mMjUo4Jvg1pSzCYH+LKA3Tm71ZuRbvfOb1mt9IZ8H9dANBjvVFg/DIpwN3kxgB3694HLHT/nbDDQFSYdcvbVLjCMS8JbQYGuatMSlGOYcnyo8hsNb54ks2VdMKw4b2YGxDKRfQhr/1f8yT3jjaBVCuZhDifHCrWGMinIlX1jtZ51HacN1t8+8QSXod0qpPBOuDyBgv6oZfw3rF89pPtE0WnsHEfZLdBiwvLd+qw0D/VVwH+y+UjCyXOmYtnV1Er/0yzRt+GymweWgS0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW5PR15MB5121.namprd15.prod.outlook.com (2603:10b6:303:196::10)
 by DM5PR15MB1531.namprd15.prod.outlook.com (2603:10b6:3:cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Thu, 31 Mar
 2022 18:44:22 +0000
Received: from MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::f0a3:d4e5:fb3c:51b6]) by MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::f0a3:d4e5:fb3c:51b6%4]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 18:44:22 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>
CC:     "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
 recycling
Thread-Topic: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
 recycling
Thread-Index: AQHYROq/O8pWwbXuikyfM1tbLQYmY6zZ1BLg
Date:   Thu, 31 Mar 2022 18:44:22 +0000
Message-ID: <MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com>
References: <20220331102440.1673-1-jean-philippe@linaro.org>
In-Reply-To: <20220331102440.1673-1-jean-philippe@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2328ed8-9554-4380-2070-08da13467928
x-ms-traffictypediagnostic: DM5PR15MB1531:EE_
x-microsoft-antispam-prvs: <DM5PR15MB1531BE62FA871F48C37C7886BDE19@DM5PR15MB1531.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K8xJxfPtfMgCN9US3TfYD7pLz5e+tw3mC5J938dY3noEHt54pYYg3lDoQ9cKFa2vbi3ekogEBuPd2mq0dFvzydTKN2l9NSJeja5AjNJ3KfX1cVRNLuAZYKmgFVmPiLUc4LoeIqWTx+nDEGWzMtgCJGgqqk6sMQBSwGvL2BBhu8oW8MzlKZoUgkprEsezA+KgT6z6mIicYFLVBpA2lDykOIsmfJq2EkHcImLtC0+qxpUD/SlLrhVBlY68loTQXX7uY8VBQKEF0g33MI9Z0OYIyZOir7JGbQHJ97VESLsB8C8N7Q3yi4A7ODRwwes3jkpUj6D6ZMcyceH18vXeJ77sm7EffLY04OKkUMRqnkVpGxWnhmjpPKYS1OESU6DscJ9MK/8bzeaIaFJAmjRWaS64iHtvSe3Z4Z9CvkleZEqG8IblH8JD3gt8hdIUbLq098UW7318XHYktr4+e2EBBLyiLTr6Sru4zT74aYj0h4q1MQco/DEfjOMbRy4dCxVajexAhA8UvfhJOA3Vpy1aKMBbO9x4tdRGaDXJpOhhKScWXs8mIOh81Q3MkzPwLmupU9OM4XQEmF94oTpXQJLrl7I1KN9IgHGtL4+2WYcgxMrriT2UW/gl6kX7aG6gh5e7BMvtxu8sICJib+J0KcY4GbykeSO/rPGJ9Y4+3QIeTW68WiBUFOIEQuYQfJcI+9/w3uVmzjJtniYvcDTW7Kc+5JpBuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR15MB5121.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(8676002)(66446008)(4326008)(64756008)(5660300002)(316002)(110136005)(66476007)(76116006)(86362001)(38100700002)(2906002)(66556008)(8936002)(66946007)(54906003)(122000001)(38070700005)(508600001)(9686003)(55016003)(186003)(83380400001)(7696005)(6506007)(53546011)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1lien9qITr9EC9nfHNErjq01fARmMxuaApSf4M9Zs1+hfcue684AnqTixcdB?=
 =?us-ascii?Q?JhMDvCSL9HzQ2P47MQF6CArL7yaea3fI2+J1tMNvEdSIHZIXSISSpwmjYCnl?=
 =?us-ascii?Q?LjLn80B5D/mavCR7LYOFKOguttGEVaaFqGBnveE9Js/Beh72i9xhoF37xsBu?=
 =?us-ascii?Q?bFRICZvMiJKL+bSt6/miBOuDy+Eqf3GKPhZngihrHGMR48I5Nb/L2LzaU59w?=
 =?us-ascii?Q?Dq9dj6lERhB8Z3/NAKqKnfRPC4S2W36FsUcdnK5blAySR3lXFyTaUR6p7AAE?=
 =?us-ascii?Q?/zwvY4QazuJly/drjZf/3TEne5UBLpt4sCKxtw9zJnZRz8syneEVky0wcOqF?=
 =?us-ascii?Q?vxodulOB+0sMmacBrov3FBQVmczb6zns6nnMLIVTyiBZnsVduNmlxbs+Z966?=
 =?us-ascii?Q?+INFWrleuJIIzZHQPwadljjOAN8Sk25zuGq3sB1fUwC8TR0f7Jua8OvUBY77?=
 =?us-ascii?Q?+LlnPypwDxF9OzJyWjQYOgIFHtdy98Q7EiUX6cgNiU6RQA+8R7e4+W1R+ZtY?=
 =?us-ascii?Q?eYHp3Obk6aXNvoWi0AmNg7tg7ZaFwGc/wAyuU9W8YuqY9w9zsUbOgxw3Tf+Q?=
 =?us-ascii?Q?4wP+sBQ1UfWdK2z2AuieVNFuObYkyAY5+YUaLI+SWiwAc6JFQfKMpCnUcQAG?=
 =?us-ascii?Q?zilPc48G/okemzativ9knrCrU4BY7inzsYjwHTbLwcBK4XXBwqKy1AZaNRh+?=
 =?us-ascii?Q?sowwqbyPattXxDxJD+2Ece8Q0j9oPAYarDzN9FvLbt8bdwsYn7kAbNp7SGdd?=
 =?us-ascii?Q?RT/zwE01A9unpW1dVyhuH1lUpeyU2zWYIgRaAka3F9CCEWuuXwH4kH7UXFPJ?=
 =?us-ascii?Q?CeUWvpVQhw+028YZKZk1B/f9H2sBj4Egov3pJULiavkUIXPKZ4Az/R2E4kb0?=
 =?us-ascii?Q?Dyq7JuVqlh4EL4zPqeYUgKtMpVrpVrZZQNC+RMVLwdRg8kkstvXl0+PRfhUG?=
 =?us-ascii?Q?vrUQLqYmQ7fiGZt01+E/pjJsY1vOgXX0iuYrP0/Vy4XrGgOFaoXYPQZvr+PP?=
 =?us-ascii?Q?cKbjK+AmQIqddCQX+ZYxKQuTEVmdkoGLthterg4k1/0A80fp52qLXkpW/7fv?=
 =?us-ascii?Q?g7KIUSCeEG24/8NGx+0qKOKWqb23uh7+nbFQx7XVtbXBUu0uWlO3ySnd4T2R?=
 =?us-ascii?Q?Bk4iwMDGeW/Ugc/BnORGglBCmICTEx4sBDHpUIcsJrpTW9iaRNuPAdJL7yhn?=
 =?us-ascii?Q?g6yEAEvsFlsl9VTmu+nTXwtGaBsk8hKIGth37EMznJ2DgP4isRZxZUMdvJuI?=
 =?us-ascii?Q?CW7WcuX56rd+oGCJbK5lg7bZm4TSY4Cz5X8er31hm8fvzMl1llhvE8to5gIa?=
 =?us-ascii?Q?TxB4OfPcn9U7XnX4zlMvDu1Gptn/qzqqgkDalRidsdcMDJI4B87VdPVjBOOx?=
 =?us-ascii?Q?hNbhzy9feR//jylWpuJ4iWMqDczNQBOjRSTLuX4LY0/ND9gEg8GqVAzR+SW5?=
 =?us-ascii?Q?Jt2hRS4u0Xal5uTPyr5hqjb7GFeDLSu3VHIdY4n3K8OudnfGhobLErxUb23x?=
 =?us-ascii?Q?Qs6vGVrS4C/c6/kiBhRw+M3e8I64tZyqHKF3A52saqlK+UvdIaiSOpyukwxJ?=
 =?us-ascii?Q?loOjqJJ3Zj/gnIUSO/5/mX1XwgPyrxWuAEiKcqTSK19LKB1qpOjhxhXmPnJ2?=
 =?us-ascii?Q?0+VtfsapZH7gk2rwhJQpXhx0DYJJM4R3olsYfrOyAYt6N8iL3mvRU45V60Yj?=
 =?us-ascii?Q?cYe18bAC+voTYkF3n6NC0ERVQjwXkc0v2mf2C+2JiazkmdBcjwxWDa6hsEZf?=
 =?us-ascii?Q?b/0ipJWoEnSRV4i/C5dAc/P8LriLE9c=3D?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR15MB5121.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2328ed8-9554-4380-2070-08da13467928
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 18:44:22.7189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZSwde0+ZPe1aUC1biIhuzUa8HJVe62RC3k/yI1VH8sA2+HP7UWV/+viaZuz1iAz8jLz4yHa3Gz5CfJ13CY6XiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1531
X-Proofpoint-ORIG-GUID: DNhYKPy76bcr9QreJU_tsfgDKi-C4L15
X-Proofpoint-GUID: DNhYKPy76bcr9QreJU_tsfgDKi-C4L15
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_06,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Thursday, March 31, 2022 3:25 AM
> To: ilias.apalodimas@linaro.org; Alexander Duyck
> <alexanderduyck@fb.com>; linyunsheng@huawei.com
> Cc: hawk@kernel.org; davem@davemloft.net; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; Jean-Philippe Brucker <jean-
> philippe@linaro.org>
> Subject: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
> recycling
> 
> Fix a use-after-free when using page_pool with page fragments. We
> encountered this problem during normal RX in the hns3 driver:

<snip>

> ---
>  net/core/skbuff.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c index
> ea51e23e9247..2d6ef6d7ebf5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5244,11 +5244,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct
> sk_buff *from,
>  	if (skb_cloned(to))
>  		return false;
> 
> -	/* The page pool signature of struct page will eventually figure out
> -	 * which pages can be recycled or not but for now let's prohibit slab
> -	 * allocated and page_pool allocated SKBs from being coalesced.
> +	/* In general, avoid mixing slab allocated and page_pool allocated
> +	 * pages within the same SKB. However when @to is not pp_recycle
> and
> +	 * @from is cloned, we can transition frag pages from page_pool to
> +	 * reference counted.
> +	 *
> +	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
> +	 * @from is cloned, in case the SKB is using page_pool fragment
> +	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
> +	 * references for cloned SKBs at the moment that would result in
> +	 * inconsistent reference counts.
>  	 */
> -	if (to->pp_recycle != from->pp_recycle)
> +	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
>  		return false;
> 
>  	if (len <= skb_tailroom(to)) {
> --
> 2.25.1

This looks good to me. The impact should be minimal since it only applies to pp_recycle pages.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

