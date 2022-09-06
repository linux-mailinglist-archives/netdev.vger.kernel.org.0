Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C519F5AE4FE
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiIFKFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiIFKFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:05:31 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B105123BF4;
        Tue,  6 Sep 2022 03:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpsGPWT3EJR1g8JJATT2y2XFhu58lPv9DAWem+pYLopMVwrkBxLcNfb87P6fFJ5Hwva0LGMAPqiLU44gzht/5YbCmJCyNb5fJUtumuzrar+1EXLg5Yu18xm1rDDwiO6R6veWZsuMLhven5WL3NjM+SVX7Rpv85K6k2/wivkc/0/TkoPIEf33d2FoUjczr+zsfrENjit9NH6JUzqeUxrPFy44eYLW5c5AVMXnk5CGkFfGUS20La4+nisJU3it39JfpBfrpd8YXCdGb5EmXBcltLCc5v5fU/6PrOLhsQ0Xow83uAbznkLkkRtB1FPZfYus5ltAIMWqyNyVTRkqq4X9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMMF/Qu2ezEOlE0OD/ac/+GcHt+fSZTLhtRDdUq6fTM=;
 b=HfQMG/O2W7a+EIXGCd6OQvfgPnzNS+jE6oJFAgVl89koM7nN/qDji/dinQKu9xt/bl/A05F0xBvBLu/IYuZBYbuDqi2rAH0ZSbtmNXPUigPAsZN4mjoFnlkqD2z9THlS8FowEMyGJePQrfFfY2CfFqcH6YFvg7Wd0wmFX+JuLA7e9XFV4gCKd8Zm44fu3uPX2XPNKbKoSfddX4aZuJta1XJQbDT0pdMD2tth7sMfUqKiOwf8WYNUkOPCJq0kEXThZuOPPoE8x0zLVIKJ8/qJ/yU9Xc8GsxT4AuYJ9fTY2h/xCB5vALOWLsQOOrWOU2/4MKmVc7zZBo301xsJMC9FyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMMF/Qu2ezEOlE0OD/ac/+GcHt+fSZTLhtRDdUq6fTM=;
 b=bVmC4E1ktqiQYc10MXFpUBHzq/+U0n4j2D2xUoAdFxvocetXmeYMKfVlnULoZisyPRivrcgk+b/Rxt6yo5rN4Gsl+Z0oYYZt30NuihYyVmyQmTA263HJExqxZNFe3DoBK9WnLbVuUnwiVKnS26mRrEoDb8NtcMIby84CxhiN3js=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7097.eurprd04.prod.outlook.com (2603:10a6:10:12a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Tue, 6 Sep
 2022 10:05:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Tue, 6 Sep 2022
 10:05:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Thread-Topic: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Thread-Index: AQHYwW37dzULUFcX/0OQXQkpZmzQZq3RZ7aAgAAbB4CAAIrBAIAAIAOA
Date:   Tue, 6 Sep 2022 10:05:26 +0000
Message-ID: <20220906100525.mhjomm6f2y4lr3lw@skbuf>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
 <d00682d7e7aec2f979236338e7b3a688@walle.cc>
 <20220905235413.6nfqi6vsp7iv32q3@skbuf>
 <0c1b726c6791cc97f9ba15f923264630@walle.cc>
In-Reply-To: <0c1b726c6791cc97f9ba15f923264630@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1517bc60-4934-45cd-eda9-08da8fef5207
x-ms-traffictypediagnostic: DB8PR04MB7097:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4gMdNrXAzFo52UPjeH9LorDh5HDYUBG/0ut3iOk7V0XF2uTmTZL7BEpDddz73D6Pz9SEtW/ulcQ14dITXEOHGyuif7STZtDjN7Tw5M7n42BJWyLPshVfH5BOMwh/AVJUl+muHzXsmH17nn+ML7vpBoODJsmbionuCpztwHSPjO7KdblL368CTVhYpeLqgM/keP4bPnZ1++hkadZzGDH+eFqFHZl/wiktkD0cdNgFvjasDMgUBUdpaHlJzSUbNR4NaNSbcCwMg8CeRJzH2EfYIfAp52bFpgr1h9X0W/fNPP9w0/xvrNDcYzJPaeGHF0QiNA33GZ9yxthdaj6ceUpeGI84islXrsMvPY34yTjwxh/sDwQKTM3fukNF4K8azxOoJqQotIJnuNhVEMOiY+ps4QdKSw7bpfWUUJG97O1RNjumKup0pHlUBd+ZBZK9Sz+Yc7qaNiz4hPO+dJBO0vwAU3n3EDBAvZdi3LBI323ItFkFiw42ZD+gEQn1i4it+mhI810lHXucSgsSWwB+fuUGlTBrWC2folm84HZnG/8AgshXQ3XkeVmCHUVQe6X4/FtSBy1fKgPVGe5ARLc0YhhLsR0ZEhaF3SyDGqvgByAB9wxsByGqNBDEzcg6dBWben3HtSiPBRMkEpjDsfXolHmxjS16PS9Mq3ffF9lsyzLd25mVNfp99X2qEG+wzLxo4ZyVRxsVbg8YRILikw6QtuiRQTc4UDoDrRGwV5671a26QgHjfXcqklL1z+waq1mPYeTSmC8rvX7wN6n9Kniw5a0PCZbLUvdp1HXY3cjJau+dRQmXFgG2x0UqkhjtWcRNqJ12hSi4Lkt/Yjhqyd2IeNm43g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(83380400001)(38100700002)(122000001)(54906003)(38070700005)(6916009)(4326008)(33716001)(66446008)(64756008)(66556008)(2906002)(76116006)(66946007)(8676002)(66476007)(316002)(44832011)(9686003)(8936002)(5660300002)(6512007)(6506007)(26005)(1076003)(186003)(6486002)(966005)(71200400001)(41300700001)(86362001)(478600001)(66574015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6uEfwKFIzBs7zMou3B7cdIE092mchwwsXoXxFAlv2vVXklcIyQYba9Nnbh6E?=
 =?us-ascii?Q?COVRuZuPQPTNnRfblHooFS7Npi/cLGbo7xz/qGkhijLKKy1TJnbAOQ2etVG9?=
 =?us-ascii?Q?GK6RDvlc2IYQLtIhQ/9DNc7f5ycnWxdGMhkLRHe1EqpP85iwDJHt9bv9jk7z?=
 =?us-ascii?Q?Ohu+RsXpGjPeE8sGF7nTDRXdcD/e7YRlt98DKsTSZeTQD+MgI6IKeMlVweAO?=
 =?us-ascii?Q?5J75iYPa5Pxo1IQUuzyKw/+p35FzYgPudCfB1QIg/rjBNJuuCVdUYcGZaD9J?=
 =?us-ascii?Q?4zq6QiiWXO86U0ps7yt1LA7tU6+WWqGozo5uB8CL+nZ6MLIhUtjBBrsqlbWi?=
 =?us-ascii?Q?Ax2nRegGNm5CxFAxVgRmnGPW5AWbKKK1zgOANi7Q8djOL0G+hZO4m4kBQOQ6?=
 =?us-ascii?Q?Q2MfbB1LSa+H9EUnaqnTlCH+ZCgDld2dfNVEM1uKE04tcrshYE+mwEdEVSMz?=
 =?us-ascii?Q?EsRtsHBHgQf1sYasOzQRUVxGLoYJxDLQO66etKXQ3bri9/DzKiFIKrv45d43?=
 =?us-ascii?Q?6/W6x0RkYNBuq/GG0jzWLgozbddhRyLwK/x+5yaN991VtYd/fWuDnIS/oMKB?=
 =?us-ascii?Q?k/L8sVPNuVcLaAj7iH8Vs0cdxd7iriTTYiZh77mN/fMOug7fOPgqWWpOCEVr?=
 =?us-ascii?Q?tEy8cgV282cyBzmN3I2pfvFGSgmrDvt9DmlXi0VXbiXgoKWQhm6uJ24g087R?=
 =?us-ascii?Q?1YNNcG7t65AHFRQeMoRGvgOR6RSeR+/ozWSH+2ActQ96oAP0hgLLgIPeb0qS?=
 =?us-ascii?Q?K8ZV+Pp9OMKj/9P2Q4c8mMO6M2M1Yq+LAHJc+CmMdXtzCLdliiY4eAkss4hG?=
 =?us-ascii?Q?ePHEjsJlJHDZs8vRjL7Lt7O38l2KxQ+n83QmDyhj41BszkwCbB21PhfiZYlb?=
 =?us-ascii?Q?kl8KxXVfS9Vbr6jWxcUZWRKP3z5OKwkXOOtjQV7FXvXpE/Q4FqsjPROggudM?=
 =?us-ascii?Q?Nku/nce16WliT7JYKHOWIJNAQWC3zSOHRXDu2qirIPJvCqqYyeJQJKW6CMBW?=
 =?us-ascii?Q?p9Cu9D5KyqWMceslUvVskOuLRVj2EoGO6XLfK+oi1dGpnzsR8c/Ye0fReXcG?=
 =?us-ascii?Q?W+onQr4Sikh2KinWZFnltRsvPZYJAVdhhA74+yC/3A+oceGRRfLgNLUSFNbs?=
 =?us-ascii?Q?G1mdxJf5DHe5H/YHFi0hUCgJk3mIAHriJofDZjbibK/NfYr6iEzMNHHklGgb?=
 =?us-ascii?Q?PvcTsRQseIJgHTXLngdAUD4iYfNiKUH3gqeJTL2LNzq1Nr+3SvVe0YktG8xr?=
 =?us-ascii?Q?8xHx6MVpE83vcbmoZOivGxGVtzu4lo2UINEESkCliWazY5Jdd6X9mSNXUGUY?=
 =?us-ascii?Q?JypaLgnTaB/1r19QEexDr2HnVYbvxfvPGx9bAPP8CsIzINobTcsJcFSZVk9v?=
 =?us-ascii?Q?vW+yfqHWssUgLXFbid/61jouUeEv014zsdhzDI0SdZTS2gVHmVCi1zB9lZ+j?=
 =?us-ascii?Q?7qHHVRGUkBVCUQXs2Lc4uqO3Vh70We5Yjr5Cr6bNemd/xt2lvyMEYSA0JfNh?=
 =?us-ascii?Q?7HIz/RDouP3bqSQGMzrJnJQNfNQN02Kc3D4nvNwqzYM3cTyvcIADzlHWwJWB?=
 =?us-ascii?Q?3rosz6lRWQ18XQs1QAptmImNLGhohVgWfsTYiNW3cl/SN0BiOQIeb0iLFS5v?=
 =?us-ascii?Q?jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C46006B5BA1E004BB89EC4ACFA58503C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1517bc60-4934-45cd-eda9-08da8fef5207
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 10:05:26.2397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4Wa3zNKO6O9ANI5P0SNgapi2NeEOZosw3ezV8fNDPFQxCSDW5JK7Nl83MFrwsx2wUM7511UXc+d/51q718rsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7097
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 10:10:50AM +0200, Michael Walle wrote:
> > > with 3 MAC addresses, right?
> >=20
> > Which 3 MAC addresses would those be? Not sure I'm following. enetc #0,
> > enetc #1, enetc #2? That could work, multiple DSA user ports can share
> > the same MAC address (inherited from the DSA master or not) and things
> > would work just fine unless you connect them to each other.
>=20
> enetc #0, #1 and swp0. As you mentioned, swp1..3 should inherit the
> address from swp0 then if swp0 is added as the first device, right?
>=20
> So why would enetc#2 (or #3) need a non-random mac address? I must
> be missing something here.

I didn't say that swp1..3 inherit the MAC address from swp0. I said that
the DSA user ports can inherit the MAC address from the DSA master (eno2
or eno3). See dsa_slave_create():

	if (!is_zero_ether_addr(port->mac)) // device tree
		eth_hw_addr_set(slave_dev, port->mac);
	else
		eth_hw_addr_inherit(slave_dev, master);

The DSA user ports (swp0-swp3) can also share the same MAC address which
is not inherited from the DSA master (eno2), but this can only be
achieved through static configuration (such as manually setting the same
mac-address in the device tree).

> > If eno2/eno3, then a
> > configuration where having MAC addresses on these interfaces is useful
> > to me is running some of the kselftests on the LS1028A-RDB, which does
> > not have enough external enetc ports for 2 loopback pairs, so I do
> > this, thereby having 1 external loopback through a cable, and 1 interna=
l
> > loopback in the SoC:
> >=20
> > ./psfp.sh eno0 swp0 swp4 eno2
> > https://github.com/torvalds/linux/blob/master/tools/testing/selftests/d=
rivers/net/ocelot/psfp.sh
> >=20
> > Speaking of kselftests, it actually doesn't matter that much what the
> > MAC addresses *are*, since we don't enter any network, just loop back
> > traffic. In fact we have an environment variable STABLE_MAC_ADDRS, whic=
h
> > when set, configures the ports to use some predetermined MAC addresses.
> >=20
> > There are other configurations where it is useful for eno2 to see DSA
> > untagged traffic. These are downstream 802.1CB (where this hardware can
> > offload redundant streams in the forwarding plane, but not in the
> > termination plane, so we use eno2 as forwarding plane, for termination)=
,
>=20
> I'm not that familiar with 802.1CB. Is this MAC address visible outside
> of the switch or can it be a random one?

The MAC address of eno2 is visible outside the switch, onto the network.
Take this 802.1CB ring network for example:
https://github.com/vladimiroltean/isochron/blob/master/frer/8021cb.sh

Every board has 2 redundant ports in the ring, and every board can ping
every other board through the redundant ring, through an IP termination
point (eno2). Except that the switch does not support inserting/stripping
802.1CB redundancy headers for locally terminated traffic, or splitting/
eliminating duplicate streams for locally terminated traffic.

So we configure the switch to consider the internal swp4 as a user port,
and effectively set it up for the forwarding plane, in a bridge with
swp0 and swp1. It's now as if each eno2 used for termination is
connected to a switch that's physically separate from the LS1028A, which
handles the redundant forwarding. Except it's not physically separate,
it's part of the same SoC, and its DSA master is eno3. All in all, it
requires a bit of a split brain syndrome to work with it. This is in
fact one of the key things blocking 802.1CB upstreaming for us, as a
side note - we don't have a very good proposal for modeling a generic
software data path for this.

You can see more details here if you care enough:
https://patchwork.kernel.org/project/netdevbpf/patch/20210928114451.24956-1=
-xiaoliang.yang_1@nxp.com/

> > DPDK on eno2 (which mainline Linux doesn't care about), and vfio-pci +
> > QEMU, where DSA switch control still belongs to the Linux host, but the
> > guest has 'internet'.
>=20
> For me, all of that is kind of a trade off. If you want to use
> virtual interfaces, you might need to borrow a MAC address from
> one of the switch ports (where you have 3 unique addresses left
> if you combine all 4 ports to one bridge).

I didn't say virtual interfaces in this case, I said vfio-pci which is a
way to do PCI direct assignment to a guest OS, which sees the whole
0000:00:00.2 PF corresponding to eno2.

By the way, the internal enetc ports eno2 and eno3 don't have VFs since
SR-IOV is a bit of a complicated topic when DSA-tagged traffic is
expected (you don't want a guest OS to see DSA tags in packets, it
doesn't know what to do with them). But this is one of the main reasons
we have 2 internal ports btw. You configure eno3 as a DSA master, you
leave swp4 as a user port, so now eno2 sees DSA untagged traffic and you
can do direct assignment to whomever.

> > > So uhm, 6 addresses are the maximum?
> >=20
> > No, the maximum is given by the number of ports, PFs and VFs. But that'=
s
> > a high number. It's the theoretical maximum. Then there's the practical
> > maximum, which is given by what kind of embedded system is built with
> > it.
> > I think that the more general-purpose the system is, the more garden
> > variety the networking use cases will be. I also think it would be very
> > absurd for everybody to reserve a number of MAC addresses equal to the
> > number of possibilities in which the LS1028A can expose IP termination
> > points, if they're likely to never need them.
>=20
> I think we are on the same track here. I was ignoring any VFs for now.
> So I guess, what I'm still missing here is why enet#2 and enet#3 (or
> even swp4 and swp5) would need a non-random MAC address. Except from
> your example above. Considering the usecase where swp0..3 is one bridge
> with eno2 and eno3 being the CPU ports. Then I'd only need a unique
> MAC address for eno0, eno1 and swp0, correct?

Don't say "unique MAC address for swp0", since swp0's MAC address is not
unique, you probably mean to say "a MAC address which will be shared by
swp0-swp3".

I think I've answered why eno2/eno3 could need a stable MAC address -
for the case when they aren't used as DSA masters (through the switch
termination plane) but as interfaces unaware of the switch connected to
them (through the switch forwarding plane).=
