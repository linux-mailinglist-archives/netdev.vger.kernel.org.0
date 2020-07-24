Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB49922D221
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGXXSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgGXXSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:18:50 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF71FC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 16:18:49 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b13so5731123edz.7
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GTIWfVzE+qaEDvvSuBdQRzhbFbeYEWA+faxm/WM51mQ=;
        b=e70zIdllZjIguOQOF63hHzYoFCJLwUpEZEQ3+TaVODycEIanyHzQg6uFc0sSXRjkRb
         q+4XBnvMlWcPWlj1PW8ghwKjL5ZCvoxUH6HtNeS/6Sde63Cx2XIxKrKTkeFb/1UcqGCr
         zRU6itdz06jlaQHCV5dFWoovjV5Vn5YAf+Pb4WmOowOequnpcDJ/6FbSJfSgLuIoZjB3
         Dt0PZ5LtzpLiaObCjhqPGuFHU4xOh9irZsAveBKKR9ehouD4Dsz3D1vg0Jz2BsQXlLgx
         ZGqiCyCW5FkZH9hIU/w+E30RfFl0SsQmlPKUrN2uzdcfN2e8d9+EE89a3h3UhJ3VDYUT
         jXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GTIWfVzE+qaEDvvSuBdQRzhbFbeYEWA+faxm/WM51mQ=;
        b=OCZImgB4N65T69ZMkN5nTzUu/gHeZDi1xOpPGhdRjUX1XcC9UMZvKKypvYjZbZw5oz
         CV8o3rpJPEUqmtiJSQJrmqNe4iz6Sv/e/C5rPxkCukV+4FL3pIosvoKbu4Sx1BNcEei1
         eIHB2HL4ciiYFttCLIHubTsBB/fKyVQV2mQ8PkSlrcK5RFFErPJJFcE7WPXIdnGVhUav
         kmW8BIz/FkuVyfA4mMhtUAH/jaBWi/YyJR1890UL2yWaNoHBzVI88eiUqrIl+t6bWtRj
         v46aa9bTergacNFbz6lvZx+nR1d0fBKAvmlV8/vqs8+Bj2c9YBep77PQN49Y9733ib3t
         LEBA==
X-Gm-Message-State: AOAM5317wqZIqB2Xa5QX3l1PGnjhECSp5tQsRp1hm+TikcoEEuDw+Gp2
        0sn3nBCJWBNMkGVQ4nTS1F4=
X-Google-Smtp-Source: ABdhPJyfYFEaqpQdTWU1qHyAqPJf7mBET33OopV4NcyItq1yL+0fnZFrmMuAbZBhQPKMqWUjI49klg==
X-Received: by 2002:a05:6402:2c5:: with SMTP id b5mr10739392edx.316.1595632728508;
        Fri, 24 Jul 2020 16:18:48 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id l9sm1659412edj.12.2020.07.24.16.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 16:18:47 -0700 (PDT)
Date:   Sat, 25 Jul 2020 02:18:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        George Shuklin <amarao@servers.com>, netdev@vger.kernel.org,
        jiri@resnulli.us
Subject: Re: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
Message-ID: <20200724231845.crjdn76uhosssfgi@skbuf>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
 <20200724091517.7f5c2c9c@hermes.lan>
 <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
 <20200724120513.13d4b3b1@hermes.lan>
 <eb3056d2-67ae-3706-169f-31159f707cc1@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb3056d2-67ae-3706-169f-31159f707cc1@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 01:51:02AM +0300, Nikolay Aleksandrov wrote:
> On 24/07/2020 22:05, Stephen Hemminger wrote:
> > On Fri, 24 Jul 2020 19:24:35 +0300
> > nikolay@cumulusnetworks.com wrote:
> > 
> >> On 24 July 2020 19:15:17 EEST, Stephen Hemminger <stephen@networkplumber.org> wrote:
> >>>
> >>> The bridge portion of ip command was not scaling so the
> >>> values were off.
> >>>
> >>> The netlink API's for setting and reading timers all conform
> >>> to the kernel standard of scaling the values by USER_HZ (100).
> >>>
> >>> Fixes: 28d84b429e4e ("add bridge master device support")
> >>> Fixes: 7f3d55922645 ("iplink: bridge: add support for
> >>> IFLA_BR_MCAST_MEMBERSHIP_INTVL")
> >>> Fixes: 10082a253fb2 ("iplink: bridge: add support for
> >>> IFLA_BR_MCAST_LAST_MEMBER_INTVL")
> >>> Fixes: 1f2244b851dd ("iplink: bridge: add support for
> >>> IFLA_BR_MCAST_QUERIER_INTVL")
> >>> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> >>> ---  
> >>
> >> While I agree this should have been done from the start, it's too late to change. 
> >> We'll break everyone using these commands. 
> >> We have been discussing to add _ms version of all these which do the proper scaling. I'd prefer that, it's least disruptive
> >> to users. 
> >>
> >> Every user of the old commands scales the values by now.
> > 
> > So bridge is inconsistent with all other api's in iproute2!
> > And the bridge option in ip link is scaled differently than the bridge-utils or sysfs.
> > 
> 
> Yeah, that is not new, it's been like that for years.
> 

I remember having reported this quite a while ago:
https://www.spinics.net/lists/netdev/msg567332.html
I got no response, sadly.

The real problem is that the documentation has been wrong for all this
time (that needs to be updated as a separate action). Yet there were
only a few voices here and there to signal that.

So there are 2 options:

- There have been many users who all hid their head in the sand while
  mentally multiplying by USER_HZ.
- Almost nobody was using it since it didn't work.

Occam's razor tells me to go with option #2. So fixing it is never too
late.

> > Maybe an environment variable?
> > Or add new fixed syntax option and don't show the old syntax?
> > 
> 
> Anything that doesn't disrupt normal processing sounds good.
> So it must be opt-in, we can't just change the default overnight.
> 
> The _ms version of all values is that - new fixed syntax options for all current options
> and anyone who wants to use a "normal" time-based option would use those as they'll be
> automatically scaled.
> 

Right, the problem, of course, is that you'll end up typing a command
and you'll never know what you're gonna get. Old iproute2, old behavior,
new iproute2, new behavior. So you'd need to look up the iproute2 git
history to figure out, or put prints in the kernel. Unpleasant. At
least, with new strings for ageing_time_ms and such, at least you're
going to know based on whether the program is parsing them.
I vote for new options too.

Thanks,
-Vladimir
