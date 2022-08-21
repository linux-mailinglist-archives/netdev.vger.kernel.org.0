Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C91259B660
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 22:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiHUU6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 16:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiHUU6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 16:58:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F942AD2
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 13:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661115498; x=1692651498;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LDbBKfgesfG6E691+yIYohNOaXD7a7G1fvZGwCjrbvU=;
  b=PzAfSm+VrXhoeNXj7Q5T0J3dD8ugTmcXb+EkEIqrp8b/nVYcxeJKjR8t
   WE4p2yz/43X+cHTwheDPkZY3C0S5g0sGOExyj307mx86iRlRAhWm24pMC
   jEusxnxEERE2JpL3qw5CuGNOZ5EA+fjPc6A6rlaykPMASpV9i9hp+DYGj
   t3YKoPv5wnccKMDHUIaKkg33EJABJrUsXFyBzV5GmDF9HU35gKi0uiHCP
   nM2269f+tiepN20UIK6fl66z12cbzMzSYq/filoJRwKAupxZ80aAkecSN
   YWFMuIiah5bd5bFBjAol5ZFC13+ZI9YpUuCVqgkwLhKzTfPJRd3hMIXcU
   g==;
X-IronPort-AV: E=Sophos;i="5.93,253,1654585200"; 
   d="scan'208";a="173428128"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Aug 2022 13:58:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 21 Aug 2022 13:58:16 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 21 Aug 2022 13:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I86g1P5+Gpl/2RRLxWKT5CnpOo/Re56Rz6RaMqOZbglmLBJU7M5cZF1IJSooy7rrTexjBAu9TooCIgrpTZje+xLoOrZ2S79CtymrgOEEx9/gf0tk7+nNjRNN/zosdW6pHemOXSa4YsK8m4h7+m+774yonIrGGGlImbkRAUc0BEwYGb9gGEPUWKMEl2aUqfFAruB/brRLMUqTEM5KYk5cWI9HyKvXpPopiXJ9verTOTKbW3gYrEIjuOl9R20aEOYgA+ib+zYe+rapMLcQhlqF6etWbArcjgOzdqktbcEpvAOOYGGqignlCxV03UzIHUpvJ/U5VNDpF+Ww6Q/dH+pU/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrVwrfj92KJfr75Dk0XE3zMsTolZGzG6kP52RHxtDYQ=;
 b=aOzCvDo5Ui5aKdTtJEBPD6NDJyuSqvXDYlSry9ROzGnfSSCqny14KNWn7kwEGB1Lz/xXLF3GnGZSlbS+maHobsUaZWfRrL764i7jdWNIWI/0SwltGeB59ilwKmnKJGL542HbqwL2ZOst7iObsv7H9fZdDCNBS3LPUcb55TAOH6O5uFuPbsVJnOw83AmNPgocKIqGDXbT1UywHbZfd7I6TC7ibi5aHe+N3/ywBy7kMoeMlZqdFhLrSry4Q3mOstUs9Uhz+L+jLsSUn4nvQ8bB+pGLqMONek/srNkK5fIDPirr1QUEsNM9KpV0Oxv7BaS+oFXIa1A8zMHW7HoWRGCVxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrVwrfj92KJfr75Dk0XE3zMsTolZGzG6kP52RHxtDYQ=;
 b=XG/Q+5uV6GgZy78LJLVrN2XwicDuWdaUoU0R4TENit3oM7T7LveefNaSgAZg70K9SpWyaX9lNtUuDkzktZJbb+09GWiDyBnLnmk63KYKP1fvnArXCCwZqwvHPH/1cAml8NRDjG50UGJZMqlG7aNdPHde60jWmC7WmAs7kx1Fi1o=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MN0PR11MB5962.namprd11.prod.outlook.com (2603:10b6:208:371::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 20:58:05 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::2941:a64d:5b83:8814%3]) with mapi id 15.20.5546.022; Sun, 21 Aug 2022
 20:58:05 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYA=
Date:   Sun, 21 Aug 2022 20:58:05 +0000
Message-ID: <YwKeVQWtVM9WC9Za@DEN-LT-70577>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
In-Reply-To: <874jy8mo0n.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30596edc-2a4c-4a83-b085-08da83b7d7f2
x-ms-traffictypediagnostic: MN0PR11MB5962:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tNysv70Pu6hc2ZZ3SgW1xwaQoUkgv1EUjDAr8XAU2nJj4R7AAiYe4a3w6W0FmzRFDSK8PGVdKwOzxoa5pUot3Cjq0mmZ+OOAX8GJkUPg7HB54XQ/nllnK4YkZkm3RsPTtR158CyfSr+ymK35ERdMrSIg42FDhRp9EHOko70dDpnHaVZeAu5rf9EUS7A55ViAOWyJoNeSJM2oKlCONz+XJhzcCAULyHWphEU+VuXYNorJOU0fxxIhZCKzLWcoIKr1cDvtoNb/8vbpDNktd1Nx6QzxTuS+MA/R76OA93AphK/wqlFEj6eKWAOES8EN1S/mEcfuYApklI9jbSSYgwEWAf9HVv/57CjjV0WTRweHu2CXFVHGkjxEtpBgiEBEm35DFxtVJSW/yO9VPXW9RjFNUitc274yv71PS4GLud39l1ccULbzUQPyugEgbh6946vHEM2+y/ZE66jyaKSwBaqS2zFBZa8y5jrJq3vZYULvaYiVQFarhTzlCVoE8oB14sQf+WVcoyJpuh06JHVWAzaGiAtf6MjBbr+0IQFAVoEyS+UOi4z4W/2u9Wc3JYytPOaI1SlfIVI9FY+/PNEmuW7+jqQfjE0ah5YK8cX8wLS3Fe5jXTdFsrNNQwydMhOpA4bxWhVOEyyaTKnVrB+sjfh/zA272ppCURunNuYW4r8pwchL/Lz2Cr01DlEp9eW+TNflSVw2pQvEkUYHAKDPLNb/DDmu545d7bMJEo5g+wUCdSMot++3ZrFUx2afsEzReg4dsdg1SmihD5y+NLjMVCr/r00+ZjQc2qyZsEgtq9VJ7mA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(396003)(136003)(39860400002)(366004)(376002)(66556008)(64756008)(4326008)(8936002)(66446008)(66946007)(2906002)(186003)(41300700001)(316002)(5660300002)(86362001)(91956017)(6916009)(66476007)(8676002)(54906003)(76116006)(33716001)(966005)(6486002)(26005)(478600001)(38070700005)(71200400001)(83380400001)(6512007)(6506007)(38100700002)(9686003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xBJ5NunvMTT0JDP27Zpw2TR8pjkB2VFkNHoe2xKu6ZWev5RpCub1V6hvH6db?=
 =?us-ascii?Q?QEIumUdY33yFOlluOqJBcmtz/czdmWWWpLbFvmvYK/MvwvXuuL9GfzzBWXam?=
 =?us-ascii?Q?tuhDdlcgnc0TfRXBilB+mGG8QBzrR86v/2HL1Ca1hT99OjZ/h+C5y90GQCj3?=
 =?us-ascii?Q?5QCiAGn9MW9XyRuqBREAUwPYsOSOge+ichmn3481K+5EDwOK8Z7pOF+nWZGo?=
 =?us-ascii?Q?fTMJs8viWIVUYJTKQ/1ewiDdDRf/o7pbvAXzOFPuBevn7jhnbH2Xm47Or7Xe?=
 =?us-ascii?Q?j/PsT6HpnDPO/jbLzG8BMkx3KVgqGWES8gn5SbJC6kzHWSnAlGUo718odSCL?=
 =?us-ascii?Q?AnwjMn6QIdav1UoqoxYpr8aUjloU64a0CjQTr27JhsUbvtqD1FCH6ZyHq33C?=
 =?us-ascii?Q?Du+51wA9oW7qBrNxWXqCpyv1qnPCE9Rhf+fBryLs/7A9Bz7TM1evCwbhypBQ?=
 =?us-ascii?Q?sRQVEyrWaQQNbkJ8G2osaTyXhGhMigdb8HxQ0jLilrjo06UCU4eQb3AJz5wF?=
 =?us-ascii?Q?v6ISOcBQ7eQAttvaJJHWRC9S15O0wjgz3FgHubDsrLjP4hT7s+NX2Qt4OJd2?=
 =?us-ascii?Q?GCKWjmyaImNjsLW2nwctbFpxT/2OnAUWGYmeKKzMnX4Ns1o8WPSM/IAtFkVW?=
 =?us-ascii?Q?S5CWj9BTyB4FQg2XkMIHW7V4vIEZvA6j3Vo5x3ptL+IDQfLig4n/oxCsln/J?=
 =?us-ascii?Q?FhRkI9F5JtewEmuSeh7tdptEQw3IuNMMspW2MFNEEOcS4p1ABOK9rwlXwBjR?=
 =?us-ascii?Q?xNTkfN052Xtc1p9eRi/AzuTrbJ4eEJFld6gPONsYinr/9uZif4L/5Fdr6/W6?=
 =?us-ascii?Q?vbFJ80cBOeehqWDjooC9R5XOlp3+yLOR7PGdR8gAsrqbBxSJVQqI9qkSCoSq?=
 =?us-ascii?Q?iHGTHpO4nxO164483b4JCYEb8xVIsvrVe8lRx1ea4dU5NcIxbK1B6aeuTRCD?=
 =?us-ascii?Q?s6IZbv4vZucIaAsGFzcqdARC4gREN6xayAhsJgMV7CfSNRyLCqZJcLvm7vlk?=
 =?us-ascii?Q?kKAuhMMeek8RAxKE+hYKBuP1DQ83bik8HOKgRv83hyN3tZGynZwhaDJ6T1hK?=
 =?us-ascii?Q?+pxoPIDy/JVHtLWL33k9nAqmoAX31/+6lFXSV6dS9lRKzERA3AgkAunC+ZXU?=
 =?us-ascii?Q?W8oVsLIqTq419BRfHiMBXhTqnaCnkQV68Z/zJfLZSP3fuWyJgrsJckARMt3h?=
 =?us-ascii?Q?pJXKuo+BlEa4al1ts3mqzdD8l6RXqr2V2SgGPKnNnTtvOEIWHGikhb76JoJi?=
 =?us-ascii?Q?Kpl0Y+9d0WUoECDknsz7fjxzlToxvfRgY6/+OM+isIAToW1tUtbMe3/6twfT?=
 =?us-ascii?Q?C4Pjre7R8gI9U40vo9rJAOxuy8jTQWYL4ToyD5oW6Rni+mLrG37vMtwdvh4/?=
 =?us-ascii?Q?N53myzN9Wc/GBJAY1FqhwhfJiadGQ9s7pnvhcMvsr7QUDgYfZwLCkwZrW6rl?=
 =?us-ascii?Q?9lup4TvnwAfGGLBlcdHExNc7EpEIzJRghhGdMFCnkA83k2r2l9u2ywgLT5DO?=
 =?us-ascii?Q?MYIdIVvpvvdzvtlPxotRk6No3rhRGMquWS/sL95MUQ2HgJCf92/YBXykLqHv?=
 =?us-ascii?Q?XkSFRmQGGDi/3fOWn+VyCggT1TJjeMhyLatQyQ2/6LKEgzOgQW/TZpXNAWMc?=
 =?us-ascii?Q?E3bcakeSOKAHp+ys/ijSAqc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20725CE42FE8A643B5BB25EA91B3D0FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30596edc-2a4c-4a83-b085-08da83b7d7f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2022 20:58:05.0981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DK+P222m72wwTHR7Wk4kGxzTssbCDpsa6mUUdiKWAAzkpZ3bwnfbiJ0qT8BuJ/7tGWmZCuvVk2VZNwkZbPpk85HdQvNWuT/7IwVWHDX9T+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5962
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,
Thank you for your answer.

> > Hi netdev,
> >
> > I am posting this thread in continuation of:
> >
> > https://lore.kernel.org/netdev/20220415173718.494f5fdb@fedora/
> >
> > and as a new starting point for further discussion of offloading PCP-ba=
sed
> > queue classification into the classification tables of a switch.
> >
> > Today, we use a proprietary tool to configure the internal switch table=
s for
> > PCP/DEI and DSCP based queue classification [1]. We are, however, looki=
ng for
> > an upstream solution.
> >
> > More specifically we want an upstream solution which allows projects li=
ke DENT
> > and others with similar purpose to implement the ieee802-dot1q-bridge.y=
ang [2].
> > As a first step we would like to focus on the priority maps of the "Pri=
ority
> > Code Point Decoding Table" and "Priority Code Point Enconding table" of=
 the
> > 802.1Q-2018 standard. These tables are well defined and maps well to th=
e
> > hardware.
> >
> > The purpose is not to create a new kernel interface which looks like wh=
at IEEE
> > defines - but rather to do the needed plumbing to allow user-space tool=
s to
> > implement an interface like this.
> >
> > In essence we need an upstream solution that initially supports:
> >
> >  - Per-port mapping of PCP/DEI to QoS class. For both ingress and egres=
s.
> >
> >  - Per-port default priority for frames which are not VLAN tagged.
>=20
> This exists in DCB APP. Rules with selector 1 (EtherType) and PID 0
> assign a default priority. iproute2's dcb tool supports this.
>=20
> >  - Per-port configuration of "trust" to signal if the VLAN-prio shall b=
e used,
> >    or if port default priority shall be used.
>=20
> This would be nice. Currently mlxsw ports are in trust PCP mode until
> the user configures any DSCP rules. Then it switches to trust DSCP.
> There's no way to express "trust both", or to configure the particular
> PCP mapping for trust PCP (it's just hardcoded as 1:1).

Right, so this could be of use by you guys as well.

>=20
> Re this "VLAN or default", note it's not (always) either-or. In Spectrum
> switches, the default priority is always applicable. E.g. for a port in
> trust PCP mode, if a packet has no 802.1q header, it gets port-default
> priority. 802.1q describes the default priority as "for use when
> application priority is not otherwise specified", so I think this
> behavior actually matches the standard.
>=20
> > In the old thread, Maxime has compiled a list of ways we can possibly o=
ffload
> > the queue classification. However none of them is a good match for our =
purpose,
> > for the following reasons:
> >
> >  - tc-flower / tc-skbedit: The filter and action scheme maps poorly to =
hardware
> >    and would require one hardware-table entry per rule. Even less of a =
match
> >    when DEI is also considered. These tools are well suited for advance=
d
> >    classification, and not so much for basic per-port classification.
>=20
> Yeah.
>=20
> Offloading this is a pain. You need to parse out the particular shape of
> rules (which is not a big deal honestly), and make sure the ordering of
> the rules is correct and matches what the HW is doing. And tolerate any
> ACL-/TCAM- like rules as well. And there's mismatch between how a
> missing rule behaves in SW (fall-through) and HW (likely priority 0 gets
> assigned).
>=20
> And configuration is pain as well, because a) it's a whole bunch of
> rules to configure, and b) you need to be aware of all the limitations
> from the previous paragraph and manage the coexistence with ACL/TCAM
> rules.
>=20
> It's just not a great story for this functionality.
>=20
> I wonder if a specialized filter or action would make things easier to
> work with. Something like "matchall action dcb dscp foo bar priority 7".
>=20

I really think that pcp mapping should not go into tc. It is just not=20
user-friendly at all, and I believe better alternatives exists.

> >  - ip-link: The ingress and egress maps of ip-link is per-linux-vlan in=
terface;
> >    we need per-port mapping. Not possible to map both PCP and DEI.
> >
> >  - dcb-app: Not possible to map PCP/DEI (only DSCP).
> >
> > We have been looking around the kernel to snoop what other switch drive=
r
> > developers do, to configure basic per-port PCP/DEI based queue classifi=
cation,
> > and have not been able to find anything useful, in the standard kernel
> > interfaces.  It seems like people use their own out-of-tree tools to co=
nfigure
> > this (like mlnx_qos from Mellanox [3]).
> >
> > Finally, we would appreciate any input to this, as we are looking for a=
n
> > upstream solution that can be accepted by the community. Hopefully we c=
an
> > arrive at some consensus on whether this is a feature that can be of ge=
neral
> > use by developers, and furthermore, in which part of the kernel it shou=
ld
> > reside:
> >
> >  - ethtool: add new setting to configure the pcp tables (seems like a g=
ood
> >    candidate to us).
> >
> >  - ip-link: add support for per-port-interface ingress and egress mappi=
ng of
> >    pcp/dei
> >
> >  - dcb-*: as an extension or new command to the dcb utilities. The pcp =
tables
> >    seems to be in line with what dcb-app does with the application prio=
rity
> >    table.
>=20
> I'm not a fan of DCB, but the TC story is so unconvincing that this
> looks good in comparison.
>=20

Agree.

> But note that DCB as such is standardized. I think the dcb-maxrate
> interfaces are not, and the DCB subsystem has a whole bunch of weird
> pre-standard stuff that's not exposed. But what's in iproute2 dcb is
> largely standard. So maybe this should be hidden under some extension
> attribute.
>=20

So a pcp mapping functionality could very well go into dcb as an extension,
for the following reasons:

 - dcb already contains non-standard extension (dcb-maxrate)

 - Adding an extension (dcb-pcp?) for configuring the pcp tables of ieee-80=
2.1q
   seems to be in line with what dcb-app is doing with the app table. Now, =
the
   app table and the pcp tables are different, but they are both inteded to=
 map
   priority to queue (dscp or pcp/dei).

 - default prio for non-tagged frames is already possible in dcb-app

 - dscp priority mapping is also possible in dcb-app

 - dcb already has the necessary data structures for mapping priority to qu=
eue=20
   (array parameter)

 - Seems conventient to place the priority mapping in one place (dscp and p=
cp/dei).

Any thoughts?

> >  - somewhere else
> >
> > In summary:
> >
> >  - We would like feedback from the community on the suggested implemena=
tion of
> >    the ieee-802.1Q Priority Code Point encoding an decoding tables.
> >
> >  - And if we can agree that such a solution could and should be impleme=
nted;
> >    where should the implemenation go?
> >
> >  - Also, should the solution be supported in the sw-bridge as well.
>=20
> That would be ideal, yeah.=
