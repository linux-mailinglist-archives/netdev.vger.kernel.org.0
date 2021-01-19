Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AC2FC571
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406003AbhASNtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:09 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:25347 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390578AbhASKa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:30:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611052140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gNpfvvHWgmG/f9WHAty1JQPiTIFnPBtW1J4MXWf79q4=;
        b=J8TTH8jujNo3xb0szyctcwqaofzINOLU8PdRkksZJdvXD18Nc9KV/2NIAj1k6oVSBe23Mz
        wsNv484nuXjBO1KtmtEeBoMTn63c/kcmoqf9vLvsPs4q/aMdFggkkZLsoLxOCvj3zI4aX5
        1QU/RgBTdG2tZk6DfTdDJeoLBAVK8jk=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-czs9z81JNBqTHPheY97QRA-1;
 Tue, 19 Jan 2021 11:25:25 +0100
X-MC-Unique: czs9z81JNBqTHPheY97QRA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZw07fAcsKMWvAIHihjJaYZbOnotRXUzO1361t4C5K4KYASYwBs3HYbcf52Xiwmjb4IKrgKuXFxIiQRALuN8cDalW5v19IB1f2xsWLbh7WaIGM9BmtYfIu+Nq6fxCyXXuA/KOMG2W9nn0uh/fog0GA+koKbkS5bfDfFQ9RSN9sPBoHPSbOdWWEUnpNJZG8XsrZDSKa8Lzco6r71ENkswGPLO4ci2wNBHvILlwaHic9g5/Gvj9XW9sl/SgERnp0LQtyyXY458ofdug3e77FWQ6cKC46D3ZnKd/+CtP2c3mtdEx5k8VoikqxHzcEa79Ps3Ja+mBeLzfvj1ybds6QEQGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VArmcz2yqvIxpuzSpJifCQH1ustF5QD3oOs7M9xjECQ=;
 b=SxI9L0VhBM3h36PMjxs309BKqB/nHYe1bzvOM7i/9VdrL+7g6Py4DCPZp00nDVrEEcl3umyrmQGHuf9qAPgZlYaelPqzbkaPErgp48uAE7HqubEdZhAXeZibGvAicWZCiimF9wijjQ2zfvIierDNPOYhiXgKms8vBnwaqCwhFl8tPP21Q8hKxnzmlm1WhwTR9HQeRmh9lZYcVom32tXfxcfHpHtY27GlX1mgkXtn9mjhQhd1bYv3NT/JJGihZ33rhKgM9ayk7MOU2mFo4oIZ4EaBfnzGR1ZvhVkh34KeSlJ2eI3sG3/U0gzXarHoLjdMAjiT3XU8dVjoIiqtvUydTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB6PR04MB3109.eurprd04.prod.outlook.com (2603:10a6:6:f::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.14; Tue, 19 Jan 2021 10:25:24 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:25:24 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v4 0/3] bpf,x64: implement jump padding in jit
Date:   Tue, 19 Jan 2021 18:24:58 +0800
Message-ID: <20210119102501.511-1-glin@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.113.126]
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.113.126) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Tue, 19 Jan 2021 10:25:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a99b077-0535-4246-ea06-08d8bc648849
X-MS-TrafficTypeDiagnostic: DB6PR04MB3109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB310902D754CE1342E26D7F8AA9A30@DB6PR04MB3109.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pEs/fw65XGa2h6qCnPEtoj63p4xa9m2GA/NcboQbHBZJYKcCjqlRItLOdIUMsyh1kXt6fg4mtDp0c8/WKkRz5zi9Ql4Du46xjKT/pEPWn3N/akxt3aon9cVIakrkC3s+a8a99RDP2HjXFHwol2ECgX8OLHQ6UM+dCqUvX1I6LEMCxaTIul4xbuvSL12yLp3M61L/eIcc5tuOIRrLkDZWoIIBW3kYKpYaHp4qkqvF5aH9LB4UuKkaHYUHWFeXNxZZPi8fsZpdHBCVrxOh+ewn2FGgi4J4ljeZYPXnjerLcbSGRveKdGQN6p7+XyT4cg8eKAORIVGLvZS4qqWaT3QXQvPNQ5e8V9U7cJz/GWIn44Tg4hZeETQLXjkzeXTUsn1W7OzHZaknmJFetkoR+y/tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(83380400001)(1076003)(186003)(26005)(6486002)(52116002)(316002)(956004)(16526019)(6512007)(6506007)(4326008)(107886003)(8676002)(5660300002)(36756003)(66556008)(2906002)(8936002)(66946007)(66476007)(86362001)(2616005)(478600001)(110136005)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bY8p+KXhPnvMsi0zNVvTPeSFMZlfi/XH6dkd8We23VWCnrrTrHkZ66EL2ju1?=
 =?us-ascii?Q?q65vyZ6eo8SKKeAthc/QCdZz9uhfSaH3jOx8tq1MPt2piT0jO6hSSexiIOzx?=
 =?us-ascii?Q?C6gt3aLD0BiRNs4v+wwHOsfNcWk6qe32ouGLpPfL75gtTO3vMjw9aABgWv9/?=
 =?us-ascii?Q?yOZPo/SESk0JKadHC0NQxD+3kMAtX3aOBqJVCiytUV3ejSnv7DZN+wHtBQ1H?=
 =?us-ascii?Q?mrsjujey1vFTbdFGZyVkKQnTtibT+nE7MuhIXxRIOmbipV54UnboJglqwp7Q?=
 =?us-ascii?Q?VlRlhBrJiK3hNseJkQtTLV3HMVaiv42/zuuhXLwu++HawJ+kZJ4dQWQMewQg?=
 =?us-ascii?Q?Bly9dzfNNS/lLGAXOXF8LHvOHKCUp9hzaAIfaAdO8qdeROb7HCMydh2eQOXU?=
 =?us-ascii?Q?ajtkKf5nVr+qE2rMaSUZC9qZY8ifkmWb1yRyeSgfJJSqZ/6Quymtn01fbFLK?=
 =?us-ascii?Q?x2V1kJmF9o0LORcsjx/lW5ocxMRgiHjZ8S8gBk6yUbaA49t133zHzlNhNxNj?=
 =?us-ascii?Q?hWUkIkcNHIVRiiY1QPJnbYMkwsia5MZWjWLL8ZSNRu7cCt16M75WzRCSE+hp?=
 =?us-ascii?Q?S3DfIttQpPSOwcmksr8X91C/U3vRsOv1GVgLGGSgoL36ZGC8aTKxgSBtAKxs?=
 =?us-ascii?Q?8S9dhsfu7RGmlsgYbFKevutmpYFPKirZHgmGJ+7iLv4lhi1mF1iDazzaNzTj?=
 =?us-ascii?Q?46DGhe/lC/2fCdxil6r9tJuZuqYnBiBl+94bXLyWtsBkDJAoygvx3INccLy+?=
 =?us-ascii?Q?rjoqXVGkmiXZr2PgSjO47pzNx7g5haDUZ3VZQVcfyHrOQqHI8YIkLSwv7yOW?=
 =?us-ascii?Q?Xdbnnc500aTgEwOnTfZd20P/NeoINHB8EPD9D+U0oDJ5UtglsWypapNk3oRw?=
 =?us-ascii?Q?EWzctXWAZ7GBVkZni0eSmpohmO8/59YG0xedAbWfQPeCb4R4kMCkjynf3OWm?=
 =?us-ascii?Q?qtJEpnn+V6COKPW6QXsEYPQnNHow2GY6uS1Q7S73R0ANHtA47p/1tKz1rmOA?=
 =?us-ascii?Q?w2SC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a99b077-0535-4246-ea06-08d8bc648849
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:25:24.6589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xp3aIDA0Be32wDcm2ptTBYDh9z013fw49m5OYY+uU28vzBpP9u9wYzhomDfuQvCK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implements jump padding to x64 jit to cover some
corner cases that used to consume more than 20 jit passes and caused
failure.

v4:
  - Add the detailed comments about the possible padding bytes
  - Add the second test case which triggers jmp_cond padding and imm32 nop
    jmp padding.
  - Add the new test case as another subprog

v3:
  - Copy the instructions of prologue separately or the size calculation
    of the first BPF instruction would include the prologue.
  - Replace WARN_ONCE() with pr_err() and EFAULT
  - Use MAX_PASSES in the for loop condition check
  - Remove the "padded" flag from x64_jit_data. For the extra pass of
    subprogs, padding is always enabled since it won't hurt the images
    that converge without padding.
v2:
  - Simplify the sample code in the commit description and provide the
    jit code
  - Check the expected padding bytes with WARN_ONCE
  - Move the 'padded' flag to 'struct x64_jit_data'
  - Remove the EXPECTED_FAIL flag from bpf_fill_maxinsns11() in test_bpf
  - Add 2 verifier tests

Gary Lin (3):
  bpf,x64: pad NOPs to make images converge more easily
  test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
  selftests/bpf: Add verifier tests for x64 jit jump padding

 arch/x86/net/bpf_jit_comp.c                 | 140 ++++++++++++++++----
 lib/test_bpf.c                              |   7 +-
 tools/testing/selftests/bpf/test_verifier.c |  72 ++++++++++
 tools/testing/selftests/bpf/verifier/jit.c  |  24 ++++
 4 files changed, 209 insertions(+), 34 deletions(-)

--=20
2.29.2

