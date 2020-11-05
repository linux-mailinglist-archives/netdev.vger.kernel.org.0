Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBFE2A877B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732129AbgKETki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:40:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2922 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:40:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa455330000>; Thu, 05 Nov 2020 11:40:35 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 19:40:35 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 5 Nov 2020 19:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4bLIoXCGToxBQvSgPC1V9x0SbVjgNNToQWU8bsFyTGC5kt8M4pWE9qqHYXa9yMKjEqS7gfqkKgVegHhNC3OfI6R5ditw/yxCct0hmmrMzPswgxCt1mTYdpIim78kCZNPyxT/UIxyra2yAoPQvBv+0cWNfP6FW5lqYt4RWjsGfrTB0KJ7vVLszENAQ+1pl2+WA8s3W/M2fMIT20zZsTy5b2DB29qmU5j06KdBdNspDLpeH95Kk1AP7a8pqihMkCGnFOoHofXBsWzvPiLokgUOd186kJUf+KFygG2qC73rKFZmyt7WYRzv9uLPimMGLF6QWBIAoE3VIWuOAF0W+pp1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckTWAVJcmJHIdB9un+jGwufqMIGOqNbXGvDxXKMPzYY=;
 b=SSByxIqaILa8zRybH1PZ65wr76hiIjlg1acz/Hx5V8yssjLSI35EduU1UfcIu5WkE9I/niHNFoLBf4d+xrNI3C7K2WwZvUG9io6DaWAmuJG3hShXVrq20dcB1aXzbvVCsqsokoxcc80MdZtTME+tWW29PvYO6EyyZB0aBkMJk6AZ2qKyVWrx9fNimzMdJSpl6B9MLOoGCWyKPDIPjAKPujhtb5+V+1r/+GFLdVqxqM0m5Hg8CjkaqaABAandDsNFhTFx91BLHCVUpoQ/ZV/GMc34yvT+AnSqjQOtz4gVSvTcZe6M/wQvKvwFoqoEnKRngbpT5Trk1t6pfusTz9wEiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3432.namprd12.prod.outlook.com (2603:10b6:a03:ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Thu, 5 Nov
 2020 19:40:34 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 19:40:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Ertman, David M" <david.m.ertman@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: RE: [PATCH v3 01/10] Add auxiliary bus support
Thread-Topic: [PATCH v3 01/10] Add auxiliary bus support
Thread-Index: AQHWqNRzAuOUFv+0MUGnf97WP/Ijmam5V8WAgACqGACAAAJYUA==
Date:   Thu, 5 Nov 2020 19:40:34 +0000
Message-ID: <BY5PR12MB43228923300FDE8B087DC4E9DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cbbd395-4d7c-4423-0f94-08d881c2a9ad
x-ms-traffictypediagnostic: BYAPR12MB3432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3432611CA7B0B0C3824EF49CDCEE0@BYAPR12MB3432.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P8RZOnIycGiVVWOVZ6t830qi8FiBWVVRUqkHaPEb72TYeWG1YJJ9HIc3cDCdUVH0clv1ocaR5UOFfU5Qpb5vNUuTN8duTzLDEw4iCTgx9r8NELFmFGT5zXjJk4QtBZ6PWgbePUpZvjD70ViZFhCf3VRsKartRJEPR8f55DDzTyG0P9vPK+DeZqkOw+9wHqSEeWhhxb1dNloxa961HYbLadFQNA1qiQ4IC+U7KXeujg66Qz8XSgMnY9eGPdt8Y30KZiXdZy1LggXCQWZIH/h/vLurKfCargmk3kL3aQG2U+IMABXY4HHVxGm+4RJaEOu5DDBPcrd5uxbcNXFHZhXHQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(2906002)(316002)(66556008)(64756008)(52536014)(4326008)(66446008)(26005)(71200400001)(83380400001)(8676002)(9686003)(110136005)(55016002)(54906003)(107886003)(55236004)(6506007)(66946007)(53546011)(66476007)(7416002)(5660300002)(76116006)(478600001)(186003)(7696005)(33656002)(8936002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GmN1Ttlo/CQEUtnb2lJiJFaOtH8hjGZX+W74ei0B1KFimq6GPFNL+/7vgGwPhtX+7pAfLkwHdAEcG+mdQqt+5yy71AeqWNBkHiO1swFg7cIUIGSrPFSFjJfydosFpmw/z9XWsZ9k1d4s6cn8ewiqm6kjDVsSw9Joo2Ai3nxEjGNqKky6u6MJN5+tdn9bkNEod07BToTLtICSkDLtYva9aIOadGmi1h/7aApGBA2PjWioTqQY/9cLEUI9/A8myK83xb8ftwVsn6Ld6uKO101tvkCV8v27b9uHmVxNEQ6xi+jT1KxA5ETdvaAlD0nG4zaGqhivM8Nit97moaVuNkrMmmt+Ekjzm4IC666BeNeRlhJmE6BdM2Sibcp9vCcN3blkaoXFgmlfw8/D+7C596WbnZH5G4X48POtJrLbXD4/QQL5bgoQfuCEROZ6+0TtGv+X74GY88U+JbFx9j/fGG0JttvC4fhkpSBIUpkne38JaJoHjzcIEap1TV0efK3QSti1jAQuIb+9dPkFc6kcdvvuiBSJX5F45VTGPgEB0LuSkV2q9rKMGJdl46yUV4qlL3vUHKE9vorhfrSF35l1xFpugSNxjTCZMOADmOp2w5OQrsqASTEOHDXm76+YCD8lytxIjxgKTMZVNFzCntXoIO9/Ow==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbbd395-4d7c-4423-0f94-08d881c2a9ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 19:40:34.1612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +e3Z0ntovn8/3e4IPiPxBI7OUazovBS6n343cKerKxgk5QpmAzJIg8+5falUhIMqFDgndYfuD7/fTbdt+yQkYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3432
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604605235; bh=ckTWAVJcmJHIdB9un+jGwufqMIGOqNbXGvDxXKMPzYY=;
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
        b=cz0+I50qC/Y5g6pZScjcvegtZUZO2LorilG1h8bpx4DnbGFpR6NLA6+Z9kcwBUqo6
         ZsAgk/ecY7ITvZ6xl3VMnb77odOfTPCGqF/Bo0TuiubGZ+R9gYOsg+8z+tNEWhdwzp
         jHAhMng6befKbbMl23Rvy3BqV93EVZFDGzIxc5hDdetkytFLKSdK1CLw8Jx9lg+mbb
         uwgma1eFRIesxfdUaGKv3+Iy83E9rmR4Ororc2W9k0J+X0QdpVqeQ78aqI6jRPJn68
         G8Tebkxl4UGYKIszsX6E1T6hf7meuNOtZr58ZAS/Am83LYrMa5jUVHe91z3Flp3ExP
         UmuojWmSjg7sA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+DQo+
IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgNiwgMjAyMCAxMjo1OCBBTQ0KPiBTdWJqZWN0OiBSRTog
W1BBVENIIHYzIDAxLzEwXSBBZGQgYXV4aWxpYXJ5IGJ1cyBzdXBwb3J0DQo+IA0KPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+DQo+ID4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDUsIDIwMjAgMTox
OSBBTQ0KPiA+DQoNClsuLl0NCj4gPiA+ICsNCj4gPiA+ICtBbm90aGVyIHVzZSBjYXNlIGlzIGZv
ciB0aGUgUENJIGRldmljZSB0byBiZSBzcGxpdCBvdXQgaW50bw0KPiA+ID4gK211bHRpcGxlIHN1
YiBmdW5jdGlvbnMuICBGb3IgZWFjaCBzdWIgZnVuY3Rpb24gYW4gYXV4aWxpYXJ5X2RldmljZQ0K
PiA+ID4gK3dpbGwgYmUgY3JlYXRlZC4gIEEgUENJIHN1YiBmdW5jdGlvbiBkcml2ZXIgd2lsbCBi
aW5kIHRvIHN1Y2gNCj4gPiA+ICtkZXZpY2VzIHRoYXQgd2lsbCBjcmVhdGUgaXRzIG93biBvbmUg
b3IgbW9yZSBjbGFzcyBkZXZpY2VzLiAgQSBQQ0kNCj4gPiA+ICtzdWIgZnVuY3Rpb24gYXV4aWxp
YXJ5IGRldmljZSB3aWxsIGxpa2VseSBiZSBjb250YWluZWQgaW4gYSBzdHJ1Y3QNCj4gPiA+ICt3
aXRoIGFkZGl0aW9uYWwgYXR0cmlidXRlcyBzdWNoIGFzIHVzZXIgZGVmaW5lZCBzdWIgZnVuY3Rp
b24gbnVtYmVyDQo+ID4gPiArYW5kIG9wdGlvbmFsIGF0dHJpYnV0ZXMgc3VjaCBhcyByZXNvdXJj
ZXMgYW5kIGEgbGluayB0bw0KPiA+IHRoZQ0KPiA+ID4gK3BhcmVudCBkZXZpY2UuICBUaGVzZSBh
dHRyaWJ1dGVzIGNvdWxkIGJlIHVzZWQgYnkgc3lzdGVtZC91ZGV2OyBhbmQNCj4gPiBoZW5jZSBz
aG91bGQNCj4gPiA+ICtiZSBpbml0aWFsaXplZCBiZWZvcmUgYSBkcml2ZXIgYmluZHMgdG8gYW4g
YXV4aWxpYXJ5X2RldmljZS4NCj4gPg0KPiA+IFRoaXMgZG9lcyBub3QgcmVhZCBsaWtlIGFuIGV4
cGxpY2l0IGV4YW1wbGUgbGlrZSB0aGUgcHJldmlvdXMgMi4gRGlkDQo+ID4geW91IGhhdmUgc29t
ZXRoaW5nIHNwZWNpZmljIGluIG1pbmQ/DQo+ID4NCj4gDQo+IFRoaXMgd2FzIGFkZGVkIGJ5IHJl
cXVlc3Qgb2YgUGFyYXYuDQo+IA0KVGhpcyBleGFtcGxlIGRlc2NyaWJlcyB0aGUgbWx4NSBQQ0kg
c3ViZnVuY3Rpb24gdXNlIGNhc2UuDQpJIGRpZG4ndCBmb2xsb3cgeW91ciBxdWVzdGlvbiBhYm91
dCAnZXhwbGljaXQgZXhhbXBsZScuDQpXaGF0IHBhcnQgaXMgbWlzc2luZyB0byBpZGVudGlmeSBp
dCBhcyBleHBsaWNpdCBleGFtcGxlPw0K
