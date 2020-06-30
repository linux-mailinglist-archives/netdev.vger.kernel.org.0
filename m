Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C24720F9D8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbgF3Qwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733180AbgF3Qwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:52:46 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C46C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:52:46 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j80so19280158qke.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5o2WDZinRRAjterWIfc4fZaEmRvJs1tczuUjLyh7AuU=;
        b=NYbSLAqDy8Z6G4/7sAvXGnk8GwtbEyBOMHU+OyYXSW9qOlT9veUZ4a86y81kFtBDys
         h/3IATDX+a31xzf7wVvrQ0tZQU7sevVGmHjCfKANVhzzEs7ddl7DsoNq8GV7/lYKbOH7
         bI6IWbiCkAp5y6WQ1/t8q9buNYYjbIOib4N7gXxiifPEN9aJEtdDna2nGZiT/jfXq8e5
         jpzmPgxAf3fw7eYrGeXq0QOf6zYxEYm3ayWBH09Z70zzC9SytkAfC4X27YpAGV3z9CUY
         8nzJWGSx0f0zcpKsYzGeoXLroUlQHGO9FbwEdcUb187t45zIWkY8mkiXlSHRmFEUDHxW
         3jxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5o2WDZinRRAjterWIfc4fZaEmRvJs1tczuUjLyh7AuU=;
        b=DAQOTIX0Z9SDi/G92L0gSWF7MxY3uLUYCx39dHEyougvhw/5uMFlG0p/oXvWLRJui0
         Mk6h2uavCA9XDvJ3oO9nwt6M88FkE08724eHQJx20VJV45aZiMge1RsF8hh7uyOewnHf
         5H3SaDAuOlQ437nHtE4b5LTFt/xZ6tdVLYuUmtsEZDnOBxpZE8UPSY6KQRk0vWRtvU4z
         m5UuSsin9RhpYhFlrdeOkgXfdB1O/5rjrPf4zwlkMbthhXY5X7puKDbDaAwzQbUXQ91R
         F4ngOPpJY63l0RlJZo7U1vyZC3iriljcA9sFWOJRrUEnC+9BKZL3GlnI2ltnSlQxGMdy
         aweA==
X-Gm-Message-State: AOAM530TQAuRO0Tk9P5a9uSsSNytxUTJny3nR9wCzl4wvjx6FmFB0noQ
        wkyDIcjo2n0KrdLCdZ3HYM6AB+Gk
X-Google-Smtp-Source: ABdhPJxDYijRc3zByORutwo21etjIiGF0nHIsZxT3K9Gl2MFyfd74UdWvPq/qQosV32uCmDGAd7Q7Q==
X-Received: by 2002:a37:b56:: with SMTP id 83mr19912286qkl.362.1593535965017;
        Tue, 30 Jun 2020 09:52:45 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id d19sm3194799qko.114.2020.06.30.09.52.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 09:52:44 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id o4so10448744ybp.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:52:43 -0700 (PDT)
X-Received: by 2002:a25:df81:: with SMTP id w123mr33248830ybg.428.1593535962923;
 Tue, 30 Jun 2020 09:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com> <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com> <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
 <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
 <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com>
 <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com> <CALx6S37QCUanU0Cpe+mCedoiceLyxX58O2jdrv+g64YQTUj2sw@mail.gmail.com>
In-Reply-To: <CALx6S37QCUanU0Cpe+mCedoiceLyxX58O2jdrv+g64YQTUj2sw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jun 2020 12:52:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf-mHHPksCvvTU3B+Hr_aEzj1KjfS3ksCbHxXfXQrOd_w@mail.gmail.com>
Message-ID: <CA+FuTSf-mHHPksCvvTU3B+Hr_aEzj1KjfS3ksCbHxXfXQrOd_w@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Tom Herbert <tom@herbertland.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:41 PM Tom Herbert <tom@herbertland.com> wrote:
>
> On Tue, Jun 30, 2020 at 9:16 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 6/30/20 6:57 AM, Willem de Bruijn wrote:
> > > On Mon, Jun 29, 2020 at 10:19 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > >>
> > >> On Mon, Jun 29, 2020 at 8:37 PM Tom Herbert <tom@herbertland.com> wrote:
> > >>>
> > >>> On Mon, Jun 29, 2020 at 4:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >>>>
> > >>>>
> > >>>>
> > >>>> On 6/29/20 2:30 PM, Willem de Bruijn wrote:
> > >>>>> On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >>>>>>
> > >>>>>>
> > >>>>>>
> > >>>>>> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> > >>>>>>> From: Willem de Bruijn <willemb@google.com>
> > >>>>>>>
> > >>>>>>> ICMP messages may include an extension structure after the original
> > >>>>>>> datagram. RFC 4884 standardized this behavior.
> > >>>>>>>
> > >>>>>>> It introduces an explicit original datagram length field in the ICMP
> > >>>>>>> header to delineate the original datagram from the extension struct.
> > >>>>>>>
> > >>>>>>> Return this field when reading an ICMP error from the error queue.
> > >>>>>>
> > >>>>>> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
> > >>>>>> second word of icmp header.
> > >>>>>>
> > >>>>>> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
> > >>>>>>
> > >>>>>> Should we add an element in the union to make this a little bit more explicit/readable ?
> > >>>>>>
> > >>>>>> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> > >>>>>> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
> > >>>>>> --- a/include/uapi/linux/icmp.h
> > >>>>>> +++ b/include/uapi/linux/icmp.h
> > >>>>>> @@ -76,6 +76,7 @@ struct icmphdr {
> > >>>>>>                 __be16  sequence;
> > >>>>>>         } echo;
> > >>>>>>         __be32  gateway;
> > >>>>>> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
> > >>>>>>         struct {
> > >>>>>>                 __be16  __unused;
> > >>>>>>                 __be16  mtu;
> > >>>>>
> > >>>>> Okay. How about a variant of the existing struct frag?
> > >>>>>
> > >>>>> @@ -80,6 +80,11 @@ struct icmphdr {
> > >>>>>                 __be16  __unused;
> > >>>>>                 __be16  mtu;
> > >>>>>         } frag;
> > >>>>> +       struct {
> > >>>>> +               __u8    __unused;
> > >>>>> +               __u8    length;
> > >>>>> +               __be16  mtu;
> > >>>>> +       } rfc_4884;
> > >>>>>         __u8    reserved[4];
> > >>>>>    } un;
> > >>>>>
> > >>>>
> > >>>> Sure, but my point was later in the code :
> > >>>>
> > >>>>>>> +     if (inet_sk(sk)->recverr_rfc4884)
> > >>>>>>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
> > >>>>>>
> > >>>>>> ntohl(icmp_hdr(skb)->un.second_word);
> > >>>>
> > >>>> If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
> > >>>> reading linux kernel code to understand why we do this.
> > >>>>
> > >>> It's also potentially problematic. The other bits are Unused, which
> > >>> isn't the same thing as necessarily being zero. Userspace might assume
> > >>> that info is the length without checking its bounded.
> > >>
> > >> It shouldn't. The icmp type and code are passed in sock_extended_err
> > >> as ee_type and ee_code. So it can demultiplex the meaning of the rest
> > >> of the icmp header.
> > >>
> > >> It just needs access to the other 32-bits, which indeed are context
> > >> sensitive. It makes more sense to me to let userspace demultiplex this
> > >> in one place, rather than demultiplex in the kernel and define a new,
> > >> likely no simpler, data structure to share with userspace.
> > >>
> > >> Specific to RFC 4884, the 8-bit length field coexists with the
> > >> 16-bit mtu field in case of ICMP_FRAG_NEEDED, so we cannot just pass
> > >> the first as ee_info in RFC 4884 mode. sock_extended_err additionally
> > >> has ee_data, but after that we're out of fields, too, so this approach
> > >> is not very future proof to additional ICMP extensions.
> > >>
> > >> On your previous point, it might be useful to define struct rfc_4884
> > >> equivalent outside struct icmphdr, so that an application can easily
> > >> cast to that. RFC 4884 itself does not define any extension objects.
> > >> That is out of scope there, and in my opinion, here. Again, better
> > >> left to userspace. Especially because as it describes, it standardized
> > >> the behavior after observing non-compliant, but existing in the wild,
> > >> proprietary extension variants. Users may have to change how they
> > >> interpret the fields based on what they have deployed.
> > >
> > > As this just shares the raw icmp header data, I should probably
> > > change the name to something less specific to RFC 4884.
> > >
> > > Since it would also help with decoding other extensions, such as
> > > the one you mention in  draft-ietf-6man-icmp-limits-08.
> > >
> > > Unfortunately I cannot simply reserve IP_RECVERR with integer 2.
> > > Perhaps IP_RECVERR_EXINFO.
> > >
> >
> > Perhaps let the icmp header as is, but provides the extra information
> > as an explicit ancillary message in ip_recv_error() ?
> >
> > Really this is all about documentation and providing stable API.
> >
> Actually, I think we may have a subtle bug here.
>
> RFC4884 appends the ICMP extension to the original datagram. The RFC
> describes backwards compatibility in section 5. To be backwards
> compatible with legacy implementations that don't know how to parse
> the extension, and in particular to find the length of the original
> datagram in the data, the requirement is that at the original datagram
> is at least 128 bytes long and it seems to assume no ICMP application
> need to parse beyond that. But parsing beyond 128 bytes is possible,
> consider that the original datagram was UDP/IPv6 with an extension
> header such that the UDP header is offset beyond 128 bytes in the
> packet. If we don't take this into account, the UDP ports for socket
> lookup would be incorrect.
>
> To fix this, we could check the Length field per the types that
> support extensions as described in RFC4884. If it's non-zero then
> assume the extension is present, so before processing the original
> datagram, e.g. performing socket lookup, trim the skb to the length of
> the orignal datagram.

This is somewhat orthogonal to this patch.

You are suggesting proactively protecting applications that do not
know how to parse RFC 4884 compliant packets by truncating
those unless the application sets the new setsockopt?

I'm afraid that might break legacy applications that currently do
expect extension objects. They already can in case of ICMPv6.
And unfortunately they can try in an unsafe manner by parsing
the original datagram for ICMPv4, too.

ICMPv6 differs from ICMP in that it suggests forwarding as much
of the "invoking" packet as possible without exceeding the min
MTU (1280B).

RFC 4884 mentions the minimum 128 B for ICMP but not for
ICMPv6. It specifically keeps the wording about forwarding as
much as possible.
