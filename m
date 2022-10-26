Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDFD60E00D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJZLwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiJZLwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:52:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79B19E0C2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 04:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKId87kINDHXO+l8NC95j36cRlUpMh1bMptnQEoD0oGJkRZBbzTS+tIHPKI0sstH6ihLdwUeX6AyafELkqJlgndkrk0zXkRAIUQn/qc1ICJ6DlRmyiaeqA1frYDlI3wtGeNP1F037QoLynrjq6VOfl/+J2NeGu1EGajKt4TgxmGsKAYTdweJQRa4XugEdNfSn6No6z/wNfO269VC+lfIQyPWc+5YUZm+b5ARXUs8ALPUvOgjTMauL1d+GkT8mOTMRn6VU1qo+Vy6T5XvZNS0fzHXrMQjnvarW31clSCO7wq+ML0rl0w5fbhUjLINOHIN7wvADhxL2JvSv0XH4XtB0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5ydupDEv0mxi5Y01KuT89oY9nwZXE12tG30xSFb47Y=;
 b=T+Hh4PxvzhJnSPCMUD9GmBlWXqtjX4p71u3yuh4f9u6p9A4VdSxYguwZN0KY/RRxGvtrK4Sg45UwmtaUpNcqIhoGm5YPLYnhp2OBHI1Haul0mc86L4qsYRl5y8RdQx86l72ZLu4q3s/i6T/MI26IYXEtuYRnl3b9xJEDtiPNc+p6KvS3aAWJUluiNWbsayku1J37jvkrTJBG/T5NX6VpF5cgJDwpAtlWHG2MtZjQP+U3LFf2xxBdhIeDQlzM52iGm+MWDo62bEEmuN8DILx40/Lu6rmunoZWjwjFLhFcaGX58JgZW9uvISNUt6tS4yay6lTXY8J9C5Zt1QoQBZ2MRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5ydupDEv0mxi5Y01KuT89oY9nwZXE12tG30xSFb47Y=;
 b=poBKKMOdKjbktRMNeWj2NiPygBm1V9MfVLa+6m00DsM3Q63/BOl/Z4j7l+1Ie4UKSIHEH8PzmO7J0ldwjkSoKb9rbZZSt6nrtUQ3hUCQUjqmh3Kdli0pZUvxtAr+HDsn2vEz0PR2/cM+RLK+fXkyjgCxaoGW7ub5FPUCnw254+/D70Z21Vv4DsYFvq3rK6ZPL7XqUkh6Fi5JdKXCA4m2K1Rl9Pv/B3xcj2SjEnb3K8JfIyVOi4p9+HKQ49WupNOkk2nTRY5ivXILGzOXulVYc5IJ/xDzjZhcQovfxeNXannL+j6azxPGVO7GHI8LQXrDnZK5tdi7gnvmlI3Z2ZohTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL1PR12MB5970.namprd12.prod.outlook.com (2603:10b6:208:399::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 11:52:30 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 11:52:30 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v7 00/23] nvme-tcp receive offloads
In-Reply-To: <20221025160039.GA26372@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025160039.GA26372@lst.de>
Date:   Wed, 26 Oct 2022 14:52:25 +0300
Message-ID: <253ilk6zts6.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL1PR12MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: 62fc74eb-d748-4d19-21cf-08dab7488f7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isnlZg26Vf6vBn5+BzPsNXRZKTQCeA7drc6zRmjgNNVDysfObSHIlWFVS1ynseW4B/a031cJiAbdESrkRBsGUw24KDAeo+qlyFKU6+TbHVdMUm8SQHE2UnGPnQduydnQT/GxIagGsQRqZyn/zmRzpdYGUxD5p0aJbzs9mHwfebT8ox09HyF4BMBCsREt5R0wm2ExAC4ICZ68aJE8Mruj4R+7OXRpNcCSHIbMeFwImNTb9mVoimNu70o8EMB6ad9mgQvaI9XG43gKSoxVRtCoBDOWGq44UrIpPJpGkdJdNwT9gToMVCtC8jns7hu9NtqzOrUg93XU7Lcf3R6JjoyWRepo4i2i7oxFu3urrB1daDHpju6A9pUnU/p1OI54C511YY0fWCWjItBaEMV861CdSnNkrRHPkVm3jKWAoRwyuwQNkptJw7LhOc3/Ab6oeUcbIJLWfm6OsytV6S/VmoOLRNcPCgcs7bdCzway1HPPpMlk/zbZxJOHEWMg63P0QDYFVdAxxLXgmlzwv/w9h+sSrU2s9Ghc9qvR/k4naDCk/2pda06RQFAQe3M9AxrBNLnJXon3t4OTixVw4jk7DzzmBrD9HalN8/sFgXSDA9SUKQ9FXDQbwjR3xC2e73g7dFQWnpBJkXOuUtJfq2az+LAsaCSQnICBySLWqr/2SvMj1qZGq0XWij2I4u97dphX0Rp3WV//F2jfQc6/qUN5Bsr2uvmPJi+1aUVlZqck96E+K5hWllcPvSeGc/KDngCokPraxqTcl15nJF7OZMEsrEBuhSgKFzXmZVgmbJ5GYh6zbCHlV7tQzPhEXVf+bk2rmzhOng5tJiIDKvoGc0Y2jVhNIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199015)(6916009)(966005)(6666004)(66946007)(6506007)(66556008)(8676002)(316002)(66476007)(4326008)(6486002)(478600001)(8936002)(7416002)(4744005)(83380400001)(5660300002)(6512007)(26005)(9686003)(41300700001)(2906002)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b7JkSO0z3Xz7c/JitreiDCCninqsn6u0hKptX+BTEg5j14Xy9Kc4aPTwl/j7?=
 =?us-ascii?Q?s8SVB8wxUJ4t8YNhhclO8TOo3lN6Z5w5L93C9RjkOsXxvUFZ4LuSjDzQe4uz?=
 =?us-ascii?Q?4QsGbwd09KvdCgUC/YrwzC6HAaj3TCfz0HigzxeMRzxjvFYBAvfnX6rNWqM+?=
 =?us-ascii?Q?Qe8zcwJ4tbQg3vRq25SeGU+PbowTh8WK/sJboF2HJe8KDZgZYyRxDHn48TwE?=
 =?us-ascii?Q?O9iVoOC5ozJcDAuh23/lKHIlHBa2+cSk+/pBdAu03ZdMW+JLadzX/dkXRWM4?=
 =?us-ascii?Q?AoFAZ5x2SBYRtbsjZ2iDJ1IFNCo8Cw5b9t7kE3sx1LXjIBDFugGqlZZpeUxp?=
 =?us-ascii?Q?Qa1J6nNERzhVju4WVpL7YvOqKZ9L6jruimUuoNSm9XdD8HCuri4rSXlOTA17?=
 =?us-ascii?Q?qbdHPoyDkjWcVSSnVEEi5E9mstD+A7Y+SB6pgaK+fp1dgkFHHA5BEkNLI2VJ?=
 =?us-ascii?Q?pefJ1P+Two+E+j7+AkqnQlZgdTp+FeSuMjGgq8rSw53uL9IJcUBhyX/cInON?=
 =?us-ascii?Q?YcfcWmAzUo6pR4Cp6/+u3PosbjOXl2H1v7zZqoKUlwWtW8uCJJDdiCQAG6Xl?=
 =?us-ascii?Q?AGWNgw8BUIwnBwcQH09BtTJa4RTWkZCytd3LRqksUphrfUdjE0I585/Q/wZp?=
 =?us-ascii?Q?idXcKNM96F43syEGJ/KLQMs9EtPvMPo5+mm4557Pa6qwWPNDs6X+NXEMP+Kj?=
 =?us-ascii?Q?6PGBHu0v4xdN2aAMX8xHGVdVUsiZP8pimW94EYWqsW8cr36AcdiQVIShcGuX?=
 =?us-ascii?Q?TJ+zjc4WQuAobiQkp/zDFMj5BELmaMaWByVtcLK6mmoCbzOU+SAyo/W0DGEs?=
 =?us-ascii?Q?90qv2P5irM/wMPl1gH7JDymfIDpAJzMGYKTxEs6SHGb480TQkywVB54VSZJj?=
 =?us-ascii?Q?vfSmIGxpk9C+OQvr956neiXegST0/7crtEgtbOkXSQVQaeMJjWtn3RjGMOdD?=
 =?us-ascii?Q?sm2nNTrXWK6hgYMIv2c+uU3Wf93dFEH0kopW4dkjQLu4T1NNwYZzupMp8RrK?=
 =?us-ascii?Q?P1HzgqoiDVCe4aga1YHWbcRHza11hwQff/eCruQ4UwSmzyhlAc3zZPwX0ASv?=
 =?us-ascii?Q?5EtOPbd+PXA3F0vUaD+O261Jf1uaZoO+Ls3zOTWFAdmbTlDh8KTOdnd0jMwF?=
 =?us-ascii?Q?k1byTBU+5Sf6TWwnWGAM4dme2NutTAVWzzhSeu3kgjG0zFImPDFfbkoZQiqt?=
 =?us-ascii?Q?qcPeTjACZLBI8dA3jhrBFamann25UauGz/N6u86MfVqlbebGGytn2jpUzvMK?=
 =?us-ascii?Q?GR1kSKVwKmJ5PkzEw+1JGjQ3aZC3PMBryjXbCfdAvNSaQVWU7WSAwAAw7HWY?=
 =?us-ascii?Q?dcC/j82b0zDBwkUKarqZ0kEzxBw26JgBXUjvXSNCOvEtLntl7BwPKMy4awoF?=
 =?us-ascii?Q?aGGgiKYOm6CMlYHSGyMS1Iv+g97NZM26Klhhm5b9QKl5XzhK6/wzoLtuvVA9?=
 =?us-ascii?Q?hs0iHCGj88HhMt0/LU4rW2bFXKx7xhQQlX7bnyzNxCO1sZAhoj9Ll8o6mxKx?=
 =?us-ascii?Q?m3EV+cvbeUeowemZK8laWmLozQv8wP6ct0hj5sOjkZZRSsS0EocfREPHBuei?=
 =?us-ascii?Q?J2sKDJPFWrZr6owlTZvflL6BUBFMAI8yxx5UKBu0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62fc74eb-d748-4d19-21cf-08dab7488f7e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 11:52:30.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxWMxlGIDTIbpspAbqmRvlWXdFjQyspzy5kVL/59JwfZGsFgU9R5hRNQTITD3B2OYY//ssXmRidayvHpYxpQVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5970
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

>> Currently the series is aligned to net-next, please update us if you will prefer otherwise.
> Please also point to a git tree for a huge series with a dependency
> on some tree, otherwise there's no good way to review it.

This series is based on top of yesterday's net-next [1] and I created a
github tree if that's easier to use [2].

1: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
   branch 'main' commit d6dd508080a3 ("bnx2: Use kmalloc_size_roundup() to match ksize() usage")

2: Github: https://github.com/aaptel/linux/tree/nvme-rx-offload-v7
   Git repo: https://github.com/aaptel/linux.git branch nvme-rx-offload-v7
