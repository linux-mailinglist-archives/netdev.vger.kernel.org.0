Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4622FFA0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgG1CaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgG1CaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 22:30:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C6EC061794;
        Mon, 27 Jul 2020 19:30:12 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b14so15659780qkn.4;
        Mon, 27 Jul 2020 19:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LghMRY0eJz69FvNdTsfGPJkdBB+xNH9H4rz/7MbnCRI=;
        b=bnJMCKAIkqv0DGEntX13OzGGsZW0+aLpEjGvdVH+nwpdCRplj4EbvcqI8cbWbjSJBt
         ESwvwcvL3cM/CMZjuhngVhK6SR/K9NLKWx1wgtzSxQsFKhuHTBvbY+oisLuA9J/fUvLZ
         W+32kca1wzmT/Hl7g1nITD/8xfQJShz4P/N2EEOexgDzSpRxuq66oPEaUrLncjzd/bea
         oamgmazXldhBcjM32ClHTQ110SD4Og1HV4BekIr4hfA78fLILc8ilNwuHGFCGGcTBdim
         3HmJzPqwMwpu81xHRInRsucvn0hkNc2h1EPFLrK4blGnw2CSM/RPHLJ7KBY+2sP85y4U
         ijJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LghMRY0eJz69FvNdTsfGPJkdBB+xNH9H4rz/7MbnCRI=;
        b=jxTeL7Z6O7IhslM/fzYONhOpgkFapx7McCHzRSxjOYA7m7UZK9dQvBTTbCN8rLJv5B
         c8fS3Ica1L48GpGkLrLCSAvmQfjCOjbQ53MNijNgfuURC468kA80QyteVpY20vCb6MFO
         CSW+yJs0F8nBAYq04F8kx5oNTUNZv5ccd9b+FUhq57KES1h9qkP+rq+bpfuzrndz7Hs1
         xeltUbDAzmJkECcKMS2SPYD2SPZdyMOg2ocKQNQAzYR01L7kuOsktyU1t/dw3xLdlF4R
         Dm2xo5f097B6h6HqjPb6TWevRtZlMIx4V/G6ZbEYjO5smvF0eVrvxFLNJXZSxbSGxavz
         sWzQ==
X-Gm-Message-State: AOAM532yMoFFPJzdVWTAKJaRVoN5AjL4NpwUlL57f7faEmZPCyaiqoy2
        xPCjPyJpJzbwRIbu83HUMg==
X-Google-Smtp-Source: ABdhPJxMp6DcUWEKQIocOpTM4d9HTvWLZLU8wxIErmHS9bFo53Aq3b3460+pTV09zE/YLSONmTToNA==
X-Received: by 2002:a37:4916:: with SMTP id w22mr26521332qka.246.1595903411573;
        Mon, 27 Jul 2020 19:30:11 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id x12sm19496229qta.67.2020.07.27.19.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 19:30:10 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] xdp: Prevent kernel-infoleak in xsk_getsockopt()
Date:   Mon, 27 Jul 2020 22:28:59 -0400
Message-Id: <20200728022859.381819-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_getsockopt() is copying uninitialized stack memory to userspace when
`extra_stats` is `false`. Fix it by initializing `stats` with memset().

Cc: stable@vger.kernel.org
Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/xdp/xsk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 26e3bba8c204..acf001908a0d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -844,6 +844,8 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 		bool extra_stats = true;
 		size_t stats_size;
 
+		memset(&stats, 0, sizeof(stats));
+
 		if (len < sizeof(struct xdp_statistics_v1)) {
 			return -EINVAL;
 		} else if (len < sizeof(stats)) {
-- 
2.25.1

