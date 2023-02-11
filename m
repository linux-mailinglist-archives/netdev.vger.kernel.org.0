Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472F2693345
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 20:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBKTQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 14:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBKTQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 14:16:09 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336A5FB
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 11:16:07 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id z37so104961ljq.8
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 11:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yYDn3qHBMUFV7GcWIkHQjKvyTiHlDHUQsi8SWbSplw4=;
        b=eZc6JMtrgSwPhr4G5S8e9TjM9aBNBCdr57ufL0lXWzjPvGJRaYuKVeA+wrRLM0l3sD
         96nI7hpMYiEt/gfKzV9P1L8suRxTXUY0Qb4Ijf/r+N7oH1ZK2sKT5gJFrc9g04MQ7UMM
         GxYuS7hMHq3nuf8CVW8JJwC+BdIXxEqUHn0i5wyJuOsQTJOuk8Xcw810LJ/nd3utb4ao
         lXpRLsTw0HHp/88sdfG1ax2a6Y+pZE8G31p3T5wjdeFzkMjGJGJ7GkHSkJ79SlBhqOJj
         XpsyTvOguV0yXB/R9sdRvDzezQKzbvhiI8HhsxpFhunja1xCAtcDm0kqwEEVHdpuS2bl
         Q5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yYDn3qHBMUFV7GcWIkHQjKvyTiHlDHUQsi8SWbSplw4=;
        b=Tib3HzbMtgxDzsCvjb8zHnmsSx4AbTzj9J35Hd8izBIZ0yjwNBCL2Jy9NRQo2QJrk8
         LLYiUi/5qwxcFutOLCbaxwF7pY3AsUXLZSU4vWSrceXs4KiUM/UgAEkHi4KPV/qV1132
         MevjhwJn4p5zixeOTRhXbNcCM0hmRwCKLVVs6wssdie+JMz7TJCtL8yyaVEzXCBxCp7G
         96eqE07hxauE8y9fe46cc/CHVpQzjJHtUl4VnD+ObllGjuWbHYlT6TcAe6Ua2EAkb1Kd
         WGNxD4jNszAAZP9gt2JzUfANqb2tcJvKA54UXcy4ZL9KMhUixy0eTI1MCCjYYBb9twW3
         68QA==
X-Gm-Message-State: AO0yUKVvmGE59VdFjd7BQS1ikI9gk4NYbzpkQ/qRdnE4dfXfj6hB1uBF
        uRLchr3QKNWP5Ak1gdB4v0eZt4MVBoKI/7wC810=
X-Google-Smtp-Source: AK7set9cy0J90kgH7vnWOFK9EfVc6BNElUsaUHZGvY5LxCjsrbsTY+/YzW54u/pvLxzgHzpgPdWEc+nEz2MR/glZ7bk=
X-Received: by 2002:a2e:9c92:0:b0:293:32a9:2273 with SMTP id
 x18-20020a2e9c92000000b0029332a92273mr1692835lji.202.1676142965220; Sat, 11
 Feb 2023 11:16:05 -0800 (PST)
MIME-Version: 1.0
References: <20230207171557.13034-1-luizluca@gmail.com> <20230209185147.lsyrxzjlz65mohy3@bang-olufsen.dk>
In-Reply-To: <20230209185147.lsyrxzjlz65mohy3@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 11 Feb 2023 16:15:52 -0300
Message-ID: <CAJq09z6TBOYZzrd-MraUTZPweA0Lcq=fzLczDEqzPz5rzATtuA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: realtek: rtl8365mb: add change_mtu
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Feb 07, 2023 at 02:15:58PM -0300, Luiz Angelo Daros de Luca wrote:
> > rtl8365mb was using a fixed MTU size of 1536, probably inspired by
> > rtl8366rb initial packet size. Different from that family, rtl8365mb
> > family can specify the max packet size in bytes and not in fixed steps.
> > Now it defaults to VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN (1522 bytes).
> >
> > DSA calls change_mtu for the CPU port once the max mtu value among the
> > ports changes. As the max packet size is defined globally, the switch
> > is configured only when the call affects the CPU port.
> >
> > The available specs do not directly define the max supported packet
> > size, but it mentions a 16k limit. However, the switch sets the max
> > packet size to 16368 bytes (0x3FF0) after it resets. That value was
> > assumed as the maximum supported packet size.
> >
> > MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
> > (where rtl8367s is stacked) can go.
>
> Thinking about it, I'm sure why you would test this with 802.1Q
> specifically. Maybe you can elaborate on how you tested this?
>
> >
> > There is a jumbo register, enabled by default at 6k packet size.
> > However, the jumbo settings does not seem to limit nor expand the
> > maximum tested MTU (2018), even when jumbo is disabled. More tests are
> > needed with a device that can handle larger frames.
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >
> > v1->v2:
> > - dropped jumbo code as it was not changing the behavior (up to 2k MTU)
> > - fixed typos
> > - fixed code alignment
> > - renamed rtl8365mb_(change|max)_mtu to rtl8365mb_port_(change|max)_mtu
> >
> >  drivers/net/dsa/realtek/rtl8365mb.c | 43 ++++++++++++++++++++++++++---
> >  1 file changed, 39 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> > index da31d8b839ac..c3e0a5b55738 100644
> > --- a/drivers/net/dsa/realtek/rtl8365mb.c
> > +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> > @@ -98,6 +98,7 @@
> >  #include <linux/of_irq.h>
> >  #include <linux/regmap.h>
> >  #include <linux/if_bridge.h>
> > +#include <linux/if_vlan.h>
> >
> >  #include "realtek.h"
> >
> > @@ -267,6 +268,8 @@
> >  /* Maximum packet length register */
> >  #define RTL8365MB_CFG0_MAX_LEN_REG   0x088C
> >  #define   RTL8365MB_CFG0_MAX_LEN_MASK        0x3FFF
> > +/* Not sure but it is the default value after reset */
> > +#define RTL8365MB_CFG0_MAX_LEN_MAX   0x3FF0
>
> Again, the max is 0x3FFF per the automatically generated register map
> from the vendor driver. Unless you have evidence to the contrary. Please
> fix this.

I wonder why the switch resets to 0x3FF0 and not 0x3FFF. 0x3FF0 is the
safest value as it is what the vendor is already using. But I cannot
guarantee that those extra 16 bytes will not break something. This
switch might behave funny when non-conformant things are touched, like
reading the status of non-existing ports breaks following read ops.
But as you are the maintainter and have contact with Realtek, I'll do
as you asked.

> >
> >  /* Port learning limit registers */
> >  #define RTL8365MB_LUT_PORT_LEARN_LIMIT_BASE          0x0A20
> > @@ -1135,6 +1138,36 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
> >       }
> >  }
> >
> > +static int rtl8365mb_port_change_mtu(struct dsa_switch *ds, int port,
> > +                                  int new_mtu)
> > +{
> > +     struct realtek_priv *priv = ds->priv;
> > +     int frame_size;
> > +
> > +     /* When a new MTU is set, DSA always sets the CPU port's MTU to the
> > +      * largest MTU of the slave ports. Because the switch only has a global
> > +      * RX length register, only allowing CPU port here is enough.
> > +      */
> > +
>
> Spurious newline.

I'll drop it.

>
> > +     if (!dsa_is_cpu_port(ds, port))
> > +             return 0;
> > +
> > +     frame_size = new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
>
> I'm still not convinced that this is correct. dsa_master_setup() sets
> the master MTU to ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops) by
> default. So even if you wanted to make space for 802.1Q-tagged packets
> whose payload was 1500 bytes, they wouldn't make it past the master, as
> they are 4 octets too big for its MTU. Or what am I missing?

Yes, when device port_change_mtu() increases the MTU of one of its
user ports, the DSA will also call a port_change_mtu() to the switch
CPU port when the port_change_mtu() changed the maximum MTU in use by
the switch. That change is also propagated to the linux network device
connected to the switch CPU port (or a parent DSA switch port).
However, the port_change_mtu(..,cpu_port) and the
"eth0".ndo_change_mtu?() touch different sides of the same cable. They
must agree but they are independent.

While MTU does not account for L2 headers, port_change_mtu() must add
those extra bytes as the switch deals with frame size, not MTU. How
the network device (normally "eth0") will deal with extra L2 headers
is up to that driver as it can even be from a different vendor. Some
poor devices, like usb ethernet, cannot handle 802.1Q and they will
drop tagged 1500-MTU frames. From the switch side, as we cannot tell
if it will be any 802.1Q-tagged frames, we just need to add those
extra 4 bytes to make it work on both cases. The side-effect is that a
non-tagged user port will be able to forward a 1504-MTU frame. Maybe
there are other L2 extra frames that require more room without
reducing the MTU, like QinQ, but that seems to be how other DSA
drivers are handling this situation.

Another approach to this problem would be to keep the default 16k
filter and let the large frames be forwarded between user ports and
also hit the network device. But I don't know if that will break other
assumptions.

> On the other hand, since we are talking total frame size here, shouldn't
> you should also compensate for the CPU tag (8 bytes)? Did you check
> this? For example, maybe the switch applies the frame size check after
> popping the CPU tag and that's why you don't add it?

I checked it byte by byte. As I enabled writable regmap debugs, I could
quickly change the register and test right away. I was using
rtl8366rb.c as a reference and I was expecting to get this:

* The first setting, 1522 bytes, is max IP packet 1500 bytes,
* plus ethernet header, 1518 bytes, plus CPU tag, 4 bytes.

The "18 bytes" already considers the 802.1Q. So, in my case, as the
CPU tag has 8 bytes and not 4, I would expect vlan frames to require
1518 + 8 = 1526. However, the same 1522 worked (and 1518 for non-vlan
frames).
My educated guess was that the extra 4 bytes were not the CPU tag but
the Frame Check Sequence (4-bytes). And, indeed, other drivers do have
the same math:

drivers/net/dsa/mv88e6xxx/port.c:1330
size += VLAN_ETH_HLEN + ETH_FCS_LEN;

> I think the comment in dsa.h is helpful:
>
>         /*
>          * MTU change functionality. Switches can also adjust their MRU through
>          * this method. By MTU, one understands the SDU (L2 payload) length.
>          * If the switch needs to account for the DSA tag on the CPU port, this
>          * method needs to do so privately.
>          */
>         int     (*port_change_mtu)(struct dsa_switch *ds, int port,
>                                    int new_mtu);
>         int     (*port_max_mtu)(struct dsa_switch *ds, int port);
>
>
> My bid would be:
>
>         frame_size = new_mtu + 8 + ETH_HLEN + ETH_FCS_LEN;
>
> where the 8 is for the CPU tag.

Sorry, but that is not what I empirically verified.

>
> > +
> > +     dev_dbg(priv->dev, "changing mtu to %d (frame size: %d)\n",
> > +             new_mtu, frame_size);
> > +
> > +     return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> > +                               RTL8365MB_CFG0_MAX_LEN_MASK,
> > +                               FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK,
> > +                                          frame_size));
> > +}
> > +
> > +static int rtl8365mb_port_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +     return RTL8365MB_CFG0_MAX_LEN_MAX - VLAN_ETH_HLEN - ETH_FCS_LEN;
> > +}
> > +
> >  static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
> >                                        u8 state)
> >  {
> > @@ -1980,10 +2013,8 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
> >               p->index = i;
> >       }
> >
> > -     /* Set maximum packet length to 1536 bytes */
> > -     ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> > -                              RTL8365MB_CFG0_MAX_LEN_MASK,
> > -                              FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
> > +     /* Set packet length from 16368 to 1500+14+4+4=1522 */
>
> This comment is not very helpful IMO...

How about:

/* Set frame len from 16368 to 1522 (VLAN_ETH_HLEN+1500+ETH_FCS_LEN) */

Or should I simply drop it?

>
> > +     ret = rtl8365mb_port_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);
> >       if (ret)
> >               goto out_teardown_irq;
> >
> > @@ -2103,6 +2134,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
> >       .get_eth_mac_stats = rtl8365mb_get_mac_stats,
> >       .get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
> >       .get_stats64 = rtl8365mb_get_stats64,
> > +     .port_change_mtu = rtl8365mb_port_change_mtu,
> > +     .port_max_mtu = rtl8365mb_port_max_mtu,
> >  };
> >
> >  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
> > @@ -2124,6 +2157,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
> >       .get_eth_mac_stats = rtl8365mb_get_mac_stats,
> >       .get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
> >       .get_stats64 = rtl8365mb_get_stats64,
> > +     .port_change_mtu = rtl8365mb_port_change_mtu,
> > +     .port_max_mtu = rtl8365mb_port_max_mtu,
> >  };
> >
> >  static const struct realtek_ops rtl8365mb_ops = {
> > --
> > 2.39.1
> >
