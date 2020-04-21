Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F11B233D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgDUJvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:51:42 -0400
Received: from mail-eopbgr50086.outbound.protection.outlook.com ([40.107.5.86]:47617
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725920AbgDUJvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7hWKv4QbqZsJauysmPOco3Vxi3w0XxAAvCTb9O+6Hc=;
 b=VvcFFvUt2tDtuM76TpKw0Mr+yt5/mKvjTh5ETbPvQ5uBu4ACiE584w0rXJrValmdrwLLGUl+xO+gyu4qBwVEE0W6fW6DQFp7MQrR1cXJxtKJxfw2aIgDkKS64NV6vLtOUCIQoQr/Ab5+P4dGZJDlBp6/GWyuyVvtlbuCXlaY6i8=
Received: from AM6P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::15)
 by AM0PR08MB4449.eurprd08.prod.outlook.com (2603:10a6:208:143::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Tue, 21 Apr
 2020 09:51:33 +0000
Received: from AM5EUR03FT053.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8b:cafe::f3) by AM6P191CA0002.outlook.office365.com
 (2603:10a6:209:8b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Tue, 21 Apr 2020 09:51:33 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT053.mail.protection.outlook.com (10.152.16.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Tue, 21 Apr 2020 09:51:33 +0000
Received: ("Tessian outbound ecb846ece464:v53"); Tue, 21 Apr 2020 09:51:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5f959d203d53682b
X-CR-MTA-TID: 64aa7808
Received: from a26fae153160.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C404701D-2669-471C-9EE8-A3AD6B44AD70.1;
        Tue, 21 Apr 2020 09:51:27 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a26fae153160.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 21 Apr 2020 09:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiSKc3kKFl7i7aTFhy9IENfL96RAvpf9MHLZLX627l1nBDlhiqcF0vJ+9aC55M5HwmEvR5KBegeXfPNzY1GjR3v4X0VSaEC1eUAFq3KRHvpnhOEzTzAPHuE5xVFtADSExa9/S5l/LwjK+yLW6TpeqXrVByHBg/TbMHcQw1TGOua5m5uHYl9e9uiZJhHAO5nGnL7Hnnt/oLxjf2j1uS+xFvueDXFQZ8+jAIIcOM7FbTtUJjn/Vl8GgBmMtDVx/tN3XjUt73hpm0C+DI3qPqYvvHzrZxniWRmpXtq012v/2OYjxxRNNXEG7tQ/a7nbYBvneS6hG7W7ntb+J6NBuhZlQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7hWKv4QbqZsJauysmPOco3Vxi3w0XxAAvCTb9O+6Hc=;
 b=NYA6aj/e0t8/5zosrBoYMczFsUNnRa/O7xt+sC3PKzNEuUgkxhjV40F0sQZv/8I5M8D6rGniP2rq1dum7U0FSe1sQvUqS0tarTSbymUZ/AlG6x+alilxj+HjbcAEO/IwA3NzTuC2Ph5Hhu8hZmg5yCJrHLCP8XEkijzeH0QJF1o3W1CdGGl7BGd4r3T/5QpgibSH8IG7Jjfk2Xil+nIclJv342mHL48yWLXeAWx6YT0xWSTjo5HRtegkbXz0LRPsGMvoi839Detpy7w9MFWIaVVcX2KMAG5u/lKD6YVQZC0NefCFrCyA+tAttG7kI2ZvQCYCoHwHD1CYkdQd4a3Dig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7hWKv4QbqZsJauysmPOco3Vxi3w0XxAAvCTb9O+6Hc=;
 b=VvcFFvUt2tDtuM76TpKw0Mr+yt5/mKvjTh5ETbPvQ5uBu4ACiE584w0rXJrValmdrwLLGUl+xO+gyu4qBwVEE0W6fW6DQFp7MQrR1cXJxtKJxfw2aIgDkKS64NV6vLtOUCIQoQr/Ab5+P4dGZJDlBp6/GWyuyVvtlbuCXlaY6i8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2251.eurprd08.prod.outlook.com (2603:10a6:3:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 09:51:25 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 09:51:25 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Mark Rutland <Mark.Rutland@arm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: Re: [RFC PATCH v11 1/9] psci: export psci conduit get helper.
Thread-Topic: [RFC PATCH v11 1/9] psci: export psci conduit get helper.
Thread-Index: AQHWF4xCog26uJuT5UavVEF5u0ShTaiDUtMAgACJBgA=
Date:   Tue, 21 Apr 2020 09:51:25 +0000
Message-ID: <3F1930C1-5CBA-4401-9595-1432C16EE750@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-2-jianyong.wu@arm.com>
 <20200421094058.GA16306@C02TD0UTHF1T.local>
In-Reply-To: <20200421094058.GA16306@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad0a3367-c6a8-451f-e05d-08d7e5d9930f
x-ms-traffictypediagnostic: HE1PR0802MB2251:|HE1PR0802MB2251:|AM0PR08MB4449:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB44499890AABC1D7602831D9CF4D50@AM0PR08MB4449.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4941;OLM:4941;
x-forefront-prvs: 038002787A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(26005)(7416002)(6486002)(8676002)(54906003)(4326008)(55236004)(6862004)(2616005)(6506007)(37006003)(2906002)(316002)(33656002)(6512007)(478600001)(76116006)(66556008)(66476007)(66946007)(64756008)(66446008)(81156014)(5660300002)(91956017)(86362001)(186003)(8936002)(71200400001)(6636002)(36756003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +I4oOEzo61Vtp+ZY1LfM7pyFg25HxJvp3daQD2KkT+bwUL69m5N1/ZRFCt7d1O7fsDQzJqcGfCIQ11lcvLiBEAbXZhRpIlU0R9jWGBfuR9ybl4GSS/q+/h713fhE9O6Cj7zZYaRUbkz5j429BTnHs3cp0vwp2WtHMA278GeZ/Ba+9MFTdfLbH9bJs2PvvzWcVTcK6nLYggWQqgvw8Ng0sOUfy1nGnX+0rD/PR3QE2PKCj1rNK7og1/86AOM8uHCLAxZ8JzMY4cMhCyFoBv0KRrBhEJN0wwNYVgQHMu8AIL4Xz5X/X4ATMYZDCkXNDyws2wK+ExZwUdW8VGCfkECqzlrvNSvCOzigykn4GrrovA9CfBhweTUIUXWFIVvI7BXzh7JgaZ7IYRIT+ZNrKJJ0HNlHiu/SOsuynpgQvKNrkVHzrOvdGqIFHctyQ6Jb0yMo
x-ms-exchange-antispam-messagedata: Umxn/qEG7j66i589fh1wWJxDSlGUrYM2daF2MoYiZWPLvL7OMuzxkYSnmMWuyPaCuGmWapHwbZFzf4vHXdE2zsH2AD2HnNNtB9pBVzf7p7tt6kkAhuMLm979PlUs7L1uEqTPRl8GwmylDTBAhPFlYw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C3C9D2110CAC3499E56C274878C1D4D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2251
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(346002)(46966005)(81166007)(86362001)(54906003)(47076004)(336012)(4326008)(37006003)(186003)(316002)(33656002)(8676002)(478600001)(82740400003)(450100002)(6506007)(6636002)(36906005)(2906002)(6512007)(81156014)(6862004)(356005)(5660300002)(70206006)(70586007)(8936002)(36756003)(6486002)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: e7985c54-5911-48bf-967b-08d7e5d98e7f
X-Forefront-PRVS: 038002787A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jq4rRE6k1xChzIghKr3eP3ZznFncbyiXpGdLsgfUCYKzhDin6LmRyA4LCIjWYFTXhQn9dHkwupZE97F32903162/a/H9sTb5I6SLAnRzRJkST4Tz5T0M5xXohWGolgj7fLyR2VuknByEGXK3uJ4IMXd2vhv2CalnuLMyhq0bVrD4oMGUaQeUyBLuPwAVMGkq1xQo74gmA+Kt2eB/xThtP75gPuOJ6264eAJ6JCFXCSAjVza8KmjX2mLky4XEmJ2IpiiL/ZRfP73HCGlp/xKkcTsK+R0ZU44QDxRPWsa6RmOJomueLB2ad8o+UtSEtw6UoqfcbEP0NfIfpUJmhNIWwFtLXmxFm9SbDth1HbEvImU3qv/Gu2XxxPOIBUsfdkRHH0dyylbJp61A1/nxVUC8ibTX5yu+3JO7o5k/noPyyZHGzY78BPenRDz1ZwI9PkhaA/bac7XqjvEH/dp6hVGOohn2Y4QnYi18nTGmVMBsJYHCR/7athQ1tqp3ZiFtKCh79OP2+K4Ymf/lf4rE9obltA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 09:51:33.3178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0a3367-c6a8-451f-e05d-08d7e5d9930f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyaywNCg0KDQrvu79PbiAyMDIwLzQvMjEsIDU6NDEgUE0sICJNYXJrIFJ1dGxhbmQiIDxt
YXJrLnJ1dGxhbmRAYXJtLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUdWUsIEFwciAyMSwgMjAyMCBh
dCAxMToyMjo1NkFNICswODAwLCBKaWFueW9uZyBXdSB3cm90ZToNCiAgICA+IEV4cG9ydCBhcm1f
c21jY2NfMV8xX2dldF9jb25kdWl0IHRoZW4gbW9kdWxlcyBjYW4gdXNlIHNtY2NjIGhlbHBlciB3
aGljaA0KICAgID4gYWRvcHRzIGl0Lg0KICAgID4gDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBKaWFu
eW9uZyBXdSA8amlhbnlvbmcud3VAYXJtLmNvbT4NCg0KICAgIE5pdDogcGxlYXNlIHNheSAnc21j
Y2MgY29uZHVpdCcgaW4gdGhlIGNvbW1pdCB0aXRsZS4NCg0KT2ssIEkgd2lsbCBmaXggaXQgbmV4
dCB2ZXJzaW9uLg0KDQogICAgT3RoZXJ3aXNlLCBJIHNlZSBub3QgcHJvYmxlbSB3aXRoIHRoaXMg
cHJvdmlkZWQgYW4gaW4tdHJlZSBtb2R1bGUgdXNlcw0KICAgIHRoaXMsIHNvOg0KDQogICAgQWNr
ZWQtYnk6IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+DQoNClRoYW5rcyEgR2xh
ZCB0byBnZXQgdGhpcy4NCg0KQmVzdCByZWdhcmRzDQpKaWFueW9uZyANCg0KICAgIE1hcmsuDQoN
CiAgICA+IC0tLQ0KICAgID4gIGRyaXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMgfCAxICsNCiAg
ICA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCiAgICA+IA0KICAgID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMgYi9kcml2ZXJzL2Zpcm13YXJlL3Bz
Y2kvcHNjaS5jDQogICAgPiBpbmRleCAyOTM3ZDQ0YjVkZjQuLmZkM2M4OGYyMWI2YSAxMDA2NDQN
CiAgICA+IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMNCiAgICA+ICsrKyBiL2Ry
aXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMNCiAgICA+IEBAIC02NCw2ICs2NCw3IEBAIGVudW0g
YXJtX3NtY2NjX2NvbmR1aXQgYXJtX3NtY2NjXzFfMV9nZXRfY29uZHVpdCh2b2lkKQ0KICAgID4g
IA0KICAgID4gIAlyZXR1cm4gcHNjaV9vcHMuY29uZHVpdDsNCiAgICA+ICB9DQogICAgPiArRVhQ
T1JUX1NZTUJPTChhcm1fc21jY2NfMV8xX2dldF9jb25kdWl0KTsNCiAgICA+ICANCiAgICA+ICB0
eXBlZGVmIHVuc2lnbmVkIGxvbmcgKHBzY2lfZm4pKHVuc2lnbmVkIGxvbmcsIHVuc2lnbmVkIGxv
bmcsDQogICAgPiAgCQkJCXVuc2lnbmVkIGxvbmcsIHVuc2lnbmVkIGxvbmcpOw0KICAgID4gLS0g
DQogICAgPiAyLjE3LjENCiAgICA+IA0KDQo=
