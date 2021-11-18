Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABAB455A33
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343945AbhKRL3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:29:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343683AbhKRL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pX4ji75/Gajon/2J1LuYrNCwjAQvI0++spwtccRCPdk=;
        b=SZRTdPvgbcd9+A3fggLc9sKEATV4doR4LcUM5gNs0htdP1UI6uR0Brn7+qCX3i9Vbk2NJH
        mlBDHpUUJCyqDd2B+k6MpSvCHOleMRd+LtA4yKv6R4QgvUrmlGFbIEu3qFM8Ve0opcwnPj
        MUS+67ycyAZK2ClMnknv1VcCs3ZyHmI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-wrvB6OLqM4-k1xrnT33GHA-1; Thu, 18 Nov 2021 06:25:46 -0500
X-MC-Unique: wrvB6OLqM4-k1xrnT33GHA-1
Received: by mail-ed1-f71.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso4982240edb.11
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:25:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pX4ji75/Gajon/2J1LuYrNCwjAQvI0++spwtccRCPdk=;
        b=L3tpnYTBWAnG21cSvm5xq//nCrk8VORj46ccWhMUb2kvyJkY2S/9XdaPTI5UhzfPZL
         q5g0SNiFtYsdwzCf8GRl2pCknSNf79ERl/8wupwXLpktEIU/DUpFStBrMmScEOWNgak7
         jIBb1rqKnsuA1xv58MYOKUCjF7XhrUAgzObK1KPv4U9w0TI3aO/D+wZaGI2vPKPGdeMy
         jTIMSPXWYc9fEla29ZeABJIh75sOjHEiD8s+beUHcPUe8KeoWLyFtK7jeHmUEFsAdf8Z
         3JQanm6//3TtjRzjreDjTZNtCpd7Ry+BU34Y9ualkaPPTPwnqlLMriLpMjGQWjanKBp0
         tl5Q==
X-Gm-Message-State: AOAM530qctb8C5f7+l1SGahgiA4b828wTbRZqg1yq7jFNueItl77k/ct
        LEyus/zAM+EzMgH2NF0pDNA7mMHp49zRh4mT+rcokissIgPS2ejp4UiwJsq7GBw/EBVTt5wr7Qd
        PI8O3jELwGb10YFkv
X-Received: by 2002:a17:906:608:: with SMTP id s8mr32950799ejb.405.1637234745253;
        Thu, 18 Nov 2021 03:25:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXium1CcxTPtrQy+FrdiIZ6BCZsyJfc85NeUUE7XrI3XxCDHWOTUp2hMdOjCO6IiOvKBowSw==
X-Received: by 2002:a17:906:608:: with SMTP id s8mr32950762ejb.405.1637234745054;
        Thu, 18 Nov 2021 03:25:45 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id s18sm1583011edd.15.2021.11.18.03.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:25:44 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 08/29] bpf: Keep active attached trampoline in bpf_prog
Date:   Thu, 18 Nov 2021 12:24:34 +0100
Message-Id: <20211118112455.475349-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keeping active attached trampoline in bpf_prog so it can be used
in following changes to account for multiple functions attachments
in program.

As EXT programs are not going to be supported in multiple functions
attachment for now, I'm keeping them stored in link.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 77c76e2fa9ff..c93c629b5725 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -872,6 +872,7 @@ struct bpf_prog_aux {
 	struct mutex dst_mutex; /* protects dst_* pointers below, *after* prog becomes visible */
 	struct bpf_prog *dst_prog;
 	struct bpf_trampoline *dst_trampoline;
+	struct bpf_trampoline *trampoline;
 	enum bpf_prog_type saved_dst_prog_type;
 	enum bpf_attach_type saved_dst_attach_type;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50f96ea4452a..0df8b2f3d982 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2623,15 +2623,28 @@ struct bpf_tracing_link {
 	struct bpf_prog *tgt_prog;
 };
 
+static struct bpf_trampoline *link_trampoline(struct bpf_tracing_link *link)
+{
+	struct bpf_prog *prog = link->link.prog;
+
+	if (prog->type == BPF_PROG_TYPE_EXT)
+		return link->trampoline;
+	else
+		return prog->aux->trampoline;
+}
+
 static void bpf_tracing_link_release(struct bpf_link *link)
 {
 	struct bpf_tracing_link *tr_link =
 		container_of(link, struct bpf_tracing_link, link);
+	struct bpf_trampoline *tr = link_trampoline(tr_link);
+	struct bpf_prog *prog = link->prog;
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
-						tr_link->trampoline));
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog, tr));
 
-	bpf_trampoline_put(tr_link->trampoline);
+	if (prog->type != BPF_PROG_TYPE_EXT)
+		prog->aux->trampoline = NULL;
+	bpf_trampoline_put(tr);
 
 	/* tgt_prog is NULL if target is a kernel function */
 	if (tr_link->tgt_prog)
@@ -2662,9 +2675,10 @@ static int bpf_tracing_link_fill_link_info(const struct bpf_link *link,
 {
 	struct bpf_tracing_link *tr_link =
 		container_of(link, struct bpf_tracing_link, link);
+	struct bpf_trampoline *tr = link_trampoline(tr_link);
 
 	info->tracing.attach_type = tr_link->attach_type;
-	bpf_trampoline_unpack_key(tr_link->trampoline->key,
+	bpf_trampoline_unpack_key(tr->key,
 				  &info->tracing.target_obj_id,
 				  &info->tracing.target_btf_id);
 
@@ -2682,6 +2696,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 				   int tgt_prog_fd,
 				   u32 btf_id)
 {
+	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	struct bpf_link_primer link_primer;
 	struct bpf_prog *tgt_prog = NULL;
 	struct bpf_trampoline *tr = NULL;
@@ -2748,6 +2763,11 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 
 	mutex_lock(&prog->aux->dst_mutex);
 
+	if (!prog_extension && prog->aux->trampoline) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
 	/* There are a few possible cases here:
 	 *
 	 * - if prog->aux->dst_trampoline is set, the program was just loaded
@@ -2824,7 +2844,11 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	}
 
 	link->tgt_prog = tgt_prog;
-	link->trampoline = tr;
+
+	if (prog_extension)
+		link->trampoline = tr;
+	else
+		prog->aux->trampoline = tr;
 
 	/* Always clear the trampoline and target prog from prog->aux to make
 	 * sure the original attach destination is not kept alive after a
-- 
2.31.1

