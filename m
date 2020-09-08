Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A14D2616AF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbgIHRQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:16:29 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:26533 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731461AbgIHQS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:18:28 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5776b70000>; Tue, 08 Sep 2020 20:19:03 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 05:19:03 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Tue, 08 Sep 2020 05:19:03 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 12:19:03 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 8 Sep 2020 12:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhCRvpw0na40OyicnP5AGw2d5w2Hhbyk8qCtU0YqvsOst+Eo26xpH2gpmZBtr5JYfxpFpKv/XrQFm1XnRRgkCjSwoXKBsw6TKSCsVCF0tj4wxHJJPwn9wz99iwAOAbf/eggWd87FiRceVkSRffkIYt6djq3IxuBMaptdpsp2plqrUu2OWECo9YfaDLmbL7w2EZI9XHIxxu0bxNxapnbSFvP9rnX8uP/2nj8LF3EtPWI0aVKp4/wI+E9ku8C8s8MhRnxSTiLV+90/uz3UBSvkuYVggkUcrH5ahvc5vDOQFpm8uRQwMPqip0ZSV4qbS+eqMYffX6w8QrlXuCr09dTwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KS+R990lQZnGVh4RQQN9/kxGvT5sUya0ywclu9I0Drc=;
 b=aGd8pLrh6a1ERJKWrihCTy6y0xKzbKB5qy35ctyXO+o98XkZbvL1WALP6Kz54nnbQRPSSMxadOV8HrkVT7X5fzhkoyYgGjLnA7pV4Ge5Hn1mXoNwREjZUFgtSQx3Gi5jfGCmZ1dTRrUkuYuZ1JvMhlET16lZw1cXNIbd/GVwMxxreFF4oKYPtJIj4Rzjj9H6mwbB+v5G2CW0KB2rF3tSvLZxuo3G8ie1NEKSDn6W8HPgrwWB7+jlzz1uesUvHHTkyM9Kwb2dGhRgK9lAf501ReFIZL3/4yZlrbamXJDMHF/rG5YIpMkdSL13wIYsnYkBexBhqFzHVbWxd0ygK0XFdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB2968.namprd12.prod.outlook.com (2603:10b6:a03:ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Tue, 8 Sep
 2020 12:19:01 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 12:19:01 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC 3/7] bridge: uapi: cfm: Added EtherType used by the
 CFM protocol.
Thread-Topic: [PATCH RFC 3/7] bridge: uapi: cfm: Added EtherType used by the
 CFM protocol.
Thread-Index: AQHWgpyCX3nL4xS5YUOMsYdITEags6lerzyA
Date:   Tue, 8 Sep 2020 12:19:00 +0000
Message-ID: <30bf3cb37537691d03b38fee323504290ddb8ac1.camel@nvidia.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
         <20200904091527.669109-4-henrik.bjoernlund@microchip.com>
In-Reply-To: <20200904091527.669109-4-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71b1721c-570f-472e-dcc2-08d853f15e89
x-ms-traffictypediagnostic: BYAPR12MB2968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB296894E3AB00C9FF9B5C770FDF290@BYAPR12MB2968.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: scQeIl5o+yC37NcHmC8KjK53KavaY3/m2qqSfwnGe1oc9U2Wd9g0W4xYCTpl//2bgC+a05nHfll06iJpgBgIz5qoQeah/RQYe+WCsRJl5zzeDdjBp6tKEd4Y5VCG3fV1A8w7otJEvhqufiFGK/EwJLGrHbmYgAbkv0YpCzlgLBvorPnsgw28DHuyO9zIGFEQJ+OLYq63y46j5NmPBEMSUSBFebmq/ncuKZCNFSpFrID6mGIgcYaE98zyx8q0a0zbwrQ7XqtKbxnG9J8vNIV57iAtiIgwUPipoeEM5gO6X/RbJ7wBedbJ5H0Bhp5FdrnB52gfRBG9jqNOV/0+tVapOtpE9KWvcBuwpnSfYQnVOHShOY12FUomB8NHSi6qF0J+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(6486002)(4326008)(3450700001)(4744005)(110136005)(91956017)(6512007)(2906002)(316002)(76116006)(66446008)(64756008)(66476007)(66556008)(2616005)(8676002)(36756003)(5660300002)(86362001)(26005)(8936002)(186003)(6506007)(71200400001)(66946007)(478600001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7VgzWPjQnQ7dIWob0XWGkXsrkrpCYizGcJDyd6aTsm6CXFOXSHPgnTcR3cV/tdXxljaPMDS6WVvMHdvm+U/kpdZ8jSvjmWzkOcU6elDkC/4i5FcFzr71MZ+8pWSaPqSQftcBQBs0/YXYatX46OpU+0akQKVUMH4as5fJ8LW+SdHumAtIxGTpRr+cOFKenluXN6Holp2qIE5d5RD9XL8dEmTc/5hPFEM4Vsv4XOAEcgOv1Rrhtlg3q+j+Y1HZ0iutDAOsEvOsSZ3fF7KIIJKGbaBiSy5EtJMqieLZg8168+i5Iwi7DO5XWEHkJ5GnR/E1IWWP0sS6BABM6lBKjcZ7UeaLZNoM1Y6DSzy49Bqz9BJ6CJpb5kOn/3t2t+2AUwMGBYP1IRzrpt3qMnhE/FeJsbzgKyjOr5vjKtz23POMKaSobjOy6tc2A8XNJ47HSkPEvJ1+LEB5OUSjBjwa/nWgLHAB89XZZc/PUbYPOC9ltu/CLcXGepDPGVjVXsr0ohocTjZofeHrZz6T2mKdgw4PtpY2y2QbI8mlSg05Mwr81hK+BD7IYCF2KfjDKzNxNY1v4pIoUK3+iT6KdbTI3VwzAFjGkNYJYK2DTIMf+hQKHaU81z4DWzggRvKF5vTNis41c/PLOf1VrSLQXty21EKkBQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE6440E9ACB65946BD6F17E90FC60519@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b1721c-570f-472e-dcc2-08d853f15e89
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 12:19:00.9043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ij8MMQ+/skyME5tyClsHpyi0Lo6bFt3SU2WDuGR3iAdz4D+w/ti6KGPVgJdwYXxZr/pCALfQIp2O0Z99OIShYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2968
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599567543; bh=KS+R990lQZnGVh4RQQN9/kxGvT5sUya0ywclu9I0Drc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=bNQrHtCq7clSFk3lF0pz66G1AGwsvwKHez290eRCt/gE3OOZ/znOVU6uVvVeWWob0
         H59iP15hytdQYr64dqfZLSMrm//DmGSXFVbGaUetKy5JJwOKCnS2TDc2zRvfb7le/Y
         /FevifEtOMTZ0UtpfvwiqtgOulxIuhXDb/jGRvDna1whzmMCyfjJlqUW70OIC3urL9
         pgoacj5CFM/egahCKfXIG7ayySXYPUgWNffn5V2kVqDMI1evcYT90V6nCjuYeERwlt
         mCqQgER+u1TvxwOwmKrl7MNdaC7jg3Q+RkE1g5KsKTiJiBUb1lEi+4OwcvNTnM4Hra
         Yvv+TdJTxbzRg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTA0IGF0IDA5OjE1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBFdGhlclR5cGUgaXMgdXNlZCBieSBhbGwgQ0ZNIHByb3RvY2FsIGZyYW1lcyB0
cmFuc21pdHRlZA0KPiBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3Jv
Y2hpcC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L2lmX2V0aGVyLmggfCAxICsN
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9pZl9ldGhlci5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX2V0aGVy
LmgNCj4gaW5kZXggZDZkZTJiMTY3NDQ4Li5hMGI2Mzc5MTFkM2MgMTAwNjQ0DQo+IC0tLSBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9pZl9ldGhlci5oDQo+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9p
Zl9ldGhlci5oDQo+IEBAIC05OSw2ICs5OSw3IEBADQo+ICAjZGVmaW5lIEVUSF9QXzE1ODgJMHg4
OEY3CQkvKiBJRUVFIDE1ODggVGltZXN5bmMgKi8NCj4gICNkZWZpbmUgRVRIX1BfTkNTSQkweDg4
RjgJCS8qIE5DU0kgcHJvdG9jb2wJCSovDQo+ICAjZGVmaW5lIEVUSF9QX1BSUAkweDg4RkIJCS8q
IElFQyA2MjQzOS0zIFBSUC9IU1J2MAkqLw0KPiArI2RlZmluZSBFVEhfUF9DRk0JMHg4OTAyCQkv
KiBDb25uZWN0aXZpdHkgRmF1bHQgTWFuYWdlbWVudCAqLw0KPiAgI2RlZmluZSBFVEhfUF9GQ09F
CTB4ODkwNgkJLyogRmlicmUgQ2hhbm5lbCBvdmVyIEV0aGVybmV0ICAqLw0KPiAgI2RlZmluZSBF
VEhfUF9JQk9FCTB4ODkxNQkJLyogSW5maW5pYmFuZCBvdmVyIEV0aGVybmV0CSovDQo+ICAjZGVm
aW5lIEVUSF9QX1RETFMJMHg4OTBEICAgICAgICAgIC8qIFRETFMgKi8NCg0KQWNrZWQtYnk6IE5p
a29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCg0K
