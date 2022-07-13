Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84A7573521
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbiGMLPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiGMLO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 253F0101480
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIG1zNsh8lsCTnIOSJjvN9N6MeUmyuIluq3oahpmRcc=;
        b=E4eoDZB+gGk87B3q+QVsuPIW7NAOt0X+I7gN/CaRRgQ54WkLf35RGmlHiAmFqc1sBlWKln
        E0KXR5ylveW2m0h2YnNL7TtZGZQ6wQOzJ4U29SCNYoNhjQPQF8MxwWK8rp1wFDZvx0fB7T
        4HWI7NqQsKjxDr4xrkzhjq+YvytH5p4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-v2mW3qc0MgqrtWIWj0bwVQ-1; Wed, 13 Jul 2022 07:14:43 -0400
X-MC-Unique: v2mW3qc0MgqrtWIWj0bwVQ-1
Received: by mail-ed1-f69.google.com with SMTP id f13-20020a0564021e8d00b00437a2acb543so8084931edf.7
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wIG1zNsh8lsCTnIOSJjvN9N6MeUmyuIluq3oahpmRcc=;
        b=mh7mK8Pz7vbYXgCWmL7X+s4oV2kiI8TgEGSMkSRtnr8f85ZHq7BLPySA6/sGQf8his
         /Bf4xRsPpDZ46w6uTHM44v3b5aNeBWbmzGMr7S4xJpzTzHnPU1Zsb0Ix4vSS4qWYIuVv
         YrheHa3Ca3gKxz3hSHpYvN5Xc9/NpLR7rtFPEEziP7IdxX+wtbvDZ7fj4IrwOeWVF/0B
         Q0FFOVDxmPF8Vmr4YYNq7ENDRKqg6U+HotcyQWkfzMOSdEw4orvb0LZCvn25OpGfGuuV
         B/4+ZlJYgsLgxNVRZFaa/5ExSNpp714zlnj86hSG1W4eGlW5iTxE8+1hXcqPqOa848ZW
         Gm7w==
X-Gm-Message-State: AJIora/ccevXU5zUtdZrzILQA975pegK5SSuSAXVwZNoNvInqw9WAiFY
        DbqR+qe8B4FY42bbey/X4bnZSuIVu5JdplufB/Xx86R1LjW/bSyRXtNJ3nY6VMAmcb8yvfZxzjX
        MVD8SsKLVEdhmp9/G
X-Received: by 2002:a17:907:28c9:b0:72b:7165:20c2 with SMTP id en9-20020a17090728c900b0072b716520c2mr2891714ejc.120.1657710881128;
        Wed, 13 Jul 2022 04:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s16+3AyfkzBbcXq34X0y++PLKuDiMja5ZSlf2hxVY8NWSB4DRX/1or5m4FigZlda0Vp75obg==
X-Received: by 2002:a17:907:28c9:b0:72b:7165:20c2 with SMTP id en9-20020a17090728c900b0072b716520c2mr2891611ejc.120.1657710879788;
        Wed, 13 Jul 2022 04:14:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id hy10-20020a1709068a6a00b00704757b1debsm4839880ejc.9.2022.07.13.04.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 710C94D9909; Wed, 13 Jul 2022 13:14:36 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 07/17] bpf: Teach the verifier about referenced packets returned from dequeue programs
Date:   Wed, 13 Jul 2022 13:14:15 +0200
Message-Id: <20220713111430.134810-8-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

The usecase is to allow returning a dequeued packet, or NULL directly from
the BPF program. Shift the check_reference_leak call after
check_return_code, since the return is reference release (the reference is
transferred to the caller of the BPF program), hence a reference leak check
before check_return_code would always fail verification.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 489ea3f368a1..e3662460a095 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10421,6 +10421,9 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	return 0;
 }
 
+BTF_ID_LIST(dequeue_btf_ids)
+BTF_ID(struct, xdp_md)
+
 static int check_return_code(struct bpf_verifier_env *env)
 {
 	struct tnum enforce_attach_type_range = tnum_unknown;
@@ -10554,6 +10557,17 @@ static int check_return_code(struct bpf_verifier_env *env)
 		}
 		break;
 
+	case BPF_PROG_TYPE_DEQUEUE:
+		if (register_is_null(reg))
+			return 0;
+		if ((reg->type == PTR_TO_BTF_ID || reg->type == PTR_TO_BTF_ID_OR_NULL) &&
+		    reg->btf == btf_vmlinux && reg->btf_id == dequeue_btf_ids[0] &&
+		    reg->ref_obj_id != 0)
+			return release_reference(env, reg->ref_obj_id);
+		verbose(env, "At program exit the register R0 must be NULL or referenced %s%s\n",
+			reg_type_str(env, PTR_TO_BTF_ID),
+			kernel_type_name(btf_vmlinux, dequeue_btf_ids[0]));
+		return -EINVAL;
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
@@ -12339,11 +12353,11 @@ static int do_check(struct bpf_verifier_env *env)
 					continue;
 				}
 
-				err = check_reference_leak(env);
+				err = check_return_code(env);
 				if (err)
 					return err;
 
-				err = check_return_code(env);
+				err = check_reference_leak(env);
 				if (err)
 					return err;
 process_bpf_exit:
-- 
2.37.0

