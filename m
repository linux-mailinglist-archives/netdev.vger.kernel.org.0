Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B055F6C8CF2
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 10:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjCYJ2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 05:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbjCYJ2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 05:28:06 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1926E2D61
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 02:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679736481; i=frank-w@public-files.de;
        bh=Ul1L9FEefs5iwACDDtk3oUiWMPr2IzeUo5sHKwKhSbI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BcKpzzmonTI/5cBpLSMxsqrFDbPX4pbh8aGPPAt9MNRIP+1T5dEITNe/1OlN0vQFs
         HTdi9okPsd5Dut/99kiSTF9/fmiT6/gjWFQsV+/uKPLMI7HmhL2JERg6j9oRcwrsFP
         4UDebKVgGxdMgYbIzC73gLVWIIQzPOQEV5LyMDDdlTI4ou/gdSZuBmhdsP8haROqFC
         vkB9Vicnnor9k7pOhj4kerpd0kphZ5Ex/rphOqkFhvON62b22/Pqt+yL0UNZhrxsTb
         O0HYL0H13ykDLcaYt3Of5hxn2uXPUUkOl2TUKFSW4GZYiKlRrWX9eVnKpvIcKBk4Ll
         PCqUg2vuJjxzw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.75.216] ([80.245.75.216]) by web-mail.gmx.net
 (3c-app-gmx-bap48.server.lan [172.19.172.118]) (via HTTP); Sat, 25 Mar 2023
 10:28:01 +0100
MIME-Version: 1.0
Message-ID: <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Aw: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput
 regression with direct 1G links
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 25 Mar 2023 10:28:01 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230324140404.95745-1-nbd@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:pce2h4H2GSV5H6q10Euut+DRLeC0C7gTcKbgjWvvy2/wlnyKvFsOVh63DiOwrKmLQ1uqt
 EKpi4YwPrUVYltPNQcp3ZrPppN2AtFj/6e2Z6ua1nrXRsitoWo0mvp+Rf+VJg68+2s2lcMxrFMx0
 +5FDNTy9HC3zJk8JkfQQiF6+Ym0EPxVGzyrgWlFWHlFCkCBCa3qcPSYNmHKoPaWWe6Ld0VWiQFjS
 oYH7ypK+0pMtuyoUp4DfnSwH/HMpvdLsdZjrWpZKQRgBg+vbXjoUyWfqbiVVkAI9EKqacomOHB6d
 5g=
UI-OutboundReport: notjunk:1;M01:P0:uEQu4c+onxw=;jLDp0+b/+CZT8FoJqm2JVMcA02t
 qNg1SojqlCf1pYgYb5otqvaGHb8+qcZmwTR7qX/TxJfohlDoPIv13Ur81lL89l+oo7o3DfmTL
 aBw1rXbuZGaTi2Z2YVfte/e/uL9SrjjZk5/8018bfZzBsf9ULkfyMfQnrRe4WGwKkk4hog3hI
 PAPUy/t1idwT6Fwq/Ll5VAuJfGVYLGUuYqygmUuiL8kOtcPIcKOJHYFG6fYnW+a+HNBAnyXZr
 fIwbE6HDx7rh7p0KDBCqKlh3TvSpmxv6XfPowX17X/Horf3GL0H5HwKd/5Yxlpxdib46ciCuY
 BKhN/+Q4dUriYPpq++hzH5WwIAsW/fXTA6PyQO+imA4hLwi9vjBjhh0ARop4o1OqLrfTuAMuv
 UDI7wCh709DtCd7zAubWu4vExceKemVVrvYYNHLB3e2BWppI/QZXRdFpyAZpeyzTawzVOdvwJ
 Rg0+Xq9L17JTGMWgSIwSmmH8cPaZWgn1gx6IrXOY3f3cbFD6E5Os+Ik6lvvybbc/LnI+kgCsz
 DyKvBKcw2P78j9t5cdl390iSotwqvBQE8J32jVZ/V9Fk4xyx1ATUmPGvynSLGg4LpsW1s+PLg
 XePkcbHAdKQCOUUZ7quAx9LdB7BQtHGsVrspocbLdYi2fiEowmBmJBjCYkCCZ+uzfA73KGvVR
 Jv3U5fkDfHeFzaT8zI7kxyjm50JN3yAG67dMXn5APLak58M8iHMFbSzYPx9TJvzGv4cIbylGM
 7LYPwcIaMh62sHCvrc/nLhpO+bVSy+T/GBSRq7OLe7M3S+5ay5cLfX8bdY6bBbQ22PIZ0mStw
 YizzppTB9a2i9dcg/CIPn7vzdh8fLqcV1rU32LWflboMc=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Freitag, 24=2E M=C3=A4rz 2023 um 15:04 Uhr
> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> An: netdev@vger=2Ekernel=2Eorg
> Cc: "Frank Wunderlich" <frank-w@public-files=2Ede>, "Daniel Golle" <dani=
el@makrotopia=2Eorg>
> Betreff: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput regre=
ssion with direct 1G links
>
> Using the QDMA tx scheduler to throttle tx to line speed works fine for
> switch ports, but apparently caused a regression on non-switch ports=2E
>=20
> Based on a number of tests, it seems that this throttling can be safely
> dropped without re-introducing the issues on switch ports that the
> tx scheduling changes resolved=2E
>=20
> Link: https://lore=2Ekernel=2Eorg/netdev/trinity-92c3826f-c2c8-40af-8339=
-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
> Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue =
support for per-port queues")
> Reported-by: Frank Wunderlich <frank-w@public-files=2Ede>
> Reported-by: Daniel Golle <daniel@makrotopia=2Eorg>
> Tested-by: Daniel Golle <daniel@makrotopia=2Eorg>
> Signed-off-by: Felix Fietkau <nbd@nbd=2Ename>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec b/drivers/net=
/ethernet/mediatek/mtk_eth_soc=2Ec
> index a94aa08515af=2E=2E282f9435d5ff 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> @@ -763,8 +763,6 @@ static void mtk_mac_link_up(struct phylink_config *c=
onfig,
>  		break;
>  	}
> =20
> -	mtk_set_queue_speed(mac->hw, mac->id, speed);
> -
>  	/* Configure duplex */
>  	if (duplex =3D=3D DUPLEX_FULL)
>  		mcr |=3D MAC_MCR_FORCE_DPX;

thx for the fix, as daniel already checked it on mt7986/bpi-r3 i tested bp=
i-r2/mt7623

but unfortunately it does not fix issue on bpi-r2 where the gmac0/mt7530 p=
art is affected=2E

maybe it needs a special handling like you do for mt7621? maybe it is beca=
use the trgmii mode used on this path?

regards Frank
