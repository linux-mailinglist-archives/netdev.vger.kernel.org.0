Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917701B9840
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD0HUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:20:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbgD0HUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 03:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587972042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mfdSckWLkb7DhX2heVZuq27RYRTS87u4sE1AXan2YcI=;
        b=dnA6FmlZNi8WP60koiQYVIXuvcVOf80+4H0Ephdgjp4JXVBBrDywL+4CSxAJ30tm4nP+Zr
        rN3qybRyP1i4/He3nfuFxInV2BdCgasNSYPjiRlI906qeZBtDppY6jWmNwp53itMqZROqX
        QBCUBmhD3RxtCujUeOJ6MbNQsc9qA+Q=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-3A4-UdgdNiy33drPy7Oj8Q-1; Mon, 27 Apr 2020 03:20:37 -0400
X-MC-Unique: 3A4-UdgdNiy33drPy7Oj8Q-1
Received: by mail-lf1-f70.google.com with SMTP id t194so7141555lff.20
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 00:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mfdSckWLkb7DhX2heVZuq27RYRTS87u4sE1AXan2YcI=;
        b=TCpVY5f2mHVS1hj/VYv2NSYAJfbxhDLrTR4bVxubVmeVpWBhurYWHo8iEUtDuzD9KA
         S/3JvO2FsaxVUtCB5rt+3LrKZbTTBsW/85KQe1pjuhxDYIbV5n7SfLE/rVnxi5fgZdM2
         9r4c5woD4vOwzQYkSMA1GBVe3B2w9nNX7HB081cfCghaO2vRUTvC4DzT0e8w0Hi9AoIK
         5yU1eFGisSnliwbzcpEhDMVE0ypyB/0q/W3k5bP5beu41Nv7P/FCaoZo1PUIQnvlsju6
         6bGq4RPvFIWy2hFBEcLgGBfsr8u0JScSr7UOeQbSNSeGjWdtkltgAbOhgKAWgcfkF9Qn
         yMZg==
X-Gm-Message-State: AGi0PuZ/LrOJbyZnnWcDQxgu8B7EKJWLpOZSvNZyMMzQpPAhOrgW82ih
        908WSBDOpCC9qE51N5ZJqLEaXjaBCcKgZ7HpO15MJ7vSgxCmTrMqFVOJa0ZcNqEVdNaD6T3XKY+
        d7AM/3reZiBNc/tlF
X-Received: by 2002:ac2:483a:: with SMTP id 26mr14429313lft.5.1587972036149;
        Mon, 27 Apr 2020 00:20:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypJGAzX1IfEZMSAjZX9XJ7QCNzjQa9NM7eDhUtC9gHTJmG3hIoxM6CCCaK9X27Ry7lcIIe3R9w==
X-Received: by 2002:ac2:483a:: with SMTP id 26mr14429300lft.5.1587972035933;
        Mon, 27 Apr 2020 00:20:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t81sm10466474lff.52.2020.04.27.00.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 00:20:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5757D1814FF; Mon, 27 Apr 2020 09:20:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v1] net: xdp: allow for layer 3 packets in generic skb handler
In-Reply-To: <20200427011002.320081-1-Jason@zx2c4.com>
References: <20200427011002.320081-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 09:20:34 +0200
Message-ID: <87h7x51jjx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> A user reported a few days ago that packets from wireguard were possibly
> ignored by XDP [1]. We haven't heard back from the original reporter to
> receive more info, so this here is mostly speculative. Successfully nerd
> sniped, Toke and I started poking around. Toke noticed that the generic
> skb xdp handler path seems to assume that packets will always have an
> ethernet header, which really isn't always the case for layer 3 packets,
> which are produced by multiple drivers. This patch is untested, but I
> wanted to gauge interest in this approach: if the mac_len is 0, then we
> assume that it's a layer 3 packet, and figure out skb->protocol from
> looking at the IP header. This patch also adds some stricter testing
> around mac_len before we assume that it's an ethhdr.

While your patch will fix the header pointer mangling for the skb, it
unfortunately won't fix generic XDP for Wireguard: The assumption that
there's an Ethernet header present is made for compatibility with native
XDP, so you might say it's deliberate. I.e., the eBPF programs running
in the XDP hook expect to see an Ethernet header as part of the packet
data (and parses the packet like in [0]).

So, to make XDP generic work for Wireguard (or other IP-header-only
devices) we'd need to either (1) introduce a new XDP sub-type that
assumes L4 packets, or (2) make Wireguard add a fake Ethernet header to
the head of the packet and set the skb mac_header accordingly.

We've discussed (1) before in other contexts (specifically, adding a
802.11 sub-type), but IIRC we decided that there wasn't enough interest.
I wonder if the same wouldn't be the case for an IP sub-type, since
users would have to re-write their XDP programs to fit that hook type,
and it would only be usable for generic XDP on certain tunnel interface
types. Not sure about the feasibility of (2).

-Toke

[0] https://github.com/xdp-project/xdp-tutorial/blob/master/packet01-parsing/xdp_prog_kern.c

