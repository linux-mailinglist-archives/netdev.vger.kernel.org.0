Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B3E13DCE4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgAPODx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:03:53 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:58590 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbgAPODx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:03:53 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GDxsW8030909;
        Thu, 16 Jan 2020 09:03:49 -0500
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xf93b5w57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 09:03:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUsCbm/7k5LolIk2WDYYAIdXMt3UByCLpqMumbuFWdfJrj3nRmOZruWYOlVI21IFbXsLx3O7QW8WBpHUB5of936TC1r/DCpFzgv6tiowkbeuXLAy3j8STzByfCS7Cl63/frHifADkwh8ljXOUcBddxYYEZwamGFUsTRS8atQrFb1YhQiTo5iV0dL3t1tzgGINYPXKlb66ZPZvZTsn0zhsabaVFc5jF4rRlARON0z0QBEiEhh+Ucj60wZRcCdASbSNVd/ohCXYZaQG/dfIELp4cNCzRPGYWjyVcjGNhtwthQlAteURKp1dFdLh8k5tn30tJYzaO9MTOP2PdyBO7ruqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5W9VODgIaX6Mb9htpsATlX/qbSN3Qa6AZZCsOZT7wrM=;
 b=U58qhqmAwSLWErmJuA+Yi45zLnBj2JSYKG640D4MkDFpLooOiGHNIrP3UZuTbKygK/l8VFuCqOxwkML68jOIxZMYHslBHOWqrqz63VF6rUUAGukRFC0JvJMdfy374/TBgIykYexhK+6oo1G8lSc68/940Eq9qc+tBjVsxK44YwiNChZ92b9WkY9h6Tm4kFcCbOSJ2ulRtZqLSe38ishuj8BP+HllvPCWGVw1Blk9FghyjF6F5HaRRTlMV9ApxqAxMYKKTdXXrfEEc4obgVhfTQxEvkQCOKE8k9avDxEyOkrnnig3TpIZHkk5OXiKdMBNZfGMoNYZ1f++KtYoNf520g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5W9VODgIaX6Mb9htpsATlX/qbSN3Qa6AZZCsOZT7wrM=;
 b=tKFVlqXGNFBhn6SFwXW8JJLilSy/7S2Vw5FTQXIrZbc+wrerpVV6kK9adLORur7p2soub+is7+QwS4xHX4Ubf2Jln50a2ZSoHoCpiurnR9IXovhuBv2mfPksZAeSH1/HNuyL7NZlyO7A2+FswVhXAcD0fYMQojT5Os1vZE3JZkk=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5189.namprd03.prod.outlook.com (20.180.4.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Thu, 16 Jan 2020 14:03:47 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39%7]) with mapi id 15.20.2644.021; Thu, 16 Jan 2020
 14:03:47 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: phy: adin: implement support for 1588
 start-of-packet indication
Thread-Topic: [PATCH 3/4] net: phy: adin: implement support for 1588
 start-of-packet indication
Thread-Index: AQHVzE0qb1PjEEbCPEazD7W9RZgA8aftUJEAgAABnoCAAABsAIAAAO4A
Date:   Thu, 16 Jan 2020 14:03:46 +0000
Message-ID: <3739df8b41a757d1b117f172e15dc43c36909715.camel@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
         <20200116091454.16032-4-alexandru.ardelean@analog.com>
         <20200116135518.GF19046@lunn.ch>
         <efab72f360a2043bc8cf545dcc7f24d00f3269c6.camel@analog.com>
         <20200116140236.GH19046@lunn.ch>
In-Reply-To: <20200116140236.GH19046@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00537ab0-6ad4-4462-4259-08d79a8ce7bd
x-ms-traffictypediagnostic: CH2PR03MB5189:
x-microsoft-antispam-prvs: <CH2PR03MB51899651A23FC34E8411A1F9F9360@CH2PR03MB5189.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(366004)(376002)(136003)(396003)(189003)(199004)(8676002)(81156014)(2616005)(6916009)(4326008)(81166006)(36756003)(6486002)(478600001)(71200400001)(4744005)(5660300002)(76116006)(54906003)(186003)(66476007)(66946007)(26005)(316002)(66446008)(64756008)(66556008)(6512007)(6506007)(8936002)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5189;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HVhmU895GWWwpUj2uUBiGIXtvLC7ZZc4LZ2rN36GWT+Fw//dpJA1A54u9QC18pms7Q3d2wUlXZc+Z5KqHpdwI+06atIZBMQlfRMtelToy0BWQnAafI4l+wo+SYqqqpGvqGs0taYZlmNnAlufeg89Ok4dgki5bUOro5Jp6Uq1MEvgFWuaqQbu7joQkM9Iy7pTaqhz9U0JGEon4+IlFyIvX68vEJEoNUOdEAQ1PaM1G3OZ//ohpYEJjHKwLczshFag7jVbujm3R4Q1PEmMZNh4HbvUZhGTsWtOI5jMXOVj7m7CvccfsETPaRzvd+PwxV9ufp81U0LIqg8QslfrwdBhGbqqr8+8xt34hryyEaRHDH4BV2KYXOH72Jq3LscbgWB9e5cN/VY8yVnsNbxCqf0qy573XiV3hMgMWwpwm+0t3aKvl7OID9+sUSmS79tKmB2m
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F391F6AF6FB64847803644EB7792DBCA@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00537ab0-6ad4-4462-4259-08d79a8ce7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 14:03:46.8511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GGeYjk9KNrubDQVc/J6KJJmoWsDt0wVX2vva2dXmXUNxlLwwcMIZbUwwtP2+Cj5zl9NXavlxlW7D6rUSnSRdBBoDrGvp2VCNTjURwHMWXTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5189
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=813 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTE2IGF0IDE1OjAyICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVGh1LCBKYW4gMTYsIDIwMjAgYXQgMDE6NTg6NTVQTSArMDAw
MCwgQXJkZWxlYW4sIEFsZXhhbmRydSB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjAtMDEtMTYgYXQg
MTQ6NTUgKzAxMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+ID4gW0V4dGVybmFsXQ0KPiA+ID4g
DQo+ID4gPiBPbiBUaHUsIEphbiAxNiwgMjAyMCBhdCAxMToxNDo1M0FNICswMjAwLCBBbGV4YW5k
cnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gPiA+IFRoZSBBRElOMTMwMCAmIEFESU4xMjAwIFBIWXMg
c3VwcG9ydCBkZXRlY3Rpb24gb2YgSUVFRSAxNTg4IHRpbWUNCj4gPiA+ID4gc3RhbXANCj4gPiA+
ID4gcGFja2V0cy4gVGhpcyBtZWNoYW5pc20gY2FuIGJlIHVzZWQgdG8gc2lnbmFsIHRoZSBNQUMg
dmlhIGEgcHVsc2UtDQo+ID4gPiA+IHNpZ25hbA0KPiA+ID4gPiB3aGVuIHRoZSBQSFkgZGV0ZWN0
cyBzdWNoIGEgcGFja2V0Lg0KPiA+ID4gDQo+ID4gPiBEbyB5b3UgaGF2ZSBwYXRjaGVzIGZvciBh
IE1BQyBkcml2ZXI/IEkgd2FudCB0byBzZWUgaG93IHRoaXMgY29ubmVjdHMNCj4gPiA+IHRvZ2V0
aGVyLg0KPiA+IA0KPiA+IE5vcGUuDQo+ID4gDQo+ID4gSSBhZG1pdCB0aGF0IG9uIHRoZSBNQUMg
c2lkZSwgSSdtIG5vdCB5ZXQgZmFtaWxpYXIgaG93IHRoaXMgaXMNCj4gPiBpbnRlZ3JhdGVkLg0K
PiA+IEknZCBuZWVkIHRvIHN0dWR5IHRoaXMgbW9yZSBpbi1kZXB0aC4NCj4gDQo+IE8uSy4NCj4g
DQo+IFRoZW4gaSBzdWdnZXN0IHlvdSBwb3N0IHBhdGNoICMxIGFzIGEgc2luZ2xlIHBhdGNoLiBB
bmQgdGhlbiB3b3JrIG9uDQo+IHRoZSBNQUMgc2lkZSwgYW5kIHBvc3QgYm90aCBNQUMgYW5kIFBI
WSBhcyBhIGNvbXBsZXRlIGFuZCB0ZXN0ZWQNCj4gcGF0Y2hzZXQuDQo+IA0KDQpBY2sNClRoYW5r
cw0KDQo+IFRoYW5rcw0KPiAJQW5kcmV3DQo=
