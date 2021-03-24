Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D815348369
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbhCXVIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbhCXVH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:07:58 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCE0C06174A;
        Wed, 24 Mar 2021 14:07:58 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id c17so296900ilj.7;
        Wed, 24 Mar 2021 14:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=jp0A9q/Fa/axx/Bk04+YYn4R1yemv50C/Z1nRtFG2S8=;
        b=Z2hw56i8tiiyvA9632SHpeWA6J62QfsZCkHp2TrKDzFCy46MZEKo7xE//+R3HRRUXo
         MwS6CmaWTwY0fHw64iUfWQrpMkKaVpNn2SxwsHc73cfhmesHNAFakMct6kLrJ65V4YyW
         /fs3Xf3E1bio5Ll7qRhj9/zHSCtwY0NPuzxYQkl86qrIZtrOKmLytPXu1MQht2m1e8iF
         WX/q+ohi6FHmqQ/dX7zdRQhjlPjgWeixrCJLP15CJxWf2XJXMCh2sZP5+kQUg+WKdKtC
         byMN3kJIRYMkHFUecg3s8prEzW83IkrO97FKGlWq+hHvLCuZOccIELbpcvGxINVxjo93
         Bd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jp0A9q/Fa/axx/Bk04+YYn4R1yemv50C/Z1nRtFG2S8=;
        b=qeVaUfsnaFtHTZMwMIamW2xyTOleKYy1rFYPBdmvZMKTorC5BnNSRompSmB/w7rTyf
         O473vroNzHTi1uci/xMzShI6fPsUKOqK7P6kSX+AKp6D7PQmyRj3emI9lcdddOgEWDp4
         Bh66KMvyeFS7wcEmEqCszvZJ9Jut3kJLWiaTzvZ89OpZ/QSjo3i7GQULUvT5lwZjSQuQ
         pcJB5fRRYh9lbtJTQi/npdk+tWeuaxB+WRnhuXvXer+FAMjDO3ie3o+KrMY5sfLl+0eF
         1KKLLPPbnPylzqWltz88GKfl4Ra7U5in5Xm/ssJQojjOnGF6eXmW1URAxAtZXwMozmnC
         F6aQ==
X-Gm-Message-State: AOAM531lEcAC3/R4I190+e/Fz0atS9Cs7XCJEOiOJMA9EgOXJnI5D9Hc
        Q89hb6VksA6xDKpuLJBLf2i/fAB+K7d8Hw==
X-Google-Smtp-Source: ABdhPJy5L99NF++6PPlaLZkc7BB38RK9m+jg6jGNA5D2ShFADHxsPiRXC7+jCvhKx/w3udwXD4/Kyw==
X-Received: by 2002:a92:6712:: with SMTP id b18mr4488580ilc.181.1616620077252;
        Wed, 24 Mar 2021 14:07:57 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id j6sm1264887ila.31.2021.03.24.14.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:07:56 -0700 (PDT)
Subject: [bpf PATCH] bpf,
 selftests: test_maps generating unrecognized data section
From:   John Fastabend <john.fastabend@gmail.com>
To:     andrii@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com
Date:   Wed, 24 Mar 2021 14:07:46 -0700
Message-ID: <161662006586.29133.187705917710998342.stgit@john-Precision-5820-Tower>
In-Reply-To: <161661993201.29133.10763175125024005438.stgit@john-Precision-5820-Tower>
References: <161661993201.29133.10763175125024005438.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a relatively recent clang master branch test_map skips a section,

 libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1

the cause is some pointless strings from bpf_printks in the BPF program
loaded during testing. Remove them so we stop tripping our test bots.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
index fdb4bf4408fa..0f603253f4ed 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
@@ -16,10 +16,7 @@ int bpf_prog1(struct sk_msg_md *msg)
 	if (data + 8 > data_end)
 		return SK_DROP;
 
-	bpf_printk("data length %i\n", (__u64)msg->data_end - (__u64)msg->data);
 	d = (char *)data;
-	bpf_printk("hello sendmsg hook %i %i\n", d[0], d[1]);
-
 	return SK_PASS;
 }
 

