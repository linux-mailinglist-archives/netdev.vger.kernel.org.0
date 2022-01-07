Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECD5487C3A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348739AbiAGSbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:31:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348759AbiAGSbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 13:31:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641580269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CnnFuMGhB5JyFl3Jry+SDDf7d1TYi2ACAz22LLK65xE=;
        b=Tf3lD3bQKspJ4+NR/i89FmrFHhs1Lnhe47q/Eh7Nl0cceHLceHIFdfP+odIE3rZTs0xjqO
        kr7xFLqkIZpJXdSD/bFZUhPD0Ukil7V3XTb77c6wVE5bWylFVlLn8d32uDUS6ogkxCvIHx
        o4sIHZwcAx+kb0W4kRoQz6oHrZKzUS0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-LoqF9ecnN36V3T-AHQv67w-1; Fri, 07 Jan 2022 13:31:06 -0500
X-MC-Unique: LoqF9ecnN36V3T-AHQv67w-1
Received: by mail-ed1-f69.google.com with SMTP id z10-20020a05640235ca00b003f8efab3342so5370198edc.2
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 10:31:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CnnFuMGhB5JyFl3Jry+SDDf7d1TYi2ACAz22LLK65xE=;
        b=W6vi3JSUUJP8TEc4bwvXetjPUppQKqLuo6Tuphws8KGa930GUzK8HAaMcVsi837mWJ
         tf2b7TVyo1FxxoegfR0RwMQn2ShNLZux9wuQl5epVvqPdSG5sLr2kPiHBC10Gzhz3OQk
         2HJ4WDULjy+okfVrs4Sd5NScypzh/0FjV6OZ/O5a55rofBKtdcuvDGmrbMPY0eyuuMVz
         wwPin5fpEHwxhiHLwf79BtNCp6XrH9R5CcofyQXCLBLmKVpAQMQd3esNDRDCucQuldkP
         JCw7LCYGVzfCKpdzcEogjxOIm0H2QgHro7NtqTPdfAtk0kTeXRk0AM6btt5Jhq9+LDKJ
         NMqQ==
X-Gm-Message-State: AOAM532UHOcyNUoG6NBBemi6DxQOPQyWP4Uxwe4bsdiI3EqR9FAl+Lfg
        S5XYlvzSD3e2+6ZnO3cv+PNhwbj0lLo66uvw8tblo5egwwC2NDSUBGBaFDM2LI0kk1/kTzZ/1SQ
        apPmcQNt644/5uSAx
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr2378940edv.396.1641580265230;
        Fri, 07 Jan 2022 10:31:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOjDvG04fHiqW1oMWTPMiyPLrLIZvdP2d1EgvGYDfE3UckOVJN/UxvqyJ1rQW3vEZHpke8HQ==
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr2378909edv.396.1641580264843;
        Fri, 07 Jan 2022 10:31:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 1sm1614361ejo.192.2022.01.07.10.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 10:31:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 617CF181F2A; Fri,  7 Jan 2022 19:31:03 +0100 (CET)
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
Subject: [PATCH bpf 1/2] xdp: check prog type before updating BPF link
Date:   Fri,  7 Jan 2022 19:30:48 +0100
Message-Id: <20220107183049.311134-1-toke@redhat.com>
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

