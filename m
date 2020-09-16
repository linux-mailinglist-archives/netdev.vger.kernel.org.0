Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EE826CCC3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgIPUtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgIPRAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:00:50 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C3CC0A889B
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1p0uIZoa9T/wQWBZtb/MBvI6U75JKSDH7rN/5CKFC9k70cUjyeq2yEf8H1QmF/cdKgoSwPOEgGJS/oQMcjipolGEpEXsAfyx24DUr0uL2oz3UdjpgRS/EZazDDA5Yx/IAsyyA9iDvPS38QJnN2cXUbbecL5U5pv/q8t3iU7vYARKiBX22IE2bn+U90WvRp8Wyv0xLTWb3Dz0xyOJHhkGgrTK+Ns3uxiVBfigjMu7rtVF+X3bhN0C/XtNIw9T7tz4qknWtH4OT5ukGC/hb72+zVmChUnYHKMuwU9X2W60g5rInI60NVvdGIMJBswcSAmLG+uXcxvshgzYbrfMJKjjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZHAaVx43InUKaQrHzMqsjLq0WAqCVjH2bFLeUzl6Zc=;
 b=HoQZxuRY8LkTHRtTPMYiewQc2QbL3H2uPhpNRmDywiWnf4IHm2oWZb0RLX/uJLSIAAKwis/37VqOW7s7uIDKRklvrEbIFRPn+nHZAqA4A8w/4UdIaXMmEQaGY+IVZ6Fup1dL3EhBydVSJgRJF5aTf8Plf7W0WWhjG8g8bI7kRN9Db47dyqvUlp4lPT5UeXBrtmdnyTQwn3pFlZgh5IRSCIBBXGeNNV99RC6oJvxgWl1Ys9v3VW3vjhKh2VK2nm9brnjfKMVGHNPVTcH+DqTxjN2LIqhdRxRDbHy0fLSNcGJY2Q6R1R7QRO1BVsg3mYgqf7Er7M5oAcMd+n8YC3YEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZHAaVx43InUKaQrHzMqsjLq0WAqCVjH2bFLeUzl6Zc=;
 b=O5m8jXv3p7Y/7hUtXbxP5xOsYQsgadj07hnz/8PxYXixLF4mqA6DSamzRYmqLejchyLj7WRGSjrcwUgu/CQnQgQsTZuhP5MBBbGi1qAJTDYxfHh28luU+M/s24VS+s+VSaIwloatpn7u4Y9XbzlaATfyj6HLFRvu6Hgy1+ImzzQ=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB3959.eurprd04.prod.outlook.com (2603:10a6:209:4f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 11:43:05 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%7]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 11:43:05 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Thread-Topic: [PATCH 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Thread-Index: AQHWh1du5aIDBW7z4EaIAdM1IwookKlh8r+AgAk7fcA=
Date:   Wed, 16 Sep 2020 11:43:05 +0000
Message-ID: <AM7PR04MB6885CD2526DA6A647D4B53A7F8210@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
        <20200910093835.24317-6-yangbo.lu@nxp.com>
 <20200910074315.59771a9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910074315.59771a9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70148cb5-cccd-46c4-bbeb-08d85a35ad0c
x-ms-traffictypediagnostic: AM6PR04MB3959:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB39596B275C6064D3E584CAF9F8210@AM6PR04MB3959.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 82qwWs9JXj7d49CypGHsjHSq+6jZrTK2hudaYsPt/gmtfqHgEsKomm47PvorqfdKrzt6FHF7foViUCXYCCDJ3ZoIkChS3e61NTDlxl7bxWPgtyFXxzbWFutlWbWqYxdAf/DLtdgJ5xN0hQ1A3zvVcr8frNi0nskPD69G2E6ETUqBjviquPiVe08MsbfFTg/jYQhA1JxHb+64FOh1Ldh5Nr+7KCag3l5aSCrxfrRL0KwWfEu0Ps9dWwAzQqOamQC7TXbZ8pStWJM/CP27Jk/pepLSWSZ8lYJPQHqSpeQeL0uDci34gILGkHEpAMtgMH51PdQ6ai+6PoefHJFA4Br22w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(33656002)(186003)(52536014)(71200400001)(5660300002)(86362001)(53546011)(8936002)(6506007)(66556008)(4326008)(64756008)(54906003)(76116006)(66446008)(66946007)(66476007)(7696005)(478600001)(8676002)(83380400001)(26005)(6916009)(316002)(55016002)(9686003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DToxoyE0HoPiMIzZxsch/3BZmGigNSKg2LRd7SrzZ/M+7F4OgI7AKD3XEqGddaZ5ci8eTXOiwv0Ah5JZSKbCgIaGW9s0HJ4hZWACJrlASjj6VqfOuMuU9cnt0a9rosUmFrzm0yBiwDNX4Q7I40uidfLJmhDrf7KBIJanu1qsIGpBRee4XbNey4ydZomWov6RKGiq3veMm3eywDmST7UU3G5gv41ghCo2ok3grqP+0aOygczXvQ7WO0ugV24yckUyUl/gBGUo+CUbZ65kzS9uMU5FPvfYjmIaY/utHKqRzUfbacGjv+WpITcLccdr1knXtrqAbqAPVCJYNImQHOKiHp9tdSkZGkwsiUIowMXdLsqjOL/C6SgDJy4qenwsXPuOR9wrO2Wn2VEQWdRfUG8hVMCuKlSfb25LpKcruXzNEhqp784YgCE/J3vJdGPmXE2yXtaizcPk9fWzbkR+QA6l0pUQX5Q3p4sJDA2kGOIshsR3OQF0QASWkrkGV+N/2gHnhFloj9Pmt3iJo5+57I/QhJcUeEj5JYTmpEB7UrOcijjpbwQSx35Gc8P4qoOrTbSKf61CMPCCDy2YOg6bPILep+yxvpMr2cEbWeEFTFzVf9+pLQ2xr/Vb1v8RGOCMvDg7wnzc34vLoDkkSqcG5+hmuQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70148cb5-cccd-46c4-bbeb-08d85a35ad0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 11:43:05.4570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yu4FG5uUj+mkLRGLqND5b8/+YWw5nmym493y4eEWEbLqM8lYEHwsfX5+Th9MHMWG3GWshxETD7Enc0tJnOkboQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB3959
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 10, 2020 10:43 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>; Ioana
> Ciornei <ioana.ciornei@nxp.com>; Ioana Ciocoi Radulescu
> <ruxandra.radulescu@nxp.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH 5/5] dpaa2-eth: support PTP Sync packet one-step
> timestamping
>=20
> On Thu, 10 Sep 2020 17:38:35 +0800 Yangbo Lu wrote:
> > This patch is to add PTP sync packet one-step timestamping support.
> > Before egress, one-step timestamping enablement needs,
> >
> > - Enabling timestamp and FAS (Frame Annotation Status) in
> >   dpni buffer layout.
> >
> > - Write timestamp to frame annotation and set PTP bit in
> >   FAS to mark as one-step timestamping event.
> >
> > - Enabling one-step timestamping by dpni_set_single_step_cfg()
> >   API, with offset provided to insert correction time on frame.
> >   The offset must respect all MAC headers, VLAN tags and other
> >   protocol headers accordingly. The correction field update can
> >   consider delays up to one second. So PTP frame needs to be
> >   filtered and parsed, and written timestamp into Sync frame
> >   originTimestamp field.
> >
> > The operation of API dpni_set_single_step_cfg() has to be done
> > when no one-step timestamping frames are in flight. So we have
> > to make sure the last one-step timestamping frame has already
> > been transmitted on hardware before starting to send the current
> > one. The resolution is,
> >
> > - Utilize skb->cb[0] to mark timestamping request per packet.
> >   If it is one-step timestamping PTP sync packet, queue to skb queue.
> >   If not, transmit immediately.
> >
> > - Schedule a work to transmit skbs in skb queue.
> >
> > - mutex lock is used to ensure the last one-step timestamping packet
> >   has already been transmitted on hardware through TX confirmation
> queue
> >   before transmitting current packet.
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
>=20
> This doesn't build on 32bit:
>=20
> ERROR: modpost: "__udivdi3"
> [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!
> ERROR: modpost: "__umoddi3"
> [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!

Will fix by using do_div in next version. Thanks.
