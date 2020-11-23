Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D7E2C1881
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgKWWft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:35:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12598 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728693AbgKWWft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:35:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANMZ43I006260;
        Mon, 23 Nov 2020 14:35:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=FltfOxyfQCCW74Va6hnp+4W2QwwfgI9c9opVOpNeFk8=;
 b=Yp8F5fGahNIZHxGJg2fBjdsYvpeTz4BZXbFnLoV5ybQNq86O7mGdVb1X8wEbZVzpejSf
 ZWsXch6apVeNhxcBSsYCU2mxS3WuGeU7jG0PYD7yhl/grkatWJpRwHxbeRrvZBvpT+7V
 94oQ8G9KSCkMlffy7MngYrOk59COreJ3w41bPMssnsrAqzVEQX4YKIVH+mpNHmBbIq0F
 t1gAOxqbFxn7aD1kdelF5xK5Gn1wbqotrxw9U2FEqfrhH3ZTFv/iTtvH5bEBbyom/tpV
 v1e2GIGmvZ1DFIZcO1Qh+s/IhjRiwb2yD6ciFgYFM/CbRG/Apk+6qrbY7ioHNbnf1G3D Eg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r7dv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:35:04 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 14:35:02 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 14:35:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVcRp5x0rlXpsBx1zz+rziDwK/sKnrwcCuGmTluu6ILb/AuKUFA2XSrsEjgwrGaf8E77Wda5TxCyHWjKEj6np/NxeQwQNUrokYfu1DDwSlwn9UaNkiBjUZ3vulznCjQT1CVpf1txw+68uumoRVzb23E/hU/MX6TiSqLIVxlL/TtEcbFVZ8ensBFdMzoVM/LyIVgnO56o/L0IwemURPJkUDLQHjP08uW4hzszaZcI8qMpN/mC4pN5UFgBo+ACjt4au/glEi8qMUKVJN2SsIjaecx4MVgjIjRUrV9dZ9YPn3RCQ8H52zIZSATUnD9350yN3EToVP+73n0/b77FH0v2pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FltfOxyfQCCW74Va6hnp+4W2QwwfgI9c9opVOpNeFk8=;
 b=d0DRO4PUeTcmwjJmZ3woS+EjbDLpe3U6Sk65OFEI1bSELJQeHCtLkwM8akFFyCyJ36q6cSSjK5OpKM6mXAzFWyqyIRYqbPsBoawBl5mP0vvlJyGw4W+2+TPs+5N8gTpz1ouU4zz+Bk5kSCw9bVsdUbK7cTMTxhGDiUP/J5S8TGRei6IE4aGg4Xn31qyuIJD2+mB4yBCytQm8SGzxN1zj1LU8tnuMsFKR0ssXwCCVRu1WvsK2w6HVN0dlPRHBfnFDGauBmiL66UU2R236MLmWzP1fWipqbOQI9gbmQgvAeCS4f95/vmVftpn9U1B93iC7IFn7+MqrM+MFFaHI2YC34A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FltfOxyfQCCW74Va6hnp+4W2QwwfgI9c9opVOpNeFk8=;
 b=cJ+a9PcTTHBsp5mNBrPJ1wcOcYjkEgZh00N41MCqe7wux5wsrKttpqBa7JvnOPh4MkukYsGcqAmO1jXdvBAQrEM+LhAt1f5Cf8IhmMV52jPlWQXeKJQyEA4Xfn/E/hC7bbfi//j3h7xGshUR4koWjTUH2obE5UVdAE+r7YKGAoQ=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by CO6PR18MB4052.namprd18.prod.outlook.com (2603:10b6:5:34a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 22:35:01 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 22:35:01 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>
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
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 7/9] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Topic: [PATCH v5 7/9] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Index: AQHWwejhJlApE01BIU2RlahAgN9o7A==
Date:   Mon, 23 Nov 2020 22:35:01 +0000
Message-ID: <f30e373ec3b4adc667dcae4d3da6ff9a18283979.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <76ed0b222d2f16fb5aebd144ac0222a7f3b87fa1.camel@marvell.com>
         <20201123221336.GB1751@lothringen>
In-Reply-To: <20201123221336.GB1751@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbcc4518-e581-41e1-8dc1-08d890000420
x-ms-traffictypediagnostic: CO6PR18MB4052:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB4052148CFA2B833FAC1AD949BCFC0@CO6PR18MB4052.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jMxEmJ5FqyNhO0/TRlkyNaJ3kBWW4AryyDo/XdDgdPx+DWf6YVzcCKAt/8bw4bdqXYw3yeZMK3dq3QniucPgeqvuZ7pxIxil/n/AUxDVmsreYarcMS0ui40NmEFM4miWuQ7rytUCoVKdruCl/MOr9bbVO/L3DImxPPQr5clDJ57xuF0YD7HhYbjddAsJpX5UMF5HdjPigW+16DOrYDn2LW4SFQoUEAPKnRnWELMq78+CqdrCz4ZA8Yxqrh3ap8angfVxJDOfd9pZWl0mJnQ79dflni0MzY3BDmo2Eps5nFJp5w7LiIvFk64Mb7yQSDd3mSdXTewNy5mGADH5FAAqDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(91956017)(6506007)(76116006)(316002)(83380400001)(86362001)(36756003)(2616005)(26005)(54906003)(7416002)(2906002)(186003)(71200400001)(4326008)(478600001)(8936002)(6916009)(8676002)(5660300002)(6512007)(66446008)(66946007)(66556008)(4001150100001)(66476007)(64756008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jTri6gqhZ4rwKwYXFZySaTwatfKgg8nD/MBnOUAqvl8NMnPahGaYo5Y/9iI7bjgGqZwdNDWCaSNJ50Ku1Xy4/SA83udq0sNdjmncO06xTbNbtQ8XOkte6ulf6qL05oz8wzxQCckmZP6HhVruCrbItPsd4ur3qF1ARTSL8VaMMRu0Iuyi5WSBnP1s6ejlYQrAm+e6Ek0qXFGUT1fs7nvDkst1TFKRJcMvS4wN2fg7/h0G35ooY9Z9esKXW2UlDtT/7TXD+R3M/9seniYGk28FpMVSr+czFOsLzlbzN8UdtIkursNx9SdKkVhqTnswUF7+3k6kX+XpVmSJUZkQ75JG9W6ESReEWwxipsddGr5vei9awLsOYN3NuKPdX8ZFSxjCEhHFNcEREEIQS/vqmwvN5dzIDx2SeTQdTCnx55ywXWdZOdD1tLZI+WppK5ZSHtlyTPDiGX6xXj9ECOlLW9NoIYTwqMpwAfMADNl5bRNdBGAdihhjdF3g4kf7xzsJ5RwQLxSTd6jr4RhQhjKNkUIZ7fBDFOrLZdXuejvzfLfL1T9VM1SQ6hZw2GYFzI+A4Nrid5Q/InfWMi662GByPyfbgkKfJQ9pG8xXhB5illJPWVi9niRXGx9HyOq/kh2Xgwe1WRxbfQK6jyz6EZVw9s2fwioUv0dNImS8xCmt1koFaPNcDccxQGISWUVroCLz7UoRrrYgchzIrC3djiGE7zy8FwZuXF2qeOkDFg6QMZqhuojrH5MWRRc1Cb9fQeRfXIcHOf8XALMvK4HoquA/cbn1ul/y2Y/lE6Ir+ieRDlOoFuMqAAyPQpzN7+Efd42TFoll6SsABn1QlcAQqJC+ZKCa49U/kr2KV45VG57rHWWR724xUoYM078Fb/tvpT3NFEDaDjocQ9ZZyU1CICov/UxR+Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <331BF2DE0E087745A23E25C258E0CD06@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcc4518-e581-41e1-8dc1-08d890000420
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 22:35:01.5018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8gmhv7qNkFSrGZxtoIcnls+1Ht+HtS6YJOFy48c6gX2F0muNiXJwLOXjY53CxRqOYIlIw43bAM3T6LsMXoJx3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4052
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBNb24sIDIwMjAtMTEtMjMgYXQgMjM6MTMgKzAxMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLQ0KPiBIaSBB
bGV4LA0KPiANCj4gT24gTW9uLCBOb3YgMjMsIDIwMjAgYXQgMDU6NTg6MjJQTSArMDAwMCwgQWxl
eCBCZWxpdHMgd3JvdGU6DQo+ID4gRnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29t
Pg0KPiA+IA0KPiA+IEZvciBub2h6X2Z1bGwgQ1BVcyB0aGUgZGVzaXJhYmxlIGJlaGF2aW9yIGlz
IHRvIHJlY2VpdmUgaW50ZXJydXB0cw0KPiA+IGdlbmVyYXRlZCBieSB0aWNrX25vaHpfZnVsbF9r
aWNrX2NwdSgpLiBCdXQgZm9yIGhhcmQgaXNvbGF0aW9uIGl0J3MNCj4gPiBvYnZpb3VzbHkgbm90
IGRlc2lyYWJsZSBiZWNhdXNlIGl0IGJyZWFrcyBpc29sYXRpb24uDQo+ID4gDQo+ID4gVGhpcyBw
YXRjaCBhZGRzIGNoZWNrIGZvciBpdC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBZdXJpIE5v
cm92IDx5bm9yb3ZAbWFydmVsbC5jb20+DQo+ID4gW2FiZWxpdHNAbWFydmVsbC5jb206IHVwZGF0
ZWQsIG9ubHkgZXhjbHVkZSBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQNCj4gPiB0YXNrc10NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCj4gPiAtLS0N
Cj4gPiAga2VybmVsL3RpbWUvdGljay1zY2hlZC5jIHwgNCArKystDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0
IGEva2VybmVsL3RpbWUvdGljay1zY2hlZC5jIGIva2VybmVsL3RpbWUvdGljay1zY2hlZC5jDQo+
ID4gaW5kZXggYTIxMzk1MjU0MWRiLi42Yzg2NzllMjAwZjAgMTAwNjQ0DQo+ID4gLS0tIGEva2Vy
bmVsL3RpbWUvdGljay1zY2hlZC5jDQo+ID4gKysrIGIva2VybmVsL3RpbWUvdGljay1zY2hlZC5j
DQo+ID4gQEAgLTIwLDYgKzIwLDcgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3NjaGVkL2Nsb2Nr
Lmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9zY2hlZC9zdGF0Lmg+DQo+ID4gICNpbmNsdWRlIDxs
aW51eC9zY2hlZC9ub2h6Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9pc29sYXRpb24uaD4NCj4g
PiAgI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvaXJxX3dv
cmsuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3Bvc2l4LXRpbWVycy5oPg0KPiA+IEBAIC0yNjgs
NyArMjY5LDggQEAgc3RhdGljIHZvaWQgdGlja19ub2h6X2Z1bGxfa2ljayh2b2lkKQ0KPiA+ICAg
Ki8NCj4gPiAgdm9pZCB0aWNrX25vaHpfZnVsbF9raWNrX2NwdShpbnQgY3B1KQ0KPiA+ICB7DQo+
ID4gLQlpZiAoIXRpY2tfbm9oel9mdWxsX2NwdShjcHUpKQ0KPiA+ICsJc21wX3JtYigpOw0KPiA+
ICsJaWYgKCF0aWNrX25vaHpfZnVsbF9jcHUoY3B1KSB8fCB0YXNrX2lzb2xhdGlvbl9vbl9jcHUo
Y3B1KSkNCj4gPiAgCQlyZXR1cm47DQo+IA0KPiBMaWtlIEkgc2FpZCBpbiBzdWJzZXF1ZW50IHJl
dmlld3MsIHdlIGFyZSBub3QgZ29pbmcgdG8gaWdub3JlIElQSXMuDQo+IFdlIG11c3QgZml4IHRo
ZSBzb3VyY2VzIG9mIHRoZXNlIElQSXMgaW5zdGVhZC4NCg0KVGhpcyBpcyB3aGF0IEkgYW0gd29y
a2luZyBvbiByaWdodCBub3cuIFRoaXMgaXMgbWFkZSB3aXRoIGFuIGFzc3VtcHRpb24NCnRoYXQg
Q1BVIHJ1bm5pbmcgaXNvbGF0ZWQgdGFzayBoYXMgbm8gcmVhc29uIHRvIGJlIGtpY2tlZCBiZWNh
dXNlDQpub3RoaW5nIGVsc2UgaXMgc3VwcG9zZWQgdG8gYmUgdGhlcmUuIFVzdWFsbHkgdGhpcyBp
cyB0cnVlIGFuZCB3aGVuIG5vdA0KdHJ1ZSBpcyBzdGlsbCBzYWZlIHdoZW4gZXZlcnl0aGluZyBl
bHNlIGlzIGJlaGF2aW5nIHJpZ2h0LiBGb3IgdGhpcw0KdmVyc2lvbiBJIGhhdmUga2VwdCB0aGUg
b3JpZ2luYWwgaW1wbGVtZW50YXRpb24gd2l0aCBtaW5pbWFsIGNoYW5nZXMgdG8NCm1ha2UgaXQg
cG9zc2libGUgdG8gdXNlIHRhc2sgaXNvbGF0aW9uIGF0IGFsbC4NCg0KSSBhZ3JlZSB0aGF0IGl0
J3MgYSBtdWNoIGJldHRlciBpZGVhIGlzIHRvIGRldGVybWluZSBpZiB0aGUgQ1BVIHNob3VsZA0K
YmUga2lja2VkLiBJZiBpdCByZWFsbHkgc2hvdWxkLCB0aGF0IHdpbGwgYmUgYSBsZWdpdGltYXRl
IGNhdXNlIHRvDQpicmVhayBpc29sYXRpb24gdGhlcmUsIGJlY2F1c2UgQ1BVIHJ1bm5pbmcgaXNv
bGF0ZWQgdGFzayBoYXMgbm8NCmxlZ2l0aW1hdGUgcmVhc29uIHRvIGhhdmUgdGltZXJzIHJ1bm5p
bmcuIFJpZ2h0IG5vdyBJIGFtIHRyeWluZyB0bw0KZGV0ZXJtaW5lIHRoZSBvcmlnaW4gb2YgdGlt
ZXJzIHRoYXQgX3N0aWxsXyBzaG93IHVwIGFzIHJ1bm5pbmcgaW4gdGhlDQpjdXJyZW50IGtlcm5l
bCB2ZXJzaW9uLCBzbyBJIHRoaW5rLCB0aGlzIGlzIGEgcmF0aGVyIGxhcmdlIGNodW5rIG9mDQp3
b3JrIHRoYXQgSSBoYXZlIHRvIGRvIHNlcGFyYXRlbHkuDQoNCi0tIA0KQWxleA0K
