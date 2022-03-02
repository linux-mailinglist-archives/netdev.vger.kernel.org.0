Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD9C4CB1B6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 23:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbiCBWGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 17:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbiCBWGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 17:06:11 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47859C9920
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 14:05:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXsFTkgcd4LhR1M6nxSXZZW/teidi2m3vdUktqdQZyi4Bw7GihxVSTCCWYTb1kCEBDJYzh1Hs5rSFIzUtpy2O1i2WWLOBfQ1XQwra//+EhQuUH5+0MnJlgezylE6PnIu9PJQ3bolPVkoJlqfNTiakenYvViyXHvgEAKoUQoFgILXbLAezIQ6Ortcp8qDTfYlitHD7e8k9mk42AKgWkgHgCKiyx4iFPsmZMnWzyq0s5eqN9eyfBEU5oee0xfZuUVWhY7T9bQu77OdqBL//79O4imCPCPJNH3eBPGdx5OJx2SzgFapuGl0/CqC2qFTWPWPuc76ThsR2mqKhAxcJ/8s3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+WqVfGsc8mxXmn7HCiOcxVw6RzQkA5aXl66XWyc2gE=;
 b=asV2rVS7eRB2SGj3no3jEEgoKzxUnMjWLTPKXnbZkGKP1S5AB2D2urXeL7vXR2aUhY0qGAmDmrkAQAvSK9BHJ8ggCki/366Plp1Y+2jMlEcoVE5p1RPWKciY9b9OOIIds8FrmelrKnJRpvarG6HoE/2iJ647+Vls6z9Jeq+HpOTEZyxVuPbo7oSeGTUzD/WTrF4yMeLAYZWZSVJ3TYT5EUNwGE8Xw3+dsp4cgsxtjBidRoVXUB/lqWjaQb9uHfMxgnwJh0f0VLO568L4E6vAx94iNj71f6uwL0eXkyFQ01MwpILTnx+0CT4cXCa3+MXX9jzJFhGwsU+1jQ3JmW8E5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+WqVfGsc8mxXmn7HCiOcxVw6RzQkA5aXl66XWyc2gE=;
 b=nKfh0//gK05GEjXZuza5IK4ampZi2bSfFrqxUYruFyz1FzeZ4QeLFp5rFhhRn9msx3SMbuRt11O1P7yPa65V6mmUuiTSp6lTHsWoOyhY9xFY/rUWXbgcI7KPGs6C0QVwK+Cv1J+CRw4Iutypr5WPTq40gB2xoeClJUgJdEJomRI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3418.eurprd04.prod.outlook.com (2603:10a6:7:82::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 22:05:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 22:05:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 00/10] DSA unicast filtering
Thread-Topic: [PATCH net-next 00/10] DSA unicast filtering
Thread-Index: AQHYLmnKbqJ8uFqvo0eudldhc5/zKaysey2AgAArNgA=
Date:   Wed, 2 Mar 2022 22:05:21 +0000
Message-ID: <20220302220520.z34hk3nsn5njw2z4@skbuf>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
 <8b65b656-bf65-7fa5-f1f2-72429708cf41@gmail.com>
In-Reply-To: <8b65b656-bf65-7fa5-f1f2-72429708cf41@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c18d3c62-d459-437d-8d45-08d9fc98beba
x-ms-traffictypediagnostic: HE1PR0402MB3418:EE_
x-microsoft-antispam-prvs: <HE1PR0402MB3418055E91F13D03035B707FE0039@HE1PR0402MB3418.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1b+Uw46oVutNifEr3Ot8nWk64M0w1PMApAKqtqP5ZfL9IhAcVybT1mYOsJoACYnbaIkGxbq9TJM1Zg/madd07lSRJw54iOnHTsMM8LfYN+Sxa8itas/alv8SV5IQt+tMhK0iv2rTKpGGVM+hieRptPl5TYGOXuK+zy67Ku+2VZVAfcKvfqZUWT1XzfStva6tcOQz30ZvarJarrrsxbhI6tDwpHHTOQpYXj5GAeYmShQ6hPBGMvsObmg8cMT1wLgMXY7HcnMsbl5JGq4CjBmj/gp3FyqYPn+f2iAjEinYoJNRJqeOfhtKIOaomp/asQJUnsTFtWWzarYoHGZfxaLmTRpZHjhdcMuUySKNT95sodXfXpAt5yUw0cu+FX+ocopQc0QHjNP1+RILfueQHBQ4Wl/e093BhYTy8ukHvfKVI4wveC9cm4sykBRHrFkY/TOf3krLullj66sZCBubpvjzB7/Xt5MArY08NYW6FZ3vwweFV6QRCoxZMzDWCCQQ0wnJll2CA0IMmBYz4kkLEZRD84t9tAhfgJaWAbqYYPYMoM3+9ps2tES3sG6pfyX2gpJxVDQFnBufysJAMfmpOeV12DaAq3cOOCBFg3PfaNHHSN8beE+4TifZhQ0Dpw8sNl0KRveZ4umPQOy9gGav9O30SxVa3xpdFKNxrJIloH2W6xphjPKW4wohS1Tof6RfdZwdyY8bmvD/90kIZE+1USRXN6mUCI1MWsWROO+dJgnT5wkRIOudSwXc3xrCY9mZMH3tsmHkl8NpTCBbat/6AIJHp8czIc7FWmqmFvReqj9IySo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(76116006)(38070700005)(4326008)(8676002)(66946007)(66476007)(26005)(66556008)(64756008)(38100700002)(66446008)(186003)(83380400001)(1076003)(86362001)(44832011)(8936002)(7416002)(122000001)(71200400001)(5660300002)(6506007)(6512007)(53546011)(9686003)(6916009)(33716001)(54906003)(498600001)(6486002)(966005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8RASu8qa5NPt+h+ZcTMXekmuPbcNrg33r83hqR/slN8s3sf3APrDFY+c5ToP?=
 =?us-ascii?Q?IPq+Rx2/gLeTrC4MaWgas5Giu3v8utHXlHY6Rmyel22gsRmUx+P+9kV4eunX?=
 =?us-ascii?Q?7SMrUGtaw8Wm/b6+SamiNE5h3qSUF7OHOk8dP0MMt0CArOJVY8KBYmnkiDbO?=
 =?us-ascii?Q?BxNdeaSfH5D9Hrh1jdkdKXzW0jvqONuA+qtwFrV/L2gD+HcX+KxB9hBH3lBL?=
 =?us-ascii?Q?gCindIVpURU0IqYH95zZndZJ08JM0mBB0oeyaM0z9oALyvSUWw7KZpOvwufO?=
 =?us-ascii?Q?4VLKGSV39fBiWNs0nTBtkGqlc4UwOCZVl6GJFpbtW7BSJ+VXUYrkCo7ihU3N?=
 =?us-ascii?Q?0G09YQMl3hWsPs0a7mUfwMXFWm1lrKQCxrRaL8hOzbo585c8Za570Ns16vtN?=
 =?us-ascii?Q?ZyBohoNmyfSwjfVSkAjbpxgRJootsHxn4Kk6zxJ7ZFYvg8dlH2023ESr5M/g?=
 =?us-ascii?Q?20hbIB7C3xHPBx8RdRnros2LoaSyhYZZ6q4+vEuDYqjwU7J2PTr8czAAdH+0?=
 =?us-ascii?Q?+d29FRSGZ7r4gJZ44y9GnCiU8XTEB8Av97z3cZHyh5biA11q5ymNTjIFq5QF?=
 =?us-ascii?Q?aShmy95NUubIOcQ05ONzmsDJV5BnF62utwbkCnrzfolkwyDjeFqcYeNmfC/m?=
 =?us-ascii?Q?BkVsP2NNCi+9ddpjNH+yeSdRLxE1b5QApfvIqBb/Oz9FDNAUdst5oQH2wuCT?=
 =?us-ascii?Q?c1+DQoi+HApwZulfK/WPUru9bt+zhG1JkEp5f9+QKfbBc6tJ1vsKGPdn5CLJ?=
 =?us-ascii?Q?vn9bNRlYAA5OCv9uPWE0aXRUxhFwmq18qcBHhfBTBiHJtyBcWmKjGDF3f+e2?=
 =?us-ascii?Q?uOYfdCx5AEDC472RT4tvPOb3QhVTGpMvGP6mVJooTDXQYDAnBLN9o2vmyBAl?=
 =?us-ascii?Q?iF7bedVbVru3yvqcrfuIx/jP7f8OQSfsqoFhc2+4GRjZiwrFE1xoUF+UStQD?=
 =?us-ascii?Q?A0ff63sskekTlWqRISNieN3bL/0oJUN8uWe7Zbnit+4GNHzWg4yqDbjQ7SNi?=
 =?us-ascii?Q?t2ODq4BzxYgLLJ48x5M/cjioPfBvN5hA7XdMmYQ04d9lg3ShMMM7jHxY+bdO?=
 =?us-ascii?Q?HBG8nPYIeAz0N7v1CJ51k9ZkoqYq7htgqt6SyIcSm/w1a9kYzYOplSrNJ39e?=
 =?us-ascii?Q?ttJ4EebXJ1StEeIfwaDNIiFEg34jkdwh2EI4P+mPBPfTaeVnTsZBx+rkRXKk?=
 =?us-ascii?Q?uOPS9I/6rw+NJkfQmzZWk0rKsLeqquD4+q/qFn4baRJT849kun1Rd0lFovLC?=
 =?us-ascii?Q?MHk5vXsL51C96sYCq+dLMgN+w48rjzPelTQkLsuL6sIihRfEYTpXfvyQChQM?=
 =?us-ascii?Q?IAbhdvqgnD8u8pogrAQJ4A9ZMCIvadWifW/j5VzNFu0rmPloo1J0j9BLAW6n?=
 =?us-ascii?Q?4ipT9ZWs72if4B3MHHnkCsU8LOFRNdkw1DWEcK5j7ttkjLMGiGQb84aVfc9p?=
 =?us-ascii?Q?/z8auW+pw+5H18o5Qy77vhiyjDQNqAZNhfiBhEUUgzU0fHY1RNUJh3Hmdnl6?=
 =?us-ascii?Q?+toUiC96tQrNsG7I8Ng6swEkXIYzv7YyALb6C7yTXGnc5Gz9nP/jmMdSTYi3?=
 =?us-ascii?Q?a30k670ydeRmzqpJKSUtwSiC+sLWRoGhz1SLvdCDW3TQPGSU3FeTGGZksoSI?=
 =?us-ascii?Q?kICd6PrXYr8sBy8ekfpNsJ0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B147E24586EA6D4BACDB07CC486D86DE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18d3c62-d459-437d-8d45-08d9fc98beba
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 22:05:21.3823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UwaGsi44kPacLn1MDSGpXrYFS7V598bjG+g/KmeO2r4SbSAsL1ZgkeMlMMkgpHY/AGQzwh+lVB3sto+plBkAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3418
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Mar 02, 2022 at 11:30:41AM -0800, Florian Fainelli wrote:
> Hi Vladimir,
>=20
> On 3/2/2022 11:14 AM, Vladimir Oltean wrote:
> > This series doesn't attempt anything extremely brave, it just changes
> > the way in which standalone ports which support FDB isolation work.
> >=20
> > Up until now, DSA has recommended that switch drivers configure
> > standalone ports in a separate VID/FID with learning disabled, and with
> > the CPU port as the only destination, reached trivially via flooding.
> > That works, except that standalone ports will deliver all packets to th=
e
> > CPU. We can leverage the hardware FDB as a MAC DA filter, and disable
> > flooding towards the CPU port, to force the dropping of packets with
> > unknown MAC DA.
> >=20
> > We handle port promiscuity by re-enabling flooding towards the CPU port=
.
> > This is relevant because the bridge puts its automatic (learning +
> > flooding) ports in promiscuous mode, and this makes some things work
> > automagically, like for example bridging with a foreign interface.
> > We don't delve yet into the territory of managing CPU flooding more
> > aggressively while under a bridge.
> >=20
> > The only switch driver that benefits from this work right now is the
> > NXP LS1028A switch (felix). The others need to implement FDB isolation
> > first, before DSA is going to install entries to the port's standalone
> > database. Otherwise, these entries might collide with bridge FDB/MDB
> > entries.
> >=20
> > This work was done mainly to have all the required features in place
> > before somebody starts seriously architecting DSA support for multiple
> > CPU ports. Otherwise it is much more difficult to bolt these features o=
n
> > top of multiple CPU ports.
>=20
> Thanks a lot for submitting this, really happy to see a solution being
> brought upstream. I will be reviewing this in more details later on, but
> from where I left a few years ago, the two challenges that I had are
> outlined below, and I believe we have not quite addressed them yet:
>=20
> - for switches that implement global VLAN filtering, upper VLAN interface=
s
> on top of standalone ports would require programming FDB and MDB entries
> with the appropriate VLAN ID, however there is no such tracking today
> AFAICT, so we are not yet solving those use cases yet, right?

Yes, here we're entering "brave" territory. With this patch set we have:

static inline bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
{
	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
	       !ds->needs_standalone_vlan_filtering;
}

so yes, the use cases you mention are disqualified. To remove that
restriction, every time our .ndo_vlan_rx_add_vid is called, we'd need to
walk over our address lists (kept by struct net_device :: uc and mc),
and replay them in the newly added VLAN. This is the easy part; the
harder part is that we'd need to keep one more list of standalone VLANs
added on a port, in order to do the reverse - every time dsa_slave_sync_uc(=
)
is called, we program that address not only in VID 0, but also in all
VIDs from the list of standalone VLANs on that port. It might be
possible to use vlan_for_each() for this. In any case it is incremental
complexity which I've not yet added.

This solution would install more host FDB entries than needed - the
Cartesian product of RX VLANs and secondary MAC addresses. I'm ok with
that, but there's also Ivan Khoronzhuk's patch series for Independent
Virtual Device Filtering (IVDF), which basically annotates each MAC
address from struct net_device with a VID. That one really seems
excessive, at this stage, to me.

> - what if the switch does not support FDB/MDB isolation, what would be ou=
r
> options here? As you might remember from a few months ago, the Broadcom
> roboswitch do not have any isolation, but what they can do is internally =
tag
> Ethernet frames with two VLAN tags, an that may be used as a form of
> isolation

The central thing I had in mind is that DSA doesn't really enforce that
packets are sent as 'control traffic'. The users of tag_8021q are the
closest example to me - routing towards the correct egress port is done
through a VID added to the packet, later stripped. The essential
characteristic of a packet sent by a DSA tagger as a 'data packet' is
that the FDB lookup is unavoidable.

The reason why I added FDB isolation as a requirement is this:

   +--------------------+
   |                    |
   | +------+ +------+  |
   | | swp0 | | swp1 |  |
   +-+------+-+------+--+
        |        |
        +--------+

swp0 has 192.168.100.1/24, swp3 has 192.168.100.2/24, they are in
different net namespaces or vrfs and want to ping each other.

Without FDB isolation, the mantra is that DSA will keep the FDB devoid
of swp0's and swp1's MAC addresses. Flooding is enabled on all ports and
the CPU port, and learning is disabled.

With FDB isolation and this patch series, DSA will install the MAC
address of swp0 on the CPU port in swp0's private database, and the
address of swp1 on the CPU port in swp1's private database. It is the
driver's responsibility to then distinguish between those 2 databases
the best it can. VID, FID, EFID, you name it.

When swp0 sends a packet to swp1, it has swp0's MAC SA and swp1's MAC DA.
If DSA doesn't know in the general sense that there will be no FDB lookup,
then the best it can do is to ensure that swp0's and swp1's address are
at least not in the same database. Because otherwise, the CPU port will
see a packet with swp1's MAC DA, but the destination for that address is
the CPU port =3D> drop.

Sadly I don't know if this scenario is hypothetical or not.
With sja1105, it wasn't until I converted it to isolate the FDBs
(packets are sent as 'data traffic', but every standalone port has a
different pvid, and packets sent from the CPU follow the egress port's
pvid). If there are more which I haven't caught (there are many DSA
drivers which I don't know very well), this would break them.
So I wanted to be on the conservative side, but I suppose I could be
convinced otherwise.

Please note that there is hope. On ocelot, standalone ports share the
same pvid of 0, and yet it still declares FDB isolation. This is because
traffic sent over the NPI port (using the "ocelot" tagger) bypasses the
FDB lookup and it will always reach its intended destination. And using
the "ocelot-8021q" tagger, packets hit a VCAP IS2 TCAM rule on the
ingress of the CPU port that redirects them to the desired egress port,
before the packet processing reaches the VLAN table.

As for the Roboswitch discussion:
https://lore.kernel.org/all/04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufs=
en.dk/T/#mb2c185003d8a58c691918e056cf09fd0ef6d1bd0

that was mainly about TX forwarding offload, i.o.w. "how to use the FDB
lookup of data plane packets to your benefit, instead of against you".
In this context of FDB isolation I think it would be more beneficial to
you to keep sending control packets, if those bypass the FDB.

It is the bridge TX forwarding offload that I don't see how you could do.

My takeaway from that discussion is that the IMP port processes the VID
from the packet if VLAN awareness is turned on globally, and probably
reverts to a single default VID otherwise.

So even though you could arrange for each VLAN-unaware bridge to have a
driver-private port pvid, and your tagger could wrap packets in an outer
VLAN tag with this value, the fundamental problem seems to be that VLAN
awareness is global in the first place. So either your user ports can
offload a VLAN-unaware bridge, case in which the IMP can't see the VID
from the packets, or the IMP can see the VID from the packets, but you
can't offload a VLAN-unaware bridge.

In this case and if I have understood all the information, I think what
you can do is deny multiple bridges (regardless of VLAN awareness),
configure standalone ports to use pvid 0 or 4095 (and different from the
pvid of VLAN-unaware bridge ports) and just declare that you support FDB
isolation.=
