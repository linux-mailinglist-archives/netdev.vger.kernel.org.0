Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D8752EAEE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348586AbiETLh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348565AbiETLh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:37:56 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD548BD04
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653046673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mGtsbrPAVQDl4GgRlTmQzOytBAcHE2v6RovdI6bzTKk=;
        b=JXfzP2qNyxbMXin5e0/khh7m2UN4A0bWLXFOj/XRK0IzoLPphIKrBAfdumpuKeR6S0CO2E
        UCNaw/IVW99EYW4qTNXvpIZxwrtb9HkqT/lfvIMKInDJhvfttZAJxhmAZkOcKUDVRqSC8Q
        VJzNNYWrdTP3VgAyeLZAv1YTikGTlqA=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2059.outbound.protection.outlook.com [104.47.4.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-37-hdLN__zkN4K8r1Y_IK3Opg-1; Fri, 20 May 2022 13:37:50 +0200
X-MC-Unique: hdLN__zkN4K8r1Y_IK3Opg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hd/GMtZSQ+bmVFpk79GJl/eFnru9c9yhAASfEbSrRuQmGhR/beRRoSqRULsSNN8NA+t58eVCTrawUiFLaddhcue5Efikd8/d5DlQaac6rbS4tcuS0YGZItYRT2VknNr/MHPE3AcBvZylm9KE2htsUBHFvI9aU5vT29HZOvXi/TlxwxBZyXbyDr9xPzHWj3nqQdgXJ2RbodjOM5ljXiTIR1z2Y9OWOm3+ZT8RgFGZPu7iwhWiuK04lBvYaywSZpLhMAHVcT6Qhy1dppK5iyh5j0HGS/sXW5vdvMAbS1bRtBn5BkWbeC7X69qIzS53XWFA2GB4fn65+HDScOnhcaFKpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=put/l3a8uBpnPjDFmJf80oTC3KanlUOtTDNgrobEPQg=;
 b=XXYF7BHG34J8/C36YahzXbStQ1MxuPq8ufvxQmcH7J05ftpdHWaWkqZfVjAR0/9W6xtpgJeQySUkiSenwKyY+d2dQ/Z+h9dvDnYZq1JDix+4/TYK22oXRbbDzY8aJMYT6EXsLreu/W7t+O7aWOvuNLj8QkF6cLbvg631FviCulx/Ml7RxFeiXcJEclAEjnUNSANUpEZH0uiWyBm6/RT35gBAqJdCn+/keI4z+fDspCQd1E5/9BNMJ03I5NdfAEhqSgBzqa93YY3YJmpiPsMRlh9vL5GdVXl6Albam3mxozMRQSU10PfPsg9idKaO4ieDMgIjTDXG3Q0DVrE8+PJ0fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by HE1PR0401MB2297.eurprd04.prod.outlook.com (2603:10a6:3:23::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 11:37:47 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 11:37:47 +0000
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
CC:     Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH bpf-next 0/4] bpf: verifier: remove redundant opcode checks
Date:   Fri, 20 May 2022 19:37:24 +0800
Message-ID: <20220520113728.12708-1-shung-hsi.yu@suse.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0082.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::6) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b1c26e2-56fb-4bf6-1803-08da3a552989
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2297:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB229772F83F48079FDDD82C73BFD39@HE1PR0401MB2297.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUCKup57i1A88axG7/PTob/+wr/3ab8IDsoptiqYQ6w8fe8PwJoF5xCuMlo4deVGuvPxJ08MECLzl3ez0QEp30DZHJ9kXjM9QtXekKIYqkLj1312SITCDr3943B9ZH1awTUNYVbTgerUuyp1hYRIjgdcu8nDXpr3IE6/IzNABOC+Z4uNHu27iGVD9C9Lmtz3AF1TczB5cuo7ho7JcVySt7VYFyYZAREMfeiGyiTY44q6F90fwdTeo/YscwU4B/dMcOn/GKOtkb0KZrvLJLtqKx1iSRigvhBjOmC4jCzfdDKex7whT2AEBCVHyl3VQ2PQVeDedYoAvtxAtWjD+1tIVyRPFIEripBrjcig8w6jbMSbGOfIEVvgQHqtC7F9AR6PhvNWbpMFjbB/ARasRwIEu/YIT3KPpBxwjS+ZPhYrPTztb4jguy1Ogbr2NilE7UC11xBx6Rt7G89cObyOO6i2VKAVvPiZrQ0NMrFZ+/n70fk14W4Mdf9JJ6sYi6D2f2DBR3XYzL43Ip20ik2/hTQ/BctTeqraMp6RwMh9XUfadf3xRZoOCUYW+C98zbbso87NAn2LXyj9Ad1So/EWtqS8L9m+2mfZ+GfhYpNp7HlFNb81gsNGxxAAuc/CWmQQiS/O178ugjHystftB/f76pw8uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6486002)(5660300002)(7416002)(26005)(6506007)(6512007)(508600001)(6666004)(36756003)(2906002)(66476007)(54906003)(4326008)(2616005)(86362001)(66556008)(8676002)(66946007)(316002)(186003)(38100700002)(1076003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zga13PmJo5TnWzFFOzjAuIfGeXYcl2AsIp/Xl/558ndfHetw/nXxCI9bB5oy?=
 =?us-ascii?Q?sOgVIhhwiuXM4gXeLr5aTrnHd6ieDOLCA2JNyNoFtAcnUDS5rc/tMPfiIfM+?=
 =?us-ascii?Q?foQEFQgPJXt3bm1m8utxaF0GOqIRBWmALjMIdjWBST2Nv8RpcgF6w90tm6qc?=
 =?us-ascii?Q?Usxg56C29eLkbB4PinxZnxiMEnmFu/t7gZz/7iPtF7pZBHYbu89wzyGJqNXo?=
 =?us-ascii?Q?xuJ6BqJiD1Ji7DLcS0alAFxshmqd/c3fpIYs0sHCGk4wtGYYJ221JvTv3jj6?=
 =?us-ascii?Q?JiD0H5+GcqKZF+H0zOI7DMFIcMLCEnuNI4uA8QTC6fCirhOvA+eh4feYwi/P?=
 =?us-ascii?Q?N1CQTFR7U8tKLvaLJwRJGky84TGCCDosrYJHrdM/vJSlYxcJcPHZHwl/d/55?=
 =?us-ascii?Q?ut3WgvzBZeOS5mqVZNDIg2xRgB13N2EXARiM7TBW+Y4/ENTz7iNFthhoSBlM?=
 =?us-ascii?Q?jMR1ui0ZU/qoJBgGcGYIpjxqRhIyxIQKG1ykIIQ7sTzWuvEyysDzxrvqcZWl?=
 =?us-ascii?Q?19XMt7poUBjYNc0Y7mtLRRZeL+3JXpDYWaIH8xCtzPWVrXs14V8ojvLSUNyA?=
 =?us-ascii?Q?rKH0kQSVuwpJoncojLxqzLe2lzFM9Bq1zwB3cZ2kh/fnSCN6rTqu9s6RQWFE?=
 =?us-ascii?Q?FgiXSoUSQM/1Sf3ZH+VzkPGZeOE8Rc8cmPxOf2ZEfLOPFTPK//YaDuk5fSST?=
 =?us-ascii?Q?sk7gptbPK39Rx9T8MCrdcnCqegpig5/jL8GELziohbSLV1nMnrm+1ML8shR8?=
 =?us-ascii?Q?2kRefRjk7rhZFTi5rgtmjP/czCuGv2c7j/VVR5d/oiMSIcpAZQOK5Q7qpFxh?=
 =?us-ascii?Q?svLlJtgWd8YQx0BPABpdeBqy8F3ol89VYyCzIveTnEo0fXhjBmLDdc3tEUI/?=
 =?us-ascii?Q?VjOfH8UYJMQfndQxqzZ13mUVJ1TH/YrIvSfT4+o0z9U2jel2WLRM+mOLMPyr?=
 =?us-ascii?Q?DBqTleFeuLV5SteNNTrMluagC89zmlQJYcr22xm2cdVte3VvSX/ZbZ2QAiiO?=
 =?us-ascii?Q?OsqnuCQbu52nAiP8aotzcYq2DEbsKuY7FoXjVGiH4zf/Mp5jj7DO2BnJ2sVL?=
 =?us-ascii?Q?WEt5Rdq+M7C6+UEabeAri5+tN/n95d98Qdk24au3XGciAEwnfThDXfrP7UKI?=
 =?us-ascii?Q?PEB/Ki4SWqwzeVpL7NieAH3B5Ag7PmV6Q18P/pdDnNPmotiUVJ06ZTu+t7gX?=
 =?us-ascii?Q?JlXp34LIWv4e0d6dReZB3EbqzrsixZ8weMt3Bal7CA5y5CxZcbLrVdPEpn3U?=
 =?us-ascii?Q?uEuSkcF0ePE/84Uomsgo4odYoXYiIc2PSyanv5CdGm2YKAwp0k1bT+lylxs5?=
 =?us-ascii?Q?cPxmjOoZnIIh/NIa5RJjUXA4y+uBuWwxhfj9QO+M1W6LG3BoYVMGQ9W762qF?=
 =?us-ascii?Q?h72oyGiHnqDLdlZ5oW9omp9ubLfn0Pa2rQPn1UehQxc8lEJv4k5NxLKl5sNL?=
 =?us-ascii?Q?KUzb3Fe/i+GeO029ftTaqftRMBI33SHgTMTjBnnaxyaa0LG/fbaN7V2hy4/N?=
 =?us-ascii?Q?k3ImRMWgwoLV3eyvv9wAebmRLVvTYhcv2RLFT9ZrXX4jx1rxsSfJLMEXjOPp?=
 =?us-ascii?Q?V5A9E4piiCdm2Awzg67BVkIF9ebPKnvJ50mKPOMDNwfhAkAL+IIkO3NSByHh?=
 =?us-ascii?Q?NlpREWuFpTgGlJZ+oqUuT4LDcMKMgd3mJP9s0DrBLBoQ14gGxRCbgyZ1joMY?=
 =?us-ascii?Q?nym5e8AgxgnpYRXDBzG1dn1ZnmzUMFFBGMWqRhNCXGEz3xsyUZhCY4zc2auH?=
 =?us-ascii?Q?JSuTrP4C8Q=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1c26e2-56fb-4bf6-1803-08da3a552989
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 11:37:47.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7PgS+rjxOZgN68nV2VEd9N+c+HQ9rfVuANCd115SURji+14j9I5RUJxGWYKPXxs4hw1yvuajY0z+2zaDgTbHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2297
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set aims to remove opcode checks in BPF verifier that have
become redundant since commit 5e581dad4fec ("bpf: make unknown opcode
handling more robust"), either remove them entirely, or turn them into
comments in places where the redundancy may not be clear.

The exceptions here are opcode check for BPF_LD_{ABS,IND} and
BPF_JMP_{JA,CALL,EXIT}; they cover opcode validation not done in
bpf_opcode_in_insntable() so is not removed.

After apply the patch set test_verifier passes and does not need further
modification:
  Summary: 1348 PASSED, 635 SKIPPED, 0 FAILED

Also, add comments at places that I find confusing while working on the
removal, namely:

  1. resolve_pseudo_ldimm64() also validates opcode
  2. BPF_SIZE check in check_ld_imm() guards against JMP to the 2nd
     BPF_LD_IMM64 instruction
  3. reason behind why ld_imm64 test cases should be rejected by the
     verifier


Shung-Hsi Yu (4):
  bpf: verifier: update resolve_pseudo_ldimm64() comment
  bpf: verifier: explain opcode check in check_ld_imm()
  bpf: verifier: remove redundant opcode checks
  selftests/bpf: add reason of rejection in ld_imm64

 kernel/bpf/verifier.c                         | 33 ++++++++-----------
 .../testing/selftests/bpf/verifier/ld_imm64.c | 20 ++++++-----
 2 files changed, 25 insertions(+), 28 deletions(-)


base-commit: 68084a13642001b73aade05819584f18945f3297
--=20
2.36.1

