Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBBA37FFBE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 23:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhEMVUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 17:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233360AbhEMVUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 17:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620940738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4u0P1QwlIxwXI4r0dMrVxAOO4Ho2sPgYEPbkXjDOoQQ=;
        b=O5B7hkHBAFSu1vy5LB0OzVVl2m4gmq7R20CsDC2/Kc5mS0PSLinkOC1SdaMnOiFL5fGnF4
        0L4mPCwL5u8OEGKSo5kbZpMKDWChoxZxlU90cRO/yTR05+usD9+gqBA+O2zFxyI3MrlWci
        WzlLmsUAVnRHtL0Z6CbO6MxO8ZHkG4A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-Fwfm8EK4PYKkcdxUGYWgHQ-1; Thu, 13 May 2021 17:18:56 -0400
X-MC-Unique: Fwfm8EK4PYKkcdxUGYWgHQ-1
Received: by mail-wr1-f71.google.com with SMTP id c13-20020a5d6ccd0000b029010ec741b84bso3289823wrc.23
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 14:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4u0P1QwlIxwXI4r0dMrVxAOO4Ho2sPgYEPbkXjDOoQQ=;
        b=N39xDDyIx5mV92w1pkEWlKlJRyhczTBmfarrs6WdSW6rQ0dL1yTsVEN+KkbscZYFAa
         rbp7u7TK7G1qeKhGloY/F+GHwyHlzqunGRAsb3Q/jMmNseBTzUxlr147s6dBV50gGNpd
         bmD111IVjgJDWFuT8EftHL1GHiYG657hlEfCTcDE1oxri6QwOMV1NArZRBQhCvHmXQTT
         Cg2iVLazjSdXrrsXLGZCJcQdnvYB1Gf7O4fo6gc+EaoaYLg1rc+7k79rtXg734Qz3FR8
         fU4gVNEPAS1BmxhlPM6olRPiGKXlI2E3x+7+Ev2XMafQHyPSfHtcPKAuLfv5mn60wB5X
         Hm7g==
X-Gm-Message-State: AOAM533eicLlYm9bwpC+Qi0ufUeLDI7xL3DdGAbij3umsb5cjNCVoapT
        v45lLL5QrAlYsEucwXIDH6QdydBIPy9ZtNU1XurJmrVEJnFH7MvPE+tz2ak4Fj9UHVvCMdfNZV6
        T8BEcXw/AcVwetwwU
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr54404843wro.249.1620940735091;
        Thu, 13 May 2021 14:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnRUDVDbEb/UToMx4PAe4hIW6M8DzVeK1ZrNOf9b1VfBvTkat4vV3rHfWH3kg2fvWEiG08Hg==
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr54404821wro.249.1620940734806;
        Thu, 13 May 2021 14:18:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-162.dyn.eolo.it. [146.241.242.162])
        by smtp.gmail.com with ESMTPSA id j14sm5829859wmj.19.2021.05.13.14.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 14:18:54 -0700 (PDT)
Message-ID: <4ba41620dbba70de6e3fed1356fc1910192cd074.camel@redhat.com>
Subject: Re: Panic in udp4_lib_lookup2
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kaustubh Pandey <kapandey@codeaurora.org>
Cc:     willemb@google.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        sharathv@codeaurora.org, subashab@codeaurora.org
Date:   Thu, 13 May 2021 23:18:53 +0200
In-Reply-To: <20210513194810.GA25255@kapandey-linux.qualcomm.com>
References: <eda8bfc80307abce79df504648c60eae@codeaurora.org>
         <a0728eea0f9f2718a6c4bc0f12ba129f1ed411b7.camel@redhat.com>
         <20210513194810.GA25255@kapandey-linux.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-14 at 01:18 +0530, Kaustubh Pandey wrote:
> On Thu, May 13, 2021 at 10:05:37AM +0200, Paolo Abeni wrote:
> > Hello,
> > 
> > On Wed, 2021-05-12 at 23:51 +0530, kapandey@codeaurora.org wrote:
> > > We observed panic in udp_lib_lookup with below call trace:
> > > [136523.743271]  (7) Call trace:
> > > [136523.743275]  (7)  udp4_lib_lookup2+0x88/0x1d8
> > > [136523.743277]  (7)  __udp4_lib_lookup+0x168/0x194
> > > [136523.743280]  (7)  udp4_lib_lookup+0x28/0x54
> > > [136523.743285]  (7)  nf_sk_lookup_slow_v4+0x2b4/0x384
> > > [136523.743289]  (7)  owner_mt+0xb8/0x248
> > > [136523.743292]  (7)  ipt_do_table+0x28c/0x6a8
> > > [136523.743295]  (7) iptable_filter_hook+0x24/0x30
> > > [136523.743299]  (7)  nf_hook_slow+0xa8/0x148
> > > [136523.743303]  (7)  ip_local_deliver+0xa8/0x14c
> > > [136523.743305]  (7)  ip_rcv+0xe0/0x134
> > 
> > It would be helpful if you could provide a full, decoded, stack trace
> > and the relevant kernel version.
> > 
> > > We suspect this might happen due to below sequence:
> > 
> > Some email formatting made the "graph" very hard to read...
> > 
> > > Time                                                   CPU X
> > > 
> > >                                     CPU Y
> > > t0                                inet_release -> udp_lib_close ->
> > > sk_common_release -> udp_lib_unhash
> > > inet_diag_handler_cmd -> udp_diag_destroy -> __udp_diag_destroy ->
> > > udp_lib_rehash
> > 
> > ... but it looks like udp_lib_close() is missing a
> > lock_sock()/release_sock() pair. Something alike:
> > ---
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index 360df454356c..06586b42db3f 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -209,7 +209,9 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
> > 
> >  static inline void udp_lib_close(struct sock *sk, long timeout)
> >  {
> > +	lock_sock(sk);
> >  	sk_common_release(sk);
> > +	release_sock(sk);
> >  }
> > 
> >  int udp_lib_get_port(struct sock *sk, unsigned short snum,
> > ---
> > 
> > could u please give the above a spin in your testbed?
> > 
> > Thanks!
> > 
> > Paolo
> > 
> > 
> Hi Paolo,
> 
> Pls find full backtrace:
> [136523.743141]Unable to handle kernel paging request at virtual address
> 00000c08ff000820
> 
> [136523.743147]Mem abort info:
> [136523.743150]  ESR = 0x96000004
> [136523.743154]  EC = 0x25: DABT (current EL), IL = 32 bits
> [136523.743157]  SET = 0, FnV = 0
> [136523.743159]  EA = 0, S1PTW = 0
> [136523.743162]Data abort info:
> [136523.743164]  ISV = 0, ISS = 0x00000004
> [136523.743167]  CM = 0, WnR = 0
> [136523.743170][00000c08ff000820] address between user and kernel
> address ranges
> [136523.743174]Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [136523.743218]pstate: a0c00005 (NzCv daif +PAN +UAO)
> 
> [136523.743226]pc : udp4_lib_lookup2+0x88/0x1d8
> [136523.743229]lr : __udp4_lib_lookup+0x168/0x194
> 
> [136523.743232]sp : ffffffc039a9b600
> [136523.743234]x29: ffffffc039a9b610 x28: 0000000000000000
> [136523.743237]x27: 0000000000000000 x26: ff000c08ff0007f0
> [136523.743239]x25: ffffffe1e2319b40 x24: 0000000073737272
> [136523.743242]x23: 0000000000003500 x22: 0000000000000000
> [136523.743244]x21: 000000000000a622 x20: 000000000000001a
> [136523.743246]x19: 00000000ffffffff x18: ffffffc02b6d7098
> [136523.743249]x17: 0000000000000000 x16: 0000000000000000
> [136523.743251]x15: 0000000000000000 x14: 0000000000000000
> [136523.743254]x13: 0000000000000000 x12: ffffff81d8e30000
> [136523.743257]x11: 0000000000000fff x10: ff000c08ff0007f0
> [136523.743259]x9 : ff000c08ff000808 x8 : 0000000000000000
> [136523.743261]x7 : ffffff81d8e3e6a0 x6 : 0000000000000000
> [136523.743263]x5 : 000000000000001a x4 : 000000000000a622
> [136523.743266]x3 : 0000000000000000 x2 : 0000000000003500
> [136523.743268]x1 : 0000000073737272 x0 : ffffffe1e2319b40
> [136523.743271]Call trace:
> [136523.743275] udp4_lib_lookup2+0x88/0x1d8
> [136523.743277] __udp4_lib_lookup+0x168/0x194
> [136523.743280] udp4_lib_lookup+0x28/0x54
> [136523.743285] nf_sk_lookup_slow_v4+0x2b4/0x384
> [136523.743289] owner_mt+0xb8/0x248
> [136523.743292] ipt_do_table+0x28c/0x6a8
> [136523.743295] iptable_filter_hook+0x24/0x30
> [136523.743299] nf_hook_slow+0xa8/0x148
> [136523.743303] ip_local_deliver+0xa8/0x14c
> [136523.743305] ip_rcv+0xe0/0x134
> [136523.743309] __netif_receive_skb_core+0x9d0/0xd74
> [136523.743313] __netif_receive_skb+0x50/0x17c
> [136523.743316] netif_receive_skb_internal+0xa0/0xd8
> [136523.743318] netif_receive_skb+0xec/0x1e4
> 
> Kernel version used is 5.4
> 
> Derived from your suggestion I think below change might be more suited
> here:
> diff --git a/net/core/sock.c b/net/core/sock.c
> index f87c9f7..a5dd0e5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3210,7 +3210,9 @@ void sk_common_release(struct sock *sk)
>          * A. Remove from hash tables.
>          */
> +       lock_sock(sk);
>        sk->sk_prot->unhash(sk);
> +       release_sock(sk);

The above will cause deadlock on protocol rightfully calling
sk_common_release under the socket lock (e.g. sctp).

Could you please test the change I suggested in your testbed?

Thanks

Paolo

