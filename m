Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4F1A2A81
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgDHUii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:38:38 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:56288 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgDHUii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:38:38 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 64119B233D;
        Wed,  8 Apr 2020 16:38:36 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=FXs96PD9q6AihpPiIw66bQCCq08=; b=U8ETg0
        PMUzCxd1Etp4NTyjwzMVnSGylSOEkCEBXTKQYzm7o3Acpusy+ZC2z7Ra8sWzvHP9
        pnt3xOIbUpkedWag6NuNCVdmiLjRH674iDjF8gcmVmbVPGZCZuNTyiYLda7vq6lL
        RYQd+jNEdW+/AJGlaJ8XO2ozC2x4gdHJmqJFw=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 5B0C5B233C;
        Wed,  8 Apr 2020 16:38:36 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=qLgNDpEXsnrm/8QYj83jowhEfOt5/wA6l8IQuAQGxlY=; b=BpSnWiZOUdexci0KAuec0G+2jfPVozIKdqH97mGEA108YctqFuRxRffnGzGrPwh2foY4yVjd0fKDiPFWkJWkdmQthCj9TJyaqJ7SNxaaysIuRmFzGAdaXTKY7K1rT6cxW0LYK3KBQUU/n1fyLp+kXrbsfctkypwMeTILo06PQv4=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id D8611B2338;
        Wed,  8 Apr 2020 16:38:31 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id F39562DA0D3A;
        Wed,  8 Apr 2020 16:38:29 -0400 (EDT)
Date:   Wed, 8 Apr 2020 16:38:29 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
In-Reply-To: <20200408202711.1198966-1-arnd@arndb.de>
Message-ID: <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
References: <20200408202711.1198966-1-arnd@arndb.de>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: E91C3C66-79D8-11EA-84B4-B0405B776F7B-78420484!pb-smtp20.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020, Arnd Bergmann wrote:

> Hi everyone,
> 
> I've just restarted doing randconfig builds on top of mainline Linux and
> found a couple of regressions with missing dependency from the recent
> change in the "imply" keyword in Kconfig, presumably these two patches:
> 
> 3a9dd3ecb207 kconfig: make 'imply' obey the direct dependency
> def2fbffe62c kconfig: allow symbols implied by y to become m
> 
> I have created workarounds for the Kconfig files, which now stop using
> imply and do something else in each case. I don't know whether there was
> a bug in the kconfig changes that has led to allowing configurations that
> were not meant to be legal even with the new semantics, or if the Kconfig
> files have simply become incorrect now and the tool works as expected.

In most cases it is the code that has to be fixed. It typically does:

	if (IS_ENABLED(CONFIG_FOO))
		foo_init();

Where it should rather do:

	if (IS_REACHABLE(CONFIG_FOO))
		foo_init();

A couple of such patches have been produced and queued in their 
respective trees already.


Nicolas
