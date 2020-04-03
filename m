Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872C819E142
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgDCXF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:05:58 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:53598
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbgDCXF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 19:05:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLxQlxFz2UykbbC9b1V2QNI8Lh2GLCHhpaN8ClkB2CAQG99sbz8weNF1KBVb8qfn/u8PJS2Bo8ksXr6jwf58LO9bT2MkH0nHBBSc/fqds2OznR30bSXnMy3rMqCNfyN8aMB9Hx03H5uy8jd5ikJNjXv8ze2i1dAeEkZxH2J0NflRiL1O3ELQb2VlMXC6IaTvFjCMSP7xXjllMO1nPBT5g2Awr47wvhROMHSvKUlhx80i13s5pM92gzwBQ68hRDaPY6XbgqChjOZvBAxTr2IkxNsWnJ/fJW9lt3TuUCPnpkEh010j3OJONZGKf0x7zIhPFRt7PpH/J0XaIOz0eYfzLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KL0A574o73TLfD6LmgM2AzfJfhtZWOI3OJx27Qw19b0=;
 b=iYUxpwlcgmy473v3XvKdOfFnuw0pamYnXJJtjkO1AL7AFiSkjVpXP9XLJ9hrQFDmwFMIx+q6xUbhW7oOh2XxK2XRRwIDQYUtmq4qRXNalcE0g56zfb4bpKW+LhntI9Brv3g6nj6PGyy7xkHnn3SiSGm6WJnYBJw1tqOlPYSgfDsiSdIrZs62KyTmdEP7tnLrS6yqKj4t6PE8O07VDzSzyOidqiRv8/E3ZHnN8V6W2a12W28pLcs+OEQf8FGw8SJHUh3caD9DaGb/MGbjtq5dlbOcqhh90Nm5HjOjZLOLkgwgaKribaVGDlYPhmMuKDGotax7TyJjLnqFKM3xAJ+iQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KL0A574o73TLfD6LmgM2AzfJfhtZWOI3OJx27Qw19b0=;
 b=Ob+FWkmqoXGO1Sb90xFcoe4MN6wqTO8Unmexh9tuvscbnO0hnmhWgC2atgqMy5seIkwkLm5PuAZ0skT7In0hXKuzJDlkSlHKWNEh8EJrSxA2db2eM8nwL5xBkG7BtSVJjBUXbLEjWAuD/DMXFdd37n9HokzKPx0/Jc9W/QkegsI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4652.eurprd05.prod.outlook.com (2603:10a6:7:99::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Fri, 3 Apr 2020 23:05:54 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Fri, 3 Apr 2020
 23:05:54 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next v2 0/3] Support pedit of ip6 traffic_class
Date:   Sat,  4 Apr 2020 02:05:28 +0300
Message-Id: <cover.1585954968.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0039.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::14) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P193CA0039.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Fri, 3 Apr 2020 23:05:53 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc80c4a3-74f2-4e18-2c50-08d7d8238f88
X-MS-TrafficTypeDiagnostic: HE1PR05MB4652:|HE1PR05MB4652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4652E5F19C4183F2AAD46DC1DBC70@HE1PR05MB4652.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(4744005)(54906003)(6916009)(2616005)(956004)(36756003)(86362001)(81166006)(52116002)(2906002)(5660300002)(8676002)(8936002)(478600001)(81156014)(16526019)(186003)(66556008)(6506007)(6486002)(316002)(26005)(66476007)(66946007)(6666004)(4326008)(6512007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NstLqxLl1xUJ81ml3gGCSJdeqHlkIurF2nWbu+WCajXZ8WJ1tpFyJRtyFk7srzR//N09gONDyQXOzaIhNYsRpqeGNBzYjQgtASHMKNidffc8xnxEklFLFHi9NeYPVSO13zIYfLmnSseOC/rSpNUmdZccRpQpQOXVoFEwMjn0qmC68nttRa7iEvmxoBIvhdgLK8GDlRADGqR8aCyst1rif5NG0yrRT3HxxTdoEvCFp4G+8hZAt/YzaMywIOnV/jRJ/kMYmdFMyOUVSdKc5HW8/QjANtd9151QcG9PPQGzuhc+LZk0UJ4WwkKjwi9ccW/lDylc9Y8kbnxwoOXk+rwV1AWPWzqGxBopmInubTnMOQ5fh+vf3JylX+PFSq26Mg/2swk72PX1DAvHo1mV0mURbH/WCkH/zf2Qokg4sq+gvwyfD3ELzU3pCUJNqk9Of/4p
X-MS-Exchange-AntiSpam-MessageData: kaM8k2E0AlqJzfHattKEeACFIgbHywVSIgRq2IhJ2I7Tt4/RUGQO1Hb1b+cmqe1zBejZdeGAsmjCfrVbechmP7Ly7Kvxq3Nk5YTnAy/LBmP383YOaqnzYdSIoK6KJc2XsUNMNck+pv6ph/wC57+UzQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc80c4a3-74f2-4e18-2c50-08d7d8238f88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 23:05:54.4023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7j9F04MInj9OcSpe5FnRE2i2YxxMGGhD9Pfff3QhBfTj+I71ah7sia0ERS3+TnsVb7xxSRDLpN6jSfYBUx2nfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4652
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pedit action supports tos (and its synonyms, such as dsfield) for IPv4,
but not the corresponding IPv6 field, traffic_class. Patch #1 of this
series adds this IPv6 support. Patch #2 then adds two related examples to
man page, and patch #3 removes from the man page a claim that the extended
notation is only available for IPv4.

v2:
- Patch #1:
    - Only accept 'traffic_class'.
    - Move the if-branch that matches it to the end of the list.
    - man: Drop the untrue statement that the traffic_class field needs
      to be sandwiched between two 4-bit zeroes.

Petr Machata (3):
  tc: p_ip6: Support pedit of IPv6 dsfield
  man: tc-pedit: Add examples for dsfield and retain
  man: tc-pedit: Drop the claim that pedit ex is only for IPv4

 man/man8/tc-pedit.8 | 31 +++++++++++++++++++++++++++----
 tc/p_ip6.c          | 15 +++++++++++++++
 2 files changed, 42 insertions(+), 4 deletions(-)

-- 
2.20.1

