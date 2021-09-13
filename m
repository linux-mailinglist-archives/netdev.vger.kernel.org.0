Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7701C409DEF
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 22:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbhIMUKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 16:10:14 -0400
Received: from mx0b-0038a201.pphosted.com ([148.163.137.80]:13814 "EHLO
        mx0b-0038a201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236133AbhIMUKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 16:10:13 -0400
X-Greylist: delayed 1869 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2021 16:10:13 EDT
Received: from pps.filterd (m0171341.ppops.net [127.0.0.1])
        by mx0b-0038a201.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DJDHav008482;
        Mon, 13 Sep 2021 19:37:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0038a201.pphosted.com with ESMTP id 3b1ydq27bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 19:37:38 +0000
Received: from m0171341.ppops.net (m0171341.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18DJYv9a031886;
        Mon, 13 Sep 2021 19:37:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0b-0038a201.pphosted.com with ESMTP id 3b1ydq27be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 19:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsTkkTiVybPnUNOY0B3jslcf7wEo+F2vM5LUxBf4PeBxyufNXF5GkEztoODwgTcoaCY4k1slF6bUPO7Uu+A8sbtUZLOyarD3Gta72OKxuMDWxjKAClrYo9nplnSAo9PlUhDXE/vPGV1ZfrA33dS7hUUgqOh5vJdMMVq+uW8Ndmgf5XESkDCkAZr5RgsInbjIMhqpkPBWPWZOb6urGunwVXc8PqKsKAaSGnOM6Mj4oPBKfzQrxoStucsyEUFopRb7F+BkuPuc9C5hhhDUB7tuQ/AeGUyJ5M+v06KfvaothoiLC4oeQHTDNkYs2hZVmBPZcDecia3++uvDo8OdbDUVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KcHcH3t3kKKd7T10iPSTr5OdCwh/anwOYCH30LuAooI=;
 b=NzpuONzOZtMTLyMilrmr1DYQJa8apFQTRdZAIf8NsI4uuqwHDoAUT08+SyWmbd5NbiEMBDlzt9omP1VZl2VWKK4YyrKpZWo1j0cSk9flS3MOg0OP5N9XMT2p7zLmwVgqruN+0eSLuZ80dgzZmh3AV6YnnAJde0IfoXVVgJXO0I5k33FOtWa0A9le854OMp25bWWPMqvpPL4EZpZdsrXOICwdcyqYzrSEX0bvYyIydpCizb02EeHNDzcpY+bbDTPIq6u7DYtyTNrm1R22DvfdHxwU3E2vqjWHr4w6MR1C+0IBYMRtb4FCfAxXwGHzuPD64bD7vnBukFuIZDAHiKWelg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jumptrading.com; dmarc=pass action=none
 header.from=jumptrading.com; dkim=pass header.d=jumptrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcHcH3t3kKKd7T10iPSTr5OdCwh/anwOYCH30LuAooI=;
 b=f1CZHcC9J/2COc0qGXse0WHnBM+Rr4I4QxnlY0ZuQkdLZFITIPx31kwoZ5ZX1VoFTcJrnJcr9YZVaDwb6lf71EEJVx27WlJzc+Tlwp3pjXgin4ZJfXlWd1FsCSrSNWaORIes0Rii8KahWoel5hPwOJDNoA89IE+80YIuRs0peLM=
Received: from MW4PR14MB4796.namprd14.prod.outlook.com (2603:10b6:303:109::19)
 by MWHPR14MB1360.namprd14.prod.outlook.com (2603:10b6:300:b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 19:37:34 +0000
Received: from MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e]) by MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e%9]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 19:37:34 +0000
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsh2FN3baon3J0C4ms4cTGoQHauMjGGAgAGT9oCAFFbJcA==
Date:   Mon, 13 Sep 2021 19:37:34 +0000
Message-ID: <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
 <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
 <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
In-Reply-To: <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=jumptrading.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcde45aa-49a5-412b-7018-08d976edef85
x-ms-traffictypediagnostic: MWHPR14MB1360:
x-microsoft-antispam-prvs: <MWHPR14MB1360A64589DA34BC50B46FFDA1D99@MWHPR14MB1360.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7SNc7BLUHjILrGEjM7Rm5N9zfBUpTfdV7HSSW2JwS83K0894VgOEM+v4+8SSvxsx1P209q0LzoNR2bUVxWOOc1EBxp7omq5t55hqGhP5rWmEDBlvVYhF5zHb8RJOzkbzwJ1hifcMCuz6/Ox8MnFzvbhk0oCviYzITFjFT3s+u6pHHZDCJps+hbcaQmQT5yEiaPoJNupfnCas8KDBlOFV+28LC/NdzqZZZ23LZv84LX9+E+Gee2NbxnDNCxdFNDhBakRBkXkC7vOnvyh4Ou3ynZ46afzBDF4PYsHOjA+dkvcso7GDTzK985rxjqEh2RlAc3SGAiB9fCYsLyONzNZSKI477amYUQUyIVqNHW/PjX58uYNLmBlmk0LKNA1hhxyEpWnlGzqXNoUFcBBdpSZsOe8iQf25TX88nA6O54s5AsOSoQzoyrfPBFF/d/2IhHiGt+fj/qRXkYbGU07WXPt175j4pJv8jkUNicN2y6AQ1JIOpKaRCMYke+t5Pyc3HSdmWLcO1oBmO+BGqgAebfE/V05zSOBX4Ha/BX4lOkgmOrssPrjWS0LDZec5O6opm7goB7K2Hw5ifsIinXqb/bmrmo4Y2nvxcuLQcyQlmRdyqlHqiGJOElYtcn0KiY2p3h2RU0CJZP8/z2GLGVg3fQ6hRwJuuK20PJ/NyE3cjFwIKZJvYPX1qifxEo5kprCyCG1D5NAR7pQTJ0mXk30huA43KQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR14MB4796.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(122000001)(5660300002)(8936002)(53546011)(7696005)(86362001)(66446008)(66476007)(66946007)(66556008)(64756008)(9686003)(55016002)(6916009)(71200400001)(38100700002)(38070700005)(8676002)(186003)(26005)(4326008)(478600001)(52536014)(316002)(76116006)(2906002)(54906003)(83380400001)(33656002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXNMMkpIQzZxL3l2WXd2WEVBUW9OT2RoVGtNbUFzTjFHMEJyb2JJcjVQK3R1?=
 =?utf-8?B?akltMkdyNXZ0WEdTUGlKVU1UVjl2a3pYMjAwemgyb3hsUXdHelVEa25zazlh?=
 =?utf-8?B?dTViaktOMkhOUzI0NXNWTktONDd1TzY3U1oxbWJiRFViT2pvaDMzeUpOSkh5?=
 =?utf-8?B?b0NIaklnRTBhL3RiaVpRN0JvcTVOYVFBR0NwZi9QWmY4THdlNTN0VjVsRlVv?=
 =?utf-8?B?dExzd3NIY1U1VGJmUkxlUjlqUEExK2dKcVgrWDBnaFFRcmwyeGtGVGdUMm1j?=
 =?utf-8?B?ai95UWc4aUFvYlp6MU9EMjhxcU9FWW5vaEVQalIwbFZ0WWxURmxaSXliS2F2?=
 =?utf-8?B?a0ZwM256aHl4ZmdRVTV1bkl2Nm5sdEN3NUFad0tPeEJpUkFpbzNtK1pnVm1U?=
 =?utf-8?B?R1R1amNhWXI1NXF4VU5wTjYzc1hwZ0gvbHVJd3FhcXZOR1R4SjMrSVVQWUtE?=
 =?utf-8?B?TkpnbWRjY2I4UytSb0x6VGUzZHVJNTE5bnM1cW56L2ZWTVlZay93Nm80ekFq?=
 =?utf-8?B?V3ZkVmtsVkRwMHBXcHNnMnNCMkdLVE5CdXpSZS9yQUx4Rk5rWFE1U3haTWRX?=
 =?utf-8?B?dER1NWh3OFFjL2N3U0RnN3k4SXNJU3FnNUdYNC9WazJ3U05YZDVEZ0NMaW5k?=
 =?utf-8?B?OUIyTTZCUU1Ra1NDUG4rQWt3aGUwMmRRWGlZOG1pQThoSThRMTJBdytZZmlV?=
 =?utf-8?B?MERicDUzUENTaStabjVsYm1OTnI5Um9RaGw2cno4T21tMVV6UFQzVDBjamFk?=
 =?utf-8?B?K1gwT0dYVzZRTTk1dVhNRTF4M2g1cjdwM1VuZytnNmhNMWY1ZXpBN1JIRWFH?=
 =?utf-8?B?TjdCR3ZMT2FTQnpoZUlsNkNEK1FoS0xWVTd1aWV3TGovY3dsei9DbjlaMWtP?=
 =?utf-8?B?bHByWkdLYTE5c3lxdXAxeFRiZnZRZGU0TTBJS2I3N1J6Y1JjVUdDTENOU1JI?=
 =?utf-8?B?THFIRWJNbGRwT0tyS3FUZVNISkVMdWVqUkhiQkJVaml1L1p6dUdzNWc0N3NQ?=
 =?utf-8?B?Y2xuWHFyNUduSWpwZHlCWjRlR2ljMHFmRXB2SmVYSkJtRWp4REJoY2hkaWx1?=
 =?utf-8?B?YXdYOGk4bUR0M0NMaUkreFRPZGJHci81Q3NYdUZ3SjZVNkJrWHJ6RFZ4Z083?=
 =?utf-8?B?ckNqelV1a1RBa2RadzFFTG5XYi9kcjREWm5hNEZBejJGYzg5MUdmcHZnZjBG?=
 =?utf-8?B?Z3krT2g2TDVZdlFTN2xaYzlGRHkwektmaGU5Vm5PV0Jtc3A5UTVUQWtQaWFy?=
 =?utf-8?B?L0VWZGhMYWlIMXdkRittNDVGc2IzY0JhN3lkT3pvOTdyM2cwNytURTlRZVNU?=
 =?utf-8?B?R3JXQVZoZzZ5azJvVzVGY2NjYWdUZllZQWt3WkJ0SGc1SzlPQXpkWWxBUXRm?=
 =?utf-8?B?U0M5VjlQZUwrOUFtZXgxckNmUGRjQVR0K29idzBhT2tobWJJZnZmSGVUdklR?=
 =?utf-8?B?OWNBcnpHSXVvTDBVOXRmT2JmZkszWmpUSXBQakUrSStCZUhQRzFOYWk4a29w?=
 =?utf-8?B?bkZKNnp1MG5HbjNnU2NGYkVyVjd6M29sWlI4dGhoM1B4b3RoMW9iMWczSkhk?=
 =?utf-8?B?eHJ5MTJvdVo3Nm5JL0NNLyt5Wlp3S25EZkYzNG4rYjJscm93VUt1SXZaeGZr?=
 =?utf-8?B?QVk4Qkh3czNlYTlrTE9VK0drazZVUUVEejYxV2ZqU3puSU9wVEhxTTBkVzcr?=
 =?utf-8?B?czNQN3hkN2tkWGJLTmFIUVpRTWNQOGt1NnA5bWQ3WVBkOVVNVTdSa1BaTWgr?=
 =?utf-8?Q?Ra3qPjZxt3OtFj+4lREiAjwRbYdDNMR+2fdMLvc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR14MB4796.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcde45aa-49a5-412b-7018-08d976edef85
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 19:37:34.7048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I0DGVpbN2N7ZL/Q/iz8as14qSkjsPu5bQr2CXQDFsVYYfFxKwr25zGSrR7q91wZevAAv07N3HeXG8y43FVwOByjjQmmFxTX1SoT0JMPObws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR14MB1360
X-Proofpoint-GUID: 3LDAgRAUIRtBtyCyL9uYY1xRQ4IfIXzb
X-Proofpoint-ORIG-GUID: LFLdcyO7GNDAnTOiQ-B4vTqjKTe94CWp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_09,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVG9ueSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQSiBXYXNr
aWV3aWN6IDxwd2Fza2lld2ljekBqdW1wdHJhZGluZy5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEF1
Z3VzdCAzMSwgMjAyMSAxOjU5IFBNDQo+IFRvOiBOZ3V5ZW4sIEFudGhvbnkgTCA8YW50aG9ueS5s
Lm5ndXllbkBpbnRlbC5jb20+DQo+IENjOiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9y
ZzsgcGp3YXNraWV3aWN6QGdtYWlsLmNvbTsgTG9rdGlvbm92LA0KPiBBbGVrc2FuZHIgPGFsZWtz
YW5kci5sb2t0aW9ub3ZAaW50ZWwuY29tPjsgRmlqYWxrb3dza2ksIE1hY2llag0KPiA8bWFjaWVq
LmZpamFsa293c2tpQGludGVsLmNvbT47IER6aWVkeml1Y2gsIFN5bHdlc3RlclgNCj4gPHN5bHdl
c3RlcnguZHppZWR6aXVjaEBpbnRlbC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBCcmFuZGVi
dXJnLA0KPiBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBQSg0KPiBXYXNraWV3aWN6IDxwd2Fza2lld2ljekBqdW1wdHJhZGluZy5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8xXSBpNDBlOiBBdm9pZCBkb3VibGUgSVJRIGZyZWUg
b24gZXJyb3IgcGF0aCBpbiBwcm9iZSgpDQo+DQo+IE9uIE1vbiwgQXVnIDMwLCAyMDIxIGF0IDA4
OjUyOjQxUE0gKzAwMDAsIE5ndXllbiwgQW50aG9ueSBMIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAy
MS0wOC0yNiBhdCAxNzoxOSAtMDUwMCwgUEogV2Fza2lld2ljeiB3cm90ZToNCj4gPiA+IFRoaXMg
Zml4ZXMgYW4gZXJyb3IgcGF0aCBjb25kaXRpb24gd2hlbiBwcm9iZSgpIGZhaWxzIGR1ZSB0byB0
aGUNCj4gPiA+IGRlZmF1bHQgVlNJIG5vdCBiZWluZyBhdmFpbGFibGUgb3Igb25saW5lIHlldCBp
biB0aGUgZmlybXdhcmUuIElmDQo+ID4gPiB0aGF0IGhhcHBlbnMsIHRoZSBwcmV2aW91cyB0ZWFy
ZG93biBwYXRoIHdvdWxkIGNsZWFyIHRoZSBpbnRlcnJ1cHQNCj4gPiA+IHNjaGVtZSwgd2hpY2gg
YWxzbyBmcmVlZCB0aGUgSVJRcyB3aXRoIHRoZSBPUy4gVGhlbiB0aGUgZXJyb3IgcGF0aA0KPiA+
ID4gZm9yIHRoZSBzd2l0Y2ggc2V0dXAgKHByZS1WU0kpIHdvdWxkIGF0dGVtcHQgdG8gZnJlZSB0
aGUgT1MgSVJRcyBhcw0KPiA+ID4gd2VsbC4NCj4gPg0KPiA+IEhpIFBKLA0KPg0KPiBIaSBUb255
LA0KPg0KPiA+DQo+ID4gVGhlc2UgY29tbWVudHMgYXJlIGZyb20gdGhlIGk0MGUgdGVhbS4NCj4g
Pg0KPiA+IFllcyBpbiBjYXNlIHdlIGZhaWwgYW5kIGdvIHRvIGVycl92c2lzIGxhYmVsIGluIGk0
MGVfcHJvYmUoKSB3ZSB3aWxsDQo+ID4gY2FsbCBpNDBlX3Jlc2V0X2ludGVycnVwdF9jYXBhYmls
aXR5IHR3aWNlIGJ1dCB0aGlzIGlzIG5vdCBhIHByb2JsZW0uDQo+ID4gVGhpcyBpcyBiZWNhdXNl
IHBjaV9kaXNhYmxlX21zaS9wY2lfZGlzYWJsZV9tc2l4IHdpbGwgYmUgY2FsbGVkIG9ubHkNCj4g
PiBpZiBhcHByb3ByaWF0ZSBmbGFncyBhcmUgc2V0IG9uIFBGIGFuZCBpZiB0aGlzIGZ1bmN0aW9u
IGlzIGNhbGxlZCBvbmVzDQo+ID4gaXQgd2lsbCBjbGVhciB0aG9zZSBmbGFncy4gU28gZXZlbiBp
ZiB3ZSBjYWxsDQo+ID4gaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSB0d2ljZSB3ZSB3
aWxsIG5vdCBkaXNhYmxlIG1zaSB2ZWN0b3JzDQo+ID4gdHdpY2UuDQo+ID4NCj4gPiBUaGUgaXNz
dWUgaGVyZSBpcyBkaWZmZXJlbnQgaG93ZXZlci4gSXQgaXMgZmFpbGluZyBpbiBmcmVlX2lycSBi
ZWNhdXNlDQo+ID4gd2UgYXJlIHRyeWluZyB0byBmcmVlIGFscmVhZHkgZnJlZSB2ZWN0b3IuIFRo
aXMgaXMgYmVjYXVzZSBzZXR1cCBvZg0KPiA+IG1pc2MgaXJxIHZlY3RvcnMgaW4gaTQwZV9wcm9i
ZSBpcyBkb25lIGFmdGVyIGk0MGVfc2V0dXBfcGZfc3dpdGNoLiBJZg0KPiA+IGk0MGVfc2V0dXBf
cGZfc3dpdGNoIGZhaWxzIHRoZW4gd2Ugd2lsbCBqdW1wIHRvIGVycl92c2lzIGFuZCBjYWxsDQo+
ID4gaTQwZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lIHdoaWNoIHdpbGwgdHJ5IHRvIGZyZWUgdGhv
c2UgbWlzYyBpcnENCj4gPiB2ZWN0b3JzIHdoaWNoIHdlcmUgbm90IHlldCBhbGxvY2F0ZWQuIFdl
IHNob3VsZCBoYXZlIHRoZSBwcm9wZXIgZml4DQo+ID4gZm9yIHRoaXMgcmVhZHkgc29vbi4NCj4N
Cj4gWWVzLCBJJ20gYXdhcmUgb2Ygd2hhdCdzIGhhcHBlbmluZyBoZXJlIGFuZCB3aHkgaXQncyBm
YWlsaW5nLiBTYWRseSwgSSBhbQ0KPiBwcmV0dHkgc3VyZSBJIHdyb3RlIHRoaXMgY29kZSBiYWNr
IGluIGxpa2UgMjAxMSBvciAyMDEyLCBhbmQgYmVpbmcgYW4gZXJyb3INCj4gcGF0aCwgaXQgaGFz
bid0IHJlYWxseSBiZWVuIHRlc3RlZC4NCj4NCj4gSSBkb24ndCByZWFsbHkgY2FyZSBob3cgdGhp
cyBnZXRzIGZpeGVkIHRvIGJlIGhvbmVzdC4gV2UgaGl0IHRoaXMgaW4gcHJvZHVjdGlvbg0KPiB3
aGVuIG91ciBMT00sIGZvciB3aGF0ZXZlciByZWFzb24sIGZhaWxlZCB0byBpbml0aWFsaXplIHRo
ZSBpbnRlcm5hbCBzd2l0Y2ggb24NCj4gaG9zdCBib290LiBXZSBlc2NhbGF0ZWQgdG8gb3VyIGRp
c3RybyB2ZW5kb3IsIHRoZXkgZGlkIGVzY2FsYXRlIHRvIEludGVsLCBhbmQNCj4gaXQgd2Fzbid0
IHJlYWxseSBwcmlvcml0aXplZC4gU28gSSBzZW50IGEgcGF0Y2ggdGhhdCBkb2VzIGZpeCB0aGUg
aXNzdWUuDQo+DQo+IElmIHRoZSB0ZWFtIHdhbnRzIHRvIHJlc3BpbiB0aGlzIHNvbWVob3csIGdv
IGFoZWFkLiBCdXQgdGhpcyBkb2VzIGZpeCB0aGUNCj4gaW1tZWRpYXRlIGlzc3VlIHRoYXQgd2hl
biBiYWlsaW5nIG91dCBpbiBwcm9iZSgpIGR1ZSB0byB0aGUgbWFpbiBWU0kgbm90DQo+IGJlaW5n
IG9ubGluZSBmb3Igd2hhdGV2ZXIgcmVhc29uLCB0aGUgZHJpdmVyIGJsaW5kbHkgYXR0ZW1wdHMg
dG8gY2xlYW4gdXAgdGhlDQo+IG1pc2MgTVNJLVggdmVjdG9yIHR3aWNlLiBUaGlzIGNoYW5nZSBm
aXhlcyB0aGF0IGJlaGF2aW9yLiBJJ2QgbGlrZSB0aGlzIHRvIG5vdA0KPiBsYW5ndWlzaCB3YWl0
aW5nIGZvciBhIGRpZmZlcmVudCBmaXgsIHNpbmNlIEknZCBsaWtlIHRvIHBvaW50IG91ciBkaXN0
cm8gdmVuZG9yIHRvDQo+IHRoaXMgKG9yIGFub3RoZXIpIHBhdGNoIHRvIGNoZXJyeS1waWNrLCBz
byB3ZSBjYW4gZ2V0IHRoaXMgaW50byBwcm9kdWN0aW9uLg0KPiBPdGhlcndpc2Ugb3VyIHBsYXRm
b3JtIHJvbGxvdXQgaGl0dGluZyB0aGlzIHByb2JsZW0gaXMgZ29pbmcgdG8gYmUgcXVpdGUNCj4g
YnVtcHksIHdoaWNoIGlzIHZlcnkgbXVjaCBub3QgaWRlYWwuDQoNCkl0J3MgYmVlbiAyIHdlZWtz
IHNpbmNlIEkgcmVwbGllZC4gIEFueSB1cGRhdGUgb24gdGhpcz8gIE1hY2llaiBoYWQgYWxyZWFk
eSByZXZpZXdlZCB0aGUgcGF0Y2gsIHNvIGhvcGluZyB3ZSBjYW4ganVzdCBtb3ZlIGFsb25nIHdp
dGggaXQsIG9yIGdldCBzb21ldGhpbmcgZWxzZSBvdXQgc29vbj8NCg0KSSdkIHJlYWxseSBsaWtl
IHRoaXMgdG8gbm90IGp1c3QgZmFsbCBpbnRvIGEgdm9pZCB3YWl0aW5nIGZvciBhIGRpZmZlcmVu
dCBwYXRjaCB3aGVuIHRoaXMgZml4ZXMgdGhlIGlzc3VlLg0KDQotUEoNCg0KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18NCg0KTm90ZTogVGhpcyBlbWFpbCBpcyBmb3IgdGhlIGNvbmZp
ZGVudGlhbCB1c2Ugb2YgdGhlIG5hbWVkIGFkZHJlc3NlZShzKSBvbmx5IGFuZCBtYXkgY29udGFp
biBwcm9wcmlldGFyeSwgY29uZmlkZW50aWFsLCBvciBwcml2aWxlZ2VkIGluZm9ybWF0aW9uIGFu
ZC9vciBwZXJzb25hbCBkYXRhLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50
LCB5b3UgYXJlIGhlcmVieSBub3RpZmllZCB0aGF0IGFueSByZXZpZXcsIGRpc3NlbWluYXRpb24s
IG9yIGNvcHlpbmcgb2YgdGhpcyBlbWFpbCBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLCBhbmQgcmVx
dWVzdGVkIHRvIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkZXN0cm95IHRoaXMg
ZW1haWwgYW5kIGFueSBhdHRhY2htZW50cy4gRW1haWwgdHJhbnNtaXNzaW9uIGNhbm5vdCBiZSBn
dWFyYW50ZWVkIHRvIGJlIHNlY3VyZSBvciBlcnJvci1mcmVlLiBUaGUgQ29tcGFueSwgdGhlcmVm
b3JlLCBkb2VzIG5vdCBtYWtlIGFueSBndWFyYW50ZWVzIGFzIHRvIHRoZSBjb21wbGV0ZW5lc3Mg
b3IgYWNjdXJhY3kgb2YgdGhpcyBlbWFpbCBvciBhbnkgYXR0YWNobWVudHMuIFRoaXMgZW1haWwg
aXMgZm9yIGluZm9ybWF0aW9uYWwgcHVycG9zZXMgb25seSBhbmQgZG9lcyBub3QgY29uc3RpdHV0
ZSBhIHJlY29tbWVuZGF0aW9uLCBvZmZlciwgcmVxdWVzdCwgb3Igc29saWNpdGF0aW9uIG9mIGFu
eSBraW5kIHRvIGJ1eSwgc2VsbCwgc3Vic2NyaWJlLCByZWRlZW0sIG9yIHBlcmZvcm0gYW55IHR5
cGUgb2YgdHJhbnNhY3Rpb24gb2YgYSBmaW5hbmNpYWwgcHJvZHVjdC4gUGVyc29uYWwgZGF0YSwg
YXMgZGVmaW5lZCBieSBhcHBsaWNhYmxlIGRhdGEgcHJvdGVjdGlvbiBhbmQgcHJpdmFjeSBsYXdz
LCBjb250YWluZWQgaW4gdGhpcyBlbWFpbCBtYXkgYmUgcHJvY2Vzc2VkIGJ5IHRoZSBDb21wYW55
LCBhbmQgYW55IG9mIGl0cyBhZmZpbGlhdGVkIG9yIHJlbGF0ZWQgY29tcGFuaWVzLCBmb3IgbGVn
YWwsIGNvbXBsaWFuY2UsIGFuZC9vciBidXNpbmVzcy1yZWxhdGVkIHB1cnBvc2VzLiBZb3UgbWF5
IGhhdmUgcmlnaHRzIHJlZ2FyZGluZyB5b3VyIHBlcnNvbmFsIGRhdGE7IGZvciBpbmZvcm1hdGlv
biBvbiBleGVyY2lzaW5nIHRoZXNlIHJpZ2h0cyBvciB0aGUgQ29tcGFueeKAmXMgdHJlYXRtZW50
IG9mIHBlcnNvbmFsIGRhdGEsIHBsZWFzZSBlbWFpbCBkYXRhcmVxdWVzdHNAanVtcHRyYWRpbmcu
Y29tLg0K
