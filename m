Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E94B24A6E9
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHST34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:29:56 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10121 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHST3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:29:54 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3d7da40000>; Wed, 19 Aug 2020 12:29:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 19 Aug 2020 12:29:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 19 Aug 2020 12:29:54 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 19:29:53 +0000
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 19 Aug 2020 19:29:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4Bf1W0nvKPi9uslhtMX/Jca2/Efm0IL9sDzPXMIdKUmYU0AkDAMpdJJO2a+94GCDQYDT7k7ZRTYlwIOw5taO/C8VSWLfTjH7GikJivFux1R/maEfP0DuStF8XLXMaUNRFvMHvqJlIz7TPigrpIiPMqoFH2kR8u3L9UdV32vcWiVAfFmmCTd3DNUKzYnRCskg3MBwtat62XFn8wWqrh5eMnhpXy4QvQsRc4FnD0pEbOIIrvtcVKUCeX9BQdrcGuC+iVGdmooSAsGwY9X0gjk2IliTNUe1bBvOEiZjdrBuAEq67V3w+nxGoRmtWl1TA9lVRcLUbhZGNCV1EmMmCrhiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PasQ6GxcMDeEN11O8QC3pncaurITKXDSyvn8tMkbDw=;
 b=ZXHt9yWJ4or6J2E+vtk9ZLPbMgdZNnTk1lq0TlenpfkYTaPfIDIVAIJjic2dg71bMx8pOc5/dvnIc2YqttV+oeMnuPoGrOsQ78W6VSwptzk4EwzNZ4u5V1ZyxmQM4JatY4hMOMX4/BJAXmMZHYytYdGTOvvUIlZzkJn8OBXJHvhCEZfrLQr3zNX4B9qMaxcnORiVL2Dj7baLi+F3673qN+VqYBzVmAZLVJ/NeDiawogSFtPQy1V9fA4ck3i5I3gi81SoxLowBWyki/yt3rJaUlVe0GLm/U7Wn46HE5h0v5mD389y90OeifPtmcreySYAS4xxeIH5aVlWD+W3SUaI0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2664.namprd12.prod.outlook.com (2603:10b6:a03:69::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.23; Wed, 19 Aug
 2020 19:29:52 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e528:bb9a:b147:94a9]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e528:bb9a:b147:94a9%5]) with mapi id 15.20.3305.024; Wed, 19 Aug 2020
 19:29:52 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: remove erroneous fallthrough
Thread-Topic: [PATCH net-next] net/mlx5: remove erroneous fallthrough
Thread-Index: AQHWbGgclkrvAGzKUkKQzJ7+RKwEoKk/5WUA
Date:   Wed, 19 Aug 2020 19:29:52 +0000
Message-ID: <d6eb19690bd2e996d9dfd33361a506af7c53b325.camel@nvidia.com>
References: <20200803143448.GA346925@mwanda>
         <20200803154801.GC1726@embeddedor>
In-Reply-To: <20200803154801.GC1726@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eb02a44-f6f9-41c8-885c-08d844763f1a
x-ms-traffictypediagnostic: BYAPR12MB2664:
x-microsoft-antispam-prvs: <BYAPR12MB26648E23F35DFD748F5C0525B35D0@BYAPR12MB2664.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1QUtvOz/AVCZflI3on4CVv5V0Dfb1fSuvqgcI11M5V6Hmw6bDna5rhDXb6xsn2sEEsh8XH1BY3TkKDquWQYKEBfjxPIfUiw8rgaNxO/mVhZDpFRonPf7tkVMJK8Q/bY2cUuqBXErn3RdfCBx9rTx8SRkTsxb2lyH/2q4iSnKKmiBGlQv/A3U0Y5xhvtITzvuGbRpfFKHfC5qcXFF1pirds3NQLnGWdIVAIWvHG0PK4PzOOv3bWwPyFv4IeX0Qp3ouXkHBRQrGUYqmCpJmG4TeqxBr9vy3cjr/9Bs5R7Zf4dNOvEv92LEhua3BQ71DmDV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(316002)(478600001)(2616005)(186003)(6506007)(8676002)(8936002)(83380400001)(4326008)(66476007)(2906002)(6486002)(64756008)(66446008)(4744005)(66556008)(110136005)(36756003)(76116006)(71200400001)(26005)(6512007)(66946007)(86362001)(5660300002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fxDzZlwrs24IgR2xJRgjCRqHqZIbRXF6be4K4aLXGdpwZB5siSwazIF3SqBsseqIRORcdHFQAO2PVxOoZHwO8BAvB5PVxHOwXUrYZvvp0hW5SAVagz8uKyWdsd0N2InGo1pML7LyZSJRx4ZTR1XDFm429zkcKtgFApApwP4ekrBl8cUPsIO6JpdX1xR1j/19YZh/S/1S0QoKZP55fpM/vGBmwkXok9NFzQPebPK26gAjlC7coaAy/Fn2FfQ01YjUSlvSYV1mknkAXx2N3JOGRCuzxVzEFHxpuySsy/YxqQgeFqh9I0ecai5SyTBY8HLU5nSCpZeC1r3CGaC97yUEuvuJmOp7/SsKm8VCFtqSAzUhFuGcn6S7VaJo9tbWfEzO+QtMLPf8SHt93uP40tgrLYoCklnGzqNEv3Ym/o95sXuidfFjc6a7qHGDi4kmYr4tRgXIyFULgQj8su5xWqepP+cjqQP4ABOrEo989rvBmEjqYDx9lgWI+8CqXGpD4ZmsPH9G2HyuZjyIh2Cv670vVaVkNA4KXgyq6kOIkTd0SDTujPahyL/4KjlydDjm7/O9pi5b67gTgEmltG3E0ZM8pVXDYtwbJFW7ts8Fs6yLw7LqaMvYUf2Yq2xjUWxHDqWVPt7pCF7rQ53JKVXyhKyQSQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C97AD5E7C9B9041A524DBF546A3DA9F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb02a44-f6f9-41c8-885c-08d844763f1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2020 19:29:52.6905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lOex19YjB/BttcDWDosElHDS2EDq8NF8jsQ/yhtRV2cctZz9sfkTF8BTBw1/OSNvSSzG8X4rgxHZU5jmtTv13g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2664
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597865380; bh=1PasQ6GxcMDeEN11O8QC3pncaurITKXDSyvn8tMkbDw=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Y5pNyrvJ6zZyr05TMIuc+YqulNnioSnwX9vSttGiBaxOplXgbKeJa0ntUXb6SFcLV
         PQQ9hAkPiC865fl7/QmdjBHVf4SjnnTH3DHBx+2XNYdt+BzyYTEymrTauYJEKpyJ+Y
         Xd3g7Sp2fcujKjs/amFyCTD4iGMp+rctQVzSeuvnv274rWuNmg6b3U35X7BTJ5Psi2
         YgA2sc8xmCmNMO9PRUHse+N5dikJOzN9m14LIwi6DHvgLiFGIQV1INjdpTUIWXM7HA
         JQ/rmRsHnbalnlxTF7Te7AKWehE5n3uOMWkgnSY8HefEeqKFDmw9RNy7v6sERWZMTX
         J/YdvQ39pzmKQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA4LTAzIGF0IDEwOjQ4IC0wNTAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBPbiBNb24sIEF1ZyAwMywgMjAyMCBhdCAwNTozNDo0OFBNICswMzAwLCBEYW4gQ2Fy
cGVudGVyIHdyb3RlOg0KPiA+IFRoaXMgaXNuJ3QgYSBmYWxsIHRocm91Z2ggYmVjYXVzZSBpdCB3
YXMgYWZ0ZXIgYSByZXR1cm4NCj4gPiBzdGF0ZW1lbnQuICBUaGUNCj4gPiBmYWxsIHRocm91Z2gg
YW5ub3RhdGlvbiBsZWFkcyB0byBhIFNtYXRjaCB3YXJuaW5nOg0KPiA+IA0KPiA+ICAgICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jOjI0Ng0KPiA+
ICAgICBtbHg1ZV9ldGh0b29sX2dldF9zc2V0X2NvdW50KCkgd2FybjogaWdub3JpbmcgdW5yZWFj
aGFibGUgY29kZS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4u
Y2FycGVudGVyQG9yYWNsZS5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogR3VzdGF2byBBLiBSLiBT
aWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPg0KPiANCg0KQXBwbGllZCB0byBuZXQtbmV4dC1t
bHg1DQoNClRoYW5rcyENCg==
