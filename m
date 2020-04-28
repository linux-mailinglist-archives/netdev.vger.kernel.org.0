Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3D1BB655
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgD1GPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:15:07 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:2374
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbgD1GPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 02:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPr3Vr6TWZPdPtYl0j8ft01290WNWZw8bWF3tmEpssk=;
 b=d+/5Z0xP50CUQhVyU6d+OvAVGmDR8gyXn9sz8o/7EM3qNHalkg8o4OC6FC4buTqXeV3nqS10XtWbP89jwN+bD2xEjAEr2DfqNL8uo7gyYfzng5NKYAV5ipG28QYZ6RTPbfgwSi9nz3nO8xIM4haE1ymynOHUMol4JI1aGIZGvGw=
Received: from DB6PR0201CA0029.eurprd02.prod.outlook.com (2603:10a6:4:3f::39)
 by AM6PR08MB3639.eurprd08.prod.outlook.com (2603:10a6:20b:51::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 06:15:01 +0000
Received: from DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:3f:cafe::fe) by DB6PR0201CA0029.outlook.office365.com
 (2603:10a6:4:3f::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Tue, 28 Apr 2020 06:15:00 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT004.mail.protection.outlook.com (10.152.20.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Tue, 28 Apr 2020 06:15:00 +0000
Received: ("Tessian outbound fb9de21a7e90:v54"); Tue, 28 Apr 2020 06:15:00 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f629d18fc52ee4c7
X-CR-MTA-TID: 64aa7808
Received: from 0290c1ce7e80.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1E74BF0C-578F-4E27-83C3-AE9C8BF93A20.1;
        Tue, 28 Apr 2020 06:14:55 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0290c1ce7e80.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 28 Apr 2020 06:14:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+wjXmdEL69azDzg4CpxBCs2yb7LetkkslG/jB0xi6ZkH02U0GU8cy/IXfVjH385BcOk7sS0sgeO82J8K23XfYbSBTeO3Km4mWAnuIlcKoQa8W2fyKzDnlTTdtiaup0CHiGYYQ5ge4QwCA9lKnLCryQgPnjA3sQH6VcwBqRHg/bFMG4MecoZhbGLdmYDBfDOvie0vd4XVu1j2AiCMAo0Qt9gdlffdg1h4Y0oT7h3VhwqCCA1g9QDZE5kkOKGDpHjYZBlKgp5HMYwdYABDmD8xVUxAVPn+R9n+f1GttvwaHizArDAvDO2UfJO+4riiGYb2b/oSOFAQu3xt4FI0HrPxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPr3Vr6TWZPdPtYl0j8ft01290WNWZw8bWF3tmEpssk=;
 b=oSlWzLcMKRHaTeQ2Edx9dlSZ1AdCSwIJRjs5KxX18eWH/G9X7YsUJdRQOfjjntt6FGTkFAgU9H1un5pKxUb28TGJLFFjz+PebxT/XZLaCSbZjbTBaqtAPB3GVfcPwhvp6oTGy50P27uiNkDqH89CX9vC4q05gIkXW/UiKiYie7CtUWnTI4yQtEWeZCdL5CIQH8QTtJbG6jOpCE0LhAEYMgtkrt1qsNWnLnIQxGZT3IH9lANRVLe6lgX9NnhmTwuqlu5cL40PuM02+k0TSro3jJH4MNLKNRHpk/ZUKV1bNVOLIdvXG17om4HL2u9WXOxzjBHwtATqE0l3EgaW016+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPr3Vr6TWZPdPtYl0j8ft01290WNWZw8bWF3tmEpssk=;
 b=d+/5Z0xP50CUQhVyU6d+OvAVGmDR8gyXn9sz8o/7EM3qNHalkg8o4OC6FC4buTqXeV3nqS10XtWbP89jwN+bD2xEjAEr2DfqNL8uo7gyYfzng5NKYAV5ipG28QYZ6RTPbfgwSi9nz3nO8xIM4haE1ymynOHUMol4JI1aGIZGvGw=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2409.eurprd08.prod.outlook.com (2603:10a6:3:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 06:14:52 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 06:14:52 +0000
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
        nd <nd@arm.com>, Haibo Xu <Haibo.Xu@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Topic: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Index: AQHWF4xRpK0ubTCCx0eiqM1JOH1VE6iDV3gAgAQ/ngCAAIMxgIAF/0YA
Date:   Tue, 28 Apr 2020 06:14:52 +0000
Message-ID: <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
 <20200424103953.GD1167@C02TD0UTHF1T.local>
In-Reply-To: <20200424103953.GD1167@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9de506dc-4d6b-4f80-eb11-08d7eb3b7bce
x-ms-traffictypediagnostic: HE1PR0802MB2409:|HE1PR0802MB2409:|AM6PR08MB3639:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB363948E13002F9243C99E2D1F4AC0@AM6PR08MB3639.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0387D64A71
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(66556008)(66946007)(66446008)(91956017)(76116006)(66476007)(64756008)(37006003)(2616005)(54906003)(2906002)(316002)(7416002)(5660300002)(71200400001)(36756003)(6862004)(6636002)(31686004)(31696002)(6486002)(26005)(8676002)(966005)(186003)(8936002)(81156014)(478600001)(86362001)(6512007)(4326008)(6506007)(53546011)(55236004)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: k0YuxqipcGgklTBhUmRLYgbAR9JQQtES+5mTXORWXOox85LnwOVfxpgo2acKI3T3dxKxvBfv1vJgYyKGClyPuMjizVYSTJBywEFfOZzYXa3nX8H8HiuD4zaZApKiKDIY/kaGfP2RjkBtjY6YwqMxmKrOZAcXmSgkSFsm8HC99K+nzVX7TGPl39v+SuV4px2lqUF9eMsQGuXrNGs3bqrTsgOaCDdUsSjmIkS7euy82WQ/au9sGtZGhZqllwt4Fd4FXvDr7GGkfHpGtsOXWMDoKfpUvzzGeUVdWSQEatHTKyTDs1Gejvy1C6fK9D2P5ZPHQFeXxzWFFSa9nx9XEuRnjknkr5yGRzbo0u3WGcl+FrVDbjrXU5LXAtIVopahYvdnufJC8HuEwPW1u/rsVfCiDvUEjPe06xzRaorUkJM3csyIhrQhHzk/6ybxX7tn8ly+yaTfFmDJVjbKcPypFWJEQMAzee2+AeSknaxq0S0VHv5OonwpBFeVRTo1GT+f8lUqJL5FBAGT0nhKO6kb2M1UYyqw5Y2PEGLGlbV3FdDbXyvBl4tzojZ26fi+jo3PLnYQ
x-ms-exchange-antispam-messagedata: iMUI5KkIEXOFBX7wprG2+LOR3xr8PEteplyfSvkzw9VX9yHGQFmapxMu41v2OW5iEBdJHIs+6J79WKdzkiBjzj+grRSpF65M2yf16hVQ9vjv+Mti3QGMjmxHXSgtSSc3R4FjfB+BrHxwMWDmseJpROhD2tuh1D1vLn4Vq9Vnfth26LT3kH3QSrcDMFFdZ2xK0mgSY8u2wIJ5aAy6P+96nj/lNfQ3dwsihHb0J6sdBxeB8ApAmlouhgLPhwDk1UsymI56f8ZIOKXjF1Vh3rg/EOmIXcGiba3ZXvP1fC/6+Zk8DboPvXfJrbSl5CCL4qfHm879wxJXktpNk/PrdNS0jBAmjca69KYhR9G7q2xZxrgoAVRgUq0Yccqx86bOcd7xyONTO2lFAFsHTxw+pb+BCiI1I5GvwPHNs4RdAzXSJEvwTQPziaMcxma9isMXXP9Wh9XrI0ZClajrvpvABXOhg9nq1jg9oCk7PcIHzHsSzIvK/8LlrgsXOPap95TwYMwJV0GzSWyz/bjjqeKE8lXQMr1qVWWAGzXFlM9PexNp1TrNUlfJmxzArIn6kO8/vKXCNGYK7GlnlhL7A75Q0yjpDkLkqW/gyyiV9v2vYQFOVUTSdcxfgHc/xao13Geh/ngYsbmudZCf0n+TdjnKJZExsLn2cFFrEBmX8e7IQHQuD68TE6dQFy7c88PO0hnXZP/gINZ1l9jSYt0rmh/tFpRC3WO1QxNklDsOGow1ocOiFxe62fYwVAzOskz7eT4ZaDlK26xItn6bBuqLlYPbHSLll20HyvhrbI+y5jM19sEvo5k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <457310EB5B4E5C4C8A3486656E7C6391@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2409
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966005)(36756003)(70586007)(70206006)(8936002)(6862004)(26005)(8676002)(336012)(186003)(2616005)(6506007)(2906002)(53546011)(31696002)(86362001)(81156014)(450100002)(6486002)(82740400003)(356005)(47076004)(81166007)(31686004)(6512007)(478600001)(966005)(6636002)(82310400002)(5660300002)(54906003)(37006003)(4326008)(316002)(21314003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: b4aceafe-ef1e-4932-5afd-08d7eb3b76c4
X-Forefront-PRVS: 0387D64A71
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iE4TkFcNNWTu2uqORz88aeyYFsiYwGcDakq38I1+ol7FB1rcyXaVxCZl/0mM6KbUmQCSVh3+O9bwJY1UXU1cOoxzJMw5x+muwVYRl8ZTfQ+Ev1EwsipmaJnI4m65xULXqBjc/ZfCzQ6FEEdGUuAz6YZz3hOR530w8DCzOuvGGMsH/af5feB22T+M3LxpYdNxk43NMxnAOoUxlJMBW1LkfWZJYg/E1hN3ytUNAduhRKb96i52lhAEBwPdtCtX3n0DblIExj4Ng59zSuWw9QC1UwUmuxfjGsGEt1kF6FjhjdmADxaDZi1CLhHM3LHuKk8b3b/ZSRNKkPt1/p79xM139Hxbgof2WGeDzZPp2CyanU3+3YePD2IEx3vra4c1P9fI+T+Xjz1/Vl2TThRINKBMeIrek6jVUstVC8ZqcJA9i+4gpcWHUSYmuiYz9lo28FTht3g86PU15b6cR7Z8rVD5PexHGPYCj144+uh6WuWEjaax75GMmyMdd3NgjigNdEa+ryOWJqzDQMZlVUGBW9CO+Ki3Mft05ZoEegzGnzD0R1dwzjaxmpugPTLPWxIBc0KPlfuvz2aHESgjeVOuomnKGku8rAZuuZMXz1BP48f8GfY=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 06:15:00.8540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de506dc-4d6b-4f80-eb11-08d7eb3b7bce
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3639
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAyMC80LzI0IDY6MzkgUE0sIE1hcmsgUnV0bGFuZCB3cm90ZToNCg0KaXQncyBhIHJlc2Vu
ZCBvZiB0aGUgbGFzdCBlbWFpbCwgcGxlYXNlIGlnbm9yZSBpZiB5b3UgaGF2ZSByZWNlaXZlZCB0
aGlzLg0KDQpIaSBNYXJrLA0KDQp0aGFuayB5b3UgZm9yIHJlbWFpbmRlciwgSSBob3BlIHRoaXMg
ZW1haWwgaXMgaW4gdGhlIGNvcnJlY3QgZm9ybWF0Lg0KDQo+IE9uIEZyaSwgQXByIDI0LCAyMDIw
IGF0IDAzOjUwOjIyQU0gKzAxMDAsIEppYW55b25nIFd1IHdyb3RlOg0KPj4gT24gMjAyMC80LzIx
IDU6NTcgUE0sIE1hcmsgUnV0bGFuZCB3cm90ZToNCj4+PiBPbiBUdWUsIEFwciAyMSwgMjAyMCBh
dCAxMToyMzowMEFNICswODAwLCBKaWFueW9uZyBXdSB3cm90ZToNCj4+Pj4gZGlmZiAtLWdpdCBh
L3ZpcnQva3ZtL2FybS9oeXBlcmNhbGxzLmMgYi92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+
Pj4+IGluZGV4IDU1MGRmYTNlNTNjZC4uYTUzMDljMjhkNGRjIDEwMDY0NA0KPj4+PiAtLS0gYS92
aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+Pj4+ICsrKyBiL3ZpcnQva3ZtL2FybS9oeXBlcmNh
bGxzLmMNCj4+Pj4gQEAgLTYyLDYgKzY2LDQ0IEBAIGludCBrdm1faHZjX2NhbGxfaGFuZGxlcihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+Pj4+ICAgIGlmIChncGEgIT0gR1BBX0lOVkFMSUQpDQo+
Pj4+ICAgIHZhbCA9IGdwYTsNCj4+Pj4gICAgYnJlYWs7DQo+Pj4+ICsvKg0KPj4+PiArICogVGhp
cyBzZXJ2ZXMgdmlydHVhbCBrdm1fcHRwLg0KPj4+PiArICogRm91ciB2YWx1ZXMgd2lsbCBiZSBw
YXNzZWQgYmFjay4NCj4+Pj4gKyAqIHJlZzAgc3RvcmVzIGhpZ2ggMzItYml0IGhvc3Qga3RpbWU7
DQo+Pj4+ICsgKiByZWcxIHN0b3JlcyBsb3cgMzItYml0IGhvc3Qga3RpbWU7DQo+Pj4+ICsgKiBy
ZWcyIHN0b3JlcyBoaWdoIDMyLWJpdCBkaWZmZXJlbmNlIG9mIGhvc3QgY3ljbGVzIGFuZCBjbnR2
b2ZmOw0KPj4+PiArICogcmVnMyBzdG9yZXMgbG93IDMyLWJpdCBkaWZmZXJlbmNlIG9mIGhvc3Qg
Y3ljbGVzIGFuZCBjbnR2b2ZmLg0KPj4+PiArICovDQo+Pj4+ICtjYXNlIEFSTV9TTUNDQ19IWVBf
S1ZNX1BUUF9GVU5DX0lEOg0KPj4+IFNob3VsZG4ndCB0aGUgaG9zdCBvcHQtaW4gdG8gcHJvdmlk
aW5nIHRoaXMgdG8gdGhlIGd1ZXN0LCBhcyB3aXRoIG90aGVyDQo+Pj4gZmVhdHVyZXM/DQo+PiBl
ciwgZG8geW91IG1lYW4gdGhhdCAiQVJNX1NNQ0NDX0hWX1BWX1RJTUVfWFhYIiBhcyAib3B0LWlu
Ij8gaWYgc28sIEkNCj4+IHRoaW5rIHRoaXMNCj4+DQo+PiBrdm1fcHRwIGRvZXNuJ3QgbmVlZCBh
IGJ1ZGR5LiB0aGUgZHJpdmVyIGluIGd1ZXN0IHdpbGwgY2FsbCB0aGlzIHNlcnZpY2UNCj4+IGlu
IGEgZGVmaW5pdGUgd2F5Lg0KPiBJIG1lYW4gdGhhdCB3aGVuIGNyZWF0aW5nIHRoZSBWTSwgdXNl
cnNwYWNlIHNob3VsZCBiZSBhYmxlIHRvIGNob29zZQ0KPiB3aGV0aGVyIHRoZSBQVFAgc2Vydmlj
ZSBpcyBwcm92aWRlZCB0byB0aGUgZ3Vlc3QuIFRoZSBob3N0IHNob3VsZG4ndA0KPiBhbHdheXMg
cHJvdmlkZSBpdCBhcyB0aGVyZSBtYXkgYmUgY2FzZXMgd2hlcmUgZG9pbmcgc28gaXMgdW5kZXNp
cmVhYmxlLg0KPg0KSSB0aGluayBJIGhhdmUgaW1wbGVtZW50ZWQgaW4gcGF0Y2ggOS85IHRoYXQg
dXNlcnNwYWNlIGNhbiBnZXQgdGhlIGluZm8gDQp0aGF0IGlmIHRoZSBob3N0IG9mZmVycyB0aGUg
a3ZtX3B0cCBzZXJ2aWNlLiBCdXQgZm9yIG5vdywgdGhlIGhvc3QgDQprZXJuZWwgd2lsbCBhbHdh
eXMgb2ZmZXIgdGhlIGt2bV9wdHAgY2FwYWJpbGl0eSBpbiB0aGUgY3VycmVudCANCmltcGxlbWVu
dGF0aW9uLiBJIHRoaW5rIHg4NiBmb2xsb3cgdGhlIHNhbWUgYmVoYXZpb3IgKHNlZSBbMV0pLiBz
byBJIA0KaGF2ZSBub3QgY29uc2lkZXJlZCB3aGVuIGFuZCBob3cgdG8gZGlzYWJsZSB0aGlzIGt2
bV9wdHAgc2VydmljZSBpbiANCmhvc3QuIERvIHlvdSB0aGluayB3ZSBzaG91bGQgb2ZmZXIgdGhp
cyBvcHQtaW4/DQoNClsxXSBrdm1fcHZfY2xvY2tfcGFpcmluZygpIGluIA0KaHR0cHM6Ly9naXRo
dWIuY29tL3RvcnZhbGRzL2xpbnV4L2Jsb2IvbWFzdGVyL2FyY2gveDg2L2t2bS94ODYuYw0KDQo+
Pj4+ICsvKg0KPj4+PiArICogc3lzdGVtIHRpbWUgYW5kIGNvdW50ZXIgdmFsdWUgbXVzdCBjYXB0
dXJlZCBpbiB0aGUgc2FtZQ0KPj4+PiArICogdGltZSB0byBrZWVwIGNvbnNpc3RlbmN5IGFuZCBw
cmVjaXNpb24uDQo+Pj4+ICsgKi8NCj4+Pj4gK2t0aW1lX2dldF9zbmFwc2hvdCgmc3lzdGltZV9z
bmFwc2hvdCk7DQo+Pj4+ICtpZiAoc3lzdGltZV9zbmFwc2hvdC5jc19pZCAhPSBDU0lEX0FSTV9B
UkNIX0NPVU5URVIpDQo+Pj4+ICticmVhazsNCj4+Pj4gK2FyZ1swXSA9IHVwcGVyXzMyX2JpdHMo
c3lzdGltZV9zbmFwc2hvdC5yZWFsKTsNCj4+Pj4gK2FyZ1sxXSA9IGxvd2VyXzMyX2JpdHMoc3lz
dGltZV9zbmFwc2hvdC5yZWFsKTsNCj4+PiBXaHkgZXhhY3RseSBkb2VzIHRoZSBndWVzdCBuZWVk
IHRoZSBob3N0J3MgcmVhbCB0aW1lPyBOZWl0aGVyIHRoZSBjb3Zlcg0KPj4+IGxldHRlciBub3Ig
dGhpcyBjb21taXQgbWVzc2FnZSBoYXZlIGV4cGxhaW5lZCB0aGF0LCBhbmQgZm9yIHRob3NlIG9m
IHVzDQo+Pj4gdW5mYW1saWFyIHdpdGggUFRQIGl0IHdvdWxkIGJlIHZlcnkgaGVscGZ1bCB0byBr
bm93IHRoYXQgdG8gdW5kZXJzdGFuZA0KPj4+IHdoYXQncyBnb2luZyBvbi4NCj4+IG9oLCBzb3Jy
eSwgSSBzaG91bGQgaGF2ZSBhZGRlZCBtb3JlIGJhY2tncm91bmQga25vd2xlZGdlIGhlcmUuDQo+
Pg0KPj4ganVzdCBnaXZlIHNvbWUgaGludHMgaGVyZToNCj4+DQo+PiB0aGUga3ZtX3B0cCB0YXJn
ZXRzIHRvIHN5bmMgZ3Vlc3QgdGltZSB3aXRoIGhvc3QuIHNvbWUgc2VydmljZXMgaW4gdXNlcg0K
Pj4gc3BhY2UNCj4+DQo+PiBsaWtlIGNocm9ueSBjYW4gZG8gdGltZSBzeW5jIGJ5IGlucHV0aW5n
IHRpbWUoaW4ga3ZtX3B0cCBhbHNvIGNsb2NrDQo+PiBjb3VudGVyIHNvbWV0aW1lcykgZnJvbQ0K
Pj4NCj4+IHJlbW90ZSBjbG9ja3NvdXJjZShvZnRlbiBuZXR3b3JrIGNsb2Nrc291cmNlKS4gVGhp
cyBrdm1fcHRwIGRyaXZlciBjYW4NCj4+IG9mZmVyIGEgaW50ZXJmYWNlIGZvcg0KPj4NCj4+IHRo
b3NlIHVzZXIgc3BhY2Ugc2VydmljZSBpbiBndWVzdCB0byBnZXQgdGhlIGhvc3QgdGltZSB0byBk
byB0aW1lIHN5bmMNCj4+IGluIGd1ZXN0Lg0KPiBJIHRoaW5rIGl0IHdvdWxkIGJlIHZlcnkgaGVs
cGZ1bCBmb3IgdGhlIGNvbW1pdCBtZXNzYWdlIGFuZC9vciBjb3Zlcg0KPiBsZXR0ZXIgdG8gaGF2
ZSBhIGhpZ2gtbGV2ZWwgZGVzY3RpcHRpb24gb2Ygd2hhdCBQVFAgaXMgbWVhbnQgdG8gZG8sIGFu
ZA0KPiBhbiBvdXRsaW5lIG9mIHRoZSBhbGdvcml0aG1tIChjbGVhcmx5IHNwbGl0dGluZyB0aGUg
aG9zdCBhbmQgZ3Vlc3QNCj4gYml0cykuDQoNCm9rLCBJIHdpbGwgYWRkIGhpZ2gtbGV2ZWwgcHJp
bmNpcGxlIG9mIGt2bV9wdHAgaW4gY29tbWl0IG1lc3NhZ2UuDQoNCj4gSXQncyBhbHNvIG5vdCBj
bGVhciB0byBtZSB3aGF0IG5vdGlvbiBvZiBob3N0IHRpbWUgaXMgYmVpbmcgZXhwb3NlZCB0bw0K
PiB0aGUgZ3Vlc3QgKGFuZCBjb25zZXF1ZW50bHkgaG93IHRoaXMgd291bGQgaW50ZXJhY3Qgd2l0
aCB0aW1lIGNoYW5nZXMgb24NCj4gdGhlIGhvc3QsIHRpbWUgbmFtZXNwYWNlcywgZXRjKS4gSGF2
aW5nIHNvbWUgZGVzY3JpcHRpb24gb2YgdGhhdCB3b3VsZA0KPiBiZSB2ZXJ5IGhlbHBmdWwuDQoN
CnNvcnJ5IHRvIGhhdmUgbm90IG1hZGUgaXQgY2xlYXIuDQoNClRpbWUgd2lsbCBub3QgY2hhbmdl
IGluIGhvc3QgYW5kIG9ubHkgdGltZSBpbiBndWVzdCB3aWxsIGNoYW5nZSB0byBzeW5jIA0Kd2l0
aCBob3N0LiBob3N0IHRpbWUgaXMgdGhlIHRhcmdldCB0aGF0IHRpbWUgaW4gZ3Vlc3Qgd2FudCB0
byBhZGp1c3QgdG8uIA0KZ3Vlc3QgbmVlZCB0byBnZXQgdGhlIGhvc3QgdGltZSB0aGVuIGNvbXB1
dGUgdGhlIGRpZmZlcmVudCBvZiB0aGUgdGltZSANCmluIGd1ZXN0IGFuZCBob3N0LCBzbyB0aGUg
Z3Vlc3QgY2FuIGFkanVzdCB0aGUgdGltZSBiYXNlIG9uIHRoZSBkaWZmZXJlbmNlLg0KDQpJIHdp
bGwgYWRkIHRoZSBiYXNlIHByaW5jaXBsZSBvZiB0aW1lIHN5bmMgc2VydmljZSBpbiBndWVzdCB1
c2luZyANCmt2bV9wdHAgaW4gY29tbWl0IG1lc3NhZ2UuDQoNCg0KVGhhbmtzDQoNCkppYW55b25n
DQoNCj4gVGhhbmtzLA0KPiBNYXJrLg0KDQoNCi0tPg0K
