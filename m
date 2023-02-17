Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573A369B554
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBQWNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBQWNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:13:19 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3456F53EEF;
        Fri, 17 Feb 2023 14:13:18 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id e4-20020a05600c4e4400b003dc4050c94aso1939522wmq.4;
        Fri, 17 Feb 2023 14:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s8Cs+D1dNRVvU5FZhA9NdvKWxN01yyeYmicSt7fW840=;
        b=ZtOpor/tIoioJVDeaEsupf5C46Ca+I22u8Zl620GFn4Yfyzx4z61zXzY2BzQv8fJQ4
         YZ+a3oTwU/d5AMztC924vr8S6e7d6ZKdnMPnw1fz9PjxMhYXH1IbZyuQ0/lw4jQbw3EF
         swOeB9owdWhyT9ISN5fLmRFuXeWL49A4KpBZxrgTgLGrYXjvBwswiQ3H0IgcOui8KqF5
         75TR+lUllD2cRT/vNOMJjzXEP4b6qZch0blElpQpNtli9bzAcCG5DLvEZ0QY1wt7jWRq
         e6tJ6jvqZac8igTHvxo6K0LBP649TpUyPC6NoGwB23h/LnkzisjEgG7L2kSTq4+LmWws
         A61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8Cs+D1dNRVvU5FZhA9NdvKWxN01yyeYmicSt7fW840=;
        b=1hojA0cRBf8NsT7EJ6wHSNu0aRBuQys5W26MazJoV3nBuZydQCRzIGthZe9w2Rc72w
         zLF3nP32hmlLMhsym5A6Tb1xUpCqQP5KPwhMFa5IoU94PJ6SBaVQSaSmCanckFuLfy9T
         zz5STCsjdu+N9IMYOV0wjQvbgPnxEl9j2jGTQxsFSBd6I9OyjzqZfyWI0C4i620QXDDN
         0DdZ1pL7G8YJ9OmrPPI0MVvFvgK0YZHlke+u2k0XSEtNs1XFzX6Y4Pcr35yp5TJsJ2bp
         /W29xhVBOK/F7Hx4ORidBAN5Ij8Foc8elBlptBKN3hHpko4oqylg2UkRt/FY41IWm2Uh
         syxg==
X-Gm-Message-State: AO0yUKWxLdcxncZ5ecvJ59QvH2UTWxs77dzZV0bh5ofMWVPHJ5I22M3P
        R914IOi1ciOQsgmlBexpEflQvqDa3UM=
X-Google-Smtp-Source: AK7set+qH0WimBUCqvuGrBjkIyVNTwjx96FysdQp2U2Hu7V5sBpkmHWGms50WTRGDkiqauhQIzzXsA==
X-Received: by 2002:a05:600c:43c5:b0:3dc:557f:6129 with SMTP id f5-20020a05600c43c500b003dc557f6129mr2099290wmn.2.1676671996347;
        Fri, 17 Feb 2023 14:13:16 -0800 (PST)
Received: from Ansuel-xps. (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.gmail.com with ESMTPSA id n6-20020a05600c500600b003dc433355aasm6479927wmr.18.2023.02.17.14.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 14:13:15 -0800 (PST)
Message-ID: <63effbfb.050a0220.3dc6e.3732@mx.google.com>
X-Google-Original-Message-ID: <Y+8KOiu8UqQ2DZHR@Ansuel-xps.>
Date:   Fri, 17 Feb 2023 06:01:46 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y++PdVq+DlzdotMq@lunn.ch>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 03:30:13PM +0100, Andrew Lunn wrote:
> On Thu, Feb 16, 2023 at 02:32:17AM +0100, Christian Marangi wrote:
> > This is another attempt on adding this feature on LEDs, hoping this is
> > the right time and someone finally notice this.
> 
> Hi Christian
> 
> Thanks for keeping working on this.
> 
> I want to review it, and maybe implement LED support in a PHY
> driver. But i'm busy with reworking EEE at the moment.
> 
> The merge window is about to open, so patches are not going to be
> accepted for the next two weeks. So i will take a look within that
> time and give you feedback.
> 

Sure take your time happy to discuss any improvement to this.

-- 
	Ansuel
