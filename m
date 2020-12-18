Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36652DDF3A
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 08:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbgLRHut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 02:50:49 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:38914 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbgLRHut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 02:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608277780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/d6PkSxgHGdSO2G/bGXqwO9r0hc+j9TjkglmPmxN7qY=;
        b=RbV37Ef/Fe/hhSZt0ibtIH0LJYkddkXpO4BlyrJqCHuCMe3HxgXxV2eGtiBs7tymVb1PCM
        FILfM/4o0EKjlZZXm2Yj0L7bxo0p66cK3YRhIUR1HWIlpsMljjD4PgbActIlD7mp2xPBV2
        9PdiXMiyQ6DXnuRcBPqLv3OBZDMAhpU=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2058.outbound.protection.outlook.com [104.47.8.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-XfxwiuxRNJyxzRTmMl61XA-1; Fri, 18 Dec 2020 08:49:33 +0100
X-MC-Unique: XfxwiuxRNJyxzRTmMl61XA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIq5L7TrZaNJPYVv4mkUHOs8Kfe+uz7D7qUguZNz2cHKl9WrDPhbEbIvW9SSLs91G0c6gQ/UuEiOpnPifbYcDr2rw+JjSlM9wxEMObsGgSlFsy8P5dh1GOhQDe/W3Ma2SkC5PC5PhMItYv/bpz8d1c8PLJgxqlKdUoFYjnkbj6xLgltzFXpKpC1Usdhn0WatmIQ8GcxnRmgFSaJORFb4/3aEts9LuB4ieuxMjMYZj0QChUHFgc+JIphOfxgo3nMaMiew4+hF4scU+hds4HBGJmKTQ0b0+5gXJynLLt8RFk9v11PizunipgyE4mlbnKACJkqtojp5DGYEntqSXwBg2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzJtz1nvJ5cu4n8yvT9Y3LIlPmRzzoP8wHFLST9meWQ=;
 b=D3kz1yvo5/pPaWutYYervo7jCDV8q5R/fvG2pm2knl241YWTZKdqoM97VmnWLM9yZs2DjlrtKExUf/v+t3csQqS4bPybZxVWp0ht2pv8ykYYoA8+4RpACAj4rSxsBd/HRS0dzD7BgXFMZMDSltwN15gAprTrDgHUhWYWM1IQji8lvW23VT3kS2n1jyxzire6SWSMQLMScs5DHJRLy0gTU+rJny13FWj7xZYlsZr+LTqIG1nYuD1aGJcQMMMVSnl4hBUkD/jyCbaga1z//Qg2hfEJ4OYjNvo1FmzUxwY9DoxZEWjwnDVXFDV9f6DIdcqrNxzkC6ILPOX5d7YXaw5YTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB5755.eurprd04.prod.outlook.com (2603:10a6:10:ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 07:49:32 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 07:49:31 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v2 0/3] bpf,x64: implement jump padding in jit
Date:   Fri, 18 Dec 2020 15:49:12 +0800
Message-ID: <20201218074915.22242-1-glin@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.227.5.136]
X-ClientProxiedBy: AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::17) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (36.227.5.136) by AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 07:49:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa5b7910-82b1-40b9-d5d3-08d8a32974a8
X-MS-TrafficTypeDiagnostic: DB8PR04MB5755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5755EFA4DAD1E02BACE179A5A9C30@DB8PR04MB5755.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKx6XRTSXpVQfAYX7QHW6wEQRCFH5NBDA0Jqc29JMYNzwGeX68WcPlYlGmHYfFOP5Ue2VOfGgRM540bUOhylj+aDNj7KJ8G2gtKku0nYqNp8WKFgbPqxGaAG1Tc0qDvJkMMrwMjhIwIj2/Vra3elGIXfhPh5acgEAEY3Beib6qwVHZSmUCNou57oHF3iyjCzZZhgvwMtfK9xBzzuH+97cZVatHeh341emjuuV8xL0l8WdqbPH+XsR9Q48d3d4He6MVOBTNyAYLXXahTT9jDMdR9eynTuZ0AwWiTV4hlY2rSfFpMBqw0xqiPJvdjTT0XL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(6506007)(83380400001)(956004)(54906003)(66556008)(66946007)(52116002)(186003)(2906002)(66476007)(2616005)(26005)(8936002)(107886003)(86362001)(1076003)(16526019)(6486002)(4326008)(8676002)(6512007)(5660300002)(6666004)(4744005)(478600001)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xUvoUa/WriokokhTEPYL1kk/qqNGWKxMbQ+naX8kVSHuw+dYljYIbof6PSxK?=
 =?us-ascii?Q?j2BxWyyLrRgfRRVnMyG7ypi6zQutx/yGk9HBaq+9PVPDucKr5NdHrlUam3Ge?=
 =?us-ascii?Q?cRN0EEjUH/Bk2IPc1d/YyUVbWAlHLaPblJ7AOXIoV5fPfeqSufWn5OA6jxUX?=
 =?us-ascii?Q?dO/b0N4k1PR5ZIc0iGf4tU7ZxoTCDQ4ME5w8jY/cFebaYHeXu8htle98rvrO?=
 =?us-ascii?Q?51Yx2pJeesgz1gBrWgrdqSQrVBVv6dZ4wOAMMX/xSk8m9hY1aQ4hq2ZpoHfG?=
 =?us-ascii?Q?KBfc6I8dRbzhSgOEivTVH91XZYXA1LQjwu0mx0iDU/GUZ8dztPchJ0ZMRRsa?=
 =?us-ascii?Q?ZFuvW7hHi538628N59a/OgEO/Za11RwBO7z3lfLT0vC0ghepTS62G6EneKV0?=
 =?us-ascii?Q?HyNJKa1oczKvBK2UJKg5l6Jv2WiAPjYSvtzr1Cl3is5f+3c3t36/fb0yfV14?=
 =?us-ascii?Q?pox7fUVKup3woGH8vo5if1uNDQJoT2IQry8ZSNOaqzNVu1d6m5USMzuzbhfX?=
 =?us-ascii?Q?xsDErbzTrD82EJkaEndHLUIvui+uTMxTSSdWc58FiG5g1qitRM1I7/6oWsNd?=
 =?us-ascii?Q?zei9mcMlXoS87jcOKMZMczCk9iqqN/XGzSdtnJn+9RcGFhnuZiE3xMzvc7+W?=
 =?us-ascii?Q?MiYH/TAaw0wtO1YaJfSmXsv8EMeGIOhhSSiwQRtLHG4+7BrgOper3rPp6ow7?=
 =?us-ascii?Q?ObkiN5Vsf8Hp4hU3P5IyWHbTQZEVkqDaQ6W44ztPkpTrC9Frr6Xxq4ILbWHO?=
 =?us-ascii?Q?sv1CqlP3/n5m5/GKNphg8etsj/YG1qmzxmQt1097YTi+8Q9Oq52BzeYJLMEo?=
 =?us-ascii?Q?tO/Tydn+1i+2EGyCYs2Opz4L8YumUq2batXp4afNjuLNCCP8T2iAL+YWSweR?=
 =?us-ascii?Q?EcMGA5BsKw7GNiQtKzgmN9gpjMJmC/ZuUDiBytfOgp3pJpxCZFzEmLJ3YDfZ?=
 =?us-ascii?Q?vywX1yKky+6mP+BzeJTNhV8YbDkHV/bHCQvVJbEKTvY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 07:49:31.8104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5b7910-82b1-40b9-d5d3-08d8a32974a8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAmF6Ahp3Y/Us2K8tX/ufVH6UrZVeDybijGEjrppjpO+Bz+1E4yCpZ0b/zJNn8Lb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5755
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

