Return-Path: <netdev+bounces-6297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF42271595C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CE752810B8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AB912B9C;
	Tue, 30 May 2023 09:07:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883CC134A5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:07:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937ECCD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685437621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r3Zial9iZJISeYClvZYyZ8Yv7etW85azNObdeUUZmYs=;
	b=CBgJBv/oFnM1ev0ejhPT+MXrnhprZIAXRqugJ/OzO0ug2ki7l4t1lTMKM04sTXxI7A3bUZ
	qC3YojtU9g/e0suSntWMiInehA8Z9RSWaWAknNsjgPN8+dGYyJGQYWLjPh0Twc1eAoa3De
	MYrbngVfayjXtp7HNcpeMfMq81ztAww=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-keJTRcY3Mbmtphos5pcgyQ-1; Tue, 30 May 2023 05:07:00 -0400
X-MC-Unique: keJTRcY3Mbmtphos5pcgyQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-75b147a2548so36880085a.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685437620; x=1688029620;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r3Zial9iZJISeYClvZYyZ8Yv7etW85azNObdeUUZmYs=;
        b=c2xmrtPkZAMAPs/6z0EfVt4mbLp1iJtTkNg4OIUSb7zOKyX+mRA0fvc1Vf13o+7lfQ
         YlPqaJZ0RAoXP6b8Dq74HlALNohAU8HfPM7v5cY72yPbMSR2NWO4ss+HDCJ2Ik4gGKaP
         kXxFmpTf7uOzripgE4rS7q2yAELKTeL0GH/aDoqQiM6MV5fhpyjbm6q9sPhLPSNlgrat
         qINplCK2n51u4FnR10eye/n5jeSLzm+Zx6p/BAHC6ijB030BnU/J0eT5kjTkeQYhHVJX
         op9QPQWqdjgwuUcvr5mchck1TzBlw/FieZudoUtKMb1SdcKCmZV6JW8h/TeZPbHoYZbX
         pLeQ==
X-Gm-Message-State: AC+VfDyuVpqB1mkKXhh3oK4QywcPCV25pgr3RQySVg5jjx8mBLEd25Pn
	G2vBJ55854Kn7RmEL5ypJ3MpARttrCgUOTG/KM9HOLeN2mGkv4Li3Q01mj7MSY+7iAGCo3Jpp/+
	wBMuv+ICQY/Z4XqCz
X-Received: by 2002:a05:620a:28d1:b0:75b:23a1:69eb with SMTP id l17-20020a05620a28d100b0075b23a169ebmr1642861qkp.2.1685437619917;
        Tue, 30 May 2023 02:06:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5JYz1BOc+28hQeM8NLy6JZBLVmZY7T0sdKmepYq5PLTRtGePjFwkRZaNHzSZ6j0qJZ3g1Q1Q==
X-Received: by 2002:a05:620a:28d1:b0:75b:23a1:69eb with SMTP id l17-20020a05620a28d100b0075b23a169ebmr1642848qkp.2.1685437619662;
        Tue, 30 May 2023 02:06:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id x12-20020ae9f80c000000b0075954005b46sm3959048qkh.48.2023.05.30.02.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 02:06:59 -0700 (PDT)
Message-ID: <c7a1ee2dea22cd9665c0273117fe39eebc72e662.camel@redhat.com>
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>, Russell
	King <linux@armlinux.org.uk>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Oleksij Rempel
 <linux@rempel-privat.de>, Heiner Kallweit <hkallweit1@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org,  kernel-janitors@vger.kernel.org
Date: Tue, 30 May 2023 11:06:55 +0200
In-Reply-To: <20230529215802.70710036@kernel.org>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
	 <20230529215802.70710036@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-29 at 21:58 -0700, Jakub Kicinski wrote:
> On Fri, 26 May 2023 14:45:54 +0300 Dan Carpenter wrote:
> > The "val" variable is used to store error codes from phy_read() so
> > it needs to be signed for the error handling to work as expected.
> >=20
> > Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configu=
ration")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>=20
> Is it going to be obvious to PHY-savvy folks that the val passed to
> phy_read_poll_timeout() must be an int? Is it a very common pattern?
> My outsider intuition is that since regs are 16b, u16 is reasonable,
> and more people may make the same mistake. Therefore we should try to
> fix phy_read_poll_timeout() instead to use a local variable like it
> does for __ret.=20
>=20
> Weaker version would be to add a compile time check to ensure val=20
> is signed (assert(typeof(val)~0ULL < 0) or such?).

FTR, a BUILD_BUG_ON() the above check spots issues in several places
(e.g. r8169_main.c, drivers/net/phy/phy_device.c, ...)

I think it should be better resort to a signed local variable in
phy_read_poll_timeout()

Thanks,

Paolo


