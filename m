Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FF71449B5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAVCMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:12:24 -0500
Received: from mail-dm6nam12on2106.outbound.protection.outlook.com ([40.107.243.106]:32161
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726584AbgAVCMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 21:12:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjxbCIKEGx5SkJAWRWefjYGnhTm4ILoOXEKKRtbY5LVIwJa2OkzmWEp5fbGSyhByMMEDboWrHZnVGW58xqz0zXfsZZFeFe51YGtuMSfCHkwJh9EYEjEKkXVrxQSh5/dRgtDxuOVsfVIEUAuBEd+6bNlz9B+5uB4tQrZ9nAwKfYAqet4f/+5OWOSEYOAmWtaf2R2KsVaFKx2uN0fK0oPdPPY2WcvZHeuXBylNlE37zuHwLM5nBEETiqB2wWn5ZVhd5rVDEveVYTOyF9B+qVLza0dofhhbilBDctaGk3bg1Q0oAYTsEKuKPQLy2UmvR3eR3Jl/oV32HZ6iD1PpR5bZUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRXHs3ipgyMgNJg8G42QOSfSHIc77TCC5ldvKK7oaC4=;
 b=GdehaUF5nsb78KeapAGms1H02VQw78jk5QdWAInZXll7Y1Vn1A6upBD0q+5lKRAV1mQtaj1F1sGRELd8uj6lUvLmDWK+FFZjc8/QbFGEf0gyKalb9Kmmlnw83yr8YCtRoQwVfGJD4YyVH9bZNvgLIWrkeenUqL/7hMsWEhO9N+xui3aaotLr86mLS4RFes4dAA95D+K8Qn7hhuXVSg6eLYSR0aCGKeBpstk4kVneZ87Jq3qQFzRFJ4wMIbPMeD0bm/dY1x1oilL1FU4sc+Go9koynu2NyV7duQg+POgEUNqSYhR+bkSfkvOE9TQ/bK1vydQiVb5RsJl7R7TQxdFV4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRXHs3ipgyMgNJg8G42QOSfSHIc77TCC5ldvKK7oaC4=;
 b=KBqllYq+PXvjH7IGP0uDY3vFl/5R+yacdbpC1SVwvsZJ9XduJXzNJwherzJradPMHCrZVMAqB2Ft0OfQU0u/FsL7HJBYRP/oGqOnGmkAhymxsfY9QfvPgFCMy2Mu5lT6OWKJ1sWGObPHWk4hzX0Jetmc5feZtNnfjqY/opszm9k=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1504.namprd21.prod.outlook.com (20.180.27.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.6; Wed, 22 Jan 2020 02:12:20 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::5deb:9ab5:f05a:5423%6]) with mapi id 15.20.2686.007; Wed, 22 Jan 2020
 02:12:20 +0000
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
Thread-Index: AQHVz+AvfPSXwM4tmU6pTPdgXF0O8qf05LQAgACQzTCAAC4wgIAATv6w
Date:   Wed, 22 Jan 2020 02:12:19 +0000
Message-ID: <MN2PR21MB1375DBB53EBFC15229B6ED52CA0C0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579558957-62496-2-git-send-email-haiyangz@microsoft.com>
        <20200121.110454.2077433904156411260.davem@davemloft.net>
        <MN2PR21MB1375A6F208BC94CD4CFA016BCA0D0@MN2PR21MB1375.namprd21.prod.outlook.com>
 <20200121.222829.888926574980511328.davem@davemloft.net>
In-Reply-To: <20200121.222829.888926574980511328.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-22T02:12:17.3500833Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3f3c0820-b884-4fb7-800c-b1cd5876cca1;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70d87c26-06d1-4a46-ec3f-08d79ee082fd
x-ms-traffictypediagnostic: MN2PR21MB1504:|MN2PR21MB1504:|MN2PR21MB1504:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB15047A9C3113869CE86606D6CA0C0@MN2PR21MB1504.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(189003)(199004)(26005)(316002)(186003)(64756008)(7696005)(66946007)(66446008)(2906002)(55016002)(54906003)(66556008)(81156014)(66476007)(9686003)(4326008)(71200400001)(76116006)(8936002)(81166006)(478600001)(5660300002)(6916009)(8990500004)(10290500003)(52536014)(86362001)(53546011)(6506007)(8676002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1504;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YD+rJIQJvXfsffQWtRv9axGgC0JdMJC8HHmqnFakPNVz6K1wsm++muWKbeAUp8Sfu6j96/vy3l/W1NEbUqv+USbZ3AMLqXnMxLsmkgHtG7HXuspxqNtDRrwdnqTLvu6+OWDU6OjsnB3d4R/zxOBz2UZXRClgV8bKbJCt6BIkrNzs1sgLoqSUVYDFqfcyHhRVBdDnFsb3YfIqaMAGChjmskkNLPj6uGeNpP1XYOc/8clfU+dxH4XYUkbeHNTZDQHqHwihz/t53i/Df/QELrbYrH3pnoZvlcTb9CCt8dztUIsnWkOKtB7UZ2XVYbmm0CykIN4cJmuR2iwM86odBsn+A0kBrYCFR1E0MMv2fbzpjQdLCjYIVxJB5D2q+2yyTXzpsLpYhak9kvbQRqXBCDAoSt+m/sxLTp0fmIE8H28kFwIzdOZbk8o4WvVDBFmghIW9
x-ms-exchange-antispam-messagedata: RLjuDuBgXMlVqMyXNFVpcKS7pb0pA+15qbT36F8TNRCjlnQa9QgTJsxRLS6qP8n/G7xbnGqa38rFkmRFzaNNUQHAJX3saRFmXQmtP4O4Inmr5Bq3O1EEAGTbl3uj2uE1AWJe8VH9nPtVTx3E6dFLTQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d87c26-06d1-4a46-ec3f-08d79ee082fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 02:12:20.2627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MStL/8wEb8L+2PqJKEcOrsc1V0XmTltQ4n1Oq/JgvJa2PmxYY9ZisJ21WWsLmeHxUWroq6gT2mbXie5ABjc2NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Tuesday, January 21, 2020 4:28 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 21 Jan 2020 18:53:28 +0000
>=20
> > Sorry I was replying too quickly. See more detailed explanation below.
> >
> >> -----Original Message-----
> >> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> >> owner@vger.kernel.org> On Behalf Of David Miller
> >> Sent: Tuesday, January 21, 2020 5:05 AM
> >> To: Haiyang Zhang <haiyangz@microsoft.com>
> >> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> >> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> >> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> >> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
> >>
> >> From: Haiyang Zhang <haiyangz@microsoft.com>
> >> Date: Mon, 20 Jan 2020 14:22:36 -0800
> >>
> >> > +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel
> *nvchan,
> >> > +		   struct xdp_buff *xdp)
> >> > +{
> >> > +	struct page *page =3D NULL;
> >> > +	void *data =3D nvchan->rsc.data[0];
> >> > +	u32 len =3D nvchan->rsc.len[0];
> >> > +	struct bpf_prog *prog;
> >> > +	u32 act =3D XDP_PASS;
> >>
> >> Please use reverse christmas tree ordering of local variables.
> > Will do.
> >
> >>
> >> > +	xdp->data_hard_start =3D page_address(page);
> >> > +	xdp->data =3D xdp->data_hard_start + NETVSC_XDP_HDRM;
> >> > +	xdp_set_data_meta_invalid(xdp);
> >> > +	xdp->data_end =3D xdp->data + len;
> >> > +	xdp->rxq =3D &nvchan->xdp_rxq;
> >> > +	xdp->handle =3D 0;
> >> > +
> >> > +	memcpy(xdp->data, data, len);
> >>
> >> Why can't the program run directly on nvchan->rsc.data[0]?
> >
> > The Azure/Hyper-V synthetic NIC receive buffer doesn't provide
> > headroom for XDP. We thought about re-use the RNDIS header space, but
> > it's too small. So we decided to copy the packets to a page buffer for
> > XDP. And, most of our VMs on Azure have Accelerated  Network (SRIOV)
> > enabled, so most of the packets run on VF NIC. The synthetic NIC is
> > considered as a fallback data-path. So the data copy on netvsc won't
> > impact performance significantly.
>=20
> You need to explain this in your commit message otherwise every reviewer
> with XDP expertiece will ask the same question.

Will do.

Thanks,
- Haiyang
