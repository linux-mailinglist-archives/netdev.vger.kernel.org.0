Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F41849DD4D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiA0JGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:06:46 -0500
Received: from mail-bn1nam07on2091.outbound.protection.outlook.com ([40.107.212.91]:20157
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234522AbiA0JGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:06:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYsXZwz2IHizENnqTegUpEBqE3XP6SXhfgpNb/AlN+JGdI0W4HSqL7LPBuAkwsfmzQX5xPVCrZpfssFt7sj/JZALaLKgP+2S2gN4bS+vYvtNOhZOaE65VJLrsIHwAXTtp8fISyiPfmhoiv0EJnRWnt6PeI2z6292Qo3R77SocLyYBjqTTxpvpOlfg0fmprj7c0gf6vy7G5VZwGWA8qBQq2u1wTgWqIRePiyoA+9W6n7Rx2gyMShwx0yJzQHbAuIUcAyKMcNaHXAM9pHh9bCd9RDjcgeWGDrhpso5lm7q+dmc4Fb6Z/Pyj+Z5gV9lm3W5ov7/sXpuYRe2PmMOqeF6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAww2qrD2CP06FqCnxZt5i9lbaF2iS6+ddz8htfTRSc=;
 b=kqHH1oryrFHIXN5AlF0dT0z+wWg5O4uTSd97oarRnteX4AuzggylPKPgmQ1+48ruIVn7J3r3QOWY/kNqIc11KV+4UqQbu2DdWopR2m2p8AXsiES3jB+3zvUlC31OMFUuTe4iRe2vSRXduNjmdJ0HFr8c76UmUAwjofgo8X52aqjXmsqcMy64jbpQBGlY1Dh+lXW3DYEWsdB9RkrNtSTn5c1PaekKlvR8f3A2KwWYBjs+uiarbOAS2edKr8ZHvBUYrXr04r6E2D155TsTU5KmpHFjg/22bs+urPkPYANrT143u71FnQF4L1a0p4q+YieTHq2ODj4YXSNPafNC3L1N/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAww2qrD2CP06FqCnxZt5i9lbaF2iS6+ddz8htfTRSc=;
 b=dMyDFfzsXp+DCong9cetCupOUh0oh2wGAul1JJcnToGmRRy5i1t68t4nJ1LuIBgrdZ334Xgg8EQP1OiGZXkN35HWQebvZe+h/sihEIYXwNOAHRivfB46f07YpIX1EzXGDjhLz8765KsaP1iZ7a26Q11Nf2uTzabwxJmdlfRGC+4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB1978.namprd13.prod.outlook.com (2603:10b6:4:31::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 09:06:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f486:da6a:1232:9008]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f486:da6a:1232:9008%3]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 09:06:42 +0000
Date:   Thu, 27 Jan 2022 10:06:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] nfp: nsp: Simplify array allocation
Message-ID: <20220127090636.GA21279@corigine.com>
References: <af578bd3eb471b9613bcba7f714cca7e297a4620.1643214385.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af578bd3eb471b9613bcba7f714cca7e297a4620.1643214385.git.robin.murphy@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM4PR0501CA0064.eurprd05.prod.outlook.com
 (2603:10a6:200:68::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08c24166-b4f5-49ac-814b-08d9e17455d1
X-MS-TrafficTypeDiagnostic: DM5PR1301MB1978:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB19784C114DEDEFDBF914BF0DE8219@DM5PR1301MB1978.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:212;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KSNBuHhDFVto82toQQ73FHFRwxMdEcLbQ4CbqcSkFM5dKFEdI+0RhTd0LqoTTHG6W6oBVV0QZqODNrwhSIdGLfmn5WQ/K2afVKjDNixlcDNlE1F63lvyhA7Jo0Nryzy9sWz7usvLt6yUvcKIfkvyAKzDNZDEOmdmmdprVwaAU7P2Chhmpq3TXp9QUDweQjLrYGRjNEWPDSDgq2ZHr8ngdpR2zUXasUOGJWKAYWRiihwVX3FNcILjJUIaTJZfT001h5os90DIdgU7d0lTnmfXsWj71If0jX/0sEFrV61w/WR2xh/HEkhxrjV8eTwGoO/sAZDjcUUJs75g1/NZNIJs7tUGDAghhDU46bS9JcDD3Q1+/Hp7WZyw76n6NTrDzLDiw/j4l00M/x8kDKLCvj+JsI2R0bdlHXqDbr7gTyf+hc4yp3EAWQ7R9eKFdQSUhXEENAvGHfuBeBhesJg3LGXZ4awex9RbMzp88DdM0lAaFdhX0urfb4M3B2OzeK+/eYfdxTOsY0ctUTBIW9y+kQZfA6v6fnLao73hOuNqQp1yTluGlmSZzXFBLHTujuRTxVH4TxWzIX2W6XrnpafOB3JXSFfWO7I5aOWrNAhxZ4TPrmYEhjer7DSgwVmCu8hHH4sAhkNYQ7L5sj/RcemGaY08SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(366004)(346002)(39830400003)(136003)(6512007)(83380400001)(52116002)(6916009)(36756003)(8676002)(8936002)(6666004)(1076003)(66476007)(66946007)(6486002)(6506007)(508600001)(186003)(2616005)(316002)(4326008)(33656002)(66556008)(44832011)(86362001)(2906002)(5660300002)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fvWWRLTHSUcMd+CA1Yd9EJMR05DWCj727UiT+HxwWNus5TaP7+bBOXLzQ329?=
 =?us-ascii?Q?HVVONqiUdclXSfjvO80ChYot7YJJoXpalsO5XyimFBCEXDvJUhhVAwHY64PI?=
 =?us-ascii?Q?H6yead49fFpvCj8tkNbu5ELU/35AGWA/xExcTLi6kcooxNE7ei3+B+5Xa333?=
 =?us-ascii?Q?dHIec1kLy2M6Z9GRi2l0/8lL500y4Qid7J/iMCjQ2NOvPA4+WCBXRmnYJ3v/?=
 =?us-ascii?Q?A4/nETk7uR5akzUppEabkFUEnJG8PYGRKCk7huJ1xmFrh56Ye5H/8YGI9sgG?=
 =?us-ascii?Q?JOaIE9dbwu0J5o3HnhFVbKmkfDhE/8hC/H2TIBnXuARCr7YjqEpc0CL6X1Ss?=
 =?us-ascii?Q?byUJebw1IlRDFTCM9GwIpZcaMkM9fjTzc/cyPV00MfvRQDc0J61Fd8xFcflr?=
 =?us-ascii?Q?IOmAjv13eyN+88i2EUbUX32JdECt++nbC/kf7ZFYOIP9Vmy5FkQ3TyhSr5tN?=
 =?us-ascii?Q?KCpwE9g8yJesNv7wtAa0BkQG72JTjylt0oFglw99/Ig4RysgqlhanamNpsrk?=
 =?us-ascii?Q?cJMKtSmRFmthY7faGXQDNEkbrTBQojHs0wqXLQWqM+N0TeqDKWcBpuwbH6Xl?=
 =?us-ascii?Q?u1bz88O57MXSLyXRVrYQua+4Sr+eXw7dZQMAJsyacQntIAJXtGwhgtSdk73k?=
 =?us-ascii?Q?tYGFRiGEtyFXdfn7JFJSaTtZPC85xMyEMfC5F0LCvkBVG897qnYfiHWATIln?=
 =?us-ascii?Q?UH3GktAc+csS9J6JXxjdB3/EJhJHwajn59kkzcELYvZCvMFf7uP3zSZ5v+nN?=
 =?us-ascii?Q?/srQVFzJOhdVVSVUXJROX/rl1Nt4rTwydIqz37HDC5Kda8p89ubt1MvCMvXT?=
 =?us-ascii?Q?pbrxAGiYY/K7YynMfO/GDea2q6sPu3SrUe3NuI4CKrZlaX1A1olu/vfGNKrb?=
 =?us-ascii?Q?l/Cc6HYxJlUcKNqfx+iaqP/ZzrpMvwfG8Mp0/RLoSDqNUamDQkHKCA13cnFL?=
 =?us-ascii?Q?c8jt9pLMZUgc59SJlGq2ZwGmxlPA5V1kOEH0RBIIEKN9v0jGhE8JjMwEmSTG?=
 =?us-ascii?Q?RDPK+adAGGt05sqcClPwdyyTVM6ZF7Irz/QWJI4NUWIvUB9rbOX8Y7UCTSZy?=
 =?us-ascii?Q?fgIRN6o22+jZYBk4yZ/AItuboxBEBsR6Eg491i9hgnXcxMrsq04X8CKq+7++?=
 =?us-ascii?Q?SWjtAzzJy6/EIjHQz/LnpwLeDl6DDzSGZ60QqXaRpXN4VlmNEg+4a/iOJ4Hd?=
 =?us-ascii?Q?6HEyayQ+TWOEpTd9WcEG7JHp6FPlzNfpd1cQQ/HQ+v7H9l1HTFaspvCpL85q?=
 =?us-ascii?Q?GVaFypahcKZXtfnx/yv7x4/ZP1/3F3scMYEFmPk2ccq5JE7C0hlMpZc0gUKj?=
 =?us-ascii?Q?2/7cntbDKIJcGXkQRa3THJewfaul9fnGXsrFa+sq5EL5B5LYZzXxiDsnqJ6u?=
 =?us-ascii?Q?a2EXxmENudYRTxkeZ/FiqISTVfS9Y5YN8bUZXUaFU/GAWhrFP8ounSRVN/oy?=
 =?us-ascii?Q?YMWkeWUZuXxHAG12aeLldB/kYKIZPudZYD5sCRWk85gwYu+urqhiIMwG0ti3?=
 =?us-ascii?Q?Tzfhktb5c1c4U3yAP2mwrvy8Zpijzcw+EAvyretd7DeTrYPyvwgrH+sOEIHN?=
 =?us-ascii?Q?gjnJT5xomXA/nUTaVv/unN0BHSYdOEHj9DcV37Hyu2h7ZSLOQUo9nAA8IKU3?=
 =?us-ascii?Q?zHnCKfOl/jGL2trer20HM0TEDk6xso0SxBb3CRQQhXhRos9YqNOc51+AcxwE?=
 =?us-ascii?Q?3duobZh9oMFlIgkhW5fBz5pjagwyLvxJcgln/7QUM2VlgpMF3qgBX7wPwK1H?=
 =?us-ascii?Q?5tODYCC2DA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c24166-b4f5-49ac-814b-08d9e17455d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:06:42.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpkzgBDO0hy/PGIFXVcRV8f725Cjq+VRrkWApUyof1xuAfN557TctwxnrMQQqEuRKZj0RFhezAlMCGvJNxp/ND9gT3vnHGNrwDG3MhOUrQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB1978
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 04:30:33PM +0000, Robin Murphy wrote:
> Prefer kcalloc() to kzalloc(array_size()) for allocating an array.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Hi Robin,

thanks for the cleanup.

One minor nit: I think "nfp: " would be a slightly more normal prefix
than "nfp: nsp: ".

That notwithstanding,

Acked-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
> index 10e7d8b21c46..730fea214b8a 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
> @@ -513,7 +513,7 @@ nfp_nsp_command_buf_dma_sg(struct nfp_nsp *nsp,
>  	dma_size = BIT_ULL(dma_order);
>  	nseg = DIV_ROUND_UP(max_size, chunk_size);
>  
> -	chunks = kzalloc(array_size(sizeof(*chunks), nseg), GFP_KERNEL);
> +	chunks = kcalloc(nseg, sizeof(*chunks), GFP_KERNEL);
>  	if (!chunks)
>  		return -ENOMEM;
>  
> -- 
> 2.28.0.dirty
> 
