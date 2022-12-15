Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571C564D63D
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 06:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLOFqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 00:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLOFqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 00:46:06 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30CE32B8B
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:46:03 -0800 (PST)
Received: from [192.168.14.220] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 649CF20034;
        Thu, 15 Dec 2022 13:45:57 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1671083158;
        bh=M1+aFTwAxXO7Z4YqK9TGJYffLz8SqEQ3BPKTCaP35gg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=A9U+bn73lECY4vI765xjQ/135zRjArbHEh17oZGrK36WksQ2/DINB4MQd5TnfiykS
         kVL+pfzYUzLUNDFhYXwowPXaKSzmMSnIv4sfJVFUhDmItguK+L1UE4B0CDD3Zanjw0
         GjNu5zXGhHbBC6CT+jKZ0Y/sVwYKoG2IB/ZJARAk3YU4KcLWD05PMm+wQtKMSiT/hs
         nk11z0UlQp/0XKRVojc0Vt1KbbBRveJ8qYqZ1O9Hg2z0fbnFWaNXlQ8ZRVJw5dXn4f
         iJL0SgPnNK9c69e9dA9NgkRpettCP/3hAa/lkjB4YZu3AbupRpA46Hxk8bVT9rvXJE
         QDnrm6abgrPgQ==
Message-ID: <4ce3d9c2297c4b839ab8c6fac0f8cdb375813e0b.camel@codeconstruct.com.au>
Subject: Re: [PATCH net] mctp: Remove device type check at unregister
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, jk@codeconstruct.com.au
Date:   Thu, 15 Dec 2022 13:45:56 +0800
In-Reply-To: <7ee98dcab99a4fd23323f6cec803ef6c008118b0.camel@gmail.com>
References: <20221214061044.892446-1-matt@codeconstruct.com.au>
         <7ee98dcab99a4fd23323f6cec803ef6c008118b0.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 08:42 -0800, Alexander H Duyck wrote:
> > diff --git a/net/mctp/device.c b/net/mctp/device.c
> > index 99a3bda8852f..dec730b5fe7e 100644
> > --- a/net/mctp/device.c
> > +++ b/net/mctp/device.c
> > @@ -429,12 +429,6 @@ static void mctp_unregister(struct net_device *dev=
)
> >  	struct mctp_dev *mdev;
> > =20
> >  	mdev =3D mctp_dev_get_rtnl(dev);
> > -	if (mdev && !mctp_known(dev)) {
> > -		// Sanity check, should match what was set in mctp_register
> > -		netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
> > -			    __func__, dev->type);
> > -		return;
> > -	}
> >  	if (!mdev)
> >  		return;
> > =20
>=20
> It looks like this is incomplete if we are going to allow for these
> type of changes. We might as well also remove the block in
> mctp_register that was doing a similar check for devices that already
> have the mctp_ptr set. Otherwise you will likely need to follow up on
> this later.

I'm not sure it's possible to hit that, I'll remove it in a v2.

Thanks for the review.

Cheers,
Matt
