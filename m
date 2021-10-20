Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4943943470C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhJTIif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:38:35 -0400
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:34788
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229603AbhJTIif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:38:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPxuKDwgBoxH6tn7lW0G2MBw++RDDtIM3fXApDtIiKMxD+bf/ZyVFXhKwQDCg08hRfozUdMDsDoTPNlzj25TW31d8/Km44aBB+KCjE0ASs+GGWiH/pammk+ZcLrKDmHaxMJZTwo7ZdWkZA+ERiNTVR3j6A7jPnDqH/HRYSRE5geqslryA0UANGmQRbDg7IrZEkdJhI3jbSvyh3ar5aagRW7rnrCs1l0tKGZ4+uxKQQcK/EQKK3Nu1NP202tRrn8Q7t3zQ59kd1rMouPYxogR66PSSykI79aR3+IhY7G7CbI33nupT04HCdFemjk8BGXBPCU9YVRYH83QV2WKdeu2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnnKn++Eqepzza7UpTlqmqrdQZ/mrzLSrC0KCKg9WLg=;
 b=YONzRghtFWrwHIYkBKYkw+Re7i0FHdNISRCuCxyX7xmAej1XSnbT5TKG+mOwgFb8z0O5ZdPBbWUUK9XVZXzkxt1xOmHnNKCnas3b1aiew/GNH9rkOP8cBnOLGbMx2ND8M4qPiBeVUOghBPBvWAHHDbaScSsrj67Rd+IuWktt7CSq4Ix1/4Rm7QAMtldQXDEOQAVambQgPr/NY4TKcw2uLEd6hF4w1gl/AcwRp/uOCoLDEkGsCOl9o/Td00JfPxxfSG3oFOhTiIxXULocreK/f0k0vDX4LD7XP9mmb7FiAHzoYBCg3xoSCtsLTIRhwEuCK+iYN/XSXCh3AickH0cplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnnKn++Eqepzza7UpTlqmqrdQZ/mrzLSrC0KCKg9WLg=;
 b=q+1vsCGY2FrzeRS6oZnLvdE8SflS+2iwB9iICMj1jzNGdoWAuLBTfIG1z/ekPYZ1p7SrIiXzayIenOc9IBqoVb516pXASU+g6XQETlnY6c0E0Tp4cKAjblsAwKT2hOuBmV5JV4pMhyZitVP5Jz4boyiKxPtOViv3sTZARzUgsR6c0OoBXi/jh/UDA3hAKy1Y8GzOlV3CtHX6Ka3/HCXE+sHmuSR6SEqqGqpqXOUu1Pwm1m4Zdmanl+v8CYG4HqqB6LOdv2zSRlgsaynFJUYlOPqbDHRm14AORffl9CNzM0MzTK2jPzj7eT6yxBa63DZJEXw8HyLzg6nZxx42N70Eqg==
Received: from BN7PR02CA0014.namprd02.prod.outlook.com (2603:10b6:408:20::27)
 by BN8PR12MB3425.namprd12.prod.outlook.com (2603:10b6:408:61::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 08:36:20 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::f1) by BN7PR02CA0014.outlook.office365.com
 (2603:10b6:408:20::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Wed, 20 Oct 2021 08:36:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 08:36:19 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Wed, 20 Oct 2021 08:36:16 +0000
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-2-eric.dumazet@gmail.com>
 <ygnhzgr49mmy.fsf@nvidia.com>
 <20211020081143.2xu3n6qjqh4zloa4@linutronix.de>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in
 qdisc_run_begin()
In-Reply-To: <20211020081143.2xu3n6qjqh4zloa4@linutronix.de>
Date:   Wed, 20 Oct 2021 11:36:14 +0300
Message-ID: <ygnhwnm89jpd.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c4131a1-85b4-4b37-b19d-08d993a4b0e7
X-MS-TrafficTypeDiagnostic: BN8PR12MB3425:
X-Microsoft-Antispam-PRVS: <BN8PR12MB34250F53B2B96A6CC5E952DEA0BE9@BN8PR12MB3425.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: veuR2vZmYiM0ltTayeVuAT5fNGtGHEmrGaNTvIB+sz5tTU6iImCw2T4rXQZz6YgJhFcsdRk7rYdkhU1a1zC+N9Gp/5fT1eIu1QhIEDVSVpKc5b4OXMg0f1i7dLAGV3QeDXPRBaKpTlQbIYl5+DU7J29ltsFocxU9aX6rtJt2FvqAhvdbC4dErt053gvl2RokAN7mETIKgesQlXBywHan66yw9ysbGkLEH25UTKpHm4s0hikvawA9x/kUrY+2Yr/2l48pw792Qf7zKiZt8YssHYkNC7BVIuroVBu1KfCEIbSh+QoYgdLO0bxQ9hhWCdhl6Kv3hMHMzm/azpB+TGB2Wc/1ivRSMYhqdwW9qx7i5fSxMQkiN7dMREJ88OjMGPC28dgu0iVDHa2B16pDhAabxJsT3UcEmplFc/oihFmUEvGJOJIJ9+3RCOVEtwkKv632eU2HqwiCfiaBMhuD44EG8JwwzOsAyKfagNKR3FqlUVBWrZ/D7dBil1BUDBfLT+ZF0LnkkbRQmuf4yTzeurcpi+PSKMvnrNAjWrCjAu0jllkHIgDKfwj/tbptNrdrDVRkeU2SfdzjLIla7MOhhv0XGApDR255MDoVX/fbvoTRbmHCy9xd6qXiRk2WEclLxbr8LxD2qgsUfrixPsHu9LbNmN7IvxmjySvkGhl2x2QHVvnCZwOYCFdO89HIiQQr3yboq6ZkRyRwNrBdHrOEMF6rUkbKnqtIM68xfSAQCho29AM4tY8wq0USkEQd9/MssnG7EouJPJq/Xc0rDl8IkmfeeP+OUM0Z7yhbHDZpMnghtFc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(4001150100001)(5660300002)(2906002)(8676002)(36860700001)(6916009)(8936002)(4326008)(47076005)(966005)(508600001)(4744005)(36756003)(83380400001)(7636003)(356005)(82310400003)(336012)(86362001)(70206006)(70586007)(426003)(2616005)(316002)(7696005)(54906003)(186003)(26005)(53546011)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 08:36:19.6472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4131a1-85b4-4b37-b19d-08d993a4b0e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3425
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 20 Oct 2021 at 11:11, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> On 2021-10-20 10:32:53 [+0300], Vlad Buslov wrote:
>> We've got a warning[0] in today's regression that was added by commit that
>> this patch fixes. I can't reproduce it manually and from changelog it is
>> hard to determine whether the fix is for the issue we experiencing or
>> something else. WDYT?
>
> The backtrace looks like it has been fixed by
>    https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=e22db7bd552f7f7f19fe4ef60abfb7e7b364e3a8
>
> Sorry for that.
>
> Sebastian

Thanks! I somehow missed that fix when searching in the mailing list.


