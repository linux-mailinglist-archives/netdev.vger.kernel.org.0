Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55322543DCD
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiFHUuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiFHUun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:50:43 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82043EE8E5
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 13:50:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g186so11132225pgc.1
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 13:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Dg4kiVBHxFqbs5dhBwOYmopbK+1eNN0B9eaH2AOaok=;
        b=HHE8nvYlNUgLEbPUJRRNw/lWsRwqbbXAYzFawhObGR9RU45yR9FinjcxCSyt+oOi7I
         HbF6b6zTaBJunmb70wtttY4os6v0DvVhw2NDRNJ0o8/kUgoR2fTF+KMdkjcQ/mXKnpTs
         F0RGGLyM8oHdwrSq9zgewU0L+204T0GGVWZFeoWgFrtJMPvbyKAehh8Rz9XuMXYQMfy0
         88K9APLBmo8s6L3gbhVIY9IVpc9zfMCnhsa0UCOSi9I65RiqabHDEgeLyEKSOYYREs1t
         Z2b9F06kg6GQn0nWGupLVcUzcoCm6Ogjz1PmAxE0eYFmtIgKmgXK8nr+CJnPNba+FTbx
         79qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Dg4kiVBHxFqbs5dhBwOYmopbK+1eNN0B9eaH2AOaok=;
        b=BoUR6OSzqbo2FtD1Ou6he1FZRGYXTWLUEVo0LHXhIGfAYWYhM48Fg8kgAemNMYqEXd
         MvSL07Q+M7ojx8qwStD4g5oIEyILPAET3DIAyDQt79gdTydQHYwPzVJ+bkd+WD/OZBGg
         N6oUNAl0ixLjppkr16krPoFMnPyuKDyqaYDQ1NApj4jNOWIPOUj4mq+7U71aiqQB/+Tl
         DbTlYSD/1QacK1AYJiZw+baxLuU/0utS1nSodaJhuJ0bLQ/rcEUnMXADuDjJUEX4tWhd
         AZsqWHLmZkc8SF4CTs1w4v63VinfR39Z5oVN2zR4c1YXuoO1fR3FK4bw81JnAdcX6Fbm
         yFaw==
X-Gm-Message-State: AOAM531J0jX60/CKcET6BZchOdTDqxKZSvWHnCztq0q/8o8WzjapQh1A
        cDHDPU7yv0wZqIwZh0+5jo0=
X-Google-Smtp-Source: ABdhPJzV6dLnSCrq98qO2xF1XcLtBxKmWzLq0/PbZNLtjbZ/isA8g7x/MFNkxAXTQECj+GBltGhcJg==
X-Received: by 2002:a62:6144:0:b0:51b:99a7:5164 with SMTP id v65-20020a626144000000b0051b99a75164mr35974916pfb.61.1654721441980;
        Wed, 08 Jun 2022 13:50:41 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g85-20020a625258000000b00518142f8c37sm16007154pfb.171.2022.06.08.13.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 13:50:41 -0700 (PDT)
Date:   Wed, 8 Jun 2022 13:50:39 -0700
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
Subject: Re: [PATCH net-next v6 3/3] net: phy: Add support for 1PPS out and
 external timestamps
Message-ID: <20220608205039.GA16693@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-4-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608204451.3124320-4-jonathan.lemon@gmail.com>
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

On Wed, Jun 08, 2022 at 01:44:51PM -0700, Jonathan Lemon wrote:
> The perout function is used to generate a 1PPS signal, synchronized
> to the PHC.  This is accomplished by a using the hardware oneshot
> functionality, which is reset by a timer.

Is this now really in sync with the PHC?

(previously there was talk about it being random phase/frequency)

Thanks,
Richard
