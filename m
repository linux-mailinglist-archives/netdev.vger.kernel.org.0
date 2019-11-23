Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12BF108011
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKWSuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:50:13 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33780 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfKWSuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:50:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so527208pgk.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 10:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mxSiz2XaGm9AwTz4aUM9cgVJt2QFWzuDloygPSaug/I=;
        b=H1joQiORVP0iuBZxhU4HFG1SvIx0B0kYQ+K+u2iWDQhTLf/AGrGEr+8aBA+E8OIpl5
         /+Tqhpp0CmsH4akc3SGYiyfN18SFTu+oBiA++cXvGbeSGSpmxSzXyEZgc/JF5/bHgBsC
         Rm4q8WYISCH8u/2oc/VE1uG6vfWqRHmV+1HydjL40q9UuZmWYYEAPEZcqFB5TpGU+pdF
         0+MahySRcGMoQzOxRCtX3tNphTE6egcNnra4og4diTbUDDeqP5AJQjsjfI2a7KegLe8g
         EuCyHb8WNJCUnD4N0Og9tzIaCraxGJsUs31l4/KmJZH1qhWuOJFE48m1VEPPLrux0w3I
         nu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mxSiz2XaGm9AwTz4aUM9cgVJt2QFWzuDloygPSaug/I=;
        b=k7ngvyGiNYZlx2cFJ6/l1Vjnc+FTyQjgGGJaVNdBHE2Q/GKNy5q4RU4p/n3XU+CxQP
         4QTq2K68ha9/EEialbHA4A431xDdYLR9/zjMjsjJV2PM/XGOFFYR/cuWifVKpX33ip2L
         CD8aqlDvu+mmisIz+fIY5vt//9z18G4MxrXzGiiRxy8QHkufMhDdW2Q+Vh9Up8JF3Wob
         oCBuQExWTp7EEe45MpwTFdpwJSEuGuR+c2d0cdvESymDDVdHgyjjP4O+vg2tj0QGaSIO
         7yS7i814mRhzjxTevm60Fjf3O/lHuw0ZyhQmwp0BbqYFqJykNmKwkflHws1MXpCeiAyx
         9Lcg==
X-Gm-Message-State: APjAAAW0/C32uLnN4Y/ZpU9XQE2RPd5dIF5QjwihvSGlTcOQMmYNh1PN
        e3rNID1emJDI1GojkKhxCJUxUb9bZF0=
X-Google-Smtp-Source: APXvYqyCSdpnXOPPsMbh1tsrPaBxIbYsYuUeh1xsa/AU9jEEHO9L4tXhL1QhHDbcWsSgB8vxswY/Og==
X-Received: by 2002:a63:fb15:: with SMTP id o21mr22608816pgh.193.1574535012774;
        Sat, 23 Nov 2019 10:50:12 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i10sm2683720pgd.73.2019.11.23.10.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 10:50:12 -0800 (PST)
Date:   Sat, 23 Nov 2019 10:50:08 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: initialise phydev speed and duplex
 sanely
Message-ID: <20191123105008.1a2305bd@cakuba.netronome.com>
In-Reply-To: <E1iYAmJ-0005gz-Hc@rmk-PC.armlinux.org.uk>
References: <E1iYAmJ-0005gz-Hc@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 15:23:23 +0000, Russell King wrote:
> When a phydev is created, the speed and duplex are set to zero and
> -1 respectively, rather than using the predefined SPEED_UNKNOWN and
> DUPLEX_UNKNOWN constants.
> 
> There is a window at initialisation time where we may report link
> down using the 0/-1 values.  Tidy this up and use the predefined
> constants, so debug doesn't complain with:
> 
> "Unsupported (update phy-core.c)/Unsupported (update phy-core.c)"
> 
> when the speed and duplex settings are printed.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you!
