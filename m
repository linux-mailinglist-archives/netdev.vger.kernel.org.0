Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4EB52EAF5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348596AbiETLiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348620AbiETLiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:38:08 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A29D412E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653046684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHnRwheJspQkmn76le7EVGLtzqEbStJTDz8H7sbZgVw=;
        b=A3t/xGb03rY1kTN1ZQGPO0DKdQxLmNPJzbz27u+LueqJeQO2r04TwZN+38LmBtc4/zzcN2
        s4it6w+ykDhm3/6HBHVar/7pcXLrt4/yQM2NrJrudC6AUxMLpyKh9r/VEN1QFB5jIoe3vq
        WjbbEN4lAMp46WNOgnZ0MiGBePz0q2o=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-U6tm6fWYNpmLyj8qCHWEew-1; Fri, 20 May 2022 13:38:02 +0200
X-MC-Unique: U6tm6fWYNpmLyj8qCHWEew-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBU9AgsdhvKGoD2Ss143EGsuOAm3wcPJQ/d31DISwnU6Yy08mlEOwYNhTribABWc7nrocxmMZ81jQdTislyBB9YNTHGKuY0Vf7/dK8fJgp9DUYUSIMNKzGYnWj+U7MOoPvCL3WYgsMbBjaexmZX8fP4rmZWreHsdsErGnNbhfSSY2YO2JlfciqeAR5DPNGS4BDdjweU/jC6hA2gPpaF2vpNwczmvBXwjN7eCrGPXb4RtCgUaQVvrOERolXTzMXDdgjK7zKVJMPkmps3BUrkRB6zBIvvhkrKsTgOof54Ktf3sBEn7vfxlh+YN2BKROQlX4+YAqoZFr/YNYq7bkOFemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PSMqY10e5/tV5vgnADjiHQ22OyOLc3AAhVtw02N+Dc=;
 b=JcdWGNdKzM2iX6eq4t21MoVQoSGKKIyNFptNy5JgDmumre8OuRRnuJ90CYUIzaLu4csP9cBHzgR8ywoUcuy7tOnObSTfZGkwq7iFmmpWdvICk54IPhOy2oQll6FLbZ2vGxqNtD5mCD6nu82U89jA19GR7UmwpuLiXAD0MJ+pTfPBhmGv22v008dgN9QoWQk0dcfnplbfaj2hcQnwytZUAhUiHEioMHB8ol10U83Um0w9i12jFi0PxAcJQTmKxWVWPwFnvsMrgW3Me6Na6bLOkQJgD81kffWykbpa7ss0LlL+99oCbh2MLCxwe/7E9AN8ZyxU+oVjBg83jUX3JBDE/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by DB6PR04MB3253.eurprd04.prod.outlook.com (2603:10a6:6:4::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Fri, 20 May 2022 11:38:00 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 11:38:00 +0000
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
Subject: [PATCH bpf-next 3/4] bpf: verifier: remove redundant opcode checks
Date:   Fri, 20 May 2022 19:37:27 +0800
Message-ID: <20220520113728.12708-4-shung-hsi.yu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220520113728.12708-1-shung-hsi.yu@suse.com>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0076.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::18) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9124e83-b4d8-4745-ec1f-08da3a55317a
X-MS-TrafficTypeDiagnostic: DB6PR04MB3253:EE_
X-Microsoft-Antispam-PRVS: <DB6PR04MB32534BEED2E8F5FC97B866FFBFD39@DB6PR04MB3253.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+fbsS2Z5m47LoqeIAdyn43XtDtzQ363CaEw5Sr+xKSHWohVQIxJVFmAfN+2Grm51i4I/3kbusIIm9RWR121kdSltxlK+g5uSdUF6YPoBWjZb94iIfhvHP80z6SLYKGSAC5k7AY5iWww+MNypHf/qvsdzh/6huzdWjhpw2sD7PRq+vwiLQlTfUJf7DzJDiWZLy2j/v2b7M8P490JBwxo471Zk50OIEqetdW5M2rWzZABiom5zE0vFSrdvjgOrk7YBOJuZ2xJZSQgS78d2Bc3trJRfnSud6kwierOMRxlq5Jhqejus1ksXYtxo/9IJ+RGjmUnB6Blu54mUrm8Ul3/9UFAbn8fY9oDywzDCQWxMO0BMYDaQuWtnJfrGHn27ULLxVMnHDdqrXhVr7VWwpwh4LFsP2Wk9aS61l/aaVClIJfH1nS+l0DHgXZaVNry1b0VmZAvplMcGO1g8vXfrCn2uxj6R3zyeICGU2mtsqfZkGFlz/RTg80d04BX9VIqf8Zrm+zJO/ugvVXuF9jszijjIKGlFaxsJNdQw6eikLnzhCDo7YHd/TtF3NcA3wvPU93WjU+kVRfLYr1z+naNqpLBzsBEvMwSFOmB7T48eQnDeM4cN9Yrd+6tQOvAtNbHL7ImwnKuoqdXMhiz1RXR7T0ZSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(316002)(5660300002)(66946007)(66476007)(66556008)(6512007)(26005)(508600001)(86362001)(1076003)(2616005)(8676002)(6506007)(54906003)(36756003)(4326008)(186003)(83380400001)(6666004)(2906002)(6486002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x4mJRXkZ6vlV9EWYhl/py8/IwTpfRWWa4thujcTORrvm71/iqrAoNipsWDBG?=
 =?us-ascii?Q?deHvVAtiZSFCCxn6gyC2m0zpttj1Yopfbkdy1HX1uLPLmpSkI958OQGOj+vX?=
 =?us-ascii?Q?hJkfvUuUc/i8KGeVjd6Jsnnj6X7WC6UFSYgIEJ8ocLHeliPQRPbN99FiA2Uf?=
 =?us-ascii?Q?DInqkD0S6meO+gkOgYZ1wMI/0MqVTsvYL0KYLLJKUYgEqX+/sQERgFGYmgjY?=
 =?us-ascii?Q?VATFMYu2QG0xGLYhCxNVMZaTt1Q3jzqAh8qePIznGm+9eBNkTNB144OmX6ME?=
 =?us-ascii?Q?bRVmA0IWHg8LcoJYnbpMcdqCn5yD6iQ9VJoVUXDbcv/Q4DPLMQxWaAD8wF1s?=
 =?us-ascii?Q?1Fy/4Q6pmKwlRe/LcUV36guUZv0ncy6KyV3oQRBeQvihFpgpj98IaVa7nOZC?=
 =?us-ascii?Q?LifL19fN0tmZkwqroyf7ee24eQsX0X2jAdIMpO/WdBaDjFaCx5732LnmVtG/?=
 =?us-ascii?Q?7PLnQ0QTROKTAC5xjJPpRGkZaIisSb2ADTJT8wHW00a3R0fkCO05UCXYc/w6?=
 =?us-ascii?Q?Fx5dFWBDY/vzMn8Q8Wp/yczHNlU71/z7iiY8g9u6z8CrDsdVYskVDhlJ7OEs?=
 =?us-ascii?Q?yNcnjQEYwolGorDWA3ceNyWYcOzFLQ/+MXEtX+0RoJZjTATKDbQFrxI/E+HA?=
 =?us-ascii?Q?P9sgyS6eltrsK72Istnky8bi4hShQwBBnNuU08gFVJV97WQiIE9NrMO0lLx+?=
 =?us-ascii?Q?lcOjul0VA7ZGVopK127jSBNCro/ixE65Nno8ODyjHVFf2gQ7KhZ8w0QBXnCH?=
 =?us-ascii?Q?d/LXIbMX7nvbak4OVjezD5wYx8Xun9URXiqgwrEfupfLufnoQSBT7pyQUX0C?=
 =?us-ascii?Q?ElxeZooZ2ovRyTQHyqfyGM8CVOayoD8T3g/NkH7B6EhPuPwX6/QIrqXuW5pu?=
 =?us-ascii?Q?6qT8yP8HVsaKS/3kv+wspaS0Vh84lfOVwWAMk10X+53O6MB0g3YozEsqde+k?=
 =?us-ascii?Q?HC0XTEC3c/vOxsPOk/fACLUIBVBqohIuxkMu4zbyIRlPv9bD4oVzt2t2tO9n?=
 =?us-ascii?Q?WsRhD3H5P5K03ZEAmXgSXsOkjHCd1TWT6bhluct9TBOptL5CzSEFxG1hFm+T?=
 =?us-ascii?Q?JxBl1KSxc67wkHN1k/eMf3IptN3Pk6Myu1TnHTgBJXXL/Sem48MWjjoqkh4P?=
 =?us-ascii?Q?lR4OzBMMLCPp06s6jd58FcDuMSz69nfVGg5sEqq29yCA3IW/AclFXWMWXqdV?=
 =?us-ascii?Q?33zq6EOOVGm30wUdwLssL/VwX0VtM4WA30xqnuRm90YFarjJFGiIMtfjFHi8?=
 =?us-ascii?Q?lm2DJ/MIosKJ4xK1BLaq8RsaAx6Iunz2nk2SZdOwgVB7+fWDY/Fel093P7Bb?=
 =?us-ascii?Q?hoZA6T7dnsVihAxTvkglKCr0KuGDXWTy98/sMrFJNHNLg9HMi9jPHEZHL6je?=
 =?us-ascii?Q?KrBaNSIQesDhGWW0fpls0SqLwDeSvi8NsujsoYimKwfc9RXn5hZ+4fHdcaIz?=
 =?us-ascii?Q?MKcQzxIdiyqtZCeClFFrbVo4Cdfwr9PV3MVIAkDliKrqJk/iFeE/iFGoVvfx?=
 =?us-ascii?Q?VsYv/n1Dkqsxajr535jTh4/1+eGBWy/IUhvPs6TaRF5gzBrpc/rdyoa0DuIG?=
 =?us-ascii?Q?vihGnRhc97Wv3oK4QLxjSZw7don9rZxDRJG9lDj8VG5eIUoW7pzXlGKzR3gG?=
 =?us-ascii?Q?AYufl/tSxJtUY/pkkLuM51wA8xuqxv68eWzojVw3CWaZqO++6pxQ4mht1Yue?=
 =?us-ascii?Q?9RrwD+aoH5U35YyFb/jjJM/AGluj+Yr8awg+jvKi5Ozu4u2Ux5RSFGlPixh2?=
 =?us-ascii?Q?Wl3V39OUDQ=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9124e83-b4d8-4745-ec1f-08da3a55317a
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 11:38:00.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHSqXRmBBPy7JQoYiyus/x4blOO5ezM1G0HVO1LxBoFOtL+Q2NyOigE/UdzcLWEUpm+5GdsbLUez330wPVCi8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3253
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of opcode validation with bpf_opcode_in_insntable() in
commit 5e581dad4fec ("bpf: make unknown opcode handling more robust")
has made opcode checks done in do_check_common() and its callees
redundant, so either remove them entirely, or turn them into comments in
places where the redundancy may not be clear.

Opcode code check is not removed for BPF_LD_{ABS,IND} in check_ld_abs()
and BPF_JMP_{JA,CALL,EXIT} in do_check() because they cover opcode
validation not done in bpf_opcode_in_insntable().

Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 kernel/bpf/verifier.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 133929751f80..d528848083b9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4797,11 +4797,6 @@ static int check_atomic(struct bpf_verifier_env *env=
, int insn_idx, struct bpf_i
 		return -EINVAL;
 	}
=20
-	if (BPF_SIZE(insn->code) !=3D BPF_W && BPF_SIZE(insn->code) !=3D BPF_DW) =
{
-		verbose(env, "invalid atomic operand size\n");
-		return -EINVAL;
-	}
-
 	/* check src1 operand */
 	err =3D check_reg_arg(env, insn->src_reg, SRC_OP);
 	if (err)
@@ -8793,8 +8788,7 @@ static int check_alu_op(struct bpf_verifier_env *env,=
 struct bpf_insn *insn)
 			}
 		} else {
 			if (insn->src_reg !=3D BPF_REG_0 || insn->off !=3D 0 ||
-			    (insn->imm !=3D 16 && insn->imm !=3D 32 && insn->imm !=3D 64) ||
-			    BPF_CLASS(insn->code) =3D=3D BPF_ALU64) {
+			    (insn->imm !=3D 16 && insn->imm !=3D 32 && insn->imm !=3D 64)) {
 				verbose(env, "BPF_END uses reserved fields\n");
 				return -EINVAL;
 			}
@@ -11874,9 +11868,8 @@ static int do_check(struct bpf_verifier_env *env)
 					return err;
 				env->insn_idx++;
 				continue;
-			}
-
-			if (BPF_MODE(insn->code) !=3D BPF_MEM || insn->imm !=3D 0) {
+			} else if (insn->imm !=3D 0) {
+				/* check for mode is already done, so mode can only be BPF_MEM */
 				verbose(env, "BPF_STX uses reserved fields\n");
 				return -EINVAL;
 			}
@@ -11909,8 +11902,7 @@ static int do_check(struct bpf_verifier_env *env)
 			}
=20
 		} else if (class =3D=3D BPF_ST) {
-			if (BPF_MODE(insn->code) !=3D BPF_MEM ||
-			    insn->src_reg !=3D BPF_REG_0) {
+			if (insn->src_reg !=3D BPF_REG_0) {
 				verbose(env, "BPF_ST uses reserved fields\n");
 				return -EINVAL;
 			}
@@ -11944,8 +11936,7 @@ static int do_check(struct bpf_verifier_env *env)
 				    (insn->src_reg !=3D BPF_REG_0 &&
 				     insn->src_reg !=3D BPF_PSEUDO_CALL &&
 				     insn->src_reg !=3D BPF_PSEUDO_KFUNC_CALL) ||
-				    insn->dst_reg !=3D BPF_REG_0 ||
-				    class =3D=3D BPF_JMP32) {
+				    insn->dst_reg !=3D BPF_REG_0) {
 					verbose(env, "BPF_CALL uses reserved fields\n");
 					return -EINVAL;
 				}
@@ -11968,8 +11959,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (BPF_SRC(insn->code) !=3D BPF_K ||
 				    insn->imm !=3D 0 ||
 				    insn->src_reg !=3D BPF_REG_0 ||
-				    insn->dst_reg !=3D BPF_REG_0 ||
-				    class =3D=3D BPF_JMP32) {
+				    insn->dst_reg !=3D BPF_REG_0) {
 					verbose(env, "BPF_JA uses reserved fields\n");
 					return -EINVAL;
 				}
@@ -11981,8 +11971,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (BPF_SRC(insn->code) !=3D BPF_K ||
 				    insn->imm !=3D 0 ||
 				    insn->src_reg !=3D BPF_REG_0 ||
-				    insn->dst_reg !=3D BPF_REG_0 ||
-				    class =3D=3D BPF_JMP32) {
+				    insn->dst_reg !=3D BPF_REG_0) {
 					verbose(env, "BPF_EXIT uses reserved fields\n");
 					return -EINVAL;
 				}
@@ -14751,6 +14740,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_att=
r *attr, bpfptr_t uattr)
 	if (ret)
 		goto skip_full_check;
=20
+	/* checks for validity of opcodes */
 	ret =3D resolve_pseudo_ldimm64(env);
 	if (ret < 0)
 		goto skip_full_check;
--=20
2.36.1

