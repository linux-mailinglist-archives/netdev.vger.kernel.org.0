Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FFC8CA62
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 06:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfHNE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 00:28:43 -0400
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:61552
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725262AbfHNE2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 00:28:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ee8Bo916M3K08detDGTGpuXRYG4lS/GifUuXma/V084yp7Yz/XOMBH0Q2GO9SSjB8qFwazx79vrJloaJPSxgprkQX84MmKPE+7P7YHOo5Uw7ocKKDsE2to+LobBETQdcX3ikPeWf69kvA0lST9WxvMH8J2WXBALSpoxMaTYFf801bUewcn051K3lWMq+M2QR8wmH4u1+SavuY0PNgjYczGLGE/D8Lz9c1vQx14chz4M++BF50O0/VKU4B77UL4yg3J5+I9PMZ6kgQ2pprzstP97+M+NZePxW/Na4sdB4QUgT7L53XQ8fc6OTaGEDRaZ7zFtIVz7geENhOSn0rq7EWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjqQSrsHMiMq+9J7qZRIRB/yCN9LoCKIdt8/7BAVwHE=;
 b=Dd5Y8t3vr1Ivuo7sR9nhCnV0oLGAM0jR0rmWzSAaQSwC4cQiHav5RYFNVazK6jyWmxbOylJyrfvtHbP9jg1J4re2PeRyZ4/e3Ct8fmzwJ90TqM8tD/P45JHwZQnLkteEhQAYq/Az0Zf/czquCUZUXeLnHGPHtub0NQ1n79gOI9sm3uwaQd4NPztjqM0RgkRPnzhEHF0DgvYaykA6rZztByvQhuotG9gbZEcgNn911fGAEyVMHMt438szzg1JnpuUnboycbZQrdc5C88tsg5i832FHzGjnYIpHGxZZb6Pp/wdxDihM4Pn+6JmRI5g7ZdFDIpbhVbBVxFqvPV2LU3fig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjqQSrsHMiMq+9J7qZRIRB/yCN9LoCKIdt8/7BAVwHE=;
 b=fTo0sXTk+njudttOA9BQADM+i7NFgp5o23vTBC/NU+2J+H8h9vdGfXsucTCfsil5Rlc0nMqKZZRlTNVzV0h6DDj7ISNmTXp8CV7pYtyxGz+EjkCM/tzmOk9DfIcTF+v66y3yqqYz5DcEEnKtMVLB8YICT0KwnboCiELu66HRRxM=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2576.eurprd04.prod.outlook.com (10.168.65.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 04:28:39 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2157.022; Wed, 14 Aug
 2019 04:28:39 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Topic: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Index: AQHVUPsbgCvvMJE2AE2KMlSf5gLebab3cdsAgADjDBCAAMMRAIAA8IOQ
Date:   Wed, 14 Aug 2019 04:28:38 +0000
Message-ID: <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813134236.GG15047@lunn.ch>
In-Reply-To: <20190813134236.GG15047@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e23f67f-d122-476f-36a8-08d7206fe15e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0401MB2576;
x-ms-traffictypediagnostic: VI1PR0401MB2576:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0401MB257616CAAD7A915555CD77F6F8AD0@VI1PR0401MB2576.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(199004)(53754006)(13464003)(189003)(71190400001)(229853002)(66556008)(71200400001)(110136005)(478600001)(53936002)(81166006)(316002)(81156014)(5660300002)(76116006)(54906003)(6306002)(66446008)(9686003)(66476007)(66946007)(64756008)(99286004)(55016002)(8936002)(6436002)(2906002)(6246003)(52536014)(86362001)(33656002)(4326008)(102836004)(256004)(14454004)(305945005)(26005)(7736002)(186003)(74316002)(11346002)(966005)(45080400002)(6506007)(25786009)(7696005)(3846002)(76176011)(8676002)(66066001)(6116002)(476003)(446003)(486006)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2576;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KTkLeLTVGVxg48ZU0NLdihgAMo8Skrdiyc5nP9XwO2C4eOaXzfXYOB49pFMfkuMKyKmnpGR0AWKj0a9L2JAqFl3W0Y1Z/7LYnO6LEx7D4ZfxVVBbgiqQkdATXo22WGBdrzmdEW9sgvQyGYdjVXduKMwixBOmsAoGGFOJEvMoNcmdz+aZhRzh70E1UTxEEWtZJNix5iD4bFzfC50iMONnqf7aDLptIJgODpYgH1JghOUf4ePtjN127zuiUUax5sHH0T2UrwzSOwkC2KKoVZXDIfxgAUK/bofnVBuwzBiUitAH5I3wgwsJVW5eno7UaDYcv2FfHT5wHnllhREDVQA5cp2y9ZeZgbdaMCXrSFAZTvPZB5gyUL+TRioF4P7C0WcAXqAfRX/zKi4/fNTzSwEAnP2yLo2f1EPME7CnSbUWnkA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e23f67f-d122-476f-36a8-08d7206fe15e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 04:28:38.9651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nTn/eJsRM8tDwjG9a1qoFjYuU4cOHfK8N4BwLJt70nal3OHwEvEZykOBgnElKLOIGHVdlsGX2ui6gxwWF4SPUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Allan,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, August 13, 2019 9:43 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: Allan W. Nielsen <allan.nielsen@microchip.com>; netdev@vger.kernel.or=
g;
> David S . Miller <davem@davemloft.net>; Alexandre Belloni
> <alexandre.belloni@bootlin.com>; Microchip Linux Driver Support
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
>=20
> On Tue, Aug 13, 2019 at 02:12:47AM +0000, Y.b. Lu wrote:
> > Hi Allan,
> >
> > > -----Original Message-----
> > > From: Allan W. Nielsen <allan.nielsen@microchip.com>
> > > Sent: Monday, August 12, 2019 8:32 PM
> > > To: Y.b. Lu <yangbo.lu@nxp.com>
> > > Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> > > Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux
> > > Driver Support <UNGLinuxDriver@microchip.com>
> > > Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
> > >
> > > The 08/12/2019 18:48, Yangbo Lu wrote:
> > > > The trap action should be copying the frame to CPU and dropping it
> > > > for forwarding, but current setting was just copying frame to CPU.
> > >
> > > Are there any actions which do a "copy-to-cpu" and still forward the
> > > frame in HW?
> >
> > [Y.b. Lu] We're using Felix switch whose code hadn't been accepted by
> upstream.
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> >
> hwork.ozlabs.org%2Fproject%2Fnetdev%2Flist%2F%3Fseries%3D115399%26s
> tat
> >
> e%3D*&amp;data=3D02%7C01%7Cyangbo.lu%40nxp.com%7Cfbf7f74803d040f1
> b55608d
> >
> 71ff41b17%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6370130
> 05597107
> >
> 485&amp;sdata=3DxPGDbm2XtDI0L7F5A2xLhDDtctbeqB0MFByCAlgAtJ4%3D&a
> mp;reser
> > ved=3D0
> >
> > I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU through etype
> 0x88f7.
>=20
> Is this the correct way to handle PTP for this switch? For other switches=
 we
> don't need such traps. The switch itself identifies PTP frames and forwar=
ds
> them to the CPU so it can process them.
>=20
> I'm just wondering if your general approach is wrong?

[Y.b. Lu] PTP messages over Ethernet will use two multicast addresses.
01-80-C2-00-00-0E for peer delay messages.
01-1B-19-00-00-00 for other messages.

But only 01-80-C2-00-00-0E could be handled by hardware filter for BPDU fra=
mes (01-80-C2-00-00-0x).
For PTP messages handling, trapping them to CPU through VCAP IS2 is the sug=
gested way by Ocelot/Felix.

I have a question since you are experts.
For other switches, whether they are always trapping PTP messages to CPU?
Is there any common method in linux to configure switch to select trapping =
or just forwarding PTP messages?

Like Allan's comments in new version patch. I have no idea.
https://patchwork.ozlabs.org/patch/1145988/

Thanks.

>=20
>     Andrew
