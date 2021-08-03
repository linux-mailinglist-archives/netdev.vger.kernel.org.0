Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5E13DE9D6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhHCJl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:41:27 -0400
Received: from mail-bn8nam11on2115.outbound.protection.outlook.com ([40.107.236.115]:33888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235168AbhHCJlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 05:41:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTIr5wEAVlNZTOmXKUL3xLp4jcAUm/SZMQO4tskPKRakwi8FhcFw+CBgraYKLGWqPO16XVzQMY7zdMvRZ/i/9Di/AbQZPDY3hlgAaOC5m+4LTXhEJ0dExQPn3aVRtkCVzIHm6eCfrLbnOdSpWBFHy2v1lfLMiHwE/HbFVTwd8/PgOCcCoWvyk2uZUNa56QZ44PBGK/Bin7oMME6dQp4LMdJaXKEpgk/bdlnB+Z7ErxKyBt9qK6yOS9IIwyQshUmfMXfi9eBzlBWKF7AN3qZMQPKW8t+xx64la/9kHucxHXwW5v41YZFyt3zjfRMfAXVVpJOxA5tIsnQtg31DDHMG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHNspiNFbIUrCP9KxK4VLEdFNqFOLk4L9xPAetEHTZ0=;
 b=d3qYua80gB/D43C4lwBrqKM3oJioDuDVOgSIOClN/Z+iAPHOvIYAg8lum4jXWF0Vb5VqnBOCceKjcTbkKY4OhLc4EUcH9vferN/h7/DGUyRzpzZEhxbvD/bDg0ZqQtuJ2Kp30jDxx+p4mKwXDQ6MPVxpUXa7xz1pYE2sUZYqaHpG2s3IqxhacdK/SKBLlzxcYa69ldifuqcpp8X9DGWTydlUF3wbKApor5dONIZLB4IbsY8iBwm7OYKv1kIMkvhCid6DdVwNNAQNDzPM/0bp/jPazWNyJg4VTHRgM+dqjFQJqF4LmNtXRLJUuMZyUTaW1qQYxbRI9FirjULZOpBEiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHNspiNFbIUrCP9KxK4VLEdFNqFOLk4L9xPAetEHTZ0=;
 b=dIvXoWChIYvaL4IIA8XnH4UfC5WYRvHQsdHCQi4MihXUKwA6/ecqh96Us29jGBfvC7KdeAnY2IFlvWCjQdMaKPUg53G43TMKghLfS9lRmw9qfp5NOY3orUaeAQW7xIdk1iVCqCIBpMBwwt23R4BubdedOhcqA3J5NQHoD7SDlcE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4988.namprd13.prod.outlook.com (2603:10b6:510:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6; Tue, 3 Aug
 2021 09:40:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 09:40:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bijie Xu <bijie.xu@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/2] net: minor kdoc fixes
Date:   Tue,  3 Aug 2021 11:40:17 +0200
Message-Id: <20210803094019.17291-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0009.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR08CA0009.eurprd08.prod.outlook.com (2603:10a6:208:d2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 09:40:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9736474-7c17-4c80-8a0a-08d95662beae
X-MS-TrafficTypeDiagnostic: PH0PR13MB4988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4988E2B5E978FCCCE033880DE8F09@PH0PR13MB4988.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mx0rrqV71VuClwdMVEiPWOnEDG0BsR1Kn4mTFablKTo8taM5S0pVmH0O7X7foQcmEkUFje+wZza24Te4LjyPbYFpX7fHL2gCiPfBBaJTr9srivzFrUeWvW5S8w5HVm5w8Aa0+6c15s0KbfsiEdStpqlh7p8qWualAXj3c1Ti2UvJOF9EH7y3UfWF3lfzLu7bjRsAiaTUWzZ9WYTGWnKI0W8p7+dt/e0Pi75RoEUrHJpvCHYJM6TqzLBSLRykiGqtJy3cC4FlkJS40djSqt9POk1+CgrTOkQvpLIbYkkN2r9iwEOfw8gEgpcVzUIL7jP1jETmYxkg/B2jwVROOGpQDrMLj+e6f8758OGNE7BV1YrRzfMGTkm1fwGhRubhNqzu3OAIeJMbjCd+cFBd/kAuOGlT+LnqSldXqhl2kIVJ6WrOIZwvwPiYmiAtJzkdgPC87Z7d8uYn5lXqFtTz1mBME9atvzPsdc7kpTEGWcgXQx0pb4sHyWBlkOfz6XQXwTmG+hz2QIpUepIRGBAPWNnsaE1UVo4SME9cCwTzyZpIQ2ieh8Gk0BtO39BL1QerlKxteyDLlsPdH3Am/+yfTh54Q3Cts98/88EpUHUW9YjAlYFgSAxISoy7Zdh90g/irmukEDF6WOhI19NK3N9Lhzf7TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(366004)(346002)(396003)(136003)(110136005)(2616005)(86362001)(2906002)(316002)(8936002)(6666004)(6506007)(4326008)(44832011)(54906003)(52116002)(83380400001)(107886003)(508600001)(8676002)(66476007)(38100700002)(1076003)(66946007)(6512007)(6486002)(5660300002)(36756003)(4744005)(186003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dU3UcXTzzZ3/JPxT2s7QgcBC4ljclQQoH/ReS8+UdHF5j/TOE+iucPvNerIP?=
 =?us-ascii?Q?6CAa/Uu9/53cVz4zDdonfVSLNhqVCmFUGiDZMTo3GDSbtL7GUpjeoX+Q2sdG?=
 =?us-ascii?Q?tlkl/t1tWO+Z9iSP2LphSAiCSAZZWl1ecvbHUpZ4rkwVW6WvabybYRkh0OWC?=
 =?us-ascii?Q?65vSMQeSiw8WD7++Afi3hHwGSVMTJsMbUwRyqS8HfGn6QknX4dRN5BFZ9bQy?=
 =?us-ascii?Q?cpg3ZaNtHfYaD7mZcUxbatSg5iq46EIBt3zh61EAoEQizcAtr3Y7YDnF5ERk?=
 =?us-ascii?Q?DmmJib76RvnxPOl4RDiLTDzTu9Gq15adIp/8vHA4cfeg5UcG2GIQ6vndpe96?=
 =?us-ascii?Q?vTZtsDpN1LyFqIs5LRqC/iRpSC6d3SrXVD/IQqCfL0zsV1yR0cSq945wrw7+?=
 =?us-ascii?Q?J52GLtidMxKCQ4Fjm0QjDUYkhDQ7CF4b87Cg6TZoH8YQJ/nvxAEFAQGpsa0V?=
 =?us-ascii?Q?CFmY3Wbc8lcLUXwXLvX4JcKIrBViN7HlEeBCQ9DjEj81dk9LaLSGozHbxPv4?=
 =?us-ascii?Q?Vx04dGjlKsKmBDKVZZcddJ3tnmt7zYhmQKCgdpsTgtCFOFYIi2zPyfQJJ9vV?=
 =?us-ascii?Q?uUJZ4sPXXtnl8cR4rWS6gdCxm9RoHXpB8bAEihSPMb7uRm4SB//oloKk7oXC?=
 =?us-ascii?Q?3yChoLKSGy+EqPxrxMdC/5cpWjdJSSIsnrWHksa/Z3hviZdfnsAdMoD1fL4j?=
 =?us-ascii?Q?E2CeHEpJcYyiKLNAzn6A7QyMQl7HmdM0XG9myrN2hFoiLTYIGi6xJzUOP6It?=
 =?us-ascii?Q?xC7IT4zuFJXrtwtDPdsVML/2PtnqS3pn2VgmfZazdN/OrJJiCdk9MhqK2tNL?=
 =?us-ascii?Q?jsRNZzLkPAwKNGsn8c9OVG+fIrd7YUDSSRgl3ITLHkbk+gwooAluYKN/+b8n?=
 =?us-ascii?Q?TJ3jXg8qG0CsEOEzFm9VzNp/A1jjqSEXySfIFGwbtyIa7gPe4MQbSucGJazQ?=
 =?us-ascii?Q?CChmtEmRvACrMvvEXg9x21jd8LOEH3rV1eucJudrIM+PfdquXVsb9zhGjBn/?=
 =?us-ascii?Q?PGg/P2zQBrld1Oah6jwY5wY6OCLTyOkNrLOif9mRngBelhDlVPbd+RF7eP62?=
 =?us-ascii?Q?rLa5E3oeWSY+72oyIzWifJf4wbv0rvwL8PpU+o7FWEbFwuh/10ZF/ovszEui?=
 =?us-ascii?Q?iFPKQ1y4UZl//Uz21dflDc82LSn8uLzKS6HLkOidRaw6qIhFLUMSgjn/cHc8?=
 =?us-ascii?Q?VAH9y+coFPN0t3itguZ7kmBIXdTgW/GgI3CdTRFAS03NM/RZn1FjiHG4lhwg?=
 =?us-ascii?Q?RuPoieEJiBmWD9n2vZsByFQ56h89UCVqajqHFxJhle2KnSCwzEdUqnQoRAXg?=
 =?us-ascii?Q?JVPiVUApoa097xg1vMuxDDge7li7VxtLd93NoWz68fd9zasXMrUP+xZU+3lE?=
 =?us-ascii?Q?WmeIwZFrawrSVfSpvB0mOeaU9e7r?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9736474-7c17-4c80-8a0a-08d95662beae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 09:40:35.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPDAJdWxL6PexYBNJ9i0CjShRhrpJC7AF/+MrvUJ1zwmIM8RnWufstKTWCw65yiTmnMcj1jmaxowmBRRQlzSPoGtB/Ff37Wq6k+l0ik0V7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series fixes two kdoc errors that were noticed
during development.

Bijie Xu (2):
  net: flow_offload: correct comments mismatch with code
  net: sched: provide missing kdoc for tcf_pkt_info and tcf_ematch_ops

 include/net/flow_offload.h | 2 +-
 include/net/pkt_cls.h      | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.20.1

