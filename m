Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A94F3AEBDA
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhFUO6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhFUO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:58:22 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF90C061574;
        Mon, 21 Jun 2021 07:56:08 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m21so30667362lfg.13;
        Mon, 21 Jun 2021 07:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D+fLSayFG8QxEIC9B2As9be2IazOg0NVf6wn1NOVf4E=;
        b=PZBGTvzeDn9KsAwct4T6Wge0EXTWmvOTibzcJTmVsun4CWv+NixRE0buXYKxhcdMFt
         fPb/W4NecAHaQvs1Zp2xOq6TDIxRDV0zGVboORGEJk2FOqyvmxi7CT+e4LeEYUi60sU7
         5Kp9cJRSIH8w3Xr4r0GPeg+q24xJbWVjT+50IqnlVIlrIzOLGd7tRHcmkfKWaXMdyddF
         +6OyfyelcKrdnzFDztG5NmBgOV+pkGT40PKLKh+/9DNzE/HK7wb4HsAYUd0guefr5C+O
         YfKV7fKkCdfrK9g9IehI4zxW8F6pONUOVEVukLvOm8PLQDQmcIR3F3/RQvaRe1VtUiTl
         0tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D+fLSayFG8QxEIC9B2As9be2IazOg0NVf6wn1NOVf4E=;
        b=FMv9r/dRasZaTTcnLHSib8DL/wefpHNkwVp9jgen+bsRc2dZOD2ialek+m/KnodhSd
         h81Tbm7RGXv3SGuZRbPOrkDMxR53Muh4WXODpXcYZ9w8ZWv+a2ReweCM1f5jBgVFERXv
         qA0mL6hfBuxnF+vocFUHPDnxXrlGzCG1qjQbXMF57eP1f0JqPf+fX7cTS24mKkeHIyXP
         DmbwpFZWfEx6yoyPMGrLWOUWjLIFqGDstH4CH/tUmx18j+XbI+8BIRUQTJSYKHSBkAvG
         PdIoOZrFQTNuqMsRYwY+UVro4PBpvLKboHjZmv/wnL1Ybbi8Ntm8Ht7s7Vjs/CylpwLj
         8DzA==
X-Gm-Message-State: AOAM531wE+IfrEjwhl31QKligrQ9kn+lgKomLC9oNaKg0DXeO7H1Tncm
        54EIIQKV0I1o7SsIdFqzCM0=
X-Google-Smtp-Source: ABdhPJyBqdDZt86UloZZprSO26CdVeIs7opiaXT4ap4bI2egdRDz84K33gK6Kt8te8VVL3rZaORupA==
X-Received: by 2002:ac2:5444:: with SMTP id d4mr14595696lfn.243.1624287366798;
        Mon, 21 Jun 2021 07:56:06 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id f18sm1564215lfc.251.2021.06.21.07.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 07:56:06 -0700 (PDT)
Date:   Mon, 21 Jun 2021 17:56:03 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, kadlec@netfilter.org, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        guvenc@linux.ibm.com
Subject: Re: [syzbot] general protection fault in smc_tx_sendmsg
Message-ID: <20210621175603.40ac6eaa@gmail.com>
In-Reply-To: <000000000000d154d905c53ad34d@google.com>
References: <000000000000d154d905c53ad34d@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Jun 2021 16:22:16 -0700
syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0c337952 Merge tag 'wireless-drivers-next-2021-06-16'
> of g.. git tree:       net-next
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=1621de10300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=a6380da8984033f1
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=5dda108b672b54141857 syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=121d2d20300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100bd768300000
> 
> The issue was bisected to:
> 
> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Apr 21 07:51:08 2021 +0000
> 
>     netfilter: arp_tables: pass table pointer via nf_hook_ops
> 

I think, bisection is wrong this time :)

It should be e0e4b8fa533858532f1b9ea9c6a4660d09beb37a ("net/smc: Add SMC
statistics support")


Some debug results:

syzkaller repro just opens the socket and calls sendmsg. Ftrace log:


 0)               |  smc_create() {
 0)               |    smc_sock_alloc() {
 0) + 88.493 us   |      smc_hash_sk();
 0) ! 131.487 us  |    }
 0) ! 189.912 us  |  }
 0)               |  smc_sendmsg() {
 0)   2.808 us    |    smc_tx_sendmsg();
 0) ! 148.484 us  |  }


That means, that smc_buf_create() wasn't called at all, so we need to
check sndbuf_desc before dereferencing

Something like this should work

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 075c4f4b4..e24071b12 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -154,7 +154,7 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		goto out_err;
 	}
 
-	if (len > conn->sndbuf_desc->len)
+	if (conn->sndbuf_desc && len > conn->sndbuf_desc->len)
 		SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);
 
 	if (len > conn->peer_rmbe_size)


Thoughts?


+CC Guvenc Gulce 


With regards,
Pavel Skripkin
