Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36B022C899
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgGXO6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgGXO6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:58:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB36C0619D3;
        Fri, 24 Jul 2020 07:58:43 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a14so5266741pfi.2;
        Fri, 24 Jul 2020 07:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QkqqWSeWUuD3HygOIUorTjyLc3b0L3sITA+lUb4cF40=;
        b=sVuj4ZUs9ormiALXE8mSBXmPwBAZjN1g/gp/PGZJo+xnCtLCXc+ib65AVMQsm2b2f+
         X69daFQHIUotiKVt9msWSze3AjHsDu3r9q7xLGsJi93ZX8hRd6/np10qymypSAPx63eh
         +7qVhcaJFsVVlSQnMGCmXYKOKI8QxRFYXjyeJ6JIVEevtRTmfJEjUKuY6ro6L/yjgzu4
         Q8wB1CzaU7y86U3LIlqQ+ErVW/1OfumnjceWFoc03YQAwiluXPEecSTNSvUpLR96mUIB
         Y65HDvIJeaKs/geZBTMDMmEZvvWiA9M6VeFNwPrFoDwBjSkNgl3/TmlJz2C2N07YAemh
         OEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QkqqWSeWUuD3HygOIUorTjyLc3b0L3sITA+lUb4cF40=;
        b=AmlVDCSIGeKxK2XmOSGJkWW699n10twcF1BZ266Hf/40RTeZst9W928+yqOnqgERD7
         ob5CRZt74I2fiMCuKW2j2Z9J4ollzU5r8fWbs10aYPdTSh1FVoS73SlBK3jAmr8UrTZx
         gyVRB4QM1cxPvEJ68dRtFJBCZa45POEJiwIDTFp6kz3hlv5ALmIe4aVt6sFHx4t8q9im
         /Wq1MN0jsOn4m+ZkcxsbfOhG40IJEpf/0i9ZMOsDXWgrLiGYSgQ8KdJjS/7njNrF5/Po
         7X/4cktb7BFuGhprFRDv80Wjx8Qv/JIEhR+U9U/qMH9grCdc9voF5Zx+f2R8tDjMIVy5
         EGWg==
X-Gm-Message-State: AOAM533128Ra/b/geTuZdq/wCdvQQ42wRGSooWFbjB//EaNPsdlnNwtN
        W/tspGtXEOsSl/ja3F/j1A==
X-Google-Smtp-Source: ABdhPJwyRpFJ4lQro4xWnibbtnjkVlbhkniCoPRqc53gNDf50tJkPSvISJXW2o44oSxG+s+ujaQLLg==
X-Received: by 2002:a63:c404:: with SMTP id h4mr8756035pgd.336.1595602722446;
        Fri, 24 Jul 2020 07:58:42 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:d0b:42f6:80c3:156e:164d:54c2])
        by smtp.gmail.com with ESMTPSA id a13sm6828930pfn.171.2020.07.24.07.58.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jul 2020 07:58:41 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Fri, 24 Jul 2020 20:28:35 +0530
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        David Miller <davem@davemloft.net>, isdn@linux-pingi.de,
        arnd@arndb.de, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrianov@ispras.ru,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] drivers: isdn: capi: Fix data-race bug
Message-ID: <20200724145835.GA30994@madhuparna-HP-Notebook>
References: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
 <20200723.151158.2190104866687627036.davem@davemloft.net>
 <20200724044807.GA474@madhuparna-HP-Notebook>
 <20200724065747.GF3880088@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724065747.GF3880088@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 08:57:47AM +0200, Greg KH wrote:
> On Fri, Jul 24, 2020 at 10:18:07AM +0530, Madhuparna Bhowmik wrote:
> > On Thu, Jul 23, 2020 at 03:11:58PM -0700, David Miller wrote:
> > > From: madhuparnabhowmik10@gmail.com
> > > Date: Wed, 22 Jul 2020 22:53:29 +0530
> > > 
> > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > 
> > > > In capi_init(), after register_chrdev() the file operation callbacks
> > > > can be called. However capinc_tty_init() is called later.
> > > > Since capiminors and capinc_tty_driver are initialized in
> > > > capinc_tty_init(), their initialization can race with their usage
> > > > in various callbacks like in capi_release().
> > > > 
> > > > Therefore, call capinc_tty_init() before register_chrdev to avoid
> > > > such race conditions.
> > > > 
> > > > Found by Linux Driver Verification project (linuxtesting.org).
> > > > 
> > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > 
> > > I agree with Arnd that this just exchanges one set of problems for
> > > another.
> > 
> > Thanks Arnd and David, for reviewing the patch.
> > Do you have any suggestions on how to fix this correctly?
> 
> Based on the installed base of ISDN systems, and the fact that no one
> has ever actually hit this race and reported it ever, I wouldn't worry
> about it :)
>
Fair enough! Thanks for having a look.

Regards,
Madhuparna

> thanks,
> 
> greg k-h
