Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D191D20B4ED
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgFZPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgFZPkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:40:06 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC5CC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:40:05 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a8so6067586edy.1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uvnSYd8s4WKn/QODR62iqB9h29Lmw7RcvE0IecslInM=;
        b=T++YffFoYL2fNvYN1w8ld5dmfWb7UWGgYVc6VVJOGNqI478K47Dw9VcHGcwvWpHQBa
         cWHna34SjiCscEHxgLli84rnndIBmqhkVi6txPfHGMfsl596foO1ti+jENL5C61Vu+bO
         h7ijZiYRGBtLnABoYr1QrIEL4P67DS6Kxd7T4vA+a+BVm+w0OnacQPHAN3PKyi3UIHbl
         LHEd5XXkGAYJTs+3dCsXyFXbWkgHQO3ZawUhC5SzSeyVKQHpY9QSh7fEXLU/tYiK8n77
         pkaEvotUGAzGTv0MssPJpM2RsAzzmgYRVNWjwqzPo3SeMDbTjaa75QU5BQ/0K0YM9hlP
         /FKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uvnSYd8s4WKn/QODR62iqB9h29Lmw7RcvE0IecslInM=;
        b=tQ3WKjVBEUSN4w2/ittuCoNqmSTiKFNIwpGAOsKDiz1gzAPwWEEmVaEQ28EkCyFwnW
         iWl0tTWkDqRB85QHYZd5x3L6R8ZxeRcOZOaIXMItVwDQlsLwOymz5LPe+0ZvDHr6RFsh
         0JDLTTgDqeIpxR4f1JRHDDmo59LgPbGtqXULA7DmgFsgIvl5I1JfObfoJXvO3f+m+yMi
         utz/ZyHpIUX8klsuYk7ukCaas1gU4Vii7BT1+dqMWTwgIkV4MuURDQ/n4G8323Pf0gJL
         nbwa6CIV5VkmReUHcWHpJo9bbdWlwuk88gOm0KsHELq1MHnEjM2YujLYcfdkoEq+4W3t
         Bk5Q==
X-Gm-Message-State: AOAM532QZ+awKesDDapFIy/cyLVPA4fm9viFyC/YN93j5g5MCy9OGbhp
        zQWwHmpZTuFDSokKOxMeDxZqe/JzdyVBB+E4Dyl26jDx
X-Google-Smtp-Source: ABdhPJw3jBJg2N3sE9/s2ifJeJDYdBlwNJ7rGHmQYF5xIPWZElR18+FtyBUOjnZo/KYBXsrRTTzR+gFoqkLgATiNWBg=
X-Received: by 2002:aa7:c341:: with SMTP id j1mr4138808edr.197.1593186004263;
 Fri, 26 Jun 2020 08:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be>
 <20200624192310.16923-2-justin.iurman@uliege.be> <CALx6S34K5+GabNAs9GtutpPNxR+fAdibDTFphT_LUOJ1mAzfOQ@mail.gmail.com>
 <517934373.36575257.1593107228168.JavaMail.zimbra@uliege.be>
 <CALx6S34-2TNpWhNOwGfe1xwAJhCZr+xsh7WV2eVN6Yv2qshYrA@mail.gmail.com> <1383260536.37030044.1593159759771.JavaMail.zimbra@uliege.be>
In-Reply-To: <1383260536.37030044.1593159759771.JavaMail.zimbra@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 26 Jun 2020 08:39:53 -0700
Message-ID: <CALx6S35-=m-V7ytcMk0AO9YDwGSJmKkpp9SpWQf4PPNkNXuOYA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] ipv6: eh: Introduce removable TLVs
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:22 AM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> Tom,
>
> >> Hi Tom,
> >>
> >> >> Add the possibility to remove one or more consecutive TLVs without
> >> >> messing up the alignment of others. For now, only IOAM requires this
> >> >> behavior.
> >> >>
> >> > Hi Justin,
> >> >
> >> > Can you explain the motivation for this? Per RFC8200, extension
> >> > headers in flight are not to be added, removed, or modified outside of
> >> > the standard rules for processing modifiable HBH and DO TLVs., that
> >> > would include adding and removing TLVs in EH. One obvious problem this
> >>
> >> As you already know from our last meeting, IOAM may be configured on a node such
> >> that a specific IOAM namespace should be removed. Therefore, this patch
> >> provides support for the deletion of a TLV (or consecutive TLVs), without
> >> removing the entire EH (if it's empty, there will be padding). Note that there
> >> is a similar "problem" with the Incremental Trace where you'd need to expand
> >> the Hop-by-Hop (not included in this patchset). I agree that RFC 8200 is
> >> against modification of in-flight EHs, but there are several reasons that, I
> >> believe, mitigates this statement.
> >>
> >> Let's keep in mind that IOAM purpose is "private" (= IOAM domain), ie not widely
> >> deployed on the Internet. We can distinguish two big scenarios: (i) in-transit
> >> traffic where it is encapsulated (IPv6-in-IPv6) and (ii) traffic inside the
> >> domain, ie from an IOAM node inside the domain to another one (no need for
> >> encapsulation). In both cases, we kind of own the traffic: (i) encapsulation,
> >> so we modify "our" header and (ii) we already own the traffic.
> >>
> >> And if someone is still angry about this, well, the good news is that such
> >> modification can be avoided most of the time. Indeed, operators are advised to
> >> remove an IOAM namespace only on egress nodes. This way, the destination
> >> (either the tunnel destination or the real destination, depending on the
> >> scenario) will receive EHs and take care of them without the need to remove
> >> anything. But, again, operators can do what they want and I'd tend to adhere to
> >> David's philosophy [1] and give them the possibility to choose what to do.
> >>
> >
> > Justin,
> >
> > 6man WG has had a _long_ and sometimes bitter discussion around this
> > particularly with regards to insertion of SRH. The current consensus
> > of IETF is that it is a violation of RFC8200.  We've heard all the
> > arguments that it's only for limited domains and narrow use cases,
> > nevertheless there are several problems that the header
> > insertion/deletion advocates never answered-- it breaks AH, it breaks
> > PMTU discovery, it breaks ICMP. There is also a risk that a
> > non-standard modification could cause a packet to be dropped
> > downstream from the node that modifies it. There is no attribution on
> > who created the problem, and hence this can lead to systematic
> > blackholes which are the most miserable sort of problem to debug.
>
> Yes, I know the whole story and it's been stormy from what I understood.
>
> > Fundamentally, it is not robust per Postel's law (I actually wrote a
> > draft to try to make it robust in draft-herbert-6man-eh-attrib-00 if
> > you're interested).
>
> Interesting, I'll take a look.
>
> > IMO, we shouldn't be using Linux as a backdoor to implement protocol
> > that IETF is saying isn't robust. Can you point out in the IOAM drafts
> > where this requirement is specified, then I can take it up in IOAM WG
> > or 6man if needed...
>
> Well, I wouldn't say that IETF is considering IPv6-IOAM as not robust since [1] (IPv6 encapsulation for IOAM) and [2] (IOAM data fields) are about to be published.

I was specifically referring to the requirements around removing the
IOAM TLV from packets in-flight. I don't readily see that in the IOAM
drafts.

Also, be careful about saying that drafts are about to be published by
IETF. Until a draft reaches the RFC editor we really can't say that. I
don't believe drafts you're referring to have even made it through
WGLC.

Tom

>
> Justin
>
>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options-01
>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data-09
>
> > Tom
> >
> >> > creates is that it breaks AH if the TLVs are removed in HBH before AH
> >> > is processed (AH is processed after HBH).
> >>
> >> Correct. But I don't think it should prevent us from having IOAM in the kernel.
> >> Again, operators could simply apply IOAM on a subset of the traffic that does
> >> not include AHs, for example.
> >>
> >> Justin
> >>
> >>   [1] https://www.mail-archive.com/netdev@vger.kernel.org/msg136797.html
> >>
> >> > Tom
> >> >> By default, an 8-octet boundary is automatically assumed. This is the
> >> >> price to pay (at most a useless 4-octet padding) to make sure everything
> >> >> is still aligned after the removal.
> >> >>
> >> >> Proof: let's assume for instance the following alignments 2n, 4n and 8n
> >> >> respectively for options X, Y and Z, inside a Hop-by-Hop extension
> >> >> header.
> >> >>
> >> >> Example 1:
> >> >>
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       X       |       X       |    Padding    |    Padding    |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |                                                               |
> >> >> ~                Option to be removed (8 octets)                ~
> >> >> |                                                               |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Y       |       Y       |       Y       |       Y       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |    Padding    |    Padding    |    Padding    |    Padding    |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >>
> >> >> Result 1: assuming a 4-octet boundary would work, as well as an 8-octet
> >> >> boundary (same result in both cases).
> >> >>
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       X       |       X       |    Padding    |    Padding    |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Y       |       Y       |       Y       |       Y       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |    Padding    |    Padding    |    Padding    |    Padding    |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >>
> >> >> Example 2:
> >> >>
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       X       |       X       |    Padding    |    Padding    |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |                Option to be removed (4 octets)                |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Y       |       Y       |       Y       |       Y       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >>
> >> >> Result 2: assuming a 4-octet boundary WOULD NOT WORK. Indeed, option Z
> >> >> would not be 8n-aligned and the Hop-by-Hop size would not be a multiple
> >> >> of 8 anymore.
> >> >>
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       X       |       X       |    Padding    |    Padding    |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Y       |       Y       |       Y       |       Y       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >> |       Z       |       Z       |       Z       |       Z       |
> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> >>
> >> >> Therefore, the largest (8-octet) boundary is assumed by default and for
> >> >> all, which means that blocks are only moved in multiples of 8. This
> >> >> assertion guarantees good alignment.
> >> >>
> >> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >> >> ---
> >> >>  net/ipv6/exthdrs.c | 134 ++++++++++++++++++++++++++++++++++++---------
> >> >>  1 file changed, 108 insertions(+), 26 deletions(-)
> >> >>
> >> >> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> >> >> index e9b366994475..f27ab3bf2e0c 100644
> >> >> --- a/net/ipv6/exthdrs.c
> >> >> +++ b/net/ipv6/exthdrs.c
> >> >> @@ -52,17 +52,27 @@
> >> >>
> >> >>  #include <linux/uaccess.h>
> >> >>
> >> >> -/*
> >> >> - *     Parsing tlv encoded headers.
> >> >> +/* States for TLV parsing functions. */
> >> >> +
> >> >> +enum {
> >> >> +       TLV_ACCEPT,
> >> >> +       TLV_REJECT,
> >> >> +       TLV_REMOVE,
> >> >> +       __TLV_MAX
> >> >> +};
> >> >> +
> >> >> +/* Parsing TLV encoded headers.
> >> >>   *
> >> >> - *     Parsing function "func" returns true, if parsing succeed
> >> >> - *     and false, if it failed.
> >> >> - *     It MUST NOT touch skb->h.
> >> >> + * Parsing function "func" returns either:
> >> >> + *  - TLV_ACCEPT if parsing succeeds
> >> >> + *  - TLV_REJECT if parsing fails
> >> >> + *  - TLV_REMOVE if TLV must be removed
> >> >> + * It MUST NOT touch skb->h.
> >> >>   */
> >> >>
> >> >>  struct tlvtype_proc {
> >> >>         int     type;
> >> >> -       bool    (*func)(struct sk_buff *skb, int offset);
> >> >> +       int     (*func)(struct sk_buff *skb, int offset);
> >> >>  };
> >> >>
> >> >>  /*********************
> >> >> @@ -109,19 +119,67 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int
> >> >> optoff,
> >> >>         return false;
> >> >>  }
> >> >>
> >> >> +/* Remove one or several consecutive TLVs and recompute offsets, lengths */
> >> >> +
> >> >> +static int remove_tlv(int start, int end, struct sk_buff *skb)
> >> >> +{
> >> >> +       int len = end - start;
> >> >> +       int padlen = len % 8;
> >> >> +       unsigned char *h;
> >> >> +       int rlen, off;
> >> >> +       u16 pl_len;
> >> >> +
> >> >> +       rlen = len - padlen;
> >> >> +       if (rlen) {
> >> >> +               skb_pull(skb, rlen);
> >> >> +               memmove(skb_network_header(skb) + rlen, skb_network_header(skb),
> >> >> +                       start);
> >> >> +               skb_postpull_rcsum(skb, skb_network_header(skb), rlen);
> >> >> +
> >> >> +               skb_reset_network_header(skb);
> >> >> +               skb_set_transport_header(skb, sizeof(struct ipv6hdr));
> >> >> +
> >> >> +               pl_len = be16_to_cpu(ipv6_hdr(skb)->payload_len) - rlen;
> >> >> +               ipv6_hdr(skb)->payload_len = cpu_to_be16(pl_len);
> >> >> +
> >> >> +               skb_transport_header(skb)[1] -= rlen >> 3;
> >> >> +               end -= rlen;
> >> >> +       }
> >> >> +
> >> >> +       if (padlen) {
> >> >> +               off = end - padlen;
> >> >> +               h = skb_network_header(skb);
> >> >> +
> >> >> +               if (padlen == 1) {
> >> >> +                       h[off] = IPV6_TLV_PAD1;
> >> >> +               } else {
> >> >> +                       padlen -= 2;
> >> >> +
> >> >> +                       h[off] = IPV6_TLV_PADN;
> >> >> +                       h[off + 1] = padlen;
> >> >> +                       memset(&h[off + 2], 0, padlen);
> >> >> +               }
> >> >> +       }
> >> >> +
> >> >> +       return end;
> >> >> +}
> >> >> +
> >> >>  /* Parse tlv encoded option header (hop-by-hop or destination) */
> >> >>
> >> >>  static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >> >>                           struct sk_buff *skb,
> >> >> -                         int max_count)
> >> >> +                         int max_count,
> >> >> +                         bool removable)
> >> >>  {
> >> >>         int len = (skb_transport_header(skb)[1] + 1) << 3;
> >> >> -       const unsigned char *nh = skb_network_header(skb);
> >> >> +       unsigned char *nh = skb_network_header(skb);
> >> >>         int off = skb_network_header_len(skb);
> >> >>         const struct tlvtype_proc *curr;
> >> >>         bool disallow_unknowns = false;
> >> >> +       int off_remove = 0;
> >> >>         int tlv_count = 0;
> >> >>         int padlen = 0;
> >> >> +       int ret;
> >> >>
> >> >>         if (unlikely(max_count < 0)) {
> >> >>                 disallow_unknowns = true;
> >> >> @@ -173,12 +231,14 @@ static bool ip6_parse_tlv(const struct tlvtype_proc
> >> >> *procs,
> >> >>                         if (tlv_count > max_count)
> >> >>                                 goto bad;
> >> >>
> >> >> +                       ret = -1;
> >> >>                         for (curr = procs; curr->type >= 0; curr++) {
> >> >>                                 if (curr->type == nh[off]) {
> >> >>                                         /* type specific length/alignment
> >> >>                                            checks will be performed in the
> >> >>                                            func(). */
> >> >> -                                       if (curr->func(skb, off) == false)
> >> >> +                                       ret = curr->func(skb, off);
> >> >> +                                       if (ret == TLV_REJECT)
> >> >>                                                 return false;
> >> >>                                         break;
> >> >>                                 }
> >> >> @@ -187,6 +247,17 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >> >>                             !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
> >> >>                                 return false;
> >> >>
> >> >> +                       if (removable) {
> >> >> +                               if (ret == TLV_REMOVE) {
> >> >> +                                       if (!off_remove)
> >> >> +                                               off_remove = off - padlen;
> >> >> +                               } else if (off_remove) {
> >> >> +                                       off = remove_tlv(off_remove, off, skb);
> >> >> +                                       nh = skb_network_header(skb);
> >> >> +                                       off_remove = 0;
> >> >> +                               }
> >> >> +                       }
> >> >> +
> >> >>                         padlen = 0;
> >> >>                         break;
> >> >>                 }
> >> >> @@ -194,8 +265,13 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >> >>                 len -= optlen;
> >> >>         }
> >> >>
> >> >> -       if (len == 0)
> >> >> +       if (len == 0) {
> >> >> +               /* Don't forget last TLV if it must be removed */
> >> >> +               if (off_remove)
> >> >> +                       remove_tlv(off_remove, off, skb);
> >> >> +
> >> >>                 return true;
> >> >> +       }
> >> >>  bad:
> >> >>         kfree_skb(skb);
> >> >>         return false;
> >> >> @@ -206,7 +282,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >> >>   *****************************/
> >> >>
> >> >>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> >> >> -static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >> >> +static int ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >> >>  {
> >> >>         struct ipv6_destopt_hao *hao;
> >> >>         struct inet6_skb_parm *opt = IP6CB(skb);
> >> >> @@ -257,11 +333,11 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >> >>         if (skb->tstamp == 0)
> >> >>                 __net_timestamp(skb);
> >> >>
> >> >> -       return true;
> >> >> +       return TLV_ACCEPT;
> >> >>
> >> >>   discard:
> >> >>         kfree_skb(skb);
> >> >> -       return false;
> >> >> +       return TLV_REJECT;
> >> >>  }
> >> >>  #endif
> >> >>
> >> >> @@ -306,7 +382,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
> >> >>  #endif
> >> >>
> >> >>         if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
> >> >> -                         init_net.ipv6.sysctl.max_dst_opts_cnt)) {
> >> >> +                         init_net.ipv6.sysctl.max_dst_opts_cnt,
> >> >> +                         false)) {
> >> >>                 skb->transport_header += extlen;
> >> >>                 opt = IP6CB(skb);
> >> >>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> >> >> @@ -918,24 +995,24 @@ static inline struct net *ipv6_skb_net(struct sk_buff
> >> >> *skb)
> >> >>
> >> >>  /* Router Alert as of RFC 2711 */
> >> >>
> >> >> -static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >> >> +static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >> >>  {
> >> >>         const unsigned char *nh = skb_network_header(skb);
> >> >>
> >> >>         if (nh[optoff + 1] == 2) {
> >> >>                 IP6CB(skb)->flags |= IP6SKB_ROUTERALERT;
> >> >>                 memcpy(&IP6CB(skb)->ra, nh + optoff + 2, sizeof(IP6CB(skb)->ra));
> >> >> -               return true;
> >> >> +               return TLV_ACCEPT;
> >> >>         }
> >> >>         net_dbg_ratelimited("ipv6_hop_ra: wrong RA length %d\n",
> >> >>                             nh[optoff + 1]);
> >> >>         kfree_skb(skb);
> >> >> -       return false;
> >> >> +       return TLV_REJECT;
> >> >>  }
> >> >>
> >> >>  /* Jumbo payload */
> >> >>
> >> >> -static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >> >> +static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >> >>  {
> >> >>         const unsigned char *nh = skb_network_header(skb);
> >> >>         struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
> >> >> @@ -953,12 +1030,12 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int
> >> >> optoff)
> >> >>         if (pkt_len <= IPV6_MAXPLEN) {
> >> >>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> >> >>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
> >> >> -               return false;
> >> >> +               return TLV_REJECT;
> >> >>         }
> >> >>         if (ipv6_hdr(skb)->payload_len) {
> >> >>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> >> >>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
> >> >> -               return false;
> >> >> +               return TLV_REJECT;
> >> >>         }
> >> >>
> >> >>         if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
> >> >> @@ -970,16 +1047,16 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int
> >> >> optoff)
> >> >>                 goto drop;
> >> >>
> >> >>         IP6CB(skb)->flags |= IP6SKB_JUMBOGRAM;
> >> >> -       return true;
> >> >> +       return TLV_ACCEPT;
> >> >>
> >> >>  drop:
> >> >>         kfree_skb(skb);
> >> >> -       return false;
> >> >> +       return TLV_REJECT;
> >> >>  }
> >> >>
> >> >>  /* CALIPSO RFC 5570 */
> >> >>
> >> >> -static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> >> >> +static int ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> >> >>  {
> >> >>         const unsigned char *nh = skb_network_header(skb);
> >> >>
> >> >> @@ -992,11 +1069,11 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int
> >> >> optoff)
> >> >>         if (!calipso_validate(skb, nh + optoff))
> >> >>                 goto drop;
> >> >>
> >> >> -       return true;
> >> >> +       return TLV_ACCEPT;
> >> >>
> >> >>  drop:
> >> >>         kfree_skb(skb);
> >> >> -       return false;
> >> >> +       return TLV_REJECT;
> >> >>  }
> >> >>
> >> >>  static const struct tlvtype_proc tlvprochopopt_lst[] = {
> >> >> @@ -1041,7 +1118,12 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
> >> >>
> >> >>         opt->flags |= IP6SKB_HOPBYHOP;
> >> >>         if (ip6_parse_tlv(tlvprochopopt_lst, skb,
> >> >> -                         init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
> >> >> +                         init_net.ipv6.sysctl.max_hbh_opts_cnt,
> >> >> +                         true)) {
> >> >> +               /* we need to refresh the length in case
> >> >> +                * at least one TLV was removed
> >> >> +                */
> >> >> +               extlen = (skb_transport_header(skb)[1] + 1) << 3;
> >> >>                 skb->transport_header += extlen;
> >> >>                 opt = IP6CB(skb);
> >> >>                 opt->nhoff = sizeof(struct ipv6hdr);
> >> >> --
> > > >> 2.17.1
