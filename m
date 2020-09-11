Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0B4265D36
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgIKKAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:00:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgIKJ72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yw+OBp17cq1h1RyAy6dvNRDL5oF78jBZQhRd17iuPDs=;
        b=A/6sfzpYQ1VS4bC2Y9TxS4A4l7NuZCxrGtrmYdXbzrqaCEjLwIccvqYxBrQtDthGca+h4R
        JxywlwnQrliPWAssy0dcCR/sVT4EBDQDnzvDICWN5K3Tzm3evs8kCOSe+70YLvaOgZNRKw
        kxrTBzl4aqvHuvMdVR+z39Wc7Y3HIhE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-48oQ33MmN5GZnPa8YOTL4g-1; Fri, 11 Sep 2020 05:59:25 -0400
X-MC-Unique: 48oQ33MmN5GZnPa8YOTL4g-1
Received: by mail-wr1-f72.google.com with SMTP id i10so3315636wrq.5
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 02:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Yw+OBp17cq1h1RyAy6dvNRDL5oF78jBZQhRd17iuPDs=;
        b=HxMUgFhC1b50tAfl5F3UyWe3Yp+qroGCjCdPYsTC6ccKiqDCi3pCgax9o1HOyg88XG
         fy2mYQodS3W9g7qmVDEk2PltQtWBWE0/bmaeOBprFeOqKb0lpkNlmE2cRytaFKrfIOtj
         gPvL5HfTvW/tC9SWGtzk5nljfEvqh8vq+iIJ33uaM0OP07sh+EvpdT4Q51xW3SRi3S0G
         eMofXQxDmnhBTMcIAM3xUk7Em/mSM0PC+Ofoap7XqB2dg5G5JAJx56PUIYoNoQBLV7Um
         PQi3hXTnUem7w4IMXtsB5qbQyoygqRpVP44rIXPK4oITUrOuRAuIzxSYgpS9sq7VGs+B
         8MnQ==
X-Gm-Message-State: AOAM533BnhHdWel0ZSjjb9GQNDfLestul53qEaMMUdG7LboU7XtsFx6L
        QqgHidU0Hll+pf1saETbXe8lCkrYb7W+MtSlxpgehJMLvL5ajAwATAF2spXqr0D8yIyt7Ywzo0D
        HuLgE16+fSpQYSs4O
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr1408112wml.6.1599818364115;
        Fri, 11 Sep 2020 02:59:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjaevFM/brwL7/zuHm2kxWloBn0Sj5bnN9U4Gj7kpUU/NNGgl2Pm5K8v/TX3DGYFrLk8jrtg==
X-Received: by 2002:a1c:80d7:: with SMTP id b206mr1378348wmd.161.1599818362098;
        Fri, 11 Sep 2020 02:59:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l8sm3602001wrx.22.2020.09.11.02.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:59:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5E6381829D4; Fri, 11 Sep 2020 11:59:21 +0200 (CEST)
Subject: [PATCH RESEND bpf-next v3 6/9] tools: add new members to
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
Date:   Fri, 11 Sep 2020 11:59:21 +0200
Message-ID: <159981836129.134722.13602310042777114855.stgit@toke.dk>
In-Reply-To: <159981835466.134722.8652987144251743467.stgit@toke.dk>
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
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

