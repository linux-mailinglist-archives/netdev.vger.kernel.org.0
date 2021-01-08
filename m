Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1EF2EF666
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbhAHRXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbhAHRXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:23:14 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9579C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:22:33 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h16so11929481edt.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4M2IJKB1sqsuwfqhG1D6BK3FBvalSW700ezXUI9Ah1o=;
        b=Sdr3LwBmJ3gTurx0lCWf2QlLM0bHb8zWF+bgz8HUGxto13dVcvLZYbEHbqNQlSf2bk
         OCjRJlotVZRrHKkZ/a1m/rlp6e73aDBcYvSFEEDm+39m0L2PBvhxgvXMIv2mPRfnPSkG
         Rk2gtyVvTQZnr165C8RMKYxBjSpWL6yN0lY497QeiyybSZz1R/Gj55CzGyI4mTYFi+Sc
         YjMIWXb9BMbNxKDkPPGvVw2wVqAp9drCuRANYvrO5/PwpZg5s9oVU3KQVUb3Ly7qDgXC
         8O17sZD5SRTNA7ZHWggf7ousL0NA/cKw3+8PsaNFjMVP8Xg2ZQsDOOW12xBG+qAgkH1I
         0xrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4M2IJKB1sqsuwfqhG1D6BK3FBvalSW700ezXUI9Ah1o=;
        b=HRAWhx3EfmxASZGWRXTv5ybtnZ0AU21hYgVsq9Rmub0ZByjh0XEwXxu5EUl2pYA7Ig
         JBlK7lkUbrc3C4iI4A/SlZetjHaqY1kzW7IFwx+NZN9LlT2PyAe36NaUdMfUScRxAWUN
         srzbLvYFQchNwusTS6cZUt7wo+9ha9+k8yhYPuS/cV3B2gcifGs2ZctqCwDzyePJuIvH
         tyzDYouKIqbPDwYfPrgS7Bk6PwKmClVyquPUG/sulariWn7gpW+bE+IBjfduseVfRcmo
         nvTUTacAmCftJ0z/qzRVLxe3BanmhvbFZd1HqmvtlWQOeECly7DfGKGCvH/awVYn/4hf
         HeYA==
X-Gm-Message-State: AOAM533ajFcTy8veXV+rhpXrEOZDXcEp1ceW5iRDEsz48CTiXuZpdM8q
        2gqywj8GC/hITsGEhVldJFs=
X-Google-Smtp-Source: ABdhPJzE1GHi+MWsoBw70MW41vrcTkFIFivUDFUBk0UvN2ufy3W5SBJo96J204ijwVTcynvswdeStg==
X-Received: by 2002:aa7:c652:: with SMTP id z18mr5677105edr.60.1610126552471;
        Fri, 08 Jan 2021 09:22:32 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bn21sm3746389ejb.47.2021.01.08.09.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:22:31 -0800 (PST)
Date:   Fri, 8 Jan 2021 19:22:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v5 net-next 11/16] net: propagate errors from
 dev_get_stats
Message-ID: <20210108172229.yxcwp7t2ipacajhs@skbuf>
References: <20210108163159.358043-1-olteanv@gmail.com>
 <20210108163159.358043-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108163159.358043-12-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 06:31:54PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> dev_get_stats can now return error codes. Take the remaining call sites
> where those errors can be propagated, which are all trivial, and convert
> them to look at that error code and stop processing.
> 
> The effects of simulating a kernel error (returning -ENOMEM) upon
> existing programs or kernel interfaces:
> 
> - cat /proc/net/dev prints up until the interface that failed, and there
>   it returns:
> cat: read error: Cannot allocate memory
> 
> - ifstat simply returns this and prints nothing:
> Error: Buffer too small for object.
> Dump terminated
> 
> - ip -s -s link show behaves the same as ifstat.

Note that at first I did not understand why ifstat and "ip -s -s link
show" return this message. But in the meantime I figured that it was due
to rtnetlink still returning -EMSGSIZE. That is fixed in this patch
series, but I forgot to update the commit message to reflect it. The
current output from these two commands is:

$ ifstat
RTNETLINK answers: Cannot allocate memory
Dump terminated
$ ip -s -s link show
RTNETLINK answers: Cannot allocate memory
Dump terminated

> 
> - ifconfig prints only the info for the interfaces whose statistics did
>   not fail.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v5:
> - Actually propagate errors from bonding and net_failover from within
>   this patch.
> - Properly propagating the dev_get_stats() error code from
>   rtnl_fill_stats now, and not -EMSGSIZE.
> 
> Changes in v4:
> Patch is new (Eric's suggestion).
