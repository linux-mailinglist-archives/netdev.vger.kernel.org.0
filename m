Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9602F267BFF
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgILTd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:33:59 -0400
Received: from mail-dm6nam12on2138.outbound.protection.outlook.com ([40.107.243.138]:57728
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:33:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuDBZDKgkPqytx7ms8q+S/h71ADgDp5d3mU3oaig7PiKBgkVrT5hzQTkhunX7AdoOxmAVIwAgdXS9xpgFW6zmBREsvC3Asq0FDqM340Yk6qvFOLCC2UaXerH5QM6hDzz5YBUh5cBfyogv+p3hSQS8EPNdB/SxR2xMfOnvPlr7nkY4uBkk62RKI+PT629YAS9EKvFPFl28zV9VuOh6CYrdz8oCsUm0IvyXmctySdwHkYUx0z9AOlKxsfgWe7Ib+Dzrjozmc4ys/NTO7JvVNVF/VUIhge4VvdYbuIt79BL/LQeO9F5ngaxJ5bku3ZBs36X48ieU3/ji6rwMtoojLyzJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNggoHl3c50RrezccPuwsRg33rFNKshsIDv1J7Eb8cc=;
 b=N46Tk29aBBJ2VT84B9x6XkGgtibmQ+jkYO/Z5W8PZtWcfm+c52R+xhvHo3MdTPKC1udV389qe3ubikj9DsdDcmM7jTKKvxuvlt7kLucN8OfFXCQOlSA2Y2XGr4DcQmzA7+9tG5MCFz2ewN70kFOCkNh/lb2919vTTqwxnZjT01tCtsp0cQghic2Wb0WkrbtlEQ8dV9YhVdas9a0dYwru726fI//NRiYOAkAjozl96F/nIBNte6RTlDdxitDGmEHMmGfd87P2NbJ9+DitQs5moQBokqB0WxHS3CDhfBSFLEOVnvAymiY7qq7GpmoEhqJA02s3rabXMj4Vj+MipGzZ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNggoHl3c50RrezccPuwsRg33rFNKshsIDv1J7Eb8cc=;
 b=R0KDt8AAzrgrsQGRcUgvdg2xpuK1N5j813fFQPs/gkDBUe4ESS+8kef+PcWCVqYuhKNj+2Mu0Sse5mgDGZFZqX3S0ZSw6h3NaiSdBRdWgPBAKgVf9FujInOfiVUSVYg1IhQSqFcs52gBOUYQM89Pwo01JX7JlErAN4EVF6pRsKM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0512.namprd21.prod.outlook.com (2603:10b6:300:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0; Sat, 12 Sep
 2020 19:33:53 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:33:53 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 06/11] hv: hyperv.h: Introduce some hvpfn helper
 functions
Thread-Topic: [PATCH v3 06/11] hv: hyperv.h: Introduce some hvpfn helper
 functions
Thread-Index: AQHWh3+dWfR1AZ5UfU+bq7AyPqN+qKllaBBQ
Date:   Sat, 12 Sep 2020 19:33:52 +0000
Message-ID: <MW2PR2101MB1052BC61D5EAE1009E8D81FFD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-7-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-7-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:33:50Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=09982c6c-bf57-45ca-913b-64bb882bcd1a;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ffc3c2d1-fd23-454d-9f24-08d85752c837
x-ms-traffictypediagnostic: MWHPR21MB0512:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0512BDDB884E90C811396324D7250@MWHPR21MB0512.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ejKz3oRRPg6t6hYJ84uOip2l0l/hW1JV2c0rwSNzkJGQLPpf9vBmyMsOrRLdSAvEtlzulEH1pPsZorXdOPh2ChJZ11Q/zFAYLjvDYKlc5RL5Uj7Rmwj8hWUg/K+HTPpsboct12B+7UD1sHPuDwoDT2pigyFO5vwiq6ldlwQypsPSyu/6dD5LFfUOlk0NYvfixkjQMpaSHo2AguTyKWzNz/9G+hBvXdO8pTZvHmSTx0u0CiHrZXyWuBNKqK/ti2uuEk8YOGZzA7CNyi5Nb+qlsnLflYLrUcic2HAlYZ60KHBOuAc3v01VQ0EW68CJYyuwR2BgQ0ytv83Tygkt13q/889I2JTrnApefEqWcPReFPsBCBn16kVxnjJiRKNRsQHB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33656002)(316002)(4326008)(9686003)(10290500003)(2906002)(71200400001)(52536014)(8990500004)(86362001)(66556008)(64756008)(66446008)(66476007)(6506007)(55016002)(4744005)(82960400001)(82950400001)(186003)(5660300002)(8676002)(66946007)(26005)(110136005)(76116006)(478600001)(7696005)(54906003)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Bb6MHuOJxlJE1BhC4jP2p5RT+a0rjpS1jdmXLNUpr9HAugC/3mvOl36NVRFeEIWH0VU4Wd9BbppCvs+aU9+8zMTDs96d0vybHP1dAhoVYydK8ZoXPahp7h6pjM60U5l8SY6eheCo9EdjCDQq2ISv0oGXWf26VkZxEAiTqWppwvsCK/sMp/4CTkYU4RseokJZFEOTZGYU2PSdaUGlZU2r8El9Z4fu8bUXqQ+5PiX8tWDn9uUCGP6Z1pZD10AHVJJox6icuitFqnQYv1cg0OTXb4N1DfQiMD6LcZZMyJxvrfU6mO1oKJkHyxIarIvGRrWccY5M5xrGpxl4/1e+l9Ps/MYrXq6QyumE+uDQKFfwbmgx4R+iWmY6D+0A7hJLpCwr89U7/DGwO2Y0JGW3tMUEe59JfHeE95blMrihHYv6daWSdK1lavQWLNPhHqMyDwfXwX2dV0sNIiqMncaEzCTWYfw8FuhzwpDiaoSOHBppz4ghggmvwottkMr+Pg4iTUL6OzbByW6XYzA2ikc40Bum82tTVpE0vHRjFkyf4gFoeB1pecWSReEynsx2BeGxYfD53mQGE4gi7dFZ/bs8UHRpKPnKPloIqnm7p90dW4qz6eVv0XFCyV9fFginYwmFKmmO/Uh9tfGq3RPRloDaeDh6tw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc3c2d1-fd23-454d-9f24-08d85752c837
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:33:52.7700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7/bRNffT/uvy3enbMEir+T1tmwpfn4FNHorA8i5ktCNIppikK8gIQK3Q9jScLAo7tsti2F+Lg7MOKSqRYBwzc5/95pSRrXpH8exLGzZ4QXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> When a guest communicate with the hypervisor, it must use HV_HYP_PAGE to
> calculate PFN, so introduce a few hvpfn helper functions as the
> counterpart of the page helper functions. This is the preparation for
> supporting guest whose PAGE_SIZE is not 4k.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  include/linux/hyperv.h | 5 +++++
>  1 file changed, 5 insertions(+)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
