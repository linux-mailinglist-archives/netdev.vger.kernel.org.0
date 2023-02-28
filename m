Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70B6A6134
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjB1VYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjB1VYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:24:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0370C2B62C
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:24:36 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n2so6650568pfo.12
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677619475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LlJmTeYk4BhxVuaGxtCxtDrhZuullw3/xZzZBGmlGv4=;
        b=FlHf0naBmJvdYBpn4m0VGwTjIKzVUOop9NgnAP8M1RhfbXRljK6/dIjXu09cznvwBo
         VSgGRqcQDUqMkhizztrJh9HEvCDtoxQy8si+b5D88MUe/H+BXB46axvL/daHa6pq/HUw
         0GvEuCuuGRbPgwH1uRCtFl9uz2zJvBggIy0kg+41BSjW/NcZ6uNzqxqLDucCKHKoWbDK
         lI/hODNwnM0tys7BlfN0Gou4C//dfjWGq3CEpg5HcgkyrPubJFEhqqArbGfATg2mUhB3
         a+11tazgrgoHKIDu/+RZbFuFukqbMI8bal+zP1KDkSwyCjHdgEc6BUawq9NHFlGu5hS8
         RGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677619475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlJmTeYk4BhxVuaGxtCxtDrhZuullw3/xZzZBGmlGv4=;
        b=RAsn0ynnHCO55vkBi8CGevUt/7p2d3adUqDwcv2tlJR7KaRps9uOxK2x1XthQLfj4z
         92dV8HXfF1Oez0xiS38xNB81GBsx/+fSpSSlkoTR468qmC9o7jfLzWWgPb/GO3zoJLYD
         YSlAO1U68Pc/XtekTi4039NGcooZKOpgAkjbOTnhDPI36wUnGBaQ9V+d9QTU8AKbjaAs
         FZXiefbVNdbVOMCaOw296tsfqqSjLSETkr/TtmQI4tNrDc69eXn/ul6Wq3SDxRVDooks
         a9vWAeT9PYfMwuCL6Wcfl7Tbem3GuBJsxgJ6R3qp9SekQxnyPpWEKFJNJq/VCYMDg/U7
         F/MQ==
X-Gm-Message-State: AO0yUKUpOHQCRgUkZDt4FiFuajCk53uKJ9ZZukRI2dYkm5rrHjHdVUon
        T1ZGc9SG84fiETe9bm39XI4=
X-Google-Smtp-Source: AK7set8BvGnXt8kC5odVK+KZa83zoA3nEdNmBvxB29JvZtCVRZ4KBJKIt0WX7r3fKApJOrAMDIJPzQ==
X-Received: by 2002:a05:6a00:23c8:b0:5e4:cbc9:6e06 with SMTP id g8-20020a056a0023c800b005e4cbc96e06mr4289238pfc.3.1677619475328;
        Tue, 28 Feb 2023 13:24:35 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v191-20020a6389c8000000b00502fd12bc9bsm6227497pgd.8.2023.02.28.13.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 13:24:34 -0800 (PST)
Date:   Tue, 28 Feb 2023 13:24:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/5xDyWBfvbBDKcj@hoboy.vegasvil.org>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 04:27:10PM +0000, Russell King (Oracle) wrote:

> Another possible solution to this would be to introduce a rating for
> each PTP clock in a similar way that we do for the kernel's
> clocksources, and the one with the highest rating becomes the default. 

Hm, that is an idea.

It would only need a command line override in case the user disagrees
with the kernel's hard coded rating.

Thanks,
Richard
