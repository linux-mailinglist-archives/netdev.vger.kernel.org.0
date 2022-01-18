Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1C492FA5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244670AbiARUqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:46:01 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:25955 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234217AbiARUqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:46:00 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBseTn030788;
        Tue, 18 Jan 2022 15:45:33 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2051.outbound.protection.outlook.com [104.47.61.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0quh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 15:45:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAqfi1MdtSsRhYQk5M9pm5SC+ZEXDdqgy+VDK1VBwrs7dflcwlwkKukTRW3qZrjc/UwnCo7hKPV4/L3I6DT+9AJvoKWktQKbZsb1f2LafPoHNrzPxKWQsFhbaSwFU5whntUpeWkPa64TsCrxHBFEA8cjZTRuJuV4V/rV3nEjWc2kNIw14kfCW+tihHz8iWL7CzJID456VbXfvmZDJg0+EMy5t24VRwBL09QpvEtOwzRwi2g3vZCSyGGzZx90OCRe0v8Fg/5tijkjQnGo2I2OJivjZZvLqWjmv4wr5GdkIVEZPbUJ25fEgo+UOkdiVi1UqNN8axZyyaOMTUVbTG1w0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1L4U4HQupA10pI83PwOMuqIgXa74c9haJXY1IksFKw=;
 b=HuGwhoT/tckgT7/ADYbW/ib4TpzezTqEtYx2fVNlwarXwkxdrM7wf7oFz+s6xR/eARQ2L35tTkUMBS6pPear2d8H2Voavgr0UxiLv2YFaVnZxwwGnGYfc+AKmlJU40rUPU013uKE9Jr0Ov0YKQnLDBOKU++swLBnsJFxbYIaBCPC70zuMv/CAxDmzUuWnHcNXAV19sbz/JCaUhK7c+eljy+no2JnGVSYPns8KU/xc/DgjH1e0TG+dGiy+C0NE1C1Y71U2e0hRWrRihv7qBFwKu/3lxwI5yxZnT/j8GMzVD9LAKQ1lAsj8qEals3JrscdOc4lSwtiG8oRYxg1CN/E9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1L4U4HQupA10pI83PwOMuqIgXa74c9haJXY1IksFKw=;
 b=g96JDHdgtYXIC9qpqsHwXth8mb3bPex0eVhR+C6lrZdPQiE3mSr/fhSabK7kNhSUhMiihvlpEil4EqCJNr6h9v6LQCu0KK7wfpFO/MEGDXSiQaDNGk1e8wXYMh5p9qqXCjwdcRIqJCro+ARtEplSRGWZe5p8E4JxHgkJPWHsKOM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB1604.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 20:45:31 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 20:45:31 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH net v2 0/9] Xilinx axienet fixes
Thread-Topic: [PATCH net v2 0/9] Xilinx axienet fixes
Thread-Index: AQHYB9sgUWF+MmvI00+a3NTtxrZpe6xpSPIA
Date:   Tue, 18 Jan 2022 20:45:31 +0000
Message-ID: <5a5b1c7d58b81b2a6ab738650964ea7a1c2cf99b.camel@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 896b9373-acbf-4a2a-52fd-08d9dac377f0
x-ms-traffictypediagnostic: YQBPR0101MB1604:EE_
x-microsoft-antispam-prvs: <YQBPR0101MB16047560BF3DE07B14B9D4B5EC589@YQBPR0101MB1604.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VeK9W5NogiRYB1i46MOuAxhfUV3ZxNX2/J9NuUnpf6i4aOlVfwo1czpTN2ALUWLapd0RAhg58IOlM/IvJQp4YSZVMrbpIOb9PDlfsP6m1Q5V4FD8H3+8w7WYFL1p3Lv2NgA3A7k3bvTflMqJI7xIWYi7YaMYVS+0S77Appy6spEgVEqxZruXZIOqy/L7oDhvNgBZIlBl1gwRyjpAXdvpVPQfiI1zWFfhya8E2Eaqn/mAQPs5AdkKqV18DMh8FuFVrJqpGGREM2JljYhOTrjWDzGLmqkkPK4cIFPEMQ42YZaWni4UN9pRw6HYZow+iXMKNClp1GWXUPXqi+79GDSNBMZReA7jBSTTWwP2MGXrmRkEafGyHA8Ce0XVvSuBcVaB3myM8oO6mpIHIWTZmsHu63DdPy5Fv6j+1JQHiUS+gbSXW758y3QW7XUFxHUazCzbUALZyFUhqoNPkDCFPiVoUv+3NP+GZo/Qhs43R9rnB77baeVerXWPiHdTHbGLMq25wlZQOabD8dO/xEyVIBtl6lhxIdw2mr/GsyHTQb6I9agttqJ8R1VEKn1Gd5TKlYqDO8lcU63d/AMzYYJNg54WH8FDncRWfm7kTN++cqHmSmnoLEefwE1PnzoXp6MOqxjeQ+7eJxI5ujgfUag1QmbdE6WPTQTKfjQt6hfqnDRaod6ergWBvHyP09wpxOvINo0Z/OolSCHnjkSou608kot+tXaTQj7vKI/79EST2XSjaqdoqrJdDWFzFrSwKZ0aCBIOtpMj/LGiYewdxvyRtXgBV2QpB3mUQXTLxfre+18HyARDTsQReqn4KRrCklpkp69td0L/YIADbCYP2rcbfxx7egLZ8bVvu4CfMiAR4hbskcY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(38070700005)(2616005)(6512007)(38100700002)(66446008)(66556008)(66476007)(122000001)(91956017)(76116006)(66946007)(5660300002)(71200400001)(6506007)(15974865002)(64756008)(44832011)(4326008)(36756003)(186003)(54906003)(316002)(83380400001)(6486002)(508600001)(6916009)(8936002)(86362001)(2906002)(8676002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkFHRm5Ya0RycUVtRFNJYTUxNnhzV0UzRnVHOERvL0hCTVNqeWhENWpLV2Nu?=
 =?utf-8?B?blpaUXdmRDdQVGdqak53ZEYyVnZiS1VqRjlVL0hqaVgvS1R2aGhRWE9Makw4?=
 =?utf-8?B?R3RkQ2x5SkNGUmlqbTIrNUhyZFFVWElhTHlwd284ZWdGQ1FMcThkZkdmZ01z?=
 =?utf-8?B?MWlyaEQ0M3B0eHZIRnlST2R2OGg2VlJpQVB1VTZyT3BKYnlCbGxSNi9EdmtW?=
 =?utf-8?B?aUx5OHdUOEtoQXl0SlhQSHloRlFTUDQyODhrRWYxd3RKN3l4L3Z4L3p1VC9V?=
 =?utf-8?B?UTZJeDZhOUhVTmhYY25uNWc4NEIycjdEYkkreHRRTGE3WFVFRDA2c3lESmdJ?=
 =?utf-8?B?Q205c1o0NWNWamlMZU04dDhJaHkxc1JXWHk3Titra1E5RnBkRHhQSEdFdlh6?=
 =?utf-8?B?aFpGbElpRE4xU2pBVmtsK2JMNTlyVFhRcXltK2JMb1hFa2M4SU5PNmd3ZzVY?=
 =?utf-8?B?eHplWjVBUWdCd3hUZ2F4UUVxQnFlWXJTM1EzNzFZa0ZWRExsLzgrRzBHeXZX?=
 =?utf-8?B?VUJNVWJBS09IVEQ5UTl2Q2UybTVTd0NmbmhiUXAxd2pVb1MzVnJua3hCQnJ2?=
 =?utf-8?B?ZEZoTzdpaTRQV3VvRkljWXIwQ29HWkxIcE8wcGp5WmlTQU1Cczd4eGRVTXJK?=
 =?utf-8?B?dXJDQTdXM2FHVmR5aWl1QlZ3UW5tOStkT3VEc3hLUlUrRHNqTEEwRTRRRlhv?=
 =?utf-8?B?ODA2L0dwRjAxQTFsL2Ntby9lZHRiLzJGSWhDVFp2MzRuVllHdkpWNnlCSkMy?=
 =?utf-8?B?UWNpc3JuTDJkUEl3OWZkWThCWTlIRzdaSXRKclUvOXlETmpyNkNTY2ZXVWtH?=
 =?utf-8?B?bzROUGwwTEdEZ1YrSmZZZDhVMUVjeE9OcVNEdXFlMS9zSGdhUCtyMW5WUVEx?=
 =?utf-8?B?Q2tRUmMzbzNZYUh5RGE0bW1ZMHVmRzZLd1ZCK1RhQlpVVFhoci9NNTZ1TklZ?=
 =?utf-8?B?VE5WaGE5SXNUcnF6ZE40WjR0bGlCcjEzYjhzR0Fsd2dVbnRBZy9GL2hMcWtN?=
 =?utf-8?B?VmxSSVU3Y1krb05ZQk0xQ2RFd3VmcHRQQ1J6NTBoUk4vQ2todE10MTNmeGtQ?=
 =?utf-8?B?b2d0TkRISVBjVURpVkNqTXRpWnV6ZjZqNm0wcGpRYU5FU3hYWTVleEM4YWhS?=
 =?utf-8?B?cDhsSjI2VlVWQUNveDZ6dEd1cWRKSHRyMFRQaW8zYnZNNXB2UEU2dmN3b2Uy?=
 =?utf-8?B?bmlpQkFDeG5RMmxNczE0YkJKNkVZWDV0OGRjSGFsbkNoV0RSQzlPSXRzbjRH?=
 =?utf-8?B?eVlBL2QwMXQ1bkpOdiswdTBGTWxlY1p5YUNzSTVkQjBlSG1vNlY1c2NVZXpH?=
 =?utf-8?B?UHVZMUZWM3Vpd0hxZ2tpby9LYlJ6a05CRGJYSzl1Y1h2ZVRVYUlsVTZmTVdN?=
 =?utf-8?B?MjBZRGZLUTFTTXUyUVB6dExreW9ibVhaMjlZK3ZNRjRHNzBNQzZiQ3pVUzJs?=
 =?utf-8?B?aFNIeGFOQklKaGptTmxpQlhPUGZvWXZrQTRGSkdtMlUvY2hZZTJxWlNNc0c4?=
 =?utf-8?B?Qjk1bTVkSVI1dE0rMitMZjNrKzRsMENucStpaWNiN0x0SDBSWENxUlJVWVpo?=
 =?utf-8?B?eFcrSkpmV3ZNNENMZGQ4QlkxYjRla2pHVkdTQTA5VU45U3pNT3JlaDJ0U1A5?=
 =?utf-8?B?QXJ4dWJCYmJUYkNESGlibFRVbVJKUXhKVjdzMkpzV2V4ajFER2E3N3FHVmRO?=
 =?utf-8?B?bnN1RWphMnZyaEV0VEFmTmdoMWtQOUVxQ2daY05ZVWVibGVTV2F5TkNoREYy?=
 =?utf-8?B?YUFnbUNvTmEwajcrclM3TGQ1dUVUVUlFNUtBVG9pRlpDMDMyVVh0dlh5c2FG?=
 =?utf-8?B?U3JwMGxha1JHNjNkSGtnR2Q5bFBRSGhlTHZ5bDhqWENZbEcxcEJNTys1NTFR?=
 =?utf-8?B?bnFwMndCOGY0NmQ4elg5V1A5d1hVRjBQVnNUeHBoYzZETkVWRTFJbHFQOVFQ?=
 =?utf-8?B?NEsyRDVuVjRNQkx6V25zdzlSYkNQdjhSb3JiWjBkazZwVUc1Nnh5S201SjY0?=
 =?utf-8?B?NzN5Uk40NFhDc0R5aGpNRE5rL2lQR0VvZmpTRnlvMGw1TjhPMzhZNmhxMXNF?=
 =?utf-8?B?ckxnR3BBYzNwdExIV0U0Z3AvODlWL05kNDZwclc5WFdMVElrcWp4d3ZWem0w?=
 =?utf-8?B?WnlJWGJoTmI1cHJoK1pnWWZmZUxmbjl0MGZ6Y0hHdHFtcVg5WTdWNHNoQlJX?=
 =?utf-8?B?S3ppQUFucDhsY0V2cS9vRm5MdjZqZ2ZqUkFxaGRCcnpFd2RhZzdndUdPRElW?=
 =?utf-8?Q?VP6cS8PHiEtAFNsUOhIs6opZVmokS1FJqVRzdztlcs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AA2E47B3ECCB344A290BDC7A223FA2F@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 896b9373-acbf-4a2a-52fd-08d9dac377f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 20:45:31.4727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oGGAykYKG0QbVQrogB2ym70RewPlqIt2FBdIvGwaVvzXY6SZdFjuiMEFArRrkPEak4D71YcUFNRUfF8Jj1sIue/w2kMy/KEAy8GYLVMmyhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB1604
X-Proofpoint-ORIG-GUID: FMFm6JM9IrZYt2J3Q9wYgHN-zF3im4lQ
X-Proofpoint-GUID: FMFm6JM9IrZYt2J3Q9wYgHN-zF3im4lQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTEyIGF0IDExOjM2IC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gVmFyaW91cyBmaXhlcyBmb3IgdGhlIFhpbGlueCBBWEkgRXRoZXJuZXQgZHJpdmVyLg0KPiAN
Cj4gQ2hhbmdlZCBzaW5jZSB2MToNCj4gLWNvcnJlY3RlZCBhIEZpeGVzIHRhZyB0byBwb2ludCB0
byBtYWlubGluZSBjb21taXQNCj4gLXNwbGl0IHVwIHJlc2V0IGNoYW5nZXMgaW50byAzIHBhdGNo
ZXMNCj4gLWFkZGVkIHJhdGVsaW1pdCBvbiBuZXRkZXZfd2FybiBpbiBUWCBidXN5IGNhc2UNCj4g
DQo+IFJvYmVydCBIYW5jb2NrICg5KToNCj4gICBuZXQ6IGF4aWVuZXQ6IGluY3JlYXNlIHJlc2V0
IHRpbWVvdXQNCj4gICBuZXQ6IGF4aWVuZXQ6IFdhaXQgZm9yIFBoeVJzdENtcGx0IGFmdGVyIGNv
cmUgcmVzZXQNCj4gICBuZXQ6IGF4aWVuZXQ6IHJlc2V0IGNvcmUgb24gaW5pdGlhbGl6YXRpb24g
cHJpb3IgdG8gTURJTyBhY2Nlc3MNCj4gICBuZXQ6IGF4aWVuZXQ6IGFkZCBtaXNzaW5nIG1lbW9y
eSBiYXJyaWVycw0KPiAgIG5ldDogYXhpZW5ldDogbGltaXQgbWluaW11bSBUWCByaW5nIHNpemUN
Cj4gICBuZXQ6IGF4aWVuZXQ6IEZpeCBUWCByaW5nIHNsb3QgYXZhaWxhYmxlIGNoZWNrDQo+ICAg
bmV0OiBheGllbmV0OiBmaXggbnVtYmVyIG9mIFRYIHJpbmcgc2xvdHMgZm9yIGF2YWlsYWJsZSBj
aGVjaw0KPiAgIG5ldDogYXhpZW5ldDogZml4IGZvciBUWCBidXN5IGhhbmRsaW5nDQo+ICAgbmV0
OiBheGllbmV0OiBpbmNyZWFzZSBkZWZhdWx0IFRYIHJpbmcgc2l6ZSB0byAxMjgNCj4gDQo+ICAu
Li4vbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMgfCAxMzUgKysrKysr
KysrKystLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgODQgaW5zZXJ0aW9ucygrKSwgNTEgZGVs
ZXRpb25zKC0pDQo+IA0KDQpIaSBhbGwsDQoNCkFueSBvdGhlciBjb21tZW50cy9yZXZpZXdzIG9u
IHRoaXMgcGF0Y2ggc2V0PyBJdCdzIG1hcmtlZCBhcyBDaGFuZ2VzIFJlcXVlc3RlZA0KaW4gUGF0
Y2h3b3JrLCBidXQgSSBkb24ndCB0aGluayBJIHNhdyBhbnkgZGlzY3Vzc2lvbnMgdGhhdCBlbmRl
ZCB1cCB3aXRoIGFueQ0KY2hhbmdlcyBiZWluZyBhc2tlZCBmb3I/DQoNCi0tIA0KUm9iZXJ0IEhh
bmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xv
Z2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
