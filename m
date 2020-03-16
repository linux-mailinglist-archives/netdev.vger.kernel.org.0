Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CDB1870C5
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbgCPRAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 13:00:48 -0400
Received: from mail-vi1eur05on2063.outbound.protection.outlook.com ([40.107.21.63]:5244
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731864AbgCPRAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 13:00:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PI3RoUo62WdeDhHiVAkcTTWIVMn+NpDA28rN0uCHZpcFzKLrDr+4Raotafx4s+rVAfKOHEFo0eoFF8LOvI+9s4BfkddAh6HlrgN3FVZY88mRXDGe9GWNOv5v/9w0TinYCwBr3efBNzUNh2pkOkCaSEmyXNnpgucsTb8Cq5cNk78Mt/1g/d2MOSf5HQngEtHTyUAUQD72kZJqezMdUbPw2JrHDpU3FMF8//5p3uAQLR+jZgl9mcuDkIvowhcY8P6ko3TvkUB+k9WXrPiCnbme6NoEQkKp9KRs6oE7/y3N4F8FC9cfy6aoU745xnRq1O49Tn70RId7tuuBrSfMNPpd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYgFIIpLJXRDfGwMKZk+nUwzZmq0FbxqU9h2j7alqNo=;
 b=jTbQB8ssBTVGVzJ4G9PAmqnX7JKKQDCmee9NiD0lNdCe1hkvm6qkDkX0NGnbJMp88dXuwSA0pkXYJD/EKWGbK+pwK22Wor74v9lgKD9ODOITVCxRWYqG+i0+2CwJQTcJeuYBYxlkxxlOpCqkwSiDNtW78GIFVJ2QoNHJrH6iOhYKnKwg+UxHDDwHV+RdfdYU9Cbg/JQ8aF6nG2PLDjghJvlvpRFIiYrooJlhi/4lHdF+qCV8WPIymvX2H5tl7feCDAGX66qbZW1w7dCkuAYkls1LMsu0vLoLcB9muifkWLvbE+br0ki1YmSoQkvoXffhF1pQxtCxIz7edNd2+oRZVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYgFIIpLJXRDfGwMKZk+nUwzZmq0FbxqU9h2j7alqNo=;
 b=Mr3tuqDb2AzNhWUcuonscj/43j3T7Zj/0NTQS8PNYliTZWB5CiBogP6qp8ZxpkC1w+ve4uwpPSuxfv3gsyDqxuWWoMUwawU46b8qRRJdsiF2g5PHwT1t2ca4lixKT1+i3YSFyS72aKTNjZKYxMaymLdM+tsdqsoFQ07riNPKjng=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB0062.eurprd05.prod.outlook.com (20.179.19.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Mon, 16 Mar 2020 17:00:44 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Mon, 16 Mar 2020
 17:00:44 +0000
References: <000000000000c08f2005a0ed60d4@google.com> <00000000000081b1df05a0f40d13@google.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     syzbot <syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: general protection fault in erspan_netlink_parms
In-reply-to: <00000000000081b1df05a0f40d13@google.com>
Date:   Mon, 16 Mar 2020 18:00:41 +0100
Message-ID: <87zhcgw7ye.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::12) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13 via Frontend Transport; Mon, 16 Mar 2020 17:00:43 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c3152a8-14ac-45d1-d24a-08d7c9cb907b
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0062:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0062A3634E73025020A5A703DBF90@AM6SPR01MB0062.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(8936002)(316002)(16526019)(478600001)(8676002)(966005)(6496006)(52116002)(186003)(81156014)(81166006)(26005)(5660300002)(36756003)(66556008)(66476007)(66946007)(86362001)(956004)(2616005)(2906002)(6486002)(4326008)(99710200001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6SPR01MB0062;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9QJs4i69rVCJmVxy1so6Tt8T6REhekvE+gKnERnR2sbNzSyOfDcBuh9/cRWNw1bO5fYJIjEMKtF2CApGpNDZZKEstP3Y+s0Rb8nBsmQeGvKcpmLHtKMBCY+dfUYTUCyW9yuzSPb+T0AkNWrkE66H8m1VznT3YuGoo1TYrnowyHLw9Pnb1ovD7hqe8jEDxKu3mfB2Ig4bpLaEaW1Zc1kBRjJse5qNkah5ik1eOYqRQ3HPIYQd3Ual+l4XjpwyKdW0Avs1yiKkHZsCNRYM/BiwZxG/bAZOKFq3lxzGKdx25eXNbhJAVR3+3IAQuz1PCFEuuUH/CVeRB+czda2aBDwMf9/vbLL62hXCRyMnRTqo148GlWabu3tm55cNEa9Am6dlikRMG1nwgSJTLPhOBHZE8NQ0MTCLSZGddyplK8aJtwfWIXI3jGXRFZg9q2T6rlWpe97tYX9oQtGenrzXI1StUKpoSbV+lcOrKa52H31VOgetimtfVa1+MZ+FEi5HJ1CGllpHr1HcTM3Wbhc+sYPCeNZrFcIfD971rnMG/zwFEFUFnBCKXlSibThimIyCyx7cPyYaIAh6pokBnPG5nBt4SJC8ecnSqCoxArzQzWfqQ63D2J7No/Gj0F7pZjEb93cbyrpyEBi3UlxN85JC3OeNg==
X-MS-Exchange-AntiSpam-MessageData: lO0jv0lcvhcDIftKr6PydYT0rMQ+V0ynlPuFCMBo+aFYEEhw2i2/Vzf/J1bin0d/k+2POdIPrE6kP9BnnFYk2F6ANAD0Ux51TPEJfCS2T+4shghsmj8nLiZ5y/MX3pWgLNJdp6FBK5pfkb3UVAKC9g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3152a8-14ac-45d1-d24a-08d7c9cb907b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 17:00:43.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/zsbEH/BOCu7dW3zI19VT8x5HzcUgCoXwhLcNmKMHSpJx2jU1waLO72eF5buU9yToxXKN/PQtfHXxeqZo23LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've got this reproduced, it happens when IFLA_INFO_DATA is not passed,
so "ip link add type erspan". The problem is that the commit referenced
below doesn't check data != NULL in the ERSPAN branch. I'll send a fix
later today.

syzbot <syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com> writes:

> syzbot has bisected this bug to:
>
> commit e1f8f78ffe9854308b9e12a73ebe4e909074fc33
> Author: Petr Machata <petrm@mellanox.com>
> Date:   Fri Mar 13 11:39:36 2020 +0000
>
>     net: ip_gre: Separate ERSPAN newlink / changelink callbacks
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=101477fde00000
> start commit:   0fda7600 geneve: move debug check after netdev unregister
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=121477fde00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=141477fde00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
> dashboard link: https://syzkaller.appspot.com/bug?extid=1b4ebf4dae4e510dd219
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1627f955e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111ac52de00000
>
> Reported-by: syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
> Fixes: e1f8f78ffe98 ("net: ip_gre: Separate ERSPAN newlink / changelink callbacks")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

