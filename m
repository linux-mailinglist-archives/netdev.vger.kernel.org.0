Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF034309F18
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 22:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhAaV3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 16:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhAaV3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 16:29:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D669C06174A
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 13:28:30 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s3so2940467edi.7
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 13:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=96FfUmiEdQ830favyJ2Hi+OB8/gzq/13tz4LJOBuXQ0=;
        b=abCEusqxQ7GMOXfhfXX6eJnJIodKmRXxEN5EkvXZtSY3arDMX948M0pSvh4pPdXqle
         4XKZ4I+l28v5U4VmY6+bIDF7xU9A/Bjaavg4zLqL0Wd4zvJdOI/YjH4BU9VtbcM7uPsl
         JXPu53xdwuLel44d6iCjwshtMVEJcIv6z7KGRlYeTZiXkDQcZpQZqdq0nNLSyTHOflN3
         01JTSzCx3RSrVEoaEORjFiGCZjNuIS/EMGOclY2mA1EdMGf9EiBnLlgV9EmAFA2fswFU
         jZMdP0N0ixlCJwAOyBbzKLQWCTKZ2y6EMnAUw44YQw11S6ADgRfcQdSM47jlycY6il9A
         ESwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=96FfUmiEdQ830favyJ2Hi+OB8/gzq/13tz4LJOBuXQ0=;
        b=WoefbKCxWPjxi9Zaeh2xqzFLAYCl72vSiRfntgRBF12MvLsKtjo+M7Mi6mJiQzFsep
         69vqiH8IFxWuLfsR0EyvHqXF955HNCA4UHTyVWJNsOgGpsaSUcBZ37HQixwPjiq69T5H
         iRbilUF+rKW+xB1fCaAxOD63roK7ROeOhF3R9fIKWpw3NPeLogMeIIibZuUFJthUl977
         Ohyba2SUQTCj2H3810+YZdyuaRb5mW4gbjUP7epE47zhBLwD8CJPp5qCLb1sd9Rf0i1C
         Chsge8pgYxcsH1w3FI6jDGqtqR4zdvK+He5BuJirVFfQGi7WqCocrXd4CJ9flResQTrw
         D1ow==
X-Gm-Message-State: AOAM5333apxwuBmsQ4nMRgacHAUcyXG85OHO3AtlLAqqkN1SvLfeRbkh
        5cTyfTPHYkNR1PEfsAAJl10=
X-Google-Smtp-Source: ABdhPJza/9TjQAXTIfaolKti+we6ADwrnUzOggNhG7KIoj7ztMMbuuSjlQxCpIb6aIJwBujgJryAnQ==
X-Received: by 2002:aa7:c991:: with SMTP id c17mr7632399edt.289.1612128508745;
        Sun, 31 Jan 2021 13:28:28 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f20sm7756294edd.47.2021.01.31.13.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 13:28:27 -0800 (PST)
Date:   Sun, 31 Jan 2021 23:28:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: dsa: hellcreek: Report tables sizes
Message-ID: <20210131212826.dcr2cur4cf2xlhje@skbuf>
References: <20210130135934.22870-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210130135934.22870-1-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 02:59:32PM +0100, Kurt Kanzenbach wrote:
> Florian, Andrew and Vladimir suggested at some point to use devlink for
> reporting tables, features and debugging counters instead of using debugfs and
> printk.
> 
> So, start by reporting the VLAN and FDB table sizes.

I don't remember having suggested that, but nonetheless it doesn't seem
like a bad idea.

By the way, your email landed in my spam folder, I just noticed the
patches by accident on patchwork.

Sorry, I am not competent enough in email headers to tell you the reason
why gmail flagged you.

	Why is this message in spam?
	It is in violation of Google's recommended email sender guidelines.
