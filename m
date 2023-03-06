Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933E76ACCDC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjCFSn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCFSn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:43:26 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558D52E0FB;
        Mon,  6 Mar 2023 10:43:25 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p26so6282597wmc.4;
        Mon, 06 Mar 2023 10:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678128204;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9howz/MYIxQFOTkjG2sZpdC7yu6HSX7t+4kJG+A428w=;
        b=RnYzgl5WppeBICyY1Qmu1aiUrbPL0PnHOWQqqLHOo6Oa8WlLlBB3H8ipoPvJsND8NL
         +AqUgw+/V2JVJ4I0dnK1gAaYDtM2lcMCjU4fLKUOLyagYv63UPbPk6yL4a0qbbic3uVl
         wgf4ldWVweQlmgN6hGD9PKYh37kyyh4VBQDIn6jbuhVMlqq+GRv8Z79RNhjO28JEhcxQ
         pZSYbgJHyVerQBR13/kqTrDp/MOUt4XB2kVkeF3hcMdt5HK2R3MNxxlsNkWV60PM8PS8
         zRqtwE3CLnmu+UOlA7BiWYRMep8EbKDTd7hTdT8ENLJo1ib46CIXo4GcSWOz9KtKcEwn
         Ammw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678128204;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9howz/MYIxQFOTkjG2sZpdC7yu6HSX7t+4kJG+A428w=;
        b=bts/DOMgHdrXGYTRUfWEQdNIBnZZDqeC70h+ZNYBRYcPIa2FDwBO325sJ5O2aukYp2
         otTzdVXdsxB0VlfVtQzOeO4mHdrVQBlzXh8z1Ix1mMykBJRqdgwYXvsqeG7MBUwmeViy
         WpYaRowH0fIb7s3TIX14w8WBaAXe0UPm6/iwvsmSipPoEVVgPkDDLvp3K2k9Vir3HLlj
         xIPYQPrZXLQbEO+K1Aq4fl00CB/Oy1maMqS1nZCaGgUbwey1X6dgu9nwyMK4kWDQIARC
         x6qPErYHtZQpSp0vdAGTD3dvyeL4ocnO7qbBQSu7N2m/aIhAMyJsaGLRCEnJYfd3caUg
         0GKQ==
X-Gm-Message-State: AO0yUKX00Cj6f22maIWASb8uYsnWr2V3vQSurPjGo/mDoYz10N+8hplT
        BTMm+tuMsYvhjBF0XsRwt+c=
X-Google-Smtp-Source: AK7set9ocXY79rQCq8kdmSs3rFvVpcdzSuqw0hZ/yLMPPrZfSYmrWzRcwSyRFmjA6ou8n26+wR5neA==
X-Received: by 2002:a05:600c:4f87:b0:3ea:d610:f059 with SMTP id n7-20020a05600c4f8700b003ead610f059mr11280986wmq.4.1678128203504;
        Mon, 06 Mar 2023 10:43:23 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b003dfe549da4fsm15761153wmq.18.2023.03.06.10.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 10:43:22 -0800 (PST)
Message-ID: <6406344a.050a0220.693b3.6689@mx.google.com>
X-Google-Original-Message-ID: <ZAY0SzbzIgRH1oBa@Ansuel-xps.>
Date:   Mon, 6 Mar 2023 19:43:23 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Lee Jones <lee@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <Y++PdVq+DlzdotMq@lunn.ch>
 <Y/YubNUBvQ5fBjtG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/YubNUBvQ5fBjtG@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 03:02:04PM +0000, Lee Jones wrote:
> On Fri, 17 Feb 2023, Andrew Lunn wrote:
> 
> > On Thu, Feb 16, 2023 at 02:32:17AM +0100, Christian Marangi wrote:
> > > This is another attempt on adding this feature on LEDs, hoping this is
> > > the right time and someone finally notice this.
> > 
> > Hi Christian
> > 
> > Thanks for keeping working on this.
> > 
> > I want to review it, and maybe implement LED support in a PHY
> > driver. But i'm busy with reworking EEE at the moment.
> > 
> > The merge window is about to open, so patches are not going to be
> > accepted for the next two weeks. So i will take a look within that
> > time and give you feedback.
> 
> Thanks Andrew.  If Pavel is still unavailable to conduct reviews, I'm
> going to need all the help I can get with complex submissions such as
> these.
> 

Hi Lee,
thanks for stepping in. Just wanted to tell you I got some message with
Andrew to make this thing less problematic and to dry/make it more
review friendly.

We decided on pushing this in 3 step:
1. Propose most basic things for some switch and some PHY. (brightness
and blink_set support only, already supported by LED core)
2. A small series that should be just a cleanup for the netdev trigger
3. Support for hw_control in the most possible clean and way with small
patch to they are not hard to track and understand the concept of this
feature.

I'm starting with the step 1 and sending some of my patch and Andrew
patch to add basic support and I will add you and LED mailing list in
Cc.

Again thanks for starting checking this and feel free to ask any
question about this to me also privately, I'm very open to any help.

-- 
	Ansuel
