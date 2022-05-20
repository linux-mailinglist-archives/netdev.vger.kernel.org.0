Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07F52EF81
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351008AbiETPoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351027AbiETPow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:44:52 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48D9179954;
        Fri, 20 May 2022 08:44:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s3so11269166edr.9;
        Fri, 20 May 2022 08:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tyAvoowTXKVugbeaK0IDb8Jhhf+Ac8sQHfcbSHM1+DY=;
        b=U3Oz7mJ0qB82lCiUVGtcl3niwlBbDf/kFwJTZU00ucufE5c8kP79Aqv3QfI0/RGQ7B
         XPx1KKENFfXsHccA/mOicip/C+HH3lI025Mv3nYcwOhi6RfEiXaO7X3hWpN3ta5b5Bz5
         o5VTjmEA+9GUj6ijkFblZfG+r7w1dC5YEiIsTJwzN5lnSoUHp1NQWwRhT4lJIBPV6Ko/
         Zx2O34DNuKXjfBz+0hue+8JT2/svCyN8ExwJ3DExjfysAsk/uxA28CYK+CKkh+tdQ4iE
         WX8/GS33V7SY2ru1GTv8Co7ZVqDi7DQIjc/OKxB599V0rfWGe1PEWaCh3t5hbMMg3HZB
         i+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tyAvoowTXKVugbeaK0IDb8Jhhf+Ac8sQHfcbSHM1+DY=;
        b=KDA3jghOean+TCFIvc4+9clvt93LpYwDx7Je7VU0HulzrkmPWS2yCuM2k4In0TaCDO
         TTl3yVA6mCwQt7+KGeDL0yQ7zWF8kIlgVjci9gkS8EvJnfGBoP26ej2ky/nQP6Y7i8Lg
         5eC9GDxHjE2mzQowRTqQFEDWzmgLywHF51nLd16bOGxu0HOxB0bjaPCHIPqncUSHmirw
         U5qGshWmorGMKePX9IFz+IJDLtAHTQdVrsseN+aDn2rkfPP4ax0JNXLwl9q/D/7F99tk
         63L3/jkt0CVno497NYJ4UG+oIkUODyCIoZOtwTOyoHV+dbyofDz/qAFPBASUaEjytcHB
         d3Zg==
X-Gm-Message-State: AOAM533ysGsHOCg+nEMYV8MoQbIrxdWsK/pIwnelwaU1CgKoI+qPoz0x
        J2J6YkjwF84t44wkA8OB0bc=
X-Google-Smtp-Source: ABdhPJwXaWWJpYmaGjXmAB9fG+OPzFSP7uG/+reinHUqy4s8FyzZvIxfPjmEolawLHcG8V2ncK+uqA==
X-Received: by 2002:a50:9b0d:0:b0:42a:4bda:c70 with SMTP id o13-20020a509b0d000000b0042a4bda0c70mr11731951edi.287.1653061483138;
        Fri, 20 May 2022 08:44:43 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id dq20-20020a170907735400b006f5294986besm3266593ejc.111.2022.05.20.08.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 08:44:42 -0700 (PDT)
Date:   Fri, 20 May 2022 18:44:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 05/13] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220520154440.jtswi6oyjpseffpu@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-6-clement.leger@bootlin.com>
 <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
 <20220520095241.6bbccdf0@fixe.home>
 <20220520084914.5x6bfu4qaza4tqcz@skbuf>
 <20220520172244.1f17f736@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520172244.1f17f736@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 05:22:44PM +0200, Clément Léger wrote:
> Le Fri, 20 May 2022 11:49:14 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
>
> > On Fri, May 20, 2022 at 09:52:41AM +0200, Clément Léger wrote:
> > > > Also, as a request to unbind this driver would be disasterous to users,
> > > > I think you should set ".suppress_bind_attrs = true" to prevent the
> > > > sysfs bind/unbind facility being available. This doesn't completely
> > > > solve the problem.
> > >
> > > Acked. What should I do to make it more robust ? Should I use a
> > > refcount per pdev and check that in the remove() callback to avoid
> > > removing the pdev if used ?
> >
> > I wonder, if you call device_link_add(ds->dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER),
> > wouldn't that be enough to auto-unbind the DSA driver when the MII
> > converter driver unbinds?
>
> I looiked at that a bit and I'm not sure how to achieve that cleanly. If
> I need to create this link, then I need to do it once for the dsa switch
> device. However, currently, the way I get the references to the MII
> converter are via the pcs-handle properties which are for each port.
>
> So, I'm not sure creating the link multiple times in miic_create() would
> be ok and also, I'm not sure how to create the link once without adding
> a specific property which points on the MII converter node and use that
> to create the link by adding miic_device_add_link() for instance.
>
> Do you have any preference ?

The simplest (although not the most elegant) way would probably be to
pass the ds->dev as a second argument to miic_create(), and call
device_link_add() multiple times, letting all but the first call fail,
and ignoring the resulting NULL return code. Maybe others have a better idea.
