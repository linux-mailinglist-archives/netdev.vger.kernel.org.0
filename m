Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4A6035A2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 00:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJRWED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 18:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJRWEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 18:04:02 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4993ABE525;
        Tue, 18 Oct 2022 15:03:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DD545FF806;
        Tue, 18 Oct 2022 22:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666130613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LcBqf03x+GtVudHxfqW+K/pUlgVsWxbPKfj6lE9Ye98=;
        b=M5Z8r/jb+WWEP5EU8iH6OprPVUjcqb9OJIgd2JvHO/cR3C52tLc9hruaHwmolVPN20r57Z
        Egv56PVrBnau9zd3WxzxfkyyfIBx8PkFvtNb75SoNriXXnoa0atYYTy8+0MRb8CkYWJSmB
        3ayZOQmjtSmUpzuHjA9LTphAWHYTsd9W3NKyAZRvpnWTkAWlQ2e1EbEOSgzr4Vb/zB3snL
        ndifvQ/et95awwjB+B/WSsyj8JyLdfOjFcgRJSuPBsBGJc5Bnps4/Q2vPm5zty42OKjRxi
        BsRjkp2Om/K8y3pikAIN7QmaWoN1zdLs4qywx/ymwpbMAw0v3Ea8GJgcRcRfdA==
Date:   Wed, 19 Oct 2022 00:03:29 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v5] mac802154: Ensure proper scan-level
 filtering
Message-ID: <20221019000329.2eacd502@xps-13>
In-Reply-To: <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com>
References: <20221018183540.806471-1-miquel.raynal@bootlin.com>
        <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Tue, 18 Oct 2022 16:54:13 -0400:

> Hi,
>=20
> On Tue, Oct 18, 2022 at 2:35 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > We now have a fine grained filtering information so let's ensure proper
> > filtering in scan mode, which means that only beacons are processed.
> > =20
>=20
> Is this a fixup? Can you resend the whole series please?

Hmm no? Unless I understood things the wrong way, Stefan applied
patches 1 to 7 of my v4, and asked me to make a change on the 8th
patch.

This is v5 just for patch 8/8 of the previous series, I just changed
a debug string actually...

There was a conflict when he applied it but I believe this is because
wpan-next did not contain one of the fixes which made it to Linus' tree
a month ago. So in my branch I still have this fix prior to this patch,
because otherwise there will be a conflict when merging v6.1-rc1 (which
I believe was not done yet).=20

Thanks,
Miqu=C3=A8l
