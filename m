Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21C146FF2
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAWRo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:44:56 -0500
Received: from mail-mw2nam12on2136.outbound.protection.outlook.com ([40.107.244.136]:17249
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727022AbgAWRo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 12:44:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Byiy23TprH0nIHP54kYALTEODvoHLm/SXvU8x2Bj4SmCUpBZsVq302rb3MnV7oNetibW0lWlPNNhzu4uhZsI3tjob9Dl9mpbK0OVOkMqaFsLkZAYBYDaoAEuXViQzDzsznUdbrRvS8/RgPXse7Lcpuq5wQd4wF5BE95vMDEAxg81N7jf7fQDQeFckSffhq2J3mYs9mjInbzOPlmTPFm6m093GioC7wuMbD9WEeoylV6mABSviAnAPeSBCPPALZP/zFy2K1JAkKBWswlu+MzXgOBQtBtf21HV9fcE+nKY5MnbzGcAokVE9RBpVJfuhsjXl2LqKRYN7nHntP5GFu897Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcRI9beZse0lG11RbrUH9ml+lntYvkWI0aF0F52XeO8=;
 b=d2TQdaEs3d4GOV8Pcff7POiR1G0tCthgkI/qv362xICe0HcLcx840VnUPMTATezcEnzgVJdZ4Ix0S/dmZnxpr9ewEDImlq56Szo8n46x6wyywLtqVz0/M5e0dNGGxJSnZT8/9Qibc1ArgLNHMAbfSaFHt/Basgv2PHrjpjeEs3NQUvsZWH3fm/qcYXr3IyGD28PO1itiITrM1Q8opJ8u91ohn1sdY2MRKUdK9Yx15wk1jrQnNCCSRqxFOdl0B3fj1Nio5B+hVkEgRW5VawURxpXfGfBF1yJQSKAIBoK1TojGRA/m/W20KfwlT4RX0CIgYgn/zgLbAAlNlXylXQi5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcRI9beZse0lG11RbrUH9ml+lntYvkWI0aF0F52XeO8=;
 b=ER31gEbTq2a3FjLp+b68dWfLmXhdA/EYpnLOdcqwNZj0KmU/o/6Jxp1bahqz6PTn0aumZbB4AgEwbsiGETPeqUPBjcAzCvUeksgpnOHCEcZ1z/mVIUfs17TmgyB7zQHjkCtP8pvwviEgdchjCstZzPmuTSHqTpo+B+TT/QCXGJ8=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1216.namprd21.prod.outlook.com (20.179.20.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Thu, 23 Jan 2020 17:44:53 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423%6]) with mapi id 15.20.2686.013; Thu, 23 Jan 2020
 17:44:53 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Thread-Topic: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Thread-Index: AQHV0UjdH1AVu+KRP0+E0p14Je7IQaf4ekYAgAABksCAAAcfgIAAAh5w
Date:   Thu, 23 Jan 2020 17:44:52 +0000
Message-ID: <MN2PR21MB1375147709E57BA25F661505CA0F0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
        <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
        <20200123085906.20608707@cakuba>
        <MN2PR21MB13757F7D19C11EC175FD9F98CA0F0@MN2PR21MB1375.namprd21.prod.outlook.com>
 <20200123093013.53d78485@cakuba>
In-Reply-To: <20200123093013.53d78485@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-23T17:44:51.4844806Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c8d5ad5b-c76c-4ac7-8c93-e15f6f73f981;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a6ab1373-e798-478b-e5a1-08d7a02bf3ce
x-ms-traffictypediagnostic: MN2PR21MB1216:|MN2PR21MB1216:|MN2PR21MB1216:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1216054B92E92061FE6C7CC3CA0F0@MN2PR21MB1216.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(199004)(189003)(316002)(54906003)(86362001)(8990500004)(5660300002)(10290500003)(9686003)(2906002)(55016002)(478600001)(26005)(33656002)(53546011)(6506007)(81166006)(66476007)(66556008)(76116006)(6916009)(4326008)(186003)(81156014)(8936002)(64756008)(66946007)(66446008)(71200400001)(52536014)(7696005)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1216;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9FM5qUROSyz4BaCxeY8Mm1T828mGE3YyKoPjCQttDtOXkYhVAeI5jcYphlz/FS5H8H0AhS5VCG5fDLl+Epu9XsNAK4j5B04wPzKj0+rpZOmIwD7d9co/G5OnJ9aSTtzsHGdroV5rsmBxDX4bwFvDYKPhuVwm9YKwNzNZNkI1w2EEePQL9J75mMDnfCZ6FObiquqzdzw4Tnol9XSBmkU6XCkFVIgwlil2Wbi0Phawh5zaSE2ERhqk2x/7YAEIjRN+yw8rIlt3Zkxif9cm31md7gB1KJlUn+YJr1Y6IA9AvEWa3FFHTj7ZZUE0omYaTQp2vtzYGxPbkP4N8+BW43//VbqJtxzO8jKCNJPXj1oD08HE3lqc20l0Vj4fFSmg8rqkCGFi0hOukObhYVwg+aUeqsOcFi16MP+YksPmjJIluW/BC7iwrVwgf79CFdgRiITt
x-ms-exchange-antispam-messagedata: o7rx8mdXSco3ESnKw9YeOX+RJ9hukRDD6wEnmPgJwGPdEGCIYVqmAY/MePxJqkpd/IAWAFaO4xxpK41Jubqj/1EHgbx2U6zWXvAX1vlJERtw+UF7VpnKQUH/v2Q2PVtmkTz+n4rFOxYHsSlrdS0mXw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ab1373-e798-478b-e5a1-08d7a02bf3ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 17:44:52.8696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+blLINXE1BiQT62jxYFEucNvFV7itQRi/GTX3VwRhKxVJ2JW77Ci7teocgBHaaUdUWcuQy4hQfcrW5rNDbo4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, January 23, 2020 12:30 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
>=20
> On Thu, 23 Jan 2020 17:14:06 +0000, Haiyang Zhang wrote:
> > > > Changes:
> > > > 	v3: Minor code and comment updates.
> > > >         v2: Added XDP_TX support. Addressed review comments.
> > >
> > > How does the locking of the TX path work? You seem to be just
> > > calling the normal xmit method, but you don't hold the xmit queue
> > > lock, so the stack can start xmit concurrently, no?
> >
> > The netvsc and vmbus can handle concurrent transmits, except the msd
> > (Multi-Send Data) field which can only be used by one queue.
> >
> > I already added a new flag to netvsc_send(), so packets from XDP_TX
> > won't use the msd.
>=20
> I see, there's a few non-atomic counters there, but maybe that's not a bi=
g deal.
Yes, those error counters are used less frequently, and not necessary to be=
 precise.

> What frees the skb if the ring is full, and netvsc_send_pkt() returns -EA=
GAIN?
> Nothing checks the return value from netvsc_xdp_xmit().
Good catch! I will add skb free when -EAGAIN is returned for XDP_TX.
I will update the patch.

Thanks,
- Haiyang

