Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BB3416614
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbhIWTqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242796AbhIWTqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:46:24 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B37C061574;
        Thu, 23 Sep 2021 12:44:52 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id eg28so27266845edb.1;
        Thu, 23 Sep 2021 12:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=USB+c9NQPlFOCzOlELYb3av2B5sqofQxC78jD/L/Faw=;
        b=Ivaw8/yqDkDtpnoa7KVXQ6wxjxdqq44QfO1qZ78DTS4rrjKcWcUFsPBm+ofL7L7x6R
         2IACsu+wVJpiBby+hhKqcpWZLnWHlKEvodtRGQDwLTKo/+iTUpRyV4orTrIkN+h1qs2x
         XUFHBmZvvYaLJUBBrNmrvpYHkQyUXQGvotwbfkSaL5r4SlgvnJbdPsJQEaDS3bwp4s5q
         Z5hH+MZLx37l8cSs84HcbrBmhLPCPTxtFYukZpARcdxF3OeiqN7xVc3IwN52TsdwDd5D
         1OOAqogeF0kZdBMcUcCFFAsC3sNLEFDQk9Po65bBJvriI7kqVh2dbE8SSZDliJeAGV4X
         tdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=USB+c9NQPlFOCzOlELYb3av2B5sqofQxC78jD/L/Faw=;
        b=0aWe1kamQ1hIKWsd80gtCEsvOacMbj12KIzwWzKGIqVKNZDSMPz3yPSlKE9oyxb4Jm
         ORvgII5ULJzXH9B7arHTm7LqEv3drXIKtm2pOzAMgrZzORlGmh/1njYVpxd/hhFLu3Xb
         3q1JlMMzyvXHjRt4bHE09qFqYYHsAK52iz52jdCVd1vE/hNBD8V5NGHVR7KQg6NLPycs
         jf64gaoDb6vI7pUucpx/0dEdBlWHyq7CDIntc6zGnJ/Axy3yvQg053TKX6SuCwCz6WHK
         h74bj+4NFfMbFcs6GYmSQAUEelzAvJjmUgq1mvf73u1y0jHzkgSyukKqzAl4SfJP2VNR
         I2Vg==
X-Gm-Message-State: AOAM533zoBC2X6llCS+z8ecwMZVocozN04fNHpYSiBZ01sriHR1hrFXy
        jpcgFz7oB0lIrCEPrXduqwI=
X-Google-Smtp-Source: ABdhPJx47JRxPImn3bCOzzIp9JgZuhIzAfodEXn1mXk91Uklp1+eljNjL+So5E5m3okurvJieN/S6g==
X-Received: by 2002:a50:cfc3:: with SMTP id i3mr656314edk.36.1632426290611;
        Thu, 23 Sep 2021 12:44:50 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id b38sm4101128edf.46.2021.09.23.12.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 12:44:50 -0700 (PDT)
Date:   Thu, 23 Sep 2021 22:44:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] fw_devlink bug fixes
Message-ID: <20210923194448.tnzkdvigknjrgoqn@skbuf>
References: <20210915170940.617415-1-saravanak@google.com>
 <YUy5nDMeWMg0sfGI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUy5nDMeWMg0sfGI@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 07:30:04PM +0200, Greg Kroah-Hartman wrote:
> It fixes the real problem where drivers were making the wrong assumption
> that if they registered a device, it would be instantly bound to a
> driver.  Drivers that did this were getting lucky, as this was never a
> guarantee of the driver core (think about if you enabled async
> probing, and the mess with the bus specific locks that should be
> preventing much of this)

Since commit d173a137c5bd ("driver-core: enable drivers to opt-out of
async probe") it is possible to opt out of async probing, and PHY
drivers do opt out of it, at the time of writing.
