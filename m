Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DF12EC801
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 03:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbhAGCSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 21:18:32 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20184 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbhAGCSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 21:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609985845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/d6PkSxgHGdSO2G/bGXqwO9r0hc+j9TjkglmPmxN7qY=;
        b=FiTlEHZvmUv89wyc4iDDas37QxvL6XVaNIXAytlWdG7QFKxGQ391ZlZHTd0cWdf3Ygos0D
        /qWyRhscsCgodWHFDg6oeT7RdRHN4cc/pNWVFrJPGcE7vNQbAdKYlteMZVyloXnPfLsqNF
        pORfr7psAr1WnDMe4L3y1U7LrUBImJ0=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-QDFCRoFmO2qwp6g_6vlLRA-1; Thu, 07 Jan 2021 03:17:23 +0100
X-MC-Unique: QDFCRoFmO2qwp6g_6vlLRA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAJmWHSCmTJPVfhY8Q4pS9vn+i2F8dtqgC3TuKrj4W9griwp6y1EBvKByZW+UPZ5vsq7O9vzUDHJpVK9o8N7ojCrOGEcnKQuz7zSiBzeOHCmD8laitZOQHeA7WR9PXDOG3R9QexuXV2js43XbSV2pWiewZf68YxfZp6SVtWWcb+VVJiibax9Fj5SGVLIA4z8v2x3kKuRxtR1Pvq14RGm1zdyy0Hg3Oi7Brn5TTxlFwYA22eaVnEWNH8fVymDsmMjSUddMj/UdGpibnXiWj4mmtkZ5ZuJXGuhYo7MVtQ/SK8X/Hh57cUxpEBhXGQLnRcGp/aNjJn/agoPe1GU8U/oqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzJtz1nvJ5cu4n8yvT9Y3LIlPmRzzoP8wHFLST9meWQ=;
 b=l8b+FgU71TRaIU/4EAJ291ja2+KZURhsXDvgl6UpyI1oG+cEoY3Qa0ZC9bBEiVlRfstXR+2ybKIskVa/ZdX8kBEQpHUWCO8Nv4CnVVthB8FN4nCR82q+Z0h/tJCtHvL2XwLt714gFjHf78hIX//9/DCe2PG5U9KgN5RU3ECkh9fuOm0bRxmMc8cDL2R0T7O+E1Pmziq5iAyi4ufQxb44eZPcuHjAPobIF3I5iaah9SJ4wxusotOtj5c4VoDplhpOOFpDqVLQfv+0Oc1EbFoIUJL58dHvzR8pVVQtCltgpNztsx5gJJxwl+Oqn2N1NnipJmL2DlKyFnlke7eOgSdwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB5226.eurprd04.prod.outlook.com (2603:10a6:10:21::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 02:17:22 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 02:17:22 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH RESEND v2 0/3] bpf,x64: implement jump padding in jit
Date:   Thu,  7 Jan 2021 10:16:58 +0800
Message-ID: <20210107021701.1797-1-glin@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.141.15]
X-ClientProxiedBy: AM4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::34) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.141.15) by AM4P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 02:17:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdbae070-bfcf-4807-2d1d-08d8b2b25dd3
X-MS-TrafficTypeDiagnostic: DB7PR04MB5226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5226F1DEAAE98844399FA7E7A9AF0@DB7PR04MB5226.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PsohQRQlGIWhjb50gT0sNXIhoXLd2KxwgTJjgYAiXZEP+ibFyzqqUxNAwDYRP4zAwSMEm4gkv0ENgVIeJ9F3alobCD49D7MdsUfonHxq9P924UZUaTFtCum8GVz+3tADY985I0vZ8hrvAGVtGYV2SXKDV4uAC17Y5t4h9XAZKrJB2QmlQ84nGA+XlLskKlQs3krOBgdP0vel7QvyLU+aC3nSJkx7r2IK02Ub2aSpz3TLtdpI6w5cx0FNHEZzBG00oS1QIKBD58cIDVQ/6DC7bN7RcdSuF9zHUf9RqCrFT0pdY6ajextY5Gvr+wc9NKROLvw1I0glipQ2o1qH2lNvAGGElDYYpe57JyDhwlb5sfr8EYBMbqRJonRtkEeFcQmJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39850400004)(396003)(478600001)(8676002)(5660300002)(6512007)(54906003)(86362001)(2616005)(956004)(110136005)(4326008)(8936002)(316002)(107886003)(6486002)(36756003)(4744005)(1076003)(83380400001)(66946007)(66556008)(6666004)(16526019)(2906002)(52116002)(186003)(6506007)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ht27g2BJ6FlT2/KgXwl7chgkNZxeGRS/3dV+QhReF5CyuRR7ogASUOSBWAUM?=
 =?us-ascii?Q?zO5S5SOmidxvWdWrt+hP3ENMgHrd20hsxi3LBp0026Stpbk8xBRxCorNlMeg?=
 =?us-ascii?Q?nU6tjMstKGT3c9Y6LQy2ByQB0j6sUwUjBw2akpsjMxPZy4GP72xDubcfIthA?=
 =?us-ascii?Q?zzHyzXsQw0WIA7S855WCBpp4OErCCUM8XoqQLUNcpE2GyYtQOaYK5pqNSPxQ?=
 =?us-ascii?Q?UnnZBp5fUfbVDX3n3TnyFVzOx8ZzzS10AlqNXPgsl9wkuO72EdQUhTYQw5dV?=
 =?us-ascii?Q?pYPyiWezRVXwJ+vtmvKt2gvYAAPwZjzEfOpRw36ZPo3XIOp09M8RkJlZtrHj?=
 =?us-ascii?Q?VNSZagmRm6/R3jv6n2XB47pxHfm+/Wwsl0UOkLmJY4lzGt7NRUdQy4hsEo7V?=
 =?us-ascii?Q?b3+S3bQoMsREOz7r17qXlzicpXyQr26VopYZZ2jJCLS3lP93IVP5k/408GLd?=
 =?us-ascii?Q?t02E0DCczS9VdgLazherSOwuJeQ7vNDrQ8ResT5f/ln7nMmFW5tOndcAPDD9?=
 =?us-ascii?Q?P3JGERpWggkWFepdES36sKQs3JMyYw85BwHTmB/xOHtSruuhIWv8nVzW9wbY?=
 =?us-ascii?Q?2zHEgnc9BaT0ilUPoRobbpE6wS0k3nMVkUPMF3nshUp/fd1D5XvhvxtkOjuT?=
 =?us-ascii?Q?P9fmHsbfwm9ZwUKk7jfY9V/3jcsm+nYWyZU3RHWYCoXprtHEpmHLZVgu1eDX?=
 =?us-ascii?Q?TNeOZjsPubgKNoz+L5l79Vx0VYJunuaR/QaMVMvgGd+p5aB4RBQASbTycVfA?=
 =?us-ascii?Q?QgUCD35njN+rDgyyGM5HFwM9gQXw3PuGXJabZoVtZwhVJxPQv9ZnM5Npb4DQ?=
 =?us-ascii?Q?LwBODf7MdNP7sDB9Pzsg8mQmsMdEnzE/yxS/OmZnzX0X36OL4bRbUlnkkRGj?=
 =?us-ascii?Q?53nOfRU+Tijlc2v6Q9Ag1/JyETQRfo753ptdFaXtmbiN1n7ZE7622ixUHUwM?=
 =?us-ascii?Q?paukwJb+jIQ5F0a8I2A+43kWAudGhX7I7YCU/Arr8huniWuzeRZDUBD3dQBM?=
 =?us-ascii?Q?JJeU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 02:17:22.0059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: cdbae070-bfcf-4807-2d1d-08d8b2b25dd3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RP9/wIvg/J7pwmdh7keLwnvrxwnwRP8ltDqh9IxlLOx40SUBF4ffIpxe+9xs2dLz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5226
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implements jump padding to x64 jit to cover some
corner cases that used to consume more than 20 passes and caused
failure.

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
  selftests/bpf: Add verifier test for x64 jit jump padding

 arch/x86/net/bpf_jit_comp.c                 | 86 +++++++++++++++------
 lib/test_bpf.c                              |  7 +-
 tools/testing/selftests/bpf/test_verifier.c | 43 +++++++++++
 tools/testing/selftests/bpf/verifier/jit.c  | 16 ++++
 4 files changed, 122 insertions(+), 30 deletions(-)

--=20
2.29.2

