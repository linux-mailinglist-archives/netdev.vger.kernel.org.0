Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D08B3093C1
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhA3JyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:54:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28510 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232018AbhA3Jxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:53:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10U9p4EW008045;
        Sat, 30 Jan 2021 01:53:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=ZoqzdKQE7WExQ+uPAhFibIWUspur5QjkTW0KzZrexxk=;
 b=ZHMn6WCG+yvPfXfilx5FE1U9gSVLOCwI2IgTXgTZ0FNnmaIKgNi3jOc0VkKu9r3KjvJp
 Tinb8MJqT4O94ekpXkzyPx5GDoq+jhDRj1Fp/YS9rkL+lKBrzLtC82EI2po6SwFrx7kg
 iFThqf9EVYoH6UIiWptS6b0y1BNjmABow2DtGPRZrJg5RkRu82C6ZuIrceszkGG28Geq
 7WX1Wp18fGCEsC9kjs6S4WzQU4bMM4iZ4LkV27yI19uiGjNEAV3iIWuIOKhsUOW1Ieie
 gnynnGwx21hqsNPAc98nGJ4GHy+OTYmgzVwihGvQpi7WPpkfQ4fxeXNNVOKyZ0yyfRzq ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d0kd8bvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 01:53:02 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:53:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 01:52:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lh1VKhk1e3pewEpTm9JM8CbFUln6UZtoEtOPJh8Xv+v3gV4N+QHpsFDMeH/k1K0pnXO64dJ5sECfqIKnojligvfdhoQThb7lmLBNnj6Vk7s2j3pMd6efKnbqRvHGoCiPuQGT7q+WzR4FIHL6jZTJNxHbQa9UOZiwh2fxaRt3FvAJ1YnuYaES9wP19GevZTEGgSN8ws28Mx0HEYXujBg3tqVHk+rkAoIIylhRmqu2rwaKGDCAlb8grZh1xPDE210JhuJb1sd1fBKwheWnO4l8EjLPZ9Pxn2zYV4GFIXLmH58PvmrXQpVCOCkHSjOmyiTS7A91qzrbe54vtpuo8LZkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoqzdKQE7WExQ+uPAhFibIWUspur5QjkTW0KzZrexxk=;
 b=MsdQ8JmtCFXzoIaYKtBfDN5BmHRY9mhFr5bJwHiRksWjrId2FCCmHzI33ufBMYe3FdsUEEAL7xbhStwbk360gwOAKzidOsMcfPAfl86exkSz4fXqmtrPKdXt/f44oZlEAKA4tihU2AlZrHjXnN9xGYJjYeMaJugKLvCfn18MRDJ/me8ppF1Dod5rzvA6KKBJ/njliGXl4++9da5ocH3JHNzSeG3oeskqo3jqvBKBQgq0s+jLuKX3nMgQ/a//xIQZCY+8+T0wxyK1w6QAwGRv7KQybXMxhuLCnLCxgIiHauIXnymP12i5cNNmCbP319viwB1FT81uZ4I9u37XvQQXhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoqzdKQE7WExQ+uPAhFibIWUspur5QjkTW0KzZrexxk=;
 b=dey3wZAXBYq1Ob/lrCIOOVCpkrF+7+VeHWa2wnjW70ZWMEXK/OsHl44QWfhV8y4yUgU/mMjG3KvNHT/l63Ob2YvxK1/n5FEY+2aHZvBlTUaq1RUV8vUhS0iW6GziKQg/AynOF1bp2QYw3crG6ZwWfGCldMFNKzpWC27KNczGSB4=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by CO6PR18MB4052.namprd18.prod.outlook.com (2603:10b6:5:34a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Sat, 30 Jan
 2021 09:52:57 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 09:52:57 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        "Sunil Kovvuri Goutham" <Sunil.Goutham@cavium.com>
Subject: Re: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY
 FEC statistics
Thread-Topic: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY
 FEC statistics
Thread-Index: Adb27FuZ44nOMW/5QSahBF6er4r9iA==
Date:   Sat, 30 Jan 2021 09:52:57 +0000
Message-ID: <MWHPR18MB1421B580CF911A13D1369D98DEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.216.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eba11bd2-7399-49cd-1dcf-08d8c504d2ae
x-ms-traffictypediagnostic: CO6PR18MB4052:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB4052BC03869AE04D53C7DBCADEB89@CO6PR18MB4052.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kSMy6J09jdCz/Kzs9wF7Mf40udScfQso01/dqHeR0txmphY9zN97HCk1vIhm//He1kBx3VMFk3/1gYzCZmMB3hep84m5Ww5Pgcy5iAwnHj23g2RHsoHIWJASUF7afnSCLocplIyEANxgXu2r5cejk558Yvm//1CSTpQwO6QCDcc4+sLbS3xPS/q+rSdXJrkqFQMlrHMDzOwcG1SYIJ9W98xQjU0TrGntpVced7Ezq2tyTRshpLlo8UGPLIs5PK2203YL8nqniwOHgIrObiTFgKNDh17Rk94GaH5GEq9b9W9K5RLT9JWNUQZGGUfPUDV+eBFSbKJOA4llGQkTvsd/3q4xN9fo59zm16rW+Bbbt8bBZSS9ugxvahSIMxjkYb/Eg2RiHZPyD5B5Erhy0wCFdSk3AgL0o4CID+6c8VFLB7Xgc//cp+DRNZfP+5owYtPmMIV5OQmm+xLIayvuvMNOvexCnmySa5QuV+r8A66q/fOtwzOOIyErGoiBRUVh/wJ+tMepSFNt0O7yZmbKPuzdhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(7696005)(52536014)(33656002)(8936002)(5660300002)(186003)(26005)(76116006)(66946007)(66476007)(66556008)(66446008)(6506007)(53546011)(55236004)(8676002)(64756008)(6916009)(4326008)(86362001)(71200400001)(83380400001)(55016002)(9686003)(478600001)(54906003)(316002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dnloUGdzM1FsaHhwaWU3Y004WGp1T1Q5dUtZSHRoY2dPM3lLZnZzME16NVRm?=
 =?utf-8?B?enkrTkJVVnNJTi90azh1RENpZ0MyQXNNYjU5aTFUMU5HMnpWSDY0NmRTOVZW?=
 =?utf-8?B?KzZmNGtYVTFhL3ExRWE4UStVSUVzOUJmSXJUMWpZMXlJTURVNGhHUGtsbk9j?=
 =?utf-8?B?OGZ6S1ZGUGZMbFpIN0N4VzlNWkNBN05IWGMrWldQN1hDalk4R28xRVcwbHZR?=
 =?utf-8?B?QW0yeG5RTHI0blJKTHlpNHRkUlJzUCtKc0Z2USt0dVR1bWpOeGVkWkhqYVAy?=
 =?utf-8?B?SHhVdUNKc0JtMkFtdHF4VXFGZHkxY0VPRm40RDhmS2Fpb2hpTHVKQkxMQVY2?=
 =?utf-8?B?WXBtSDEyNGs1VGhtQXZiRGJkVVhuRE1CMVR2WkN1Vno3R3lZSW5JUXo1dng5?=
 =?utf-8?B?MzdsUnV3Q1BxM2N1SGxtWUZqTjh3bmZnVHdHbEdpZUZqdCtGUGZNV3BGNU95?=
 =?utf-8?B?TWpHSjFTQkNmWDNuOS9xNG5hZlBlajlNTXJMRW5USzhVZ0RNNGJLVlplUDl2?=
 =?utf-8?B?WEVPUU1lR2s3eFk4VHZUd2k3QWdOQlRaQWRUWkliM2RFamI4bTlQWHEzd0g3?=
 =?utf-8?B?TnJab3NNSjJ1dWEzOGtCSEhVcThZcS9FWmlkRkxIYTd1NEVRVEUzbjRvL3h2?=
 =?utf-8?B?dHUvbWZsVkFFRXdjWjg0bEk1akNUTEtRUHBJdUxIdWV0MUtmQzlLZ2o0TjM3?=
 =?utf-8?B?NThIUHNhbGszbmkyMWxOQlNKQnd5NnVKTHVIN1gwWlYwZkVvYmp5S0RKODRk?=
 =?utf-8?B?NFpkcHp4NUFLclZZU3k2SU5xT2hiQnBiSGR2NEJjdVI4VjNmZ1VnRlBCM0F4?=
 =?utf-8?B?eG9nYk5obW10RDF5K1RmY0F1dlNoVldhU09xZWxDd2c0bThBMkhkSk9naS9N?=
 =?utf-8?B?SDY5K1QyTWFPaWlkUUpDd25JeUhCQmQxY05EMUtuUk1xaytLSk9xRXB5Z2dj?=
 =?utf-8?B?T2wvVUM2dm9rSGlVd0hqWjBHRTA2R2R3bG5kV2dPMzk3clQyaWpyT2xVN0dY?=
 =?utf-8?B?cUovcExubVlHVGE5c3lQZjNLc1JEVUhzSUNZcHFQSWY1cFZpTzgrSEdCejU2?=
 =?utf-8?B?WjVYTStyYlJHREpvT0JjUmtiUWNnSVNmdm0xalh1OGI5UGp1cEtOSHFsejdQ?=
 =?utf-8?B?N3BGdiswOThWNndjYnZUSWpZbkN0WjY1TWJzZEdsSFIrUUQyK0V0R3VpSlUw?=
 =?utf-8?B?WnBxaFpTdTZCdEF1a0wyK2M2Qzl1dFo2eUdsbng0UGNnNG9xZHFDTDJzMU5P?=
 =?utf-8?B?ekdQTXNLNjhEZDBXNzUyU3VOT0d4TEhkKzRscnVRM054c0NyOGpsU1oyM09K?=
 =?utf-8?B?aVgxQ2xaVGY3Z0M3YnVhWXpRaGtCa0pzTDc2TUxrU2I2RzRrcnp3RG44L01j?=
 =?utf-8?B?QTJsd1VpeGVJMU5BcHhkbjVDbHh3c0ZSWDg2Zml1N3YwZW5zS3Z2WmkzaGZC?=
 =?utf-8?Q?2Y+KppTN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba11bd2-7399-49cd-1dcf-08d8c504d2ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 09:52:57.6223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qsH42F+lglboqWW/r8ygHQIX6Y+9o26ZEg1bXaZkPUUNsnQ/57a3lhVlqh+Yt4ilSRHC4Yf9RgBjSlK7w9/56A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4052
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-30_06:2021-01-29,2021-01-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxl
bSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBKYW51YXJ5IDI4LCAyMDIxIDE6NTAgQU0NCj4gVG86IEhhcmlwcmFzYWQgS2VsYW0g
PGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZz47
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBTdW5pbCBLb3Z2dXJpIEdvdXRoYW0NCj4gPHNnb3V0aGFtQG1hcnZl
bGwuY29tPjsgTGludSBDaGVyaWFuIDxsY2hlcmlhbkBtYXJ2ZWxsLmNvbT47DQo+IEdlZXRoYXNv
d2phbnlhIEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBKZXJpbiBKYWNvYiBLb2xsYW51a2th
cmFuDQo+IDxqZXJpbmpAbWFydmVsbC5jb20+OyBTdWJiYXJheWEgU3VuZGVlcCBCaGF0dGEgPHNi
aGF0dGFAbWFydmVsbC5jb20+Ow0KPiBGZWxpeCBNYW5sdW5hcyA8Zm1hbmx1bmFzQG1hcnZlbGwu
Y29tPjsgQ2hyaXN0aW5hIEphY29iDQo+IDxjamFjb2JAbWFydmVsbC5jb20+OyBTdW5pbCBLb3Z2
dXJpIEdvdXRoYW0NCj4gPFN1bmlsLkdvdXRoYW1AY2F2aXVtLmNvbT4NCj4gU3ViamVjdDogW0VY
VF0gUmU6IFtQYXRjaCB2MiBuZXQtbmV4dCAyLzddIG9jdGVvbnR4Mi1hZjogQWRkIG5ldyBDR1hf
Q01EDQo+IHRvIGdldCBQSFkgRkVDIHN0YXRpc3RpY3MNCj4gDQo+IE9uIFdlZCwgSmFuIDI3LCAy
MDIxIGF0IDQ6MDQgQU0gSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1hcnZlbGwuY29tPg0KPiB3
cm90ZToNCj4gPg0KPiA+IEZyb206IEZlbGl4IE1hbmx1bmFzIDxmbWFubHVuYXNAbWFydmVsbC5j
b20+DQo+ID4NCj4gPiBUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCB0byBmZXRjaCBmZWMgc3RhdHMg
ZnJvbSBQSFkuIFRoZSBzdGF0cyBhcmUgcHV0DQo+ID4gaW4gdGhlIHNoYXJlZCBkYXRhIHN0cnVj
dCBmd2RhdGEuICBBIFBIWSBkcml2ZXIgaW5kaWNhdGVzIHRoYXQgaXQgaGFzDQo+ID4gRkVDIHN0
YXRzIGJ5IHNldHRpbmcgdGhlIGZsYWcgZndkYXRhLnBoeS5taXNjLmhhc19mZWNfc3RhdHMNCj4g
Pg0KPiA+IEJlc2lkZXMgQ0dYX0NNRF9HRVRfUEhZX0ZFQ19TVEFUUywgYWxzbyBhZGQgQ0dYX0NN
RF9QUkJTIGFuZA0KPiA+IENHWF9DTURfRElTUExBWV9FWUUgdG8gZW51bSBjZ3hfY21kX2lkIHNv
IHRoYXQgTGludXgncyBlbnVtIGxpc3QgaXMgaW4NCj4gPiBzeW5jIHdpdGggZmlybXdhcmUncyBl
bnVtIGxpc3QuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBGZWxpeCBNYW5sdW5hcyA8Zm1hbmx1
bmFzQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENocmlzdGluYSBKYWNvYiA8Y2ph
Y29iQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFN1bmlsIEtvdnZ1cmkgR291dGhh
bSA8U3VuaWwuR291dGhhbUBjYXZpdW0uY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEhhcmlwcmFz
YWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gDQo+IA0KPiA+ICtzdHJ1Y3QgcGh5X3Mg
ew0KPiA+ICsgICAgICAgc3RydWN0IHsNCj4gPiArICAgICAgICAgICAgICAgdTY0IGNhbl9jaGFu
Z2VfbW9kX3R5cGUgOiAxOw0KPiA+ICsgICAgICAgICAgICAgICB1NjQgbW9kX3R5cGUgICAgICAg
ICAgICA6IDE7DQo+ID4gKyAgICAgICAgICAgICAgIHU2NCBoYXNfZmVjX3N0YXRzICAgICAgIDog
MTsNCj4gDQo+IHRoaXMgc3R5bGUgaXMgbm90IGN1c3RvbWFyeQ0KDQpUaGVzZSBzdHJ1Y3R1cmVz
IGFyZSBzaGFyZWQgd2l0aCBmaXJtd2FyZSBhbmQgc3RvcmVkIGluIGEgc2hhcmVkIG1lbW9yeS4g
QW55IGNoYW5nZSBpbiBzaXplIG9mIHN0cnVjdHVyZXMgd2lsbCBicmVhayBjb21wYXRpYmlsaXR5
LiBUbyBhdm9pZCBmcmVxdWVudCBjb21wYXRpYmxlIGlzc3VlcyB3aXRoIG5ldyB2cyBvbGQgZmly
bXdhcmUgd2UgaGF2ZSBwdXQgc3BhY2VzIHdoZXJlIGV2ZXIgd2Ugc2VlIHRoYXQgdGhlcmUgY291
bGQgYmUgbW9yZSBmaWVsZHMgYWRkZWQgaW4gZnV0dXJlLg0KU28gY2hhbmdpbmcgdGhpcyB0byB1
OCBjYW4gaGF2ZSBhbiBpbXBhY3QgaW4gZnV0dXJlLg0KPiANCj4gPiArICAgICAgIH0gbWlzYzsN
Cj4gPiArICAgICAgIHN0cnVjdCBmZWNfc3RhdHNfcyB7DQo+ID4gKyAgICAgICAgICAgICAgIHUz
MiByc2ZlY19jb3JyX2N3czsNCj4gPiArICAgICAgICAgICAgICAgdTMyIHJzZmVjX3VuY29ycl9j
d3M7DQo+ID4gKyAgICAgICAgICAgICAgIHUzMiBicmZlY19jb3JyX2Jsa3M7DQo+ID4gKyAgICAg
ICAgICAgICAgIHUzMiBicmZlY191bmNvcnJfYmxrczsNCj4gPiArICAgICAgIH0gZmVjX3N0YXRz
Ow0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RydWN0IGNneF9sbWFjX2Z3ZGF0YV9zIHsNCj4gPiAr
ICAgICAgIHUxNiByd192YWxpZDsNCj4gPiArICAgICAgIHU2NCBzdXBwb3J0ZWRfZmVjOw0KPiA+
ICsgICAgICAgdTY0IHN1cHBvcnRlZF9hbjsNCj4gDQo+IGFyZSB0aGVzZSBpbnRlbmRlZCB0byBi
ZSBpbmRpdmlkdWFsIHU2NCdzPw0KPiANClRoZSBhYm92ZSBmaWVsZHMgYXJlIHVzZWQgYXMgYml0
bWFwcyB0byBzdG9yZSBmZWMgQkFTRVIvUlMgZXRjLg0KQXMgc3RhdGVkIGFib3ZlIHRvIGF2b2lk
IGZyZXF1ZW50IGNvbXBhdGlibGUgaXNzdWVzIGJldHdlZW4gb2xkICYgbmV3IGZpcm13YXJlIC4g
d2UgYXJlIGNyZWF0aW5nIHNwYWNlcy4gIA0KDQoNCj4gPiArICAgICAgIHU2NCBzdXBwb3J0ZWRf
bGlua19tb2RlczsNCj4gPiArICAgICAgIC8qIG9ubHkgYXBwbGljYWJsZSBpZiBBTiBpcyBzdXBw
b3J0ZWQgKi8NCj4gPiArICAgICAgIHU2NCBhZHZlcnRpc2VkX2ZlYzsNCj4gPiArICAgICAgIHU2
NCBhZHZlcnRpc2VkX2xpbmtfbW9kZXM7DQo+ID4gKyAgICAgICAvKiBPbmx5IGFwcGxpY2FibGUg
aWYgU0ZQL1FTRlAgc2xvdCBpcyBwcmVzZW50ICovDQo+ID4gKyAgICAgICBzdHJ1Y3Qgc2ZwX2Vl
cHJvbV9zIHNmcF9lZXByb207DQo+ID4gKyAgICAgICBzdHJ1Y3QgcGh5X3MgcGh5Ow0KPiA+ICsj
ZGVmaW5lIExNQUNfRldEQVRBX1JFU0VSVkVEX01FTSAxMDIxDQo+ID4gKyAgICAgICB1NjQgcmVz
ZXJ2ZWRbTE1BQ19GV0RBVEFfUkVTRVJWRURfTUVNXTsNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0
cnVjdCBjZ3hfZndfZGF0YSB7DQo+ID4gKyAgICAgICBzdHJ1Y3QgbWJveF9tc2doZHIgaGRyOw0K
PiA+ICsgICAgICAgc3RydWN0IGNneF9sbWFjX2Z3ZGF0YV9zIGZ3ZGF0YTsgfTsNCj4gPiArDQo+
ID4gIC8qIE5QQSBtYm94IG1lc3NhZ2UgZm9ybWF0cyAqLw0KPiA+DQo+ID4gIC8qIE5QQSBtYWls
Ym94IGVycm9yIGNvZGVzDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21h
cnZlbGwvb2N0ZW9udHgyL2FmL3J2dS5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2
ZWxsL29jdGVvbnR4Mi9hZi9ydnUuaA0KPiA+IGluZGV4IGIxYTZlY2YuLmM4MjRmMWUgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1
LmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9y
dnUuaA0KPiA+IEBAIC0zNTAsNiArMzUwLDEwIEBAIHN0cnVjdCBydnVfZndkYXRhIHsNCj4gPiAg
ICAgICAgIHU2NCBtc2l4dHJfYmFzZTsNCj4gPiAgI2RlZmluZSBGV0RBVEFfUkVTRVJWRURfTUVN
IDEwMjMNCj4gPiAgICAgICAgIHU2NCByZXNlcnZlZFtGV0RBVEFfUkVTRVJWRURfTUVNXTsNCj4g
PiArICAgICAgIC8qIERvIG5vdCBhZGQgbmV3IGZpZWxkcyBiZWxvdyB0aGlzIGxpbmUgKi8NCj4g
PiArI2RlZmluZSBDR1hfTUFYICAgICAgICAgNQ0KPiA+ICsjZGVmaW5lIENHWF9MTUFDU19NQVgg
ICA0DQo+ID4gKyAgICAgICBzdHJ1Y3QgY2d4X2xtYWNfZndkYXRhX3MNCj4gY2d4X2Z3X2RhdGFb
Q0dYX01BWF1bQ0dYX0xNQUNTX01BWF07DQo+IA0KPiBQcm9iYWJseSB3YW50IHRvIG1vdmUgdGhl
IGNvbW1lbnQgYmVsb3cgdGhlIGZpZWxkLg0KDQpBZ3JlZWQgd2lsbCBmaXggdGhpcyBpbiBuZXh0
IHZlcnNpb24uDQoNClRoYW5rcywNCkhhcmlwcmFzYWQgaw0KDQo+ID4gIH07DQo+ID4NCj4gPiAg
c3RydWN0IHB0cDsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9vY3Rlb250eDIvYWYvcnZ1X2NneC5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2
ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY2d4LmMNCj4gPiBpbmRleCA3NGY0OTRiLi43ZmFjOWFiIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2Fm
L3J2dV9jZ3guYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9u
dHgyL2FmL3J2dV9jZ3guYw0KPiA+IEBAIC02OTQsNiArNjk0LDE5IEBAIGludCBydnVfbWJveF9o
YW5kbGVyX2NneF9jZmdfcGF1c2VfZnJtKHN0cnVjdA0KPiBydnUgKnJ2dSwNCj4gPiAgICAgICAg
IHJldHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiAraW50IHJ2dV9tYm94X2hhbmRsZXJfY2d4X2dl
dF9waHlfZmVjX3N0YXRzKHN0cnVjdCBydnUgKnJ2dSwgc3RydWN0DQo+IG1zZ19yZXEgKnJlcSwN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG1z
Z19yc3AgKnJzcCkgew0KPiA+ICsgICAgICAgaW50IHBmID0gcnZ1X2dldF9wZihyZXEtPmhkci5w
Y2lmdW5jKTsNCj4gPiArICAgICAgIHU4IGNneF9pZCwgbG1hY19pZDsNCj4gPiArDQo+ID4gKyAg
ICAgICBpZiAoIWlzX3BmX2NneG1hcHBlZChydnUsIHBmKSkNCj4gPiArICAgICAgICAgICAgICAg
cmV0dXJuIC1FUEVSTTsNCj4gPiArDQo+ID4gKyAgICAgICBydnVfZ2V0X2NneF9sbWFjX2lkKHJ2
dS0+cGYyY2d4bG1hY19tYXBbcGZdLCAmY2d4X2lkLCAmbG1hY19pZCk7DQo+ID4gKyAgICAgICBy
ZXR1cm4gY2d4X2dldF9waHlfZmVjX3N0YXRzKHJ2dV9jZ3hfcGRhdGEoY2d4X2lkLCBydnUpLA0K
PiA+ICtsbWFjX2lkKTsgfQ0KPiA+ICsNCj4gPiAgLyogRmluZHMgY3VtdWxhdGl2ZSBzdGF0dXMg
b2YgTklYIHJ4L3R4IGNvdW50ZXJzIGZyb20gTEYgb2YgYSBQRiBhbmQgdGhvc2UNCj4gPiAgICog
ZnJvbSBpdHMgVkZzIGFzIHdlbGwuIGllLiBOSVggcngvdHggY291bnRlcnMgYXQgdGhlIENHWCBw
b3J0IGxldmVsDQo+ID4gICAqLw0KPiA+IEBAIC04MDAsMyArODEzLDIyIEBAIGludCBydnVfbWJv
eF9oYW5kbGVyX2NneF9zZXRfZmVjX3BhcmFtKHN0cnVjdA0KPiBydnUgKnJ2dSwNCj4gPiAgICAg
ICAgIHJzcC0+ZmVjID0gY2d4X3NldF9mZWMocmVxLT5mZWMsIGNneF9pZCwgbG1hY19pZCk7DQo+
ID4gICAgICAgICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+ICsNCj4gPiAraW50IHJ2dV9tYm94X2hh
bmRsZXJfY2d4X2dldF9hdXhfbGlua19pbmZvKHN0cnVjdCBydnUgKnJ2dSwgc3RydWN0DQo+IG1z
Z19yZXEgKnJlcSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgc3RydWN0IGNneF9md19kYXRhICpyc3ApIHsNCj4gPiArICAgICAgIGludCBwZiA9IHJ2dV9n
ZXRfcGYocmVxLT5oZHIucGNpZnVuYyk7DQo+ID4gKyAgICAgICB1OCBjZ3hfaWQsIGxtYWNfaWQ7
DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCFydnUtPmZ3ZGF0YSkNCj4gPiArICAgICAgICAgICAg
ICAgcmV0dXJuIC1FTlhJTzsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAoIWlzX3BmX2NneG1hcHBl
ZChydnUsIHBmKSkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FUEVSTTsNCj4gPiArDQo+
ID4gKyAgICAgICBydnVfZ2V0X2NneF9sbWFjX2lkKHJ2dS0+cGYyY2d4bG1hY19tYXBbcGZdLCAm
Y2d4X2lkLA0KPiA+ICsgJmxtYWNfaWQpOw0KPiA+ICsNCj4gPiArICAgICAgIG1lbWNweSgmcnNw
LT5md2RhdGEsICZydnUtPmZ3ZGF0YS0NCj4gPmNneF9md19kYXRhW2NneF9pZF1bbG1hY19pZF0s
DQo+ID4gKyAgICAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCBjZ3hfbG1hY19md2RhdGFfcykpOw0K
PiA+ICsgICAgICAgcmV0dXJuIDA7DQo+ID4gK30NCj4gPiAtLQ0KPiA+IDIuNy40DQo+ID4NCg==
