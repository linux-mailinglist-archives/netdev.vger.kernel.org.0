Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295AC220DB7
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgGONJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:09:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39020 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731510AbgGONJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594818550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYWtpykPvB8BhaRiBcYzbHdq5CDZAFVD2s9zddWuWd0=;
        b=ECYURA/4pjIYb0RsqlfbDZ3nhu2qz6aDhvYLrJGjddncEaRG9rEEMmRmww4C1wNKg7i8jj
        6tRB9hYU8/PEZWkE7HP06OaPhBMv0ZvjtcrolW23vSV/8MC4xGQIF/Mef67cpX26HZMhxj
        ZyrPsWqqt3yDpaiMWwUlGSSrbguNUyY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-gLZSY2PdNSS8Wnmd1q9_1w-1; Wed, 15 Jul 2020 09:09:08 -0400
X-MC-Unique: gLZSY2PdNSS8Wnmd1q9_1w-1
Received: by mail-qt1-f198.google.com with SMTP id l53so1321181qtl.10
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nYWtpykPvB8BhaRiBcYzbHdq5CDZAFVD2s9zddWuWd0=;
        b=PPj4IWKBBcLaC4KUdQM537ebVY1NDNnyDb0TupH9DMa+YEJN4IMYO3v2+QtjaLUkV8
         REHwwkTvfWEthsGHqeMs4/A3TOKiGkHesXT5X1EzZz8KqVI0+BKwwq6BBAxAZ7cyBuFu
         emjoyT0ITF2H7nbhyQQTXIFc7XtLfUwb8O/zV/doUQpa9H7Pc4V9T8pjgYxSrskWW+7s
         qNeUMx3sn7wCiBIlgHcJYLaMclzRYuVKliIVCCq/43BJQT4yyuDyvAxdwaOGpPnSJPjJ
         +/G80ShpzqmcVJAME9MJ9Xmy2ozTvMIja/YS/TT0uJLzq5WfsnJ0A8etix3etAW1jQjD
         8X+w==
X-Gm-Message-State: AOAM532Ee+H6+zoZz6R3Bt4+8c+OPrRdQUWrj3fUSSmitu44v5+BtrET
        Le3TZv4LniJFsbfq/kt2mc3JJeltqYiHZriDmAWn32LKpQiOUeyfMGYgVA5p81VU2r+evdA/97n
        KkSnCKscxFPXZORJ8
X-Received: by 2002:aed:2f04:: with SMTP id l4mr10384711qtd.227.1594818548056;
        Wed, 15 Jul 2020 06:09:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAwcP+7wNRWG5Tjl6MUkTt9PeYzZCzvCIeDd8DeDnx3jOoia1FH7JoTvN956VFZ3fGkmbOfg==
X-Received: by 2002:aed:2f04:: with SMTP id l4mr10384687qtd.227.1594818547861;
        Wed, 15 Jul 2020 06:09:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o10sm2860796qtq.71.2020.07.15.06.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:09:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B6349180653; Wed, 15 Jul 2020 15:09:03 +0200 (CEST)
Subject: [PATCH bpf-next v2 4/6] tools: add new members to
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
Date:   Wed, 15 Jul 2020 15:09:03 +0200
Message-ID: <159481854364.454654.3830221599405038317.stgit@toke.dk>
In-Reply-To: <159481853923.454654.12184603524310603480.stgit@toke.dk>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
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
index 5e386389913a..01a0814a8cfe 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -574,8 +574,10 @@ union bpf_attr {
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

