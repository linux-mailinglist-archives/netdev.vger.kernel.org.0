Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B853455209
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbhKRBQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242143AbhKRBQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:16:14 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83806C061764
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 17:13:15 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m14so4290814pfc.9
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 17:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JmdBiBLxPyJxJAfjQJGiOnZa1z5gV9qSkM8eUa4HDxw=;
        b=qv92XP3uilvr8IZszD1kzgxDdfEjeYaphCCN39khN+/cgA4202VOTpmhEFJWzS1Qdx
         i9A9/oN6gk88TEc1nR57CVrABIYgB2K+V/SkBzZJkjsU7lJ7r2AmZyxGejQ0LiNY47XK
         uLgFzFClLz7uv9d+et72/q3iPb1gElXOXHNE0fufIP1qKzRrxVAZZ3kCUeIBf3Xz8Tdl
         5NaLR1TJl8k4CaWSCoESxAgZ4MosL504GvrFnP2aT0jgUVQxoFb8gghcitOlK7MoDocQ
         gfHLBOwX0zECwESamvL3V8gPdSpeT1MQUKClQDIl442YcTjYL9KKMbpj4mj1OZFzd/2x
         S6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JmdBiBLxPyJxJAfjQJGiOnZa1z5gV9qSkM8eUa4HDxw=;
        b=jicv1yQJQOQlvDmG5QPlLzqC426U4kJHXHlncOVM8bgTyVhL+gedihXmgunqDfoK0A
         vLCZNOT0KrtVXAGXSlZIOIUwLvbZVdMHHbjLLAQe8X/sYvpg7SKUJlsfUCBse5xD0SZY
         3NKWupiFaDHjqoUNSvO+iSiqyCliSvc136+7gpboevg8OlCB0XPzG385jNuxOCk7Bz+3
         0icfTWgyHwZwfKqBR+ncUZqMAkpeA7MYAcGIOpMdz9kwWBysvYr/9MtLXN1OTOAK/Lvv
         dpBBDthyq8o5I0qiPsqb8u3XMuGkmy5A9TtWYUdn7/GMluMfX/e2aYyIef0HHqMOIWmo
         tzhg==
X-Gm-Message-State: AOAM532aMaKyuwuVTgCa8oCNUj6vooM5D4QwXw9eNEw7DRXOCvGgllxo
        EuUFl1o8hNzDP/4HBQZP0D8=
X-Google-Smtp-Source: ABdhPJwaKdNa5Tl7fczyLDuyD05XW33tRqn0ozbKJK+qZeiJj32+W4yWnIMsdiPf6EjlfTmybCCwUg==
X-Received: by 2002:a05:6a00:14c8:b0:49f:af00:d5cd with SMTP id w8-20020a056a0014c800b0049faf00d5cdmr52190696pfu.59.1637197995127;
        Wed, 17 Nov 2021 17:13:15 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l12sm817692pfu.100.2021.11.17.17.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 17:13:14 -0800 (PST)
Date:   Thu, 18 Nov 2021 09:13:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add missed_max option
Message-ID: <YZWooyiGT9Z3mPwh@Laptop-X1>
References: <20211117080337.1038647-1-liuhangbin@gmail.com>
 <70666.1637138425@nyx>
 <YZTSUh0vA1gVZFr3@Laptop-X1>
 <86277.1637165806@nyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86277.1637165806@nyx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 04:16:46PM +0000, Jay Vosburgh wrote:
> >I didn't explain it clearly. I want to say:
> >
> >I'm not using arp_misssed_max as the new option name because I plan to add
> >bonding IPv6 NS/NA monitor in future. At that time the option "missed_max"
> >could be used for both IPv4/IPv6 monitor.
> >
> >I will update the commit description in next version.
> 
> 	There has been talk of adding an IPv6 NS monitor for years, but
> it hasn't manifested.  I would prefer to see a consistent set of options

I'm working on it now. I should send a simple draft patch in 2 weeks.

> nomenclature in what we have here and now.  If and when an IPv6 version
> is added, depending on the implementation, either the IPv6 item can be a
> discrete tunable, or an alias could be added, similar to num_grat_arp /
> num_unsol_na.

The name of num_grat_arp looks better than missed_max :) . In my
IPv6 implementation, the function bond_ab_arp_inspect() will be reused
directly. So one name or an alias looks more reasonable.

For the alias options, do you mean to let both num_grat_arp and num_unsol_na
change a same option in bond->params?

Thanks
Hangbin
