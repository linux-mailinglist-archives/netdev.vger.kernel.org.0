Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0F287E4D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgJHVsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJHVsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:48:01 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD2EC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:48:01 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id c7so2379576uaq.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/vKcyYpCm9KAYwXxJPU4omevqZmvX8BUTGAgUc44jlY=;
        b=vPU/YguGnwjvrrMUjgASTL3ss1W/EdEiuw4uDBW/+tP0bhsO4nhEANCxfsT57Qu2ou
         S5ZykIHup1AW3OBpYtIxMyY14f0RgEyMvM2A7lTipZA5GM0Iq9m0j9lZ8PXv/oMn6Dr2
         NYUIdR3Ea6JMdGaF5PYV7v/uiUYw+OkaSbPWi7jDSX487n/E1dF96IYUR03L6PMPRVvf
         48SLRUxuPXQNgdSwESR4hSppezty5bFjzNWgJ/bkNkYCPrH8jQEe8E/Uq7HVEcjlDpUp
         yXdPAGcqr3BQatApQcHfvUscZG2WSJmWNBQ/m2WYJgtL62GkbOCGDqUYRumEXzn8gQcw
         aOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/vKcyYpCm9KAYwXxJPU4omevqZmvX8BUTGAgUc44jlY=;
        b=pqkANXBWM/Q7hO2WGhGCPe0hQSTHUQKPJNdCKo9sn5ISyhW1TUtiXfZqoFST5V7EuO
         9RgM9+7v3SaRU55X4YPPvOupGg1ljtFsSj+M1lQycR72/vSQ0ui+JWe2dnDuOSPK1e/c
         C04PRfwQONwh3/NQ2ldkSAdt5SBQOBlFkPWZSfCn/vKQ44NAj5T3BM2jKGpGgvKU5dNc
         2vNjH8KlKOvQ8XgRCZCcGM+yyAd+Er62O5Qt4nbDKujqs+1FgBY/uLEW4Z47kXkZyGpU
         4fNJsmwxycWNILIwuSeA4W3KX4AV5gMkCfjoz7ytHh+yi5pVeJvDiGe4O9E1N6yni0h4
         rskg==
X-Gm-Message-State: AOAM532wxFCBwV/TfSVEGPjEBm9sVPpjcqLeXe2M15Gl9rP8yBFe3N9O
        XTyhFX6hHDnN58Jszi4zjgepGGQ7gGA=
X-Google-Smtp-Source: ABdhPJyrFl+H2J82JwLqJVdREQjZaQaXPsob1RDGecmQRFF9LTLvNczilYeOxlkSm73b7TdIl+E2og==
X-Received: by 2002:ab0:6659:: with SMTP id b25mr5989243uaq.81.1602193680279;
        Thu, 08 Oct 2020 14:48:00 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id v2sm274022vkd.40.2020.10.08.14.47.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 14:47:59 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id f8so3905069vsl.3
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:47:59 -0700 (PDT)
X-Received: by 2002:a67:684e:: with SMTP id d75mr6451521vsc.28.1602193678587;
 Thu, 08 Oct 2020 14:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com> <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
In-Reply-To: <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 17:47:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
Message-ID: <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 5:36 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 1:32 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 4:11 PM Xie He <xie.he.0141@gmail.com> wrote:
> > >
> > > OK. I understand that t->tun_hlen is the GRE header length. What is
> > > t->encap_hlen?
> >
> > I've looked at that closely either.
> >
> > Appears to be to account for additional FOU/GUE encap:
> >
> > "
> > commit 56328486539ddd07cbaafec7a542a2c8a3043623
> > Author: Tom Herbert <therbert@google.com>
> > Date:   Wed Sep 17 12:25:58 2014 -0700
> >     net: Changes to ip_tunnel to support foo-over-udp encapsulation
> >
> >     This patch changes IP tunnel to support (secondary) encapsulation,
> >     Foo-over-UDP. Changes include:
> >
> >     1) Adding tun_hlen as the tunnel header length, encap_hlen as the
> >        encapsulation header length, and hlen becomes the grand total
> >        of these.
> >     2) Added common netlink define to support FOU encapsulation.
> >     3) Routines to perform FOU encapsulation.
> >
> >     Signed-off-by: Tom Herbert <therbert@google.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > "
>
> I see the ipgre_xmit function would pull the header our header_ops
> creates, and then call __gre_xmit. __gre_xmit will call
> gre_build_header to complete the GRE header. gre_build_header expects
> to find the base GRE header after pushing tunnel->tun_hlen. However,
> if tunnel->encap_hlen is not 0, it couldn't find the base GRE header
> there. Is there a problem?
>
> Where exactly should we put the tunnel->encap_hlen header? Before the
> GRE header or after?

The L4 tunnel infra uses the two callbacks encap_hlen (e.g.,
fou_encap_hlen) and build_header (fou_build_header) in struct
ip_tunnel_encap_ops to first allocate more space and later call back
into the specific implementation to fill that data. build_header is
called from __gre6_xmit -> ip6_tnl_xmit (or its ipv4 equivalent).
This happens after gre has pushed its header, so the headers
will come before that.
