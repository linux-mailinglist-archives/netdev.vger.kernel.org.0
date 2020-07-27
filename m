Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EFD22F7E7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbgG0Skh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgG0Skg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:40:36 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9408CC0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:40:36 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id q16so7065953ybk.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=usslZA3+Fw9S+jhbVTNezZSIZ62JiTZdo3CFfm698p4=;
        b=thlpf9L4yz7ClSTdR4rrOUwokSEBQj+tsz+Myt1+Sgfg8Qq8MD/4mw+dNeoXjjtwxk
         Mw89b6vJvW14Xqq+gxrDsS8bQ2JHeC4PqZp6ft8zZZ4N+7Iz4Jd1dJrdcfzOT5tY26+D
         SzaB/2fBy8o4YrmbwsUEXovTStIxYub8eMnwcl9CVXabN/QJvrvi5QcyUSQaroAfshRL
         nGv+AibqIsqvFASQQavYDVK0JHxQ/TKqziEQ4NOVVPBcZ7TpZUErY2/0kVpU0rFvWYNl
         umCiIvD04rAk6c9++fmOdeD0W8Byl8gnPdh5ktyW+y032UWBDv6XhF9CNOPr5X3N8+Pg
         UOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=usslZA3+Fw9S+jhbVTNezZSIZ62JiTZdo3CFfm698p4=;
        b=hYnZb7n4Z/HYeZayOO1l3qj3Pfm4SlqbIiIdgLhwJdxarcrXfrSW07GOkmgsgVi6gJ
         ZUHPhr7kHARMNl9/trx5rl+BYOHSt3a3F/T9Gzn5c2xEFFh4BieNjtputf70HvP5nrym
         u4qHVlnsyc6/nagwqPctKocb+ap1w5jD1YR4gxxQICP1DpVJDvmX+0O0bRL7rcfFH1nA
         Ng2EC1hK0RdO1oQrpoZ+dADPPT+ZGmlHiwFNcgKiRldYZwBgRZX/octntMlH4f8Y7b4I
         pWfZaKwLdOyBYvjHECElZnTvgAsLnLL/ivydSjcToxQMLGFo9I+6dX6aahg0iTW0wh9a
         VRgg==
X-Gm-Message-State: AOAM530OOq1jJEJ27MNZYB6OamqZbb/3Hjm+nIJ9Bwyn0ei2q0gws+w8
        eKc7fDiFL8o2nRO0zeHXyHEs3S768vZIY2mK+HiOPw==
X-Google-Smtp-Source: ABdhPJw+sLoRRO4gIlOoifcNuUTm//B6cmfArMR6FsO+1aHEwUExOV1iIS9YFpuQ+MsAsQk5mAEr27pICzRJbIqN2+c=
X-Received: by 2002:a25:ec0e:: with SMTP id j14mr37939179ybh.173.1595875235614;
 Mon, 27 Jul 2020 11:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
 <20200725055840.GD1047853@kroah.com> <KL1P15301MB02800FAB6F40F03FD4349E0ABF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <KL1P15301MB02800FAB6F40F03FD4349E0ABF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 11:40:24 -0700
Message-ID: <CANn89i+JPamwsU-22oBTU-8HC+e6oxtQU+QgiO=-S1ZmrkGvtg@mail.gmail.com>
Subject: Re: UDP data corruption in v4.4
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Greg KH <greg@kroah.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:38 AM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Greg KH <greg@kroah.com>
> > Sent: Friday, July 24, 2020 10:59 PM
> > > [...]
> > > Eric Dumazet made an alternative that performs the csum validation earlier:
> > >
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
> > > sk_buff *skb)
> > >                 }
> > >         }
> > >
> > > -       if (rcu_access_pointer(sk->sk_filter) &&
> > > -           udp_lib_checksum_complete(skb))
> > > +       if (udp_lib_checksum_complete(skb))
> > >                 goto csum_error;
> > >
> > >         if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
> > >
> > > I personally like Eric's fix and IMHO we'd better have it in v4.4 rather than
> > > trying to backport 327868212381.
> >
> > Does Eric's fix work with your testing?
>
> Yes, it worked in my testing overnight.
>
> > If so, great, can you turn it
> > into something I can apply to the 4.4.y stable tree and send it to
> > stable@vger.kernel.org?
> >
> > greg k-h
>
> Will do shortly.
>

Just as a reminder, please also add the IPv6 part.

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a8d74f44056a681ef9057c4c4abb34016120b44f..13713e0e5779b75de975faaeb4511bef40e097dc
100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -661,8 +661,7 @@ static int udpv6_queue_rcv_one_skb(struct sock
*sk, struct sk_buff *skb)
        }

        prefetch(&sk->sk_rmem_alloc);
-       if (rcu_access_pointer(sk->sk_filter) &&
-           udp_lib_checksum_complete(skb))
+       if (udp_lib_checksum_complete(skb))
                goto csum_error;

        if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
