Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD23D2AA74F
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgKGRw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgKGRwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:52:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D209320885;
        Sat,  7 Nov 2020 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771545;
        bh=Ek8fLm8CsziGOioX30LOA4auYUYzdOZZY0eTuGPWcfc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KwKf/2R51UpXegvQjPlFVDOl0p2hMluq1qw8FEBAPjkE4vlxnixWahOmH7RYJYENy
         9p9ZoMxIyXD92MbzXsbRnvANVMD/qkVK+D/15NIX2N3YiDsvv/eYZwsLzAkeQNV77h
         fHoEuI4De4klH1TaELuhV1rFgG52aJHQgokj6k08=
Date:   Sat, 7 Nov 2020 09:52:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
Message-ID: <20201107095224.63c27a1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107075550.2244055-1-ndesaulniers@google.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 23:55:50 -0800 Nick Desaulniers wrote:
> -			   ntohs(tuple->src.u.icmp.id));
> +			   (__be16)ntohs(tuple->src.u.icmp.id));

Joe has a point, besides __be16 clearly is not the right type here,
the result of ntohs is in host order.
