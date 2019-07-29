Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06689791A9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfG2Q7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:59:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40650 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfG2Q7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:59:35 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so27693920pla.7;
        Mon, 29 Jul 2019 09:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D+TzFW4RpIKq9WD2DO20S9txmOagqfJIoYXfqJht9nY=;
        b=M5NKlwJjPm2fkyi/zJ78yISUKzXDSUcF1QZgvEx3/g6ccRY+K1Y4HgLpoSIu1DhMc9
         6CJoxJ9tN9etO6mG7C0lEDT1d8bEx3LsHtOogk8o8tSIhHPBSckpIuNRGv6a42N4iok3
         YrlaKFESssRQrsi9N5Ply5/qUBMe4G02PjdjpPpgx8zIKnTM2mH1W+F6pvZ91MFYUdPy
         lh6eE4h5Qs0qgTF+8/KzXuXw1x/NrZYMlgf7BPFBVMEH3Xmfs9B1GCRSNSfZmPaTFGKb
         2y0gOAgAT4KfX/3mBf0KkiDCDQyb679q6QEIxkGHHF0zzPlSv53jxo33b0h1aWBiNVLI
         dqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D+TzFW4RpIKq9WD2DO20S9txmOagqfJIoYXfqJht9nY=;
        b=FN0cZDZoKHHo1/7nt6/wYTysVURTFtwPNrOBoPhhuCpbSG7atyx9voV3owJDLXk7AY
         n7NCezyiNsqUtvgC+z/XyBSS6vtWMjLZ84/vgqQ4l2REOd3HzhxpcL9RoB5oAWV0U3PV
         veAdiC6JFTqGtiWe+XDWdakpTrJ1sAsSzppC0pjkp73jNdz706qQ89dFl+xzEyJt4mzW
         gkYDTjMMDWG6Hz720X7BaBteKwk5sLA+U8rOcTz6OYp031HZDooLhytrk6uodl0YzF+y
         ZHYsoztmTmJRRxOYy/JnkjH5e4DpIJOEtqFPw+I0Qztn33riTDsPN+rCVmwVA5DFdsaD
         OSDw==
X-Gm-Message-State: APjAAAVNUzxrSKYmn9tuFRqRqpiC8e/o2YxmpDNbtpftwqAMvCDXakL4
        58D8hRaJzIpHHLcvREXhDuTS65C8
X-Google-Smtp-Source: APXvYqzujjWDuoHNjuek9zlIVpsU+gp4rrTesamLeRI5jcIE5FHu/bwMJ4Exz/U/D9J4iYQ72AFiSw==
X-Received: by 2002:a17:902:7288:: with SMTP id d8mr27304060pll.133.1564419574724;
        Mon, 29 Jul 2019 09:59:34 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id i198sm60784651pgd.44.2019.07.29.09.59.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:59:34 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        toke@redhat.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2 5/6] selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
Date:   Mon, 29 Jul 2019 09:59:17 -0700
Message-Id: <20190729165918.92933-6-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

Expose bpf_tcp_gen_syncookie to selftests.

Signed-off-by: Petar Penkov <ppenkov@google.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index f804f210244e..120aa86c58d3 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -228,6 +228,9 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
 static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
+static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
+					  int ip_len, void *tcp, int tcp_len) =
+	(void *) BPF_FUNC_tcp_gen_syncookie;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
-- 
2.22.0.709.g102302147b-goog

