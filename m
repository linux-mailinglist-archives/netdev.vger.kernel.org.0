Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82664C5A5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiLNJOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiLNJOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:14:12 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B5A1E724
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:14:09 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n20so43001110ejh.0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uWkMxa5MLgkbzdYiOGyURygCOSuCzD/0jnB9r1qxWTs=;
        b=TcGAPjxR9F6gw8xpoGK2DjJ+OF1X1Kwmirxn+f1vVC6ZrCogbLdvYMSA45jSe5obuT
         auY5It6QRqAisUJ0D0lKegv8tJKrxhiEU3UMMnsXw9navQBet5mrgf3zrBj4O6s/szRB
         F0ONb8u0wLbZa7QxTpsQ6bNk8X14u0Xf8B7hS/scpjMsPG13JkyGmjXvElukHQix7+zn
         wEo5+GIceH543hYpmLLOa7lmNoqvhEI6dNY/xg8dlxDX5tRduSUZOjSAPR3YUPu0dzP9
         1SW2Gh1WF3jwREjOXZ2b3/OpBcsl2O+7uJVbhyAIwpX+Ap+37eEAXlu9d0tR/R3siZGl
         hZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWkMxa5MLgkbzdYiOGyURygCOSuCzD/0jnB9r1qxWTs=;
        b=O3qsPqbUNKZ7Pt73gK5OyJlNiCpb8JwQG8k/SxVxcyabokcJsQJvUK/Q7BvBddcLOM
         DI248oFIp8W9aMVfTxPhjAzKGjPQjzSY+HU9jur/WOqUY616InEiS14fvXMhQrcUubh4
         1rsXXmI+ZzHD8kwzd35ff8HabFgSAxZekNqMcY0wALdmbit0jJE6Vh8d/EOGBEoThTFK
         Rh3qYGh395Cav5MSkfwe99JOKXLk/EYd20YoVqTdm4eR+jhakO1nQSCxIyVyRZlIdhep
         iYN8BRGSfjodLtRhex1EbCdOb7rtJcP/37lEpWWniWoqSrXKHep1RnGAvrRTlONSrrJO
         gJ/Q==
X-Gm-Message-State: ANoB5pkZ63LnMfzasNhnzuxqmnxishKwhHbYQCrELvrF2EVNGtutfhKt
        3J33qepmhUFJxP7Stkb3biu2yg==
X-Google-Smtp-Source: AA0mqf5Hh2vYaRSCkuOt0e+bO9Bytz2NDRllVNqTlpXkMHlnUyydFlzhOsdwMBeV0ocC3UEihjU6JA==
X-Received: by 2002:a17:906:1f53:b0:7bc:bf97:169c with SMTP id d19-20020a1709061f5300b007bcbf97169cmr19058269ejk.77.1671009248480;
        Wed, 14 Dec 2022 01:14:08 -0800 (PST)
Received: from blmsp ([185.238.219.9])
        by smtp.gmail.com with ESMTPSA id k24-20020a17090632d800b007ad94fd48dfsm5529083ejk.139.2022.12.14.01.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 01:14:08 -0800 (PST)
Date:   Wed, 14 Dec 2022 10:14:06 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221214091406.g6vim5hvlkm34naf@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > Currently the driver waits to wakeup the queue until the interrupt for
> > the transmit event is received and acknowledged. If we want to use the
> > hardware FIFO, this is too late.
> > 
> > Instead release the queue as soon as the transmit was transferred into
> > the hardware FIFO. We are then ready for the next transmit to be
> > transferred.
> 
> If you want to really speed up the TX path, remove the worker and use
> the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> 
> Extra bonus if you implement xmit_more() and transfer more than 1 skb
> per SPI transfer.

Just a quick question here, I mplemented a xmit_more() call and I am
testing it right now, but it always returns false even under high
pressure. The device has a txqueuelen set to 1000. Do I need to turn
some other knob for this to work?

Thanks,
Markus
