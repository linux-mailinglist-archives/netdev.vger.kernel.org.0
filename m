Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B817571A34
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 14:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiGLMly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 08:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiGLMlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 08:41:52 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2767A5E77
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 05:41:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEyv0fpDd+sUXZjrILqoZlhfaFGDuCYioHNAGZdwhsKoZwxfnbe1iMFuS9+MMeYLVwCWa0nJ5gjEJXU0xtp7QrhPJLNshxtmyKwAUfnnkn6O71hvTzL60sM0Ox5P61khxtM1E3nyyZdfmHQyKTU+dPbEBHGbNPBADiTl2klWjMFL+nUZw6HtchG64BNI+8+PVz5oBZPF8lj6uFrJ34TpZxbDSXJzo8XPmHqXFahdyz2hMR8rQ7PD0AQk79LTokoSbm0S6FszxrWe5Rym7kCPyid5yrFA7L3V1Jp9w41BphvfxTrhp39dY2UoIQS8B6ofF+c/Qf7O6V7j4jDyidwq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcnjFR1PDMFyByTQWIPn854VG9jm8/0pzEFOoidDgWY=;
 b=MVmjrDG8ZdUxfy/pzcDyVd0ZpAYywNHFZMA2cSGIPx9hj76NZPNwBYbpuBNn03Jtw+nOIsxe7/30RDa7RaiJAlfj75njghwAs5OAsHEfT7Q8ie4QGZ+ATNApw/mcKqR/2siq8H3fDCQInf5uN6pqis1SJDG0gHe+aEPJjeyiRe6VZ73Wa/+lUhGusGpesEibTiUgGRRfTiPXyj7KhINpkjj7m05mzaViCOXTR7ig2PBWV6Npu1/ardwIgKq3djHsDKuG2Kzq5t6wAi0n+77KcuF5qPonkqgziYHAwB5iscNMtC9uaZpebVRXqto5vc0APa6Lu7w8gbLGltkGrWROSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcnjFR1PDMFyByTQWIPn854VG9jm8/0pzEFOoidDgWY=;
 b=BH1Pqmb/dUKnFjUW7emnq1raQFMwsxuCj+aXjFhsNyaTamonO9+QguLEPI7aNgDKIEEPqAQg7pbAjnzL+7xKr8YDhLLazyUl8DNklU8u9GIZ1RBvArXtqd2wThR7jZiaTnMjgcgBDw0FeJwJ6uRxn4a/mUbjg65E71eldF+ZJcRoHwyAXW7cSz74zOT42Sy+/UaLTuefpFbPaEgpys2UHNlHGlIIZQt8oDy7Tdp9WB3+WEqse5H1lzunheP1AHdtHFRbfwiWdkFsHr81OHj8plU8uksjvjsOn7QQe6w9pSHZdMH/bIJLANUGAHo7V23R5wj89f7R9C931cSDLlO+4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB3197.namprd12.prod.outlook.com (2603:10b6:208:107::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 12 Jul
 2022 12:41:48 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 12:41:48 +0000
Date:   Tue, 12 Jul 2022 15:41:44 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: Re: [patch iproute2/net-next] devlink: add support for linecard show
 and type set
Message-ID: <Ys1sCNp0E0W86EGG@shredder>
References: <20220712103154.2805695-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712103154.2805695-1-jiri@resnulli.us>
X-ClientProxiedBy: LO2P123CA0083.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e5073bc-b7fe-439e-c55c-08da6403e31f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3197:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eW8uGbi7oY06bWxlsJOK0ZeRhqD/Fvc6QECPrImI8Vsqf3wsAKOEAfZE4BDA2BcaGiy6KHMAiiLJcMXoqVbYYwVam2nFiMknf0ckpogiXKiywTE++5uOSre1sJ6/VifwkkBDmLeaHlcPN7bCve6iixfjlStZgBtudtCBHZszx4xJAH3cUcYwfIgquPINbqdQ68MxkG0IIQ8x141GhX4MdZ3SPFwltEA3yNIAEATVRMJi03iQNF+qaIMGAYYTvLhdmSzSK0Uu5cRbbLR7G4Y9/uvNW2lb+ZevJsgfNgd7YqPt+FbJhle6wAYDDf8P2EUzbU4+iN1WDjg7DWZvD8sjxN/0BXjkCInHW1jJsdZq6UbUVejZ7pn2XAvo/uSYhWVIAeeeCUFugD7gbiclgUgUHXEZWlSCE0MGrMFXE9cdKNNrN6W+SPFy5Lh6l0muzHju/m3Qeps3jCuieNWleb8w2HoJaaHGAt0nOy7LLes/0tHsX9C8p+t1YPqpHxO5wQzRy9ZAcLh2Pa4WD6WZ/8lCP6aGyH3EV01Nte6zSPC6EGyaKswNmHumXH4/QyLmaIsmH4NwQC7tP7VCCtnb7i5hZNAHT+oI10yAFN6I0qIc5mddSjN4Pe6QU0HIG9t0WjS0ZA1tnD+YqX0916yZpBd96UoA32GLc/noqCHdee7uCwqT8++HzdNDuN9GiFOPMYUNZw5pEGEJHmMdC3supp1hq0Sm+7iVh4m9vGxPBqLHB7NrQ6NvHUqzAmlBZP0WgFxv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(376002)(136003)(346002)(366004)(5660300002)(66556008)(8676002)(33716001)(9686003)(2906002)(4326008)(6506007)(558084003)(83380400001)(38100700002)(478600001)(6666004)(66476007)(186003)(26005)(107886003)(6512007)(316002)(6916009)(86362001)(6486002)(66946007)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yXJOzoLdIp7xJj6MP2UFoVAVWnH5W+Knmn9O/BgclUvVPPhVF6xqUJqPG3aw?=
 =?us-ascii?Q?Zv1E8KlhvPkoCWBYA7/tQbePxoYnAHZTm4BTO0RV33zGTJCq1E5GDkI4DQJ4?=
 =?us-ascii?Q?67T5N9i8pH2ke4B/bFPNbDEmKEa7BS6XPAKDXTHC8GzVNX5c7AqdlaeQPTc8?=
 =?us-ascii?Q?nzNCLiQ6sKxqGFZLnITGJZMs52PRAFsZDWnWqF9hDAm/xPxbVdeCL+jn0WYX?=
 =?us-ascii?Q?JdAHpG6w+BwWmgm1uma+EQmJdAOZYp/D/bkwYexEUTxi+gujg+a8Frg3ePe/?=
 =?us-ascii?Q?3OXdz2GhPEveQLAZiB6+MJktYvicK9zb9wjNjTlzvRGeGcmmnAixKYnm2ebl?=
 =?us-ascii?Q?qpH+FQoaidGmpLDm4s8Oa+9dqIQa7xIWIb1BlVdu9u6M7dk0HdcSUWEgCqB6?=
 =?us-ascii?Q?UiHom+r9StZ/RkbmluU4yEhSWvtvC/hpJf0isAmBHVZhINhJsETxIU5/RD4S?=
 =?us-ascii?Q?bANQjGyUWUQRCGA25vdtI8VDXgRQuyO4AvTJomgrASlStWUVwMDXaKLDtdQU?=
 =?us-ascii?Q?vSAXD0VDHdTkFoFLO90JfSfCXRf7bACJ4bleYI8Xbu1hhD8Pm0qy6A21slcX?=
 =?us-ascii?Q?Wtvu2GqhLtohloHEsjxcxVv6EaRFEsQ2MBq/gOli/IJ+YSvfpjy1Sh+6r5E/?=
 =?us-ascii?Q?M6pnjXyLrpb5RcVSVeg3nDUm7+G/S8/DETL51crC6K2tapABaejCdNPnMp2X?=
 =?us-ascii?Q?61Htpv9QLzGX3mf4djBWQYlIM0MlNOoalVAq8GVlieIg7a68kbK9GbF8vYOE?=
 =?us-ascii?Q?EVhl+39Nwnz7Kyd75IGpst5Hl2oKXqj4yI7O+QLHChz+iqzyIgWFdC5ATEOi?=
 =?us-ascii?Q?m1adgDmbNatDe3qwkRiRQs1ipKPKovysU2kYxB2hOTk//Uq2Aro2OHPbjIQ8?=
 =?us-ascii?Q?JoCylLzFKwhBWISwJ38ffCx+sGK6ShPKQHDgk55tvYrKMHz6W5dp1JgxmxsF?=
 =?us-ascii?Q?7754ieIVLmr2Fjcp6sy2Bu+sKlrvrIxzJ5ejPmXqxKaRmx0MMivUT7JlzoHo?=
 =?us-ascii?Q?sQtzwdT7C4mrs76fSMWu/BTJxeZvaloNvxin43okkrUuurgo3hY5lTi5uQrz?=
 =?us-ascii?Q?RMUBe28NJCojG0NBdtJ5CyvALwIoVs01H4oB+FMswLUngsp9Z4M+mT3adi4p?=
 =?us-ascii?Q?V++hl4+6UDTICkUbqwIByvvCCt7gmtvRrMdv328ND18oUStYUqLMdVHuJWJH?=
 =?us-ascii?Q?+vBtPqLsN/GXOJWQNd/ha5N32o9Q3rm3ctO4zfn84B5TuBD5SBxo8YjqpFTb?=
 =?us-ascii?Q?DJqkCaVRV+BSjN5MZqMzUf4wNpMITs8xnLjaHIJKu1GZ4Ayx4pmB5E2bTDI8?=
 =?us-ascii?Q?lu9zP5cjwArMt6OkaKsWclLbMjOUWoZA/TA01FLQ45WWTiISwZDvjNzZ1Ywm?=
 =?us-ascii?Q?YOV8L4GN5VpAAPcW8CeAzzJee1Xvf3CTq8p+GurYhiCnZsYdny91mm2PQnyv?=
 =?us-ascii?Q?b/FQtOvkUwfB2Q8VK12kzi+xtNbcpRgkvseDP4E9ffrnm0VQSdy+kTOuo361?=
 =?us-ascii?Q?S5Dn0QbFoPwUSDfrgevqiK8y/6D9oHjjwweSbTYZh0GhJQp9iMlqNwlvhGcP?=
 =?us-ascii?Q?rPJ5dBkJUg0FGfRFqqvpDiphThLJQRNLLJitYC9/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5073bc-b7fe-439e-c55c-08da6403e31f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 12:41:48.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hio9PAsUKTqfJTufm0MnEyiaSNNeuh3lh8qX2QeH/XVk7hS1nc0wjgsphLN7Gjzh+YCVVrfvFZoSv8cLzVXgGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3197
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 12:31:54PM +0200, Jiri Pirko wrote:
>  devlink/devlink.c     | 210 +++++++++++++++++++++++++++++++++++++++++-
>  man/man8/devlink-lc.8 | 103 +++++++++++++++++++++
>  2 files changed, 310 insertions(+), 3 deletions(-)
>  create mode 100644 man/man8/devlink-lc.8

Missing bash completion
