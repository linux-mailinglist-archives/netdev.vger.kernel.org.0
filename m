Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8630719267D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYLCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:02:06 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:29378
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727177AbgCYLCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 07:02:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgCfU2tuWrfMw/cSY8KD+k2jzaNmtCtXEs4qYzfohBEbFkSJbDTJK9JknIEqS85QEEaG0XWhst8DeZ7cgwU6CygtPHlB4X3UUTnr2/sVCprV1LJROS161iOsI8Rt2aUBPksx0xHDDNPmssVybqri+CdAnCBm6xxxt1qIsvImWiYJeo/THwC7W9hl93HQEYZuDjo36wFMENZKj931jC5wBONksoRYpCrkJFtpHGXbEJJ+afxXLvpp7lzP2Mkpr7SlT5tBDyi2iZbozoOKboD75ucCNTbf8gjfgeT1Fu4VFXBeAA5pQNMmGqep5p4soobZOcgUxBZmpLvt94RX150o6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTav6xEYaPRhFHso/spDLm51k0ezJJEpqSIFjhVfFvA=;
 b=nI2vqSaEmWmLa6qO55Se4PsX6GL4GtaK6En71w4sc3tJlLacdVBDJdGAOrH026AEO3JVy3EriN2mMflvRXRa5sH6rZ3kvTtaEYJ0LMnKdGLEq6dbG62Vg8F7/uqcTxj2HQ7P4vPqswj85Y0AEgyiHYkcOro97xVpZGPJMWu5pQXjtE907DNZSge5Hq8xBe7/734CsPsz3ruMaxu/9OmXKr51TG03DRGOYg3TzeuMQkB2aiTjXzIPNx3+FQtv6x3kEgEh+8djjPc5z/aVP4J++gGhszv0Ak6onypW3KCwdqX8Hzkt1SzrO9TygDZyQ3u0yc06ak86iO5UmaMqhSPdQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTav6xEYaPRhFHso/spDLm51k0ezJJEpqSIFjhVfFvA=;
 b=QkSoB0Ts4RgSikAn5IRQNChiULP/i7ybc6dW3X2UWay/Fc27fEEaAF8qZs98r8rO55ejqMoMiHlb5maMIHGr94g6DYMBIpf5NBbTJKaiRPF9AC/tYC1x7oICOvAr4ZnhEFxAGcDPfZY9HY0w0DIn2W+yhs/YxMOeLTmekORgt8o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB5279.eurprd05.prod.outlook.com (20.178.11.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Wed, 25 Mar 2020 11:02:02 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 11:02:02 +0000
References: <1585096042-1800-1-git-send-email-wenxu@ucloud.cn> <1585096042-1800-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v7 1/2] net/mlx5e: refactor indr setup block
In-reply-to: <1585096042-1800-2-git-send-email-wenxu@ucloud.cn>
Date:   Wed, 25 Mar 2020 13:01:57 +0200
Message-ID: <vbfmu84itp6.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0103.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::19) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0103.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Wed, 25 Mar 2020 11:02:01 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9bc5e8f-15b5-471a-f1bc-08d7d0abf233
X-MS-TrafficTypeDiagnostic: VI1PR05MB5279:|VI1PR05MB5279:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB527953E0258903055AACC8D5ADCE0@VI1PR05MB5279.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(26005)(66946007)(16526019)(66476007)(956004)(2616005)(186003)(86362001)(5660300002)(316002)(4326008)(66556008)(81156014)(81166006)(8936002)(6486002)(478600001)(2906002)(36756003)(6916009)(52116002)(7696005)(8676002)(4744005)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5279;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGCewqrZQnAXSHexfgizyw0M/nMrQE+u1F1Wfr6Db1MTIIR9lu3bfM688wuR7kETVYK0fRpqOQhgdpfipwokgPlp73S89WyixIINgoLiojLIwkGMIlq9XwI1lAAnBiAP+pc5fG6I1p4E+hj/E/WlNbAkq7sI7QfTKnH3K4/GVWrYhvjLCEFgc9zXzKfTMSG94ZHzqNdlwODysr95sCl9sMIG6x1wqWWxIY4/IdoiQKfjFCzA+wBNlq4gBvvBQwCe8xUeW6AkKVISzEih/fFtEkZ1bMm/f5YJlEvCjD/uYmFrMXBuHkWNO3Q+YxGNQvZICVntvq7v3w5hAPZcg/Urmoeld5usjp03YpTX1B595de4/PI76P7U0kE6JHVnW6VSKVPIP5T9hIVTI4Kkg2op95vy4yWGsqJWpX7aBCcFYPRdLArJtxYVwSjrm3fWbWKH
X-MS-Exchange-AntiSpam-MessageData: fnXuBT62FDfwxWvyp2wflQ43pFTN52nL+Jqax5rDyCIwJ1HHuWu9ABxCIxFLpseXgxn3dSCrkR6DB69jbvVaIjBAxtiLRiJWjGqM7MQHazhBoiVM+uW5hrYlrzhqX8pqSsG7f5/nr9CdRvYvlAaBrw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9bc5e8f-15b5-471a-f1bc-08d7d0abf233
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 11:02:01.9479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnHjgkXrJpKnw58SLuS5wymggL0m64ZD8ceQapN6ciqWJT4IA06n2oulAksy3ew7M0uJ806tqQu58NpwGrRYBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5279
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 25 Mar 2020 at 02:27, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Refactor indr setup block for support ft indr setup in the
> next patch. IThe function mlx5e_rep_indr_offload exposes

Typo here. Otherwise LGTM.

> 'flags' in order set additional flag for FT in next patch.
> Rename mlx5e_rep_indr_setup_tc_block to mlx5e_rep_indr_setup_block
> and add flow_setup_cb_t callback parameters in order set the
> specific callback for FT in next patch.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

[...]

