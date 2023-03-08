Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953616B064B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjCHLq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCHLqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:46:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CB2B9BDB;
        Wed,  8 Mar 2023 03:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678275933; i=frank-w@public-files.de;
        bh=qEavMN1oNHIzuD8noKMIhhy5yWfLaY/kuANm9Ge6KwI=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=t1KogGT4MmYx30vi7OO4cMg5ghrLEDijOcIqpiHppwseqSAqal+mwJlAqAGESpYBB
         93L1GVDpYZMR01axjyhbuZV5RzxH5pt3xyLejd6TdPbiJCwyAeo/K1ykEI4GDpzenM
         GHvu9TQ/iVhXCWuU9K0aPJ4KMfjfituiDM2Bn8v9lG69LQ0VdQKfWBZomzXBPkKwnu
         wXSNHC6t9bDtnSIcwxUQwj1pwT2ISMVcZ8wkf3+2QgobbV5qy8GKSeO6pfI8UAfo2m
         xVVqGQ47Vy08jVSbc81dbFKwlw/iLu0CdkS1HwybrTXv+Bt1XpA/4t8ZOMBEsUlkdj
         KeZfZuzhzJFGA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([80.245.79.148]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MLzFx-1prg4K0sE5-00HzeR; Wed, 08
 Mar 2023 12:45:33 +0100
Date:   Wed, 08 Mar 2023 12:44:57 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>
CC:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_v12_09/18=5D_net=3A_ethernet=3A_m?= =?US-ASCII?Q?tk=5Feth=5Fsoc=3A_Fix_link_status_for_none-SGMII_modes?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <ZAhzt5eIZiJUyVm7@shell.armlinux.org.uk>
References: <cover.1678201958.git.daniel@makrotopia.org> <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org> <ZAhzt5eIZiJUyVm7@shell.armlinux.org.uk>
Message-ID: <B69026D7-E770-4168-B1CA-54E34D52C961@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:U0PP32xta1RnFR2flRmcenHYZpYoj2Ef4IAW6ruNMl10pX7i6w4
 A9yAcQ8VNRT6NZUG6Sc7Po5hzbBIItxfLe4Iag/EqYpmLi6/C6ZTSpa9jiwCoNvyOxTEr1b
 EXbFqzSXnz2iUcTNHmZowsxn7gWIMy3JJHEws1wO+wKAmArVusQapJFqbHaHe1RUwURbibB
 mCp8O6NrjhklOfBgj5EYQ==
UI-OutboundReport: notjunk:1;M01:P0:S4xCqvkT+XQ=;5qo8wFaspq4RNU/Odi3ftREhRlO
 s5slcf7rPRArkT7DkDOi27wcNLSc2JZS5l3Nee09r9ccaivKfMfl3WpOFSKF2R5g2zO8aTG36
 Q04x8FsDvR5ybFqwYvxrCEXjNt4Hw7KG+cxPeLwFs9XpJluN17EuR7R+IPXKpjka645fUHNH5
 rpd/Kk09gO8Pu4JwBt8bJ5vbjneQ1rJxnAQloskEUIYPl2q3B3Hfl8ARmusWpI3sWETR+NX+4
 4Lg/41FAaKcNv9+HRa1NjjgzSW3NQl72rdapFjeybAY8YmZSIEHa7KQKYG+x0jkbpfRjWDIi1
 lHePhwzbBoDvWRvhOXCGE9hBNKXZ6tsOEWh4eYGrJrMp8gUJXZYav2faGWiuEVPiINffQjp/1
 W5toW5pIIY0c8XIMufkXNUCNJSS/ME/6n6dSSDS6CB6FdQFu6tNdBRRfkNUaiqJa+KSkzloB5
 jlQCyxhKw1DAGTEYOqg+L06PF/Gepew07g+XbLY9ZUl5nA+owA3wq6N05Vvz1WbZ2zEwchzFS
 xVYMRIadoqzcPbgXmBcDSsqWxGBxdkLiOrwE2fX9wJsQuUJrU9ZnDzZ2YS+kv4Fo35d+T0aMx
 LlIn5ewx7FHLyVRgisXlWET4XXEVPJZ/pjK7pXw6FhWp7D0uIkI0d8i8IyJ0H0jdxNhZHtR95
 5RUOwwS+Bi2KRjIp/liYU+vlT0BgFE3piI8/jW+xkliHlHK/wrzVIvLXmDDOtQy0SYa2muE6W
 BAknH01lDSYCp2zdnmA6PzN5yT8DHTS88qEIqmNJtC2ou1fMZkQRcaZfRs508SbwVi0qLGruA
 kJMIrA9AZjynzxxFQDZM4ALENa/nUTC7XJvJw3MwL/9daWEoc0C6Bgek0phmqSzIB++K36DNy
 GMJPIYZPhqMIc44ZbBPDDHyVCN0z+0IhHjrqM101lgreG+rFu1tUl4IS/EnPB6NrNLH2IK2DV
 HrncH2mNFX6+A3XXATKfxm3Wl5s=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 8=2E M=C3=A4rz 2023 12:38:31 MEZ schrieb "Russell King (Oracle)" <linux@=
armlinux=2Eorg=2Euk>:
>On Tue, Mar 07, 2023 at 03:54:11PM +0000, Daniel Golle wrote:
>> Link partner advertised link modes are not reported by the SerDes
>> hardware if not operating in SGMII mode=2E Hence we cannot use
>> phylink_mii_c22_pcs_decode_state() in this case=2E
>> Implement reporting link and an_complete only and use speed according t=
o
>> the interface mode=2E
>>=20
>> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pc=
s")
>> Signed-off-by: Daniel Golle <daniel@makrotopia=2Eorg>
>
>This has been proven to work by Frank Wunderlich last October, so by
>making this change, you will be regressing his setup=2E

Hi

My tests were done with 1 kind of 1g fibre sfp as i only have these atm=2E=
=2E=2Ehave ordered some 2g5 rj54 ones,but don't have them yet=2E I'm not su=
re if they are working with/without sgmii (1000base-X) and if they have bui=
ltin phy=2E

Daniel have a lot more of different SFPs and some (especially 2g5) were no=
t working after our pcs change=2E

>What are you testing against? Have you proven independently that the
>link partner is indeed sending a valid advertisement for the LPA
>register to be filled in?
>


regards Frank
