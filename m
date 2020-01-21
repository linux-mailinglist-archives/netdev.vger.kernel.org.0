Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B9214449E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 19:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAUSxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 13:53:31 -0500
Received: from mail-bn7nam10on2131.outbound.protection.outlook.com ([40.107.92.131]:44833
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728186AbgAUSxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 13:53:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndz0PAsRQ6aMPl13iIevxLKTmUmqY45n7IywpwQHFGOcSFZ/szwd6524NR9nOR8MQV1rUVSjakEvUS4sshtofg3paS5V3Fqo7iMzKnGM+2XuNmHbCd4S+3w0+pJYTVHtzCMrh9dz4rOSCn8birAMMRGtZ7jQCcH4CsxgKye4BOi73GdAAJJqVe7xw+m3XVlb1X0Id5B3ZOebSST5MNMn7Fau959BH5mSe6trYQbFz0odYae680Jt7Jm/LjvHtuW1YuLTP5/EQ/Pk1dYP1rX62VDZOzBGUGPxEUjpDUdosRBxJ2a01uPuv6gn4P2OrfAe5LnttEJGQf5y70nr5eRCew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVnLhKneqMBjHIYobMr2XihOEEKNLBp/SG04kIhnofg=;
 b=SnG+WzRBjQhi9EkGQTglgtYIvOOJKk9D489qQHwPiZmPuP4eoyIAEwOLSSvkKxj9N0xtI+QknyS1g3+vui6RywbGvFPs3rMN1+7nlbxT01XWmeie0BjBDozT4lm6Xr1ZiserxkBPa9SUzeU+nX12NykYlTY9qnWLULocr2v0S3HWMZfqXgo4qotdhivJEBEKCDo7AE1KZMh6FHIDCKqLfTDoZS11jRRehEO1+2IVy2flIq1/s5F0+IAxPL0VT+V2LTvee0Nnpj/O/i2p9NDn0hDLnj8FBdpCJYdnuf0VMJR+PAujz1IFtsFvamsBI9HkYWxjRrX3go1sCn2H3gnp1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVnLhKneqMBjHIYobMr2XihOEEKNLBp/SG04kIhnofg=;
 b=DAB6ttPMt8k8kEGGy+GyeatGTIOtVWwyFskamlDWmJgRnkqm7e/mF8/0a5XWsuz7JSjd5Ib7zF5KZ9x2NFis2D7Gz+pgGixFqlOwusLRIlQHgtstUfw4SLq9rCoXJs3B1h5RpkYWFlOEfIWMrksC7RVjpNrpP0g+IFTaaXljXnw=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1152.namprd21.prod.outlook.com (20.178.255.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Tue, 21 Jan 2020 18:53:28 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423%6]) with mapi id 15.20.2686.007; Tue, 21 Jan 2020
 18:53:28 +0000
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
Thread-Index: AQHVz+AvfPSXwM4tmU6pTPdgXF0O8qf05LQAgACQzTA=
Date:   Tue, 21 Jan 2020 18:53:28 +0000
Message-ID: <MN2PR21MB1375A6F208BC94CD4CFA016BCA0D0@MN2PR21MB1375.namprd21.prod.outlook.com>
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
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-21T18:53:26.6616026Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=84662424-9a5b-46b7-bab6-1577979d1d9f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd6ab8e2-d2a7-46f5-7d88-08d79ea333f3
x-ms-traffictypediagnostic: MN2PR21MB1152:|MN2PR21MB1152:|MN2PR21MB1152:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1152B3DC2D98EFA4512E50B4CA0D0@MN2PR21MB1152.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(189003)(199004)(54906003)(33656002)(2906002)(8990500004)(186003)(10290500003)(8676002)(55016002)(81156014)(9686003)(8936002)(316002)(81166006)(4326008)(478600001)(26005)(76116006)(66476007)(52536014)(66946007)(64756008)(66446008)(71200400001)(5660300002)(53546011)(66556008)(6506007)(86362001)(6916009)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1152;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qhFgS0SAZ4R3bslCMubIi7ZgU7As/VxhNpMHTssm0mrIc9fTeF8JlNpF71gfTmsEkkJ0lzPy09DMfI6uF9laBWvEJz240STkVLYgn1oWOpebA4DNNXZd8y9YsonC/oJ8bvgSaO3hTC807mdVKYVGFXcp3qGIbzYUwmYtwi84SCg9uxJLhMJSnpOr+A1RL3n7++X1V7z7pYL7UMvGHap2wHkotnUK6Qqn/GPf5Sb9g4KWYnG1cmt6Q7wRMwK4Fnwl6LITUR9CxKWx0hkJiTabNpPIPA0g7eih9jRbOeWAD9Vy0ljMgilRRSji13jrxCN+56AZPnjWh4oDyclF7Zlcyy7Sz5hBMQowuli44BCTEmETr6sLBFBlNHflKhs8CeX2j73JH450uE3hamvCaiFGexxRIx94P4ffrQqRgQWvyw6k6iuYHqJq7FPIjXCIUUMD
x-ms-exchange-antispam-messagedata: JWznWI7B2QKXreXEVKqJaPrJj0NbuswSv/at2unhYVQewV3V6OBCLWEwXcGltOBUSLK6ZCNkECyytNhFGO6YJEvQbsaS9n+bI83VlnrosBcmLzrScXyOsHi1dr8QoEVt3ly/LLghNKLYTxAkHo3suw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6ab8e2-d2a7-46f5-7d88-08d79ea333f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 18:53:28.2958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m1gtQqfCl1meZ11Bq4vKUv2t9h2jetuGG78E1qqwWAn0+ULDd5kgSkAhjTq+QlTAyPMnZ9IZGWVS8Qm3XZPLVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry I was replying too quickly. See more detailed explanation below.

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
Will do.

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

The Azure/Hyper-V synthetic NIC receive buffer doesn't provide headroom=20
for XDP. We thought about re-use the RNDIS header space, but it's too=20
small. So we decided to copy the packets to a page buffer for XDP. And,=20
most of our VMs on Azure have Accelerated  Network (SRIOV) enabled, so=20
most of the packets run on VF NIC. The synthetic NIC is considered as a=20
fallback data-path. So the data copy on netvsc won't impact performance=20
significantly.

Thanks,
- Haiyang
