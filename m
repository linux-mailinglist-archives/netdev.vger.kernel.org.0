Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C934169A4
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 03:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243825AbhIXBx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 21:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243813AbhIXBxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 21:53:46 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EE1C061756;
        Thu, 23 Sep 2021 18:52:14 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q81so22718439qke.5;
        Thu, 23 Sep 2021 18:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k6nLk3aL6nBiH7JDC988keu7nNQDGEdARxJpeWOPbtg=;
        b=bs3jrrPiAUQqyENrDpO6ddMqHbSjldAUrr3MNq/QkCGDD22auAE8lwaFo7PNUpwtZ8
         SLm7GXnx7gUGwOm2gvUh0Qei49XZLvx+iOycESLPa9x6rdPdAXpCt4Pd7xz3/tukoxaz
         UlRYNdFK0UyKntRBLL9ScK1rwu1XY163w5GAKzhRPRX2QVR3cP9nsxtqnhjG7vrwfChw
         TuwVXn/RC3kcCFz5oHuxft/KTGHk9GrfskxhiI6WWy6WzSnD9tIOvbCWREV39TRzw6FO
         8SjYlZrTwL15KCERaSEEH346UGbiZQJj3UFE14NLha712KAPKoOAMSrBWGn9Ms2WYRuF
         tWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k6nLk3aL6nBiH7JDC988keu7nNQDGEdARxJpeWOPbtg=;
        b=5gVmi/euFt3Agbfryd0s2UVmgq+0Z7fHNM25N62ydS2pDP4bZCNPkaPDvOYRTWSJ+b
         GZ+Kp/xl8mRhguef+6YHYXvJafFsTsGH4HukHmRuIvzAa+P2kq59imMadi8CkTJblqvt
         +c+RdwcsJxEYtA+ixjIg+cNTgCi8r8NAYKsgVv/mD/ThaRTjd+O/3ZfUhRBLIrNGLnBl
         zXngBaEzB0K8sxQf/SMI9syG6ojHCV7ISzt9hQ0w8JR6sGBPHjR/mQgqfX2g/M188eum
         q7NmZEDbOWbG1Bb4oFuRsQuA/p9ueb6Ow7eTT1zsJzuguj1kq/Eb5kes2gIxCeZtvg9z
         yXMQ==
X-Gm-Message-State: AOAM5313T3nmi8I0jVrf+QfRQCRoAteb/sl6RUAWv5pRquvVTK6myJCV
        lLg6ylHHfrvoLilM/byD29c=
X-Google-Smtp-Source: ABdhPJyiHxHR1dzN5tK9aZzz23jTjfZwrzwxIthx8aJyfqQazkX3v8zFWi1XJWHnJxc0DNjzfIaxdQ==
X-Received: by 2002:a37:aac6:: with SMTP id t189mr8019507qke.88.1632448333813;
        Thu, 23 Sep 2021 18:52:13 -0700 (PDT)
Received: from t14s.localdomain ([177.220.174.161])
        by smtp.gmail.com with ESMTPSA id z1sm4918463qki.42.2021.09.23.18.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 18:52:13 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 10B1967FA8; Thu, 23 Sep 2021 22:52:11 -0300 (-03)
Date:   Thu, 23 Sep 2021 22:52:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net] sctp: break out if skb_header_pointer returns NULL
 in sctp_rcv_ootb
Message-ID: <YU0vSytl5kjXYe9k@t14s.localdomain>
References: <8f91703995c8de638695e330c06d17ecec8c9135.1632369904.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f91703995c8de638695e330c06d17ecec8c9135.1632369904.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 12:05:04AM -0400, Xin Long wrote:
> We should always check if skb_header_pointer's return is NULL before
> using it, otherwise it may cause null-ptr-deref, as syzbot reported:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
>   RIP: 0010:sctp_rcv+0x1d84/0x3220 net/sctp/input.c:196
>   Call Trace:
>   <IRQ>
>    sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1109
>    ip6_protocol_deliver_rcu+0x2e9/0x1ca0 net/ipv6/ip6_input.c:422
>    ip6_input_finish+0x62/0x170 net/ipv6/ip6_input.c:463
>    NF_HOOK include/linux/netfilter.h:307 [inline]
>    NF_HOOK include/linux/netfilter.h:301 [inline]
>    ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
>    dst_input include/net/dst.h:460 [inline]
>    ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
>    NF_HOOK include/linux/netfilter.h:307 [inline]
>    NF_HOOK include/linux/netfilter.h:301 [inline]
>    ipv6_rcv+0x28c/0x3c0 net/ipv6/ip6_input.c:297
> 
> Fixes: 3acb50c18d8d ("sctp: delay as much as possible skb_linearize")
> Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
