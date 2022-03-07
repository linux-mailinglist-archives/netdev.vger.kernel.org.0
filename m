Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A234CF125
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 06:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiCGFa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 00:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiCGFa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 00:30:26 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905C33B018
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 21:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646630969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=PYL2+nfFveOBDxu8oSAjkR6wgoWTMSulu+kLnrHAIKM=;
        b=AyhcOapLxRUIe9DJTRR4iW+GB47qM/fqlybJX0/rZYik/N5GrNjUmsLltSjFF2FVCE2B9o
        s3PfmIHEvu9EzMjZzg/V5rTxRztuZs3vGTNM5mC87gZBUaOgLxum9kYHzngYLITAWOVKqx
        V62oaInK3Tkcy436hAD9Rxa6kY0bCyk=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-3-wssm1ythMjCLyW7Wtv3zuQ-1; Mon, 07 Mar 2022 06:29:28 +0100
X-MC-Unique: wssm1ythMjCLyW7Wtv3zuQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUWBVCf0cthj7MD1c5VTRfaaa25GM0PPbt0IZm4B3uN4WgXcFOy2CoqkR/T0DgUlRgsviWRKAsw99aJdY1NyGzEmJ3ctNd4G7gI/gEfnrSv5hjScfYcn31L7kzOPZETcnObP7Zw1lj1gdaxHLeYBMKGIEu+x9heKp0REzpm3nH1FEfg9mIFzASX6Tf/S+KZBXAwpIYYb+pYUX1NlkbCXWQsZ0eVu9Guj8Ek1OEg5T19XbY2h4tq10YwegHu0WJnFpbPsWZN/LgmTnqxXK7LLwS+ncvgjFek/2wlkTD8uY4lwaE0vt9XSIxFRYuE5C45Zxlsg+YIu2oS/RpicNN0Y9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYL2+nfFveOBDxu8oSAjkR6wgoWTMSulu+kLnrHAIKM=;
 b=SjJF+Tlkp4eixsFs7YhSppyRIHMtMEGqLytCMGmlBalZiIkh+/a/hNjoxDa3cifLr5OuNLPOB63/KsXvLxOOMhpDsTFa2yju7UupXD1PKtz3wTgQnhjO2cFNrTHJaqUUw6S/0KpYhhvZw8txoVUZhdvggBAHPy6dCundN4xLLnit0P22KQIo134nm1ygAakalcVUsy6dzmpP+xQiy75v68yjJpotMlUuq754nyIyL1W3XRwTBQlf6706tSjV3a7W5oLZO4IVI2G9So+kGjLqYvdJeEeGwt7+JWyQ0KhKYYcRuW8Gm2VdJLjBblokJCmDYliN9RFJApSugQoxApf1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by DBAPR04MB7206.eurprd04.prod.outlook.com (2603:10a6:10:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Mon, 7 Mar
 2022 05:29:27 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::5d4:d76f:ecea:e459]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::5d4:d76f:ecea:e459%9]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 05:29:27 +0000
Date:   Mon, 7 Mar 2022 13:29:18 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpf: determine buf_info inside check_buffer_access()
Message-ID: <YiWYLnAkEZXBP/gH@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: HK2PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:202:2::14) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1465ea1-b428-483c-8c05-08d9fffb7257
X-MS-TrafficTypeDiagnostic: DBAPR04MB7206:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB7206B20241CC91C4AC23B391BF089@DBAPR04MB7206.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FbX3T2VqJb74HWEHPuTjL6432q6GKJhJn+XrB8pQHeNucV5Sa6KJeNxdtWY6LI2VyCrntNndPlbRYyAq9W3Nn27KxaCov7qB07uQe/DJaCCj0eZ4GV6SxSRJpFISoonCeW02z7/EiFgZtpP1BzanZ2NRaIfojo4rCr9mE2YLwfNZ5Ej84O4pX8KQg+iGxAphQ0X9vQHocvi5oxG0bG2xjtuvKYy1UdvX/60MMnfVw/ikhAh4X2t5bpT6aXA5c/4oWDREZTmGoXBwA0CbX4YWBPHzcA6rF42a3zeyV+TjSDoIG0g55mpBIq8qh1sSIEc8yYnWhQ/IH8MSXhOXDRqszxsgQN8e35lk1PhuN7CiPhlRyE9GJWApFACyfpE0q34tYPpMDbMqy9PNUeBUqBffyH/Gwu/YbNeBnfrEE0ltAnCZOpAhNdWt9F474sc9Q37K55deEkz8BCbUbzRMMJBB6MVyZ5WQ1C06DN2tt0nIeEeukHKzGu+T0JG8ohJQu3zBsA8UahBrZbpsUheNdxE7N9X4bJ+3GBhi9R+TRkOzbs2DJUZV7wQip1XwiBRDsE1pVw2JfAAPubfp6iWhSfPlhyJt8Oyq+3lbe/Zs8FV+gp1OWdi9F4B8ocwm4cwlbXR/D2SjBWGxtKxZxUpyDQsNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(7416002)(66946007)(66556008)(4326008)(508600001)(6512007)(9686003)(6506007)(6666004)(83380400001)(33716001)(186003)(26005)(8676002)(66476007)(86362001)(2906002)(316002)(6486002)(54906003)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWJhVENDc2hUMm4vYTJDbUJZa1J0K3lVYU1QcG1QY1VNL0d3bzJsaGhtdk5p?=
 =?utf-8?B?L014QzYwRmFHQ1c4QWRXWndKV2Z2M0Y0MXNFaldsdlRpbEZlVDVGcW40SzhE?=
 =?utf-8?B?cVltSW8wMHlXNXo1TkpVdkVKMGtJVWxhckt3b2oyVUwwNC9NTkxNSnRDOWdp?=
 =?utf-8?B?ZThld05xS0F5ZGdKdCs0ZVhDSFFRcHpBbG10REJzNVA1Q2lJWC90YTdXdnJk?=
 =?utf-8?B?QkhDMlJOY25RbFBtSC9oVFpoN1RjemFDVlMzTkdSdGtWSDU0Y1BndU1FMjQ5?=
 =?utf-8?B?d3QxODFTZ3JiTGFoLzlaa0dvaGxxMUNCVWdmSjl2Q29VRmpBbG1TWEZzakpa?=
 =?utf-8?B?T1hWUEc4cGZGUEYyRDNwc3NDOEN5UjB1c3R3TGFMOWFrL3d0aS9zS3hnSG51?=
 =?utf-8?B?MjVKR2lpSkM4RlVYd1VDRmVITkQrREZWa2wzcmM2V2tKU054M1R5bDBFcjJZ?=
 =?utf-8?B?bjlvWHJicFBySU9XcW82eUplVG5lK2ZBSVNyZnMxUExmQWJ0czYrQ1ZlNG5s?=
 =?utf-8?B?dVV6MUNvQjZ4TnBTaFBzTDZha2t1Q1piTWhhM3VvbnZaOUwvanYzV045V0I5?=
 =?utf-8?B?N3hMeGREbWIxeHBxc0pUVHE3N21FejQvaU9nbDNtMnVBa2h2YlV6Y1hQcGM2?=
 =?utf-8?B?dXJmcm9GNVJlTm96R0RQU1dveWpCdEczbHVDcFhUYVBZckVpMHhtNjlHZGxu?=
 =?utf-8?B?RmRIaHFjK2F4SjNxS1YvZkYzbWx5UGl6S2JrRXhKd0kxQThwQUtDMUo2U1l6?=
 =?utf-8?B?TUhZSWpYdXhpVk5NMEo5dWdQQm84eFFCQ2xkUHhreFRKUm1qL3AyUlNjS0JJ?=
 =?utf-8?B?TVpjQlBZOXBtcFNvUnV1S1V2ZEpPUmxwYXJIR2JGdFFlbkduTG1mWVgvWnNV?=
 =?utf-8?B?Zm4wUUYrVzY5WW5LYTcreVpOd2FtNnpCemtjOFl0ak1YZEZrK3k4a0tOQTZN?=
 =?utf-8?B?L0l3N3pJelh2bktmVWV2TTdYc3pkWlpnNlNMMjFlMVNSZDJQL1FVRzBmTWdj?=
 =?utf-8?B?WGxvSy9MVUdFV09KQ0dZV0VHbjN5a1dvaGpkQnptam5uTWVoeGVxenYzdXYv?=
 =?utf-8?B?eDVqTmtETUNLak1CazBuakoxRTZNSGw4VWRtQTVvVWJxbUIzcUJEUytESm9s?=
 =?utf-8?B?Qk1oZzNxY3ZCV25FUlBRcEFNclllYWVjcWtzUWxLa1oxVEs3N1JFQ2VZZXZt?=
 =?utf-8?B?UHRicFZVTjhqaEcvRlBDZG5yei9GSk1xdmYvVzlnb2lhYWI3bEFWMXl0a0Zs?=
 =?utf-8?B?U1dlUHhtOWdZb1h2eFpMZU50TnhqZkJ3ekp2azJsZGppTHpBWHMyNFJGR1ND?=
 =?utf-8?B?dVNZemYxUEorMmpabWhkMWZyZE9OMHpiMTJQZUFxQmN2MFROUVdUT0t4YjBu?=
 =?utf-8?B?NVE3RnhyOXhseWlJYnYzbHl5M3k3QndFOFBzaXBLM1oxdTBnOFRxZ0FWNlNP?=
 =?utf-8?B?bWxXc29oZWxuVHNXUk5JbTdqdFQrK3V0VzNxdVhrWS9XdWJvSG1Ick1zZnAx?=
 =?utf-8?B?K3hmenBoUXZDWG01ajY0VkdiSjJYTUh6RnRBKzNEOHcrWmNvREVxbThWMUZi?=
 =?utf-8?B?QWZXZG5MTkVrOUxqKzlpYWpUbE9CVE1Wdm1jY3JoUWNrQm8wY1Y4UnQyRkYv?=
 =?utf-8?B?MFJhNGlIWHlBODRzamZUeENnZ0tqMVF5N2Uzc0prNC96dXl0TVdxR3UwRFor?=
 =?utf-8?B?aE1IZFVvZXJtQ25MWUVxenN5ZEhTZHgvdEVwYjZrMHhhWUd2TW10RUsvRzZC?=
 =?utf-8?B?N3BHSSt2UXFWVkh0c1NiS2pNOUQ0dGlEL2xFZmJlakRmcUVoemY0QnI1dmR2?=
 =?utf-8?B?RlRMNVY1cGdlNVZBaVAycDNlVDB5U3gvbTJoNWFXalFwTC9MZTZndlBDMVRQ?=
 =?utf-8?B?ZXhsWWt6d0lwMFlSODNxdWJZZmdpYllxQW1MY0Q2dERxN00zQ2dkdVQzZndN?=
 =?utf-8?B?WS9PTDR2TnZ2MjRCY1lxZkJ4bXhHQld4WS9KV1dqN0tnU2ZacVJhNEtPcjB3?=
 =?utf-8?B?NWNPNURMMGFNUE9tZFlBazdQWEdGZ0VHV1c3UC9xSWZ6eEllQVUwVWVzV05m?=
 =?utf-8?B?aGF0U0VrSjlCbllXbGZ4UkZBWTgybnUyNUVRbk51Zjk3QWxwRUVyQXBaVUI2?=
 =?utf-8?B?S2h5MXhVQk1rUG4wMnY4b2hpV09RVkVxbzAzMmdnbDdKNy9sVUJrbk0xYVpw?=
 =?utf-8?B?WGc9PQ==?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1465ea1-b428-483c-8c05-08d9fffb7257
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 05:29:27.1103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4macZq3ALJI/kA3fuihijo+BxPt5gxWOm4zTA9CpDQS0CjGO0xliePSzTeSYeimsveuZ5XzD3ax8SsPq66o0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7206
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of determining buf_info string in the caller of
check_buffer_access(), we can determine whether the register type is read-only
through type_is_rdonly_mem() helper inside check_buffer_access() and construct
buf_info, making the code slightly cleaner.

Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---

Initially I tried to remove the buf_info argument from
__check_buffer_access(), however check_tp_buffer_access() uses "tracepoint"
(rather than the usual "rdonly"/"rdwr") as it's buf_info, thus I decide to
leave __check_buffer_access() as-is, and only change check_buffer_access()
instead.

 kernel/bpf/verifier.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a39eedecc93a..518238029e46 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4047,9 +4047,9 @@ static int check_buffer_access(struct bpf_verifier_env *env,
 			       const struct bpf_reg_state *reg,
 			       int regno, int off, int size,
 			       bool zero_size_allowed,
-			       const char *buf_info,
 			       u32 *max_access)
 {
+	const char *buf_info = type_is_rdonly_mem(reg->type) ? "rdonly" : "rdwr";
 	int err;
 
 	err = __check_buffer_access(env, buf_info, reg, regno, off, size);
@@ -4543,7 +4543,6 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 					      value_regno);
 	} else if (base_type(reg->type) == PTR_TO_BUF) {
 		bool rdonly_mem = type_is_rdonly_mem(reg->type);
-		const char *buf_info;
 		u32 *max_access;
 
 		if (rdonly_mem) {
@@ -4552,15 +4551,13 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 					regno, reg_type_str(env, reg->type));
 				return -EACCES;
 			}
-			buf_info = "rdonly";
 			max_access = &env->prog->aux->max_rdonly_access;
 		} else {
-			buf_info = "rdwr";
 			max_access = &env->prog->aux->max_rdwr_access;
 		}
 
 		err = check_buffer_access(env, reg, regno, off, size, false,
-					  buf_info, max_access);
+					  max_access);
 
 		if (!err && value_regno >= 0 && (rdonly_mem || t == BPF_READ))
 			mark_reg_unknown(env, regs, value_regno);
@@ -4823,7 +4820,6 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				   struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
-	const char *buf_info;
 	u32 *max_access;
 
 	switch (base_type(reg->type)) {
@@ -4850,15 +4846,13 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 			if (meta && meta->raw_mode)
 				return -EACCES;
 
-			buf_info = "rdonly";
 			max_access = &env->prog->aux->max_rdonly_access;
 		} else {
-			buf_info = "rdwr";
 			max_access = &env->prog->aux->max_rdwr_access;
 		}
 		return check_buffer_access(env, reg, regno, reg->off,
 					   access_size, zero_size_allowed,
-					   buf_info, max_access);
+					   max_access);
 	case PTR_TO_STACK:
 		return check_stack_range_initialized(
 				env,
-- 
2.35.1

