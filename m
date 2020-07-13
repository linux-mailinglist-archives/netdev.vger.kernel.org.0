Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2B21E136
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgGMUMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:12:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726798AbgGMUMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594671149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r62uEiX4gXx9on9wTU8Kbsa3mLKmRZ7+dNYoSyMkncA=;
        b=SIAlkDuqG1wYrJpEBs1JgJ2B2tlDM34Hdi6ga+6m5UMYstkxbdg+ePFiri1ydQ9GON2n5e
        JPmJYJML/2ULWpGS2u7s4/0mavbjYKD4fCllyXkpxJ7KI4lyzAanlL5si2BOErQT44YU3q
        JLVRpcxuFOo7SqhB2UI7rTWQziyhsSE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-zp4qWreANya4iuQDisfEpA-1; Mon, 13 Jul 2020 16:12:27 -0400
X-MC-Unique: zp4qWreANya4iuQDisfEpA-1
Received: by mail-wr1-f72.google.com with SMTP id y16so18627793wrr.20
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=r62uEiX4gXx9on9wTU8Kbsa3mLKmRZ7+dNYoSyMkncA=;
        b=rcS9INEpp/yUY0XwlGbAOns/zq0VnrtFxCtskUlcmo7j/EYu4tjws+t/Q4nFV9gJh8
         znYDpjgVGZxYEBfE8nkT80Pp2lfl89Pgb96U/oUMMz3I4eZFSbl5V/IsijOp8pfcILyw
         1D49ZaLgx2/hj6p98W8+oeUUDN+2WO4eLOVpTsWVXb+j0r+pt+5RzCjONH5UEoXSaX8m
         qBqStqIuH4gay7Q4Mlo5y5tyKrzeDdV9Mstqs6jaWPkWDoHxXQRojW7wypuIpt3owSSI
         hCxUiR2f3AmL0Vp90504/paKWaLDIvMc6eCYDJqn5euVU6uFff7lD9UtyhojAjVHwkAx
         pwiw==
X-Gm-Message-State: AOAM5317kwRWPT1c8kPIKj4n+DYiqbjxjgntkcOX8LMo/PVCkAWolPq+
        6f5euUs7xM5pJRg+3z7dvj670BL6iL0ut33sF+DOAAF9OhOnzVlNME6o9XzxzQHwYXEn3I0xTOR
        u40kqETDwUvkJfyko
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr1171134wrx.50.1594671146020;
        Mon, 13 Jul 2020 13:12:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHuL1u53iYWEo0/trUpZpXNAJTAQGz0n6g3EupXuadC4qKdfTjweczjX09j3dGLz98+Hj6cA==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr1171120wrx.50.1594671145870;
        Mon, 13 Jul 2020 13:12:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m4sm848784wmi.48.2020.07.13.13.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:12:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 26330180653; Mon, 13 Jul 2020 22:12:24 +0200 (CEST)
Subject: [PATCH bpf-next 4/6] tools: add new members to
 bpf_attr.raw_tracepoint in bpf.h
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 13 Jul 2020 22:12:24 +0200
Message-ID: <159467114405.370286.1690821122507970067.stgit@toke.dk>
In-Reply-To: <159467113970.370286.17656404860101110795.stgit@toke.dk>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Sync addition of new members from main kernel tree.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/include/uapi/linux/bpf.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index da9bf35a26f8..662a15e4a1a1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -573,8 +573,13 @@ union bpf_attr {
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
-		__u64 name;
-		__u32 prog_fd;
+		__u64		name;
+		__u32		prog_fd;
+		__u32		log_level;	/* verbosity level of log */
+		__u32		log_size;	/* size of user buffer */
+		__aligned_u64	log_buf;	/* user supplied buffer */
+		__u32		tgt_prog_fd;
+		__u32		tgt_btf_id;
 	} raw_tracepoint;
 
 	struct { /* anonymous struct for BPF_BTF_LOAD */

