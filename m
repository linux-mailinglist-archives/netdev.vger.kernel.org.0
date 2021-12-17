Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC3C478DE2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhLQOfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbhLQOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 09:35:19 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA30EC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 06:35:18 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p36-20020a05600c1da400b003457428ec78so3030601wms.3
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 06:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fMc2v4K0kX8aTPiSum+unuVGgdc5yJF7LINDGiGWUew=;
        b=fLOXS9FhsTNV9RSn2jJgKHrgfZsBKIOk6Zng68+o441kBjLUkzkFnj15TTQHxcLdQc
         pjKw0rpv457ulgWkqE3PzIq5xYDL3g5cx41ZxyPHpOsYP+X5IUzN+5uQfnTszxPmWKSy
         w47WRu+/P8FwDUnXo2lvAQ6DqyYhY3i4XkFKXA0cRJxhl8vSCbVW4qVGxuGYHYa3vmoU
         xj+NOKfGIkt0YzbQDSrj2UVZA1r0bWdqIDSmAG+QrngKPBumfrn0jFsEjfedw233f5vR
         Hbsvn5el4csxPNgCl8RgA35k9A2KgzuD/bzutJtXKK8yEFGdmQQ/WgZntajEXafRqXl6
         kENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fMc2v4K0kX8aTPiSum+unuVGgdc5yJF7LINDGiGWUew=;
        b=JdSt6h6nbRlJ1ewlNTviUvnuI46WrVw7lD9WqeFh9p9wej5U3ZbCTfyvCgpCIn0pfZ
         lvxUxd7+F3IFiytk/cVW6+sg4WhvhDKe4LqeM+Mo467Uy04tnQA64dSZUVDJYLJA49wd
         pNHnoeI4uhd4CzeXn9NEoCHUrYCTb+S6u43uAuy/W9ttmxtUYKKZRT5bxyrDpr/M0SvU
         fNN6/ZKzg/T4WEmCx7zkhottrguC5cRwn0qwf04ZMALzaKcrW02hhg3P2OXEMQJ4nBax
         aqMpe2m4L0vvIbNMbUr3KYOrma0Xz7v6R+BLFuZ/m+m5m51LPeZKv2aecciBfEyUNfqY
         EeVQ==
X-Gm-Message-State: AOAM531UB+RQkJ+5088mdlyZKsmUIoMGLDOSvzmRIuQbuGnEaZGXt+9N
        Q7rmh5h5BOQPnM2RZg26SK8HVA==
X-Google-Smtp-Source: ABdhPJzbKCEHjADe51tS6VDfOuaX6CXkgQz1c2MofRXJbYQ7ugSokbF05hcC9VmLN5sBSTghlR1Plw==
X-Received: by 2002:a05:600c:3c9b:: with SMTP id bg27mr2909352wmb.163.1639751717439;
        Fri, 17 Dec 2021 06:35:17 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id d2sm3707114wrw.26.2021.12.17.06.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:35:16 -0800 (PST)
Date:   Fri, 17 Dec 2021 14:35:15 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and
 return incremented endpoint
Message-ID: <YbygIz4oqlTkrQgD@google.com>
References: <20211217134607.74983-1-lee.jones@linaro.org>
 <1458e6e239e2493e9147fd95ec32d9fd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1458e6e239e2493e9147fd95ec32d9fd@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021, David Laight wrote:

> From: Lee Jones
> > Sent: 17 December 2021 13:46
> > 
> > net/sctp/diag.c for instance is built into its own separate module
> > (sctp_diag.ko) and requires the use of sctp_endpoint_{hold,put}() in
> > order to prevent a recently found use-after-free issue.
> > 
> > In order to prevent data corruption of the pointer used to take a
> > reference on a specific endpoint, between the time of calling
> > sctp_endpoint_hold() and it returning, the API now returns a pointer
> > to the exact endpoint that was incremented.
> > 
> > For example, in sctp_sock_dump(), we could have the following hunk:
> > 
> > 	sctp_endpoint_hold(tsp->asoc->ep);
> > 	ep = tsp->asoc->ep;
> > 	sk = ep->base.sk
> > 	lock_sock(ep->base.sk);
> > 
> > It is possible for this task to be swapped out immediately following
> > the call into sctp_endpoint_hold() that would change the address of
> > tsp->asoc->ep to point to a completely different endpoint.  This means
> > a reference could be taken to the old endpoint and the new one would
> > be processed without a reference taken, moreover the new endpoint
> > could then be freed whilst still processing as a result, causing a
> > use-after-free.
> > 
> > If we return the exact pointer that was held, we ensure this task
> > processes only the endpoint we have taken a reference to.  The
> > resultant hunk now looks like this:
> > 
> > 	ep = sctp_endpoint_hold(tsp->asoc->ep);
> > 	sk = ep->base.sk
> > 	lock_sock(sk);
> 
> Isn't that just the same as doing things in the other order?
> 	ep = tsp->assoc->ep;
> 	sctp_endpoint_hold(ep);

Sleep for a few milliseconds between those lines and see what happens.

'ep' could still be freed between the assignment and the call.

> But if tsp->assoc->ep is allowed to change, can't it also change to
> something invalid?

Not sure I follow.

> So I've have thought you should be holding some kind of lock that
> stops the data being changed before being 'allowed' to follow the pointers.
> In which case the current code is just a missing optimisatoion.

Locking would be another potential solution.

The current code already tries to lock.

	lock_sock(sk);

The difficultly here is that we don't know whether 'sk' is still valid
at this point.  I've seen the current code panic here.  Xin Long
suggested something similar using the RCU infrastructure, but this
code can sleep, so it wasn't suitable.

If we were to use locking, we'd need to figure out a) what to apply
the lock to and b) where to apply the lock.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
