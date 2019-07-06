Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDA160F84
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfGFIrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 04:47:22 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33768 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfGFIrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 04:47:21 -0400
Received: by mail-ed1-f65.google.com with SMTP id i11so9832688edq.0
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 01:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YzAlqk3Y5FSFz8PAiXf231hvJXeKFQjxzcquZVCtDHQ=;
        b=WcuDdHPS76/XQRgd/nZi6rusOuJ+LDEVVcCmwGBopZw1ywJn5MEMyw06eC2EgL4dBW
         MrtXBCA3C6YVed9CbrmzTLR96K1l2KDY7e0tgo0yOOsyO1MbvtRAAmeTb09QmUESMdad
         gMPt066ZO5NelgzdL66hyrTyRKC8quVSiBD7g+AUpQ3hm7MJqUHZZDdfQnz1ik9VA0Oz
         jHIxTeUMUFlmBfcA6irPKN+rlwLYyWImiobRyRZADi6kAf2jd9aLik/uWNnHJ+Urr0CX
         WAdX+81nXhpUz7kMb7wDi5DLSn0IuDN0TAcTdJ/hD8WXAQfcJ66Jir/4SmTJ+gETVjgI
         hAEw==
X-Gm-Message-State: APjAAAWDgi2VGIzbARRm3J3lAkz+sNBzjQ/pEPyo6xbQrvnpzgSJFoBY
        CzfHwLJq2lRtPv28HAXsuOmbLQ==
X-Google-Smtp-Source: APXvYqx2W4oeYHMzIYVXFEulGwbPsZVjxDrEoK4/2zF/ThyFnWKkANBmhOyNko34D1ZqEPmbEZzwJA==
X-Received: by 2002:a50:fb8c:: with SMTP id e12mr9029456edq.155.1562402839981;
        Sat, 06 Jul 2019 01:47:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l35sm3392971edc.2.2019.07.06.01.47.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 01:47:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1BAEE181CE8; Sat,  6 Jul 2019 10:47:16 +0200 (CEST)
Subject: [PATCH bpf-next v2 5/6] tools/libbpf_probes: Add new devmap_hash type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 06 Jul 2019 10:47:16 +0200
Message-ID: <156240283604.10171.7357918628117446896.stgit@alrua-x1>
In-Reply-To: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
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

