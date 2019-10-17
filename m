Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1309DA413
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 05:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392088AbfJQDCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 23:02:54 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37945 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392047AbfJQDCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 23:02:53 -0400
Received: by mail-lf1-f66.google.com with SMTP id u28so581708lfc.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 20:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qo/VilSO7837EjszfC0cxM6ucoTePvd/OUYdFz0CGKk=;
        b=gvVeZj3UVqkfCDDQDkaNq1cykm1qg0OGYmXx+x/QW9CwmnhInLLE0Ebw1js8UtzxsT
         /UpnGd48/dHAkbcd2fAKdy3gGSqh9RWlVTJ+kCZlKjhabrpvEh0pzncEXzVwSxGtkyM4
         B3xYprDgcglRbDz14nALpM4UOPCO7nkKZUJj3d4AqfdIYKFhH0ACYBXD+r4nhiLf/w8F
         lnE+LqLUUEjlEweJV2AaoRSVj00YcjQDE40d30zb8I96tZEERb0nwz54EvUAu9wLEYoF
         09wOzEOC0V9iNNYBbUJDSjy/soAVHrDkgQF8Wf6TDh6AkMBF1acMcGkeBiFc7yIL2qWN
         UsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qo/VilSO7837EjszfC0cxM6ucoTePvd/OUYdFz0CGKk=;
        b=eboE+HcQ3VTLRXTyz844O0IkmI2OQwss7gUbJLzRRGkmEtwvhDrlZZFOY1HzpGTJ2m
         dalRNx3EIp8DZI9Hk2fRxtFderiJzAp6/rbFSPXnnNMlILICHp4WPVi/oxyMLWdvhZq5
         CW5Fj7leT1NT8vg5YTOWcRAYkblRoinAty7KI+iChCIn7piR9u9t9ZhBq+BOJ6gBG9ga
         VF6ZyWWBeFMXG65/DBTouS+4Oj21f2X+3V2F0B1+GZjZ9Ex+KV8lewYwvIN5ltOZg9Vy
         xKCbxWp39oDIEQPy1EMny/llLCyQCztzvFHls5Pf+HrtQ2NFpzi6ws3bfSu5nkF2G94n
         65kw==
X-Gm-Message-State: APjAAAUp5E8Gy373gXJdxokovFmQQmvdil8LiOAQLu/CdvKeUEwCk4Xh
        rx46f5kyfG7e/sD8d1aXgghy8JQTUK6cA1mlzjY=
X-Google-Smtp-Source: APXvYqwNwYBXHAllIVlDI14IiPMgk06SIUjUtTr6Z/ZXooyBCAsUtH9bCcqRJP7ptJmRPI2UyHDutcgYYkI4Q+ILGMI=
X-Received: by 2002:ac2:4a6b:: with SMTP id q11mr565239lfp.192.1571281371317;
 Wed, 16 Oct 2019 20:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190318053952.115180-1-komachi.yoshiki@lab.ntt.co.jp> <CAF=yD-K74v6+hH1p0Fn6z7c9KH=4rqzOOaBxr+BqMj4Ydjxt_Q@mail.gmail.com>
In-Reply-To: <CAF=yD-K74v6+hH1p0Fn6z7c9KH=4rqzOOaBxr+BqMj4Ydjxt_Q@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 16 Oct 2019 20:02:40 -0700
Message-ID: <CAHo-Ooy5csMY23LYq0eGth8KTVhn_bzYgMGBMzT2N4=BdJbdXw@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: fix the tx skb protocol in raw sockets
 with ETH_P_ALL
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Yoshiki Komachi <ysk@ht.sfc.keio.ac.jp>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The Fixes tag is missing. Calling sendmsg on a packet socket bound to
> ETH_P_ALL goes back a long way. It is a user, not kernel, bug to do
> so.

I would argue it's not a bug at all - at least not the way you phrased it.

AFAIK it can/could be done correctly via specifying the protocol in
the sll_protocol field of the struct sockaddr_ll passed to sendmsg as
the target address.

Not specifying it would indeed be a bug (and a common one)
Hence I do agree it's better to automate this.

> But no more than sending on a socket bound to ETH_P_NONE (0), which
> was addressed in commit c72219b75fde ("packet: infer protocol from
> ethernet header if unset").

This is also not a bug.  That's simply how you send when you don't
want to receive.

Other approaches add your socket to the receive hooks and slow the system
down (even if you add a bpf filter to unconditionally drop stuff).

ie. this is the *optimal* way to send frames.
