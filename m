Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49CA2CE4A4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgLDA5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgLDA5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:57:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4193CC061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 16:56:56 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id qw4so6240822ejb.12
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 16:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M8rdejdL6sQpmXJbypKF099zt9YPWmaMgGDVaUV8+5U=;
        b=uMUZ+5F7EKaVxt+EaEQQLRCs3IbSck6Uxf08wmCRlKjbmrxvPFnhIs1lVo5jMHdVep
         IJh0upm1dq/OVqqji8KVVOuWUUDQTP9O5QYWmetH5I28gitU4KBz/OVdTMgAU9YtNmF7
         mcy0EM4ykbePJ2D8Il2Pu4dBZFxwElDSBP7mnfLYBiyglicoYzNt6tS38zVBXHt8FNiA
         Imwea6YTO5Y0PSwi5ZO8v70G5OWimy81hMU7Fj8Bv4iYO84sEv+LORaTrJVJ9DxFZdEQ
         xj8uQdBdyM2kXBQS1S7wORz8nUNgw1tMbMcYuDbT7smLPYdrixDvDesfrI4I297fuC9N
         8TXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M8rdejdL6sQpmXJbypKF099zt9YPWmaMgGDVaUV8+5U=;
        b=pk1+GXrWSzzEvkx2K6QcSpNNWZCJn0rrgymXGf02rh9Wmsefx8Nczym3HqW7yK9Kuf
         bxmn7ptkA/sNv5SKf2SSGf7uHvOeAKeKhcd7lqsj2dIsj4zlfHQlhrwJmO+EBsAm7+uM
         DKZVJ6GXuVTu/jBNzmQbrfiEBg+1UkCH/8bU8cA/DaQY5ZfUljs+3yXq27N9s1s+c/bX
         tlr5Gmp9C5M014FWk/lq7MNbELkspQtpS2wEzYZBRwNuBCTVm+SOs19aIN2hnI+ko+ur
         Rnx5FiE14CAYoDRCHGlOf2L+JwaFKy1Md350z9iXT5UGmOiKOxstWkMWQJBqwue6WR5w
         tYBQ==
X-Gm-Message-State: AOAM532kJFAS4pBZedYPaSWzRwdfwc391UNYy0+A0I1p2Xr61Ky4D4Ol
        m/dXzsDheXHU5hJPOye9OWs=
X-Google-Smtp-Source: ABdhPJwW2aleXQWtze78B4sxGNL/DouaT/bPjs1ORK1Pl5ILSaUK6XVGk7VZdz9hcSQYuEwszmTUlQ==
X-Received: by 2002:a17:906:60d2:: with SMTP id f18mr4739644ejk.528.1607043414981;
        Thu, 03 Dec 2020 16:56:54 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id q5sm1918934ejr.89.2020.12.03.16.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 16:56:54 -0800 (PST)
Date:   Fri, 4 Dec 2020 02:56:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201204005653.uep7nvtg4ish5xct@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201203162428.ffdj7gdyudndphmn@skbuf>
 <87a6uu7gsr.fsf@waldekranz.com>
 <20201203215725.uuptum4qhcwvhb6l@skbuf>
 <87360m7acf.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87360m7acf.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:12:32AM +0100, Tobias Waldekranz wrote:
> You make a lot of good points. I think it might be better to force the
> user to be explicit about their choice though. Imagine something like
> this:
>
> - We add NETIF_F_SWITCHDEV_OFFLOAD, which is set on switchdev ports by
>   default. This flag is only allowed to be toggled when the port has no
>   uppers - we do not want to deal with a port in a LAG in a bridge all
>   of a sudden changing mode.
>
> - If it is set, we only allow uppers/tc-rules/etc that we can
>   offload. If the user tries to configure something outside of that, we
>   can suggest disabling offloading in the error we emit.
>
> - If it is not set, we just sit back and let the kernel do its thing.
>
> This would work well both for exotic LAG modes and for advanced
> netfilter(ebtables)/tc setups I think. Example session:
>
> $ ip link add dev bond0 type bond mode balance-rr
> $ ip link set dev swp0 master bond0
> Error: swp0: balance-rr not supported when using switchdev offloading
> $ ethtool -K swp0 switchdev off
> $ ip link set dev swp0 master bond0
> $ echo $?
> 0

And you want the default to be what, on or off? I believe on?
I'd say the default should be off. The idea being that you could have
"write once, run everywhere" types of scripts. You can only get that
behavior with "off", otherwise you'd get random errors on some equipment
and it wouldn't be portable. And "ethtool -K swp0 switchdev off" is a
bit of a strange incantation to add to every script just to avoid
errors.. But if the default switchdev mode is off, then what's the
point in even having the knob, your poor Linus will still be confused
and frustrated, and it won't help him any bit if he can flip the switch
- it's too late, he already knows what the problem is by the time he
finds the switch.

> > I would even go out on a limb and say hardcode the TX_TYPE_HASH in DSA
> > for now. I would be completely surprised to see hardware that can
> > offload anything else in the near future.
>
> If you tilt your head a little, I think active backup is really just a
> trivial case of a hashed LAG wherein only a single member is ever
> active. I.e. all buckets are always allocated to one port (effectivly
> negating the hashing). The active member is controlled by software, so I
> think we should be able to support that.

Yup, my head is tilted and I see it now. If I understand this mode
(never used it), then any hardware switch that can offload bridging can
also offload the active-backup LAG.

> mv88e6xxx could also theoretically be made to support broadcast. You can
> enable any given bucket on multiple ports, but that seems silly.

Yeah, the broadcast bonding mode looks like an oddball. It sounds to me
almost like HSR/PRP/FRER but without the sequence numbering, which is a
surefire way to make a mess out of everything. I have no idea how it is
used (how duplicate elimination is achieved).
