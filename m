Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11EC224676
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgGQWvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQWva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 18:51:30 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5D3C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:51:30 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id h17so4964666qvr.0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hv0XnQOWtY9OCjlsU2Dp0Tl7Vxt5Fgqvo4el6dpIGg=;
        b=MAebQTUSbhdYLEb5CMo78L3phVfs643syXjQrGmgEUFB7xSE5+n5QqBjG9mFqx1R29
         WrRqnuQ4A41+BGog6PUjhR1F640b3kUEedzpq86DIQYLo100UNBHa7gaiI6Q/1/UB9L1
         S0YMfd0usB4JWjxmJAMRJgMuqRJjxLbnkrO3eXquE2KN+k3u/YAHP9fGbSeE0MCeHRIP
         7xRgbVZHsMBwBHGF/LxZSO4C8cvVF3bAyur/PXF2IutLX/+/2fv3OgTvfeJeUt7zHx0W
         k/U2aXPeDckVBSfdV0ZdwyQJbQD888EuQqG3ml4JnegtgsdCEnWKCqgZPUK67DQZtu9Q
         E3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hv0XnQOWtY9OCjlsU2Dp0Tl7Vxt5Fgqvo4el6dpIGg=;
        b=iBKaGIRksJhwZB680v2vZB8n+4HQdvU4DlxmjekQL2BPa6zIJv3YpqkfesYPtMIElM
         Ez7eee/mSgucU9zAPP9hxQoxj3I1BK/cIUmMTm65i4cKxaaT9XOkbNgSvDhVk41lmVRt
         EBj1N/0cySkWzmp1NKz3V7qyVLlpFBPagwVNDN/XMoJOy0kGUoXSJBnitkNMwQjDm6em
         hJMYFbjGM+hMAzqE9IcDjDcQvFoHGxx9xI26EiUhypB0h6f1WpassJfYqItLHkdOz3Py
         c2URvuvs8Y51z6r6vjXIOvwjLVSMebU9jIt1iytAZzyPRNiNRRcjULD4XI94lVSLtw0g
         CEnw==
X-Gm-Message-State: AOAM533ARCN6+oeI80/xnH7Lmitdr7NRy19K1Gtl6Cb9RuiTgy20oupw
        oi4TYMa9R39rDSJ620JG1OObsiou
X-Google-Smtp-Source: ABdhPJy7FgDRinf/meNIXvo4eHR7niOF/C0OAHshq3CGY+OxpS1bqy7kN6ANsbqrdsOoGjx/oqMbLg==
X-Received: by 2002:a05:6214:170a:: with SMTP id db10mr11289479qvb.216.1595026289446;
        Fri, 17 Jul 2020 15:51:29 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id j24sm10651833qkl.79.2020.07.17.15.51.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 15:51:28 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id c14so5241627ybj.0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:51:28 -0700 (PDT)
X-Received: by 2002:a25:ae4f:: with SMTP id g15mr17868735ybe.441.1595026287708;
 Fri, 17 Jul 2020 15:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAPGpzNf5oRy7Vuesi2Y_aVj_B66ZUsQRKk+yQAF9g8TbASj=3Q@mail.gmail.com>
In-Reply-To: <CAPGpzNf5oRy7Vuesi2Y_aVj_B66ZUsQRKk+yQAF9g8TbASj=3Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 17 Jul 2020 18:50:50 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeR-M56yJbYNeE4j4+4kQ6Mi4P2DrxQAdoFSkvoWKHxJw@mail.gmail.com>
Message-ID: <CA+FuTSeR-M56yJbYNeE4j4+4kQ6Mi4P2DrxQAdoFSkvoWKHxJw@mail.gmail.com>
Subject: Re: Unexpected PACKET_TX_TIMESTAMP Messages
To:     Matt Sandy <mooseboys@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 1:52 PM Matt Sandy <mooseboys@gmail.com> wrote:
>
> I've been playing around with raw sockets and timestamps, but seem to
> be getting strange timestamp data back on the errqueue. Specifically,
> if I am creating a socket(AF_PACKET, SOCK_RAW, htons(ETH_P_IP)) and
> requesting SO_TIMESTAMPING_NEW with options 0x4DF. I am not modifying
> the flags with control messages.
>
> On both send and receive, I get the expected
> SOL_SOCKET/SO_TIMESTAMPING_NEW cmsg (in errqueue on send, in the
> message itself on receive), and it contains what appears to be valid
> timestamps in the ts[0] field. On send, however, I receive an
> additional cmsg with level = SOL_PACKET/PACKET_TX_TIMESTAMP, whose
> content is just the fixed value `char[16] { 42, 0, 0, 0, 4, <zeros>
> }`.
>
> Any ideas why I'd be getting the SOL_PACKET message on transmit, and
> why its payload is clearly not a valid timestamp? In case it matters,
> this is on an Intel I210 nic using the igb driver.

This is not a char[16], but a struct sock_extended_err.

The first four bytes correspond to __u32 ee_errno, where 42 is ENOMSG.
The fifth byte is __u8 ee_origin, where 4 corresponds to
SO_EE_ORIGIN_TIMESTAMPING.

This is metadata stored along with the skb by __skb_complete_tx_timestamp.
This helps demultiplex timestamps received from the error queue from
other messages.

Additionally, in the case of timestamps it may include additional
associated information:

        serr->ee.ee_info = tstype;
        serr->opt_stats = opt_stats;
        serr->header.h4.iif = skb->dev ? skb->dev->ifindex : 0;
        if (sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID) {
                serr->ee.ee_data = skb_shinfo(skb)->tskey;
                if (sk->sk_protocol == IPPROTO_TCP &&
                    sk->sk_type == SOCK_STREAM)
                        serr->ee.ee_data -= sk->sk_tskey;
        }

The fact that the field after ee_origin is zero means that this is a
timestamp captured at device transmit (SCM_TSTAMP_SND), for instance.

The csmg_level and type themselves are chosen on recv errqueue in
packet_recvmsg:

        if (flags & MSG_ERRQUEUE) {
                err = sock_recv_errqueue(sk, msg, len,
                                         SOL_PACKET, PACKET_TX_TIMESTAMP);
                goto out;
        }
