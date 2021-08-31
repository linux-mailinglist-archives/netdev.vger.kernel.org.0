Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAE43FCFDC
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhHaXTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbhHaXTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:19:03 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F56C061575;
        Tue, 31 Aug 2021 16:18:07 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id j14-20020a1c230e000000b002e748b9a48bso2734280wmj.0;
        Tue, 31 Aug 2021 16:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W4R9JjXGDyrJfGo/ByCDrrIJv5IMDVnwTuXafEDr9Ko=;
        b=SOOaVDeOR5wjqreW4h406PHEmTGalXuNvkeIiaYObi2U4tg7BGvw2oPNVKdYl4d/j+
         sy+2yOIgUzZ3N5CUPPXAzzcoRsKTdodbfWblsbOjo/A7Qu2VhOkKqJsAFWKuP1S+tJCD
         vkIzJH4hsdI5GQq7ncpuC8BXJqLjQLXX4ZF59dgMvQVxYdOry65BcZSnwDkgtuK0m5sL
         rw8eq3rDY7WSLLKloP2WmCums+UsbtNaee++pUXiw5T4zYRHSIR8i1BakUGzx7hFO64Y
         k9oyX32symf4KYWg7HgqE2xMZp2qKCJPoPq05btyf1zZQ1TrbsuqRDhHkhZCapsn3o8q
         62fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W4R9JjXGDyrJfGo/ByCDrrIJv5IMDVnwTuXafEDr9Ko=;
        b=X+lkn/8XQRmxYX+UDlfni6UBjy/ayop9WcGMww7DMZ3ZE386VP18W0NytxwBh7Kg+B
         Uy3vbaveM8K6gd7HgSez2pNrjhxvXMaSYYgBRO/88K98yiafTfQ/bt+K9b41Zrl791Ac
         fkSSuFj3k/mYu5034+CVQ81p6T5qC5syezwfwlhHDbfowAT+u1e1ZRljOdYbiq4PrNuq
         l9gxb0zcB1LAImcUlfD6Y2YgBZs2sumhAxphvV1aVa4tX9APvjZXNdm6U41G8/1l1+HA
         zWA3z8YEgrWCFMSFf7/rMHeRuRyOARrEYP6a3OBaq+/LC64Q1oGXqSp7KSL1YPU78xgN
         FD0A==
X-Gm-Message-State: AOAM532pOYXE2RZrHy7kmCIemfs3MqkRI+BU5qnr9W9PJFLtwxqKNf/L
        nmx1RtjHTaX7XVhFKtsmnpQ=
X-Google-Smtp-Source: ABdhPJwPxg6EW0RO5NmHnoz2p+ROHyG50SHMEDfJ9iJYyKemxkIGvMJlpLvdsAPxw5tbboUdwGN0tw==
X-Received: by 2002:a1c:9a91:: with SMTP id c139mr6651808wme.106.1630451886214;
        Tue, 31 Aug 2021 16:18:06 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id t7sm21524913wrq.90.2021.08.31.16.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:18:05 -0700 (PDT)
Date:   Wed, 1 Sep 2021 02:18:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <20210831231804.zozyenear45ljemd@skbuf>
References: <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YS608fdIhH4+qJsn@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> Rev B is interesting because switch0 and switch1 got genphy, while
> switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> interrupt properties, so don't loop back to their parent device.

This is interesting and not what I really expected to happen. It goes to
show that we really need more time to understand all the subtleties of
device dependencies before jumping on patching stuff.

In case the DSA tree contains more than one switch, different things
will happen in dsa_register_switch().
The tree itself is only initialized when the last switch calls
dsa_register_switch(). All the other switches just mark themselves as
present and exit probing early. See this piece of code in dsa_tree_setup:

	complete = dsa_tree_setup_routing_table(dst);
	if (!complete)
		return 0;

So it should be a general property of cross-chip DSA trees that all
switches except the last one will have the specific PHY driver probed
properly, and not the genphy.

Because all (N - 1) switches of a tree exit early in dsa_register_switch,
they have successfully probed by the time the last switch brings up the
tree, and brings up the PHYs on behalf of every other switch.

The last switch can connect to the PHY on behalf of the other switches
past their probe ending, and those PHYs should not defer probing because
their supplier is now probed. It is only that the last switch cannot
connect to the PHYs of its own ports.

So if this does not work (you say that there are 2 switches that use
genphy) I suspect there are also other bugs involved.
