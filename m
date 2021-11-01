Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADEF4419D9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 11:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhKAKaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 06:30:10 -0400
Received: from mail-mw2nam10on2126.outbound.protection.outlook.com ([40.107.94.126]:21544
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231868AbhKAKaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 06:30:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoL6o0Weiw099cKiFyB+Qew4z/ESdqUnvDkAWeprkVyR9HwvaYfO6MDZX4uR8KSiI25R0L9o9TmRad/Nk0NrfS1xJUwuxnk91sv7CH1U2ZBhAdp408txoAWtxIFV4D0IOoQhysOLboiolfM78fL3Z2ZetcyHaVjeXjrMKBNj4koRaMemPPtIfKfV2O9lpnV1KBdEgPRLueOdOUk/16kS5z0lsXkj5mSTExCc0XgMLuM77Ol5IF+Xwm2mmMuFN452D7TyIJh+npYR+eSrwbH/tMCVy2gtc7y+oQNrdd4K9Vx1m9m4BMoj+qCxj+bLe5sZG7iRlG1uKwhVXWJ05+YINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHZcJRCT3y2OmTy/RT+s+WMQxtNNCVoMZvaUeka61I0=;
 b=i0xEbIvnnTmWS6oJ8gZsRBgwlbEluZf5cyQMgHrADf5lzBmwYyMV5wd48JpcLl4OjeUpcwE1wvYfLchnDmT6dQyrQGUi1bOv1GcLcwI0KmEjTgVdvqDrWEzw0gP+1QmSyRbvhZxTSlxQqcmMjzxiE1gxTp8FZTJg0muV9sIDexAcrGYIpi0A21w9voqS2X6XFbEW68v/LUbN47CwyHsUzDw/D7sczhtosyDNhAIdQbEnI28C3E8PiL+Uwttn6oyH6zqTIs6EaVUcOkuW83Ezqkk8KvghqI4Iavy2O7VzrcQWUZs5mqOer1qyUyXvVMG2SfNqvyA507CphGZL2Knx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHZcJRCT3y2OmTy/RT+s+WMQxtNNCVoMZvaUeka61I0=;
 b=u+2G7u+7i6lvd3kbbvuiltfs4OXUF/tuLk3xzOq63nn2cJtdHWdJcYSsD58vgUYFVguN1wYJAuQ+Yn4VeA6WJo5PYo26/Dk23PEdo/Hi0WvU8UpRddQ7/YC2n+3CSIp/t4mnXwjD/Bubz7meBdm7Do4rEXgypUsea4GstDWtNC4=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1865.namprd13.prod.outlook.com (2603:10b6:3:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6; Mon, 1 Nov
 2021 10:27:33 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.009; Mon, 1 Nov 2021
 10:27:33 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload
 tc action to net device
Thread-Topic: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload
 tc action to net device
Thread-Index: AQHXy+v1+y1G/1prI0246nLJaJu/lqvs4YgAgAERgLCAAIWSAIAABCMw
Date:   Mon, 1 Nov 2021 10:27:33 +0000
Message-ID: <DM5PR1301MB217274AAA2D474D194159C8BE78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-4-simon.horman@corigine.com>
 <cf6ebe6c-d852-e934-cbb3-03220d5eedf8@nvidia.com>
 <DM5PR1301MB2172C90CF04E14EA7FAD5528E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <2d6daa85-97b9-140a-5e92-0d775ba246d0@nvidia.com>
In-Reply-To: <2d6daa85-97b9-140a-5e92-0d775ba246d0@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a817565-2b43-40cf-e2ca-08d99d2237a5
x-ms-traffictypediagnostic: DM5PR13MB1865:
x-microsoft-antispam-prvs: <DM5PR13MB1865A3F16DED4981A8F93075E78A9@DM5PR13MB1865.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VPDq56/c/sMhvN8Ohf1VW18LNO4mg9Ee/8V+zuu/9yDddpOwuzF39USDhA9LGdVd/HuEY+peknyoK0LZmEkx3GvCp4oO2UdHzlI2veKL6s76V/FUpcmFzzcUTSrmGwa8PSsiYigznGI+R85NrXhL2HbK3OenW6fvsKRkHpclUcBgHVL0GQCnBD6+XDdkVe7N60Mo40N0Wvjs0rcAiKN6HQQ9+Okx8M+gOa9cCQNVERg8eG41X1R+UyiK7QtTohSFwANu1iIz3EHiPH/A93NfVm3svu+VcuO7VmDD5l6rk/dNNl8icl3ACjyTOzmXYR0jR0VB0+JZVTyPQC+gYWKp3QLqnDNyRZtbNikWAu55RfnGDeDr0VYsVmF1Qp0yqQFpZRGZvLDjuyMpMLb0Ym0AmbT72A0tU5VwXAcc0Rk+K3re2yiqZx5ztHxROYxTo5LAFzD++yY+BoAiqm0JRByLZUutKpY774y7tzOhQ2DQ0OIVdPkbqRvqdWodo+vLGLkr8CpRICDPfGOYyPBfwSyNcGBpWd04LX9hr3AlkIno7CUBoKcNOwbp3BfAJXaDIeAKgt5yF9T/EEHSB5djXTdBaMM8lQXP8qsM1EBg4HJXx1QC5Tu8YCSWt5iV6+ze9FcXfcvyoxf7oaH7V1VJz7QiVljXOMujYH/kHSmKVpt59hDTnChQb/0fsx8m+gznuNcyQePpTVzyvYnf6N26NXyVfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(76116006)(66946007)(71200400001)(53546011)(52536014)(6506007)(107886003)(9686003)(66446008)(86362001)(64756008)(66556008)(66476007)(2906002)(38070700005)(316002)(83380400001)(54906003)(38100700002)(122000001)(7696005)(55016002)(186003)(8676002)(33656002)(44832011)(5660300002)(110136005)(508600001)(4326008)(26005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmZOcVBhbVBuL3ZDMDVSUkVwSDVRVGpSVFdqbXFTbFA0N0x4NW1PaHl5TXN6?=
 =?utf-8?B?bzNXQ0t1blhWeGVkN21xdnV1Zmo2cWxSVXpTY2tLZm1uU09GMUVRSTRhenZt?=
 =?utf-8?B?WlVSQlQvdkpPVkl4bmh2VVVVa083MGQxMG1aSy9pMUVlNncwNDJ4MG5QVlVI?=
 =?utf-8?B?dE9BWmw0d1MxMmJ5NUtOQTF1VUQxaWs2N0g2SnVkeDNzdEpKZGtsSUhmMU5Q?=
 =?utf-8?B?Z0ZQaDR4TnMrYVA2TG1YeEhmeTRlN214MmpFUHZnbUJ6M0NWNUxCcXg1RjMw?=
 =?utf-8?B?S3F2YmlnZEM0MWV5WlAvTklHUzFndHdyQUludEZCUVlhankzOGg1dVB1dm55?=
 =?utf-8?B?RVlsMkxZWEFLaVVGYjhuNjVtM2hEZ3VXYnRScjVDV01CQnoxTFhrYTVWQWY4?=
 =?utf-8?B?eExuNTArdTZFNThZTU1uRFl6V1phQ2FRWlpLckNTcmZ1bUZCc1V4T0tPRENM?=
 =?utf-8?B?MHZKNi9NMlM5UTBGREtYeVJmWXg5OTVCUll1bTNZTUZYNGlMYy82SWo1ZG5w?=
 =?utf-8?B?ZERJa1hkT04vNitKZ2RHNjcyUmtmSklZRlprVnVRNjAvaTZpL2lDQzlzREd5?=
 =?utf-8?B?UnU5NjUvV0lhTExEclYrbXZ5OUNLb2JkL0VRQ25HbTVGRzlTTnY1NGFaZUxi?=
 =?utf-8?B?YSt4ZTZ5Z1dSdXoxNVhwOXdZS3ZZNloycWdBWGI0QjdDbXlNVWMwOS9qNTFP?=
 =?utf-8?B?OXFCR0xoMWViTjdUbW9QVTF5c3k4aXptK2RobUtvL2crS2RFVERjZWNjc1gy?=
 =?utf-8?B?dkNkSzJrWHpDMlhhQXhhSmwwR2I5b215L2ErTmFUdU9KYWhGM2t4MVZYUkxR?=
 =?utf-8?B?ZDduaDJndGFXOWtEelMzZTBkcmMwc2F6ZUh4OHpOOWpvYlgvcGZaUW5PWDdy?=
 =?utf-8?B?dG1RK3FnYXY1YzltTWtIVzNpVEZEOXJHTEF3MkhqaG00eTJjVy9PQjNSMjlG?=
 =?utf-8?B?Z0JjMjMvcm1rUFlESXdGcjZzUXhWL2s0elp6NnlNVVhjcitDMDgwcmJaZjNX?=
 =?utf-8?B?azhkejhjbk1OVnJ1d3NzcHVoUGNiWUpWU2xHd2libEllQ2JjVUJyRGhMUG13?=
 =?utf-8?B?am00UklrRWl5aXRDQWpCcGlwTUJCOFcxVnV3N3Nhb1l5NFZBNUoydTdpVTd5?=
 =?utf-8?B?a2RMNDFkUWY4cThqeTF6SUsvVVFOVkt1WHNPTzI0Qjl6b05sWkRzTnBaRXlB?=
 =?utf-8?B?NUtJOTNkYmlnMUh0a3ZLZzI3VDBpUUtmbUcveXJSS1kyalpleGRaQ2pTSFNC?=
 =?utf-8?B?T2Y4NHU3RTh4dEtMMjVBODJoMHpVdTNGNTh4MDREbDJTUVhVYjlld3R0T0o5?=
 =?utf-8?B?Rlp0WGd4ck5KY0poTDFwbmdQa01EOUN6Y0RXVXB6YXZLZ21zV0NXaVF3ZEdx?=
 =?utf-8?B?Y2V4MU1FeGlXbTY1RFdnNGhBV2xQWlQwaDQ1SFNtNktWY3FRWjkvZUEveUhO?=
 =?utf-8?B?a2ozWXlnV1B2MmlmTVFBL3FZVEFzYlpjNC9lQTlma0JWTnBvSjh5ZmgzSGpE?=
 =?utf-8?B?UGVRRG1vQXA4VzVRczBJOHZUd254Y3NPOGI2K1V3VHR3aDRwYi91TWZoQkpK?=
 =?utf-8?B?K2RXOFpYMjZjSUJzTDFTcnpNczNnMW5qcmZ0M3lFRmpHeEFhOHFDSHJLNkRF?=
 =?utf-8?B?RmFlU1ZDYlVSNWkwVXVGUWFHa1o2Mkw4OUdnclFBTFJ1QmhnZFJlL0xkWjRt?=
 =?utf-8?B?L1k2U01wcnRZcnNORlRWUEI5d3VYT3YyUXBtWkMzaFhDMjRRS2Vya253eG8x?=
 =?utf-8?B?Y2h6VmVOVnZVbVFXNDNMbUhUREYxaVBScDhqZ3VjVWdzMjdTcmR1NWpGV09o?=
 =?utf-8?B?WktFRS9Lek1IS1hOUE9PV0I0SGRrVVcwRzVCMGRJL0FWWmoxYllOelNNQ0JJ?=
 =?utf-8?B?MjJBci9CUUEwMTByNkpzRTFTVnl3K2dIdDhaN0pYUW5zdVJUc0FWVVd3U3pL?=
 =?utf-8?B?TmVOWDFkSzNqSlFCTXlpUDlIeFpyYUZWenVSSCtlTGdGcXM2bDdqdGJ2ZkUz?=
 =?utf-8?B?THFZdTgzMnRaUWtJVmRHVUtsMVJ0aXpvK21OWjg4aGtOK3hKZThsdXBMT0d0?=
 =?utf-8?B?NGtEMVRxc0xyYXVtYmdKYUVLSXNmMUlGMVpUTmhpSXVYa29uZTYvWCtRblk3?=
 =?utf-8?B?WWdUT1hta3luQXhTY1BCWTFadWxYQWVTR3g0NmJqVjl3SFJWZW5vR1R1WWxt?=
 =?utf-8?B?TlNhblJ2emN5ZE50VU5xcVRPK3MvdTJsMHJISWszRVhlZEZOZTNhOVlxRVBC?=
 =?utf-8?B?NU1Qa0ovQmxNMEFZVldYSTNDOGpnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a817565-2b43-40cf-e2ca-08d99d2237a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 10:27:33.6004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZR7YE1Ijd5MK6xj5fDHTEsqQclC4PwUyZN2DuKESFh3dxArvQ3iZvtF9WeXtncBSuqZFPlYQHEv5/6H5+d2rKfilCHv2T7zu1PzI5N4K70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMSwgMjAyMSA2OjA3IFBNLCBPeiBTaGxvbW8gd3JvdGU6DQo+T24gMTEvMS8y
MDIxIDQ6MzAgQU0sIEJhb3dlbiBaaGVuZyB3cm90ZToNCj4+IE9uIDEwLzMxLzIwMjEgNTo1MCBQ
TSwgT3ogU2hsb21vIHdyb3RlOg0KPj4+IE9uIDEwLzI4LzIwMjEgMjowNiBQTSwgU2ltb24gSG9y
bWFuIHdyb3RlOg0KPj4+PiBGcm9tOiBCYW93ZW4gWmhlbmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2lu
ZS5jb20+DQo+Pj4+DQo+Pj4+IFVzZSBmbG93X2luZHJfZGV2X3JlZ2lzdGVyL2Zsb3dfaW5kcl9k
ZXZfc2V0dXBfb2ZmbG9hZCB0byBvZmZsb2FkIHRjDQo+Pj4+IGFjdGlvbi4NCj4+Pg0KPj4+IEhv
dyB3aWxsIGRldmljZSBkcml2ZXJzIHJlZmVyZW5jZSB0aGUgb2ZmbG9hZGVkIGFjdGlvbnMgd2hl
bg0KPj4+IG9mZmxvYWRpbmcgYSBmbG93Pw0KPj4+IFBlcmhhcHMgdGhlIGZsb3dfYWN0aW9uX2Vu
dHJ5IHN0cnVjdHVyZSBzaG91bGQgYWxzbyBpbmNsdWRlIHRoZSBhY3Rpb24NCj5pbmRleC4NCj4+
Pg0KPj4gV2UgaGF2ZSBzZXQgYWN0aW9uIGluZGV4IGluIGZsb3dfb2ZmbG9hZF9hY3Rpb24gdG8g
b2ZmbG9hZCB0aGUgYWN0aW9uLCBhbHNvDQo+dGhlcmUgYXJlID4gYWxyZWFkeSBzb21lIGFjdGlv
bnMgaW4gZmxvd19hY3Rpb25fZW50cnkgaW5jbHVkZSBpbmRleCB3aGljaCB3ZQ0KPndhbnQgdG8g
b2ZmbG9hZC4NCj4+IElmIHRoZSBkcml2ZXIgd2FudHMgdG8gc3VwcG9ydCBhY3Rpb24gdGhhdCBu
ZWVkcyBpbmRleCwgSSB0aGluayBpdCBjYW4NCj4+IGFkZCB0aGUgaW5kZXggbGF0ZXIsIGl0IG1h
eSBub3QgaW5jbHVkZSBpbiB0aGlzIHBhdGNoLCBXRFlUPw0KPg0KPldoYXQgZG8geW91IG1lYW4g
YnkgImFjdGlvbiB0aGF0IG5lZWRzIGluZGV4Ij8NCj4NCj5DdXJyZW50bHkgb25seSB0aGUgcG9s
aWNlIGFuZCBnYXRlIGFjdGlvbnMgaGF2ZSBhbiBhY3Rpb24gaW5kZXggcGFyYW1ldGVyLg0KPkhv
d2V2ZXIsIHdpdGggdGhpcyBzZXJpZXMgdGhlIHVzZXIgY2FuIGNyZWF0ZSBhbnkgYWN0aW9uIHVz
aW5nIHRoZSB0YyBhY3Rpb24gQVBJDQo+YW5kIHRoZW4gcmVmZXJlbmNlIGl0IGZyb20gYW55IGZp
bHRlci4NCj5EbyB5b3Ugc2VlIGEgcmVhc29uIG5vdCB0byBleHBvc2UgdGhlIGFjdGlvbiBpbmRl
eCBhcyBhIGZsb3dfYWN0aW9uX2VudHJ5DQo+YXR0cmlidXRlPw0KV2hhdCBJIG1lYW4gaXMgY3Vy
cmVudGx5IHRoZSBhY3Rpb24gaXMgY3JlYXRlZCBhbG9uZyB3aXRoIHRoZSBmaWx0ZXIsIHRoZW4g
dGhlIGluZGV4IGlzIG5vdCBuZWVkZWQuDQpXaXRoIHRoaXMgcGF0Y2gsIHdlIGludGVuZCB0byBv
ZmZsb2FkIHRoZSBwb2xpY2UgYWN0aW9uIHdoaWNoIGFscmVhZHkgaW5jbHVkZXMgYWN0aW9uIGlu
ZGV4LiANCkkgdGhpbmsgeW91ciBzdWdnZXN0aW9uIG1ha2VzIHNlbnNlIHRvIHVzLCB3ZSB3aWxs
IGNvbnNpZGVyIHRvIG1vdmUgdGhlIGluZGV4IHRvIHRoZQ0KZmxvd19hY3Rpb25fZW50cnkgc3Ry
dWN0dXJlIGluc3RlYWQgb2YgY3VycmVudCBpbiBzaW5nbGUgYWN0aW9uIHN0cnVjdHVyZSwgdGhh
bmtzLg0KPj4+Pg0KPj4+PiBXZSBuZWVkIHRvIGNhbGwgdGNfY2xlYW51cF9mbG93X2FjdGlvbiB0
byBjbGVhbiB1cCB0YyBhY3Rpb24gZW50cnkNCj4+Pj4gc2luY2UgaW4gdGNfc2V0dXBfYWN0aW9u
LCBzb21lIGFjdGlvbnMgbWF5IGhvbGQgZGV2IHJlZmNudCwgZXNwZWNpYWxseQ0KPj4+PiB0aGUg
bWlycm9yIGFjdGlvbi4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogQmFvd2VuIFpoZW5nIDxi
YW93ZW4uemhlbmdAY29yaWdpbmUuY29tPg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBMb3VpcyBQZWVu
cyA8bG91aXMucGVlbnNAY29yaWdpbmUuY29tPg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBTaW1vbiBI
b3JtYW4gPHNpbW9uLmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgICBpbmNs
dWRlL2xpbnV4L25ldGRldmljZS5oICB8ICAgMSArDQo+Pj4+ICAgIGluY2x1ZGUvbmV0L2FjdF9h
cGkuaCAgICAgIHwgICAyICstDQo+Pj4+ICAgIGluY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oIHwg
IDE3ICsrKysNCj4+Pj4gICAgaW5jbHVkZS9uZXQvcGt0X2Nscy5oICAgICAgfCAgMTUgKysrKw0K
Pj4+PiAgICBuZXQvY29yZS9mbG93X29mZmxvYWQuYyAgICB8ICA0MyArKysrKysrKy0tDQo+Pj4+
ICAgIG5ldC9zY2hlZC9hY3RfYXBpLmMgICAgICAgIHwgMTY2DQo+KysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPj4+PiAgICBuZXQvc2NoZWQvY2xzX2FwaS5jICAgICAgICB8
ICAyOSArKysrKystDQo+Pj4+ICAgIDcgZmlsZXMgY2hhbmdlZCwgMjYwIGluc2VydGlvbnMoKyks
IDEzIGRlbGV0aW9ucygtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9u
ZXRkZXZpY2UuaCBiL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgNCj4+Pj4gaW5kZXggM2VjNDI0
OTVhNDNhLi45ODE1YzNhMDU4ZTkgMTAwNjQ0DQo+Pj4+IC0tLSBhL2luY2x1ZGUvbGludXgvbmV0
ZGV2aWNlLmgNCj4+Pj4gKysrIGIvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPj4+PiBAQCAt
OTE2LDYgKzkxNiw3IEBAIGVudW0gdGNfc2V0dXBfdHlwZSB7DQo+Pj4+ICAgIAlUQ19TRVRVUF9R
RElTQ19UQkYsDQo+Pj4+ICAgIAlUQ19TRVRVUF9RRElTQ19GSUZPLA0KPj4+PiAgICAJVENfU0VU
VVBfUURJU0NfSFRCLA0KPj4+PiArCVRDX1NFVFVQX0FDVCwNCj4+Pj4gICAgfTsNCj4+Pj4NCi4u
Lg0KPj4+PiAgICBpbnQgdGNmX2FjdGlvbl9pbml0KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRj
Zl9wcm90byAqdHAsIHN0cnVjdA0KPj4+PiBubGF0dHIgKm5sYSwgQEAgLTExMDMsNiArMTI2Nyw4
IEBAIGludCB0Y2ZfYWN0aW9uX2luaXQoc3RydWN0IG5ldCAqbmV0LA0KPj4+IHN0cnVjdCB0Y2Zf
cHJvdG8gKnRwLCBzdHJ1Y3QgbmxhdHRyICpubGEsDQo+Pj4+ICAgIAkJc3ogKz0gdGNmX2FjdGlv
bl9maWxsX3NpemUoYWN0KTsNCj4+Pj4gICAgCQkvKiBTdGFydCBmcm9tIGluZGV4IDAgKi8NCj4+
Pj4gICAgCQlhY3Rpb25zW2kgLSAxXSA9IGFjdDsNCj4+Pj4gKwkJaWYgKCEoZmxhZ3MgJiBUQ0Ff
QUNUX0ZMQUdTX0JJTkQpKQ0KPj4+PiArCQkJdGNmX2FjdGlvbl9vZmZsb2FkX2FkZChhY3QsIGV4
dGFjayk7DQo+Pj4NCj4+PiBXaHkgaXMgdGhpcyByZXN0cmljdGVkIHRvIGFjdGlvbnMgY3JlYXRl
ZCB3aXRob3V0IHRoZQ0KPlRDQV9BQ1RfRkxBR1NfQklORA0KPj4+IGZsYWc/DQo+Pj4gSG93IGFy
ZSBhY3Rpb25zIGluc3RhbnRpYXRlZCBieSB0aGUgZmlsdGVycyBkaWZmZXJlbnQgZnJvbSB0aG9z
ZSB0aGF0IGFyZQ0KPj4+IGNyZWF0ZWQgYnkgInRjIGFjdGlvbnMiPw0KPj4+DQo+PiBPdXIgcGF0
Y2ggYWltcyB0byBvZmZsb2FkIHRjIGFjdGlvbiB0aGF0IGlzIGNyZWF0ZWQgaW5kZXBlbmRlbnQg
b2YgYW55IGZsb3cuDQo+SXQgaXMgdXN1YWxseQ0KPj4gb2ZmbG9hZGVkIHdoZW4gaXQgaXMgYWRk
ZWQgb3IgcmVwbGFjZWQuDQo+PiBUaGlzIHBhdGNoIGlzIHRvIGltcGxlbWVudCBhIHByb2Nlc3Mg
b2YgcmVvZmZsb2FkaW5nIHRoZSBhY3Rpb25zIHdoZW4gZHJpdmVyDQo+aXMNCj4+IGluc2VydGVk
IG9yIHJlbW92ZWQsIHNvIGl0IHdpbGwgc3RpbGwgb2ZmbG9hZCB0aGUgaW5kZXBlbmRlbnQgYWN0
aW9ucy4NCj4NCj5JIHNlZS4NCj4NCj4+Pj4gICAgCX0NCj4+Pj4NCj4+Pj4gICAgCS8qIFdlIGhh
dmUgdG8gY29tbWl0IHRoZW0gYWxsIHRvZ2V0aGVyLCBiZWNhdXNlIGlmIGFueSBlcnJvcg0KPj4+
PiBoYXBwZW5lZCBpbiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc19hcGkuYyBiL25ldC9zY2hl
ZC9jbHNfYXBpLmMNCj4+Pj4gaW5kZXggMmVmOGY1YTYyMDVhLi4zNTFkOTM5ODhiOGIgMTAwNjQ0
DQo+Pj4+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4+Pj4gKysrIGIvbmV0L3NjaGVkL2Ns
c19hcGkuYw0KPj4+PiBAQCAtMzU0NCw4ICszNTQ0LDggQEAgc3RhdGljIGVudW0gZmxvd19hY3Rp
b25faHdfc3RhdHMNCj4+PiB0Y19hY3RfaHdfc3RhdHModTggaHdfc3RhdHMpDQo+Pj4+ICAgIAly
ZXR1cm4gaHdfc3RhdHM7DQo+Pj4+ICAgIH0NCj4+Pj4NCj4+Pj4gLWludCB0Y19zZXR1cF9mbG93
X2FjdGlvbihzdHJ1Y3QgZmxvd19hY3Rpb24gKmZsb3dfYWN0aW9uLA0KPj4+PiAtCQkJIGNvbnN0
IHN0cnVjdCB0Y2ZfZXh0cyAqZXh0cykNCj4+Pj4gK2ludCB0Y19zZXR1cF9hY3Rpb24oc3RydWN0
IGZsb3dfYWN0aW9uICpmbG93X2FjdGlvbiwNCj4+Pj4gKwkJICAgIHN0cnVjdCB0Y19hY3Rpb24g
KmFjdGlvbnNbXSkNCj4+Pj4gICAgew0KPj4+PiAgICAJc3RydWN0IHRjX2FjdGlvbiAqYWN0Ow0K
Pj4+PiAgICAJaW50IGksIGosIGssIGVyciA9IDA7DQo+Pj4+IEBAIC0zNTU0LDExICszNTU0LDEx
IEBAIGludCB0Y19zZXR1cF9mbG93X2FjdGlvbihzdHJ1Y3QgZmxvd19hY3Rpb24NCj4+PiAqZmxv
d19hY3Rpb24sDQo+Pj4+ICAgIAlCVUlMRF9CVUdfT04oVENBX0FDVF9IV19TVEFUU19JTU1FRElB
VEUgIT0NCj4+PiBGTE9XX0FDVElPTl9IV19TVEFUU19JTU1FRElBVEUpOw0KPj4+PiAgICAJQlVJ
TERfQlVHX09OKFRDQV9BQ1RfSFdfU1RBVFNfREVMQVlFRCAhPQ0KPj4+PiBGTE9XX0FDVElPTl9I
V19TVEFUU19ERUxBWUVEKTsNCj4+Pj4NCj4+Pj4gLQlpZiAoIWV4dHMpDQo+Pj4+ICsJaWYgKCFh
Y3Rpb25zKQ0KPj4+PiAgICAJCXJldHVybiAwOw0KPj4+Pg0KPj4+PiAgICAJaiA9IDA7DQo+Pj4+
IC0JdGNmX2V4dHNfZm9yX2VhY2hfYWN0aW9uKGksIGFjdCwgZXh0cykgew0KPj4+PiArCXRjZl9h
Y3RfZm9yX2VhY2hfYWN0aW9uKGksIGFjdCwgYWN0aW9ucykgew0KPj4+PiAgICAJCXN0cnVjdCBm
bG93X2FjdGlvbl9lbnRyeSAqZW50cnk7DQo+Pj4+DQo+Pj4+ICAgIAkJZW50cnkgPSAmZmxvd19h
Y3Rpb24tPmVudHJpZXNbal07DQo+Pj4+IEBAIC0zNzI1LDcgKzM3MjUsMTkgQEAgaW50IHRjX3Nl
dHVwX2Zsb3dfYWN0aW9uKHN0cnVjdCBmbG93X2FjdGlvbg0KPj4+ICpmbG93X2FjdGlvbiwNCj4+
Pj4gICAgCXNwaW5fdW5sb2NrX2JoKCZhY3QtPnRjZmFfbG9jayk7DQo+Pj4+ICAgIAlnb3RvIGVy
cl9vdXQ7DQo+Pj4+ICAgIH0NCj4+Pj4gK0VYUE9SVF9TWU1CT0wodGNfc2V0dXBfYWN0aW9uKTsN
Cj4+Pj4gKw0KPj4+PiArI2lmZGVmIENPTkZJR19ORVRfQ0xTX0FDVA0KPj4+PiAraW50IHRjX3Nl
dHVwX2Zsb3dfYWN0aW9uKHN0cnVjdCBmbG93X2FjdGlvbiAqZmxvd19hY3Rpb24sDQo+Pj4+ICsJ
CQkgY29uc3Qgc3RydWN0IHRjZl9leHRzICpleHRzKQ0KPj4+PiArew0KPj4+PiArCWlmICghZXh0
cykNCj4+Pj4gKwkJcmV0dXJuIDA7DQo+Pj4+ICsNCj4+Pj4gKwlyZXR1cm4gdGNfc2V0dXBfYWN0
aW9uKGZsb3dfYWN0aW9uLCBleHRzLT5hY3Rpb25zKTsgfQ0KPj4+PiAgICBFWFBPUlRfU1lNQk9M
KHRjX3NldHVwX2Zsb3dfYWN0aW9uKTsNCj4+Pj4gKyNlbmRpZg0KPj4+Pg0KPj4+PiAgICB1bnNp
Z25lZCBpbnQgdGNmX2V4dHNfbnVtX2FjdGlvbnMoc3RydWN0IHRjZl9leHRzICpleHRzKQ0KPj4+
PiAgICB7DQo+Pj4+IEBAIC0zNzQzLDYgKzM3NTUsMTUgQEAgdW5zaWduZWQgaW50IHRjZl9leHRz
X251bV9hY3Rpb25zKHN0cnVjdA0KPj4+IHRjZl9leHRzICpleHRzKQ0KPj4+PiAgICB9DQo+Pj4+
ICAgIEVYUE9SVF9TWU1CT0wodGNmX2V4dHNfbnVtX2FjdGlvbnMpOw0KPj4+Pg0KPj4+PiArdW5z
aWduZWQgaW50IHRjZl9hY3RfbnVtX2FjdGlvbnNfc2luZ2xlKHN0cnVjdCB0Y19hY3Rpb24gKmFj
dCkgew0KPj4+PiArCWlmIChpc190Y2ZfcGVkaXQoYWN0KSkNCj4+Pj4gKwkJcmV0dXJuIHRjZl9w
ZWRpdF9ua2V5cyhhY3QpOw0KPj4+PiArCWVsc2UNCj4+Pj4gKwkJcmV0dXJuIDE7DQo+Pj4+ICt9
DQo+Pj4+ICtFWFBPUlRfU1lNQk9MKHRjZl9hY3RfbnVtX2FjdGlvbnNfc2luZ2xlKTsNCj4+Pj4g
Kw0KPj4+PiAgICAjaWZkZWYgQ09ORklHX05FVF9DTFNfQUNUDQo+Pj4+ICAgIHN0YXRpYyBpbnQg
dGNmX3FldmVudF9wYXJzZV9ibG9ja19pbmRleChzdHJ1Y3QgbmxhdHRyICpibG9ja19pbmRleF9h
dHRyLA0KPj4+PiAgICAJCQkJCXUzMiAqcF9ibG9ja19pbmRleCwNCj4+Pj4NCg==
