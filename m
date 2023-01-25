Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0724967B6B1
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjAYQRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbjAYQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:17:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2111.outbound.protection.outlook.com [40.107.94.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C61911672
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:17:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRHkgeNZJRAR7brKEPqd8QjnmXTvyQqjHotIPLSCn3mpAAd8/kfL0/3U6Lpr0TGoPfLbSF2+9rqgGOmM8pJUyr/aF/NVstT6VL1tIwb3a46nJwsatEi3uOkMPfQ9St+EDvhOA+pEMrUOqmIxAewKaFk1WujRyXbGaPbo8kLX3r+VdYPh7dmP2sM+ZEFpLJz4m+6qMlZVbbh17mRChViINsTKlz3/QWhHQqajaR1LNYnfVUNfuXs3qddcfMd+gWgpYsEt9pZCiGKjFo4qDdGY8T8Ls7vK27DiOSMqJ7NnRwrYuOMRHwEY+yvJIsDHVbjTZpxhuCd+PMuv0idFtFTtHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGVOGMj964udr7+QUWvF0yYfv9/wcWMwZYBajcdSPT8=;
 b=Y7/93agy9wSwbtp8Z7qgBkmaCyZsFrIXafEdsjxundSZftcPsTNr0cyauTC679IJZVABBMdTo9kjPtn78c8UYnF8awtKiexsMd+whkMx78exuhsPVk+A9PRZ1d5lrP+bs5zfwofuA2zjsfo3QLw/m9ts8Dre/yl6Kid7sbcmrwGkBPcZzPpx+AlnGlmJILG772rcvz7t2CHZz8lcOTbBg6lt2l5ugAIwE3rS578c5/Vc10fkiWWED7gvXKKO1sRpzCHtokFP/b+axs+w9p0JwjvQOpwiX6NYUmUhI7l2MEqFxuUnqmF3bKfpm8Ee6fzRbhqDtFRaMON+8bXM5Jr6UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGVOGMj964udr7+QUWvF0yYfv9/wcWMwZYBajcdSPT8=;
 b=RiJ8cfJiU2LO0LWAwybTKEZXL44I1yqoyma/K9aym/WUvPLs/+lPenlhRg3y8l0nbjV7wrcudgs0UWGH7YeTogld0xqZraqGLkxqstm996ylqzUDRUli3H/9PSmtfIvz7jGND3B+9iyrY/fIAweZmsSqeH+ke8hJr+AIwd3tHzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3769.namprd13.prod.outlook.com (2603:10b6:5:244::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 16:17:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 16:17:45 +0000
Date:   Wed, 25 Jan 2023 17:17:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sven Neuhaus <sven-netdev@sven.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v2 1/1] ip-rule.8: Bring synopsis in line with
 description
Message-ID: <Y9FWJC6ZZvORZJKu@corigine.com>
References: <2d32d885-6d27-7cb9-e1e6-c179c2f4d8c5@sven.de>
 <1f93526f-02b0-8554-265e-e03d7b04552e@sven.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f93526f-02b0-8554-265e-e03d7b04552e@sven.de>
X-ClientProxiedBy: AM0PR01CA0124.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3769:EE_
X-MS-Office365-Filtering-Correlation-Id: f702d5e1-4f1b-4379-4e12-08dafeefb190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mBDOM4NCsLrT3i7aT0iFvgMHpildqar0dCWnmqqgH9MJR10NogBgMzOxrS98xYgICYTpcjDjVB2W6Kd4pfz9oCAxot1IuQRWfAWP9wIBc20Ms2xHYQ1z3RAOPilH6oaiRXjil1cz41ocMrH+hRpsONMxYZQn330hvMxIU0z7mSXSQR2WgPQlfo/yYkA57ImsfZ2FbsRxTwOt27i9QXkMrKgpOyl/fWG9bVY/8pQ9wwlh/EAOrHBlmi72AE591v8VysierCM4GrQL0fkvVH3HPi6x7v/FBEeNo3tD1SnFSxxtMctAS0z1RzSizmNvLlYot2cHRlkjUNUfNsz21NZiexp5yJeK6tR7BvmZY2WC2rxnIaPvPRttnhR09AZP4O8Hw9/1Ls+a0A8vsVFhxzS6iT94m3XjkvX+4ud49SZ+cZMp0MczU6xHPSpl8pFM8FGRDyqiPNN5qABmwTt7jTOUFDip55KLG82gZqf6tIwejrCHLsxLicsPk5TBNb2Ro17av9U9X8jiyCWHsh/vA5PPjMb4yxCB2CBtBRdEM06EGDEQVlrSHPRnQAuNCHUJP93Ln5s4NcrO5NdZqvz+WwLzE5vmBDbWxiAttyzYUdZp+VTU2n4gWRW6aZw7aaA8k8k9zibmDYBBsbkS0SCiw5iZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39830400003)(366004)(396003)(451199018)(6512007)(83380400001)(41300700001)(186003)(8676002)(66476007)(66556008)(36756003)(66946007)(2616005)(478600001)(6486002)(86362001)(2906002)(44832011)(38100700002)(6666004)(316002)(6506007)(6916009)(5660300002)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HQPz88QT9SC8fF1NDCacCRARPpoiH5J9ymtAjB1IMChfcYYihFQ1Kl4d3P0R?=
 =?us-ascii?Q?ZPlcBcIu7dKuFjiBs6xOhiTYnmhspr4hOvQxuCZBvLek/TQXo5E0VTvZhsNZ?=
 =?us-ascii?Q?toFpMX1f6wvXVQim655cwtH7R2QUhBLBRLQ5s6riubybRrXFGGlbZjIVxMJP?=
 =?us-ascii?Q?rOgA1dfi59bWtf77yGa9c4iE/CVAsbtLZ+hg0SEhUnGe2S5ObqVHqXCKkidB?=
 =?us-ascii?Q?dWFL9Z0Ojq+rfl+HdfRvLgRfKr7AI/mC4BAd35WuwK0TF/6CTNPVsw6Axnmk?=
 =?us-ascii?Q?0Sr4ZHPjGRhTeydGaKypSDGspBtqgaXB+af3RSX9n712OJjBWTHcI2Clv+vM?=
 =?us-ascii?Q?ex6uMEmNJ+p+qsFDQt0+4TblvI+psGAgBo/bSUDdPXEnX3x8IAa5N3iNaKIw?=
 =?us-ascii?Q?uC5xCBbMON7wvJZqOdJIGnQe+jtB0kAHex2oq0C3ePKdSuJw3ZGLMPilPzDB?=
 =?us-ascii?Q?VR1AK+neaLIQ6TuZ/8VQtq398PwRr1wQqSWUY847wFlKBK9dF+oDYqRMWX2S?=
 =?us-ascii?Q?35WtBnUMA/1Jo2HM6iMHos6cdY+8RxjWS4kEPbfWAvZTHPTpKo7+56/ZGquz?=
 =?us-ascii?Q?gYC2Pe7eZdmPjt78Sx2IVV6oWYfxY/0qs9Gf3pxZdG+5kFl09EECR7AnEsmf?=
 =?us-ascii?Q?gvOVvJjqTBdakic0flViwBGDB3J8vo4wWssUmUyA2ubNl1E+Gdu1FsO+56zl?=
 =?us-ascii?Q?jbnDE7aZl4HfZf9K1fpvE+8eSGnDYLLWh62aP+/4bdV6VdSbjlXTlOv1+47w?=
 =?us-ascii?Q?kPCDob88lD5a+SouPfi1qvrWRrz/AWHjLXOKuMQ1RJyWr9C2NYDnRHyMw7uF?=
 =?us-ascii?Q?ow0hK2S+Bxf2Sx9DDuEiy6IWQMP1G8aceSy+ACvruAZ1uJxa4xXFOjx5d72r?=
 =?us-ascii?Q?t/MYHsOkidJ8scJlzdDgI4xFoKkccFc3PrBV1tY7yGNzLItnsLeagRQEKrNM?=
 =?us-ascii?Q?VPBk/6SiJeNSPxK3a96g2yJuraARhArRE9pNYd1u9Q0E6zWyjf/cgpCpqjFX?=
 =?us-ascii?Q?DBUB2zth8TWpRhI8LUNovawgGIKO/uH7YRC7tsz6fGTU2w/wwKVX/t8LTBtZ?=
 =?us-ascii?Q?7pfV5L+UXVolPh13gst0Dgf02bC89D9LH09MSWzWxFjm90OBERw5SsJgmUWb?=
 =?us-ascii?Q?PCU7RxPRmTEBBVm1zLh68pnzwCSaM1lWvjHyjYD5VpO5vugeI1fx2lzw4yy5?=
 =?us-ascii?Q?ZijyAbRQt5zuC6MGJD+3eAQyPN+hBIvzkE1fGMpuFvjE5JdFhxQ7LEzWhXi2?=
 =?us-ascii?Q?TAWk3dDS86npA7Qs0Jq3Zmrd/KWmEbhUZevpmHTg/HWQZo58BIWDuXw0gCrk?=
 =?us-ascii?Q?s6rvC9NxHDLgU6rfB5yWVI8BoJrQ4gI2jjgFcR6OYyCOJxfNh8bIp0kiNZ6e?=
 =?us-ascii?Q?BIig7tSUr6zfKeFOgFswC0Aa1o64wcLF8lqy/x2tYCFI9G+sfj824l69OxwO?=
 =?us-ascii?Q?t6S40NC9fhvI75j2btpsiy7x2fi2GLx8vS8MPElRjUrotWZStKho6to4wNaV?=
 =?us-ascii?Q?lDva9JRL6wnqqls/PE9WinCI4XYNn+lBtD9Ldw0LvV+WNFOs1ue/OQuwvKXZ?=
 =?us-ascii?Q?QbByvmXtGWl/ODQSG4Qcb09i5u2Z8y2FJwLn8fqDce7QE8Nqs6K9ylgwOPLz?=
 =?us-ascii?Q?fZXdUC+HMOe83zSWii+HDi05Dh9vET5MgGEvTinbHzILcfexmi91CL7ditWR?=
 =?us-ascii?Q?JuK78w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f702d5e1-4f1b-4379-4e12-08dafeefb190
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 16:17:45.7727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNz7h6e0eIiUm3PYFCntG2Dzp4KEZ2JfMFbmFWuq4CR5bROp1a1RQXDjIwAVp4nSVCS8KsU+1IRsSTDvfUcKRdqJhLyl4QTdRQvg4XijgIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3769
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 04:53:08PM +0100, Sven Neuhaus wrote:
> From: Sven Neuhaus <sven-netdev@sven.de>
> 
> Bring ip-rule.8 synopsis in line with description
> 
> The parameters "show" and "priority" were listed in the synopsis using
> other aliases than in the description.
> 
> Signed-off-by: Sven Neuhaus <sven-netdev@sven.de>

FWIIW,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> V1 -> V2: Include Simon Horman's suggestion, adding "show".
>  man/man8/ip-rule.8 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/ip-rule.8 b/man/man8/ip-rule.8
> index 2c12bf64..743d88c6 100644
> --- a/man/man8/ip-rule.8
> +++ b/man/man8/ip-rule.8
> @@ -15,7 +15,7 @@ ip-rule \- routing policy database management
> 
>  .ti -8
>  .B  ip rule
> -.RB "[ " list
> +.RB "[ " show
>  .RI "[ " SELECTOR " ]]"
> 
>  .ti -8
> @@ -42,8 +42,8 @@ ip-rule \- routing policy database management
>  .IR STRING " ] [ "
>  .B  oif
>  .IR STRING " ] [ "
> -.B  pref
> -.IR NUMBER " ] [ "
> +.B  priority
> +.IR PREFERENCE " ] [ "
>  .IR l3mdev " ] [ "
>  .B uidrange
>  .IR NUMBER "-" NUMBER " ] [ "
> -- 
> 2.30.1
> 
