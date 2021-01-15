Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE7C2F7EA1
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbhAOOyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbhAOOya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:54:30 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E710C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:53:50 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n26so13661705eju.6
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YmtGmO6G72Bra0YAFPCW68dhj0TVYIhqIaXQVPdFikQ=;
        b=FRd0lxAlLu8sQuUoZ/YHNu2vs7oK9VzdP5LNvi/6sj2io2CsC08gwkV11+WFsDg7Gp
         lvZuzQ1pzkNg+BBvKThRDE1TFPOzeEyvsWJ/2mVL6I3A5mqc/GO6s9t2C148LYlgczYW
         Xy0710yP7IHty6M57Q2Qy4HNx/L9SiwU34PjIxDk1jBrTdFORX87EaLWxC/6Ej415Ae6
         bSmrenqDt4o2h3D4TgU03B3JXSywgNnslAJyNAwpFJkG8bpiBMjnuBQ0DH53cW/e9NoJ
         +841NtJ3OLWuiZHAwC6kM/O1FhLxGf9UBJMD24QI4Nhc3MBnKmUPPBAgbo7jldA7XgnJ
         TcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YmtGmO6G72Bra0YAFPCW68dhj0TVYIhqIaXQVPdFikQ=;
        b=QJYFgscHHfA9q9h3c5aHyu/Bhyu88PY4CQ8YuV7PUiHwVTTs8s9PAyfJWYIkoR3+9S
         zR0Hk9ZZNa+lL8w+hgP3P2WGu5l5xxHM1hT7Ms8zwGIXMf9IYBzKU2cD4l3YTAMV3xV2
         5mfGijNroWzbTFWr5APeTl1DqneW8L1spoFNRpnI4KVNDR1V4wub18tLxUXvZBJmQG7S
         JIP7OjZqlAuSgzS2NPKK8jWjUnHjk6MCMMog3w5pijNI7O4wa6HwTbL1Z/ijM67cJ3hi
         Eo17AE+FDu4/bwxRO0OQtlPo4nrIcfDJdGzgwBGgfCQiCcIu0ydvjhiYkN1hTAalTN15
         wwIA==
X-Gm-Message-State: AOAM530HpNS2fvdgg93iCNgYFky8cLegHbrf8eBkpFCM+Nm8Gzf9b/zV
        SAWzmVIPAz/G9mSyk9nWZks=
X-Google-Smtp-Source: ABdhPJwYONrfX7nzOXQGs2L1VaqIJZYRabu1+Ch3gKtlx9RqO+Ipb0pHjuNunLdcwHWXVlSLk1CwIQ==
X-Received: by 2002:a17:906:a951:: with SMTP id hh17mr9545245ejb.388.1610722428682;
        Fri, 15 Jan 2021 06:53:48 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b7sm3668623ejz.4.2021.01.15.06.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:53:48 -0800 (PST)
Date:   Fri, 15 Jan 2021 16:53:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy
 implementations for trunk setters
Message-ID: <20210115145347.3ajwvo5o65mgkwn2@skbuf>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-2-tobias@waldekranz.com>
 <YAGnBqB08wwWQul8@lunn.ch>
 <20210115143649.envmn2ncazcikdmc@skbuf>
 <YAGrRJYRpWg/4Yl5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAGrRJYRpWg/4Yl5@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 03:48:36PM +0100, Andrew Lunn wrote:
> On Fri, Jan 15, 2021 at 04:36:49PM +0200, Vladimir Oltean wrote:
> > On Fri, Jan 15, 2021 at 03:30:30PM +0100, Andrew Lunn wrote:
> > > On Fri, Jan 15, 2021 at 11:58:33AM +0100, Tobias Waldekranz wrote:
> > > > Support for Global 2 registers is build-time optional.
> > >
> > > I was never particularly happy about that. Maybe we should revisit
> > > what features we loose when global 2 is dropped, and see if it still
> > > makes sense to have it as optional?
> >
> > Marvell switch newbie here, what do you mean "global 2 is dropped"?
>
> I was not aware detect() actually enforced it when needed. It used to
> be, you could leave it out, and you would just get reduced
> functionality for devices which had global2, but the code was not
> compiled in.
>
> At the beginning of the life of this driver, i guess it was maybe
> 25%/75% without/with global2, so it might of made sense to reduce the
> binary size. But today the driver is much bigger with lots of other
> things which those early chips don't have, SERDES for example. And
> that ratio has dramatically reduced, there are very few devices
> without those registers. This is why i think we can make our lives
> easier and make global2 always compiled in.

That makes sense, I thought you meant something else by "global 2
support is dropped", nevermind.
