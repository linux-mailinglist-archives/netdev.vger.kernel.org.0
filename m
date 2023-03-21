Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1046C2F28
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCUKgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCUKgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:36:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D632658C;
        Tue, 21 Mar 2023 03:36:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c4so8685632pfl.0;
        Tue, 21 Mar 2023 03:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679394968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=19wMmvfNWQyO4plWiUVaSYLzZEvvz2rrcCtkkcHymrA=;
        b=XA2Or4IIUOT0w8WumqdaJjkHZ8CnX5ppAwonPbP4+Lky47xrJthUuf9oZjNW5Q5BYk
         1QcvQJGo27FQnytWA//NmhvgEIGFYFtLPjD92qSWJpZeZK/QtH6P9NE3DekkkRGWSIjD
         8UExGk4+RwfIgGSdhEcP8Qa27AI8qZJaq8JrkuHZGMkOJJNnzrve9X8OEHozsqtc5hep
         T0P5U/CU5MG6pPLM9aQ6Y/ZzyV1MTMNhE5h7cFaGnzqqjW1dsKRfjHh4E4qnuQNj3jQv
         unSGzxE2Bmdw2b6XR7x2VK6IDiEMwOtVD1pa7aNkaXPm+BGZjrwH5RXRFwsU7gt++8wP
         ejnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679394968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19wMmvfNWQyO4plWiUVaSYLzZEvvz2rrcCtkkcHymrA=;
        b=0UI68w/PdOqAjFIqaJfssqWc6rTwSmIqUD2gf+ZOISK2jWCKH4QfKzzjRzXk2QyP73
         ucCI0p1ljPU8lUsZkRrZ0Ux3jhCraNUUHZRJXopH7ljCWhT7mnlby+aRxxk0aWnIBPA1
         m23V+HIt/aMKIkelmNci8b/IWfdHmS2x5wTQhvf8ug7Ac3M3MfoUCV3LTXnxKDOjZXGh
         A4OKcg1741WFvfHsIaWFkwohMo7DRuAn9llxgeaoFvGzEu9hcInqU/dpXwKIsfpYMF53
         tR7JrSg1QYU5gcno0eLqntsjeKOBiIW4CYhA1uRCO/HaK9OFmDyvbIKp/2L11XdX/VCi
         H4XQ==
X-Gm-Message-State: AO0yUKV/9BQFs1779twB5oGVne1wUqVZeC1xgB1rdj0cBg+7liyAFgq+
        RsB3GPwbdR9SGgTRTvo9w0oxzoqV5pEyoXDsKwE=
X-Google-Smtp-Source: AK7set9Ai3aUCQzsCnSs67dxCqfbDdyWFvnULvCzjfwd10kfeVpg4uoBXfmJUhY664JgGow0KWFsS/aeRCpc953/MNs=
X-Received: by 2002:a63:a442:0:b0:503:77cd:b7b4 with SMTP id
 c2-20020a63a442000000b0050377cdb7b4mr472055pgp.12.1679394967834; Tue, 21 Mar
 2023 03:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230320182813.963508-1-noltari@gmail.com>
In-Reply-To: <20230320182813.963508-1-noltari@gmail.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Tue, 21 Mar 2023 11:35:56 +0100
Message-ID: <CAOiHx=nKVWfa1-_VAf3bz+6PPz0uWMHyEtoVVOysFf0srZorBA@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: net: dsa: b53: mmap: add phy ops
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 at 19:28, =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gma=
il.com> wrote:
>
> Currently, B53 MMAP BCM63xx devices with an external switch hang when
> performing PHY read and write operations due to invalid registers access.
> This adds support for PHY ops by using the internal bus from mdio-mux-bcm=
6368
> when probed by device tree and also falls back to direct MDIO registers i=
f not.
>
> This is an alternative to:
> - https://patchwork.kernel.org/project/netdevbpf/cover/20230317113427.302=
162-1-noltari@gmail.com/
> - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302=
162-2-noltari@gmail.com/
> - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302=
162-3-noltari@gmail.com/
> - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302=
162-4-noltari@gmail.com/
> As discussed, it was an ABI break and not the correct way of fixing the i=
ssue.
>
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c    | 86 +++++++++++++++++++++++++++++++
>  include/linux/platform_data/b53.h |  1 +
>  2 files changed, 87 insertions(+)
>
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mma=
p.c
> index 706df04b6cee..7deca1c557c5 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -19,14 +19,25 @@
>  #include <linux/bits.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_mdio.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/b53.h>
>
>  #include "b53_priv.h"
>
> +#define REG_MDIOC              0xb0
> +#define  REG_MDIOC_EXT_MASK    BIT(16)
> +#define  REG_MDIOC_REG_SHIFT   20
> +#define  REG_MDIOC_PHYID_SHIFT 25
> +#define  REG_MDIOC_RD_MASK     BIT(30)
> +#define  REG_MDIOC_WR_MASK     BIT(31)
> +
> +#define REG_MDIOD              0xb4
> +
>  struct b53_mmap_priv {
>         void __iomem *regs;
> +       struct mii_bus *bus;
>  };
>
>  static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8 *v=
al)
> @@ -216,6 +227,69 @@ static int b53_mmap_write64(struct b53_device *dev, =
u8 page, u8 reg,
>         return 0;
>  }
>
> +static inline void b53_mmap_mdio_read(struct b53_device *dev, int phy_id=
,
> +                                     int loc, u16 *val)
> +{
> +       uint32_t reg;
> +
> +       b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> +
> +       reg =3D REG_MDIOC_RD_MASK |
> +             (phy_id << REG_MDIOC_PHYID_SHIFT) |
> +             (loc << REG_MDIOC_REG_SHIFT);
> +
> +       b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> +       udelay(50);
> +       b53_mmap_read16(dev, 0, REG_MDIOD, val);
> +}
> +
> +static inline int b53_mmap_mdio_write(struct b53_device *dev, int phy_id=
,
> +                                     int loc, u16 val)

On nitpick here: AFACT, what you are actually getting there as phy_id
isn't the phy_id but the port_id, it just happens to be identical for
internal ports.

So in theory you would first need to convert this to the appropriate
phy_id (+ which bus) first, else you risk reading from the wrong
device (and/or bus).

See how the phys_mii_mask is based on the indexes of the user ports,
not their actual phy_ids. [1] [2]

[1] https://elixir.bootlin.com/linux/latest/source/net/dsa/dsa.c#L660
[2] https://elixir.bootlin.com/linux/latest/source/include/net/dsa.h#L596

Regards
Jonas
