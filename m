Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38B81E49EF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389862AbgE0QZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:25:20 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:3141
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbgE0QZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpMZOAaBZ9GOhOeYu4pK6XCW43JlwBB1gdcgQfYMvf68kNSRX60Z7F5SdHuJUeOE0BqTNdNAgiXIFAwiN2nWs8U2KVxGyDKUFv6hLsBfaimj9kL0BRhXqmQVmzWPsDuQJC8qpYlJ6mvJD0347+hG8csH0PdBF2Qask/okR0p5Zj9x4CSFPPK+DIUseTLBJSu7z4oQRQObFkmM6vZdkV77FEbSxt4B7YpNWwQCtM8smD3XxjsINVovp1ssxiF7V+DC6DhkeEXX+t1O+L5/2uksD8hso3p6HPznZfiK1EuelPVybUE49jhhYIDqY1LksqqlL7GmnWStGexx+zPJ4EQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acmEXfLb/v606jw6NyWtQVxSS0cg2gkM9uNufA2WSY0=;
 b=HPRIh28GqICgjYry38pSvAA9jso/wG2OkEYh8tJUcjGyDMfhaec0xF+KmUkLUxYWKdy6gaHVvxeealxe+mFtZd+CE6/P+p5NIk+Y5Jba1lX0MXIdHRRPv5NEo9yzF5DqrsJVp534YBYaGyJveNWpHIS55+hMLTQyi9u8vnNygSD2dY7yzSHFGc8XhV8DNW+0k44xTQJrOlXqp04kOlf3EV155tWS8+qI8f48n/EE2ZdXJEFqYvWEE/XQQzzvC7GI8V/2AetFTdLm+smyi54IyEGmAHvjkJ4+jNgb72ErA9cmcpJ0WwH9t5+I6iHmBWNBWiNkR+Ndi9fnO/CFe10iWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acmEXfLb/v606jw6NyWtQVxSS0cg2gkM9uNufA2WSY0=;
 b=BcwzKN91qztyrMo4hiPe7tsHmYS3QolEt4X4PhC59NEy2gjnCGlCTAcKZtqSdpyFRv83N+uFcFVhSC13hEvpsAK7ot0cIEqANMTSG7nK3YXuv/yetoexI5nKavyqGhz1YuPfXL6qHKHvlhihZAGOLS/jfgPYZmKsI3nEr3YbaDA=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3307.eurprd05.prod.outlook.com (2603:10a6:7:31::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.17; Wed, 27 May 2020 16:25:15 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Wed, 27 May 2020
 16:25:14 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <CA+h21hqUKN9+Staoff++CoMd7wAkYBnwHOcunzX4nOFuAK_XHg@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
In-reply-to: <CA+h21hqUKN9+Staoff++CoMd7wAkYBnwHOcunzX4nOFuAK_XHg@mail.gmail.com>
Date:   Wed, 27 May 2020 18:25:10 +0200
Message-ID: <871rn5uyzd.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0015.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (46.135.76.89) by AM0PR07CA0015.eurprd07.prod.outlook.com (2603:10a6:208:ac::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Wed, 27 May 2020 16:25:13 +0000
X-Originating-IP: [46.135.76.89]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba45964e-ef0b-4908-90bd-08d8025a8902
X-MS-TrafficTypeDiagnostic: HE1PR05MB3307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33079AC764A930814BE6DB12DBB10@HE1PR05MB3307.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eF5bTWl+JrsHb/GjJ2lcUnHmjZzXml5SqAU5GJf25jKoP9CLfznnVh6bqlY7sv+EH30flZLd5+Cqf/bjkaAUYxdzml5DTswe1cnVyODoeFN/IbrzWJIEF+1AyptMMQIDBmuE0UNqHCqSgEzY15giRyR0lDCd5enEqqpfa9qNMti48X5fz5L1AP5W0sJy+w8SedXuo1XEHEzWDXNRbkvhrdTo+9P98ArMCUhzvScfiTYQl+hVGRksg+CIOvjUDQt9Klng9XAqRV1Xhn+tSC3Bzo/ulbeFA1QgF0ho4b/axHNYcnJdlrehAPmi2NLQP1Ssly0roHrig51/vAKJdk+2gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(8936002)(8676002)(66476007)(186003)(4326008)(36756003)(66946007)(66556008)(107886003)(956004)(2616005)(16526019)(5660300002)(86362001)(6496006)(26005)(54906003)(2906002)(6486002)(52116002)(316002)(6916009)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v4i8bkCOM0mt2KvSCNhm89Oh75jd9jjMrUSIL/P7vm8+M7iyKtf8Nkci6FeW71ODobgdhNEP/lDZlq/3vy09J1cNL+3LtU25p2YGx+qsPMDAsGaHI9lk/6iCziEHtskLNuvkL6VHILoqAbjwDmkq1KExFC3zAUp3w0lb0ot9NEk0taOoCyvprPVZ1kvPpkm1ALdHKqbclp+Lv+Onk8yG50BhU+N1IuvVmnUaEzQl0Jpn2SfNiPg0O/2nW7DF92UgG2T702bkyNUd2WyNER0Y2h5mFxojTifMiNRWwcMVurHNcpf3cY+OAvU3dZQLsndResG9I127IMY6TK8KLAKXTxMq+Nsbx4RILItNmlT3ncifp7jvLtcZ0p/GAB22cQclzxala4DM0jLdCW5t51VWBP5IHRamIRnsFVdpnAsmvsrcLRiRo//TkV4sKpE1VJ7p1Jla5iPcBhfLLXoSuHWxBQkBdalhhLSDx3ctH54S+yc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba45964e-ef0b-4908-90bd-08d8025a8902
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:25:14.6671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5zZL/Oda3l7TX6Jd5L/zFYO3o2J9uWt7rFrJMcSBtmcWTVPHfq0qEjuEy8Hl8ZRveZ52bMpJKFZFp9lT54HYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Vladimir Oltean <olteanv@gmail.com> writes:

> I only took a cursory glance at your patches. Can these "qevents" be
> added to code outside of the packet scheduler, like to the bridge, for
> example? Or can the bridge mark the packets somehow, and then any
> generic qdisc be able to recognize this mark without specific code?
> A very common use case which is currently not possible to implement is
> to rate-limit flooded (broadcast, unknown unicast, unknown multicast)
> traffic. Can your "qevents" be used to describe this, or must it be
> described separately?

You mean something like a "flood" qevent? In principle nothing prevents
this, but it does not strike me as a very good fit. These events are
meant to be used on qdiscs, hence the "q" in the name. I am not sure it
makes sense to reuse them for bridge traffic policing.

Peeking in 802.1Q, I see "Managed objects for per-stream filtering and
policing". If that's related, it seems like it would be conservative to
model the policing directly in the bridge, instead of this round-about
through TC.
