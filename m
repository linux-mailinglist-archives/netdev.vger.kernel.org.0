Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187FE4BB170
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiBRF3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:29:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiBRF3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:29:34 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960DAB5601
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:29:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d17so1526209pfl.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QxdKSkQeQfaslFifzHrR/4awnpHMN67f/MujkWPtrbU=;
        b=OmDpyU0UdRNr/T03q9wV7iwYi2L3n5bkNlaGF1578RBN2XW4pTrPrlwVVeynPyPm+1
         WikclSTZBXct8HzK3kLegtls5T2MY8YAeaWTDZmqoOR9s7D5jPkDisq04kS5DFJCKgdQ
         xRWI10ApbmRwZk5APX8GI9fRlvksKHVgWNR2fHUU0tDUNkHu/7JICtq4EBSZD5IpA81K
         wdJVYdT4js3WbRRrt45cclRGI974MBR4E8pysGsRPz945HkNifddZV0inO/zpC9tLg35
         wuhlXExMYMYvGNTzEcFPEF9XpYnBzajAsguNWeIO6TWqbL8gP2FyYkqiQkpBK1209lJx
         SjLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QxdKSkQeQfaslFifzHrR/4awnpHMN67f/MujkWPtrbU=;
        b=TPL/VAQsTxnbfdos1F+GP+C6xUZ9At4BNJSLLMJVm+nvljE4nPrDRYdf/s82AHn22a
         mhFkz6Pp/eWeQw2k1sxdzANc10bcdO6STgnIlgTCbmZSSTCEatReuof3VlCr1waNd2Ce
         wsVW44OunH9vs/WwhsQ4bujqkIvJK4OKgzwnkFbpYHhH5TeE6haRH/fUG8NtVgVKSMAE
         JuUMCJRohGp71jvMXtb8ZwludlokXx2odyWKAwUGuZEBIqkyLoYUZvje78Kdpta6uaqL
         CsTq+NpNcXvPm20gYsu+j1a3s9LJBH+mqBuWBfHzXUHnoxvmzRwEUWiuGiWnAX6pmUCf
         Zxaw==
X-Gm-Message-State: AOAM533FFCRG4oEHUiDkIAD1IccMz3LA5x/CpuMZ7YXrdChBeJwnL0/r
        8ml6z1CmGZ+XIn2GP9k1a+dHTWfpjzu39AGNpHBfIdctIbEkyA==
X-Google-Smtp-Source: ABdhPJz5sJlWz9F5JYYJQ7YXOeG2glVDBBNmSzD8Rf/4fNspPOSbjNiuO/XVGhj5SVNMqM8WewClOL+g9zdAX2nVCWc=
X-Received: by 2002:a63:334d:0:b0:340:75a1:be06 with SMTP id
 z74-20020a63334d000000b0034075a1be06mr5125724pgz.118.1645162158048; Thu, 17
 Feb 2022 21:29:18 -0800 (PST)
MIME-Version: 1.0
References: <20220209211312.7242-1-luizluca@gmail.com> <20220209211312.7242-2-luizluca@gmail.com>
 <20220209215158.qdjg7ko4epylwuv7@skbuf>
In-Reply-To: <20220209215158.qdjg7ko4epylwuv7@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 18 Feb 2022 02:29:06 -0300
Message-ID: <CAJq09z5KEFUjpKuyPu0AL6pDessi8+1cjV454AgGoMyCYVw+ng@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_rtl8_4: add rtl8_4t tailing variant
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Re: title. Tail or trailing?

I guess I'll stick with trailing. It looks like the most used term.

>
> On Wed, Feb 09, 2022 at 06:13:11PM -0300, Luiz Angelo Daros de Luca wrote:
> > +static inline void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev,
> > +                                 char *tag)
> >  {
> >       struct dsa_port *dp = dsa_slave_to_port(dev);
> > -     __be16 *tag;
> > -
> > -     skb_push(skb, RTL8_4_TAG_LEN);
> > -
> > -     dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> > -     tag = dsa_etype_header_pos_tx(skb);
> > +     __be16 *tag16 = (__be16 *)tag;
>
> Can the tail tag be aligned to an odd offset? In that case, should you
> access byte by byte, maybe? I'm not sure how arches handle this.

I see. I'm not sure my big endian MIPS device is able to test it
properly. I tried a wide range of payload sizes without any issue. But
I believe we need to play safe here.

Andrew Lunn, you suggested using get_unaligned_be16(). However, as
using get_unaligned_be16() I will already save the tag (or at least
part of it) in the stack, could it be a memcpy from stack to the
buffer (and the opposite while reading the tag)? It will be less
intervention than rewriting the code to deal with each byte at a time.
I'm not sure if I need to or can help the compiler optimize it. In my
MIPS, it seems it did a good job, replacing the memcpy with four
swl/swr instructions (used to write unaligned 32-bit values).

> >
> >       /* Set Realtek EtherType */
> > -     tag[0] = htons(ETH_P_REALTEK);
> > +     tag16[0] = htons(ETH_P_REALTEK);
> >
> >       /* Set Protocol; zero REASON */
> > -     tag[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
> > +     tag16[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
> >
> >       /* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
> > -     tag[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> > +     tag16[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> >
> >       /* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
> > -     tag[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> > +     tag16[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> > +}
> > +
> > +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> > +                                    struct net_device *dev)
> > +{
> > +     skb_push(skb, RTL8_4_TAG_LEN);
> > +
> > +     dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> > +
> > +     rtl8_4_write_tag(skb, dev, dsa_etype_header_pos_tx(skb));
> >
> >       return skb;
> >  }
> >
> > -static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> > -                                   struct net_device *dev)
> > +static struct sk_buff *rtl8_4t_tag_xmit(struct sk_buff *skb,
> > +                                     struct net_device *dev)
> > +{
>
> Why don't you want to add:
>
>         if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
>                 return NULL;
>
> and then you'll make this tagging protocol useful in production too.

It works like a charm! Thanks! And now I have a pretty good use for
this new tag: force checksum in software. Whenever the cpu ethernet
driver cannot correctly deal with the checksum offloading, switch to
rtl8_4t and be happy. It will work either adding 'dsa-tag-protocol =
"rtl8_4t";' to the CPU port in the device-tree file or even changing
the tag at runtime.

Now checksum will only break if you stack two trailing tags and the
first one added does not calculate the checksum and the second one is
"rtl8_4t". When "rtl8_4t" does calculate the checksum, it will include
the other tag in the sum. But it might even be considered a bug in the
first tagger.

Regards,

Luiz
