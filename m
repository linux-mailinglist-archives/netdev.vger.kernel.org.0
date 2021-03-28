Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093CC34BC45
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 14:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhC1MG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 08:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhC1MF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 08:05:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DA2C061762;
        Sun, 28 Mar 2021 05:05:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 33so1776146pgy.4;
        Sun, 28 Mar 2021 05:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bh7FpP7ll2rb0ew3xIuqAoIB0GKlnqepEv7+KeRSy+0=;
        b=aDxFeDSRpHfeC0QquDjRtHbg47SsLq1G3W9Egd6ch/sBvaDCQzTSxBMdTxJfmoDFjn
         YFfMGJL6f+noevkRJAsTXyjCFNcS0LSXF1DPLqVB6cXVrbRvSzz6+a7hZnlOgdkMZ8iJ
         uyJigQGqY+pMvbiULBOpJ9KWJSeYnrR48mUsxoMoQ7R18AhfcuScFIojUKHofITBu/XW
         PYcsN0xCt4iabu/p/EBsAxf2Bp4LQgexzD6cJ0qVqthnR28nOKMWrenZ7oO7aE10Y8BA
         lOJKk5LX8CrhxMgbw7qDSpJD/hc/Z+zr1JEjUyBCKw9KUTVl0Yy2qMVgULV1h5bACHJn
         khbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bh7FpP7ll2rb0ew3xIuqAoIB0GKlnqepEv7+KeRSy+0=;
        b=RsBxQCWshrk+bNmwMGNWboVe3/KmhkVPp2TaJTZ9tNqQxRfzWnk9B2qrFSK3vX/8SA
         2AE6db2PmJTlAXVdK8fl50pIuwK5D/FQ66XXA2ug4Uo+4Mhgn2pD6Ig73FSu5ENowN6K
         CrbEKUfBefNw5QU2ddCPOG8MxxxUT7nvhdgipgOM52ZFisxR1zqA1pH6b5RBIbckd+jY
         oLNubvR4srSVvBgBhPU2mKaoxVD4hPtIWd1yCGUjpv20kngXqPpvX+ny93E/P107wJZu
         sAA1GuNZrnxuRNUG5bMd6KIWF4zkroirPOs3ae7TbDsDhcfvuroRasOYAkh5q/Jo07/J
         75zw==
X-Gm-Message-State: AOAM533/02AnD+KIer4cTPGtQWUmz/tFovjMkqQBWaFQhWJVCNzVRXTF
        woY/jM5lnybw0HyVa2GQyppk8STaZJq7tFsL
X-Google-Smtp-Source: ABdhPJw75mA8YVf01PjO5ZIpfSaDgVtNIzdzcXlrnhwXj/Anvfw/E318D2ivs7Os+0erTAXcgD90Mg==
X-Received: by 2002:a65:538f:: with SMTP id x15mr20180856pgq.429.1616933156973;
        Sun, 28 Mar 2021 05:05:56 -0700 (PDT)
Received: from localhost.localdomain ([136.185.95.200])
        by smtp.gmail.com with ESMTPSA id y12sm14483328pfq.118.2021.03.28.05.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 05:05:56 -0700 (PDT)
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        syzbot+0b74d8ec3bf0cc4e4209@syzkaller.appspotmail.com
Subject: [PATCH bpf-next] bpf: tcp: Remove comma which is causing build error
Date:   Sun, 28 Mar 2021 17:35:15 +0530
Message-Id: <20210328120515.113895-1-atulgopinathan@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, building the bpf-next source with the CONFIG_BPF_SYSCALL
enabled is causing a compilation error:

"net/ipv4/bpf_tcp_ca.c:209:28: error: expected identifier or '(' before
',' token"

Fix this by removing an unnecessary comma.

Reported-by: syzbot+0b74d8ec3bf0cc4e4209@syzkaller.appspotmail.com
Fixes: e78aea8b2170 ("bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc")
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
---
 net/ipv4/bpf_tcp_ca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 40520b77a307..12777d444d0f 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -202,15 +202,15 @@ BTF_ID(func, dctcp_cwnd_undo)
 BTF_ID(func, dctcp_state)
 #endif
 #if IS_BUILTIN(CONFIG_TCP_CONG_BBR)
 BTF_ID(func, bbr_init)
 BTF_ID(func, bbr_main)
 BTF_ID(func, bbr_sndbuf_expand)
 BTF_ID(func, bbr_undo_cwnd)
-BTF_ID(func, bbr_cwnd_even),
+BTF_ID(func, bbr_cwnd_even)
 BTF_ID(func, bbr_ssthresh)
 BTF_ID(func, bbr_min_tso_segs)
 BTF_ID(func, bbr_set_state)
 #endif
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
 
 static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
-- 
2.25.1

