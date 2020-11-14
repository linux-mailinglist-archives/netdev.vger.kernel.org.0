Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BF82B3011
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgKNTR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNTR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:17:26 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A86AC0613D1;
        Sat, 14 Nov 2020 11:17:26 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so18674083ejb.3;
        Sat, 14 Nov 2020 11:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbC8+y4b+eAA7rNyPLQIjCBTvRwcIcXayWyHs45xBpo=;
        b=Gr428jHhlSJ1UhxNAedZ0/zlY4OdkyeF77gcdE2s2a4pJaA7nRFTlKfhQcmKWUupGl
         lhgGJvJhFwic5BUYeRCgzpqD9RlmtBWcY+plCxSaa11r53EoCky2XLP+8/gNC4lCeC4X
         0JEbRHsvcZEDIgwQMyga8so7CvJD1NYvhthNbizHH/hVvahHwwqYzTrLS1yIRYl5jou0
         l6p2l+A0h5WyG1yCBH8X6pC4eos+Na81axmkrNogJ+CChi6UqyHu4rvEk/ZEmmtQ+9cM
         EkVFvk93DklAJst75aOTZcm/MplGoAcTcstrSvHOuIb6wEYlqH1apMzcgZnedIL+TMzt
         BE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DbC8+y4b+eAA7rNyPLQIjCBTvRwcIcXayWyHs45xBpo=;
        b=dthJvvVCO+Ba79ouZ2jsDkboIgZHC0iexkhaL8Qd2urZgI/qqkBHPDX8B3mAwdWsZJ
         kQImbAms2QqXkZmpF7Zx7XB18kmlgbOJpU5bqAuHW79j2utKiSb2MsXu+MvAT4kWY3JE
         4goibftG6dNo0uFaBJvOBn28k1yBNWHe+5SfoJuRUtvdwc8SYnf1ch1djBN/4HGeaHRa
         OEsnJ7KUg5LAS4WYAqZ9pPYnu4gIRZ9JvVJaboUYTcLjPicoMizAk7KbUZzIxkVhC/B4
         SbXwfwfmg0l8Dr0hYwGxLcRu3/gbMQ2LPN+ZQIbw1yT4PWOE8NVi4dD26eWefbTAFJVz
         hyTg==
X-Gm-Message-State: AOAM532Ri2Cf/cSt8jFSibP2O4SBYtZi8hFYTvKPOSNrEamZN4B/Q5/R
        rmCEGbc3hbZ9h5zdOpFQORYKJk9dOHk=
X-Google-Smtp-Source: ABdhPJyaXjIdNFAbFCAsA0fR9h5dQCJAEvzN16slQB8P+tn2EJ+nAhIuiG7YUwK1Z70qlGJIOfrLUg==
X-Received: by 2002:a17:906:860b:: with SMTP id o11mr694528ejx.252.1605381444693;
        Sat, 14 Nov 2020 11:17:24 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b1sm7327231ejg.60.2020.11.14.11.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 11:17:24 -0800 (PST)
Date:   Sat, 14 Nov 2020 21:17:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: am65-cpsw: enable
 broadcast/multicast rate limit support
Message-ID: <20201114191723.rvmhyrqinkhdjtpr@skbuf>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
 <20201114035654.32658-4-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114035654.32658-4-grygorii.strashko@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 05:56:54AM +0200, Grygorii Strashko wrote:
> This patch enables support for ingress broadcast(BC)/multicast(MC) rate limiting
> in TI AM65x CPSW driver (the corresponding ALE support was added in previous
> patch) by implementing HW offload for simple tc-flower policer with matches
> on dst_mac:
>  - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
>  - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting
> 
> Hence tc policer defines rate limit in terms of bits per second, but the
> ALE supports limiting in terms of packets per second - the rate limit
> bits/sec is converted to number of packets per second assuming minimum
> Ethernet packet size ETH_ZLEN=60 bytes.
> 
> Examples:
> - BC rate limit to 1000pps:
>   tc qdisc add dev eth0 clsact
>   tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
>   action police rate 480kbit burst 64k
> 
>   rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.
> 
> - MC rate limit to 20000pps:
>   tc qdisc add dev eth0 clsact
>   tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
>   action police rate 9600kbit burst 64k
> 
>   rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---

I understand this is unpleasant feedback, but don't you want to extend
tc-police to have an option to rate-limit based on packet count and not
based on byte count? The assumption you make in the driver that the
packets are all going to be minimum-sized is not a great one. I can
imagine that the user's policer budget is vastly exceeded if they enable
jumbo frames and they put a policer at 9.6 Mbps, and this is not at all
according to their expectation. 20Kpps assuming 60 bytes per packet
might be 9.6 Mbps, and the user will assume this bandwidth profile is
not exceeded, that's the whole point. But 20Kpps assuming 9KB per packet
is 1.44Gbps. Weird.
