Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA926C909
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgIPTCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgIPRst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:48:49 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0277C0086BD
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 06:44:59 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so3121142wmk.1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 06:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4dl2E36IT++Epfaf89pf4ocS2i76rCOis/+URY5PLmQ=;
        b=FPK/6jzmYFbA+D673b79HCVgLqvHTYf/fbXTB3/wEVBKsD3TjfAL2Ysp8udcHucQmH
         ksOMEe403/ORGrd8qmCWb9XVg/tMbdUYvTZSsi16bDZRxZcFP8VKwFJxcv6ByjsCcuGd
         qpXDgMXHKcZJKmXEOuouiUcIDBcAxSPSBPoMQcVhQc5/eHUCevr3ADjvFoR7zHEOJzVw
         BAfrA0QyiRE1FY6vbRYHf+oNpVTMcnTInjEqvHAQgZO2+D5ISCre/PtxF2BrnPLtUcup
         wIBNz/2NzpQMFp+Mgkg+ZExTyQxBX4vei9FZ/a4mdxnnGjBh3hMAljhqsd7CuUn+56c8
         ryxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4dl2E36IT++Epfaf89pf4ocS2i76rCOis/+URY5PLmQ=;
        b=r0Px1bs9dGWAKHIHNqgCqI2UUbI7Q/BNGlqkbuU6CUvGdyDFjIJt/Nx+r10zCtUlbB
         JfGmQe7VwaV/1uIfET1xJTTGXW30ik+f1gVFKH/ankcbDUyNVFa4vLfrri6ARvgVG42n
         6w3ZkiO7NmXjN3LRxiWiJwrEDcuhMGGm+9dZotP/QyEEaXXrD19Ey35/VRHKZOO6piFh
         AQXDTFqCkzd2wqmyWdUy1VrnwUui1tD/67mLomHsvFDlNE54ejVfH2TIpSZ1/IcCUz2e
         JgJC5Siyve72rsUvuv8xsIAavuRJLOzbXtU2nHl6F5IhFg677jGbFQNsFEL35LyT85TB
         ygHQ==
X-Gm-Message-State: AOAM531NfJFPCgdVBJNhE2o7IadA4rlnqnO2mK42eOhvDEr8UXrPx7VU
        i64xKIUM5arUMHl8tL84dZlPyotZeKdc+w==
X-Google-Smtp-Source: ABdhPJzIStvqGlvQyfrjasZ1DnHHZ9nJu8xB5ntjy2TO3DIc6VErhfegcv/LA1Hbwnd1PFEqlvlZkA==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr5123028wmc.154.1600263898338;
        Wed, 16 Sep 2020 06:44:58 -0700 (PDT)
Received: from dell ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id z7sm33064936wrw.93.2020.09.16.06.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 06:44:57 -0700 (PDT)
Date:   Wed, 16 Sep 2020 14:44:55 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Allen Pais <allen.cryptic@gmail.com>
Cc:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de,
        keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH 10/16] wireless: intersil: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20200916134455.GD4678@dell>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
 <20200817090637.26887-11-allen.cryptic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200817090637.26887-11-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020, Allen Pais wrote:

> From: Allen Pais <allen.lkml@gmail.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly
> and remove .data field.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
>  .../net/wireless/intersil/hostap/hostap_hw.c   | 18 +++++++++---------
>  drivers/net/wireless/intersil/orinoco/main.c   |  7 +++----
>  drivers/net/wireless/intersil/p54/p54pci.c     |  8 ++++----
>  3 files changed, 16 insertions(+), 17 deletions(-)

This patch seems to cause several warnings along the lines of:

drivers/net/wireless/intersil/hostap/hostap_hw.c: In function ‘prism2_init_local_data’:
drivers/net/wireless/intersil/hostap/hostap_hw.c:3185:48: warning: cast between incompatible function types from ‘void (*)(struct tasklet_struct *)’ to ‘void (*)(long unsigned int)’ [-Wcast-function-type]
3185 | do { memset((q), 0, sizeof(*(q))); (q)->func = (void(*)(unsigned long))(f); } | ^
drivers/net/wireless/intersil/hostap/hostap_hw.c:3187:2: note: in expansion of macro ‘HOSTAP_TASKLET_INIT’
3187 | HOSTAP_TASKLET_INIT(&local->bap_tasklet, hostap_bap_tasklet,
| ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intersil/hostap/hostap_hw.c:3185:48: warning: cast between incompatible function types from ‘void (*)(struct tasklet_struct *)’ to ‘void (*)(long unsigned int)’ [-Wcast-function-type]

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
