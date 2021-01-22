Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52FF2FFE22
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbhAVI0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:26:46 -0500
Received: from mail-mw2nam12on2067.outbound.protection.outlook.com ([40.107.244.67]:55744
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbhAVIZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 03:25:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnAAE4lcqg5QebitEMg6jtgfgIaaUbS0S3Dt7myE+X4TEuR0IWUooI5QZzFoy9Ik5G5zNCgPuS3RLtK7HlyvhV4s2p6AEjPNe1RX5zSoWJlyuXYVfhLiCFQQnED7zZvf8JxoavqWw0krWWXU9f2fwKszIPtYopS+bwnFgQg4Ox1Ef2Ipmjo1HSSrsm72E5l2gyIAyZgHVPID3rmGc7JBvTLDj/02XsC5y9kYxmCy8T6QW4bEoKJi/eqzneuTMEvQ+N10tDnmx0SquJIKFcLDUkaaCfo24xuBjrbHkr3TGX74IfMh1FqW27jTStSc9cPq9OMoP1AOWRLijRVHq+nA0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57OLQhWQc4sZRU498KR5IZJs+s5QC0WYyQu0XBYK0sE=;
 b=MBGtIWoEW9Xk3SGWpkvD8N+0edSHChJkjXhIZ351KpN+9H0DELIxRy7GAcBtt9M2IYCHAQNPufQ8WJGlPm4LpXD+nkq92MS7kNvSo01Mx9/KUfykZUyarPdG4SXsTlCpVLeq/XN/07K1KvnOmDR8jFE2SKZttXRsj9+M2GywYX1RPtkxO2GNgTczeRDb3JNkCHsKgS32Jo82DPKe5OSphtSADSrhNlc2bnFUgztCXRu6NzFv+qvXyLYbfH0XFvkfhVExAfWR6XB7GlXCOO7eBIGb8yFKHX/cztokTcWl9mu1VBxCz86PsKZp+AnTQw3Zf+wV1G2tsxKv7IZJM2Qw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57OLQhWQc4sZRU498KR5IZJs+s5QC0WYyQu0XBYK0sE=;
 b=qj20pBeHAxGfO7wJWvyNl/UmV5cIuWhIDrQnRY1OfBg/dmlv8jrd0XoiQaLhcUfxqTi1Bmg/uMHYd1PBRq5fy5FHVwonyQSRNf8BBfUVdNT51+Y5QViz98moBCscEkpMJ8NrfaF7fZqt4oZ6qLxkZX6+8Z4jFjlWyr6DDaw2BUo=
Received: from (2603:10b6:a02:fc::24) by
 SJ0PR05MB7739.namprd05.prod.outlook.com (2603:10b6:a03:2e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6; Fri, 22 Jan
 2021 08:24:59 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::5d18:d12d:f88:e695]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::5d18:d12d:f88:e695%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 08:24:59 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vmxnet3: Remove buf_info from device accessible
 structures
Thread-Topic: [PATCH net-next] vmxnet3: Remove buf_info from device accessible
 structures
Thread-Index: AQHW7tLhDzRAxKYQ2USgax8SHBpL0aoy2CaA///0OwA=
Date:   Fri, 22 Jan 2021 08:24:59 +0000
Message-ID: <888F37FB-B8BD-43D8-9E75-4F1CE9D4FAC7@vmware.com>
References: <20210120021941.9655-1-doshir@vmware.com>
 <20210121170705.08ecb23d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121170705.08ecb23d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.40.20081000
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4c00:97e:ed06:21ea:867d:e6c5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aca1b386-5b7e-43d9-3277-08d8beaf3578
x-ms-traffictypediagnostic: SJ0PR05MB7739:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR05MB7739AE0EDC11672E206FCBACA4A09@SJ0PR05MB7739.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: muoPcX/CLRuIHO7CmbtDooGvEm0F2p2c/aF8RT4EEHmXWDJa5m/BnnztKqTI+ZJ53/3z6qOXKvp0zsJba2VCri57spEj0FCQjXeWBVrcTRBTnKBzS2PmVGeS5m+DpDatPQBXodkv/6c6UZ1q3VFMywdlYJLQc25/1G5UpYRXedG0IiHSg7PBeCWbnik21Iy1o5fdviVjgIsL+rZMGG61cBREbO+oATE03+Ln6Ajtdhgai1fLXucrQSj9dQj541PfHrly7xGQUH3Vlu9OHd14nx+MiU8YxGKjmPHQl/vJ+ki1gT5OmwMFEx3I3qrtRw3nwtuNWZMaydVfcaU6VLNnWlodgRAjhdlFeBLOClNIcpoiOEPfNSk27tnE9HCeoKANVG4hgvRn3vI91o7MUeko6pvUC70UL8uG+RN7iSlRAgCkV5978IVvriWhHCbbh9WI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(86362001)(36756003)(76116006)(91956017)(6512007)(4326008)(6506007)(53546011)(2906002)(316002)(478600001)(54906003)(64756008)(33656002)(6486002)(5660300002)(186003)(66946007)(6916009)(71200400001)(8676002)(2616005)(66556008)(83380400001)(4744005)(66446008)(66476007)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Wm9McnM2TXpaYnNicUJsQXE3OEVab09LZXYxUHN5ejZES2FXYWdjTjI3Tzda?=
 =?utf-8?B?QnNhUHArclQyUXI4Y0E5dE9lNlpYYS81bEVYSVdRUndpbzdrUEZpT2ROaHov?=
 =?utf-8?B?ck53bEhaWWl5K2FxNkhVdDUydGN2YWVydVUwRy82SGFKU2l6cU9ma1ZZRGtT?=
 =?utf-8?B?WVpXb0hqQjRRZ2VUN0FOMThKMUswS2oxalU5a3RKZ1NsaUtHYWlpKzlXYXZk?=
 =?utf-8?B?R0hmQWhPR2N2Q1lLY1gvZDJTb2hkOUtNV3pyVVhlZFFlbVc5emlMYTR5OFVU?=
 =?utf-8?B?SVNhUWdOZ2hYYVhoRlowcm9OU0FHZFo4cU82b0JhT25DYkx2TmV4aS8yWnU2?=
 =?utf-8?B?UndUSWQ3VXRkNHNHR3MwdFVaZCtDcStCNTcwQzVzelhpK21aM2JVbTd1RDRa?=
 =?utf-8?B?bXd2dXhiS0k4NzlqRi9JR2FLUzU3K01abVhDTFk2T1RlK00wbHBmQkI0ZEpY?=
 =?utf-8?B?Q1ZyRTdGcGxxZ3VlOUJuTVJnVEU2c1J5TGc3WFg1NUFMYjVwR2dNTCtZSjIv?=
 =?utf-8?B?blR2S1ZSODVTbXErRmwrL1RRcGRTYVlWNEZSbGJZTzVXVE9Xa1hadmRyVWpl?=
 =?utf-8?B?SHhMK2hYdUFBSHVMeHhKSjQ2ZGVkNksvaThnQkFrTzFObStQYWdOcnE4aXlr?=
 =?utf-8?B?djZUYndJQ0Z6bmk1RFp2aVpQMzZ0MFpPcjZ5QU90YVV0TTlya1ZoTVlGSGN3?=
 =?utf-8?B?UkFSaVVwNVRBdWtNbW93WVgyTUZOemRmT2ZDUVAvUXpoN0hMclNCWGZ2cEdm?=
 =?utf-8?B?VEZvLzNJSWFHTGkrN0RxYnFtMi9HcWlUeXZ6WnZLM2tmcmg1Sm5CZUk5LzlG?=
 =?utf-8?B?c2hwampXM0wyZFF6dVBoYVI2YmlMdmh5ZzV6Y2w3VVZtYytIK2NUaW5rUnlh?=
 =?utf-8?B?dHgwMDlZNUNmblJVR3p3QXFoTGJSRGVUL0hBR21mVDE3dUFNNzJoU1VnbGJp?=
 =?utf-8?B?dEJmOUpNYWxCdVFnSlBXalgyQmtkSUMrSFR5ajhjVE5TY0dzb3NGSHV3MXQ3?=
 =?utf-8?B?RXlCNzRGa1NJR0JRVjNNMllqanRyN3I3enE5dXJDdE1meWx1UHQ5aTIzS1RM?=
 =?utf-8?B?VU9maFJZZm4wTTJQOFhvVVFJZ1pldXpsNHRtbGIycEpreGFJS2lHQ1ptaTVR?=
 =?utf-8?B?ZmhHRWdhSlh6QnNTSEdGeTc4WTlQTFozWjNjZWVPekFjc3dBU0prSnFSNzN2?=
 =?utf-8?B?RjZlcHBLU3RBWVZ6TUtjdXZVZ096NHh0MTlQczh1QXNRQ1lSay9hZlNVR3F5?=
 =?utf-8?B?dEQ0OEVSWHlyM0J5OFptWEY2MlIrNU8yQjg2REFheW55THdVbFpYSzZlem84?=
 =?utf-8?B?ZGFLKzJ4b2YvT0ZEUWxPL1BiZUE5Rit5cElvMVcwT2pmalpNUnZyWjF5QmFi?=
 =?utf-8?B?bXphY0lPV1RpMitaeHVBT1VQSEdhWmJ6YWljQTRzcnR1ZUc4ZkFLS3dXVTdD?=
 =?utf-8?B?dGFYVk43S0VqSG5xZ2lwSVpGSytzN3pSSS9OQVpsVnJrQUkxcFZmSHVMSHNp?=
 =?utf-8?B?ZDUrc1ZJL29XQ3JxNlMwUmtOUVlMaHNaSmxBaHEvR3d4cVR4cFJ4MnEyM3FB?=
 =?utf-8?B?QVU3Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72A53382C69E60418ED5FA1AEFE75033@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca1b386-5b7e-43d9-3277-08d8beaf3578
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 08:24:59.4661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CcB5xBoo33lVgQ3yS/8Uuakg6AYjeLufUcFYixNyNaXk1lHDofGkOlhjf/Kd3vSRoGFFY3iBtTVLUP5N2AoV7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7739
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzIxLzIxLCA1OjA3IFBNLCAiSmFrdWIgS2ljaW5za2kiIDxrdWJhQGtlcm5lbC5vcmc+
IHdyb3RlOg0KPiAgT24gVHVlLCAxOSBKYW4gMjAyMSAxODoxOTo0MCAtMDgwMCBSb25hayBEb3No
aSB3cm90ZToNCj4gID4gRnJvbTogUGV0ciBWYW5kcm92ZWMgPHBldHJAdm13YXJlLmNvbT4NCj4g
ID4gDQo+ICA+IHZteG5ldDM6IFJlbW92ZSBidWZfaW5mbyBmcm9tIGRldmljZSBhY2Nlc3NpYmxl
IHN0cnVjdHVyZXMNCj4NCj4gICAgU29tZXRoaW5nIGhhcHBlbmVkIHRvIHRoZSBwb3N0aW5nLCBs
b29rcyBsaWtlIHRoZSBzdWJqZWN0IGlzIGxpc3RlZA0KPiAgIHR3aWNlPw0KSXQgZ290IHNlbnQg
dHdpY2UuIFBsZWFzZSBpZ25vcmUuDQoNCj4gID4gLQlpZiAoIXRxLT5idWZfaW5mbykNCj4gID4g
Kwl0cS0+YnVmX2luZm8gPSBrbWFsbG9jX2FycmF5X25vZGUodHEtPnR4X3Jpbmcuc2l6ZSwgc2l6
ZW9mKHRxLT5idWZfaW5mb1swXSksDQo+ICA+ICsJCQkJCSAgR0ZQX0tFUk5FTCB8IF9fR0ZQX1pF
Uk8sDQo+ICA+ICsJCQkJCSAgZGV2X3RvX25vZGUoJmFkYXB0ZXItPnBkZXYtPmRldikpOw0KPg0K
PiAgIGtjYWxsb2Nfbm9kZSgpDQpTdXJlLCB3aWxsIHVzZSB0aGlzIGNhbGxiYWNrLg0KDQo+ICA+
ICsJaWYgKCF0cS0+YnVmX2luZm8pIHsNCj4gID4gKwkJbmV0ZGV2X2VycihhZGFwdGVyLT5uZXRk
ZXYsICJmYWlsZWQgdG8gYWxsb2NhdGUgdHggYnVmZmVyIGluZm9cbiIpDQo+DQo+IFBsZWFzZSBk
cm9wIHRoZSBtZXNzYWdlLCBPT00gc3BsYXQgd2lsbCBiZSB2aXNpYmxlIGVub3VnaC4gY2hlY2tw
YXRjaA0KPiB1c3VhbGx5IHBvaW50cyB0aGlzIG91dA0KDQpPa2F5LCB3aWxsIGRyb3AgaXQuIENo
ZWNrcGF0Y2ggZGlkIG5vdCBjb21wbGFpbiBhYm91dCB0aGUgZXJyb3IgbWVzc2FnZSB0aG91Z2gu
DQoNClRoYW5rcywNClJvbmFrDQoNCg==
