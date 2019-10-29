Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6CE92CD
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 23:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfJ2WJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 18:09:10 -0400
Received: from mail-eopbgr730109.outbound.protection.outlook.com ([40.107.73.109]:59744
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbfJ2WJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 18:09:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMQEN+XxrIECukHOYE0vwmCGK7CaB4HakJEVy1aWiT+yaxwlw28LMeRXTcuxHfp94S1EEZJqcEAThZy57ar4p46bVGeJZb6EFwsfega52hFAi3mv5Mc4iu48dndwL7GNHrO4Al3cB/s5S5igDY5safaVdwbvR1VPGoWIKNF5eYn1JIDwF4+7SSQdHvYTKJC4XOeOMsY8+4fw2+w5G6aJM0v/sSQWZ7SlYNZRGfSXTZO19Y4u/Hrg2dhY/D+W3tqjoEZ+EFAp4hpt0Wm+EYxay5/8r8rsaz6EwpYkWhAMFfbMmB/bX4OMaBAhi0cl2y7hPe54jjf0CiAMYqORjqTatg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3pEKDWXrdO+8hfT96YHgl6N4XpLcMDHr761fr7EeNA=;
 b=K+nSxjr3xboC9QS5NsGkjx1OkkNrQvgrMZVXm4i34gLIvcPvX+iRRZVrrIs4dRwgjFzbEcSwZNS0f94K8UuPM3hJ45r4FXEufeiNQR/zHmyT8ROVcbYZnf38krBKKaIoaSJBM/LJ0srbKhYqDUBt/a7cHvkeO0dcc+gUk9krBnDdHOhPCUZNxGvWMXrZxSHqo1H94RApA+v/7E2HFSYH7enGJCCJ7vCB6ZRs75F/hdxn5lPOaQMTiVRvGRNSLkzVq3KxOvWsW0A/1FuJnjREt4BLxx2wZXN/E4QJBtfn+msCJUD1p2fPJL4IMsz69AZlnWMuS5fbl+ehpnUlZE9WcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3pEKDWXrdO+8hfT96YHgl6N4XpLcMDHr761fr7EeNA=;
 b=OJESfwtb3OZYWx/aZq4DKrKTYrE29lmpymx6MIYnk9BkIkwFovsLg5XIuNQcKefBvbrBQokiwG+3FIlgPRKGkqJ+zABco4iwKD+rdfXDMEo5pO0ZWMcLkjmrHON5/BCkYvHCsu3rHBOb6NMtGwoGYll4SHCZ6N5L8lgwAuvWGl0=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1161.namprd21.prod.outlook.com (20.179.51.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Tue, 29 Oct 2019 22:08:26 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5ce7:b21d:15d7:cff8]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5ce7:b21d:15d7:cff8%9]) with mapi id 15.20.2408.019; Tue, 29 Oct 2019
 22:08:26 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Topic: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Index: AQHVjdOmZZw8T6TbMU+gJli1k9ewVadwkv0AgAFiizCAADb6gIAAAakQ
Date:   Tue, 29 Oct 2019 22:08:26 +0000
Message-ID: <DM6PR21MB13378821FCD94A4D342079DBCA610@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
        <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
        <20191028143322.45d81da4@cakuba.hsd1.ca.comcast.net>
        <DM6PR21MB1337547067BE5E52DFE05E20CA610@DM6PR21MB1337.namprd21.prod.outlook.com>
 <20191029145905.414f86c3@hermes.lan>
In-Reply-To: <20191029145905.414f86c3@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-29T22:08:24.7952013Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=491a4a91-0032-4b5d-bd15-6748b1043011;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 817086e3-c67f-485b-fd90-08d75cbc85e0
x-ms-traffictypediagnostic: DM6PR21MB1161:|DM6PR21MB1161:|DM6PR21MB1161:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1161C4BD5F4DDE37AD0D9D97CA610@DM6PR21MB1161.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(346002)(396003)(136003)(199004)(189003)(13464003)(2906002)(74316002)(66556008)(11346002)(478600001)(33656002)(8990500004)(25786009)(9686003)(71190400001)(53546011)(6506007)(6436002)(86362001)(76116006)(476003)(229853002)(64756008)(446003)(66476007)(4326008)(71200400001)(66066001)(7696005)(10290500003)(55016002)(66446008)(186003)(486006)(6246003)(52536014)(256004)(3846002)(26005)(81156014)(6116002)(7736002)(66946007)(6916009)(5660300002)(8936002)(305945005)(102836004)(316002)(8676002)(10090500001)(22452003)(54906003)(99286004)(14454004)(76176011)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1161;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2gEDrFa2w4U1WwPYnCwTFZoXQ0tTnfOtUvPXGK31bCaI9+mrZGu6mVhUtDzS6brVnLoMMChaC3Gu26hkrbvV6c2Bsx87iuW3yexkzx71Z1P+zA5g2pm8A9rdoJgD2H4Ia7sPA2Sf4cihB2hRCvXa+7FtwYHxyi50e0jPA7WxOBNVK08RS35qdRYZ/HUvPX3AU7mh9ok04Ug7nMNfHD7m0A3zTlHpacAFrYgdPO6Z/NAFYTJ6gEowd5tZuJArvaMjHfPTEkxWCvimZQ9XEgLY/VPp32gacOV2wL5HF+itNcer52aUyw72Gvctb6KpwTHYv4YIablCfeXis5dGAYZuUkCEdm/0pXdet1ENPo5TcXC85dpURG6c6vRHrf0Ev9q9PVdDSMC5ri4Iy+etBTptcIRelGe4o32w8Tl5nDSkBzU4r6oJFfAimpjrkucABrSz
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817086e3-c67f-485b-fd90-08d75cbc85e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 22:08:26.4841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTIfepsSy/C2q+BG45emsA4auU/qcoldIZzy0Msd6sAMNy6w1H3YYzmfiO4I5ETFI8B8fdZXRgf7FzwKR/vjtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Tuesday, October 29, 2019 5:59 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>; sashal@kernel.org;
> linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> olaf@aepfle.de; vkuznets <vkuznets@redhat.com>; davem@davemloft.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
>=20
> On Tue, 29 Oct 2019 19:17:25 +0000
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > Sent: Monday, October 28, 2019 5:33 PM
> > > To: Haiyang Zhang <haiyangz@microsoft.com>
> > > Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> > > netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> > > Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> > > <vkuznets@redhat.com>; davem@davemloft.net; linux-
> > > kernel@vger.kernel.org
> > > Subject: Re: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
> > >
> > > On Mon, 28 Oct 2019 21:07:04 +0000, Haiyang Zhang wrote:
> > > > This patch adds support of XDP in native mode for hv_netvsc driver,
> and
> > > > transparently sets the XDP program on the associated VF NIC as well=
.
> > > >
> > > > XDP program cannot run with LRO (RSC) enabled, so you need to
> disable
> > > LRO
> > > > before running XDP:
> > > >         ethtool -K eth0 lro off
> > > >
> > > > XDP actions not yet supported:
> > > >         XDP_TX, XDP_REDIRECT
> > >
> > > I don't think we want to merge support without at least XDP_TX these
> > > days..
> > Thanks for your detailed comments --
> > I'm working on the XDP_TX...
> >
> > >
> > > And without the ability to prepend headers this may be the least
> > > complete initial XDP implementation we've seen :(
> > The RNDIS packet buffer received by netvsc doesn't have a head room, bu=
t
> I'm
> > considering copy the packets to the page buffer, with a head room space
> > reserved for XDP.
>=20
>=20
> There is a small amount of headroom available by reusing the RNDIS
> header and packet space. Looks like 40 bytes or so.
Yes, I thought about the RNDIS header. But is this space sufficient?
I saw some drivers, like virtio_net gives bigger headroom: 256 bytes.

Thanks,
- Haiyang

