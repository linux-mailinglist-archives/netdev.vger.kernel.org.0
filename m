Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF4E474CD1
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhLNUzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhLNUzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:55:19 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96266C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:55:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z5so68053374edd.3
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1w8aBA4E+7NGNWSKQpbqbx/6haGUUDyNG+UHDOSKO9I=;
        b=FjGQ1/pp2JzBAI6UahjW0gNKYeCub96qxTF7OiUQNuthakA7MvNAnQelaBY2YbripF
         Ul50RUk8yXVmsxadpY8lLKfAmVLg0FVmFJWvfypXLQRBpCVWz4y/JdeNqxh0sZOXawok
         k9DVxTGE1C0WxHsq0luA65QV+7e8rlil+F5WN57P671xCUQK91Y9ZGGR6xpXr4qI5a/p
         rNFmnLTg7YddoHe7dqnS06Av1NGYj3DjL2p51aDIAXJGIJsNiUc9yIRm7kg7M35oa5He
         iwdEoIJ8V/5P1buksXEE+9CuYrGsm53cTerv+c0G3r780gvGVRgSqaLygSODWwbZ6zHX
         gi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1w8aBA4E+7NGNWSKQpbqbx/6haGUUDyNG+UHDOSKO9I=;
        b=kz25R+VpbbnUIEA2crleEfgl4rkl8BYzbRlBdvDGUOmXE7isR/k2WeF+tbCFpRdPxw
         OM7ZT/Fj70jvN73UjHjBEnoSB0CbqQK94jKpmx/kGAEZt44/mAmTHi2dw2oHN5twIEH1
         JOSVlOMi/TvlmwMKfjbPA02dDEbJH9CDC6BBAsu46ab2gmLhI1cQuLIYx1yXtTqzmJhu
         sFXVkdRG3YkoNSF/5n4w52AkPjX1b694Y2115D1s57aiWOMKrgXjYBz8Ck3a8aCQbtLE
         QhQnuXmr9RnA+bYuqWc2fRgRmElO9MlBeM6rY3vcFTzNLOLI1LEeoUWCkyvcG67RwUaj
         wIqw==
X-Gm-Message-State: AOAM530v01KC8Bqadr3bKybfkrE5WqUErKnJwDxK8fesqQTfJS3lR3Vp
        Gwch38bneK2i8+wduORaQhs=
X-Google-Smtp-Source: ABdhPJxbcHuUfRtvu86RTrYiMfUNF8UHcKiMfVLRaaxhkBOT+ihcteoTET13C9hrnmYvPtqnI2b8OA==
X-Received: by 2002:a17:906:55c4:: with SMTP id z4mr8295311ejp.665.1639515317184;
        Tue, 14 Dec 2021 12:55:17 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id s4sm266950ejn.25.2021.12.14.12.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 12:55:16 -0800 (PST)
Date:   Tue, 14 Dec 2021 22:55:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/4] net: dsa: hellcreek: Add STP forwarding
 rule
Message-ID: <20211214205515.of5wifohpwyyxywm@skbuf>
References: <20211214134508.57806-1-kurt@linutronix.de>
 <20211214134508.57806-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214134508.57806-3-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 02:45:06PM +0100, Kurt Kanzenbach wrote:
> Treat STP as management traffic. STP traffic is designated for the CPU port
> only. In addition, STP traffic has to pass blocked ports.
> 
> Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Kinda "net" material?

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
