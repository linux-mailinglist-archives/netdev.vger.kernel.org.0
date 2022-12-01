Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB5C63F5A6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLAQtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLAQtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:49:07 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807D6B5D90
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:49:05 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fy37so5548183ejc.11
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qairkvFMBk38ixno7FXK1yC32lvL5RMbFL4tU3mHNiU=;
        b=E6+O5sFnlzcfx6vCEWapoW1Pm6SStOFR//uju9VpmHL/c12Gkl0B9mbseX4dybeaws
         IMPy4v+09Q7C/6/6aSrE35hUPpOzdiLIaZXMxKejpeuwdY0G0XqPHWdyjPyUJy8QdpgE
         D4DpT7VHfure02QmLJ/U74k1DYN2DlArLESACzF4Y2UocJUxtr0gxAIPv+EZtMVGPtiR
         sMkEcMF3pD5BNS/FW/uOvR/h+M2bpskrxIGTBtdyQ+T3gWJxGg20+eACCzEErhraAhei
         YHYAtqNB5Lkh1EGk79Bkve5DRXkMfmt316bV6cr+yCYRcL1LGwAx9O3LpKATtXmjZgsd
         Pbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qairkvFMBk38ixno7FXK1yC32lvL5RMbFL4tU3mHNiU=;
        b=5plpHJDA+ze0fNwP/YbvViFFwKnLj+9xzRnj8uOFCOLTc4Iwkw2dQoWVfS0ky1Fe2I
         5D0lr21ah8P8gZn/xuhQ6hKZOf9tUwi6SRpPonh6UyUf7/D4WWZFsXxYvST9yoo2VDfE
         5XmH6q7dWJp9VXtzepEB6aozhhDub/qJwED4od2JXxZaKdlPEGMiJORbn7tXFPyxuN+x
         FN3WlW3oRkYrREGUfzOtYn/VpiHSMR1SlYLhxl7cVtOpBblM5QH453lEdL/nmkNhm9Hr
         RbCyWWZcL0pyi9d4T1fpWkg+LIso4BtWu5PK0T11aBhr5gsqdaZkVA9T8cpYWf4+Jn1J
         IiMA==
X-Gm-Message-State: ANoB5pkcfOBNV+cWtlfmXx5MCqdTRnQoSbMFrVw4rpUHvN5j8HeGNx94
        l0/Q2jwN9khfrBrG2gXHpRY5gg==
X-Google-Smtp-Source: AA0mqf5gFoJAiraBGIPuIXjQYFHjMFmI/vY7Nq2QR8kIuoZe+8iX0nA0VxsHUEAPSYZ8zx3HJVxSzQ==
X-Received: by 2002:a17:906:27d8:b0:7bd:6264:a022 with SMTP id k24-20020a17090627d800b007bd6264a022mr24292090ejc.693.1669913344077;
        Thu, 01 Dec 2022 08:49:04 -0800 (PST)
Received: from blmsp ([2001:4091:a245:805c:9cf4:fdb8:bb61:5f4e])
        by smtp.gmail.com with ESMTPSA id n9-20020aa7c449000000b004588ef795easm1935430edr.34.2022.12.01.08.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:49:03 -0800 (PST)
Date:   Thu, 1 Dec 2022 17:49:02 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221201164902.ipd3ctrtne47jtmv@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221201084302.oodh22xgvwsjmoc3@blmsp>
 <20221201091605.jgd7dlswcbxapdy3@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201091605.jgd7dlswcbxapdy3@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Thu, Dec 01, 2022 at 10:16:05AM +0100, Marc Kleine-Budde wrote:
> On 01.12.2022 09:43:02, Markus Schneider-Pargmann wrote:
> > Hi Marc,
> > 
> > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > Currently the driver waits to wakeup the queue until the interrupt for
> > > > the transmit event is received and acknowledged. If we want to use the
> > > > hardware FIFO, this is too late.
> > > > 
> > > > Instead release the queue as soon as the transmit was transferred into
> > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > transferred.
> > > 
> > > If you want to really speed up the TX path, remove the worker and use
> > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> > 
> > Good idea. I will check how regmap's async_write works and if it is
> > suitable to do the job. I don't want to drop the regmap usage for this
> > right now.
> 
> IIRC regmap async write still uses mutexes, but sleeping is not allowed
> in the xmit handler. The mcp251xfd driver does the endianness conversion
> (and the optional CRC) manually for the TX path.

I just saw, you can force regmap to use spinlocks as well. But it uses
the same operation for sync operations as well.

> 
> Sending directly from the xmit handler basically eliminates the queuing
> between the network stack and the worker. Getting rid of the worker
> makes life easier and it's faster anyways.

The current implementation of the driver doesn't really queue anything
between the network stack and the worker. It is a queue of size 1 ;).

To be honest I would rather focus on the other things than on getting
rid of the worker completely as this can be done in a separate patch
later as well. Yes I agree it would be nice to get rid of the worker but
it is also probably not a major bottleneck for the performance and in
its current state it works. If I have time left at the end I will be
more than happy to do that. But for the moment I would just keep the
worker as it is. Is that OK for you?

Thanks,
Markus

> 
> > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > per SPI transfer.
> > 
> > That's on my todo list, but I am not sure I will get to it soonish.
> 
> I haven't implemented this for the mcp251xfd, yet, but I have some
> proof-of-concept code somewhere. However, the mcp251xfd driver already
> implemented byte queue limits: 0084e298acfe ("can: mcp251xfd: add BQL
> support").
> 
> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


