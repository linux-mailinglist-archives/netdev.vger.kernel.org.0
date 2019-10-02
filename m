Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916B5C4543
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfJBBEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:04:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38747 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfJBBEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:04:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so24196008qta.5;
        Tue, 01 Oct 2019 18:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RV90rTO/8NizoEL3vyRjJ2MhsfOgnhf/LNxyVtWGm9k=;
        b=nv4+NLw/+z0OCEirWCk+wwu52hefuQ2CcYumpMRa9ddeQSi8WBhIOu7Re1wznJHFBq
         McU/1xRWpx2ib+pASnUU1sFFAUV3TbbxM/2stImeKPUeil3lTMZ/gRjK+nHs3FOxx3PJ
         ORM3HTrRnLFqFLZp3sNOJKd5+p7Jm3LJZy4D5/svx/wvqY3dMGc3+VhYwCo6/DVn+v8K
         Cyw2Tj5o1cXl7Xosg+oAo+cKoCj7BkyZxze1mh/FyvQpoRNt3uZ/s3umK7bqbm7Gg9WR
         CCIwLYEe3DtHLTZbqDsubxBJKXMV/8uN3nCCCF66lRhOdp2WCsfAsNajgXu1rMvap8dN
         1dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RV90rTO/8NizoEL3vyRjJ2MhsfOgnhf/LNxyVtWGm9k=;
        b=DYI1GxDYcq+s7cv2WRYh5C+4r5bvScWdqj77Th+ItWIcBIxzElnhlPPuJV79BVEYYF
         8S40AkUr3pfgSglC0ROS/gRRqdL2TL9G317URnjNsgqndhwt2ABVoby82QVU/D/kR1BD
         akT96m1ww646L5XvfTeN4jui+0dB/OA0A88/xkwNfgrKDvWYGEjSo6vui89li9j9H30d
         HwkcJeGzxEN/F9IB34FR8FYTzwBlwQwqthPC+IjhyTXCpQOStEdE93CN9S4Smvcl3uzz
         oEXEEyuW/EJ15gkUXpBBbAt/BnDlzdg4KV/CxKkqklR0hED2qfEUX6kXD+1nihm6Ryu1
         fCyg==
X-Gm-Message-State: APjAAAWX+UFhGuuij7kvQRIw5roztZVOzvaOzyrl1N13WnJzXg4G9mNf
        hgLeFNB99ehoKFdSZOgto8k=
X-Google-Smtp-Source: APXvYqxyE8C+l/PNm0u8qCrIoRcouC44Xmk7fA/6FD8E/y97CdiFMnEITFtgnBuLTFNC9OqYb7jzig==
X-Received: by 2002:ac8:4757:: with SMTP id k23mr1394926qtp.1.1569978239974;
        Tue, 01 Oct 2019 18:03:59 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.85])
        by smtp.gmail.com with ESMTPSA id a190sm9636453qkf.118.2019.10.01.18.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 18:03:59 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B77DAC085B; Tue,  1 Oct 2019 22:03:56 -0300 (-03)
Date:   Tue, 1 Oct 2019 22:03:56 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing
 listening sk backlog
Message-ID: <20191002010356.GG3499@localhost.localdomain>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> 
>   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
>   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
>   [...] Call Trace:
>   [...]  security_sctp_bind_connect+0x58/0x90
>   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
>   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
>   [...]  sctp_do_sm+0x139/0x520 [sctp]
>   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
>   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
>   [...]  __release_sock+0x120/0x370
>   [...]  release_sock+0x4f/0x180
>   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
>   [...]  inet_accept+0xe7/0x6f0
> 
> It was caused by that the 'newsk' sk_socket was not set before going to
> security sctp hook when doing accept() on a tcp-type socket:
> 
>   inet_accept()->
>     sctp_accept():
>       lock_sock():
>           lock listening 'sk'
>                                           do_softirq():
>                                             sctp_rcv():  <-- [1]
>                                                 asconf chunk arrived and
>                                                 enqueued in 'sk' backlog
>       sctp_sock_migrate():
>           set asoc's sk to 'newsk'
>       release_sock():
>           sctp_backlog_rcv():
>             lock 'newsk'
>             sctp_process_asconf()  <-- [2]
>             unlock 'newsk'
>     sock_graft():
>         set sk_socket  <-- [3]
> 
> As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> backlog, as accept() was holding its sock lock. Then at [2] asconf would
> get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> would deref it, then kernel crashed.

Note that sctp will migrate such incoming chunks from sk to newsk in
sctp_rcv() if they arrived after the mass-migration performed at
sctp_sock_migrate().

That said, did you explore changing inet_accept() so that
sk1->sk_prot->accept() would return sk2 still/already locked?
That would be enough to block [2] from happening as then it would be
queued on newsk backlog this time and avoid nearly duplicating
inet_accept(). (too bad for this chunk, hit 2 backlogs..)

AFAICT TCP code would be fine with such change. Didn't check other
protocols.

