Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C372B2FE5
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKNSyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:54:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgKNSyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:54:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEIrhci001815;
        Sat, 14 Nov 2020 10:54:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=CbrA5tR5MgPFu31f7OgpMQRwkqu6JeC+jN91GBbC25Y=;
 b=gO8PK4WOdoX263ahaU1oQgOgPJP1XSswoUGXQlaoJSLw63PiFjwzgdi4Szvw5t+VChH3
 aGzuS5vYJqu4Bjthxx4Qi+dmzMQsL19r7eWWI9225EQoJuh6DaajO0P4OBGAoQrBO7Pm
 4nZyfOf+GOFgqnssIdExZxJGvri+1eRkaTWPut+Ui2eM0pi5jFSqvEKgUVWNEGqpoWPF
 ckK2/bUK0pWSIIcTQS02kbeavkUMnwkOVQKRYKpYmAYv/Z1dJriAnT9WcTAFZUcNrau3
 RkgdV9Y0Ygg+SDfZT+jtxq0UA5YJf6QwMav7IMJ51qYckVx4NrJhLYxBWw5PTTMpK7Ov +A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfms8m3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 10:54:48 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 10:54:47 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 10:54:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 14 Nov 2020 10:54:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9QwBQ1weItnSPfgqicU9OGkte2yrtursv+iiVjdHnCpxfTOPftCvjB75IjMR3f1ELQ4PjLcdYgP3hBV2S6rCINNtL6EIXREj7YMYfZ2SAGBHJy3zGDNmGT22rd6xel8KejiudtNX9nTuZHJLObzXnuAADU/jleo7Op9ea5hghb1rKC5uwOP3NS8GhEpUpp6z8CgFtePr9qabjh02w1d/kJdWHTWMcHE27mQBQqExr3HEmVIgpez3P014uwUybTCvYkx7v0dPbIX/eUGCpSYBAXHLZD5vCKK6qUsasJOivdiLjxGJPmuuhuhR89k6kMb/SyD8bKtKGdkwGa6gFgjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbrA5tR5MgPFu31f7OgpMQRwkqu6JeC+jN91GBbC25Y=;
 b=MUn5Es5FlTtiOYTfY1tEzdupGZruWACxwjGLAgJPLcGatMa55PRwHmPcJjzCTYoROSl6UzoZTWVDOxIzyKM/vPZwjILVPsEveDaCEIrKWuehCBNg8VFaIET7PrYX61FP/McDyWClUpzlfS5UPzx26qAYbONXUzLjUBTpextmuEDt/e0LsAHssz3+HKCNQYGRTVRNV0m02n9k4WMaxQy5oTyVQfA5o+XZtTIraFGmSbTUfb0azhB8d4L8XkG3cldsIj/JrnGiYb5TbM8HMaujjz/RU6+ir6FwbeAcSqxfrrOX4craha2U+FZwONw9J5chlE75jRy0YrjNS3EN5UZ03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbrA5tR5MgPFu31f7OgpMQRwkqu6JeC+jN91GBbC25Y=;
 b=Nt6cdAKkVECa0SF1SkLsE88N506sDPAWIUDRxZJRZ0y5k4ISh4qvy0H883p9gtzGO+vanh6L/1zpQTS72joZWBEWGGJBED8CZ9FA2PnR9eoij8/Om47ex6egGz/199+u8/3uMceKdiixqRH6cbkf8rO+K8eRNpCn/UWPQgNXB7g=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM5PR18MB1243.namprd18.prod.outlook.com (2603:10b6:3:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Sat, 14 Nov
 2020 18:54:45 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Sat, 14 Nov 2020
 18:54:45 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "saeed@kernel.org" <saeed@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [PATCH v3 net-next 03/13] octeontx2-af: Generate key field bit
 mask from KEX profile
Thread-Topic: [PATCH v3 net-next 03/13] octeontx2-af: Generate key field bit
 mask from KEX profile
Thread-Index: Ada6t5io9O7RkrDzQayqbol57IIg+w==
Date:   Sat, 14 Nov 2020 18:54:45 +0000
Message-ID: <DM6PR18MB3212143717CA6FCF281B39D3A2E50@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.206.46.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e57774b-5d6d-4d34-cecb-08d888cec122
x-ms-traffictypediagnostic: DM5PR18MB1243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1243E3FBCD57BE5D9FBADB41A2E50@DM5PR18MB1243.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NP2wFTS1ps/UkKUR3Arp8aRGlv0uV+PxDkqidssh3fxST3txQFVoYwaROnbNmgAra90n7kfPAhMqtIKn/RpoDtB0ozfAyk3ZjRcvyJIC4klTqAdye1B3MYgXFzkHWq+SJNioDJxV5GPG1TpNSRke8vOeeqDvCSGB7xzLpNLJJfjTrqANVH5jxZ7vi1Ly0XhzkUKuUye/Or3RciWLQbLJNY3RRczUcUn7Va5D4MWblCxmKinKKe5pNyshmITGz9uCbL+AcRSrRm2RolbcYJvhfGUbH5JzNxg2fyrzByGKZu4D6f1Dy3S07kvVG+DizvIm9s4TTQRl+bE6IBU4gtLIZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39850400004)(396003)(136003)(6506007)(26005)(53546011)(55236004)(186003)(107886003)(4326008)(55016002)(54906003)(9686003)(7696005)(66446008)(66476007)(66946007)(76116006)(316002)(66556008)(64756008)(52536014)(6916009)(71200400001)(83380400001)(8676002)(8936002)(2906002)(478600001)(33656002)(5660300002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Pgt2eIkT98MnbPN3albAvuafGH/tkbDdZZ4Wt+nYSs/MkqwTQkumQtkbkTsoUvTi7pLNuS7XHiSPG4x5C6v1RbvOv/qlkFRMOW73Tyml/6SzGsHHODGXZAYtZ1ex22IXirgvZfAJH41xd9h6oqimO2gWxeGPNP1kudLdAnt/rn9MdMcLFOVESnAdqBj4fBCGokT4kTYfcwvMBseysNDGCQm9mCc519KbxXyCloZMS9V9WUzGhg8vIo2K5m41alsfwj73mww62RDGPwtKSWb29NwMEsCd18VR06d/S32OBErYoiUC2pgEHwu+XGK7WiX0L/zdNZ/LPDe/DFLa6lXjBFbYth1pfILcyUn4asyBu9S3kosuN+/JL0uSnWcPixYipytjDZqsGdomcxDOheV8WmwQdDbPCgYoWbHfz8OjB8/Q9PpbwnCxNggH/i8NxVhgW6+le0B+whtyZvAUhUraz3RDYvOl80vX8vuGLf+i5cvSPJELa0ldgIckhSFudC/pVnjCCqZ4/IaceSZsPVgGBN4UNyB6jlHfpnn8ThoL1Bv1+jfEPiMZlo2S5Sj9Q84JsYiABShxzqKmGt1stOG6Z5ZcNnPZoFOu7i9N8zK5TQHYpPxtOPu2Frch2DyqFMTPAQWzz4XiXnXbeWFWrOTQPg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e57774b-5d6d-4d34-cecb-08d888cec122
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 18:54:45.6590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qCivuQyO40P4ohon9Y9OaIQ5XWcZpuSZm8vuJL1RKAA3SYElY/N9zUBOi8T2uFUwqRTiF7/RflhP9PYj42I+/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1243
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxleGFuZGVyLA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuZHV5Y2tA
Z21haWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE5vdmVtYmVyIDEzLCAyMDIwIDI6NTUgQU0NCj4g
VG86IE5hdmVlbiBNYW1pbmRsYXBhbGxpIDxuYXZlZW5tQG1hcnZlbGwuY29tPg0KPiBDYzogTmV0
ZGV2IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZz47DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBEYXZpZCBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBzYWVlZEBrZXJuZWwub3JnOyBTdW5pbCBLb3Z2
dXJpIEdvdXRoYW0gPHNnb3V0aGFtQG1hcnZlbGwuY29tPjsgTGludQ0KPiBDaGVyaWFuIDxsY2hl
cmlhbkBtYXJ2ZWxsLmNvbT47IEdlZXRoYXNvd2phbnlhIEFrdWxhDQo+IDxnYWt1bGFAbWFydmVs
bC5jb20+OyBKZXJpbiBKYWNvYiBLb2xsYW51a2thcmFuIDxqZXJpbmpAbWFydmVsbC5jb20+Ow0K
PiBTdWJiYXJheWEgU3VuZGVlcCBCaGF0dGEgPHNiaGF0dGFAbWFydmVsbC5jb20+OyBIYXJpcHJh
c2FkIEtlbGFtDQo+IDxoa2VsYW1AbWFydmVsbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djMgbmV0LW5leHQgMDMvMTNdIG9jdGVvbnR4Mi1hZjogR2VuZXJhdGUga2V5IGZpZWxkDQo+IGJp
dCBtYXNrIGZyb20gS0VYIHByb2ZpbGUNCj4gDQo+IE9uIFR1ZSwgTm92IDEwLCAyMDIwIGF0IDEx
OjI0IFBNIE5hdmVlbiBNYW1pbmRsYXBhbGxpDQo+IDxuYXZlZW5tQG1hcnZlbGwuY29tPiB3cm90
ZToNCj4gPg0KPiA+IEZyb206IFN1YmJhcmF5YSBTdW5kZWVwIDxzYmhhdHRhQG1hcnZlbGwuY29t
Pg0KPiA+DQo+ID4gS2V5IEV4dHJhY3Rpb24oS0VYKSBwcm9maWxlIGRlY2lkZXMgaG93IHRoZSBw
YWNrZXQgbWV0YWRhdGEgc3VjaCBhcw0KPiA+IGxheWVyIGluZm9ybWF0aW9uIGFuZCBzZWxlY3Rl
ZCBwYWNrZXQgZGF0YSBieXRlcyBhdCBlYWNoIGxheWVyIGFyZQ0KPiA+IHBsYWNlZCBpbiBNQ0FN
IHNlYXJjaCBrZXkuIFRoaXMgcGF0Y2ggcmVhZHMgdGhlIGNvbmZpZ3VyZWQgS0VYIHByb2ZpbGUN
Cj4gPiBwYXJhbWV0ZXJzIHRvIGZpbmQgb3V0IHRoZSBiaXQgcG9zaXRpb24gYW5kIGJpdCBtYXNr
IGZvciBlYWNoIGZpZWxkLg0KPiA+IFRoZSBpbmZvcm1hdGlvbiBpcyB1c2VkIHdoZW4gcHJvZ3Jh
bW1pbmcgdGhlIE1DQU0gbWF0Y2ggZGF0YSBieSBTVyB0bw0KPiA+IG1hdGNoIGEgcGFja2V0IGZs
b3cgYW5kIHRha2UgYXBwcm9wcmlhdGUgYWN0aW9uIG9uIHRoZSBmbG93LiBUaGlzDQo+ID4gcGF0
Y2ggYWxzbyB2ZXJpZmllcyB0aGUgbWFuZGF0b3J5IGZpZWxkcyBzdWNoIGFzIGNoYW5uZWwgYW5k
IERNQUMgYXJlDQo+ID4gbm90IG92ZXJ3cml0dGVuIGJ5IHRoZSBLRVggY29uZmlndXJhdGlvbiBv
ZiBvdGhlciBmaWVsZHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdWJiYXJheWEgU3VuZGVl
cCA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdW5pbCBHb3V0aGFt
IDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBOYXZlZW4gTWFtaW5k
bGFwYWxsaSA8bmF2ZWVubUBtYXJ2ZWxsLmNvbT4NCj4gDQo+IEEgZmV3IG1pbm9yIHNwZWxsaW5n
IGlzc3Vlcywgb3RoZXJ3aXNlIGl0IGxvb2tzIGZpbmUuDQo+IA0KPiBSZXZpZXdlZC1ieTogQWxl
eGFuZGVyIER1eWNrIDxhbGV4YW5kZXJkdXlja0BmYi5jb20+DQo+IA0KPiA+IC0tLQ0KPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9NYWtlZmlsZSB8ICAgMiAr
LQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ucGMuaCAg
ICB8ICA0OCArKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9h
Zi9ydnUuaCAgICB8ICAzOCArKw0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9u
dHgyL2FmL3J2dV9ucGMuYyAgICB8ICAxMSArLQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21hcnZl
bGwvb2N0ZW9udHgyL2FmL3J2dV9ucGNfZnMuYyB8IDU2Mg0KPiA+ICsrKysrKysrKysrKysrKysr
KysrKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDY1OCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKSAgY3JlYXRlIG1vZGUNCj4gPiAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9vY3Rlb250eDIvYWYvcnZ1X25wY19mcy5jDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvTWFrZWZpbGUNCj4gPiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL01ha2VmaWxlDQo+ID4gaW5kZXgg
MmY3YTg2MWQwYzdiLi5mZmM2ODFiNjdmMWMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvTWFrZWZpbGUNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9NYWtlZmlsZQ0KPiA+IEBAIC05LDQg
KzksNCBAQCBvYmotJChDT05GSUdfT0NURU9OVFgyX0FGKSArPSBvY3Rlb250eDJfYWYubw0KPiA+
DQo+ID4gIG9jdGVvbnR4Ml9tYm94LXkgOj0gbWJveC5vIHJ2dV90cmFjZS5vICBvY3Rlb250eDJf
YWYteSA6PSBjZ3gubyBydnUubw0KPiA+IHJ2dV9jZ3gubyBydnVfbnBhLm8gcnZ1X25peC5vIFwN
Cj4gPiAtICAgICAgICAgICAgICAgICBydnVfcmVnLm8gcnZ1X25wYy5vIHJ2dV9kZWJ1Z2ZzLm8g
cHRwLm8NCj4gPiArICAgICAgICAgICAgICAgICBydnVfcmVnLm8gcnZ1X25wYy5vIHJ2dV9kZWJ1
Z2ZzLm8gcHRwLm8gcnZ1X25wY19mcy5vDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL25wYy5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ucGMuaA0KPiA+IGluZGV4IDkxYTlkMDBlNGZiNS4u
MGZlNDcyMTZmNzcxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZl
bGwvb2N0ZW9udHgyL2FmL25wYy5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFy
dmVsbC9vY3Rlb250eDIvYWYvbnBjLmgNCj4gPiBAQCAtMTQwLDYgKzE0MCw1NCBAQCBlbnVtIG5w
Y19rcHVfbGhfbHR5cGUgew0KPiA+ICAgICAgICAgTlBDX0xUX0xIX0NVU1RPTTEgPSAweEYsDQo+
ID4gIH07DQo+ID4NCj4gPiArLyogbGlzdCBvZiBrbm93biBhbmQgc3VwcG9ydGVkIGZpZWxkcyBp
biBwYWNrZXQgaGVhZGVyIGFuZA0KPiA+ICsgKiBmaWVsZHMgcHJlc2VudCBpbiBrZXkgc3RydWN0
dXJlLg0KPiA+ICsgKi8NCj4gPiArZW51bSBrZXlfZmllbGRzIHsNCj4gPiArICAgICAgIE5QQ19E
TUFDLA0KPiA+ICsgICAgICAgTlBDX1NNQUMsDQo+ID4gKyAgICAgICBOUENfRVRZUEUsDQo+ID4g
KyAgICAgICBOUENfT1VURVJfVklELA0KPiA+ICsgICAgICAgTlBDX1RPUywNCj4gPiArICAgICAg
IE5QQ19TSVBfSVBWNCwNCj4gPiArICAgICAgIE5QQ19ESVBfSVBWNCwNCj4gPiArICAgICAgIE5Q
Q19TSVBfSVBWNiwNCj4gPiArICAgICAgIE5QQ19ESVBfSVBWNiwNCj4gPiArICAgICAgIE5QQ19T
UE9SVF9UQ1AsDQo+ID4gKyAgICAgICBOUENfRFBPUlRfVENQLA0KPiA+ICsgICAgICAgTlBDX1NQ
T1JUX1VEUCwNCj4gPiArICAgICAgIE5QQ19EUE9SVF9VRFAsDQo+ID4gKyAgICAgICBOUENfU1BP
UlRfU0NUUCwNCj4gPiArICAgICAgIE5QQ19EUE9SVF9TQ1RQLA0KPiA+ICsgICAgICAgTlBDX0hF
QURFUl9GSUVMRFNfTUFYLA0KPiA+ICsgICAgICAgTlBDX0NIQU4gPSBOUENfSEVBREVSX0ZJRUxE
U19NQVgsIC8qIFZhbGlkIHdoZW4gUnggKi8NCj4gPiArICAgICAgIE5QQ19QRl9GVU5DLCAvKiBW
YWxpZCB3aGVuIFR4ICovDQo+ID4gKyAgICAgICBOUENfRVJSTEVWLA0KPiA+ICsgICAgICAgTlBD
X0VSUkNPREUsDQo+ID4gKyAgICAgICBOUENfTFhNQiwNCj4gPiArICAgICAgIE5QQ19MQSwNCj4g
PiArICAgICAgIE5QQ19MQiwNCj4gPiArICAgICAgIE5QQ19MQywNCj4gPiArICAgICAgIE5QQ19M
RCwNCj4gPiArICAgICAgIE5QQ19MRSwNCj4gPiArICAgICAgIE5QQ19MRiwNCj4gPiArICAgICAg
IE5QQ19MRywNCj4gPiArICAgICAgIE5QQ19MSCwNCj4gPiArICAgICAgIC8qIGV0aGVyIHR5cGUg
Zm9yIHVudGFnZ2VkIGZyYW1lICovDQo+ID4gKyAgICAgICBOUENfRVRZUEVfRVRIRVIsDQo+ID4g
KyAgICAgICAvKiBldGhlciB0eXBlIGZvciBzaW5nbGUgdGFnZ2VkIGZyYW1lICovDQo+ID4gKyAg
ICAgICBOUENfRVRZUEVfVEFHMSwNCj4gPiArICAgICAgIC8qIGV0aGVyIHR5cGUgZm9yIGRvdWJs
ZSB0YWdnZWQgZnJhbWUgKi8NCj4gPiArICAgICAgIE5QQ19FVFlQRV9UQUcyLA0KPiA+ICsgICAg
ICAgLyogb3V0ZXIgdmxhbiB0Y2kgZm9yIHNpbmdsZSB0YWdnZWQgZnJhbWUgKi8NCj4gPiArICAg
ICAgIE5QQ19WTEFOX1RBRzEsDQo+ID4gKyAgICAgICAvKiBvdXRlciB2bGFuIHRjaSBmb3IgZG91
YmxlIHRhZ2dlZCBmcmFtZSAqLw0KPiA+ICsgICAgICAgTlBDX1ZMQU5fVEFHMiwNCj4gPiArICAg
ICAgIC8qIG90aGVyIGhlYWRlciBmaWVsZHMgcHJvZ3JhbW1lZCB0byBleHRyYWN0IGJ1dCBub3Qg
b2Ygb3VyIGludGVyZXN0ICovDQo+ID4gKyAgICAgICBOUENfVU5LTk9XTiwNCj4gPiArICAgICAg
IE5QQ19LRVlfRklFTERTX01BWCwNCj4gPiArfTsNCj4gPiArDQo+ID4gIHN0cnVjdCBucGNfa3B1
X3Byb2ZpbGVfY2FtIHsNCj4gPiAgICAgICAgIHU4IHN0YXRlOw0KPiA+ICAgICAgICAgdTggc3Rh
dGVfbWFzazsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9v
Y3Rlb250eDIvYWYvcnZ1LmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0
ZW9udHgyL2FmL3J2dS5oDQo+ID4gaW5kZXggMTcyNGRiZDE4ODQ3Li43ZTU1NmM3YjZjY2YgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYv
cnZ1LmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9h
Zi9ydnUuaA0KPiA+IEBAIC0xNSw2ICsxNSw3IEBADQo+ID4gICNpbmNsdWRlICJydnVfc3RydWN0
LmgiDQo+ID4gICNpbmNsdWRlICJjb21tb24uaCINCj4gPiAgI2luY2x1ZGUgIm1ib3guaCINCj4g
PiArI2luY2x1ZGUgIm5wYy5oIg0KPiA+DQo+ID4gIC8qIFBDSSBkZXZpY2UgSURzICovDQo+ID4g
ICNkZWZpbmUgICAgICAgIFBDSV9ERVZJRF9PQ1RFT05UWDJfUlZVX0FGICAgICAgICAgICAgICAw
eEEwNjUNCj4gPiBAQCAtMTA1LDYgKzEwNiwzNiBAQCBzdHJ1Y3Qgbml4X21jZV9saXN0IHsNCj4g
PiAgICAgICAgIGludCAgICAgICAgICAgICAgICAgICAgIG1heDsNCj4gPiAgfTsNCj4gPg0KPiA+
ICsvKiBsYXllciBtZXRhIGRhdGEgdG8gdW5pcXVlbHkgaWRlbnRpZnkgYSBwYWNrZXQgaGVhZGVy
IGZpZWxkICovDQo+IA0KPiBzL21ldGEgZGF0YS9tZXRhZGF0YS8NCg0KT2theSwgSSB3aWxsIGNo
YW5nZS4NCg0KPiANCj4gPiArc3RydWN0IG5wY19sYXllcl9tZGF0YSB7DQo+ID4gKyAgICAgICB1
OCBsaWQ7DQo+ID4gKyAgICAgICB1OCBsdHlwZTsNCj4gPiArICAgICAgIHU4IGhkcjsNCj4gPiAr
ICAgICAgIHU4IGtleTsNCj4gPiArICAgICAgIHU4IGxlbjsNCj4gPiArfTsNCj4gPiArDQo+IA0K
PiA8c25pcD4NCj4gDQo+ID4gKyAgICAgICAvKiBIYW5kbGUgaGVhZGVyIGZpZWxkcyB3aGljaCBj
YW4gY29tZSBmcm9tIG11bHRpcGxlIGxheWVycyBsaWtlDQo+ID4gKyAgICAgICAgKiBldHlwZSwg
b3V0ZXIgdmxhbiB0Y2kuIFRoZXNlIGZpZWxkcyBzaG91bGQgaGF2ZSBzYW1lIHBvc2l0aW9uIGlu
DQo+ID4gKyAgICAgICAgKiB0aGUga2V5IG90aGVyd2lzZSB0byBpbnN0YWxsIGEgbWNhbSBydWxl
IG1vcmUgdGhhbiBvbmUgZW50cnkgaXMNCj4gPiArICAgICAgICAqIG5lZWRlZCB3aGljaCBjb21w
bGljYXRlcyBtY2FtIHNwYWNlIG1hbmFnZW1lbnQuDQo+ID4gKyAgICAgICAgKi8NCj4gPiArICAg
ICAgIGV0eXBlX2V0aGVyID0gJmtleV9maWVsZHNbTlBDX0VUWVBFX0VUSEVSXTsNCj4gPiArICAg
ICAgIGV0eXBlX3RhZzEgPSAma2V5X2ZpZWxkc1tOUENfRVRZUEVfVEFHMV07DQo+ID4gKyAgICAg
ICBldHlwZV90YWcyID0gJmtleV9maWVsZHNbTlBDX0VUWVBFX1RBRzJdOw0KPiA+ICsgICAgICAg
dmxhbl90YWcxID0gJmtleV9maWVsZHNbTlBDX1ZMQU5fVEFHMV07DQo+ID4gKyAgICAgICB2bGFu
X3RhZzIgPSAma2V5X2ZpZWxkc1tOUENfVkxBTl9UQUcyXTsNCj4gPiArDQo+ID4gKyAgICAgICAv
KiBpZiBrZXkgcHJvZmlsZSBwcm9ncmFtbWVkIGRvZXMgbm90IGV4dHJhY3QgZXRoZXIgdHlwZSBh
dA0KPiA+ICsgYWxsICovDQo+IA0KPiBzL2V0aGVyIHR5cGUvRXRoZXJ0eXBlLw0KDQpJIHdpbGwg
dXBkYXRlIHRoaXMgdG9vLg0KDQo+IA0KPiA+ICsgICAgICAgaWYgKCFldHlwZV9ldGhlci0+bnJf
a3dzICYmICFldHlwZV90YWcxLT5ucl9rd3MgJiYgIWV0eXBlX3RhZzItDQo+ID5ucl9rd3MpDQo+
ID4gKyAgICAgICAgICAgICAgIGdvdG8gdmxhbl90Y2k7DQo+ID4gKw0KPiA+ICsgICAgICAgLyog
aWYga2V5IHByb2ZpbGUgcHJvZ3JhbW1lZCBleHRyYWN0cyBldGhlciB0eXBlIGZyb20gb25lDQo+
ID4gKyBsYXllciAqLw0KPiANCj4gU2FtZSBpc3N1ZSBoZXJlIGFuZCBhIGZldyBvdGhlciBwbGFj
ZXMsIHJlcGxhY2UgImV0aGVyIHR5cGUiIHdpdGggIkV0aGVydHlwZSIuDQoNCkkgd2lsbCBjaGFu
Z2UgdGhlbSBhbGwgJiBzZW5kIHY0Lg0KDQo+IA0KPiANCj4gPiArICAgICAgIGlmIChldHlwZV9l
dGhlci0+bnJfa3dzICYmICFldHlwZV90YWcxLT5ucl9rd3MgJiYgIWV0eXBlX3RhZzItDQo+ID5u
cl9rd3MpDQo+ID4gKyAgICAgICAgICAgICAgIGtleV9maWVsZHNbTlBDX0VUWVBFXSA9ICpldHlw
ZV9ldGhlcjsNCj4gPiArICAgICAgIGlmICghZXR5cGVfZXRoZXItPm5yX2t3cyAmJiBldHlwZV90
YWcxLT5ucl9rd3MgJiYgIWV0eXBlX3RhZzItDQo+ID5ucl9rd3MpDQo+ID4gKyAgICAgICAgICAg
ICAgIGtleV9maWVsZHNbTlBDX0VUWVBFXSA9ICpldHlwZV90YWcxOw0KPiA+ICsgICAgICAgaWYg
KCFldHlwZV9ldGhlci0+bnJfa3dzICYmICFldHlwZV90YWcxLT5ucl9rdw0KPiA+DQo=
