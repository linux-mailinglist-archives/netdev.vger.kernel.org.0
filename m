Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B7013CC67
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgAOSoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:44:03 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:37635 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbgAOSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:37 -0500
Received: by mail-pf1-f202.google.com with SMTP id d85so11453626pfd.4
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xQls5+iJi5Kqz7m3pR6x7QjrYUU6eZohn0NALbSGdKM=;
        b=uRu8Ql4OQe2tRaLyN4BrE2DzO8IeVWLi2wpeas1c8W1cbwT50VQ4hrVy7LBKcfIDne
         kbAGW11znsVoK9quuUOlLQ0elOv7VjBCiXAfr6BresyWbkaGuazrWHb+leZly2Ph3DZI
         O6mDiFPggpkCo+c1kyW6hySnLvFvMCP2sK1liTK0B1Krkycm4prBumLGlVIsfTkVLxZF
         AbD6D2M4jpR2guEvJrYljDLBvS540vq03Wd32exylK90h+AOlHeOc1a+Q1GaRIugverK
         Mg5oSJUGhqrWgHoCvlIIB7seQwLdKPFBPRRniyH3BZj0OHNvS1z2Xdjqn8rE6neaiFK1
         qVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xQls5+iJi5Kqz7m3pR6x7QjrYUU6eZohn0NALbSGdKM=;
        b=JvNXv7fHQPNslrFO4PtSpZDFrYEfxidS3cSLcdh906GNEg5pg6lOw5YbXt7NqfCYTe
         CqVt4CCh4sxvv6r4gxXQ4/ZuEE3NEpk2ncJl02YZ/qDEzuh3zwhlWAYFihAZb+eCW5Wb
         4hFN8YjV3OlNZdu0AafZGeNunA3Ca6smf0373NSDnl5Z61+57xEzSz1uEwliT0ZkNxjN
         wnL5IC3BZzHr503q1RqYjXVDkqjCGkVoL8yopsMPafspDc3sJQYSK2pGW9TAJCYWsI5U
         B4BWCtDprVAB67Piws+9cfLzWUt1U1vd37Dm0iVnBAHfYaNgps068RZa3iQ/v6sS82rR
         SzZQ==
X-Gm-Message-State: APjAAAWMuoi0N9iFOMzvJjNrdWaYFD/Tp0+xyuWjgjuij39Eus2eUpnk
        emjCi1vDeToCh4iRC4ykRbSD8OVFGvQy
X-Google-Smtp-Source: APXvYqw5Ows/8hwQ5OpgZH3vnFhIClHIpjJvEHfV11l+uWhlycMBwr24JyLQtkvI1Jahpm1ssHhjFsYA51Ri
X-Received: by 2002:a63:a34b:: with SMTP id v11mr33495694pgn.229.1579113816781;
 Wed, 15 Jan 2020 10:43:36 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:05 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-7-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 6/9] tools/bpf: sync uapi header bpf.h
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

sync uapi header include/uapi/linux/bpf.h to
tools/include/uapi/linux/bpf.h

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 52966e758fe59..9536729a03d57 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -107,6 +107,10 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+	BPF_MAP_UPDATE_BATCH,
+	BPF_MAP_DELETE_BATCH,
 };
 
 enum bpf_map_type {
@@ -420,6 +424,23 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_*_BATCH commands */
+		__aligned_u64	in_batch;	/* start batch,
+						 * NULL to start from beginning
+						 */
+		__aligned_u64	out_batch;	/* output: next start batch */
+		__aligned_u64	keys;
+		__aligned_u64	values;
+		__u32		count;		/* input/output:
+						 * input: # of key/value
+						 * elements
+						 * output: # of filled elements
+						 */
+		__u32		map_fd;
+		__u64		elem_flags;
+		__u64		flags;
+	} batch;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

