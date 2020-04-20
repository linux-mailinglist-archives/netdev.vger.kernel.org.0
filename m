Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA97D1B05F2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 11:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgDTJvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 05:51:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50626 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTJva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 05:51:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K9pH70018129;
        Mon, 20 Apr 2020 02:51:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=6woLa9gUdSXm9NeJvgHybHQHymx01VgLfzHB0lh6BpY=;
 b=hOhSxbZ4/8lkwmc9RXFiqiWdIVtVKDncI2eL8wuGdu5Cy6364VLEgQcabEF2mmFlSD2v
 o/7yqqlARHmNKu5pdmTFdrFzp/sBtze1wvv7kHW3OQh/VX/Hn6LGzCiMVI97MMNhbqDJ
 sJnlKlKPsfV+NmD/VXAqagtO6eIwsevIdPPCheNN6SI971qZCKE3GqjJCNBKKLsS3VYU
 YapRYCuoR/IJmBOvJRXjRqyD18VTFr8DzPYk7GqjAwtbGbFAD6WNhgbiks6W/eyGWpsy
 P+iaSCV0T3vDSl/9oShLQuBNP2UZRkcc0/ZfssNvLIi2gkj0lRWBDmwNsiO2Q4WRG8WH Wg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwp6jr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 02:51:27 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Apr
 2020 02:51:24 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 20 Apr 2020 02:51:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nq2MZ2AGm4LjuVOsNtD1QSRudMfOfBoIUDVXJNviUBOSDAIpjr6tY7GbHuDpIS+GXAWBgo6aS3SCJiDAW57EjGQJJTZu98KtYzM9/0yaFvecBlG5PDFNCBPNUCIEe5l8X3qTEIfNWQBAcEUSQq0B6islioYDDWzMAX/WqfXo7RqU1E7H9O8NsTa/tV2kxrXAfSOSHvLNZr7skzcbqPz3z0ljcEpZXz4Fo5JSEc7C3gLeZRQ91R4EM+iv+E6wNJ47dXNm2IqeQGYRBHGXCggu87YlP+3nLCIhxMpzFyE3B6FecgHBRBediP6biPek2WluFRMX/hEWByISHfp3+MPBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6woLa9gUdSXm9NeJvgHybHQHymx01VgLfzHB0lh6BpY=;
 b=bFZ5md/JH0Y9JYBe5Lz9L2qKnYLMGq1vO0YhdJTcCwkZ3R7zFrUD5PZlKa3a9Xt9l6BlYjQgMRCYf2UbPkAwKzXkzONNwe6/HoMutLKaxMo/Qvd3CA5uUC62VSoc77fr5vM2Zb4+tYDPVUF4Q6qNXPNthkV5QOzfdygsZmLvQGv8oI0vtxNWRwlMJD60InoVve/6mxKzdd6POVnQtlIX6r1DaMwSi/pa4hU/imJhTHkipUwWrWkyDYxktvWPHb4fosYknLFW+eJNnUxAWYc0WMsXjKGT8d9UdOrjV+umF+QNVfKi7ylMbxrcakPARkyM94qN2zi6alZc8hkOOqTltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6woLa9gUdSXm9NeJvgHybHQHymx01VgLfzHB0lh6BpY=;
 b=sLkfBe0CYGMHStHwCqVUNgbqnqxuv9eg/N/wr8LaqrXFGq62kwZWVBf2BsEihr+Y/h569SW0MXrYg4IZ1BBjWIYePdZ4RkazWVBphPrkKTwepmFOUdZqSuR/bGw2K2zi2T6lg1S7dg76u3czxTRrBpuf7eTmY6MqWLLr3E06/Pk=
Received: from BYAPR18MB2357.namprd18.prod.outlook.com (2603:10b6:a03:133::11)
 by BYAPR18MB3063.namprd18.prod.outlook.com (2603:10b6:a03:108::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 09:51:23 +0000
Received: from BYAPR18MB2357.namprd18.prod.outlook.com
 ([fe80::5d2d:5935:98d3:9693]) by BYAPR18MB2357.namprd18.prod.outlook.com
 ([fe80::5d2d:5935:98d3:9693%4]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 09:51:23 +0000
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: RE: [EXT] Re: [PATCH net 1/2] net: macsec: update SCI upon MAC
 address change.
Thread-Topic: [EXT] Re: [PATCH net 1/2] net: macsec: update SCI upon MAC
 address change.
Thread-Index: AQHV9u/RVec0u4zjc020MYyT4v27vah9QOSAgABYI0A=
Date:   Mon, 20 Apr 2020 09:51:23 +0000
Message-ID: <BYAPR18MB235709AA95C28FAD4C6C39C2A4D40@BYAPR18MB2357.namprd18.prod.outlook.com>
References: <20200310152225.2338-1-irusskikh@marvell.com>
 <20200310152225.2338-2-irusskikh@marvell.com>
 <20200417090547.GA3874480@bistromath.localdomain>
In-Reply-To: <20200417090547.GA3874480@bistromath.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26d770e1-bc34-4fab-024c-08d7e51062d7
x-ms-traffictypediagnostic: BYAPR18MB3063:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB3063D05A7D1C80AA76E24D45A4D40@BYAPR18MB3063.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2357.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(39850400004)(396003)(366004)(346002)(6636002)(110136005)(54906003)(5660300002)(316002)(6506007)(478600001)(7696005)(53546011)(26005)(2906002)(186003)(86362001)(66446008)(64756008)(81156014)(9686003)(76116006)(4326008)(52536014)(66556008)(66476007)(55016002)(66946007)(8676002)(8936002)(33656002)(71200400001)(15650500001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kVGhbwkzlfnEXEysv8RWtyAN5TlJxdzYBjO1TPUzfpN68Epoj5ySMQb3DIsbIVDI7y+Z0duGZvfR7BNCmCX/h17Oh2JQBOKjkcTST6o9luG9aCiksPFB2ag2OaIA2G0SBKelQoYr7O7eJBnSiTiTaXxK0IyFAAxY4YFLVMtlL/Qe+QxQ8XD5zz4aNPYyHqU4MnBc+K4BXlRIilAA4lxf4roFn5FFgjMYWUTxFI+hWEHoIU9NH9KYxlgtgB4Xojyzck5uPoyV9eu1C19P0hEg3JUOg7oyVP3AFvzka3EEDLRpXE/JeYGSt44mXZTRud15LD4UU7yB4o+XZERt3cDiAO8aQfRfXPFwNW9dIejmdyfIJLDMhmJ7JTLf2nQF3m2oV4DL9Q6I5sNmytTlSL6cQI1rTNpao3+FIwQRsqcS8kvM87uw3RRWbdadZNLa4vlz
x-ms-exchange-antispam-messagedata: wIXHuwjyu3J9xNoHQg1YNCyeFeyxGhzToZ/ZqNW64XwfAdAIEuzTFoI1zluZD76gIpi5JQHTAN0mpVUpfvxN3ZAPlQrrRa61heyGYepErEgPDPnspWEr1xFBPvgnP2HAclrmsH9Y6zegnr6l0ktr3g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d770e1-bc34-4fab-024c-08d7e51062d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 09:51:23.2752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5v/K7zm8plZu1YuG2WK4CD4A+A0/bhnPcjiZjb6oX25ONdysdq/4nCQuT19bLqfy9BQ86KGk8M90S+ZtKtUv7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3063
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-17,2020-04-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FicmluYSwNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQpCdXQgdGhpcyBwYXRjaCAg
ZG9lcyBub3QgZGlyZWN0bHkgcmVsYXRlZCB0byBzZW5kX3NjaSBwYXJhbWV0ZXIuDQoNCkFueSAg
bWFudWFsIGNoYW5nZSBvZiBtYWNzZWMgaW50ZXJmYWNlIGJ5IGlwIHRvb2wgd2lsbCBicmVhayB3
cGFfc3VwcGxpY2FudCB3b3JrLiBJdCdzIE9LLCB0aGV5IGFyZSBub3QgaW50ZW5kZWQgdG8gYmUg
dXNlZCB0b2dldGhlci4NCg0KSGF2aW5nIGEgZGlmZmVyZW50IE1BQyBhZGRyZXNzIG9uICBlYWNo
IG1hY3NlYyBpbnRlcmZhY2UgYWxsb3dzIHRvIG1ha2UgYSBjb25maWd1cmF0aW9uIHdpdGggc2V2
ZXJhbCAqb2ZmbG9hZGVkKiBTZWNZLiAgVGhhdCBpcyB0byBtYWtlIGZlYXNpYmxlIHRvIHJvdXRl
IHRoZSBpbmdyZXNzIGRlY3J5cHRlZCB0cmFmZmljIHRvIHRoZSByaWdodCAobWFjc2VjWCAvZXRo
WCkgaW50ZXJmYWNlIGJ5IERTVCBhZGRyZXNzLiBBbmQgdG8gYXBwbHkgYSBkaWZmZXJlbnQgU2Vj
WSBmb3IgdGhlIGVncmVzcyBwYWNrZXRzIGJ5IFNSQyBhZGRyZXNzLiBUaGF0IGlzIHRoZSBvbmx5
IG9wdGlvbiBmb3IgdGhlIG1hY3NlYyBvZmZsb2FkIGF0IFBIWSBsZXZlbCB3aGVuIHVwcGVyIGxh
eWVycyBrbm93IG5vdGhpbmcgYWJvdXQgbWFjc2VjLg0KDQoNCkJSLA0KIERtaXRyeQ0KDQotLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogU2FicmluYSBEdWJyb2NhIDxzZEBxdWVhc3lz
bmFpbC5uZXQ+IA0KU2VudDogRnJpZGF5LCBBcHJpbCAxNywgMjAyMCAxMjowNiBQTQ0KVG86IEln
b3IgUnVzc2tpa2ggPGlydXNza2lraEBtYXJ2ZWxsLmNvbT4NCkNjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBNYXJrIFN0YXJvdm95dG92IDxtc3Rhcm92b2l0b3ZAbWFydmVsbC5jb20+OyBBbnRv
aW5lIFRlbmFydCA8YW50b2luZS50ZW5hcnRAYm9vdGxpbi5jb20+OyBEbWl0cnkgQm9nZGFub3Yg
PGRib2dkYW5vdkBtYXJ2ZWxsLmNvbT4NClN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggbmV0IDEv
Ml0gbmV0OiBtYWNzZWM6IHVwZGF0ZSBTQ0kgdXBvbiBNQUMgYWRkcmVzcyBjaGFuZ2UuDQoNCkV4
dGVybmFsIEVtYWlsDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCkhlbGxvLA0KDQoyMDIwLTAzLTEwLCAxODoy
MjoyNCArMDMwMCwgSWdvciBSdXNza2lraCB3cm90ZToNCj4gRnJvbTogRG1pdHJ5IEJvZ2Rhbm92
IDxkYm9nZGFub3ZAbWFydmVsbC5jb20+DQo+IA0KPiBTQ0kgc2hvdWxkIGJlIHVwZGF0ZWQsIGJl
Y2F1c2UgaXQgY29udGFpbnMgTUFDIGluIGl0cyBmaXJzdCA2IG9jdGV0cy4NCg0KU29ycnkgZm9y
IGNhdGNoaW5nIHRoaXMgc28gbGF0ZS4gSSBkb24ndCB0aGluayB0aGlzIGNoYW5nZSBpcyBjb3Jy
ZWN0Lg0KDQpDaGFuZ2luZyB0aGUgU0NJIG1lYW5zIHdwYV9zdXBwbGljYW50IChvciB3aGF0ZXZl
ciBNS0EgeW91J3JlIHVzaW5nKSB3aWxsIGRpc2FncmVlIGFzIHRvIHdoaWNoIFNDSSBpcyBpbiB1
c2UuIFRoZSBwZWVyIHByb2JhYmx5IGRvZXNuJ3QgaGF2ZSBhbiBSWFNDIGZvciB0aGUgbmV3IFND
SSBlaXRoZXIsIHNvIHRoZSBwYWNrZXRzIHdpbGwgYmUgZHJvcHBlZCBhbnl3YXkuDQoNClBsdXMs
IGlmIHlvdSdyZSB1c2luZyAic2VuZF9zY2kgb24iLCB0aGVyZSdzIG5vIHJlYWwgcmVhc29uIHRv
IGNoYW5nZSB0aGUgU0NJLCBzaW5jZSBpdCdzIGFsc28gaW4gdGhlIHBhY2tldCwgYW5kIG1heSBv
ciBtYXkgbm90IGhhdmUgYW55IHJlbGF0aW9uc2hpcCB0byB0aGUgTUFDIGFkZHJlc3Mgb2YgdGhl
IGRldmljZS4NCg0KSSdtIGd1ZXNzaW5nIHRoZSBpc3N1ZSB5b3UncmUgdHJ5aW5nIHRvIHNvbHZl
IGlzIHRoYXQgaW4gdGhlICJzZW5kX3NjaSBvZmYiIGNhc2UsIG1hY3NlY19lbmNyeXB0KCkgd2ls
bCB1c2UgdGhlIFNDSSBzdG9yZWQgaW4gdGhlIHNlY3ksIGJ1dCB0aGUgcmVjZWl2ZXIgd2lsbCBj
b25zdHJ1Y3QgdGhlIFNDSSBiYXNlZCBvbiB0aGUgc291cmNlIE1BQyBhZGRyZXNzLiBDYW4geW91
IGNvbmZpcm0gdGhhdD8gSWYgdGhhdCdzIHRoZSByZWFsIHByb2JsZW0sIEkgaGF2ZSBhIGNvdXBs
ZSBvZiBpZGVhcyB0byBzb2x2ZSBpdC4NCg0KDQpUaGFua3MsIGFuZCBzb3JyeSBhZ2FpbiBmb3Ig
dGhlIGRlbGF5IGluIGxvb2tpbmcgYXQgdGhpcywNCg0KLS0NClNhYnJpbmENCg0K
