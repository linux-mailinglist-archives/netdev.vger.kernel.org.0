Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B061EC253
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFBTEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBTEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 15:04:36 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D2C08C5C1
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 12:04:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j32so11541568qte.10
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 12:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ydjZZ/ilQLsmdZFvWneFx8YQw0naaW6pMoRk4YZc32g=;
        b=nT+oxDDS7llQ8jlw8oVLNxwiKx8QkQh0lqFx+X+OJ4rrD9GaMGlCbh5k+zmjxrgoB7
         aZS50ng2VjS0dmHyWGig7J+DtV+HGrey5UvShw2UKWL30q1y5CyqZgXHpBm33PFkqRjn
         hv25zLn7EKwnljJgEHcxIfj1jwaE6rO1J9c8Q1xA/M7QoqQ55v3Huct2Z8Z/LLgRgd28
         3aLG3NTuAGh/k8jACu9eNjWvR0IMPWTzhGfr+ykXZ0FbhHPGaXXqhJoPGQ3hbg0VY6fb
         qhC/KlJX6NFMiVkOlavw4otwGW9QumjgXovMRgujsFufxretv/CaMxaZEJ+7yyq0ja5K
         QkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ydjZZ/ilQLsmdZFvWneFx8YQw0naaW6pMoRk4YZc32g=;
        b=Q4xAOYsGBXjt3hSnxP9UASyFfM4Gmj69TuWacrzFk+N+oKlYup6eKIXywiTcEgTlUV
         mZKGrMIwsWeMj5qJyWe5uRZZKjwTGNz3Z5kO7ICH2A5uP0Vip9Q4uzIHG56sIIpL3vhs
         Zy5dnfgnoM02I9PR1IsR1nDVqx9wJPekIx/8ykK5Kg3N8I0DXwx0dnZHJELOxqUVNYwB
         tWZFF/2MfFqtdn86h+HBUeVQvg1yaOZrV0ur+HxQ1yc/m4zDwHEqc97nE9dy1UU4id4I
         Dl60cP4zPqVaNRfKdyXrtNTVwws8WnFs6N4Nm0V6sunOVdBqVpwHfPqwSi1TGkdSbjUb
         psQQ==
X-Gm-Message-State: AOAM531wy1RuQw6lFqkXf5rzUCLJg4VcgWuIT7uzVE2S8slKbjjcqLTL
        JD+7xVbdm9yyMp7SGHb6mP1DrnXV
X-Google-Smtp-Source: ABdhPJy5NqIiUX7mTL7CE/Z03BlPwAwVYpFkfnsqoESS7WbR4A7q5WWdOiUUht3YwXkAD6JUxaVsGA==
X-Received: by 2002:ac8:6a08:: with SMTP id t8mr28740664qtr.271.1591124674592;
        Tue, 02 Jun 2020 12:04:34 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id b11sm3234893qti.50.2020.06.02.12.04.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 12:04:33 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id k18so3720094ybm.13
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 12:04:32 -0700 (PDT)
X-Received: by 2002:a25:f413:: with SMTP id q19mr45810132ybd.178.1591124672091;
 Tue, 02 Jun 2020 12:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080535.1427-1-victor@inliniac.net> <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
 <b0a9d785-9d5e-9897-b051-6d9a1e8f914e@inliniac.net> <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
 <06479df9-9da4-dbda-5bd1-f6e4d61471d0@inliniac.net>
In-Reply-To: <06479df9-9da4-dbda-5bd1-f6e4d61471d0@inliniac.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jun 2020 15:03:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSci29=W89CLweZcW=RTKwEXpUdPjsLGTB95iSNcnpU_Lw@mail.gmail.com>
Message-ID: <CA+FuTSci29=W89CLweZcW=RTKwEXpUdPjsLGTB95iSNcnpU_Lw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] af-packet: new flag to indicate all csums are good
To:     Victor Julien <victor@inliniac.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Drozdov <al.drozdov@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 2:31 PM Victor Julien <victor@inliniac.net> wrote:
>
> Hi Willem,
>
> On 02-06-2020 19:37, Willem de Bruijn wrote:
> > On Tue, Jun 2, 2020 at 1:03 PM Victor Julien <victor@inliniac.net> wrote:
> >>
> >> On 02-06-2020 16:29, Willem de Bruijn wrote:
> >>> On Tue, Jun 2, 2020 at 4:05 AM Victor Julien <victor@inliniac.net> wrote:
> >>>>
> >>>> Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
> >>>> that the driver has completely validated the checksums in the packet.
> >>>>
> >>>> The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
> >>>> in that the new flag will only be set if all the layers are valid,
> >>>> while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.
> >>>
> >>> transport, not ip checksum.
> >>
> >> Allow me a n00b question: what does transport refer to here? Things like
> >> ethernet? It isn't clear to me from the doc.
> >
> > The TCP/UDP/.. transport protocol checksum.
>
> Hmm that is what I thought originally, but then it didn't seem to work.
> Hence my patch.
>
> However I just redid my testing. I took the example tpacketv3 program
> and added the status flag checks to the 'display()' func:
>
>                 if (ppd->tp_status & TP_STATUS_CSUM_VALID) {
>                         printf("TP_STATUS_CSUM_VALID, ");
>                 }
>                 if (ppd->tp_status & (1<<8)) {
>                         printf("TP_STATUS_CSUM_UNNECESSARY, ");
>
>                 }
>
> Then using scapy sent some packets in 2 variants:
> - default (good csums)
> - deliberately bad csums
> (then also added a few things like ip6 over ip)
>
>
> srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(),
> iface="enp1s0") // good csums
>
> srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(chksum=1),
> iface="enp1s0") //bad tcp

Is this a test between two machines? What is the device driver of the
machine receiving and printing the packet? It would be helpful to know
whether this uses CHECKSUM_COMPLETE or CHECKSUM_UNNECESSARY.

>
> 1.2.3.4 -> 5.6.7.8, TP_STATUS_CSUM_VALID, TP_STATUS_CSUM_UNNECESSARY,
> rxhash: 0x81ad5744
> 1.2.3.4 -> 5.6.7.8, rxhash: 0x81ad5744
>
> So this suggests that what you're saying is correct, that it sets
> TP_STATUS_CSUM_VALID if the TCP/UDP csum (and IPv4 csum) is valid, and
> does not set it when either of them are invalid.

That's not exactly what I said. It looks to me that a device that sets
CHECKSUM_COMPLETE will return TP_STATUS_CSUM_VALID from
__netif_receive_skb_core even if the TCP checksum turns out to be bad.
If a driver would insert such packets into the stack, that is.

> I'll also re-evaluate things in Suricata.
>
>
> One thing I wonder if what this "at least" from the 682f048bd494 commit
> message means:
>
> "Introduce TP_STATUS_CSUM_VALID tp_status flag to tell the
>  af_packet user that at least the transport header checksum
>  has been already validated."
>
> For TCP/UDP there wouldn't be a higher layer with csums, right? And
> based on my testing it seems lower levels (at least IP) is also
> included. Or would that perhaps refer to something like VXLAN or Geneve
> over UDP? That the csums of packets on top of those layers aren't
> (necessarily) considered?

The latter. All these checksums are about transport layer checksums
(the ip header checksum is cheap to compute). Multiple checksums
refers to packets encapsulated in other protocols with checksum, such
as GRE or UDP based like Geneve.

>
> Thanks,
> Victor
>
>
> >> (happy to follow up with a patch to clarify the doc when I understand
> >> things better)
> >>
> >>> But as I understand it drivers set CHECKSUM_COMPLETE if they fill in
> >>> skb->csum over the full length of the packet. This does not
> >>> necessarily imply that any of the checksum fields in the packet are
> >>> valid yet (see also skb->csum_valid). Protocol code later compares
> >>> checksum fields against this using __skb_checksum_validate_complete and friends.
> >>>
> >>> But packet sockets may be called before any of this, however. So I wonder
> >>> how valid the checksum really is right now when setting TP_STATUS_CSUM_VALID.
> >>> I assume it's correct, but don't fully understand where the validation
> >>> has taken place..
> >>
> >> I guess I'm more confused now about what TP_STATUS_CSUM_VALID actually
> >> means. It sounds almost like the opposite of TP_STATUS_CSUMNOTREADY, but
> >> I'm not sure I understand what the value would be.
> >>
> >> It would be great if someone could help clear this up. Everything I
> >> thought I knew/understood so far has been proven wrong, so I'm not too
> >> confident about my patch anymore...
> >
> > Agreed that we should clear this up.
> >
> >>> Similar to commit 682f048bd494 ("af_packet: pass checksum validation
> >>> status to the user"), please update tpacket_rcv and packet_rcv.
> >>
> >> Ah yes, good catch. Will add it there as well.
> >>
> >>> Note also that net-next is currently closed.
> >>
> >> Should I hold off on sending a v3 until it reopens?
> >
> > Yep, thanks. You can always check
> > http://vger.kernel.org/~davem/net-next.html when unsure.
> >
>
>
> --
> ---------------------------------------------
> Victor Julien
> http://www.inliniac.net/
> PGP: http://www.inliniac.net/victorjulien.asc
> ---------------------------------------------
>
