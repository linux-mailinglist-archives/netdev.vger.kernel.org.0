Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217AA41EB4C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353717AbhJALDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353710AbhJALCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:02:49 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B196DC061775;
        Fri,  1 Oct 2021 04:01:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id q17-20020a7bce91000000b0030d4e298215so894111wmj.0;
        Fri, 01 Oct 2021 04:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AlljMHBis/HGJBiP3p84b0NWwK4Vv/mNrhgfG66xRN0=;
        b=kL8k3KExxNPjOhmf5Yc13M8iZH785dkPpqzkefCPkoYoobgeIRoIHDV8wgOno4cJnI
         QBGI7Ak9zU7bgiDFYIMUJ7i6bSpO/5cGqY6Od1wDemxYR6iCuh4UEMviiE4BK3Z45RqJ
         1LrZ85eo6KjDTmJvv1H3XMLHoh0Vz7Jdw5GuBHZUxXDF6kQwd2SrlfkdUdzxHvEQiP2q
         uhkHMHTfJF2yV/HucKogY5JzXGXRfcAq60mT8AUjImo451ZxpQYjK373T2zdPg1AUX6N
         AYB8xSYi/WM5rW4AyPhDw0gqEWyVfmh8HDPGmBPRL8iy+ypNZU1hzys3VllwC1P/TrKg
         ut4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AlljMHBis/HGJBiP3p84b0NWwK4Vv/mNrhgfG66xRN0=;
        b=5obvZzoNw99d6fy9vdldFGxvaffoXcnPkGU/1zMV8l5ahbhvYdHtmnZChcOIwueztY
         /zs5e7Wpy0MmtLIEA4cnwatQ3NsqVVJRJWIgmgbnXpTn5xw0NQw67ZciqqBmiV1pr0Pa
         PLiKSeRNXyP4xwWnn/rZ+4AwmBI8VZh9rGFfxfk5XUA1+QUr/MyvEnPYcJeJ7hhu693M
         XGIqxJWm/e8Xz+9wHO46ynoIvIH6PmmEsTkqZjDUa1YEwxeaz2RPlBu9+G5MHhL9UYNe
         cTE9lvjLtQik7OWdwTjexfrzZNOi6jkX3Lp972RA5EPutF3eGdW/etf5gd4X8HApwGvp
         O6uQ==
X-Gm-Message-State: AOAM531NbfYlpEGEAlLWllZ+M5ycrD84XAdzBvlWUsZNXaTj65bgtIES
        sJiAfM9EOGG/n2/yGIo0iOYTQGXuGWI=
X-Google-Smtp-Source: ABdhPJzLsgwBDTgq0mPqkClwiGnbU8lLscbd3XxcsEkz1bR8+RG3h7laXw0AK7hf+stOwcAdlLKVHQ==
X-Received: by 2002:a7b:cb4b:: with SMTP id v11mr3803605wmj.155.1633086063029;
        Fri, 01 Oct 2021 04:01:03 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.gmail.com with ESMTPSA id q18sm7337204wmc.7.2021.10.01.04.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:01:02 -0700 (PDT)
Date:   Fri, 1 Oct 2021 13:01:02 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] drivers: net: dsa: qca8k: convert to
 GENMASK/FIELD_PREP/FIELD_GET
Message-ID: <YVbqbq180jgrhiIe@Ansuel-xps.localdomain>
References: <20211001013729.21849-1-ansuelsmth@gmail.com>
 <91eb5d7e-b62c-45e6-16a3-1d9c1c780c7b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91eb5d7e-b62c-45e6-16a3-1d9c1c780c7b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 07:14:13PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/30/2021 6:37 PM, Ansuel Smith wrote:
> > Convert and try to standardize bit fields using
> > GENMASK/FIELD_PREP/FIELD_GET macros. Rework some logic to support the
> > standard macro and tidy things up. No functional change intended.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> > 
> > I still need to test this in every part but I would like to have some
> > approval about this kind of change. Also there are tons of warning by
> > checkpatch about too long line... Are they accepted for headers? I can't
> > really find another way to workaround the problem as reducing the define
> > name would make them less descriptive.
> > Aside from that I did the conversion as carefully as possible so in
> > theory nothing should be broken and the conversion should be all
> > correct. Some real improvement by using filed macro are in the
> > fdb_read/fdb_write that now are much more readable.
> 
> My main concern is that it is going to be a tad harder to back port fixes
> made to this driver with such changes in place, so unfortunately it is
> usually a matter of either the initial version of the driver use BIT(),
> FIELD_{PREP,GET} and GENMASK, or the very few commits following the initial
> commit take care of that, and then it is all rosy for everyone, or else it
> may be complicated.
> 
> You are one of the active contributors to this driver, so ultimately you
> should decide.
> -- 
> Florian

Problem I'm trying to solve here is that I notice various name scheme
used and not an unique one... (many _S and _M mixed with MASK and SHIFT)
Various shift and strange bits handling. I think this is needed to
improve the code in all the next release.
About backports you mean for older kernel (bugfixes) or for external
project (backports for openwrt, for example?) Anyway in the main code
(the one in theory that should receive backports) I just reworked the ACL
code that should be stable and the switch ID handling (I don't think
there is anything to fix there). Aside from that and some improvement to
VLAN, I tried to implement FIELD_PREP only in the define without
touching qca8k code. 
I honestly don't know if this would cause that much of a problem with
backports (assuming they only touch qca8k code and not header).
Would love to receive some feedback if I'm wrong about my idea.
Any feedback about the warning for long names in the define? Are they
accepted? I can't find anywhere how we should handle them.
-- 
Ansuel
