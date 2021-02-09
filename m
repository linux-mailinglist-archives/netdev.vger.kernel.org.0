Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918BB3154E6
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhBIRVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbhBIRVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:21:07 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D3BC061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 09:20:27 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so32898837ejf.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 09:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iNVIpUUGzPSMmzM1YgoDxgr7l8s2IfWS0TNnBIAZ8vU=;
        b=AmpsmpT8zIv5qC8kaerel8XYMPVzMwcAVCTLH3YB/Ho+Oj/MPWYcXPUs1x2ygNinjF
         DOiZoavoHlL5SkBcQ72wRkUgdBnyWD2xJHTUu/GvyIcDWc+CxPaUs2j8gQWtOGgvIMop
         KFe5bZZIUF44PZBMV3AY8VT2BVmtj3a0bejVAXOpZILgAUMilTEY1g3zXQBmrAxKcecS
         YBgeDm9QlGvNxxfm5SNjJt4L8pYyuws0SdZspXq7eaon9QF8TLs1TmKvLdpg6urGX6Ps
         oPVRVK4GHJEMF6jIb13qcc4R0c45tEwCKTVOd13j5p+b69l7XP+h9vdJj4WwoERZ/gl1
         KNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iNVIpUUGzPSMmzM1YgoDxgr7l8s2IfWS0TNnBIAZ8vU=;
        b=seGq/iz0dSUnEHVTLwvOg2+is8PiHQ+5VJ2fYz/GXcZPwYKPRXp0xYLOMcw38Z655e
         aUAoj6WDOxJUKkoQFiO/LmYS2yR1CKEt3l2V7KW/iIFBkLGEImmzFyqzAetMyiR68KyG
         dyeknBl2WQfGr/t2aVvW2rO3PtGyIRxPwoMh8Gq3b1e6QjyIrqK/36RSobJgAS95EIKZ
         Ms0PUsQcBkJ+arJzuHmPZ2BqJNOvo1vvRf69M0DexWsYMdr+7tySqfS4xchUzjTaAani
         MIV3fxE8UYVHErdoXQ7zhfndYO7KqriK2Qh4NRNPHvcwooQ1Mja+pbLGEs9GC9mUOMMh
         UyWw==
X-Gm-Message-State: AOAM532A1hK/GbVzcjoS4ma0AHbdZEWFDiegNhi28j1fgXHArzFLj9+c
        gypZ4QGl1rH9xUzMECGo5Mg=
X-Google-Smtp-Source: ABdhPJwWeAmzi6lpJSELm+yfVLyhsD6CmHwa58vjmgOQxks26cNpQ8wGWO36grY0j3tUDrPWNfGZLg==
X-Received: by 2002:a17:906:a153:: with SMTP id bu19mr24004710ejb.287.1612891226096;
        Tue, 09 Feb 2021 09:20:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d3sm4282230edk.82.2021.02.09.09.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 09:20:25 -0800 (PST)
Date:   Tue, 9 Feb 2021 19:20:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
Message-ID: <20210209172024.qlpomxk6siiz5tbr@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-4-george.mccollister@gmail.com>
 <20210206232931.pbdvtx3gyluw2s4u@skbuf>
 <CAFSKS=MbXJ5VOL1aPWsNyxZfhOUh9XJ7taGMrNnNv5F2OQPJzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=MbXJ5VOL1aPWsNyxZfhOUh9XJ7taGMrNnNv5F2OQPJzA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 11:21:26AM -0600, George McCollister wrote:
> > If you return zero, the software fallback is never going to kick in.
>
> For join and leave? How is this not a problem for the bridge and lag
> functions? They work the same way don't they? I figured it would be
> safe to follow what they were doing.

I didn't say that the bridge and LAG offloading logic does the right
thing, but it is on its way there...

Those "XXX not offloaded" messages were tested with cases where the
.port_lag_join callback _is_ present, but fails (due to things like
incompatible xmit hashing policy). They were not tested with the case
where the driver does not implement .port_lag_join at all.

Doesn't mean you shouldn't do the right thing. I'll send some patches
soon, hopefully, fixing that for LAG and the bridge, you can concentrate
on HSR. For the non-offload scenario where the port is basically
standalone, we also need to disable the other bridge functions such as
address learning, otherwise it won't work properly, and that's where
I've been focusing my attention lately. You can't offload the bridge in
software, or a LAG, if you have address learning enabled. For HSR it's
even more interesting, you need to have address learning disabled even
when you offload the DANH/DANP.
