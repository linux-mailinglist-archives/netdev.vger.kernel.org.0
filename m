Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DEB290A9E
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732619AbgJPRYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732610AbgJPRYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:24:52 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1D7C061755;
        Fri, 16 Oct 2020 10:24:52 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e22so4304171ejr.4;
        Fri, 16 Oct 2020 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pO3C+eXVvdwEI+IB+Le7XDmmj0drnX6Kq4OH7rf6SWM=;
        b=rzfTPmqKWPn5DVLJ/RSKh3IpxFwmm+Yg7IliPjxDF7N4zpe1au0Q+WGLVdrm4EI31O
         cQX8YEu3uV6KZFp+gRVuKvo5lyqFNjBJyOKahWVyTTPQZjrXmSeW+8O42WK8fOemMcki
         1mrjFzJ9qiFxC17i6SmeFj9thth6vwvhCGfCZC2D53aS0ZZrtcCfywo7qDBya3lOwjB+
         uXGUsL9lz5HoArxpf05zs9+H+R0oKOrWedHlv6Hxq2Y6D0VRgzciHQKAtE9Ah2tOICXB
         46PXtL0rfSEc4zcsUSts9kZxcujCyQsBmBw5S/BzNfJUut7ADoAcXV8NoXfDxBRPQLoA
         MDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pO3C+eXVvdwEI+IB+Le7XDmmj0drnX6Kq4OH7rf6SWM=;
        b=T9dmxIrsD3F/lc5+Zv1Qt2MxSKk6sTZTQj1FjQZeLH+GxtpJ+xnPMiILZE1nyXt+V3
         9a8O26SySDi1IzNTC+PsCUBAr09QJSeJLWISxNuoBA2MpplP4YtemU/20Ijf+murWtcO
         //Luq/TNhLklqZJZTQKWE4h834EloOZdyqn+CDjfxEUr6RIhXBBr3KgLf84Wi/GA8j9s
         kBeCltBkdqYM24oM+QQLulZpyvnpNTX7C1Ee58rsKMTy0c+2exeNHmflNLTA1o9fgEEC
         1n9B+Zgkvx9b9NorZL68ffLJREpZiKyfToV6a+bEO5N5ym05UjqI5DT8sx3LLtHKQp1h
         8BeQ==
X-Gm-Message-State: AOAM532iaN2NZnBXn8ATMKFu+MvWnc3xbCsPp5dIEusCpmoTKgvgOnTq
        xgN+yKT5YXVlE4xMrTTCdyQ=
X-Google-Smtp-Source: ABdhPJzxW81+cifvI/aItNeslq0SE4A1BL4NP/tFyZs6G5CSSwZNlk/NlRDCoQaFXw0rumBxK/8LKA==
X-Received: by 2002:a17:906:f298:: with SMTP id gu24mr4888353ejb.53.1602869091066;
        Fri, 16 Oct 2020 10:24:51 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id j10sm2147768edy.97.2020.10.16.10.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 10:24:50 -0700 (PDT)
Date:   Fri, 16 Oct 2020 20:24:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: tag_ksz: KSZ8795 and KSZ9477 also use tail
 tags
Message-ID: <20201016172449.nvfflbbkrdbzukwz@skbuf>
References: <20201016171603.10587-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016171603.10587-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 07:16:03PM +0200, Christian Eggers wrote:
> I added it manually because the commit ID is not from Linus' tree. Is there any
> value using Fixes tags with id's from other trees?

Yes, that's what "git merge" does, it keeps sha1sums.
You should check out "git log --oneline --graph --decorate" some time.
Every maintainer's history is linear, and so is Linus's.
