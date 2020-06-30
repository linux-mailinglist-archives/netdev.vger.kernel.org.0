Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B84720F671
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgF3N5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731327AbgF3N5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:57:38 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C276C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:57:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a8so15111556edy.1
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7AUJ86Dv5H0LjEHbc2oQNE/3QwNEb+p/2GO8ru7Wx18=;
        b=Ffh6zb2MpBn/US69pMpQYauwvLQw7IrM/tHCZauzu7+ZR9XqxJ8koMCDLDJv04Gru2
         dYRZv7tX9CXNtZlRGhJyzLV+HNPZHVqS6efLq3zjRE3FLaFGc4Sx4pNqqfbxOE30++wx
         Eeb6s2vPcMlcS8GL5EWOEbYqGnnammxbrP4ucpc2iIaGpOPh3OUpuD4MEbjNOLOBVSv1
         LZ5P8RxAB+Hym8X9su4VeoVXQmtIQ9Oy6LjBcM78t1IIS9dkEROm5G9LRmYxbE+Nvl+T
         ibcJIIyd3c3LIpn/HtqyP54KjzUxTiooWWRB7pHs4K3XUAODF31xnTchnFuzZx24f3s8
         iQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7AUJ86Dv5H0LjEHbc2oQNE/3QwNEb+p/2GO8ru7Wx18=;
        b=A81L7GTcw22XYK+wXQalFb/4tjPe1zluYh8Zk/iYElbB08qlDV5AGJ1zXMaHZHYM8a
         MbcVrbsq95Goqq2FimA3BS9Zyv0B4+cmTEndUd1oU8EdvSRCxyViEbMcuMyloExkdmAZ
         SQTo7An/4GOlFm1oT1TvzbJc6pwZcD8pGC6N9Wr4ch/sBxaTDyoXRbYqIa/ilAao7Pdt
         Cxz2mlzZbjMvGUbajdRErbuUK2tYQJLAgQwQEsmrlaPg6n2oZN+upbjRhEg/aIZ3J/Gp
         u7kAzyLMNdCxqxckhmhTuY4jsPidz+WoVLvfEs/5YGjYzrMiJVLiXv4JC5uSZkNcJj36
         3Sdw==
X-Gm-Message-State: AOAM532FNjPPNZmumLVcF81JIJqcivWCgpowgToIZaYn5+sWfBGPbdQV
        AZctXDW4+ghJjgkprLbv8BM6pERaZ7Dh8ioHxdh0+x7u
X-Google-Smtp-Source: ABdhPJzVp9+lEtly+KCAfIL36Q2ZTMGWaRFbZECvIy8UsR1j6n1mOT/UvLwXNp+U4pgL3gicFhBOQNM7QWvwiM/dVV0=
X-Received: by 2002:a05:6402:21c2:: with SMTP id bi2mr22899668edb.296.1593525456889;
 Tue, 30 Jun 2020 06:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com> <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com> <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
 <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
In-Reply-To: <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jun 2020 09:57:00 -0400
Message-ID: <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Tom Herbert <tom@herbertland.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 10:19 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Jun 29, 2020 at 8:37 PM Tom Herbert <tom@herbertland.com> wrote:
> >
> > On Mon, Jun 29, 2020 at 4:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >
> > >
> > >
> > > On 6/29/20 2:30 PM, Willem de Bruijn wrote:
> > > > On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >>
> > > >>
> > > >>
> > > >> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> > > >>> From: Willem de Bruijn <willemb@google.com>
> > > >>>
> > > >>> ICMP messages may include an extension structure after the original
> > > >>> datagram. RFC 4884 standardized this behavior.
> > > >>>
> > > >>> It introduces an explicit original datagram length field in the ICMP
> > > >>> header to delineate the original datagram from the extension struct.
> > > >>>
> > > >>> Return this field when reading an ICMP error from the error queue.
> > > >>
> > > >> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
> > > >> second word of icmp header.
> > > >>
> > > >> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
> > > >>
> > > >> Should we add an element in the union to make this a little bit more explicit/readable ?
> > > >>
> > > >> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> > > >> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
> > > >> --- a/include/uapi/linux/icmp.h
> > > >> +++ b/include/uapi/linux/icmp.h
> > > >> @@ -76,6 +76,7 @@ struct icmphdr {
> > > >>                 __be16  sequence;
> > > >>         } echo;
> > > >>         __be32  gateway;
> > > >> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
> > > >>         struct {
> > > >>                 __be16  __unused;
> > > >>                 __be16  mtu;
> > > >
> > > > Okay. How about a variant of the existing struct frag?
> > > >
> > > > @@ -80,6 +80,11 @@ struct icmphdr {
> > > >                 __be16  __unused;
> > > >                 __be16  mtu;
> > > >         } frag;
> > > > +       struct {
> > > > +               __u8    __unused;
> > > > +               __u8    length;
> > > > +               __be16  mtu;
> > > > +       } rfc_4884;
> > > >         __u8    reserved[4];
> > > >    } un;
> > > >
> > >
> > > Sure, but my point was later in the code :
> > >
> > > >>> +     if (inet_sk(sk)->recverr_rfc4884)
> > > >>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
> > > >>
> > > >> ntohl(icmp_hdr(skb)->un.second_word);
> > >
> > > If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
> > > reading linux kernel code to understand why we do this.
> > >
> > It's also potentially problematic. The other bits are Unused, which
> > isn't the same thing as necessarily being zero. Userspace might assume
> > that info is the length without checking its bounded.
>
> It shouldn't. The icmp type and code are passed in sock_extended_err
> as ee_type and ee_code. So it can demultiplex the meaning of the rest
> of the icmp header.
>
> It just needs access to the other 32-bits, which indeed are context
> sensitive. It makes more sense to me to let userspace demultiplex this
> in one place, rather than demultiplex in the kernel and define a new,
> likely no simpler, data structure to share with userspace.
>
> Specific to RFC 4884, the 8-bit length field coexists with the
> 16-bit mtu field in case of ICMP_FRAG_NEEDED, so we cannot just pass
> the first as ee_info in RFC 4884 mode. sock_extended_err additionally
> has ee_data, but after that we're out of fields, too, so this approach
> is not very future proof to additional ICMP extensions.
>
> On your previous point, it might be useful to define struct rfc_4884
> equivalent outside struct icmphdr, so that an application can easily
> cast to that. RFC 4884 itself does not define any extension objects.
> That is out of scope there, and in my opinion, here. Again, better
> left to userspace. Especially because as it describes, it standardized
> the behavior after observing non-compliant, but existing in the wild,
> proprietary extension variants. Users may have to change how they
> interpret the fields based on what they have deployed.

As this just shares the raw icmp header data, I should probably
change the name to something less specific to RFC 4884.

Since it would also help with decoding other extensions, such as
the one you mention in  draft-ietf-6man-icmp-limits-08.

Unfortunately I cannot simply reserve IP_RECVERR with integer 2.
Perhaps IP_RECVERR_EXINFO.
