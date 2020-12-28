Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037052E6974
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgL1QtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgL1QtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:49:04 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00CCC061796
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:48:24 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id 17so3512306uaq.4
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=28E+iqzR/ZCpLV3rPjkQtUHGp1Pkn7UdNGwCfj37Ps8=;
        b=AltQHM8uT5Ta+3j7glS4xruGSVQWC59IBA9Pzn4+0b/3LymXjR6o4mNntV3BbdSBg7
         cGuqVQzDGnInYl3su80I/WfgnqsJScITEk18eOlsJmyYdDK1s/bs4DgZVG+G2+G12/+h
         EJ/J/kW4iudP6u2QwqNzfh8Fs8D9iALuF682uxIcFAZnVPS6eUosV4h137mK66XOXyMj
         4vEjbahnfwibIhtyE6OP7ATkYMz7b7LRyjh/mYEMyZ8g6/F1VzhxJmu3Zpd9OPwrq1Y9
         CZHv3r8v9iFGT4fyDBIGtJHi7WQDzhqiRNvUWRIrl/c4WYkO+pHbJM7WxYt6zZpK4XyD
         EASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28E+iqzR/ZCpLV3rPjkQtUHGp1Pkn7UdNGwCfj37Ps8=;
        b=Mz5VPtq+Xx3TuA4gJ2xOq9iQhWxliPAYSjxBOnuya7t7ZRsfWW5+lHK57A6OymZi9s
         DxnO0fOHhdJGS/+EPLmuc+BZeOLOhgkGmxTqTcZlLit/FS1IW6TyKYCDoNez7dmQgmsJ
         D1nUpAU9Os9kZ6higHuXyta8zwuoSL7P/D+94GYGjGKo+TsQ6LkkRcWg5IU/YMxHW37x
         W7Riv6w7GhsmYshAXfk/3cRj/NjODPBx/iHTLQe+hkEgY/CmiLd9NBkd3k4pDB7jZqGT
         NwG2ufrCynfACKp8gZkQlMjaTKNEA6Ysiu4O1EmeNmkXlp4L4MwfHIFsL7w+Tb41BRya
         14ng==
X-Gm-Message-State: AOAM531f9+x6ZW3yEXIdaYFPST+uE4wmHP0n2at7iUP7+UFjZjaNgipS
        dk5zjxvQdwWIwA/goOjQ2sZ8oKAyArA=
X-Google-Smtp-Source: ABdhPJz4UDLlm0r+JR5dHbwXDXH9iGJ1tfq4HS5/qJV99KYMcP73RfHjhhBdb2ObKJIZ4BWfRmvSGA==
X-Received: by 2002:ab0:1eca:: with SMTP id p10mr29872108uak.38.1609174103683;
        Mon, 28 Dec 2020 08:48:23 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id v195sm4518241vsv.7.2020.12.28.08.48.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 08:48:23 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id s2so5815712vsk.2
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:48:22 -0800 (PST)
X-Received: by 2002:a67:bd0a:: with SMTP id y10mr27448729vsq.28.1609174102391;
 Mon, 28 Dec 2020 08:48:22 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-2-willemdebruijn.kernel@gmail.com> <20201228112657-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228112657-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 11:47:45 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdYLxV2O2WiD3D0cy2vaVbiECWheW0j7OGKKgV84wkScA@mail.gmail.com>
Message-ID: <CA+FuTSdYLxV2O2WiD3D0cy2vaVbiECWheW0j7OGKKgV84wkScA@mail.gmail.com>
Subject: Re: [PATCH rfc 1/3] virtio-net: support transmit hash report
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:28 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:22:31AM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Virtio-net supports sharing the flow hash from host to guest on rx.
> > Do the same on transmit, to allow the host to infer connection state
> > for more robust routing and telemetry.
> >
> > Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
> > and updates these fields on error with sk_rethink_txhash. This feature
> > allows the host to make similar decisions.
> >
> > Besides the raw hash, optionally also convey connection state for
> > this hash. Specifically, the hash rotates on transmit timeout. To
> > avoid having to keep a stateful table in the host to detect flow
> > changes, explicitly notify when a hash changed due to timeout.
>
> I don't actually see code using VIRTIO_NET_HASH_STATE_TIMEOUT_BIT
> in this series. Want to split out that part to a separate patch?

Will do.

I wanted to make it clear that these bits must be reserved (i.e.,
zero) until a later patch specifies them.

The timeout notification feature requires additional plumbing between
the TCP protocol stack and device driver, probably an skb bit. I'd
like to leave that as follow-up for now.

Thanks for the fast feedback!
