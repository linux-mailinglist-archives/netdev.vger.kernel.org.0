Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A806627C4
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbjAINzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjAINza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:55:30 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3362EDD7
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:55:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso9066745wms.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 05:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=va66QghiVwE6QiiPu9+UqCbbyrDyyXt5x9KLmndYxL8=;
        b=GCbpLCPt03bLfCX0hIfUstelzWW82socA5TVed6Mkkf687r2qcXjySW9kXEgKlOGPh
         Yd84hbnwYZ0varuAkWdq5mkmPYo1LeTM1WOPEdCabTFA5OzEoHgwvobs6yETn5oR6ssa
         4sXLgkDJwyG5Udg/ASYQLx2fCJNwjYVEC+xJMxsZssLoAsOxK/u5g30vas2PR7TQ9mZZ
         hUv+qR+nKFQORVbXoOov4LDvFkWBxrHxrbDNum90W4WjwcAI/SkuYXTut8RxoldH1Xtn
         VHtL+/c+xw3BjMGKcelvN1WMF7unrtQUZlcVEskL0HUO14pQT8S8ZljO0k3hViyhcSQX
         hfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=va66QghiVwE6QiiPu9+UqCbbyrDyyXt5x9KLmndYxL8=;
        b=YoXK1hWVKmP9bVtaTWQfxr3OUAz/hBNtYVnVNdRYZ04OSwspobNhaVQB6vWHF5nycC
         36nLM+WiayFCXXQ9soh5JusekxUZCDjMrPp11+bHtEsfVIrK5uG5J1U1vPArdmDTW+vt
         pshmrah8H/qpz+M9wBw9DFRSiOBKybfgg9jaq05wWrk/NeRHEk9SjEQTWc3PHrIokAn0
         yxbq/SA4CcM3z8Dyu1JHn2ihsAcm4hbZIwV1GzxMUK6OmThw6bvamSmhJLdXHVLqz3hw
         rc6hJBlB5oT49EOtH/M8bCLZN1D1l/KT5AvsRVGyqMn2w/M+o7V+hTiPnBRixXKDiWi0
         Y+ZA==
X-Gm-Message-State: AFqh2koyhhONWXuViSqfHTyIocdGZnAjk7kJrqki6sNY6qVBXR+koXLU
        jx+zfDj1yHbjqh4WeVO8rlcgDg==
X-Google-Smtp-Source: AMrXdXv2WN4wMVGdDkBhjE+UWpSu6saJ98AIITLU1NrEhKekqQlPlT+EBUtwJNXfeVDh6ZJgMatH0g==
X-Received: by 2002:a7b:c3c9:0:b0:3d2:e28:647f with SMTP id t9-20020a7bc3c9000000b003d20e28647fmr55927989wmj.15.1673272526694;
        Mon, 09 Jan 2023 05:55:26 -0800 (PST)
Received: from blmsp ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id o21-20020a1c7515000000b003d995a704fdsm11487570wmc.33.2023.01.09.05.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 05:55:26 -0800 (PST)
Date:   Mon, 9 Jan 2023 14:55:20 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] can: m_can: Optimizations for m_can/tcan part 2
Message-ID: <20230109135520.6dt3p7wvo3zoygmi@blmsp>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

On Wed, Dec 21, 2022 at 04:25:19PM +0100, Markus Schneider-Pargmann wrote:
> Hi Marc and everyone,
> 
> this is the second part now. I know it is the merge window right now but
> I am quite sure this won't be merged immediately anyways, so if you have
> some time for some comments I would appreciate it. So it is still based
> on v6.1-rc8 + the patches that got applied.
> 
> I tried to do as small patches as possible so it is easier to
> understand. The series changed a lot compared to v1 I sent so I didn't
> call it v2. There are a lot of new patches as well.
> 
> The series contains a few small fixes and optimizations at the
> beginning, then adding coalescing support and at the end removing the
> restrictions on the number of parallel transmits in flight.
> 
> Note that the last patch 'Implement transmit submission coalescing' does
> not perform well for me in a loopback testing setup. However I think it
> may work well in normal testcases. I attached this mechanism to the
> tx-frames coalescing option, let me know if this is the correct option.

I introduced a bug in this series in the internal m_can driver (not
peripheral) and maybe for older m_can versions as well. No need to
review at the moment, I will send a new version once they are fixed.

Best,
Markus

> 
> Best,
> Markus
> 
> part 1:
> v1 - https://lore.kernel.org/lkml/20221116205308.2996556-1-msp@baylibre.com
> v2 - https://lore.kernel.org/lkml/20221206115728.1056014-1-msp@baylibre.com
> 
> Markus Schneider-Pargmann (18):
>   can: tcan4x5x: Remove reserved register 0x814 from writable table
>   can: tcan4x5x: Check size of mram configuration
>   can: m_can: Remove repeated check for is_peripheral
>   can: m_can: Always acknowledge all interrupts
>   can: m_can: Remove double interrupt enable
>   can: m_can: Disable unused interrupts
>   can: m_can: Keep interrupts enabled during peripheral read
>   can: m_can: Write transmit header and data in one transaction
>   can: m_can: Implement receive coalescing
>   can: m_can: Implement transmit coalescing
>   can: m_can: Add rx coalescing ethtool support
>   can: m_can: Add tx coalescing ethtool support
>   can: m_can: Cache tx putidx
>   can: m_can: Use the workqueue as queue
>   can: m_can: Introduce a tx_fifo_in_flight counter
>   can: m_can: Use tx_fifo_in_flight for netif_queue control
>   can: m_can: Implement BQL
>   can: m_can: Implement transmit submission coalescing
> 
>  drivers/net/can/m_can/m_can.c           | 498 ++++++++++++++++++------
>  drivers/net/can/m_can/m_can.h           |  36 +-
>  drivers/net/can/m_can/tcan4x5x-core.c   |   5 +
>  drivers/net/can/m_can/tcan4x5x-regmap.c |   1 -
>  4 files changed, 418 insertions(+), 122 deletions(-)
> 
> -- 
> 2.38.1
> 
