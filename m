Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616EB344DB9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCVRto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhCVRtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:49:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 872036148E;
        Mon, 22 Mar 2021 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616435365;
        bh=q7HC2I4mxeo1qc53HdIrLWYeyFGMJRdZ4DQIGQPQ6vY=;
        h=In-Reply-To:References:To:Subject:Cc:From:Date:From;
        b=gNLUmvSrtwP0A6hLSEY+h9Mjhs7+5gPXtF29+4m57BIhAk6FldkSuRr/UGkDsVH1C
         JBczFlk2ctFQ0Feb8M5kAOY0mqt3Umppa57tpti2juMeUy7bDTMqz+5ngo31oto8xA
         hXps8MBPiLdFSmaBmzS2lT7GlLP1glSodiW4APzjwA/6acUVe1CNrKKdoIDtMhbvuR
         gBzuOOz6vthRcXYQB9OFZRJsk4YNKyYjSh1yjEalUb4LtenH0cRFBJc8ywAT5H01j7
         AnipataI2tO1K+T+cE1fgjZqAmZzLlk/PMoln9oDUtiNfOiGrcrnABpP0MuKo7A3Tb
         bqsmdDLXjXk1Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210322174421.GT1719932@casper.infradead.org>
References: <20210322154329.340048-1-atenart@kernel.org> <20210322165439.GR1719932@casper.infradead.org> <161643489069.6320.12260867980480523074@kwain.local> <20210322174421.GT1719932@casper.infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH net-next] net-sysfs: remove possible sleep from an RCU read-side critical section
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <161643536180.6320.4308324155205704739@kwain.local>
Date:   Mon, 22 Mar 2021 18:49:21 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Matthew Wilcox (2021-03-22 18:44:21)
> On Mon, Mar 22, 2021 at 06:41:30PM +0100, Antoine Tenart wrote:
> > Quoting Matthew Wilcox (2021-03-22 17:54:39)
> > > -       rcu_read_lock();
> > > -       dev_maps =3D rcu_dereference(dev->xps_maps[type]);
> > > +       dev_maps =3D READ_ONCE(dev->xps_maps[type]);
> >=20
> > Couldn't dev_maps be freed between here and the read of dev_maps->nr_ids
> > as we're not in an RCU read-side critical section?
>=20
> Oh, good point.  Never mind, then.
>=20
> > My feeling is there is not much value in having a tricky allocation
> > logic for reads from xps_cpus and xps_rxqs. While we could come up with
> > something, returning -ENOMEM on memory pressure should be fine.
>=20
> That's fine.  It's your code, and this is probably a small allocation
> anyway.

All right. Thanks for the suggestions anyway!

Antoine
