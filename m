Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866E66365CB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbiKWQ2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239112AbiKWQ1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:27:47 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2A319022;
        Wed, 23 Nov 2022 08:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=aoAeMEdmL2MvS8jsSZitNEibkl3qtsPxiMd3aeqhHUA=;
        t=1669220866; x=1670430466; b=s/OgaVQksgPM11mqnSsPiDaP/NHFjYR7vVz5JDzgEBnWuA7
        Hp44u74sLT+yntwaTD8CCxLn+EZTANA5GdKOcye2SxWUbq4U5b6Rh1bzt73N7q4ni8gSfDVQogkVL
        L1pYiIpeL5Qe0u+g3RJD1Cv0Zg3s+ryE82iNpqd8TYcOtPdPg/dTM1sjTzlmsn21oT33L/WEkf8pn
        TUC88MYM+pg548J0DDcYfyV/2mB8iBHrUElcnFWJo43dndQATe9LNBFOitONGNla9llEz8SFbIhdO
        Slkry0S1Wb8g28ZmEnhTdIhidJ+OA7QayG+EWpeAk4uqOWmRr7xAtmrBkUQ0gjPQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oxsay-007Fjd-0F;
        Wed, 23 Nov 2022 17:27:32 +0100
Message-ID: <d397e09df8bfd1286ed3e652fbba37ec7fe02f32.camel@sipsolutions.net>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Date:   Wed, 23 Nov 2022 17:27:30 +0100
In-Reply-To: <Y342oUJu9CFHNmlW@kroah.com>
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
         <9b78783297db1ebb1a7cd922be7eef0bf33b75b9.camel@sipsolutions.net>
         <Y342oUJu9CFHNmlW@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-11-23 at 16:05 +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 23, 2022 at 03:20:36PM +0100, Johannes Berg wrote:
> > On Wed, 2022-11-23 at 13:46 +0100, Greg Kroah-Hartman wrote:
> > > The Microsoft RNDIS protocol is, as designed, insecure and vulnerable=
 on
> > > any system that uses it with untrusted hosts or devices.  Because the
> > > protocol is impossible to make secure, just disable all rndis drivers=
 to
> > > prevent anyone from using them again.
> > >=20
> >=20
> > Not that I mind disabling these, but is there any more detail available
> > on this pretty broad claim? :)
>=20
> I don't want to get into specifics in public any more than the above.

Fair.

> The protocol was never designed to be used with untrusted devices.  It
> was created, and we implemented support for it, when we trusted USB
> devices that we plugged into our systems, AND we trusted the systems we
> plugged our USB devices into.  So at the time, it kind of made sense to
> create this, and the USB protocol class support that replaced it had not
> yet been released.
>=20
> As designed, it really can not work at all if you do not trust either
> the host or the device, due to the way the protocol works.  And I can't
> see how it could be fixed if you wish to remain compliant with the
> protocol (i.e. still work with Windows XP systems.)

I guess I just don't see how a USB-based protocol can be fundamentally
insecure (to the host), when the host is always in control over messages
and parses their content etc.?

I can see this with e.g. firewire which must allow DMA access, and now
with Thunderbolt we have the same and ended up with boltd, but USB?

> Today, with untrusted hosts and devices, it's time to just retire this
> protcol.  As I mentioned in the patch comments, Android disabled this
> many years ago in their devices, with no loss of functionality.

I'm not sure Android counts that much, FWIW, at least for WiFi there
really is no good reason to plug in a USB WiFi dongle into an Android
phone, and quick googling shows that e.g. Android TV may - depending on
build - support/permit RNDIS Ethernet?

Anyway, there was probably exactly one RNDIS WiFi dongle from Broadcom
(for some kind of console IIRC), so it's not a huge loss. Just having
issues with the blanket statement that a USB protocol can be designed as
inscure :)

johannes
