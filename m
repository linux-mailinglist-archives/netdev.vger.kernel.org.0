Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C3C602952
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJRK3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJRK3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:29:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CCDEE00;
        Tue, 18 Oct 2022 03:29:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t16so537464edd.2;
        Tue, 18 Oct 2022 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8wyb1pD8c4kNkSky1rGfLKeKyLpRrL4+xpIFRZD/O20=;
        b=FUwR6yFHr1g2QDyMU1Xcktrr+tj+iccihtOH3JwTJU3x0Dvo4u5fk5n000NwmQDmuV
         oK3zrOrIrhfAEm2D4M8UMDfYbsVUEjhWqObSS+GV2Cq9BR0OXkt+y6jNOQWmSXgtKYDC
         tNzPKGZLpPLOXwkeiHgvpmVM/kYv+o2Z/EdzZYnZHTXwih86aGN5A9SB0kyhUJVXehKn
         qFAUwk3rgU9wbhHx5F1XeKIsKXdbNqwH0xw4nwk+Wx3LjRGJMOE3WAz0SaPpYWAqReJh
         kWfoa3hhvhW/rKZbld7EWa95hAAiCykqaLFP2Fx9YSgMxr8hsN3WAs1lt7Xh8XcWDy/r
         KfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wyb1pD8c4kNkSky1rGfLKeKyLpRrL4+xpIFRZD/O20=;
        b=E+tkWW2KESTjGaML1EHyUtw7yKcWF7Z+TqamZ/hBxUP0nyInMAswT5Q4GxjNHzGzgo
         Fq3oRtyQU2xZepmP9OJgg8xPLksuGTC4gpmz29sKpbTINgKPMbPHa9gT6Ko5TVXzUb4X
         j/YuUd9QjRTnvy0MYV+8ijF1z/Qb2vvl5iWuHvp7HEwpUbAlkaLWKTHPM0hqb8bx2/2y
         KRqvsPNKRyU2ackeOUtv1lWNpSjbysmgBytvj/icWaX755lGJBJizIpQWW568wO3Ecil
         Mx/8EsQM7V1TafyusEAiPnzwRPwODkKz+iH98WNv2K+6LN01qxRqldHlusThEzNP43iI
         bqSA==
X-Gm-Message-State: ACrzQf277SbMOXZnqjQMyeQfxHf5jpJge4cMGckx/7LsMIi0cBgRKIDy
        FaQD5DHSRIiczXWCDVRypyg=
X-Google-Smtp-Source: AMsMyM6L5Q5weA0xG2DIC9K5KwiMf1vUdfVyiobb/GxgqTAjCzsPWc9Zo5j64qSDUiJLFyKHjpQqCQ==
X-Received: by 2002:a05:6402:3408:b0:43c:2dd3:d86b with SMTP id k8-20020a056402340800b0043c2dd3d86bmr1966191edc.108.1666088968878;
        Tue, 18 Oct 2022 03:29:28 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f11-20020a170906738b00b0073dc8d0eabesm7490755ejl.15.2022.10.18.03.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 03:29:27 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:29:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, ceggers@arri.de, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net, b.hutchman@gmail.com
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Message-ID: <20221018102924.g2houe3fz6wxlril@skbuf>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
 <20221017171916.oszpyxfnblezee6u@skbuf>
 <77959874a88756045ae13e0efede5e697be44a7b.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77959874a88756045ae13e0efede5e697be44a7b.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:44:04AM +0000, Arun.Ramadoss@microchip.com wrote:
> I had developed this patch set to add gPTP support for LAN937x based on
> the Christian eggers patch for KSZ9563. Initially I thought of keeping
> implementation specific to LAN937x through lan937x_ptp.c files. Since
> the register sets are same for LAN937x/KSZ9563, I developed using
> ksz_ptp.c so that in future Christain eggers patch can be merged to it
> to support the 1 step clock support.
> I read the Hardware errata of KSZ95xx on 2 step clock and found that it
> was fixed in LAN937x switches. If this is case, Do I need to move this
> 2 step timestamping specific to LAN937x as LAN937x_ptp.c & not claim
> for ksz9563 or common implementation in ksz_ptp.c & export the
> functionality based on chip-id in get_ts_info dsa hooks.

The high-level visible behavior needs to be that the kernel denies
hardware timestamping from being enabled on the platforms on which it
does not work (this includes platforms on which it is conveniently
"not tested" by Microchip engineers, despite there being published
errata stating it doesn't work). Then, the code organization needs to be
such that if anyone wants to add one step TX timestamping to KSZ9477/KSZ9563
as a workaround later, the code reuse is close to maximal without
further refactoring. And there should be plenty of reuse beyond the TX
timestamping procedure.

I expect that Christian will also be able to find some time to review
this RFC and propose some changes/ask some questions based on his prior
observations, at least so he said privately.
