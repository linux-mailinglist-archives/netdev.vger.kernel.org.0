Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787E74221C1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhJEJKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhJEJKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 05:10:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AE6C061745
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 02:09:02 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m14-20020a05600c3b0e00b0030d4dffd04fso2326413wms.3
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 02:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rammhold-de.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+NRP6+YwwZPDC6xBF9B2HRbg5ERKmcqeAmIAWlpjJrM=;
        b=c5Yw2ircgC4PU7lpSnr7c3T49mMg32AAE91PNMlXDVI/QZeIJX9wwNRZJsy/FsWd/W
         leA/UmcnSiIV7RvIRwkiSoON8m4yEmLdZtKuKt3t6iBfhT57Uw+SI0S6hc+iDxWMftVw
         0laZU8Ktg6yfOPPy+BRSUsSXro4QujZlYY493NFOy+7Ci7Mw9nyjnwA/h7AOZ9jXADbj
         9p69MvwhuKoXkzbGdOWlC194qUwzkYqYwHmcyaennrv+51pge0DcSVn1dLTu67ZJVKZ1
         MHhpqf1c0+RvfdFtEb4XJfp4XFyCjtVGEmm+jqZyig+g9AtbVFQTD5xmQNTEbXN05U/P
         Y2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+NRP6+YwwZPDC6xBF9B2HRbg5ERKmcqeAmIAWlpjJrM=;
        b=n8BJYxBAYCUA7LCtU8H412hx5KZfrB7AGXHwPsbt7o39ndY2vKfhz72WuWWwiFgykp
         G8oLOC2FHvFzeXbMF0qQBUW4UmgcyHfLj6l5KuwBPz3SHODy6/ifiJrKDAc11uxqQXco
         bdtP3055H7vu/mc50xIjRJs4f3ntw7AyKMi0/n6NeqRxnrtc9LI/nb6PuB9f2Fu8EKOq
         wI4Az+DmZcJON92QuYYiwcCC9NDteB8bm7rJfiHqxAV2Wi+VzC3msuyns4ykBP7rATiC
         Oen8wTGIxdoNXOyRgNiMLiaX63NmawmiUdFm3kBYirt+qFSBiKa4EZ+Gu7GXDMA99IbK
         c8Pw==
X-Gm-Message-State: AOAM532h9g2yzGsBs/gXQQskGpatl3p8RkRLmO6KdCL2Q6HtN1SQH4CX
        CIywTjTijZ59RGlhyulK6yEtmA==
X-Google-Smtp-Source: ABdhPJwUnaB/55ITALv3KemyJXfjyXnToYUVBFOvbZPTsSHy0KcCqrkt9gcpGsiS/iJzMy8TCezM3w==
X-Received: by 2002:a1c:a508:: with SMTP id o8mr2149762wme.29.1633424940434;
        Tue, 05 Oct 2021 02:09:00 -0700 (PDT)
Received: from localhost ([2a00:e67:5c9:a:a1fa:90d6:f435:5294])
        by smtp.gmail.com with ESMTPSA id m14sm1167110wmi.47.2021.10.05.02.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 02:08:59 -0700 (PDT)
Date:   Tue, 5 Oct 2021 11:08:56 +0200
From:   andreas@rammhold.de
To:     Punit Agrawal <punitagrawal@gmail.com>
Cc:     Andreas Rammhold <andreas@rammhold.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based
 devices
Message-ID: <20211005090856.ccuccgbjejs5g7gd@wrt>
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
 <12744188.XEzkDOsqEc@diego>
 <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211002213303.bofdao6ar7wvodka@wrt>
 <20211002172056.76c6c2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211003004103.6jdl2v6udxgl5ivx@wrt>
 <87h7dx2dvv.fsf@stealth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7dx2dvv.fsf@stealth>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21:06 04.10.21, Punit Agrawal wrote:
> Andreas Rammhold <andreas@rammhold.de> writes:
> 
> > On 17:20 02.10.21, Jakub Kicinski wrote:
> >> On Sat, 2 Oct 2021 23:33:03 +0200 Andreas Rammhold wrote:
> >> > On 16:02 01.10.21, Jakub Kicinski wrote:
> >> > > On Wed, 29 Sep 2021 23:02:35 +0200 Heiko Stübner wrote:  
> >> > > > On a rk3399-puma which has the described issue,
> >> > > > Tested-by: Heiko Stuebner <heiko@sntech.de>  
> >> > > 
> >> > > Applied, thanks!  
> >> > 
> >> > This also fixed the issue on a RockPi4.
> >> > 
> >> > Will any of you submit this to the stable kernels (as this broke within
> >> > 3.13 for me) or shall I do that?
> >> 
> >> I won't. The patch should be in Linus's tree in around 1 week - at which
> >> point anyone can request the backport.
> >> 
> >> That said, as you probably know, 4.4 is the oldest active stable branch,
> >> the ship has sailed for anything 3.x.
> >
> > I am sorry. I meant 5.13.
> 
> AFAICT, 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> pm_runtime_enable warnings") is not in 5.13 stable.
> 
> Either you're not using the stable kernel or there's another issue
> breaking things on the RockPi4.

I was using the 5.13 branch, somewhere after 5.13.12 the network started
to fail on bootup. Due to the nature of the system I don't have
persistent logs on it. When I next looked at the system (and updated to
5.14.x) the issue still occured until I applied this patch on to 5.14.8.
Might have been the same use-facing issue but different bugs?

I can try to narrow the issue down further. It'll probably take a few
evenings to test this out.
