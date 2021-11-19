Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69B8456820
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhKSCfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhKSCfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:35:12 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA103C061574;
        Thu, 18 Nov 2021 18:32:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id t5so36371992edd.0;
        Thu, 18 Nov 2021 18:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=k5Yckb9RccWlUPuQszFg2wwJUvNEZLblC9QZZqMbmgU=;
        b=DvGxjBToMvr2TsmjQ/DNINNjU167vtTaQlb12Qh778zVzSkB+XKckKoxHpRyHFdeMD
         aU2vwAMxzPwcoigLbKWZTCH5xIvo602M2Qtei8eVvdO1+my5NdpKjGE7Ktj3i6iIMwAd
         SGPuLWduCyGaFx+XM+JXwaf2m0PvvbnEdNsIitmAugr/HNlGFIXEWd6UF4Y7cFA72OFc
         ukKkbpAnm4oUHIPD/jUdC7iXg2zoamZXMOQgNb1TQOQCaagORqrdev4NP9p6n0cHw4Y9
         bY9ppe5LDuRjKMZI3IuE9lio8tF+2LAM1Uc9OSrAUlCRsdc1rvoRrUab/uLjOPz7mg3x
         vO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=k5Yckb9RccWlUPuQszFg2wwJUvNEZLblC9QZZqMbmgU=;
        b=tQNAORnigGAFFxyhMC0Mccez8NV5guvcBJC6wRqNdd8PPTQoODq2JZH0yw702nzgyF
         TinB8mffTdsY6oYvVDA6bv62heNoBUpoUWo1v0FG8sszqsdqe4ZAUAyzeBUeQOwrPNeV
         4sTvSfimg/aRjOvx2OQy8u0FG3rDqgueZdWr3hKuCT2xtMqkFDQ/VoByj+1l2jkx4a18
         kBVKBUo7lV88iap38o86ZYG49/zVItNq/cVhGJ4IrstqXNJ0E+01ShPxy8ur4delWGQX
         sCA9Tieh3cSIBMYfGwEDYRq6aGQD0kr0Xz+xkpR2BQ/dANJRlRR2UfdyppbcHjWiahcb
         ejew==
X-Gm-Message-State: AOAM533nupY3VPEKSjqcedZu55O10WjzEKB4g6wF2IUrxm0w4TNOAd/E
        MOLx9nHKsV2/94VI6dWxf+U=
X-Google-Smtp-Source: ABdhPJwy/Yh77mSyrSUM9YB9p1B2D3NYUl+mFdSBRRnkcavYeBzWAqhtXZXzsK8nuw5ApBPcxeW0iA==
X-Received: by 2002:aa7:c902:: with SMTP id b2mr18633435edt.320.1637289129437;
        Thu, 18 Nov 2021 18:32:09 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e7sm816521edk.3.2021.11.18.18.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:32:09 -0800 (PST)
Message-ID: <61970ca9.1c69fb81.c7bcc.3d36@mx.google.com>
X-Google-Original-Message-ID: <YZcMpqRuvH63ki7Z@Ansuel-xps.>
Date:   Fri, 19 Nov 2021 03:32:06 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 18/19] net: dsa: qca8k: use
 device_get_match_data instead of the OF variant
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-19-ansuelsmth@gmail.com>
 <20211119022136.p5adloeuertpyh4n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119022136.p5adloeuertpyh4n@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 04:21:36AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 17, 2021 at 10:04:50PM +0100, Ansuel Smith wrote:
> > Drop of_platform include and device_get_match_data instead of the OF
> > variant.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> Why? Any ACPI device coming?

No ACPI device coming. Notice we could drop an extra include.
Is using device API wrong for OF only drivers?
Just asking will drop if it can cause any problem or confusion.

-- 
	Ansuel
