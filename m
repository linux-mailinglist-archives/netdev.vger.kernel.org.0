Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA13C11E11C
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfLMJpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:45:38 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9752 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbfLMJpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:45:38 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBD9jSrW032570;
        Fri, 13 Dec 2019 01:45:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=35WXXYWG+i9TEFNpZmh5n7omgbYgsupYzFVXr7ZjGy4=;
 b=cTnwn33bA6A4sWAj+p694S8t5SzE4T+wwr5LVseCwf83O5GJPkmHjaOe2icebSxtSzhz
 PFWFzS0Y66t7yJlzEHrFmVcnGNKMcQBfA1eBCwar3kpy2UEZ8nmF68dFD3JyVF4lPTix
 XbVfzGIeRVXEBIT/u4FialwP06/kIYFp9Ze+ObpLpF0fFzI41WTs+KSCVmPM9IEwPDX3
 o6uEnq5eba/uUwPvQvU6vReI6CP68Mt5bjWGRDHjtdMzoNph8oanFFlviuK+4JE+m8ky
 A86++frNUm07mnINZ43j6bjHUz/Wca4Pnpb6W3qX1rd/9guazK4m3tw1yUpDlFjWOuRK bw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wv4tg8rbj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 01:45:35 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Dec
 2019 01:45:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 13 Dec 2019 01:45:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrLQwfDjUIPTfK0wc5+hwsMotDsLldNq7/QXMX9J5oyOXqqrIWnc5NTKUCnJxUs04I4jpTAp389LUQMFGPIbdEdfGLHKhEOmoBgmn4/Ex1pPHO4VVXL6p81FL8ADQ5JZjzx0E5YeqNx/S8I67erVGh6Vsd33Lvi4LPYX8Qb67SjBYLlibvWMoyoXONFsC5mzCK+5xm7NfsJtwHCXclzGF+MYLBU3DPPbZ6D1Bij23qkdwHZ+5Q1GSsyKmrQLHAaeoH2rTmi7kb6XFzrc8kxAU/WeURyoaH2+1+hHi1xBU3zO6H3WUlDJZ2mLm+DiTEpC/zs/2AE8q7YFO2i289tC8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35WXXYWG+i9TEFNpZmh5n7omgbYgsupYzFVXr7ZjGy4=;
 b=Ebn4q0I+zxLkqqsqi1c5Aq1bDvmUtYm0JPrfz7cZGr9SAKrZdznGuaPImelb6ubGy2KGcb5DOWPdVlaOt/2IQ1Ga0tJje6fI5tttic1W/5pYHbI7x39URi1/R/K3tikgIeNDlxYhoNsAw0c5ggXsCtIul3zw2D8baV7NVLNGSkxscNu96yioYartG7b6rOsdUihPx3Z0nNr8iqyfAQxhCKOG27HvhdfWCDPRo9/7RRO7YAro5EoP8dQN00Csg25Uoxpo+oZ/vufDuGD5GjydWbmrITeG+o+/Owx1jRB15HOaifyAp2sMM/tOu5LRi1mWsmvMJtoGktzWKM/XiyTEJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35WXXYWG+i9TEFNpZmh5n7omgbYgsupYzFVXr7ZjGy4=;
 b=dtoEjsk4uwButccm0DIL1ORPUNuqs2ubHj0gJP+37vhh51HcHws2L8MPsTRlgCXeIp7F306OhHfCm09JgZAzzS/dB+aBLQsSq1vxlFnkfVrncA1F8kgV0itW4iloGBuIt1KuGBAwt2NEyYqBZJxQ6quV1ZwBEn2Nc/JrXPi+SVQ=
Received: from BY5PR18MB3379.namprd18.prod.outlook.com (10.255.136.142) by
 BY5PR18MB3265.namprd18.prod.outlook.com (10.255.139.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Fri, 13 Dec 2019 09:45:32 +0000
Received: from BY5PR18MB3379.namprd18.prod.outlook.com
 ([fe80::2063:308e:d9e6:5b6e]) by BY5PR18MB3379.namprd18.prod.outlook.com
 ([fe80::2063:308e:d9e6:5b6e%7]) with mapi id 15.20.2516.020; Fri, 13 Dec 2019
 09:45:32 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Michael Chan <michael.chan@broadcom.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is installed
Thread-Topic: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is
 installed
Thread-Index: AdWxYyOH9Q0NPNE5QOubY6DZVvHbMwACD3OAAAq2EKA=
Date:   Fri, 13 Dec 2019 09:45:32 +0000
Message-ID: <BY5PR18MB3379AC23267423E0CE9EEA05AB540@BY5PR18MB3379.namprd18.prod.outlook.com>
References: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
 <CACKFLi=30KJXL0xbdfgYqxWML5C5ZWyDPjtATByVf7hsao9gZQ@mail.gmail.com>
In-Reply-To: <CACKFLi=30KJXL0xbdfgYqxWML5C5ZWyDPjtATByVf7hsao9gZQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d97b04a5-6bd8-4ad1-566b-08d77fb13246
x-ms-traffictypediagnostic: BY5PR18MB3265:
x-microsoft-antispam-prvs: <BY5PR18MB3265C6AEFE24FF7E32F61AF2AB540@BY5PR18MB3265.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(13464003)(66946007)(53546011)(26005)(6506007)(186003)(33656002)(71200400001)(76116006)(66446008)(86362001)(66476007)(66556008)(55016002)(7696005)(9686003)(6916009)(4326008)(64756008)(316002)(81166006)(2906002)(5660300002)(52536014)(8936002)(478600001)(8676002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR18MB3265;H:BY5PR18MB3379.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +0Q79VrXvAT05XOYxpycQPO9iBWH7WtJRa6RpNxlgi0kuT0bIFXT9iL0LNCb6buQcPKJiGYja9Yts7mv/vYs0jXF2tZQIlSVb/R8WdoYO+UT6Zobcrt9MeRAdfK4TNeNF5KkGAjSIOHkd+t1JRrEl4yGsU4x3c6C2UWthfQxZW0UvfJZ8b2fwnVE2l/IuaPgvM3TVHNJ22rE4P3+pu0mXKfrVXCMxjQV7yGkhjbOe5ClKK9SU+lI0jmgbS4MkkIsDlHBUuo4Zxl+LGo7Be89ZUfwOA/EDAopzcyrbCs7PAfMjg4/ODqlv3GCiHlJDpr54qww4Gb/IbRJ1THCI1FMTugNbd1BDg4CJ8fztZ4nU/X9Cp+ScpwNwtOSEvdPeFrjtnKA9J1TSp7EJpGk1D2YQyRgDNICEX088jt7qZS8R8q7A9ymMpxTMhiAWV8GuQV8xORDuE6mFgrEJoDXSxQ7MjCLtVQim9Ck8ws4ELgTPpxQyFL2AR6Vogp+nC6AZ6ET
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d97b04a5-6bd8-4ad1-566b-08d77fb13246
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 09:45:32.4974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWnjvCP7EZocUL0Z7BojcUk98apfrUQZFgr9NN44FVIYMqCgm40n1wqnamAev9Z5edvafqGFekM2YtULdyhNuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3265
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_02:2019-12-12,2019-12-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWljaGFlbCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWNo
YWVsIENoYW4gPG1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgRGVj
ZW1iZXIgMTMsIDIwMTkgOTo0MSBBTQ0KPiBUbzogTWFuaXNoIENob3ByYSA8bWFuaXNoY0BtYXJ2
ZWxsLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0VYVF0g
UmU6IExSTy9IV19HUk8gaXMgbm90IGRpc2FibGVkIHdoZW4gbmF0aXZlIHhkcCBpcyBpbnN0YWxs
ZWQNCj4gDQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IE9uIFRodSwg
RGVjIDEyLCAyMDE5IGF0IDc6MTMgUE0gTWFuaXNoIENob3ByYSA8bWFuaXNoY0BtYXJ2ZWxsLmNv
bT4NCj4gd3JvdGU6DQo+IA0KPiA+IFdoZW4gYXR0YWNoaW5nIG5hdGl2ZSB4ZHAgcHJvZ3JhbSwg
ZGV2aWNlJ3MgYWdncmVnYXRpb24gZmVhdHVyZXMgKGkuZQ0KPiBMUk8vSFdfR1JPKSBhcmUgbm90
IGdldHRpbmcgZGlzYWJsZWQuDQo+ID4gVGhleSBzZWVtcyB0byBiZSBnZXR0aW5nIGRpc2FibGVk
IG9ubHkgaW4gY2FzZSBvZiBnZW5lcmljIHhkcCBpbnN0YWxsLA0KPiA+IG5vdCBpbiBjYXNlIG9m
IG5hdGl2ZS9kcml2ZXIgbW9kZSB4ZHAsDQo+IA0KPiBUaGF0IHNvdW5kcyByaWdodC4gIEZvciBi
bnh0LCB3aGVuIGFuIHhkcCBwcm9ncmFtIGlzIGF0dGFjaGVkLCB0aGUgZHJpdmVyDQo+IHdpbGwg
cnVuIGluIGEgc3BlY2lhbCBwYWdpbmcgbW9kZSB0aGF0IHdvbid0IHN1cHBvcnQgTFJPIG9yIGhh
cmR3YXJlIEdSTy4NCj4gU28gdGhleSBhcmUgYXV0b21hdGljYWxseSB0dXJuZWQgb2ZmLiAgSXNu
J3QgdGhhdCB0aGUgY2FzZSBmb3IgeW91ciBkZXZpY2UgYXMNCj4gd2VsbD8NCg0KSXQgdXNlZCB0
byBiZSB0aGUgY2FzZSBmb3Igb3VyIGRldmljZXMgYXMgd2VsbCBsb25nIGJhY2suIGJ1dCBhZnRl
ciB0aGUgY29tbWl0IDE4YzYwMmRlZTQ3MjYgKCJxZWRlOiBVc2UgTkVUSUZfRl9HUk9fSFciKQ0K
dGhhdCBwYXJ0IHdhcyByZW1vdmVkIGZyb20gb3VyIGRyaXZlciBhbmQgY29tbWl0IDU2ZjVhYTc3
Y2RhZDEgKCJuZXQ6IERpc2FibGUgR1JPX0hXIHdoZW4gZ2VuZXJpYyBYRFAgaXMgaW5zdGFsbGVk
IG9uIGEgZGV2aWNlIikNCndhcyBhZGRlZCB0byBhY2hpZXZlIHRoZSBzYW1lIGluc3RlYWQgb2Yg
aW5kaXZpZHVhbCBkcml2ZXIgZG9pbmcgaXQsIGJ1dCBpdCB3YXNuJ3QgY2F1Z2h0IHRoYXQgdGlt
ZSB3aHkgbGF0ZXIgY29tbWl0IG9ubHkgZG9lcyBmb3IgZ2VuZXJpYyB4ZHAsDQpub3QgZm9yIG5h
dGl2ZSB4ZHAuIFNvIHRvZGF5IHdoZW4gbmF0aXZlIHhkcCBpcyBhdHRhY2hlZCB0byBvdXIgZGV2
aWNlLCBIVyBHUk8gYWdncmVnYXRpb24gcmVtYWlucyBlbmFibGVkIG9uIG91ciBkZXZpY2UuDQpQ
bGVhc2UgbGV0IG1lIGtub3cgaWYgdGhhdCBmaXggaXMgZ29vZCBlbm91Z2ggdG8gYmUgcG9zdGVk
LiBXaWxsIHRlc3QgaXQgb3V0IGFuZCBwb3N0Lg0KDQpUaGFua3MsDQpNYW5pc2gNCg0KDQoNCg0K
