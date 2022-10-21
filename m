Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0218D606FD2
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJUGFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiJUGFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:05:39 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B701A0444;
        Thu, 20 Oct 2022 23:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666332300;
        bh=XcKCqy9WT0HZU+yGc89UpnlSmGCGlPa9TVxnjEkCmbs=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=IIAptyNrk5ip/23Pap1EkWy7Djnd4uKJ5axDJ/QSVnP9t6esIaJBBSv9KdUoFOyWv
         LPNSlsUbBqGlo42TvWZMjNW62U1A2enJzMWvW0ZPIeYl5x2o/K+12ALHunP1UuDuDV
         lTBRtPEu7TU4R58bLR7AGwFESU0FHOfTxAcaJ4/I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [127.0.0.1] ([217.61.146.132]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M9Fjb-1oiA7X2mIB-006O7z; Fri, 21
 Oct 2022 08:05:00 +0200
Date:   Fri, 21 Oct 2022 08:04:51 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Frank Wunderlich <linux@fw-web.de>
CC:     linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de> <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
Message-ID: <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:T0xeOlwWh+mj7CEVR5iha6HOYXAeiLwNgtwZuW5tfseTPyJVnow
 GV12rB5Z7Gqzk4O4+QSM50R55FX0xEos8jDSOVx7p8bZMP7lN6VctuiyK9OHcZ+uEFsgQv4
 JmPyLp3jiGosxAujzutswr5HylZYkhCoKZiWednBXfVzEw2fOqJUw2npQUORevq0ZHGKkr9
 /CW12oH2hbgX05Otva25Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jngH6wwMaIk=:Lbh6chv5Fo/u3adZRcy8WY
 UROP3LiJwPScWNqtO1rXkSwcYkO1jIvsrsDDgNw/nt5hAuHoHp80XTPdd8todANvmQbo9c5qQ
 uYi0iYeEkg436tCdoWQnU4IYLPHGVNW8dxQyyZPBm7339abBVmdTW0kcJWuXNp+fECebeiA69
 gMyHGriGupxS/S/f8Ji+bzLr7GZilATTR4pifgEJYxa7zwq9838O54IL3x3xdTm7FIbSJ24g7
 ad5IPsACPbocj3P0IN7xSjQNyVTGF3LTBWtcGhEvxZDdpyTHCrYsMhptt68l7XlphCrzNulmY
 eK/gudWKVspn51337DOPk33FixZg2Hp90zCepk6qMNoN7j4n1iB4yJlwwaduuO0UtGZqqtGDn
 yKZS2v3e/5a6YNXL7XsO/k30Efr+tULO7d74jbiRpkXPJid5YtnL1egFL/+Vmqi5ia6fGsUZa
 S7hfwfEYOyuJ+VhnT+VW7MLjoIMEdpAjIj8jNXIjhZLQ3nNFXSmVuZGbQ6Ht3E7hVkc9wFEUc
 hmIrQnSgV/ERuC2STMzykK8QSc7Nq4SftpVx1vaaoFgBM0f6rLOtA/g5UjdOt0jsCDdwaDKaG
 f9Rbs5ApnovfNJ2PpjlEOSfc5otcTGpPkUMze0D+xf85BL4S9K9SXStrwz5YTb9FVdfxG/mWq
 MioYe07Pdq/9zDsIuijDa7ixTqc3cN//7BmP3htkqGFu9/M2WW61E+4+m1Nxk5UC/SbkhrGUs
 b4GiMSux3EWzApRepcEh1lojYbghJA4HqoBFHnnxoMXYlMNfao8/hz34Zx97JhzHI8YSnj2GM
 6wD/xeCSZ8NW74byHkgvxG24xQRUdDaArwh6rQWVJUAS6l9Dj0thzIrkARs4jYYWln+DjBknm
 LrwksjMJhx9rnBJ/NtMzpYOWo14Aqn28nEULVTzUZ+VekU3xFj6/s5amcZ3Il5CKQikG4Jp3Z
 e7QL98ygI5hA73hoY41KZhsYMgNbnySy8JcIT2lYeUnHykc51MSAWyqb7FvmOdxqacRqIOuSH
 f+QjZyqsE0of3/u0nOnNhsBfEyd6dPol8Bk1aENbg008hAMHzWsaJrRsABfB9NLNvtGEc1kuJ
 x/ObPH0UV26ZJy5HBWd4CGpW9Cuxz1VudUcSKxuiRmfEOyiZcJo/WDn46qByQd2g/X4dQKWe9
 jlhtXzcbJAjjVRAz9OvVH7Jh9BCpRYIMZaQst8cC7lT1FrdjJrQ40AtUnxfFvYKdChtLgc1fF
 DNlh7cepMA9QwJTCer4XRs12lLMcW+lJNh+ljqgCnDYheC8+xrgK2fWVHmbHLcTIbZicZr3a5
 OoQc+Qt2xmBkbVzh+S3+oLBuNlxrfqR5BxDa7w6kacrUPSLxH7bwT7sBmvk/iR4Ixq9OBkzQa
 tjvXGATGtlZmdzDGhjZhxXlXd12B4KoNiN4ROGo10uXnij0jghf93ktmCu37a9/NZn+WodaDO
 s64iZQtIZ0Q8IE42Qhj7QJdS7wr3ExhEWrate7mjuJN5vVETIRCkmpGNG8Rd6J5AUGd5wrmU2
 /iJfb3+hMH+cKLDaZzi2j3udXCAYV86+nhm5bT5L61Erm
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 20=2E Oktober 2022 18:17:41 MESZ schrieb "Russell King (Oracle)" <linux@=
armlinux=2Eorg=2Euk>:
>On Thu, Oct 20, 2022 at 04:44:31PM +0200, Frank Wunderlich wrote:
>> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii=2Ec b/drivers/net/=
ethernet/mediatek/mtk_sgmii=2Ec
>> index 736839c84130=2E=2E8b7465057e57 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_sgmii=2Ec
>> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii=2Ec
>> @@ -122,7 +122,21 @@ static void mtk_pcs_link_up(struct phylink_pcs *pc=
s, unsigned int mode,
>>  	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
>>  }
>> =20
>> +static void mtk_pcs_get_state(struct phylink_pcs *pcs, struct phylink_=
link_state *state)
>> +{
>> +	struct mtk_pcs *mpcs =3D pcs_to_mtk_pcs(pcs);
>> +	unsigned int val;
>> +
>> +	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
>> +	state->speed =3D val & RG_PHY_SPEED_3_125G ? SPEED_2500 : SPEED_1000;
>> +
>
>Sorry, looking back at my initial comment on the first revision of this
>patch, I see my second point was confused=2E It should have read:
>
>"2) There should also be a setting for state->duplex=2E"
>
>IOW, "duplex" instead of "pause"=2E
>
>Also, is there no way to read the link partner advertisement?

Hi,

On my board (bpi-r3) we have no autoneg on the gmacs=2E We have a switch (=
mt7531) with fixed-link on the first and a sfp-cage on the other=2E Second =
mac gets speed-setting (1000base-X or 2500base-X) from sfp eeprom, but no a=
dvertisement from the "other end"=2E Imho it is always full duplex=2E

I have no register documentation to check if there is any way to read out =
pause/duplex setting=2E Maybe MTK can answer this or extend function later=
=2E

regards Frank
