Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E071A2AEB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgDHVRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:17:54 -0400
Received: from pb-smtp2.pobox.com ([64.147.108.71]:51922 "EHLO
        pb-smtp2.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgDHVRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:17:53 -0400
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id 15C175069A;
        Wed,  8 Apr 2020 17:17:49 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=UIkb5A+H+jKDQ3GWp3Tbf0a8oXM=; b=AcgYlX
        TnCHG5UcWgHkl8IlsC1e1uSPmTDBMpHTb4rnXL06C201X87TtsWkywbE7tyhVEgL
        joaA4hStDMXuw8ZUssiqUmef7sB8CpImWNNVRynUk532oaFQQiq7ylZfjC6WKOG0
        n438CvV7eUlVobxBSL2o/win8JdgiYwNnjPJU=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id EBD9250698;
        Wed,  8 Apr 2020 17:17:48 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=C5qZnucLOvddU0/aYHUwvuoSJMokDJ9d4K7zprmELhs=; b=rhI9Y9k7ariW+D63u1TPx511dXcnGqLfZWvC4hyySB7C8iu6lcGWtATA4lzrxivdp5SOwycFxqeXwlBHGMIZ+/TN4juy0TA9A3TTPQBm6TTbluFOmyrcr3+B1c5KEDP/2UtjGbuSvcOZxVxL1iYp3mQwA1ofghE5W48Ncw1e8cc=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id 5F86F50697;
        Wed,  8 Apr 2020 17:17:48 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 798F72DA0D4B;
        Wed,  8 Apr 2020 17:17:47 -0400 (EDT)
Date:   Wed, 8 Apr 2020 17:17:47 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
In-Reply-To: <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
Message-ID: <nycvar.YSQ.7.76.2004081715080.2671@knanqh.ubzr>
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr> <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 65B28AAA-79DE-11EA-BF5C-D1361DBA3BAF-78420484!pb-smtp2.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020, Arnd Bergmann wrote:

> On Wed, Apr 8, 2020 at 10:38 PM Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Wed, 8 Apr 2020, Arnd Bergmann wrote:
> > > I have created workarounds for the Kconfig files, which now stop using
> > > imply and do something else in each case. I don't know whether there was
> > > a bug in the kconfig changes that has led to allowing configurations that
> > > were not meant to be legal even with the new semantics, or if the Kconfig
> > > files have simply become incorrect now and the tool works as expected.
> >
> > In most cases it is the code that has to be fixed. It typically does:
> >
> >         if (IS_ENABLED(CONFIG_FOO))
> >                 foo_init();
> >
> > Where it should rather do:
> >
> >         if (IS_REACHABLE(CONFIG_FOO))
> >                 foo_init();
> >
> > A couple of such patches have been produced and queued in their
> > respective trees already.
> 
> I try to use IS_REACHABLE() only as a last resort, as it tends to
> confuse users when a subsystem is built as a module and already
> loaded but something relying on that subsystem does not use it.

Then this is a usage policy issue, not a code correctness issue.

The correctness issue is fixed with IS_REACHABLE(). If you want to 
enforce a usage policy then this goes in Kconfig.

But you still can do both.


Nicolas
