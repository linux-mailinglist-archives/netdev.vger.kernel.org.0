Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C232A6A16
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgKDQnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731210AbgKDQnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:43:05 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77C7C0613D3;
        Wed,  4 Nov 2020 08:43:05 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id w11so10538276pll.8;
        Wed, 04 Nov 2020 08:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bH66Ulkk+HNzi+h3l2238xPbIOr76DAq74H0dqLHkJE=;
        b=i3hIQiTfi6MwakQg00IBO0+XxpQet27JULd1t67pA8emnMB9MmNlOrE3Jpxt63nlfI
         Dr9OYTkFKKvAlXg9g3yVV4mte+dUvi/QtiXiH6iPWAePcOa8mwf7fVwPs+cfm7sEXy3a
         uuSYytEnOlDOzwMFFRPSrjv7u816Dx9tUO98ZFTpjUs0/+mukX9CPkWKTMpstVInyfDn
         FprOcdSFpKOaqqWaEdboluVP08yQClePYPx5jpx4rBeG9I20BORAKBSbV8IlJnypvuol
         VGRiReFGm6wySqtrYwbR9W9d7f20UDe7vqFCMZXkT5H8LeUF3Rzcm4R9CtNWm8eOMQ43
         5kPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bH66Ulkk+HNzi+h3l2238xPbIOr76DAq74H0dqLHkJE=;
        b=dZarTqWytNSJ+DCGLG8RsZfQQHohY95J/Ch4bTdAamdGbR3KxV9pHvEu9ro/peyErD
         EmuwlCgNu2dBR2XlJYPKa5VzwA3BndJzuPwADT+wFcRnhI4LzLgIF/gH7BsQzgdW+e1h
         iMXhyl4wrkK5VPiP8jKI2vhn4tsyNPGKDKzdG2E1npKt+DXGDbM4nYSO16ycRTBawX+W
         cDvkiK0w+Rl2rWzJYIXlH4Dqu07tNVcuykbsU5E7pVSDtcXjsUO8Sg26jn305JvWlq7j
         xBHV3RHMAiy7Tf5n4ZEHppjYHhbRhkSq59TstK2tdSCs8pQ5boifNQ4+RKhSpZMz/TLi
         X6Vw==
X-Gm-Message-State: AOAM533tEe5QQL3U1/nmUxanYYqMv7n5gRtJJzYneH2kpIkKffouXpxS
        Pgl0PkPuwLR4UW63U6yP32xTtl1RrUQ=
X-Google-Smtp-Source: ABdhPJxu7Ium/wh2eBLH4ViiefTKA/mHeeQp7x3AeB7Y1ivlnwb+fsE3A4Gp+o1oZvHG0ftYsdCTbQ==
X-Received: by 2002:a17:902:7402:b029:d6:8558:7920 with SMTP id g2-20020a1709027402b02900d685587920mr29612126pll.8.1604508184718;
        Wed, 04 Nov 2020 08:43:04 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id s6sm2903548pgo.8.2020.11.04.08.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:43:04 -0800 (PST)
Date:   Wed, 4 Nov 2020 08:43:01 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ptp: idt82p33: use i2c_master_send for bus
 write
Message-ID: <20201104164301.GD16105@hoboy.vegasvil.org>
References: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
 <1604505709-5483-2-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604505709-5483-2-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:01:48AM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Refactor idt82p33_xfer and use i2c_master_send for write operation.
> Because some I2C controllers are only working with single-burst write
> transaction.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
