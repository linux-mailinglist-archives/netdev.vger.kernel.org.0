Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D504B91DF
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbiBPT4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:56:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238394AbiBPTzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:55:33 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4232B102C;
        Wed, 16 Feb 2022 11:55:20 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y17so5771693edd.10;
        Wed, 16 Feb 2022 11:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PD6yzCgOYpWVSwenJgOD3M2UZqs8pw6XfrocvAB3tzQ=;
        b=LW13VbLkwTWAZedb390gkobGLU9vJgjeSnIV+ZGYVYe26PJNMm7yXL4LjCeRv2Lg5X
         W1OVyibLduGH1TDCldY5uIkkMCuAFmSwwAGrATLjBGM0rkV4dNZCciBzlAs9FXJuKDzt
         a42VB6GOtSAAKARxnXVWWoLUa8+9hyJ4JFq68f8CkQZi+HBNlOAEIHfuZ6a7AUBVDUaq
         P+HFnmIABQejUZFNDj7/CgtECH8x/GOXxItG8tdmFPjy7F0qmfaoeiUOX331JgeRwjXN
         9lp+7kiN29bFKciIhvtQ/UevMttvbRBSn3bk7zRUeEeoe89Oxzae9a0UaHgJyO+rKtUo
         wEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PD6yzCgOYpWVSwenJgOD3M2UZqs8pw6XfrocvAB3tzQ=;
        b=4l7J42oZuI0yXP5FH8ZntNV5iREuq7ayVIzTaBD+hCupHrFo4UVg9r2CJENYc9KvJJ
         XZb0V5bkeDvy/ikuytaLr3w6CqujXdRAiDJcxIjPQZAqxVc+Aw6T5ZAd4ePbptJKc2CK
         a5DZqXRTtE8Y3w7vIEd+Ocim3x/sabMZiBlOh3QhRaX5lWN5IZ4EubAJu0pr91ST/HSB
         vjq+erp64WHwN5W9zfcWfAgpKL5RH599lcY1mLTjFDaaooM9ZhX47WovhVtQQAEnAilS
         /VOK/ianY/kfgRDZWZFO7XRyHOg4OJn7e5wA0FJ67MI6Agv8NFvwHUlxleHdGIZdePP3
         D4Vg==
X-Gm-Message-State: AOAM531+/OBec82zg1ImbkDIislYfBQYyo5VqlSMiK51V87l1uxHV0un
        7qFvqTgcz+zQZcWQT6vrLr4=
X-Google-Smtp-Source: ABdhPJwzX9rXztPm8dfsc3nzWcIwAAE+AuY4iJwnmgmrnaoHyGFSukZqgjH8Mhp/D9pIU+CXifMmyA==
X-Received: by 2002:a05:6402:b62:b0:3e2:a75f:b949 with SMTP id cb2-20020a0564020b6200b003e2a75fb949mr4770157edb.62.1645041319061;
        Wed, 16 Feb 2022 11:55:19 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id z5sm284783eja.20.2022.02.16.11.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 11:55:18 -0800 (PST)
Date:   Wed, 16 Feb 2022 21:55:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Mans Rullgard <mans@mansr.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: add VLAN IDs to master device
Message-ID: <20220216195517.o6dk64gwoe4sizl6@skbuf>
References: <20220216151111.6376-1-mans@mansr.com>
 <202202170327.RiXqUeGc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202202170327.RiXqUeGc-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 03:33:39AM +0800, kernel test robot wrote:
> >> drivers/net/dsa/lan9303-core.c:1095:2: error: implicit declaration of function 'vlan_vid_add' [-Werror,-Wimplicit-function-declaration]
>            vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), port);
>            ^
> >> drivers/net/dsa/lan9303-core.c:1111:2: error: implicit declaration of function 'vlan_vid_del' [-Werror,-Wimplicit-function-declaration]
>            vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), port);
>            ^

#include <linux/if_vlan.h>

drivers/net/dsa/Kconfig:

config NET_DSA_SMSC_LAN9303
	depends on VLAN_8021Q || VLAN_8021Q=n

and maybe you can access using dp->cpu_dp in the next revision.
