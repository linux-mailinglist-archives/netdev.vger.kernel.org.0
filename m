Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59B9218363
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGHJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:19:35 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:34625
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726144AbgGHJTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 05:19:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWT+VaCn5fqqRPW1+llAeC5dX5EVBryjLNC8olSJRfcMelEry+XgUJG98H7nKBomIfGyvpyuiWnGjTb5AVzFrtFroKCh8tjcUsVlnc/oqUSPrKweq1K7m42QtYhsSdIG02XIeUsWHBBjYtVX8dwGCxyEmk30gecDA6ALv679zaupC1+XhEwnVDd4JkDi0Vqa4ThkhkajQdIMoykDeVv36KU+iQYnS+ZnVQ34/YpyWjQ1GHn8zKLqNbbVFE2MsCEDd9zAoHrdwlreajyIVfOQ1Uw7yNBsLuzZE6PkMw5V0LmCPxZawbwROz05U48I4IAygqDNRCGskkZQTs+D31gwdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZHPjzbhpOZliJg5oWiB5JRz5WCWLvho9lcIe/Os4O0=;
 b=Qce24KSLU9PgU61bcpS4ngdNlaGg9Hu12FbyGhoDNZ3QI/OLxpPkQvaIE0EgfMyVHOd9TwHmME+lF5yHJhpt5BUakiLErklbm9p8lfntRFm6YY5BjanO7dIS88yGbrLuFpYoADQ6AgYcug0XtrVck98JaL7V0nfYOPrgalFpHwfKbbZQw9gOe2UNE9JQaOfZhkOHTXD1p6M57ejFzeKFFMF8t2fVzszMsF8mN+y1IitGpH0UCAPjnok2gtztcZLONNSZQ3ck9ZOxppmy1sLjVV4eNZB2vRJ6448gl/mqYQSSgQUGBCHBHkggMHKEZwot7L80CeEUCe9SU3UmD82EtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZHPjzbhpOZliJg5oWiB5JRz5WCWLvho9lcIe/Os4O0=;
 b=YxnIPvdnDK6nKCnRfeQjqDir5Z7qWFdzjqBJrgoD6rynfKhhSKwYy5jWsllSgJ1pciF+3mRcfufc3ezJmlQvOyi3KQyvW7L7gfMoUqlWjvuJN1eAXgcCvxPA4Fyqosk/mQCZudwBHsDbVcLx8KI7kT7EYXOIzmDvSwBsJXY8Au0=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3419.eurprd05.prod.outlook.com (2603:10a6:7:36::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.28; Wed, 8 Jul 2020 09:19:29 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 09:19:29 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXBF6hBb4T_cjGw39PRuxaxE1f=Cfmr49QMkCtv-LT61w@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
In-reply-to: <CAM_iQpXBF6hBb4T_cjGw39PRuxaxE1f=Cfmr49QMkCtv-LT61w@mail.gmail.com>
Date:   Wed, 08 Jul 2020 11:19:27 +0200
Message-ID: <875zayictc.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0146.eurprd04.prod.outlook.com (2603:10a6:207::30)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM3PR04CA0146.eurprd04.prod.outlook.com (2603:10a6:207::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Wed, 8 Jul 2020 09:19:28 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 863cb341-81f9-4a26-37d4-08d823200460
X-MS-TrafficTypeDiagnostic: HE1PR05MB3419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3419D8284E7279211100EBE5DB670@HE1PR05MB3419.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4ZHyuL1kihgD0BGrEZWeAEIDkqHqhYbB7MUS1MBFsfoQsvJ6AhUDSABGkvgG0KK4NVlX5RSK0tE/wnuYDBJ5iwlTakKZAr11AAFn5DDrvbzvaYWk86GbxntlwMzPSMaQsa++Hh+G0aL9l+vOC5T2cbjX/E4kzVFWzLKSK+Pn/+2q+uz03GqINrrl/+h3yf/VYdeEE1fpHVYBaIsFVIjCgBRl3kU/ahdk99QRCv3bX7fs8nkDLn213IwL30VdsYCzNuYYo4ulh4enLVPswC7A+ORWcNuq/unREwjm76Qo0IQ6Rlw2nCv3KW9Mznh1Lr2wSMonBtxeKDd0z+wsjKmbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(107886003)(36756003)(86362001)(186003)(26005)(16526019)(316002)(2906002)(2616005)(956004)(54906003)(8936002)(66556008)(66476007)(66946007)(52116002)(5660300002)(6496006)(83380400001)(478600001)(4326008)(6486002)(8676002)(6916009)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EIETjIKFictYqVpDXGe4013dMvp+Mbm1OjLYP9RMw4rUB0O8y0Y+c8dQOwUs4k7p4DwQgNi/hkYulGa2AvP9RL+Pd2amR6gq8Eo7f3vARC385eg6rNqT1EwjDd7qmGHIroAhUHbpUgsVlNGP8c+MCUHBY4CPx87+TSo/V61qq53PbIVfIorxmbFbdGZIQMTcT1+UAujUZmN/Y0PLBxVeES7aYnmZeIOG65sF8wqLr8/hORYdbLxBh3NAOQCTNypV3kF/bX1cGh0tFwgDy0Z4UrelAn8XO/OUC1iuad4ZhpGv1l5vF8Lus8ZyseqKnVRL/aOgwBLgM8/kZOjLB/nRb/kgBGm0mUPbDQBZ2wsw82/p83bUatuZzasCWAgjrCU7iwm4wItEhD0tbyEnizsiDaQvTt0SMAZdfU8s+cRgxinpDBlGnuRnbXQXM4Tfc1KPqFbDOW3dBhiQmb0kQNcl3AWdAQDfs5v48lkD0mf16eH1cAIA1roMkpFhgOuicgiB
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863cb341-81f9-4a26-37d4-08d823200460
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 09:19:29.4494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1ShEFc+tAfhkBUveHtHkTVR9WP80WwFydgZG4rD0UXStcmRSbEE2f0/Y58Rk6pI3nBOWgNvO1yKv6IoUnSRvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3419
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
>> The function tcf_qevent_handle() should be invoked when qdisc hits the
>> "interesting event" corresponding to a block. This function releases root
>> lock for the duration of executing the attached filters, to allow packets
>> generated through user actions (notably mirred) to be reinserted to the
>> same qdisc tree.
>
> I read this again, another question here is: why is tcf_qevent_handle()
> special here? We call tcf_classify() under root lock in many other places
> too, for example htb_enqueue(), which of course includes act_mirred
> execution, so why isn't it a problem there?
>
> People added MIRRED_RECURSION_LIMIT for this kinda recursion,
> but never released that root lock.

Yes, I realized later that the qdiscs that use tcf_classify() for
classification have this exact problem as well. My intention was to fix
it by dropping the lock. Since the classification is the first step of
enqueing it should not really lead to races, so hopefully this will be
OK. I don't have any code as of yet.

The recursion limit makes sense for clsact, which is handled out of the
root lock.
