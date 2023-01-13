Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980F56699FC
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjAMOXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbjAMOVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:21:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB2F8D398
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:16:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ffngk/RUQkAJt9kFj6JwstDzhGK/D2/EjBp+ztlMK4LsF90EArhUD3JXhGr7qDMc1j+658/eWYYMMYI+I3OOQQy905bD2AlyzaWoCWj60LN8cR0dRFjP8Ge5ybE+/czV7xlTEotTra4zcfVHHT4aQBJJ80CFXFkmRa8o1X+xnN58sOHQR8e2E1Pyn645+Vpq4EzlO6xvY2HVIrDuM+tyySowzNwCbL1Y9SPOxlwyqil+dPbFnAkeIUw+BMTr/u6CIDISQJw2Z5rELCHIyz4+1boz1Hjq6ZVQeSwHSXKK/OFb0Vawu4toM3y8v8ahnPA+SfYspDhmi2l4+Wf3GXCDbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtJSbexbp22D3N+LrkqAlEolwPdQgkO8e9lmtZ7wbTY=;
 b=HKCOGxP36hpxPymavr/4x8IMfS+YiUKktlhFXBqM+p5Xb9xrQB1XcGPZ0aIGo97HR7bTp4v2mjAq5Y9fyZewkh4x2nufZxJk4dyJ2kXYQ6fcap4Ogg90tBjHkAGyGgjiRTljy4KtB1Wf0XWp4sSa1DVL2oEj1Fpxvmau4GtRAvu0Bld8Uj2CLs4/DNGCVGvw0Ji8YwxFSRpd92LOf+7jIupPTlMxKAkDI7YvSI6N+Ujkj03lhw2T7n6v1DaesWPlNXrOeH1zI6x8iXWgbqurLD9DXje50iJOlVPCiQXCnWySY5uj3hO5ugFnBWuEQCD+gWQc/iisW3dhPNkQgyjYdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtJSbexbp22D3N+LrkqAlEolwPdQgkO8e9lmtZ7wbTY=;
 b=Xl7EnIH3OqcZD2RpkzxQ3RDT4J9HILSRV/wRUiYNAjaMD4TA/aVc9E4s1HJ8Ol5I+dl+mjb8fkQDemZyDIqdOUZc9CznmEMCoVsnq2HON+qsNz7NIxnXS8oAVpf/CryiG3hBOp82jpMI7co9aJwr8qP0Q2kG4kE/AGNZ+bOeCEuCYN7Q/h5ZbnzVno849yo0M/tgfZuEomirr8FNfVeJy8s57kNCPKi5/FY9jZAJELDa2Ps82pfgFreTIM63BMCaXSL797HD2vBPqig7rYAqKjMgImzpROuk3+8ghiOKddutv6o5nV/GNP32v3oJ0Oixn8bvsxStFSQHt+YH2P1VGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BY5PR12MB4273.namprd12.prod.outlook.com (2603:10b6:a03:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 14:16:15 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Fri, 13 Jan 2023
 14:16:15 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        Shai Malin <smalin@nvidia.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH v8 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
In-Reply-To: <20230112154700.46d148ed@kernel.org>
References: <20230109133116.20801-1-aaptel@nvidia.com>
 <20230109133116.20801-4-aaptel@nvidia.com>
 <20230111204644.040d0a9d@kernel.org>
 <SJ1PR12MB6075B6ACD47B7707087522AAA5FD9@SJ1PR12MB6075.namprd12.prod.outlook.com>
 <20230112154700.46d148ed@kernel.org>
Date:   Fri, 13 Jan 2023 16:16:10 +0200
Message-ID: <2535ydatt91.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BY5PR12MB4273:EE_
X-MS-Office365-Filtering-Correlation-Id: d93955a8-6dff-40f6-0259-08daf570bb47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4AfCfCuCg/nc+z7rmhipV4LgTv11i1FOm+U8bJT+BhaIxz+fRRgWcP4VaaP0Az0Arso2huNWWb9ioMHKrhzYFANHDQ+ixgmgiR3lRhiJFV84WQHwtR4riXPqBpPv62xSm+v+YOElxdcOazagNc+N4rZPw5jGX9BnGw3LXBSagO8P3yVon2RHUg5sbYG9rOvi958WjnvXllXHrkntyiDiflRLAMvI7mWz4qcg04/79KK0JOCGPJ9k60OzAxniaa5bQbJJoqjRJ0hsbdgBnQW6e6niAuwREXWokOMwq/SKBo2hh/7w2RGpqljLJmQUcY4N4oeVwyn5xe4GJvI9MdEWCq2qOUwq4D2acfbKTWmLaNeLBTS9VL+wwUpB5Cbm4HsjzCaOUjZU05xv57vsy8KTDsKL0x2kss6DmQnyvfIGOpau7LHTZj4lDJEYEqDF1+zyM4N9mJU/nMP6lVs5HySevD6FcC7vkUwljOKiQzwASGnu6QLaZOUuxHKWb5O1tGmIT1LQlfbtxl9jan9Bk9h18fEUQ4fWvmCnHhyN+lMtUN1m7sDzEO1WMW2YHwHA9dbuULv/x0IVRNBWfGB/qMMBZGsSTjs8XR9mR/THElnLcB8bD1sJ4qy19HxGPMQLQMCAjwFj4Lr6dEv0u6sK2nqkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199015)(6512007)(9686003)(26005)(186003)(478600001)(66946007)(316002)(66556008)(6666004)(54906003)(107886003)(6506007)(8676002)(4326008)(6916009)(66476007)(6486002)(38100700002)(8936002)(7416002)(5660300002)(41300700001)(86362001)(83380400001)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pgMAD4Ao5aRnzyuprH47DayV8If0GJ5TCY5WOwccNTu5pXT1MY+JToox1R4I?=
 =?us-ascii?Q?ZUXJS7MkNzA/opvsQDoSyQotVk3lzAehbG6J0RpZKfoP6dOIAAlU5SXBsj0G?=
 =?us-ascii?Q?Jba8bo39tEDJuyszVHUo5z4Cm8RsC4wgiG7+KnIodPXU3Q2o2GFEHHmqvo8J?=
 =?us-ascii?Q?INgcKq0XKflgngOg3dWXigUXRlL6uAhfuW3/QztCnObbaZsXV4do6gGU6I3V?=
 =?us-ascii?Q?0VTM/8WEHn82o5hy4dlx4mczCjhwgzejVOlFAUj/5fnxScUmbJVNqz3WMsty?=
 =?us-ascii?Q?Ckk9LIlJKxgZUs6Y6l3PfW8S4gJDl/1IZgBo6AiY4/khDbfM+ZAfd8kTu2sy?=
 =?us-ascii?Q?d3fp8lFbBYUJdYcnn1PDRA/tWStOjJBIO5bOXbSpB45Tb6HF8uPIliYTUo4m?=
 =?us-ascii?Q?biWpxlNP9b1qOC2MAra4akbim9zouXgPSGDc3nbmuwYrzup7fo5gJ2WbVksT?=
 =?us-ascii?Q?AvI962ingBvriqSlfy0aOnTr+faDlRJBh/zq6GBNWWkPgEgUA1g5K7u2B5DM?=
 =?us-ascii?Q?NBP+baUeqQ+CPpnzqihIc3EiygtojSOOF3d74fWJ9tMUqxKyaqq4cl7adMIU?=
 =?us-ascii?Q?wNPLa3amTu4rs2aDuLfC+EQ6KYzMHQ1UqH04IXUNJvr+NHc6ldKNA95IxTDR?=
 =?us-ascii?Q?NpA18UB0cRDRMyi3LP1TS7+KLasOgbXE7QdevVKyIYjI/g4lphq3+N86KONT?=
 =?us-ascii?Q?r+Pjwst0K5Ko66Kaf3SLtKkWtvdl5WFpwQxae4vGcAN389VL8vZgvsO2KYHD?=
 =?us-ascii?Q?/4HBS+NFUb/6Dg6SiG+VfepZu9waUqls4CCE3j53vjFslsXbGUorGJo4bng8?=
 =?us-ascii?Q?lFEWx+LQyegyk8p5UBkjy+YD3VrMF6wIfrBQcbOc11ZTEsOSvs5CxOz/36l3?=
 =?us-ascii?Q?BL7FZ6G6wfnHT36OXuGsy/t+kay3NjAuHiWBK4q8zcGxI7Peuy23R8LMi035?=
 =?us-ascii?Q?yDm6ktkhBU1k3nlfbprI/+oRJ0fEtzOQ7ZHD8T52Hlkfk41SVWv21JMO+QO4?=
 =?us-ascii?Q?7aPZO4PwfpknAq8LfM8hjQe2yMi+CvqDL7oyg+eR2FH+SpGjomSBlkW6MnID?=
 =?us-ascii?Q?xoUu9IgC8kUdYghawMHW6smjUIvXgSjfQNwwSi8cZqhwUsa8RtvHqQ9bqla9?=
 =?us-ascii?Q?V1PKCPirdga9rdsjeehKq3vevDCOT7TUtZSK1/KlcwOs77zcKtcJADYtdFen?=
 =?us-ascii?Q?JarF80VA75DY1n7bgaYISqV26IaiwfKWV1juclVJXF4vvLQINXRrUuFBbWpm?=
 =?us-ascii?Q?5p6qdTs+jwisQjGCjL9AtPi0oYaiiicO0T6QCVRRp42a02ANpD3+xfHCSlqj?=
 =?us-ascii?Q?+dmEcVTaZFBSlYuQ2Kob0r/Eca0mf71252IiNQVuWgExfhHhYOIE07XmDqVs?=
 =?us-ascii?Q?qDk6gzPT3BVvaGAIg/1FhGLh6lyXB2ufLBc+zbeF32FduvMWStIwezjBJTjS?=
 =?us-ascii?Q?pCcI8pb5PBVr80Z7sK1jRv5e2rjNrQzCxRuSeG5AnI0rpa27Y+eJzXCpqbl8?=
 =?us-ascii?Q?012NuSAUAODmkBaBrSerkXQtGeJma9Gf8w6z615RWjMCpLZG+5jqEHuMB6gU?=
 =?us-ascii?Q?aUlV1TJ3THZme/4ZaHbsbqsKM7nex7poQxsALwsy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93955a8-6dff-40f6-0259-08daf570bb47
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 14:16:15.6918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9izFiiRfsohustyfkimozoie+1FnVCLZj+A1RcmOh5SbbSP5/e6yFRyqxArUG6zrLh4PPzM1tUUiX9RJFqe2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> The standard ethtool interface should expose the accumulated stats.
> The stats of finer granularity need to be reported on the object to
> which they are scoped.
>
> I'm still yet to find any practical use for per-queue stats in
> production.
>
> IOW report the cumulative per device stats in ethtool -I --your-switch.
> The per-queue stats can go to ethtool -S until someone actually finds
> a good reason to read them in production..

We currently don't have justifications for the per queue stats,
hence we will move it out of the series at this point. We might
reconsider it in the future.

We'll continue with your suggestion with global dynamic strings to
avoid having the need to update ethtool with the additional counters
we are planning to add as part of the incremental features (TX, target
mode, ...).

Thanks

