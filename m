Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245526FF03
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfGVLwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:52:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39057 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfGVLwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:52:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id m10so40345307edv.6
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 04:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=U6WQtC5xM6IYSnYYnyAm+5V9mEzha+VJ9T/U/pGdTmo=;
        b=C1lTnzbcW3EtFLfv0kYe2Gn1kMxH2l2f2oy/0Ctdn1JpboH6DO8PRq4T0AzLnABs9y
         8cw5CRoeTnGE0B+NMwfLd1HyDe3L7WVSh2Xf1j6YLRfbqU8qHKN9qDTNRUu/jYOXHZby
         zM56ADWI02eh8BJxmE3zGwgZ216xUCzEei7jLmYpnaq+qFppnhrMMtcWIbyKa/FN3Iim
         n36TXSEqjFu0bLYuxli2Uarp/fmKJ2uH9sSv68adR4dojMupNYzxPARBTsmvjPXPDxqG
         XnloLkytL0GvCkvhkgoRruZNP43KRjMHGgwUXmEgYn1d/wah3qNvd4IaQGNBnzPbT0Zl
         xSdQ==
X-Gm-Message-State: APjAAAV7pmTliVUmMK/geYCuvqnJCYjhk3io7rb5W1BFCc1db1UzaYQ0
        4rxV0n+z4FXe34FyK8Ru+HfLUw==
X-Google-Smtp-Source: APXvYqxr02s3hIdO+LQNj6c2oBeFiB+ryjCjUPw0nosvKa1mFlQwEddKKnTADQ8klwg0vQAv1DxPuQ==
X-Received: by 2002:a50:b87c:: with SMTP id k57mr58805978ede.226.1563796371815;
        Mon, 22 Jul 2019 04:52:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i18sm11241953ede.65.2019.07.22.04.52.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 04:52:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0A397181CEE; Mon, 22 Jul 2019 13:52:49 +0200 (CEST)
Subject: [PATCH bpf-next v4 4/6] tools/include/uapi: Add devmap_hash BPF map
 type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 22 Jul 2019 13:52:48 +0200
Message-ID: <156379636887.12332.15017927691246240137.stgit@alrua-x1>
In-Reply-To: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
References: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds the devmap_hash BPF map type to the uapi headers in tools/.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f506c68b2612..f7eaec10e82e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_DEVMAP_HASH,
 };
 
 /* Note that tracing related programs such as

