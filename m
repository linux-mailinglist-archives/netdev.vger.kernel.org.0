Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202EE48D4DC
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiAMJOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 04:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiAMJMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:12:47 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F910C034002
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 01:12:38 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso4392248wmj.0
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 01:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9eVWPKFszyFBjxfc9/yhuv9HXCB5L9Mjwe4xyLGsHZQ=;
        b=TcpcHSYPtKCWa70bXBcRrJpkvUOGrBQCFeS9bSeicupmuRi/Wc/vjagaeNvO869dqu
         rOH2Jf9rD72ajvLdW9gQV+XsJ10ca1nQ+XwriEZ2Z5UxiUmc6drXwb7Avu0gmM2wHhsi
         FmdxqkuykXE7g4jSc4DEbrYEfR1wY5jAegI6azi/uodGqD0KImFNo2s0Cw0q7eLLfzjg
         4i1/U2TyoYIwaLFwAdRBilEml8u7OnOR9Xj6qB85WW/BbyVonlnPzhrG3oXlcvGHI76s
         FS1RpxrwHcgpSqSEwcfyhv8Sf7cGW+ltLU12nZykZj7ELt3pCDyIreFZdQuIEti60pnI
         0c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9eVWPKFszyFBjxfc9/yhuv9HXCB5L9Mjwe4xyLGsHZQ=;
        b=gZ2gt4GNY5gz9+++ZG/M3EgE71FyiJTFUxi/SB0ARrEWUoTyugTdEAa9J+6kXB0wcI
         N+ozdudrlcZyFmB8eiau/8N+O96rpSRGZAJvSzKKEuiVLANExhfirqbTwlF9Fr1EjjGW
         41kBhmK3eLw/8LiJNPoX7XPw2dE0lWN49qeXOdK90f/emZVVTCjdixIi1fEJ2x2K/5iJ
         TxdrSpIqKKQqRGXTgCBj4+GAZt+8YZCiwVFtMZdcKl2vRZ/D/hgMcXJH/CiPT+vcYxs8
         78HSnr9AMFV+uqHCYH0TrGlD5yncnG2347jeSk2uBLh9dveOtv69Hd+OLvlBzvo8os3R
         rV5A==
X-Gm-Message-State: AOAM53000BP9Vd7rLMAZVz8Ou24FKGHjeO8bperqnsGBvEBOUO6oNJWx
        k4Qad4tf6t/OF8VCdEO+7vmHfA==
X-Google-Smtp-Source: ABdhPJwwuk0lJd2q9B0XQRjlxLNr4+VHWmnHeE+pxSHGCjPezBRiTpnT1tTjk942qIhQTg+waquDYw==
X-Received: by 2002:a05:600c:3d93:: with SMTP id bi19mr60037wmb.50.1642065156503;
        Thu, 13 Jan 2022 01:12:36 -0800 (PST)
Received: from localhost.localdomain ([2001:861:44c0:66c0:bece:ab45:7469:4195])
        by smtp.gmail.com with ESMTPSA id m15sm2135702wmq.6.2022.01.13.01.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 01:12:36 -0800 (PST)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     Neil Armstrong <narmstrong@baylibre.com>, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-oxnas@groups.io, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] ARM: ox810se: Add Ethernet support
Date:   Thu, 13 Jan 2022 10:12:34 +0100
Message-Id: <164206502761.1011244.11952182860924885505.b4-ty@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104145646.135877-1-narmstrong@baylibre.com>
References: <20220104145646.135877-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 4 Jan 2022 15:56:43 +0100, Neil Armstrong wrote:
> This adds support for the Synopsys DWMAC controller found in the
> OX820SE SoC, by using almost the same glue code as the OX820.
> 
> Patch 1 & 2 are for net branch, patch 3 will be queued to arm-soc.
> 
> Changes since v1:
> - correctly update value read from register
> - add proper tag on patch 3 for arm-soc tree
> 
> [...]

Thanks, Applied to https://git.kernel.org/pub/scm/linux/kernel/git/narmstrong/linux-oxnas.git (v5.18/dt)

[3/3] ARM: dts: ox810se: Add Ethernet support
      https://git.kernel.org/narmstrong/linux-oxnas/c/ae552c33f6edad1097dec7a5543314d35d413b3e

-- 
Neil
