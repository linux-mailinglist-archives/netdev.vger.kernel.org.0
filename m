Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA275A8B8A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiIACm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIACmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:42:54 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585B0155A46;
        Wed, 31 Aug 2022 19:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goMGG1C+fmgtElO7UgR0UJ6ukFVxs81KqwUEUPJLWYgya82+odLyVG7O/2Ld/FN7Sr88gehLFviqVc7wz9SCHa/pe0MmjZPajmJ41n7YSAEQD6OTOM1RjS17T7Z+bkcJMNzmJKLRFZouwpUqfxaU9T+1LeaEleauXdNMMgx+b09u3OC8VIfjGUtsjc1LM0Ey0EJoJcKZSeBfuF7KVvLsm5Nx0wrMQQnHaVHFMd5+yh/aXfoMPWSNLlnByoVAamc32qWE26lPT6h3ZLe6pmLlr0pAQnSGaAH/ETj9Sb9PBC/5cBiFt2bsYgN1xGe8bT2zgk6nz7ucKSQ75mfy9dj5GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBcI/pPZTdhKRzU5OLm6eZSY0lj1nijQ2IbhWEQLCsg=;
 b=Ra58mUlM03iFkktJ3636E0ZPDD1Mdq/ZHsk6ol8cl3h8+K4hexjli00EqiXqCXphNR9sRXJxmh/xWzciVERw1CIgyQ3gNPcPBe09mLjYWNNSPYzQXq55TCgDIJ+ILRFcKuk4x5jMzpJeTmKWU83hicahvCp64uudzxH2jEoPsiG/fGAGw15DsCiCq6e4hSEOSDs4N05jXl9C7wCDzkhQ0IzBcmVbPsVC28QloZNDQkXp9QS6M8Zma5JbpDEU/UfzYlkmPTZYg5AgeQro36T7r9qAEgSTN0N5/Bg1IdPgvREBoUeQ8nO7UQ4vahHpDDsRRAEV/p6t5zAO6tx6MMtfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBcI/pPZTdhKRzU5OLm6eZSY0lj1nijQ2IbhWEQLCsg=;
 b=jdRVmSE+PLgzcHVARXs8IeA59g0+C7lNmyiTYnqANOZMuLDZtOaF8K67Dsdw38wfRxfeoI3N4tLG1E/32TXo4ra1h3L9cgrbg5Ma7OwJKO41AgflSWfPoYcJ7ObEJbnWE3XeBYA5gxB7lYPvdU/l6B9iY+uygXXr7D/v4BzY66NdqUAChkkTYPE3OQ4nfMKnSl1uKFgrt9X17ptQtWLY+NsRGsYmfLch9udejtFH55Qu+BhF3d3n8lrVnR8R5JBqMe66a7SOt53mzaGtf1QEzYZXMwJai+SQz1zXTZPymb8hnH89CmPq40JVQzAopkuMuEceN5qxeSU1uE2xo+jxeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 02:42:49 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 02:42:49 +0000
Date:   Thu, 1 Sep 2022 11:42:29 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 3/3] net: Add tests for bonding and team address list
 management
Message-ID: <YxAcFRJlc0icvrai@d3>
References: <20220831025836.207070-1-bpoirier@nvidia.com>
 <20220831025836.207070-4-bpoirier@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831025836.207070-4-bpoirier@nvidia.com>
X-ClientProxiedBy: TYAPR01CA0224.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::20) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 228e91d1-5891-41e9-5999-08da8bc3a8c4
X-MS-TrafficTypeDiagnostic: CY5PR12MB6429:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Z0XfL8HGfqfxHGi96GCX/mBLOW077T68RUSuOE0A43IYWC8xFCWFuI6xnVJlR/nHUlnfvudt/wqahPG8hYawPiHDBJeyNp1HEfKBTCGbC+pwnclQMNzxNclWcLtCjsTOJJTDjdl5YYBZ2wU9n89uc+pVHzAlSuLS8eTf6IY+S+HXt6kfl6sYYQMNmFFoq55MNghNPOqQ8ICggIybFQTIdnV+wpHhp3KHOu9oGX+mw2ZVnUauOg//Uofr8UM8Rw/euI28y2TCMd00WfWXrI3Tz3B6dvcPTbk7RSNPjl9uaRiFtq0XJMOb8t6CGB0eQM7fjXr2+NTySOTmvaOYshxxY2Npsd2s7iCCVEu261t8Oc4mgwZmPLWA+Yuty4GD19OrfRTSwmxevZoa7wH5Mly/isYQv/U2PrUrQZORdZXQHwwoj0VFWUYRzJk3o32NVLxQFzf85JrnI2cpIvgaJoV+Ri5vAE9cOrsKYlszFI21iJY6osvO7d8R+J4FnkTtTjpgze/G4mopR/mycv8Uyl4Rl3JMORORAfGbe0OmNkGhh7XF7QurO4z2rLktwO09U0PNE3GCN9+KupXRlDNQvaSL8nkdzL+HLg/SsQCYHKH31G8IdYzo+sCy9SmiOA5+yJ59Vl74679OMGza6JheLddhK7uLb4rbczSM9ovq1Ld4zFDqoRM5nsfNHm6xAFRkaiwTCskls6cHTEwqUznZBSpCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(8936002)(5660300002)(38100700002)(478600001)(7416002)(6486002)(54906003)(6506007)(53546011)(316002)(41300700001)(6916009)(6666004)(9686003)(6512007)(86362001)(26005)(83380400001)(33716001)(2906002)(66946007)(66476007)(186003)(4326008)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LvEgvjqasEr34eBmdcQzrN96QaD8T6TcMGNHPptL7XbfiY6hPH/5yTIxfZya?=
 =?us-ascii?Q?4+J3lMIYMBjHNSGIZHNNZ/8KcRmCxluBOo/2bUFh2Hq0xMjdHVHdh3JkHtS8?=
 =?us-ascii?Q?5XZib5YXXra2PhsKM3fJudzhV6L2Gy374MUJVmrUjSiIzqgsvx7xcBUs38kp?=
 =?us-ascii?Q?F0Q0ijQbsyOk0FngoVfPuSZ0hHpW2teyHC/zzdwcaQK48PK1yTTvLiRlp9RQ?=
 =?us-ascii?Q?MfY8f0ccc9mXzS4RqE2FvZ0EyVxxBo6vQaAC7wznJ9+Fvw413yNbOtn5zrq7?=
 =?us-ascii?Q?p7O53V9ytk0SV9BQOvDcPPDJX1A1RPh2+SCspJoeEKj6QFqP7S33MNJjqojy?=
 =?us-ascii?Q?4Zirpz1cou6cTkfDfeB52Z7UaMoYVDrEm8NMejnX/yjlSontMQ/3Ju73jqzU?=
 =?us-ascii?Q?WTeLEXavddiatWFLCZtTTOzstBMl9jYbA0RRD2SMyifhLsXUBnVuyXik/hkX?=
 =?us-ascii?Q?TOSes3zKgfjzvp2pyN2oXEEr1npBOe03conWj8K1mrsH+aGKOgsJ67o3MhEQ?=
 =?us-ascii?Q?jp/2xm/glCUwdNQwZ3hRhyMhaoJck609OT41i1KQVRt+So8CBVSE6QHssMx/?=
 =?us-ascii?Q?KYTp0nfazhIIH8zAQPLV/AHBNf8sMRqtKiBO14jfuPC101/d98RoI7NOSTvg?=
 =?us-ascii?Q?gyhZRmxmS46+iuLzMzv+oLAON+ckLkDmWv/rZx/qkMek/Le/m/U8JTTptRvo?=
 =?us-ascii?Q?2liBWYr5hlLOTaSJhQ1TUTGCmf+xnElb5sCeKUlvw1mdbiqiIYVSCPGfNIya?=
 =?us-ascii?Q?3kYZL+XtjFawshu6AtIGejDXOao3Y3MJsuKSTO4zwPLT4CxTnRjBBXWgS515?=
 =?us-ascii?Q?gdOM30pAQAlxhKjDQtSWSYPC1ylMBm1ntW9pv1pfuGiqvTpyPH6IHCGNXXoR?=
 =?us-ascii?Q?CEzM7M6Aty0xB7/TdY1thMwCz648xRQ/UEJPLIGMfPONF7Q6Mgbnk9r1O07H?=
 =?us-ascii?Q?Rlz3V4d1R/rJ3Wr5OXQJ7lZ3B6o6wA/QX8NNNfyQUJ18EO6qZz4wK3kq6hY5?=
 =?us-ascii?Q?czEX8+Myu/oqB27AtfFys0GjU9F4yOp/1EGgKaQDpHTOf1q8YVf9prN4TkPJ?=
 =?us-ascii?Q?2bTqsrMnDJIqH3e76olzTokvZ4nsFEPcOycVvn/+lG9WTwLD+bQJ4O0O3TQM?=
 =?us-ascii?Q?DIfruPBWhmlv/Ygxzq87t/BKj1rklvPLcrma8XapU2UMoQaJJlSY5do3eKaK?=
 =?us-ascii?Q?ZVefrolCunskrxI9LOeElFxdiqivxSQcmLdE2AlxHU4+jSd5Jzt/uNpPJ3Wc?=
 =?us-ascii?Q?T9ATZceg+/Q2pIMef34yyGLrBRJv6XmN7huRBe9uIJpB/IyobPSYs7q9PG5k?=
 =?us-ascii?Q?MpSiRLmScDHnuu82twElCSFrxl6AIV+Xft7v+UcvM2hIwxutGtcpFmZcJNEp?=
 =?us-ascii?Q?ZY1p10tt351b9FtedAvYa/Nd0M5mafd6gRyvdR0aKhZ86Dlhrag4sYOVpKkT?=
 =?us-ascii?Q?Fpxqd9ArrqQBNh2Kqwe/PUtMYKRE7xoAZPLeVfu0jxPePyW3DJqGx2RHk0qr?=
 =?us-ascii?Q?RWyCRtMBHUr3EdmVLMz9z4QVoykv4lXQDEjNjUx7j9TXS0K4H54LtPxwd796?=
 =?us-ascii?Q?3IWNo/jyC1Vlg7cyAFU+OyEjaWaWvA+aMQCpY3wg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228e91d1-5891-41e9-5999-08da8bc3a8c4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 02:42:49.4545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbSiT5n2HUlLeMwd50SdivgosHZXHNMpOy/sL/Rr4F/gAFdrc+uaT8sQyq66Xm5VbYwgUlvraxvVT/sXQEeYXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-31 11:58 +0900, Benjamin Poirier wrote:
> Test that the bonding and team drivers clean up an underlying device's
> address lists (dev->uc, dev->mc) when the aggregated device is deleted.
> 
> Test addition and removal of the LACPDU multicast address on underlying
> devices by the bonding driver.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
[...]
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> index ab6c54b12098..bb7fe56f3801 100644
> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for net selftests
>  
> -TEST_PROGS := bond-break-lacpdu-tx.sh
> +TEST_PROGS := bond-break-lacpdu-tx.sh \
> +	      dev_addr_lists.sh
>  
>  include ../../../lib.mk

Patchwork detected a problem in this patch so I will send a v2.

"Script lag_lib.sh not found in tools/testing/selftests/drivers/net/bonding/Makefile"
