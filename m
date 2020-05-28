Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8B1E6D7B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436539AbgE1VSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:18:42 -0400
Received: from mail-eopbgr750073.outbound.protection.outlook.com ([40.107.75.73]:22190
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436512AbgE1VSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 17:18:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC2Nk30Bcl2pZYvchrcHIWthzJWeDpIWnwFF4wPu8CmXndYW8UnfnUWv6ialXFLmKCcW4T2a2w4npiSf8ID8tZUYs4impItMc6+kHquh9Igg6aAjqBOw5/pOduy/9tGzJ9H0g80QDCmhdSeuEwK1nWeUr7LjvKP64BgbCJaieol3FtYTMrunncs/MbK6fXVONpyDRII9EX/CtoI0avVHm4DzDwSb+LXSx7gVXU2Kgo5Fmk/pUCkWE6SZFWqFlwIT+ph0jsQw+HMnUCCArIcOKv7Uf7bIAOnQYVq/w78kUkmofqh8v0tZLuE9VOwrHYqc91XNI1oA2XbvEPAOFol+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbMjfA4cCK7yeSXKP9wUEP5L8cVZbH08ywrwK/jgJA0=;
 b=jsGlZHNoGsMFWSwfRz0ib4OJyNTc4DQBsfDDsBLGytuq7ff4BjcXa+MKjW6cGBbFjxgRMBcIiueGKBTvN/7e5eGkue5NiiyFaSM4H4MDlJBuNQV04vX6ZWaGj11p+Pw45XzcQwrItPN1t1/FimsKrW3kWnDLtfO+p2EPiUzTC3WuLVm106+zs8viT23G3S09P/A00bCixOpHNe458qiCcPl90AEhHTyKhJ2qTrJGWwJyRBXKNtUY/FSRUVqOJtUgaWUtAUphtTREAt/3q6Vnru4G1qEWOKBG9QoPfJQ1/GVnzxuLT9Nh4l3UsGxCJs8RJOh59jqOW0jOFvTR7mubdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbMjfA4cCK7yeSXKP9wUEP5L8cVZbH08ywrwK/jgJA0=;
 b=t8QGh2OC+ALs6GBlSQWEr8GfrP4IyFBXfVtHSFOFcGT/msi4vzDtAIBykvv0wQ8AbJ7Do7GhzRfmjGqJxvetINv/SFROfv2EU9HBzVkqjGDsMaObijid0EaB24vvZlJzF5NJKDXJ/wDQX1+Lh5fIioEHcknHv6itdho6HZtCbWk=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by BYAPR05MB4791.namprd05.prod.outlook.com (2603:10b6:a03:45::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.8; Thu, 28 May
 2020 21:18:34 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa%5]) with mapi id 15.20.3066.007; Thu, 28 May 2020
 21:18:34 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 3/4] vmxnet3: add geneve and vxlan tunnel
 offload support
Thread-Topic: [PATCH v2 net-next 3/4] vmxnet3: add geneve and vxlan tunnel
 offload support
Thread-Index: AQHWNR7lVDuZ/9h2NkuMq36M0U0ThKi94++A//+nj4A=
Date:   Thu, 28 May 2020 21:18:34 +0000
Message-ID: <C3E924AA-41B4-437E-BC7A-181028E5CFE9@vmware.com>
References: <20200528183615.27212-1-doshir@vmware.com>
 <20200528183615.27212-4-doshir@vmware.com>
 <20200528123505.25baf888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528123505.25baf888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190512
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4c00:97e:fd55:6286:cbbd:103a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d39878e-52e1-4fb5-feff-08d8034cadfa
x-ms-traffictypediagnostic: BYAPR05MB4791:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB47918B99F27C95B5F5EB3C07A48E0@BYAPR05MB4791.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XpnMtPOnf75X/dKg4GAuXR5aE/rDKjrsXCIBPL58qyhJVLtGIHLix002WjHMvvLihITHBLuvqdSVg4FyFrhUgCI3XkO9RfFlRBjvjMATBq414o75khJ6zh2vb1JzNH2gfmGl9a2Ape1srYrrYXta1i+Iiqg0sg/1/pgR4g9L9CuIzdXbUExmCPn5D40GZ9cr5ztgpr3+5ozXpkEk3GVuUbsXz3CRSVTEnrCUDXmtecaR88Zbv8XgbPFOnzN4TWT+oE+tzNl+cJthB0kIs3Igw7PqBUzBya+wg2q1KzIy2ZYYQ6QyrbEFC1oeTUEvv5xF1bVUwG+JoB7wgYGhVXwJ2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(8676002)(2906002)(186003)(6506007)(4744005)(5660300002)(36756003)(66476007)(66446008)(66556008)(64756008)(6916009)(71200400001)(33656002)(76116006)(2616005)(4326008)(6486002)(8936002)(86362001)(66946007)(6512007)(478600001)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QyQPM80ktrX1N19Y+9fDy6WZvL0/nOBv4jzK1xy7AI83g2ZBu+siSMAW1lqy5iFRdiIPlOn4+I6n0bwPN3W8M2Q9nzuPKMs2BEAF4QsNgIaB2dQZ1+D0Xx59llwkOqY6RHEU4fSNYQ9mu5hPQFZCQOvScKDU+iHOrUxYNy+ZpuubrUxu3t8FXSWnTeLWvp1QVTPVn/DFlNTNoNaKLEzV3t6SIHPHV+fHHkjRn9KM6ZaFEDuvN6/T67NKaWE56+o/YG7wzDOSLt3RdaQYDwDCqtRDMQwd+hn4dpg2jJ5wqANXpmG2fefgqDz/4+FTccJNvUrGKHsM7iq7Hk3m0QEyop6dA2YNMxdMqu2udL3sIbOxJ5tdCCwMw1Ppcmz1NpVc4wznYv2rv3rz1JLhxO1m29ZHcplaZpWRRPJPHQgnDzfCTpinn1AHfdL3rWr4pKeo9XR+x0zzLOQAYtMVogZ5nxZGWD8NCtuMnValvV7+Mmy55RDhXxpOTuxxeAoWyg6w2TrwUrj3Ve7dYJRS0NfKmMz3kBcci9WZwefIejpssJk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00FD3E1D38D18A4189437A9A51E5811A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d39878e-52e1-4fb5-feff-08d8034cadfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 21:18:34.2211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SY/DvD3YJ2m/ZEqn05fPwwHXLNzufIfpmPmW247MRL/uXFB6XCwPapTfmGS0+sKOmA2SjMboOqHWHwTK9JuCBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA1LzI4LzIwLCAxMjozNSBQTSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToNCj4gICAgT24gVGh1LCAyOCBNYXkgMjAyMCAxMTozNjoxNCAtMDcwMCBSb25h
ayBEb3NoaSB3cm90ZToNCj4gICAgPiBAQCAtMTE2OCwxMyArMTIyMCwyMSBAQCB2bXhuZXQzX3J4
X2NzdW0oc3RydWN0IHZteG5ldDNfYWRhcHRlciAqYWRhcHRlciwNCj4gICAgPiAgCQkgICAgKGxl
MzJfdG9fY3B1KGdkZXNjLT5kd29yZFszXSkgJg0KPiAgICA+ICAJCSAgICAgVk1YTkVUM19SQ0Rf
Q1NVTV9PSykgPT0gVk1YTkVUM19SQ0RfQ1NVTV9PSykgew0KPiAgICA+ICAJCQlza2ItPmlwX3N1
bW1lZCA9IENIRUNLU1VNX1VOTkVDRVNTQVJZOw0KPiAgICA+IC0JCQlCVUdfT04oIShnZGVzYy0+
cmNkLnRjcCB8fCBnZGVzYy0+cmNkLnVkcCkpOw0KPiAgICA+IC0JCQlCVUdfT04oZ2Rlc2MtPnJj
ZC5mcmcpOw0KPiAgICA+ICsJCQlCVUdfT04oIShnZGVzYy0+cmNkLnRjcCB8fCBnZGVzYy0+cmNk
LnVkcCkgJiYNCj4gICAgPiArCQkJICAgICAgICEobGUzMl90b19jcHUoZ2Rlc2MtPmR3b3JkWzBd
KSAmDQo+ICAgID4gKwkJCQkgKDFVTCA8PCBWTVhORVQzX1JDRF9IRFJfSU5ORVJfU0hJRlQpKSk7
DQo+ICAgID4gKwkJCUJVR19PTihnZGVzYy0+cmNkLmZyZyAmJg0KPiAgICA+ICsJCQkgICAgICAg
IShsZTMyX3RvX2NwdShnZGVzYy0+ZHdvcmRbMF0pICYNCj4gICAgPiArCQkJCSAoMVVMIDw8IFZN
WE5FVDNfUkNEX0hEUl9JTk5FUl9TSElGVCkpKTsNCj4gICAgDQo+ICAgIFNlZW1zIGZhaXJseSBl
eHRyZW1lIHRvIHRyaWdnZXIgQlVHX09OcyBpZiByeCBkZXNjcmlwdG9yIGRvZXNuJ3QNCj4gICAg
Y29udGFpbiB2YWxpZCBjaGVja3N1bSBvZmZsb2FkIGZsYWdzIDpTIFdBUk5fT05fT05DRSgpIGFu
ZCBpZ25vcmUgDQo+ICAgIGNoZWNzdW0gb3IgZHJvcCBwYWNrZXQgd291bGQgYmUgbW9yZSB0aGFu
IHN1ZmZpY2llbnQuDQogICAgDQpIZWxsbyBKYWt1YiwNCg0KR29vZCBwb2ludC4gSG93ZXZlciwg
SSBkaWQgbm90IHdhbnQgdG8gY2hhbmdlIHRoZSBiZWhhdmlvciBpbiB0aGlzIHBhdGNoLA0Kc28g
a2VwdCBpdCBhcyBpcy4gSWYgcmVxdWlyZWQsIHRoaXMgY2FuIGJlIGRvbmUgaW4gZnV0dXJlIHNl
cGFyYXRlIHBhdGNoLg0KDQpUaGFua3MNCg0K
