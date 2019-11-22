Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D58A105DDD
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKVAyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:54:24 -0500
Received: from mail-eopbgr790102.outbound.protection.outlook.com ([40.107.79.102]:11860
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfKVAyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 19:54:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5RH0SlYnfkMAfqVQ+ZFqJwsK/137GLvHIhC7ZLcrlqHlyNHutS9wcela8motw28lMO3hpLvFC3GmPSHLL+7MhojvwFdoRbFqbkKQCARr3tPAhE3cdw2skNBLTHjgwqgu4R9uDSlhfqp6wJL02WlDim6tlq9JwFqIHYvJ9LioxIHAAZmJ0ENjhUdfNXLlkQt+NoRYct6vUk02AB8GKeFFCAlcpDCHElqL2td4RIf9b2HVu0mtjDEuIhkeKmpNkMT/hBV+JXOm3mUPVf5jmSRriXDNFfH2zV/hTCdDkRJUP0h38qJE0xIhs7LycuInY8TVn7k0Ex+GbTD/srNRAfjGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9QHbpvqi5SYp3ilMl8F93BnyjoVJFWt++k3rgTHzMM=;
 b=neG8gMQTIjdom6J2CHXe/n80li8s1aTxshQ3IEr2+TpJhDbXWAP/VHTtXcT1Dca4nowODwC5jW4GaUXlHgcBRHiTqKf/l3chWdagotX3f84Slw8EoaPK0eK5ZTLY2hQxbpxlQl4Y4pLTR/ZDv3VfYCjit4KvHBjL24JMNtf5CseOPiy+1t1G1t86svOz0WOPl+Zp/C1HEXPjAXjESies0GQUnvTbMNuM3ZKrhKC6nxfaORrSddoWAYHxmrqew2B562uV0+XbNpo43Rrcfom87Z10Y3B/vgGXR5UTJnyQGB7lPJkBORyaBvnGHTXW+8amUQYAaNug0x0W+JDhCxorIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9QHbpvqi5SYp3ilMl8F93BnyjoVJFWt++k3rgTHzMM=;
 b=RDuZ2HVxl9CuyBCFcMn4XdfK6sO9dSGfq4tqF2CN6MggueePWPiFnERZGL2zj6GP8gOv/6H5Ls96op2/QbFQv8nfXouJpkJB9LdjCkHwrayZm8FA6BWFF8UQbF3HhOpwSpqXIEjODhKpLYrw4Wnsc6anF1nhNl/ANhjVSO5fYxo=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1472.namprd21.prod.outlook.com (20.180.26.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.3; Fri, 22 Nov 2019 00:54:20 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::ac9c:72ce:8bf5:790]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::ac9c:72ce:8bf5:790%9]) with mapi id 15.20.2495.010; Fri, 22 Nov 2019
 00:54:20 +0000
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
Subject: RE: [PATCH net,v2 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Thread-Topic: [PATCH net,v2 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Thread-Index: AQHVoLN/DO59iE8Ib0GhW4llyhRdpKeWPrqAgAAeLLA=
Date:   Fri, 22 Nov 2019 00:54:20 +0000
Message-ID: <MN2PR21MB13750EBD53CFDFCBA36CF1D8CA490@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
        <1574372021-29439-2-git-send-email-haiyangz@microsoft.com>
 <20191121150445.47fc3358@cakuba.netronome.com>
In-Reply-To: <20191121150445.47fc3358@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-22T00:54:18.8139576Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=70dfb9ad-7d68-4c35-b862-7e9ee07c348c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27796e20-6f57-4989-3fef-08d76ee68256
x-ms-traffictypediagnostic: MN2PR21MB1472:|MN2PR21MB1472:|MN2PR21MB1472:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1472C579708A6F57E222E43DCA490@MN2PR21MB1472.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(13464003)(54534003)(199004)(189003)(66066001)(5660300002)(55016002)(4326008)(6916009)(76116006)(22452003)(99286004)(71200400001)(71190400001)(76176011)(316002)(7696005)(7736002)(66476007)(66946007)(6436002)(64756008)(66446008)(66556008)(33656002)(6116002)(86362001)(8936002)(8676002)(81156014)(2906002)(446003)(3846002)(11346002)(10090500001)(74316002)(229853002)(10290500003)(6246003)(26005)(478600001)(6506007)(81166006)(8990500004)(256004)(102836004)(25786009)(54906003)(53546011)(9686003)(14454004)(52536014)(305945005)(186003)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1472;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lBk+E0X08fLNy9vjSvwsroJPP46youD88W/pVr9PN0LkIgtXv9eg/ABzIPKl4tKUpF0Nek3n6a0uzOPrurSQOaureTJs76hgQSuyMbQhJVJ8dB0/6f12kLW5dNLPfMCRu7jQUISpkklxs0qQDzbYFOVKHfq0S+N1b/tW58OuYAdTzMQKfSedcZqcebQIIK84+S3Plj569hgWRDsQUhFvYxAmeu/5VDJjvyZ/5Q1cvqz4xnIru/odLspPkxLI9L/8HPwqxEWVWbW/lbwcqMP7M1lZomBYmmNFASCOw/OT6IdhiO0/mmOi+kg0xQtiKiWaVHR781bHVZVBo/fnH+7Xdq85mHL8fNjI+ueF70oB91aBwyBv3flp8t0lNBmTenb0j0WmlRq5tYjT+GWE32TgQfbYS4eW6zr5RB2hXp21/uqDdfCHzX6CaQ/ocNBjLgN/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27796e20-6f57-4989-3fef-08d76ee68256
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 00:54:20.2119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7beE9xBvtsQ2f3c25sXzZtNWafI4hsdKfyQoZCdkkHZiijpTDNtZAVsJvXU7CkEowvQ/dw6ByfBOFgCwDTsddA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, November 21, 2019 6:05 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net,v2 1/2] hv_netvsc: Fix offset usage in
> netvsc_send_table()
>=20
> On Thu, 21 Nov 2019 13:33:40 -0800, Haiyang Zhang wrote:
> > To reach the data region, the existing code adds offset in struct
> > nvsp_5_send_indirect_table on the beginning of this struct. But the
> > offset should be based on the beginning of its container,
> > struct nvsp_message. This bug causes the first table entry missing,
> > and adds an extra zero from the zero pad after the data region.
> > This can put extra burden on the channel 0.
> >
> > So, correct the offset usage. Also add a boundary check to ensure
> > not reading beyond data region.
>=20
> Please provide a change log at the end of the commit message when
> posting new version in the future.
Sure. Will do that in the future.

>=20
> > Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scal=
ing
> (vRSS)")
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> >
> > -	tab =3D (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
> > -		      nvmsg->msg.v5_msg.send_table.offset);
> > +	if (offset > msglen - count * sizeof(u32)) {
>=20
> Can't this underflow now? What if msglen is small?
msglen came from the vmbus container message. We trust it to be big
enough for the data region.

Thanks,
- Haiyang

