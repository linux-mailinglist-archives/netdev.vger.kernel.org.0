Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7935139B2A1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFDGe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFDGe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:34:27 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AE2C06174A;
        Thu,  3 Jun 2021 23:32:41 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j12so7052071pgh.7;
        Thu, 03 Jun 2021 23:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eU29L3cWBGVDlnYoGo+dyBaSf4Rb5FQNt6AlHPIbiN4=;
        b=H3ud3A3Ej6A7lpaze5h3a41Gipym3EbMKrwvfvXdt6sAl+OJNI0rOX3iI6b7tp7fb4
         JppttH2/EMwdSwZc4zwTH3hNJMtc4HaVMYifASbw8owDFEN9qpbIteN0RMTH1WYKv9dI
         LtPhjHRSskRVAqG4zL2pXSAKbbgncqgnWFJySpypfOBlw8gxcRbum1sbHK2OU2yQoUCh
         r1veQSpVXPEScCfkzcayE2Fv58RNw2P6whuqcrTSJgNYanatPXj4e/DJMiA1m2cC1VKa
         XV7gcUxkQdIvTytqjRDF6YJHetvhsUAbwYZv/bz8WjJRtbtePOlnaJTOXMYJVr1qg5if
         to/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eU29L3cWBGVDlnYoGo+dyBaSf4Rb5FQNt6AlHPIbiN4=;
        b=FscF5LyWLNSCh9JkL1FqiwejJTJHv0M81tHFzhAcsEnFoCPf3Z8ino3U4qUhn2dCTc
         +Ob9HggbwQagKEJyDm+YHGQVUSyx9S5UzBrBPKNC9GXcM0mHAcP/HMLmZrr8sgkww0Dy
         2FOYaqnX7w5bJgaGt6b+f5WX3TV1mXM1fSwuuevKGSWZdR22OIgeUxnleof0FFm1EA4j
         uorTqWxEWBs8lycBB54JNJfnu14pTCquJ3tEpYi/3ugE4E5IuxrwAueUj6CbmD+cIstn
         IZHEsY52K7704gWIYwAq+gUpKdKsJf41txvFHom3SC5Rq7SZOLn4rzY0jfHG9GFZE4f1
         m2Uw==
X-Gm-Message-State: AOAM533rs98AwTo78m2RFZ3Y8AzuYdbnBqkpk8FKCs1i8VlBgdjcvePu
        pFvseGzQsNeylqdCUNhhl1EzEj3Zc6s=
X-Google-Smtp-Source: ABdhPJygjb6UHuMT+WXwANY47yDOXIxe/piXi1hPNeipF9Usgf1BCM5/wy03M/rHVVlfFWn84jhV2Q==
X-Received: by 2002:a62:1ad7:0:b029:2e9:ac27:6ac8 with SMTP id a206-20020a621ad70000b02902e9ac276ac8mr3192264pfa.21.1622788360859;
        Thu, 03 Jun 2021 23:32:40 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id v6sm1066135pgk.33.2021.06.03.23.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:40 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 5/7] tools: bpf.h: sync with kernel sources
Date:   Fri,  4 Jun 2021 12:01:14 +0530
Message-Id: <20210604063116.234316-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
References: <20210604063116.234316-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to expose bpf_link based libbpf API to users.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2c1ba70abbf1..a3488463d145 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -994,6 +994,7 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_TC,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1007,6 +1008,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_ITER = 4,
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
+	BPF_LINK_TYPE_TC = 7,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1447,6 +1449,12 @@ union bpf_attr {
 				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 				__u32		iter_info_len;	/* iter_info length */
 			};
+			struct { /* used by BPF_TC */
+				__u32 parent;
+				__u32 handle;
+				__u32 gen_flags;
+				__u16 priority;
+			} tc;
 		};
 	} link_create;
 
@@ -5519,6 +5527,13 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct {
+			__u32 ifindex;
+			__u32 parent;
+			__u32 handle;
+			__u32 gen_flags;
+			__u16 priority;
+		} tc;
 	};
 } __attribute__((aligned(8)));
 
-- 
2.31.1

