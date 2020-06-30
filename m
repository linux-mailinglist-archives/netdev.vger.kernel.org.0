Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8023020F9AA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbgF3QmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbgF3QmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:42:14 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3623C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:42:13 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t7so9551939qvl.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SadgmInxZZ0jg2UL0WoaLXzMgM4PHV5878bDDnVb0lg=;
        b=NpppUpp8wQw7NO9S/h0gs52tCHqLheUlxdtIFNT5ZtrjkgVpKr0RNs7/l4xZ4q0QJR
         aRebbI3qKzA42xn/dlYBTrwaqP+xv9oLjWfCQFpZWWH7o1vj2TciHUYKoBuqbbWyVyTR
         HqUGRk9/zCem5RznCAXSqeTz1fNMAjBCKkBEw/CXD+zodJzDzyUJZHARyVvN5zlKekq5
         KHV6L8g+krtJuf0u5buUUWagRABpCyevTHtGdtq3XDhmwjKeMw3telIq4/CIkXP+7/cN
         dQAZMDV6+Id+ycBW2pVK40IJLUgbu1V2VutA14Q05SLVk1gVt7YP2N4vmxZW1IHbL9Ha
         X1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SadgmInxZZ0jg2UL0WoaLXzMgM4PHV5878bDDnVb0lg=;
        b=rch59lir4xPrrQPerckE06sof4Tu+QBpzjwFQKLL8CkvZoo4fuEwm2j9gVeSr5gyR9
         ZjpDcLcNiMuLnL6eimWgkobwLCFE6T1TiEIb0yszEJpWgml7xyMKBBncxgII6coANmAv
         bKfpMEH0ZAy+F0USvJZPGUzkz8SrJSXQ4zyRVKesYxISlT1D+KhkH7pdWo4XQjplFJrx
         m+6uIt2elUwiZRW/8bwDqHB2BJT6sY9wtxaB1aqU0eJJ9uPWkmY+QjwyhgTBCFbAiWTZ
         r5ja+6vKqhMAngbzPq6LGaYPiQu7bX1+FE+LTmuuv21Y2wYvnjTvry7hw4/rDKosUUUA
         4XtQ==
X-Gm-Message-State: AOAM531Az1iLdURqoBVOhO6kYULQ6CyUOwtRE/ztrIY/DwXPyRiPEQBb
        U4TlcWYFjMDxbubdYY0AvFnN1Qlx
X-Google-Smtp-Source: ABdhPJzajLERW0vPPvrmKyhRyn+6StuKrtDTWxxTO/hnEIGOb5gZcNkPfZsP6PPueV5VV1ofl5We1g==
X-Received: by 2002:ad4:4a64:: with SMTP id cn4mr20722981qvb.199.1593535332609;
        Tue, 30 Jun 2020 09:42:12 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id o21sm3479456qtt.25.2020.06.30.09.42.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 09:42:12 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id j19so7393072ybj.1
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:42:11 -0700 (PDT)
X-Received: by 2002:a25:cf82:: with SMTP id f124mr35868118ybg.441.1593535331257;
 Tue, 30 Jun 2020 09:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com> <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com> <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
 <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
 <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com> <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com>
In-Reply-To: <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jun 2020 12:41:34 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdHoMg=unJhBSFAMcJ0RJ0oiVqpCe=zpNEipCdApoWYhw@mail.gmail.com>
Message-ID: <CA+FuTSdHoMg=unJhBSFAMcJ0RJ0oiVqpCe=zpNEipCdApoWYhw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:16 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/30/20 6:57 AM, Willem de Bruijn wrote:
> > On Mon, Jun 29, 2020 at 10:19 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> >>
> >> On Mon, Jun 29, 2020 at 8:37 PM Tom Herbert <tom@herbertland.com> wrote:
> >>>
> >>> On Mon, Jun 29, 2020 at 4:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 6/29/20 2:30 PM, Willem de Bruijn wrote:
> >>>>> On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> >>>>>>> From: Willem de Bruijn <willemb@google.com>
> >>>>>>>
> >>>>>>> ICMP messages may include an extension structure after the original
> >>>>>>> datagram. RFC 4884 standardized this behavior.
> >>>>>>>
> >>>>>>> It introduces an explicit original datagram length field in the ICMP
> >>>>>>> header to delineate the original datagram from the extension struct.
> >>>>>>>
> >>>>>>> Return this field when reading an ICMP error from the error queue.
> >>>>>>
> >>>>>> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
> >>>>>> second word of icmp header.
> >>>>>>
> >>>>>> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
> >>>>>>
> >>>>>> Should we add an element in the union to make this a little bit more explicit/readable ?
> >>>>>>
> >>>>>> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> >>>>>> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
> >>>>>> --- a/include/uapi/linux/icmp.h
> >>>>>> +++ b/include/uapi/linux/icmp.h
> >>>>>> @@ -76,6 +76,7 @@ struct icmphdr {
> >>>>>>                 __be16  sequence;
> >>>>>>         } echo;
> >>>>>>         __be32  gateway;
> >>>>>> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
> >>>>>>         struct {
> >>>>>>                 __be16  __unused;
> >>>>>>                 __be16  mtu;
> >>>>>
> >>>>> Okay. How about a variant of the existing struct frag?
> >>>>>
> >>>>> @@ -80,6 +80,11 @@ struct icmphdr {
> >>>>>                 __be16  __unused;
> >>>>>                 __be16  mtu;
> >>>>>         } frag;
> >>>>> +       struct {
> >>>>> +               __u8    __unused;
> >>>>> +               __u8    length;
> >>>>> +               __be16  mtu;
> >>>>> +       } rfc_4884;
> >>>>>         __u8    reserved[4];
> >>>>>    } un;
> >>>>>
> >>>>
> >>>> Sure, but my point was later in the code :
> >>>>
> >>>>>>> +     if (inet_sk(sk)->recverr_rfc4884)
> >>>>>>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
> >>>>>>
> >>>>>> ntohl(icmp_hdr(skb)->un.second_word);
> >>>>
> >>>> If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
> >>>> reading linux kernel code to understand why we do this.
> >>>>
> >>> It's also potentially problematic. The other bits are Unused, which
> >>> isn't the same thing as necessarily being zero. Userspace might assume
> >>> that info is the length without checking its bounded.
> >>
> >> It shouldn't. The icmp type and code are passed in sock_extended_err
> >> as ee_type and ee_code. So it can demultiplex the meaning of the rest
> >> of the icmp header.
> >>
> >> It just needs access to the other 32-bits, which indeed are context
> >> sensitive. It makes more sense to me to let userspace demultiplex this
> >> in one place, rather than demultiplex in the kernel and define a new,
> >> likely no simpler, data structure to share with userspace.
> >>
> >> Specific to RFC 4884, the 8-bit length field coexists with the
> >> 16-bit mtu field in case of ICMP_FRAG_NEEDED, so we cannot just pass
> >> the first as ee_info in RFC 4884 mode. sock_extended_err additionally
> >> has ee_data, but after that we're out of fields, too, so this approach
> >> is not very future proof to additional ICMP extensions.
> >>
> >> On your previous point, it might be useful to define struct rfc_4884
> >> equivalent outside struct icmphdr, so that an application can easily
> >> cast to that. RFC 4884 itself does not define any extension objects.
> >> That is out of scope there, and in my opinion, here. Again, better
> >> left to userspace. Especially because as it describes, it standardized
> >> the behavior after observing non-compliant, but existing in the wild,
> >> proprietary extension variants. Users may have to change how they
> >> interpret the fields based on what they have deployed.
> >
> > As this just shares the raw icmp header data, I should probably
> > change the name to something less specific to RFC 4884.
> >
> > Since it would also help with decoding other extensions, such as
> > the one you mention in  draft-ietf-6man-icmp-limits-08.
> >
> > Unfortunately I cannot simply reserve IP_RECVERR with integer 2.
> > Perhaps IP_RECVERR_EXINFO.
> >
>
> Perhaps let the icmp header as is, but provides the extra information
> as an explicit ancillary message in ip_recv_error() ?
>
> Really this is all about documentation and providing stable API.

Understood. Of course happy to discuss alternatives, as it does set
things in stone.

>
> Possible alternative would be to add an union over ee_pad
>
> Legacy applications would always get 0 for ee_pad/ee_length, while
> applications enabling IP_RECVERR_RFC4884 would access the wire value.

And leave __u32 ee_data free for other uses.

I find it much more intuitive to just unconditionally pass the 32 bit
data that an application may need to be able to decode any ICMP
message (along with ee_type + ee_code), rather than start defining
ee_pad + ee_data fields in context dependent ways.

As for ICMP_FRAG_NEEDED now 24 of the 32 bits are defined, something
will inevitably find a use for the remaining 8 bits, and then we need
another kernel feature.

Also, if going down this path I will have to add the same for IPv6,
while it already exposes all this information userspace needs in
ee_info.

That said, if consensus is that the kernel should make more of an
effort to return this data in a structured form, and it is limited to
32 bits overall, the ee_pad/ee_len union for this case has my
preference. CMSG parsing adds a lot of boilerplate to each
application.
