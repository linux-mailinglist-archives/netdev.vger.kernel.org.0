Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7843839E
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhJWMHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 08:07:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhJWMH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 08:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634990709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IclPFWVvkolcccbxu0IPirIhrTDIkZuCzmLS7DOYFgI=;
        b=F7/AvmiYUXEBXveAiEvvoux7jW15PdId053DOthOb+0LY+ISRZOvw3872ezNHrXPe84+/Y
        SJnAphh6iVTS0erFr2KVt8682c5ChJSEPPBI4Te/1oxPkJU5BfScIihnTn/SZZ4/4xrNcG
        VHmAxgl2gwfkawE0FtWcuqiLYf2fNx8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-UsPv9e-ONgeW6B4hqrBPNg-1; Sat, 23 Oct 2021 08:05:08 -0400
X-MC-Unique: UsPv9e-ONgeW6B4hqrBPNg-1
Received: by mail-ed1-f69.google.com with SMTP id p20-20020a50cd94000000b003db23619472so5984083edi.19
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 05:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IclPFWVvkolcccbxu0IPirIhrTDIkZuCzmLS7DOYFgI=;
        b=QIMjvfcmZRHad29I4HeaAl0h1GGN1WV9wutymw115u46OUZ6R5qzG0MrS/AJ18W1d+
         KZihEDgPD8DHvVVOvhJI3Flmyx4jqG5BrkVmPwycUZXKGioQMkPkxve6f6TMYF/rSxDk
         iCyk9Hl/qVNHx8Iocyuy1EYdCXjuH3K7QE2oxTQ78//If6u0+xrglJn3VOBPLOpBVWR0
         /uxvNJqs1AQwC4ctnpO5r5YEfPMzB+u9a8c02PFbhdhXKgY+2x8/nLA4XPde1up5shwT
         cYqVmBfu4cq9v4hYHpaKJeFpDTLWfyXG0qJdIQnE2dzvsUglpnRaREIYDLvw1X3VQxL7
         +5pw==
X-Gm-Message-State: AOAM533fHzih1v+LnMM8ZnTOJl20nbz9uOU5VDVweuEN0svZkd24oLG7
        g15Img/OBKwwoKUB4WqMbX/Zu9I01UHp+y9Qtcwtb7lgOHofCrzXl7PFLL0Hs/zZXOLKqCqIWxx
        eu0GM9W/yrXJzYmqu
X-Received: by 2002:a17:906:2f16:: with SMTP id v22mr6949529eji.126.1634990706790;
        Sat, 23 Oct 2021 05:05:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVtClV4NnnT26CqdfsxTrFouECxaoGO2mUCScs8FDHTQkHzWtwKNZICZbHvkvVlDCaqrNfwA==
X-Received: by 2002:a17:906:2f16:: with SMTP id v22mr6949501eji.126.1634990706602;
        Sat, 23 Oct 2021 05:05:06 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id ho17sm2117788ejc.101.2021.10.23.05.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 05:05:06 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 2/2] bpf: Add support to detect and dedup instances of same structs
Date:   Sat, 23 Oct 2021 14:04:52 +0200
Message-Id: <20211023120452.212885-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211023120452.212885-1-jolsa@kernel.org>
References: <20211023120452.212885-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The s390x compiler generates multiple definitions of the same struct
and dedup algorithm does not seem to handle this at the moment.

I found code in dedup that seems to handle such situation for arrays,
and added btf_dedup_is_equiv call for structs.

With this change I can no longer see vmlinux's structs in kernel
module BTF data, but I have no idea if that breaks anything else.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3a01c4b7f36a..ec164d0cee30 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3920,8 +3920,16 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 		 * types within a single CU. So work around that by explicitly
 		 * allowing identical array types here.
 		 */
-		return hypot_type_id == cand_id ||
-		       btf_dedup_identical_arrays(d, hypot_type_id, cand_id);
+		struct btf_type *t;
+
+		if (hypot_type_id == cand_id)
+			return 1;
+		t = btf_type_by_id(d->btf, hypot_type_id);
+		if (btf_is_array(t))
+			return btf_dedup_identical_arrays(d, hypot_type_id, cand_id);
+		if (btf_is_struct(t))
+			return btf_dedup_is_equiv(d, hypot_type_id, cand_id);
+		return 0;
 	}
 
 	if (btf_dedup_hypot_map_add(d, canon_id, cand_id))
-- 
2.31.1

