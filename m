Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA1320B866
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgFZSfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgFZSfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:35:41 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E719C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:35:40 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e15so7678459edr.2
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=crj+HAeFMHYpMGc2Vri23NpQoY1H9viFDZw8Jh0Ioa8=;
        b=CdGI/vY+hbwP+Jz7Rj2IK8/Zek0hQgeR7fZrb/U4KAnQNHPJgPact49sb3zNqaCWug
         Mwp2qokzgxtAI9kKRkoh7ew3LmTEZ4bbhhPZ9zvdoWnf2+crp1TzOziw05326xi2Z7pw
         CkyyW5tMgL3P2C2IflIODxy6vOHxdnv3vbBV6spCb1XBF3LdIQckIIv1nB2ptnYBBhAQ
         q5A8dqi7q6Gn/CzoOGO/HOckvYwxa4bfZNX79YQ19yO1crf9Sv926yNEPBKg6ACtLb33
         suiC+vTG7QrZwJH4Xa9S5zSeg9t+89VoJLOs8vWNjLPGLsfZvHUywhzGrKOweujM8Eq1
         ZL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=crj+HAeFMHYpMGc2Vri23NpQoY1H9viFDZw8Jh0Ioa8=;
        b=NtrFPL4jjlV0grj3sE3CBLUgjQcgnX9jUOZw/vO68z8rVsFYRXelMkwaVHfUwEKEEX
         5YE/dAYg3KuPxO/mFNpia+lEOmqPz0GpFF2mqHGoiYen0RA3Gpt/iyZom3942WBwEYV5
         ARJ0mnPUw+XBHJywLixfvu0g0CBoDqy1u/tsFjfAzIC+acXeVrgwrmClZQ6nHBbKUu8S
         w814l69r4YipJw21lToM5ka+DHwFL5iujqKh3JXPTFUMAlxFpE+8rvJWLzfRArUuAXhf
         mn3fk/S0D6gVv4fTYBNY0JeqbQEv6GI9ege1fWCW8PVEF2Brc/azAnadukaDI5auUUHQ
         8/iA==
X-Gm-Message-State: AOAM532Awtbwpx5EP1q587LGQGr6wO+NJZnR00LnOqteYXgBaxyflUKN
        T1ELFIVL54Byxvwqx3SoS7dD09jOMLeqyA/wLutZiA==
X-Google-Smtp-Source: ABdhPJwmcynM6RngSWzMnPFi6FCAD8umhWNDOQAbg/DI4vUZBFAnjOrOoq6FXtq+v9hbCvrez8iFk786yu19UpRWtr4=
X-Received: by 2002:a05:6402:1ca2:: with SMTP id cz2mr4531383edb.15.1593196538444;
 Fri, 26 Jun 2020 11:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be>
 <20200624192310.16923-2-justin.iurman@uliege.be> <CALx6S34K5+GabNAs9GtutpPNxR+fAdibDTFphT_LUOJ1mAzfOQ@mail.gmail.com>
 <517934373.36575257.1593107228168.JavaMail.zimbra@uliege.be>
 <CALx6S34-2TNpWhNOwGfe1xwAJhCZr+xsh7WV2eVN6Yv2qshYrA@mail.gmail.com>
 <1383260536.37030044.1593159759771.JavaMail.zimbra@uliege.be>
 <CALx6S35-=m-V7ytcMk0AO9YDwGSJmKkpp9SpWQf4PPNkNXuOYA@mail.gmail.com> <1451231290.37652193.1593191656880.JavaMail.zimbra@uliege.be>
In-Reply-To: <1451231290.37652193.1593191656880.JavaMail.zimbra@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 26 Jun 2020 11:35:27 -0700
Message-ID: <CALx6S35z6P6B5edDSro7bkH9-webtv98gxNH__K08asWMeNZbg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] ipv6: eh: Introduce removable TLVs
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:14 AM Justin Iurman <justin.iurman@uliege.be> wr=
ote:
>
> >> Tom,
> >>
> >> >> Hi Tom,
> >> >>
> >> >> >> Add the possibility to remove one or more consecutive TLVs witho=
ut
> >> >> >> messing up the alignment of others. For now, only IOAM requires =
this
> >> >> >> behavior.
> >> >> >>
> >> >> > Hi Justin,
> >> >> >
> >> >> > Can you explain the motivation for this? Per RFC8200, extension
> >> >> > headers in flight are not to be added, removed, or modified outsi=
de of
> >> >> > the standard rules for processing modifiable HBH and DO TLVs., th=
at
> >> >> > would include adding and removing TLVs in EH. One obvious problem=
 this
> >> >>
> >> >> As you already know from our last meeting, IOAM may be configured o=
n a node such
> >> >> that a specific IOAM namespace should be removed. Therefore, this p=
atch
> >> >> provides support for the deletion of a TLV (or consecutive TLVs), w=
ithout
> >> >> removing the entire EH (if it's empty, there will be padding). Note=
 that there
> >> >> is a similar "problem" with the Incremental Trace where you'd need =
to expand
> >> >> the Hop-by-Hop (not included in this patchset). I agree that RFC 82=
00 is
> >> >> against modification of in-flight EHs, but there are several reason=
s that, I
> >> >> believe, mitigates this statement.
> >> >>
> >> >> Let's keep in mind that IOAM purpose is "private" (=3D IOAM domain)=
, ie not widely
> >> >> deployed on the Internet. We can distinguish two big scenarios: (i)=
 in-transit
> >> >> traffic where it is encapsulated (IPv6-in-IPv6) and (ii) traffic in=
side the
> >> >> domain, ie from an IOAM node inside the domain to another one (no n=
eed for
> >> >> encapsulation). In both cases, we kind of own the traffic: (i) enca=
psulation,
> >> >> so we modify "our" header and (ii) we already own the traffic.
> >> >>
> >> >> And if someone is still angry about this, well, the good news is th=
at such
> >> >> modification can be avoided most of the time. Indeed, operators are=
 advised to
> >> >> remove an IOAM namespace only on egress nodes. This way, the destin=
ation
> >> >> (either the tunnel destination or the real destination, depending o=
n the
> >> >> scenario) will receive EHs and take care of them without the need t=
o remove
> >> >> anything. But, again, operators can do what they want and I'd tend =
to adhere to
> >> >> David's philosophy [1] and give them the possibility to choose what=
 to do.
> >> >>
> >> >
> >> > Justin,
> >> >
> >> > 6man WG has had a _long_ and sometimes bitter discussion around this
> >> > particularly with regards to insertion of SRH. The current consensus
> >> > of IETF is that it is a violation of RFC8200.  We've heard all the
> >> > arguments that it's only for limited domains and narrow use cases,
> >> > nevertheless there are several problems that the header
> >> > insertion/deletion advocates never answered-- it breaks AH, it break=
s
> >> > PMTU discovery, it breaks ICMP. There is also a risk that a
> >> > non-standard modification could cause a packet to be dropped
> >> > downstream from the node that modifies it. There is no attribution o=
n
> >> > who created the problem, and hence this can lead to systematic
> >> > blackholes which are the most miserable sort of problem to debug.
> >>
> >> Yes, I know the whole story and it's been stormy from what I understoo=
d.
> >>
> >> > Fundamentally, it is not robust per Postel's law (I actually wrote a
> >> > draft to try to make it robust in draft-herbert-6man-eh-attrib-00 if
> >> > you're interested).
> >>
> >> Interesting, I'll take a look.
> >>
> >> > IMO, we shouldn't be using Linux as a backdoor to implement protocol
> >> > that IETF is saying isn't robust. Can you point out in the IOAM draf=
ts
> >> > where this requirement is specified, then I can take it up in IOAM W=
G
> >> > or 6man if needed...
> >>
> >> Well, I wouldn't say that IETF is considering IPv6-IOAM as not robust =
since [1]
> >> (IPv6 encapsulation for IOAM) and [2] (IOAM data fields) are about to =
be
> >> published.
> >
> > I was specifically referring to the requirements around removing the
> > IOAM TLV from packets in-flight. I don't readily see that in the IOAM
> > drafts.
>patch
> Actually, this is not in the draft. Authors wanted to give operators a li=
ttle bit of freedom and this one would restrict their choices, even if it's=
 better or even the most logical option we could think about. Maybe we coul=
d discuss this on the IPPM mailing list as well on whether we should add it=
 or not? I've two advises for operators, one about the encapsulation and th=
is one about the removal of an IOAM option.
>

Justin,

You're welcome to take it up on the IPPM list, but beware there is
going to be pushback. Make sure you can show a clear justification and
how any potential issues it causes are mitigated. If
draft-herbert-6man-eh-attrib-00 facilitates that we can take a look
implementing it.

Until we have clarity on the protocol requirements and the need for
this, I don't think this patch should be accepted.

Tom
> > Also, be careful about saying that drafts are about to be published by
> > IETF. Until a draft reaches the RFC editor we really can't say that. I
> > don't believe drafts you're referring to have even made it through
> > WGLC.
>
> Indeed, but draft-ietf-ippm-ioam-data is already at its second WGLC, did =
you miss it on the IPPM mailing list? As for draft-ietf-ippm-ioam-ipv6-opti=
ons, it is just my prediction but I guess it should come soon as well since=
 IANA early allocation (there were talks about that on the WG).
>
> Justin
>
> > Tom
> >
> >>
> >> Justin
> >>
> >>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options-01
> >>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data-09
> >>
> >> > Tom
> >> >
> >> >> > creates is that it breaks AH if the TLVs are removed in HBH befor=
e AH
> >> >> > is processed (AH is processed after HBH).
> >> >>
> >> >> Correct. But I don't think it should prevent us from having IOAM in=
 the kernel.
> >> >> Again, operators could simply apply IOAM on a subset of the traffic=
 that does
> >> >> not include AHs, for example.
> >> >>
> >> >> Justin
> >> >>
> >> >>   [1] https://www.mail-archive.com/netdev@vger.kernel.org/msg136797=
.html
> >> >>
> >> >> > Tom
> >> >> >> By default, an 8-octet boundary is automatically assumed. This i=
s the
> >> >> >> price to pay (at most a useless 4-octet padding) to make sure ev=
erything
> >> >> >> is still aligned after the removal.
> >> >> >>
> >> >> >> Proof: let's assume for instance the following alignments 2n, 4n=
 and 8n
> >> >> >> respectively for options X, Y and Z, inside a Hop-by-Hop extensi=
on
> >> >> >> header.
> >> >> >>
> >> >> >> Example 1:
> >> >> >>
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       X       |       X       |    Padding    |    Padding    =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |                                                               =
|
> >> >> >> ~                Option to be removed (8 octets)                =
~
> >> >> >> |                                                               =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Y       |       Y       |       Y       |       Y       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |    Padding    |    Padding    |    Padding    |    Padding    =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >>
> >> >> >> Result 1: assuming a 4-octet boundary would work, as well as an =
8-octet
> >> >> >> boundary (same result in both cases).
> >> >> >>
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       X       |       X       |    Padding    |    Padding    =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Y       |       Y       |       Y       |       Y       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |    Padding    |    Padding    |    Padding    |    Padding    =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >>
> >> >> >> Example 2:
> >> >> >>
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       X       |       X       |    Padding    |    Padding    =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |                Option to be removed (4 octets)                =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Y       |       Y       |       Y       |       Y       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >>
> >> >> >> Result 2: assuming a 4-octet boundary WOULD NOT WORK. Indeed, op=
tion Z
> >> >> >> would not be 8n-aligned and the Hop-by-Hop size would not be a m=
ultiple
> >> >> >> of 8 anymore.
> >> >> >>
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |  Next header  |  Hdr Ext Len  |       X       |       X       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       X       |       X       |    Padding    |    Padding    =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Y       |       Y       |       Y       |       Y       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >> |       Z       |       Z       |       Z       |       Z       =
|
> >> >> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+
> >> >> >>
> >> >> >> Therefore, the largest (8-octet) boundary is assumed by default =
and for
> >> >> >> all, which means that blocks are only moved in multiples of 8. T=
his
> >> >> >> assertion guarantees good alignment.
> >> >> >>
> >> >> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >> >> >> ---
> >> >> >>  net/ipv6/exthdrs.c | 134 ++++++++++++++++++++++++++++++++++++--=
-------
> >> >> >>  1 file changed, 108 insertions(+), 26 deletions(-)
> >> >> >>
> >> >> >> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> >> >> >> index e9b366994475..f27ab3bf2e0c 100644
> >> >> >> --- a/net/ipv6/exthdrs.c
> >> >> >> +++ b/net/ipv6/exthdrs.c
> >> >> >> @@ -52,17 +52,27 @@
> >> >> >>
> >> >> >>  #include <linux/uaccess.h>
> >> >> >>
> >> >> >> -/*
> >> >> >> - *     Parsing tlv encoded headers.
> >> >> >> +/* States for TLV parsing functions. */
> >> >> >> +
> >> >> >> +enum {
> >> >> >> +       TLV_ACCEPT,
> >> >> >> +       TLV_REJECT,
> >> >> >> +       TLV_REMOVE,
> >> >> >> +       __TLV_MAX
> >> >> >> +};
> >> >> >> +
> >> >> >> +/* Parsing TLV encoded headers.
> >> >> >>   *
> >> >> >> - *     Parsing function "func" returns true, if parsing succeed
> >> >> >> - *     and false, if it failed.
> >> >> >> - *     It MUST NOT touch skb->h.
> >> >> >> + * Parsing function "func" returns either:
> >> >> >> + *  - TLV_ACCEPT if parsing succeeds
> >> >> >> + *  - TLV_REJECT if parsing fails
> >> >> >> + *  - TLV_REMOVE if TLV must be removed
> >> >> >> + * It MUST NOT touch skb->h.
> >> >> >>   */
> >> >> >>
> >> >> >>  struct tlvtype_proc {
> >> >> >>         int     type;
> >> >> >> -       bool    (*func)(struct sk_buff *skb, int offset);
> >> >> >> +       int     (*func)(struct sk_buff *skb, int offset);
> >> >> >>  };
> >> >> >>
> >> >> >>  /*********************
> >> >> >> @@ -109,19 +119,67 @@ static bool ip6_tlvopt_unknown(struct sk_b=
uff *skb, int
> >> >> >> optoff,
> >> >> >>         return false;
> >> >> >>  }
> >> >> >>
> >> >> >> +/* Remove one or several consecutive TLVs and recompute offsets=
, lengths */
> >> >> >> +
> >> >> >> +static int remove_tlv(int start, int end, struct sk_buff *skb)
> >> >> >> +{
> >> >> >> +       int len =3D end - start;
> >> >> >> +       int padlen =3D len % 8;
> >> >> >> +       unsigned char *h;
> >> >> >> +       int rlen, off;
> >> >> >> +       u16 pl_len;
> >> >> >> +
> >> >> >> +       rlen =3D len - padlen;
> >> >> >> +       if (rlen) {
> >> >> >> +               skb_pull(skb, rlen);
> >> >> >> +               memmove(skb_network_header(skb) + rlen, skb_netw=
ork_header(skb),
> >> >> >> +                       start);
> >> >> >> +               skb_postpull_rcsum(skb, skb_network_header(skb),=
 rlen);
> >> >> >> +
> >> >> >> +               skb_reset_network_header(skb);
> >> >> >> +               skb_set_transport_header(skb, sizeof(struct ipv6=
hdr));
> >> >> >> +
> >> >> >> +               pl_len =3D be16_to_cpu(ipv6_hdr(skb)->payload_le=
n) - rlen;
> >> >> >> +               ipv6_hdr(skb)->payload_len =3D cpu_to_be16(pl_le=
n);
> >> >> >> +
> >> >> >> +               skb_transport_header(skb)[1] -=3D rlen >> 3;
> >> >> >> +               end -=3D rlen;
> >> >> >> +       }
> >> >> >> +
> >> >> >> +       if (padlen) {
> >> >> >> +               off =3D end - padlen;
> >> >> >> +               h =3D skb_network_header(skb);
> >> >> >> +
> >> >> >> +               if (padlen =3D=3D 1) {
> >> >> >> +                       h[off] =3D IPV6_TLV_PAD1;
> >> >> >> +               } else {
> >> >> >> +                       padlen -=3D 2;
> >> >> >> +
> >> >> >> +                       h[off] =3D IPV6_TLV_PADN;
> >> >> >> +                       h[off + 1] =3D padlen;
> >> >> >> +                       memset(&h[off + 2], 0, padlen);
> >> >> >> +               }
> >> >> >> +       }
> >> >> >> +
> >> >> >> +       return end;
> >> >> >> +}
> >> >> >> +
> >> >> >>  /* Parse tlv encoded option header (hop-by-hop or destination) =
*/
> >> >> >>
> >> >> >>  static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >> >> >>                           struct sk_buff *skb,
> >> >> >> -                         int max_count)
> >> >> >> +                         int max_count,
> >> >> >> +                         bool removable)
> >> >> >>  {
> >> >> >>         int len =3D (skb_transport_header(skb)[1] + 1) << 3;
> >> >> >> -       const unsigned char *nh =3D skb_network_header(skb);
> >> >> >> +       unsigned char *nh =3D skb_network_header(skb);
> >> >> >>         int off =3D skb_network_header_len(skb);
> >> >> >>         const struct tlvtype_proc *curr;
> >> >> >>         bool disallow_unknowns =3D false;
> >> >> >> +       int off_remove =3D 0;
> >> >> >>         int tlv_count =3D 0;
> >> >> >>         int padlen =3D 0;
> >> >> >> +       int ret;
> >> >> >>
> >> >> >>         if (unlikely(max_count < 0)) {
> >> >> >>                 disallow_unknowns =3D true;
> >> >> >> @@ -173,12 +231,14 @@ static bool ip6_parse_tlv(const struct tlv=
type_proc
> >> >> >> *procs,
> >> >> >>                         if (tlv_count > max_count)
> >> >> >>                                 goto bad;
> >> >> >>
> >> >> >> +                       ret =3D -1;
> >> >> >>                         for (curr =3D procs; curr->type >=3D 0; =
curr++) {
> >> >> >>                                 if (curr->type =3D=3D nh[off]) {
> >> >> >>                                         /* type specific length/=
alignment
> >> >> >>                                            checks will be perfor=
med in the
> >> >> >>                                            func(). */
> >> >> >> -                                       if (curr->func(skb, off)=
 =3D=3D false)
> >> >> >> +                                       ret =3D curr->func(skb, =
off);
> >> >> >> +                                       if (ret =3D=3D TLV_REJEC=
T)
> >> >> >>                                                 return false;
> >> >> >>                                         break;
> >> >> >>                                 }
> >> >> >> @@ -187,6 +247,17 @@ static bool ip6_parse_tlv(const struct tlvt=
ype_proc *procs,
> >> >> >>                             !ip6_tlvopt_unknown(skb, off, disall=
ow_unknowns))
> >> >> >>                                 return false;
> >> >> >>
> >> >> >> +                       if (removable) {
> >> >> >> +                               if (ret =3D=3D TLV_REMOVE) {
> >> >> >> +                                       if (!off_remove)
> >> >> >> +                                               off_remove =3D o=
ff - padlen;
> >> >> >> +                               } else if (off_remove) {
> >> >> >> +                                       off =3D remove_tlv(off_r=
emove, off, skb);
> >> >> >> +                                       nh =3D skb_network_heade=
r(skb);
> >> >> >> +                                       off_remove =3D 0;
> >> >> >> +                               }
> >> >> >> +                       }
> >> >> >> +
> >> >> >>                         padlen =3D 0;
> >> >> >>                         break;
> >> >> >>                 }
> >> >> >> @@ -194,8 +265,13 @@ static bool ip6_parse_tlv(const struct tlvt=
ype_proc *procs,
> >> >> >>                 len -=3D optlen;
> >> >> >>         }
> >> >> >>
> >> >> >> -       if (len =3D=3D 0)
> >> >> >> +       if (len =3D=3D 0) {
> >> >> >> +               /* Don't forget last TLV if it must be removed *=
/
> >> >> >> +               if (off_remove)
> >> >> >> +                       remove_tlv(off_remove, off, skb);
> >> >> >> +
> >> >> >>                 return true;
> >> >> >> +       }
> >> >> >>  bad:
> >> >> >>         kfree_skb(skb);
> >> >> >>         return false;
> >> >> >> @@ -206,7 +282,7 @@ static bool ip6_parse_tlv(const struct tlvty=
pe_proc *procs,
> >> >> >>   *****************************/
> >> >> >>
> >> >> >>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> >> >> >> -static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >> >> >> +static int ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >> >> >>  {
> >> >> >>         struct ipv6_destopt_hao *hao;
> >> >> >>         struct inet6_skb_parm *opt =3D IP6CB(skb);
> >> >> >> @@ -257,11 +333,11 @@ static bool ipv6_dest_hao(struct sk_buff *=
skb, int optoff)
> >> >> >>         if (skb->tstamp =3D=3D 0)
> >> >> >>                 __net_timestamp(skb);
> >> >> >>
> >> >> >> -       return true;
> >> >> >> +       return TLV_ACCEPT;
> >> >> >>
> >> >> >>   discard:
> >> >> >>         kfree_skb(skb);
> >> >> >> -       return false;
> >> >> >> +       return TLV_REJECT;
> >> >> >>  }
> >> >> >>  #endif
> >> >> >>
> >> >> >> @@ -306,7 +382,8 @@ static int ipv6_destopt_rcv(struct sk_buff *=
skb)
> >> >> >>  #endif
> >> >> >>
> >> >> >>         if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
> >> >> >> -                         init_net.ipv6.sysctl.max_dst_opts_cnt)=
) {
> >> >> >> +                         init_net.ipv6.sysctl.max_dst_opts_cnt,
> >> >> >> +                         false)) {
> >> >> >>                 skb->transport_header +=3D extlen;
> >> >> >>                 opt =3D IP6CB(skb);
> >> >> >>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> >> >> >> @@ -918,24 +995,24 @@ static inline struct net *ipv6_skb_net(str=
uct sk_buff
> >> >> >> *skb)
> >> >> >>
> >> >> >>  /* Router Alert as of RFC 2711 */
> >> >> >>
> >> >> >> -static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >> >> >> +static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >> >> >>  {
> >> >> >>         const unsigned char *nh =3D skb_network_header(skb);
> >> >> >>
> >> >> >>         if (nh[optoff + 1] =3D=3D 2) {
> >> >> >>                 IP6CB(skb)->flags |=3D IP6SKB_ROUTERALERT;
> >> >> >>                 memcpy(&IP6CB(skb)->ra, nh + optoff + 2, sizeof(=
IP6CB(skb)->ra));
> >> >> >> -               return true;
> >> >> >> +               return TLV_ACCEPT;
> >> >> >>         }
> >> >> >>         net_dbg_ratelimited("ipv6_hop_ra: wrong RA length %d\n",
> >> >> >>                             nh[optoff + 1]);
> >> >> >>         kfree_skb(skb);
> >> >> >> -       return false;
> >> >> >> +       return TLV_REJECT;
> >> >> >>  }
> >> >> >>
> >> >> >>  /* Jumbo payload */
> >> >> >>
> >> >> >> -static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >> >> >> +static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >> >> >>  {
> >> >> >>         const unsigned char *nh =3D skb_network_header(skb);
> >> >> >>         struct inet6_dev *idev =3D __in6_dev_get_safely(skb->dev=
);
> >> >> >> @@ -953,12 +1030,12 @@ static bool ipv6_hop_jumbo(struct sk_buff=
 *skb, int
> >> >> >> optoff)
> >> >> >>         if (pkt_len <=3D IPV6_MAXPLEN) {
> >> >> >>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRO=
RS);
> >> >> >>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+=
2);
> >> >> >> -               return false;
> >> >> >> +               return TLV_REJECT;
> >> >> >>         }
> >> >> >>         if (ipv6_hdr(skb)->payload_len) {
> >> >> >>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRO=
RS);
> >> >> >>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff)=
;
> >> >> >> -               return false;
> >> >> >> +               return TLV_REJECT;
> >> >> >>         }
> >> >> >>
> >> >> >>         if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
> >> >> >> @@ -970,16 +1047,16 @@ static bool ipv6_hop_jumbo(struct sk_buff=
 *skb, int
> >> >> >> optoff)
> >> >> >>                 goto drop;
> >> >> >>
> >> >> >>         IP6CB(skb)->flags |=3D IP6SKB_JUMBOGRAM;
> >> >> >> -       return true;
> >> >> >> +       return TLV_ACCEPT;
> >> >> >>
> >> >> >>  drop:
> >> >> >>         kfree_skb(skb);
> >> >> >> -       return false;
> >> >> >> +       return TLV_REJECT;
> >> >> >>  }
> >> >> >>
> >> >> >>  /* CALIPSO RFC 5570 */
> >> >> >>
> >> >> >> -static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> >> >> >> +static int ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> >> >> >>  {
> >> >> >>         const unsigned char *nh =3D skb_network_header(skb);
> >> >> >>
> >> >> >> @@ -992,11 +1069,11 @@ static bool ipv6_hop_calipso(struct sk_bu=
ff *skb, int
> >> >> >> optoff)
> >> >> >>         if (!calipso_validate(skb, nh + optoff))
> >> >> >>                 goto drop;
> >> >> >>
> >> >> >> -       return true;
> >> >> >> +       return TLV_ACCEPT;
> >> >> >>
> >> >> >>  drop:
> >> >> >>         kfree_skb(skb);
> >> >> >> -       return false;
> >> >> >> +       return TLV_REJECT;
> >> >> >>  }
> >> >> >>
> >> >> >>  static const struct tlvtype_proc tlvprochopopt_lst[] =3D {
> >> >> >> @@ -1041,7 +1118,12 @@ int ipv6_parse_hopopts(struct sk_buff *sk=
b)
> >> >> >>
> >> >> >>         opt->flags |=3D IP6SKB_HOPBYHOP;
> >> >> >>         if (ip6_parse_tlv(tlvprochopopt_lst, skb,
> >> >> >> -                         init_net.ipv6.sysctl.max_hbh_opts_cnt)=
) {
> >> >> >> +                         init_net.ipv6.sysctl.max_hbh_opts_cnt,
> >> >> >> +                         true)) {
> >> >> >> +               /* we need to refresh the length in case
> >> >> >> +                * at least one TLV was removed
> >> >> >> +                */
> >> >> >> +               extlen =3D (skb_transport_header(skb)[1] + 1) <<=
 3;
> >> >> >>                 skb->transport_header +=3D extlen;
> >> >> >>                 opt =3D IP6CB(skb);
> >> >> >>                 opt->nhoff =3D sizeof(struct ipv6hdr);
> >> >> >> --
> > > > > >> 2.17.1
