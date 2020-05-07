Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0344D1C81E6
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgEGFzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgEGFzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:55:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B89C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 22:55:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y24so5270952wma.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leon-nu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oH3LjbuNvDT9L8S5Sf69u824MeEV5cEtswBnzJfZKgg=;
        b=NtQ9lrEB0RKmvJcKiFzKnz9QfMiUbEXXjSe/p7wlkumIjpn8oRgUaELn6nJE6+2mwu
         eXq4XStBUlPFpoP7TZhinRFDLHkIVkcxHvIXhU/OEMPZK2iLNXl++NcXynu44/BVTlIn
         rVh6p9N05KTDa9Q8ype8NNg2HnUWiPAd3wP3AzpbjjlhbKDy3Xx6bX2MASwUnDq/e9sH
         NpPRGLQdiSfRxfqGDpqARRojvEVXdkbhH8c4G/uNC+4VE+5mkWr1oASrxa68BA9bhq1D
         Ks+uYM4F4sB7PlGSmjPu//nwU8Pla6FjKmc/oxCpG6pwK81I+kxqrhid3dpNLpAPvwsk
         VLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oH3LjbuNvDT9L8S5Sf69u824MeEV5cEtswBnzJfZKgg=;
        b=uDfk38Z2yrnOeAGLofUP9rdAZoJ+FZkRCVLNqcf7QkNAwXB1PUcuJwFnbxRBQ7H3Td
         VLny/Ja+z3fOZDGWrOQlKphcQYaVrE7LnJjnlqBobrM2QXAf43BWO2bVdXC39HxDxicb
         jx6ZXGgFX6AeRNxN4HLkKCkjZfN2lanyd7dnxNquDQqhrndU0gv1gCKK7VigBtGJq1fK
         OqHb/1S75VuXispmcHekhKK+TJu0soJSq4Vp0tdyQ2N2qwWSHjs67tpYRrH1yAbddH/p
         a30TqGuLT0lbr1nqCnn6LkE9pBL3BIIEmZq99zL+V8k2jrc/lV59F05lTJ6IKB+4J7X2
         kQMw==
X-Gm-Message-State: AGi0PuZtPACVoiJolO4LbyNaZyR01SlKkjPV+KauzZysHohc2f/3SP1A
        5L8gs/GzKCpSCCvlfKWZvOQOZQ==
X-Google-Smtp-Source: APiQypK8a3UU8ELR11PAnuJfpnQYv+HCtC1y98AmPp3kCtHlJNWMr93w7mzfA1WmRqve6h0Pe9LTrg==
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr8648512wmj.170.1588830950010;
        Wed, 06 May 2020 22:55:50 -0700 (PDT)
Received: from localhost ([2a00:a040:183:2d::a43])
        by smtp.gmail.com with ESMTPSA id i129sm6614225wmi.20.2020.05.06.22.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 22:55:49 -0700 (PDT)
Date:   Thu, 7 May 2020 08:55:47 +0300
From:   Leon Romanovsky <leon@leon.nu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
Message-ID: <20200507055547.GB78674@unreal>
References: <20200505140231.16600-1-brgl@bgdev.pl>
 <20200505140231.16600-7-brgl@bgdev.pl>
 <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
 <20200506122329.0a6b2ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506122329.0a6b2ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 12:23:29PM -0700, Jakub Kicinski wrote:
> On Wed, 6 May 2020 22:16:11 +0300 Leon Romanovsky wrote:
> > > +#define MTK_MAC_DRVNAME                                "mtk_eth_mac"
> > > +#define MTK_MAC_VERSION                                "1.0"
> >
> > Please don't add driver version to new driver.
>
> It has already been pointed out. Please trim your replies.

Off-topic.

Is there any simple way to trim replies semi-automatically in VIM?

Right now, I'm doing it manually, but maybe there is some better
way to do it.

Thanks
