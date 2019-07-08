Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B928861D4F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfGHKz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:55:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35142 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbfGHKzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 06:55:53 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so14138652edd.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 03:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YzAlqk3Y5FSFz8PAiXf231hvJXeKFQjxzcquZVCtDHQ=;
        b=pi/3VRa9hcY0R3ywoogl9D32eQeE9kHMCj37r+0qOKeayajfCs00pkirVCR//zzjfn
         2sXk5TVnNHjWB4fZJc0gh5aHMP0VQgPBYnxgA1y61/CPzIoGazW72KTZvSP/EvUTur5l
         M5laq2WZlQGyl6Zh3fTMU1l1XUHVOoMnkq7IK7c5XvMj2UfB+NYO7ytE+2k9JP6LdsV8
         H2GBimkmFNiPUyFqOgWCmcKVwMDdQ6dZkiuwEPnAM+NyPJCIrK2nuyyApLl85XK+yTlO
         I5SY9NdIY8dcYP4gILvyIgORPi9phNjrvOnYBFlUUihgUmIvkhkog1TZlfHemW7UK0NU
         7Atw==
X-Gm-Message-State: APjAAAVDuiQO7wPu25HgVk1dAIOaNcl5ibETF5ujcSuZa33iDNgsC1Ty
        5dASrGstfgTWnDDgoKR8gQuUOg==
X-Google-Smtp-Source: APXvYqwvIaBRLfHzbCHyWTr5c/6bmtBpSrP/SohGpNrBJqdWm1HLcMcVl1iJYaCDHlW+brKUcTH65g==
X-Received: by 2002:a50:941c:: with SMTP id p28mr13080664eda.103.1562583351392;
        Mon, 08 Jul 2019 03:55:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i6sm5609278eda.79.2019.07.08.03.55.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 03:55:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7DEF5181CEE; Mon,  8 Jul 2019 12:55:47 +0200 (CEST)
Subject: [PATCH bpf-next v3 5/6] tools/libbpf_probes: Add new devmap_hash type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 08 Jul 2019 12:55:47 +0200
Message-ID: <156258334745.1664.1686759894096070590.stgit@alrua-x1>
In-Reply-To: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
References: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds the definition for BPF_MAP_TYPE_DEVMAP_HASH to libbpf_probes.c in
tools/lib/bpf.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf_probes.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index ace1a0708d99..4b0b0364f5fc 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -244,6 +244,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
 	case BPF_MAP_TYPE_HASH_OF_MAPS:
 	case BPF_MAP_TYPE_DEVMAP:
+	case BPF_MAP_TYPE_DEVMAP_HASH:
 	case BPF_MAP_TYPE_SOCKMAP:
 	case BPF_MAP_TYPE_CPUMAP:
 	case BPF_MAP_TYPE_XSKMAP:

