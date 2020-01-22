Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9CB145D24
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAVU31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:29:27 -0500
Received: from mail-bn7nam10on2110.outbound.protection.outlook.com ([40.107.92.110]:48374
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbgAVU30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 15:29:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ5l8GBrEyXtH1UCgcVYgOtJCR4O3fc09HH7UVzVXOY2lBweveK1NJhZq6TuTd/PVxVTTpgY1bM3GIHwGlvz1/IF+qSKnc4+VL6BWMiVqa/xFXS+cvF9XJ6vSAXuKfHqkwUdkRIHeV+Rx5sR4qo3exSv4Z8eO+Rr/8AkHoC/Vobni2qHbKMg8ILw/CJoMDtHs+8R4HiQwjVvpnOJP6T6kUofEaHzpsJQej/1vCLnzuDwInwP15RI8qXU8WrpEdNjKpF6lZeQtsO1cYWtc4dR63xtZrbqG3fiZrRWtVqTpQkmI4YE0uyj00egFkjvsCjS2O6GZqBl1xq8U60QDQ5lrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS8fvkrqWJwahEiw0ixYly2vTdgkxneAO6DGDkBX0jY=;
 b=T+IzB61Unbm+HyQX0LCPjvG4zRJFx0OYWNOVXbfydUqy41WXzbIdKRDO8lIZZH12cc48s7Q0JZi9MjPOWWPEIVgNDGm5mFmJraRo60GxGHwZDaeHQo5Y3NUpZlDCRZotacsoKfoDmEl5J6yyUBrltAfsz3e9wGZVa/wz8Ydyzh6zZbEF6N4G9NNUK4hAb7lBOJfKFpbKeD3fFJEth+dP+jkO+G0HdbOvy+NULiLRQA+SQ0rvp+145XkWY4V8IEtstZuOZJX8z9a+MTMqe+HgaN9x6A4816Rzco7flWcCFS4uzJZyjQUHXor7zNkqPR7fdRXWpl0qMqWK7S33VEL8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS8fvkrqWJwahEiw0ixYly2vTdgkxneAO6DGDkBX0jY=;
 b=G5gBz6eD1E0oD7gUpPwH9oV4jXaF6KlSo7o3rApXNJJnVpLMZg4DRGdaSIPPl9PYSChofSvhtaVVkx3buqt0KNqsGF3yGjBqlVxlgU7tIhECxV2PGpVWdeI33dqOpA0nrgphg1NsYutZdHXEAr7QA0FjiGawLHdmvM38tHezKLI=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1261.namprd21.prod.outlook.com (20.179.21.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Wed, 22 Jan 2020 20:29:22 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423%6]) with mapi id 15.20.2686.007; Wed, 22 Jan 2020
 20:29:22 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: RE: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Thread-Topic: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Thread-Index: AQHV0UjdH1AVu+KRP0+E0p14Je7IQaf3GB+AgAAG3tA=
Date:   Wed, 22 Jan 2020 20:29:22 +0000
Message-ID: <MN2PR21MB1375C9F1F2EA6C9F5E95E873CA0C0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
        <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
 <20200122205133.00688f7c@carbon>
In-Reply-To: <20200122205133.00688f7c@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-22T20:29:21.0706536Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8a5f2dba-fefc-4322-8719-75316e7721c8;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 85a4e05a-9c1b-4e77-faaa-08d79f79c44f
x-ms-traffictypediagnostic: MN2PR21MB1261:|MN2PR21MB1261:|MN2PR21MB1261:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB12612355AEDB8C2D9165A625CA0C0@MN2PR21MB1261.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(54906003)(52536014)(5660300002)(33656002)(6916009)(55016002)(71200400001)(9686003)(76116006)(86362001)(64756008)(66946007)(66476007)(66446008)(66556008)(8936002)(81166006)(81156014)(26005)(4326008)(10290500003)(6506007)(7696005)(53546011)(186003)(8676002)(478600001)(2906002)(316002)(966005)(8990500004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1261;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WtHIpfBiB63VIgnzefPvCebyIxvoCsxTjt72lv9Rd5dZPzJccKtH54sUXRxYyK5ND2N0fTifraTSqpYFFNBRVkuulXdKvA7mYzWkNB9HeNeYdJpB05DVceBXvxhYyUEHXbX1453q71JrA/clkYWyaIUyleiu0wUrB6rJLroyVcYWRIXg7u7Ie/nhflIHp89l2pzBGvNa8/3RHxct2irGpP+3ctS/VgeB2zmwnAus67UJ/MqZdPSpFidmDOjSh7Fw64TSPRgSmwkYvbFhjeMuYOP1Gj2gJ12b2mtSomgkOMvZoPzpu1JHtjt99LNjdmoDlhibdeDy+G+OzHjliFzzOodRQ10LiUB3vHaNm63IYZBq5QCq7V+mBdE6y2AMJsyqsoTr0Z8CiJQ1S4mFC5XRU33gSUr+u8BcXoOVjMbXtao/Ot3ALxYyQic40+d8ex7N3+8QPje+w4dSHDe/I+uWjMiMNm2HntU0rneJCYE6c48=
x-ms-exchange-antispam-messagedata: NX76SWcNy5CQK+3uo6qSWNiF2RSPk1ESvT+xVXms2+c63stAKvpm0T4Oe45BU2im3htpW7rgZ+DynVlZs+8B6UorXTjI4FUjknon51JQTHzJb+Nz6ITwGHN3kCidLNsafsCU18+K2nS8qAbHg0hhuw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a4e05a-9c1b-4e77-faaa-08d79f79c44f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 20:29:22.7630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXSNFPfI7xonpBbmh4Ship/pqJK72OrjTmRLnwksVwOwuqNaZdbj8dZ+bg7HZaTpep8CjHI7kkXqJTGUW0MMZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Sent: Wednesday, January 22, 2020 2:52 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: brouer@redhat.com; sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org;
> Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Subject: Re: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
>=20
> On Wed, 22 Jan 2020 09:23:33 -0800
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvc=
han,
> > +		   struct xdp_buff *xdp)
> > +{
> > +	void *data =3D nvchan->rsc.data[0];
> > +	u32 len =3D nvchan->rsc.len[0];
> > +	struct page *page =3D NULL;
> > +	struct bpf_prog *prog;
> > +	u32 act =3D XDP_PASS;
> > +
> > +	xdp->data_hard_start =3D NULL;
> > +
> > +	rcu_read_lock();
> > +	prog =3D rcu_dereference(nvchan->bpf_prog);
> > +
> > +	if (!prog)
> > +		goto out;
> > +
> > +	/* allocate page buffer for data */
> > +	page =3D alloc_page(GFP_ATOMIC);
>=20
> The alloc_page() + __free_page() alone[1] cost 231 cycles(tsc) 64.395 ns.
> Thus, the XDP_DROP case will already be limited to just around 10Gbit/s
> 14.88 Mpps (67.2ns).
>=20
> XDP is suppose to be done for performance reasons. This looks like a slow=
down.
>=20
> Measurement tool:
> [1]
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.co
> m%2Fnetoptimizer%2Fprototype-
> kernel%2Fblob%2Fmaster%2Fkernel%2Fmm%2Fbench%2Fpage_bench01.c&am
> p;data=3D02%7C01%7Chaiyangz%40microsoft.com%7C681b5b13e50448d098d408
> d79f748522%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63715319
> 5109318994&amp;sdata=3DpncqYIWm1yS5rDf%2BAIbWgskycmuofzl09yA1QmsRb
> M0%3D&amp;reserved=3D0

On synthetic data path (netvsc), the per channel throughput is much slower =
than=20
10Gbps, because of the host side software based vSwitch. Also in most VMs o=
n=20
Azure, Accelerated Network (SRIOV) is enabled. So the alloc_page() overhead=
 on=20
synthetic data path won't impact performance significantly.

>=20
> > +	if (!page) {
> > +		act =3D XDP_DROP;
> > +		goto out;
> > +	}
> > +
> > +	xdp->data_hard_start =3D page_address(page);
> > +	xdp->data =3D xdp->data_hard_start + NETVSC_XDP_HDRM;
> > +	xdp_set_data_meta_invalid(xdp);
> > +	xdp->data_end =3D xdp->data + len;
> > +	xdp->rxq =3D &nvchan->xdp_rxq;
> > +	xdp->handle =3D 0;
> > +
> > +	memcpy(xdp->data, data, len);
>=20
> And a memcpy.


As in the commit log:=20
The Azure/Hyper-V synthetic NIC receive buffer doesn't provide headroom
for XDP. We thought about re-use the RNDIS header space, but it's too
small. So we decided to copy the packets to a page buffer for XDP. And,
most of our VMs on Azure have Accelerated  Network (SRIOV) enabled, so
most of the packets run on VF NIC. The synthetic NIC is considered as a
fallback data-path. So the data copy on netvsc won't impact performance
significantly.

>=20
> > +
> > +	act =3D bpf_prog_run_xdp(prog, xdp);
> > +
> > +	switch (act) {
> > +	case XDP_PASS:
> > +	case XDP_TX:
> > +	case XDP_DROP:
> > +		break;
> > +
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(ndev, prog, act);
> > +		break;
> > +
> > +	default:
> > +		bpf_warn_invalid_xdp_action(act);
> > +	}
> > +
> > +out:
> > +	rcu_read_unlock();
> > +
> > +	if (page && act !=3D XDP_PASS && act !=3D XDP_TX) {
> > +		__free_page(page);
>=20
> Given this runs under NAPI you could optimize this easily for XDP_DROP (a=
nd
> XDP_ABORTED) by recycling the page in a driver local cache. (The page_poo=
l
> also have a driver local cache build in, but it might be overkill to use =
page_pool
> in this simple case).
>=20
> You could do this in a followup patch.

I will do the optimization in a follow-up patch.

Thanks,
- Haiyang
