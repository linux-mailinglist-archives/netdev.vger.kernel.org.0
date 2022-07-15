Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C26B576799
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiGOTj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGOTj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:39:56 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC0B6F7E3;
        Fri, 15 Jul 2022 12:39:54 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id mf4so10711449ejc.3;
        Fri, 15 Jul 2022 12:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=XEKfpFw02gqf7NoXFh68+SxWr6u5EljMHt08x8BZg0o=;
        b=ZsIi3huAGfDp3Exh9GR+u5CC9waovw/IDhbPSEf+KU8vE/TIVnbCC8Atk7lV7lV/NV
         YxGfOh5faYadDFFQ4jwmanc15Jgt4CCeErWtkcmqQTgjSjvZhI+hRUuDqJgxJYWSie6h
         zLa3pJyh076AYypxrNpWF6hQ6guw8Kb+PSVAjIGkcjxPssq0KgV77AlxDwjXFZ9HrsWl
         fxrEPxE9NlheiJ9/xVSdZJdVwogn1UnABnZJx696IexvSKplUVof0fObReDfrjdXulHy
         0o7Lt/hoM0p6z0azvBQKBRP/1RatDiOnkuFgLcbkUBmLRGlXxGjfOUqqJR5rqhqj890N
         3cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=XEKfpFw02gqf7NoXFh68+SxWr6u5EljMHt08x8BZg0o=;
        b=4/9cPk+YI8Is52RlnaIw8v4mTtUDy17m/+ElO5sWTfUOajFjx3bYcRv4GPq8smWq3c
         uolm2V5MvRC3TVvqUHtfgMGGyU26x3dP+Q7V2FRzbthXuF3bLEBKtY1zEx8w5IC4EArZ
         T6xPY0+bDmDpvZPnk2WVBDi7m5yQhNIwEjWr0aXSQx0C8+9a5q1sjdFfVtGRPfRSSgXP
         r5le17XjwQzdtvNw0ETl4Spj70kERPwiQzROrWf5qyYdLj+1AxIgyNOJRuGPRbmjnqnR
         C+66fB3apuuefONUYgw+lbZqvmN6QFiV8HYLRh/PaUURMBACHK9gBc0KyzVk5Kav2Tx6
         tlgw==
X-Gm-Message-State: AJIora+Vf+ai9YUkFdWYnNfliRrJQ4hzwm5MNSNeJp08ExeFhMNi8n+r
        rUGYl+rbuMnS2RlptjkQwkM=
X-Google-Smtp-Source: AGRyM1uv7pIljfKIzkcmPHgcUK0HUNToL1Vrm6lC05TLtSu2p0JomsVFKl1lE1vSw8YDQZ5UstWRdA==
X-Received: by 2002:a17:906:c10:b0:6f4:6c70:b00f with SMTP id s16-20020a1709060c1000b006f46c70b00fmr15133333ejf.660.1657913993070;
        Fri, 15 Jul 2022 12:39:53 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906318a00b0072aac739089sm2367472ejy.98.2022.07.15.12.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 12:39:52 -0700 (PDT)
Message-ID: <62d1c288.1c69fb81.45988.55fe@mx.google.com>
X-Google-Original-Message-ID: <YtG9Hp5nqZY2REGy@Ansuel-xps.>
Date:   Fri, 15 Jul 2022 21:16:46 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
 <20220714220354.795c8992@kernel.org>
 <62d12418.1c69fb81.90737.3a8e@mx.google.com>
 <20220715123743.419537e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715123743.419537e7@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 12:37:43PM -0700, Jakub Kicinski wrote:
> On Fri, 15 Jul 2022 03:57:46 +0200 Christian Marangi wrote:
> > > Does the split mean that this code will move again?
> > > If so perhaps better to put this patch in the series 
> > > that does the split? We're ~2 weeks away from the merge 
> > > window so we don't want to end up moving the same code
> > > twice in two consecutive releases.  
> > 
> > What to you mean with "will move again"?
> >  
> > The code will be split to qca8k-common.c and qca8k-8xxx.c
> > And later qca8k-ipq4019.c will be proposed. 
> > 
> > So the files will all stay in qca/ dir.
> > 
> > Or should I just propose the move and the code split in one series?
> 
> Yup that's what I prefer.
>

Ok no problem, if the current merged commit is a problem, np for me with
a revert! (it was really to prevent sending a bigger series, sorry for
the mess)

> > Tell me what do you prefer.

-- 
	Ansuel
