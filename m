Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39B52B2FF4
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKNTGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:06:22 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgKNTGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:06:21 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJ6Hwa023295;
        Sat, 14 Nov 2020 11:06:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=2PlSe6RWt82d0iydTLcYbNe6ftJe/AfZMG4jMlgFsvg=;
 b=EUNDC6I+Tf2nAXo0w6QVi63kek/ej/KAreRQcgEUSr4bfVC4z3DYKqBwaZ5+VeDfPuiT
 QKqbyzFCs6Ea5HXFPRchLudXYOEShf6wFBn8AxlRbZJ5MFvIS+d9EfRjeFxi/L8nuabv
 7bIJ5xmwBFt0nSNrJ9ccfJmHoSSt7J9C5bDzPA3jxPXz6UtbNtdjjfdY/qVUGUfXzc25
 bbc4eZCg3WUdi555VjCh6fnHEbxMS0se4IScngLo/2EHXMh7s2q6UF4gQUK8rS3P5t0H
 EtyecLfSmoyWaDr26vrrp+pnRIojW5/fnPyM6p4VELsMBHHZCGF6qTqDNohCXLNLwfii Ng== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfms8msw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:06:17 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:06:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 14 Nov 2020 11:06:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDj5tR8GDBs67DrvQgzsWJHuW9CdsiOXv5Q+SBN3VaOEDAQDYjOilu9gmff41f6jzpVv4wItXz7IrzWj7xKYt620yJY6s36jzq6CM551Z08XkcbFDX1nYXZuR157XQYJoNl40YVC+YQd3yCwc7Nm9nzmgKAJWOqhKze5buI261U9SBEVK2igei0mVHFFGoVkf+bPlmqmkyXb39OM7dsFSJfZk1bT5Io1i4cb5ChGs2HvOKBupQkhHrKixJjr4i5eVh86Lgob9WUXDe3IHGeSYp9TUF9o1A+d9+ISXoUPL49OaUKeAJ26CvkLslv7CUTKqLbwKTOI2sF5p+sSfVRtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PlSe6RWt82d0iydTLcYbNe6ftJe/AfZMG4jMlgFsvg=;
 b=e1CG8kjHtYuCHbTgFyknlm2oZXbczLIh6R4tZij5f15D+L/4NXcyhDmfEC00X9a/drmP9jm1cy71tHhk5OvyzyagSwlYliQHCVeYWRw5qHPhqHKcwBKMoFCewuXNMV4/0AKtlsGp/ksnDRCBOzqBj/dCmKKKDMEAVGnEhEUDjU7Uj8RsLtnpKnwEF57WnL4q9SllS99QR0pntXvpxVwO75+JqmVkUBzTu8/WiFVhIW0JcYYySqPn1jHTTi9CqjXDXOdTbmPWYuDpDhO1llyTLnKQs9ufYd2bQgFUSxCESsdgretZPN/XTwygjDYU4OvIL0JetcGxUI2WhJcwIe62XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PlSe6RWt82d0iydTLcYbNe6ftJe/AfZMG4jMlgFsvg=;
 b=Xn2k/sj+qu/fMZmsr2Sz1O5nbVdo2/iCEJEizcWEXZ67dGfqbrhoKZaeuFMuLlbRNUFMIv0/pDCIf/oY6PzJfkcEfPKaC2hVUYQXFoLpmRnRRXFqg0VZfTffz/dUW7qikK2A4hqe1oCmrUlNtmh1OJkolwCRVnIjU4B/yLXBGDY=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM6PR18MB3507.namprd18.prod.outlook.com (2603:10b6:5:2a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Sat, 14 Nov
 2020 19:06:13 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Sat, 14 Nov 2020
 19:06:13 +0000
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
Subject: Re: [PATCH v3 net-next 00/13] Add ethtool ntuple filters support
Thread-Topic: [PATCH v3 net-next 00/13] Add ethtool ntuple filters support
Thread-Index: Ada6uN8X0PoLnrWCSduZuWXchAYCXA==
Date:   Sat, 14 Nov 2020 19:06:13 +0000
Message-ID: <DM6PR18MB321250732B1A9B243DF437F4A2E50@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.206.46.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 770352ac-7e78-4a47-975b-08d888d05ae4
x-ms-traffictypediagnostic: DM6PR18MB3507:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB350761C0BD417562F4DCF9EBA2E50@DM6PR18MB3507.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AC1NEFB72bc2CjrwRoizsnvhM+KSq87FlXFpy5aoshvzyYMmJXH15cjtH6+j1f3Ju3lc3i4wVcoMRUv8ghQY8Uwpc+S8YuJQv5+7nkPE0zHX85BW1/KylZUp9rJG273YBOk/OB9tFQMJlJiy1Tqj0kefpLTxC5SlbICPQr90iKITw3XTTKZNKyydAsog/a9wuDg549WoOtEWxTQvRjWKVLHcfk7nK9hZsi6MEQuIdn8CXyHUMZl+OoGtoHHNHwpziP3Rq4W33a7uxqM7rtjA8ZquLXDARIGTONBuGJKcs6ejuHWMU2Rc0G3gqvxa6GIDO55aALwzmZEkCbBqmgcGOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(6506007)(478600001)(2906002)(52536014)(33656002)(26005)(7696005)(76116006)(8936002)(66946007)(55016002)(53546011)(5660300002)(54906003)(55236004)(4001150100001)(9686003)(86362001)(110136005)(83380400001)(316002)(8676002)(66556008)(66446008)(64756008)(107886003)(66476007)(4326008)(71200400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wZU/XcQuBI3XoGgQb5clyaBVieHU1pXlrjbJLd4RQ3uYySDNIyy2ElWFp6HS81jmj0+lusV6JpZTTnlIPdPSzVlp4h4Es/Try3yoBLEXmDbHQ7exM5YE48yZkINZCDZ9yeJl8yBAqWTl6LYlpW9HKY0TNcE8jxWjWg5DudIySO9gi8u7NkIi6yaZhz2ZBpW+8gnDXTg1UJOKG8OBeuA7pATE9N4q4B/72kz5QRmJ7zIzie7jKDuPDVWzPmXiyL0JXyxsM+VrznPydFmsjtpEk0slIjYo758ZPcRMvCtlAU024KJTwha0Jq7+3VojwmX89WoMTXwR0QgcdP9+CD9BviPRm5/xb9w9puwr4ozZpSXQZONpaBddmZ1M+AdeT7wJyq4jKPE414sGvHwilYzodEDkZy9qOC5r85lAGTiUWm7BU/L523jWTOKioqtz/AWEE63gnCv5lIBQlBF7bgb7j54/I5hnOgqQQRPhVcwAIFBm8g7FBCWItTF3Up7UEuw2CabEaAXW8fS4/qrs3n5qNyRALuh5gCPFCEb+EHmKUBMzMTXrxPi4cqkMM5bY8ePWN8tbPiILexQlwam6ECYkvQbft7hxsmLkAazBQvl9rXNlpPf5HwXeIIeUpvwoZn9NwWV10qpfFlHrZm0UpEIFog==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770352ac-7e78-4a47-975b-08d888d05ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 19:06:13.1041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l6ruz1ASj+G3ySZzT+0hZHOkX6G9QveinqJZHnACWB0kLOxFYLvGSMUFErBVhNLF5YBMuxvrbxzsn7xzvearXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3507
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz4NCj4g
U2VudDogRnJpZGF5LCBOb3ZlbWJlciAxMywgMjAyMCAxOjQ3IEFNDQo+IFRvOiBOYXZlZW4gTWFt
aW5kbGFwYWxsaSA8bmF2ZWVubUBtYXJ2ZWxsLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGt1YmFAa2VybmVsLm9yZzsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgU3VuaWwgS292dnVyaSBHb3V0aGFtDQo+IDxzZ291dGhhbUBt
YXJ2ZWxsLmNvbT47IExpbnUgQ2hlcmlhbiA8bGNoZXJpYW5AbWFydmVsbC5jb20+Ow0KPiBHZWV0
aGFzb3dqYW55YSBBa3VsYSA8Z2FrdWxhQG1hcnZlbGwuY29tPjsgSmVyaW4gSmFjb2IgS29sbGFu
dWtrYXJhbg0KPiA8amVyaW5qQG1hcnZlbGwuY29tPjsgU3ViYmFyYXlhIFN1bmRlZXAgQmhhdHRh
IDxzYmhhdHRhQG1hcnZlbGwuY29tPjsNCj4gSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1hcnZl
bGwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIG5ldC1uZXh0IDAwLzEzXSBBZGQgZXRo
dG9vbCBudHVwbGUgZmlsdGVycyBzdXBwb3J0DQo+IA0KPiBPbiBXZWQsIDIwMjAtMTEtMTEgYXQg
MTI6NDMgKzA1MzAsIE5hdmVlbiBNYW1pbmRsYXBhbGxpIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2gg
c2VyaWVzIGFkZHMgc3VwcG9ydCBmb3IgZXRodG9vbCBudHVwbGUgZmlsdGVycywgdW5pY2FzdA0K
PiA+IGFkZHJlc3MgZmlsdGVyaW5nLCBWTEFOIG9mZmxvYWQgYW5kIFNSLUlPViBuZG8gaGFuZGxl
cnMuIEFsbCBvZiB0aGUNCj4gPiBhYm92ZSBmZWF0dXJlcyBhcmUgYmFzZWQgb24gdGhlIEFkbWlu
IEZ1bmN0aW9uKEFGKSBkcml2ZXIgc3VwcG9ydCB0bw0KPiA+IGluc3RhbGwgYW5kIGRlbGV0ZSB0
aGUgbG93IGxldmVsIE1DQU0gZW50cmllcy4gRWFjaCBNQ0FNIGVudHJ5IGlzDQo+ID4gcHJvZ3Jh
bW1lZCB3aXRoIHRoZSBwYWNrZXQgZmllbGRzIHRvIG1hdGNoIGFuZCB3aGF0IGFjdGlvbnMgdG8g
dGFrZSBpZg0KPiA+IHRoZSBtYXRjaCBzdWNjZWVkcy4gVGhlIFBGIGRyaXZlciByZXF1ZXN0cyBB
RiBkcml2ZXIgdG8gYWxsb2NhdGUgc2V0DQo+ID4gb2YgTUNBTSBlbnRyaWVzIHRvIGJlIHVzZWQg
dG8gaW5zdGFsbCB0aGUgZmxvd3MgYnkgdGhhdCBQRi4gVGhlDQo+ID4gZW50cmllcyB3aWxsIGJl
IGZyZWVkIHdoZW4gdGhlIFBGIGRyaXZlciBpcyB1bmxvYWRlZC4NCj4gPg0KPiA+ICogVGhlIHBh
dGNoZXMgMSB0byA0IGFkZHMgQUYgZHJpdmVyIGluZnJhc3RydWN0dXJlIHRvIGluc3RhbGwgYW5k
DQo+ID4gICBkZWxldGUgdGhlIGxvdyBsZXZlbCBNQ0FNIGZsb3cgZW50cmllcy4NCj4gPiAqIFBh
dGNoIDUgYWRkcyBldGh0b29sIG50dXBsZSBmaWx0ZXIgc3VwcG9ydC4NCj4gPiAqIFBhdGNoIDYg
YWRkcyB1bmljYXN0IE1BQyBhZGRyZXNzIGZpbHRlcmluZy4NCj4gPiAqIFBhdGNoIDcgYWRkcyBz
dXBwb3J0IGZvciBkdW1waW5nIHRoZSBNQ0FNIGVudHJpZXMgdmlhIGRlYnVnZnMuDQo+ID4gKiBQ
YXRjaGVzIDggdG8gMTAgYWRkcyBzdXBwb3J0IGZvciBWTEFOIG9mZmxvYWQuDQo+ID4gKiBQYXRj
aCAxMCB0byAxMSBhZGRzIHN1cHBvcnQgZm9yIFNSLUlPViBuZG8gaGFuZGxlcnMuDQo+ID4gKiBQ
YXRjaCAxMiBhZGRzIHN1cHBvcnQgdG8gcmVhZCB0aGUgTUNBTSBlbnRyaWVzLg0KPiA+DQo+ID4g
TWlzYzoNCj4gPiAqIFJlbW92ZWQgcmVkdW5kYW50IG1haWxib3ggTklYX1JYVkxBTl9BTExPQy4N
Cj4gPg0KPiA+IENoYW5nZS1sb2c6DQo+ID4gdjM6DQo+ID4gLSBGaXhlZCBTYWVlZCdzIHJldmll
dyBjb21tZW50cyBvbiB2Mi4NCj4gPiAJLSBGaXhlZCBtb2RpZnlpbmcgdGhlIG5ldGRldi0+Zmxh
Z3MgZnJvbSBkcml2ZXIuDQo+ID4gCS0gRml4ZWQgbW9kaWZ5aW5nIHRoZSBuZXRkZXYgZmVhdHVy
ZXMgYW5kIGh3X2ZlYXR1cmVzIGFmdGVyDQo+ID4gcmVnaXN0ZXJfbmV0ZGV2Lg0KPiA+IAktIFJl
bW92ZWQgdW53YW50ZWQgbmRvX2ZlYXR1cmVzX2NoZWNrIGNhbGxiYWNrLg0KPiA+IHYyOg0KPiA+
IC0gRml4ZWQgdGhlIHNwYXJzZSBpc3N1ZXMgcmVwb3J0ZWQgYnkgSmFrdWIuDQo+ID4NCj4gDQo+
IFJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+DQoNCg==
