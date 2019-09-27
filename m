Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7F0C0815
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfI0O4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 10:56:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfI0O4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F0xnrmUjbrfwa3GpwQVGYBFuXq2e2mehUtxT3ModRTo=; b=nhxK6DBTvF+v06EKwJgrmAlsi7
        JIwhI4VYfcrPNojHpc8+3Pt0aN7Lk5xpnJJDFhs33EhLD7yRs+BR5QG9L51JD0iKXDhBSy6YTcrRP
        Krh4aOZqNKBNmvoGdG313jPmOLHKKyBBvYkC74GftuqTqshNXRZv8iEBTukdlds8psEo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDrfc-0002vq-L1; Fri, 27 Sep 2019 16:56:32 +0200
Date:   Fri, 27 Sep 2019 16:56:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent Cheng <vincent.cheng.xh@renesas.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Message-ID: <20190927145632.GI20927@lunn.ch>
References: <1569556128-22212-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1569556128-22212-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20190927122518.GA25474@lunn.ch>
 <20190927141215.GA24424@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927141215.GA24424@renesas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static void set_default_function_pointers(struct idtcm *idtcm)
> >> +{
> >> +	idtcm->_idtcm_gettime = _idtcm_gettime;
> >> +	idtcm->_idtcm_settime = _idtcm_settime;
> >> +	idtcm->_idtcm_rdwr = idtcm_rdwr;
> >> +	idtcm->_sync_pll_output = sync_pll_output;
> >> +}
> >
> >Why does this indirection? Are the SPI versions of the silicon?
> 
> The indirection is to enable us to replace those functions in
> our unit tests with mocked functions.

Due to Spectra/meltdown etc, indirection is now expensive. But i guess
the I2C operations are a lot more expensive.

But in general, we try to keep the code KISS. Have you tried other
ways of doing this. Have your unit test framework implement
i2c_transfer()?
 
> I read somewhere that I should leave a week between sending a
> revised patch series.  Is this a good rule to follow?

There are different 'timers'. One is how long to wait for review
comments, and reposting when you don't receiver any comments. netdev
for example is fast, a couple of days. Other subsystems, you need to
wait two weeks. Another 'timer' is how often to post new versions. In
general, never more than once per day. And the slower the subsystem is
for making reviews, the longer you should wait for additional review
comments.

What also plays a role is that the merge window is currently open. So
most subsystems won't accept patches at the moment. You need to wait
until it closes before submitting patches you expect to be good enough
to be accepted.

   Andrew



