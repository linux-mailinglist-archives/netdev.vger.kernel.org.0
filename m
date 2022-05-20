Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0012D52EAF7
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348614AbiETLiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348597AbiETLiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:38:02 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11248BD1E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653046679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPztGPOmOg22h4lw1Ah2H1abI9PuYR4Jvou0MyiUX9A=;
        b=SYRdsrExkFeGQ/Rw5E4OQLieinMjW9Bmjft/YWsFeS5XKIbl2jin+OQ+pQKumgpM6WclT3
        5cF/ovopK0SRR/XOaL9YSl88j1X+xE3iaReO+bJPayzrB1wMW/Ut4VR8spML1RIBSC/AOy
        bSvsKpQWoTDki7NcuHIXJgrH69r31hs=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-9-TTL6mofeNoOY2KjEBUMtqw-1; Fri, 20 May 2022 13:37:53 +0200
X-MC-Unique: TTL6mofeNoOY2KjEBUMtqw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKlNeV7K9jl7cv9+l60wL/QnkN8bm4Vxpse0I5aNXbb08hfQWhfhxgug9fq8sOIKJtZTmsT1bue+xwIdPn+82XtpBggrK4ccsPR0LLdkJyk2yMkSiJGUE2g3xm/dZhz8SWhBLsnt6bpZj//rhKqlfKgayvLp/d1CreJnCUpmSaAd4/2Hl3jy0YpfOTcdJzGwbJ8y5vRCUZlHyJz1UZA89xs429mkbGj2V/16AyHFXa+AI1H7+fVUl0mloYuMoIYLwH7C15kkGD/IM887G9PPPwYb0fjmCOGhOo2cOCNy2aF0rmqtTv3KIUGRdUpR2KHP3Hk9yKLbY9WQVWeIBlZDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OEukA+AtXRqePaCqfqV1aq1pcpfZqW8JaLZRGnc8ka4=;
 b=Xbam+rvDUrIpKHCiLVu3aEueAOBR0VXMG8FXeAOvaKjh3I2bb00Z57vLaYyq25MXPLdulxFsdwT/LJQJjfDdrlgKgRswJYvAqpOWnUKrjvXY1Q+2XBonIforvlcEkIgfTyFk1vUxsmY5LkFtDE1XXkF5MaS1d1izchX/4OBsbunp1wVVKkcLxCvhj6enimHfhmQtnatreILIeeZHtlmeMFL0nQodiL9N48fu1AR46OnNZX4zapT3LoW5e0yIPFUVJaqLJuQz60rWDXL5AKXVLxgcZUNvToOx0J2o2R45vxXwODG8ikPEUs/BzhelUVZoRX1O5J1MfWcJvUhFVyvFuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Fri, 20 May
 2022 11:37:51 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 11:37:51 +0000
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC:     Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next 1/4] bpf: verifier: update resolve_pseudo_ldimm64() comment
Date:   Fri, 20 May 2022 19:37:25 +0800
Message-ID: <20220520113728.12708-2-shung-hsi.yu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220520113728.12708-1-shung-hsi.yu@suse.com>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0061.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::15) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44398e4f-cc32-47a2-ceaf-08da3a552c11
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37120A83028FE920BF235F37BFD39@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8QFGhEDh5purFPmsreZk9Fcek/VhXEuBrIkYEVa64V8XCHhF8lJ5LeoYeyuINL7taqcczHeVZABA2R5Ct6btRvFBWgxcqgb7tqe+GPQwObMeqfSje7TDoYk8gpmAXKlAC5/Rp3SNKlhYnhWQc1GtDbkjMKWFNtDlHcMJcdCF2nu39BKKE2VehviwKQ90cJBVA9LwIIfZUyb4IjIk+LzMgfhyxkPyJ2o2v4j1DudStsMD7y6FEgTisU2OW3e7ALKMN7HQsX6hpQlYHf5ACYqZUL0MQyo1Xn/3nPBdxc7V5pop6oEOWrI4wYcs6ysuhSQkCTM8GQqDLJKoo42ptYKcjCB+fv5+wn9TczA5czpHnLOkBlTWNtDYZuFJdURazWnmxwGZtMXexzfPZObzdlfBynjkrdRf5Ubrg6l5pgHJIXsyC70vte9wRloNwqlEIbvFsl0m3xW6PNUIiSqyEoRGrSMNycVOuK7bkRAkucQW97uMThujlGkiEwNRRsk464JZkYLG6M1T7qRAub5E05VxOruIHDHlkDVrntTSKUJRH2QmY7TrSRgKCFyVkoN1l4eEWKXKzMnSIOfyg7xnSOcIBTqphTI2eKYHcE+XHEw5CSAlX8key5q8q4TlrETyd9iXcbgQBfsJ/Q08tL4mqTiUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(8936002)(6486002)(26005)(2616005)(4744005)(2906002)(1076003)(186003)(5660300002)(36756003)(6506007)(6512007)(6666004)(7416002)(83380400001)(15650500001)(54906003)(316002)(8676002)(66946007)(66476007)(66556008)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y0jicYKnZ3kD+T0zbHJqYdlCr2RXVd279w7vmEuedVQl6G9R6Y/upi3KmpjP?=
 =?us-ascii?Q?OD9n+l8vJfHmKCXh/9mCmbIfqKJnVTepY9kUtLr5dHz7tJpgq5WWhQ5HwpPV?=
 =?us-ascii?Q?rSwZFheHKZAzMWclXqSLoRV1qo55EPsLWA4L59WeSupsvnmiFhQmyMCCB5yU?=
 =?us-ascii?Q?M87E8LkTcG7JUyAt/nGBw+B7oUnSkv6NtTK2w5ZFjQHiajSFKfb9N5A8T6CU?=
 =?us-ascii?Q?tQHdPE9PJW2J3IuFmw+LuAKc1K8hP3FV/WaAiI5fA1SWDv1Vz3JdRQ1JTAmM?=
 =?us-ascii?Q?m/F+AP1Grkb/Pj/sF3JvC175IMQhhm3wknCFrEFgVml7XUUmw+q7SCX9+Pwc?=
 =?us-ascii?Q?YDL1PNkU8Qt4pLVtpPd8hkvK/g2T51YfoRE9itode1WdZZJnd4wd99/NmIlE?=
 =?us-ascii?Q?ThJMCQ5gDUjFWT4ilIpD9UGGQreQ8A5tSUHuC1fZUqr3287WnPZoz2CgJanC?=
 =?us-ascii?Q?qPRN1Ngo8IaBttqGD0D/+hhzZrxQi9eU7mduEWRpR/fJpu90oZj1romYLKIA?=
 =?us-ascii?Q?dLmwVrxJo7Dyi8EF1sGpFQf/ZnmCEh4QRzdqDr5sWDf9qiM2jppAWjxk/DMr?=
 =?us-ascii?Q?a0I6JpQhQ/pw+sSv4rSeZ5mGIi2XjorGjPNMhggqF+3WeunDA5kZ4WnBPV+T?=
 =?us-ascii?Q?HdjD6fme4mlGOSXo7yedagWsx91M36BOwk0uP7TU0gWVv6NkZ+BUPTWY7fgY?=
 =?us-ascii?Q?gFAzogb9XyFxRxbfmmA7pthWV/l4YhzEKQgYO9/U5X8/Kq6S97H8Xbe57JHv?=
 =?us-ascii?Q?9Jv2hyahpMdRu+Wq8wbNOdlD9jAyScGChGUtaU6aMylvm4HhPlrTPSUuUC/l?=
 =?us-ascii?Q?O7igZzZyyMtO93ZxF6tjJTc3lA9Q1wmsbv+i5rJFaMiZiOB778zHvB+rvZNJ?=
 =?us-ascii?Q?zqDAm9ZHdcUjSVdTxR+I7HUl8p+F5BVPH2K9wCYN+QyIuE55rKxvLiSPpYl1?=
 =?us-ascii?Q?K+Cn3nYNbT37JGMKvK2+QOPVXlUGJXjmDN5VcPJbz0ufMS5ChIbBj34m4kzB?=
 =?us-ascii?Q?Qkp34SRT2wnejkdLhFPjMNh135GLEK5qp4QzZ9KiYDMxVgu1HHP+2lfTqQN5?=
 =?us-ascii?Q?GoyA8KA8OowMmMYi9RDDmDTyihir6BFlc3eZw2PJS+mXCwFO65UktPuBwfe6?=
 =?us-ascii?Q?bHIhdkbNTrzPYjQ6vT97Ov5pQ1Lp36fYfMhF1heWmhy1OiE3WQjTRu5nAZ4t?=
 =?us-ascii?Q?YPSqBXt+yj+tODbhsgLWLYrUVnXCjCVbJJmGSEOBQLWOFickV28XBLFGkJCj?=
 =?us-ascii?Q?Ai83UG8Cv56QvOyziIaTkdDvcTXR+BK2Bt2O6dL1LIuUUZDcB83aIgcYPPMD?=
 =?us-ascii?Q?1DQHHh8Kz48slavffM01zejhuIXn5OuX0PVT4yis9SyZvAgb253TsyyasK3I?=
 =?us-ascii?Q?idf6qJ+SW/ChRJbeV7MeMeoXscuV57/YI+C/eL6LVeC4+u6xqoZ01yDaoZ+n?=
 =?us-ascii?Q?ohRVZDSXYiVOGK9dQtEv2babaUx8AEu2/hF6jWdS0fsFJ2OryWbPStu631+D?=
 =?us-ascii?Q?6V+yA68Z2L5/nv9SuBGwPIuCK6oipSq4IEL0UQGVmWOkTrIeoMQ0X2bnRaQC?=
 =?us-ascii?Q?DgNJNblOGq0kKicoYrVAd7FfY3mwGC/gkLrEl0i/9O2MChxAD9RxKPnZqMlz?=
 =?us-ascii?Q?kML2nI1z1vAk04SYyLEsIii4oNcVCv/9pYG2uRirXrpMQbjuLom/etZ7CAul?=
 =?us-ascii?Q?WogFukzp1jaz1kSk50p144X7PfJqR8J7pJAIB2qkFTibNzpI6fBLDVs/iIuE?=
 =?us-ascii?Q?HVdv/6vyAA=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44398e4f-cc32-47a2-ceaf-08da3a552c11
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 11:37:51.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enBoXXtB4sqf6TiEPahiGUaOQcwnolbGMAuFY0JqMPfJXACfxtm90vap0HbkmEyQpLlSGZtfvsps7GRc0ysdiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 5e581dad4fec ("bpf: make unknown opcode handling more
robust") the verifier also checks for opcode validity while resolving
file descriptor, update the comment to reflect such fact.

Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9b59581026f8..79a2695ee2e2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12350,7 +12350,8 @@ static bool bpf_map_is_cgroup_storage(struct bpf_ma=
p *map)
 		map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE);
 }
=20
-/* find and rewrite pseudo imm in ld_imm64 instructions:
+/* check the opcodes of all instructions, and find and rewrite pseudo imm =
in
+ * ld_imm64 instructions:
  *
  * 1. if it accesses map FD, replace it with actual map pointer.
  * 2. if it accesses btf_id of a VAR, replace it with pointer to the var.
--=20
2.36.1

