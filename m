Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDB23F8B02
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbhHZP2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhHZP2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:28:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD134C061757;
        Thu, 26 Aug 2021 08:27:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2615175pjq.4;
        Thu, 26 Aug 2021 08:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=EsDDLFruXfgXRGBZ4psfYrG5xfY4R6rx1WaKqay82xg=;
        b=SYQ4w04r1YPinHAM+T4jRVRpPJhOSpjnJjngD6fmvJjfkVUqfvsuS7U5XuB35Mzg9Y
         j5GCZ0QXaN/xzJTwfmx5CgXnJQTMn88R318UQg45dsQutt4Vp0TDIJZiU6qBWH+wePi3
         gC2l/trUQ4rgzP8l90aKAg+HNpagV4/XNd9685pxUq4AWmLv7rDo3/U0kKUD/421Tdl8
         IFsMF60TponD8ZnQk60fjZneakmVnnT4p580IIvFzR7Hoat/JW9Yz49P5o6iCOfCs6Jm
         EqTFFIgVCniovO+cAhLAt+GVlzwmwZbi8wgQfD976yC9wCxHPPMei3pUcrqKAAf09nLi
         ki/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=EsDDLFruXfgXRGBZ4psfYrG5xfY4R6rx1WaKqay82xg=;
        b=Ywc5smT9NgPAvKCJBqBzfHWqNxddAC8Zw5fyN9TdlH89SvzNvDx+TWuNGY4Glp0Qvn
         l7k+B22GikUVtRzCdoAM8t/+Zt+w1J4yWQr/jauZClccb4H0lGGWSbXUzq9Yw70i9I7v
         N4cjRkD6J5yYIT66t+0j86H9v6x7BSwq1Yxu9pZabcr2EtzNVvlWK28azZI0w6Nuw1c2
         Qea0HRxUkUw48r2XkrIRnqO5bCsJWQ4h6Nl4se3X3OiIvJHiz9C3uWvJD3qUNtNivRq4
         4a83J+suiw5EegjL29bnESUmfHtXYBjAlwtip9POGM5eMKPZ+y3FXd6bSZ8iEm0+WWsQ
         IqzA==
X-Gm-Message-State: AOAM5307KoGkDC3RLtGuPImSslwqkwBrYbbyoGV7NO1WBFjmxLFXZgHF
        Y4NOgzeL0qxJJyxXSLMCx/I=
X-Google-Smtp-Source: ABdhPJzgulZo1l4aidr56hzMH6tvcn7ua9S8kOn5bpUgwTIF5YUsvQDRBUxw2ie25n0kV5INj6CX0Q==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr17402574pjr.18.1629991666283;
        Thu, 26 Aug 2021 08:27:46 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id e21sm1505066pfl.188.2021.08.26.08.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 08:27:45 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 2/2] net: dsa: tag_mtk: handle VLAN tag insertion on TX
Date:   Thu, 26 Aug 2021 23:27:37 +0800
Message-Id: <20210826152737.3280662-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826141326.xa52776uh3r3jpg4@skbuf>
References: <20210825083832.2425886-1-dqfext@gmail.com> <20210825083832.2425886-3-dqfext@gmail.com> <20210826000349.q3s5gjuworxtbcna@skbuf> <20210826052956.3101243-1-dqfext@gmail.com> <20210826141326.xa52776uh3r3jpg4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 05:13:26PM +0300, Vladimir Oltean wrote:
> On Thu, Aug 26, 2021 at 01:29:56PM +0800, DENG Qingfang wrote:
> > 
> > The comment says the VLAN tag need to be combined with the special tag in
> > order to perform VLAN table lookup,
> 
> It does say this.
> 
> > so we can set its destination port vector to all zeroes and the switch
> > will forward it like a data frame (TX forward offload),
> 
> And it does not say this. So this is supported after all with mt7530?
> Are you looking to add support for that?

I already run-tested that, it works, as long as there is only one bridge.

> 
> > but as we allow multiple bridges which are either VLAN-unaware or
> > VLAN-aware with the same VID, there is no way to determine the
> > destination bridge unless we maintain some VLAN translation mapping.
> 
> What does "VLAN translation mapping" mean, practically?

It's just VLAN remapping, as you stated below.

> Other drivers which cannot remap VIDs to internal VLANs just restrict a
> single VLAN-aware bridge, and potentially multiple VLAN-unaware ones.
