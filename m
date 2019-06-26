Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46078574F8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfFZXmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:42:12 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41715 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFZXmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:42:11 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so5260238eds.8
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 16:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p57FvlhbWeopHvbdNS15PY7SxJnN9e7RshD1N+sr8No=;
        b=E2NeY7xnCWuyuK4dh2f9x/Slu6V1kjeR4k9qZO8tjd9w8Vkua3YEhkZ0f57tZwuasb
         hLAo1JG6iWiDI+LwvvfZ3kY3FadfJDz06EMDSYastNxvr9cpjwWQb7B8+ogD4aZRP3LM
         UOE3hV+D40sg+UNOJQUwWs0LFGZgkyfMfnFwMPtEJ/Hp24I4ovzFzCGQgOjFWfp9SFp/
         4qqHXD9eZ5BJps+QCMbIf31oPAZ5OVA07xacPQPwRW9TnUHGUQ92Zd81D4FQWs6mNYXH
         YPAmD2RJ6HrT0cCJA835AvxyIle6WpkWZEUtMepF+BfaNGu2YfFaoLKEILx4gvMDb2wQ
         rGYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p57FvlhbWeopHvbdNS15PY7SxJnN9e7RshD1N+sr8No=;
        b=QPpH26okwLwrnDTUu0yZnLFRH1eXnBDdWpIs7yUMrrNsboFUslHjxO9KBgBmm6YgNe
         0hG6GN33rPp1GJ+1SDWnsHmAh0XhZ882RKKUw/bkTvOgjW22F8QO/jXCkBvWb3LtQuHB
         qT2DV57iCEBJ+tnrequ6GMV3brfXyiZiM3mQaDoM/CA25fdjllvb98iDHFslg2DfwMkJ
         Nbqo3SJm+56fdc/3gunsGAcvzKon1ByaGYIV7JCQ+6DfmkDWPt+rnWy93gD7AlvfTbd3
         bca+vrX8yP+nqOEzSgxeqxB4auF3R44mOPO2AcwGP3sw9gv90UhcpHjiSKdzqCD3NrKq
         4GgQ==
X-Gm-Message-State: APjAAAVQGHh5XPRC3+LZ9CcQFUUGAabfFH1oiOC1US9VSyOqRkBFrfPA
        +5qnJ9+TMJgR7ALKhS+R8aZ82/7ORrViXnlS1Q0=
X-Google-Smtp-Source: APXvYqxTJG2qEtd8bHThnaE+8MHWXifSvAOqSE8AY6xzi3GKlH3miRx40MyD4ZG85vetLEDin/fc7aQdKxUWlrpIam8=
X-Received: by 2002:a17:906:3482:: with SMTP id g2mr376585ejb.186.1561592530124;
 Wed, 26 Jun 2019 16:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
 <CAKgT0Uej5CkBJpqsBnB61ozo2kAFKyAH8WY9KVbFQ67ZxPiDag@mail.gmail.com>
 <3af1e0da-8eb4-8462-3107-27917fec9286@akamai.com> <CAF=yD-+BMvToWvRwayTrxQBQ-Lgq7QVA6E+rGe3e5ic7rQ_gSg@mail.gmail.com>
 <f91fb37a-379a-4a59-7e04-cf8a6d161efa@akamai.com> <d5dea281-67c0-1385-95c1-b476825e6afa@akamai.com>
In-Reply-To: <d5dea281-67c0-1385-95c1-b476825e6afa@akamai.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 19:41:34 -0400
Message-ID: <CAF=yD-+zYGzTTYC-oYr392qugWiYpbgykMh1p8UrrgZ2ciR=aw@mail.gmail.com>
Subject: Re: [PATCH net-next] gso: enable udp gso for virtual devices
To:     Jason Baron <jbaron@akamai.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joshua Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 3:17 PM Jason Baron <jbaron@akamai.com> wrote:
>
>
>
> On 6/14/19 4:53 PM, Jason Baron wrote:
> >
> >
> > On 6/13/19 5:20 PM, Willem de Bruijn wrote:
> >>>>> @@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> >>>>>                                  NETIF_F_GSO_GRE_CSUM |                 \
> >>>>>                                  NETIF_F_GSO_IPXIP4 |                   \
> >>>>>                                  NETIF_F_GSO_IPXIP6 |                   \
> >>>>> +                                NETIF_F_GSO_UDP_L4 |                   \
> >>>>>                                  NETIF_F_GSO_UDP_TUNNEL |               \
> >>>>>                                  NETIF_F_GSO_UDP_TUNNEL_CSUM)
> >>>>
> >>>> Are you adding this to NETIF_F_GSO_ENCAP_ALL? Wouldn't it make more
> >>>> sense to add it to NETIF_F_GSO_SOFTWARE?
> >>>>
> >>>
> >>> Yes, I'm adding to NETIF_F_GSO_ENCAP_ALL (not very clear from the
> >>> context). I will fix the commit log.
> >>>
> >>> In: 83aa025 udp: add gso support to virtual devices, the support was
> >>> also added to NETIF_F_GSO_ENCAP_ALL (although subsequently reverted due
> >>> to UDP GRO not being in place), so I wonder what the reason was for that?
> >>
> >> That was probably just a bad choice on my part.
> >>
> >> It worked in practice, but if NETIF_F_GSO_SOFTWARE works the same
> >> without unexpected side effects, then I agree that it is the better choice.
> >>
> >> That choice does appear to change behavior when sending over tunnel
> >> devices. Might it send tunneled GSO packets over loopback?
> >>
> >>
> >
> > I set up a test case using fou tunneling through a bridge device using
> > the udpgso_bench_tx test where packets are not received correctly if
> > NETIF_F_GSO_UDP_L4 is added to NETIF_F_GSO_SOFTWARE. If I have it added
> > to NETIF_F_GSO_ENCAP_ALL, it does work correctly. So there are more
> > fixes required to include it in NETIF_F_GSO_SOFTWARE.
> >
> > The use-case I have only requires it to be in NETIF_F_GSO_ENCAP_ALL, but
> > if it needs to go in NETIF_F_GSO_SOFTWARE, I can look at what's required
> > more next week.
> >
>
> Hi,
>
> I haven't had a chance to investigate what goes wrong with including
> NETIF_F_GSO_UDP_L4 in NETIF_F_GSO_SOFTWARE - but I was just wondering if
> people are ok with NETIF_F_GSO_UDP_L4 being added to
> NETIF_F_GSO_ENCAP_ALL and not NETIF_F_GSO_SOFTWARE (ie the original
> patch as posted)?
>
> As I mentioned that is sufficient for my use-case, and its how Willem
> originally proposed this.

Indeed, based on the previous discussion this sounds fine to me.
