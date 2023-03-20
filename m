Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3596C2156
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjCTT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCTT0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:26:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6394A1F9;
        Mon, 20 Mar 2023 12:18:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXCg4ysM/GwnmApIBWL1HyR9828VrnjAaVm/KeioLJNzU1YHBj/e7RxPFmk1htBqhiE+SkgOfQSAdHssMJGcmRjfUitLL8Nqq/VmXEZTY/1r/oH2doAl1dMJvLLlozn8BNsgwK5LHwMSbAFIFZSO973Q3UYsPynltFIRjQWS6MoesvTzdu90ylP1+Oql8U97uzst4/ybqG+P/8iUUf/EpuateJCTTCYC4HhSBY1UHMxal84qKRhDvY1szPm2oifDkaiiLgLo3wlR0OSXL2fMPPQ3Ri7nfr+fxUqPLyFkmgJNxdcCIqnPd0uxl0q/qUWyHJZIc19lFntrF0cikg+ZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUCOVP1zUDEL2lJEKyKj+5zFrdhI7NfhFjSjoL88Qdc=;
 b=WwsgFxGZLbTqP6FoNRC0uBONMs2wHrUc/50L33+T86zeZDwdYMQGqOB3JJg6SnU9UIvp+pktSm43KDJANT6O6d0nVPfZ1u7I5HWwrIubC5GqCO+IccIR7PNxcxLTCy887xEmsgQaxNZfWv3rPPCn1CWQv7uUcmos9peHp2QhOAKnFpBQOPmoBd6jRY3y+hiN3d8XAQh+5/z3Qc+UGrurivyY/PyEd6WFg3iA4FZuF9jyTxE7V3KueJfrVXoOO7tJ1nN9grtzpL2FeRP5/A5Kt66m26TmaEhxf57UyAY55bsbyZ6rGxTIhMXpG97NsS8bQVXoJwHCJe9QCCkWB/05BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUCOVP1zUDEL2lJEKyKj+5zFrdhI7NfhFjSjoL88Qdc=;
 b=Nhu4PLTsAUtizy9ePkKkLLVtsbU8EnOeWCHMrZ1+grn9K4aQGkhQjRVIIcBmxmY6Y/u2h6AgyaHu8FnJ9dBzkGGLDGEJ+NaDeZxVTYmCAjyUh3lnCPcniTRysC7rcJuo5u/3YJSAhEmfbJvmtlt0mX4ItYLQ5slkcrgtA+bJWLQWEZMHR2WcPxyUU8Fna/KjYlTSRqyNMunWHdmU7XGYWO2UJhmjamN6egH0VKawmNcn2wLERfl0l/WpvQGD3ZJxkilBirRKFIUSHzFI79IcquywkrTXOpsCxo+PS/FZYoYws/2kltFox0vJ7ibRAxEzxDnZONYRzEwtn4X1hwU2/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Mon, 20 Mar
 2023 19:18:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:18:15 +0000
Date:   Mon, 20 Mar 2023 16:18:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/mlx5: Handling dct common resource
 destruction upon firmware failure
Message-ID: <ZBixdlVsR5dl3J7Y@nvidia.com>
References: <cover.1678973858.git.leon@kernel.org>
 <1a064e9d1b372a73860faf053b3ac12c3315e2cd.1678973858.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a064e9d1b372a73860faf053b3ac12c3315e2cd.1678973858.git.leon@kernel.org>
X-ClientProxiedBy: BLAPR03CA0117.namprd03.prod.outlook.com
 (2603:10b6:208:32a::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5214:EE_
X-MS-Office365-Filtering-Correlation-Id: 2429758f-08d1-4df2-eab5-08db2977dada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xWHN6f5cfhkv4U3rH/qnAyVJO85f2jn7sWaMViEq6jnHN6+b2GNbxl52757xHj43iZMOnmw8aHjt/cYUYyboHsCZCpTo0Wl9ZHQvnnSEq/MsHNFTp9PC3XrN290hmxrwuNDrdQZHkgZVdwDbND4VpmfEQa/HdoZ8KqOrTw9BEJEwsl2Vhq5rhYAWyYqGT5snood5uwQtcf8Fm0Q5hHEdhN70HJPHD9SGJR9S6i8WryO5aZKWiVUWcM4MuAFwhdkb7dplC3nx26aJHS+OBKPKsqNonNrcU/Ep0f5HAmqnI5C6AcN3h5ua8B3X0chPR8hvTzu+Z5uaXsiAgQPYw8Mszu3jhunyxLGLge1Snr2I0ugLlYDGz7PivNpabxgQKIl5Qr39tqh22CAMX6FDdjoFjzWABOTsiXCMcyd+Ys3hcEW3WeU8J2yho1AG8z218vDdw8hXlfONLwR0pm6I/tt85k/F2HppDeI+AbpDyMh0kqQlT3LN+xDnyh2KS4mtvK586opO3bdbX2DeWM8z9V2X88fCcY6qGIT1h3NpCjqjbnuVXFXoF/FwrOyvGcn9uncVfZDHNTJOIHisNN+OVeUZ51KvJWFDiKsFueC/ckp1h0n0PFlDTohRKgg8SUE236hmYzVYNPAIotIos1RH59j5lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199018)(186003)(2616005)(66476007)(6916009)(36756003)(26005)(4326008)(8676002)(66946007)(4744005)(478600001)(6486002)(83380400001)(6506007)(316002)(6512007)(41300700001)(2906002)(38100700002)(54906003)(86362001)(107886003)(8936002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gu5bKxuyQKFkt4ZwqrAI7TxtOrWVScGpMPZvbUtPtnUOKoo5vmWktxu+qqgh?=
 =?us-ascii?Q?mfLiiDTwW5d9v1dSHSBsCLYdEvexg01VwtVsupa24l/KXsyYPkdZcQrLcO1Z?=
 =?us-ascii?Q?Zm7831h7yG9dN5H7zLS8LA03lL8tgE0+doQq7cQqVW9kEEEG93kqMZo7rbJm?=
 =?us-ascii?Q?WWoScqQSs3iEzCkD8/KBFrPLeveukITBzAIBTW/++NPY0Kth97rr6nWa1JaT?=
 =?us-ascii?Q?Od+AvlS7Bj52S/vfiq/MnR9eTW9FaIp+Pn6i12kTps5owNsYvDP2NaJLQ7ir?=
 =?us-ascii?Q?xkecPC44OLRsSL3dxYVBq/KWXmmw/qpqNqioZUfSXRV62eKpBxKjDqoRWtRV?=
 =?us-ascii?Q?MDroY4rxXiW3NIFNTCVYaJ3Kgb/A+DzOnoZ8fK80m69wfoeVQsAUld6lojbi?=
 =?us-ascii?Q?vMXhzGd8wix9Pw/yxgmOnzP6LHHadauVNvHKqp79Vdl3ViberTDKxqEfYvDN?=
 =?us-ascii?Q?hMQGfoaWNDAcH9KS+xz29+o/smhXSEqhYqwt1CLabLPovZIdb+E4vKIPTH0D?=
 =?us-ascii?Q?QgFmMZNLXMMsPVfVuXdfX8IDDXXzeFKDipuwt7DZySXXetjVPTGWv0fIbllH?=
 =?us-ascii?Q?p9w2IATyRJW6e55MVpQ6dNb7t9cegVwtmqe7SeqQtSkGIZSTjdgY3wn5XyXE?=
 =?us-ascii?Q?W8gd6/y8MaEwsTD3xIxTyLJk4pPc86hY2MdO/npEXuMRSgl+38mUxf4GuZn8?=
 =?us-ascii?Q?a6yfWZ3RaW96anJDYxxUcMfZOHGP3C4cr9f6yRLOZerdt/j5JD1Dhnp/94qF?=
 =?us-ascii?Q?oydE9clqaW0V4Y+NdTE7h95GDbgvan+m5Z+R8xKEnRKLtK00kN+gx6UP2p7Q?=
 =?us-ascii?Q?9ehiJ3w08oE2X9wtvzAEng8cKsTRl3znzaGe6Wf5B6rQRc+242ENEDHjAQ3x?=
 =?us-ascii?Q?oAQ45uGIHqIFY7baPQSMw1g/k13IvqccbQ2ulDtiZqx7luGayMw8Je6rilRk?=
 =?us-ascii?Q?cQAbyW9Rsbmal/pRCorlNw6NGVXLQheJeJSmtnR/ob0BSRkeC8tiiggiLa3Q?=
 =?us-ascii?Q?sARH9VLzfDGKDQSjVL5Ci38dtrPJvUEFFG4qTcGJrDrvvbKDW8ooXHg/wDVu?=
 =?us-ascii?Q?KwTxKG1ovibnxn8P6cLRLTkuNe+SjAEM6O988l1vkBN9XixEcv2G4pRVcOdM?=
 =?us-ascii?Q?RbX/qe6fG+AbIMWBMBKh9d6O9XCPWx30iAUIDbWZ7J9V2K4fzaAQaC9kcZw9?=
 =?us-ascii?Q?OQN/2i2v19ZgyP13yR5GPAGQrli9QSavZr1yjMxLKltkXdqKPBn14EKbgubr?=
 =?us-ascii?Q?va8U97tNupXv3FOXfPA5ZSRBdSaCZJKlW600pwn9WoNncb0n7prladdrm5PJ?=
 =?us-ascii?Q?UKFGVqqIWKwKIiCRFOsRGPJOjWng737uvbT7SECaF5iErble3DrvoMzdxCoi?=
 =?us-ascii?Q?Nup0KahTdniUZMpLkSEUhfNss3f8x7V0M1IyObs6NjjIU7jXP0PzOGdBSVy5?=
 =?us-ascii?Q?MowxwIoO+xfn/J7u/N4oDhuBbg5F32CtERn7Kb289wfFU3GbiLqx/tEXklgQ?=
 =?us-ascii?Q?YDA874J1Eif+WNZQJ7c6LaZ4jV8DWS0JVdlX4vvSK0qwr/rRHNHtPSntKLnS?=
 =?us-ascii?Q?meKdh5ZRu4ngmhiQTqJY/QLLm0W4qYefGtiPIrXW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2429758f-08d1-4df2-eab5-08db2977dada
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:18:15.4090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yw53G7IVs8k3njbVFo11T0PdBRXFY4V7y/MRXU475pUT7ZuNFiQllFEZFjOrU258
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 03:39:27PM +0200, Leon Romanovsky wrote:
> From: Patrisious Haddad <phaddad@nvidia.com>
> 
> Previously when destroying a DCT, if the firmware function for the
> destruction failed, the common resource would have been destroyed
> either way, since it was destroyed before the firmware object.
> Which leads to kernel warning "refcount_t: underflow" which indicates
> possible use-after-free.
> Which is triggered when we try to destroy the common resource for the
> second time and execute refcount_dec_and_test(&common->refcount).
> 
> So, currently before destroying the common resource we check its
> refcount and continue with the destruction only if it isn't zero.

This seems super sketchy

If the destruction fails why not set the refcount back to 1?

Jason
