Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BDE3055EB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316936AbhAZXM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbhAZVWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:22:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92348C0613ED;
        Tue, 26 Jan 2021 13:21:26 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j13so21525597edp.2;
        Tue, 26 Jan 2021 13:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ST72NpNiWqGqAmDnIglIq4qqpfbif3rOOqv4QJndT00=;
        b=NTPgBLCt4jWVNE1sRWCNVWYSgz2jvQLBM8uYJUGhriCmGP0rwCgLI0Q/DNOIj86d5m
         ytOoR7EZOJMjFzoxDhZ8IC5YK9XuAKDoDSagSSY/0LdeeOWM8T1QKN5iNrgbsRXgPldC
         355X1RERr8XUckOqFe7JDIwDRJlBT6pu1jQhOIcIK/lWJSNb46A7CB7Ez4yPkepWeDA7
         xXVwQmtmHshvyQv1g0qjxnpKD9nrRs4q6hut8y0Db6BbrynDqP/oOWVCU13yIs9M0yzz
         RH4lvorabwFZSqptaDocjqqJgOUHtn8lTXPIs47VZnDZ/SDcvWKUPGNPkD7jIpZQgThL
         /YCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ST72NpNiWqGqAmDnIglIq4qqpfbif3rOOqv4QJndT00=;
        b=mIGP3DnO8HfBYRXlp6Hyex10suB1WfciL5Cfz+V/iB3NV3tAnoq4PnVC6emariHsP2
         1IIiSx4r3SRwa/bvq+G7+FRKW3YxBtehQgX9ToWtN9nXt9rJJtMYPjNuF5UyGHNBlTak
         eKPDw9bZx4ExC0TX+pSgf2xdi7KTYxo+gjFYCX1Hz36gCqXgb+0j9qmqMxiedY8jV0C+
         XwDVHVP1fnfs2A/7FMZCDQezngxlaV4UNGn88a5rorZo/XgI7OtB8G0OUeyV1i5ieuFJ
         3dRJ3SDLuRUDDqyO5b81Soj6QQxMF0x8E9kyPe/kOCMP7jGtxTUedZHZsNS4EFNmfAxW
         Nkww==
X-Gm-Message-State: AOAM532yL2Q2I/3cvaraFvKMZso0TEy9Laa89SD98OrLCG95pnPpJI7C
        uQHrjlPyaoKApJcH6Zj+qpA=
X-Google-Smtp-Source: ABdhPJyDuh27x8pJ4ko7OieJdPGlYmb/9HJWMdPtpmfHDigB8FhJlZqwxzHVUqCjwFXRSlEiz/zGAw==
X-Received: by 2002:aa7:c485:: with SMTP id m5mr5964424edq.320.1611696084707;
        Tue, 26 Jan 2021 13:21:24 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f13sm10295956ejf.42.2021.01.26.13.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:21:23 -0800 (PST)
Date:   Tue, 26 Jan 2021 23:21:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210126212122.vthdb46vx2avx2ap@skbuf>
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
 <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
 <20210126210837.7mfzkjqsc3aui3fn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126210837.7mfzkjqsc3aui3fn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:08:37PM +0200, Vladimir Oltean wrote:
> On another note, the patch doesn't apply cleanly to net-next/master.

Sorry, it does, I should learn how to apply a patch some day.
