Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F9487ECA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 23:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiAGWLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 17:11:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbiAGWLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 17:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641593483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=W74pDxNFjz7NcYMYnihFwM/9aHZKzCb3JGwhZFxTX/A=;
        b=arbrR+A1RwTd/HKVEhKAhzFCCVZjC7leEmOM/JsSWOdRCXD7coLa7qz+KWzrFN2iBYl26k
        /LYSfcASE6HNRyP22SPb/GXjMIv6DBqfGLBaQdlpuGSj3Hl/zSc5F0LEuZ3CQ7KrGHgaVr
        9U9ytFVhSe0TkfyDp6+yvOBSp1S7dWI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153--Ek9M7tiPZyU-5nhbahfwQ-1; Fri, 07 Jan 2022 17:11:22 -0500
X-MC-Unique: -Ek9M7tiPZyU-5nhbahfwQ-1
Received: by mail-ed1-f71.google.com with SMTP id g11-20020a056402090b00b003f8fd1ac475so5780874edz.1
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 14:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W74pDxNFjz7NcYMYnihFwM/9aHZKzCb3JGwhZFxTX/A=;
        b=zTSLtIshCECTicfOKCDR/xK0U5r9xGfCpyZvuejAfhKDV3nuewNGyRiZmGLYLouM1t
         ZKqz0RqVkM601YRxinWsEsqvyNj2SFLr3RR9jSf8q9o7i7XRK/UMyuJZTNnbu7dIDYSw
         XFBHEtnwEGsSbowgqWJz5jAKZvFdKy675gVYlxcFNNE65vV7DUq9KIVejubqnajIaWdL
         Ur3SXsjYb5BrTUZVDY8Vn2TNy347JOuwugc/ZzXOl60wf6yP4nRKjHBkuTGFPyYZ6l1/
         3wVqqxe6ePTmXdJpJoaMXpktA1j9wQpDLPEjF/2AkccYsc+UM04Arsi8lkrBt5ZUe9g6
         wpFg==
X-Gm-Message-State: AOAM531onW+87HJoqwMTqhUHiLYasyFQaYtya9/S8QnKkLlbY8yKZKFs
        hEE1h7yIj6qCrtaG+wGdIHqfRIqT6RebFIn5EX3SUQHOhVdK1T0mLlRPnmQBZf0Ll6x5ImKG/jx
        8HkimErhlrJ9W06eY
X-Received: by 2002:a17:906:f01:: with SMTP id z1mr22139431eji.346.1641593480133;
        Fri, 07 Jan 2022 14:11:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRefX40qs5EO3OKkITmeknKrexgrVp35uaBM2Gaea+gDH6rWiowUPlZZ4VJEWYCVYtgR67vw==
X-Received: by 2002:a17:906:f01:: with SMTP id z1mr22139392eji.346.1641593479180;
        Fri, 07 Jan 2022 14:11:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j13sm2645087edw.89.2022.01.07.14.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 14:11:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B205181F2A; Fri,  7 Jan 2022 23:11:16 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf v2 1/3] xdp: check prog type before updating BPF link
Date:   Fri,  7 Jan 2022 23:11:13 +0100
Message-Id: <20220107221115.326171-1-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_xdp_link_update() function didn't check the program type before
updating the program, which made it possible to install any program type as
an XDP program, which is obviously not good. Syzbot managed to trigger this
by swapping in an LWT program on the XDP hook which would crash in a helper
call.

Fix this by adding a check and bailing out if the types don't match.

Fixes: 026a4c28e1db ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link")
Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/core/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c4708e2487fb..2078d04c6482 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9656,6 +9656,12 @@ static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
 		goto out_unlock;
 	}
 	old_prog = link->prog;
+	if (old_prog->type != new_prog->type ||
+	    old_prog->expected_attach_type != new_prog->expected_attach_type) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (old_prog == new_prog) {
 		/* no-op, don't disturb drivers */
 		bpf_prog_put(new_prog);
-- 
2.34.1

