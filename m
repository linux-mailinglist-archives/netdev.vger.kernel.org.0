Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DEB63B4FA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiK1Wu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiK1WuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:50:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A105A2A713;
        Mon, 28 Nov 2022 14:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=T9rYwEbRiQBED+qpRhzaD06PSzyyE+bp9qase0iwt68=; b=0talWK4KaQCdH5rTWh68JNXh5E
        FvGJmHuEORZ7f0M1LHuoHTeISlWVoRfrrwhKmJ1WJDZR8ifUE4CoqwY7ueglSZmvD7NgZ2MRtdgCn
        vekVek73CuvjTGvK2JQKLnE7SY6KWvSPqmIi7Ipzrl6DE3ZDvT5CsOv6cFWRxpRNYD4c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozmuq-003nlP-MO; Mon, 28 Nov 2022 23:47:56 +0100
Date:   Mon, 28 Nov 2022 23:47:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christoph Fritz <christoph.fritz@hexdev.de>
Cc:     Ryan Edwards <ryan.edwards@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Richard Weinberger <richard@nod.at>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
Message-ID: <Y4U6nC4/ZUqkSbVq@lunn.ch>
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
 <202211281549.47092.pisa@cmp.felk.cvut.cz>
 <CAEVdEgBWVgVFF2utm4w5W0_trYYJQVeKrcGN+T0yJ1Qa615bcQ@mail.gmail.com>
 <202211281852.30067.pisa@cmp.felk.cvut.cz>
 <CAEVdEgBtikDjQ-cVOq-MkoS_0q_hGJRVSS=9L=htHhh7YvSUgA@mail.gmail.com>
 <Y4UslxhfRPVGXzS/@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4UslxhfRPVGXzS/@mars>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>   - LIN devices with off loading capabilities are a bit special.

For networking in general, we try very hard to make offload to
hardware not special at all. It should just transparently work.

One example of this is Ethernet switches which Linux controls. The
ports of the switch are just normal Linux interfaces. You can put an
IP address onto the ports in the normal way, you can add a port to a
linux bridge in the normal way. If the switch can perform bridging in
hardware, the linux bridge will offload it to the hardware. But for
the user, its just a port added to a bridge, nothing special. And
there are a lot more examples like this.

I don't know CAN at all, but please try to avoid doing anything
special for hardware offload. We don't want one way for software, and
then 42 different ways for 42 different offload engines. Just one uAPI
which works for everything.

    Andrew
