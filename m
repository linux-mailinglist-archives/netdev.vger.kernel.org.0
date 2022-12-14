Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70FD64C740
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiLNKfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiLNKfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:35:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE2420F7F
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:35:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id b2so43418523eja.7
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2RvFiiCnhAAKi7d+1qBnwz6NP+D+/ZIyHDhOt+BilbQ=;
        b=2V4nT4w2BZ/X/Hf4t9dDrH6FezCbRaJT9eK8gARAwOK5jTLArjG27ZFq2pWOBuSLpl
         bCY3WZSuMi6v1+06iAFKfMMs/kttgxTMRcA4PCJaKOVbqdTS5gm+ME6W+Z3l7dxOSOIS
         5e89STE0Lk+Yj5LDgU/Rde2I+SLS3aJrlkufHUKUG3+RDf+fq6+Q3x42STGClCSCoWR+
         FQmQfqwqFF6ScBSiX+oAl+IgjoyJ6nXWnUKwlok6TIcqbM7/Jc4Eeih5E95NSaOXfFyy
         gzam1E6rhlLU2daKpN29DA6aGJoZ9U6nc7hrDqDb2JLOFoKVwOsFjgto9ypjC52kIIfj
         /wpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2RvFiiCnhAAKi7d+1qBnwz6NP+D+/ZIyHDhOt+BilbQ=;
        b=ReQ3ph830RpISd1RqmVEiT4Glovkz8V2i3qJ3Pc0MaItYtPEaYY5jfzP1cOr5stms0
         WgIsLwaRQtmAIKPlIKWcV00n+JERppW2HX1Pzn6cxS9QQ9MJHaTGy6/ojaZGC6nCerV4
         ZeHwC3vjOTE8cU9SBhd3wc/q1gD1wWRHaXLY6Ca6S9e0twKELj+ScnqnokTu/Z54jRnU
         1Lq0SEg65Vc/Oss8AcmnnHHe8mP7TnuoL2ICLbffQ2VkUcmz6izGlzo9qIb7nqN8n0cR
         l4fDjrXaeI8I0Qjy+NwIQR0kf5pvjAyqvaNeY/OQO1z0S+yu3pTOT720Cc/uZLSNB9EN
         5gRA==
X-Gm-Message-State: ANoB5pnqqrtReLeMs9zgofrZgPN9huT/B7N3Hkuwu08T5stf6jeWmlEE
        kF+eLQAhhEk6chkbyG3OwwtSHA==
X-Google-Smtp-Source: AA0mqf4bgN78wWncfZNxqYVwCIc6gPyOa9DX5wTQAfud2G1FHgDFnihpW/1nZMNLd9Wb+KeVgmkZ2g==
X-Received: by 2002:a17:906:698f:b0:7ad:d250:b903 with SMTP id i15-20020a170906698f00b007add250b903mr19732691ejr.56.1671014143640;
        Wed, 14 Dec 2022 02:35:43 -0800 (PST)
Received: from blmsp ([185.238.219.46])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906318100b0077b2b0563f4sm5740827ejy.173.2022.12.14.02.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 02:35:43 -0800 (PST)
Date:   Wed, 14 Dec 2022 11:35:42 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221214103542.c5g32qtbuvn5mv4u@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221214091406.g6vim5hvlkm34naf@blmsp>
 <20221214091820.geugui5ws3f7a5ng@pengutronix.de>
 <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
 <CAMZ6RqLAZNj9dm_frbKExHK8AYDj9D0rX_9=c8_wk9kFrO-srw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLAZNj9dm_frbKExHK8AYDj9D0rX_9=c8_wk9kFrO-srw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On Wed, Dec 14, 2022 at 07:15:25PM +0900, Vincent MAILHOL wrote:
> On Wed. 14 Dec. 2022 at 18:28, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 14.12.2022 10:18:20, Marc Kleine-Budde wrote:
> > > On 14.12.2022 10:14:06, Markus Schneider-Pargmann wrote:
> > > > Hi Marc,
> > > >
> > > > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > > > Currently the driver waits to wakeup the queue until the interrupt for
> > > > > > the transmit event is received and acknowledged. If we want to use the
> > > > > > hardware FIFO, this is too late.
> > > > > >
> > > > > > Instead release the queue as soon as the transmit was transferred into
> > > > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > > > transferred.
> > > > >
> > > > > If you want to really speed up the TX path, remove the worker and use
> > > > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> > > > >
> > > > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > > > per SPI transfer.
> > > >
> > > > Just a quick question here, I mplemented a xmit_more() call and I am
> > > > testing it right now, but it always returns false even under high
> > > > pressure. The device has a txqueuelen set to 1000. Do I need to turn
> > > > some other knob for this to work?
> 
> I was the first to use BQL in a CAN driver. It also took me time to
> first figure out the existence of xmit_more() and even more to
> understand how to make it so that it would return true.
> 
> > > AFAIK you need BQL support: see 0084e298acfe ("can: mcp251xfd: add BQL support").
> > >
> > > The etas_es58x driver implements xmit_more(), I added the Author Vincent
> > > on Cc.
> >
> > Have a look at netdev_queue_set_dql_min_limit() in the etas driver.
> 
> The functions you need are the netdev_send_queue() and the
> netdev_complete_queue():
> 
>   https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L3424
> 
> For CAN, you probably want to have a look to can_skb_get_frame_len().
> 
>   https://elixir.bootlin.com/linux/latest/source/include/linux/can/length.h#L166
> 
> The netdev_queue_set_dql_min_limit() gives hints by setting a minimum
> value for BQL. It is optional (and as of today I am the only user of
> it).

Thank you for this summary, great that you already invested the time to
make it work with a CAN driver. I will give it a try in the m_can
driver.

Best,
Markus
