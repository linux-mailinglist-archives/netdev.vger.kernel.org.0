Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59F32CE48D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgLDAlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:41:20 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4792 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726478AbgLDAlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:41:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B40Ve7F012553;
        Thu, 3 Dec 2020 16:39:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=XIw2CR7v4Z70GQ/vjfPDxuMGrhLP9buI6EERSrEuyQE=;
 b=UQWhfyvFjAlpNT0QdJlRzixqRjiLy+HD+E8nSXHsN+Ya6UAC4rJPbfg/QeGCIHtLOUCF
 GkZb1FPtoi5lUnOLGLn4eg/x7RyM7ZyZySgeMmdL9MaVDOxYFiJX6he02ZT5e8Tx86f5
 LYiMeJj2OZ+LBrXcNyX/zBxyG7MehEC7yTx5s8bCxkJCYmCBDcJ94cQv9H7jVd1YoD3L
 1ZHDP3K3cZSixcOM0EsppcPHpVw6TvfbU+5bOaqGh+plCt9Moixi8V/EAjc1WAxEjVjV
 k/nP5yNUNZkkRlInDirIDiIJz2wkowtXZmT+Su9T7/VJUtSUa4O83Oar+2IgGpB1asCk QA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jfedwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:39:59 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 16:39:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 16:39:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELHL6bBc+LGXmYAAOQyb6xZEUI6KANaCw2j8tvHzftT08V9TCnO82xJ1/7pI+Jp2Ymt/+qgC0QJ4a9CkrE5tS6vFxxzhb9mXtcHGx2O7ePMDBO4Pa1L37L8UhFHqVqgJTQBq/JWuoRDJgy0hIxy7odI+jmsefMzVXRFYWuOhyx+Xao0DqRFirASgSEG+hm0UOLx2aS0o60hLuxqor2F9v2nhRji6NqGhNYZTPt/5F6ZW/w28lFLWyLdg3IoUC2ZrmhxdO9kn/yh8BK1fLIHpQU0IQ9KKlA08y1XcuHSOJzNV7wP19STUOHmPIDMRkZYvrXLHjSpP4dWZ73hA4w4AGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIw2CR7v4Z70GQ/vjfPDxuMGrhLP9buI6EERSrEuyQE=;
 b=TPRFlrdci7NMYxhbjnvVNLrc69XgJwdSwSNhn57YA0rA4b7vGYmbLTELHLbucqrb2tpx0Jj54DG+rtXs6lUrXz3pHi6r+wNLuOFtVhxvHt5RXN1R8qI7qLo9icsUHafL5ihf31cRq1YY/0gA+4D7eeYE91IXt5g6932dhHbh6cRMNB0UAgtiS1YE3CsX3slzZabk2Og7PIC9rYP2OwRkD/+51jrxyD7aQ7XqC2S1avS3sl0kkghmhlPrIPIF0CH9051EJtiXBqNZxH5fWjIT+wg3ofQe3qdTYuOWsIfR7pt8RvT70MHOdFZ5VzHCmlDv1A2MhtKth1ROL43sB5LBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIw2CR7v4Z70GQ/vjfPDxuMGrhLP9buI6EERSrEuyQE=;
 b=lf20Xz9pTuLNoedH2vSfX7vXDuePWllPk3fiINoXF0Hj9AyNYw5L8UJJNLUqw5VwvEt8fseZ0QTOxjxUNA5xnYwWk/Z6TBJj+924t1W3jSkIDKJV55d6mqWutdP/nky7UIE1Xb7W1TCFUiyN9gcmGfIJ9ssj/4XvanFZxj31Qqw=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1824.namprd18.prod.outlook.com (2603:10b6:301:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 00:39:56 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363%6]) with mapi id 15.20.3632.020; Fri, 4 Dec 2020
 00:39:56 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "mark.rutland@arm.com" <mark.rutland@arm.com>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 0/9] "Task_isolation" mode
Thread-Topic: [EXT] Re: [PATCH v5 0/9] "Task_isolation" mode
Thread-Index: AQHWwcAN4HMJq5rZb0WNk0YfmsaUganXfHoAgAAR6ICADFWtgIACRGgA
Date:   Fri, 4 Dec 2020 00:39:55 +0000
Message-ID: <7ca706d55fefabb9105d04476d45bbe2782b51d0.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <b0e7afd3-4c11-c8f3-834b-699c20dbdd90@redhat.com>
         <a31f81cfa62936ff5edc420be63a5ac0b318b594.camel@marvell.com>
         <20201202140233.GB66958@C02TD0UTHF1T.local>
In-Reply-To: <20201202140233.GB66958@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bd10368-610d-4ae5-ee2a-08d897ed1f3e
x-ms-traffictypediagnostic: MWHPR1801MB1824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB18244C40F2C23854D95C4F68BCF10@MWHPR1801MB1824.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +crTs0YQM9o2wGBmGrxCmbr1n+NlelYiM2I+QSc4srbL60/BkeLUH/5G9iiUtgJc3zJZTwiGW+uNeub9LwawLrf1TdWCFGCh31kMqEhK7eODnU06n1eXDM2xChreAL+DRZxW6wmuEydxM56sJCEhrxoO9qYhYvRtIP3um5hzmToxK/E3Ox7w++YjGVNTc3AYJZ1c15nYG5iWxIWSOWkCr41qw1xiDOjrV+OzGu8qKC1sDP2E8RVYOCJFhLRN8B7J6e3+b+PlLInvEvA/XQ2/2KmNhSjtSOJ7L4XgiBkTvj9KXpvDN94v0PBUK89J72Z+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(66476007)(6506007)(4326008)(478600001)(71200400001)(8676002)(66556008)(76116006)(6916009)(316002)(66946007)(91956017)(36756003)(64756008)(86362001)(4744005)(5660300002)(8936002)(6486002)(66446008)(26005)(54906003)(7416002)(6512007)(2906002)(186003)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a1dtbVZrd0JFT1BOZEVjVTQ5WWU2SFFaVjZEaU9lVTRva2h2Q3VqVUNyV2pT?=
 =?utf-8?B?N1gzL3FpZWFWMTlGbGtwZHlpc0cwZTVOZXB5UTBvU1J4bjVWeTF0cmNEejJL?=
 =?utf-8?B?d0VybTFvQjBnaTJRYTBXV3Fic2JVYnkvaFJvSEV6dHJOYTZoQ2d0T3ltbDhV?=
 =?utf-8?B?b3g4YkM4R0FtS1FMT0ZHZ2V0MVp1ZVBzbGppRk55bmI4VzlmYmNrZmJqK242?=
 =?utf-8?B?LzMxWDBWMGpwa0lzbzNQREtiMy9uNDMxOCtBRkhOMndsczRTL2pwVVAzSi9E?=
 =?utf-8?B?YlRVZ3krTVlrWEtSQkY4SnpoMGJtclVPNUxQWVh2bkU5amJybzN3OFNQbjRJ?=
 =?utf-8?B?aTlhZlFxeDJMS1RMZUkzalVTUTc3QTFUVzczUENHajVFNEdHa3p2ajRMN0xP?=
 =?utf-8?B?VTRvNk9JbllxcFBZdithbVpSZVhHRXFIcWhPK0tBNzhBUVVPUTQ2OEN6NGRW?=
 =?utf-8?B?ZjhTNStFYnRUemFzWC85ZW9WODY0Vk9qeFY5ZHU5QkhudnFLNXhKcFhJbU53?=
 =?utf-8?B?T0ZWWVJtd1ovMElZOWlLRTQ2T0drU29QeEFGdTBieXprY3dpTGVUeEQ1ZWNr?=
 =?utf-8?B?VFdrT0ZUMFZCNHRPNUlRd0dOSXpXb0NtdzB2dnk0Ni95SFlnNTVPWnVxWXU4?=
 =?utf-8?B?VjZlc2FGMlQ0alRCY0ZwT2kxZ3AvVlNjVm1QNjJxcy9xU3FSMHdWbWlGWWFS?=
 =?utf-8?B?S1BHS3g0aEp1Vng4czc3T05TVytCdmVsd3cxZmx5UlJFVDc3Qm5XTWxRVVRI?=
 =?utf-8?B?VjFBSUJNa24rMmJZNzhqcmQydElhMjMvSGZBRFJpMkY2eUxHa0JnV2dKQXFB?=
 =?utf-8?B?TTA4ZGlubHZiUWRBNnVEdnNxVUcxdzViUy9XVnBjb09sR1duKzRRWHlIMjRM?=
 =?utf-8?B?QytmYzZrL245Rjg4NVNqVUxhVTIwMXEzSko2bFNBckxMeTBKdXgyMWxtQkdO?=
 =?utf-8?B?Wk1KT0RzZXNQcUtINzFONTV4WFVwS0N6Z0p2YU04TlArRkx1Ukc3ck94dUFK?=
 =?utf-8?B?N3Z4TzVUa1RoVFd3QTRXUk94c3JEZ2JvTlhMM0NXd3NJSnBsUlQ1MzlXWnFy?=
 =?utf-8?B?b0xPWnNkaGZsUWNCY1RScHhyeHkram9CbDJHTWgvRWNvampDTWk4WGZSRVBG?=
 =?utf-8?B?WkZYN1k3REVIclRjbEJhYjJHeUlTK01MczlaRE9qV1Zsc3Q2c2w4c05IeG0w?=
 =?utf-8?B?ZUxUbmlWckFzekhtTDRBL0JMd3RjTTc3R3pSNDVnQVlxelpEY0NNbkdCZ2RE?=
 =?utf-8?B?Y2Q0NlhRejJQUUZoNXJ2UHhCaTg1NEhKYkZTZzRDYUhhS2ZZd3I2NzB6b3Iz?=
 =?utf-8?Q?47ZEre4cljO7FJyJaK1MOZhmdoAlZo8RQt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E008135782AF448B2F54C42C1F745FD@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd10368-610d-4ae5-ee2a-08d897ed1f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 00:39:55.8457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sPzHVELvcnVavCqmAJhH8ynii0Gz0i3CE7ntIo3RM3nG3lPL9u7TIDPbh1y4LsDjxHg2pISyfu65kcr3Xx9BkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1824
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQsIDIwMjAtMTItMDIgYXQgMTQ6MDIgKzAwMDAsIE1hcmsgUnV0bGFuZCB3cm90ZToN
Cj4gT24gVHVlLCBOb3YgMjQsIDIwMjAgYXQgMDU6NDA6NDlQTSArMDAwMCwgQWxleCBCZWxpdHMg
d3JvdGU6DQo+ID4gDQo+ID4gPiBJIGFtIGhhdmluZyBwcm9ibGVtcyBhcHBseWluZyB0aGUgcGF0
Y2hzZXQgdG8gdG9kYXkncyBsaW51eC1uZXh0Lg0KPiA+ID4gDQo+ID4gPiBXaGljaCBrZXJuZWwg
c2hvdWxkIEkgYmUgdXNpbmcgPw0KPiA+IA0KPiA+IFRoZSBwYXRjaGVzIGFyZSBhZ2FpbnN0IExp
bnVzJyB0cmVlLCBpbiBwYXJ0aWN1bGFyLCBjb21taXQNCj4gPiBhMzQ5ZTRjNjU5NjA5ZmQyMGU0
YmVlYTg5ZTVjNGE0MDM4ZTMzYTk1DQo+IA0KPiBJcyB0aGVyZSBhbnkgcmVhc29uIHRvIGJhc2Ug
b24gdGhhdCBjb21taXQgaW4gcGFydGljdWxhcj8NCg0KTm8gc3BlY2lmaWMgcmVhc29uIGZvciB0
aGF0IHBhcnRpY3VsYXIgY29tbWl0Lg0KDQo+IEdlbmVyYWxseSBpdCdzIHByZWZlcnJlZCB0aGF0
IGEgc2VyaWVzIGlzIGJhc2VkIG9uIGEgdGFnIChzbyBlaXRoZXIgYQ0KPiByZWxlYXNlIG9yIGFu
IC1yYyBrZXJuZWwpLCBhbmQgdGhhdCB0aGUgY292ZXIgbGV0dGVyIGV4cGxhaW5zIHdoYXQNCj4g
dGhlDQo+IGJhc2UgaXMuIElmIHlvdSBjYW4gZG8gdGhhdCBpbiBmdXR1cmUgaXQnbGwgbWFrZSB0
aGUgc2VyaWVzIG11Y2gNCj4gZWFzaWVyDQo+IHRvIHdvcmsgd2l0aC4NCg0KT2suDQoNCi0tIA0K
QWxleA0K
