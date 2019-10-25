Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32189E4BF1
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394576AbfJYNV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:21:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41143 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbfJYNV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 09:21:57 -0400
Received: by mail-qt1-f193.google.com with SMTP id o3so3151128qtj.8;
        Fri, 25 Oct 2019 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uaH6B4Hp8aE6bF/45st6S4B2vnyBOwa8Fxqndxsbz68=;
        b=VjW0pdTwGMjJ95JHq/JMpOd4dp8RuAXCbtxatM/9ivmU88sRkknL/NH9RrD04hb5zU
         VEmvQcV9CDfvGz28FBg7NRN7+uDe9yw3UmFpowFGYULlue0+rPm9dXxnoUxnZryVdW5A
         LI6jHfLYahji8jqb+2y1afvBTiD5bLZam9Q4nvK5/xCH5vQDb/ddlgbWw/I9aeI8+2Uk
         9plLMx6FYiMiu9cuIhUDETUlx87SrFuiPIThQEonEOH7j65A+UEIxuCmD4RIJfbARqfi
         WuZ9U2CLNdsfUQzRE/JekcVSGo2Lx3+REVPw89K+aYugFIHx+f4OV/r76DIu/zyW+zAf
         hjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uaH6B4Hp8aE6bF/45st6S4B2vnyBOwa8Fxqndxsbz68=;
        b=W9mxXElYs+bYKEoB3O9lqr1HUHw5LPgyL+rq4yqCgKoFez+/X0q77wj8Em0QcCTaQq
         AzmluZCXiBZNGaq3rB4NSfKOViEo/BquwVyRVlq9dC5IbHIjEPNu08mnxik+VA/haFPQ
         bVAE9X/atTpt0BclOTqNM4Tcfx5mFSfl0KglWi+6iwCrNOay90w8HbEL/adyRktfD/FD
         JVfGovfcexWixqRVHLqke4H7sZrbg1AwQVsBpekLQwREiHcVErzBc8i2edQi9gOs04nG
         Q93QTqP/qM8O1w6IBiO7EcPQPHC++7t5OU75O91B/1bDe9FceJ9HMZwYsGc1YxAHWhC1
         Gz3g==
X-Gm-Message-State: APjAAAWDq1XA0ovftRjaAAxtF4xcE/DIVN77GtglNjDwMqCTdMajzCTL
        vpEH5iLP+br088xUKLHy+wCe0iWREU0=
X-Google-Smtp-Source: APXvYqyuLSojzMn8e3Ww+QWpph+9h7qQrp30jrEsAJfT0U1HvQfCunwpqmz7FFMT5sIls5KUq9md1w==
X-Received: by 2002:ac8:1e83:: with SMTP id c3mr2965386qtm.294.1572009716281;
        Fri, 25 Oct 2019 06:21:56 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.193])
        by smtp.gmail.com with ESMTPSA id j2sm1115160qki.15.2019.10.25.06.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 06:21:54 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 720F9C0AD9; Fri, 25 Oct 2019 10:21:51 -0300 (-03)
Date:   Fri, 25 Oct 2019 10:21:51 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock
 and asoc
Message-ID: <20191025132151.GF4326@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <20191025032337.GC4326@localhost.localdomain>
 <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 09:00:45AM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 25 October 2019 04:24
> ...
> > > @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> > >
> > >  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> > >  					   pinfo.spinfo_assoc_id);
> > > -	if (!transport)
> > > -		return -EINVAL;
> > > +	if (!transport) {
> > > +		retval = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (transport->state == SCTP_PF &&
> > > +	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
> > > +		retval = -EACCES;
> > > +		goto out;
> > > +	}
> > 
> > As is on v3, this is NOT an UAPI violation. The user has to explicitly
> > set the system or the socket into the disabled state in order to
> > trigger this new check.
> 
> Only because the default isn't to be backwards compatible with the
                           ^^^^^

You meant "is", right? Then we're agreeing.

> old kernel and old applications.
> 
> An old application running on a system that has the protocol parts of
> PF enabled mustn't see any PF events, states or obscure error returns.

Yes. With the patchset, the application will only see the new error
return if it (the app or the sysadmin) explicitly choose to be more
compliant to the RFC. There's no harm in that.
