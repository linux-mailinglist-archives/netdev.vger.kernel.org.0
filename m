Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B192D06F9
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 20:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgLFTqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 14:46:08 -0500
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:20012
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726440AbgLFTqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 14:46:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JncnFSY6PeW+V4XqBNP5FdtgeijQ4Sue3OZZMpYmq8LEOYFbXz+5OnDVOtYUuj1E7pP1MScCTpBsIRLsGWClGbBARc0m2ZvIW7RcHz8EC7XzV2gMZKvssPcEjFGZhj2AssaxD78/T20qRIZyAXgh5kUj7uZRFTni5S8yemCedtfLDu+/7E9HDpOklTroskG3EHnVOx/Hdq3PLFi+fVHVW3Wa3FbmLVBHKc0/T1F7xnPJuHCaAgOhXfRsFPFnYt3+fJLtOPMHqDnqaWT4oD354F3akiy2uWUMusmkrH3mLfSjZOZxnpoMDin4szkBbTnaMii4sDYEvuF1ju6TuxdOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/uoVPDkrvW507MYw97G79ZkwjeIuQSzHZEgVD8jG2I=;
 b=VLrx7OAV4QvbkLDQkMGr0cDHuZe8jBjAfxjfNsZkh0KzrAR7TAig9yhBFfsneLkQOQgn3cbICRTlPRVjd79kCJLdA6mdAlciiBPBxwwbQkb3kKMJoA5QneVq4Gj4EmEHOCPmGAVHfue10SzPMPgRwLwcS6we2F2tkLjGPmI9BkakmWrT0a7q121e+PWbbim1VJ2Cw5XcrJqFNEWktty7xxjxb9eU2Nn2479he3uc9KmkYx81EFau0mAqWOgYEt7JtM2U16fZdG7tHbpzlK1bGfmQ2J2izCwaODNaxgikhkvdX05PIBM/S9y1Udi2PrjEd856u/+BmQUxGx4P8m/kPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/uoVPDkrvW507MYw97G79ZkwjeIuQSzHZEgVD8jG2I=;
 b=ZlPN9Np3gdJGVmJhwcUgFcarmSGGifrC7MTXSOQiFWRuCst3iZ8SJWZTcUUwsZgbPt020h7mFgy2XAvcuDcXZbVHnWhYwrkKGqIMjr8OZ/47bw4eQfVQF/2J2YGmMsOpOlbw3O0ptTyusEpUWqv0DDbY+2tUh3nTpMJgd2K0LWk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sun, 6 Dec
 2020 19:45:17 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Sun, 6 Dec 2020
 19:45:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: vlan_filtering=1 breaks all traffic
Thread-Topic: vlan_filtering=1 breaks all traffic
Thread-Index: AQHWy0MhpNKtLM78DUiJl/hLVHZUnKnqeh0A
Date:   Sun, 6 Dec 2020 19:45:16 +0000
Message-ID: <20201206194516.adym47b4ppohiqpl@skbuf>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
 <20201205190310.wmxemhrwxfom3ado@skbuf>
 <ecb50a5e-45e5-a6a6-5439-c0b5b60302a9@prevas.dk>
In-Reply-To: <ecb50a5e-45e5-a6a6-5439-c0b5b60302a9@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27e46592-4800-4845-c76d-08d89a1f755d
x-ms-traffictypediagnostic: VE1PR04MB6640:
x-microsoft-antispam-prvs: <VE1PR04MB66400CEC23E84509D9FAB5F1E0CF0@VE1PR04MB6640.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gDCKaZkmleBC3tU+no62of29/dlFPBh79puszhIMMLR/4N+kSbyfYZ4URLibdlsG3+MAnEDGjiQCfSdBj9xLNI2AQlxBcm7lunq3aWQY6p30QRXzxKwEQjt/u5GdUW9BxxeSRFXQ/soIQb9vyG46u8QUPCS6rcDobWlPnCzkF7lUfU3r9AxW8LtLjrXYZWQfTaIoDyrgGDBqZGBTOAuJO5CNmDrJgwkCMvbIXbmqz+38HAt4qUnTlO1jC1icG1+4OsUjG9hmlEiLhHBFi+GsUxKPHWbSVe5qzwF1HGwQ+yGC6oD7rheZus3Va3j+LRXn1CYS/Z4/mrD49XAfe7M7sbmR1hIZK01oPQ5yIyKIDiA8MuKe5gSQ52AJ3yxXPaLc1pSrZrXag15auH8EGlMywQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(396003)(136003)(376002)(39860400002)(346002)(66946007)(83380400001)(186003)(44832011)(86362001)(1076003)(6916009)(64756008)(66556008)(66476007)(66446008)(26005)(5660300002)(6506007)(316002)(478600001)(33716001)(54906003)(4326008)(76116006)(71200400001)(6486002)(966005)(8936002)(2906002)(9686003)(8676002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8UGLRZseT/cwCWdEETHhYPZYFlFcdaBF8PzQOPh2vRthjsNI0I8tm3aExjD1?=
 =?us-ascii?Q?zm6aki6VHMu90f9hWL5fzjFsTPETmUIJgkh58qYMIpefQr1VHNZG77AL0XSu?=
 =?us-ascii?Q?/lbopAyEtKnZxGgv2n7GqlQevAYpmh858b0zf83f+pcF9NkGVzS1nDu3BQT9?=
 =?us-ascii?Q?qf4Dagj79hYsQtNgB4kgbTuWqT4yTrXbeanJFAGWDFEyWsx7aoPzolTQaVcY?=
 =?us-ascii?Q?goBSfZsJONGo9wg02cw0JZbJNHrNzq9Pe2EipNEbvt8zwTsjlSeyHeKvhQRJ?=
 =?us-ascii?Q?TylmlK0EJv+qwe1cmfGyQ08XKkeLz40MaiAqNEwvZ+HgGENAvccTUwTXwNiC?=
 =?us-ascii?Q?+FeiR0L8IvInafQdC7Z50DEicMZVnll5CfMqVzWJ98G4lsgoQgtiEjaiB8JY?=
 =?us-ascii?Q?0ceBs4RXdyyDvIzjEdcjme5jLqJZN2UX4951h3JFPnbF2gsIinfK1wMWRlMh?=
 =?us-ascii?Q?QXno0umCKtx0/6pm62Wl4QSupl95E9xnJ6c28MiAr3HusaT56QNu+J5iHjHk?=
 =?us-ascii?Q?hzMUw63FkH2iNZRFsly5GgshOzc8VlYC/rRZaL8wTzhUlG1Aqo6670U4dijs?=
 =?us-ascii?Q?6J4yOou7K1hTRIH5Wg1qMy8V7h2INpWowUUY7wMjlqcEFgfWgn5w23d2kOnG?=
 =?us-ascii?Q?A55sQwKhb+TfSFC80YlUdwFL6IFpQSIozssWzvwKyU90lAvAUUu6lj/0XHkl?=
 =?us-ascii?Q?5sD/YD2EfzGIUK58ApLLrES5OdnMDSq1/WN6eytuLIPZfHyenbMBYjgivkg/?=
 =?us-ascii?Q?dH8OkX/wsarsiZvHjOjE0lKI6yWoj/yqTH3ma/uPK9CbLocalNG0lZBAsYnF?=
 =?us-ascii?Q?2mQPrk/JPGIFakAgEHWr6qwuoZm6+9D9Rf6gHr4CmOsiiOwGS4JO0pzDelcs?=
 =?us-ascii?Q?kWTrWqnLGUEyNjlxvPCtvhOMSsO3nUlu93sZr0JQKiXFxXnJRVVXRqBBsih6?=
 =?us-ascii?Q?xvbmnzAbJBKH9F2S5hJaBBJrNgtMCRZD0WAliLD7RMskbLleGKCBy48w9oJH?=
 =?us-ascii?Q?XgIF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <02F8D9128C96FF41807926CEB3F66E9F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e46592-4800-4845-c76d-08d89a1f755d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2020 19:45:17.5229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jWpnjJBvjnq9KQe093Y9FeJe+GoX2EH73BwZb6OFfpur9ihgm2/j78fLt3Euj9dhR0UHAvc41Bfk2sK2VuuArg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 09:13:37PM +0100, Rasmus Villemoes wrote:
> Yup, that corresponds pretty much to what I do. Just for good measure, I
> tried doing exactly the above (with only a change in IP address), and...
> it worked. So, first thought was "perhaps it's because you bring up br0
> before adding the ports". But no, bringing it up after still works.
> Second thought: "portS - hm, only one port is added here", and indeed,
> once I add two or more ports to the bridge, it stops working. Removing
> all but the single port that has a cable plugged in makes it work again.
> It doesn't seem to matter whether the other ports are up or down.
>
> I should probably mention that wireshark says that ARP (ipv4) and
> neighbor solicitation (ipv6ll) packets do reach my laptop when I attempt
> the ping. If I start by doing a succesful ping (i.e., no other ports
> added), then add another port, then do a ping, the ping packets do reach
> the laptop (and of course get answered). So the problem does not appear
> to be on egress.

It would be interesting to see what is the ingress drop reason, if that
could be deduced from the drop counters that are incrementing in ethtool -S=
.

I am not confident that it can be a VTU issue, given the fact that you
have not said that you see VTU violation warnings, which are fairly loud
on mv88e6xxx.

The procedure of joining a new port to the bridge does alter the VTU,
since that second port needs to be a part of the default_pvid of the
bridge as soon as it goes up (VID 1). However that is not the main thing
that bridging a new port does - instead, the in-chip Port VLAN map is
altered.

In theory it _would_ be possible (even if unlikely) for the VTU to get
overwritten by the second port join, in a way that removes the first
port from the bridge's VID 1. Remember that this issue only seems to be
observable on 8250, so it seems logical to search in 8250 specific code
first (therefore making the VTU a more likely suspect than the in-chip
Port VLAN map).

Since you've already made the effort to boot kernel 5.9, you could make
the extra leap to try out the 5.10 rc's and look at the VTU using
Andrew's devlink based tool:
https://github.com/lunn/mv88e6xxx_dump

# devlink dev
mdio_bus/d0032004.mdio-mii:11
mdio_bus/d0032004.mdio-mii:12
mdio_bus/d0032004.mdio-mii:10
# ./mv88e6xxx_dump --device mdio_bus/d0032004.mdio-mii:10 --vtu
VTU:
        V - a member, egress not modified
        U - a member, egress untagged
        T - a member, egress tagged
        X - not a member, Ingress frames with VID discarded
P  VID 0123456789a  FID  SID QPrio FPrio VidPolicy
# ip link add br0 type bridge vlan_filtering 1
# ip link set lan4 master br0
[   74.443547] br0: port 1(lan4) entered blocking state
[   74.446037] br0: port 1(lan4) entered disabled state
[   74.461416] device lan4 entered promiscuous mode
[   74.463564] device eth1 entered promiscuous mode

# ./mv88e6xxx_dump --device mdio_bus/d0032004.mdio-mii:10 --vtu
VTU:
        V - a member, egress not modified
        U - a member, egress untagged
        T - a member, egress tagged
        X - not a member, Ingress frames with VID discarded
P  VID 0123456789a  FID  SID QPrio FPrio VidPolicy
0    1 XXXXUXXXXVV    1    0     -     -     0

# ip link set lan5 master br0
[   84.533120] br0: port 2(lan5) entered blocking state
[   84.535563] br0: port 2(lan5) entered disabled state
[   84.552022] device lan5 entered promiscuous mode
#
# ./mv88e6xxx_dump --device mdio_bus/d0032004.mdio-mii:10 --vtu
VTU:
        V - a member, egress not modified
        U - a member, egress untagged
        T - a member, egress tagged
        X - not a member, Ingress frames with VID discarded
P  VID 0123456789a  FID  SID QPrio FPrio VidPolicy
0    1 XXXXUUXXXVV    1    0     -     -     0

You would expect to see two U's for your ports, and not something else
like X.=
