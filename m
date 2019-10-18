Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE694DBCB8
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbfJRFLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:11:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36568 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbfJRFLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:11:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so3101115pfr.3;
        Thu, 17 Oct 2019 22:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lt7tB1LeS2Sex/M1UY8JvLWxPnjBGbRvOSpWI/WAnhY=;
        b=QXtQOSFwlpgYpLscplD6fS8aglXutf62lteg1WU9ZZfAiczK5JpzBC/uj4c6pZCrVi
         mLC5q+f+vFwCpsUNiZEQ1uxUxAN3UCSFg5SHqGDqwp9Kmgc9vRXxMcYHD0ndJLbgjnb8
         4unNOzDzJjT1TM3Fr5Fzp72sxR+x0KUonP+H/KD83u+twq8ec16p8JoUU/uVTzhV79t3
         ndXhFvfUFWbOnsHqNx6h4knny5/Ngrd6Mg3VzOrTpzdHv4oXuH5vCLyK6PiBfo1DMwsi
         Hz89jCBqPoUCqjv1wzPC2vYWFOf275cKZHiY3KW8cu7va1MdgcPeUz4bxjyYk96hyTDm
         l+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lt7tB1LeS2Sex/M1UY8JvLWxPnjBGbRvOSpWI/WAnhY=;
        b=J+VexhfHff1iG2985ZY8ixEf4eDb1lpJlSpGzD+vnFT1PANPCABO8Iwg9df7XcXed6
         pJDmvfQ2f2f6B6FNvBsewDgj8SdtctfjHtAngFY4RjfYXzhynFkWb7VS9zSFOcn0Grue
         VdidbSqLezx+8eengjVMED/KyFDEx5XfU3UNadh3VFrFwjTRowHGsHKKepY8lDVZLmoB
         rnaOjA8oFwNwMKVnujHMgFWcgCAYPuD5WC3f8+O2CrSIa0AOvnPgbCf/bZCvq1SQtW+4
         kX2IBmBVbBJrezC/kYaD7AJ5wRVaXagqVGeE9XEIXDQpphsajilQW9n0NdbrFeJPikzS
         XkgA==
X-Gm-Message-State: APjAAAWWm2LD4AbgXza5tbulbEf1QqWodvugTBq1ifzdY5/KXoI3eQWk
        qtIe9jNWCZCGpo28oL2No1CQeuX8
X-Google-Smtp-Source: APXvYqyE+Nt0AFAIr6XgIzy9G75sgU6aYtXbvU7B0Yj2FMFQq8X+HLgJQbeIvbNHLsgOzTK4zp7PuQ==
X-Received: by 2002:a17:90a:3628:: with SMTP id s37mr8608320pjb.38.1571371770338;
        Thu, 17 Oct 2019 21:09:30 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:09:29 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 14/15] i40e: prefetch xdp->data before running XDP prog
Date:   Fri, 18 Oct 2019 13:07:47 +0900
Message-Id: <20191018040748.30593-15-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP progs are likely to read/write xdp->data.
This improves the performance of xdp_flow.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e3f29dc..a85a4ae 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2207,6 +2207,7 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 	if (!xdp_prog)
 		goto xdp_out;
 
+	prefetchw(xdp->data);
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-- 
1.8.3.1

