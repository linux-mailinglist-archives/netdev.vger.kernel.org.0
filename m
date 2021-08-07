Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E653E35DB
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 16:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhHGOXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 10:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhHGOXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 10:23:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F6C0613CF;
        Sat,  7 Aug 2021 07:23:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so18145193pjn.4;
        Sat, 07 Aug 2021 07:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P9A35ntPVTpy6pf5hhiO3MIDTUkr5r9FQm0lIbQCzDw=;
        b=PF9nV00K0eXuUGd3incbg1xZbDJu8rd6s6DbDcpOxh1l0mTWDqsFEpXH0lAiZl7Uas
         qEgYWHknaJucHQOMKIqkgtI0/yIdggm0I0ytrljbgUvzZEaVcaj4IDsR5cifY0PNMbM/
         WR7GbO8Rid5wVVSanL6oQfJpy+Q6lgmdLmpfn7FUNBwRB98wUhzOXsxeuFGmkmKJFhUm
         pjFvvZocjsGKXSmu29kS1OOr1VQ2AiQuUpOznNKXr5I+YVkU0L2CS77HlaRH+FvjNqit
         jWYI81WEjkjGA967G7RUHGliTJ/J3VWJ3PkeHY8cOsTkzecIy0w6wsgJhN+h5d3eMHst
         TiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P9A35ntPVTpy6pf5hhiO3MIDTUkr5r9FQm0lIbQCzDw=;
        b=Rj+BQ2aaB/ikXuMuPsjwlcRqF5mxga1UdAvEzysKVx1UMWNOIy8IVelXAGL8lRnDOe
         cn4+WbGsTtXc7qo6BGkK45CTxjwq1J6au3983hc2JzzjDBRbiF2S+aiUOmtWDKFtxLF0
         WeR9x76etOILCy9fC0Yt2N9IiBB/f3B8+/jDlMZh4vUkHzImCV390tNeQq4exWwdIjhy
         rPdKbeSFNs2YSzQ7qKbQzjVYuxAac6QPt8oeh+u2VfGqAkqOyn/NxY+hYF/xPvtgkuJu
         yZ897HpWbw/JMoqIfcdoRIire5R79Z3v7Ed0+mwS1Q+dESZUMI88V/OCjw3CULtIp7UR
         0faw==
X-Gm-Message-State: AOAM532br+zVDg2ILI0ZpYtcRMpO4mVsHwDH/RwuU4/iMYxkdTYNzGAW
        XhSfdTpsLA0U/WxEqo0I4xU=
X-Google-Smtp-Source: ABdhPJy92k9k5qZ3bBCOKumWsKbrfTfPUPSu3kLMSRUcWn8KbV5+YJehLWBXAO5z+tU5vEQ8x37dhA==
X-Received: by 2002:a65:67c6:: with SMTP id b6mr189426pgs.332.1628346182845;
        Sat, 07 Aug 2021 07:23:02 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b17sm15707800pgl.61.2021.08.07.07.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 07:23:02 -0700 (PDT)
Date:   Sat, 7 Aug 2021 07:22:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v5, 02/11] ptp: support ptp physical/virtual clocks
 conversion
Message-ID: <20210807142259.GB22362@hoboy.vegasvil.org>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
 <20210630081202.4423-3-yangbo.lu@nxp.com>
 <87r1f6kqby.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1f6kqby.fsf@vcostago-mobl2.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 06:15:29PM -0700, Vinicius Costa Gomes wrote:

> >  int ptp_clock_unregister(struct ptp_clock *ptp)
> >  {
> > +	if (ptp_vclock_in_use(ptp)) {
> > +		pr_err("ptp: virtual clock in use\n");
> > +		return -EBUSY;
> > +	}
> > +
> 
> None of the drivers (that I looked) expect ptp_clock_unregister() to
> return an error.
> 
> So, what should we do?
>  1. Fix all the drivers to return an error on module unloading (that's
>  usually the path ptp_clock_unregister() is called)?
>  2. Remove all the PTP virtual clocks when the physical clock is
>  unregistered?

This:

 3. Let the vclocks hold a reference to the underlying posix dynamic clock.


Thanks,
Richard
