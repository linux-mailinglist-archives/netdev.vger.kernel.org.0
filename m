Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB39D143EB1
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgAUN46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:56:58 -0500
Received: from mail-mw2nam12on2091.outbound.protection.outlook.com ([40.107.244.91]:35489
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgAUN46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 08:56:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXfzBf4BzLBOXtWe7jcHwo67xfl7EHsNbvyqyBpulTemFHAk9CcRWaahqNVF6baXbTqN3n8/kEMppFES8BXpBNrQtfolJ/15hszxd6cAurWxRJz7jFhemvuf68VKzeBQT6StcOXBg1aaKX0hu018fhAJ8mMzDZiKkrZD4t3DdDHyxkooKdRHLXrUJtqWzDQZfNcMSe4W95X1P0+BcM/1MfoOtt1LcId+Xdksy0otEsPdwBJ+DB9mxion5W506jFGn/smy/Blnhpfq++Wor2ubLy4BZe6UJKdecXP8c5t0XaLBVvHNEYLOncxa8+il8nh8Zkyxa6tNi1ZgairqY5xBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bL2sQa1VdnCkUucBoIum7Iay7pnEvIETtiwwP+lSw4g=;
 b=RgH+uHmwxPF5g0sbrkHmg4rIqDB3oO/g6H9vtmMfPo+LxZsRJNitOcwAxsMUoVuWtxVVhXNzneXxpbmTOV6I+zAnkrPC5yGC3umsN4yeF5G5W8SmQmuEgDNgwG+AYiAZAd7peu2PYld8w3qYKHtEUy2x4vzal6I/nFP7iTE0yWMu/rms8Rhh/3OkDTYtuAQTb0yi1nEQiTCb9dJ++vxqH+2EvZMvhiUyVVf8MHHjQYWnUTrdyTyw+iSOY7mwEu2lwDaTihp3vWkGIvU61EruJlTuJJOoN6+4W4p3UCZUTuBPS3kwAtH6JwdSW+0wUZzCyqREJkhWCF662AQCZl1cKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bL2sQa1VdnCkUucBoIum7Iay7pnEvIETtiwwP+lSw4g=;
 b=OYRWzbctYN7yUnTDDGK3py71p/PaFDkhF4SoCxAb5kxTstaKhCLfCq6XkZcOIcBjynQI6t3KQ7AZh8QggJEThxtCG2RbNdooSQTmrd7U9/44d+itAZaMztWI+BzKlZJ5yjRL+VceYzZb2D4HzjyMIWpD579Kx2Bp8/Z6w+G5M1A=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1261.namprd21.prod.outlook.com (20.179.21.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Tue, 21 Jan 2020 13:56:55 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423%6]) with mapi id 15.20.2686.007; Tue, 21 Jan 2020
 13:56:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
Thread-Topic: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
Thread-Index: AQHVz+AvfPSXwM4tmU6pTPdgXF0O8qf05LQAgABAioA=
Date:   Tue, 21 Jan 2020 13:56:54 +0000
Message-ID: <MN2PR21MB1375A2A91EDBD8E63CBDA2F4CA0D0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579558957-62496-1-git-send-email-haiyangz@microsoft.com>
        <1579558957-62496-2-git-send-email-haiyangz@microsoft.com>
 <20200121.110454.2077433904156411260.davem@davemloft.net>
In-Reply-To: <20200121.110454.2077433904156411260.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-21T13:56:52.7021036Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1edcef48-8851-44c9-ae5e-6414768f3a20;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 62251a07-59da-4cb8-578c-08d79e79c648
x-ms-traffictypediagnostic: MN2PR21MB1261:|MN2PR21MB1261:|MN2PR21MB1261:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB12612A75E64B7F1E6CF1B4E7CA0D0@MN2PR21MB1261.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(189003)(199004)(54906003)(2906002)(9686003)(55016002)(6916009)(478600001)(316002)(7696005)(8990500004)(52536014)(10290500003)(5660300002)(86362001)(76116006)(66476007)(66556008)(66446008)(66946007)(64756008)(81166006)(53546011)(4326008)(71200400001)(33656002)(81156014)(186003)(8676002)(6506007)(8936002)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1261;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h24kewKPqlmONNw9Rpd/ZUQzAfBXYtI31/K5averIUBPWo8jLCYBIitTNrzuNV8U2O/pyXr8t0qF+pgXKh9nZYo3dH3S6Ow2e5KUgUwWnjQyBt50FvnYkJeZYyAfdwB3p7fBeAN3HtvdEf56CRzp2OkL9f4o3iLz7NixW6RzICdO/BVlDBZaybspHmVOGqsYI0RDlA/RtCXewyNIVhU8N4iNiYMmEWMahQVuFGJ2q9yjbii5qwlmxTi3O1+y7cEFcW3PFXcqAuEZzbSZqkrhqzADVsi2+jdbDcPW4n7zBpUf7FJS5DCLDbeQLyfjGDydOXBwFKiPoc0pPwjdwbwfIIDWKIAUOQ9T3giqc5o+MzRIjZqkZPZ3PmlqLK9ngtlCeoW/a6sXvymRPLbnJEbLBxvVzrvdEgLP0I7dNwQncBmPj5BgaH9d/aDsknWdnHcO
x-ms-exchange-antispam-messagedata: 4+0tZg99rHbynJ8c/Y+qbeh3TdQ46FszD4Eo9n1cJdZZULSh83Ay54ozZUlcLGoPbNsx9HWul2MphQTTybUDgGr6RqThcdI5hAcLAOSrgnL8loLQvC3g5Un92jd+llEV4h6JFDqhzU1ElWqlbiFzzw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62251a07-59da-4cb8-578c-08d79e79c648
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 13:56:54.8986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gPXMc1erQtulrFKgXgVH0/QrEauDW/G+Cj1prpcjjLjy+3HvU40C91pNLFpWU8i4tEt8JLtAltRY/xuVw64j6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Tuesday, January 21, 2020 5:05 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon, 20 Jan 2020 14:22:36 -0800
>=20
> > +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvc=
han,
> > +		   struct xdp_buff *xdp)
> > +{
> > +	struct page *page =3D NULL;
> > +	void *data =3D nvchan->rsc.data[0];
> > +	u32 len =3D nvchan->rsc.len[0];
> > +	struct bpf_prog *prog;
> > +	u32 act =3D XDP_PASS;
>=20
> Please use reverse christmas tree ordering of local variables.
>=20
> > +	xdp->data_hard_start =3D page_address(page);
> > +	xdp->data =3D xdp->data_hard_start + NETVSC_XDP_HDRM;
> > +	xdp_set_data_meta_invalid(xdp);
> > +	xdp->data_end =3D xdp->data + len;
> > +	xdp->rxq =3D &nvchan->xdp_rxq;
> > +	xdp->handle =3D 0;
> > +
> > +	memcpy(xdp->data, data, len);
>=20
> Why can't the program run directly on nvchan->rsc.data[0]?
>=20
> This data copy defeats the whole performance gain of using XDP.

Sure I will update this, and the var order.

Thanks
- Haiyang
