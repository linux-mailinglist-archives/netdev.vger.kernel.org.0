Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E47241D78E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350016AbhI3KV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:21:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349839AbhI3KVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:21:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U2Z10p027759;
        Thu, 30 Sep 2021 03:18:24 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bd47dsr06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 03:18:24 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18UAFo8v015733;
        Thu, 30 Sep 2021 03:18:24 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bd47dsr00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 03:18:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOrJp7hM1ZPUKoN1YCwaw9jUhwLFtFhiIi4/34z6a65nGwyXNTzR1aMwvfmanwK+3U2EsF/Dnyg1wQF7tRZ3f0KrS50IYnnVottXTeIzVO4j02Ay//f3BNyMhw8owowlR76r0Og8y+QojVrCFENTIQ6PhpMOoEaPm+IwSO6HwH+YZXPRlU5H/XFzmLBVDucK01ubjWS8eW+e8My2NL0lnCMVb12s20AUVFrCAiH/oi1hr7VoZqchNnAwydVv1WeYNKzsn2NAmj91uG2GNxeqJ3QmiFfzHt29PDc6AuUtEmATiovJ7F2efo5SE+RsdV2FK7OrniIdUiDjhrNDYGHJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Z6QWUM4AwlUapxVUfzt2zPLm0duoaCom104iiMDYdvs=;
 b=g96d7h6Km1zVxMhaVu+RGlQNtLqA2DXoTeAuMF3XCwBPU7RcypWCGTHzeH8BeURumcuWHrZCe363w4bTJN3qMBiFxCFRmEg1tSS+spVzwTcTo3olFVr+OekC4yGDXGb79CJFQ4VjoQC+Na+1PG+T3Xjr1ENAHgCrCTXncU8XxTIRz/cu/hl45AeAKGn7ZzBja7WMyHfJWHKLeCXrVg6fdQGvL/6xdp75Wz3BMQ0tNaaO52dsKaaIt0J3dJbwtsZw2wkCxLA/2LZHju+FUyUvvksjobTYntoW1K77r4f18/bW8Up9Nqcm0QnbBCcqVLs/GFHMoYyj7HsSu5VCPfex+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6QWUM4AwlUapxVUfzt2zPLm0duoaCom104iiMDYdvs=;
 b=mcMPxxl71xad5JDYcwDPVzIyf7u/QxNaXZlctDy1U7FMUnGJaJN9mrbxbdguPaB2vvlBMk8J1SrLqxSZy+Zr6crBrQF4l/7U3LTwSzBpJ07j9JzI4nGSMyAeJvBBoVfGBWQYNj4yII5j81j1DlWaMvFRqeLoJMplzOwhSsR4qYg=
Received: from MWHPR18MB1071.namprd18.prod.outlook.com (2603:10b6:300:a1::9)
 by CO6PR18MB3922.namprd18.prod.outlook.com (2603:10b6:5:34a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 10:18:21 +0000
Received: from MWHPR18MB1071.namprd18.prod.outlook.com
 ([fe80::4df2:5a52:5bc0:afb0]) by MWHPR18MB1071.namprd18.prod.outlook.com
 ([fe80::4df2:5a52:5bc0:afb0%5]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 10:18:21 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "prabhakar.pkin@gmail.com" <prabhakar.pkin@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: RE: [EXT] Re: [PATCH 04/12] qed: Update qed_mfw_hsi.h for FW ver
 8.59.1.0
Thread-Topic: [EXT] Re: [PATCH 04/12] qed: Update qed_mfw_hsi.h for FW ver
 8.59.1.0
Thread-Index: AQHXtStR7C9nHjKCQ0mK8r/MVhxCwqu7V/+AgAEGCzA=
Date:   Thu, 30 Sep 2021 10:18:21 +0000
Message-ID: <MWHPR18MB1071B5034AD53DD075A0E1C4B2AA9@MWHPR18MB1071.namprd18.prod.outlook.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
        <20210929121215.17864-5-pkushwaha@marvell.com>
 <20210929113817.06da736a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929113817.06da736a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fd03bc2-17c5-4344-0a36-08d983fba166
x-ms-traffictypediagnostic: CO6PR18MB3922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3922E7367D3E3C41AE78D2BAB2AA9@CO6PR18MB3922.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z5VZXOO4/L3QcR3XU1TDxCmRlNNPoHC9WYAL1Li8b6QbUp7JqYDHHZ3B+vAy7QeedCYxDkYQsnPRkFjK70J6Dvb6p6wGjDICfCAvNrtSh9nL4EQ8Kh2nFMECKtDleEnhZtZsODkQAxJS1Q5C5tNaXe3kG1KzlXFmQ0cz3379RYC7Pm++Jsh6WkaIn1zzJKsFhR5Y/um2G66u/XHry92snRRp7laD3xNK8joHpk+pNHmI1griiOOaxuPGHOKB1T1aKTMJDD4nwExL8LZ+ga5Fv0HUrwe/S2Lsf+jYdJzXqkP05nxKpT+Kj9RhQdRN4Ntx7JxdIucCtJIP4mMM5jx0TNR2VRii6eIo32CRgrxy8O/PTD7yDyXGk1F5Dk33ikegriTGy8khSDUpJMWd0RDuCFFstglJR1dzpLVrUe5fUdGVA5VQKnlB7haRcy6s24rJwmXBrjnkQxSCL7pOQYjuBnFJmHj7TO+e6/CntKaFOCHl0P6xJhE79yLErgpza29EY0/Ixw/swHUMXhY9Rjzc3u73rNlKOTD7NbOO8V/25DwkQ4HR+p9MnNaiOQUO0UPCZY8sUXd4sm1O6VPcM0qfudP3yLuiw2LwZ4sPkBOEMhbPI9yqlBp090QpkyE0PVmPgewrtZ/QVtr36d9N+TiRZnqnJhHIJ+qNP4CBIxwiZTo2mxM6B4ffyGcGTKREIXYMPVCydjDzip85hqNlw7ew/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1071.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(15650500001)(26005)(186003)(86362001)(38070700005)(71200400001)(2906002)(6916009)(8676002)(33656002)(508600001)(66476007)(66446008)(55016002)(7696005)(66556008)(64756008)(66946007)(76116006)(107886003)(83380400001)(6506007)(4326008)(8936002)(316002)(53546011)(52536014)(54906003)(122000001)(5660300002)(9686003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2JrK2tVZU1YQnlHK3hMaFlCR2p3ellRTElVZERrTFJOVU5SWUpMWEJZK3pT?=
 =?utf-8?B?Z0ttYmcvSTdaOGV2cmxybEV6aWwvUXpDS0c3bzBRWTZtMUNiT0t6TmFSYmNs?=
 =?utf-8?B?N2ZkTy96QmV6RFR5aDR1SlRYRGxkR0FkR0NqcWtjWkxQdFZMRWVNOURiU0wz?=
 =?utf-8?B?Yy9KcVFYYklJSFFXYnZFdVRmemZJZUdRNzVIWmozeDIyWUttQVo0Ylc4QjlS?=
 =?utf-8?B?endLYkVBejdxMWtuNm1ISjg1TkFSUGNEekZma2dkbVRxbWRpMG9kRkp0Q3h1?=
 =?utf-8?B?a3hERkNNSzVackVoVXBjajZrb1BGelkrMHpHZUVyQ2x3K1RlMFJVbVQ4c0dv?=
 =?utf-8?B?VmcvYjBZYUZpdnZKOU9TMmpUazl4dlZORCtabklHMEtPUG1mRGd4ZnBTelVy?=
 =?utf-8?B?UDdLSmFZYkxqUmRCc3lLYzlPVzk3UGhORlE5WjdMc1N6eXErTE9lUnM0dWp1?=
 =?utf-8?B?SmVYdHhSV0JwRmEvRjdPL0tkSnlOMGJkeXlmZzV5VFpnbVcxU0kzMWRzc080?=
 =?utf-8?B?Sng3Y3NkdDFmekJnR3ErMG1kbHJsZ3RjaDNaVElEZFdkdm5ZZzhuaC9TTXdY?=
 =?utf-8?B?WENMWWtBK1lnb1VDaDEzRURTQ04wYTllUG4yOUVpWVM4TWU2b2ZiK0IwUndk?=
 =?utf-8?B?UU4xVW15aFllcEhiMVRsWTJ5T2ZuWXZya0ErQ20vdjlqeVIxMmxZaWYwc0Ex?=
 =?utf-8?B?UU9kN2taTWNuMDRnNWRCczQxNmpUa0lUM3hScCtJZ0pmR0pHVnNrVTRiWTNo?=
 =?utf-8?B?Vyt1M2Q5YU4zWUlraklkemhtQXZLeFRtUURTT1h0MDJJa2UyYnMrbHhuL280?=
 =?utf-8?B?T0NlbnBtN1pwaExDVWEweGtCdnJ1Nkc1RGVqK3YyL05Td3NUaW5CcnJ1R2Nh?=
 =?utf-8?B?T2hvZjVQdXpTOGUzaStKTEVURVJhaFM5d3BNSytESzFsNjk1SEFsN1F5THZV?=
 =?utf-8?B?aXozSjlybmI3Y05DbEpxTmNhRGtCQlI2eUJaMzRFMGRMUjlXWW1idkk2SUMz?=
 =?utf-8?B?WFFkQWJRVnZtd0d4Z0dCN1BNbzNKTDlGYWMrS0FNVFRWcGswNklhSTVwamZ4?=
 =?utf-8?B?ejZFR3BuQzJ4TTBueDhUUFRtTStlY1hmb1hGc0hSSk5TZFJvM3pYeXZpZGQ5?=
 =?utf-8?B?RkoydTg3Wkp4bXhQdWJsQ2NWc3FIR0ZGWVRqd05nRTdmUzlCY2dwYWhucHVE?=
 =?utf-8?B?SDNNUWI5aFdJVHdoOHJxcDI2QVZGUEZwTFJvWUJqQ25xc3JPWHlGUWFUMndw?=
 =?utf-8?B?NlRra1A1RjVPNlc3QzdzR2hBYk9aYUQxQzNLZ082SFBCM2pjazdud2Z4Sy9h?=
 =?utf-8?B?MCtRTllBR3J0WDl3a2tBNko2aG9QRjlYRFdLbHozNlowNVAyaFpna09KUHFY?=
 =?utf-8?B?SmxrSnladHN6cndSN0c2a3RpcVlkd3lJRjlVRVFHdi8vWDdJR0M5eWFwZGtu?=
 =?utf-8?B?WFZnaWtFaTd3eURuOFhNNXNodlVVUDFsRHFUSHRsamlRL0RnV2JLWEh2YTJ3?=
 =?utf-8?B?K1ZuUE04bU1FRTMrVEg3ZVUxSlI3ZGNTNk1wN0k3VlhHMlNHc3JVZmFQWWgz?=
 =?utf-8?B?cHViNGdtNlFjbFhQK0xYcXMzWkdKL3FSWHBxR01KKzE2SjZLVlZTazRRd0p4?=
 =?utf-8?B?OXYxVG9hVC92bnRRdkw4YnVUYmk1MWY0Z1ExMkkyMXNUQkpkV1BqNVdQaEFS?=
 =?utf-8?B?NHZvTWN6TUdycFJ3d0hNTHBDMTNsZjNPa1g4S29GaFRjZkYvTVJab3g4QzRC?=
 =?utf-8?Q?5NDAbB1KMBP6OlCvKABy4WMvfFIpvEWBj2LvNQl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1071.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd03bc2-17c5-4344-0a36-08d983fba166
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 10:18:21.5925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zKCqP0+1k/oHmSulpJWOZJ5Bnp9U9o7v05ET6GBPLN29N3Bl1l0WgwNXFlRMGuuTXM3+jHAmR3waJ6aQ0uPZsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3922
X-Proofpoint-GUID: OaL9deaQF9koOU42Ti11lIDxF3FOJCeE
X-Proofpoint-ORIG-GUID: y2Otf6qcnuMsrua4_Q9Plm3TPI8MNUZ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-30_03,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEpha3ViIGZvciByZXZpZXdpbmcgdGhpcyBwYXRjaCBzZXJpZXMuIA0KDQoNCj4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAzMCwgMjAyMSAxMjowOCBBTQ0K
PiBUbzogUHJhYmhha2FyIEt1c2h3YWhhIDxwa3VzaHdhaGFAbWFydmVsbC5jb20+DQo+IENjOiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBsaW51eC0NCj4gcmRt
YUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOw0KPiBtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbTsgQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxsLmNvbT47IFNo
YWkgTWFsaW4NCj4gPHNtYWxpbkBtYXJ2ZWxsLmNvbT47IEphdmVkIEhhc2FuIDxqaGFzYW5AbWFy
dmVsbC5jb20+OyBNYW5pc2gNCj4gUmFuZ2Fua2FyIDxtcmFuZ2Fua2FyQG1hcnZlbGwuY29tPjsg
cHJhYmhha2FyLnBraW5AZ21haWwuY29tOw0KPiBtYWxpbjEwMjRAZ21haWwuY29tOyBPbWthciBL
dWxrYXJuaSA8b2t1bGthcm5pQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW1BB
VENIIDA0LzEyXSBxZWQ6IFVwZGF0ZSBxZWRfbWZ3X2hzaS5oIGZvciBGVyB2ZXINCj4gOC41OS4x
LjANCj4gDQo+IE9uIFdlZCwgMjkgU2VwIDIwMjEgMTU6MTI6MDcgKzAzMDAgUHJhYmhha2FyIEt1
c2h3YWhhIHdyb3RlOg0KPiA+IFRoZSBxZWRfbWZ3X2hzaS5oIGNvbnRhaW5zIEhTSSAoSGFyZHdh
cmUgU29mdHdhcmUgSW50ZXJmYWNlKSBjaGFuZ2VzDQo+ID4gcmVsYXRlZCB0byBtYW5hZ2VtZW50
IGZpcm13YXJlLiBJdCBoYXMgYmVlbiB1cGRhdGVkIHRvIHN1cHBvcnQgbmV3IEZXDQo+ID4gdmVy
c2lvbiA4LjU5LjEuMCB3aXRoIGJlbG93IGNoYW5nZXMuDQo+ID4gIC0gTmV3IGRlZmluZXMgZm9y
IFZGIGJpdG1hcC4NCj4gPiAgLSBmZWNfbW9kZSBhbmQgZXh0ZW5kZWRfc3BlZWQgZGVmaW5lcyB1
cGRhdGVkIGluIHN0cnVjdCBldGhfcGh5X2NmZy4NCj4gPiAgLSBVcGRhdGVkIHN0cnVjdHV0cmVz
IGxsZHBfc3lzdGVtX3RsdnNfYnVmZmVyX3MsIHB1YmxpY19nbG9iYWwsDQo+ID4gICAgcHVibGlj
X3BvcnQsIHB1YmxpY19mdW5jLCBkcnZfdW5pb25fZGF0YSwgcHVibGljX2Rydl9tYg0KPiA+ICAg
IHdpdGggYWxsIGRlcGVuZGVudCBuZXcgc3RydWN0dXJlcy4NCj4gPiAgLSBVcGRhdGVzIGluIE5W
TSByZWxhdGVkIHN0cnVjdHVyZXMgYW5kIGRlZmluZXMuDQo+ID4gIC0gTXNnIGRlZmluZXMgYXJl
IGFkZGVkIGluIGVudW0gZHJ2X21zZ19jb2RlIGFuZCBmd19tc2dfY29kZS4NCj4gPiAgLSBVcGRh
dGVkL2FkZGVkIG5ldyBkZWZpbmVzLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhbHNvIGZpeGVzIHRo
ZSBleGlzdGluZyBjaGVja3BhdGNoIHdhcm5pbmdzIGFuZCBmZXcgaW1wb3J0YW50DQo+ID4gY2hl
Y2tzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxs
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBPbWthciBLdWxrYXJuaSA8b2t1bGthcm5pQG1hcnZl
bGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNoYWkgTWFsaW4gPHNtYWxpbkBtYXJ2ZWxsLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQcmFiaGFrYXIgS3VzaHdhaGEgPHBrdXNod2FoYUBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX21haW4u
YzoxMDI6MTg6IHdhcm5pbmc6DQo+IOKAmHFlZF9tZndfZXh0XzIwZ+KAmSBkZWZpbmVkIGJ1dCBu
b3QgdXNlZCBbLVd1bnVzZWQtY29uc3QtdmFyaWFibGU9XQ0KPiAgIDEwMiB8IHN0YXRpYyBjb25z
dCB1MzIgcWVkX21md19leHRfMjBnW10gX19pbml0Y29uc3QgPSB7DQo+ICAgICAgIHwgICAgICAg
ICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCj4gDQo+IA0KPiBQbHVzIHlvdSBhZGQgYSB3aG9s
ZSBidW5jaCBvbiBrZG9jIHdhcm5pbmdzIHdpdGggdGhvc2UgcGF0Y2hlcy4NCj4gUGxlYXNlIG1h
a2Ugc3VyZSBubyBuZXcga2RvYyB3YXJuaW5ncyBhbmQgbm8gbmV3IGNvbXBpbGF0aW9uIHdhcm5p
bmdzDQo+ICh3aXRoIEM9MSBXPTEgZmxhZ3MhKQ0KDQpTb3JyeSBmcm9tIG91ciBzaWRlLiANCg0K
TGV0IG1lIGZpeCB0aGlzIGFuZCBzaGFyZSB2MiBmb3IgcmV2aWV3LiANCg0KLS1waw0KDQo=
