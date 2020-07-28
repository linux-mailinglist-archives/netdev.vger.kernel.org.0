Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315FD2301E1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgG1FhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgG1FhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:37:22 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31EBC061794;
        Mon, 27 Jul 2020 22:37:22 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s23so14036660qtq.12;
        Mon, 27 Jul 2020 22:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z7EWQYD7wy6xCJAzFJ7nXjY1PCd7b/cbV/q3G3Duy1U=;
        b=t+NKvYabQIvU/bHs2WsL/A56+4mEPwZyGuCuo2EDSpO7Cn1xgAdMW091HIp4X0cdeW
         VIEiRb/BQ0nAhKJWIXHOgMgBTfOL8Zicv+XDvRfD/8C51MHVvRk7q+aGL64IwS9GACQI
         jc7rFwTNzHcpyifukhI3hDWXpXauBuu86JnCdLxEtAOnyWJA7o7wfomtIQ10EM8Fs3xM
         RUUmBSHz0Ula/jnvdWOo9zuYXWfiPdfuOgmok3hEfzfKUlDSG1FGt9QPeuEcwNPE+9YU
         AX1ZbamMYUepk0RXfjSV8iocfUKnvwl3HWPIF4eAWN8L7q9jT3jtBC9HNOOYVWTJfdIP
         abcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z7EWQYD7wy6xCJAzFJ7nXjY1PCd7b/cbV/q3G3Duy1U=;
        b=jh0uSwbtiJTKLgs/OkfKARjcvQrjdbjQ1ktgi2yE/7K1j1v35wvATILid5omw2aaXx
         5jOVM1QzED5O6FZ7osLY9bve6aw07s+AzkMksZKE1i0HZqxgpsYc5E86UavyMx6kJVIN
         11xVrifSLxB4LnPR4I6h3fiVtuxlIJd5W+ClAHcHvkTPZ0k3eiz2s+2btn60N/r8spl4
         SbNNRf847UpeneI+c54mn1ibQkkJc/axfDORL4Ai0/9NThyEJ9AdQ+aQSyV90JLprU1g
         oXmmp1nE7mw2apP8JpQk+BEOfMc4+PrZdWKe1DekoiJthuia3htpI8BaZyWedZJChs34
         I+Tw==
X-Gm-Message-State: AOAM531IrO2W1fueBuKSJqNpgxtogfgnc9l3aNELM45oZNa0IHeG0IFq
        H5Z6KNJGdylBNh2Cd/tiQA==
X-Google-Smtp-Source: ABdhPJweN6bn9NhBF9KiMYU9STaREohK2QHtDH4joic0d2gYLwLSMzbMZq23Ys2LH0vazmtYJv5tNw==
X-Received: by 2002:aed:3387:: with SMTP id v7mr24245834qtd.318.1595914641882;
        Mon, 27 Jul 2020 22:37:21 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id u42sm20985975qtu.48.2020.07.27.22.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 22:37:21 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Song Liu <songliubraving@fb.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
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
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net v2] xdp: Prevent kernel-infoleak in xsk_getsockopt()
Date:   Tue, 28 Jul 2020 01:36:04 -0400
Message-Id: <20200728053604.404631-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200728022859.381819-1-yepeilin.cs@gmail.com>
References: <20200728022859.381819-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_getsockopt() is copying uninitialized stack memory to userspace when
`extra_stats` is `false`. Fix it.

Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Doing `= {};` is sufficient since currently `struct xdp_statistics` is
defined as follows:

struct xdp_statistics {
	__u64 rx_dropped;
	__u64 rx_invalid_descs;
	__u64 tx_invalid_descs;
	__u64 rx_ring_full;
	__u64 rx_fill_ring_empty_descs;
	__u64 tx_ring_empty_descs;
};

When being copied to the userspace, `stats` will not contain any
uninitialized "holes" between struct fields.

Changes in v2:
    - Remove the "Cc: stable@vger.kernel.org" tag. (Suggested by Song Liu
      <songliubraving@fb.com>)
    - Initialize `stats` by assignment instead of using memset().
      (Suggested by Song Liu <songliubraving@fb.com>)

 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 26e3bba8c204..b2b533eddebf 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -840,7 +840,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 	switch (optname) {
 	case XDP_STATISTICS:
 	{
-		struct xdp_statistics stats;
+		struct xdp_statistics stats = {};
 		bool extra_stats = true;
 		size_t stats_size;
 
-- 
2.25.1

