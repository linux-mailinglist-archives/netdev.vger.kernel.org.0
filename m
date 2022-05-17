Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7452ACF3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353011AbiEQUp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351440AbiEQUpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B581EC5F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCB88B81C5F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 20:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109CC385B8;
        Tue, 17 May 2022 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652820351;
        bh=SJaS18QUgt40kTy7MdIsRpo1oyyLjVmAgoQEnVDWcMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MdLgP8vtCI+QV+br3An39BDOECXu84g+FYujUfwLgg39NVaKfKGuTbc+y/DyanVqi
         grTPOQWxfPfiz1YAvBQD5WZxE9oDnHcvqSf0G0clt28YKDWxbL3DxTpF0Cw0KGFRFn
         4wM0JyVAvHAOpn/I7GYsRKPTDBuEiXObWK5O1jfgXuSCnF8mGyJsC3soB9A19/N9/g
         uKKGq6zHZrpdP9DRZRnaOlTHX8XOJmBGnH87cAR/Xbhca3v/hQcjEwySAIaXijX8J7
         C7b4xA/8/XNhumVsY5FBr5YV5F3MkwyfQt/GjTBQSOHyKE+xaEe57EhyxgB0ysUp3Y
         kUY0bHOCrK14Q==
Date:   Tue, 17 May 2022 13:45:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Anders <sven.anders@anduras.de>
Cc:     netdev <netdev@vger.kernel.org>, intel-wired-lan@lists.osuosl.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: Bonding problem on Intel X710 hardware
Message-ID: <20220517134550.7c451a83@kernel.org>
In-Reply-To: <ad3e244d-2f87-c74b-1d40-c21e286a721c@anduras.de>
References: <700118d5-2007-3c13-af2d-3a2a6c7775bd@anduras.de>
        <ad3e244d-2f87-c74b-1d40-c21e286a721c@anduras.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: intel

On Tue, 17 May 2022 16:23:16 +0200 Sven Anders wrote:
> Hello!
>=20
> This is a follow up to my question. I did not hear anything so far, but I=
 tried
> to find some some information meanwhile.
>=20
> I've got a guess from somebody, that the error message "Error I40E_AQ_RC_=
EINVAL
> adding RX filters on PF, promiscuous mode forced on" maybe triggered, bec=
ause
> I'm hitting a limit here.
>=20
> Somebody other said, that this seems to be an error in the "bonding drive=
r", but
> I do not think so. Aside from that, there seem to be no special "bonding"=
 mailing
> list anymore. So I will have to ask this questions here anyway...
>=20
> I want to understand the problem to classify it.
>=20
> 1) Why is this "error" issued? Do I really hit a limit and what is this c=
urrent limit?
> 2) Is it really an error or is it more "a warning"?
> 3) Why is this error triggered only when changing the "ntuples filter" an=
d not during
>     the normal adding of VLANs?
>     Remark: I can trigger the "ntuples fiilter" later on again and it sti=
ll works.
>=20
> I also tried the latest 5.18-rc kernel with the same problem.
>=20
> Maybe somebody will find time and try to reproduce this?
> I will answer any questions...
>=20
> Regards
>   Sven
>=20
> Am 12.05.22 um 16:05 schrieb Sven Anders:
> > Hello!
> >=20
> > I'm having problems setting up a bond in adaptive load balancing
> > mode (balance-alb, mode 6) on an intel X710 network adapter using
> > the i40e driver connected to an Aruba 2530-48G switch.
> > The network card has 4 on board ports.
> > I'm using 2 ports for the bond with 36 VLANs on it.
> >=20
> > The setup is correct, because it works without problems, if
> > I use the same setup with 1GBit Intel hardware (using the
> > e1000e driver, version 3.2.6-k, firmware 5.10-2).
> >=20
> > Data packets are only received sporadically. If I run the same test
> > with only one slave port, it works without problems.
> >=20
> > I debugged it down to the reception of the packets by the
> > network hardware.
> >=20
> > If I remove the number of VLANs under 8, almost all packets are
> > received. The fewer VLANs the better the receive rate.
> >=20
> > I suspected the hardware offloading operations to be the cause, so I
> > tried to disable them. It resulted in the following:
> >=20
> >  =C2=A0If I turn of the "ntuple-filters" with
> >  =C2=A0=C2=A0 ethtool -K eth3 ntuple off
> >  =C2=A0=C2=A0 ethtool -K eth3 ntuple off
> >  =C2=A0it will work.
> >=20
> >  =C2=A0But if I do this I see the following errors in "dmesg":
> >  =C2=A0 i40e 0000:65:00.1: Error I40E_AQ_RC_EINVAL adding RX filters on=
 PF, promiscuous mode forced on
> >  =C2=A0 i40e 0000:65:00.2: Error I40E_AQ_RC_EINVAL adding RX filters on=
 PF, promiscuous mode forced on
> >=20
> > Disabling any any other offloading operations made no change.
> >=20
> > For me it seems, that the hardware filter is dropping packets because t=
hey
> > have the wrong values (mac-address ?).
> > Turning the "ntuple-filters" off, forces the network adapter to accept
> > all packets.
> >=20
> >=20
> > My questions:
> >=20
> > 1. Can anybody explain or confirm this?
> >=20
> > 2. Is the a correct method to force the adapter in promiscous mode?
> >=20
> > 3. Are the any special settings needed, if I use ALB bonding, which I m=
issed?
> >=20
> >=20
> > Some details:
> > -------------
> >=20
> > Linux kernel 5.15.35-core2 on x86_64.
> >=20
> >=20
> > This is the hardware:
> > ---------------------
> > 4 port Ethernet controller:
> >  =C2=A0Intel Corporation Ethernet Controller X710 for 10GBASE-T (rev 02)
> >  =C2=A08086:15ff (rev 02)
> >=20
> > with
> >=20
> >  =C2=A0driver: i40e
> >  =C2=A0version: 5.15.35-core2
> >  =C2=A0firmware-version: 8.60 0x8000bd80 1.3140.0
> >  =C2=A0bus-info: 0000:65:00.2
> >  =C2=A0supports-statistics: yes
> >  =C2=A0supports-test: yes
> >  =C2=A0supports-eeprom-access: yes
> >  =C2=A0supports-register-dump: yes
> >  =C2=A0supports-priv-flags: yes
> >=20
> >=20
> > This is current bonding configuration:
> > --------------------------------------
> > Ethernet Channel Bonding Driver: v5.15.35-core2
> >=20
> > Bonding Mode: adaptive load balancing
> > Primary Slave: None
> > Currently Active Slave: eth3
> > MII Status: up
> > MII Polling Interval (ms): 100
> > Up Delay (ms): 200
> > Down Delay (ms): 200
> > Peer Notification Delay (ms): 0
> >=20
> > Slave Interface: eth3
> > MII Status: up
> > Speed: 1000 Mbps
> > Duplex: full
> > Link Failure Count: 0
> > Permanent HW addr: 68:05:ca:f8:9c:42
> > Slave queue ID: 0
> >=20
> > Slave Interface: eth4
> > MII Status: up
> > Speed: 1000 Mbps
> > Duplex: full
> > Link Failure Count: 0
> > Permanent HW addr: 68:05:ca:f8:9c:41
> > Slave queue ID: 0
> >=20
> >=20
> > Regards
> >  =C2=A0Sven Anders
> >  =20
>=20
>=20
> Mit freundlichen Gr=C3=BC=C3=9Fen
>   Sven Anders
>=20

