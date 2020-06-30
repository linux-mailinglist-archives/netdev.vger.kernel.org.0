Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEF920FC58
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgF3S5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgF3S5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:57:18 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF19BC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:57:17 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id b15so17197514edy.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zCoYtnZeT2/chOsMLedboMjom3LOXrBZI5STKJWRMfg=;
        b=tbhK3DhrIIc11P6cnwuotaGox1xwmlP5VfY3shZXXeSid350lucHFc+rJ1k2kfhHzJ
         IkxrPZjwGGenXKdkwPsxQQzy5qj6/q5CqhqDF5gC1Fz+XJfOpMfxcBskirJiCPh7S6ps
         wmW9Ti/HW00430lGMRiDeWSELECW8iFB3174LgnTP+5XIpJV1cCFfi6EqriZz3o77JZB
         JddbpN6MlndDmYMLNszJb8to6dwuhg3LVzo8LWUQET4AUKjISMjP8NNH3aycHDneXkIi
         sf1HB8HY4evuMbecIq0A3RCe9BnDNqa/R6bUacKMBXO6boD+X4K/i/WHy9PNcOoOFYtD
         NQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zCoYtnZeT2/chOsMLedboMjom3LOXrBZI5STKJWRMfg=;
        b=uS2WgwDU/KVg1elzG7gcPhdRnoyPgZS2Tz9Pgp7iP6eeZPyTQlrcp6e5nbEV6CWczM
         61Ug4Bzj/TH900P3tml8izMVzVQnCro4QqqGuC/+hXBbO7Q2cPagFniZAoDW69fPQQOU
         FnCdak/SIeK5xl+d2Qb+TYW94iHrNo8Ffb7r/JzdptkdPHs5xbvSBrWBL7qK+sCvb5mE
         adDrNl2KOi+OpXfzmTmcePBnI8ZuTpsFCEtjzolCjpAK5p1+rt6DEok4OrepafnT1bY7
         cJ3AS4Vh0mvZGG31+zyVNiuWLywjmQ6dwdL5eWRLRCJWxnLiQRj9nGXBZ4sNGy4T9GgR
         oNlA==
X-Gm-Message-State: AOAM531bYqUQcJj4NEWSGgr30eZalohGiewH+0RTE2JadKHkYqmIto13
        AM69ZhvLllSN3C1HIYrmhTsZNyT2aIJD8QPaRhg9gQ==
X-Google-Smtp-Source: ABdhPJxd/R+B16rG0rEETVZvDVGgDMx8tZ1m7Su/55CDbwPMsXCpmzARfRWO1P4/8TiZ2lIbRezsrheBeDT3qgPeo3I=
X-Received: by 2002:aa7:d049:: with SMTP id n9mr17567534edo.39.1593543436531;
 Tue, 30 Jun 2020 11:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com> <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com> <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
 <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
 <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com>
 <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com> <CALx6S37QCUanU0Cpe+mCedoiceLyxX58O2jdrv+g64YQTUj2sw@mail.gmail.com>
 <CA+FuTSf-mHHPksCvvTU3B+Hr_aEzj1KjfS3ksCbHxXfXQrOd_w@mail.gmail.com>
In-Reply-To: <CA+FuTSf-mHHPksCvvTU3B+Hr_aEzj1KjfS3ksCbHxXfXQrOd_w@mail.gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Tue, 30 Jun 2020 11:57:05 -0700
Message-ID: <CALx6S34-MzDyqbA64iFiPZmBVOrdg-tg+ZEzswGdKM9_Y0wAPw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 9:52 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jun 30, 2020 at 12:41 PM Tom Herbert <tom@herbertland.com> wrote:
> >
> > On Tue, Jun 30, 2020 at 9:16 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >
> > >
> > >
> > > On 6/30/20 6:57 AM, Willem de Bruijn wrote:
> > > > On Mon, Jun 29, 2020 at 10:19 PM Willem de Bruijn
> > > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >>
> > > >> On Mon, Jun 29, 2020 at 8:37 PM Tom Herbert <tom@herbertland.com> wrote:
> > > >>>
> > > >>> On Mon, Jun 29, 2020 at 4:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >>>>
> > > >>>>
> > > >>>>
> > > >>>> On 6/29/20 2:30 PM, Willem de Bruijn wrote:
> > > >>>>> On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >>>>>>
> > > >>>>>>
> > > >>>>>>
> > > >>>>>> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> > > >>>>>>> From: Willem de Bruijn <willemb@google.com>
> > > >>>>>>>
> > > >>>>>>> ICMP messages may include an extension structure after the original
> > > >>>>>>> datagram. RFC 4884 standardized this behavior.
> > > >>>>>>>
> > > >>>>>>> It introduces an explicit original datagram length field in the ICMP
> > > >>>>>>> header to delineate the original datagram from the extension struct.
> > > >>>>>>>
> > > >>>>>>> Return this field when reading an ICMP error from the error queue.
> > > >>>>>>
> > > >>>>>> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
> > > >>>>>> second word of icmp header.
> > > >>>>>>
> > > >>>>>> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
> > > >>>>>>
> > > >>>>>> Should we add an element in the union to make this a little bit more explicit/readable ?
> > > >>>>>>
> > > >>>>>> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> > > >>>>>> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
> > > >>>>>> --- a/include/uapi/linux/icmp.h
> > > >>>>>> +++ b/include/uapi/linux/icmp.h
> > > >>>>>> @@ -76,6 +76,7 @@ struct icmphdr {
> > > >>>>>>                 __be16  sequence;
> > > >>>>>>         } echo;
> > > >>>>>>         __be32  gateway;
> > > >>>>>> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
> > > >>>>>>         struct {
> > > >>>>>>                 __be16  __unused;
> > > >>>>>>                 __be16  mtu;
> > > >>>>>
> > > >>>>> Okay. How about a variant of the existing struct frag?
> > > >>>>>
> > > >>>>> @@ -80,6 +80,11 @@ struct icmphdr {
> > > >>>>>                 __be16  __unused;
> > > >>>>>                 __be16  mtu;
> > > >>>>>         } frag;
> > > >>>>> +       struct {
> > > >>>>> +               __u8    __unused;
> > > >>>>> +               __u8    length;
> > > >>>>> +               __be16  mtu;
> > > >>>>> +       } rfc_4884;
> > > >>>>>         __u8    reserved[4];
> > > >>>>>    } un;
> > > >>>>>
> > > >>>>
> > > >>>> Sure, but my point was later in the code :
> > > >>>>
> > > >>>>>>> +     if (inet_sk(sk)->recverr_rfc4884)
> > > >>>>>>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
> > > >>>>>>
> > > >>>>>> ntohl(icmp_hdr(skb)->un.second_word);
> > > >>>>
> > > >>>> If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
> > > >>>> reading linux kernel code to understand why we do this.
> > > >>>>
> > > >>> It's also potentially problematic. The other bits are Unused, which
> > > >>> isn't the same thing as necessarily being zero. Userspace might assume
> > > >>> that info is the length without checking its bounded.
> > > >>
> > > >> It shouldn't. The icmp type and code are passed in sock_extended_err
> > > >> as ee_type and ee_code. So it can demultiplex the meaning of the rest
> > > >> of the icmp header.
> > > >>
> > > >> It just needs access to the other 32-bits, which indeed are context
> > > >> sensitive. It makes more sense to me to let userspace demultiplex this
> > > >> in one place, rather than demultiplex in the kernel and define a new,
> > > >> likely no simpler, data structure to share with userspace.
> > > >>
> > > >> Specific to RFC 4884, the 8-bit length field coexists with the
> > > >> 16-bit mtu field in case of ICMP_FRAG_NEEDED, so we cannot just pass
> > > >> the first as ee_info in RFC 4884 mode. sock_extended_err additionally
> > > >> has ee_data, but after that we're out of fields, too, so this approach
> > > >> is not very future proof to additional ICMP extensions.
> > > >>
> > > >> On your previous point, it might be useful to define struct rfc_4884
> > > >> equivalent outside struct icmphdr, so that an application can easily
> > > >> cast to that. RFC 4884 itself does not define any extension objects.
> > > >> That is out of scope there, and in my opinion, here. Again, better
> > > >> left to userspace. Especially because as it describes, it standardized
> > > >> the behavior after observing non-compliant, but existing in the wild,
> > > >> proprietary extension variants. Users may have to change how they
> > > >> interpret the fields based on what they have deployed.
> > > >
> > > > As this just shares the raw icmp header data, I should probably
> > > > change the name to something less specific to RFC 4884.
> > > >
> > > > Since it would also help with decoding other extensions, such as
> > > > the one you mention in  draft-ietf-6man-icmp-limits-08.
> > > >
> > > > Unfortunately I cannot simply reserve IP_RECVERR with integer 2.
> > > > Perhaps IP_RECVERR_EXINFO.
> > > >
> > >
> > > Perhaps let the icmp header as is, but provides the extra information
> > > as an explicit ancillary message in ip_recv_error() ?
> > >
> > > Really this is all about documentation and providing stable API.
> > >
> > Actually, I think we may have a subtle bug here.
> >
> > RFC4884 appends the ICMP extension to the original datagram. The RFC
> > describes backwards compatibility in section 5. To be backwards
> > compatible with legacy implementations that don't know how to parse
> > the extension, and in particular to find the length of the original
> > datagram in the data, the requirement is that at the original datagram
> > is at least 128 bytes long and it seems to assume no ICMP application
> > need to parse beyond that. But parsing beyond 128 bytes is possible,
> > consider that the original datagram was UDP/IPv6 with an extension
> > header such that the UDP header is offset beyond 128 bytes in the
> > packet. If we don't take this into account, the UDP ports for socket
> > lookup would be incorrect.
> >
> > To fix this, we could check the Length field per the types that
> > support extensions as described in RFC4884. If it's non-zero then
> > assume the extension is present, so before processing the original
> > datagram, e.g. performing socket lookup, trim the skb to the length of
> > the orignal datagram.
>
> This is somewhat orthogonal to this patch.
>
> You are suggesting proactively protecting applications that do not
> know how to parse RFC 4884 compliant packets by truncating
> those unless the application sets the new setsockopt?
>
No, the bug is a bit more insidious. The problem is that it's possible
to misdirect an ICMP error to the wrong socket. If that can happen and
leads to adverse side effects then it's a bug. Grant it, in normal
conditions this is probably exceeding rare, but we can't discount the
possibility and this sounds like the sort of thing that could be used
in some twisted DOS attack.

> I'm afraid that might break legacy applications that currently do
> expect extension objects. They already can in case of ICMPv6.
> And unfortunately they can try in an unsafe manner by parsing
> the original datagram for ICMPv4, too.
>
I suspect there's more legacy applications that don't understand the
extensions so the risk of misinterpreting the packet data with
extensions exists for them.

> ICMPv6 differs from ICMP in that it suggests forwarding as much
> of the "invoking" packet as possible without exceeding the min
> MTU (1280B).
>
> RFC 4884 mentions the minimum 128 B for ICMP but not for
> ICMPv6. It specifically keeps the wording about forwarding as
> much as possible.

Out of curiosity, are you implementing this patch for a specific use
case in mind or just for completeness?

Thanks,
Tom
