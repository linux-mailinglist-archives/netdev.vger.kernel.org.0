Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81F331F05F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhBRTrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhBRT1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 14:27:30 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F477C06178B;
        Thu, 18 Feb 2021 11:26:50 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ly28so7425081ejb.13;
        Thu, 18 Feb 2021 11:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aw8d5niVaenZLTQo98c2VrT4Pux17Z8Q4Q6X91Kfq3U=;
        b=GPeAezxLenee31Xo7WYsfzOiXa0RGgJjYiwDgkQiabdq0SY9I2k2+j68t6u6iaPSXv
         s4Rr7rI86o/M86G+2RpMNdFADz9ws4f7PHovioyYrrCZoTY6kSCShsNa2RRaR1f+FXd3
         UhvOGRoPHiLb3Ogxf7wDNKNUr2ir1nrfEp/5jW89k8/CpK2qrJ5yYHfePhsjO5RXXO1F
         lC0I2XVGT4ijrBPtzASr3o1eoNvjkXaCMzX+AxtXUMeMoWHkUTIgIdq3+NPQkolUW+3j
         l2p8+qIvSCSfQi4DNbf7qxBSGxOvQoZ1Wc0tx9iQ/rHDKzCiTMHW+BzpqtNg9eZvfabi
         qkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aw8d5niVaenZLTQo98c2VrT4Pux17Z8Q4Q6X91Kfq3U=;
        b=ZZIir37JLB2KTkeFoFfzW1M6wpdamSculs2GBhZ7AvxswZXHz4HJ1BgloxHPPYMqvr
         1/e82/QDEaSXPKuY3gwmAUqwXFE5scpHSYSvqBS0fRFU8WcvDWJsBjAMlRG3YggVTmaw
         KQwfuMPRS8lFecxk10RQIyrb442hnwx6MTbaZtHLJcGLiJ+i15H+KDttdtjtAMGqF8Uh
         d4XooNowePW59wpIldq0wleYo3k/SOHRdbtiXbUqPjzEXW3xh/CIAhno7yi9/Rew3k+S
         1C/maAsdQzyYvpHsLW47n3uYbHXElKFFoz4n7Kz+32R3Y4Xx3piHU5dve5sEyh/VQZ/u
         WIqw==
X-Gm-Message-State: AOAM530i3Jbf+ccjrc9G29KEC13qib2JWAwQkFX+D3ExNGj5ibdGkD50
        oYvV5pVPHgquZSul23QB2qRNWhWlqak=
X-Google-Smtp-Source: ABdhPJwn4q3cnEBltpPfaLDstDNi1hwtK7htRNC3aZH/s4iY/8SIp4oDQlv04evEjyPrxHkKDYiF7Q==
X-Received: by 2002:a17:906:ae85:: with SMTP id md5mr5678930ejb.76.1613676409266;
        Thu, 18 Feb 2021 11:26:49 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id a23sm3113645ejy.60.2021.02.18.11.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 11:26:48 -0800 (PST)
Date:   Thu, 18 Feb 2021 21:26:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: phy: at803x: paging support
Message-ID: <20210218192647.m5l4wkboxms47urw@skbuf>
References: <20210218185240.23615-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218185240.23615-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 07:52:38PM +0100, Michael Walle wrote:
> Add paging support to the QCA AR8031/33 PHY. This will be needed if we
> add support for the .config_inband_aneg callback, see series [1].
>
> The driver itself already accesses the fiber page (without proper locking).
> The former version of this patchset converted the access to
> phy_read_paged(), but Vladimir Oltean mentioned that it is dead code.
> Therefore, the second patch will just remove it.
>
> changes since v1:
>  - second patch will remove at803x_aneg_done() altogether

I'm pretty sure net-next is closed now, since David sent the pull
request, and I didn't come to a conclusion yet regarding the final
form of the phy_config_inband_aneg method either.
