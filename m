Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286E167CDC
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 05:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbfGND6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 23:58:03 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39439 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbfGND6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 23:58:03 -0400
Received: by mail-yw1-f68.google.com with SMTP id x74so6317917ywx.6
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 20:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bdMIhDBdVNcvCSBNvQXpoSmrS4IyNeg0f/UUKfcyc1Y=;
        b=Vb4V+Q2rmU0ayZFsAnMF/xjDaFk1AqllI6ljdul/YG5ITQibZP4CYA7Unv0zdSdmHS
         tdIN88OeJKBcmVsJA93I3J65GJO3wWo6Pz8Lvlarns2mhd2sYd3XVrhdirdx89LfGs69
         HAvETivdrg9qbERxfRFrQ2bxvs2R578rekDUPduhMQl6rOxlZJONCaQBH24pHLcB5Eh3
         6VxUC13Qj3grP8/R7GW5pVfNSA37ueiUduzCQUSJnjwIMzpdyLIhvEQxugKO3OU16iM/
         skHc/3p2grvjCIVDJELm8OCs9Mj1v98/7+V8dxkYmIsix27AnxSBYYGNYKQeCe0Oo6pf
         GGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bdMIhDBdVNcvCSBNvQXpoSmrS4IyNeg0f/UUKfcyc1Y=;
        b=Gi7lk2W4ePEjZQS52e/uHgfnlYPl0tSTTpthPy2+iva1dl2MSkqgKfy6AwPFleLWmt
         dtMLuO7mkRSo668PAJeqGEK3UlndVcjJF3rxgHnzwDDbGu2DMETfx7k6WwxTgDuguVWy
         RWT+0YCrPoYTKFVF4Vqm97sMRSEPeh1GDYi/tqCqBzDechpR1gslVr+a0XL+KTCLysdy
         KrziY/TO3i+EPPrcjz1LoeCEdqmYRsx2w2wZoikUc8hW7WscdZXD+7AbWfnWxEj7uDAH
         sZb+iCTz0NX10NXNZZHBkNdM2dcQf5xAZZ8y9CS1yClmcJfaDHqw5VpLr8rH/W0BpStq
         PNng==
X-Gm-Message-State: APjAAAXzKMimy4c7eRvc9g1BPn7AOSMjvPQDsVF5HetR57pAi9aL0aeR
        rhcb0ybejYoCBdH7/B2NGoHPHTOG7Vt2qT0p1ssHZQ==
X-Google-Smtp-Source: APXvYqys1x7u/g0NVzfVDDUD27Q2ksVy7Z9Ovi4YcCdHSZT0BeNRlFT8TZPJG79V32TuNQZcyMKLQz8XYLfqrdJ2vXY=
X-Received: by 2002:a81:57d0:: with SMTP id l199mr11614165ywb.179.1563076682115;
 Sat, 13 Jul 2019 20:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <1561223254-13589-1-git-send-email-dave.taht@gmail.com>
 <1561223254-13589-2-git-send-email-dave.taht@gmail.com> <20190626.132003.50827799670386389.davem@davemloft.net>
In-Reply-To: <20190626.132003.50827799670386389.davem@davemloft.net>
From:   Paul Marks <pmarks@google.com>
Date:   Sat, 13 Jul 2019 20:57:50 -0700
Message-ID: <CAHaKRv+Fnrxd=jD6itFXBGrLKA-kphxhUQhvd9ngN1dDNhd4nQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] Allow 0.0.0.0/8 as a valid address range
To:     David Miller <davem@davemloft.net>
Cc:     dave.taht@gmail.com, netdev@vger.kernel.org, gnu@toad.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 1:20 PM David Miller <davem@davemloft.net> wrote:
>
> From: Dave Taht <dave.taht@gmail.com>
> Date: Sat, 22 Jun 2019 10:07:34 -0700
>
> > The longstanding prohibition against using 0.0.0.0/8 dates back
> > to two issues with the early internet.
> >
> > There was an interoperability problem with BSD 4.2 in 1984, fixed in
> > BSD 4.3 in 1986. BSD 4.2 has long since been retired.
> >
> > Secondly, addresses of the form 0.x.y.z were initially defined only as
> > a source address in an ICMP datagram, indicating "node number x.y.z on
> > this IPv4 network", by nodes that know their address on their local
> > network, but do not yet know their network prefix, in RFC0792 (page
> > 19).  This usage of 0.x.y.z was later repealed in RFC1122 (section
> > 3.2.2.7), because the original ICMP-based mechanism for learning the
> > network prefix was unworkable on many networks such as Ethernet (which
> > have longer addresses that would not fit into the 24 "node number"
> > bits).  Modern networks use reverse ARP (RFC0903) or BOOTP (RFC0951)
> > or DHCP (RFC2131) to find their full 32-bit address and CIDR netmask
> > (and other parameters such as default gateways). 0.x.y.z has had
> > 16,777,215 addresses in 0.0.0.0/8 space left unused and reserved for
> > future use, since 1989.
> >
> > This patch allows for these 16m new IPv4 addresses to appear within
> > a box or on the wire. Layer 2 switches don't care.
> >
> > 0.0.0.0/32 is still prohibited, of course.
> >
> > Signed-off-by: Dave Taht <dave.taht@gmail.com>
> > Signed-off-by: John Gilmore <gnu@toad.com>
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Applied, thanks for following up on this.

This breaks an undocumented feature of Linux:

$ telnet 0.0.0.1 22
Trying 0.0.0.1...
telnet: Unable to connect to remote host: Invalid argument

It's sometimes useful to put 0.x.x.x in command-line flags,
/etc/hosts, or other config files, because it forces connect() to fail
immediately, instead of sending packets and waiting for a timeout.

Given that this has been user-visible for decades, is it a good idea
to pull out the rug?
