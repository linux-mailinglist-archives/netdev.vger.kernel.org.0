Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4834564D8A2
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLOJcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiLOJbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:31:44 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E335FE7
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:31:43 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id n20so50886912ejh.0
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0YAKGDMlZN4p7SGu1vmDkPv/Bp6BjxoeHp4dwkcNfc=;
        b=2f3RUKhIBSh486JTHI1LtttZ415mWNa9U2TLd2xJ81N+di7BPRGccKUXO+B3tWnv6e
         MxQp+ywMvY0KT2MHPteX66Cdkxc4vDCFl8wwsT2H/KnrJtqboZ4v4xVW1WIcOwscQJtk
         EXzS14okcECBa5A0LwliClUG49W/vadFAt5c5kXewKUNjocHSDwjLDc1/F56FHMDmNf6
         OhFVmx9F5p6v/4cL58/0nfgyDfLhxNeazfLAv/ACjn8x/rwopoNPKgfp6LdUVQsy0oyn
         zbQ7+wvE/BNvLJdFrWw1SsyUq9c9qS5NRtSaD2PcPuLLfl9gJZfzc0B0tZ6aXUCUA3eR
         tLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0YAKGDMlZN4p7SGu1vmDkPv/Bp6BjxoeHp4dwkcNfc=;
        b=z0nEPnadM4qMf6hkS5TzlmZx9FNH2A/Szk0qIq/FxXQUuoEyvd7m/y/uxXNPPcwXUV
         hkP8yhtXL5UOikThrF0AzM3PEU35Y5jbIyPryS4NkBAx8zr4SYLizqKNv120/cl6ecTV
         fBWAKjYWWC+L3RmiAW4j3WaSm4K13swnnnbfNUrI6BZY5OTKvI49nHvDR66KIdjYqv08
         JT47JTYuyz39Yw9yhYtXwjKZwb51Obke1Uzqiaex7g1bk/DRlKSqmQB6ANTO36hsAX1P
         RMYJVP5oqkOBfbJftcGHzKSH6zwQYCI8aTjlCzjHSjhxuo4WcECuEVrs5pdhXBMQympR
         J/5A==
X-Gm-Message-State: AFqh2koJ7NEXr4S/UXVvavzQIfn2iK15RRbLM8RlE+BxgqAKAotHIMoI
        AU79wdbm+IXMbJkT6/RdK7Oc+QouAt81WdA+
X-Google-Smtp-Source: AA0mqf5MMcU0t1oncbTYHhV2o2kO+I4zfDKxm6R/liP0XWxOGWAI0R3zjT2Yg8Zg/LZRDrkiN4wcbg==
X-Received: by 2002:a17:906:26c6:b0:7c5:fd:4352 with SMTP id u6-20020a17090626c600b007c500fd4352mr5582566ejc.49.1671096701556;
        Thu, 15 Dec 2022 01:31:41 -0800 (PST)
Received: from blmsp ([185.238.219.6])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906292200b007c09d37eac7sm6796931ejd.216.2022.12.15.01.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 01:31:41 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:31:40 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221215093140.fwpezasd6whhk7p7@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221214091406.g6vim5hvlkm34naf@blmsp>
 <20221214091820.geugui5ws3f7a5ng@pengutronix.de>
 <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
 <CAMZ6RqLAZNj9dm_frbKExHK8AYDj9D0rX_9=c8_wk9kFrO-srw@mail.gmail.com>
 <20221214103542.c5g32qtbuvn5mv4u@blmsp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221214103542.c5g32qtbuvn5mv4u@blmsp>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Dec 14, 2022 at 11:35:43AM +0100, Markus Schneider-Pargmann wrote:
> Hi Vincent,
> 
> On Wed, Dec 14, 2022 at 07:15:25PM +0900, Vincent MAILHOL wrote:
> > On Wed. 14 Dec. 2022 at 18:28, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > On 14.12.2022 10:18:20, Marc Kleine-Budde wrote:
> > > > On 14.12.2022 10:14:06, Markus Schneider-Pargmann wrote:
> > > > > Hi Marc,
> > > > >
> > > > > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > > > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > > > > Currently the driver waits to wakeup the queue until the interrupt for
> > > > > > > the transmit event is received and acknowledged. If we want to use the
> > > > > > > hardware FIFO, this is too late.
> > > > > > >
> > > > > > > Instead release the queue as soon as the transmit was transferred into
> > > > > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > > > > transferred.
> > > > > >
> > > > > > If you want to really speed up the TX path, remove the worker and use
> > > > > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> > > > > >
> > > > > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > > > > per SPI transfer.
> > > > >
> > > > > Just a quick question here, I mplemented a xmit_more() call and I am
> > > > > testing it right now, but it always returns false even under high
> > > > > pressure. The device has a txqueuelen set to 1000. Do I need to turn
> > > > > some other knob for this to work?
> > 
> > I was the first to use BQL in a CAN driver. It also took me time to
> > first figure out the existence of xmit_more() and even more to
> > understand how to make it so that it would return true.
> > 
> > > > AFAIK you need BQL support: see 0084e298acfe ("can: mcp251xfd: add BQL support").
> > > >
> > > > The etas_es58x driver implements xmit_more(), I added the Author Vincent
> > > > on Cc.
> > >
> > > Have a look at netdev_queue_set_dql_min_limit() in the etas driver.
> > 
> > The functions you need are the netdev_send_queue() and the
> > netdev_complete_queue():
> > 
> >   https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L3424
> > 
> > For CAN, you probably want to have a look to can_skb_get_frame_len().
> > 
> >   https://elixir.bootlin.com/linux/latest/source/include/linux/can/length.h#L166
> > 
> > The netdev_queue_set_dql_min_limit() gives hints by setting a minimum
> > value for BQL. It is optional (and as of today I am the only user of
> > it).
> 
> Thank you for this summary, great that you already invested the time to
> make it work with a CAN driver. I will give it a try in the m_can
> driver.

Thanks again, it looks like it is working after adding netdev_sent_queue
and netdev_complete_queue.

Best,
Markus
