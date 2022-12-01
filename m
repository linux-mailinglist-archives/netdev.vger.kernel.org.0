Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B8663EB5E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiLAIni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiLAInR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:43:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3BB8C464
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 00:43:05 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h12so1493799wrv.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 00:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HQr1oGy5DEX3lJPtiK6R7BWnZFhYcZk8exhLp6Q2aeg=;
        b=5mzqMo7ukyygGX8OISLeYMNYuA34leGRYjCMcXqfPPGOlGdgdZQKtAqTF45lMN7ihv
         CHnZ472nBq5kBNnVYB8rU+zZyJmr+Bs/U/l3MS0fbr07++HbU6AARnkZb/E/1vTb6YBY
         Wk/obn2X2pIwR+eF49qrqsJAdePjAkbS/Nq9yk22poLvEVKHv2QRjbw93U0/hJ5Zu3q/
         tYnRIZ2FZWtzY1ODNJtR+18vXVWiXy4Vq3zcld7S1S3zVLVnfzVyfyiknt4ZOZf5clbB
         LksCgTmcSvllUifUGeK0ESEW5fLg+47SodBHBekeiQ1R9sBthnIoU5Vd/oErIXpojUuY
         Igyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQr1oGy5DEX3lJPtiK6R7BWnZFhYcZk8exhLp6Q2aeg=;
        b=o8B6eYpUT05MktAITqtsffZcQuNrGk/qUf6QOGGutubNKWfwmD118QcYrSqOC0BpVs
         XJCXTi+QjJsELudvomnq5+ycpTmkFeTVj511rKS+varjDTqxF/9qqWK96jHUs2R1qVNB
         mlFC9m+4cRF9frsTIUrMtx2mUx4AyqAQYhnzj1a45moA23uwQwF8DneSjzalVJ60U7h3
         p3sWN+/zhMyn4ucMeil/IG0tpKqN/u5xWIfZcaNDVWqIE2ivMcBwb6iA0pJlcVJb73bo
         UbzmLjDXez/AUlYu4bXMLKymWnIhSNzhVMVdlcdSMJvLCh/S96/e/xmMRt5WagFkhPHZ
         3iPA==
X-Gm-Message-State: ANoB5pkXYrqhrwE/YBEVj0abPd32/8lokDAU11XNAK76XsSx6m0hDBBq
        f5iL7VGbfmu34LHrPPKJyr+VSQ==
X-Google-Smtp-Source: AA0mqf7H1EX5CBJip8X5BYo3Qni+dk8nKfSn+VCA/YzN7e5gdR3ij6oS9ggQbb9q0vgllf1d6qQNvA==
X-Received: by 2002:a05:6000:510:b0:22e:3ca6:d4ab with SMTP id a16-20020a056000051000b0022e3ca6d4abmr41983182wrf.658.1669884184194;
        Thu, 01 Dec 2022 00:43:04 -0800 (PST)
Received: from blmsp ([185.238.219.115])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c2cb000b003c6bbe910fdsm9892758wmc.9.2022.12.01.00.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 00:43:03 -0800 (PST)
Date:   Thu, 1 Dec 2022 09:43:02 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221201084302.oodh22xgvwsjmoc3@blmsp>
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

Good idea. I will check how regmap's async_write works and if it is
suitable to do the job. I don't want to drop the regmap usage for this
right now.

> 
> Extra bonus if you implement xmit_more() and transfer more than 1 skb
> per SPI transfer.

That's on my todo list, but I am not sure I will get to it soonish.

Thank you Marc!.

Best,
Markus
