Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26923E3CC6
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 22:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhHHUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhHHUql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 16:46:41 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BDDC061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 13:46:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so10087052wmg.4
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 13:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9CdZKrx+LTQpeC6eiy1wJkwH0dARPvsS3wJE4pHGe1w=;
        b=HmeDQge15yRkrqxAo89wwaNSJyuU2o2dInm57V3h012ReXhRHrH2dudbH/W8VQPO4Y
         FK+ri6odCbHcPSJZ55x0wueg0F5oAe1bxeWFuhJBEGgIcMYN5IMrgmlIe8nGxUOWF50a
         sP8GJBlZIpDiNqZkgzJPNunRi/6aBAZ603AE3rAWBCCkEXbx9ZxhDhNBfwB0yeJ/ohId
         fsTFYN/jRd8rwVTR5F+JQGOpQse6uGrbjbmPmQglsnxfLOEUOC4LEfsLTEo4RTeXC7oV
         HtW96bMbnxhufad8vmY34d8KLk/CvUh0oCJNMVQ03hdfVWGTuFJKtERB0LwPfMWH9GLZ
         Se/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9CdZKrx+LTQpeC6eiy1wJkwH0dARPvsS3wJE4pHGe1w=;
        b=OTOwWtOsDODQecIykwvY3XO+qrzY/PKbg7c6SJqY+904BvopFWcV95PLxxwa/kOw54
         tWkEUOUhCWtlJxpFiBFa1JQgieDxWtPAg7X8XZuNacS6gLc4JZi2wCdSBe5OiXR3SEx7
         yzYdcoAmbUlLmIfNnMMyOLKjMnOIJJU5KNOwmxyPz2Y9AT5OwFmFge38MewI5g1ap7fX
         BdR0JE/IdL/W3yIhcw/6KU5lKiwuEppZoBLQqiAICPJAnWpvyhsTT1+4blU/GSwgGfK1
         X0HyLPs5mPxjA51hHRwnVKffmhTvw892SALM0H3maeInREXI/KITu4MbSCXQ8THb7y8r
         corw==
X-Gm-Message-State: AOAM532d9m1viKMfiazMuHXXjJPD1AZXM6L9oh5DbDLnLAWD3/dOMdV9
        Q/RL/IvfMyMk98dEjkVXQXtzqHXxvjY=
X-Google-Smtp-Source: ABdhPJx5D5bYTcb4KuOj8WE037U9qQi49e+k+48ln079THn7jOjuIF/bK/P0aGVIHJ84xujHstSfJA==
X-Received: by 2002:a05:600c:5108:: with SMTP id o8mr13338749wms.97.1628455579646;
        Sun, 08 Aug 2021 13:46:19 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s14sm2316406wru.9.2021.08.08.13.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 13:46:19 -0700 (PDT)
Date:   Sun, 8 Aug 2021 23:46:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: don't fast age standalone ports
Message-ID: <20210808204618.hasisjhlkcl2ah4a@skbuf>
References: <20210808111637.3819465-1-vladimir.oltean@nxp.com>
 <YQ/6IEA2F4BAuZOG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQ/6IEA2F4BAuZOG@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Aug 08, 2021 at 05:37:04PM +0200, Andrew Lunn wrote:
> Hi Vladimir
> 
> Do all DSA drivers actually support disabling learning on a port?  If
> there are any which cannot disable learning, we still need the flush
> somehow.

Indeed, I will send a patch to restore the behavior for drivers that
cannot toggle address learning.
