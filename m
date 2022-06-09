Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C57544242
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbiFIEBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiFIEBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:01:45 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408D21F9C8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:01:44 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 15so20042213pfy.3
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 21:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=62+PWQiLxPjZjQYgRhko08/Ww2TxqASYsuAZ9j7CFfs=;
        b=YytZSjB/mbEabrafnck2Z0amlWBP4vlIly+oI/4EgteMU6Kdu2nXiQngO2IVPhGhQc
         VxVXL3zGLhHk+srEYTqlhA1B6Z2z8MIqFo9+RFC8nzGrUaeDUM8ayLTLoZt7wPyv/DCa
         kbTKQ9llasNtpONKZSpAKqchTXx97r7HJOTt20UwpOtiRnHepUjfNjyFIMW5uCn+O3Fj
         7zkGcZVaEafh3TnNRj5EBEZVjxGoxa57HVfWVBDYGyPzfEVuztwClzpTcHcmsli0nqcH
         ++R6CWmBnV/5+RM/Lkz8AMXVHtUT5RMQjHPbH5l6yH2SAIBXvMLXP4eomRfZ+oqMnqYy
         p9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=62+PWQiLxPjZjQYgRhko08/Ww2TxqASYsuAZ9j7CFfs=;
        b=ggTQvZrXVL30mAqcyH5IkegK/RLWY4S0Ilh+pkeRxLkzhna13cHj/MXvzgsYzTFKmx
         8cPEVgCvWeWOp2hlIwCvUHKtTyD0JZN4+yst0z0AUVBFyRWxjTBfO7WZyUb5G7xqTm08
         9KNBkVyQK6c+EbOKJr+7aChGV155WvpLlEJ6GIKwfrJV4RFF3M/cEdUYCpk649letH5x
         reW7Bj5Jj9w5/SpRUuPKvA89bMf2nF/UDRNIZs3/aFwONeYtXg0kEqeUqkzbmpTTj9jV
         NArZlB9ALD+LBIRRYdTe9bBNfcnt28kdIhzwoyuX3KWQIEA7J4cVP8kZLJaKz3oUJ4SP
         psdQ==
X-Gm-Message-State: AOAM530AfCf6JhcoexA5kpCJhbb8mniPlHfufv0JR2VN1iqkSKB2Xy0L
        RUnfydB7rb4DZptOvROQlow=
X-Google-Smtp-Source: ABdhPJxR/4O/CCYyF/boaSLknWj+u49IrCYZx4ezm/CeRP2NLVb+prjrBVXZbYtWsLKEvGP3UAh7nQ==
X-Received: by 2002:a63:8941:0:b0:3fc:7efa:119d with SMTP id v62-20020a638941000000b003fc7efa119dmr33383239pgd.340.1654747303787;
        Wed, 08 Jun 2022 21:01:43 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 205-20020a6216d6000000b0050dc76281f0sm15854527pfw.202.2022.06.08.21.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 21:01:43 -0700 (PDT)
Date:   Wed, 8 Jun 2022 21:01:41 -0700
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
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220609040141.GA21971@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-3-jonathan.lemon@gmail.com>
 <20220608205558.GB16693@hoboy.vegasvil.org>
 <BCC0CDAF-B59D-4A7A-ABDD-7DEBBADAF3A3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BCC0CDAF-B59D-4A7A-ABDD-7DEBBADAF3A3@gmail.com>
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

On Wed, Jun 08, 2022 at 02:29:15PM -0700, Jonathan Lemon wrote:
> Do you have a stress test to verify one way or the other?

You can set a large freq. offset on the server.  For example

   phc_ctl eth0 -- freq 500000

for 500 ppm and see what the client does.

Thanks,
Richard

