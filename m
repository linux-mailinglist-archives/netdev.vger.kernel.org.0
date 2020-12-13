Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB882D9034
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732853AbgLMTdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 14:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgLMTdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 14:33:35 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E604C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 11:32:55 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id w135so13461848ybg.13
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 11:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0gsU7KyrOSNQ6R7Iz0ii7jO2TRFtsoC/We/q19bg+I=;
        b=gGCyMHSPvqgCzNuQH6NuDSIPXru26potxT97NVCl5JP/wgUCD0nsuV51nWQSwSCloC
         rxk2WTo6VdbAcOfnQkKJYUy8h5ZiKMWT2gXulA39MYdEMQ1XgbRA0md/HCMvvAS4BZ58
         UGIyEs4++KOwd8MPTOD1u19ImaJ0Fxm1vhFgKTL4ZqQtGGIurpRm6ssX5Op3/3G3N99k
         lj4tElbgQu3beTzfiE1Qc0ObSQfLxV6WUoLHic7PGD2APg3ivteEo/7WlQrPqaK/Qzh+
         bmfEfhNJUUUyYgfUNgjMX950GRNBhA9oIb1nSIqq6jv1Hk2fN4E1RsebHxnKYoty+DYW
         uscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0gsU7KyrOSNQ6R7Iz0ii7jO2TRFtsoC/We/q19bg+I=;
        b=cMnXb3v0QdE4tH1U3JwsaoAdPQUICUr7eTvQ+VdBRdsXORNC0KTjLz7q0tG3sBlpmL
         o58fq7fQLKLV+S0pdi7fLOMYKOJnvQ+C+6sNHybjnUplXGoudwDco4qoIBxaXD5CQXGw
         qRMn0QVwSvIGgB28VH/xzEoSvqWq6gF4TBBqB3o8c86lz/Z17pDBcFTfdsFA0jdt0jPO
         M6gLJ9Y9UEAmEqbGZazhtm1uhyWvYXBw/j3kEgFRBc+tmRzAg2Ggy2e72hbmCAekj/Zz
         KRYGswWEMezMsLlPJoKQD1IpbfD/nacCl368+VjGbSA1xf1HdbDckhojVr8dJRwwt+1y
         EIpw==
X-Gm-Message-State: AOAM530lu34q7DKInw8P47xVH7sO4SzuVY5K1hMINIciGqd0xMlC4wH+
        ffJBDg4UIbdN1E4tG/zN9KuX3whzRBHEKuYI2VA=
X-Google-Smtp-Source: ABdhPJygwtJIKeYVYKSQDcwDJBNOfIQcHlJprHImRcD4nReCzwf2qPQ5pCvRwJfHbIP8l4lDb2OcuKHh/JgH/8f1o1Q=
X-Received: by 2002:a25:a86:: with SMTP id 128mr30231915ybk.370.1607887973934;
 Sun, 13 Dec 2020 11:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20201212044017.55865-1-pbshelar@fb.com> <67f7c207-a537-dd22-acd8-dcce42755d1a@norrbonn.se>
In-Reply-To: <67f7c207-a537-dd22-acd8-dcce42755d1a@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 13 Dec 2020 11:32:43 -0800
Message-ID: <CAOrHB_Dpq+ZnUxQ3PWSxPv_a7N+WPqdczuD=iG_YDpC-r8Q82Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] GTP: add support for flow based tunneling API
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 11:56 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Pravin,
>
> I've been thinking a bit about this and find it more and more
> interesting.  Could you post a bit of information about the ip-route
> changes you'll make in order to support GTP LWT encapsulation?  Could
> you provide an example command line?
>
This is done as part of the magma core project
(https://www.magmacore.org/) that needs OVS GTP support.
I have started with OVS integration first, there are unit tests that
validate the GTP support. This is datapath related test, that has the
setup commands:
https://github.com/pshelar/ovs/blob/6ec6a2a86adc56c7c9dcab7b3a7b70bb6dad35c9/tests/system-layer3-tunnels.at#L158
Once OVS patches are upstream I can post patches for ip-route command.

> I understand the advantages here of coupling to BPF and OVS.  How does
> storing the encapsulation parameters via ip-route compare to storing
> them as PDP contexts from the point of view of resource consumption?
> Are there are other advantages/disadvantages?
>
This would allow user to program openflow with OVS or LWT tunnel APIs
to process GTP tunnel packets. As you can see LWT API provides more
fine-grained control over tunnel packet processing. It also integrates
well with the rest of the networking stack. This would bring the same
LWT APIs for GTP tunneling as we have for Geneve, GRE or VxLAN, etc
tunneling in Linux. I do not see much difference in resource
consumption.

> On 12/12/2020 05:40, Pravin B Shelar wrote:
> > Following patch add support for flow based tunneling API
> > to send and recv GTP tunnel packet over tunnel metadata API.
> > This would allow this device integration with OVS or eBPF using
> > flow based tunneling APIs.
> >
> > Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> > ---
> > Fixed according to comments from Jonas Bonn
> > ---
> >   drivers/net/gtp.c                  | 514 ++++++++++++++++++++---------
> >   include/uapi/linux/gtp.h           |  12 +
> >   include/uapi/linux/if_link.h       |   1 +
> >   include/uapi/linux/if_tunnel.h     |   1 +
> >   tools/include/uapi/linux/if_link.h |   1 +
> >   5 files changed, 382 insertions(+), 147 deletions(-)
> >
> > diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> > index 4c04e271f184..0e212a70fe4b 100644
> > --- a/drivers/net/gtp.c
> > +++ b/drivers/net/gtp.c
> > @@ -21,6 +21,7 @@
> >   #include <linux/file.h>
> >   #include <linux/gtp.h>
> >
> > +#include <net/dst_metadata.h>
> >   #include <net/net_namespace.h>
> >   #include <net/protocol.h>
> >   #include <net/ip.h>
> > @@ -73,6 +74,9 @@ struct gtp_dev {
> >       unsigned int            hash_size;
> >       struct hlist_head       *tid_hash;
> >       struct hlist_head       *addr_hash;
> > +     /* Used by flow based tunnel. */
> > +     bool                    collect_md;
> > +     struct socket           *collect_md_sock;
>
> I'm not convinced that you need to special-case LWT in this way.  It
> should be possible to just use the regular sk1u socket.  I know that the
> sk1u socket is created in userspace and might be set up to listen on the
> wrong address, but that's a user error if they try to use that device
> with LWT.  You could easily make the sk1u socket an optional parameter
> and create it (as you do in your patch) if it's not provided.  Then
> ip_tunnel_collect_metadata() would tell you whether to get the
> encapsulaton details from the tunnel itself or whether to look up a PDP
> context.  That should suffice, right?
>
Sounds good. I have added it as part of v3.
Just to be clear, I still need collect_md_sock to keep reference to
the socket that is created as part of the newlink in kernel space.

Thanks,
Pravin.
