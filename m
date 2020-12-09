Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E143A2D4489
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbgLIOlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbgLIOlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:41:15 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E483C061793;
        Wed,  9 Dec 2020 06:40:35 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id t9so1765957ilf.2;
        Wed, 09 Dec 2020 06:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=lrVKy9ubG/ETOf2frLaztz8leb/O1uo8SpRzH8S0NrM=;
        b=H+x6Xuq3KblNHKzIOGWYPWs6L1G1DaKK0iCwMzPh83oa67KQOh04X1zP74yAStkQUg
         x3hqlPaSpisaey+sn/ANVqchR4dY/VIi62DOXCpK46dfyCDZJLnY3LDGcembjAs9Jejc
         3oi6Kx4S0Ph368r3xKOj0E0h1/ExCPZl7ZIWiHRutAq4jtPNeJ2HNcEKazHjRB20967R
         25Kn7A3MlhHuLdKSBcXMX0TQZdIqQACBHqFMfTvQEkyVz1p/ie8RZycO2BMKT/S1GDyR
         kHabgqtW2h+wQJOcFpGStHkZ0ewcD4j0sJ4pZST0cfDS9HKm+DfjNzQ9VlpGzumPH4Pl
         ME7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=lrVKy9ubG/ETOf2frLaztz8leb/O1uo8SpRzH8S0NrM=;
        b=lRg8ysQBmoka+kPPCpI0S0oYX5L+nhla8MWbyJUx9ZTKeTOzOzsDKNQ7KQ9xsL6Oal
         bADtqFA3njyhbYT83lDm6Lr58pzCgV07apKf1CNlLcevaW16nfdWdq0PItWOVBfmuUGx
         gfwxJYep8LSv1wMuMHspvXFrbdp3gDPcpthzzyrdws4GMbgXtTkYCpNfSIZkJ7ZciZ2O
         DlwZEa9ipdMGNAQGEFVUyLlxawQQYsn9iA41gRVel37jnqoQ83CFJfrJUaK9MdZsh3Uo
         GPtr6WnIjA4hNhqWP/tvHo9CGPi4DmH+6QZpcaE9WH5kwJJh/72KBLensQ9j+M6i1hk2
         9fxw==
X-Gm-Message-State: AOAM530k/C6t4ZnWKZTuxJGwY8OrhaLtNLQekQ1GYjQ0VuY3Ge2aRevV
        0p13lRcE+Q5+B1DNGvX25ef5Va0mO/zQAmu/zJanBiwlN7uyvXerljQ=
X-Google-Smtp-Source: ABdhPJy5RiOg7nIVTJtIQNb5lXpcVlKpPeV60+E3GUZJ9hcjHIAulWDk3miEwCBVG6CiZFYd0wC87gLOaYIlmp1c/c8=
X-Received: by 2002:a92:d09:: with SMTP id 9mr3323278iln.54.1607524834704;
 Wed, 09 Dec 2020 06:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20201207134309.16762-1-phil@nwl.cc> <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
 <20201208185139.GZ4647@orbyte.nwl.cc>
In-Reply-To: <20201208185139.GZ4647@orbyte.nwl.cc>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Wed, 9 Dec 2020 16:40:23 +0200
Message-ID: <CAHsH6GvT=Af-BAWK0z_CdrYWPn0qt+C=BRjy10MLRNhLWfH0rQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from netfilter
To:     Phil Sutter <phil@nwl.cc>, Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

On Tue, Dec 8, 2020 at 8:51 PM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Eyal,
>
> On Tue, Dec 08, 2020 at 04:47:02PM +0200, Eyal Birger wrote:
> > On Mon, Dec 7, 2020 at 4:07 PM Phil Sutter <phil@nwl.cc> wrote:
> > >
> > > With an IPsec tunnel without dedicated interface, netfilter sees locally
> > > generated packets twice as they exit the physical interface: Once as "the
> > > inner packet" with IPsec context attached and once as the encrypted
> > > (ESP) packet.
> > >
> > > With xfrm_interface, the inner packet did not traverse NF_INET_LOCAL_OUT
> > > hook anymore, making it impossible to match on both inner header values
> > > and associated IPsec data from that hook.
> > >
> >
> > Why wouldn't locally generated traffic not traverse the
> > NF_INET_LOCAL_OUT hook via e.g. __ip_local_out() when xmitted on an xfrmi?
> > I would expect it to appear in netfilter, but without the IPsec
> > context, as it's not
> > there yet.
>
> Yes, that's right. Having an iptables rule with LOG target in OUTPUT
> chain, a packet sent from the local host is logged multiple times:
>
> | IN= OUT=xfrm SRC=192.168.111.1 DST=192.168.111.2 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=21840 DF
> | PROTO=ICMP TYPE=8 CODE=0 ID=56857 SEQ=1
> | IN= OUT=eth0 SRC=192.168.111.1 DST=192.168.111.2 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=21840 DF PROTO=ICMP TYPE=8 CODE=0 ID=56857 SEQ=1
> | IN= OUT=eth0 SRC=192.168.1.1 DST=192.168.1.2 LEN=140 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ESP SPI=0x1000
>
> First when being sent to xfrm interface, then two times between xfrm and
> eth0, the second time as ESP packet. This is with my patch applied.
> Without it, the second log entry is missing. I'm arguing the above is
> consistent to IPsec without xfrm interface:
>
> | IN= OUT=eth1 SRC=192.168.112.1 DST=192.168.112.2 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=49341 DF PROTO=ICMP TYPE=8 CODE=0 ID=44114 SEQ=1
> | IN= OUT=eth1 SRC=192.168.2.1 DST=192.168.2.2 LEN=140 TOS=0x00 PREC=0x00 TTL=64 ID=37109 DF PROTO=ESP SPI=0x1000
>
> The packet appears twice being sent to eth1, the second time as ESP
> packet. I understand xfrm interface as a collector of to-be-xfrmed
> packets, dropping those which do not match a policy.
>
> > > Fix this by looping packets transmitted from xfrm_interface through
> > > NF_INET_LOCAL_OUT before passing them on to dst_output(), which makes
> > > behaviour consistent again from netfilter's point of view.
> >
> > When an XFRM interface is used when forwarding, why would it be correct
> > for NF_INET_LOCAL_OUT to observe the inner packet?
>
> A valid question, indeed. One could interpret packets being forwarded by
> those tunneling devices emit the packets one feeds them from the local
> host. I just checked and ip_vti behaves identical to xfrm_interface
> prior to my patch, so maybe my patch is crap and the inability to match
> on ipsec context data when using any of those devices is just by design.
>

I would find such interpretation and behavior to be surprising for an IPsec
forwarder...
I guess some functionality of policy matching is lost with these
devices; although they do offer the ability to match ipsec traffic based on
the destination interface it is possible to have multiple ipsec flows share
the same device so netfilter doesn't provide the ability to distinguish
between different flows on the outbound direction in such cases.

Thanks,
Eyal.
