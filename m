Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8604CF59D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiCGJaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiCGJ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:29:25 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2122.outbound.protection.outlook.com [40.107.96.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D62A46166;
        Mon,  7 Mar 2022 01:27:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVXaN/k8LMfy7mhs9UXtahWuJEfROSumIefU/iD0NYl9B0ZMvjO4W90DbzisrsfDmd2qgUcsJ16wSi3HY6IR/Q/OJLBKLqTVtM3aSA0DPNfbtnYbB0J2kuqmp8KZZMfLF2n9R5MaIfJF8uTIlsov0zVbhJQ/xJBUVaMF7Zg1yHMuxrya6uV3JHCEBRtNqCmd2FEshZjmgn8OT9FfaSRU8ZMk1C+HBavU8EpPrTtISSey5KrmWScN1gGOQbmlgyYQ42GcGtmf+411rb09PzPFbizjxPBFPq/78pm+OkobwiwLMYuerCKJg3QARSw7PdzLj6xKobZ3w2E1xv3imkRWpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3Vz0mNKoZC25222tzSPJ7CApulzVwlOc1k1IZu5Mpg=;
 b=aOgaJoh0oDgkJA3bZPhhDNHJ1EK4wGZV/j6o2t7T/ig0JWiYf/kiFtvTti9WQLr0N4nvLfKBzAU7g9l7fYiDrzf4mCxnq6g7iPPV1afoM5d7lqijBD/LK9D91kAvra5AJ9kEkhQq16Y5CIPHJ9jBvtWymtgiI03b5hhCipSYvpymYD65Dz36Av1jDVIZxMdXP+VHA1xmpocnusxzP5dL2K4j9bDYKn+QK3yRC9E1n0j+jGmWdDxj8OA3rap7jWVZg5BKXjxab6D2+S2ABKPxwUTzqMajwNMdHE8jJOdV7VVD/WPLFcq/GPrGhQqGjq9HL3vmTHymOoUDHUPMAR93wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3Vz0mNKoZC25222tzSPJ7CApulzVwlOc1k1IZu5Mpg=;
 b=SLPksfly/eupleTIg1JpAnFU01S66OhXUGdGBLV3ZakKfq8rCS9Fbkjt1KYF1vEvKyn1iRyE7+tg7ZljvpRSg53RfkW0aA1AKeuD6X/mBF3ii4Lq8O8LnFrlRSVXnR2iFrSCVeGRAjWKy7qei2j9guOIaHxUeVNF7UrEGUBwOQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by CO6PR13MB5355.namprd13.prod.outlook.com (2603:10b6:303:14b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.13; Mon, 7 Mar
 2022 09:27:17 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::e035:ce64:e29e:54f6]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::e035:ce64:e29e:54f6%5]) with mapi id 15.20.5061.018; Mon, 7 Mar 2022
 09:27:17 +0000
Date:   Mon, 7 Mar 2022 10:27:10 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@corigine.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfp: xsk: avoid newline at the end of message in
 NL_SET_ERR_MSG_MOD
Message-ID: <YiXP7i/tSLpdzM3+@bismarck.dyn.berto.se>
References: <20220307090804.4821-1-guozhengkui@vivo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220307090804.4821-1-guozhengkui@vivo.com>
X-ClientProxiedBy: AS9PR06CA0286.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::32) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb4310de-b27b-47f1-d4a8-08da001cac0e
X-MS-TrafficTypeDiagnostic: CO6PR13MB5355:EE_
X-Microsoft-Antispam-PRVS: <CO6PR13MB535532559E5F9A788E7EF435E7089@CO6PR13MB5355.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUX6ZCpg81z7M1CwLQCReMUD+3ZVB1yZqu+hMjQgJXh8WMKb5hJzwX35wmplDITLdv1Yd1YgycBFyDOuYBoekD92xotc4j4ITMsQD04tVatZ28w43u8cQfhS5k07oicSIcNAWH14/ZV3L68TvDwai0Kc6cOesJJiprVPhHbnEJZtssDcL8+Qt/5rxXM+8830+4PCXyzDlfy5HZVyg9BzTfi7FKIzRkcHfAg0NV+UzOhJUvYPKUl2z9RXi/BvcnlhuW/dujIag2XIbG6nTMcyaA19W23/G2CvARIx4908wJ+56+KK5WTgB30tEEWLfcYaJV31cDZ+JbFKJA4KrIn4hEyMpHqtfzMhByFqTF8F1eyxMHLAsOZx8ViFSBOYdzu4hDFnwZHdnJb9bnD+Qf0xCAKNMG2yNx7uUwC5wMyGKrj+cxOSKwqJxBqkHEqMk1zCw4UPhCtzpYJTbhQrhzmcnnz7glB9uR8uKzVSEyKtzsBEvU8AebrjuZd/IySmGR+i6yLfM/RJiW5gCPn02eL0nrsHKpTcMsWj6BDe6GqbZmpVQcN7KcdX1LugQ5dvUTFk2MoFJRO/S7RV6vQfB+yWltrc9Z44l6e+H7DLb9sOWZfzZSaQjqltBPZbLBWlZP25PHeZEdDT5f1Hq93IfZBC4cmyWeV5c7hXBuaJZo83Lx6R8bQTMSsGhXiAEPlwKBK5PG2V2DPQ7ElKvdkyGMyWoarkdUtaq+ImjND5YJy6yZMVsWO1PEcCu9BM7z9uoxR9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(346002)(396003)(376002)(39830400003)(6666004)(186003)(26005)(2906002)(15650500001)(86362001)(8936002)(6506007)(53546011)(52116002)(38100700002)(38350700002)(66476007)(66946007)(6916009)(4326008)(8676002)(66556008)(6486002)(316002)(508600001)(83380400001)(66574015)(9686003)(5660300002)(6512007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2Hyl6GOL1uFPRnA4F7p/CsiXgSA7juAhc4z8WXkoYDNXgNjgo9C3XBkUPn?=
 =?iso-8859-1?Q?AaNOr6P/lXK/iZhqsuepENtiWhLl7lSz2009BCI0gs5LmAf1vAA32Rz8jA?=
 =?iso-8859-1?Q?jN7uimVdkCFt19zEDrzDArG76zfMux9JAH0G57nxCxS7Q96BXY9e9gvZeI?=
 =?iso-8859-1?Q?O8BbyLI5tw3ZUCMg1rYYgti1PyZvz2b+aYSTQVk0pqY4fWnI4ulclO5ca+?=
 =?iso-8859-1?Q?iMMWFSY7s/8RKTbRTq9VVBpVvNgeB5VuHCot3PPh51DpzjNs5TTfZZ5AzO?=
 =?iso-8859-1?Q?AIcwNLyI1LLMIeQ2JDIbzFbKuMxf7Uciy7Ntk3B9PmyHhBLDpsMiu56Viv?=
 =?iso-8859-1?Q?v51J969MXml2gFiSE38IJhOpYHN8xajCJWGp3nAhwYiKdkvGbYs1ODAS8w?=
 =?iso-8859-1?Q?ud7EftC1wdJHi7PNih/VTM1SIfBzj0mzES5pVVZg39NCkU4Ud9hBHo8RcG?=
 =?iso-8859-1?Q?3xzy/82nkhVK1OyhkrzASkilArhHkqvJ7pRfgYbS9YWNoF/yGhaN+Y3SAS?=
 =?iso-8859-1?Q?mJDAWAKXhMStHaUbjhSEhhQfK1VJzto+Wdl4WJhmXd6gwtPyumUHTFs8aP?=
 =?iso-8859-1?Q?Qu052wqxiAH2G6Irp1zh5+0PNWUx3401B/LGJTMfB6GO8U4+YnuYl3zISi?=
 =?iso-8859-1?Q?AdOLRg77BosBsOxyhw6Dz9pj8DZt518RWPFR25IjbbF7YzURK4VOEAPy5V?=
 =?iso-8859-1?Q?P1oN2/EPsNc8S5Bbx0rHulNYtCiAQh4mAeewF69XXcwMOg/PFEFnYyHFWi?=
 =?iso-8859-1?Q?0jXMbRsO1qSHcONxKTC9rADbqHtQW9G323LYuaQ5amaknW2YpplAoQVxVP?=
 =?iso-8859-1?Q?yU9oxKCLAcOQuYme1DiTzXfqwvOw6MwsmjUfE6yWqOfq0X0gd5qJOkw9Ra?=
 =?iso-8859-1?Q?5hCfJSPXhQQhVRi2utB/tzHgnKa9CJs7AoT7BWI8zhoxCtg5PSwJy/fD0A?=
 =?iso-8859-1?Q?hDkoQcqNud11vcR5H/7fH/r9O9YZkYQSP9TOfV39XpZYYBCxC/l2W2dE7i?=
 =?iso-8859-1?Q?aWHrrAgDcStYL/2n9dI78jHH5nkLYYrk4OuaV8I5dy6pKghX7y0G3kQAtq?=
 =?iso-8859-1?Q?bQXGXs8GNDlKgeHX5OLkjOjP12+jIfEKxeOTOEfl2qeyBydFDZTwOc2+HH?=
 =?iso-8859-1?Q?zSR6WyxYlPWytmLewr35hxIncuyY8WQiQQrNZDDWFNnQmov7ifNxYhpoze?=
 =?iso-8859-1?Q?N+Jk7vzN3qM2g4SyO7XDLbxIWtb6WvWgSf7cxqyPXXR7jc//Zc6OE1yZuI?=
 =?iso-8859-1?Q?qbT+JlaDRCglhFR2VG0aNWbw9CH4hPHwaUGIGhADf40LcfrkiMa7qkkAta?=
 =?iso-8859-1?Q?Vz2KlwjJYI0ifXu1raJOWQaWiI4m2L5FUmfw/1RH72HET2nePSiShMyn0/?=
 =?iso-8859-1?Q?r/KU5/SJ6JXDP97Q+K4aZkgFOfSiiJZHqi3AePR0U7CgnP2zmM5Kz7QIfs?=
 =?iso-8859-1?Q?x72WwuNKsJNLyeztBOzE1+UFurXnc+FV88wZMkpN8x3iXSMi4e39QJWWzE?=
 =?iso-8859-1?Q?fx7LvuU3qhnQoRJfL6IefyX6cWP8CA2D6iVQcUGUMAoQUSKRuUH5FFUKLU?=
 =?iso-8859-1?Q?z/Oxbr8=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4310de-b27b-47f1-d4a8-08da001cac0e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 09:27:17.4427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/y9j73xivd5s6v+wxHmP3H+XSGc7eZnEQuGrk4hb7NN4iq9T9TMM/xVf//tKrmxMdbFUEwy/UnVxc4P9tdXhRxw0nfN8DyOsiuTaPMgbOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5355
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guo,

Thanks for your work.

On 2022-03-07 17:07:59 +0800, Guo Zhengkui wrote:
> Fix the following coccicheck warning:
> drivers/net/ethernet/netronome/nfp/nfp_net_common.c:3434:8-48: WARNING
> avoid newline at end of message in NL_SET_ERR_MSG_MOD
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 00a09b9e0aee..d5ff80a62882 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -3431,7 +3431,7 @@ nfp_net_check_config(struct nfp_net *nn, struct nfp_net_dp *dp,
>  
>  		if (xsk_pool_get_rx_frame_size(dp->xsk_pools[r]) < xsk_min_fl_bufsz) {
>  			NL_SET_ERR_MSG_MOD(extack,
> -					   "XSK buffer pool chunk size too small\n");
> +					   "XSK buffer pool chunk size too small");
>  			return -EINVAL;
>  		}
>  	}
> -- 
> 2.20.1
> 

-- 
Regards,
Niklas Söderlund
