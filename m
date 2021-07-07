Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415363BE00A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 02:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGGAI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 20:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGAI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 20:08:28 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0B7C061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 17:05:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q10so536568pfj.12
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 17:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QYxMmNWw5Ysgr4OB4dUbcGYuuUdJR6AIDRq6tx9dm68=;
        b=PO/rybceBDGur/pC3rBeBEixDb6zLhNldd891EYmJH5N8CgNZTe1wMkOs4U5gTjeKr
         mLXcM9WtvhnBWceqZWQ2eJuPgV/Lnc8iLXXSHSa9ESdQOcTc0bgLfEuBZdgVJRBzJUhr
         m+U29sYma8kC2P+VpvvdCY4yzzi87JdaSQbMf4878eQNjDtVK+imXfyQRGDynTfJUVuz
         axtB3MG5Va0hIIdbVjXa599oA5nDKfZ6kCXy2z68Fi3HRQIdBHb15fMMHCopIL3NBTex
         kxUa87wt9PVwu2lnBAvx2TPCZeivZMxSizmeiZkHVeb2jpU/EEhuqIOhYVLpGa23LyUf
         zmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYxMmNWw5Ysgr4OB4dUbcGYuuUdJR6AIDRq6tx9dm68=;
        b=IE68QtAHh+mSV74F9QqPL6/dxrQLSvjjiIxTIuo/mDmYEfL+r9iIq8LrCPWDQFJgkV
         m+4IgBR6YlOl0Jae0eXy8af35guDnxfEjpmoNMF4xEpvxFJ+PzbCUqOoFtgJU+rtArRb
         xc+QMAnQB7qy1kgTOzmi2c4Aret0hiXz/3SfGNN3+cd2U9rIFYDQwn7bu/5HRxYpR4Yv
         4p4FWMFw2FOq4GyIKUyXn+uWt6IH18LwFkdwS+slG9qAkBBlLEfKsW0J83rgI4/uhlJc
         3UVqhYixjFy/6nohQ38S35tndzpstL4ANmWLfx5qFA7fT35Zh4N3+CTk7gpioe4Vt3vR
         m7Yw==
X-Gm-Message-State: AOAM533W6jkiUjmn/YQfa8h7bk7D7t3vxWoTdfygY8LChwUSHFTvgx6X
        ShcZTYVG2IWgwxybA+nnELtn3g==
X-Google-Smtp-Source: ABdhPJyeXXe4MmZIO0YbztjStgv4v+rXZFGJ4MX3HDrwMA206QNOz5FTETacLSOZhtxtIvOY/jD96w==
X-Received: by 2002:a05:6a00:2162:b029:308:9346:2f55 with SMTP id r2-20020a056a002162b029030893462f55mr22669293pff.49.1625616347960;
        Tue, 06 Jul 2021 17:05:47 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d13sm4060922pjr.49.2021.07.06.17.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 17:05:47 -0700 (PDT)
Date:   Tue, 6 Jul 2021 17:05:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210706170545.680cfe43@hermes.local>
In-Reply-To: <20210706201757.46678b763f35ae41a12f48c1@virtuozzo.com>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210706083407.76deb4c0@hermes.local>
        <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
        <20210706091821.7a5c2ce8@hermes.local>
        <20210706201757.46678b763f35ae41a12f48c1@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 20:17:57 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> On Tue, 6 Jul 2021 09:18:21 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Tue, 6 Jul 2021 18:44:15 +0300
> > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> >   
> > > On Tue, 6 Jul 2021 08:34:07 -0700
> > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > >   
> > > > On Tue, 29 Jun 2021 18:51:15 +0300
> > > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > > >     
> > > > > +	const struct rtnl_dump_filter_arg a[2] = {
> > > > > +		{ .filter = filter, .arg1 = arg1,
> > > > > +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> > > > > +		{ .filter = NULL,   .arg1 = NULL,
> > > > > +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
> > > > >  	};    
> > > > 
> > > > I am OK with this as is. But you don't need to add initializers for fields
> > > > that are 0/NULL (at least in C).    
> > > 
> > > Sure, I've made such explicit initializations just because in original
> > > rtnl_dump_filter_nc() we already have them.
> > > 
> > > Do I need to resend with fixed initializations? ;)  
> > 
> > Not worth it  
> 
> Ok, thanks!
> 

Looks like you need to send v5 anyway.


checkpatch.pl ~/Downloads/PATCHv4-iproute2-ip-route-ignore-ENOENT-during-save-if-RT_TABLE_MAIN-is-being-dumped.patch 
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#62: 
We started to use in-kernel filtering feature which allows to get only needed

WARNING: 'extened' may be misspelled - perhaps 'extended'?
#84: 
easily extened by changing SUPPRESS_ERRORS_INIT macro).
       ^^^^^^^

WARNING: please, no space before tabs
#111: FILE: include/libnetlink.h:109:
+ * ^Irtnl_dump_done()$

WARNING: please, no space before tabs
#112: FILE: include/libnetlink.h:110:
+ * ^Irtnl_dump_error()$

WARNING: please, no space before tabs
#116: FILE: include/libnetlink.h:114:
+ * ^Ierror handled as usual$

WARNING: please, no space before tabs
#118: FILE: include/libnetlink.h:116:
+ * ^Ierror in nlmsg_type == NLMSG_DONE will be suppressed$


WARNING: please, no space before tabs
#120: FILE: include/libnetlink.h:118:
+ * ^Ierror in nlmsg_type == NLMSG_ERROR will be suppressed$

WARNING: please, no space before tabs
#121: FILE: include/libnetlink.h:119:
+ * ^Iand nlmsg will be skipped$

total: 0 errors, 8 warnings, 183 lines checked
