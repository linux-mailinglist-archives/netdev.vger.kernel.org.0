Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95FD52EAF6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245084AbiETLiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348598AbiETLiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:38:02 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3198BD29
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653046679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pdKUfi4l4rSLwtlUmzGsGCFvVvE2oJIhV/wygh4mIpo=;
        b=juqwbdpOGRM9tvX0jgsdfA/c5LzD4cdf6jYHKK0BoCxApRX7jkpH8G30RWUI9rzdbcx/Jv
        LxG19APREE0GLTehASWhBVMBY4P5XResKmuGMVbtx4wlrDF08kpd2rQQ94ksT04J6n9jHt
        7GBgyKtc5UFMuW+DmkSzC05ShPby4UU=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-15-c3eyB47XMUGOHX439qwigQ-2; Fri, 20 May 2022 13:37:58 +0200
X-MC-Unique: c3eyB47XMUGOHX439qwigQ-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MS9zlRjL56gb1vEf/KA97ZAmY6A6D/Yrd4qOKN+ejr9mBk7Vix0RHd8tudCxwkZ4ubcmvse6uAOReRZ6LB/3Iflnt91L/sSLKzdXVvG1Ch9XgIAp9sITbx5XR4NuIgv+rGOlT2Kk7nD0MVFMVvgNZDumOhZHK4czdSQRfrS6NYmR3h94sNsoFJMnP7mzkbB6cBXNNIwKV/fF6x6xM+Y0LP+jGWpJd+N2bzvt7pKkY7dLv7uV6FrTYHKJ137c1SZPXjTjIpx+0HYzpKrOuAnBLXFD0EoNtnCXHWs6nH3shZCaQ8Zj1sxFQyYK9NYYXV42pEK7R3xkU2ggodT3u4h7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLPug2Nzp0WH84UFjUq7M3TokQjw/w9qo9KxZ/ei0hk=;
 b=e7XdN26A/R9705GTsxOC9CEpFJNbza275iLy+59bFKfwE51hSS84w+lYwPedl6QKbYP4RAm6prAmrYCkII7ple6oOJYgcT5urznCPs36r77V7xV7aYDj8UWQnzV8BBUFtXV8+SJ+qycNO70F2np9VJeY2cJkw23TzMzAdnvARQB43sQ23MSNVQuwsP1vihwqvl2umBIBSRQyIcrGT+89cuVTUF9qe8amK0NOKHi6eEZ3e6ZMpA/gIMJ2k0FlGcQW8KNrW2aUKlOzhwbSYmySUVyx+2JjRReSo/sFCk2qLXhu8kGjSCjn7mns7+QwT9FWRTz0LBmV+zH7FXsso76ezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by DB6PR04MB3253.eurprd04.prod.outlook.com (2603:10a6:6:4::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Fri, 20 May 2022 11:37:56 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 11:37:56 +0000
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
Subject: [PATCH bpf-next 2/4] bpf: verifier: explain opcode check in check_ld_imm()
Date:   Fri, 20 May 2022 19:37:26 +0800
Message-ID: <20220520113728.12708-3-shung-hsi.yu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220520113728.12708-1-shung-hsi.yu@suse.com>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0080.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::28) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3d3a47b-e156-4503-f524-08da3a552ec9
X-MS-TrafficTypeDiagnostic: DB6PR04MB3253:EE_
X-Microsoft-Antispam-PRVS: <DB6PR04MB3253E1DE9A2179BF3D13134FBFD39@DB6PR04MB3253.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ffo7w+TXODKNiLvqrB7xXgddsoZLRIuIlJ1HEQf5IsILOYsHfU01UZERaTJk9adpFVBpTTvn3LHD5OAtoIO0udBQKBjhaCfmN4um+9+xhfKhEb+GkPMuJl4DvICZjNp7rngMA1CdbN68eWwiF2qY2mlbQTW/9CGH1APyIVQU6TsykvxHMPL8UYenm3pWczekPfF2q3lTv6tg0fqTxoIXs5XyvziAj3qRJGsKq/IUNE4m1S/JH2mJucQYFJKaH56eHF7WEuTEAl0ev13lR8ZvtPQnh2Vq6guuagcza8tUKD54C4oUwi74t/aYrcIq1A98ErEGDh8FTwWWhLaV5Yd+6INwHJNfao9uTeITIFfJxu6t9T8FLwT/N0XAfb32Za2qe/Sh0sslJf++OvnKkx1QBc8zsNTsi6tPUYXKWX7GBt4MUp7ZTjF2HLCTgUu5zcNDaVBObqXu9w33kVVsOKjQmP2F0/XeAOeiJILIyJKUCfrFPlmFv3oGyFxJHML6iwHdHa53jlUVjS/6tEj09koMLgauzD0YbVpdtXr92zOkhaPw4PqDC1Wy7efoaxdHlrTvcy/QCU84AKbL74yDBas29esqS8ITzvG2QPwfvDf++5HfVclNBLmrQMzb+lPw3yLzCGfVhPJ23oe4euRRlPuVVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(316002)(5660300002)(66946007)(66476007)(66556008)(6512007)(26005)(508600001)(86362001)(1076003)(2616005)(8676002)(6506007)(54906003)(36756003)(4326008)(186003)(6666004)(2906002)(6486002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2gJ05teQjU4KSUTff8mCtagtPpZgEbIjgl7I7MXD0LgaK8aSv7LdOfbyVP1U?=
 =?us-ascii?Q?VmBRX0DiZlBhuLiznPb6JPxMzW3Xijj4o0D4SmpCsZF4091cFUiE+lw8xe/u?=
 =?us-ascii?Q?gkiI78yyK68f1oxM+E19G5aI7idsxBL0s0PNMmHyxxMlRLXI6aGPGgRLRsTg?=
 =?us-ascii?Q?rf92pa8rgFhWACEQOu4NZEQ2Ehr1IUKY9Sy0a26kWv0sP1TeLiYef5rVJLlE?=
 =?us-ascii?Q?SO0u/a87gs0zGRCTP6ubzsouAyAX+XuWkjH6ck6vWx3JD06pKlP9e/XSuaJk?=
 =?us-ascii?Q?Sncc8C3dLslM8W9Pe0iq3H0ETFNtT92ZvDB4swzzC93EBNb01gSaplqGAcR5?=
 =?us-ascii?Q?l70YvaIxzOZkjBXKi0JxFsM9sWHVoItlYq5u8UyK0WmmyKI6mSmKax4NF39v?=
 =?us-ascii?Q?xYh+scn57QzD1gJIw43xmgduQ/9cESH5YA5VstoB9EiPOESej45CGaXG0apM?=
 =?us-ascii?Q?+LG0rSE0nuICFtnktAGdJnHBYyYajVjomzLtvMyxGxCXWEAJQsqeMAdsTAbg?=
 =?us-ascii?Q?mlg6njE2e18oE31OA5y7sj4ikGxz3ie7b0F/NUyvTw4BmLbxXYTdLULbFGBM?=
 =?us-ascii?Q?CRNjjiMRGzZan5SmQLTB6bZUUV3wjD75xJipFBWDrEsR4T8KED+oYelapxDx?=
 =?us-ascii?Q?1xiZUYhhfsgKlHE6gYH2Z6iR7F6DKQsKit5APvKb+1kG5dafS8rAKS4QlsA7?=
 =?us-ascii?Q?mCniiHFb0looMmIulkX9EYICCaYnUG7V0AZbx4mQ/YZMCesTh5xOtDL3mQf2?=
 =?us-ascii?Q?RKm32su000yOCW+N60xCL1/lbLFURVOx+WGJykTWi6Ppxo00RCrc/dPhuxD1?=
 =?us-ascii?Q?Nrv260oBclEgc5+nG6fMJkNw0tHJdQOcPbQCuhWfH3c3ftf+lIHP/lFIEag1?=
 =?us-ascii?Q?JXmgfyRgZZmZj73ljcfn+NVt2pjndxvg6+2IpoGwL5gj47yFD/tyHDgnnbtA?=
 =?us-ascii?Q?Wj9DaSAye20ESJmu0aIoeduqW7mo+pQ9s/8WLjVQcrTL10lBVfHkeYCYPTJl?=
 =?us-ascii?Q?Hf4tJMzug/01tSywF8zoQb7VtLMG/AUzXSEV8kyQfb44+DGUWMCbmMkv1pOt?=
 =?us-ascii?Q?isx/nGS99bAFcLnvHkSfFeR35U0YUrybeeQnUnjkdvBITAd/3HEVNrf0hi5D?=
 =?us-ascii?Q?+o4W+WV0706ycK1C8n4RVgGlBha8hhBzB1BR2luiTuQfJxHJ/0cqtIC6vjud?=
 =?us-ascii?Q?UAIwWuTqBrk7gAg+wI9BX9RVzBUDUKMCHJP32mXnjVcDk9+XX+IUcpm2Vrw1?=
 =?us-ascii?Q?WMqvMtFrnPW0Xqpu2vZa9agMQfFUAj2boY1wWykD14l0gMQwubAPbXiTlbbp?=
 =?us-ascii?Q?tdHPcfXN3jTgQPWFhdiFGcNMtQXla9fbFiclzMh+Z4S8pwUG04CnO3A4OOf3?=
 =?us-ascii?Q?RRONUnpGYLM3rz5++fLnL48YycxdHiftl1K6DUPuGJ7ujq6T22r3YpZ8syMx?=
 =?us-ascii?Q?2Z9+z/NPdlXYOdaf8ybfKNMUW4zM1RpHVVDiDcrLqHuUTXVdp8ey1ZPUnQg5?=
 =?us-ascii?Q?e9mAjEXizjkO6YI2BtnSjndUncbeTzqzMTelD2vpwhF1Bi6brLUyBkmPYmkf?=
 =?us-ascii?Q?RQF091kdQ9BG7UBHt6yqdPVKeH70l8NMEM73LKS1y+CWBvk/CKHLiCSejXVz?=
 =?us-ascii?Q?DIuXozteNH3yCWwET3d+I6GGUu8LrYHwHjb0zWd2LcsSW9G8D4aM9eLjER12?=
 =?us-ascii?Q?AD40KiT5NQAiNQPB7IL/X7SVIhg6dRgWW5hk7mLj3dpBm6gDWDe6tp+PAZPF?=
 =?us-ascii?Q?KJNALQqVJw=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d3a47b-e156-4503-f524-08da3a552ec9
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 11:37:56.0933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WA03VNJyUWJ9gpmt0KRV5Uzh+kUkVcs3FwiTx6DR54X1hZXWVNRoDciQU9QPP9nr6x7bVXs7Q7JHhF39BOKTDQ==
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

The BPF_SIZE check in the beginning of check_ld_imm() actually guard
against program with JMP instructions that goes to the second
instruction of BPF_LD_IMM64, but may be easily dismissed as an simple
opcode check that's duplicating the effort of bpf_opcode_in_insntable().

Add comment to better reflect the importance of the check.

Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 79a2695ee2e2..133929751f80 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9921,6 +9921,10 @@ static int check_ld_imm(struct bpf_verifier_env *env=
, struct bpf_insn *insn)
 	struct bpf_map *map;
 	int err;
=20
+	/* checks that this is not the second part of BPF_LD_IMM64, which is
+	 * skipped over during opcode check, but a JMP with invalid offset may
+	 * cause check_ld_imm() to be called upon it.
+	 */
 	if (BPF_SIZE(insn->code) !=3D BPF_DW) {
 		verbose(env, "invalid BPF_LD_IMM insn\n");
 		return -EINVAL;
--=20
2.36.1

