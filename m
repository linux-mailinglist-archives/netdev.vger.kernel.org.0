Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FF95EFD09
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiI2S2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiI2S1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1501438C8;
        Thu, 29 Sep 2022 11:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DEB3B82646;
        Thu, 29 Sep 2022 18:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D73EC433C1;
        Thu, 29 Sep 2022 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664476067;
        bh=peXm6EYz/EMFFA8zuW/FKucf85TPZxTNbaodSHoZ7Wg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kv7xhea2uFIbwtuFQLZh9XSjU1NQfjbcVqi7NBdfo1YmhLPr/oFL/8Xy7h8nVd63Y
         1QbyuerlojcUMR9UJXqyqMMe/stYLXuAEzjAn5YgYL+gSYYe2Mgq5Jy1q1QOi5phs9
         LUXrQ/s2M+7o3FfgPVpda31wV2wVBaOYzo8yfTohR2fDzhGsJx5Pf63zWtPQKojM9F
         jn5yUhRAxSZA/Yu9rBhiUcBtbQl8G7FuabZv9yLUhOJjlvUZ798HikAJYp4pUIjm//
         HnqLKE0lE+TxmEdaYgq6OQOzGouYBxg3CmBkmarKcPIbw5qPRqYRZam7X/YTCqQye3
         IoYyggPAxMHZw==
Date:   Thu, 29 Sep 2022 11:27:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/9] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <20220929112744.27cc969b@kernel.org>
In-Reply-To: <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
        <20220929091036.3812327f@kernel.org>
        <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 18:37:09 +0200 netdev@kapio-technology.com wrote:
> On 2022-09-29 18:10, Jakub Kicinski wrote:
> > On Wed, 28 Sep 2022 17:02:47 +0200 Hans Schultz wrote: =20
> >> From: "Hans J. Schultz" <netdev@kapio-technology.com>
> >>=20
> >> This patch set extends the locked port feature for devices
> >> that are behind a locked port, but do not have the ability to
> >> authorize themselves as a supplicant using IEEE 802.1X.
> >> Such devices can be printers, meters or anything related to
> >> fixed installations. Instead of 802.1X authorization, devices
> >> can get access based on their MAC addresses being whitelisted. =20
> >=20
> > Try a allmodconfig build on latest net-next, seems broken. =20
>=20
> I have all different switch drivers enabled and I see no compile=20
> warnings or errors.=20

Just do what I told you - rebase on net-next, allmodconfig.

> I guess I will get a robot update if that is the=20
> case but please be specific as to what does not build.

The maintainers simply don't have time to hold everyone by the hand.
Sometimes I wish it was still okay to yell at people who post code
which does not build. Oh well.

../drivers/net/dsa/qca/qca8k-common.c:810:5: error: conflicting types for =
=E2=80=98qca8k_port_fdb_del=E2=80=99
 int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
     ^~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/dsa/qca/qca8k-common.c:13:
../drivers/net/dsa/qca/qca8k.h:483:5: note: previous declaration of =E2=80=
=98qca8k_port_fdb_del=E2=80=99 was here
 int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
     ^~~~~~~~~~~~~~~~~~
../drivers/net/dsa/qca/qca8k-common.c: In function =E2=80=98qca8k_port_fdb_=
del=E2=80=99:
../drivers/net/dsa/qca/qca8k-common.c:818:6: error: =E2=80=98fdb_flags=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98tsq_f=
lags=E2=80=99?
  if (fdb_flags)
      ^~~~~~~~~
      tsq_flags
../drivers/net/dsa/qca/qca8k-common.c:818:6: note: each undeclared identifi=
er is reported only once for each function it appears in
make[5]: *** [../scripts/Makefile.build:249: drivers/net/dsa/qca/qca8k-comm=
on.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:465: drivers/net/dsa/qca] Error 2
make[4]: *** Waiting for unfinished jobs....
../drivers/net/dsa/sja1105/sja1105_main.c: In function =E2=80=98sja1105_fas=
t_age=E2=80=99:
../drivers/net/dsa/sja1105/sja1105_main.c:1941:61: error: incompatible type=
 for argument 5 of =E2=80=98sja1105_fdb_del=E2=80=99
   rc =3D sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
                                                             ^~
../drivers/net/dsa/sja1105/sja1105_main.c:1831:11: note: expected =E2=80=98=
u16=E2=80=99 {aka =E2=80=98short unsigned int=E2=80=99} but argument is of =
type =E2=80=98struct dsa_db=E2=80=99
       u16 fdb_flags, struct dsa_db db)
       ~~~~^~~~~~~~~
../drivers/net/dsa/sja1105/sja1105_main.c:1941:8: error: too few arguments =
to function =E2=80=98sja1105_fdb_del=E2=80=99
   rc =3D sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
        ^~~~~~~~~~~~~~~
../drivers/net/dsa/sja1105/sja1105_main.c:1829:12: note: declared here
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
            ^~~~~~~~~~~~~~~
../drivers/net/dsa/sja1105/sja1105_main.c: In function =E2=80=98sja1105_mdb=
_del=E2=80=99:
../drivers/net/dsa/sja1105/sja1105_main.c:1962:56: error: incompatible type=
 for argument 5 of =E2=80=98sja1105_fdb_del=E2=80=99
  return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, db);
                                                        ^~
../drivers/net/dsa/sja1105/sja1105_main.c:1831:11: note: expected =E2=80=98=
u16=E2=80=99 {aka =E2=80=98short unsigned int=E2=80=99} but argument is of =
type =E2=80=98struct dsa_db=E2=80=99
       u16 fdb_flags, struct dsa_db db)
       ~~~~^~~~~~~~~
../drivers/net/dsa/sja1105/sja1105_main.c:1962:9: error: too few arguments =
to function =E2=80=98sja1105_fdb_del=E2=80=99
  return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, db);
         ^~~~~~~~~~~~~~~
../drivers/net/dsa/sja1105/sja1105_main.c:1829:12: note: declared here
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
            ^~~~~~~~~~~~~~~
../drivers/net/dsa/sja1105/sja1105_main.c:1963:1: error: control reaches en=
d of non-void function [-Werror=3Dreturn-type]
 }
 ^
cc1: some warnings being treated as errors
make[5]: *** [../scripts/Makefile.build:249: drivers/net/dsa/sja1105/sja110=
5_main.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:465: drivers/net/dsa/sja1105] Error=
 2
make[3]: *** [../scripts/Makefile.build:465: drivers/net/dsa] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [../scripts/Makefile.build:465: drivers/net] Error 2
make[1]: *** [/home/kicinski/linux/Makefile:1852: drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:222: __sub-make] Error 2
