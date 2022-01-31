Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313944A4D28
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350183AbiAaR0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380085AbiAaR0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:26:43 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FC5C06173D
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 09:26:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so13148539pjb.5
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 09:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=js0kgbzvnwyYyJ5dJev27YsHDUdWGhV56nDnyoByLKs=;
        b=SRC7ltxj68uuzZ9qJBuXb7/NXl3k6Vo+lu9GroHZG/EI2uyB7sumXe46wfSx2s4FZv
         YrG1+t0iOodFwLY5Ze4kqHNJYt9KZw9Y4MOxlkarP4eVL7uYdnUxVyNWEg0xVtiDhqxC
         XTOQYk7LdPRbt/V6+K4NSw+uaGKu9j3etE6clmB+lFwD7n21f+1RrTEdTBkDW0g4Gyxw
         TpfZwoxdsrqbg19XXbRGQ3uHmvCWmUmPN99quvZ+63SwCDPr/t/sQepHDEtJ7IUKWt0/
         pXAg0y6deVB2+QnRp3KkzjA8wS98POueBU4ZlWBTmOoBwf6Nf05YGgpWrc3VLGZF+t7f
         B5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=js0kgbzvnwyYyJ5dJev27YsHDUdWGhV56nDnyoByLKs=;
        b=zrqTcAh/HCR/7r78ZV8aRZKCHcx+zrLGFEV3kwDpeRkw9PbsauKLIHCJIyCB4lae5j
         +X9BeNi1mElk8vdU004jvQWmcRcPO29cOqFLqAamvWpQYmxCcgwLT9DBr+OU6iBhZTU9
         O0o8ShiwQ2i2cXwC5o3DDi6Ha9CsAZPDmiYW9yni16uRinyP8vC8tpaMRnfuFBkLugok
         qTr+JbtyDllZsTiH+o0OlZb692IFDgGaYZXnqwx6RgDZiXJewvtUFfSslOwynK46xgOd
         THv2SB2ar4RZct0pFI8TmnDtoBato7D+Q+a5k+fTKBirXn+B39C4W6Xpb/UkiqbY/eI3
         Ou9A==
X-Gm-Message-State: AOAM531sHKAYaTT2hBJ0+EjvDLE9wTSLB1W8cm4OlreQA4N+bzZjMulI
        30vxJq3VYDR7P8sf3K/D9gnUGnhTNrGnkmAk+XQ=
X-Google-Smtp-Source: ABdhPJwoQNxdC855+gRAFnDL7nryaF5dz/iWDN6En5iHghfHn/i54STgEf9uSAJquo3fQNXijjQ6YX74OqxSwnVcP5Y=
X-Received: by 2002:a17:902:ab41:: with SMTP id ij1mr22658172plb.59.1643650002762;
 Mon, 31 Jan 2022 09:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <CAJq09z5sJJO_1ogPi5+PhHkBS9ry5_oYctMhxu68GRNqEr3xLw@mail.gmail.com>
 <CAJq09z4tpxjog2XusyFvvTcr+S6XX24r_QBLW9Sov1L1Tebb5A@mail.gmail.com> <5355fa92-cf8c-4fa5-5157-9b6574f1c876@gmail.com>
In-Reply-To: <5355fa92-cf8c-4fa5-5157-9b6574f1c876@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 31 Jan 2022 14:26:30 -0300
Message-ID: <CAJq09z48A7Y6p=yNocUv17Ji1AfSuP4e6MdT1tNDY0Pfz_Om=A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 1/29/2022 8:42 PM, Luiz Angelo Daros de Luca wrote:
> >>> I suggested it might be checksum problem because I'm also affected. In
> >>> my case, I have an mt7620a SoC connected to the rtl8367s switch. The
> >>> OS offloads checksum to HW but the mt7620a cannot calculate the
> >>> checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
> >>> move the CPU tag to test if the mt7620a will then digest the frame
> >>> correctly.
> >>
> >> I implemented a new DSA tag (rtl8_4t, with "t" as in trailing) that
> >> puts the DSA tag before the Ethernet CRC (the switch supports both).
> >> With no tag in the mac layer, mediatek correctly calculated the ip
> >> checksum. However, mediatek SoC included the extra bytes from the DSA
> >> tag in the TCP checksum, even if they are after the ip length.
> >>
> >> This is the packet leaving the OS:
> >>
> >> 0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
> >> 0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
> >> 0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
> >> 0030   fe 88 83 82 00 00 02 04 05 b4 04 02 08 0a 01 64
> >> 0040   fb 28 66 42 e0 79 01 03 03 03 88 99 04 00 00 20
> >> 0050   00 08
> >>
> >> TCP checksum is at 0x0032 with 0x8382 is the tcp checksum
> >> DSA Tag is at 0x4a with 8899040000200008
> >>
> >> This is what arrived at the other end:
> >>
> >> 0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
> >> 0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
> >> 0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
> >> 0030   fe 88 c3 e8 00 00 02 04 05 b4 04 02 08 0a 01 64
> >> 0040   fb 28 66 42 e0 79 01 03 03 03
> >>
> >> TCP checksum is 0xc3e8, but the correct one should be 0x50aa
> >> If you calculate tcp checksum including 8899040000200008, you'll get exactly
> >> 0xc3e8 (I did the math).
> >>
> >> So, If we use a trailing DSA tag, we can leave the IP checksum offloading on
> >> and just turn off the TCP checksum offload. Is it worth it?
> >
> > No, IP checksum is always done in SW.
> >
> >> Is it still interesting to have the rtl8_4t merged?
> >
> > Maybe it is. It has uncovered a problem. The case of trailing tags
> > seems to be unsolvable even with csum_start. AFAIK, the driver must
> > cksum from "skb->csum_start up to the end". When the switch is using
> > an incompatible tag, we have:
> >
> > slave(): my features copied from master tells me I can offload
> > checksum. Do nothing
> > tagger(): add tag to the end of skb
> > master(): Offloading HW, chksum from csum_start until the end,
> > including the added tag
> > switch(): remove the tag, forward to the network
> > remove_client(): I got a packet with a broken checksum.
>
> This is unfortunately expected here, because you program the hardware
> with the full Ethernet frame length which does include the trailer tag,
> and it then uses that length to calculate the transport header checksum
> over the enter payload, thinking the trailer tag is the UDP/TCP payload.
>
> The checksum is calculated "on the fly" as part of the DMA operation to
> send the packet on the wire, so you cannot decouple the checksum
> calculation from the DMA operation, other than by not asking the HW *not
> to* checksum the packet, and instead having software provide that.
>
> Now looking at the datasheet you quoted, there is this:
>
> 241. FE_GLO_CFG: Frame Engine Global Configuration (offset: 0x0000)
>
> 7:4 RW L2_SPACE L2 Space
> (unit: 8 bytes)
> 0xB
>
> Can you play with this and see if you can account for the extra 4 bytes
> added by the Realtek tag?
>

I played with it, both with the L2_SPACE and RATE_MINUS:

FE_GLO_CFG_REG=0x10100000 FE_GLO_CFG_SIZE=32
FE_GLO_CFG=$(($(devmem $FE_GLO_CFG_REG $FE_GLO_CFG_SIZE)));
for l2space_sig in b0 b1 c0 c1 d0 d1 e0 e1 a0 a1 90 91 80 81 70 71 60
61 50 51 40 41 30 31 20 21 10 11 01 00 e0 e1; do
    FE_GLO_CFG=$(($(devmem $FE_GLO_CFG_REG $FE_GLO_CFG_SIZE)));
    printf 'Before FE_GLO_CFG = 0x%X\n' $FE_GLO_CFG;
    devmem $FE_GLO_CFG_REG $FE_GLO_CFG_SIZE $((FE_GLO_CFG & ~0x00000ff
| (0x$l2space_sig)));
    FE_GLO_CFG=$(($(devmem $FE_GLO_CFG_REG $FE_GLO_CFG_SIZE)));
    printf 'After  FE_GLO_CFG = 0x%X\n' $FE_GLO_CFG;
    echo "Please test L2_SPACE_sig==$l2space_sig"; read;
done; devmem $FE_GLO_CFG_REG $FE_GLO_CFG_SIZE $FE_GLO_CFG_ORIG

It only made a difference for values 0x0 and 0xf but it looks more
like an overflow. And only on the traffic I receive, not send. The
remote endpoint
always receive 0x8382 as the tcp checksum, which is the "fake ip header" sum.

The default value is 0xb (11) and docs says it is a 8-byte unit. What
is 11 * 8 bytes? 88 bytes? Maybe it is wrong in docs.
That same register also has EXT_VLAN, which points to 0x8100 (802.1Q ethertype).

In the same doc, there is also a mention about the L2 space usage,
only related to received traffic:

"1. RX_CTRL pass through VLAN tags on L2 space (at most 2 tags)" (page 245-247)

Anyway, even if the Mediatek switch could remove the Realtek tag, it
should not do that. The Realtek switch still needs it.

> > ndo_features_check() will not help because, either in HW or SW, it is
> > expected to calculate the checksum up to the end. However, there is no
> > csum_end or csum_len. I don't know if HW offloading will support some
> > kind of csum_end but it would not be a problem in SW (considering
> > skb_checksum_help() is adapted to something like skb_checksum_trimmed
> > without the clone).
> >
> > That amount of bytes to ignore at the end is a complex question: the
> > driver either needs some hint (like it happens with skb->csum_offset)
> > to know where transport payload ends or the taggers (or the dsa) must
> > save the amount of extra bytes (or which tags were added) in the
> > sbk_buff. With that info, the driver can check if HW will work with a
> > different csum_start / csum_end or if only a supported tag is in use.

I must be missing something. Is SW TCP checksum really broken when a
tailing tag is in use? If so, it will only work if TCP checksum
offload is enabled in a compatible HW. Anything else like different
vendors, software checksum or stacked tags will be broken.

> > In my case, using an incompatible tailing tag, I just made it work
> > hacking dsa and forcing slave interfaces to disable offloading. This
> > way, checksum is calculated before any tag is added and offloading is
> > skipped. But it is not a real solution.
>
> Not sure which one is not a "real solution", but for this specific
> combination of DSA conduit driver and switch tag, you have to disable
> checksum offload in the conduit driver and provide it in software. The
> other way would be to configure the realtek switch to work with
> DSA_TAG_8021Q and see if you can continue to offload the data path since
> tagging would use regular 802.1Q vlans, but that means you are going to
> lose a whole lot of management functionality offered by the native
> Realtek tag.

Definitely not a real solution. It was just a hack to check if
checksumming at slave device will overcome the issue. As I said,
simply disabling checksum and doing it in SW "as usual" is not enough
because SW checksum also sums to the end. We need to parse each
possible transport layer to find its end or taggers must hint how many
bytes to ignore, something like a new skb->cksum_stop_before_end.
Another solution would be to hint the slave interface if it needs to
checksum right there (modifying slave->vlan_features). None of that
exists today. Is it the right way?

--

Luiz
