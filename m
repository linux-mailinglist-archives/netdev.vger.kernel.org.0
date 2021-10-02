Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1361941FE44
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 23:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhJBVe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 17:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJBVez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 17:34:55 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF254C061714
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 14:33:08 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m14-20020a05600c3b0e00b0030d4dffd04fso4073935wms.3
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 14:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rammhold-de.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=F8UDpjnQBldDuJU6rmGvahmZPDxt2kePCnSKQd7HXG4=;
        b=mO6R2I6M03AiFu8in1neOBOyhQC4wruqS8jIb65NFHgVyDhLfLEGsWSRSEMdg8Lxf+
         w1HsRqLxbRFSVT+NDYnQ9Xz4WYTD+ZhVraUIRhb1CdMc55vaUK/zyYHEis2XBY/DB7e0
         DHYprqwdAXeL6K/qKRDC/a9t/reNtRCUCxe8EiofTTJ53GVCRio+sH4/E5FlumZrM2v+
         HP3DNTEZSfIzNWZ9Yq/nbKq8xGm3tWhbhHQIxXvkYVJ+/DXoowuhHDxWLHfduLdfapMx
         5/EURzEBLVRUlsAv8629USZEncKnVb0VBcfrZh/tXqb+x/UCSVgX+XW100m2F6gOzfU4
         gwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=F8UDpjnQBldDuJU6rmGvahmZPDxt2kePCnSKQd7HXG4=;
        b=h8WI3ZwLDaPCfeTIfVCE71VdNBv1xPAasOsJABy0g4sKUDgWNyCapGvrY+ut/RZI38
         Lv88enjoK/nH3f6bi7WJiGdKDJdMqA6Gt0llavkRso46QKsiFXV+PMTn6QoNF6OGzkx/
         2N99XQpemxcGZOKBSEcSUBM2IPRuIMKIK1DNEIHcuRue3tY5bED5lvbZSLC2y5VPEl4C
         wXiHQepFX2l7PkQHrab+dHKWF0mdFCN0nU19/CMfRqqIc0Xu8ittXAN2/voVVKT/i+jD
         lDrwp6SFbKBW4/mtgk0rkU10lZucWi2fynt+z0gfTfthUakNk2znDwTqoVCg+ODMvFhL
         Tijg==
X-Gm-Message-State: AOAM533+NqCmqsHgBk/AwG281IkppxR8o4iGR2LiuTJZm9OhcPG4sovO
        RGVdMyrEnWpm5EJ+dSCteivDW0hFzQ0stg==
X-Google-Smtp-Source: ABdhPJzJ8VTihT1Ur7aTqVIXTAXPkfuDMOgeW55F8CPfPRDayvZ86vq/Z0sKuqHwd3ApU5byeI4PDg==
X-Received: by 2002:a05:600c:358d:: with SMTP id p13mr10979016wmq.71.1633210387458;
        Sat, 02 Oct 2021 14:33:07 -0700 (PDT)
Received: from localhost ([2a00:e67:5c9:a:5621:d377:9a16:5c6c])
        by smtp.gmail.com with ESMTPSA id d8sm2449356wrz.84.2021.10.02.14.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 14:33:06 -0700 (PDT)
Date:   Sat, 2 Oct 2021 23:33:03 +0200
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
Message-ID: <20211002213303.bofdao6ar7wvodka@wrt>
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
 <12744188.XEzkDOsqEc@diego>
 <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16:02 01.10.21, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 23:02:35 +0200 Heiko Stübner wrote:
> > Am Mittwoch, 29. September 2021, 15:50:49 CEST schrieb Punit Agrawal:
> > > Commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
> > > while getting rid of a runtime PM warning ended up breaking ethernet
> > > on rk3399 based devices. By dropping an extra reference to the device,
> > > the commit ends up enabling suspend / resume of the ethernet device -
> > > which appears to be broken.
> > > 
> > > While the issue with runtime pm is being investigated, partially
> > > revert commit 2d26f6e39afb to restore the network on rk3399.
> > > 
> > > Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
> > > Suggested-by: Heiko Stuebner <heiko@sntech.de>
> > > Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
> > > Cc: Michael Riesch <michael.riesch@wolfvision.net>  
> > 
> > On a rk3399-puma which has the described issue,
> > Tested-by: Heiko Stuebner <heiko@sntech.de>
> 
> Applied, thanks!

This also fixed the issue on a RockPi4.

Will any of you submit this to the stable kernels (as this broke within
3.13 for me) or shall I do that?
