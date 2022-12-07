Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0CE6457E7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLGKdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLGKdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:33:19 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9007926493;
        Wed,  7 Dec 2022 02:33:18 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id t17so12955469eju.1;
        Wed, 07 Dec 2022 02:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AQ+rKetvs9glfZtSdIu3eRMWCUE4jvDtp/rzk0nJvKI=;
        b=YdolyPRyLIsEN2zsOpZG+Qd//a3Z7C5QysDCkHOVs0KWBWQ8yFbRHlc2qCvgMo1tCn
         B6EO/GG3zpKC/qb9zRoGm70zUhZnIjBb9BE9YB1kH0XppZrS3cVKLPC/afoe9juXJDPN
         7OOkZUb5HYhy6cNQ6uGiVfibHvEF2bKz1TxnnVk04y3idum5RlVyR34ZYEkEhuOt7TW9
         90HklIQ7nS4HoM8DD+wCLkYUFJ/88Vr2xMJQYU4kGLyai+eeytkZUjCEffTR2IDvZ1am
         75nVe5I+whO3FDNVFpid7UJT9//wEXjRPFTa8XlnQqqtRKoWmAHEJHv9aAi97VVfbRl9
         woQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQ+rKetvs9glfZtSdIu3eRMWCUE4jvDtp/rzk0nJvKI=;
        b=E0108StwmW5YUy6vQzt/NYiFfvDHNlkRMRW1MQu+lbMr3I/nTMhvyor4CAS6r9cJ5S
         dB7KXDzk/1ACUVsuPJDwIBxQw1p+Cg1/EQ9h2VJXknbUP8/1dnX/hkjCqlakIo7t0lUG
         IoQubyWO5erzHex5VNORC3dQJS/o+/Y49R4IwH2v+bXhFqmbcN+IlOsUnyhSJI1CfR+8
         WTxINFNo1a1IqxqwMvMOwECMlt8hUTLhWG+36xKQzzm+xKA4E4qGmrQ6eTiwHysTkXed
         GD3rVoxPYtX9JsrJ/0ePxN0rjsqUUDHVIuTBB1LoIhFxGXTeV2Gs5rkKgiZNbvMMxg/3
         EkuA==
X-Gm-Message-State: ANoB5pnbe/WVUmFgvfe21HvlxxgYoCnuOYHch3RaGcM56WPKOOgggY+d
        vfcc0QHS1jCDUWhVtdM4FXA=
X-Google-Smtp-Source: AA0mqf4tAOYrTuQuGHDqsGS5/EEoVpbDZyPxu0SwpOgq9cNr/W+w7nHyyd/JIfoPsYjGqALYo7pNNQ==
X-Received: by 2002:a17:907:6744:b0:7c0:8d04:d1f1 with SMTP id qm4-20020a170907674400b007c08d04d1f1mr30228920ejc.208.1670409196916;
        Wed, 07 Dec 2022 02:33:16 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id i16-20020a170906251000b007c10fe64c5dsm1528574ejb.86.2022.12.07.02.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:33:16 -0800 (PST)
Date:   Wed, 7 Dec 2022 12:33:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, linux@armlinux.org.uk, ceggers@arri.de,
        Tristram.Ha@microchip.com, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch net-next v2 06/13] net: ptp: add helper for one-step P2P
 clocks
Message-ID: <20221207103314.rmmh5halvcsugute@skbuf>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
 <20221206091428.28285-7-arun.ramadoss@microchip.com>
 <Y49v73+Hg7x3JhFS@hoboy.vegasvil.org>
 <27ed1d631d1c804565056c4ff207dc66cfa78c80.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27ed1d631d1c804565056c4ff207dc66cfa78c80.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 04:15:04AM +0000, Arun.Ramadoss@microchip.com wrote:
> Kindly suggest on where to add tag, before signed-off or in the patch
> revision list.

Nowhere. Just do it if you fix a problem using the robot for a patch
that has already been merged.
