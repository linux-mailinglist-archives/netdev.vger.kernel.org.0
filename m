Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570CA531F55
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiEWXo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiEWXo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:44:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C8880F4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+Geb9PYtwxT5Z+UrYs52VykQbohwi4PGJG7zLFfk65Y=; b=NuHvSXxYz2eqJljXK4JV5yU6AL
        pctHgrf23jcL6eL3Xv1F44oF6+xEZzr+LdBDgPl0hPOrc3aYsvJ9KNQZEw7zTN43iq/xJsIViO9DW
        U0am+9aY+2OWOY9MbFglpAe8E7O8QjHaH69KCOXyYtqWBYPi3aFSDkaiJ7T6m/9bUqcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ntHj3-0042L5-4R; Tue, 24 May 2022 01:44:37 +0200
Date:   Tue, 24 May 2022 01:44:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Networking <netdev@vger.kernel.org>,
        David Wilder <wilder@us.ibm.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Subject: Re: [PATCH net v3] net: ftgmac100: Disable hardware checksum on
 AST2600
Message-ID: <YowcZUX3lwAA6c5k@lunn.ch>
References: <20220517092217.323060-1-joel@jms.id.au>
 <5630dd68ca5f31dafce3f92489761294ea589b16.camel@kernel.crashing.org>
 <CACPK8Xd5BLiz1ePwzirtxLvSL8V8EGmJuxB0GmxyyqBRK9mSdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8Xd5BLiz1ePwzirtxLvSL8V8EGmJuxB0GmxyyqBRK9mSdQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > The observed results:
> > >
> > >  1500 - good
> > >  1434 - bad
> > >  1400 - good
> > >  1410 - bad
> > >  1420 - good

Looking at these numbers, all the good cases a divisible by 4. All the
bad cases are not.

Could you extend the test to automatically test 64 through 1500?  Or
manually try 1499, 1498, 1497, 1496. Maybe the workaround is if the
packet length is divisible by 4 let the hardware do the checksum,
otherwise do it in software.

      Andrew
