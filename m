Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823CA3752B3
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 12:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhEFLAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhEFLAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:00:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF270C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 03:59:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l2so5115211wrm.9
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 03:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sGBr1I+38iZ7SVnFDQNVpTYJGDmr4wfSvLU5slITSjA=;
        b=YcOxJyvtIiLWGDxusQyV7Mqmlk0DFwcmK6bn/eaRqgA0rO7IdzmFOlcOavH/SYkGaj
         nqnb7pQWPXG5UhO5Qg8THbhrZqElOnab8VVU/acYpEtb506ySsNM02Os7mZPj2ZIxLd1
         5yPfZOGq0jqBdyCR9EHZjaZ8HMm5vXzmIYtJMMnMto6+PgEmvAT1HZJci9R0AC1/gq13
         wxjkovi2ItZht+bssZjjErBf3jh5Rk/5Fx/SpN4yAMHJI0QucMvBHhZJiJstbt4b5CYC
         /mrYkmAo1Oum/XFuWDvIQUqfnzAaV7pZ4k2iSpNMOiIR9tU1Y4T5ZIJ1snacVTFpFUah
         DPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sGBr1I+38iZ7SVnFDQNVpTYJGDmr4wfSvLU5slITSjA=;
        b=GXOpV2JKtlMFYLxgaF4DAvhKEN2wmQjgi0rbbiovSMfZ6M3BKIAVAcQqPvgAmb7XJY
         BxX0XlemB08crqD+kK2VKMXYD9j49TPgEWOGRvqMBy8KkjH9d5CTjpWVdAhL5a6ag1Qn
         gPXGt6ADi+dZiYnXLd4ZKtPoDg2HRFWJiglSPfC8BOK3SIG+WZ7wNGt9TUbVLVCvHz/m
         D5isshTkrJiwLiNXAxCboJw0B5gO1LC3JDM/Hjs04bSJCxrI1XjLn4D++gOMFSx4iWGh
         wfafQFGu8VD21FPMUJWUyNJ5wPCgONg92Gyok2/8gvZGsrZNDb8ReMdgYN7VlVwr5sWv
         z46Q==
X-Gm-Message-State: AOAM533KpxTIrZlnYPss30e0n49mRTjk7WLxEIlgO+HF434+dnxnQIzY
        KLt+5qvz8OpXpsX3EWCqMGc=
X-Google-Smtp-Source: ABdhPJxMn3yxbxrqEVmXgrqTUt4R+jIFafwwkx1wFeuVe7bF2Nj152JSiIo1mXv2gHFLJacAAjrsiQ==
X-Received: by 2002:a05:6000:1051:: with SMTP id c17mr4259342wrx.43.1620298786654;
        Thu, 06 May 2021 03:59:46 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id z6sm2875732wmf.9.2021.05.06.03.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 03:59:46 -0700 (PDT)
Date:   Thu, 6 May 2021 13:59:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 0/9] net: bridge: Forward offloading
Message-ID: <20210506105944.tclatsr4jgdk6qw2@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <YI6+JXDG/4K30G5L@shredder>
 <87bl9snocq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bl9snocq.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 11:44:21AM +0200, Tobias Waldekranz wrote:
> > Do you expect this optimization to only work when physical netdevs are
> > enslaved to the bridge? What about LAG/VLANs?
> 
> LAGs should definitely work once the .ndo_dfwd_{add,del}_station helpers
> are in place.
> 
> Stacked VLANs could also be made to work. But they may require some
> extra work.
> 
> In v1, the bridge will always send offloaded frames with the VLAN
> information intact, even if the port is configured to egress the VID
> untagged. This is needed so that the driver can determine the correct
> VID to use in cases where multiple VIDs are set to egress untagged.
> 
> If any kind of VID translation takes place I think things get very
> sticky. Then again, that is maybe not all that defined without this
> change applied either?
> 
> What is the typical use-case for using an "external" stacked VLAN device
> over configuring the VLAN inside the bridge?

I think it will be very sticky to support forwarding offload for this
setup anyway:

            br0
swp0.100  swp0.101   swp1.100

Need to understand what the use case is. The correct behavior IMO is for
the physical switch port to remain standalone and for the bridge to know
that the bridge port (swp0.100) is not offloaded.
FWIW I had an attempt to handle situations like this here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-17-olteanv@gmail.com/

I will let Tobias finish with his forwarding offload patch set before
rebasing and resending mine, his work looks a lot better at this point.
