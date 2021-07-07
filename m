Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6CF3BE9C9
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhGGOeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhGGOeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:34:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F34CC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 07:31:35 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b5so1173294plg.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 07:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1tJts3C2MPqE7b39IUNyFVVXKkN6WnysGawm2A1vXD0=;
        b=gOu9AZkGDY6rc/LAo5W3mFkx4H9GdBYCMne6FFwvRuMvSUnFRBxRhaiyPvFcV6yTmZ
         0COwHR2i5A32Wb1jEKg2IBnvlQZuDoLZJoFyuu3zBxjjOOae50bU0/NOI7JBVqJGDgpe
         V0Ipk2ZFQEg0BSJLy3bL25mXVCk/qw4tVN1STHHE0Hs56u18JZtuOaOzguCRqRtT7cmG
         I+jwGh7rcOj7uEzab0AMXqoviUUgUw1tdDDiTzPpy5yJXFFrM224deFGvHAXmG52+bjf
         8R79wpsNDmAdlQXBof4RQWWqhZBexDtVVBgMNgIXr5RNq49CH6s142PbF4w/D1/fOsEc
         Noaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1tJts3C2MPqE7b39IUNyFVVXKkN6WnysGawm2A1vXD0=;
        b=ORLpAe9mmze/Zf1ZrtWcvvNBXs381tYBGtuKl2cCBykvexezTZhae0wrBpj5yBusVh
         04JQNib94WVPo/O4upJqsgNfqKhgoBtkUKgBZKBuf70ZGbuyVx7rcOMS0FCraso+GzoN
         70uAWv7W7KHipLz7tO8/nc0Bmtedt9R/rt6kPnzBQViGriM8iSR/i/lXkDvC88TM7fbI
         4Z94z3Oa/uILVD+0gxcT4W0W3jR9lrNI5aHRCjItAew3SLGFmzotDDAIxRhxjftu/Y9Z
         k8+JSkcX0KQoBnfWpoU396yLmZ8FvMNAluLUgU1DQhtMBeACbdyklrZpXWxJE8TDmSVr
         DPEg==
X-Gm-Message-State: AOAM533QpT5G28vZxX3pyBl+u1tO+XRwPWrn4mrn7xysdtSCOW/6+hrr
        5489WWGaObS/LjQxgBmvopVfuw==
X-Google-Smtp-Source: ABdhPJy+xigfTyoXc6V8eAkUzSCL6b98ykeCOYh+IlcyWwwC+GJsrj8Ve1iiByFxoJjd752JVQw4qA==
X-Received: by 2002:a17:90a:c78f:: with SMTP id gn15mr6372003pjb.90.1625668294833;
        Wed, 07 Jul 2021 07:31:34 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id t14sm25552634pgm.9.2021.07.07.07.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 07:31:34 -0700 (PDT)
Date:   Wed, 7 Jul 2021 07:31:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210707073131.6e6ee75d@hermes.local>
In-Reply-To: <20210707152236.08ac5a20fc3be20adbb50879@virtuozzo.com>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210706083407.76deb4c0@hermes.local>
        <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
        <20210706091821.7a5c2ce8@hermes.local>
        <20210706201757.46678b763f35ae41a12f48c1@virtuozzo.com>
        <20210706170545.680cfe43@hermes.local>
        <20210707152236.08ac5a20fc3be20adbb50879@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 15:22:36 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> On Tue, 6 Jul 2021 17:05:45 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Tue, 6 Jul 2021 20:17:57 +0300
> > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> >   
> > > On Tue, 6 Jul 2021 09:18:21 -0700
> > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > >   
> > > > On Tue, 6 Jul 2021 18:44:15 +0300
> > > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > > >     
> > > > > On Tue, 6 Jul 2021 08:34:07 -0700
> > > > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > > > >     
> > > > > > On Tue, 29 Jun 2021 18:51:15 +0300
> > > > > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > > > > >       
> > > > > > > +	const struct rtnl_dump_filter_arg a[2] = {
> > > > > > > +		{ .filter = filter, .arg1 = arg1,
> > > > > > > +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> > > > > > > +		{ .filter = NULL,   .arg1 = NULL,
> > > > > > > +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
> > > > > > >  	};      
> > > > > > 
> > > > > > I am OK with this as is. But you don't need to add initializers for fields
> > > > > > that are 0/NULL (at least in C).      
> > > > > 
> > > > > Sure, I've made such explicit initializations just because in original
> > > > > rtnl_dump_filter_nc() we already have them.
> > > > > 
> > > > > Do I need to resend with fixed initializations? ;)    
> > > > 
> > > > Not worth it    
> > > 
> > > Ok, thanks!
> > >   
> > 
> > Looks like you need to send v5 anyway.
> > 
> > 
> > checkpatch.pl ~/Downloads/PATCHv4-iproute2-ip-route-ignore-ENOENT-during-save-if-RT_TABLE_MAIN-is-being-dumped.patch 
> > WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
> > #62: 
> > We started to use in-kernel filtering feature which allows to get only needed
> > 
> > WARNING: 'extened' may be misspelled - perhaps 'extended'?
> > #84: 
> > easily extened by changing SUPPRESS_ERRORS_INIT macro).
> >        ^^^^^^^
> > 
> > WARNING: please, no space before tabs
> > #111: FILE: include/libnetlink.h:109:
> > + * ^Irtnl_dump_done()$
> > 
> > WARNING: please, no space before tabs
> > #112: FILE: include/libnetlink.h:110:
> > + * ^Irtnl_dump_error()$
> > 
> > WARNING: please, no space before tabs
> > #116: FILE: include/libnetlink.h:114:
> > + * ^Ierror handled as usual$
> > 
> > WARNING: please, no space before tabs
> > #118: FILE: include/libnetlink.h:116:
> > + * ^Ierror in nlmsg_type == NLMSG_DONE will be suppressed$
> > 
> > 
> > WARNING: please, no space before tabs
> > #120: FILE: include/libnetlink.h:118:
> > + * ^Ierror in nlmsg_type == NLMSG_ERROR will be suppressed$
> > 
> > WARNING: please, no space before tabs
> > #121: FILE: include/libnetlink.h:119:
> > + * ^Iand nlmsg will be skipped$
> > 
> > total: 0 errors, 8 warnings, 183 lines checked  
> 
> Oh, sorry about that. I've sent v5 and checked with checkpatch.pl
> I've send two options for v5 - with initializers fix and without :)
> 
> Regards,
> Alex

Choose which ever initializer format you think looks best
