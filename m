Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27E463EC5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 03:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfGJBD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 21:03:58 -0400
Received: from mail-eopbgr760135.outbound.protection.outlook.com ([40.107.76.135]:52499
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbfGJBD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 21:03:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGttjpWjqrDqBqn5PADjj762mf4dwMTvw1bKYLOQ7GO4Bu9Tts9FGAcZsS/W4+cNLGpQxGX8rx5zpAkGAo2JIaT+2RCKZCTPRl8QBrL7Tx7g6f8IEkBj2nUxDYmcTpuqGg9N4IZTJVC3Q3CdgPaKwy1FBdPiqZ/U3uBiCm29BepkC/zBl0/MFqqD83OmA/Vv8j6R7cTCm6r1y1EbPpEtI8DkmHXkso65bD3ior2r7bJIjRqqgDRhnIDT3Zq1QgNpNRb1wHq3EOhC4WUEAMYiea17UoGZMdQFWXUt4hXr4isF2vnWMsiE6Cw3kQt4j8/Y6/RPGCzsUqN8+iJgDO1oSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/N4yHFZIo62w/W3MTe9T6t8nG0gox2lgLRGOPlytmM=;
 b=cvvyoD8c501tLbwWM6vLrOy9+bmdqToHjnD/T/BSfmNlQM2UuQC+Rm9N22iK1uTeBI3YuB3Nux1faGwHTymK0gIe+AphTxZm+T0toTD4BWbr5ZCHvbFBm29BUqiaWBIu7OrtSV5bMviE4BQdmjCCAMzZWAO7O3MEwH3H9fsa6QknncHYJXNDziJoC6nO9kMZHzFA6GNJGnyAuxjw2DJG+0htjKd5QzZa+e1Q9wUBDBLFcQ21C/0r6a6WLDTiala//HII0RMvQj31SrRLAJ3RF7j4RBB+StT+hnS6LnumBBFtooe5KJG2bT4RoNL4jg79uLxuk2Bkyk8+r13GLV/prQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/N4yHFZIo62w/W3MTe9T6t8nG0gox2lgLRGOPlytmM=;
 b=JxMVesuCd3Lu6rQB8NDiP8Gcj005Oy66pTBbgjsiJpnrDgHmUoF+/xS8wA4lvX8z1gaQF/+SCbTEwWWev1Nyk3x6f0r/ejaMO3KL+ip59ACgcWmiJNCt323D5AIFo+el2hJpjPXD9RpViequ25wzF1Y/L79otX39RTfe/niACpE=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1146.namprd21.prod.outlook.com (20.179.50.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.3; Wed, 10 Jul 2019 01:03:54 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5067:7dee:544e:6c08]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5067:7dee:544e:6c08%9]) with mapi id 15.20.2094.001; Wed, 10 Jul 2019
 01:03:54 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] Name NICs based on vmbus offer and enable async
 probe by default
Thread-Topic: [PATCH net-next] Name NICs based on vmbus offer and enable async
 probe by default
Thread-Index: AQHVNqmLUJAyxztGLUGuWv2QILreQ6bC8/EAgAAUXKA=
Date:   Wed, 10 Jul 2019 01:03:54 +0000
Message-ID: <DM6PR21MB13371872D317F960C56AB21BCAF00@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1562712932-79936-1-git-send-email-haiyangz@microsoft.com>
 <20190709164714.70774c92@hermes.lan>
In-Reply-To: <20190709164714.70774c92@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-10T01:03:52.7546227Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=edb10826-f1d6-4434-804b-d1187b406766;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ceaec80-2eee-4d08-eaec-08d704d27aa5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1146;
x-ms-traffictypediagnostic: DM6PR21MB1146:|DM6PR21MB1146:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB114634B238495D5575E371A9CAF00@DM6PR21MB1146.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(13464003)(186003)(7696005)(256004)(25786009)(8936002)(22452003)(229853002)(6116002)(8990500004)(4326008)(66066001)(11346002)(446003)(86362001)(14444005)(316002)(66946007)(26005)(3846002)(476003)(486006)(99286004)(76116006)(54906003)(6436002)(102836004)(66476007)(6506007)(71190400001)(66556008)(6916009)(33656002)(53546011)(10090500001)(64756008)(66446008)(53936002)(81156014)(76176011)(9686003)(305945005)(55016002)(74316002)(8676002)(478600001)(6246003)(2906002)(7736002)(71200400001)(68736007)(10290500003)(14454004)(52536014)(5660300002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1146;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1nKQAtnOvmCLo36iWcA0N8T+QXdtKIK/UWBnBErYbODUiK6jc301PE4j0uat0t6x29JZol6PF97gHJiLbWulNsJXh9v8Yvj0i8Diwr0+ThTRXgpU1AM7/XjKYYJ93geFEDcd5p+O7crwrPI1cOvz7zf5jCrqmpnbpUJmHYK2CCaiV4rGo95FduKhoCmSSXNkDfsfjNnKyt+Jyt0RRqXvIYviueOY1xp1v2VqoTFHLZN9ZyT/i3Zi4jEM7h3Dnoh6mdikAJLMCqfhEUavI6sXQunIR4KMAYDh3Okma8+43El3UR+YD6i1CYPpLZd4XrqR1LHJFmdSyXQQ2BtkloD28rFqmehPKc8ZS6mVnytoM8lUM0hKMX/F6twc06uVXgB11hAntlDykx/vXLU3/H88ueS18YugrHhdNv81IB4WuRw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ceaec80-2eee-4d08-eaec-08d704d27aa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 01:03:54.2705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haiyangz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Tuesday, July 9, 2019 7:47 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] Name NICs based on vmbus offer and enable
> async probe by default
>=20
> On Tue, 9 Jul 2019 22:56:30 +0000
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > -				VRSS_CHANNEL_MAX);
> > +	if (probe_type =3D=3D PROBE_PREFER_ASYNCHRONOUS) {
> > +		snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
>=20
> What about PCI passthrough or VF devices that are also being probed and
> consuming the ethN names.  Won't there be a collision?

VF usually shows up a few seconds later than the synthetic NIC. Faster prob=
ing
will reduce the probability of collision.
Even if a collision happens, the code below will re-register the NIC with "=
eth%d":
+	if (ret =3D=3D -EEXIST) {
+		pr_info("NIC name %s exists, request another name.\n",
+			net->name);
+		strlcpy(net->name, "eth%d", IFNAMSIZ);
+		ret =3D register_netdevice(net);
+	}

Thanks,
- Haiyang
