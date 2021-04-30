Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4E370128
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhD3T35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhD3T34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:29:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A2CC06174A;
        Fri, 30 Apr 2021 12:29:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l2so19471380wrm.9;
        Fri, 30 Apr 2021 12:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=xsfKWu9djAexRf8YYIEh/TvQ8uWgjaR/8FmkkjYHDMQ=;
        b=G7dPItt9FEhqr9c207tbh+hMSJ00gc44EZ7WniDIsCu+4XmHUjdthA8dOnZ315n+Vc
         j//+QqSXtoryhIvjCdapYzc1I+XO0SkhgHpAbyQHvdkKjfNfG13vXYtVpvw8IdpaqGhO
         SeIHzX9KYeogpXfRdm4ludGDoo91u9Sw6vOeTzg3LVCQTw+sn9V+D92mk3vOWAsUGmf3
         JCCW2kXWLjPFjTwzG9sju6JQUwWtLSZapS036fmfSuU1U8mabp5LIAeTdV59Ykqg+0gy
         GFOZ1UtKPIK1pk+Jm78QERu959pDCJl3cGcnbblUO6zZTSC8rwAh+Jbok1CNjk4nhust
         JBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=xsfKWu9djAexRf8YYIEh/TvQ8uWgjaR/8FmkkjYHDMQ=;
        b=AZbMUmuR58DPOMX9nSBqQgwmQsK1csDyQVaR/41TsxmBqOd4n1CFLRrUJ73P8dTHgp
         CZqGrh3wrI/kKRttj4eJoE/yWw7kCtxSkEtulgghWzjTNtv6Fg9DIv7lLYma9YA4iZOe
         xDxt1X7KyFGJxVM1Soa0rXfPsQjvwuuWtxh8fWqRyJqHS1thHhtX+eigJL+mY/sDtvi4
         b1fnNTpg0KOx0avHuofhbUnQoWMPQ3M8kXy6bJ4d1J2id6OdQ6TWaKQhQ6+jMwF0c+rt
         vhTPTikCWvGeO4/iBHM2qsHv7iAYziHDzu9BbILW4qxlrIwMTmVZtu8gQXHwIxxQ2gIC
         IOWA==
X-Gm-Message-State: AOAM532DVD9d8aEkhMrusVbECCQ7egLxJLf9tvI+/cfxY0KSxULDUOjh
        hW+iz3t+TFTk+3iAvb6Wevhczi5g5yXVJw==
X-Google-Smtp-Source: ABdhPJxSQ7n5LAUvnqoHD3cmKiQNmXUEqzIb8q1m09ms7Ugx7Ty3b1YYgG2C+JW30u8nmzrKMqbmvg==
X-Received: by 2002:a5d:6085:: with SMTP id w5mr9404523wrt.14.1619810946705;
        Fri, 30 Apr 2021 12:29:06 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id u2sm13813002wmc.22.2021.04.30.12.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 12:29:06 -0700 (PDT)
Date:   Fri, 30 Apr 2021 21:29:03 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YIxaf3hu2mRUbBGn@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
 <YIxVWXqBkkS6l5lB@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIxVWXqBkkS6l5lB@pevik>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > +++ b/lib/fs.c
> > @@ -30,6 +30,27 @@
> >  /* if not already mounted cgroup2 is mounted here for iproute2's use */
> >  #define MNT_CGRP2_PATH  "/var/run/cgroup2"

> > +
> > +#ifndef defined HAVE_HANDLE_AT
> This is also wrong, it must be:
> #ifndef HAVE_HANDLE_AT

> > +struct file_handle {
> > +	unsigned handle_bytes;
> > +	int handle_type;
> > +	unsigned char f_handle[];
> > +};
> > +
> > +int name_to_handle_at(int dirfd, const char *pathname,
> > +	struct file_handle *handle, int *mount_id, int flags)
> > +{
> > +	return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
> > +	               mount_id, flags);
> Also I overlooked bogus 5 parameter, why is here? Correct is:

> 	return syscall(__NR_name_to_handle_at, dfd, pathname, handle,
> 			   mount_id, flags);
Uh, one more typo on my side, sorry (dfd => dirfd):
	return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
 			   mount_id, flags);


Kind regards,
Petr

> > +}
> > +
> > +int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> > +{
> > +	return syscall(open_by_handle_at, 3, mount_fd, handle, flags);
> And here 3, correct version is is:
> 	return syscall(__NR_open_by_handle_at, mount_fd, handle, flags);


> + adding at the top:

> #ifndef HAVE_HANDLE_AT
> # include <sys/syscall.h>
> #endif

> Kind regards,
> Petr
