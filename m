Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479CF5774FB
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 09:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiGQHgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 03:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGQHga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 03:36:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F491A3BC
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 00:36:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj3XpuIt+UefKfDFPm2YYpAywn2nB+z0aullCytvH3OWZv9KBfDVg5wmRWUURHj+NPzIlTjORcy2y6/Fb6fiZwJL1BHCuiMRowgz9YA3xZg4Hcr5dfFe/jZvpnxuFrAmFE/VRUMyw8M1TEy2R6qiw09vDRnxxpIGVMgHqBdNuAP72dXOVY4pSqa0zHeD93b2l+AvyUZCuehTAyQXY6vGR9oS2sdW8nem9V0tgCVgsVuV/LYAMnDJlU5C1aEvJPFj52ppFcQbkNvsA5l2MvyRBIqS3JD/wuuMHL0cU7/jTw6BV9HDwecZDsUWOFIh1AUc2owdc9JcSUB8fwHkXT1E7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJ43pkgUNU1I0rn+rfaFeMyNjEXhA4QOdvHrV8tXeoo=;
 b=j5rzNvb1WM+6UG5tC4s+md/zCyMLW8mCS7SczqBTqKSVtHoBK9AFlMbkuEl+Rs4Chm4148cBNB7DY0AT7mdye/Ji/FCik2BvrQKzV5cROjhWE2SQC6z9w5iIEqlU8/sZxbpRxoj3Ka2PYFqWdMcW+hBVfkUuXlMzYntMHsCP3z6Ox+5mpxTdctR2FIGyYnpy0wegd+tSxxYOUhoSlIOUjxpRX5FaFUrVH5QRyzTwAA2ZSuhO09Ljxk43rlNxEpOG4HLkXl1c1CuKXYpBjI31OAGRTaXJLNfFnrIDAqQ+yd3wJoB2WGbTYoZ0S/DjeiX7AdObdis7y1BqlCQrLR2hIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJ43pkgUNU1I0rn+rfaFeMyNjEXhA4QOdvHrV8tXeoo=;
 b=YKtZ035BJQPsSmYCROHVqLUNkeamaWdOuc8PMxtVF/w9ZLtU7HhcERM8vK4VeWMu73NnvqcM1qXOlVXYWb93gHiDjK6qvtHhyQyxwYTcBpZbPImlXtj3FZNT6um0a197edQqbhFfDyAL6sxMJOGTwgqOIZxkqrTGpVMCBxLRG1ExILnnJZTqASfSe8LmowymsW36c0gAp17MuNy6YaZmaDrBqxRA1oBwOuoFelnZlPrNeyC2I2MKbCkPPkVMyN472IiEpLZp1ymSu24JP86PF1hfMlP6T6TFRPtxhypn36MZMI0MZ/n9IraCRq1/R7x60FWWXur1DYXm1cbPNCZg6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB6483.namprd12.prod.outlook.com (2603:10b6:208:3a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sun, 17 Jul
 2022 07:36:27 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.022; Sun, 17 Jul 2022
 07:36:27 +0000
Date:   Sun, 17 Jul 2022 10:36:20 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next 6/9] mlxsw: convert driver to use unlocked
 devlink API during init/fini
Message-ID: <YtO79H0VleQHfMUC@shredder>
References: <20220716110241.3390528-1-jiri@resnulli.us>
 <20220716110241.3390528-7-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716110241.3390528-7-jiri@resnulli.us>
X-ClientProxiedBy: MRXP264CA0002.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 425aa5a1-231c-4f0a-f3b4-08da67c70edb
X-MS-TrafficTypeDiagnostic: IA1PR12MB6483:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isS9B307OhHXQdWGjeNKxsI4+mxRBBNKpgNKFGZ17KNr/OfkDo6Hgn3ymBTtGOkTvZdWRhP915i0ccK/IGTV/U1GPTSqxu2v7owtZ7B46DKMSnID0f/YVIVKQWjPgfGMxiJORj4aM0+dsosSHKS/uvcFV1IaNoMIfHYCjRtJePuMXjwoXVaqvugSelvxU136pHzM+l8UkGyx9dBe8brMZ8JZDJbd5ApU/q35Ignck4eKOtdmpsDumSZiSJ+8M/LKGCZebFRCdTtCEkUUsbGf4JPf6yy4XKbhGnOV74AN6oN4QahVQ3/+fPQCKlWdBmw0E3pUfTn2axVt/D2mdcFsg/9aPjGlD4Z+6nw1gDQ1FqXxT6Ts0l8BBpDpIR0r1AT9/r6nGhz1LofzhkB+5s/l0ZYmRLVVGZsCcBtraael1iygmoUfbRKrDuDiafGXZg11BLluOLRgZ8hqyxh03h0elpv2xm8VM1upeBm164fHQuRzBdp+F7AiodPzARgQQoRqCuH+KX2/cYTdBGjj+3H8tbmA/i8ggyez0NNF1qvc6aemvy5g9nvFS4Hu8fy5XsiIMzSOm5YVH+iIqhcRdSiWoP7d/8njoTAcoNM81n2siVvFiie+RcceXrgz6aq2bqH0OArOUm1W21g3LZ+yByN1cbljWTq0NZQSv+C/kHpRVGW1oRLiV1fGYFyzIK48tDixDMUQ+5Wqc5LM119luy9LnwNW3BpmovOWZEkR0U0nzhbvFtwoCH+n0OdMfA9MeB/B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(39860400002)(136003)(366004)(396003)(478600001)(6506007)(26005)(6486002)(41300700001)(8676002)(2906002)(33716001)(86362001)(6916009)(316002)(6666004)(66476007)(66556008)(4326008)(66946007)(186003)(83380400001)(107886003)(38100700002)(5660300002)(6512007)(8936002)(9686003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7jLqGgdSz2OLt2TG44JadbMO4F5xZ74n9wd/T6bnhAugX1IpvIIYgxUU83oZ?=
 =?us-ascii?Q?O2XU5aJc5k6XajA6t8lnYdZZoYpNkgs25JTcsurLSSeB7zQfi9H3FIigf88Q?=
 =?us-ascii?Q?3t9y40msuWnCkLcw1A5dRyzYAtHXW3phyvpwjHiMtcedT4fB/iAEwGO4jaTg?=
 =?us-ascii?Q?R636VQAUQF/UK49vQh7yYyKJt6TVhdfaHJqMWr7ygXOnnQXml/3cF2lSAyfW?=
 =?us-ascii?Q?DJ7Tep6wgKZlIl6Mpx0UYNoEyQLyUhh++dUn9jvNRdLmXM+FF3wxHJfY5L2F?=
 =?us-ascii?Q?xWN6Ti1Gao62KA/ziECadvCBMGIXwbvZx+6svHAlGnTnZzSUGvoBt8qFb4DG?=
 =?us-ascii?Q?aGiOybkSvFZiqGbmd8NLa8zuPKeHjsr9o2i5zasxmV/J6dKZDiqm1vIc2+yq?=
 =?us-ascii?Q?IpD6+ExMqPzPUQkPvbW/hFmtWocJNBoGyMAd3QjOpWVVS3tqAlIOmJfCxYea?=
 =?us-ascii?Q?CPSm7oTh3VNpvy4L2OT8IvELGj6HQ2cgc1NVHg3gDJ9oA9y8e3B06SoIMUpw?=
 =?us-ascii?Q?RFhHCrJZROCBglSKFtVNruOUXm4bENKVg6XE6bEqLUN+1n0Wq/a7pDiulQOW?=
 =?us-ascii?Q?mSINOmvVxI5F5OaG+3XAI/9l6T1W9BV1WLNlqUoGxu+D0NuLkfJBdcdx3+9g?=
 =?us-ascii?Q?ilAeR8bsnFJz51uz+JmTozvkEptJiC6f7Fi/mPet0va7IrlNZcROAff5ensi?=
 =?us-ascii?Q?l7jzRvNUeGvPckH5yum8Gt10M4dysl+sH2LdHh5nLx0nmgdV+78InncTCLBh?=
 =?us-ascii?Q?s46BTrRLuHWezdRMAetqCcis69KxwUNk2MKx3MWcA6mbmzMp8c0dso/iOU8g?=
 =?us-ascii?Q?hIAJqoZNM4IEm7DpWdovD9t4GQTXz4E4sP2kwcX8NpP7loiS86FVAK9VMaw2?=
 =?us-ascii?Q?a/TMigeVTvOjIwomutCoSm65As8el+OHJWsgbGhyY0HTwWybzvichK/dKMH8?=
 =?us-ascii?Q?WpXRusJ18wQUBsX10GXlMq8Hswi8clp98oIFfacfMXmByMZwBfiV/pi31X9W?=
 =?us-ascii?Q?EcOp5hSE2gPevbWheCUAkPsEW9lSsblJV0psCA84/F6K8GIQCgI20u67K+SM?=
 =?us-ascii?Q?zKLFtWAcaoyOsgHb3T0YCZImeVBMqjwhUqvMEvUm3/ewLk+2MTGLbK03nrtK?=
 =?us-ascii?Q?hTwRNW0U1NzFkFYR7E+CThffqLEsBQDmrPesV5Sg5MCQRYmsaySy//UrED0P?=
 =?us-ascii?Q?vo55P6ipu6wk9URO7lZGAbwow6I3N6ulpgMuyh7BuO4hP8PD0JaOnFtcXMxU?=
 =?us-ascii?Q?C2TXvn4coo6KI8U1o+iPikDtAkZ+gA4cwmG8bOfB86mys55g/pSYOuVng5jF?=
 =?us-ascii?Q?Y4XFYuxMH8/I0AbsAWlgf0el190shFOfh8LHSi3+frxwMBD/OaCROrDTwIss?=
 =?us-ascii?Q?wU6MxY74D7bdw/mN+bav8U0aS3LCEQtEXCf2U2iul6czs1LxnpKFL3GAZ8Qg?=
 =?us-ascii?Q?uQjTUW1a+s7XWvIV5ItUm3i9IeN7bXj4tCt2B36g7xM3INH8HuZTCsPwaGfI?=
 =?us-ascii?Q?1uLg7v47c0DD8V7e7P0/Gv/OSlnuup+6OkHM6xAzamU5vawZYIjvgL2TaO5t?=
 =?us-ascii?Q?LPLpbqC2UfQ7cShiVfFze3CQJPvo0XVX9NaqrH5r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425aa5a1-231c-4f0a-f3b4-08da67c70edb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 07:36:27.2887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HrsvLTq7nCm5PVYHBA59Zj1HrOksHoYunhk0L1bW2VhVyJeHLVuR81luEOHwyE2Jj+47g3GLk/rkSufD6A3JvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6483
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 01:02:38PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Prepare for devlink reload being called with devlink->lock held and
> convert the mlxsw driver to use unlocked devlink API during init and
> fini flows. Take devl_lock() in reload_down() and reload_up() ops in the
> meantime before reload cmd is converted to take the lock itself.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

It is getting hard to review changes in mlxsw_core_bus_device_register()
and mlxsw_core_bus_device_unregister() with all these reload checks.
Probably best if I convert it to something similar to netdevsim's
implementation after the devlink overhaul.
