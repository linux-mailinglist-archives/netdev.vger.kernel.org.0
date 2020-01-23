Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF8146F49
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAWROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:14:46 -0500
Received: from mail-mw2nam12on2098.outbound.protection.outlook.com ([40.107.244.98]:29594
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726605AbgAWROp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 12:14:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndoTCQ8Uc8NYkHv1AMI5+2xkFpUQbMNHMavtyK1iHeAV93Kl3U5OVJMmaHFI+tTd2lG8spbA/PlyKIyH/yOXU+vxMjEcataAeNz9IfFlI5IU8vSGjJ4xwQK4f7tgK4ObwasK9kzwWoc+5Hbl0S6WkdXIXiUur7haIq0XO0383fXmNEtyztwI4QrH+GujGydRSgvVc4JjJyP5yZoVoyBW8Iotzgf/J2SBhAX5L9We/J6w2FO3BP0frtN1OBWq0mc8QWSGIzwz6vnNtkB/FY0goigolUk/DMmzyjSKkniafCQuswTVwQbDR4u1RfeCK2oTtmLJBhNe1xQ6LWTIzot+JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB+iH21jeXyRhNQ4j7mA5U7GRWbyMqWWqC0Y7HEG3Po=;
 b=DVoQRwUhajGn/0udBLTVwp09EvgyGz5M+uL+D0uQkdfM6DAwzzULXX1YVxOfzSQS+sPR4Wug2L33QG/ryGb+wpBEnK4uEszOeNLZURcDGpHQ+PB7iBSUoeDWfY67hEctNRVe4hPYMx6TiKfQdEytSaxRIVq3Rdn3aFzgkvziA0/wqz6biZg9hiIGUVRLBQnkNJsJjJLCR/s/Bctb4YsQv8MjDj90y9qIA1+ieVRn46uCJ6Y137rQmOygJ/9vS9FG2JaTyPu4+QfNlPP25So95qSTxi1xpYVUxJd5SiWX9t+Z0r7pDezefbHhAaaSLCfDdyzraIWw06iJF6HdolFrAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB+iH21jeXyRhNQ4j7mA5U7GRWbyMqWWqC0Y7HEG3Po=;
 b=PrdJAnxXEMK2jEUnwiA+3I+MhHNJeneiUqHtuzFNP8+yIIAcpQzFEBZLpQMlbOQeAE7fZgl8dplNGYTdIkoWjZtmVKord/8NfpGf+SuUJd2aryMIlA+XrSmIyctBMLtSIZxKMsWFhyxQH2l3AZC70zCVWxlPTxiPaTFB9g05oDI=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1213.namprd21.prod.outlook.com (20.179.20.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Thu, 23 Jan 2020 17:14:06 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423%6]) with mapi id 15.20.2686.013; Thu, 23 Jan 2020
 17:14:06 +0000
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
Thread-Index: AQHV0UjdH1AVu+KRP0+E0p14Je7IQaf4ekYAgAABksA=
Date:   Thu, 23 Jan 2020 17:14:06 +0000
Message-ID: <MN2PR21MB13757F7D19C11EC175FD9F98CA0F0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
        <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
 <20200123085906.20608707@cakuba>
In-Reply-To: <20200123085906.20608707@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-23T17:14:05.1118734Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=89d18603-f9b3-41e8-9366-578ace4c86c5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec8e38f4-3006-4598-60bf-08d7a027a74f
x-ms-traffictypediagnostic: MN2PR21MB1213:|MN2PR21MB1213:|MN2PR21MB1213:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB12131A118CDE325FA15969F7CA0F0@MN2PR21MB1213.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(199004)(189003)(6916009)(52536014)(8990500004)(10290500003)(33656002)(478600001)(2906002)(71200400001)(54906003)(5660300002)(64756008)(66556008)(26005)(66946007)(66476007)(9686003)(76116006)(186003)(8676002)(81166006)(81156014)(8936002)(66446008)(55016002)(7696005)(86362001)(6506007)(53546011)(316002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1213;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSST0RuEG/XUT17iYJkSc390C9z8Z6E1QYkUIPGEPDiUHNv5PhGLnNbGmIkrzPhG/05Gd+LOUxR00BSQHJdiRHUsYrcTC3qaOKVJ289VNL/Jjik6+nXIfbJuTWgT5vFfPpyJhHjcAXsjkypC3inVb1k8gKAxJWuQVwp/6nUsMT1/vtBz554sDYN4E1AaVzzGZcITNYgPAymMlokwW3SdNaUozi32RqKpFyQfz+3xxNTQBL+Reom835MHpNi7m6oBHHR5pPtP5iFD7JaX/GoeKvVw2FQwt4ryOQy4O14NzYYSWCp1GNSq5FhmFvIN3YuoJylCNYoCvZldQRv6m+n/+VZhAvfmkbnZxybtXtZnudkuLrHsSrheMF6l58j9bdK6Rc0fASLQXiPQF0g/+t3nkcr4KRlwyF7UIcZ9TUV8t31izyqwGo9D0ZPf3c8N1A3B
x-ms-exchange-antispam-messagedata: q4oxD6GEZZ08clxCvVd4mQFVXkxjcfgO3BhEi+KEcL93yswvqeLK7AgQPQGSIKK4I3ogcpPWMaiKd6Gdxwf7aO+wfL4OdN39uo2q2Catd5i/aEFNb2T8P6HXsTf9JH4H+hInhEY9stQpjs532NpRpw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8e38f4-3006-4598-60bf-08d7a027a74f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 17:14:06.5341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qDG3Oxo/fRFAYxS2nOkvuVgj2TRU7MQohCmbvkkNrV5Qm+yuh4fUb9sRB4+ifVo2g+1Wr28y9ck1EG28YgkfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1213
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, January 23, 2020 11:59 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
>=20
> On Wed, 22 Jan 2020 09:23:33 -0800, Haiyang Zhang wrote:
> > This patch adds support of XDP in native mode for hv_netvsc driver,
> > and transparently sets the XDP program on the associated VF NIC as well=
.
> >
> > Setting / unsetting XDP program on synthetic NIC (netvsc) propagates
> > to VF NIC automatically. Setting / unsetting XDP program on VF NIC
> > directly is not recommended, also not propagated to synthetic NIC, and
> > may be overwritten by setting of synthetic NIC.
> >
> > The Azure/Hyper-V synthetic NIC receive buffer doesn't provide
> > headroom for XDP. We thought about re-use the RNDIS header space, but
> > it's too small. So we decided to copy the packets to a page buffer for
> > XDP. And, most of our VMs on Azure have Accelerated  Network (SRIOV)
> > enabled, so most of the packets run on VF NIC. The synthetic NIC is
> > considered as a fallback data-path. So the data copy on netvsc won't
> > impact performance significantly.
> >
> > XDP program cannot run with LRO (RSC) enabled, so you need to disable
> > LRO before running XDP:
> >         ethtool -K eth0 lro off
> >
> > XDP actions not yet supported:
> >         XDP_REDIRECT
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> >
> > ---
> > Changes:
> > 	v3: Minor code and comment updates.
> >         v2: Added XDP_TX support. Addressed review comments.
>=20
> How does the locking of the TX path work? You seem to be just calling the
> normal xmit method, but you don't hold the xmit queue lock, so the stack =
can
> start xmit concurrently, no?

The netvsc and vmbus can handle concurrent transmits, except the msd=20
(Multi-Send Data) field which can only be used by one queue.=20

I already added a new flag to netvsc_send(), so packets from XDP_TX won't u=
se=20
the msd.

Thanks,
- Haiyang
