Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6C6D4DE
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390241AbfGRTli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:41:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbfGRTlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YAGdzBLCG5dsMfL2zbVRfaOZMtRzrb67yPj8E/E+uac=; b=3ztnFElTqVKGzD+iF3tjifiy3N
        A8gfsJP3ZjLfHt7pOgFqDN5PHKIQuFefOQmD4Wzrekawv1UEn4bCImhcamiWALPT5tvbWJM08TSiK
        jW/+Y9H8o6s6XgZKXtUCBZCv2B312F+uS8NbeBIVzM1U1qe/0fUL8qUrg8AlESMGHoV8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoCHT-0002jA-8W; Thu, 18 Jul 2019 21:41:31 +0200
Date:   Thu, 18 Jul 2019 21:41:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy
 reset
Message-ID: <20190718194131.GK25635@lunn.ch>
References: <20190718143428.2392-1-TheSven73@gmail.com>
 <1563468471.2676.36.camel@pengutronix.de>
 <CAOMZO5A_BuWMr1n_fFv4veyaXdcfjxO+9nFAgGfCrmAhNmzV5g@mail.gmail.com>
 <CAGngYiULAjXwwxmUyHxEXhv1WzSeE_wE3idOLSnD5eEaZg3xDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiULAjXwwxmUyHxEXhv1WzSeE_wE3idOLSnD5eEaZg3xDw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 01:21:36PM -0400, Sven Van Asbroeck wrote:
> Lucas, Fabio,
> 
> On Thu, Jul 18, 2019 at 12:52 PM Fabio Estevam <festevam@gmail.com> wrote:
> >
> > > Not really a fan of this. This will cause existing DTs, which are
> > > provided by the firmware in an ideal world and may not change at the
> > > same rate as the kernel, to generate a warning with new kernels. Not
> > > really helpful from the user experience point of view.
> >
> > I agree. I don't think this warning is useful.
> 
> Few users watch the dmesg log, But I totally see your point.
> 
> The problem I'm trying to address here is this: when I want to
> reset the fec phy, I go look at existing devicetrees. Nearly
> all of them use phy-reset-gpios, so that's what I'll use. But,
> when I try to upstream the patch, the maintainer will tell me:
> "no, that is deprecated, use this other method".
> 
> Is there a good solution you can think of which would point
> the unwary developer to the correct phy reset method?

Hi Sven

One option would be to submit a patch or a patchset changing all
existing device tree files to make use of the core method. Anybody
cut/pasting will then automatically use the correct core way of doing
it.

There is also a move towards using YAML to verify the correctness of
DT files. It should be possible to mark the old property as
deprecated, so there will be a build time warning, not a boot time
warning.

	Andrew
