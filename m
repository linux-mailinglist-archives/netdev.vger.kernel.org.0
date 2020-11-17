Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558F92B6DDE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgKQSu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:50:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10661 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgKQSu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:50:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb41b960000>; Tue, 17 Nov 2020 10:51:02 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 18:50:58 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Nov 2020 18:50:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk8U+lrRAi9294T+CGubsX03a3kMkrsdZuJtblMCrFFbKg/T0p66RXQY2oENzERYdb/zFPRMq3CWC6qEaf/KnYS1OiW5F6CSVXBPailSn2ltr6Km060uUodFFfVmcXMHAdL0Ca7zw1gvdH/AXx57FMHT7BEN1Uk08uCRpcyrLKDInLVpKGWAaot+tMbB8MMi0RHq/roB5pfdZ/zTxlx0OktqSwnFh0f0KdXqW6FMI+ThT+FGFQagdqAVCmu/TF4kphkC5FP8pOxFsu+eQI8Myj6iAbzRDN/ZRONtOaebJ7B/UfboBsIbtAJOcRzWFP1Q/sJLc/YiCFzOj+VN0t7TVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gx96CxEsB0/xSUJxhzaikkJ7ohB68KlEFBoJB8qMXeU=;
 b=c7vGBsCRWtED6UakQNTj0mWBrcS6fCkKAFXAOASxAXylXRzOSDTzX/3RGwg+rR2fO+M0J9Q4iySFthdXORBr4I3Rqf3JVAIdxGx/ew1JuSIXsusCKFtmzODfNu+4DjFNnWylFBi8221Ld2ZQeUFHuw2cNRMZKNZNzPJtejEEGrfr3hc5pQwlqdbNVnsCMwKknHTcu0dCTHn5ZKAJTnLPOJbnxVBgY1uJ60mNjQE+biKdUnasxrpYZAoA+XOuliF+jzM4HUJKlihn6lci1klmKlXLkki6XIfdJLfLS4MTavLopNcoz2D3Mb5GAmtpymghsSkG6l1Wq/IW8gxT2s2Lvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 18:50:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 18:50:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Index: AQHWuSmL5Mv5iXh50kOvsKYXf73R1KnLY/sAgAAUkACAAB9NAIAAFpTQgADolgCAAAJs8A==
Date:   Tue, 17 Nov 2020 18:50:57 +0000
Message-ID: <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20e25cd0-a3ce-481d-e0b6-08d88b29b832
x-ms-traffictypediagnostic: BY5PR12MB4322:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB43220DF51E7ADB19655622E1DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +KnssaXdpo0hgKIVJerpGbIK/xi+pPHc94QVhwd4Os9ZtxgNj0kaL/f5EYOSVfiArXGAmYwdDTORMrvRze0og5yHQOJolh8/RmSG3rT6nY19ey+fciEIsKA/9QQdL2yE3ENoeg0VTLlH7TlCVUy4xELaiXbk52+MZ0e18e8sarWd3sOPc7dWwK0Hx2CY62a7muqJzzpM8/v6JgAKcF6u/9uHGGAULTvCJRy4AxQOJDeNl7VFgOSvn7naY4JXdo2fHtLkN8dTS73rxCVDKVHBegKGDJv9loVOrjyrIl30kHk2MJg7s4ohMwzl/YntiR6clCC4JXWM7EcXP5iAlvcAzdWlDeQu9wanuRa3YalTbJS8rORTy+eQlYdFiLEPFml6k2ww7Rhcczq08ACzq3H6bA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(71200400001)(478600001)(6506007)(316002)(55236004)(83380400001)(64756008)(52536014)(66556008)(76116006)(66946007)(66476007)(66446008)(5660300002)(33656002)(54906003)(186003)(55016002)(9686003)(26005)(2906002)(4326008)(6916009)(7696005)(8676002)(966005)(8936002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Xh2Gh+c96IKdpNuTvcT6c77/IzZ1fLIPA/WIHw8MYW2Pe5tbCP9SCfP74bqUI/N9Johs4tEdKHkm0fE9ccUe4HYJvtrVVaVIZbSSeWwPf51cyXdXkRtKff0J//dRWD6zJG8uZzN8/Beyh+cjiUmsmMFWygXWpRUwtlJQKAV2L8x8VnbbV2RQ0RZ3HMF3+ty6VZK2+49OXNKtFPqQlcLtvWFG4ZSkD0gbYGQMkYQb81xmD2NhGk6ixsLNX1a+66seiJxidVt8W5hbHlX8aNR0GdsQr8rjfPohyvs+O4n+bhaucWF5oSm8Gjv3yxF/lCvFvjcNAedVEmtiCSyh0Vfb3TPBp5tNIIHCkPxsmn4NFIRvw/VBxjkO1i0e7PayQxjE7VFwwd6HvEq9IrOdB0Eka9ISEXBzhLO8JuUrLupqHWXFSPD2VxMK7OLeX65dZQuQDNweHzybcGCsdsjgiu2AdhsMdeI+JghkgRs3jisZ+4YLSwWLCjg3ULX2jORiEY8dpjhF6r9zmZ1qOtXsj4r9JsqPGA5QGYhNxZaizDQqaiVk0pl28Q8U2GVXZzhi8s3UTOMfO/dWd/7aAWUD0z15qTTtibpQviaBd9AGVepTHfdhE1nnJ2UP68/qTPW5octzJ5Y+S6H+9TGKQNMzgrjwiw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e25cd0-a3ce-481d-e0b6-08d88b29b832
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 18:50:57.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0IHoMsWf05ng7h0LFielbQwrNbnHbnck/Q8ztpsCer8I0ISpTFLHUw7/YRzsSzUHkB5Rl3JOPstakePEFw+ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605639062; bh=gx96CxEsB0/xSUJxhzaikkJ7ohB68KlEFBoJB8qMXeU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=CIXI6HDJO/H9L7H0leeHPhBDiIyJwUVlpoAmoUpiKgA3F6TWuWE7vuizcKJb0w2TO
         VZ+f1FqBzr7nvrI5inlWIWki1ih4Wr0PDGBKufbYCZhoAC0DKz9Uo0qqzl7m9ukhyb
         giP7msj3985MeK+4yYuQCJRfLLIHIljcJx1LjoginRuZlc6U1gfbjv3ipyXJmlcocR
         ghrHteTu1NABA8pqrP4tcbcetU7RXOMEqyYvc5uiNKpI4bQl1X5tg4IFYuEETCtHNa
         P2atlQvYZqFYBF9rGAmTb1kOAB8zes7MWsfAKFU9yvasNiJweOgICh41vM6QgQccEj
         74PdYZ8VDhK7w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 17, 2020 10:41 PM
>=20
> On Tue, 17 Nov 2020 04:08:57 +0000 Parav Pandit wrote:
> > > On Mon, 16 Nov 2020 16:06:02 -0800 Saeed Mahameed wrote:
> > > > > > Subfunction support is discussed in detail in RFC [1] and [2].
> > > > > > RFC [1] and extension [2] describes requirements, design, and
> > > > > > proposed plumbing using devlink, auxiliary bus and sysfs for
> > > > > > systemd/udev support.
> > > > >
> > > > > So we're going to have two ways of adding subdevs? Via devlink
> > > > > and via the new vdpa netlink thing?
> > Nop.
> > Subfunctions (subdevs) are added only one way, i.e. devlink port as
> > settled in RFC [1].
> >
> > Just to refresh all our memory, we discussed and settled on the flow
> > in [2]; RFC [1] followed this discussion.
> >
> > vdpa tool of [3] can add one or more vdpa device(s) on top of already
> > spawned PF, VF, SF device.
>=20
> Nack for the networking part of that. It'd basically be VMDq.
>=20
Can you please clarify which networking part do you mean?
Which patches exactly in this patchset?

> > > > Via devlink you add the Sub-function bus device - think of it as
> > > > spawning a new VF - but has no actual characteristics
> > > > (netdev/vpda/rdma) "yet" until user admin decides to load an
> > > > interface on it via aux sysfs.
> > >
> > > By which you mean it doesn't get probed or the device type is not
> > > set (IOW it can still become a block device or netdev depending on
> > > the vdpa request)?
> > > > Basically devlink adds a new eswitch port (the SF port) and
> > > > loading the drivers and the interfaces is done via the auxbus
> > > > subsystem only after the SF is spawned by FW.
> > >
> > > But why?
> > >
> > > Is this for the SmartNIC / bare metal case? The flow for spawning on
> > > the local host gets highly convoluted.
> >
> > The flow of spawning for (a) local host or (b) for external host
> > controller from smartnic is same.
> >
> > $ devlink port add..
> > [..]
> > Followed by
> > $ devlink port function set state...
> >
> > Only change would be to specify the destination where to spawn it.
> > (controller number, pf, sf num etc) Please refer to the detailed
> > examples in individual patch. Patch 12 and 13 mostly covers the
> > complete view.
>=20
> Please share full examples of the workflow.
>=20
Please find the full example sequence below, taken from this cover letter a=
nd from the respective patches 12 and 13.

Change device to switchdev mode:
$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

Add a devlink port of subfunction flavour:
$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

Configure mac address of the port function: (existing API).
$ devlink port function set ens2f0npf0sf88 hw_addr 00:00:00:00:88:88

Now activate the function:
$ devlink port function set ens2f0npf0sf88 state active

Now use the auxiliary device and class devices:
$ devlink dev show
pci/0000:06:00.0
auxiliary/mlx5_core.sf.4

$ devlink port show auxiliary/mlx5_core.sf.4/1
auxiliary/mlx5_core.sf.4/1: type eth netdev p0sf88 flavour virtual port 0 s=
plittable false

$ ip link show
127: ens2f0np0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode D=
EFAULT group default qlen 1000
    link/ether 24:8a:07:b3:d1:12 brd ff:ff:ff:ff:ff:ff
    altname enp6s0f0np0
129: p0sf88: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFA=
ULT group default qlen 1000
    link/ether 00:00:00:00:88:88 brd ff:ff:ff:ff:ff:ff

$ rdma dev show
43: rdmap6s0f0: node_type ca fw 16.28.1002 node_guid 248a:0703:00b3:d112 sy=
s_image_guid 248a:0703:00b3:d112
44: mlx5_0: node_type ca fw 16.28.1002 node_guid 0000:00ff:fe00:8888 sys_im=
age_guid 248a:0703:00b3:d112

At this point vdpa tool of [1] can create one or more vdpa net devices on t=
his subfunction device in below sequence.

$ vdpa parentdev list
auxiliary/mlx5_core.sf.4
  supported_classes
    net

$ vdpa dev add parentdev auxiliary/mlx5_core.sf.4 type net name foo0

$ vdpa dev show foo0
foo0: parentdev auxiliary/mlx5_core.sf.4 type network parentdev vdpasim ven=
dor_id 0 max_vqs 2 max_vq_size 256

> I'm asking how the vdpa API fits in with this, and you're showing me the =
two
> devlink commands we already talked about in the past.
Oh ok, sorry, my bad. I understood your question now about relation of vdpa=
 commands with this.
Please look at the above example sequence that covers the vdpa example also=
.

[1] https://lore.kernel.org/netdev/20201112064005.349268-1-parav@nvidia.com=
/
