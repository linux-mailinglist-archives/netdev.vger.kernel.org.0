Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C04C6B6600
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 13:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCLMlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 08:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjCLMlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 08:41:20 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B10D334;
        Sun, 12 Mar 2023 05:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678624836; i=frank-w@public-files.de;
        bh=hVChMFKQ6lB5/z/TrSDQ5p1NSBPKD262NX0BY/G2Cus=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Oo18yfYrKTjKwfDTISEv4CKAd0TtOaDHoKztgD1bNxCxXrlnNN4903B22bTsuOkR+
         3dEGKqQdTQAvcttf61j+M1ZBohJUFb1fDRTMT2VdGXhYGeYsy5kO8BxqHDsHRefwtb
         cyzEmvUgCbWpMut48mzH/s3MYZuGPmeO85cMiTA0BzpRGkhajscveGtPS605hlgUH+
         4syUw5kOe72fd+OiktMlPh0+Y9+He4QnKwlYoEkYKmMxPOJsaGtUp3iIL6E5tBJDkn
         46BYs0OTdabndbtR3YK8frZcjxVzl91nbuLmZG7ZI8CyHHMWiK/ySPB98ZupwwPF3Y
         fQie0jjqwb5PQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.155.253] ([217.61.155.253]) by web-mail.gmx.net
 (3c-app-gmx-bap51.server.lan [172.19.172.121]) (via HTTP); Sun, 12 Mar 2023
 13:40:36 +0100
MIME-Version: 1.0
Message-ID: <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: Re: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc:
 fix 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 12 Mar 2023 13:40:36 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
References: <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk> <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk> <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:j8aCWx7ku1BbmENiznwo/rnj/g8jVQsl9/TIPLE4WZIfK88w34SgWiO9hQWbk71SenFDu
 OT7wdVqEta2xmiM4iQKeZFFlIKfkM3UThkgWdZDl72J66eJS1CPdxYnC564O4T+tnfpG/QnIBrV4
 lc+HzDIXJ6d28BL3rsbn1ggpPfWozFala+3YUsTWbMkOJq+8VNKK9R/bHyMhbjf3tFJzAk/WJSvt
 45H7GQQABhc8Lrumjj9a2o3VbHkRyt6Udts9SE1ZT56Gfjrm4U0wTOIwBOrQArPNZorPkhkWuU/a
 Dk=
UI-OutboundReport: notjunk:1;M01:P0:YX/pNfqJpqw=;qPfn+TLD1E6jG5QmoSDe+tZzJbj
 U6OMqztbWyI5kIaPeFqXZpWVQjtZWOY21CBUYeaTg69Ng8jHbVOl59WDDsqEd0Um7skz9oEQr
 A3GaQM9mKc0yybNq/LSUCAwvMBlSwv5CPwxBGPep6ArKVMiiaLFDCJ1vPkaiyJhGePLyIgsb5
 1CmIWDzdnZIDUJGVW98QpdRMNZxw7M6LbYyX37+LWvI/gHuWzL8qKg1L0YDiMhIL7Dt9XCM0a
 HwXhdNDbSdlleqslG/De23d8+h57hICqWRnTLTGlXeCY09bufym2+ZmNMmugvGQW6eyfGSE85
 eKdsoVUvBGNWcYLPaskg4UsVAAhjtdh/3O7g8peP111wc8/QOFdChZxQKbkiwJUxNjEh484DK
 PXh+TCwQrOkPwHdy4cXe8Ortn48yMumXJJNEtyTzDh3H33Mn2PVI+sP6AxIitTkK7FDQcWT+L
 FGV9OGwY6mHyMsxytCwzZBv2yLyadtpzx+QIgop1uEIAOXDnLFm7dL/08AL4sYPE8HIq1a7iA
 lKdB1F/m3f6pX8XHJmHOZW535qkIxbLCpuMVh6MPdbR7HjUULsd77fS1B3Jea0V5j7UOJB4QX
 SfbwJmC1eKBLAo8jOoA+TDT20bTiCFFV9tE8twcFkd/yA3oWu+tco5C8aCiMSDmFM0rEF7AH1
 XXL1qBg9R0mEBJVu09gWPyOI98lIRZPlF4oJoKJntbDjvYoSPY7SISnwlN5uN7sEzSCKqvJxa
 kZWRBAsHjPHmCVJVmNZV2F+351A6CDXtWT+XFlwqetmfcvsYP6rwLySVSHTEDWqJPm3K8APBm
 NQ9UiZoS65kgiP822rnKK7PA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 11=2E M=C3=A4rz 2023 um 21:30 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>

> On Sat, Mar 11, 2023 at 09:21:47PM +0100, Frank Wunderlich wrote:
> > Am 11=2E M=C3=A4rz 2023 21:00:20 MEZ schrieb "Russell King (Oracle)" <=
linux@armlinux=2Eorg=2Euk>:
> > >On Sat, Mar 11, 2023 at 01:05:37PM +0100, Frank Wunderlich wrote:
> >=20
> > >> i got the 2=2E5G copper sfps, and tried them=2E=2E=2Ethey work well=
 with the v12 (including this patch), but not in v13=2E=2E=2E=20
> >=20
> > >> how can we add a quirk to support this?
> > >
> > >Why does it need a quirk?
> >=20
> > To disable the inband-mode for this 2=2E5g copper
> > sfp=2E But have not found a way to set a flag which i
> > can grab in phylink=2E
>=20
> We could make sfp_parse_support() set Autoneg, Pause, and Asym_Pause
> in "modes" at the top of that function, and then use the SFP modes
> quirk to clear the Autoneg bit for this SFP=2E Would that work for you?

i already tried this (without moving the autoneg/pause to sfp_parse_suppor=
t):

static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
				unsigned long *modes,
				unsigned long *interfaces)
{
	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
}

quirk was executed, but no change (no link on 2g5 sfp)=2E

i guess you mean moving code handling the dt-property for inband-mode in p=
hylink_parse_mode (phylink=2Ec) to the sfp-function (drivers/net/phy/sfp-bu=
s=2Ec)

as a first test i tried to disable autoneg for the inband-setting

@@ -840,11 +842,18 @@ static int phylink_parse_mode(struct phylink *pl, st=
ruct fwnode_handle *fwnode)
=20
                linkmode_zero(pl->supported);
                phylink_set(pl->supported, MII);
-               phylink_set(pl->supported, Autoneg);
+               //phylink_set(pl->supported, Autoneg);
                phylink_set(pl->supported, Asym_Pause);
                phylink_set(pl->supported, Pause);
                pl->link_config=2Ean_enabled =3D true;
-               pl->cfg_link_an_mode =3D MLO_AN_INBAND;
+               //pl->cfg_link_an_mode =3D MLO_AN_INBAND;
+
+               //how to access sfp->inband_disable?
+               printk(KERN_ALERT "DEBUG: Passed %s:%d %d=3D=3D%d (inband)=
??",__FUNCTION__,__LINE__, pl->cfg_link_an_mode, MLO_AN_INBAND);
+               //pl->cfg_link_an_mode =3D MLO_AN_PHY;
+               pl->link_config=2Ean_enabled =3D false;
+               //phylink_clear(pl->supported, Autoneg);
+               printk(KERN_ALERT "DEBUG: Passed %s:%d %d=3D=3D%d (inband)=
?? (forced phy-mode)",__FUNCTION__,__LINE__, pl->cfg_link_an_mode, MLO_AN_I=
NBAND);
=20
                switch (pl->link_config=2Einterface) {
                case PHY_INTERFACE_MODE_SGMII:
@@ -947,7 +956,7 @@ static int phylink_parse_mode(struct phylink *pl, stru=
ct fwnode_handle *fwnode)
                }
=20
                /* Check if MAC/PCS also supports Autoneg=2E */
-               pl->link_config=2Ean_enabled =3D phylink_test(pl->supporte=
d, Autoneg);
+               //pl->link_config=2Ean_enabled =3D phylink_test(pl->suppor=
ted, Autoneg);
        }
=20
        return 0;

but it seems this is not enough (or i miss something) and i get error when=
 i try to set mac up

root@bpi-r3:~# ip link set eth1 up
[   30=2E044144] mtk_soc_eth 15100000=2Eethernet eth1: mtk_open: could not=
 attach PHY: -19
RTNETLINK answers: No such device

regards Frank
