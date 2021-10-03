Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512FD41FEF8
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 02:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhJCAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 20:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbhJCAmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 20:42:55 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576C3C0613EC
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 17:41:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s17so48567810edd.8
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 17:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rammhold-de.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kdKO57eCkdze/jd7Plag9VFbHkkxaEwpzt2ifTzkHVE=;
        b=H0FByiDlJrJ/8I3Qlp2xMJAzdTJlxDmiKCr9USQOQXY54BrsW7ylzbzzKU4Vy/0ivT
         H+8ct0fWHhVn6z7d0zDIzzpnaw9WtaWJMkFTTSF4JfogeS0/+nxCZOPogWY6epfJ8SKp
         T9ZDGcyVaLysC1LdoLQAA9I9WOe+FnyKshUF0G7pgQE5Id5DyaIa/prPi1ofFhOLNnsQ
         x349WRVfmx2877e9I7czhNKZEjCQwsFigRP6vhmM9arAC8CQcdjGItEzdBhDe5PPQ67n
         zaxyX+uPeOV8F70Lhi1yyDp2nJDzBvGWwjjPV5Nz225JM8km+Uuop/9KwuTjTQqjIydK
         7yNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kdKO57eCkdze/jd7Plag9VFbHkkxaEwpzt2ifTzkHVE=;
        b=hCDP39HnTDl9UrNz64ErBi1DBTwlGK7X53jRtYV7IlKlqZ1A8mCUso4xXAySeuHreE
         JWFOSg2C/xUCb0dcLwm/qFsjrHmCpmIxr6AreXR3+MugWreHk5uB3/Z76kxNyfx3YXZw
         yFX2FRDG9G8gr8PzUhJkl7u/BoGvflAnPbabOfNjZs2uIo8X7y4h19bBfbkGOMMdrtbg
         C49xZm/ztWFIC5Q3FT8k7FkuXYp33zpph+e/2g02lK4wiFDZCd/S6RYO6YEmStv9T4rM
         Ujh02Je1HRQ66mAGxc9XSMP1z6nsJw8RdmeQ9yUeAyFJEKVeuoItR/vYyE9qrhIYJeRr
         pN/w==
X-Gm-Message-State: AOAM531vA2ir9EuY7btHRri4F+Iaj5GPa20Br+1dOCT6+KcUacpnIERm
        vS+i+KrtHQo0n7PrU0HgdMKWcg==
X-Google-Smtp-Source: ABdhPJzhz3Hpxru8q49ncXt0lESjDoisbpiQOpm5LyfVFdGxCsStypRw/Nvyo/Sp/rIg81Zc0MNqBA==
X-Received: by 2002:a17:906:2441:: with SMTP id a1mr7407973ejb.414.1633221666843;
        Sat, 02 Oct 2021 17:41:06 -0700 (PDT)
Received: from localhost ([2a00:e67:5c9:a:5621:d377:9a16:5c6c])
        by smtp.gmail.com with ESMTPSA id q11sm5183779edv.80.2021.10.02.17.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 17:41:06 -0700 (PDT)
Date:   Sun, 3 Oct 2021 02:41:03 +0200
From:   Andreas Rammhold <andreas@rammhold.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        netdev@vger.kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based
 devices
Message-ID: <20211003004103.6jdl2v6udxgl5ivx@wrt>
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
 <12744188.XEzkDOsqEc@diego>
 <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211002213303.bofdao6ar7wvodka@wrt>
 <20211002172056.76c6c2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211002172056.76c6c2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17:20 02.10.21, Jakub Kicinski wrote:
> On Sat, 2 Oct 2021 23:33:03 +0200 Andreas Rammhold wrote:
> > On 16:02 01.10.21, Jakub Kicinski wrote:
> > > On Wed, 29 Sep 2021 23:02:35 +0200 Heiko Stübner wrote:  
> > > > On a rk3399-puma which has the described issue,
> > > > Tested-by: Heiko Stuebner <heiko@sntech.de>  
> > > 
> > > Applied, thanks!  
> > 
> > This also fixed the issue on a RockPi4.
> > 
> > Will any of you submit this to the stable kernels (as this broke within
> > 3.13 for me) or shall I do that?
> 
> I won't. The patch should be in Linus's tree in around 1 week - at which
> point anyone can request the backport.
> 
> That said, as you probably know, 4.4 is the oldest active stable branch,
> the ship has sailed for anything 3.x.

I am sorry. I meant 5.13.
