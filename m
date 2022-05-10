Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C00521CC9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345027AbiEJOuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 10:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243035AbiEJOtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 10:49:41 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03BC5676A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 07:10:10 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gh6so33287860ejb.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 07:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9euCDWUejorloVc8VosrMHj8Uu6pL3LpaZYLUAPQ3/0=;
        b=n8HIDkDvAyM28YW4Vc8Jqd+GrwiwSqBh4dtV/eA95tpESMnqtFFOHsmWajFcQTKUwF
         5xlG43z8BsuY/kwSACzk2IyfRkJl6CJFoE0xMKSwPNUA0wM1HUK7XASSwscA2G2Kr2SW
         cw414ZWrgJE7XzVLXH7t7u2aT09sXHXvvBBKgIuqv1p+MxRNdjWmcvl2Lu1dzIyzf/OD
         /g93giTMrdVLGll/+KBtyt22htwRJE/PqITynrscqXPyz51Ob8FU3avEOX+fydpWczCJ
         X5Fay9rMg+AeKW1gzzpsPqEO0m/7qE43r+l116FCFHQDWLmhRZGC6skq2CQtdru/JAHq
         OfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9euCDWUejorloVc8VosrMHj8Uu6pL3LpaZYLUAPQ3/0=;
        b=OcDlmZDtbAZ50aKpr1qG7GLva01P7wtaol+bqavfEgD98DhIiQ0ymi+TiIyOllPeTe
         Lhu9BipVeqn0vnwLRmGznUVCFklNGnovHeVysxwVZujV4C5A/wsjtAY2INY1FGgK3j31
         TePybfP0Cx4o6eS/9rd3u4ENVfhbewPK18a2YCgBC9IV787ao+Sjx98cUx/RecTJw5Th
         9DD7gN9LFqerqOszp9c8bKiT26AnrLvKm9dVdcmEvWOl7OKY4aJnPbS4eFD92pMB4VAJ
         ATz1m3O/qoo/7dWJyf39Z5bBcuINnkbdy5T5gX1miO+YWrg7EoKqEEJqA7g1uE+SsWJF
         C3MQ==
X-Gm-Message-State: AOAM533Pyka15my7j+VLzNXstgjh2a8ibcfSkhytPyo/eaMsd0ahx6Ln
        t71tWcjNVBct55jQkbOXKR1aFMzgTcnYZZZsspo=
X-Google-Smtp-Source: ABdhPJxo/oSEuCFrlQtpUNyF48HHP0w7S1C2LY9llE/kfZdjXLRMXiRSILsjpeTCbOOVAC2dAtuHsxeL64iR1EGK4N0=
X-Received: by 2002:a17:907:7f12:b0:6f4:57e7:b20a with SMTP id
 qf18-20020a1709077f1200b006f457e7b20amr19186819ejc.538.1652191808621; Tue, 10
 May 2022 07:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <2a338e8e-3288-859c-d2e8-26c5712d3d06@nbd.name> <04fa6560-e6f4-005f-cddb-7bc9b4859ba2@gmail.com>
 <YnUXyQbLRn4BmJYr@lunn.ch> <391ca2d1-6977-0c9b-588c-31ad9bb68c82@gmail.com>
In-Reply-To: <391ca2d1-6977-0c9b-588c-31ad9bb68c82@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 10 May 2022 07:09:56 -0700
Message-ID: <CAA93jw5=Dh9w6x_EQtuWdAbWVUF00M+5x3idFz-XOvAzG5dMQw@mail.gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I might have mentioned this before. but I'm really big on using the
flent tool to drive test runs. The comparison
plots are to die for, and it can also sample cpu and other statistics
over time. Also I'm big on testing bidirectional functionality.

client$ flent -H server -t what_test_conditions_you_have
--step-size=3D.05 --te=3Dupload_streams=3D4 -x --socket-stats tcp_nup

Gathers a lot of data about everything. The rrul test is one of my
favorites for creating a bittorrent like load.

flent is usually available in apt/rpm/etc. there are scripts that can
run on routers, openwrt has opkg install flent-tools, you use ssh to
fire these off.

there are a few python dependencies for the flent-gui, that aren't
needed for the flent server or client
sometimes you have to install and compile netperf on your own with
./configure --enable-demo

Please see flent.org for more details, and/or hit the flent-users list
for questions.

On Tue, May 10, 2022 at 5:03 AM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>
> On 6.05.2022 14:42, Andrew Lunn wrote:
> >>> I just took a quick look at the driver. It allocates and maps rx buff=
ers that can cover a packet size of BGMAC_RX_MAX_FRAME_SIZE =3D 9724.
> >>> This seems rather excessive, especially since most people are going t=
o use a MTU of 1500.
> >>> My proposal would be to add support for making rx buffer size depende=
nt on MTU, reallocating the ring on MTU changes.
> >>> This should significantly reduce the time spent on flushing caches.
> >>
> >> Oh, that's important too, it was changed by commit 8c7da63978f1 ("bgma=
c:
> >> configure MTU and add support for frames beyond 8192 byte size"):
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D8c7da63978f1672eb4037bbca6e7eac73f908f03
> >>
> >> It lowered NAT speed with bgmac by 60% (362 Mbps =E2=86=92 140 Mbps).
> >>
> >> I do all my testing with
> >> #define BGMAC_RX_MAX_FRAME_SIZE                      1536
> >
> > That helps show that cache operations are part of your bottleneck.
> >
> > Taking a quick look at the driver. On the receive side:
> >
> >                         /* Unmap buffer to make it accessible to the CP=
U */
> >                          dma_unmap_single(dma_dev, dma_addr,
> >                                           BGMAC_RX_BUF_SIZE, DMA_FROM_D=
EVICE);
> >
> > Here is data is mapped read for the CPU to use it.
> >
> >                       /* Get info from the header */
> >                          len =3D le16_to_cpu(rx->len);
> >                          flags =3D le16_to_cpu(rx->flags);
> >
> >                          /* Check for poison and drop or pass the packe=
t */
> >                          if (len =3D=3D 0xdead && flags =3D=3D 0xbeef) =
{
> >                                  netdev_err(bgmac->net_dev, "Found pois=
oned packet at slot %d, DMA issue!\n",
> >                                             ring->start);
> >                                  put_page(virt_to_head_page(buf));
> >                                  bgmac->net_dev->stats.rx_errors++;
> >                                  break;
> >                          }
> >
> >                          if (len > BGMAC_RX_ALLOC_SIZE) {
> >                                  netdev_err(bgmac->net_dev, "Found over=
sized packet at slot %d, DMA issue!\n",
> >                                             ring->start);
> >                                  put_page(virt_to_head_page(buf));
> >                                  bgmac->net_dev->stats.rx_length_errors=
++;
> >                                  bgmac->net_dev->stats.rx_errors++;
> >                                  break;
> >                          }
> >
> >                          /* Omit CRC. */
> >                          len -=3D ETH_FCS_LEN;
> >
> >                          skb =3D build_skb(buf, BGMAC_RX_ALLOC_SIZE);
> >                          if (unlikely(!skb)) {
> >                                  netdev_err(bgmac->net_dev, "build_skb =
failed\n");
> >                                  put_page(virt_to_head_page(buf));
> >                                  bgmac->net_dev->stats.rx_errors++;
> >                                  break;
> >                          }
> >                          skb_put(skb, BGMAC_RX_FRAME_OFFSET +
> >                                  BGMAC_RX_BUF_OFFSET + len);
> >                          skb_pull(skb, BGMAC_RX_FRAME_OFFSET +
> >                                   BGMAC_RX_BUF_OFFSET);
> >
> >                          skb_checksum_none_assert(skb);
> >                          skb->protocol =3D eth_type_trans(skb, bgmac->n=
et_dev);
> >
> > and this is the first access of the actual data. You can make the
> > cache actually work for you, rather than against you, to adding a call =
to
> >
> >       prefetch(buf);
> >
> > just after the dma_unmap_single(). That will start getting the frame
> > header from DRAM into cache, so hopefully it is available by the time
> > eth_type_trans() is called and you don't have a cache miss.
>
>
> I don't think that analysis is correct.
>
> Please take a look at following lines:
> struct bgmac_rx_header *rx =3D slot->buf + BGMAC_RX_BUF_OFFSET;
> void *buf =3D slot->buf;
>
> The first we do after dma_unmap_single() call is rx->len read. That
> actually points to DMA data. There is nothing we could keep CPU busy
> with while preteching data.
>
> FWIW I tried adding prefetch(buf); anyway. I didn't change NAT speed by
> a single 1 Mb/s. Speed was exactly the same as without prefetch() call.



--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
