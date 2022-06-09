Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AC65455C7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiFIUis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbiFIUir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:38:47 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB33E96F3
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 13:38:45 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h192so16107258pgc.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 13:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tKUfONXQQwXPsga07z3EvKdZQeMsOdux4qmFEGXNMxc=;
        b=H+7A1iwbspykHHbX9k3HHXH4SumNS/7TudPkmDY5T7sYrO7GDaKFJ7RcW/rikWNKDv
         rIhcH+Vdl8mJv1ADH1cOkFBDyjznyosVXEe9O7YjlLAr35e/SgXNMCjmWkTPrkFNQEmE
         gnYG8r3scqyoawadH4IkhzeB0AVizTsyvTWtLrFMMI61SUYhbUM+YRVKzJmRE6/8l2tZ
         ML82fzcfyIXWZfYaIW4BClrnxuflTFCnuEAw8idzDPvAlDBa6qL88sX/aRJ93wL33Mfn
         NXYio1WpKqhWckkEQi3/W5O5V5++EeXMtDFAuuBP9nRToWC8TV9n3JCCGkFynRrtJf5q
         k0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tKUfONXQQwXPsga07z3EvKdZQeMsOdux4qmFEGXNMxc=;
        b=8BGJV8crr1j65Xc2TsniGfUqT3T4idRZi3u16mhWd4AtDta33F5AN+71PBywutnoZM
         bfOkBahrAvoMjzC9uQUPGyDikhd9SGINyTMEn8JHHwcKaAZP7GUfhn6clJIiwKQD7b+Q
         /raxYhpJU3i1NIAFZY3zO2OW1YiCWc23w2c+D1kR7ttRLbRxsxobhC3G3C6IOSNizx4V
         5n4kJ2m5bIEWbjGQU0BV1z6DCS76TAxBBlu9d7IEZHzvLnAueclVbibMnCSu6N8oLxfB
         lQA45z+rb5PAKOMWkPQTADIjIvNagJAm4drjF7uvAlsBV9fvWJqRmuIWnUNCWYD/b9od
         vHOw==
X-Gm-Message-State: AOAM5311GdLGXnvqQyHU+UhkmomiWZMaH4giole5MSZrFWzXfk+4ILBS
        STzFI+kgtLNbsJOHABK+6lM=
X-Google-Smtp-Source: ABdhPJzgYQOLgViUzlm4dqaegKQ9bJcFETbvoL4SJvDEcV93IGt6Ga3h+ezm/AtvJ9LyrdOV7Hu6NQ==
X-Received: by 2002:a63:84c3:0:b0:3fc:87ff:cdfa with SMTP id k186-20020a6384c3000000b003fc87ffcdfamr35553425pgd.460.1654807124841;
        Thu, 09 Jun 2022 13:38:44 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ev20-20020a17090aead400b001e86be34c98sm128149pjb.13.2022.06.09.13.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 13:38:44 -0700 (PDT)
Date:   Thu, 9 Jun 2022 13:38:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 0/3] Broadcom PTP PHY support
Message-ID: <20220609203842.GB26115@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 01:44:48PM -0700, Jonathan Lemon wrote:
> This adds PTP support for the Broadcom PHY BCM54210E (and the
> specific variant BCM54213PE that the rpi-5.15 branch uses).
> 
> This has only been tested on the RPI CM4, which has one port.
> 
> There are other Broadcom chips which may benefit from using the
> same framework here, although with different register sets.

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
