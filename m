Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDA1D1CE0
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfJIXeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:34:44 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34171 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731155AbfJIXen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 19:34:43 -0400
Received: by mail-qk1-f194.google.com with SMTP id q203so3911421qke.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 16:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vdrIoqd/RfZ28OwhRCOfdozw628IzLJO5sStHFv022A=;
        b=gjPwuFCNNA8pNxwKEURj9PZxAAYaGD/wAD90ha5sHH+TKfIpIW/zapIcuFUzEQhQS/
         GkrSQhIeTjEBm/P3C7ewm7pq46cxXXQIR9BW1LekHaNWh2ve1BPNM2LVN+5s4HjnvVQO
         vm84T95TXFKKE5K9r1tT1d47UvJgtrPUGQU86PWWWSoQsZaIn5eIgCauH8s2PVk18bXs
         jPlNsHky6z8nUDR0iw1LSifMSNfEiO/P3gbC+DIF3cOxKt/4brIzSxCkFmQegbnpQRZm
         ZHQwxycGP9jjbOzPH3EaLrAlXO8VSlweHzVC1iIseQ0Hu60oYtvfdbfQVhA/iVx3kE8r
         DGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vdrIoqd/RfZ28OwhRCOfdozw628IzLJO5sStHFv022A=;
        b=iRPFXRL42vs8GjK638evb9bOnBE37JgHTXDV+f3uKk8ej8bsoZTuX3E3gZErB2n+MM
         4wHKmCmBonyLD3UKteMjobXmS7llWmTpMxBmxaknlnQWPsAWC/i/E3jDmDTN7bpYwJqf
         WPUwETPMOHGD8x+uxQ1oc2T4vC436mHUdwHvo9B1uXAZKEm+7rhKRZoVC42hGghB6qdU
         9JJqFMeBRW/m26hyPuXT6999Td2rNqhbElelMvKh+MHHafmkQFTMzrglTKTTj8B55/F6
         s+3qfGS+/7Ss9C4VPJRxZgoRzuGD8UsE9o0Ae7Glkc9nzsAyc9wG2pSNb4XLAhqpw6F4
         TWYQ==
X-Gm-Message-State: APjAAAXLSmPhEGhE3Ln3s/9niCKhn1Bp2j0Bcg6hHn29SqCkHO3nKCeV
        gvb6SabTH8r4/DHxZ4JX7dh6ng==
X-Google-Smtp-Source: APXvYqyttF0Ej/1g4rvBTVAyImWArG/1VU0V2z4ILxCvc0trj3ka1iZsjH0dck0FkZkwPbjWPMmUOQ==
X-Received: by 2002:a37:a854:: with SMTP id r81mr6183378qke.443.1570664081351;
        Wed, 09 Oct 2019 16:34:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 44sm1977227qtu.45.2019.10.09.16.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 16:34:41 -0700 (PDT)
Date:   Wed, 9 Oct 2019 16:34:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, omosnace@redhat.com
Subject: Re: [PATCH net] sctp: add chunks to sk_backlog when the newsk
 sk_socket is not set
Message-ID: <20191009163426.4142cfd3@cakuba.netronome.com>
In-Reply-To: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
References: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 19:09:23 +0800, Xin Long wrote:
> This patch is to fix a NULL-ptr deref in selinux_socket_connect_helper:
> 
>   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
>   [...] RIP: 0010:selinux_socket_connect_helper+0x94/0x460
>   [...] Call Trace:
>   [...]  selinux_sctp_bind_connect+0x16a/0x1d0
>   [...]  security_sctp_bind_connect+0x58/0x90
>   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
>   [...]  sctp_sf_do_asconf+0x785/0x980 [sctp]
>   [...]  sctp_do_sm+0x175/0x5a0 [sctp]
>   [...]  sctp_assoc_bh_rcv+0x285/0x5b0 [sctp]
>   [...]  sctp_backlog_rcv+0x482/0x910 [sctp]
>   [...]  __release_sock+0x11e/0x310
>   [...]  release_sock+0x4f/0x180
>   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
>   [...]  inet_accept+0xe7/0x720
> 
> It was caused by that the 'newsk' sk_socket was not set before going to
> security sctp hook when processing asconf chunk with SCTP_PARAM_ADD_IP
> or SCTP_PARAM_SET_PRIMARY:
> 
>   inet_accept()->
>     sctp_accept():
>       lock_sock():
>           lock listening 'sk'
>                                           do_softirq():
>                                             sctp_rcv():  <-- [1]
>                                                 asconf chunk arrives and
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
> 
> Here to fix it by adding the chunk to sk_backlog until newsk sk_socket is
> set when .accept() is done.
> 
> Note that sk->sk_socket can be NULL when the sock is closed, so SOCK_DEAD
> flag is also needed to check in sctp_newsk_ready().
> 
> Thanks to Ondrej for reviewing the code.
> 
> Fixes: d452930fd3b9 ("selinux: Add SCTP support")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, queued for stable, thank you!
