Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC77622B353
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgGWQUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:20:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726632AbgGWQUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 12:20:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NG17jQ029257;
        Thu, 23 Jul 2020 09:19:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=uYkymn3qu6S/owdLk0LARi4PWvdDC1KxzOnIzpf/Oso=;
 b=ZkAZ9sVddT5rJdO8qY/IXVuQyiogSousqmwCq5kmXLFiAg0f0j0SSRVyhmsyeQW08wVU
 j0JEv3AUgCJB/606Tm9guXSRuK9bIzJ42jphXwIncyC1ddfXawNFZfzuSHRKa6kWL9eX
 oCimxNJSx9Ax9cKo6WnofR8KEPLGalTVZYCIidCsuOT67Xwe1C2NB3TtxOrapUiF13aZ
 Q0oEpyjcZC2ocsSXSPImuZQoct1b2LM9AJumuOYWggWKfkgbdkCJTvqBo1DZiSPlcV6i
 B0Fy8FF6k+Ql5YF01Oncy+ZDhVWFTE4r9eAD12zxm1EDxlvM/3GRusNvcYVwCtlNzDmY UA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenxm97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 09:19:18 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jul
 2020 09:19:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 23 Jul 2020 09:19:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlT71cg2vBmAUP97wTM2xxTlPbOPhMoi8QDmNFLqfSkKfNpJ7w9626nDv4CUHjCdSdDfEe+b+BqQN1aqBoqB6KuDzGenjIRalOt2RcwMeu5ahj5UcWAJ2nsISHFnC2nTrLKRbsBuwRPrsWMstdRSHbVUXSA+aB/Qv6AOMmlpeQMHvNalruvfwi9buA+shztRYX+9n9M5p+E+qQNhPd0n7QsYQ4RxJq8PlL8NM+/4wOtFhTCb/6Zzzs+AnHeOY3XiR1w4KE2jDGa8X81Z3QDMDqJV6/oxJV/jJSN+XTMVLI1fUc+RzfAtnSVoWwg07GyDklmGnXWVBRYrHqdWkV4s/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYkymn3qu6S/owdLk0LARi4PWvdDC1KxzOnIzpf/Oso=;
 b=T3BujDcVN/9v60uPVD10CCV+daA4l8pR1bjO9OYlqi3nOWa7XuM0q6zfOmSiOKNX+hCvAS2reKrnaM+TXNWHZyH61nt01l7orV28wb0BYxxawpwXj2AgrUUa61FdlXamnWn0nY0H2gsNgGjZVISIpsVNSLx5jV+AT3VtVYIieBbZVsWgn0ew98vZv0e7EtHah6KJhaf9zaB4R7VBIXa6f50qHy3l9xj9c3YqZVscuIQ05k3s6RbMVr+/xF7I2D2E7MDEYRJXtq4lS9wqlnjxlh8VnUT4nkxsDAUB5JC3lAW8it0LJnL5Jxnb3f+tv7PzD80rf5O3Z2wXmn4p9QYH9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYkymn3qu6S/owdLk0LARi4PWvdDC1KxzOnIzpf/Oso=;
 b=W9E8uNEYVcVcPw1XEkZFL2C/JYpjC631bl6gvuoAFqbSGqNC4V8i098iEYryXkXp2cnqtpAWL5clnLR/Gm9BwM2+t1Vul1lDoaljCk6Um3queWXY0XK2uki20ieLjysTyTDA3yuVfRN3od5prHS6ZpP0WHZlKwGmjGUb0wEyTbU=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR18MB1280.namprd18.prod.outlook.com (2603:10b6:320:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 23 Jul
 2020 16:19:16 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Thu, 23 Jul 2020
 16:19:16 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 00/13] "Task_isolation" mode
Thread-Topic: [EXT] Re: [PATCH v4 00/13] "Task_isolation" mode
Thread-Index: AQHWYDagTVb+dYV8A0GKqxFlnWyBeKkVJq8AgAAUHACAABRRgIAAAdcAgAAIo4A=
Date:   Thu, 23 Jul 2020 16:19:16 +0000
Message-ID: <c326dd17cab3a43e3e500636005e14b9c315d6cf.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <87imeextf3.fsf@nanos.tec.linutronix.de>
         <20200723142902.GT5523@worktop.programming.kicks-ass.net>
         <670609a91be23ebb4f179850601439fbed844479.camel@marvell.com>
         <20200723154820.GA709@worktop.programming.kicks-ass.net>
In-Reply-To: <20200723154820.GA709@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8120efc5-50c8-46ab-9e84-08d82f242537
x-ms-traffictypediagnostic: MWHPR18MB1280:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1280ECBE386724FABD9AFB2CBC760@MWHPR18MB1280.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 07SHaaHQLZj7nTr+hgLGEpe2ksumNDh/+hHleUAwCLNEEDAMVJhDVx7IyN0nbaHdBpKU8vQ5LGo9G8lFsZMvQLf05UVA/YqMRT+5bvO309u0ABZ52F70LJIUegSFd9s9qLbprD9TgST1PGuKOnSW0RKWR33YRS2t9DWgA0X14ahxDJqMBWk1Q78lpdxwcUOVtNNDKl+e1BiLFAMSwKTkKsXjD2TFYPhOgN9HjV0Q6U0zzM5YzXaeOOZRwGzEVurCfFQ9uCk1Up6jTqCnLUC7orL0gL/bWGnJTXjxJsMNefj4az5nHr0IFObujCgQGaDYlQFb2IK4ihdAN0uQ+JLsavKa4/rlZgrYECBQExPvM7D79k5psxpBfwdErMaannfXT4+NAut+ehsW1CuSMBnMDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(36756003)(71200400001)(6506007)(86362001)(2616005)(5660300002)(478600001)(4326008)(186003)(8936002)(26005)(6512007)(316002)(2906002)(966005)(76116006)(91956017)(110136005)(66476007)(8676002)(64756008)(66946007)(66556008)(66446008)(7416002)(6486002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3aWNYXg+NScx88KvPK9O4oFYRIoGKL8K24J/OBMWaRk/9Zqv1UJKwKt1YgYzyFndvOZZ7+wTxtDBc9sABVvbXrpSa57SpTTb1Xe7m8i/d+9tKli3P8ceWYWgx5LUbGAci9phuInxz61U3If1emdFNhPP7htNehk9F5Is79xmnmPVfJNsDaLjTPI6jXw3GEU2koxReTktc1QmO9p5fNSIE6E/z6W8gtju+MytmiQSPwCJ2HpyfOim5yzb1gZCBHinCEU/kKyuS1PImi4ULWlsnMzkN6Trjdn8sRanMMmIfVaUB9aLL19IB2sWK5NQbgPup6rOdHTNdbMIu8egKTbMu0f0kYYpP+lMaLr4lV4xNeVjozN3CMjkzPyHzm/9JM63eQDdnoJK/QPdu8HUBh0aol1+FzdCnFwzxPwNkCtazC1IMb6zlFBslymWuesPnXLe+ntnYe8vomXkYbxuoJpJP7Fv9guuHH0r244i0iz3Jcg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA32F048CCD89743A1D51F632B9A7DED@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8120efc5-50c8-46ab-9e84-08d82f242537
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 16:19:16.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sQCOOmPTvu0fo/Gm88jKW1BJXocO9HXQTvozGznE87Mb8hzCZ7d+kxvt7ep+1KnL0nqMqTvIOi7Haa/7YMFGDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1280
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMDctMjMgYXQgMTc6NDggKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3Rl
Og0KPiBPbiBUaHUsIEp1bCAyMywgMjAyMCBhdCAwMzo0MTo0NlBNICswMDAwLCBBbGV4IEJlbGl0
cyB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjAtMDctMjMgYXQgMTY6MjkgKzAyMDAsIFBldGVyIFpp
amxzdHJhIHdyb3RlOg0KPiA+ID4gLg0KPiA+ID4gDQo+ID4gPiBUaGlzLi4gYXMgcHJlc2VudGVk
IGl0IGlzIGFuIGFic29sdXRlbHkgdW5yZXZpZXdhYmxlIHBpbGUgb2YNCj4gPiA+IGp1bmsuIEl0
DQo+ID4gPiBwcmVzZW50cyBjb2RlIHdpdG91dCBhbnkgY29oZXJlbnQgcHJvYmxlbSBkZXNjcmlw
dGlvbiBhbmQNCj4gPiA+IGFuYWx5c2lzLg0KPiA+ID4gQW5kDQo+ID4gPiB0aGUgcGF0Y2hlcyBh
cmUgbm90IHNwbGl0IHNhbmVseSBlaXRoZXIuDQo+ID4gDQo+ID4gVGhlcmUgaXMgYSBtb3JlIGNv
bXBsZXRlIGFuZCBzbGlnaHRseSBvdXRkYXRlZCBkZXNjcmlwdGlvbiBpbiB0aGUNCj4gPiBwcmV2
aW91cyB2ZXJzaW9uIG9mIHRoZSBwYXRjaCBhdCANCj4gPiBodHRwczovL3VybGRlZmVuc2UucHJv
b2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xvcmUua2VybmVsLm9yZ19sa21sXzA3YzI1
YzI0NmM1NTAxMjk4MWVjMDI5NmVlZTIzZTY4YzcxOTMzM2EuY2FtZWwtNDBtYXJ2ZWxsLmNvbV8m
ZD1Ed0lCQWcmYz1uS2pXZWMyYjZSMG1PeVBhejd4dGZRJnI9MXFndk9uWGZrM1pISkEzcDdSSWI2
TkZxczRTUFBEeVBJX1Bjd05GcDhLWSZtPXNoazlhNUZEd2t0T1p5c1NiRklqeG1nVWctSVB5dzJV
a2JWQUhHQmhOVjAmcz1GRlphai1LYW53cUVpWFlDZGpkOTZKT2dQX0dBT25hbnBrdzZiQnZOcks0
JmU9IA0KPiANCj4gTm90IHRoZSBwb2ludCwgeW91J3JlIG1peGluZyBmYXIgdG9vIG1hbnkgdGhp
bmdzIGluIG9uZSBnby4gWW91IGFsc28NCj4gaGF2ZSB0aGUgcGF0Y2hlcyBzcGxpdCBsaWtlICdn
ZW5lcmljIC8gYXJjaC0xIC8gYXJjaC0yJyB3aGljaCBpcw0KPiB3cm9uZw0KPiBwZXIgZGVmaW5p
dGlvbiwgYXMgcGF0Y2hlcyBzaG91bGQgYmUgc3BsaXQgcGVyIGNoYW5nZSBhbmQgbm90IGNhcmUN
Cj4gYWJvdXQNCj4gc2lseSBib3VuZGFyaWVzLg0KDQpUaGlzIGZvbGxvd3MgdGhlIG9yaWdpbmFs
IHBhdGNoIGJ5IENocmlzIE1ldGNhbGYuIFRoZXJlIGlzIGEgcmVhc29uIGZvcg0KdGhhdCAtLSBw
ZXItYXJjaGl0ZWN0dXJlIGNoYW5nZXMgYXJlIGluZGVwZW5kZW50IGZyb20gZWFjaCBvdGhlciBh
bmQNCmFmZmVjdCBub3QganVzdCBjb2RlIGJ1dCBmdW5jdGlvbmFsaXR5IHRoYXQgd2FzIGltcGxl
bWVudGVkIHBlci0NCmFyY2hpdGVjdHVyZS4gVG8gc3VwcG9ydCBtb3JlIGFyY2hpdGVjdHVyZXMs
IGl0IHdpbGwgYmUgbmVjZXNzYXJ5IHRvIGRvDQppdCBzZXBhcmF0ZWx5IGZvciBlYWNoLCBhbmQg
bWFyayB0aGVtIHN1cHBvcnRlZCB3aXRoDQpIQVZFX0FSQ0hfVEFTS19JU09MQVRJT04uIEhhdmlu
ZyBvbmx5IHNvbWUgYXJjaGl0ZWN0dXJlcyBzdXBwb3J0ZWQgZG9lcw0Kbm90IGJyZWFrIGFueXRo
aW5nIGZvciB0aGUgcmVzdCAtLSBhcmNoaXRlY3R1cmVzIHRoYXQgYXJlIG5vdCBjb3ZlcmVkLA0K
d291bGQgbm90IGhhdmUgdGhpcyBmdW5jdGlvbmFsaXR5Lg0KDQo+IA0KPiBBbHNvLCBpZiB5b3Ug
d2FudCBnZW5lcmljIGVudHJ5IGNvZGUsIHRoZXJlJ3MgcGF0Y2hlcyBmb3IgdGhhdCBoZXJlOg0K
PiANCj4gICANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0
dHBzLTNBX19sa21sLmtlcm5lbC5vcmdfcl8yMDIwMDcyMjIxNTk1NC40NjQyODE5MzAtNDBsaW51
dHJvbml4LmRlJmQ9RHdJQkFnJmM9bktqV2VjMmI2UjBtT3lQYXo3eHRmUSZyPTFxZ3ZPblhmazNa
SEpBM3A3UkliNk5GcXM0U1BQRHlQSV9QY3dORnA4S1kmbT1zaGs5YTVGRHdrdE9aeXNTYkZJanht
Z1VnLUlQeXcyVWtiVkFIR0JoTlYwJnM9blpYSXZpWTdydmEzMUt2UGdTVm5UYWN3Rk5ic21rZFcw
THhTVGZZU2lxZyZlPQ0KPiAgDQo+IA0KPiANCg0KVGhhdCBsb29rcyB1c2VmdWwuIFdoeSBkaWRu
J3QgVGhvbWFzIEdsZWl4bmVyIG1lbnRpb24gaXQgaW4gaGlzDQpjcml0aWNpc20gb2YgbXkgYXBw
cm9hY2ggaWYgaGUgYWxyZWFkeSBzb2x2ZWQgdGhhdCBleGFjdCBwcm9ibGVtLCBhdA0KbGVhc3Qg
Zm9yIHg4Nj8NCg0KLS0gDQpBbGV4DQo=
