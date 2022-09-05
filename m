Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624425AD7F6
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiIEQ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiIEQ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:59:24 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0613BD1;
        Mon,  5 Sep 2022 09:59:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso6035764wmb.0;
        Mon, 05 Sep 2022 09:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=kBO13UtRr0SWrtmik6tjpAxMEsZ+XRCQYT/mFBGsQKc=;
        b=KNmRwCLYZ+pCTjK/ihObgilSV3xmsKUdKpr3KFr16T2CzyNWIef12SH5Z65EDv5MGr
         2DnoPgB0nkKemCgkM/c+Ras2uY1v5FXRzolHuZVqswtY+dPnQfKiasXeHjW+0TT+Om1Q
         tQ9eBco7SDbgZU6BPJGNagW+FqWqnLBC1ws2v3fzoKWLkuGCnRR6N1/0vq/OaowuzQ/0
         Ey7Y0+d41mP9GJW+l0takmtQxIhmUaGMNifHlxujveck670qWRl067a62egdcDsYQUmZ
         +xy11pPq0Zax3uBa80j+x3K0HtMYKOP0DpHTl2tdRo2gjtOeqAGx4nMs3bqUsvOfNAx3
         myrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=kBO13UtRr0SWrtmik6tjpAxMEsZ+XRCQYT/mFBGsQKc=;
        b=m3iw/BuHgmJb8e39n0B4bXnw7c/cDJPuase159/O2aLiLhlTtZ+u92tlI2lYmTdNOH
         REPE+e4XfTbM/u2MgUoBTKEb3lfawqH4klZ+S7jz8hdiA7P6RLM5lf3o1k1MCr8KQzHr
         9DUEnGC90sehvYKb9rqoksPmSIb/GgTjr0ftTMJI2c4RCgAyr4uMwaU8uWp5b6ab5YyW
         YjYjN+EApwzJDsxp0/GLEs9c2zJikVQX7j1z4dBg9I0PqRAYjZmk/dK8BhhbR5U9M0Kg
         dg+r9BFckpwgCun0qxd2AQ2rsd9XGI0TTXvXAzrWBk+gMyyYLk9LcC9OWm6qgBFHB0tj
         AJhw==
X-Gm-Message-State: ACgBeo3xK7vFwjpTwOsY58zun46JqZBPasC3sC5bm0K1Y0bJSCKZ8ZU4
        rKCC+puAFklZ+FYBMcgtdt4=
X-Google-Smtp-Source: AA6agR5SqvwKydijnR3iFbl7xo1zcpxxo2RQPkvLlwEPeQg/MTRp9RYxPTJDLf9ntbeEQn9s98HGdQ==
X-Received: by 2002:a05:600c:3c94:b0:3ae:ca8c:acfb with SMTP id bg20-20020a05600c3c9400b003aeca8cacfbmr4702026wmb.199.1662397161290;
        Mon, 05 Sep 2022 09:59:21 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c4fd000b003a5c999cd1asm14742926wmq.14.2022.09.05.09.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 09:59:20 -0700 (PDT)
Message-ID: <63162ae8.050a0220.8ac07.db3e@mx.google.com>
X-Google-Original-Message-ID: <YxYq5oF15RXKmGqJ@Ansuel-xps.>
Date:   Mon, 5 Sep 2022 18:59:18 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH] net: dsa: qca8k: fix NULL pointer dereference for
 of_device_get_match_data
References: <20220904215319.13070-1-ansuelsmth@gmail.com>
 <20220905165039.vcgqwjpyoy2eqlsp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905165039.vcgqwjpyoy2eqlsp@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 07:50:39PM +0300, Vladimir Oltean wrote:
> On Sun, Sep 04, 2022 at 11:53:19PM +0200, Christian Marangi wrote:
> > of_device_get_match_data is called on priv->dev before priv->dev is
> > actually set. Move of_device_get_match_data after priv->dev is correctly
> > set to fix this kernel panic.
> > 
> > Fixes: 3bb0844e7bcd ("net: dsa: qca8k: cache match data to speed up access")
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> Did this ever work? Was it tested when you sent the big refactoring
> patch set?

I have to be honest here. I feel really embarrassed about this.
The short story is that the refactor was tested on Openwrt with 5.15 by
manually applying the changes. This fix was applied there but I forgot
to put it in the final series.

I notice this mistake only now that I'm backporting patches and the
manually applied fix was reset.

Again I'm really sorry.

-- 
	Ansuel
