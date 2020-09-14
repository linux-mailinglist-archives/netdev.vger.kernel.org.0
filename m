Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F92F2695B4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgINTfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:35:11 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10582 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgINTfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 15:35:05 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5fc5db000a>; Mon, 14 Sep 2020 12:34:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 12:35:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 14 Sep 2020 12:35:05 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 19:33:09 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 19:33:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPb3A1isGx/EBrcUlCLnNEQtRYd64n/8PHTWB1fR89DwB03uNEXZVMV0xxzW8IJ6hoOOAM9X/9QEQW+TxmSYPnrQMLA0oPny/l25AkQ/fKUJxQSfW4SOsA+spa+OuucwUhvV2IgtejTRNt7ZSm60fNDghFDNvQtCukl+IzYY3DafJ4jlDWv+TlhhuxtnklA5aW1nDRREPjHLeF3UgLvMAZbpU6e8Zu8n5iDsd4S5Gx1Q621Sq1hG0eWXUKVx+Rn3rBoCjRdzaeKUWFs+jD47CLxv3g4YjNnJmN7lecdDTLu5n8G26P8h3vxNK3T66i/qwGTVH03yXy5dexapxnETYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPtm8j6LESMxjrNlmpVcDWnx+DjEyHNCOPejP972ufs=;
 b=JVOWpBUcgMqxCFP0kQzxBR2Aziy5uih4lFVWFYUp+jqAC4uo5+CMAAUGGeIctD7SU96WldKy2VH/oI0EEe7H5GawhFfhbOtNosBu72WwMXw7ni/DHa331HTWAfPJK+03Hi/KweURK9KkwpZB0rH9dph8yD7qelLS8z9C1egZ2lkh6HXzu5fdUtKFmlvTTfR0oTguEHwLskz5ugErq5YG5XWjama/ht/hNWB8SVV1SSlUbSoq5GYqjiBKfY9pNO520wKmQbcM+2tt+2phqJtUOM6/W5qgmJf/QmTWSjLoQZRCt2tUGKAEuKA/rugMKO40RIUo5zrouV0I9fjrIBMQBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4725.namprd12.prod.outlook.com (2603:10b6:a03:a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Mon, 14 Sep
 2020 19:33:08 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 19:33:08 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Tariq Toukan <tariqt@nvidia.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/8] docs: net: include the new ethtool pause
 stats in the stats doc
Thread-Topic: [PATCH net-next v2 2/8] docs: net: include the new ethtool pause
 stats in the stats doc
Thread-Index: AQHWiJNXEgM4oiMb8UeBzJO0n0/JmKloio8A
Date:   Mon, 14 Sep 2020 19:33:08 +0000
Message-ID: <1ee0f0af5fc15236689028a95ea25082138a6ebd.camel@nvidia.com>
References: <20200911232853.1072362-1-kuba@kernel.org>
         <20200911232853.1072362-3-kuba@kernel.org>
In-Reply-To: <20200911232853.1072362-3-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c399e40-f1d2-4005-be63-08d858e5025a
x-ms-traffictypediagnostic: BYAPR12MB4725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB4725A22F227E86F3101C9711B3230@BYAPR12MB4725.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hshcCuKJzy5GJGX9IRGScABaSMvSQsiszrbKfd8KFsWlRnGCwAqFl2iD8FSdQUO3xLSWupwzoy694NPtuqtCFVPDW/78z0jk2wkke99Otscoan/j4AJ3WS+doNojQpSGIZ7MS/bJB4NqmIcxYFsxeuisQtlSRjPmiJ56NVkmkp0jU3oA9fzStRVH07SySbAnp54w5HmGQU22FHhyhXxvGZgfN9A2YdTpON5w493PE+7GnIx3j3/HgMUhNE5jwbNTm1JMiBLjmCUMoabFU6qoeUUfn70yOEtlWLJPmPNhyezkQVwnYCoXVK4cBXP32Tvr3KY/hQzTUFvnQPCgU0s5LQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(4326008)(71200400001)(64756008)(66446008)(478600001)(54906003)(83380400001)(2906002)(2616005)(110136005)(6486002)(36756003)(76116006)(316002)(8676002)(6506007)(66946007)(86362001)(26005)(6512007)(5660300002)(186003)(66476007)(8936002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Yd2+PKJR6sI8RgT48Vp1DXEXM9Kca1HfwDYJR4Q4nxYRIVAm67bcv1THjcBrIsAKSvzaL31mUvUSLJxpV8CO0kJnCcTV023w3mDwxtyt0tWsYqsteWb5DJnpfKLucf/0XIN7u2sv5aLDu4GVEhlTzqWFcOf2eSYnOVQK4uqKJ4ad/fQ3mK0MwNadsoBZD6HeEa8KL59YAs2C7nB7NTirdPMOrIPeg9/9AVqUQ2gteclcQOmJK1XCmOBws0cfPHFtI0L1r6jXA2aHZLYUl0BswIGiSjZvdAkW7x6hcr0MsKxt4J/5M9l4a2I43B6pFEs81O14WySrIyuKlOFRqm7hXo2UHDayQmC5Q/GCZtQUjTYOU2qany9vDHQgcZt3+nMPhqVdSivo4vhV70E9B+xz2jmkW6u8cnRsViRIMRuxe1AXuJeX5SRHr9GyE8OlQ4K2Z1OsCOTdPjCu7QZ/HcQGl3xLNJ45qGNCVXnWzjGcQFR2JePocZ4t+QPf32SLZ3YMzUvWdoYJtqWljuiN1ZFOPBqvBlU4TPYKeYxltaXcHWOCRLignHs7/y/YYpEUuZGrygLgVCdOhS2ocgVqvifhzTWduelHJmbaYtqz+bYjjzzPoA6rqwQXEsxj7ja4IllpWyOI4Hk2mnuABS2QUUkjbw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD61EE270998F74693F0659B29BC1727@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c399e40-f1d2-4005-be63-08d858e5025a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 19:33:08.1767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3gesoEJm0eNcm0L2m2i5AZPdmGxkYsm6BpzcxkUArx7MElLfJI9UqbaIH0higXtn3iIPQrUrmmy9ZUiQN8O3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4725
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600112092; bh=FPtm8j6LESMxjrNlmpVcDWnx+DjEyHNCOPejP972ufs=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=iW65XtXZGAqxfVIFJe/COWm4t9PWFfZ1v5GeGNEgxJNpsgnlRS1uJxhf3b2Ms67Ul
         sTeN7f476GNRFavUdfk3TcwgWkmRxXZum5G406SYKB59LiXNZ3qOi7doMFZD2EOK55
         gvSW7D1sttvsgh+8xS8Kzhh5hx8rxOJ49zIJu7O0Hj4UApJqFbKtlvx3tzmH50/9AX
         Rp3BwlELwI1MMIpWHZQXvc78soXaETIDfuIeuPSU4IKU/ZOHrdYdbUSNQtvvygKnOr
         +Rti/DahQALhjlvyQE2l+06eHPbyH5IYNk+f3gMb6SlkZy/Nc8VF0YEjHS0QZz+OOg
         ibXtJOgCdzgpQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTExIGF0IDE2OjI4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVGVsbCBwZW9wbGUgdGhhdCB0aGVyZSBub3cgaXMgYW4gaW50ZXJmYWNlIGZvciBxdWVyeWlu
ZyBwYXVzZSBmcmFtZXMuDQo+IEEgbGl0dGxlIGJpdCBvZiByZXN0cnVjdHVyaW5nIGlzIG5lZWRl
ZCBnaXZlbiB0aGlzIGlzIGEgZmlyc3Qgc291cmNlDQo+IG9mIHN1Y2ggc3RhdGlzdGljcy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IC0t
LQ0KPiAgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3N0YXRpc3RpY3MucnN0IHwgNTcgKysrKysr
KysrKysrKysrKysrKysrKy0NCj4gLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA1MiBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbmV0
d29ya2luZy9zdGF0aXN0aWNzLnJzdA0KPiBiL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9zdGF0
aXN0aWNzLnJzdA0KPiBpbmRleCBkNDkwYjUzNWNkMTQuLjhlMTViYzk4ODMwYiAxMDA2NDQNCj4g
LS0tIGEvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3N0YXRpc3RpY3MucnN0DQo+ICsrKyBiL0Rv
Y3VtZW50YXRpb24vbmV0d29ya2luZy9zdGF0aXN0aWNzLnJzdA0KPiBAQCAtNCwxNiArNCwyMyBA
QA0KPiAgSW50ZXJmYWNlIHN0YXRpc3RpY3MNCj4gID09PT09PT09PT09PT09PT09PT09DQo+ICAN
Cj4gK092ZXJ2aWV3DQo+ICs9PT09PT09PQ0KPiArDQo+ICBUaGlzIGRvY3VtZW50IGlzIGEgZ3Vp
ZGUgdG8gTGludXggbmV0d29yayBpbnRlcmZhY2Ugc3RhdGlzdGljcy4NCj4gIA0KPiAtVGhlcmUg
YXJlIHR3byBtYWluIHNvdXJjZXMgb2YgaW50ZXJmYWNlIHN0YXRpc3RpY3MgaW4gTGludXg6DQo+
ICtUaGVyZSBhcmUgdGhyZWUgbWFpbiBzb3VyY2VzIG9mIGludGVyZmFjZSBzdGF0aXN0aWNzIGlu
IExpbnV4Og0KPiAgDQo+ICAgLSBzdGFuZGFyZCBpbnRlcmZhY2Ugc3RhdGlzdGljcyBiYXNlZCBv
bg0KPiAtICAgOmM6dHlwZTpgc3RydWN0IHJ0bmxfbGlua19zdGF0czY0IDxydG5sX2xpbmtfc3Rh
dHM2ND5gOyBhbmQNCj4gKyAgIDpjOnR5cGU6YHN0cnVjdCBydG5sX2xpbmtfc3RhdHM2NCA8cnRu
bF9saW5rX3N0YXRzNjQ+YDsNCj4gKyAtIHByb3RvY29sLXNwZWNpZmljIHN0YXRpc3RpY3M7IGFu
ZA0KPiAgIC0gZHJpdmVyLWRlZmluZWQgc3RhdGlzdGljcyBhdmFpbGFibGUgdmlhIGV0aHRvb2wu
DQo+ICANCj4gLVRoZXJlIGFyZSBtdWx0aXBsZSBpbnRlcmZhY2VzIHRvIHJlYWNoIHRoZSBmb3Jt
ZXIuIE1vc3QgY29tbW9ubHkNCj4gdXNlZA0KPiAtaXMgdGhlIGBpcGAgY29tbWFuZCBmcm9tIGBp
cHJvdXRlMmA6Og0KPiArU3RhbmRhcmQgaW50ZXJmYWNlIHN0YXRpc3RpY3MNCj4gKy0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICsNCj4gK1RoZXJlIGFyZSBtdWx0aXBsZSBpbnRlcmZh
Y2VzIHRvIHJlYWNoIHRoZSBzdGFuZGFyZCBzdGF0aXN0aWNzLg0KPiArTW9zdCBjb21tb25seSB1
c2VkIGlzIHRoZSBgaXBgIGNvbW1hbmQgZnJvbSBgaXByb3V0ZTJgOjoNCj4gIA0KPiAgICAkIGlw
IC1zIC1zIGxpbmsgc2hvdyBkZXYgZW5zNHUxdTENCj4gICAgNjogZW5zNHUxdTE6IDxCUk9BRENB
U1QsTVVMVElDQVNULFVQLExPV0VSX1VQPiBtdHUgMTUwMCBxZGlzYw0KPiBmcV9jb2RlbCBzdGF0
ZSBVUCBtb2RlIERFRkFVTFQgZ3JvdXAgZGVmYXVsdCBxbGVuIDEwMDANCj4gQEAgLTM0LDcgKzQx
LDI2IEBAIElmIGAtc2AgaXMgc3BlY2lmaWVkIG9uY2UgdGhlIGRldGFpbGVkIGVycm9ycw0KPiB3
b24ndCBiZSBzaG93bi4NCj4gIA0KPiAgYGlwYCBzdXBwb3J0cyBKU09OIGZvcm1hdHRpbmcgdmlh
IHRoZSBgLWpgIG9wdGlvbi4NCj4gIA0KPiAtRXRodG9vbCBzdGF0aXN0aWNzIGNhbiBiZSBkdW1w
ZWQgdXNpbmcgYGV0aHRvb2wgLVMgJGlmY2AsIGUuZy46Og0KPiArUHJvdG9jb2wtc3BlY2lmaWMg
c3RhdGlzdGljcw0KPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ICtTb21l
IG9mIHRoZSBpbnRlcmZhY2VzIHVzZWQgZm9yIGNvbmZpZ3VyaW5nIGRldmljZXMgYXJlIGFsc28g
YWJsZQ0KPiArdG8gcmVwb3J0IHJlbGF0ZWQgc3RhdGlzdGljcy4gRm9yIGV4YW1wbGUgZXRodG9v
bCBpbnRlcmZhY2UgdXNlZA0KPiArdG8gY29uZmlndXJlIHBhdXNlIGZyYW1lcyBjYW4gcmVwb3J0
IGNvcnJlc3BvbmRpbmcgaGFyZHdhcmUNCj4gY291bnRlcnM6Og0KPiArDQo+ICsgICQgZXRodG9v
bCAtLWluY2x1ZGUtc3RhdGlzdGljcyAtYSBldGgwDQo+ICsgIFBhdXNlIHBhcmFtZXRlcnMgZm9y
IGV0aDA6DQo+ICsgIEF1dG9uZWdvdGlhdGU6CW9uDQo+ICsgIFJYOgkJCW9uDQo+ICsgIFRYOgkJ
CW9uDQo+ICsgIFN0YXRpc3RpY3M6DQo+ICsgICAgdHhfcGF1c2VfZnJhbWVzOiAxDQo+ICsgICAg
cnhfcGF1c2VfZnJhbWVzOiAxDQo+ICsNCg0KdGhpcyB3aWxsIHJlcXVpcmUgdG8gYWNjZXNzIHRo
ZSBIVyB0d2ljZSBwZXIgc3RhdHMgcmVxdWVzdCB0byByZWFkIGJvdGgNCnN0YXRzIGFuZCBjdXJy
ZW50IHBhcmFtZXRlcnMsIG1heWJlIHRoaXMgaXMgbm90IGEgYmlnIGRlYWwsIGJ1dCBzaGFycA0K
YWNjdXJhY3kgY2FuIGJlIGltcG9ydGFudCBmb3Igc29tZSBwZXJmb3JtYW5jZSBlbnRodXNpYXN0
cy4NCg0KRG8gd2UgbmVlZCBhbiBBUEkgdGhhdCBvbmx5IHJlcG9ydHMgc3RhdGlzdGljcyB3aXRo
b3V0IHRoZSBjdXJyZW50DQpwYXJhbWV0ZXJzID8NCg0K
