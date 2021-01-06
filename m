Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7A52EB703
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbhAFArS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:47:18 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:52496 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727362AbhAFArR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:47:17 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46]) by mx-outbound19-61.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 06 Jan 2021 00:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MinzF83sbA57sczMTp01HpXvhoQ0PYQqlS3AkM6UhWNmQeEKP9/OZWJ6gmUXeI2AWOUTT/T7x4Y0idhL82grlhW7fuId7jMghO+lm7RPslLOZE9vdFViE3P5/mTOgxAjUkpV5F+OQU0OVHh4XqnLasdoCXsxhRW+dyMK8dHzPo04buVCNtxj/GXqj66o0Gza57vBwIbK/Uu4prvJgdrX9eUY/fa2JND0Dl4981djMN5xiF0nDdOlc6aJWOTwWWupD48LZA7l2EsiKzA4YLyp5W2JQX0gDdp5kA1LiFSsFSTBdDRKIegcuazOrNvb1v3POTinQIolMy3KRbx9UJ7kaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqo1dE9QdBJUvSMtrejOQ0puwTtgybX0HX579OfuaMk=;
 b=GRftUbbQivGE1JxTCUTgGfF1L94HgBDyWt14eNX4ZCQ0cnPsYCuSjblu0s8wRIivS9x5dpzTcrMqyaImtL5PNwQWIxVwPwP4m+1EGWBF5tfPAJbP8cMGDs+N4X5BwKs+XfS0Hal5axgt6VmFl5HvKqIGxJMEb3XmrAJ0ZyjMl5LmlPd3WBHwi1LH4kLdK4HaQQ4ZF9A6+McV3KQXS90VrrmB2BsLt4gArzaNbkwuI8/4u/11TPz2Otbl9WhaMvZ9SQN0MOhjxKhARVxi39VW3nOGc396vM5iq/5XLppUbLdKac6MaVZlLACm76sFTPQMUKjXb5QD+z6DaHJHnOn3HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqo1dE9QdBJUvSMtrejOQ0puwTtgybX0HX579OfuaMk=;
 b=Ijy7ORJPH0IPV5kzF3MIy1m6KUwyCm0BEtarv5n9Up7QbjgdGHEjk3/LYEjOvmXu/9nRM/b69b+4oXjnH0iyQKwpzpR8IPqpKbaR29ZOM6nOFyubM1b09LNreB/LgpydjexFeDNW5nF6n0z1GwrxXt6MZzkW0C9mCOYn8JOt1mM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 00:46:12 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 00:46:12 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v12 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x  family of Marvell
Date:   Wed,  6 Jan 2021 10:45:30 +1000
Message-Id: <20210106004530.22197-1-pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105131343.4d0fff05@nic.cz>
References: <20210105131343.4d0fff05@nic.cz>
Content-Type: text/plain
X-Originating-IP: [60.240.77.49]
X-ClientProxiedBy: SYYP282CA0013.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::23) To PH0PR10MB4693.namprd10.prod.outlook.com
 (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.240.77.49) by SYYP282CA0013.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:b4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 00:46:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce016289-c745-41e5-bba8-08d8b1dc7725
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711EC0D4DC1D730AD366AD595D00@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkT1d7jvUlexfuC5OwBxK8min7V9OKpEHjUHTUvlgEM01NucRFXcKHXsfDUEElH8i239Dd1ok+vLsBS6O7nHnFNR+DCbZcYMipFMFglh8vxSWy5JmCnSW6wxgZVx7TRGhv0+ueD+iNuSwOuLRhigGx2+ITFr6S6AXgoqZCsdtWKkZov2K9vfTIDZ3WT05KtHVAxwWGnVvB6PN2Jxbmw/4Tnb5kmz8Ql1ZTWYVcyWO6m3THhx/L+ngaGXufWlYKR751OpdHMeVg4sofLnhv9/IRIxZge2VOruO7v+uO2pcSbNfE+3E/Idjgjl3u25s2dD5EYp4RWMvoMoH13rsGn16LLa8E891sHFGHeLjc22IO4eOuHTii4DIKY9mCuiPoeV2AmvjRS/LMCjGQ8/0goUCKcyA91rr2ovmTDAdD9P9sP5wWqU5uXrBQiNQIbRI1eF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(316002)(52116002)(44832011)(2906002)(83380400001)(6666004)(66556008)(558084003)(956004)(16526019)(478600001)(2616005)(26005)(186003)(36756003)(7416002)(6916009)(4326008)(8676002)(4270600006)(86362001)(1076003)(69590400011)(6486002)(6512007)(66476007)(6506007)(8936002)(5660300002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Or1DF8ZNVxpCfWZRs9ruPq8DKMByQ81Zcef1D8/PZ0m26M+fe5XylfJp+Z39?=
 =?us-ascii?Q?eWwxT2LJ5NuJzr0c3O62AoTXTXt7+9zHYlpn2cCB6FG7oHSd0Da2pGXZrHO/?=
 =?us-ascii?Q?cuyO3ZjFgU6J8LzOCsaaKNaQOvqmcvBPCz/fICwha5irLEA3Mk6vZCVeS+yX?=
 =?us-ascii?Q?ewtY0k9uShC6i5BndPRxCRWqSBj3piCIlgDA0EpzB6JxHjaC86nH6WXqdKi5?=
 =?us-ascii?Q?CYSN9ENTQtQk9XDQa2QHWDN8nNQUFtmFZjweO2ghucCDbYTRrwr9jfDBxHPQ?=
 =?us-ascii?Q?/IE0wYpkjxMX2BVcOGMB2EbKoc3WlwLseagRM/75O2OlAPACFg/viKBHbyg1?=
 =?us-ascii?Q?Q+32IOwuUZEsWk1wCVJr0s7yz3euWVvXYw6wPYaQ8VLBS5mR1QG9ebWfOWy0?=
 =?us-ascii?Q?zp/uJzAi/FsHeMb7wsGyjgDP55VoINyJt6wL0bav9foXgFFreldEnois4aJB?=
 =?us-ascii?Q?/NYyMIrN0MCcs7sqqGweqwn4YrXb6F+DSGLjLo/LDEFSzhxNMCGJJ7LTqGXn?=
 =?us-ascii?Q?PA7vzvj4bTRCPkBUCLsZRNHoo6F3qveT/25ID70/Y8HBgw1ntuUyKpO65f50?=
 =?us-ascii?Q?7nGyMJupl0BLP961HfAcy0BdPb3cSVkShjY7/MqwtIsxyxjC9m/wV8OhYZH9?=
 =?us-ascii?Q?f61VbhS+pdAcKuyTtwrUirDsTUbM0eM/1VURYTUajllQD+MIa0zfDTeO/ROy?=
 =?us-ascii?Q?oa7/yibAYSIEcYl4gz1cydyQGfLqFhJ9d2U1eRV8zZlrEgZzCKNXIvmZrj4u?=
 =?us-ascii?Q?lPB9mS5Z2jLkLtkdIuNj65TK96ndZnjQ8+bA1ikvprwU64x0tG9qmIN3dvOF?=
 =?us-ascii?Q?sU+TeBMpvYvE1FvZN7Vlmx9y3c6HHFoIj77BX6DXaqh6JoZT3kTjlrRA/ksj?=
 =?us-ascii?Q?qev9rr3ZeaxPnJP6vmsQbs1HLHBmULIdrdkCplnJmHiZHHv1w2JW3nmFAJkB?=
 =?us-ascii?Q?7V2J71KRMOWZHuFT4jeFP7rVE+TduIVaVSEqjQR+t48=3D?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 00:46:12.2051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: ce016289-c745-41e5-bba8-08d8b1dc7725
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGoDheddPOvz4mk1USoLysXt6w/pND1Q73/yVHG3gvLVXNBdM+4XZKsGTFnt3Fs2WksnBAdFgA7g/ZYIF//zvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-BESS-ID: 1609893973-104925-3140-47110-1
X-BESS-VER: 2019.1_20210105.1842
X-BESS-Apparent-Source-IP: 104.47.73.46
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229342 [from 
        cloudscan22-130.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Marek for catching this.

I will have a closer look and update the patchset.
