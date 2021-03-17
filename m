Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069DD33F054
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCQM1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:27:39 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:5216
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhCQM1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:27:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cc5LpPyzEBkBZfubjWGGjzF6m6rUOPJ8G05IIB4tiRuNFyPEyzr6fiUlb6h3cAZN7PBmRncJQzxMXnEB1QaCGjNZlhycw1SKH3Z6u4G6INq+aCMWZFrFdIzjYowEbcRxS9r6dVrb5E0cmhFjaa5bmEXHRGcUtDLhPeubMeRNbmnLvXqHL6VVRcredJQWPa/X8TlQXDYXEvRpDl2Jd9qsuDxCpwLmBcyu1prXV1CWDo5Ftxzmhm9MmWw+IcaGcEnx6KjNCGDtYuQXmbtZgLPjf7sDr7G5jcPL5SoG8dvopX3ZpqIr8k0KkKj9D0sYju4VAq6UeYgMTmzNGqNJK64GMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0jGspLqgg/40FFEdUp7QgvAtH8st8AykayhuMpIWbU=;
 b=iY2mo9/hDDuHHhPtR98Gk163/2XXxQz7wsVt27I6mkjrDL9UdgYp2InI1F5uSso6sbOAJ8loorICWtF7HOvTJfbTLFroo4ejETSw+k8r/PT4Bcs2Aek4ugNiqp41TM6gqCxdy+Huj0GV6Cm9f4BdWu01KQBVu6wzWIjFmcZO0/hsWH+BjpdwbTYmhCGlcv0oBqBDqRTgzy34ckfFD8Gdygv4JF80FL3IME5OCWMjkGUad+KxzJcYv5SDUxgtHoLfgimaWT8CTYElLgy0e3xfCRY7ZI0HxT24xGJ0XQ7LtfDAwLuc1akRa7FdePD8sE/ZLSljIa/SLFNVq8dzvl4izA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0jGspLqgg/40FFEdUp7QgvAtH8st8AykayhuMpIWbU=;
 b=mJZbFBrdtDoluoh4Mnuqyrk7A8KzXP5kulBUqMa3Wc1bn+VSCgqiEM02qOLCWpxEbKN37UN6LWI+Q4Yie2200FzoGl1f5cCNVzIsHVvBelSeELk2dNhNq3imkzeq2uuKV77K38DD4tmESek5rym/SF1BfOr6srNf4CVkkvJ7pvKj4ulvMOivpU7vQl0u5/gSMxf9KfOTTYOdR3bTyNL+2o+yTkIOfc3n65/oq+33DvJC8T/ljzra1LfFJBWBhkdEUATLtYFFS8E3Jt++s0RpjpFb2m+lqkuIvP68TUxxhtIo9NyNI5OFMl1u7ROXLQiqM4ClYucf62Ky0ASaelUmjg==
Received: from MWHPR2201CA0059.namprd22.prod.outlook.com
 (2603:10b6:301:16::33) by DM6PR12MB2747.namprd12.prod.outlook.com
 (2603:10b6:5:4a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Wed, 17 Mar
 2021 12:27:35 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::70) by MWHPR2201CA0059.outlook.office365.com
 (2603:10b6:301:16::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:27:35 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar 2021 12:27:32
 +0000
References: <cover.1615889875.git.petrm@nvidia.com>
 <ef15d0e8dc8b58f93537116dd2a43f7d188a8fb6.1615889875.git.petrm@nvidia.com>
 <20210316095921.175fac07@hermes.local>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next v3 2/6] json_print: Add print_tv()
In-Reply-To: <20210316095921.175fac07@hermes.local>
Date:   Wed, 17 Mar 2021 13:27:28 +0100
Message-ID: <87blbige33.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66452bf8-e785-476d-0753-08d8e9400b8c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2747:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2747966FE14B75902589D456D66A9@DM6PR12MB2747.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxfYA6BgCLjs4KUPMlantLf/Vb99ksZodx5G57m/Ahku8yL9iquGj7XuYbsf6jpej7gzoWGzGFfFUufU9cwZB/EzEAXzt9sCnsckpKmkUC9ftLv3fIfajjBKCD+NGGlDgoMi4RyTeAOS14dvDNjX5Se4l+lf2ysUBWNsoWBg0CAlHN7wuiBLVbPzRaF27WBbn38HwpoWkvrqhcaGBDdCHkDKi7e0/i7q8wzM11dLU69IDuYY9ZasVxOh2S37/HfwP609R/fXG+Bf13DGyHoRt38O3k8AYp3CQOQuXAQYCw44wKh3RNkw8aaJ83n+Q7TLC6g6V5+Xo2l5Dh4hXfi+MjyBl/7EL1VpIqeISpcyb3Tk1oDnvkGKe6tq9XXeDQh6LH8zQAtA9UngSxFVc5mNKGNvTBCy1SUQKjj+jz17YWXnOXL3VE0qcrruPPfZG9eivETNdfJnqnv7KC9wbnlcBnEq94INQHL4ICOGuRyWdqFZSlAwH5QTZiBJrp9KAxfl3YqhPDBh8WsDQXvnEYfE8C7ypl28Ivc5qkA4bac9d4yzbiQh3WNuKXp6n/6UZxjhuD8RIUYEPY6RK2nPuGvk2ZWJOM019TtvOj/IQKDKvFB0weC8GtWWPu9tnk4Wj29wwOu7fb8QjcD/fHnBa0hw2t4XDRHnRdHP6rn1QzZNq34z1vusz6OvZg2I5batkTal
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(36906005)(36756003)(107886003)(4326008)(47076005)(34020700004)(5660300002)(356005)(2906002)(82740400003)(86362001)(336012)(36860700001)(316002)(70586007)(6666004)(8936002)(426003)(82310400003)(186003)(6916009)(478600001)(16526019)(26005)(7636003)(70206006)(8676002)(558084003)(54906003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:27:35.2081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66452bf8-e785-476d-0753-08d8e9400b8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2747
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

>> +_PRINT_FUNC(tv, struct timeval *)
>
> This 
>
> Make it const please?

OK
