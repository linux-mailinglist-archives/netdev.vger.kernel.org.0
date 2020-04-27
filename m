Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21351BB00A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgD0VOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:14:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726030AbgD0VOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588022053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BgGlIwfj4Qu7dZ9JR/Ymkfhj3JsL/bLikEdvkUNBlTc=;
        b=HECZT3d0/BhZGY0EycDymYa5iMC2N6BLReBqfgP2xbGC0yHFpxNXX8/nhRqH8hOL6lqZMi
        SNos1K5wpjS7Hxd3DAd46vJ0htFyVpVICb026i7lrsr6OybS7TEQY6IMmwhvJEHRL4d03k
        lXGcJ0tLkikzV4l1lc+WvWXNa4158oI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-9Zj3UZlQNMexsRbgqUUpCQ-1; Mon, 27 Apr 2020 17:14:09 -0400
X-MC-Unique: 9Zj3UZlQNMexsRbgqUUpCQ-1
Received: by mail-lj1-f200.google.com with SMTP id m4so3323958lji.23
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BgGlIwfj4Qu7dZ9JR/Ymkfhj3JsL/bLikEdvkUNBlTc=;
        b=VK3MtthrD6AyOUguc8fmtyjw092Dsk1O3ZC0/bYyIZM8A0OPG4m3/NbQRBVhLOPz5v
         POhcb779NtZscS3jNGo2ti4b8Co0hFM9rqz+y0qM+1V/gQwHB/swVNsnXbJMIyrTXuQD
         8nYtvmE75Ty+KVzxXzJ/+XsFl9a+xWGtTIwswv1+OHW2Srrz9gGtnd9C4+roKur6qEFQ
         3kQNmg7LvdIqVYPgmPA8kI8duNea9bfp1k97MQQhv1W52hsmblTRqaaHvpNktlulbi2f
         yaJD7QxJ9bQ6j7+JnoYyLv7aKI8/ES/q0TSBbLNDiEDdU0yD+qc4xEoz98Z1npL4tKtw
         ocxg==
X-Gm-Message-State: AGi0PuZhxtX0GoCb8PD+zyCVO27nnUhjUq7aRPtJl8iRu4b50e8T3ZRY
        0aJsPojaVVRyQeB9S5CRVqSko9VZgQ5eHcap8ZfRLA6zO7a+/6K1HsNUSdvVkOhVIGzRsoQYNy7
        eJRoJ4FLFZU6qjRP+
X-Received: by 2002:ac2:4c9a:: with SMTP id d26mr16457044lfl.112.1588022048263;
        Mon, 27 Apr 2020 14:14:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypKln456F3CfIyM0KpOl+6Jv+MuyF+6zGB5MtY2KPKTJgPzvza+EAZUjl6HHjTdaiHLMd45cZA==
X-Received: by 2002:ac2:4c9a:: with SMTP id d26mr16457037lfl.112.1588022048052;
        Mon, 27 Apr 2020 14:14:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x24sm12025322lfc.6.2020.04.27.14.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 14:14:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 961B01814FF; Mon, 27 Apr 2020 23:14:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic skb handler
In-Reply-To: <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com> <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 23:14:05 +0200
Message-ID: <877dy0y6le.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:
>> On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:
>> > A user reported that packets from wireguard were possibly ignored by XDP
>> > [1]. Apparently, the generic skb xdp handler path seems to assume that
>> > packets will always have an ethernet header, which really isn't always
>> > the case for layer 3 packets, which are produced by multiple drivers.
>> > This patch fixes the oversight. If the mac_len is 0, then we assume
>> > that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
>> > the packet whose h_proto is copied from skb->protocol, which will have
>> > the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
>> > assumption correct about packets always having that ethernet header, so
>> > that existing code doesn't break, while still allowing layer 3 devices
>> > to use the generic XDP handler.
>> 
>> Is this going to work correctly with XDP_TX? presumably wireguard
>> doesn't want the ethernet L2 on egress, either? And what about
>> redirects?
>> 
>> I'm not sure we can paper over the L2 differences between interfaces.
>> Isn't user supposed to know what interface the program is attached to?
>> I believe that's the case for cls_bpf ingress, right?
>
> In general we should also ask ourselves if supporting XDPgeneric on
> software interfaces isn't just pointless code bloat, and it wouldn't
> be better to let XDP remain clearly tied to the in-driver native use
> case.

I was mostly ignoring generic XDP for a long time for this reason. But
it seems to me that people find generic XDP quite useful, so I'm no
longer so sure this is the right thing to do...

-Toke

