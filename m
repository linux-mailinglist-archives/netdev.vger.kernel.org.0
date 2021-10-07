Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2042540D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbhJGN2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhJGN2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:28:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A119CC061570;
        Thu,  7 Oct 2021 06:26:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y12so9518711eda.4;
        Thu, 07 Oct 2021 06:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Br0I/B1IowEPVL6554FbnYOrVoIa1NtFpgkmRG+q0Xk=;
        b=jFsVr5hdHH/4GUp7/TRxD/bed2k1JETMXeERdvMoWdFY98fVpxWA0guXd6GzcGz2UM
         C21k9UUxfIOsYyuvqg5zrNF1QCi8DYAQlVLKPBf8puUMnf2NxIVZsw6/HMHZYqkkDwrH
         qYFfNp6Syy1W2MBLUKTpdR+RQGJGuFOs6hUscRcOKmecz3AvXSqa/lCPgmNp+2LR+iMN
         kwZGevAgQjsBL4eEcrfbxHAZa3o2qw91Qx20bybo4NE+8pcQZkw2YYJaRuXO9Gv4NGjL
         /esLIvQZX9NpPgQRD/DRCDd1tJvKAuI8KrBtuv/NWYqP99I+RDYypqPesMT8jiAUC9ms
         4Y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Br0I/B1IowEPVL6554FbnYOrVoIa1NtFpgkmRG+q0Xk=;
        b=qrjCXO8bWcl9/id0GoG9Kq6YQxn1fIb9Dhbzt3P9rRYPGiZO8ppemTdxHZq4YPYOJ6
         f1uH2bL9hCgAOFQu7XFlQqhcY/o/9FMEgiGxLVBqA8rX/8MtUr3AUZvXsxpzRBTbE2IY
         Wof1SHVsEAz7LUBVx+B8I5OGrQwJBp4nHgMy1PJAHtL4Il5peRwOw11e2sbx+lyGqMGK
         drOIZYn9T+h9Kr0mbKJe37427n74RTuwfKE8YwTwJsG+TApBKlAHFZQUqiHqhoWw0gLj
         BuBq5C2REaDJK2CmIl9Xzyv/l5+Z3VyJDBPoaUw25USVohIv8am1uMZhA52UbJqvFnFY
         i4FA==
X-Gm-Message-State: AOAM533rmmrHMvmZliy+GObnQBP6k+yh8KYEv3kM9qEU8oBqRawz6BUV
        4RRDVfmLdjEGRySIQhtaHE1iWWGlyC0=
X-Google-Smtp-Source: ABdhPJzZ4KeimPoiy7EgeV523alAKARD4j6wt/HpDV4LXiuiwZWPSEkRuMJoQwBtv3MARuGkWhQo6g==
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr5586969ejb.513.1633613216065;
        Thu, 07 Oct 2021 06:26:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id u6sm11339139edt.30.2021.10.07.06.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:26:55 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:26:53 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH 07/13] net: dsa: qca8k: add support for
 mac6_exchange, sgmii falling edge
Message-ID: <YV71nZsSDEeY97yt@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-8-ansuelsmth@gmail.com>
 <YV472otG4JTeppou@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV472otG4JTeppou@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:14:18AM +0200, Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 12:35:57AM +0200, Ansuel Smith wrote:
> > Some device set the switch to exchange the mac0 port with mac6 port. Add
> > support for this in the qca8k driver. Also add support for SGMII rx/tx
> > clock falling edge. This is only present for pad0, pad5 and pad6 have
> > these bit reserved from Documentation.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> 
> Who wrote this patch? The person submitting it should be last. If
> Matthew actually wrote it, you want to play with git commit --author=
> to set the correct author.
> 
>    Andrew

I wrote it and Matthew did some very minor changes (binding name).
Should I use co-developed by ?

-- 
	Ansuel
