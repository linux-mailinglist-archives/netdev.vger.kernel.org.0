Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF1510B3E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 23:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355420AbiDZVaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 17:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355415AbiDZVaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 17:30:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7506032EDB;
        Tue, 26 Apr 2022 14:26:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i24so19095185pfa.7;
        Tue, 26 Apr 2022 14:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6ccjT8oSipPf2jw27tqBgErsekTmm/pjIqbzSoCLGkQ=;
        b=dXpIjCpl/1s6LYhlBSsXMCK0+aIsnNICto5mxciPm7SQkb2NFG+CpPhJNdP9EM08iE
         XPTIySUfUe6xVFdb9/JixHoIH/rQ2U3CzXzHvCr+J74RTbI/Z1TbhR75u7Ys9RnqPCFB
         WNh/J+Oi6izjgImWMAu8++sAY/HocJAFqLT6Ki9eB1uYn6yD2xdrKvzojWjbX3/wqUlx
         DQHgga8jn6Mn4sUsrbKDNk/Dd1AmWjE2/6kQJ8viqTVdtxfhXDrkyxNJ8dc60YBbKvg6
         28gz52ix9+KwC/44mCGzK+vG4Z1LTojZNY0RILz6LCaUMkqCuwNu6spSmABXdPjQI5hJ
         eLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6ccjT8oSipPf2jw27tqBgErsekTmm/pjIqbzSoCLGkQ=;
        b=O19h3cO4kU3s9WHCJbVFAGygxVpLl8miYmaUCZeJ/eOeoGEfjLhI2L3bjDQ0HHJzdp
         5n+Fe7SfIlcTYv4FQkd9wnEUoZtRGS5pNUaIM6CRkL9Ko7IbhTEIEX1vfKuUhMEoNyUS
         1W3Tb8miA6dQrEHIfS5y+ROANurBjI9PCd+U8NySLAIC6vg/bYn/XX0G4CvF5DLbwBEm
         Xo3TXRTa1W8DW2Q4vDk41agajuSEPVChbowZct7T1aS1A5jLZwrZ2KzzVEYpyWkjlrZb
         +KmXAQF6u2vlQmBwC/k/pitiJvL2PJ7Cl7diuOAt22JvZUs8BaRCX8a+3WiFaPElfZPA
         skYw==
X-Gm-Message-State: AOAM532VPS3LbpZpLM7xs1CGXS9THhGRkF/j4ZWwnVFXj7J5Ff8sCg8X
        gNCU64RoJplnyJRHZUX72H0=
X-Google-Smtp-Source: ABdhPJwNpXPAg5M+BX3RZfs9gA2thKD4H5qXR2V92o4g+I21VlXI/7KB3Vf1sMYgu1GafcAbTkBHyw==
X-Received: by 2002:a63:2209:0:b0:3ab:113b:9a2b with SMTP id i9-20020a632209000000b003ab113b9a2bmr13890457pgi.235.1651008414031;
        Tue, 26 Apr 2022 14:26:54 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d6-20020a17090acd0600b001cd4989fed4sm4317871pju.32.2022.04.26.14.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 14:26:53 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:26:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase
 pull-in is in progress
Message-ID: <20220426212651.GC17420@hoboy.vegasvil.org>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
 <1651001574-32457-2-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651001574-32457-2-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 03:32:54PM -0400, Min Li wrote:
> Also removes PEROUT_ENABLE_OUTPUT_MASK
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 32 ++------------------------------
>  drivers/ptp/ptp_clockmatrix.h |  2 --
>  2 files changed, 2 insertions(+), 32 deletions(-)

Acked-by: Richard Cochran <richardcochran@gmail.com>
