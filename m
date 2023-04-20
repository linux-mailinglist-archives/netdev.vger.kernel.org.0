Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FDF6E9E28
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjDTVy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjDTVy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:54:28 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7871C5FCD;
        Thu, 20 Apr 2023 14:54:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f18123d9f6so7510775e9.0;
        Thu, 20 Apr 2023 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682027654; x=1684619654;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ggoiuYDGVHOJoDD7tvjEcAbvbz7tn3leV5QHJEbfn1g=;
        b=iMeISl8K+VZoGclhUVPpOIpilYNz8C3ApXwTpyEARL9A2XRDDX43zMMELs8WZlblUd
         HQuCnDMz5XNz9PEH7fV+hVuJjYR7MXm9s4fyyECxaOMAg7FldS3S0NIYiBhXBNoEVSMN
         mDIN7gsqeh5T3pexxyXnc/1MJnc93kg2E6UOnDWt4SEbl9LWqgANi61b7UzBOEIE2uwp
         Gv8hAcjAD6cr3t+v79MGyVKNF2Y1csxSy0hEIdvMwoIs6chcO4zBmQFgCxZeRxtIlyMp
         bmLuw4A4x9uCPzvgG+rSeF3Vgxx7SMjCCBbA8xez04/g7tablzI5jK5Ce4MwdG6tdReN
         kxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682027654; x=1684619654;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggoiuYDGVHOJoDD7tvjEcAbvbz7tn3leV5QHJEbfn1g=;
        b=A2lpVQwjzN9zzfhNVTwpiT1/QkRMDd5FMTG2EFD3jUHcfkX5WJiCT1MA4+upgWUf/g
         9fzeo9DCyBg20PrjEtu5/iTScnVAhU4ZBSIVq26OY6WiPgOpM29/a9kdbkbu3b8faOGZ
         KdUzN6ffR0c9tRjaMiM1InuBwezFbTm3yYp9SCa7dD+HXsZEL9kYt95vTQgVX+wUhVu6
         99up9EtwcaGHeb0A9o2zguM2QtGCMSnWzoCmaRx+AhBVSpoA7kmCqNOsR99j9ov7Q58p
         JSSkE14gkdfdWAkYt9fnLKzFw/z5hxvLRK6XxzeaTGs67CAbZeKzJ3dvOil3LaRujQ4M
         AzGw==
X-Gm-Message-State: AAQBX9chNDuMBIqrwr2bNgL89snsQhiu5LHR83dpGzTIqkkYENtlA1i1
        hByjw1cJpLUCKLvsxH/AVjo=
X-Google-Smtp-Source: AKy350bC0BUeb/cTv5JM0LvDfl2jp90QrC26SaXcRQBVMSSVUYg21MGBTzfaFWPkMzrKWwWC4jSgMA==
X-Received: by 2002:a7b:c356:0:b0:3f1:6f4a:a3ad with SMTP id l22-20020a7bc356000000b003f16f4aa3admr264117wmj.2.1682027653658;
        Thu, 20 Apr 2023 14:54:13 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id iw18-20020a05600c54d200b003f174cafcdasm6454001wmb.7.2023.04.20.14.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 14:54:13 -0700 (PDT)
Message-ID: <6441b485.050a0220.30245.0b80@mx.google.com>
X-Google-Original-Message-ID: <ZEEsgxcLN80qrjse@Ansuel-xps.>
Date:   Thu, 20 Apr 2023 14:13:55 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: fix LEDS_CLASS dependency
References: <20230420213639.2243388-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420213639.2243388-1-arnd@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:36:31PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> With LEDS_CLASS=m, a built-in qca8k driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/net/dsa/qca/qca8k-leds.o: in function `qca8k_setup_led_ctrl':
> qca8k-leds.c:(.text+0x1ea): undefined reference to `devm_led_classdev_register_ext'
> 
> Change the dependency to avoid the broken configuration.
> 
> Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks a lot for the fix and sorry for the mess...
LED_CLASS and PHY releated were really hell also for some reason this
didn't got flagged in month of this series.

Again thanks for handling this!

-- 
	Ansuel
