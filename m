Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDB2FAFCC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbhASFE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:04:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40674 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726604AbhASFBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:01:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10J50IUt001220;
        Mon, 18 Jan 2021 21:00:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=aldhT7OOtMEDrAuB1Euaa34VCuOIldmfUAAP9KkWuv4=;
 b=CwAuWy56JnrlbCuSWhFA/dPl9Hlih8bRnbWbaOv53Etceja3KJxW3h6CJuyUlsNlqqa5
 FJweYWlOkLISLV7z6SlecEBlB7cYz30icjRHCWcAex+EyrQDQBYMYHWqhMAsOsB8faej
 JBJv0yQIgaqLyD7I6nv6iKf93bgf6JhHe46HLOZgYFGFoxTolpgC71s6zp4lI+tLrJL/
 rmeOU5jRnuPsnkUQCHR+J/kva50RzOJqZMuYLuTsHvm2+PcmaZXFJ1YcnovjlpIgYEHH
 kkllfboO/C76CC/NX0TQER3B2s1xpjQYZksEpsWG07HIF/PkiHqw6UoTj9wwc58tZCiS wA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 363xcudjnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 21:00:18 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 Jan
 2021 21:00:17 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 Jan
 2021 21:00:16 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 18 Jan 2021 21:00:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNqPhKJXFzZHIfaCLQn0l5+FuLvC5oD18n7p5WYJg0rF7RP+ORs45Fz7dc+sFmlraNMmrIFACrWYLQrODPwE3Xr2XLRWEPalpWyL//IfoboJEzWAnHYNYQUGOg4414XV/1FqvDL3D1nOkqzKSnoRE9qKFB7goLT7/YBeOILTdRY9htBhHR1rcOKiE9d+1V+FW3LCDADeMPhVEnYgTFfAO777IVywcxEgpI+k9aFIF66dSy1ij5jLVpPkeUZRgCXYv5hQnE+tmzyS4ogjxfwcErmnwliDkt9ou8bnaH6Ri0IBEmQGJSkAixELRsKGy6J+q9gyLEypnTN34ewf92OCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aldhT7OOtMEDrAuB1Euaa34VCuOIldmfUAAP9KkWuv4=;
 b=lJ5fKnv1LEyahhTtP3JejyJdVG+WJwt/gqAmNApI7ucmsayIE7ZnA/JaejnmhiV53eT4bK0tyEWXcpN54afP6EFcvWKLO6pI15botCyrrmyIA/dJmrCUudQSWMlENaPPTZvDQ3OWmPrGe4cfy6fkrPnbDhlTVLiYO0s/3Lv6AxsXJ0P1UB1CLZl4tUJTS7Om+51jW01shv5U5p74D6vgFKOVXNlHkZQQYEr+eocTfrVz4cDYKV76lhdKU16NvpuquqgimJNP1QoYdf7U+Atc6/GDUz+qyvqRZL/taVJjddS0gdaCv5kKkXbWhRYkRB+/KeXVTlZhAE70DFvQxQbo7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aldhT7OOtMEDrAuB1Euaa34VCuOIldmfUAAP9KkWuv4=;
 b=gAv+vP71NkWOYYAbHhbP2FDyY5bxnTgtpmtePCGSKxhUXEjKgZBwKfHOp5eJcA8i9CGJBRlsgoBEZTxhWHwr6d97i/2+9OeWh+ir7LQgHn6W0nWOIp14T1RQ7ySy9aVUn9AhzRgNhhQNsb7yD3w4gANnW5XOGNmkvUXa+07FVHo=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BYAPR18MB2520.namprd18.prod.outlook.com (2603:10b6:a03:12d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Tue, 19 Jan
 2021 05:00:15 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::ac42:1aab:6c14:1802]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::ac42:1aab:6c14:1802%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 05:00:15 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Mahipal Challa <mchalla@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next,1/3] octeontx2-af: Mailbox changes for
 98xx CPT block
Thread-Topic: [EXT] Re: [PATCH net-next,1/3] octeontx2-af: Mailbox changes for
 98xx CPT block
Thread-Index: AQHW6b+oblL1XdhF4EixGh1S9PUf6Kony3cAgAabijA=
Date:   Tue, 19 Jan 2021 05:00:15 +0000
Message-ID: <BYAPR18MB2791125FAE5A6D8ACC6F94ADA0A31@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20210113152007.30293-1-schalla@marvell.com>
         <20210113152007.30293-2-schalla@marvell.com>
 <c8ea9deda401f4c2996129d5089aa10cb0a31e84.camel@kernel.org>
In-Reply-To: <c8ea9deda401f4c2996129d5089aa10cb0a31e84.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [223.228.109.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c732d67e-77dc-404e-98e7-08d8bc371c4e
x-ms-traffictypediagnostic: BYAPR18MB2520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2520932D193858ADAE5165F0A0A31@BYAPR18MB2520.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hbfg32My/WxglhEpRP8tPsT8Qv/2wwfYWWgFonMB6pngnSEdz3IHdbO6VMslswks1mUkBSgM3dW877dQp9+7LKD00dhdSMSE+P/KidgdkVF662QUBOZSgV2PvWsth6ejlgFfh/WRWeQjbcVAaZjyN7p3BNjj2yPdW7e865Z4PtzX1deQXcxpMKNhh0VocIuwtlGixSLg02AbGKKnS8SuolZmfEZDVOEj5SVjytJWTwsM4+GxfcgFQVrZnBU2vUiyB5iHI9nf1yagvsrd2Eqk/+RYkqVb+G2rTLiUk/MVeB0HY3Su2dYMq/35xb0dmxzHXrZgh5A8C9TCsfTwSZUlSooCigBoyhii8lSBlhSqYxvmPv6U322ek21h62dURBa7MJK8lCqq5ZVEel6qb87wS/LXQg1VnFd1fEFJcsY/Bj6VQF0gZbGkyzMoPhcj0jXEig1bibytyh4e9TWKwP+xnLmoGFAXjbisIutWS9gEc9ckhDdVns0K2+xs5qbQ6dlunNzeudjQWVB8YIOal8CE6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(9686003)(8676002)(8936002)(52536014)(107886003)(4326008)(71200400001)(7696005)(2906002)(86362001)(33656002)(76116006)(83380400001)(186003)(316002)(55016002)(26005)(66476007)(64756008)(5660300002)(6506007)(66556008)(66946007)(66446008)(110136005)(478600001)(15650500001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bGkxaTFxZ1NOSngxVDBzR0dOMzVDN2ZRY3lkWDhMNUhkTzVwM2RwRENTNWo3?=
 =?utf-8?B?Wnc2bnZpUlBqTnl1QWtMa3I2YWFHQ29PQndaeXB3eDdRT0VHaTJVWEQzSW1p?=
 =?utf-8?B?cjZBN2ZQc0tXbXNUVTlxejhOUEpCSVgwWVhRT2YzdzFraXczK00wc3hRMFcw?=
 =?utf-8?B?ak9Bay93WitnQ1ZvWTA1L2h2bUdRT1ZnSzZpZ3BQeEN4a0UxVFoxcm45cTlw?=
 =?utf-8?B?THNNOEw3NVFNSWNGSnQyaTRDeEtoSVBub0JEeVI1U1phU3c4YnUzSHlLeVZ6?=
 =?utf-8?B?WkRoS05JUmJxSzFyS2JqWjM3VnEwSkJtQ0VZbWRvQWdUS1JqanBoeHZWNUpq?=
 =?utf-8?B?NU9CaFZrbm9SVXBBVEVmdERFd3Z0dlZTelRUeHBoWnlMY1JhR0NPajhRdDNp?=
 =?utf-8?B?TTV1dHJtekdsUklYcjRxNmhsUXJKQUI2NXN2UHgvaHZNNlFGZlplK1JrMjdE?=
 =?utf-8?B?WUJaVkFORGdGL0l0Q1NMam1lQ2tZak9HejlJMWMvcm1VM3lwc0t6bk51ZjhI?=
 =?utf-8?B?SkhoV1JRZzVuRi90cXFRb09ITDRuRUdOMHE1eGpKT2pReDFJcGI3MXEzenpa?=
 =?utf-8?B?M3pSWW5JN2RXaHMxTGN2c1pydnJsYy9rRm9pQ1d4TldacklSOTdXMnJHdzlz?=
 =?utf-8?B?cC9YUkNlWTFtVDFsTDZBTXVURkNlTEpGZzBUZ25QREhzL2w1NFJJZ3lOL1ZN?=
 =?utf-8?B?VHF2M2p1NVBKZDRVaWZTSHUzblZ1blFISmFXM2tvckFOOHdMZnBTUy9Dekp0?=
 =?utf-8?B?SWJQWWRzclNMQlA4RGlFTWVSKyt2N0JiZ2FpaXFjakxaRXJ2NnE4Q240R1Ex?=
 =?utf-8?B?SlhDK1hINHgxUWdpc1BQK2NOaHpQenRSMXVyZ1p2MjF2OUt2emJqbS9oN000?=
 =?utf-8?B?WjVOWjNuT3hBMHgzWW5CQTJRRW1Ka3FKTFJ0OGNneWRCNGRPWlFEV0ozeDll?=
 =?utf-8?B?VFh5SStFdWt4MmJTRHkrNW5XS3lsY1FHWkovc1psaDJwNGF3TzFjSmdOQlg5?=
 =?utf-8?B?Rk1pZjNFTmlPRHVzYU9iclZKU1lxTFhUNi9ZN2l3d0RwZWhRc054dlZJS08y?=
 =?utf-8?B?bXRHMi9tckt2c1lHbnBDUC9nYjkxcWNvQ0daWU50RjI4RlNEZXBSTitiMkJP?=
 =?utf-8?B?Z3VmdnFsRE9NajVWcW1vWWhxcVlEWGJXWkthaHlYamtIWG1mcWFQNkMzMlR3?=
 =?utf-8?B?aWVUanZSVDMxeUZyeDUwNURRV09VYWhjVDBmbVBFV3B5dndCYSthcWZtMzZG?=
 =?utf-8?B?b3p5QzdwTmRzYUJoV2pPNzZwdW5yb0FibHY5cVhyWmhlNVZ0bElzYldpaUdq?=
 =?utf-8?B?Tk1aVUtxMjFONjJteEJITEpHMzhKeHF2VDdOUVJ5blkrSEJiaC9iOVJwWDhR?=
 =?utf-8?B?cDE2SWV2MGZlL3dyYXNROERXMStISGh3K1RLNkpZUVhoam53eGtwVWpXdE82?=
 =?utf-8?Q?c6aEBKhG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c732d67e-77dc-404e-98e7-08d8bc371c4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 05:00:15.5062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V0pqMdFST1Bspj0Ms3rxoVj4wxZfb+Zy1W0zZMozt92e3Je1vEkNkvKKwoiH5pCMluLcoXKu7DaYJXK9gbUGZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2520
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_15:2021-01-18,2021-01-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIDIwMjEtMDEtMTMgYXQgMjA6NTAgKzA1MzAsIFNydWphbmEgQ2hhbGxhIHdyb3Rl
Og0KPiA+IFRoaXMgcGF0Y2ggY2hhbmdlcyBDUFQgbWFpbGJveCBtZXNzYWdlIGZvcm1hdCB0byBz
dXBwb3J0IG5ldyBibG9jaw0KPiA+IENQVDEgaW4gOTh4eCBzaWxpY29uLg0KPiA+DQo+ID4gY3B0
X3JkX3dyX3JlZyAtPg0KPiA+ICAgICBNb2RpZnkgY3B0X3JkX3dyX3JlZyBtYWlsYm94IGFuZCBp
dHMgaGFuZGxlciB0bw0KPiA+ICAgICBhY2NvbW1vZGF0ZSBuZXcgYmxvY2sgQ1BUMS4NCj4gPiBj
cHRfbGZfYWxsb2MgLT4NCj4gPiAgICAgTW9kaWZ5IGNwdF9sZl9hbGxvYyBtYWlsYm94IGFuZCBp
dHMgaGFuZGxlciB0bw0KPiA+ICAgICBjb25maWd1cmUgTEZzIGZyb20gYSBibG9jayBhZGRyZXNz
IG91dCBvZiBtdWx0aXBsZQ0KPiA+ICAgICBibG9ja3Mgb2Ygc2FtZSB0eXBlLiBJZiBhIFBGL1ZG
IG5lZWRzIHRvIGNvbmZpZ3VyZQ0KPiA+ICAgICBMRnMgZnJvbSBib3RoIHRoZSBibG9ja3MgdGhl
biB0aGlzIG1ib3ggc2hvdWxkIGJlDQo+ID4gICAgIGNhbGxlZCB0d2ljZS4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IE1haGlwYWwgQ2hhbGxhIDxtY2hhbGxhQG1hcnZlbGwuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFNydWphbmEgQ2hhbGxhIDxzY2hhbGxhQG1hcnZlbGwuY29tPg0KPiA+IC0t
LQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL21ib3guaCAgfCAg
MiArDQo+ID4gIC4uLi9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY3B0LmMgICB8
IDQxICsrKysrKysrKysrLS0tLQ0KPiA+IC0tLS0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyNyBp
bnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9tYm94LmgNCj4gPiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL21ib3guaA0KPiA+IGluZGV4IGY5
MTkyODNkZGMzNC4uY2JiYWIwNzBmMjJiIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL21ib3guaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL21ib3guaA0KPiA+IEBAIC0xMDcxLDYgKzEw
NzEsNyBAQCBzdHJ1Y3QgY3B0X3JkX3dyX3JlZ19tc2cgew0KPiA+ICAJdTY0ICpyZXRfdmFsOw0K
PiA+ICAJdTY0IHZhbDsNCj4gPiAgCXU4IGlzX3dyaXRlOw0KPiA+ICsJaW50IGJsa2FkZHI7DQo+
ID4gIH07DQo+ID4NCj4gPiAgc3RydWN0IGNwdF9sZl9hbGxvY19yZXFfbXNnIHsNCj4gPiBAQCAt
MTA3OCw2ICsxMDc5LDcgQEAgc3RydWN0IGNwdF9sZl9hbGxvY19yZXFfbXNnIHsNCj4gPiAgCXUx
NiBuaXhfcGZfZnVuYzsNCj4gPiAgCXUxNiBzc29fcGZfZnVuYzsNCj4gPiAgCXUxNiBlbmdfZ3Jw
bXNrOw0KPiA+ICsJaW50IGJsa2FkZHI7DQo+ID4gIH07DQo+ID4NCj4gPiAgI2VuZGlmIC8qIE1C
T1hfSCAqLw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29j
dGVvbnR4Mi9hZi9ydnVfY3B0LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
b2N0ZW9udHgyL2FmL3J2dV9jcHQuYw0KPiA+IGluZGV4IDM1MjYxZDUyYzk5Ny4uYjZkZTRiOTVh
NzJhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9u
dHgyL2FmL3J2dV9jcHQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
b2N0ZW9udHgyL2FmL3J2dV9jcHQuYw0KPiA+IEBAIC02NSwxMyArNjUsMTMgQEAgaW50IHJ2dV9t
Ym94X2hhbmRsZXJfY3B0X2xmX2FsbG9jKHN0cnVjdCBydnUgKnJ2dSwNCj4gPiAgCWludCBudW1f
bGZzLCBzbG90Ow0KPiA+ICAJdTY0IHZhbDsNCj4gPg0KPiA+ICsJYmxrYWRkciA9IHJlcS0+Ymxr
YWRkciA/IHJlcS0+YmxrYWRkciA6IEJMS0FERFJfQ1BUMDsNCj4gPiArCWlmIChibGthZGRyICE9
IEJMS0FERFJfQ1BUMCAmJiBibGthZGRyICE9IEJMS0FERFJfQ1BUMSkNCj4gPiArCQlyZXR1cm4g
LUVOT0RFVjsNCj4gPiArDQo+ID4NCj4gDQo+IEp1c3Qgb3V0IG9mIGN1cmlvc2l0eSwgd2h5IGRv
IHlvdSBuZWVkIHRvIGNoZWNrIGFnYWluc3QgeW91ciBkcml2ZXIncyBpbnRlcm5hbHMNCj4gZnVu
Y3Rpb24gY2FsbHMgPw0KPiANCj4gd2hvIGNhbGxzIHRoaXMgZnVuY3Rpb246IEkgQ291bGRuJ3Qg
ZmluZCBhbnkgY2FsbGVyICENCj4NClRoaXMgZnVuY3Rpb24gaXMgYSBtYWlsYm94IGhhbmRsZXIs
IGl0IHdpbGwgYmUgdHJpZ2dlcmVkIHdoZW4gTWFydmVsbCBjcnlwdG8oQ1BUKQ0KZHJpdmVyIHNl
bmRzIGEgQ1BUX0xGX0FMTE9DIG1haWxib3ggbWVzc2FnZS4gIEkgaGF2ZSBhZGRlZCBjaGVjayBm
b3IgYmxrYWRkcg0KYmVjYXVzZSB0aGVyZSBpcyBhIGNoYW5jZSBmb3Igc2VuZGluZyBpbnZhbGlk
IGJsa2FkZHIgdGhyb3VnaCBtYWlsYm94IHJlcXVlc3QNCmZyb20gQ1BUIFZGIGRyaXZlcnMuDQoN
Cj4gJCBnaXQgZ3JlcCBydnVfbWJveF9oYW5kbGVyX2NwdF9sZl9hbGxvYw0KPiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY3B0LmM6aW50DQo+IHJ2dV9tYm94
X2hhbmRsZXJfY3B0X2xmX2FsbG9jKHN0cnVjdCBydnUgKnJ2dSwNCj4gDQo+IA0KDQo=
