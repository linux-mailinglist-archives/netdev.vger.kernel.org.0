Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF33495CF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCYPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:41:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230095AbhCYPlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616686870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mkkp9Q0MTI7AdziQNjihIsToFOQnGRdMmBYARReRHR8=;
        b=Godhy7RwE7tRLKh3q7+MRXoy/pRwdNw6ceDstoC/3OrpmbuV5/TkmfBzT2KOIu/V+e9J9M
        sOW6hLGPGqIJfF31tacfd4eiPEbqFNBfpqS5Y+j8cnUSKiKxtWO3+ljz/KdcaX2K9+SF5X
        1QfbIcRlpDvm8ogNkmdqWmmPDGKE0xo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-e1Fh-VgHMcWA1n1CI9NokQ-1; Thu, 25 Mar 2021 11:41:08 -0400
X-MC-Unique: e1Fh-VgHMcWA1n1CI9NokQ-1
Received: by mail-ej1-f69.google.com with SMTP id li22so2753781ejb.18
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 08:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mkkp9Q0MTI7AdziQNjihIsToFOQnGRdMmBYARReRHR8=;
        b=TYqR39Pa/Xb0xWNLGcQkUw+KW7V1ybA3nOgHLvnhndY9AlR6ATeGUPcUmaf9TG67tK
         SZSi7yIdyFp6hUafzmDdr/8vjBdTS89pCLf8W5J60QedjBuKpywmyrnPAFCJZLEIbSVu
         ZnH1NwN0VxgsVfpm7QU+z3g3RK20UEwGW8MFkXqVe9u6Enn7qE2BarD90Tky+5PUCBTe
         tk7Ir5QtzY0nlC+j98aOED3gjvrQ9kWyP/3WENsZO8mL5D01LogB1DcrW5QenSS5rp/e
         0W8oPXlmAtJYkgb7WwytF/mb8b9YgRZi2H2uWT8C4dVVZeHgGh8o+U6frYkyXUsVVuEk
         aYXg==
X-Gm-Message-State: AOAM532Np9cNHVVv7aDR+Ja/qLpCaNI387IuB+777kfDGvcXK61TKdET
        q0ez+c8S2A88Lgp2VrhUCuAtcna2Z/B/y6dyb+NpEXIGb3Tsof8UXhhdK7j/sLkQcZL59MEGBMx
        UO5AGP5yvXe84eMdB
X-Received: by 2002:a05:6402:3075:: with SMTP id bs21mr9881949edb.274.1616686866892;
        Thu, 25 Mar 2021 08:41:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbS3IF7eYaEHpPKdXhHOnLZDplOR/zM2ItMw4kIIUGr3miGy47ZMbfbD0l7DE1Lw9tw2rqLQ==
X-Received: by 2002:a05:6402:3075:: with SMTP id bs21mr9881901edb.274.1616686866392;
        Thu, 25 Mar 2021 08:41:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id jx22sm2567701ejc.105.2021.03.25.08.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 08:41:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 35F841801A3; Thu, 25 Mar 2021 16:41:05 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf: enforce that struct_ops programs be GPL-only
Date:   Thu, 25 Mar 2021 16:40:33 +0100
Message-Id: <20210325154034.85346-1-toke@redhat.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of the struct_ops program type, it became possible to
implement kernel functionality in BPF, making it viable to use BPF in place
of a regular kernel module for these particular operations.

Thus far, the only user of this mechanism is for implementing TCP
congestion control algorithms. These are clearly marked as GPL-only when
implemented as modules (as seen by the use of EXPORT_SYMBOL_GPL for
tcp_register_congestion_control()), so it seems like an oversight that this
was not carried over to BPF implementations. And sine this is the only user
of the struct_ops mechanism, just enforcing GPL-only for the struct_ops
program type seems like the simplest way to fix this.

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 44e4ec1640f1..48dd0c0f087c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12166,6 +12166,11 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 		return -ENOTSUPP;
 	}
 
+	if (!prog->gpl_compatible) {
+		verbose(env, "struct ops programs must have a GPL compatible license\n");
+		return -EINVAL;
+	}
+
 	t = st_ops->type;
 	member_idx = prog->expected_attach_type;
 	if (member_idx >= btf_type_vlen(t)) {
-- 
2.31.0

