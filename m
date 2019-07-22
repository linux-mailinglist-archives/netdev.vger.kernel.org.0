Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4276FF05
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfGVLw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:52:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35665 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730034AbfGVLw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:52:56 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so40326912edd.2
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 04:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vUDw12liv+q+PtuUpCHje4EUlhoF5OUW/8fU4VDZqm8=;
        b=HsUN9P1Ex2FMIrRN48aq9qdCshGU0hj7v+y0Xg0/rUT0iKuoqEtbxPHjigr5EWkCs1
         PPxF1pF3u87IQInUuIUxfrJ9HmceykArbN73bNsd6dXgzm3i4Nv0po5VwDDhPeHUHUWl
         tO4JHZ7/872TbAA+Vbn1PdgqwbCREfjCcvmUrgSONN8c87ZTBHGE16oTUKBIOAPh/tup
         g5h7efB70bPIMJI7IfnPRW9EM5HKUACnNyiRl45XlucjDW6ODoFpf4myd0sNt//nRdkl
         VwReohmVpepj2m4LZ+5jYlRgWD3ZPSuzaZuiDuZpjRtLopoVDlM13HegyTG15z7VAHOL
         gFbQ==
X-Gm-Message-State: APjAAAVvvtCka1M00Gie/ALeJkIAMpzeV49fXdY5Ez9RtXSgmQgNEIz8
        mvVa6P0kmFpwP8AsDT8mDeN6uQ==
X-Google-Smtp-Source: APXvYqyl5h+STMzaqO/o2+m/uFgyD4bp0bMHWVp++zsfqo47NwnyXQyt5k+IkRpj4CvHYNMhRG8x9g==
X-Received: by 2002:a17:906:944f:: with SMTP id z15mr53206738ejx.137.1563796374440;
        Mon, 22 Jul 2019 04:52:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i4sm8012197ejs.39.2019.07.22.04.52.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 04:52:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3317A181CEF; Mon, 22 Jul 2019 13:52:49 +0200 (CEST)
Subject: [PATCH bpf-next v4 5/6] tools/libbpf_probes: Add new devmap_hash type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 22 Jul 2019 13:52:49 +0200
Message-ID: <156379636904.12332.1075115809789333177.stgit@alrua-x1>
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

This adds the definition for BPF_MAP_TYPE_DEVMAP_HASH to libbpf_probes.c in
tools/lib/bpf.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Yonghong Song <yhs@fb.com>
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

