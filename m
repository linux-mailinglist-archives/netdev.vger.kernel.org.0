Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D654FBA39
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345762AbiDKK55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345766AbiDKK5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:57:55 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A19E3B2AE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFjg7BrzXlOzVRD13fbJAwjceW2tgmFNP4gX/Akt0CavNlqKW+8tdI2gI3oA34j5C+MgAxDIULnpRNbTkUI3LJ5a2qZtHBgaM8JS4GKEoIlZ9ogzrDZyv0emPGLZy8QzlT3Tcei145XUnSN3kexSmpG4TOpfpHIweMYt/WJ4jaDY7pUWk/Tc/hBAiW4kMtd2bccQiPho25KKn+4cIbumToTNxNq1G3t12DMjr3cdQghZjWLiyncsefsV5BMZBIxjKBrlxyVzY2xRN/RGGNZ0Kswoo72pWTWdIBNosqXKUUsExu6JCuhB5mYTJvcj1/sCw/6s+/ZTQAV5xnWFrcoHKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7Yyi2UV8DqaTYh81GPfFd+lzjc6oogv5nNC5tkw/P4=;
 b=kN0RD0fiLgcJsWUSRY0f1A1lNX3uUijuS8GCSckcRcsIbG8Ht+QQebPp3AnNX6iP2xPC0wpCCSK1mfLfvPueXvWsZ9DCUAymK+g8R/d5Ghu0kiFcl9g0FIqE4DEfcssBxOV5e0oHZayIjs7wWDDn/bhgGZZBJIWP6hW2qYlJGxQ3yA7dmnIOmnsEoAi4/ZhJu6a1xRY5f+H9+h8g67AjxfM6AvqY9/OYAsR+vz7TJlEnIo6NfAD2ngVQPQXdeyC60KzK8OHDuTIsACViKfQ7Ra4fHbGlIrIIANLbHCJIbezEpUZX2zhP0Ws/QnGk7mD6QOBXxlUHJtJmnQbX4/US/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7Yyi2UV8DqaTYh81GPfFd+lzjc6oogv5nNC5tkw/P4=;
 b=lbkkvXO9B9koI9v8WPHertjrYPA1ABbRT/+HEn04SyPLtj8zR2EPXcrv7f+S35InR3LaLDV209kxKjw6kT9U8VQMTWeK53tJ1b0aBy2KvevHRNXkdac+alFW2W1rrvy1VoEeaS5KOCIsZtdSXiIy5kauQHJa77NCiX3Mkmy1EEo=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR0402MB3325.eurprd04.prod.outlook.com (2603:10a6:803:e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 10:55:35 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4502:5fbf:8bf2:b7bd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4502:5fbf:8bf2:b7bd%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 10:55:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Topic: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Index: AQHYS4PpJFoPHwGopUSskoKVo9n1g6zn/hgAgAAQgICAAWSWgIAAQ2IAgADA3ACAABbiAA==
Date:   Mon, 11 Apr 2022 10:55:35 +0000
Message-ID: <20220411105534.rkwicu6skd3v37qu@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com> <20220409204557.4ul4ohf3tjtb37dx@skbuf>
 <8735ikizq2.fsf@waldekranz.com> <20220410220324.4c3l3idubwi3w6if@skbuf>
 <87zgksge17.fsf@waldekranz.com>
In-Reply-To: <87zgksge17.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 254fbe9e-d94f-4ddd-fc33-08da1ba9ce78
x-ms-traffictypediagnostic: VI1PR0402MB3325:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB3325AA8FA425C3E5F12E2E15E0EA9@VI1PR0402MB3325.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: got3R6qkPWLHEaea8rB0jlkUbUs4VqjFa7/BstSl9NZ1xLgKeecbejyCCbKsROltv5kWcbiboq4L38M/x5n5QdYRt6eeA0fPqdZAC4ZDuFuNaWHPPIsoTfaN96bTn65gMZKl+fnXoRBA/CPay5iVmxY7Jg0A19u4zC923n+RvYkM9hnkdcInfegvBP5EFwcIYHZ7c5XFFS874UNq1VQJ6j+bxkVdetouTJVGkiylHJppl4kzVOkb/Y2ffiBiMRUk1fAO3/X/f06JGGyozrGYAwgz9UUM4Zn+hr5bYhJmyt3TwNCnnzJBhixsv8ZE+SQHQV88Ad5PrSCxoCg7VR0/hElKR66/fwgd8WM3kQeUaax2JKANdMLXSX9k3K3A78xWxQ2ly31bBxcPvEDG2N/jwH6Mdaj0h2kauhFLogKPYJxRFi0D3a9nnnPejp/F/UzH8eF6epLpeZYESfG4uAJUTo7C601z23xIimooBuAse1Oz0HdEhM/U8kvoF7LkboK8Q+NtnMoTPVS66S/B6EPM3ZZx41szvSLWblWbWBAko4zIPqY22M1IR6GAtbX8XS6EnqTPLhAIAstaLLI40ius49F/hLRhfos3QUSXuBc/4EVoGyZUQaUV/kZ5jGyyucWnfCjmzCVGSYE+ayYGKsqKFgJabkCE5zi2mxSDuW2z2bcBn64AlzKfyBeP06/SWuLKl25Dt3WobO1RFKMYPpnhRFIrBvaaH9gHuDCxKx7f47I06wMO640Nix6/8w9KXP7X1CVjx4wK59z2hNyZuMjJ6+lWAAZH559Mrzh28q7GRRM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(38100700002)(6506007)(7416002)(54906003)(30864003)(6916009)(44832011)(5660300002)(53546011)(6512007)(9686003)(8936002)(122000001)(2906002)(38070700005)(1076003)(66946007)(508600001)(66556008)(186003)(26005)(66476007)(66446008)(76116006)(71200400001)(66574015)(4326008)(91956017)(86362001)(8676002)(33716001)(966005)(83380400001)(6486002)(64756008)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zuRCXh034KXuoSVL3xKOetoys8qlYivdK2MX53In2BmJ4fItD3I28U8wJHxz?=
 =?us-ascii?Q?e31Pvcy3IHc93zm2IFkz2pdfdxaQGEUfcQ9S/IszBa7Dtg9pa3JCwytd9djI?=
 =?us-ascii?Q?VLrNZ3bami9HTev0W/BFqYqH0dd6WBM7ZmHC7zwWVcg/+VqzRQd9wdHma1GU?=
 =?us-ascii?Q?X3uijCkKqxGjcRT6n5HL6Zx5/DOlsCstOwjWo9d2ObPkIs+BR71bklf00tCp?=
 =?us-ascii?Q?CDIleU88p23qDclO6XPMsTmznknUKk6+hioo6Iff/Ignjh8bKYNjiS1qyxXM?=
 =?us-ascii?Q?KRV6GL9ySIp8Vw1TGDLBbeRlmcb0jizpJIt6U7H4setXnjAKY9ttiuq9Youb?=
 =?us-ascii?Q?ydcrZ/e9P0m0ipOIa8Asts5RyhA4B7ey1wH+BQDfpkd7OQTA0SrSVnyP01Ri?=
 =?us-ascii?Q?iehi9Le5Ujd4wy0rFLRxWFw+YUod4pl7zqV/NTEOTZVYq80oYYiuGWfS9EC9?=
 =?us-ascii?Q?NPVkbKLRHeiM4SLczUa5NH5S6YXWI5jkVbRUeYi/AE+LKuUOf8997mNfEaGh?=
 =?us-ascii?Q?W2EcHyi0jG1AiCLTV+Pnysh/NISuo4HhSTQB5eohqmJ5qEAisr/UJeJ7pG0S?=
 =?us-ascii?Q?N8fDq8wxTa/l0EsOwf9gjU2TtaNOM5n7Squ65aeJdzgemGLF69pRlqrA9AXs?=
 =?us-ascii?Q?mRTN+4D05XJVFUpMu4+v0mWNEhLJoAK2le972yLClvQtNWR4fMDlGtyi3S+v?=
 =?us-ascii?Q?b6IcWWJ3SD/5Cc6Pcu3/CFfusQCMRI8m5y5xd4Fm39oOVRMzjHHBYbk1Nj22?=
 =?us-ascii?Q?eg4y1HY8WwVUzT7lWxExL8j/HkREOc1oetE8IOQUQPaG4k7k0MpHw8Gtk9nb?=
 =?us-ascii?Q?JCudUkn1nyDO9WLVC3Ff5hkCHC7IkN7yfsfMLVMpFR2xbhkYGuAVeIFoTm/4?=
 =?us-ascii?Q?f5hEiepKuU+0gaS5W7KXBpMsVUcMk85Z1IIv3isi2yLOLR6VVwkTiAhUmt1P?=
 =?us-ascii?Q?/Qr/5HA/1ha7inivBhM5qUdse++6oecTz/WR66CP9xOrlCk6OfqG148yjAg9?=
 =?us-ascii?Q?RmHbl/n0Jo6yqX+KtqfTmptENQfcvWxJJJ3UD2Zn8AtNPTsvsQ2rgUYXBprV?=
 =?us-ascii?Q?Nhvsz9NsCezwGcbn310ddaKXCoekPO1ezmMHJVwAGLdsIbhy3BVwnsdFOVG7?=
 =?us-ascii?Q?Y73SGFeixtMVcjUTuZNuOnyVDAU+xh7wdjdzXX8ix0spy2Q/FI3sI22MwVlX?=
 =?us-ascii?Q?cSMD8xFqs1r9RZZm1HK+JapFlco4b2rjeNBkiGp/eaRCRuiTkabysr71Uy0I?=
 =?us-ascii?Q?Lzi9oPN+e5KhMIHeqAqB0RbXGp2vi1RGjITgIUPuFcd+NwrKHfQC5Br9pwRT?=
 =?us-ascii?Q?FDELW3lWseSD5fPVgc92GS3hDFEQb+KSBeDCZCL6jvzY465p9sYOe1Ycc1TF?=
 =?us-ascii?Q?61X12uo0xMD82q/8IBqbgeia+zcZOvuoKMgBcF47FAD8qzR4WDIPxMf2lOa8?=
 =?us-ascii?Q?pG8B6ITu89dYQR0lnaeE3C8hihkLOdha7pAmmIP9+D2O4kTuJS2mwJVMtwYy?=
 =?us-ascii?Q?YN7sWMMznEWIvYkwRW65PrUNEMGYvHtoOswpjhzacKd3Y1/W0VGUu6Jgoh27?=
 =?us-ascii?Q?74O9r1vAgw6UJJuSFNfLjpz0VbZnlL9w9EAM3X79YJc4OW05uSQklnQyvaRJ?=
 =?us-ascii?Q?MAb0BQrm2dO0GLZqXxWWsRiKsKQsbSazfvqPnA8DswsPF10HTr4qwrMMvCVD?=
 =?us-ascii?Q?zjP+CRfKWky1oZt3yFHBiwSIq7ixw/BcNdJO7g6awRqAi+mDmcecY9VsJYtB?=
 =?us-ascii?Q?xBhME2HZpSzTcumW2CglJK72TVJkqeE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF2603B82E187E4A8A6B10B283F26AE1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254fbe9e-d94f-4ddd-fc33-08da1ba9ce78
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 10:55:35.2554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: koHk4D7xaTyNlU7oKgUGJZahbRP/9Qx5ekqCXnd+NfNPWBNHUpwXw7rbAe9rhYb7VWSwmzPDE35If0bT79S5gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3325
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 11:33:40AM +0200, Tobias Waldekranz wrote:
> On Sun, Apr 10, 2022 at 22:03, Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> > On Sun, Apr 10, 2022 at 08:02:13PM +0200, Tobias Waldekranz wrote:
> >> On Sat, Apr 09, 2022 at 20:45, Vladimir Oltean <vladimir.oltean@nxp.co=
m> wrote:
> >> > Hi Tobias,
> >> >
> >> > On Sat, Apr 09, 2022 at 09:46:54PM +0200, Tobias Waldekranz wrote:
> >> >> On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
> >> >> > For this patch series to make more sense, it should be reviewed f=
rom the
> >> >> > last patch to the first. Changes were made in the order that they=
 were
> >> >> > just to preserve patch-with-patch functionality.
> >> >> >
> >> >> > A little while ago, some DSA switch drivers gained support for
> >> >> > IFF_UNICAST_FLT, a mechanism through which they are notified of t=
he
> >> >> > MAC addresses required for local standalone termination.
> >> >> > A bit longer ago, DSA also gained support for offloading BR_FDB_L=
OCAL
> >> >> > bridge FDB entries, which are the MAC addresses required for loca=
l
> >> >> > termination when under a bridge.
> >> >> >
> >> >> > So we have come one step closer to removing the CPU from the list=
 of
> >> >> > destinations for packets with unknown MAC DA.What remains is to c=
heck
> >> >> > whether any software L2 forwarding is enabled, and that is accomp=
lished
> >> >> > by monitoring the neighbor bridge ports that DSA switches have.
> >> >> >
> >> >> > With these changes, DSA drivers that fulfill the requirements for
> >> >> > dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_fil=
tering()
> >> >> > will keep flooding towards the CPU disabled for as long as no por=
t is
> >> >> > promiscuous. The bridge won't attempt to make its ports promiscuo=
us
> >> >> > anymore either if said ports are offloaded by switchdev (this ser=
ies
> >> >> > changes that behavior). Instead, DSA will fall back by its own wi=
ll to
> >> >> > promiscuous mode on bridge ports when the bridge itself becomes
> >> >> > promiscuous, or a foreign interface is detected under the same br=
idge.
> >> >>=20
> >> >> Hi Vladimir,
> >> >>=20
> >> >> Great stuff! I've added Joachim to Cc. He has been working on a ser=
ies
> >> >> to add support for configuring the equivalent of BR_FLOOD,
> >> >> BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allow=
ing
> >> >> the user to specify how local_rcv is managed in br_handle_frame_fin=
ish.
> >> >>=20
> >> >> For switchdev drivers, being able to query whether a bridge will in=
gress
> >> >> unknown unicast to the host or not seems like the missing piece tha=
t
> >> >> makes this bullet proof. I.e. if you have...
> >> >>=20
> >> >> - No foreign interfaces
> >> >> - No promisc
> >> >> _and_
> >> >> - No BR_FLOOD on the bridge itself
> >> >>=20
> >> >> ..._then_ you can safely disable unicast flooding towards the CPU
> >> >> port. The same would hold for multicast and BR_MCAST_FLOOD of cours=
e.
> >> >>=20
> >> >> Not sure how close Joachim is to publishing his work. But I just th=
ought
> >> >> you two should know about the other one's work :)
> >> >
> >> > I haven't seen Joachim's work and I sure hope he can clarify.
> >>=20
> >> If you want to get a feel for it, it is available here (the branch nam=
e
> >> is just where he started out I think :))
> >>=20
> >> https://github.com/westermo/linux/tree/bridge-always-flood-unknown-mca=
st
> >>=20
> >> > It seems
> >> > like there is some overlap that I don't currently know what to make =
of.
> >> > The way I see things, BR_FLOOD and BR_MCAST_FLOOD are egress setting=
s,
> >> > so I'm not sure how to interpret them when applied to the bridge dev=
ice
> >> > itself.
> >>=20
> >> They are egress settings, yes. But from the view of the forwarding
> >> mechanism in the bridge, I would argue that the host interface is (or =
at
> >> least should be) as much an egress port as any of the lower devices.
> >>=20
> >> - It can be the target of an FDB entry
> >> - It can be a member of an MDB entry
> >>=20
> >> I.e. it can be chosen as a _destination_ =3D> egress. This is analogou=
s to
> >> the CPU port, which from the ASICs point of view is an egress port, bu=
t
> >> from a system POV it is receiving frames.
> >>=20
> >> > On the other hand, treating IFF_PROMISC/IFF_ALLMULTI on the
> >> > bridge device as the knob that decides whether the software bridge w=
ants
> >> > to ingress unknown MAC DA packets seems the more appropriate thing t=
o do.
> >>=20
> >> Maybe. I think it depends on how exact we want to be in our
> >> classification. Fundementally, I think the problem is that a bridge
> >> deals with one thing that other netdevs do not:
> >>=20
> >>   Whether the destination in known/registered or not.
> >>=20
> >> A NIC's unicast/multicast filters are not quite the same thing, becaus=
e
> >> a they only deal with a single endpoint. I.e. if an address isn't in a
> >> NIC's list of known DA's, then it is "not mine". But in a bridge
> >> scenario, although it is not associated with the host (i.e. "not mine"=
),
> >> it can still be "known" (i.e. associated with some lower port).
> >>=20
> >> AFAIK, promisc means "receive all the things!", whereas BR_FLOOD would
> >> just select the subset of frames for which the destination is unknown.
> >>=20
> >> Likewise for multicast, IFF_ALLMULTI means "receive _all_ multicast" -
> >> it does not discriminate between registered and unregistered
> >> flows. BR_MCAST_FLOOD OTOH would only target unregistered flows.
> >>=20
> >> Here is my understanding of how the two solutions would differ in the
> >> types of flows that they would affect:
> >>=20
> >>                     .--------------------.-----------------.
> >>                     |       IFF_*        |    BR_*FLOOD    |
> >> .-------------------|---------.----------|-----.-----.-----|
> >> | Type              | Promisc | Allmulti | BC  | UC  | MC  |
> >> |-------------------|---------|----------|-----|-----|-----|
> >> | Broadcast         | Yes     | No       | Yes | No  | No  |
> >> | Unknown unicast   | Yes     | No       | No  | Yes | No  |
> >> | Unknown multicast | Yes     | Yes      | No  | No  | Yes |
> >> | Known unicast     | Yes     | No       | No  | No  | No  |
> >                         ~~~
> >                         To what degree does IFF_PROMISC affect known
> >                         unicast traffic?
>=20
> When a bridge interface has this flag set, local_rcv is unconditionally
> set to true in br_handle_frame_finish:
>=20
>     local_rcv =3D !!(br->dev->flags & IFF_PROMISC);
>=20
> Which means we will always end up in br_pass_frame_up.
>=20
> >> | Known multicast   | Yes     | Yes      | No  | No  | No  |
> >> '-------------------'--------------------'-----------------'
> >
> > So to summarize what you're trying to say. You see two planes back to b=
ack.
> >
> >  +-------------------------------+
> >  |    User space, other uppers   |
> >  +-------------------------------+
> >  |   Termination plane governed  |
> >  |     by dev->uc and dev->mc    |
> >  |            +-----+            |
> >  |            | br0 |            |
> >  +------------+-----+------------+
> >  |            | br0 |            |
> >  |            +-----+            |
> >  |  Forwarding plane governed    |
> >  |        by FDB and MDB         |
> >  | +------+------+------+------+ |
> >  | | swp0 | swp1 | swp2 | swp3 | |
> >  +-+------+------+------+------+-+
>=20
> Yes, this is pretty much my mental model of it.
>=20
> > For a packet to be locally received on the br0 interface, it needs to
> > pass the filters from both the forwarding plane and the termination
> > plane.
>=20
> I see it more as the forwarding plane having a superset of the
> information available to the termination plane.
>=20
> I.e. all of the information in dev->uc and dev->mc can easily be
> represented in the FDB (as a "local" entry) and MDB (by setting
> `host_joined`) respectively, but there's loads of information in the
> {F,M}DB for which there is no representation in a netdev's address
> lists.
>=20
> > Considering a unicast packet:
> > - if a local/permanent entry exists in the FDB, it is known to the
> >   forwarding plane, and its destination is the bridge device seen as a
> >   bridge port
> > - if the FDB doesn't contain this MAC DA, it is unknown to the
> >   forwarding plane, but the bridge device is still a destination for it=
,
> >   since the bridge seen as a bridge port has a non-configurable BR_FLOO=
D
> >   port flag which allows unknown unicast to exit the forwarding plane
> >   towards the termination plane implicitly on
> > - if the MAC DA exists in the RX filter of the bridge device
> >   (dev->dev_addr or dev->uc), the packet is known to the termination
> >   plane, so it is not filtered out.
>=20
> It's more like the aggregate of all local entries _is_ the termination
> plane's Rx filter. I.e. in the bridge's .ndo_set_rx_mode, we should sync
> all UC/MC addresses into the FDB/MDB.
>=20
> There's a lot of stuff to deal with here around VLANs, since that
> concept is missing from the kernel's address lists.
>=20
> > - if the MAC DA doesn't exist in the RX filter, the packet is filtered
> >   out, unless the RX filter is disabled via IFF_PROMISC, case in which
> >   it is still accepted
> >
> > Considering a multicast packet, things are mostly the same, except for
> > the fact that having a local/permanent MDB entry towards the bridge
> > device does not necessarily 'steal' it from the forwarding plane as it
> > does in case of unicast, since multicast traffic can have multiple
> > destinations which don't exclude each other.
>=20
> Not _necessarily_, but you are reclassifying the group as registered,
> which means you go from flooding to forwarding. This in turn, means only
> other registered subscribers (and routers) will see it.
>=20
> > Needless to say that what we have today is a very limited piece of the
> > bigger puzzle you've presented above, and perhaps does not even behave
> > the same as the larger puzzle would, restricted to the same operating
> > conditions as the current code.
> >
> > Here are some practical questions so I can make sure I understand the
> > model you're proposing.
> >
> > 1. You or Joachim add support for BR_FLOOD on the bridge device itself.
> >    The bridge device is promiscuous, and a packet with a MAC DA unknown
> >    to the forwarding plane is received. Will this packet be seen in
> >    tcpdump or not? I assume not, because it never even reached the RX
> >    filtering lists of the bridge device, it didn't exit the forwarding
> >    plane.
>=20
> We don't propose any changes to how IFF_PROMISC is interpreted at
> all. Joachim's changes will simply allow a user more fine grained
> control over which flows are recieved by the termination plane when
> IFF_PROMISC is _not_ set.
>=20
> > 2. Somebody comes later and adds support for IFF_ALLMULTI. This means,
> >    the RX filtering for unknown multicast can be toggled on or off.
> >    Be there a bridge with mcast_router enabled. Should the bridge devic=
e
> >    receive unknown multicast traffic or not, when IFF_ALLMULTI isn't
> >    enabled? Right now, I think IFF_ALLMULTI isn't necessary.
>=20
> I think that setting IFF_ALLMULTI on a bridge interface is really just
> another way of saying that the bridge should be configured as a static
> multicast router. I.e. ...
>=20
>     ip link set dev br0 allmulticast on
>=20
> ...should be equivalent to...
>=20
>     ip link set dev br0 type bridge mcast_router 2
>=20
> ...since that flag is an indication that _all_ multicast should be
> received, both registered and unregistered.
>=20
> We propose to add support for all three classes of _unknown_ traffic
> (BUM) from the get-go:
>=20
> - BR_FLOOD (Unknown unicast)
> - BR_MCAST_FLOOD (Unregistered multicast)
> - BR_BCAST_FLOOD (Broadcast)
>=20
> So if BR_MCAST_FLOOD is not set, then the termination plane will not
> receive any unregistered multicast. If it is marked as a multicast
> router, then it will receive all registered _and_ unregistered
> multicast. Same as with any other bridge port.

A bridge port does not *receive* said flooded traffic, but *sends* it.
The station attached to that bridge port *receives* it. You as a bridge
cannot control whether that station will actually *receive* it.
That is the analogy with the bridge device as a bridge port.
BR_MCAST_FLOOD may decide whether the forwarding plane sends the flow to
the bridge, but the bridge's RX filter still needs to decide whether it
accepts it.

> > 3. The bridge device does not implement IFF_UNICAST_FLT today, so any
> >    addition to the bridge_dev->uc list will turn on bridge_dev->flags &
> >    IFF_PROMISC. Do you see this as a problem on the RX filtering side o=
f
> >    things, or from a system administration PoV, would you just like to
> >    disable BR_FLOOD on the forwarding side of the bridge device and cal=
l
> >    it a day, expect the applications to just continue working?
> >
> > 4. Let's say we implement IFF_UNICAST_FLT for the bridge device.
> >    How do we do it? Add one more lookup in br_handle_frame_finish()
> >    which didn't exist before, to search for this MAC DA in bridge_dev->=
uc?
>=20
> I think the most natural way would be to add them to the FDB as local
> entries. We might need an extra flag to track its origin or something,
> but it should be doable, I think. Again I think this is analogous to how
> host addresses are added as FDB entries pointing towards the CPU port in
> an ASIC.
>=20
> > 5. Should the implementation of IFF_UNICAST_FLT influence the forwardin=
g
> >    plane in any way?
>=20
> Since I propose we keep it in the FDB, yes, it will affect forwarding.
>=20
> >    Think of a user space application emitting a
> >    PACKET_MR_UNICAST request to ensure it sees the packets with the MAC
> >    DA it needs. Should said application have awareness of the fact that
> >    the interface it's speaking to is a bridge device? If not, three
> >    things may happen. The admin (you) has turned off BR_FLOOD towards
> >    the bridge device, effectively cutting it off from the (unknown to
> >    the forwarding plane) packets it wants to see. Or the admin hasn't
> >    turned off BR_FLOOD, but the MAC DA, while present in the RX
> >    filtering lists, is still absent from the FDB, so while it is
> >    received locally by the application, is also flooded to all other
> >    bridge ports. Or the kernel may automatically add a BR_FDB_LOCAL ent=
ry,
> >    considering that it knows that if there's a destination for this
> >    MAC DA in this broadcast domain, for certain there isn't more than
> >    one, so it could just as well guide the forwarding plane towards it.
> >    Or you may choose completely the other side, "hey, the bridge device
> >    really is that special, and user space should put up with it and kno=
w
> >    it has to configure both its forwarding and termination plane before
> >    things work in a reasonable manner on it". But if this is the path
> >    you choose, what about the uppers a bridge may have, like a VLAN wit=
h
> >    a MAC address different from the bridge's? Should the 8021q driver
> >    also be aware of the fact that dev_uc_add() may not be sufficient
> >    when applied to the bridge as a real_dev?
>=20
> I might be repeating myself, but just to be clear: I think the end goal
> should be to have a proper .ndo_set_rx_mode implementation that
> translates the device address lists into the forwarding plane, making
> most of this transparent to users.
>=20
> > 6. For a switchdev driver like DSA, what condition do you propose it
> >    should monitor for deciding whether to enable flooding towards the
> >    host? IFF_PROMISC, BR_FLOOD towards the bridge, or both? You may say
> >    "hey, switchdev offloads just the forwarding plane, I don't really
> >    care if the bridge software path is going to accept the packet or
> >    not". Or you may say that unicast flooding is to be enabled if
> >    IFF_PROMISC || BR_FLOOD, and multicast flooding if IFF_PROMISC ||
> >    IFF_ALLMULTI || BR_MCAST_FLOOD, and broadcast flooding if
> >    BR_BCAST_FLOOD. Now take into consideration the additional checks fo=
r
> >    foreign interfaces. Does this complexity scale to the number of
> >    switchdev drivers we have? If not, can we do something about it?
>=20
> Rule #1 is, If IFF_PROMISC is enabled on our bridge, we must flood
> everything.
>=20
> Then for each class:
>=20
> - Broadcast: If BR_BCAST_FLOOD is enabled on the bridge or on any
>   foreign interface, we must flood it to the CPU.
>=20
> - Unicast: If BR_FLOOD is enabled on the bridge or on any foreign
>   interface, we must flood it to the CPU.
>=20
> - Multicast: If BR_MCAST_FLOOD is enabled on the bridge or on any
>   foreign interface, we must flood it to the CPU.
>=20
> For multicast, we also have to take the router port status of the bridge
> for foreign interfaces into consideration, but I believe that should be
> managed separately.
>=20
> Additionally, if you _truly_ want to model the bridge's behavior, then
> IFF_PROMISC on the bridge would mean that we either disable offloading
> completely and forward everything via the CPU or setup some kind of port
> mirror on all ports. Although that seems kind of silly, it might
> actually be useful for debugging on occasion. You could have an ethtool
> flag or something that would allow the user to enable it.

So to summarize your second message.

You're saying "hey, I see that IFF_PROMISC and IFF_ALLMULTI on the
bridge are these beasts that defy all conventional wisdom about what an
RX filter even is. A unicast packet forwarded by the bridge shouldn't be
seen in tcpdump if there is an FDB entry that points to some other port
than the bridge device itself, according to the mental model we agreed
on, yet that is what happens today.

So transposed to an offloading plane, setting IFF_PROMISC would mean
that all traffic should be mirrored to the CPU, which is obviously
something that no driver does, for more than one single reason.
Consequently, the presence of an address in dev->uc would mean to mirror
that single address to the CPU.

For practical reasons (unicast traffic has a single destination), we may
mirror that address by installing it to the FDB as a local entry. And
maybe we could get away with that.

But for multicast RX filters, when an entry would get added to dev->mc,
but that same multicast MAC address is absent from the MDB, we can't
really do much about adding it to the MDB either, because this would
transform the flow from being unregistered to being registered towards
the CPU, so stations that used to see this flow via flooding will no
longer see it.

So much for our implementation of a mirror via the FDB/MDB, we'd instead
have to add actual mirroring logic of individual addresses, without
touching the FDB/MDB. Then have a way to offload those mirrors. And that
would be for the sake of correctness.

In terms of usability in the context of dev_uc_add() and dev_mc_add()
though, that isn't really sane and just caters to the naive view that
"tcpdump should see everything after it sets IFF_PROMISC". Because when
a macvlan becomes an upper of the bridge, dev_uc_add() is what it'll
call, and this won't stop the bridge from flooding packets towards the
macvlan's MAC DA towards the network. It will just ensure that the
macvlan is copied to the traffic destined towards it, too.

I maybe agree that the aggregate of all local entries is the termination
plane's Rx filter, in other words not more than that, i.e. the termination
plane shouldn't treat the RX filters as mirrors from the forwarding plane.
And in that view, yes maybe I agree that IFF_PROMISC would implicitly
correspond to BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD, and
IFF_ALLMULTI would implicitly correspond to BR_MCAST_FLOOD (ok, also
adjust for mcast_router ports).

But I'd rather turn a blind eye to that, on the practical basis that
making any changes at all to this mess that isn't correct even now is
going to break something. I'm going to invent some new knobs which
broadly mean what IFF_PROMISC | IFF_ALLMULTI should have meant, and I'm
going to insist on the selling point that these allow me more
fine-grained control over which class of MAC DA is flooded. In any case
I'm not making things worse, because the BR_FLOOD flags towards the
bridge device still make some amount of sense even in the context of a
more normal interpretation of the bridge's RX filtering flags, if
someone from the future really gets infuriated by the bridge device's
behavior in the presence of uppers with different MAC address and has
the guts to change/break something. So maybe I can get away with this."

Am I getting this right? Because maybe I can hop onboard :)=
