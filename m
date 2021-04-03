Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12573353440
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 16:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhDCOFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 10:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhDCOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 10:05:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F3BC0613E6;
        Sat,  3 Apr 2021 07:05:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id dd20so827838edb.12;
        Sat, 03 Apr 2021 07:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gr5sUZoA0I/5zcq34lqqOFzBvmsdkhLPsA9GdyxgGFI=;
        b=STddPVtr3tIM9EcAZ1GKjQXAeC4jQAjsHB/u02ct35griIwdwIkpArrBgI89Tizykg
         D7EakXwPWembJzJXiRbr17FehVzY4qHXdHbUlrLeBcgZ5yJrGHKZT/0WG9vZw5m6RYbG
         LAMyP0miXCn6VsSrR/zd6xEcwNElDc6YXsKt+ydnnjVjNAzMCcdmwVAWaS+o4AFnJ4Oc
         n1nTyWICDPVlSsTD82XDCzC+v9FiM1yn5tURsvTsiW53on5fcVA+fToJpRxgabxcSL6A
         w8KQNR3m899mSSyZITudNMz5Z5UP3XpAZouT+Bw0qfoQ+x5i3Ailsp/eOH/kcxXer59l
         bjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gr5sUZoA0I/5zcq34lqqOFzBvmsdkhLPsA9GdyxgGFI=;
        b=fToYdskLHx/YWk09gxWaGLlZHKEdJV6p00c0lrnWoFaB3271SpABUZVpWIkg3S+k9B
         J8vrqqv9WvlsFCcscQNQF1NedZO3UpOGH1kLBI6xE9F3oMz0o3rR13GPMQSRV4NSOBwt
         PWTUb7sq00ak2g1iYpLewFYJO1t8QZcWiq6lQAt58zgaqBRlKEFvDBsvKbkH8d/x/1f7
         GEaEAMj92OJmLY2ZmkINAdhpBFQUnsJWt+jxGDMhZ3Is0M0rduv13vIxS3ciE2mmMYzu
         dR2BV1d1mcea4dfTNCgCuxxGnQTRDew28nj8Zq7W0FFMFn/FvHBrWHkjtdVXVjCQELKQ
         YN/w==
X-Gm-Message-State: AOAM5329d7+06dLE9BGM774POZU3g0qeQVeovXZ74YvAzSxr4VH3bRVj
        ebLVeWaOR3YI7x4TR8PpETg=
X-Google-Smtp-Source: ABdhPJxao6+CxhL788xbXrHjGzZRZIMDAEnMuPQ055OZFjtix/ZD7XBl2UQXDAXj084VKhj6iJs5Bg==
X-Received: by 2002:a05:6402:4407:: with SMTP id y7mr21248404eda.247.1617458736372;
        Sat, 03 Apr 2021 07:05:36 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id h15sm7079339edb.74.2021.04.03.07.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 07:05:36 -0700 (PDT)
Date:   Sat, 3 Apr 2021 17:05:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/9] net: dsa: add rcv_post call back
Message-ID: <20210403140534.c4ydlgu5hqh7bmcq@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:48:40PM +0200, Oleksij Rempel wrote:
> Some switches (for example ar9331) do not provide enough information
> about forwarded packets. If the switch decision was made based on IPv4
> or IPv6 header, we need to analyze it and set proper flag.
> 
> Potentially we can do it in existing rcv path, on other hand we can
> avoid part of duplicated work and let the dsa framework set skb header
> pointers and then use preprocessed skb one step later withing the rcv_post
> call back.
> 
> This patch is needed for ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

I don't necessarily disagree with this, perhaps we can even move
Florian's dsa_untag_bridge_pvid() call inside a rcv_post() method
implemented by the DSA_TAG_PROTO_BRCM_LEGACY, DSA_TAG_PROTO_BRCM_PREPEND
and DSA_TAG_PROTO_BRCM taggers. Or even better, because Oleksij's
rcv_post is already prototype-compatible with dsa_untag_bridge_pvid, we
can already do:

	.rcv_post = dsa_untag_bridge_pvid,

This should be generally useful for stuff that DSA taggers need to do
which is easiest done after eth_type_trans() was called.
