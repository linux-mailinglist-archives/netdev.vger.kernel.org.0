Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1191E6E3C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436785AbgE1V5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:57:40 -0400
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:7583
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436721AbgE1V5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 17:57:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4wYHsOqVdMLeCBjZFQa9kxgHFRAJu/bU6N9+IIHK+BuKDAoo09MndzPfXEMFQlql8SQGWTxwCSnDutkQkd8vJrd4W66tYFUB6Q7Sqz4QPv7Q28wUUUL9xYdhKOGY1++h5KtoPgjHOGpfZcGrXiSElVys2IVruP5PHYzczqx+JmuqF/EBmz7EKuMuIvR7flJ8tHnLcusKnIx0efqHxGsdzvw0YwCTrUdF4Mfx2ymBU2Sa2tqzy1mDJR6H34l1PcjYg1dBrn5cye8jZ60r+YxXxcFXz+6HXgLud9sBZvPTZPFWBJQFoMB+EWCgrsR4iig8cx/8e+xAsK+Yj7zNPd1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnWLWm3wQ2ZtZG9U/zYjfqc3svZn1Vn/NcmgRuKHzvQ=;
 b=RCT9y0lD9IZjfdaaesjaeGYLPZp3KWRBw5XVgqLhlEtkkqpKHQnT0ApWcxt+hMG7KJyZrOmsFVFCaUX1V/nXoig2chhDpgJBfkx7GHFpUD/pN31tVxv2z+1e0Xz8ASUS0aMkyykZCviaZQU7NLhdOIxstawJiDwrt6xUBtCm+ogKEko5ql1wLpSQaxM9XR9+QYOvCv0H8UrzSi/0+AfV9CyR6UTXjIAR+HyITw+hnUHtIY0D5H9K0impZkuGKJAWe4udaCEawrN3jbbvsqYK81QeOkn1BNINlbfp+/wrIREfLbrGrNiKvGkPX7y/f9/Rwj7R+LKiW1FH7s3pxC2q4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnWLWm3wQ2ZtZG9U/zYjfqc3svZn1Vn/NcmgRuKHzvQ=;
 b=jTeIh5ga6rhZoJkpgyejTHrPIdFqzG7wjV2A3vrQay0M6Mayxfod9KvpdNL9tJY2gGTuVrg72d4+/6chUvO1tNmVnubwSMHCCFq5jCygZCxBEljIvmjPcSz/7EZfDVxKp1KLIB67hezEMIww4jopkNG0Ou6QEsGysuQvlpT3+4U=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by BYAPR05MB4120.namprd05.prod.outlook.com (2603:10b6:a02:8f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7; Thu, 28 May
 2020 21:57:35 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa%5]) with mapi id 15.20.3066.007; Thu, 28 May 2020
 21:57:35 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 3/4] vmxnet3: add geneve and vxlan tunnel
 offload support
Thread-Topic: [PATCH v2 net-next 3/4] vmxnet3: add geneve and vxlan tunnel
 offload support
Thread-Index: AQHWNR7lVDuZ/9h2NkuMq36M0U0ThKi94++A//+nj4CAAHxEgP//jqSA
Date:   Thu, 28 May 2020 21:57:35 +0000
Message-ID: <7E47274A-0BFE-4354-BF69-7B2C1E7EAA6E@vmware.com>
References: <20200528183615.27212-4-doshir@vmware.com>
 <20200528123505.25baf888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <C3E924AA-41B4-437E-BC7A-181028E5CFE9@vmware.com>
 <20200528.144319.2125126279324542556.davem@davemloft.net>
In-Reply-To: <20200528.144319.2125126279324542556.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190512
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4c00:97e:fd55:6286:cbbd:103a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44dee433-c126-4ee0-df8b-08d803522196
x-ms-traffictypediagnostic: BYAPR05MB4120:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB4120EACB2C87689316BA70B2A48E0@BYAPR05MB4120.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xgo4D+DW3cWQauLCfDb+0jeFLC0UEe/T4rgoDj7cjKV0mpB1sUDTsZ/qeBoEb3FJsafMf8fev+OmUgSDNqTtxXHxcCI4gmR8m1AEKScd2fHz48rxLZNBf5Wn4B+q0gR2DGADFvgDG6vL6KQzN0wGUSIeK1HedbhDigcacMVX+b7sagdYw7YcyR0HPskUiltUhB750CVxO3AdRbo7dnipv4MJjv4dsGyARWoahx37KWE7AIbmOz0xaO7jA23GDFQSzj9Whcl/aLrqjjiwixlizJSu7hOQaIix4ykqjJO7mBbUHnQWyF9Fg2FR0vmvVGTw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(66476007)(66946007)(186003)(478600001)(86362001)(71200400001)(558084003)(6486002)(2906002)(36756003)(5660300002)(6506007)(64756008)(66446008)(8936002)(54906003)(76116006)(4326008)(66556008)(33656002)(316002)(8676002)(6916009)(2616005)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2tpz2AE0nHUp3rEe179MfJ+8h3umP85EXQus5BfalzESwjfh0ODylL6KA0zxksRG32eI9VIqxPe3CJ7mttJme0uNeMIENDDi2edU5VnXdZyK+W4BU8GX3F224wHTlOYerYWlpQVwIqoML7CrXsF0bOEN7P+XjFBJyQsee7lRRrVA/0P+3ToSVKcklDv9GX4SLLaApMm2jyub56oNAKMES5/cIKeuraMdLoVa0BJG3JI+UJGP7juU3ILG6o+T8imHid7Pu/bUAJ0W/zyDiP07PoxprGmx2ZMupcrBHFinhw0g3h2829SFZtKN2dUclQ/yqux6XE8cMPiU/M/Yi+oGEt4Un2dK55ig2fzVoLn1WaBOmXfk/oHQ9wp9VzrNLoKDi6tO8U8Nf7dgVHgLDa9nrbnIcJn3LFMHNS/1D4DMlTyLMsMBxcfcBPXPfJ8N6MV14toWeCD9/QtwOxYDn6hrbMa0n4LhC0OTj1+KH0YIZdSrzEsDXdSBoMd6E+IDRspc2HSJnAvoa+pjvkLY5INloa8ItTEdX17kWwmQsBNYeDY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC01A52F807B424CB11EDF17C43E5868@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dee433-c126-4ee0-df8b-08d803522196
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 21:57:35.6943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b7EIkMzShi/YczxEOpyjmlpEcqALS1JpClqRvdVjak+A91y4ZRlaFb30lYuozkYfnMEOcxk2bTVDC8yuneVVWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA1LzI4LzIwLCAyOjQzIFBNLCAiRGF2aWQgTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD4gd3JvdGU6DQo+ICAgIEl0J3MgcmVhbGx5IGF3ZnVsIHRvIGtpbGwgc28gbXVjaCBvZiB0
aGUgc3lzdGVtIGJlY2F1c2Ugb2YgYSBmbGlwcGVkIGJpdA0KPiAgICBpbiBhIGRlc2NyaXB0b3Iu
DQo+ICAgIA0KPiAgICBQbGVhc2UgZml4IHRoaXMgYXMgd2VsbCBhcyBhZGRyZXNzIE1pY2hhbCdz
IGZlZWRiYWNrLg0KPiAgICANCj4gICAgVGhhbmtzLg0KIA0KVGhhbmtzIGZvciB0aGUgcmV2aWV3
LiBTZW50IHZlcnNpb24gNCBwYXRjaGVzLg0KIA0KVGhhbmtzDQoNCg==
