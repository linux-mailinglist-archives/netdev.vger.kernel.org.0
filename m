Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2194A41BBEA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbhI2Auz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242614AbhI2Auy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 20:50:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE7BC06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 17:49:14 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id l8so2052146edw.2
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 17:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gvsxAqsgbnQvT7oqH70U/GQ9oqIieKOoQb1QAt4Wgug=;
        b=PdIdkcQvvHxDCsgemFZkys3lp6HDDmuaFmkWLiSm8CduGwudU6ym9f0JrtTluYUqh7
         UPwIll4sFam6oOhXl1rBo8Ih0kFKqB/xV1Kjf3pZ3FoZofZ2hmZt0ZMN/0SKjPRnQzng
         oujyxI8gqt7488W6a82/EIc13Lv2IiK2TZdjxChfJ96smZ71TdyJcX49aluZJgYMl8g4
         pD50XYZbTrdvMddvckxke0WYmlY8Xi33hJmapHIEshJLS01ko8rRJu4IyjZL9OahWkur
         Aw2KRmzNIAr3NbTZhyZbtSrckRmNpd3p1DvM2mrlL+4W2eM0+HhSa6YNgi/02pKHOCkQ
         Ukdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gvsxAqsgbnQvT7oqH70U/GQ9oqIieKOoQb1QAt4Wgug=;
        b=xnKulcw+ZPDB0U1F0dtjWqmP2a/iqhIMMfEVqsrJY2O3JnJNoM0CKNEbu476RxYDyu
         Ztb4HehBpSEr0w4dXKlkWmBugs8T3IA9yf8bbp1dz2f7zQxo/6FpYr3kMzC2XpGha9LT
         bW1Q0/dhfAmGas9nokwypF+VBreCER5Izq6yd3Cv+GcGPopmGMTH4ucPg4arJxOFwp3/
         VxltcbZkj5I1hcbxcjTXVaR/gwatC7AIUfBaRo0wRARcc1EGArasvw7pep++4sesQUBG
         ZeFvdtbb2kd/RfgTG0hGhwd8Bsv5HBABZnQQJRHM9wJZsH59iAhLw66ZdOD9LB1xcbzP
         IRkQ==
X-Gm-Message-State: AOAM5319D6pral2JyIxBfsx3iA4o9QOI+TWeMpPn7iJjEk5ssp9XO4tB
        bF+E+bQnfYD9oHc8aSTBfA8=
X-Google-Smtp-Source: ABdhPJzx/hxK+OWdSTIFKcZWzuz2X34Kxd9tDW2qQmGozRJSxNsy/wYq90YEtUvN0GNs3feW+m7FaQ==
X-Received: by 2002:a17:906:640f:: with SMTP id d15mr10694394ejm.419.1632876552721;
        Tue, 28 Sep 2021 17:49:12 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id cf16sm380318edb.51.2021.09.28.17.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 17:49:12 -0700 (PDT)
Date:   Wed, 29 Sep 2021 03:49:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6 v8] RTL8366(RB) cleanups part 1
Message-ID: <20210929004911.o3pnn2oecqviuyht@skbuf>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
 <20210928172519.4655ec60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928172519.4655ec60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 05:25:19PM -0700, Jakub Kicinski wrote:
> On Tue, 28 Sep 2021 16:41:43 +0200 Linus Walleij wrote:
> > This is a first set of patches making the RTL8366RB work out of
> > the box with a default OpenWrt userspace.
> >
> > We achieve bridge port isolation with the first patch, and the
> > next 5 patches removes the very weird VLAN set-up with one
> > VLAN with PVID per port that has been in this driver in all
> > vendor trees and in OpenWrt for years.
> >
> > The switch is now managed the way a modern bridge/DSA switch
> > shall be managed.
> >
> > After these patches are merged, I will send the next set which
> > adds new features, some which have circulated before.
>
> Looks like v7 got silently applied. Would you mind converting
> to incremental fixups?

David LRO Miller, merging everything in sight :)
