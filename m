Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF395467052
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378276AbhLCC6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243536AbhLCC6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:58:34 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940C0C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:55:11 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n85so1490540pfd.10
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gUO5E+xo/N9p9+UdjK6Vu5oZuSx0MblDqCGrgYgZ4bE=;
        b=lPXD9Fahfa18gPf16Yu3HkR3w3z3IXuArG/q3A0unXP8w139TlSgtnRTSNEm7NAOfy
         kwpacqxiV4wgGWBDLWoXCePGj1imay6f9cz4KqrJDpdUCpvgtPGGYcTox/ZxC44wXANA
         qX1G3+jOWBeygCgdA6B2fUH/P//cPU/Ce5r/9L01rIuaz/dLgJGxhCro83jrT7WSwqFW
         Vx0ocOZTe/mnbzOOqZnUb20j6tYgQJqc7g6h0w4CpabknzvT8JoDZxclrhk3g0Ys4uRQ
         6lYRoQKO+egsmDkdmpSnQj/rTLDeYlxHHNrLtGA7vLFE3pmtgwan2lbZuBNkRKEXP5RZ
         3WLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gUO5E+xo/N9p9+UdjK6Vu5oZuSx0MblDqCGrgYgZ4bE=;
        b=dkMy9NvGURsbd12s3Zw2+AQFTJGdrvx5rCxRaLu0nlANU3uFBff5XfB0TVMHV9EX/5
         zwrG7DpQ7lAOuxpanOyDXtNloUFvP/Sw65FZEh6A6sQzpYndyUZqSCjsZ8j84X8Ek58H
         /ZQqG+rPEYd5TtySDMIW6bb/FhQMa1E66bQ+uz30wxuQUAHUm1aXuYAUR8xel60b9Rvu
         GXm/3RzavzwD+VHYvdR+V+3d3GBS2PWIOmqX4+2o6PJEkJdkrOWbOWeiR97URVsZIojN
         TFSrf6dsSF++La7N3DQEUXxgZrD2r7Lxfp5nJWw3NA+vfUrQ7telw0BPye3MJgqpSOTY
         UwvA==
X-Gm-Message-State: AOAM531GNoryzYzs6AHoDQs/ECZQy4n9BCigNUcY2G13TBXb8D8vpQOs
        wDmKg7MH2ACbmwV+F3KjaL0=
X-Google-Smtp-Source: ABdhPJwN32sefdsTlogpjud4NU6U6MKdQebl4d0nDmAlKnG2cWxgYxp6NyDtSsl00ZoyGIVrY7J5Ng==
X-Received: by 2002:a63:5119:: with SMTP id f25mr2556979pgb.11.1638500111106;
        Thu, 02 Dec 2021 18:55:11 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s4sm815295pgj.4.2021.12.02.18.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:55:10 -0800 (PST)
Date:   Fri, 3 Dec 2021 10:55:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <YamHCHzmmQFA6Wxb@Laptop-X1>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
 <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YacAstl+brTqgAu8@Laptop-X1>
 <20211201071118.749a3ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yag3yI4cNnUK2Yjy@Laptop-X1>
 <20211202065923.7fc5aa8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202065923.7fc5aa8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 06:59:23AM -0800, Jakub Kicinski wrote:
> On Thu, 2 Dec 2021 11:04:40 +0800 Hangbin Liu wrote:
> > > Yeah, there should be some form of well understood indication in the
> > > uAPI telling the user space daemon that the PHC may get swapped on the
> > > interface, and a reliable notification which indicates PHC change.
> > > There is a number of user space daemons out there, fixing linuxptp does
> > > not mean other user space won't be broken/surprised/angry.  
> > 
> > This is a RFE, I don't think this patch will affect the current user space as
> > the new topology is not supported before. i.e. no user space tool will configure
> > PTP based on bond or vlan over bond. And even the user space use other ways to
> > get bond's active interface, e.g. via netlink message. It still not affected
> > and could keep using the old way. So I think this patch should be safe.
> > 
> > Did I miss any thing?
> 
> User can point their PTP daemon at any interface. Since bond now
> supports the uAPI the user will be blissfully unaware that their
> configuration will break if failover happens.
> 
> We can't expect every user and every PTP daemon to magically understand
> the implicit quirks of the drivers. Quirks which are not even
> documented.

Thanks for the explanation. I understand what you mean now.
> 
> What I'm saying is that we should have a new bit in the uAPI that
> tells us that the user space can deal with unstable PHC idx and reject
> the request forwarding in bond if that bit is not set. We have a flags
> field in hwtstamp_config which should fit the bill. Make sense?

Yes, this makes sense for me. I check this and try post a patch next week.

Thanks
Hangbin
