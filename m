Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDE2ADC86
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgKJQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:58:42 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49834 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726152AbgKJQ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:58:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAGtCPR026560;
        Tue, 10 Nov 2020 08:58:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=k4aSnD2Q9ha70GHR8ViRQOXMBlnmiYgtwqNQFiYpgUU=;
 b=egYYdVIlnRMMT/gBQy5+oUdZoQ8PveqjumNvwf13Mkp2Fumo5Es0l0jLPuODdcZAOXA6
 bVADc3YbI4jGHx6So9cdnBCQ+IQgk7nZ6UKUNjSaVZUK23vqg/M027S5XlFYcbXD2lEF
 cdmT0TnMcXoIHLhMZaNa8LuKbaacw/YmPAZ44MWSNmTdwBBM2xbtgKvmazblrNyKq1la
 cuLhYVZcrx5FY/4w7cmGzlQvZ3+jCYE//UirvGKiqKQuW0T6S9qo0lRw3cP6ewHnu7y1
 /1NE/MV+ygSiVeJfzzGq8lQ/Xs7sBqnWfHRWiu7CU96iSgWbGZi4kx2R2eZqj7Balz+o ZA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34nstu3f67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 08:58:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 08:58:38 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 08:58:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 10 Nov 2020 08:58:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keCaOKhwi2g0WsUoOJVmGbaC3QZDKGlp6GWGyKn8WZTqC8NbQP3R+6kGpnIG2v7YFSAg2BV50Sw9EWRucZHmUxFo1EW+ooJQFpx8bET8+8bE1LRZXb7KlFE2aSO1778LOneDuaM+K/96YB1LvLZyVblIcwnzRGFbfZft8iaL5L98ctmsYiGQCZsfdt9IKqeVPUOieMCYj26rNwdK48wzcuTNobLjOLQjBgPDnJVXYjzNOOKaOA9uIoPBNORJTUzfJKKmtIxlMCdgvWaUvKEC3KnxLCl6fYgN8/EN1XZCq6TPVmGUCcDbi7Bz8p8PrHhHOjg4PAB1gk4PWOMwpP7XQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4aSnD2Q9ha70GHR8ViRQOXMBlnmiYgtwqNQFiYpgUU=;
 b=BWsZPoO7wyQfpjvj0SmXuSgV7jNKKC+bFsIaB0+iA/fBfKYZo7kE1GqbY0wL/Jhqb+B1WkwiJCKJ4m1yfIVD86k12Nerlu5v/h25SxeZcCrt1XjEZZf9UVNqS8qSnjfKLiqgGsK0LPCb3b8X0mOXsg7lU35Cx+EQR6nZLDOmZVceHCu1lUACdYIQz0uA7TabgELap1MSTRT0nfFTKnruo8dm/acY9vO43+RLlrf+EucGlcdBEIoZ3hS299M5i4U1gRoPZZdNqdSIQkmzCrO/KjrHkiddVRQJ91yj00I2RTtfDeFWvlL7id1ojI8RnVNwcNzUjQFRyAjbyCrrBj5nuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4aSnD2Q9ha70GHR8ViRQOXMBlnmiYgtwqNQFiYpgUU=;
 b=pCKuOTXLoTmUQ+GmbaWVC0bwiX5RxmRdtRxefFGeY4YZ/4nm4Q+8by/4Pp0hp6Iv+L/vcl0dOV84d6SpHa9X79I36dgWOpEpq9ahopXCq0sVTdFkuYbUZk0wWZggGDgBJs1Kumal/LvJtTnBMN5nH73KJ3/rD6qoeaj/EXNcJew=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM5PR18MB2231.namprd18.prod.outlook.com (2603:10b6:4:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 16:58:34 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 16:58:34 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [PATCH v2 net-next 09/13] octeontx2-pf: Implement ingress/egress
 VLAN offload
Thread-Topic: [PATCH v2 net-next 09/13] octeontx2-pf: Implement ingress/egress
 VLAN offload
Thread-Index: Ada3gh/lXtHvZtK/RNOZdF0oMDBAvg==
Date:   Tue, 10 Nov 2020 16:58:34 +0000
Message-ID: <DM6PR18MB3212928A5167ECEC681969F7A2E90@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.208.47.103]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e6b328f-b4be-46d1-5bb6-08d88599dc1d
x-ms-traffictypediagnostic: DM5PR18MB2231:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB223107468A221DA238B4A276A2E90@DM5PR18MB2231.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +t5do8VzpOYOvyYyBHHhxiavfByK+1SNlJzB22e1OQDuLiwNSmlMqafudUUZJo6ginHFiq4qSNBs8bW8AMMvd8n++IJG2LJxjEjynpHBOYSZar3v7jU5O11m2ObwGTmJ+ImF8/eHAaxHCSGbclArJY37my0u6JEiRxCrpJ5A/hF9fHV4WpjeIZ7BPwYD/LFrSBnhRY7MFpVaXML851yEn32RhH4Rr51IDy2ROmpdcqdLYt9AXLwnus82QYpJ8umqj0CeVwAS2GxkI3w6zrGJ2JykTjJfu1/HH2Gbj2vcqcJFTO7FrlSLQ+7zKokMrIS9YtUJbQuLAPp7CkChMprwqleWuZYwXViWzdsOVRa9MPnlLY+FGsH8b0qvLXNCQFasdSIjLQh0rPx4CBffreU6wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39840400004)(366004)(376002)(136003)(110136005)(54906003)(19627235002)(55016002)(9686003)(71200400001)(4326008)(316002)(83380400001)(86362001)(52536014)(53546011)(6506007)(478600001)(8676002)(26005)(966005)(107886003)(2906002)(8936002)(186003)(66946007)(5660300002)(66446008)(66556008)(66476007)(64756008)(76116006)(7696005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 41zuxxaYqklXGdbMUAtKg/EvKCSPzqpRGax57+8EJJNZBtqsNUh/tpZjU/f6lF4jiklcKGvd+q/shJpbPlQNUb6DCAecAXR4Gp8sT4zfFNViTqXxNW4CqOQ1vaFtWXDvGXg/0Edr/jy9UNYJ0IEwtt4qUmL+OBxnWutX8MEReDhfLGSq0tHh/kslHu7LehjTDtHCrFD5m1YSLzcJqek8ni2rAHNyChpLc+AhxE9Zq4GsUyNyaMjuJtqXAPHTjAhnGkYmHC55cXAfQX6DtNkDOoA8XLEjFjYTk5zeA16YqwZaQ8fhW7X5gMFkBpi2JEkGts8DLtfuJh+tuZ6bVG+al6HHYGSLjV/15zZ86Te1eH1dmEyPUbH3QI26vjScKUIJRHmpsILkVNsRNR2AUH1HWMbD6I3rIsMyYapwicg32A6T/WhCVH6TrvHXFDbtJ3UfHkVPz6mQBWDq3iB+mAR9K0gXXEvdH/CVApFkDX6gkp07xJZISy/TXXjt//+nHlflLRa5YleIfMTcH00F4w9pdkb5GdwpXyNDsh9s7t2hsA2LQ4a+gPzb9nXKYfdCRuqRBssdIJbnJwMCi8xsQ9Hmc58Rr/laTmVnCyhj4I753wj211R3tCXVGZa+DUI4WCfyxTSuDiaYU0D2t4Mt6hvQoQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6b328f-b4be-46d1-5bb6-08d88599dc1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 16:58:34.0438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fWW0jUCQt8t9c1mJyW/HzAO1eF+0HxaL8/bTGCVLZSzSi3y4WpL+hgyUKuB8jO4uUdWFfrEP7Xarl09mQm9e8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2231
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_06:2020-11-10,2020-11-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyENCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz4NCj4g
U2VudDogU2F0dXJkYXksIE5vdmVtYmVyIDcsIDIwMjAgNDowMyBBTQ0KPiBUbzogTmF2ZWVuIE1h
bWluZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVsbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrdWJhQGtlcm5lbC5vcmc7
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmlsIEtvdnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1A
bWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2Vl
dGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IEplcmluIEphY29iIEtvbGxh
bnVra2FyYW4NCj4gPGplcmluakBtYXJ2ZWxsLmNvbT47IFN1YmJhcmF5YSBTdW5kZWVwIEJoYXR0
YSA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT47DQo+IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2
ZWxsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiBuZXQtbmV4dCAwOS8xM10gb2N0ZW9u
dHgyLXBmOiBJbXBsZW1lbnQNCj4gaW5ncmVzcy9lZ3Jlc3MgVkxBTiBvZmZsb2FkDQo+IA0KPiBP
biBUaHUsIDIwMjAtMTEtMDUgYXQgMTQ6NTggKzA1MzAsIE5hdmVlbiBNYW1pbmRsYXBhbGxpIHdy
b3RlOg0KPiA+IEZyb206IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4g
Pg0KPiA+IFRoaXMgcGF0Y2ggaW1wbGVtZW50cyBlZ3Jlc3MgVkxBTiBvZmZsb2FkIGJ5IGFwcGVu
ZGluZyBOSVhfU0VORF9FWFRfUw0KPiA+IGhlYWRlciB0byBOSVhfU0VORF9IRFJfUy4gVGhlIFZM
QU4gVENJIGluZm9ybWF0aW9uIGlzIHNwZWNpZmllZCBpbiB0aGUNCj4gPiBOSVhfU0VORF9FWFRf
Uy4gVGhlIFZMQU4gb2ZmbG9hZCBpbiB0aGUgaW5ncmVzcyBwYXRoIGlzIGltcGxlbWVudGVkIGJ5
DQo+ID4gY29uZmlndXJpbmcgdGhlIE5JWF9SWF9WVEFHX0FDVElPTl9TIHRvIHN0cmlwIGFuZCBj
YXB0dXJlIHRoZSBvdXRlcg0KPiA+IHZsYW4gZmllbGRzLiBUaGUgTklYIFBGIGFsbG9jYXRlcyBv
bmUgTUNBTSBlbnRyeSBmb3IgUnggVkxBTiBvZmZsb2FkLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFN1bmlsIEdvdXRoYW0gPHNnb3V0aGFtQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IE5hdmVlbiBNYW1pbmRsYXBhbGxpIDxuYXZlZW5tQG1hcnZlbGwuY29tPg0KPiA+IC0tLQ0K
PiANCj4gLi4NCj4gDQo+ID4gQEAgLTU2LDYgKzU4LDggQEAgdm9pZCBvdHgyX21jYW1fZmxvd19k
ZWwoc3RydWN0IG90eDJfbmljICpwZikgIGludA0KPiA+IG90eDJfYWxsb2NfbWNhbV9lbnRyaWVz
KHN0cnVjdCBvdHgyX25pYyAqcGZ2ZikgIHsNCj4gPiAgCXN0cnVjdCBvdHgyX2Zsb3dfY29uZmln
ICpmbG93X2NmZyA9IHBmdmYtPmZsb3dfY2ZnOw0KPiA+ICsJbmV0ZGV2X2ZlYXR1cmVzX3Qgd2Fu
dGVkID0gTkVUSUZfRl9IV19WTEFOX1NUQUdfUlggfA0KPiA+ICsJCQkJICAgTkVUSUZfRl9IV19W
TEFOX0NUQUdfUlg7DQo+ID4gIAlzdHJ1Y3QgbnBjX21jYW1fYWxsb2NfZW50cnlfcmVxICpyZXE7
DQo+ID4gIAlzdHJ1Y3QgbnBjX21jYW1fYWxsb2NfZW50cnlfcnNwICpyc3A7DQo+ID4gIAlpbnQg
aTsNCj4gPiBAQCAtODgsMTUgKzkyLDIyIEBAIGludCBvdHgyX2FsbG9jX21jYW1fZW50cmllcyhz
dHJ1Y3Qgb3R4Ml9uaWMNCj4gPiAqcGZ2ZikNCj4gPiAgCWlmIChyc3AtPmNvdW50ICE9IHJlcS0+
Y291bnQpIHsNCj4gPiAgCQluZXRkZXZfaW5mbyhwZnZmLT5uZXRkZXYsICJudW1iZXIgb2YgcnVs
ZXMgdHJ1bmNhdGVkIHRvICVkXG4iLA0KPiA+ICAJCQkgICAgcnNwLT5jb3VudCk7DQo+ID4gKwkJ
bmV0ZGV2X2luZm8ocGZ2Zi0+bmV0ZGV2LA0KPiA+ICsJCQkgICAgIkRpc2FibGluZyBSWCBWTEFO
IG9mZmxvYWQgZHVlIHRvIG5vbi0NCj4gPiBhdmFpbGFiaWxpdHkgb2YgTUNBTSBzcGFjZVxuIik7
DQo+ID4gIAkJLyogc3VwcG9ydCBvbmx5IG50dXBsZXMgaGVyZSAqLw0KPiA+ICAJCWZsb3dfY2Zn
LT5udHVwbGVfbWF4X2Zsb3dzID0gcnNwLT5jb3VudDsNCj4gPiAgCQlmbG93X2NmZy0+bnR1cGxl
X29mZnNldCA9IDA7DQo+ID4gIAkJcGZ2Zi0+bmV0ZGV2LT5wcml2X2ZsYWdzICY9IH5JRkZfVU5J
Q0FTVF9GTFQ7DQo+ID4gIAkJcGZ2Zi0+ZmxhZ3MgJj0gfk9UWDJfRkxBR19VQ0FTVF9GTFRSX1NV
UFBPUlQ7DQo+ID4gKwkJcGZ2Zi0+ZmxhZ3MgJj0gfk9UWDJfRkxBR19SWF9WTEFOX1NVUFBPUlQ7
DQo+ID4gKwkJcGZ2Zi0+bmV0ZGV2LT5mZWF0dXJlcyAmPSB+d2FudGVkOw0KPiA+ICsJCXBmdmYt
Pm5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfndhbnRlZDsNCj4gDQo+IERyaXZlcnMgYXJlIG5vdCBh
bGxvd2VkIHRvIGNoYW5nZSBvd24gZmVhdHVyZXMgZHluYW1pY2FsbHkuDQo+IA0KPiBwbGVhc2Ug
c2VlOg0KPiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMt
DQo+IDNBX193d3cua2VybmVsLm9yZ19kb2NfaHRtbF9sYXRlc3RfbmV0d29ya2luZ19uZXRkZXYt
DQo+IDJEZmVhdHVyZXMuaHRtbCZkPUR3SUNhUSZjPW5LaldlYzJiNlIwbU95UGF6N3h0ZlEmcj1U
d3JlcXdWNm1ROEsNCj4gOXdJcHF3Rk84eWppa09fdzFqVU9lMk16Q2hnNFJtZyZtPTRiVUw5MzZL
bF9KbVBoZ0NnTXh2Q0VMaG9FUV8NCj4gV01fT2l0ZGxxeVRSbEhVJnM9TGdjbTgxMXRGck12dXct
DQo+IEp2VHE0QlBsNzZOcXZfSFc2Q2lndktSOExnR3cmZT0NCj4gDQo+IEZlYXR1cmVzIGRlcGVu
ZGVuY2llcyBtdXN0IGJlIHJlc29sdmVkIHZpYToNCj4gbmRvX2ZpeF9mZWF0dXJlcygpIGFuZCBu
ZXRkZXZfdXBkYXRlX2ZlYXR1cmVzKCk7DQoNCk9rYXksIHdpbGwgZml4IGluIHYzLg0KPiANCj4g
DQo+ID4gK3N0YXRpYyBuZXRkZXZfZmVhdHVyZXNfdA0KPiA+ICtvdHgyX2ZlYXR1cmVzX2NoZWNr
KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+ID4gKwkJICAg
IG5ldGRldl9mZWF0dXJlc190IGZlYXR1cmVzKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gZmVhdHVy
ZXM7DQo+ID4gK30NCj4gPiArDQo+IA0KPiB3aGF0IGlzIHRoZSBwb2ludCBvZiBuby1vcCBmZWF0
dXJlc19jaGVjayA/DQo+IA0KQ3Jvc3MgY2hlY2tlZCB0aGlzIGFuZCBJIGRvbuKAmXQgc2VlIGFu
eSBuZWVkIGZvciB0aGlzIGNoZWNrLiBJIHdpbGwgcmVtb3ZlIGluIHYzLg0KDQo=
