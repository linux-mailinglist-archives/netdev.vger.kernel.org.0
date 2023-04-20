Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21D6EAAC8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjDUMsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjDUMst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:48:49 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53134902A;
        Fri, 21 Apr 2023 05:48:48 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f173af665fso11452895e9.3;
        Fri, 21 Apr 2023 05:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682081326; x=1684673326;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0O+iUnFkEom6gWK+MZ7+krylv44gTYWpzuzr1YmZHYY=;
        b=XbqPjf2hmUz3tttYoPife86Z4NYJQh7rUanb9wsFr3mJgRoPFmmZ3ZjuF8KLxzhaA7
         kIOY4QobLWZ+CrQQICGrDe9nPjxCWA1hfrZSQ+6539+L3ykVFRMa+3vOFAREDpOT2dEs
         FEOYH7yMAxquLao3sl4lSAwVMds2ps1mCDe27lLDccH25X9LCJEK+z7h4ghIm62QtAwp
         5TVIZKZXDtp0EcQhfCgf1CO0u79fdHhBc/1NCSR4t6SnPDvdqL4zzkrafZtVx1pQ2jJy
         zf4Qm9FQxIc6umFm70UjFTjdoPGZbc0flkhdeMJqByUoPdEbf7tkmbpLUibGs6VZkN2H
         jq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682081326; x=1684673326;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0O+iUnFkEom6gWK+MZ7+krylv44gTYWpzuzr1YmZHYY=;
        b=dsVrgoRKXDTY1N5Flk0oHl6pp3VBeVozu3xuOCd/rQj81wKo4NJLeGyGlSHVlPwIen
         jFiHF6dEM3pV+9+rhNoHLUhCjqU1nqK46KtVjnRybszDrD84daQxHENe3rer9kO0lcH+
         h57teSljhRZjjGZrjlvJS4PL6Cb5/kGZP379swcDbUXq6rWRviyhXUYk8XUXqr48OMnv
         KLAybCG3k5yaIpZeMbxSbDQ9PydRqWxIogWmHYf/kVAx9LzogCxqwvpAMMvGhPL3Cwze
         yHgyi2667UnmNWBSeAh3kLv/KW6L+yiuKgG8cuMSC26CfExpBXEY39JTvzEaM3O81oXV
         5HRw==
X-Gm-Message-State: AAQBX9cnZNg3U/QovXwHuoN6LrIduhCcTxJlszOlcRNG2mAMhum+4hwS
        sH9Y5fZ1mZT4lPVpfLRCOAc=
X-Google-Smtp-Source: AKy350bbT1UTOdfcr+z4QH2/5ooCvQCHZBjvMfLLdOWALxCP/rzvVj/j6U8JDNwnfqs4k+coXDmtxA==
X-Received: by 2002:a5d:6407:0:b0:2fe:fde1:23a2 with SMTP id z7-20020a5d6407000000b002fefde123a2mr4383699wru.50.1682081326367;
        Fri, 21 Apr 2023 05:48:46 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id k6-20020a5d5246000000b002e71156b0fcsm4405414wrc.6.2023.04.21.05.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 05:48:45 -0700 (PDT)
Message-ID: <6442862d.5d0a0220.d3240.3544@mx.google.com>
X-Google-Original-Message-ID: <ZEGLmbgDwhfZaQc2@Ansuel-xps.>
Date:   Thu, 20 Apr 2023 20:59:37 +0200
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
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
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

Reviewed-by: Christian Marangi <ansuelsmth@gmail.com>

-- 
	Ansuel
