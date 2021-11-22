Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964E14587C1
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhKVBcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhKVBcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:32:18 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C25AC061574;
        Sun, 21 Nov 2021 17:29:12 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r25so32720865edq.7;
        Sun, 21 Nov 2021 17:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=asGCbWxr5zps7PC2en/ApjsCXF7zNreTSXNeUso+FNs=;
        b=iR3vP+wdATxRmpi5k9WbOiJn/YT1KuWQzgds8vW4Dc1nX8nO7M9qzy18A9vzf+0cUt
         r1BzfWL0wXglAMrXluFxPVkSwFZzPFUyd3zbaWsMCle3wJPZbtMBYUXRxJ1AGQrKW4ds
         h8pDfxH7f7RgNMCNnJMt2CQjrLbE6v0wWG/FPOYM29ZJtIdfJcFOHxaOKuuv01Srojdu
         Cp//AAWb1a+yCynyk9RICbTYzfWeGNrG6j/oxTobyQDk8vJ6YO2q0dhH6flgornML4IH
         WGBAiz3OyCvogpnFFjHUWwHwUFd2r9ecJMtWQtcvVc21uVYeH53QDfalkdsya4y8USgH
         Y5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=asGCbWxr5zps7PC2en/ApjsCXF7zNreTSXNeUso+FNs=;
        b=rl7qV5HHHPUBIOpuGwOmP0Uz4i/67yDn9waOJFGnAy6a52a2sGW7kTlpW426IGpz6g
         wG1F5lJQDjI7Ab3/gp8n9Xe8xuzQzPyUmYi1hO1yE1kvqzQYhZQAgH+nX2uVTF0e6Gcu
         28k83wizsvO1wt/sNfvABh9m85Cgdk4IjbVt1YeYSib0ro61q8gbYA7brxwCbjuKfgDP
         YQMnJcS2E2JZCmlWS+n3jSfJovrTM90QHLmrKTAsKYNTstK5Ur0fORhQ5iD5q2oe7lHx
         A5txXSVHcF3IbK9i2Onjevx2BsLnPOKzxEgGqnnh0yvAXry3jn9Cr+9+zRuxW7+2nO2X
         iFyQ==
X-Gm-Message-State: AOAM531ImPdg/oJRsoS2+vqm9d3D5RpvLpw7l6hz57WPlzpGheEg31E2
        3zIPDWxXFw/AOTuHW49okpQ=
X-Google-Smtp-Source: ABdhPJzINzBtdMTHieXbozzGg3w411GdiqzDeU3gkcsPsXRZHGvsI0h+UIPmsR9GprhMVeldA6vaQQ==
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr35794124ejz.499.1637544551474;
        Sun, 21 Nov 2021 17:29:11 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id mc3sm2994915ejb.24.2021.11.21.17.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:29:11 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:29:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 0/9] Multiple cleanup and feature for qca8k
Message-ID: <20211122012910.bd33slbrfk4h6xbw@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:04AM +0100, Ansuel Smith wrote:
> This is a reduced version of the old massive series.
> Refer to the changelog to know what is removed from this.
> 
> THIS IS BASED ON net-next WITH THE 2 FIXES FROM net ALREADY REVIEWED
> net: dsa: qca8k: fix MTU calculation
> net: dsa: qca8k: fix internal delay applied to the wrong PAD config

Since patchwork has auto build hooks now, it doesn't detect dependencies
to other trees like "net" in this case, and your patches will fail to
apply without the other ones you've mentioned, which in turn will make
the builds fail. Patches without clean build reports aren't accepted, so
you'll have to resend either way. Your options are:
(a) wait until the bugfix patches get applied to "net", and Jakub and/or
    David send the networking pull request for v5.16-rc3 to Linus, then
    they'll merge the "net" tree into "net-next" quickly afterwards and
    your patches apply cleanly. Last two "net" pull requests were
    submitted on Nov 18th and 12th, if that is any indication as to when
    the next one is going to be.
(b) base your patches on "net-next" without the bug fixes, and let
    Jakub/David handle the merge conflict when the'll merge "net" into
    "net-next" next time. Please note that if you do this, there is a
    small chance that mistakes can be made, and you can't easily
    backport patches to a stable tree such as OpenWRT if that's what
    you're into, since part of the delta will be in a merge commit, and
    there isn't any simple way in which you can linearize that during
    cherry-pick time, if you're picking from divergent branches.
