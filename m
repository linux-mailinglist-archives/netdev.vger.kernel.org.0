Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD78013BF57
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgAOMMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:54 -0500
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:25921
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbgAOMMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSEiceMOmW3KCumByskhGJ4XNqNs27PFytLrEKQQ5CIgTPo3SjolX1VSq0moGeEaK8wYKDucZXJxS8byZVMgFAoHDIyRQUnm+77XD6uMRjWcIggXQ4SV0CDJRTfzXgpCjNH4XaTlMV8y/aEzKxJwQVtCnCrniQu0aehBIS/6mRMQvbo21bRcQAvOplrSRRY6MVBv9l/B/FAi1ZFYk4yJeWcunom7tAdtt/uqyE0PvxlLnKBeqUrQ1+5YzODiGI5y867Wp99vMoiQ0hBIBSFDc2S28B53X8ulcrElVkdgwBhnJVDbrw0z36rcuQfXspsuJYkJayoceNqttD97QjzGVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkPBTof0cTcLxzfDeiNiJ0va31UOcbnIUlWzqHwtwII=;
 b=Vfpr257m51KDPAKtyX5dnM784WRxOBwt185UBCk5T4Z4rVl9s2wkJNrz2+ElVeLd/0I6/jittA6Ve8l8pcJGsz3frrKR5y3HU+JBosTshObu6TwIiD1dEaJ3hVY6hJByc7aeqJ81KEy8mvm9vYUb1PiG6HiZIt9O8cBhgNJGdqMEa/Sm4tjVS6GD4D6+TRNOq1z+68LBs65pOw7W3sV9p8ks+eXQ77Aj6bNFVRwg1GD/K3gsxyudx0jRxyyniyuTsvhaR4yFPxmFYJTap+5ipODNtZ2hJCyw84k4C4+AlTc5TZ1hYGRIEYO2d6RtwPtq5xs6GsMbhizGkgOMa0jM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkPBTof0cTcLxzfDeiNiJ0va31UOcbnIUlWzqHwtwII=;
 b=KQvBiU3fN3WlP34BODxMGzj0nhmKJw1Bkk8UKgEpampEeCC1pCk8X9KPZWwkznyqR5fu7iiQQdyIoJQsdUTDviQjjOAOiz6dgO/iFi1RH2k5aPiOJhCHnVZhejDhKQL/VYHuxIbEt+5sFjq3Ip4Y1US+CMmDpgjZ/NrSTNrVa8k=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:08 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:08 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:06 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 00/65] Simplify and improve the wfx driver
Thread-Topic: [PATCH 00/65] Simplify and improve the wfx driver
Thread-Index: AQHVy50BYfh2z0UfGE+rivOPHKtpUQ==
Date:   Wed, 15 Jan 2020 12:12:07 +0000
Message-ID: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f5f6eee-1a07-4e5b-e633-08d799b423fa
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934D05FFE4C61D5882734A193370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aoUNAvXHlyg/jTyk0ju8Ic30OuLCZmMgHYnqpLXCQ1L9zeTYqCRAfDfFZw6U+kNCqijpcVu9AtFqhdMaIvgQdhc4cefpVN2+Y8uK63qSNKUj+6qqHJjNtqd69Ocy4xt/8K/WOXMdaI/E61EJ0Y7yY325hWvgUljWsbhN0tJwB/r5WAOPU3t6GaU0S4OfYwkD/3cHl6L9+vVdJj0SNYHCD1xxh4be0eRViJ4cLBnfZK6kUmvolC1EvpLikzqGGhZTNTg2zaSXCpxJ+JqvVmR2ycUWdUtsoOcdRlSSLDSlvpl7UGjFrnFn9827BbkAhQ/ObxYWWMuhcHL9ILUsI7Zg+9FcNUnBn/h61B8f534kbI/eNyA0h/lBFg0iLHIHajq+7FtRzGQANH8qbrGSpTLllhJoCtsJoT0xCN1QWbV57rTemFY4YeY9YvUdyY3hVb+6
Content-Type: text/plain; charset="utf-8"
Content-ID: <2915B7D3973F5144BBD9C7BE480632D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5f6eee-1a07-4e5b-e633-08d799b423fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:07.8459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yNY65ludIqcsJe7+mF+EJ0EZVjKnlyAMHUFDev0bK7WbVm/YYVJa5TFRTiNeenTbNX+oLStF/Fjwk0ztrzyQgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8gYWxsLAoKVGhpcyBwdWxsIHJlcXVlc3QgaXMgZmluYWxseSBiaWdnZXIgdGhhbiBJIGV4cGVj
dGVkLCBzb3JyeS4KCkl0IGNvbnRhaW5zIDIgbWFpbiB0b3BpY3M6CiAgLSBTaW1wbGlmeSBoYW5k
bGluZyBvZiBzdGF0aW9ucyBpbiBwb3dlciBzYXZlIG1vZGUuIE1vc3Qgb2YgdGhlIHdvcmsKICAg
IHdhcyByZWR1bmRhbnQgd2l0aCBtYWM4MDIxMS4gSSBoYXZlIHNhdmVkIHBsZW50eSBvZiBsaW5l
cyBvZiBjb2RlCiAgICBieSB1c2luZyB0aGUgbWFjODAyMTEgQVBJIGJldHRlci4KICAtIENvbnRp
bnVlIHRvIGNsZWFybHkgc2VwYXJhdGUgaGFyZHdhcmUgaW50ZXJmYWNlIGZyb20gdGhlIHJlc3Qg
b2YKICAgIHRoZSBkcml2ZXIuIFRoZSBiaWdnZXN0IHBhcnQgb2YgdGhpcyBjbGVhbi11cCBpcyBk
b25lLiBJdCBpcyBub3cKICAgIHBvc3NpYmxlIHRvIGxvb2sgYXQgdGhlIHdhcm5pbmcgcmFpc2Vk
IGJ5IHNwYXJzZSBhbmQgZml4CiAgICBzdXBwb3J0IGZvciBiaWcgZW5kaWFuIGhvc3RzLgoKSsOp
csO0bWUgUG91aWxsZXIgKDY1KToKICBzdGFnaW5nOiB3Zng6IHJldmVydCB1bmV4cGVjdGVkIGNo
YW5nZSBpbiBkZWJ1Z2ZzIG91dHB1dAogIHN0YWdpbmc6IHdmeDogbWFrZSBoaWZfc2NhbigpIHVz
YWdlIGNsZWFyZXIKICBzdGFnaW5nOiB3Zng6IGFkZCBtaXNzaW5nIFBST0JFX1JFU1BfT0ZGTE9B
RCBmZWF0dXJlCiAgc3RhZ2luZzogd2Z4OiBzZW5kIHJhdGUgcG9saWNpZXMgb25lIGJ5IG9uZQog
IHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF90eF9yYXRlX3JldHJ5X3BvbGljeSgpIHVz
YWdlCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfc2V0X291dHB1dF9wb3dlcigpIHVzYWdl
CiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfc2V0X3JjcGlfcnNzaV90aHJlc2hvbGQoKSB1
c2FnZQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9hcnBfaXB2NF9maWx0ZXIoKSB1
c2FnZQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3N0YXJ0KCkgdXNhZ2UKICBzdGFnaW5n
OiB3Zng6IHVzZSBzcGVjaWFsaXplZCBzdHJ1Y3RzIGZvciBISUYgYXJndW1lbnRzCiAgc3RhZ2lu
Zzogd2Z4OiByZXRyaWV2ZSBhbXBkdV9kZW5zaXR5IGZyb20gc3RhLT5odF9jYXAKICBzdGFnaW5n
OiB3Zng6IHJldHJpZXZlIGdyZWVuZmllbGQgbW9kZSBmcm9tIHN0YS0+aHRfY2FwIGFuZCBic3Nf
Y29uZgogIHN0YWdpbmc6IHdmeDogZHJvcCBzdHJ1Y3Qgd2Z4X2h0X2luZm8KICBzdGFnaW5nOiB3
Zng6IGRyb3Agd2Rldi0+b3V0cHV0X3Bvd2VyCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSB3Znhf
Y29uZmlnKCkKICBzdGFnaW5nOiB3Zng6IHJlbmFtZSB3ZnhfdXBsb2FkX2JlYWNvbigpCiAgc3Rh
Z2luZzogd2Z4OiBzaW1wbGlmeSB3ZnhfdXBsb2FkX2FwX3RlbXBsYXRlcygpCiAgc3RhZ2luZzog
d2Z4OiBzaW1wbGlmeSB3ZnhfdXBkYXRlX2JlYWNvbmluZygpCiAgc3RhZ2luZzogd2Z4OiBmaXgg
X193ZnhfZmx1c2goKSB3aGVuIGRyb3AgPT0gZmFsc2UKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5
IHdmeF9mbHVzaCgpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSB1cGRhdGUgb2YgRFRJTSBwZXJp
b2QKICBzdGFnaW5nOiB3Zng6IGRyb3Agd3ZpZi0+ZHRpbV9wZXJpb2QKICBzdGFnaW5nOiB3Zng6
IGRyb3Agd3ZpZi0+ZW5hYmxlX2JlYWNvbgogIHN0YWdpbmc6IHdmeDogZHJvcCB3dmlmLT5jcW1f
cnNzaV90aG9sZAogIHN0YWdpbmc6IHdmeDogZHJvcCB3dmlmLT5zZXRic3NwYXJhbXNfZG9uZQog
IHN0YWdpbmc6IHdmeDogZHJvcCB3Znhfc2V0X2N0c193b3JrKCkKICBzdGFnaW5nOiB3Zng6IFNT
SUQgc2hvdWxkIGJlIHByb3ZpZGVkIHRvIGhpZl9zdGFydCgpIGV2ZW4gaWYgaGlkZGVuCiAgc3Rh
Z2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfdXBkYXRlX2llKCkKICBzdGFnaW5nOiB3Zng6IHNpbXBs
aWZ5IGhpZl9qb2luKCkKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9zZXRfYXNzb2NpYXRp
b25fbW9kZSgpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfc2V0X3VjX21jX2JjX2NvbmRp
dGlvbigpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJh
bWVfY29uZGl0aW9uCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfbWliX3NldF9kYXRhX2Zp
bHRlcmluZwogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9kYXRhX2ZpbHRlcmluZygp
CiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfc2V0X21hY19hZGRyX2NvbmRpdGlvbigpCiAg
c3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfc2V0X2NvbmZpZ19kYXRhX2ZpbHRlcigpCiAgc3Rh
Z2luZzogd2Z4OiBzaW1wbGlmeSB3Znhfc2V0X21jYXN0X2ZpbHRlcigpCiAgc3RhZ2luZzogd2Z4
OiBzaW1wbGlmeSB3ZnhfdXBkYXRlX2ZpbHRlcmluZygpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlm
eSB3Znhfc2Nhbl9jb21wbGV0ZSgpCiAgc3RhZ2luZzogd2Z4OiB1cGRhdGUgcG93ZXItc2F2ZSBw
ZXIgaW50ZXJmYWNlCiAgc3RhZ2luZzogd2Z4OiB3aXRoIG11bHRpcGxlIHZpZnMsIGZvcmNlIFBT
IG9ubHkgaWYgY2hhbm5lbHMgZGlmZmVycwogIHN0YWdpbmc6IHdmeDogZG8gbm90IHVwZGF0ZSB1
YXBzZCBpZiBub3QgbmVjZXNzYXJ5CiAgc3RhZ2luZzogd2Z4OiBmaXggY2FzZSB3aGVyZSBSVFMg
dGhyZXNob2xkIGlzIDAKICBzdGFnaW5nOiB3Zng6IGZpeCBwb3NzaWJsZSBvdmVyZmxvdyBvbiBq
aWZmaWVzIGNvbXBhcmFpc29uCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgaGFuZGxpbmcgb2YgImVh
cmx5X2RhdGEiCiAgc3RhZ2luZzogd2Z4OiByZWxvY2F0ZSAiYnVmZmVyZWQiIGluZm9ybWF0aW9u
IHRvIHN0YV9wcml2CiAgc3RhZ2luZzogd2Z4OiBmaXggYnNzX2xvc3MKICBzdGFnaW5nOiB3Zng6
IGZpeCBSQ1UgdXNhZ2UKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IHdmeF9zZXRfdGltX2ltcGwo
KQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgdGhlIGxpbmstaWQgYWxsb2NhdGlvbgogIHN0YWdp
bmc6IHdmeDogY2hlY2sgdGhhdCBubyB0eCBpcyBwZW5kaW5nIGJlZm9yZSByZWxlYXNlIHN0YQog
IHN0YWdpbmc6IHdmeDogcmVwbGFjZSB3ZnhfdHhfZ2V0X3RpZCgpIHdpdGggaWVlZTgwMjExX2dl
dF90aWQoKQogIHN0YWdpbmc6IHdmeDogcHNwb2xsX21hc2sgbWFrZSBubyBzZW5zZQogIHN0YWdp
bmc6IHdmeDogc3RhIGFuZCBkdGltCiAgc3RhZ2luZzogd2Z4OiBmaXJtd2FyZSBuZXZlciByZXR1
cm4gUFMgc3RhdHVzIGZvciBzdGF0aW9ucwogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgd2Z4X3N1
c3BlbmRfcmVzdW1lX21jKCkKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhhbmRsaW5nIG9mIElF
RUU4MDIxMV9UWF9DVExfU0VORF9BRlRFUl9EVElNCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSB3
ZnhfcHNfbm90aWZ5X3N0YSgpCiAgc3RhZ2luZzogd2Z4OiBlbnN1cmUgdGhhdCBwYWNrZXRfaWQg
aXMgdW5pcXVlCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgdW51c2VkIGRvX3Byb2JlCiAgc3RhZ2lu
Zzogd2Z4OiByZW1vdmUgY2hlY2sgZm9yIGludGVyZmFjZSBzdGF0ZQogIHN0YWdpbmc6IHdmeDog
c2ltcGxpZnkgaGlmX2hhbmRsZV90eF9kYXRhKCkKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IHdm
eF90eF9xdWV1ZV9nZXRfbnVtX3F1ZXVlZCgpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZf
bXVsdGlfdHhfY29uZmlybSgpCiAgc3RhZ2luZzogd2Z4OiB1cGRhdGUgVE9ETwoKIGRyaXZlcnMv
c3RhZ2luZy93ZngvVE9ETyAgICAgICAgICB8ICAxMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3J4LmMgICAgIHwgIDc3ICstLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jICAg
ICB8IDMxNSArKystLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCAgICAg
fCAgMjUgLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jICAgICAgIHwgICAyICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggfCAgIDMgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX2FwaV9taWIuaCB8ICAyMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyAg
ICAgIHwgIDIwICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICAgfCAgNDkgKy0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggICAgICB8ICAxMSArLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHhfbWliLmggIHwgMTU3ICsrKysrLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
bWFpbi5jICAgICAgICB8ICAgNyArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jICAgICAg
IHwgMjA2ICsrKy0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgICAgIHwgIDEw
ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgICAgICAgfCAgMTQgKy0KIGRyaXZlcnMv
c3RhZ2luZy93Zngvc2Nhbi5oICAgICAgICB8ICAgNSArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyAgICAgICAgIHwgNzM1ICsrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuaCAgICAgICAgIHwgIDEzICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oICAgICAgICAgfCAgMjUgKy0KIDE5IGZpbGVzIGNoYW5nZWQsIDUyNiBpbnNlcnRpb25z
KCspLCAxMTgyIGRlbGV0aW9ucygtKQoKLS0gCjIuMjUuMAoK
