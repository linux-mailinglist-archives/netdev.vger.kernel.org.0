Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A5446F45D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhLIT6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:58:06 -0500
Received: from mail-oln040093013011.outbound.protection.outlook.com ([40.93.13.11]:38548
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhLIT6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 14:58:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQT/oLfbabZdIccOx98hX3xh0o5qE+pBELkP+OOkGilVe6Mo9XK2WVZdMG+9pEvoXUVBMHvKtzHr3R2FE4R++UlauYLlMNKFQz6s7Qik7k9O4hFhvRAXocSd5mTaDfiigKfQb0B1vFYh4am1OB/SozPeLsyk/BxG7Jq11hHKIedgSGAQ0+ROU25HMIdtscZyCvu3T8UHEBNT+BesmttJBsleS0XfLvTBFzYr7UR4h4gNN0F/mdv6j2r/04fF/ef/mMkUQWltOhvBBlLQDzWyLEV9vCAvYFe0cRXj6UAe67oFfD8aTm7Ozy+VBwrrtuBX1KEVmJggtrZp6DlJJLxgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0L0Ehq5i1LLTscdsN9CDciqSiV+8JC+QlPIwMcRVvs=;
 b=GFHydvdy6GGwEniLCejX61uQ3o4Vm4JD9Tw9LuSOwNx30znCXFT1jzHfIBn8axwQ5FDVm8hiS9rtw5mlGjtOdyyHME71ZNimESKKhoIs+NITTzwQ98gpkIGtZnM0Iw3KN44lKZrYG8XGxDcOaZATj55RpUIk2gf3r7QYJQsEqBo6ms4EqRsevQNMMTXIAqqxSyt8FxMzpY5U6vL/YKTu3GLn6XSJ7E5vC+/+seoNJ6ePFfm49/V9TwHJNAWt0Ln6w/3Xzx4GnXna/mXvqOhd1KNY3MbRb6kDOw3aqiATQfJ53MJRw5LWdTuGdMpwdaLRJJYH3zCza3lRTlNitMumlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0L0Ehq5i1LLTscdsN9CDciqSiV+8JC+QlPIwMcRVvs=;
 b=h2y5lJl1SM2LSuMqP3w2LP6USGSOeShzPf8h4y/SmVp3eWLWGQdbv5N5HzfLFq3uX3v4VQCT4/d6RnGqYYjdQ2fdXp/a1COq6HjjMBrUqCIGt1JeWa95ACwL8CWXlfgT9uxB2sm2qVY5Hiqk4FcSKCCeexrrWb/zZzn39R1lPbw=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by SN6PR2101MB1855.namprd21.prod.outlook.com (2603:10b6:805:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.6; Thu, 9 Dec
 2021 19:54:26 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e%8]) with mapi id 15.20.4801.007; Thu, 9 Dec 2021
 19:54:26 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHX6z/p4N8f/0zLXkWT82yvkJZgZ6wpCdOAgAGKX2A=
Date:   Thu, 9 Dec 2021 19:54:25 +0000
Message-ID: <MWHPR21MB1593AF3BB6CBCA14B3805D35D7709@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-6-ltykernel@gmail.com>
 <BN8PR21MB128401EEDE6B8C8553CC8009CA6F9@BN8PR21MB1284.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB128401EEDE6B8C8553CC8009CA6F9@BN8PR21MB1284.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8f2b756c-5454-4ec4-ac2e-44d9b23f1862;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-08T20:06:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3532b909-8c81-40c9-37db-08d9bb4db440
x-ms-traffictypediagnostic: SN6PR2101MB1855:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SN6PR2101MB185583DB943F6F7B7FA4C86BD7709@SN6PR2101MB1855.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a12OiXrXBuq2z78iDNctTXpwb6SYusTzIYEXIzF9bh6qUJr+LPsUGLxrcWOtnKejH/jA71Vn3/hRhrkr30zyxbxYnbikKr32YMKpzQHx6t10ImzIyCjFkBP3AFFQmZmCJe3aTn8FhHKRXcC9q1xaAlrVHK8C43bpiiUc4FLI58GspvRZwQbeYL2ZeAXWMPoFbnGH7BwQMYNBjv8PKHpCG3nPNaIUNTe9mqVrJatLTEFNmfUTLKE6ZW1p+BDNc+ww0ISpOSUZBDpTY5bBTtlXrYJaeXquWHEAs9qHKYfJOhgmz0Wpg4TFLieZa/6eTNy6xE+sBKIovZd7Jal6emeOPAmU/X+4V1WmiGLueIJaIFdlnOVPEppFuWcKEm7plrmH6IG8LwNLBNV9ov77Wmef2EYwxgDv82NW+tpgjB5lLSjRAQwl2UNEKjtdf11IJku3YH5wKpabLHSCzenKsW9O5i3hyDMOXu5riqrVjxA3fayZY0ifMe5vQHPnhmxD6oEK8TYq10/95B0w94naU2Ob6tb9nKvQeUfYGLGuzgAiH4xrLR4xT7N83jsZGDZosC+GUk5q/yj1hGHgXm+KlLy8H8ua94WqcCJFJsNYnKk5W8wBYnaM/hLCZLUieea4ej/sfZ7O1H0UtSR0K8d9cWU+ZPRp4mv7WWddMaeut/ASmaF287FHT4sdI0Q+Ic2/Jvrn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(83380400001)(6506007)(8936002)(921005)(7696005)(508600001)(82950400001)(82960400001)(10290500003)(71200400001)(7416002)(33656002)(38100700002)(5660300002)(9686003)(38070700005)(52536014)(2906002)(54906003)(64756008)(316002)(4326008)(186003)(76116006)(8990500004)(110136005)(66946007)(66446008)(26005)(66556008)(7406005)(55016003)(122000001)(8676002)(66476007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 4IpGc1OhfBdKKqxnSdVHZ28drWU2IzchduNAjcc/J5wUvTz48FgxnjzlMJVzb6KtIcYWPxwyl6Ok9N00/DAK8/TCfjjbQkgarowUex+wgYMEktEAlXMffnBbO20XPTz+LbKbqobIV1uK5JWQgzHUj5PkXCJ1vEnGJG3iBgx1+YmsbkgaCxa27EUrKnRpPn+xH75dVKll5XOWwaIycRHyPAp5SkbE8fdTbXoHJB5NeYXk5olNfFiRtYKgCu+KMmDVuZyhJXresCOI8fSqNsHe3CIQO/ni+HWa9Xku5+AxfMZMDkrrwEbtpPt0b5XaiBDN0Zn4yojPCCkMzThhMi/YZ+VjC8q9puc7YG4UgA4fITsDBigauNxGIStXqOL625y9/c072MUAXxkw4bOhj3N2HYLO08i5wp+CGBGK2jVtmupDycl5637/MdZM9RAWl6qrIhxCX89BKME7+nkA+qcMT5IvSbz4EL5z2c1I/zQ3lR0xJhBX2q59axe1t/CBKPgP
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3532b909-8c81-40c9-37db-08d9bb4db440
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 19:54:25.8519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GIMQ+6UyJhE6eyTFBlqtGCgXVSWCbcshMc4F2DixgP0wOOkGjwIQBIz4e+87S+CsF/bpsOV1zqmlk83x+Ao0u6krNJQbWt0BBtVdKGfxm4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Wednesday, December 8, 2=
021 12:14 PM
> > From: Tianyu Lan <ltykernel@gmail.com>
> > Sent: Tuesday, December 7, 2021 2:56 AM

[snip]

> >  static inline int netvsc_send_pkt(
> >  	struct hv_device *device,
> >  	struct hv_netvsc_packet *packet,
> > @@ -986,14 +1105,24 @@ static inline int netvsc_send_pkt(
> >
> >  	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
> >
> > +	packet->dma_range =3D NULL;
> >  	if (packet->page_buf_cnt) {
> >  		if (packet->cp_partial)
> >  			pb +=3D packet->rmsg_pgcnt;
> >
> > +		ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
> > +		if (ret) {
> > +			ret =3D -EAGAIN;
> > +			goto exit;
> > +		}
>=20
> Returning EAGAIN will let the upper network layer busy retry,
> which may make things worse.
> I suggest to return ENOSPC here like another place in this
> function, which will just drop the packet, and let the network
> protocol/app layer decide how to recover.
>=20
> Thanks,
> - Haiyang

I made the original suggestion to return -EAGAIN here.   A
DMA mapping failure should occur only if swiotlb bounce
buffer space is unavailable, which is a transient condition.
The existing code already stops the queue and returns
-EAGAIN when the ring buffer is full, which is also a transient
condition.  My sense is that the two conditions should be
handled the same way.  Or is there a reason why a ring
buffer full condition should stop the queue and retry, while
a mapping failure should drop the packet?

Michael
