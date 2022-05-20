Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401E952EFD6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbiETP6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237537AbiETP6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:58:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B917996B;
        Fri, 20 May 2022 08:58:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n13so14524214ejv.1;
        Fri, 20 May 2022 08:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hzj89I5NOL6ORkKQyqqIAZvRUbPw4e9Z+bizamZOyYg=;
        b=k2ZGbTJes1BaQb8+bLQb5jerCqD+YxZmwHgd0i4k3LBJctG8BYkUUs12O25fYlCA/M
         v+k9SEt8KJ0/y9nl5MkPlv4kHVbUEbmww6Ar5sPG9aRwzwpI3mdCU8bVxsnegJlaD6fs
         0IvLGhhpiERRxep2KGZq6wkgCTu0f5vASos0fNCjHXN3p68dGqkm7YI8Ha+Z+2Egq0e8
         FbErVraZd5hj7IA5SfTUDk8NXvpNXf3U1EflqvF0vb0noybIQlf28kiM6CzvK3md66Bw
         Z7imSycLMDtzDPwdq8A9qce1Xj5xFK6rX4Dhzwtmss7xTuwyosFKgTtB1QQfTGKe/Q9h
         TYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hzj89I5NOL6ORkKQyqqIAZvRUbPw4e9Z+bizamZOyYg=;
        b=pESGKba/XQcn/0nypLTxN5/pDSSdNbW7ATzSH0eecUep2vZh/8R+2YLtk2fLg+QGFb
         T1K2Ll3gdP3KE/iDciKI9ELRDe7x+R+O9zVEzmEMtNxu+jm+gkHW1FSs9hP4B6Klq/oj
         ExsEby8ecGa8nzxLLJzO498AL0GwIUGZE+/5HLy33VTDigveIq/DeTYv1g3sQBADvlmv
         BPQSOuR3vGsah1kbF7TelXnZhU/yulqSqzqiRlNbRMCMUdimOddexzfQP3+waMVCLIG+
         CQGuUKMb5tm0FH+D+TzDcHFgi+MUDjBSUirvAq2lOzxbh/ZdeYu7Gse5hu3rM3RV7KVu
         +a+A==
X-Gm-Message-State: AOAM530CCxY7yNi/joVVRpaBH6MIW5OaUTi34WTtGdt7ZwibwmLAe1a3
        dbKHC/EHx4OvUfrr5V5AtB2tjGeOriQ=
X-Google-Smtp-Source: ABdhPJy1gEbu8XuYo4yUphHITL2Yrx03sLzRQjrY0/y17Otr1QjDCddz4+JS5AO1C4XNlnZzf110Lw==
X-Received: by 2002:a17:906:5204:b0:6fe:902a:da93 with SMTP id g4-20020a170906520400b006fe902ada93mr9942728ejm.155.1653062297564;
        Fri, 20 May 2022 08:58:17 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090601d000b006f3ef214db3sm3349200ejj.25.2022.05.20.08.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 08:58:16 -0700 (PDT)
Date:   Fri, 20 May 2022 18:58:15 +0300
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
Message-ID: <20220520155815.dtilf65h4dyo4md6@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-6-clement.leger@bootlin.com>
 <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
 <20220520095241.6bbccdf0@fixe.home>
 <20220520084914.5x6bfu4qaza4tqcz@skbuf>
 <20220520172244.1f17f736@fixe.home>
 <20220520154440.jtswi6oyjpseffpu@skbuf>
 <20220520174934.3b9feb88@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520174934.3b9feb88@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 05:49:34PM +0200, Clément Léger wrote:
> Le Fri, 20 May 2022 18:44:40 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> 
> > On Fri, May 20, 2022 at 05:22:44PM +0200, Clément Léger wrote:
> > > Le Fri, 20 May 2022 11:49:14 +0300,
> > > Vladimir Oltean <olteanv@gmail.com> a écrit :
> > >  
> > > > On Fri, May 20, 2022 at 09:52:41AM +0200, Clément Léger wrote:  
> > > > > > Also, as a request to unbind this driver would be disasterous to users,
> > > > > > I think you should set ".suppress_bind_attrs = true" to prevent the
> > > > > > sysfs bind/unbind facility being available. This doesn't completely
> > > > > > solve the problem.  
> > > > >
> > > > > Acked. What should I do to make it more robust ? Should I use a
> > > > > refcount per pdev and check that in the remove() callback to avoid
> > > > > removing the pdev if used ?  
> > > >
> > > > I wonder, if you call device_link_add(ds->dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER),
> > > > wouldn't that be enough to auto-unbind the DSA driver when the MII
> > > > converter driver unbinds?  
> > >
> > > I looiked at that a bit and I'm not sure how to achieve that cleanly. If
> > > I need to create this link, then I need to do it once for the dsa switch
> > > device. However, currently, the way I get the references to the MII
> > > converter are via the pcs-handle properties which are for each port.
> > >
> > > So, I'm not sure creating the link multiple times in miic_create() would
> > > be ok and also, I'm not sure how to create the link once without adding
> > > a specific property which points on the MII converter node and use that
> > > to create the link by adding miic_device_add_link() for instance.
> > >
> > > Do you have any preference ?  
> > 
> > The simplest (although not the most elegant) way would probably be to
> > pass the ds->dev as a second argument to miic_create(), and call
> > device_link_add() multiple times, letting all but the first call fail,
> > and ignoring the resulting NULL return code. Maybe others have a better idea.
> 
> That's indeed what I started to do although it's nasty to say the
> least... Moreover, the device_link_del() calls in miic_destroy() would
> have to be carefully made after all miic ports have been
> destroyed. Not sure this is going to be cleaner ! I'll try to think
> about it a bit more.

Wait... the whole idea with AUTOREMOVE_CONSUMER is that you _don't_
remove the device link.. you let it sit there such that the device core
knows there are other consumers it needs to remove when this driver
unbinds from the device.
