Return-Path: <netdev+bounces-1817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA06A6FF357
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6079928181A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C2F19E64;
	Thu, 11 May 2023 13:45:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30F519BDA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:45:44 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2132.outbound.protection.outlook.com [40.107.223.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00822700
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYKMrhas5/+jn/GVqLx0GYSv28Ha6aN6v5hI99P3b8nZP+YN4/1I6+PsCGvhxksvvy8EQEhmtjU88hTYSoTmlOS0iFFOGbNmzVRJ0J2QaSxjRy4R3lvDMr1kWso6PMDZXcjQPR+rPnvyp/Tc79ksvzYFjwtgBk9KwNxRPz56ieSKakKd3c9uIaCABk9NywLS4O1hwxCtZx58cU+DznzjD9E0i8z9sBIe7BWA5W2mWj68FQ8CZ0QLMuJXvRlT8k9Z1agmrKQWOYVbFUxojZLZTlfR4P4k048gwZTV1y5qxn+TfEcPPyhGl6ovWauULSIdQPT15ziUGG7XZ6Cc8t4mGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZPDNoGprIAuYhKzUD9KfmRd+j7omxlHaDg/+Q0/ysQ=;
 b=YhCzNB6gYvbs/O5yFyMnfWhu+V/uclMj4PlwFJe6CZCq2CAVlhtiF3Z2TgBoMpDqKQZLTVUYAn8J2cxwTP6ZddII2GJM2kkT+4XeF1C1lDnrQwtUkVwKhpd1yqmd11vQbjBwfz+/1XPfLCou5/vZFB6AuUo5rwEsKHVKSI+dXVO/YgFLoRTy/a3O0ixGPu2ZV69eupR4AF0wnmdmE2d/RgljrrTWrfzuGtmLqjICOKod7R5ZM2w3b18dz8Rihkw02o7M6ippmZhR8ewtU88V0Ux/p02WJ02oNT0B/ccTIlZ8Liy/a/ez4uzIq5NIahSMAjf3iIfY8txHBkC2eXJFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZPDNoGprIAuYhKzUD9KfmRd+j7omxlHaDg/+Q0/ysQ=;
 b=bMJB9STMuyDQDoyS145BQwnurMBF7q8h3R5jChnhbMUH1rAVrjXQtJMxihzM7KHQjJQ8Frxkeafe9gzcDgYvp35k9b86hFLqs+JA0oD2HNlgb0sG0ALcNCoAklaREEwspsho3W47jd1q68yrEy0SoF8qn4ka2ldOP8n2QbCPiy0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB3934.namprd13.prod.outlook.com (2603:10b6:806:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 11 May
 2023 13:45:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 13:45:31 +0000
Date: Thu, 11 May 2023 15:45:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: tariqt@nvidia.com, netdev@vger.kernel.org
Subject: Re: [RFC / RFT net 2/7] tls: rx: strp: set the skb->len of detached
 / CoW'ed skbs
Message-ID: <ZFzxdfc0tRdoluyn@corigine.com>
References: <20230511012034.902782-1-kuba@kernel.org>
 <20230511012034.902782-3-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511012034.902782-3-kuba@kernel.org>
X-ClientProxiedBy: AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB3934:EE_
X-MS-Office365-Filtering-Correlation-Id: c045db1a-2694-4fde-0f30-08db5225fcd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DaUFi7cYRWrRZs3mstl0QLKu80ewFETAuBGCJdGGRWWG2JS0XyOfZ0m/g7VGKrIgmlezhvMqKtGt/aw/5aZOuARgbX6OY51hfyzslovHhw7sTbP0hdqw1ytaF5j1k9vb3c6xe72eqsQ2xfdfmXOx09YWFHHJl4TEmJypGyckKoQ09CB/v45TsLU1kjk7wIO1+Z8nxQS7xWQlTANIovGd+etuoed4as6qyKtZ6sj2XCkBOiTlAqaH97vyE1VuekZad7m04rAuFudJuUbkZbeZNPp+p0J1brcUHizZJwhcCBnC21sLGFzGPEs5KXJ93I8iPxOyHGHXdK2AtpwnfcmbIP2K770Ijxn3vL8/sk0HazK+5OLnzW1kCXKuSVChv406Q+jsgFej/e6Fho2nn05Szvx4Zrp4Cw/OP28uGZaJxfsrUmBa9fe1TNXlauQBydbG95RVknPZBXiBZZKu3SMziqxwvPunGUdi73iO60yBxt1TNxH/5gvpn5Ph8lOcHOgr5eQpcgdY62VS+w6T0xkwFAISUYjkS0O+892c1L2/HuB0TlCkFa9CiBnP06W1jItljmS8icVVykcL/ccsy3y8h4w81jAaoqvy18RNgxIR/Vg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39840400004)(346002)(376002)(366004)(451199021)(316002)(66556008)(36756003)(4744005)(41300700001)(186003)(86362001)(66476007)(66946007)(2906002)(6916009)(6512007)(4326008)(6666004)(6486002)(6506007)(2616005)(44832011)(8676002)(5660300002)(478600001)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yvjby9Un2kXCoa4vqh2DGBzhGXz5obPtq7bZ/xK38a8ea5yOPgnPLGW/0lUu?=
 =?us-ascii?Q?HbXa9c08DM9i6ocMOZka6cVg1JIqYI93vMiAGid2cAeLOv7jqX5f1w7s0hqe?=
 =?us-ascii?Q?G3JYQkVJAEc8zDqqM6Hn2HghSJ/AVfzMDE/X6kU4MRnRiUaaprpeZVe0yfUG?=
 =?us-ascii?Q?rsALnYXoL1uVejwau4YhogjG/brUXddEPxixrNz/p0kmA3SlUXCFxqeQBevX?=
 =?us-ascii?Q?JuUOmW62/oFLLYsqaYorvaodeFT4KvH4rOLHpNuqDUq2ogRpDSnhPA4AOBoC?=
 =?us-ascii?Q?CZaOp5mMBfZLoeyjB9Z72ACLRcvpEmtw+LPrXdOMV5QESaiKoEJGQ96m4IAr?=
 =?us-ascii?Q?fXO4HZpeIbFA/xG541CbrnkY47sA5FEqjPrTdbOPlDC1z5sjSmkXYhH0cLdi?=
 =?us-ascii?Q?3wRrh1LQsDVKUEcvRd/lYpb8TGiqEURfLP3P8kHLis0K4MzDtdDx0joBUQ+I?=
 =?us-ascii?Q?5nPxWN+od1ufDueWMrr9cdhqoi8YB06c22PQhEcopnTPnr4qsS9yUStcheD7?=
 =?us-ascii?Q?beRDUG0P0zero1io5sg8vWyJPoLPjE3UhaviNw5ASEvOf28aRY+dZLrHoP7L?=
 =?us-ascii?Q?P5DE54VwwKhlqi1e5Dc6DX7HQp8JN0hEHVIjGgg15E9aAbv2AgLwH3QsvE38?=
 =?us-ascii?Q?Huf9/ZmYBlukmvCtVaHt4v3EA7XaA/WEd4IZYaGh57Ig+j3z6dwrujf1q300?=
 =?us-ascii?Q?DBa9s9wFcDs99H0uAFEjBzwNWjb2jY/SboPBMpKiEbUWMzLH49RGC4lMqkzX?=
 =?us-ascii?Q?PwPO9VHx30bkbUuJWVhI2QvZ/BEWyBnQREMZ2697Ua3VwB7AV3qt3EdWUcYn?=
 =?us-ascii?Q?2yYNcGuz9Cr4l2Nm/d8O8Xu0YLj+QBglbCHlHWriK4glpqV5kaDl3Ri8Pv2y?=
 =?us-ascii?Q?hR2FaJCefBr4p93/y7OIguOVjQ7kfD6nzN4DUw4tRJmWDXOCIvw9Gg1+4yaZ?=
 =?us-ascii?Q?oB9n5HWnf7oj/5Vy/O0VpDuCpmdQBapwCUTXvULXIsvVDq5Bqn21PJXPNHU+?=
 =?us-ascii?Q?hdD6wSfAYjbKGYLdIO4PkHkHXT0MEIBIeBhCSDI7CNJTEoKewK+RYmz+SZnc?=
 =?us-ascii?Q?EpVfrnqxp4DBV2zblhxccM39pyP5JXOu85x+kJakwHVqA8TYcnbmCNKdxrVS?=
 =?us-ascii?Q?YeyJLWQI18hj7DHPPTUBtX+ac/GojidHGXQeH1RnaV8TykhXjKuIO1lW7rBq?=
 =?us-ascii?Q?oezsDiPJpKxNauoflrI4SAy5AmhS97WpL0NUL42qNbRA6pHvcc7rcHpye2CW?=
 =?us-ascii?Q?kOwuZhSrphQINFceowOkfDoVM20hu/ErUOH+ZxiA8VIXd3rN/L64URPtm8vo?=
 =?us-ascii?Q?SyDRkepmv831U4QvPPZq/1D3KAoynjj0+9Vj2lWGRm1axW0sPyGzAb8/YQO2?=
 =?us-ascii?Q?bcRdGhrWreIPnWk0tTlaFSLfqwaiiYqoIF6zIJo7I9lg639gWyoLqXwf3qLs?=
 =?us-ascii?Q?WfbEsqgjkrVqpIOS4R8tzaixktyuXtlnt6zMjMLCXaxypn7UMUHTcGs0d8QG?=
 =?us-ascii?Q?O8vVukGYK43pqF/+QeqCBdykQlbf1YeVq3wFL06wizQtmGSTz70Yg8RzRkI2?=
 =?us-ascii?Q?uQ13Eau7CJbtNd9E+KueoM8P0RyBRbXYNL4/R1VJGEHy4VZ0UGANaABFrbv0?=
 =?us-ascii?Q?Cun2hVFpTiyasXzfjPcBCWIvu3vJSVqONBRM/Sfh+681yEgcNWDGQabXoCii?=
 =?us-ascii?Q?CfB5Gg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c045db1a-2694-4fde-0f30-08db5225fcd7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:45:31.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgCbsxLmbLkBrKmLYzGuP0wGQQKhJJ7sfThK7JwLtxLwFYm9x7Dd25LVfmfMdLUCpQwMuRnAJxS+GX8cPUhW55zl4WJTszytRhPpJrTO7V8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3934
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 06:20:29PM -0700, Jakub Kicinski wrote:
> alloc_skb_with_frags() fills in page frag sizes but does not
> set skb->len and skb->data_len. Set those correctly otherwise
> device offload will most likely generate an empty skb and
> hit the BUG() at the end of __skb_nsg().
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/tls/tls_strp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
> index 955ac3e0bf4d..90b220d1145c 100644
> --- a/net/tls/tls_strp.c
> +++ b/net/tls/tls_strp.c
> @@ -56,6 +56,8 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
>  		offset += skb_frag_size(frag);
>  	}
>  
> +	skb->len = len;
> +	skb->data_len = len;

len doesn't seem to exist until patch 5/7.

>  	skb_copy_header(skb, strp->anchor);
>  	rxm = strp_msg(skb);
>  	rxm->offset = 0;
> -- 
> 2.40.1
> 
> 

