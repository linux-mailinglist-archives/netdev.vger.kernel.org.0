Return-Path: <netdev+bounces-10469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1DA972EA42
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D1F2810A0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA833C0AB;
	Tue, 13 Jun 2023 17:53:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F733E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:53:05 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE78E10F6;
	Tue, 13 Jun 2023 10:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
 s=s31663417; t=1686678740; x=1687283540; i=frank-w@public-files.de;
 bh=ZigiYZJoMQ30F2MLp+pxKoTlTEC81zQmh89oTDunKXc=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
 b=cM9pl0hWQFpHOw4HEi/vmjQuZ3YTZmMNSwZe9Vuk9JOxB3CUZbBUoEevqoRylla9ZOkyoMO
 bOmLa93yddI9tiFt+Jk9b2PH31VWxes2M907imvo9ELNoOWKnY/5dV6u7IBsGdUySTufhbv5F
 FLyTPN6DXAuDsKHQxvWMcLeVxHKF/RLT6WtuXWYIgvXNdu3seKei91vV6D+jsDN8Rgqc5ZFC2
 4GL6BwD7sYj9cJ+5R48OTMS6rSd/+0TIcQL4Kz9vkJnst4KvJZWNDWLtAbU3DRdMME6p1/6ml
 EArd1yhjWPQRoUul9mZ0J/PknuYs3ILtbLVHZzBOZQBcJuRZt9xg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.4] ([217.61.149.4]) by web-mail.gmx.net
 (3c-app-gmx-bap45.server.lan [172.19.172.115]) (via HTTP); Tue, 13 Jun 2023
 19:52:20 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <trinity-c8924d31-5582-4174-b017-553e64864079-1686678740313@3c-app-gmx-bap45>
From: Frank Wunderlich <frank-w@public-files.de>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>, Daniel
 Golle <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>, DENG
 Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>, Andrew
 Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Matthias
 Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Russell King
 <linux@armlinux.org.uk>, Bartel Eerdekens <bartel.eerdekens@constell8.be>,
 mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Aw: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames
 with multiple CPU ports on MT7530
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Jun 2023 19:52:20 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:jggrxmZjmJDSj7Yc4T0jkrjBt3MAF/uwXCMxy3haSJShvuHfS6IGYN48RD8rHQ7jUK1BI
 oHgPQLituXgFRd8am6bM9tTROWD6veOT9NhPw+VdMCEcDX8auybulmct/op8qY5EI73nU1HYd76N
 yGIduMdQXcV/eF5FJa0+FI22jwFa6Vs4RrVgN7tZInntDlJeor/NCK9qlD8RYwmvEg8yvPO/hnkb
 5slOVcuwhIihioOjPD3DoBQIKR/hiDRLM6Z7eF0dgKeWwy7Q7sEJwXmrOsTBG5yzhKeJd2iDMBa6
 vw=
UI-OutboundReport: notjunk:1;M01:P0:b5XNck1g0f8=;+CjfVvZ8bFxtq7g+dnwJjCQCpNR
 qmAF7ktbxXk1A5l2U3wHOcrUnqYhcvM9tOmkiSVS2LmdIU5mExQjLBY6rkkfvajPL0aEYsemd
 m1XhiHL4jTrMI1JYDM3GoXlgFcEqk8piyZonWrkS0v+LWcmeI0OKDnSaWSx2hcRr5bAJmLoh/
 ASm9Iqw8/uspEmZfh+VJxaNjw4QA3wy6UE690XpbNbzzTb7J0BoRKYxTyhzyDQI3F7EJ9r3eY
 5dfaByvPNjhSsG6DQTU4xmN6JVbgi/JA8zvaoKZQ+STO8JO+AdjFAZXx1AaitcQcQ6dsHpwY/
 ekEpnSwxaGWJhWob8+j/DmdLvkDQBMPsmKO94ezij00IB3W9hBVWBVy7ZsQm+kBT+5u6yoOaL
 1i5c9HES6c949540FRyJ1gmgvrzpXGL1LP6ZdYTPWiSlDbBHVOj9gfYDpXwd+k6ichTBwpx13
 aVMhZQipB5jVgxH9Pahy1dV3apI1j8ikPHdBcdzNrryN4VUx6qiDrak+QVLseyHyU3h/hECIz
 19r08MIKuL8SuDoQ/h3Bm+utkZ1k45jo3vAUPSQVRXagV8viv0o1r8QodL1o3Zr3W/1yx2PtL
 snlCP0ZNqZdL/46KMcQ+xBGoLwSW1kKmw+VBbXOhcj+xN55GF6oS202L8QhELphsk7rcnrPgG
 +jEOOgi8ueidRonwzbrNDIfKl48JOCeRdSdspuUUL/JscPmUcjyVf3YGeg0iNmONg64Yzrvk9
 KWGXJ3FybKKMZ+wyGzUTLqFHGcaqxf5XdBk6uQyn7c4jztX7btv0c0OT50dUe4Fm8dFbzF5ts
 IkZGvp/TCV7x9zmEnFKIMcjA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi

> Gesendet: Dienstag, 13=2E Juni 2023 um 19:18 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail=2Ecom>

> On Tue, Jun 13, 2023 at 08:14:35PM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrot=
e:
> > Actually, having only "net: dsa: introduce preferred_default_local_cpu=
_port
> > and use on MT7530" backported is an enough solution for the current st=
able
> > kernels=2E
> >=20
> > When multiple CPU ports are defined on the devicetree, the CPU_PORT bi=
ts
> > will be set to port 6=2E The active CPU port will also be port 6=2E
> >=20
> > This would only become an issue with the changing the DSA conduit supp=
ort=2E
> > But that's never going to happen as this patch will always be on the k=
ernels
> > that support changing the DSA conduit=2E
>=20
> Aha, ok=2E I thought that device trees with CPU port 5 exclusively defin=
ed
> also exist in the wild=2E If not, and this patch fixes a theoretical onl=
y
> issue, then it is net-next material=2E

BananaPi R2Pro (Rockchip rk3568 arm64) has currently port5 only=2E And the=
re only port5
is connected to the SoC (so port6 is not added there)=2E

Most boards using port6 at the moment=2E

regards Frank

