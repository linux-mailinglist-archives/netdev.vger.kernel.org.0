Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B1620F9A9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbgF3QlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730657AbgF3QlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:41:13 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EADC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:41:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w6so21335214ejq.6
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axHn6LRtyZJBHNWbeR20C2RlYPRHp97OcdNvSnh/Jg8=;
        b=HscU4g3DfR+CdopW0M2P+3Z/86kdtIu7UOvGCm/uhid10trY5TCUg/hyruOIPWCUMe
         2NBdXub4hjWVsuD/zs3n9dmUMlRwqmV1IUnmE1ILhTef/99QiOYVgyUVQ3d7uyOx3Pp/
         jnqLcdkhNQ0k10qw8CriE97Tdvj6yhHoIf3aQegXMUcVfL13JH19nLVZCPO8SnSJW6bj
         xYsMQzbkmUPPi7aGKyCXVZHdI0hjQxY0y4c2pGu2DgI54gPjuPzvK6gHoSe8mSlF/EPk
         JowhGt3ycTkmFYXOXOjP5gpXt0fBpaWEvXYL2loiyenCEXDdUWqMHqAs9qunctWYtgRz
         upkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axHn6LRtyZJBHNWbeR20C2RlYPRHp97OcdNvSnh/Jg8=;
        b=LrEL0jJTiwgvI75Hn1my27Px1G4kdWmZw9VAqJQ/Lz0CaCNQPlNmAYz1G/R64TsbVM
         USx5fbVsJx4X2QQ4NnpoL6rtRDfTIbEGMmqeeQK0FFNOE29ZzhMQtJg46AuCMFvZsBHq
         bRkHCJ+iGW/p2258UOQzdzm4hmNrcD5sLt5uF1NClDuksJhEDwDjA8KwwxwMV+HAgQqt
         uejw7BnGMUl4vFGrmPQBXB4OWaLtT8BLpruOriQhabeojm3yz6rh6R4/mLNmLcFee22b
         ZgpIFt9Z1Zv6M/rGbxIi/htNUTqsWcZY+XcN1JQNNctf68BJZgeZ7teCaaV/qaWdDBGk
         l5Qg==
X-Gm-Message-State: AOAM530ge3bW4ZZygbkF6Re7oGYOse+LNcd91RNnzQMD59itd6e31+jq
        gLkiD1Tjuz+bFfK7azZLRHvfLXdmXDC1yfpGhc9mNOi2ZFc=
X-Google-Smtp-Source: ABdhPJyuishr9i3ZjuUJVlvjLpkzEamk9fLNeElI2O2Hzw47ecrTdT1kgiwqePcCCu76uQqzPOwIFJt7oW/AFxChao0=
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr19034658ejy.138.1593535271827;
 Tue, 30 Jun 2020 09:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com> <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com> <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
 <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
 <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com> <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com>
In-Reply-To: <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Tue, 30 Jun 2020 09:41:00 -0700
Message-ID: <CALx6S37QCUanU0Cpe+mCedoiceLyxX58O2jdrv+g64YQTUj2sw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 9:16 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
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
>
Actually, I think we may have a subtle bug here.

RFC4884 appends the ICMP extension to the original datagram. The RFC
describes backwards compatibility in section 5. To be backwards
compatible with legacy implementations that don't know how to parse
the extension, and in particular to find the length of the original
datagram in the data, the requirement is that at the original datagram
is at least 128 bytes long and it seems to assume no ICMP application
need to parse beyond that. But parsing beyond 128 bytes is possible,
consider that the original datagram was UDP/IPv6 with an extension
header such that the UDP header is offset beyond 128 bytes in the
packet. If we don't take this into account, the UDP ports for socket
lookup would be incorrect.

To fix this, we could check the Length field per the types that
support extensions as described in RFC4884. If it's non-zero then
assume the extension is present, so before processing the original
datagram, e.g. performing socket lookup, trim the skb to the length of
the orignal datagram.

Tom

> Possible alternative would be to add an union over ee_pad
>
> Legacy applications would always get 0 for ee_pad/ee_length, while
> applications enabling IP_RECVERR_RFC4884 would access the wire value.
>
>
> diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
> index ca5cb3e3c6df745aa4c886ba7b4f88179fa22d86..509a5a6ccc555705ef867d7580553d289d559786 100644
> --- a/include/uapi/linux/errqueue.h
> +++ b/include/uapi/linux/errqueue.h
> @@ -10,7 +10,10 @@ struct sock_extended_err {
>         __u8    ee_origin;
>         __u8    ee_type;
>         __u8    ee_code;
> -       __u8    ee_pad;
> +       union {
> +               __u8    ee_pad;
> +               __u8    ee_length; /* RFC 4884 (see IP_RECVERR_RFC4884) */
> +       };
>         __u32   ee_info;
>         __u32   ee_data;
>  };
