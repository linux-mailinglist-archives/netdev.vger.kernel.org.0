Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94D326A77
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBZXna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBZXn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 18:43:27 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9D9C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:42:47 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d2so12920091edq.10
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1vWINDWPay32nYPWg5pHsXNrFpCx7ncvtZuKrSFgly0=;
        b=N3zpAJ/jGqLarRnQHc340/T+0SsVQe4oJTkFwPi737/TiEbyOY06airDtgBKGjcl+k
         c1psu9q5/vghnCH8cSJ9ANku6S/FEqqsmfjklPPDMREDIOLMTy4/mOJSWrUZou/sxwLD
         C/L35vK+NwNJzEoakqtk2kE6Kv/fMW98lXsBoga4eIRUiGWucOXHAxx4nTzWsRMf4Y17
         IRuII8atfR5FSIuVxzp2MRv2zwkW7wqxjOIqRjXsLHhOiSBJ5zAEqP9j4O9qyZFrdXRv
         UCP8xWxLbtNAdPbk703+t33m/9xPU0xTZHXEoYH44/HeOqq4GGhMnXfiIki6LKJZod+Y
         J3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1vWINDWPay32nYPWg5pHsXNrFpCx7ncvtZuKrSFgly0=;
        b=fMDsytEBF3i3Lpn/y6ZMJ3DMVOroT4ytj+w77PRNy+8HQh4u2gXp4G27uE7sr53O38
         iWG3BKKkitFYlNWHUSa0p7T0Zn1yfgsMSOtkztH772v1+SrfMtZM4B+td3tgnxpSHvYe
         y6eJL0GPMXKpJi9gtsuJyLsy+CfTZvgZC5b51/Dka4qYCMsA2owM4oo4UGJv2ThI7867
         AidCT9c54RrzdfneWlC81ekEVZcceMqcS8iSqlP1Y9+kuM8gxpM33n7gsFPHHHUVl9Fb
         Fa5sbx+oWZ54q2G9otqJAIV/ukjhn52SGlMSDtCiozI5U7uym4HPHYTUrTsYtmKNdHiO
         64cQ==
X-Gm-Message-State: AOAM532hfNydu9tIfeIFNjLcdr1vW5TqtzQxIqTZmVgWZyAqU+k4PdJr
        XTaJ4nOhoY1CjIrEtqpsdydJoOanXq4=
X-Google-Smtp-Source: ABdhPJyyuJMuhr32b31kNSis1QZMWaTGwSp6EB6DqNu8XuN2wO2ZCGHKOWegpyoWAETgnXMJz8H6ww==
X-Received: by 2002:aa7:d588:: with SMTP id r8mr5966049edq.88.1614382966131;
        Fri, 26 Feb 2021 15:42:46 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id 35sm6918194edp.85.2021.02.26.15.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 15:42:45 -0800 (PST)
Date:   Sat, 27 Feb 2021 01:42:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210226234244.w7xw7qnpo3skdseb@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 03:28:36PM -0800, Jakub Kicinski wrote:
> I don't understand what you're fixing tho.
>
> Are we trying to establish vlan-filter-on as the expected behavior?

What I'm fixing is unexpected behavior, according to the applicable
standards I could find. If I don't mark this change as a bug fix but as
a simple patch, somebody could claim it's a regression, since promiscuity
used to be enough to see packets with unknown VLANs, and now it no
longer is...
