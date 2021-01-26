Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A0C305584
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316989AbhAZXNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbhAZV4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:56:17 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E96C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:55:36 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id a16so37057uad.9
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=HosYyu35KFRQMJ/ug+tmIw8N30Je7DemJ1Md5cmBAYQ=;
        b=RbmBk8B1+dnA5EMzvqOZ4xKpQgnpb+aDTXexrNth03T2O0J0/85zYzwbyNAAPCyag8
         4vtUKt3sdEvgWLrZMmctUNxERwZSgpXjOqQX6RZYli1N1IJRPi0FkWC46lVHs9C1hQud
         dQVePFORscjy/BUK5qL/83OmcyVq9zPTNY/GOEgD1P7SOsI0wLODJ2XfJbgfaLwJ6kpW
         JwNyECWaXGk6a5VyvrBakwaGqZeAc6JvlmHCoRKDXUnSjLDRPQI7F8TIXrXGeNAxveY5
         L21yVJ2Z18LCXThgBMXpF5r5bodbZWWuSCIqQmbrYlUbNZrP2ReVFAbJSra+HUWuL4FB
         XHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=HosYyu35KFRQMJ/ug+tmIw8N30Je7DemJ1Md5cmBAYQ=;
        b=LnpiG9UONkxeeDBH2bgGOhNBiIowYPBs+A8+MpOMeBQPCQY5Yq056tYLEeu6hOHLXV
         V0H6t0qoENU501T7J3JcfRC4x5jYDSefW6j5ppdhn877q53MB6qDIA+zOm7PRRbw0BsH
         /Uwr1MxNtZa0m7tgpE6LG7AmjsRBp61jFnHQzubB7JTz2z6Pl8a8ujcpWrS3zuOJcMx7
         tibu/MDSaVi5pAJ4KBbJOvXj2UBfHx1cYIO39GX3th14X2rQ4Tk3ru8Hb6ghT2pG581r
         95In7I1Zm/Y4aLbhc3ccYARO0uAc+Zx9sBvnpvTd1v7W1ASeJvxoKLKE41XaSgndS4kE
         QP5Q==
X-Gm-Message-State: AOAM532b83a4IDZgUjbO34JkBVOOEordO7lpft+NryQ8M6+Evlbpy8Lk
        vc6WHVyPgFn/n1rpABbE565bccSEtrs=
X-Google-Smtp-Source: ABdhPJxVLxIX/B739vz1Nef0rKGu/gfpiy6TD3Bm9H355m7ozqTXRJVHUSO0AaH7y/CsaBZGwBq/yQ==
X-Received: by 2002:ab0:4063:: with SMTP id h90mr6250578uad.6.1611698134887;
        Tue, 26 Jan 2021 13:55:34 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id b4sm19432vke.38.2021.01.26.13.55.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 13:55:33 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id k47so52826uad.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:55:32 -0800 (PST)
X-Received: by 2002:ab0:2388:: with SMTP id b8mr6088114uan.122.1611698132248;
 Tue, 26 Jan 2021 13:55:32 -0800 (PST)
MIME-Version: 1.0
References: <20210126141248.GA27281@optiplex>
In-Reply-To: <20210126141248.GA27281@optiplex>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 16:54:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
Message-ID: <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
Subject: Re: UDP implementation and the MSG_MORE flag
To:     kernelnewbies@kernelnewbies.org,
        Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 9:58 AM Oliver Graute <oliver.graute@gmail.com> wrote:
>
> Hello,
>
> we observe some unexpected behavior in the UDP implementation of the
> linux kernel.
>
> Some UDP packets send via the loopback interface are dropped in the
> kernel on the receive side when using sendto with the MSG_MORE flag.
> Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
> example code to reproduce it is appended below.
>
> In the code we tracked it down to this code section. ( Even a little
> further but its unclear to me wy the csum() is wrong in the bad case)
>
> udpv6_recvmsg()
> ...
> if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
>                 if (udp_skb_is_linear(skb))
>                         err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
>                 else
>                         err = skb_copy_datagram_msg(skb, off, msg, copied);
>         } else {
>                 err = skb_copy_and_csum_datagram_msg(skb, off, msg);
>                 if (err == -EINVAL) {
>                         goto csum_copy_err;
>                 }
>         }
> ...
>

Thanks for the report with a full reproducer.

I don't have a full answer yet, but can reproduce this easily.

The third program, without MSG_MORE, builds an skb with
CHECKSUM_PARTIAL in __ip_append_data. When looped to the receive path
that ip_summed means no additional validation is needed. As encoded in
skb_csum_unnecessary.

The first and second programs are essentially the same, bar for a
slight difference in length. In both cases packet length is very short
compared to the loopback device MTU. Because of MSG_MORE, these
packets have CHECKSUM_NONE.

On receive in

  __udp4_lib_rcv()
    udp4_csum_init()
      err = skb_checksum_init_zero_check()

The second program validates and sets ip_summed = CHECKSUM_COMPLETE
and csum_valid = 1.
The first does not, though err == 0.

This appears to succeed consistently for packets <= 68B of payload,
fail consistently otherwise. It is not clear to me yet what causes
this distinction.
