Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E642CE495
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgLDApS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:45:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbgLDApR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:45:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B40Vfn0022934;
        Thu, 3 Dec 2020 16:43:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=pzCjpJV54u05fs/t9g8LdSoySeFj51dZxLe97jJqCuI=;
 b=CoqIVmT+1Rw6HMjXTPoT5PWc7Jj/BNELcuVwR6vYhfsQZQh3WCRWyo1tqz3b3dS52SuN
 RYjKYKekkAtuKtcuARfllgGBIa7QLFI3I23Knyhs3t3maz0JWLsP35H71KjnPzPkUXYz
 6DtoN8v3sWUrKfATclO/lvi353FdkyKSsU+NThvzT0YiXg6LH9acTTI0aDGsr0YrSTBq
 X8sFsJLj22D/8L/6RYVaA9dMHaknYdqkeQHND4xsjFuKLboY+hBIwvUqzOzPznzU7HVE
 pmVopu5ksVXKTQiMJVRyQXgJcgWIpmpdpR6ey+0/IN652qWC8VeOMbZV+b6kdIVIxLxR YQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50ftvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:43:54 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 16:43:52 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 16:43:51 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 16:43:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwHJkwvo4yRwdRDJe8Q0dGy0rZre3SZvU4CImdJipsV0QEQ7e9yKw7Ls4LTB5rzlB4wmhejMD8gXzfoz8jT938EXve7dvqqI3vikgrrbs1QKzdKg3RdIqGap5lxpbv5iPmFTn0qlWBG9MKjcAEkVElYSh08K5+9Zcr88dwfByDN4G/ij+htq4GcUFRRyinlJ+eITMeO7t6HaYU+TnjngEbTZf9eTFZdx7mB4dl8TBeJ/4U3N1yQ4AzN0nn23mOuCaL7OqWKi7/TWOgv9QByPVVbBF5D7mfy8FRlHrOtenKkd3XEWs0/mzQbuDlx85k8Q3JNHLgH6OQefDPMMs3lWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzCjpJV54u05fs/t9g8LdSoySeFj51dZxLe97jJqCuI=;
 b=iScwkWP8DuA+j5loWIsljFZYLW9q2wmzZZcAjH5IhUIwyFsRLEeE6LORDpiYBn+cVMb0Qtc2oqwcX4MncdvG/7jlFAnITlIqWHuG8b2YC9uHxG0IRDNjiZkB4vJk+5D4WL+RQQKLRnLW/3QO0vLusgyW2SfOc6WDXnM815K/fM6owJQE2enZEhZxoHibzkL0Efu+tShzO9gPeGawz2tvZPv6gEjueWHgnz4xQXHbVzcDc/MG7slhSK+5dPevYHSQ6FmFIjROlyFmUS9en5J/uC2ypqeiE4KTrOaRN4VeUuVq8vV1zpDjoqBfq3zAT3KOE0XohjUQJC0k05ZV1cC6Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzCjpJV54u05fs/t9g8LdSoySeFj51dZxLe97jJqCuI=;
 b=Y1xwaH6VddJlBWonF4Rt8T8tEMgoW6e1pPMvGBzDK+6s6Xe4bW8MpAYXKpBN2LpvTxfthPCTT3648ybahIpKpdHx8z5KP1Us8aRkLEXk8zNB2T13JPLhqKauA8oKIAJaM3zdceU2yE8Khv6c1w5IWRHH9hmJsisbdyAxIuE1Lno=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1824.namprd18.prod.outlook.com (2603:10b6:301:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 00:43:50 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363%6]) with mapi id 15.20.3632.020; Fri, 4 Dec 2020
 00:43:50 +0000
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
Subject: Re: [EXT] Re: [PATCH v5 5/9] task_isolation: Add driver-specific
 hooks
Thread-Topic: [EXT] Re: [PATCH v5 5/9] task_isolation: Add driver-specific
 hooks
Thread-Index: AQHWwcIjLJ3XhCtZ4UCn5Rp0YgDpdanj6HWAgAJBFAA=
Date:   Fri, 4 Dec 2020 00:43:49 +0000
Message-ID: <fcef37ae29fdb58c7bf60a568590075a1c07dc2e.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <6e15fde56203f89ebab0565dc22177f42063ae7c.camel@marvell.com>
         <20201202141821.GC66958@C02TD0UTHF1T.local>
In-Reply-To: <20201202141821.GC66958@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc8e3888-161f-4167-ea14-08d897edaac0
x-ms-traffictypediagnostic: MWHPR1801MB1824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB18241463541FDAD198B84799BCF10@MWHPR1801MB1824.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZrhkpDubZ6txdLgcGonisAxab+GfMz5/Q2l0b3XTunm8/IGDMaxaSBEULb/FQgTJNQRML+DcR8iuF1jDf1mYhLuXzRSeRNC8RIfQgE8nozGemZ1UqmfsoqB3bCfHyt2Eor8xCh+EzWKugU4QDYbivZgQ1NlpfC1fI5KIcg8Rj4EalBi0VrhViKx4uInaMpgHRmC8P0wW0+5Gww9MNpyVVhH2B662DTgGlHTKFOu7hLzHBVtJ9VSTYtImBDI4AgjuxPh77cCCkFwBfGlF86a7WYzPCiBSPysYtbDAzmF8l3W54+GGd0K50d8e/S9bNu7SKuowTFm8yEylrtuaiK/Piw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(66476007)(6506007)(4326008)(478600001)(71200400001)(8676002)(66556008)(76116006)(6916009)(316002)(66946007)(91956017)(36756003)(64756008)(86362001)(4744005)(5660300002)(8936002)(6486002)(66446008)(26005)(54906003)(7416002)(6512007)(2906002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OFI0c0RjTE5wbW80MzJiODgvUG1TdlNMSUx5clRwZlBSL3lKbTRPcDdPMWV0?=
 =?utf-8?B?cGR0UEdHa3pGdjhJRkxPMlJ6WnpRZ2NZS0hUYXhrVHRyc3hRdUloSkZuMmx4?=
 =?utf-8?B?ZU9NVlJydFdyQzBkY2U3L2dJZlpFTStjZmxyTVdxZm5laXVaMGk5TEtxWWpJ?=
 =?utf-8?B?RzZNdG9uZWtpVnpWVDVDMVo1cDRZSnJtRUpZZUxmMU1HTXlvLzZ1dVIxazlz?=
 =?utf-8?B?aXZyK3RUMUUwaUpXbE9Gd3dRTC9WWDUvZEFJRml0b3RTeTk0NFBBYmJBS2lD?=
 =?utf-8?B?L3RkQnh4VDBNamthU3MzaGJwSFpvRUx3MktodmZxd3FzbnJRaG9KTWdNci9p?=
 =?utf-8?B?a0U0YnhxaTVMQjNzQkxqVlAwdmsvUktjb3BEeXNiaWJERFF1ZFg2Q2NzUWpX?=
 =?utf-8?B?NGVNejZodkZkTnlyQjlOYmwyUm4zM0JHcStkLzIvU2l5NFNzdlRhU0V3eFBZ?=
 =?utf-8?B?aHRBaU5mN0YxWGIxaFJoOEFZa2dpUjYrU3NYVlZ0RnN1cVRLNDQyNSswaUIv?=
 =?utf-8?B?M1hoM2ZYTGxHQ1k3RU1kSVpmcXBicU1VcEZPS3BkWUJqR0djOGc1b1JPd3hX?=
 =?utf-8?B?K2pXbVFIcEQ5d0N6dHVFRkFyanVST3NjdjdFTG1XeVovb1J6ekNCVUhuY2VM?=
 =?utf-8?B?bXM2cVp3RzBlWHRrQUFVSHZmUTVNdk1iWWdiMEdjWGNOdW1IS2hJMVRJT2JH?=
 =?utf-8?B?cmpzWlNLZGpuQzNuVnBtdGZoODFweEZyTUthZVRmMjVPcDRrR3hLdm9hU2NW?=
 =?utf-8?B?SGw2NVNMQTdOY2NrMkRCbWhkQTY2VG0xM1hteVFwN3M2WXc0algycEppUnAx?=
 =?utf-8?B?K3Z5eU5BOWkyYW9qYzhYUkVJNUI3WGNrL0xjYVZHOWVmTmh0U2pKMm52eUor?=
 =?utf-8?B?YnFTd2lhejdPWmU0RWR5Z01JSlN6M0Y5Ym1ZYzBWNlZWSmY1bWwrSFpvRnc4?=
 =?utf-8?B?bkZOZXBDZEp2eGVPd0dBY3BZYW4zTSs3SHZkc1ZkMjFtSXBham9PcXhlUXlL?=
 =?utf-8?B?NnBZckpaV3czdTFMbW92UXhnb3hxaC9WQ3VGK3FKcGFWb3ZISXlVcmtjVzM1?=
 =?utf-8?B?U2hzMjdYQzdqYmdSQTd2eGlGeWdwNkd5THc3ajN6bldTUEJpN1RxNlJQTklw?=
 =?utf-8?B?ekQ4YjVXeXE0RVNYeUpDdkptWENQVldLY0NlNDI1TVM1a25SSk1oQWc5UEND?=
 =?utf-8?B?V2JsMmhEaFZIL1FZajVFR0lvcWNpZW00RmFtekFBNlZRNXByMVQyemVyZlNk?=
 =?utf-8?B?MlFKZnNxOHpRVmNaMVFrVHkxbllzUjl2Z2Q0YmlDeGFsVGhMTDVlQnJWVU9k?=
 =?utf-8?Q?LFzx/aXcIAYskNkso99GIl1Eq0QxL9/xVf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CFE21289AD19F4A9DEC926E087B0031@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8e3888-161f-4167-ea14-08d897edaac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 00:43:49.9678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YWVdlywrzTBjk66zrNTuFx7djt2BZ9jk697Bi+OTZuMqrATttcD4mcYAO0HTEDKrAxY0qLxTZsJEXJk2zl7rJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1824
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQsIDIwMjAtMTItMDIgYXQgMTQ6MTggKzAwMDAsIE1hcmsgUnV0bGFuZCB3cm90ZToN
Cj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gLS0tDQo+IE9uIE1vbiwgTm92
IDIzLCAyMDIwIGF0IDA1OjU3OjQyUE0gKzAwMDAsIEFsZXggQmVsaXRzIHdyb3RlOg0KPiA+IFNv
bWUgZHJpdmVycyBkb24ndCBjYWxsIGZ1bmN0aW9ucyB0aGF0IGNhbGwNCj4gPiB0YXNrX2lzb2xh
dGlvbl9rZXJuZWxfZW50ZXIoKSBpbiBpbnRlcnJ1cHQgaGFuZGxlcnMuIENhbGwgaXQNCj4gPiBk
aXJlY3RseS4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgcHV0dGluZyB0aGlzIGluIGRyaXZlcnMgaXMg
dGhlIHJpZ2h0IGFwcHJvYWNoLiBJSVVDIHdlDQo+IG9ubHkgbmVlZCB0byB0cmFjayB1c2VyPC0+
a2VybmVsIHRyYW5zaXRpb25zLCBhbmQgd2UgY2FuIGRvIHRoYXQNCj4gd2l0aGluDQo+IHRoZSBh
cmNoaXRlY3R1cmFsIGVudHJ5IGNvZGUgYmVmb3JlIHdlIGV2ZXIgcmVhY2ggaXJxY2hpcCBjb2Rl
LiBJDQo+IHN1c3BlY3QgdGhlIGN1cnJlbnQgYXBwcm9hY2NoIGlzIGFuIGFydGlmYWN0IG9mIHRo
YXQgYmVpbmcgZGlmZmljdWx0DQo+IGluDQo+IHRoZSBvbGQgc3RydWN0dXJlIG9mIHRoZSBhcmNo
IGNvZGU7IHJlY2VudCByZXdvcmsgc2hvdWxkIGFkZHJlc3MNCj4gdGhhdCwNCj4gYW5kIHdlIGNh
biByZXN0cnVlY3R1cmUgdGhpbmdzIGZ1cnRoZXIgaW4gZnV0dXJlLg0KDQpJIGFncmVlIGNvbXBs
ZXRlbHkuIFRoaXMgcGF0Y2ggb25seSBjb3ZlcnMgaXJxY2hpcCBkcml2ZXJzIHdpdGggdW51c3Vh
bA0KZW50cnkgcHJvY2VkdXJlcy4NCg0KLS0gDQpBbGV4DQo=
