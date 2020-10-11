Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7020828AADB
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbgJKWKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbgJKWKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 18:10:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12CB2078B;
        Sun, 11 Oct 2020 22:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602454232;
        bh=s5SNqVq+ZBe6hjQiLpkfiBRZRF78JD0zHMy8UuCWRiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HbAJpZ6018DBKV/l48njs8OL9/FllGvxUgDG8y1p32816ZlZ7gOIkkLIjU7IAfzDF
         2QUcmqA/zF3j9ITlIHLZgFmJWBb6yjdP6LrUeZwu5dy8T8okZRM99so5ko9gjewUvK
         /fH4L6+ICSrkoy+rKqzIM+M5ZF3AZwfiDBhd8oLU=
Date:   Sun, 11 Oct 2020 15:10:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
Message-ID: <20201011151030.05ad88dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 21:34:58 +0200 Heiner Kallweit wrote:
> In several places the same code is used to populate rtnl_link_stats64
> fields with data from pcpu_sw_netstats. Therefore factor out this code
> to a new function dev_fetch_sw_netstats().

FWIW probably fine to convert nfp_repr_get_host_stats64() as well, just
take out the drop counter and make it a separate atomic. If you're up
for that.
