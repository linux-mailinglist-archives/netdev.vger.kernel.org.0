Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC762CE488
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgLDAjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:39:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728036AbgLDAjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:39:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B40WLGW013588;
        Thu, 3 Dec 2020 16:37:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=mfrl6oY80+ZHCiFgsvy8mweKk++ZqisRcjr9ghDQDx4=;
 b=HE8H2WE13DFSSmSBzoOXhXULvFE9Bu8cTtkKdn6HjGf1eSk7Qnz1x+fEB/B1kgw72uDd
 ZbviJBlrSC3xGw9fl34xf4zA9RiAwyikZkjdEfmjD04Ln5bi3KIEIl4zFfIh/ApfpGd7
 ctfsUSwfZzdwrsFqNVyez0qZKuUnV+FQMWSZOg6ThyX6/I7LgQ0T2a6z/NVkdGFIk0Jr
 VjW43PYV5pRi7auBCmCgV4e2BhgEkph3ZsfZDNu+xRQ6tN7EEaJxkAJrOeuKKCth5+V2
 cXLTbUQf3yhdUqsns2iqMnDikifXyOE/YxgwYOCt52IeJgHBg8PWkHfPJUbiyAgN3usG fg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jfedr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:37:35 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 16:37:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 16:37:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj2c9e1o/tyi8ITtvMxbxqpO22Iw6iqfkXwsosPXrU/d/GJq7660Dg/QphHuTSd9cYRY1CpyKmf8ITrHPdBHyJAMRS56SbwdYjcRwAfIWiaUy8nRO+6TTN1rnjDryk3SUPNSQcEdDBo8UuRx11tM5WBe2PFZsFCaNJtFDMoJeP4dRpFYHs+/U0YqhgQ+BgdOnFZ1r/qxcI5XTsXHcDFqgXoNBrp07bENokl/5Cpr8A0vFrhYvQ9gIfvmgTntGYeJwUw5sdIkgLDbHZ5dT2JsBTtF1lmH4o1JLdGN2YELS9SUjdqzkgpD3lUHDCdZQSOd+jhfJaV099LfAldylYLX7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfrl6oY80+ZHCiFgsvy8mweKk++ZqisRcjr9ghDQDx4=;
 b=YmcM8A81OkZa4fBOoeNgNJOt4+VcuOP/Ws6NA61PSV8MHnXZRTTjJRguO13WUDKfv8UUKgsdQPt8po615/jAo6cXcEx3IoYyFBJ+WMXtRfVFuI+tVl5FSAB0KIffDB9WgdzQfO2NyIFheEqlfkMrs/yBQ+gG6KBVODqnWTOPAGjY4t0ZznZ6QQjYBHiu5Db4+R+pnrc+zX0Z11Kr2DyDqOKv9MxluMYwg32JSrF4PBOY8x9jHUKETB1OV/J/f10roQ37zQAKmxtX5NKxWuce2JbSxURKfeSrLQibrzZo26aHwXlwe9cnv9OVMEz1sKHYvVFqOtkh11KaTQOcln0vIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfrl6oY80+ZHCiFgsvy8mweKk++ZqisRcjr9ghDQDx4=;
 b=W9nIzAb4NWwdrc3g2mEWPQdHzvq5Sc44PLi9K2jviS29DaIMGcObQmIJF2p9SBOBVG/dbwNkj51ENp7YGQ+VBQLETmGLobExi7+8/w0WwsH8ISTF7GVwPM8Ahm7kcpQLUbdzffOrVxgThgOoeNl/j5lHyQiqdAoUsKrswicsOXE=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1824.namprd18.prod.outlook.com (2603:10b6:301:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 00:37:33 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363%6]) with mapi id 15.20.3632.020; Fri, 4 Dec 2020
 00:37:33 +0000
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
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 6/9] task_isolation: arch/arm64: enable task
 isolation functionality
Thread-Topic: [EXT] Re: [PATCH v5 6/9] task_isolation: arch/arm64: enable task
 isolation functionality
Thread-Index: AQHWwcIyUgmIaBCwmkq+zZ19oo0twanj41GAgAJEd4A=
Date:   Fri, 4 Dec 2020 00:37:32 +0000
Message-ID: <9dee82d9f9af4fd8a6b8226f4ed190efeb24d5c5.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <91496c0cf8d24717a2641fc4d02063f3f10dc733.camel@marvell.com>
         <20201202135957.GA66958@C02TD0UTHF1T.local>
In-Reply-To: <20201202135957.GA66958@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cb21319-a948-482f-1be2-08d897ecca2d
x-ms-traffictypediagnostic: MWHPR1801MB1824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB18245B771EAFE0020A1D85AEBCF10@MWHPR1801MB1824.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GKep110p5L2KmbQ7+1SFjP3Y9ixQCvMCZSWO0rw9sIR94NUijrGhAdxYOJyELdogHKE/I5lIspgforvjyAPQzKRPlLedtKYm1T4BKz0rUv7TXtDzfSF7QkQ0247kBLOsaiKF7AxYM/5zQ6zNRefc7tR6QjqerhEs07bT52NTY+YDLUEyRXc+I5k8h8usQ0QdQ2r+pAA7d9W9MuHpGt0kdIPFj/96by5qw94CFJliS3yncrUJ/d7HfPkIh5cV9zY0ZSH2VBk3VVva5jecheTT1Qyvvynw3aHh9NYnPRTtbGKXWpwS4mw1izRr8YRE8CURiRvKFWIX/x3fRVt3r0GR+zGWnC9TSgv+gztqZnjhyCgas2j1z9PPE5kbdmTeUZfCp0LuRjS/TjsjuuBDK+nVHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(66476007)(6506007)(4326008)(966005)(478600001)(71200400001)(8676002)(66556008)(76116006)(6916009)(316002)(66946007)(91956017)(36756003)(64756008)(86362001)(5660300002)(8936002)(6486002)(66446008)(26005)(54906003)(7416002)(6512007)(2906002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S2tweDJUMEIwQWdobmIrWXFxY2hFVEJDc3Y3WVpKd1RRbzg2Ny80T0RzYlhB?=
 =?utf-8?B?VkNsaVZ1cm5qdnpvWTdJTzlxWDJTQzRNckxlZ1RxYXlmSFdPeWI2bFBzVGQ2?=
 =?utf-8?B?bTNGNE9yeWdKRUNOeWxGNmxmZklYWmtsWEd2a3lFdWJLRytRMUl2Y0EzRmkz?=
 =?utf-8?B?RlFzVFBHL2Qvem1sVkN0bUZic3hDRG9XdndQNmExSTlWTDA1YlFhQzVSUGdz?=
 =?utf-8?B?ZlRzNkRCVWxGQ1YxN1l2Y0kyVXlkMktRS1dCSzNrYmpGYjdNSzE2TWxsRHBO?=
 =?utf-8?B?R3pFL055NFdROCs4bTdJM0ZtK0M4bGZiSmhwaVRHb1ovbktqM1FwSFhBN2E2?=
 =?utf-8?B?cUp5K3BRQWEwdDc0Q3hNcW5IVUpSQ3Y2ZkpXTENmSW1rMkN6cUt1VEZKWGk3?=
 =?utf-8?B?RER5M3J2R2VVU2R2elA2eFMzNmVEbW5GT3FKbUFScXlDSHNCYS81TWQ0cFNn?=
 =?utf-8?B?ZjMwbS9BeEswbWZLVEkxWjdBcCtIUnpmdlBUU3RVT1RWNEthd3BWY0ZvMU8z?=
 =?utf-8?B?Szk5bVkraW5nRThQMlR3eXJwbU53MHg4K3pFZmlXTStTdXZzdWhhSHlPellW?=
 =?utf-8?B?UEY3TVJBNWxtTU9nUElCTFFyOGQrZXdIalNqNTlqNGlBWEdWOVNnS0RLOXpp?=
 =?utf-8?B?b056NXphd0FORUpsZnhrUVQzdTZlb3FZanhiMFY2enRHZjh2Ym11L1ZyWjRB?=
 =?utf-8?B?b2paOXdRSE5rUkJ1MzBaTTRJNlR0Q1o4ci95TnBjRnhES2xqMVlaOFZOZldU?=
 =?utf-8?B?TDYyM2NxQ2pZdEthMDljK2dGMFZwcVExR2ZuYTgrWTFQbzd1M2JrRjhpUkFS?=
 =?utf-8?B?eS9aOVVFZVU1Yll1WmxpNzdhNXFYNXZTRDIyRzNBczk1NlNXbGxQTE5NTHBt?=
 =?utf-8?B?S1F6UnBrRkJybUU5cDBQS296aG5NNUdqZ2t0NW11bmpyWTRxL2N3azBNNHZC?=
 =?utf-8?B?WVBobVRJZ0FCa0VobTU0a3RKakZzc2d1elFDT1NESGQxc2lKM0trOE10R1ln?=
 =?utf-8?B?cUp6eUMxM2hsaFpTN2c3S0ZOUTJ1a1pJbkZlc3JBWWdJdktGd2tyeVBZU0NL?=
 =?utf-8?B?bzJhNHR2OWlXeTBzQU94VXBRZjQwa1ROWlh2a00vRjB4ck0rY25kbDR4UEl0?=
 =?utf-8?B?WWlUYWtGWjB3b0VaUTF4bnloYUxNbG5oVjlOWjRlMW4wck1PSWJ1SWJhWERQ?=
 =?utf-8?B?WHpjUjhBZTBTYnB2dlhQbnhoWHR0N3dNL3ZqSWx2WmpOMVV1ckt2ZXJrSWs3?=
 =?utf-8?B?enZoUGZSTEYvcUtyaXYzRzM2OGgrSlUxZGZKZEFyL241emtLNElrSXRpTEo3?=
 =?utf-8?Q?z3ztuBTtyp230Qyc1k/sL+dondnYDvbUVg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15BF3F8E51CFA24FA329976EBC267FB4@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb21319-a948-482f-1be2-08d897ecca2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 00:37:33.1146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0cBIk7BImHUQdJjlcZRlAO/Xl4LVpn1Qn1yfGAw0mUkOKWsgamVGRJe22s98PY7E1GCrY9tbMXlgE1yk84MSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1824
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQsIDIwMjAtMTItMDIgYXQgMTM6NTkgKzAwMDAsIE1hcmsgUnV0bGFuZCB3cm90ZToN
Cj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gLS0tDQo+IEhpIEFsZXgsDQo+
IA0KPiBPbiBNb24sIE5vdiAyMywgMjAyMCBhdCAwNTo1ODowNlBNICswMDAwLCBBbGV4IEJlbGl0
cyB3cm90ZToNCj4gPiBJbiBkb19ub3RpZnlfcmVzdW1lKCksIGNhbGwNCj4gPiB0YXNrX2lzb2xh
dGlvbl9iZWZvcmVfcGVuZGluZ193b3JrX2NoZWNrKCkNCj4gPiBmaXJzdCwgdG8gcmVwb3J0IGlz
b2xhdGlvbiBicmVha2luZywgdGhlbiBhZnRlciBoYW5kbGluZyBhbGwNCj4gPiBwZW5kaW5nDQo+
ID4gd29yaywgY2FsbCB0YXNrX2lzb2xhdGlvbl9zdGFydCgpIGZvciBUSUZfVEFTS19JU09MQVRJ
T04gdGFza3MuDQo+ID4gDQo+ID4gQWRkIF9USUZfVEFTS19JU09MQVRJT04gdG8gX1RJRl9XT1JL
X01BU0ssIGFuZCBfVElGX1NZU0NBTExfV09SSywNCj4gPiBkZWZpbmUgbG9jYWwgTk9USUZZX1JF
U1VNRV9MT09QX0ZMQUdTIHRvIGNoZWNrIGluIHRoZSBsb29wLCBzaW5jZQ0KPiA+IHdlDQo+ID4g
ZG9uJ3QgY2xlYXIgX1RJRl9UQVNLX0lTT0xBVElPTiBpbiB0aGUgbG9vcC4NCj4gPiANCj4gPiBF
YXJseSBrZXJuZWwgZW50cnkgY29kZSBjYWxscyB0YXNrX2lzb2xhdGlvbl9rZXJuZWxfZW50ZXIo
KS4gSW4NCj4gPiBwYXJ0aWN1bGFyOg0KPiA+IA0KPiA+IFZlY3RvcnM6DQo+ID4gZWwxX3N5bmMg
LT4gZWwxX3N5bmNfaGFuZGxlcigpIC0+IHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpDQo+
ID4gZWwxX2lycSAtPiBhc21fbm1pX2VudGVyKCksIGhhbmRsZV9hcmNoX2lycSgpDQo+ID4gZWwx
X2Vycm9yIC0+IGRvX3NlcnJvcigpDQo+ID4gZWwwX3N5bmMgLT4gZWwwX3N5bmNfaGFuZGxlcigp
DQo+ID4gZWwwX2lycSAtPiBoYW5kbGVfYXJjaF9pcnEoKQ0KPiA+IGVsMF9lcnJvciAtPiBkb19z
ZXJyb3IoKQ0KPiA+IGVsMF9zeW5jX2NvbXBhdCAtPiBlbDBfc3luY19jb21wYXRfaGFuZGxlcigp
DQo+ID4gZWwwX2lycV9jb21wYXQgLT4gaGFuZGxlX2FyY2hfaXJxKCkNCj4gPiBlbDBfZXJyb3Jf
Y29tcGF0IC0+IGRvX3NlcnJvcigpDQo+ID4gDQo+ID4gU0RFSSBlbnRyeToNCj4gPiBfX3NkZWlf
YXNtX2hhbmRsZXIgLT4gX19zZGVpX2hhbmRsZXIoKSAtPiBubWlfZW50ZXIoKQ0KPiANCj4gQXMg
YSBoZWFkcy11cCwgdGhlIGFybTY0IGVudHJ5IGNvZGUgaXMgY2hhbmdpbmcsIGFzIHdlIGZvdW5k
IHRoYXQgb3VyDQo+IGxvY2tkZXAsIFJDVSwgYW5kIGNvbnRleHQtdHJhY2tpbmcgbWFuYWdlbWVu
dCB3YXNuJ3QgcXVpdGUgcmlnaHQuIEkNCj4gaGF2ZQ0KPiBhIHNlcmllcyBvZiBwYXRjaGVzOg0K
PiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIwMTEzMDExNTk1MC4yMjQ5Mi0xLW1h
cmsucnV0bGFuZEBhcm0uY29tDQo+IA0KPiAuLi4gd2hpY2ggYXJlIHF1ZXVlZCBpbiB0aGUgYXJt
NjQgZm9yLW5leHQvZml4ZXMgYnJhbmNoLiBJIGludGVuZCB0bw0KPiBoYXZlIHNvbWUgZnVydGhl
ciByZXdvcmsgcmVhZHkgZm9yIHRoZSBuZXh0IGN5Y2xlLg0KDQpUaGFua3MhDQoNCj4gIEknZCBh
cHByZWNpYXRlIGlmIHlvdQ0KPiBjb3VsZCBDYyBtZSBvbiBhbnkgcGF0Y2hlcyBhbHRlcmluZyB0
aGUgYXJtNjQgZW50cnkgY29kZSwgYXMgSSBoYXZlIGENCj4gdmVzdGVkIGludGVyZXN0Lg0KDQpJ
IHdpbGwgZG8gdGhhdC4NCg0KPiANCj4gVGhhdCB3YXMgcXVpdGUgb2J2aW91c2x5IGJyb2tlbiBp
ZiBQUk9WRV9MT0NLSU5HIGFuZCBOT19IWl9GVUxMIHdlcmUNCj4gY2hvc2VuIGFuZCBjb250ZXh0
IHRyYWNraW5nIHdhcyBpbiB1c2UgKGUuZy4gd2l0aA0KPiBDT05URVhUX1RSQUNLSU5HX0ZPUkNF
KSwNCg0KSSBhbSBub3QgeWV0IHN1cmUgYWJvdXQgVFJBQ0VfSVJRRkxBR1MsIGhvd2V2ZXIgTk9f
SFpfRlVMTCBhbmQNCkNPTlRFWFRfVFJBQ0tJTkcgaGF2ZSB0byBiZSBlbmFibGVkIGZvciBpdCB0
byBkbyBhbnl0aGluZy4NCg0KSSB3aWxsIGNoZWNrIGl0IHdpdGggUFJPVkVfTE9DS0lORyBhbmQg
eW91ciBwYXRjaGVzLg0KDQpFbnRyeSBjb2RlIG9ubHkgYWRkcyBhbiBpbmxpbmUgZnVuY3Rpb24g
dGhhdCwgaWYgdGFzayBpc29sYXRpb24gaXMNCmVuYWJsZWQsIHVzZXMgcmF3X2xvY2FsX2lycV9z
YXZlKCkgLyByYXdfbG9jYWxfaXJxX3Jlc3RvcmUoKSwgbG93LWxldmVsIA0Kb3BlcmF0aW9ucyBh
bmQgYWNjZXNzZXMgcGVyLUNQVSB2YXJpYWJsZWQgYnkgb2Zmc2V0LCBzbyBhdCB2ZXJ5IGxlYXN0
DQppdCBzaG91bGQgbm90IGFkZCBhbnkgcHJvYmxlbXMuIEV2ZW4gcmF3X2xvY2FsX2lycV9zYXZl
KCkgLw0KcmF3X2xvY2FsX2lycV9yZXN0b3JlKCkgcHJvYmFibHkgc2hvdWxkIGJlIHJlbW92ZWQs
IGhvd2V2ZXIgSSB3YW50ZWQgdG8NCmhhdmUgc29tZXRoaW5nIHRoYXQgY2FuIGJlIHNhZmVseSBj
YWxsZWQgaWYgYnkgd2hhdGV2ZXIgcmVhc29uDQppbnRlcnJ1cHRzIHdlcmUgZW5hYmxlZCBiZWZv
cmUga2VybmVsIHdhcyBmdWxseSBlbnRlcmVkLg0KDQo+ICBzbyBJJ20gYXNzdW1pbmcgdGhhdCB0
aGlzIHNlcmllcyBoYXMgbm90IGJlZW4NCj4gdGVzdGVkIGluIHRoYXQgY29uZmlndXJhdGlvbi4g
V2hhdCBzb3J0IG9mIHRlc3RpbmcgaGFzIHRoaXMgc2Vlbj8NCj4gDQoNCk9uIHZhcmlvdXMgYXZh
aWxhYmxlIGFybTY0IGhhcmR3YXJlLCB3aXRoIGVuYWJsZWQNCg0KQ09ORklHX1RBU0tfSVNPTEFU
SU9ODQpDT05GSUdfTk9fSFpfRlVMTA0KQ09ORklHX0hJR0hfUkVTX1RJTUVSUw0KDQphbmQgZGlz
YWJsZWQ6DQoNCkNPTkZJR19IWl9QRVJJT0RJQw0KQ09ORklHX05PX0haX0lETEUNCkNPTkZJR19O
T19IWg0KDQo+IEl0IHdvdWxkIGJlIHZlcnkgaGVscGZ1bCBmb3IgdGhlIG5leHQgcG9zdGluZyBp
ZiB5b3UgY291bGQgcHJvdmlkZQ0KPiBhbnkNCj4gaW5zdHJ1Y3Rpb25zIG9uIGhvdyB0byB0ZXN0
IHRoaXMgc2VyaWVzIChlLmcuIHdpdGggcG9pbnRlcnMgdG8gYW55DQo+IHRlc3QNCj4gc3VpdGUg
dGhhdCB5b3UgaGF2ZSksIHNpbmNlIGl0J3MgdmVyeSBlYXN5IHRvIGludHJvZHVjZSBzdWJ0bGUN
Cj4gYnJlYWthZ2UNCj4gaW4gdGhpcyBhcmVhIHdpdGhvdXQgcmVhbGlzaW5nIGl0Lg0KDQpJIHdp
bGwuIEN1cnJlbnRseSBsaWJ0bWMgKCBodHRwczovL2dpdGh1Yi5jb20vYWJlbGl0cy9saWJ0bWMg
KSBjb250YWlucw0KYWxsIHVzZXJzcGFjZSBjb2RlIHVzZWQgZm9yIHRlc3RpbmcsIGhvd2V2ZXIg
SSBzaG91bGQgZG9jdW1lbnQgdGhlDQp0ZXN0aW5nIHByb2NlZHVyZXMuDQoNCj4gDQo+ID4gRnVu
Y3Rpb25zIGNhbGxlZCBmcm9tIHRoZXJlOg0KPiA+IGFzbV9ubWlfZW50ZXIoKSAtPiBubWlfZW50
ZXIoKSAtPiB0YXNrX2lzb2xhdGlvbl9rZXJuZWxfZW50ZXIoKQ0KPiA+IGFzbV9ubWlfZXhpdCgp
IC0+IG5taV9leGl0KCkgLT4gdGFza19pc29sYXRpb25fa2VybmVsX3JldHVybigpDQo+ID4gDQo+
ID4gSGFuZGxlcnM6DQo+ID4gZG9fc2Vycm9yKCkgLT4gbm1pX2VudGVyKCkgLT4gdGFza19pc29s
YXRpb25fa2VybmVsX2VudGVyKCkNCj4gPiAgIG9yIHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRl
cigpDQo+ID4gZWwxX3N5bmNfaGFuZGxlcigpIC0+IHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRl
cigpDQo+ID4gZWwwX3N5bmNfaGFuZGxlcigpIC0+IHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRl
cigpDQo+ID4gZWwwX3N5bmNfY29tcGF0X2hhbmRsZXIoKSAtPiB0YXNrX2lzb2xhdGlvbl9rZXJu
ZWxfZW50ZXIoKQ0KPiA+IA0KPiA+IGhhbmRsZV9hcmNoX2lycSgpIGlzIGlycWNoaXAtc3BlY2lm
aWMsIG1vc3QgY2FsbA0KPiA+IGhhbmRsZV9kb21haW5faXJxKCkNCj4gPiBUaGVyZSBpcyBhIHNl
cGFyYXRlIHBhdGNoIGZvciBpcnFjaGlwcyB0aGF0IGRvIG5vdCBmb2xsb3cgdGhpcw0KPiA+IHJ1
bGUuDQo+ID4gDQo+ID4gaGFuZGxlX2RvbWFpbl9pcnEoKSAtPiB0YXNrX2lzb2xhdGlvbl9rZXJu
ZWxfZW50ZXIoKQ0KPiA+IGRvX2hhbmRsZV9JUEkoKSAtPiB0YXNrX2lzb2xhdGlvbl9rZXJuZWxf
ZW50ZXIoKSAobWF5IGJlIHJlZHVuZGFudCkNCj4gPiBubWlfZW50ZXIoKSAtPiB0YXNrX2lzb2xh
dGlvbl9rZXJuZWxfZW50ZXIoKQ0KPiANCj4gVGhlIElSUSBjYXNlcyBsb29rIHZlcnkgb2RkIHRv
IG1lLiBXaXRoIHRoZSByZXdvcmsgSSd2ZSBqdXN0IGRvbmUgZm9yDQo+IGFybTY0LCB3ZSdsbCBk
byB0aGUgcmVndWxhciBjb250ZXh0IHRyYWNraW5nIGFjY291bnRpbmcgYmVmb3JlIHdlDQo+IGV2
ZXINCj4gZ2V0IGludG8gaGFuZGxlX2RvbWFpbl9pcnEoKSBvciBzaW1pbGFyLCBzbyBJIHN1c3Bl
Y3QgdGhhdCdzIG5vdA0KPiBuZWNlc3NhcnkgYXQgYWxsPw0KDQpUaGUgZ29hbCBpcyB0byBjYWxs
IHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpIGJlZm9yZSBhbnl0aGluZyB0aGF0DQpkZXBl
bmRzIG9uIGEgQ1BVIHN0YXRlLCBpbmNsdWRpbmcgcGlwZWxpbmUsIHRoYXQgY291bGQgcmVtYWlu
IHVuLQ0Kc3luY2hyb25pemVkIHdoZW4gdGhlIHJlc3Qgb2YgdGhlIGtlcm5lbCB3YXMgc2VuZGlu
ZyBzeW5jaHJvbml6YXRpb24NCklQSXMuIFNpbWlsYXJseSB0YXNrX2lzb2xhdGlvbl9rZXJuZWxf
cmV0dXJuKCkgc2hvdWxkIGJlIGNhbGxlZCB3aGVuIGl0DQppcyBzYWZlIHRvIHR1cm4gb2ZmIHN5
bmNocm9uaXphdGlvbi4gSWYgcmV3b3JrIGFsbG93cyBpdCB0byBiZSBkb25lDQplYXJsaWVyLCB0
aGVyZSBpcyBubyBuZWVkIHRvIHRvdWNoIG1vcmUgc3BlY2lmaWMgZnVuY3Rpb25zLg0KDQo+IC0t
LSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vYmFycmllci5oDQo+ID4gKysrIGIvYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9iYXJyaWVyLmgNCj4gPiBAQCAtNDksNiArNDksNyBAQA0KPiA+ICAjZGVm
aW5lIGRtYV9ybWIoKQlkbWIob3NobGQpDQo+ID4gICNkZWZpbmUgZG1hX3dtYigpCWRtYihvc2hz
dCkNCj4gPiAgDQo+ID4gKyNkZWZpbmUgaW5zdHJfc3luYygpCWlzYigpDQo+IA0KPiBJIHRoaW5r
IEkndmUgYXNrZWQgb24gcHJpb3IgdmVyc2lvbnMgb2YgdGhlIHBhdGNoc2V0LCBidXQgd2hhdCBp
cw0KPiB0aGlzDQo+IGZvcj8gV2hlcmUgaXMgaXQgZ29pbmcgdG8gYmUgdXNlZCwgYW5kIHdoYXQg
aXMgdGhlIGV4cGVjdGVkDQo+IHNlbWFudGljcz8NCj4gSSdtIHdhcnkgb2YgZXhwb3NpbmcgdGhp
cyBvdXRzaWRlIG9mIGFyY2ggY29kZSBiZWNhdXNlIHRoZXJlIGFyZW4ndA0KPiBzdHJvbmcgY3Jv
c3MtYXJjaGl0ZWN0dXJhbCBzZW1hbnRpY3MsIGFuZCBhdCB0aGUgbGVhc3QgdGhpcyByZXF1aXJl
cw0KPiBzb21lIGRvY3VtZW50YXRpb24uDQoNClRoaXMgaXMgaW50ZW5kZWQgYXMgYW4gaW5zdHJ1
Y3Rpb24gcGlwZWxpbmUgZmx1c2ggZm9yIHRoZSBzaXR1YXRpb24NCndoZW4gYXJjaC1pbmRlcGVu
ZGVudCBjb2RlIGhhcyB0byBzeW5jaHJvbml6ZSB3aXRoIHBvdGVudGlhbCBjaGFuZ2VzDQp0aGF0
IGl0IG1pc3NlZC4gVGhpcyBpcyBuZWNlc3NhcnkgYWZ0ZXIgc29tZSBvdGhlciBDUFVzIGNvdWxk
IG1vZGlmeQ0KY29kZSAoYW5kIHNlbmQgSVBJcyB0byBub3RpZnkgdGhlIHJlc3QgYnV0IG5vdCBp
c29sYXRlZCBDUFUpIHdoaWxlIHRoaXMNCm9uZSB3YXMgc3RpbGwgcnVubmluZyBpc29sYXRlZCB0
YXNrIG9yLCBtb3JlIGxpa2VseSwgZXhpdGluZyBmcm9tIGl0LA0Kc28gaXQgbWlnaHQgYmUgdW5s
dWNreSBlbm91Z2ggdG8gcGljayB0aGUgb2xkIGluc3RydWN0aW9ucyBiZWZvcmUgdGhhdA0KcG9p
bnQuDQoNCkl0J3Mgb25seSB1c2VkIG9uIGtlcm5lbCBlbnRyeS4NCg0KPiANCj4gSWYgaXQncyB1
bnVzZWQsIHBsZWFzZSBkZWxldGUgaXQuDQo+IA0KPiBbLi4uXQ0KPiANCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rZXJuZWwvZW50cnktY29tbW9uLmMNCj4gPiBiL2FyY2gvYXJtNjQva2Vy
bmVsL2VudHJ5LWNvbW1vbi5jDQo+ID4gaW5kZXggNDNkNGMzMjk3NzVmLi44MTUyNzYwZGU2ODMg
MTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvZW50cnktY29tbW9uLmMNCj4gPiAr
KysgYi9hcmNoL2FybTY0L2tlcm5lbC9lbnRyeS1jb21tb24uYw0KPiA+IEBAIC04LDYgKzgsNyBA
QA0KPiA+ICAjaW5jbHVkZSA8bGludXgvY29udGV4dF90cmFja2luZy5oPg0KPiA+ICAjaW5jbHVk
ZSA8bGludXgvcHRyYWNlLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC90aHJlYWRfaW5mby5oPg0K
PiA+ICsjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQo+ID4gIA0KPiA+ICAjaW5jbHVkZSA8
YXNtL2NwdWZlYXR1cmUuaD4NCj4gPiAgI2luY2x1ZGUgPGFzbS9kYWlmZmxhZ3MuaD4NCj4gPiBA
QCAtNzcsNiArNzgsOCBAQCBhc21saW5rYWdlIHZvaWQgbm90cmFjZSBlbDFfc3luY19oYW5kbGVy
KHN0cnVjdA0KPiA+IHB0X3JlZ3MgKnJlZ3MpDQo+ID4gIHsNCj4gPiAgCXVuc2lnbmVkIGxvbmcg
ZXNyID0gcmVhZF9zeXNyZWcoZXNyX2VsMSk7DQo+ID4gIA0KPiA+ICsJdGFza19pc29sYXRpb25f
a2VybmVsX2VudGVyKCk7DQo+IA0KPiBGb3IgcmVndWxhciBjb250ZXh0IHRyYWNraW5nIHdlIG9u
bHkgYWNvdW50IHRoZSB1c2VyPC0+a2VybmVsDQo+IHRyYW5zaXRpb25zLg0KPiANCj4gVGhpcyBp
cyBhIGtlcm5lbC0+a2VybmVsIHRyYW5zaXRpb24sIHNvIHN1cmVseSB0aGlzIGlzIG5vdCBuZWNl
c3Nhcnk/DQoNClJpZ2h0LiBJZiB3ZSBlbnRlcmVkIGtlcm5lbCBmcm9tIGFuIGlzb2xhdGVkIHRh
c2ssIHdlIGhhdmUgYWxyZWFkeQ0KY2hhbmdlZCB0aGUgZmxhZ3MuDQoNCj4gDQo+IElmIG5vdGhp
bmcgZWxzZSwgaXQgZG9lc24ndCBmZWVsIHdlbGwtYmFsYW5jZWQuDQo+IA0KPiBJIGhhdndlIG5v
dCBsb29rZWQgYXQgdGhlIHJlc3Qgb2YgdGhpcyBwYXRjaCAob3Igc2VyaWVzKSBpbiBkZXRhaWwu
DQo+IA0KPiBUaGFua3MsDQo+IE1hcmsuDQoNCk15IGdvYWwgd2FzIHRvIG1ha2Ugc3VyZSB0aGF0
IGFsbCB0cmFuc2l0aW9ucyBiZXR3ZWVuIGtlcm5lbCBhbmQNCnVzZXJzcGFjZSBhcmUgY292ZXJl
ZCwgc28gd2hlbiBpbiBkb3VidCBJIGhhdmUgYWRkZWQgY29ycmVzcG9uZGluZw0KY2FsbHMgdGhv
c2UgaW5saW5lIGZ1bmN0aW9ucywgYW5kIG1hZGUgdGhlbSBzYWZlIHRvIGJlIGNhbGxlZCBmcm9t
DQp0aG9zZSBwbGFjZXMuIFdpdGggaW1wcm92ZWQgZW50cnktZXhpdCBjb2RlIGl0IHNob3VsZCBi
ZSBlYXNpZXIgdG8gYmUNCnN1cmUgd2hlcmUgdGhpcyBjYW4gYmUgZG9uZSBpbiBhIGNsZWFuZXIg
d2F5Lg0KDQotLSANCkFsZXgNCg==
