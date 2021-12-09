Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55DE46F514
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhLIUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:43:46 -0500
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com ([104.47.58.171]:6169
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232181AbhLIUno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 15:43:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htqV3jBN7CaEQU1J2oUeBl8nbKy6GfXVD2aySqKY1aFYfqHCtqzf3svSMUHJFNkTZEEdVADisNSvacfVmoCxazAgtvWsInbovrJ/NvUHPJwPWMxcaqMCGoO1o9lYSLGadSWONXstu0w7qwWgNQHnPD4y7Z3FjXY/7XVomplhUPGI1sg1m2V6PRyB1x0o+Lb/ZhVoYKiKLu6JBVLCgE+IxQqXksrDYs5KVSBNxqdlCLDFa8r3D78DQFo+4udi4TRdY6wx3BhdB90mKF0ULTA3P7e4Soh7awo525s2SlSPaQr7u4CNni6yLQuXR4/yxqvNK7KGfUn5XhOutKkiZA3FJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7p8b1XwdE3F/M6Gl35FVEnJ8LqpZsmT0Ph/6PQSOatc=;
 b=mCvGA05/3xkLMMzpe/YsJYw6v8fqpPnJUP+T+hBWS8+DHI4Mizn0/8Wu15SAIQm+4e0HiCHE3RJO/qZoBpTm6t3NZoDeI9U4E5ZMqs6J7NIgHk++w7Jm1v/CIxrDsGTIvQBbBRVg6FlZhbr97wIJ0FKtL4WpRqx1zIZhgPsi8wZ7NF2zmxje9AoPFAD24RWToMwKcA9GHcSCaebflUv/IapP5mmbrvt/YNfLLn3y2Ek+RrC5dLAqK7qfFBImlNFo8fwghUvgnyJ6v5BIj618lMhm4jz7Y0HS+xurtFyp34D1GiIvNC9c3GAFfFJIq+miZkj25GjSo0V5D8rfTift3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7p8b1XwdE3F/M6Gl35FVEnJ8LqpZsmT0Ph/6PQSOatc=;
 b=AyMw1XoMtS/wrW2Kb39SIyurIDOZWKhRjXidKoPy60v/NLhf90EimWktB5AET+YTaNer0VCFMquQzWOoMs2Glphv15KV0prTzLxxK6hXVwqSGONf+YCfz1r4cfWMCWo6BQPyJ5NVKrRGIhJWkKkzyTq7HtShRIBRsvb01YRtEPk=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by CH2PR21MB1464.namprd21.prod.outlook.com (2603:10b6:610:89::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.1; Thu, 9 Dec
 2021 20:40:02 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::8425:4248:bce6:df4a]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::8425:4248:bce6:df4a%6]) with mapi id 15.20.4801.006; Thu, 9 Dec 2021
 20:40:02 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Thread-Index: AQHX6z/p0yAcVt7N4023h97u6uYex6wpB5NwgAGPD4CAAAR10A==
Date:   Thu, 9 Dec 2021 20:40:02 +0000
Message-ID: <BN8PR21MB128403BCF7A491E55F8E2B26CA709@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-6-ltykernel@gmail.com>
 <BN8PR21MB128401EEDE6B8C8553CC8009CA6F9@BN8PR21MB1284.namprd21.prod.outlook.com>
 <MWHPR21MB1593AF3BB6CBCA14B3805D35D7709@MWHPR21MB1593.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR21MB1593AF3BB6CBCA14B3805D35D7709@MWHPR21MB1593.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8f2b756c-5454-4ec4-ac2e-44d9b23f1862;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-08T20:06:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14806b1e-a37d-4316-496a-08d9bb54135d
x-ms-traffictypediagnostic: CH2PR21MB1464:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CH2PR21MB14647D453BF2B088B4B388F7CA709@CH2PR21MB1464.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rnwVsd4Euib16tKoAVYZMO0/sIWPNyhjDaiQdV+RpDHH2EymeAHKK2igXzB1+Vl86RT0OEaM+ByxnRZIc53Tfo8QzqYj/Wrzl52i9YRbpa4DVtzleYDSl3b/1yz4glkkzw24mWwK8XNiAIuQ46UdtWhXVqOjmg+yIeie81O90ksS4JzHTfL+LWKjlg+G/yQCFaZl/2eStMJcFPNnsbXE6sVg8XOF2SRJ6ejCXTrz7bCkYXd3x7O4j64+33Do0GzVaQvVY2WG9se6MkeYtGroGpLzU48J6wlbcEp00TjK1p/+jRQlwAO7HMAKV/Z0hWqC9ZuNX7+R4Ir9fUMDUKUY4uwMJdPSqGqzcPgTiK7jx3twN99T7rrZUeYkDxWmZ5NnnRLSpahbGcNPE2aiqQcdZ7mrgP+WscgkyEqTCUegJiaDKhjAZNPl5TGpu7JZMH08V0Durpfgt+hJ569/TPvnQd2ZSTLG8Xwqu8OdJIeZupybI4hd5/1gbmuDn0tJbySG/qDmpSfz53G1BT0LQrj0tHTkpTiDBkR5SzQV4ltid1MVyRJRGnqwCw/bcp5h7siioSadZv3IpANYcPjn8cbA/oholz+VrfNhCfFgaP72nhQqwItK5yRAlvO5peiBgI3HFpeMTt8vqhrlRR7sGvFQ/60iAuU62BEu9HjyYwSbvTa+Ln/cRi5mBd4ntvsJLBJ4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(6506007)(921005)(110136005)(66946007)(66556008)(7696005)(316002)(66446008)(10290500003)(54906003)(82950400001)(5660300002)(64756008)(66476007)(52536014)(38070700005)(33656002)(83380400001)(7416002)(71200400001)(508600001)(8936002)(4326008)(8676002)(8990500004)(122000001)(9686003)(82960400001)(55016003)(186003)(53546011)(26005)(2906002)(38100700002)(86362001)(7406005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: RgWIlGmnWgAdYNi2dLgtp1PSAS5cjb5bmZ7RKwHEzClCEIglFu3Rtv0pZ4Kkl4b7r7RI/qPPVASGBTeV/PQhLVw7pWOdbFaX9HBYPkcYQhf7lf1x49bjpN1x2oLIs2dhGgdzlJYJnYEvtpQoyTdQfZ0QBhOxin6cM04T5mUhpk6fgyw0Dm6FRq/SpgPYLgtLseqdJPa/l8H1aNIGqODibagtM8JK6t7XkmDSiVZO6aulkpeJu/G8ZyHNUkUQjXT6uieIUb0KRA2KvfLMII9bI3qQYXyIaPRhv8azX9VfCFEItRI8pia0Sfu6a8nokWnRH7eGEY5FyFF9yGg+2TIhLlyM8vVRdMk9OTddoXtxxI1ulQfiz965n7U9XGsdWKWzFor0gYuof6NJr29WWn6JiieP7+w0DUMx0DViRE0od3wln7y4Sr0mwNFnv1auL6G4
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14806b1e-a37d-4316-496a-08d9bb54135d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 20:40:02.4713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ID7Jqpm4V0zjNVUtyp1XC/Nr+He39/vtQelzcUBbbZpKACOnLMjgag6onOl7XlCTemGy2T+x5KM3oIIZ/83FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Thursday, December 9, 2021 2:54 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; Tianyu Lan <ltykernel@gmail.c=
om>; KY
> Srinivasan <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com=
>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>; tglx@linutronix.de;=
 mingo@redhat.com;
> bp@alien8.de; dave.hansen@linux.intel.com; x86@kernel.org; hpa@zytor.com;
> davem@davemloft.net; kuba@kernel.org; jejb@linux.ibm.com; martin.petersen=
@oracle.com;
> arnd@arndb.de; hch@infradead.org; m.szyprowski@samsung.com; robin.murphy@=
arm.com; Tianyu
> Lan <Tianyu.Lan@microsoft.com>; thomas.lendacky@amd.com
> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.ker=
nel.org;
> netdev@vger.kernel.org; vkuznets <vkuznets@redhat.com>; brijesh.singh@amd=
.com;
> konrad.wilk@oracle.com; hch@lst.de; joro@8bytes.org; parri.andrea@gmail.c=
om;
> dave.hansen@intel.com
> Subject: RE: [PATCH V6 5/5] net: netvsc: Add Isolation VM support for net=
vsc driver
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Wednesday, December 8,=
 2021 12:14 PM
> > > From: Tianyu Lan <ltykernel@gmail.com>
> > > Sent: Tuesday, December 7, 2021 2:56 AM
>=20
> [snip]
>=20
> > >  static inline int netvsc_send_pkt(
> > >  	struct hv_device *device,
> > >  	struct hv_netvsc_packet *packet,
> > > @@ -986,14 +1105,24 @@ static inline int netvsc_send_pkt(
> > >
> > >  	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
> > >
> > > +	packet->dma_range =3D NULL;
> > >  	if (packet->page_buf_cnt) {
> > >  		if (packet->cp_partial)
> > >  			pb +=3D packet->rmsg_pgcnt;
> > >
> > > +		ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
> > > +		if (ret) {
> > > +			ret =3D -EAGAIN;
> > > +			goto exit;
> > > +		}
> >
> > Returning EAGAIN will let the upper network layer busy retry,
> > which may make things worse.
> > I suggest to return ENOSPC here like another place in this
> > function, which will just drop the packet, and let the network
> > protocol/app layer decide how to recover.
> >
> > Thanks,
> > - Haiyang
>=20
> I made the original suggestion to return -EAGAIN here.   A
> DMA mapping failure should occur only if swiotlb bounce
> buffer space is unavailable, which is a transient condition.
> The existing code already stops the queue and returns
> -EAGAIN when the ring buffer is full, which is also a transient
> condition.  My sense is that the two conditions should be
> handled the same way.  Or is there a reason why a ring
> buffer full condition should stop the queue and retry, while
> a mapping failure should drop the packet?

The netvsc_dma_map() fails in these two places. The dma_map_single()=20
is doing the maping with swiotlb bounce buffer, correct? And it will=20
become successful after the previous packets are unmapped?

+	packet->dma_range =3D kcalloc(page_count,
+				    sizeof(*packet->dma_range),
+				    GFP_KERNEL);

+		dma =3D dma_map_single(&hv_dev->device, src, len,
+				     DMA_TO_DEVICE);

I recalled your previous suggestion now, and agree with you that=20
we can treat it the same way (return -EAGAIN) in this case. And=20
the existing code will stop the queue temporarily.

Thanks,
- Haiyang
