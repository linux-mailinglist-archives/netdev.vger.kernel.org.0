Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9844D316285
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBJJkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhBJJiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:38:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD521C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:37:42 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id t5so2072445eds.12
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FZCgpqKnnKfLF/fMbcUSmlq4NgZCgXwFXRK7pAt5wMg=;
        b=ISSNe0jxf/PdZ3R3Pjzkz15ObqOLA8BlhNn0NXRNKoNHKLHJsQd1bnxA0a9ez3JsNA
         PkSOS8hR7c7jYoW1bL5hO/XQcNzU54XHU9c+9+7Zkv56mOdr1g9n9fwwY4XA7kOoZkTZ
         tvAD2yuKUXaOVze3vZ2OKLatPJeBvtjj5+DJzpyL6pW2auUctmWucakqBoMYHpHbA0Ol
         9rfLhVbtPJZvmibBNiJqz1vi1Z0VV9FlYZvIzXR3jpQh3UI8kUZW9khnJKta0Kw3eRIf
         PKhmSI/kPepgLuL22AaQtA5QlZmVZr4WhQJkbcjWRs4nJtDCblAQf405sVDqwwkFuMLG
         kRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FZCgpqKnnKfLF/fMbcUSmlq4NgZCgXwFXRK7pAt5wMg=;
        b=mlxJ6/3f61eT0VyZ91epz8926YFTep99q8DEvPQelSQFfAxMLr9cAoaomWe7LpdRxF
         WXU4I/XFM6d8f0TJo6ITDEkmHi3BMFsG7pzlNBdSXotoDKF5femeT3zbe4AAm/PlgHyU
         NcRe1r2eAbGn9bNY0JH9xpTJ9/0M1u+Qx9cVLM6hN6Zxo5N+bs27L67U1a4BoQHOrl9B
         GCu1EQVCDsU7E2NMC0VMsjTlk0Dx3OhmC/x8JGjR/p9ew5T5aS50lkBJhP0NWYAWkgK3
         Sfde3RuPURSS+s2cFH9TATYxY0ueIFvGiBm0KQpB1SoKSFUYFuobHn9ik+GjSEwZZ9kF
         qIbA==
X-Gm-Message-State: AOAM533w4lfn7LYPku0EfuWoXruiJ1sz3rfwaPtSfVeWL2ciHDLxzlAG
        RYssg3SOaFK5tMKfga9gdlA=
X-Google-Smtp-Source: ABdhPJy5R93VFbbFpH1dfBkomGskQEgSxyHavFtIb7z6bbtRH3lTXJ2OM6nqv+RvbuxpkHsdrq1Jyw==
X-Received: by 2002:aa7:c944:: with SMTP id h4mr2301983edt.233.1612949861514;
        Wed, 10 Feb 2021 01:37:41 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id g3sm725154ejz.91.2021.02.10.01.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:37:40 -0800 (PST)
Date:   Wed, 10 Feb 2021 11:37:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] net: hsr: add offloading support
Message-ID: <20210210093739.wrakrn7d3gngo2m7@skbuf>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
 <20210210010213.27553-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210010213.27553-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 07:02:11PM -0600, George McCollister wrote:
> Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
> tag removal, duplicate generation and forwarding.
> 
> For HSR, insertion involves the switch adding a 6 byte HSR header after
> the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.
> 
> Tag removal involves automatically stripping the HSR/PRP header/trailer
> in the switch. This is possible when the switch also performs auto
> deduplication using the HSR/PRP header/trailer (making it no longer
> required).
> 
> Forwarding involves automatically forwarding between redundant ports in
> an HSR. This is crucial because delay is accumulated as a frame passes
> through each node in the ring.
> 
> Duplication involves the switch automatically sending a single frame
> from the CPU port to both redundant ports. This is required because the
> inserted HSR/PRP header/trailer must contain the same sequence number
> on the frames sent out both redundant ports.
> 
> Export is_hsr_master so DSA can tell them apart from other devices in
> dsa_slave_changeupper.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
