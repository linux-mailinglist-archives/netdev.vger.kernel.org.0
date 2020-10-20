Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A564C293270
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389610AbgJTAx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389341AbgJTAx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:53:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BFCE2242F;
        Tue, 20 Oct 2020 00:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603155209;
        bh=LMQKAiX32s0mkVGD3WAfn2HWSOmt6O1YO5RZVdo02vk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GKsZpdaOj6vRnk+OrDbq5xpIPpmixf2Rw8Si3PEPUIIfCC3V3PdHvth9o/LtcadV1
         lR1DnYW0RXy9FIe9FpTA+tZ8YGW39ERm/c9idhBzuU+yULwHuoWRw3n0HH3T/aZD+Q
         bqgp868YRwzBvKzkG1+Ezq7qWvjLvzSlbS3c56dE=
Date:   Mon, 19 Oct 2020 17:53:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <gospo@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v1] net: evaluate
 net.conf.ipvX.all.ignore_routes_with_linkdown
Message-ID: <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201017125011.2655391-1-vincent@bernat.ch>
References: <20201017125011.2655391-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 14:50:11 +0200 Vincent Bernat wrote:
> Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
> ignores a route whose interface is down. It is provided as a
> per-interface sysctl. However, while a "all" variant is exposed, it
> was a noop since it was never evaluated. We use the usual "or" logic
> for this kind of sysctls.

> Without this patch, the two last lines would fail on H1 (the one using
> the "all" sysctl). With the patch, everything succeeds as expected.
> 
> Also document the sysctl in `ip-sysctl.rst`.
> 
> Fixes: 0eeb075fad73 ("net: ipv4 sysctl option to ignore routes when nexthop link is down")
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>

I'm not hearing any objections, but I have two questions:
 - do you intend to merge it for 5.10 or 5.11? Because it has a fixes
   tag, yet it's marked for net-next. If we put it in 5.10 it may get
   pulled into stable immediately, knowing how things work lately.
 - we have other sysctls that use IN_DEV_CONF_GET(), 
   e.g. "proxy_arp_pvlan" should those also be converted?
