Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811352F7DE9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbhAOOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOOPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:15:38 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08051C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:14:58 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id by1so7104024ejc.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lNMmmGZdpWY55LA4ObSgydOG+bkt1BzJhqPC6gWIisI=;
        b=UCL+inKreJ1SmCnsosIENnrpS6T4BTrqHoD8NKvIov/JBhy7ChA0z0nDulEShpV4D6
         X4WSynLdRXPQfno4XZsc3o4eOcRUxc1RmrV1tkLvyCCG4scwQRWhETi0h+h9GtJ+YK53
         pmDftG8rNwFwEITQNf/FP2gTaPvSL0ln3wMyMOKQ4unUvhz3Hax/DQEWl9+QK/ate+lM
         d+ysWm4PafpXoMvAhGIvQ7s7mCo//AHyuOJwemhXXjQKK+VmREv7dFlZv0KVs4i11eof
         Ha+wJsVIFfqzvJYPyzvARrNdgpOAmOpYmw3fqUxu87KmYfvHz2W9Ea0kUicexQdXXEbd
         CHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lNMmmGZdpWY55LA4ObSgydOG+bkt1BzJhqPC6gWIisI=;
        b=D8MFzay+l44pwdhLYl/cbtlk7jCFq80bqmKf0zO0KukJYdpABFdZsvmQAe+nlslPwg
         Tjrywx7TfJlvuWk5TLaFyUz/1oikvyTRHvlRreJ6l9xwzgzOXeL515yAgWudk/fMdgoV
         8USmc+v1tEbaJrOBc71w1kc6L/3/hOlTps0VfBIIITeDkU1J+4EOPiQMtMYnLEDpTlPc
         Utz22n1KgxFNpnbQw7gn/07nZmlZagL1BDMooFWSuzKDgM+whqJ0YQjOYw992wid2xJG
         OdQgGnoZ8bW/pBagNj7HtNu+UXTeU/RA/Wig1LquCNgvF9mU+M7JIiIUPUtO5PTK7BnD
         o2Jw==
X-Gm-Message-State: AOAM531+WZDD5GEArOfr50F9d5AYlhz9eBm8uurQp0vZN6kDYBs7XNAU
        10npJfurIw+1t2EvJ7gzk9Y=
X-Google-Smtp-Source: ABdhPJyGQInK2bna1+h4vgZSYEGybCIUr9Wkd4KkncfgwF+K5yhcLx7cbupZg2Y+em2FkitP+0209A==
X-Received: by 2002:a17:907:da9:: with SMTP id go41mr142288ejc.326.1610720096634;
        Fri, 15 Jan 2021 06:14:56 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bm12sm3586027ejb.117.2021.01.15.06.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:14:55 -0800 (PST)
Date:   Fri, 15 Jan 2021 16:14:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: mv88e6xxx: Only allow LAG
 offload on supported hardware
Message-ID: <20210115141454.m6lsjovgja6tpj4o@skbuf>
References: <20210115125259.22542-1-tobias@waldekranz.com>
 <20210115125259.22542-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115125259.22542-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 01:52:59PM +0100, Tobias Waldekranz wrote:
> There are chips that do have Global 2 registers, and therefore trunk
> mapping/mask tables are not available. Refuse the offload as early as
> possible on those devices.
> 
> Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
