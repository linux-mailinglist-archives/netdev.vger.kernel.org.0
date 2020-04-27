Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B729A1BAFDC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgD0VAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:00:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60283 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbgD0VAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588021241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Dwebu9xNYi4lMGuDq3IvOJrJFxZ6YLdxcbYZdyT5JQ=;
        b=f5Zk6/IceZ2cLqJVtBtifeUFrGVFZtzVL6Eo4AOp2ggDLOH2LCmvclFU1ou5IL2RMOtTmx
        NzIkQ7cWqA1WDPUeEgyCFaC+azyZYauJnVSYmc81Mu34Z+U0rfCy7a2WGv6CGgoBcg7krI
        R+FXpYyWghg2J1jrlTd/0iT3ucAc7YY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-y0MNVJPnOLehFy1K4EJ_7w-1; Mon, 27 Apr 2020 17:00:34 -0400
X-MC-Unique: y0MNVJPnOLehFy1K4EJ_7w-1
Received: by mail-lj1-f198.google.com with SMTP id w19so2858214ljw.13
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6Dwebu9xNYi4lMGuDq3IvOJrJFxZ6YLdxcbYZdyT5JQ=;
        b=DUca3ocnY2qH4Q8DchNeS76JO4ixrnKzShVZU67Y+3OFhsCt5ZjWj72scQAlEo5XGD
         VjKjFgI7stNhC5xGYa83U6i6okcESN0UyAvkk2hYbKmp+q8ifa0F3S6SU8ONyxkFQAkh
         gRYv5t12TWNcJmTYs39tF+WbsUeRnnfowvL3/kBa+9TnVcMLyZb/p76BVrx9+IYyjq+4
         t2dxB+HMlih7bhIGOUAhLOt5wHH6eFuOhoJzxXCjQiypMtFYNHzISEEauAKbD9OfdQIw
         06zTsTPiLPyek6rEmbgWTp25JH+03JojyUF8l51l2CbvOtpbvCOTVc5r6jIU1hsYiw2G
         Ku0Q==
X-Gm-Message-State: AGi0PuYTjzSt1pZzRrT6/VJkMx8SxPmrRiHRBSzMx+XxWqxiy0PzohC9
        G72ubc3TSKIJ8d8o9tJ2EcbEgB8QiBxeoMk01UkctkQ4SaOExZ1W1rinXM4F02gWITugZCEf5FN
        YhZxaUwBbxrBDNE0l
X-Received: by 2002:a2e:5855:: with SMTP id x21mr15083101ljd.75.1588021232805;
        Mon, 27 Apr 2020 14:00:32 -0700 (PDT)
X-Google-Smtp-Source: APiQypKTv6TJ9vVdlKPieh3nTQ68kCqP8keXbuJZfS1fsXdcEmeeVyfYO0nNHo51iIcQ7GHHsQlEUw==
X-Received: by 2002:a2e:5855:: with SMTP id x21mr15083084ljd.75.1588021232537;
        Mon, 27 Apr 2020 14:00:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 4sm10811296ljf.79.2020.04.27.14.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 14:00:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4A7421814FF; Mon, 27 Apr 2020 23:00:31 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic skb handler
In-Reply-To: <20200427204208.2501-1-Jason@zx2c4.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com> <20200427204208.2501-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 23:00:31 +0200
Message-ID: <87a72wy780.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> A user reported that packets from wireguard were possibly ignored by XDP
> [1]. Apparently, the generic skb xdp handler path seems to assume that
> packets will always have an ethernet header, which really isn't always
> the case for layer 3 packets, which are produced by multiple drivers.
> This patch fixes the oversight. If the mac_len is 0, then we assume
> that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
> the packet whose h_proto is copied from skb->protocol, which will have
> the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
> assumption correct about packets always having that ethernet header, so
> that existing code doesn't break, while still allowing layer 3 devices
> to use the generic XDP handler.
>
> [1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/
>
> Reported-by: Adhipati Blambangan <adhipati@tuta.io>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

