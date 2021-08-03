Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A43DF32A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhHCQuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbhHCQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:50:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403E7C061757;
        Tue,  3 Aug 2021 09:50:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i6so1066682edu.1;
        Tue, 03 Aug 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kz6WHa39NY1DimcXBCejglUOLZCSLGBCNYys39i436A=;
        b=GidJ4PALd8lcsN/+479wWdZjwN5ItPKon+1LgsGZDHx9vrASQ/Rm4ShGdFlftUrzqH
         QoAu/b7TUQedXNnHDd9jAC5OD/x+fJ+KU1Ax8uR0V+4iDCxeBzsN+zdX8L/GbuTkz5oz
         pysUAGB76bqKnH8xM3sBmCpFVy5x61+r6ENFAqc4XSN1tBwUhWGtOv1HT9ynTJTuwjXO
         zmk1hdAuc+jV1mhdMvHPHiS+xMZod5V6HkOU8YFpsyKQkbJphn3CYshwGAeEIKOZbZsO
         +2vcAtRltz8hdDCEhe4W5fkqWqWfVheM/y5wvjue3pz4YT0eiA4FMnutf/c02BT2cvYo
         gF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kz6WHa39NY1DimcXBCejglUOLZCSLGBCNYys39i436A=;
        b=JtA/YL8IyjYFpzDT/p1OUHODHZgPP9/AzcIvoeTTbJozEqzAlZBER/m7KUuaTDutqx
         DMorhz59TDU6m69gAysMOuwrQwxqwcOv+fxUNeBQ+cgvjgoumeJgjEz8xs0DExrpFaah
         R5C2lyDddbAZUH5KtPd/edV0y0ztnqUJiLaO3/UbTUfCZQCoUjQwyVKNRWBJcagYN/AE
         TvnG/VEveflTnnXkBYHEMaPfmfvP2vfg1Y4Jph8wVeiyi1E8p9t2U/g7gX8Od2ocrtoK
         vx7G4jxW+4LFV6ymBUjaK2kzWLWFjctevZYiyyCROOEddofqYnFSFRhvpDX1eDA2oK70
         SOlA==
X-Gm-Message-State: AOAM533sUOS7/upA5cUyqOdmrx/c7AXcSeKw9FJACXUmY0tijaN4OQ2z
        alZRuWaeko7j0+tcnswye7E=
X-Google-Smtp-Source: ABdhPJwmNyBDEg0fSP5PACTINUZaszc78lirWA5ib/lzzSZQe+Vxywl11jsMf8bIyAeX8DaOSKG/pQ==
X-Received: by 2002:a05:6402:278d:: with SMTP id b13mr27469906ede.20.1628009405884;
        Tue, 03 Aug 2021 09:50:05 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm6489399ejt.80.2021.08.03.09.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:50:05 -0700 (PDT)
Date:   Tue, 3 Aug 2021 19:50:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: dsa: mt7530: set STP state on
 filter ID 1
Message-ID: <20210803165004.za4oz7xhf6iynee7@skbuf>
References: <20210803160405.3025624-1-dqfext@gmail.com>
 <20210803160405.3025624-4-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803160405.3025624-4-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 12:04:03AM +0800, DENG Qingfang wrote:
> As filter ID 1 is the only one used for bridges, set STP state on it.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
