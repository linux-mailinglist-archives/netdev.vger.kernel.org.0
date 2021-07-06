Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F363BDB42
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhGFQVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 12:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhGFQVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 12:21:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430C7C061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 09:18:25 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o4so9241577plg.1
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 09:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=heOFddTtgrhuQumvGosFIkqvaBbKX5iQAngvm3JOatY=;
        b=l8zKmX3bM5XRdPPkmfXPJ1mOa+wshDo5BG0ixQoM9KBgzC4/EMqnz3YssA5oLl+Hcl
         obvB+wyVXkk1q8zs2Dg2MDPH4HefVrgQTosxim6tMmLUY0QG/yE3fE8dTSUeK8LfTvj8
         yqPdmciaCv7326fkZhW5rWqcb24kTtiS4h7dS+VH0ywAF6BHA6vqhxlxqB2oX9v+ySsV
         a4bhc1Ys2ymRrzMWFJMmJaTbffLve01scCdkPJi8fVQV5+V+skRbaGUa7OAOQ1JHEiaM
         0wMWOgza3mzBIXgNheaTsEYURduZeilrxhOwj3q6+GjppMs+3Zhur6+7qMxIXkUF9ner
         +ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=heOFddTtgrhuQumvGosFIkqvaBbKX5iQAngvm3JOatY=;
        b=UVWpKI+zqjW0TvZYHOqD0iqdAYonCDQjtlt58MI+Ptv9liJyNydzhoLQ4MVS6ljM3j
         82VnIHLEzchRYCUe0+qEp0uoakZoRMKlqLS7uvlvSN8fzRx7h8dITtYw3Z3hQ/1zN5NA
         xhTOvcv5YF4gYJu2C/DHjh0xjQNXNlH9L0XA5/PLRMjVNwo6kLiKvGPtXeiWQSNd0vNg
         7rXqe62T0YU4iWH4+E5ByzrWgVW4cBRN/1HcCpw7AkIikxO5DJpJXHDdWfmHOy9GexNJ
         jayW3mPz15V77SInJtM3pyJfYZuKoZnKjNNkZw2iRh3f3zYHZikRLagUVfC4wUEG0mmH
         nOMQ==
X-Gm-Message-State: AOAM531eaH24Cww8dX077kNt5E8qCgHfGfZQKeAjNWeuhopvHlaMNyU5
        hbhSm9L4kv/ZuK2o3/CXPamPww==
X-Google-Smtp-Source: ABdhPJzKcbik1YBX2nimh+V7webbgLE1ew1nI7CeBOX2pNIGox4fqmY4WK2Q/din0oSjAGLk5Ae/mw==
X-Received: by 2002:a17:90a:2c09:: with SMTP id m9mr1261502pjd.212.1625588304733;
        Tue, 06 Jul 2021 09:18:24 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 199sm16031455pfy.203.2021.07.06.09.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 09:18:24 -0700 (PDT)
Date:   Tue, 6 Jul 2021 09:18:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210706091821.7a5c2ce8@hermes.local>
In-Reply-To: <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210706083407.76deb4c0@hermes.local>
        <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 18:44:15 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> On Tue, 6 Jul 2021 08:34:07 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Tue, 29 Jun 2021 18:51:15 +0300
> > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> >   
> > > +	const struct rtnl_dump_filter_arg a[2] = {
> > > +		{ .filter = filter, .arg1 = arg1,
> > > +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> > > +		{ .filter = NULL,   .arg1 = NULL,
> > > +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
> > >  	};  
> > 
> > I am OK with this as is. But you don't need to add initializers for fields
> > that are 0/NULL (at least in C).  
> 
> Sure, I've made such explicit initializations just because in original
> rtnl_dump_filter_nc() we already have them.
> 
> Do I need to resend with fixed initializations? ;)

Not worth it
