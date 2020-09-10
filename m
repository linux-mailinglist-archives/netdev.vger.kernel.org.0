Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9516E2653B0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgIJVjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:39:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57823 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730627AbgIJNKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599743399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yw+OBp17cq1h1RyAy6dvNRDL5oF78jBZQhRd17iuPDs=;
        b=L5mFrcaeXuz27jPbtqb+kz9BHnHddOzaZgvA8qmGyCCqoz89W+eeotmr0WO/TZcbfzgCgY
        IKALmcETLK4WiU1mT4bRAL9cBCnQQYPD9ywP8y5iWX3O7mf/W+NT6AmS8TQPeC1TD6FUNO
        VnqnK5boOahTK3XY3OaF3FOrIjZ3bw4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-nKmTc-N4NgS49f2KUMcVUA-1; Thu, 10 Sep 2020 09:09:58 -0400
X-MC-Unique: nKmTc-N4NgS49f2KUMcVUA-1
Received: by mail-wr1-f69.google.com with SMTP id v12so2241690wrm.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 06:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Yw+OBp17cq1h1RyAy6dvNRDL5oF78jBZQhRd17iuPDs=;
        b=TFkcYE8AsdKxhveyJeTn60rYDvMA8zVjFmDmLHfpA2pMGG2pnVQleisK859KKJyoHl
         PPuqw/TgecboKzMy4ILRUtTBPcV2pqOHiJmRP/I+50xkLb8SSsllfnmK7ewxUNkAVKJI
         nRif7FkfaLxczdP0FK8PnE4gTi5TvtgpgAxa/PtOyMKADTeAwlQYmaYEgODOWDzFNYJu
         jZ4+HboSgHsTEIx+ns3FGya03k30yEPd2Q4h+vUGpieZxsQ13GKaowVbOAwR6xwpXw3f
         wnmB7NqukQhFEMfqxe/YHFLl8DrYBJaqtH9f4NhQ+X0KqR4Pu9bWD+DgoiXXeZWEKmHF
         4Sdg==
X-Gm-Message-State: AOAM532lgPQbuQ+oIi9X2FBnCnZjl1vkWrMrMb0gtotFRkRAPr0K2F4X
        swwNjBgbjzmiQ2wChe7ms1W5eXix9KfjChBz3KpVwN5R+0MuMUyOE+1GLITx82JQt/zr98JDs1Y
        cg4zX6kTEkhIWSsc9
X-Received: by 2002:a7b:c111:: with SMTP id w17mr8183095wmi.109.1599743397123;
        Thu, 10 Sep 2020 06:09:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycEaK5TE/MoXeqj+IsAcLh/p9SQZRnb7s/lYfqop6e2OFEVCKao3zw4umSy+u7dd9kI5Ompw==
X-Received: by 2002:a7b:c111:: with SMTP id w17mr8183071wmi.109.1599743396963;
        Thu, 10 Sep 2020 06:09:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 91sm9937489wrq.9.2020.09.10.06.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 06:09:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 203A91829D5; Thu, 10 Sep 2020 15:09:56 +0200 (CEST)
Subject: [PATCH bpf-next v3 6/9] tools: add new members to
 bpf_attr.raw_tracepoint in bpf.h
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 10 Sep 2020 15:09:56 +0200
Message-ID: <159974339603.129227.16169601282261093819.stgit@toke.dk>
In-Reply-To: <159974338947.129227.5610774877906475683.stgit@toke.dk>
References: <159974338947.129227.5610774877906475683.stgit@toke.dk>
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
 tools/include/uapi/linux/bpf.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 90359cab501d..0885ab6ac8d9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -595,8 +595,10 @@ union bpf_attr {
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
-		__u64 name;
-		__u32 prog_fd;
+		__u64		name;
+		__u32		prog_fd;
+		__u32		tgt_prog_fd;
+		__u32		tgt_btf_id;
 	} raw_tracepoint;
 
 	struct { /* anonymous struct for BPF_BTF_LOAD */

