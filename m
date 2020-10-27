Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC9D29AC06
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895615AbgJ0M1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:27:23 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40340 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408242AbgJ0M1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:27:23 -0400
Received: by mail-yb1-f194.google.com with SMTP id n142so1063021ybf.7
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2E2YC0mUn1v/iLoWaN0CWjVLhES58TqhLoJVNcD+GOw=;
        b=k3BTBZIF4fRfDUIpYKg4CNKzU4Vu5h25v/S0vhAh+kk7HfDENL0s06oB0WnMvARc44
         rm6EoJO+OOqkFUaebhwbiODX4Xf9vKheDDpXUCxUrITjpf/OgEOPv9WN4jd8SLV0ns8t
         c67naNoOCKDItwPba0rN8TH3qE++hqidJL1Q1hCJiMwnRV2KSK8vxR5GeLKoq4bN9eas
         3IvrjTBTCd8yynbKfaKNVOUQed8wvgI9GspAc6Sx2ht0QIx9/yoc0fOeP7bs6d0q2O8y
         8zep9bGCD+BEvFMhCUrwqAw/35bZG4xedC0+mH9ThCnanMhA/uFT/IAYavEPSeyBxS1n
         XLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2E2YC0mUn1v/iLoWaN0CWjVLhES58TqhLoJVNcD+GOw=;
        b=H3wv4EeNxgjZX/XcMt/xNxM1Uhz5qwwNtD3CPfIRizuplQyGzLEyCRrEYQRkEja4p0
         E1JoKsQMQOU77F6mi2wKZjlxu6E48Lc301r4NhtXfXwfGqHNWaKtUB0Gdzj7uVAHZ9ZC
         BiBJnpt1uL95DGxwTB5aHQRv9al2Q2tx+chp/+tYbjVg1d6W6ZCmiCeBKtoq8oPJezHB
         6EB26hRiTjwdVnz2zMHZs7lFKBnryQtztU51S7QkCq+qHnFPBYCd5WEOtO3F+tNKKvFA
         bbRUaCDCYcjq/wy4CVQFR7eO8/3ALWjVd16TtDGnUG57s781Mg1C+gWOxo7qgQx7yumP
         gJ6A==
X-Gm-Message-State: AOAM532Y6WXpQE5qkEwNdgnACStMUWa9hy/wM89L6j9DtVinQJPgtrNo
        7yGRWCW6BpwG+txQixZknDebeZlBZCo=
X-Google-Smtp-Source: ABdhPJw5y9Xld2dQEZrms2LIxT0ZzBkza0wc2W27+TcOJIauv3Rt8ZFdff5DuextpvTUiVpH1lvuKw==
X-Received: by 2002:a25:781:: with SMTP id 123mr2842930ybh.108.1603801642336;
        Tue, 27 Oct 2020 05:27:22 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h17sm923034ejf.98.2020.10.27.05.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:27:21 -0700 (PDT)
Date:   Tue, 27 Oct 2020 14:27:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027122720.6jm4vuivi7tozzdq@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Tue, Oct 27, 2020 at 11:51:13AM +0100, Tobias Waldekranz wrote:
> I would really appreciate feedback on the following:
> 
> All LAG configuration is cached in `struct dsa_lag`s. I realize that
> the standard M.O. of DSA is to read back information from hardware
> when required. With LAGs this becomes very tricky though. For example,
> the change of a link state on one switch will require re-balancing of
> LAG hash buckets on another one, which in turn depends on the total
> number of active links in the LAG. Do you agree that this is
> motivated?

I don't really have an issue with that.

> The LAG driver ops all receive the LAG netdev as an argument when this
> information is already available through the port's lag pointer. This
> was done to match the way that the bridge netdev is passed to all VLAN
> ops even though it is in the port's bridge_dev. Is there a reason for
> this or should I just remove it from the LAG ops?

Maybe because on "leave", the bridge/LAG net device pointer inside
struct dsa_port is first set to NULL, then the DSA notifier is called?

> At least on mv88e6xxx, the exact source port is not available when
> packets are received on the CPU. The way I see it, there are two ways
> around that problem:
> 
> - Inject the packet directly on the LAG device (what this series
>   does). Feels right because it matches all that we actually know; the
>   packet came in on the LAG. It does complicate dsa_switch_rcv
>   somewhat as we can no longer assume that skb->dev is a DSA port.
> 
> - Inject the packet on "the designated port", i.e. some port in the
>   LAG. This lets us keep the current Rx path untouched. The problem is
>   that (a) the port would have to be dynamically updated to match the
>   expectations of the LAG driver (team/bond) as links are
>   enabled/disabled and (b) we would be presenting a lie because
>   packets would appear to ingress on netdevs that they might not in
>   fact have been physically received on.

Since ocelot/felix does not have this restriction, and supports
individual port addressing even under a LAG, you can imagine I am not
very happy to see the RX data path punishing everyone else that is not
mv88e6xxx.

> (mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
> seems like all chips capable of doing EDSA are using that, except for
> the Peridot.

I have no documentation whatsoever for mv88e6xxx, but just wondering,
what is the benefit brought by EDSA here vs DSA? Does DSA have the
same restriction when the ports are in a LAG?
