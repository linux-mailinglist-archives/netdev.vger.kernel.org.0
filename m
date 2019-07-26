Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5B376E89
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfGZQHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:07:10 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38076 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfGZQHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:07:00 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so18931315edo.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 09:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vUDw12liv+q+PtuUpCHje4EUlhoF5OUW/8fU4VDZqm8=;
        b=FMPFAinuWVXEjRRg1cAKWGjRXNeSiUy/UfbZdfaepA617cD4rQaxSHah+I0cACI5xq
         7Q6VoJVovhxhig5m6nibcmdqa1etewFJkcY8Q+/5cuYtcQwnErDnI2cmZnjpv2DatLYs
         vVMOPfiRoBEg3OVo58moTHAy0i2Bp8Eqwrk2+Sr5139B3Bg5CXtA7JXmxxOGQVQFhL9A
         Y9dYczRgxBKkO9Kps/Tc7g4aiR3irXrde/1uY/vUzwB4sz3wlrjmK2UB7QBcqkEW6P6N
         OiHqFKsfb9BpttSal9mmUuSdFUuWFj7nKwOWolnj1bhGBnuABVjj3RIDl/QN29Amh5eb
         Juzw==
X-Gm-Message-State: APjAAAV+dDtqmMRxgm8DQhsF0+jSVX1dxmZpHVKZMO61ACYTQ4Kxl6Y3
        3Qo8/4Ag9ErJVpbR5J6TCdUm5w==
X-Google-Smtp-Source: APXvYqwLn0hKVMnC0q5Wjw8U1KzH8bL6l6OEbEvkLfuA+w9t/sYPm+TfnV1NhdTy+Me3RSL3zbn+lA==
X-Received: by 2002:aa7:ca41:: with SMTP id j1mr84887589edt.149.1564157218942;
        Fri, 26 Jul 2019 09:06:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id rl6sm10505772ejb.64.2019.07.26.09.06.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 09:06:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8D7351800C8; Fri, 26 Jul 2019 18:06:57 +0200 (CEST)
Subject: [PATCH bpf-next v5 5/6] tools/libbpf_probes: Add new devmap_hash type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Fri, 26 Jul 2019 18:06:57 +0200
Message-ID: <156415721733.13581.17824535343536163675.stgit@alrua-x1>
In-Reply-To: <156415721066.13581.737309854787645225.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
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

