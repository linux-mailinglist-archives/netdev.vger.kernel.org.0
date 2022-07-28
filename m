Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C81583DF0
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiG1LqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbiG1LqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:46:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5114C10FD8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:46:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IE3T7/JWbiQfvO2OAhEAMbCs0/tgFnXdvsqMcdlj9KQU2b/Wj94foAWGT0jXlez0w6kmb+gsYPS98IDtqQIq/dZGIvWtEw5DMH1g98qSU+cQH/mpyEkQPcVPOid0fbNO0kegiDi8URIbnZ/3FXVN8I0myEciftaqAg097hkFmK6/XsXOlzsaHGXFs/GB6wcTO0QfSZumwVAeRs57NeoLIPnukeO2Yah17KIQf5egBaaASbidsh0A5+5P8iiJMcT/lzsrBcdUOs0gcuUkcX0AfRwyyzJrNRXNgeqYrlef7GkwVwCTjegjfJqHKMdhh3woCQFKKNrq6jBOuiZYXerk4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xov5VpTCc/WAoL+JPcLlDW+TPQ5zXyPhxzKPYH5JzBk=;
 b=aas/kP2dlCqC585T3X8l0m9YUkfhgcuC+FMjKVjh8LGrAOg9aLF3vwUvKyBvqrgXZz8ml46W68RD/qkhLqSwZ4pbWzCa/yJHHn7lQPM+3PQf9MOGRI32IIm7aCIdb2qRPSl29ha1VTWIze5U3wTwGRcY7fo+ti62hRf6wDAuaTNt8vLYEzEHVHMc8nmAAOQu13MFim9WXFSQ2LzG8MLMMUOQJhB8hw3qlMHagP6eS+6anJumKvmftuKwFiM7jzEa9T6VL3Nlka3mK7Ugm7OJthaAoKEvNvvnAOUcv/yWf0K6uEPjSnOeBXGc0iJle3D2mU1HqcH6o31N4VTvnPRWGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xov5VpTCc/WAoL+JPcLlDW+TPQ5zXyPhxzKPYH5JzBk=;
 b=YkeSJf1DAOzoyOaGQipsHjod0dk0ndRlk7i7bgSI35wUsMW++/qpDFdXD44eCvXtLPI1oOGoxFS4bF+gqFzp+Sfx2haWtcTlR+UeeOes+c8BRjrwDrM5NLY827J/4TuTOiT+jYZctjPnPJ3AfboZShLCeSTnf+MMeHILU22BO74b9xehQPrl/CaEJYoqCvHXlCtLX9/eA7YPcduioecjxj7YOyz4O7YscIRfRxLN1T3ho2aNVWO9cHFJ1JrsEBR2mgZSP4MD8rp/RL5LGKPmjOF0i8HjBmnRr6bhzFkbjn4/3BYoW1ZA82/gUYqd9RcvlOWEwTEvW0FRcivRpGohtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 11:46:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 11:46:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com, dsahern@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/3] netdevsim: fib: Fix reference count leak on route deletion failure
Date:   Thu, 28 Jul 2022 14:45:32 +0300
Message-Id: <20220728114535.3318119-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0046.eurprd05.prod.outlook.com
 (2603:10a6:800:60::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f7ac336-b534-4dea-5c20-08da708ebff9
X-MS-TrafficTypeDiagnostic: MW3PR12MB4505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4WeVUTwwarbU3Kxl71pkBNhw4HdRTw9K78r/xu1irc5FohV/1Rpq3IPwXjX52Q0W8A/HF1XEVfhA9t9C4yLPtW+GZ2wthqE9L7IdWnd9a7D4pbZDreTxDc1C4+4q0EjlgRoPcOP4XQHKW42xK3KblmS8QAt+WZtw5Q2JBh+Fb3OP2QscntHn3DEQwpa+IDGlIDlf0dgUz+MIKppsWvGvxpJpNMvitZg7Oj0mXKJTBDmSni928Tzr6Pzmf85D6owhhT40cVroKrgkWrylXGBb7jH0/Lti2S+HjnaX1hkyvpJGscYf8oGVoKhO4XBu3Ls4KACsbjKJJLi06emZSSLuSEfpunKnH+N4Koiw+IvrgjFVg1OwY+iEw2eUsmBLwh8v/Mk+MVHLepKYDFNDu65qdayUbktqlgzY+6z3wKDcgjITEO31fpcop8ibE62K4TIi+I8hy0w4uhCpmTHKXWFBkebWMvyOBw7L5Mx1Is2dmSQ6RvxOI+RZ4CGi6WByK1jia2YrSriJ7bXbCC5Rh16nhKzgehQRZ1SX+KSF6aCJgOu4RgnxeosLLlv+q6Y354n6Qor3YlTnIkabdsTmjdmnGfqqisndRHCTEG3yPPrx8PDXK2DTjj6WHy3qLy/r7ENQjSgljxKTJvDeeV5O9+izTTdmG+ci2FGKJMJFRKjs29xMenKaBT1zXe37ZlzSB4l2m0ao7Pv9XHK0vDGFe3InJpTQptRvq4hzmPvBe3o/m/RROBxmEsmgGItK6R04LP4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(6512007)(41300700001)(4744005)(186003)(83380400001)(6506007)(6666004)(8936002)(2906002)(66476007)(478600001)(6486002)(38100700002)(6916009)(5660300002)(107886003)(36756003)(4326008)(316002)(1076003)(26005)(86362001)(66946007)(8676002)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8xBjJFQ6PTbkGqF3dhzW5zX0TE1GjHuxRqgrmzK82/6h/nyAZYyqBXpCE9af?=
 =?us-ascii?Q?2U7gJfgSErer3SJPzLTiwK2oLhVKVwrxtOrSUTJlQh5M616XNxnzvs4WBPQb?=
 =?us-ascii?Q?8oiQ8A6HGpku3FUNlSlsmCqKjgw4ZG4sPoPiJeNutY/w8Ae3QECg1DsJUV5E?=
 =?us-ascii?Q?mnyZ9Fya7ZT7DP8CXkBR6cX1c4/4/xbAxdD0f9d0FAwfBlgGgYRTB0lfQE4K?=
 =?us-ascii?Q?u6vbqInUi+JstmZ0jpqx3JLqfcWKU76C3vyrC6ER6RPpFQDSUeQBEOOThZED?=
 =?us-ascii?Q?BBqPY1AtFz5QA94b0SsAvlsCrkUnHk3qDei0HbknKgyagYckRGn0NTu7+RfN?=
 =?us-ascii?Q?7YukTLztQic5oF8lCJbG9k1/E6rzuNXrELGpoA+LjzAkGM/l4zvoUni8fSaY?=
 =?us-ascii?Q?ADtzHSVbZft6uZxavFNgYvVj8nEHxM8zPexAauLTYm1+0K8k2vyT68Gcuw1K?=
 =?us-ascii?Q?wk8Pgp14LTg50BgZrNMgkNcfM/4FkNvbGCJTDE2MIfh9Xf3Da4ZxyQND9Dgc?=
 =?us-ascii?Q?Dfbs1wSaDRCOW2pUjbLWdH08+nSV6SVpyu0VXfBsqT5ZahoRNHTlJfm9dy+Y?=
 =?us-ascii?Q?FL3hojWbbVvMqOct7E40mYLSsnFrTBahsh8bBln7R7AtUnyy1hhABeBx69Jr?=
 =?us-ascii?Q?c/Cox9k3O3TPHj+oNcxRP5Uf2UKZauRxY/f8Gto8JYYuzjuKVos6+JNFNmx6?=
 =?us-ascii?Q?bLS8vlfsq4Tcnp2q1+URzfvKzuQIXLyMWWMxmLESCpLqHJJ4rgKT/ssn6+am?=
 =?us-ascii?Q?Ce7d8IEQLZp3uqLC4Jjm0WzmCpsALsAtz4Er1JULTRVBTE/Vet7HLQfzQKNx?=
 =?us-ascii?Q?wP0D3V7M1Egfv+ElHVYwgucVtgfdfH/DDiDlaRsUL9I8SbZziRzn5wqUFeK8?=
 =?us-ascii?Q?LVQ05HWrDYs+oXsZm8m2KHOcczW+cDU/ajMLfJjOzRElDTee5Agzxgpg/EwN?=
 =?us-ascii?Q?bZdZS/BwgYOjOKkUOO33mj6zsbk5lS/rOZxXx9LcUtkBqYE3QXyEIE/70bs3?=
 =?us-ascii?Q?T6PTAmLPYziOl2RNSQZpMfRfsvxtj6tr9p8chMQ4dofj6xn/d7nT4hylXgQC?=
 =?us-ascii?Q?qpI800Rkbznkne7BMW34eLPWsu6kTsHTvOBSP7qyedB564m9kMprpZwQNJ+O?=
 =?us-ascii?Q?5HrhkVLwI3JtR+HE0ShH7+F37SYJPqP3pA0g1DWu0WROKSyJGGsQGjXnSL/E?=
 =?us-ascii?Q?kG4iLfQXE87DS6tbdmC+NxvngICjdwGxKu6Y3FdRTWDAeb8C16xqmKTbdYI2?=
 =?us-ascii?Q?HWWIoPNCktCEvW/isqvCIin+7xPRAUUPQ6/KHQAJjwaPJ5Bg6lIJSdHl4IR2?=
 =?us-ascii?Q?YrT+almeEWL2MD+sbKKPq4p0o9Ym7W9zRZtWN2UQsBwVJ9gqKd+e8t8o41kg?=
 =?us-ascii?Q?JTOQ/mT9M8bhD0sZNSRmWGVK8+j/PwHv4MITDjs3lsxC91VxZpcIylUGVblH?=
 =?us-ascii?Q?6lPSiO/1w/NivvXolijWFn2BtR9DIAsT9k5soHmZmS7VfUJhqB6vxenNFMFY?=
 =?us-ascii?Q?6md4Ny0G0uYfuUtgRIDDGzCpLmy8aH8OWUcLiJ+kGSjo2lsdLxUbg4wwso3r?=
 =?us-ascii?Q?BOt35MVwxsOIn4PStzPCITND1Z3lOR9x0/A2BDUG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7ac336-b534-4dea-5c20-08da708ebff9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 11:46:03.6053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKLlFHOHtf1bSFdJf0U815VkcimJacHhozn5qsZX5Tbb8LFuzKaQO6siqmBDdFawt/FpHUWJwaEtjpFRil3JdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a recently reported netdevsim bug found using syzkaller.

Patch #1 fixes the bug.

Patch #2 adds a debugfs knob to allow us to test the fix.

Patch #3 adds test cases.

Ido Schimmel (3):
  netdevsim: fib: Fix reference count leak on route deletion failure
  netdevsim: fib: Add debugfs knob to simulate route deletion failure
  selftests: netdevsim: Add test cases for route deletion failure

 drivers/net/netdevsim/fib.c                   | 41 ++++++++++++++++-
 .../selftests/drivers/net/netdevsim/fib.sh    | 45 +++++++++++++++++++
 2 files changed, 85 insertions(+), 1 deletion(-)

-- 
2.36.1

