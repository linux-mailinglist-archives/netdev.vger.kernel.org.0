Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F325DE907C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfJ2UBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:01:15 -0400
Received: from mail-eopbgr790105.outbound.protection.outlook.com ([40.107.79.105]:42256
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727518AbfJ2UBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 16:01:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3q68wXlZAbVYtZUxIjNUQH0al6LxvTEBuLymvwXV7Hjwcye3wfcwupZLSfEfSRrTHgK2iubfl961+twIO6FfPJFfksPhTsSxMabhYIZ5ch2F6aJMHx6h/qs+q+To1MeZzmr4NgtDouE5/tkflioOAKOm6RI7oqDHizElP+z5CrUKV/XfGqUz5vfkLd/CGY1skVw2WRlHM7kESjW+t44RCIIMm52jlqGhEIkCZbYMxGKkyVC7crssGfNPRSYfg0whgyhng5ASXvPWd06MsOlrFeCSSsF3+z7qKzWepE5sOyxCLI7oEaPlpXMtSEBTnka7WwDutfQJujqMNvN8dkGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQTiyNO6tCCey0b4mqp9s5wk2PcLB/GiOeyPkc1bgCs=;
 b=DHjMkPf/31EHjlJTt0TdVbBdGluC1Nij/jkj+2WdRknMbuYUaqvgRU0Lgkpe2HnrKcc2dDyjGhaudnmjONVu889K2O/Fk61zhvA4pOt13dcXfPbRX8QSgucqmQiyF4NvBU7VEa2yPtD4y6VynbqSYuMuGrJZI2ll6jNTBmIWt/x4EYsQiUuRFwI7R4Uu+b0n7Ka7J+KB5Q8FLAWBCFFYmt/KPHQnlhKzo5RrnhD/1Ps97s6YBQXYyA9Am2UxbhloAo6SwCXpqMvFbQkbazYKkA4PgZqhtwUEj/0v0bhAu+/eBB1bxC4Sd10EP08IozXUtfLtqq4OWbnUU9/CoIRCUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQTiyNO6tCCey0b4mqp9s5wk2PcLB/GiOeyPkc1bgCs=;
 b=G45SXu1NZcUt+elftRkTXb6O6GQmuMSw+HcqdTuy4xW/lbsATkthjQVCK3xrHlSlI6NNHpjI0vBiHQzV+bHxjN6mVkqQ3S027qDK5nubw3LrgzKzQGyTT6/c/e5RwBjkZmvvZt7NiuyfezoSUg0AjnWhEJRzw27LKSTjwP1ih0k=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1241.namprd21.prod.outlook.com (20.179.50.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Tue, 29 Oct 2019 20:01:11 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5ce7:b21d:15d7:cff8]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5ce7:b21d:15d7:cff8%9]) with mapi id 15.20.2408.019; Tue, 29 Oct 2019
 20:01:11 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Topic: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Index: AQHVjdOmZZw8T6TbMU+gJli1k9ewVadwkv0AgAFiizCAABPJAIAAAVkQ
Date:   Tue, 29 Oct 2019 20:01:11 +0000
Message-ID: <DM6PR21MB133767862C27C874A882A4E1CA610@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
        <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
        <20191028143322.45d81da4@cakuba.hsd1.ca.comcast.net>
        <DM6PR21MB1337547067BE5E52DFE05E20CA610@DM6PR21MB1337.namprd21.prod.outlook.com>
 <20191029125308.78b52511@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191029125308.78b52511@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-29T20:01:09.7323525Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1baae143-d29e-4577-9a38-26fc3987556d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d341e463-cd3d-426b-0fa1-08d75caabf02
x-ms-traffictypediagnostic: DM6PR21MB1241:|DM6PR21MB1241:|DM6PR21MB1241:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB12410781F8A9331FBD0BDDA5CA610@DM6PR21MB1241.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(396003)(346002)(189003)(199004)(51914003)(13464003)(66946007)(81166006)(81156014)(86362001)(6916009)(8676002)(14454004)(6246003)(10290500003)(55016002)(10090500001)(3846002)(8936002)(6116002)(229853002)(486006)(76116006)(6436002)(22452003)(2906002)(66476007)(66556008)(64756008)(66446008)(4326008)(446003)(14444005)(11346002)(476003)(256004)(5024004)(25786009)(9686003)(52536014)(7696005)(6506007)(53546011)(316002)(102836004)(26005)(76176011)(33656002)(71190400001)(71200400001)(66066001)(54906003)(7736002)(74316002)(5660300002)(8990500004)(186003)(99286004)(305945005)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1241;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m9ufuVc6MwTOOgTPdr2MHO/Ck1vO0uWo/LQfQ+IPlUtPYLVrar0bptAkO+O/zfZCnUnldWUEUhwzkd+XTEDopwWsQNvt3QHlndC9WARq6xsHPvSrVq/U1rlwXYYHXD76VQZHDeefwNLIjVfrOQBlwjhbZcL7NfdCjiMNZSAjaj6ajhuxuoF86QyJvzy+rOox68CpQLPkolI2FU+TH3xolsP/ET0kWLz3S1jmygxFmsaF2r2EnhZMCHr263j+moZT1DUpc8PK7tGSwDPw6fJFYzitZxFuTW1LSFgY3mcV2A8/Q+DvLZV6Sl9/DJh8E6dXp17JjdVjbsRj9G9w0MX+SX7NWfYthIZDhninRQz78wFMzmydkxgENabzk7dmb1BFAk15bxyL+lDGhSRblwFth2q8p7GfAdTAkcbEo3FTu0KdpRgTa8jmQNBhCEVlmD53
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d341e463-cd3d-426b-0fa1-08d75caabf02
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 20:01:11.3520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QkBWErg7CNXUt/GPDyE+ymNV3SNmCWpifndnWc6X9mtMaQkZvaT8+kkylZ5OIY0f1jlyWUBKEdQV6eiZcDL/yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1241
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, October 29, 2019 3:53 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
>=20
> On Tue, 29 Oct 2019 19:17:25 +0000, Haiyang Zhang wrote:
> > > > +int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> > > > +		   struct netvsc_device *nvdev)
> > > > +{
> > > > +	struct bpf_prog *old_prog;
> > > > +	int frag_max, i;
> > > > +
> > > > +	old_prog =3D netvsc_xdp_get(nvdev);
> > > > +
> > > > +	if (!old_prog && !prog)
> > > > +		return 0;
> > >
> > > I think this case is now handled by the core.
> > Thanks for the reminder. I saw the code in dev_change_xdp_fd(), so the
> upper layer
> > doesn't call XDP_SETUP_PROG with old/new prog both NULL.
> > But this function is also called by other functions in our driver, like
> netvsc_detach(),
> > netvsc_remove(), etc. Instead of checking for NULL in each place, I sti=
ll
> keep the check inside
> > netvsc_xdp_set().
>=20
> I see. Makes sense on a closer look.
>=20
> BTW would you do me a favour and reformat this line:
>=20
> static struct netvsc_device_info *netvsc_devinfo_get
> 			(struct netvsc_device *nvdev)
>=20
> to look like this:
>=20
> static
> struct netvsc_device_info *netvsc_devinfo_get(struct netvsc_device
> *nvdev)
>=20
> or
>=20
> static struct netvsc_device_info *
> netvsc_devinfo_get(struct netvsc_device *nvdev)
>=20
> Otherwise git diff gets confused about which function given chunk
> belongs to. (Incorrectly thinking your patch is touching
> netvsc_get_channels()). I spent few minutes trying to figure out what's
> going on there :)
I will.

>=20
> > >
> > > > +		return -EOPNOTSUPP;
> > > > +	}
> > > > +
> > > > +	if (prog) {
> > > > +		prog =3D bpf_prog_add(prog, nvdev->num_chn);
> > > > +		if (IS_ERR(prog))
> > > > +			return PTR_ERR(prog);
> > > > +	}
> > > > +
> > > > +	for (i =3D 0; i < nvdev->num_chn; i++)
> > > > +		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
> > > > +
> > > > +	if (old_prog)
> > > > +		for (i =3D 0; i < nvdev->num_chn; i++)
> > > > +			bpf_prog_put(old_prog);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog
> *prog)
> > > > +{
> > > > +	struct netdev_bpf xdp;
> > > > +	bpf_op_t ndo_bpf;
> > > > +
> > > > +	ASSERT_RTNL();
> > > > +
> > > > +	if (!vf_netdev)
> > > > +		return 0;
> > > > +
> > > > +	ndo_bpf =3D vf_netdev->netdev_ops->ndo_bpf;
> > > > +	if (!ndo_bpf)
> > > > +		return 0;
> > > > +
> > > > +	memset(&xdp, 0, sizeof(xdp));
> > > > +
> > > > +	xdp.command =3D XDP_SETUP_PROG;
> > > > +	xdp.prog =3D prog;
> > > > +
> > > > +	return ndo_bpf(vf_netdev, &xdp);
> > >
> > > IMHO the automatic propagation is not a good idea. Especially if the
> > > propagation doesn't make the entire installation fail if VF doesn't
> > > have ndo_bpf.
> >
> > On Hyperv and Azure hosts, VF is always acting as a slave below netvsc.
> > And they are both active -- most data packets go to VF, but broadcast,
> > multicast, and TCP SYN packets go to netvsc synthetic data path. The
> synthetic
> > NIC (netvsc) is also a failover NIC when VF is not available.
> > We ask customers to only use the synthetic NIC directly. So propagation
> > of XDP setting to VF NIC is desired.
> > But, I will change the return code to error, so the entire installation=
 fails if
> VF is
> > present but unable to set XDP prog.
>=20
> Okay, if I read the rest of the code correctly you also fail attach
> if xdp propagation failed? If that's the case and we return an error
> here on missing NDO, then the propagation could be okay.
>=20
> So the semantics are these:
>=20
> (a) install on virt - potentially overwrites the existing VF prog;
> (b) install on VF is not noticed by virt;
> (c) uninstall on virt - clears both virt and VF, regardless what
>     program was installed on virt;
> (d) uninstall on VF does not propagate;
>=20
> Since you're adding documentation it would perhaps be worth stating
> there that touching the program on the VF is not supported/may lead
> to breakage, and users should only touch/configure the program on the
> virt.

Sure I will document the recommended way of install xdp prog.

Thanks,
- Haiyang

