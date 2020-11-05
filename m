Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775F42A739C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbgKEAHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbgKEAHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:07:48 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F06C0613CF;
        Wed,  4 Nov 2020 16:07:48 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id e18so84123edy.6;
        Wed, 04 Nov 2020 16:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W+nQNP2xeQpKAeFOiZ8Y3ubuECiJeguJA48y5TOLbV8=;
        b=ObjOEB5xVAn1nNX3SDJ05Ef/7uvSbqcVlTGApotos5HDnEE8jyR72A6M5GYC7ET0CV
         /GKdwzDdXqQsGnsD+SRFGr/EWrBO+hNTPE7wZvME+iuMO5e8u/X9+0Rdtt3LU6Hyhwlf
         pi6Oo7eQ9eG9tnI3DZWn/YXLhOs+5/fDVyz7Xd1BXpPZENlWcmRqe4Cgrn7hAyhFGLrW
         qneR6JN0UwW+q2rD5rFhaY9G/Be4dRJbA7wV/ZmuM8n1AL0KLc8gGk3eNITwwoyj2G5i
         seYafuG+TGi+M5KKPH7eO9NG906P1/niT0lC+M1k5m/r7aZDHkEDkM5XmGghrIuMm8uV
         8e+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W+nQNP2xeQpKAeFOiZ8Y3ubuECiJeguJA48y5TOLbV8=;
        b=NdV05VF70Zttqf2T9wUHY0+yF4DZDWbEhsjB0LnDH+Mxwo4kZ5UK087zOSATIcof44
         8ax+h2+VBZW5Mno1+EcjJCDXtq/TgX1MRsBBDyxKY49ylcCTV77Ho2G8MVgx8Xu6Iwki
         1FgCAsduLtakyXBQxW7wHt2kZHeytS6RLZY/1IBMxRBI7+4tO2id5UDnL6lR6OvqMKkY
         +smPZor0oXAnOk3Cxr29vKfb9uvu9BcX2gMd9NRFpLxNpyc6An0UD5TdWCkylIJXsZxl
         KiBWWvcgusN5eSPxHKfcd0bhmLX2SpuS+XoLlqxjzXUYh+0IfOFA4ll6pf7bI49W5Ien
         1gyQ==
X-Gm-Message-State: AOAM531DHyLlazEdZQGqNs11B4GJN87wz1yO/O0r1B90jLsS+rGStf48
        0eC29nSD3cfm+vN5ANbTwwg=
X-Google-Smtp-Source: ABdhPJzMv6w4mIspRTsFUlR/8H4yavlAOUXLNSjxxkm6CY/VHufPEdSfTLM7KkoAmOK18YX+zxCj0Q==
X-Received: by 2002:a05:6402:1388:: with SMTP id b8mr351119edv.1.1604534867143;
        Wed, 04 Nov 2020 16:07:47 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id e9sm1720071edn.30.2020.11.04.16.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 16:07:46 -0800 (PST)
Date:   Thu, 5 Nov 2020 02:07:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v2 08/19] net: phy: mscc: remove the use of
 .ack_interrupt()
Message-ID: <20201105000745.2kynhpv5x6ukjvi3@skbuf>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
 <20201101125114.1316879-9-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101125114.1316879-9-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:51:03PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> In preparation of removing the .ack_interrupt() callback, we must replace
> its occurrences (aka phy_clear_interrupt), from the 2 places where it is
> called from (phy_enable_interrupts and phy_disable_interrupts), with
> equivalent functionality.
> 
> This means that clearing interrupts now becomes something that the PHY
> driver is responsible of doing, before enabling interrupts and after
> clearing them. Make this driver follow the new contract.
> 
> Cc: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com> # VSC8514
