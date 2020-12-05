Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8D42CFFBD
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgLEXYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgLEXYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:24:32 -0500
Date:   Sat, 5 Dec 2020 15:23:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607210632;
        bh=RjV1wPErZx185RSGihii1lBmdig8EQNnlLH4Uh4Ej74=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=SaeUmhe8oQy1BRHpzbcZTnMTMrFLKEdME05LVtbLlYo/eAirQz6CuK7FZbYnFDSpr
         MTiRRPANVcNtblY6+CML3orhqUWOt+Y3N3+ZbE5VPBSdVVxOETJ4VYNggLiqZpUOiL
         vyyeLAXOxMe7HV/GmrgSivkghYczYdVoGYHrISLNqTXnkceQe38APoxlxlJFXeJJxm
         W3i19o4M/yVZqwyly2epgH/hjIFPtA/hEzb4b7nIMzJ56YHqu8wae+IIu+Wx8ORAKI
         E5WuQh0TkW6jW6Zxqw2m4+fzXkUNUrqCoU/KnYsCnmvOYIEVmgvZ8EEbAW/83sh74i
         NaxlCOA8qQnIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] ch_ktls: fix build warning for ipv4-only config
Message-ID: <20201205152351.055d3f05@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAK8P3a3TuKAC60HAjiyHwy7ciQp=mCNKjmG5jcaCFWe8ysVCuA@mail.gmail.com>
References: <20201203222641.964234-1-arnd@kernel.org>
        <20201204175745.1cd433f7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAK8P3a3TuKAC60HAjiyHwy7ciQp=mCNKjmG5jcaCFWe8ysVCuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Dec 2020 00:18:44 +0100 Arnd Bergmann wrote:
> > This is for evrey clang build or just W=1+? Would be annoying if clang
> > produced this on every build with 5.10 (we need to decide fix vs -next).  
> 
> The -Wsometimes-uninitialized is enabled unconditionally for clang,
> but this only happens for IPv4-only configurations with IPv6 disabled,
> so most real configurations should not observe it, but the fix should still
> go into v5.10.

Great, I guessed correctly :)
