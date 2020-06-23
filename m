Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF6204EF5
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgFWKXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:23:39 -0400
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:24846
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731158AbgFWKXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiJESe1t04aQ70FifmeklprXLp7gGNzOFTuEJE086U=;
 b=9vNp7NBCB+fJOoSt54wCl0+QxultOsj9xItLUoz44USQSplPG9/LvHosmHb095qSr5+FJpRb8jGUlyS4MPIi+yf3I8RhPUujflPLUQYunoo5CAsLyGxk9BO67wMQY5GllvAL8EIvry6CZYZyl6deQsSDBvShFdn5GEJiDu3+09Q=
Received: from DB8PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:10:110::20)
 by VI1PR0801MB2047.eurprd08.prod.outlook.com (2603:10a6:800:83::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 10:23:28 +0000
Received: from DB5EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:110:cafe::9b) by DB8PR04CA0010.outlook.office365.com
 (2603:10a6:10:110::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend
 Transport; Tue, 23 Jun 2020 10:23:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT008.mail.protection.outlook.com (10.152.20.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:23:28 +0000
Received: ("Tessian outbound da41658aa5d4:v59"); Tue, 23 Jun 2020 10:23:28 +0000
X-CR-MTA-TID: 64aa7808
Received: from 248a3c0dc87e.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id F20CC0B6-D8E4-4834-BB6B-ED6281F3EEA3.1;
        Tue, 23 Jun 2020 10:23:23 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 248a3c0dc87e.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 23 Jun 2020 10:23:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEMVKb4DUJzVDZhmO01Rb9K7Pb9Xkx2e7mj3qYVfflYSYUyxuTxjkIPLiDRR7YeahFNlhhBkRCS3dr3kArZVX68EwrLLOrg9pqSvFL7FTL9VsrLgU7O/Kw04i+13W3YCzC8FQL3ak7fR+NbIKbTmbzhqi85yQtLSUfa/29fBOdTb4FhemzdHaaAA6MO4H1UcQ0fa1+LT0G2wYYIUYbBFQvQnmDu6dLdYhJRbW8De4sbCkY9k50TEOTfaz1xu2Ui4atbTamFk1jU5hRAeGNxZfqcUbLDPO4QVsn8HK+h7wfxqAdm18AEUMapdtcxx2ZuyeUMFlAmGDq0oPFosZX1NtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiJESe1t04aQ70FifmeklprXLp7gGNzOFTuEJE086U=;
 b=dQLTqeGZ1CT5q6hhYe04j30VcNfyERT164QEKKlCtrWcDpuBXrA20nHOl9tFCTFtJc/ewDjSRSAPlgwrx2YKCWfOg9SYuSLYzm3rWq04qe+cNG60Eipokb4sRPPInGUkpLMFBJBL8g7fw7IlbfMXn6J3lFE2NpU14C4gL0P6KtsBZy4EoyPJkK/fy8Ce42VZAlOpua+SZZ0gmc10Do0EgY/ikDqAEbzR1BKNXSWtPKThEvVmbV+IdnBfqZDWCYGLRZyCvxW2HDaINhmE2D5bxB+s6P2UWgzNOvrtwSef7oF3vtso32MJ+OI/cpQ2lLfceuO3FhQuL7eyn/EKWeNMzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiJESe1t04aQ70FifmeklprXLp7gGNzOFTuEJE086U=;
 b=9vNp7NBCB+fJOoSt54wCl0+QxultOsj9xItLUoz44USQSplPG9/LvHosmHb095qSr5+FJpRb8jGUlyS4MPIi+yf3I8RhPUujflPLUQYunoo5CAsLyGxk9BO67wMQY5GllvAL8EIvry6CZYZyl6deQsSDBvShFdn5GEJiDu3+09Q=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2539.eurprd08.prod.outlook.com (2603:10a6:3:da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 10:23:20 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:23:19 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Steven Price <Steven.Price@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: RE: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm
 ptp.
Thread-Index: AQHWRhxz06Mst+c5/kmb7LupZG0AtqjfwQIAgAQdABCAAIscAIABjR8g
Date:   Tue, 23 Jun 2020 10:23:19 +0000
Message-ID: <HE1PR0802MB2555318C0E7BCC653BC1D4F2F4940@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
 <20200619093033.58344-8-jianyong.wu@arm.com>
 <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
 <HE1PR0802MB25558F9A526C327134C7A7EEF4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <f331dc59-5642-33b0-9a37-553b7f536afe@arm.com>
In-Reply-To: <f331dc59-5642-33b0-9a37-553b7f536afe@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: f0caa67c-2ca3-4ae9-abee-fde16c26cb38.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e2a4e0fc-12d1-4626-31e9-08d8175f7881
x-ms-traffictypediagnostic: HE1PR0802MB2539:|VI1PR0801MB2047:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB2047B6E5F74B267026BD76E6F4940@VI1PR0801MB2047.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rcj7IV5zpBGplifIc2gOBTqrjmn/QL+l0K/gAny46KzrUDLDEmvSdUm+gD2lhEDMtfTd0lKrMo40Z+LNkD5iDX/FDOZ1qQ5RgyF/MgNMEGqvXf/tintv296iiE6RDpdi/qLmdDQkz6DZaDlogw+tVhECGHs11BECuipJQj2l4/+nLXS5e/82oFbkBJO1SyjKDotUoXT+Jk4M2HrBFcE2jqLja0d+8udVJDVi6QmdtgaP/mjmma4IBesIcZswbpUfR975iv607YtX0kw6tnSBbfMqwSMuVPS3nlGwwZfK2fKLC0OBexwHRFfRAUdOodvY1I8KDgrPzcF5kNT7TwMxhGC3b/qpeya5jQCKguB6VWdT+XhSqA2tldJkE0qVBYuM
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(6636002)(8676002)(5660300002)(52536014)(86362001)(8936002)(64756008)(66446008)(66476007)(71200400001)(83380400001)(66946007)(33656002)(76116006)(66556008)(4326008)(6506007)(53546011)(186003)(26005)(2906002)(55016002)(9686003)(478600001)(110136005)(316002)(54906003)(7696005)(7416002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pBp84UACRGVG/xMQ+MPPBUPb5cepU7HEsiGongCifA+btpCWiKja9XUnu8YOkADifP3EYE0BXup7ICYEPaWP1hQ7e8ki4lQ33eVcgZuqGYiMXqgoNHjtBv0ryJq53+1TGF7/T9pQzGss7nDr9R+SuTqfBRofEDmw5tvZE3+3no3AgQ3iS6CNF6MfGDZjTSgByFMbSR5t6QlXjSXj8kHAXwEqJYYKhNRz9SJD+pEhEk/svaPyJKsB8UmvetVq4sa9UKr/UgmhHvaZQyGoVgb5l1AJlDJdrfnNd4AOXB1PfnZ3/SGJ44KIFxJl4Qq5AvlpZUvMJD3KKfKmNTKEVmOrjeFUA5t12LLyiunMKfRqKDPFphSaUGIm5b7L/SqyGoGajQd47xjsyN1wWIT01WzCToiW40qr0WhYR5pfBMIXGo80/x9icGlSVfbAOfZG0VhRQ60XmcZKH/hwNauAsxvCEV2J83/nNoShqKio+JfT/0s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2539
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT008.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966005)(47076004)(336012)(9686003)(316002)(82740400003)(70586007)(450100002)(26005)(83380400001)(478600001)(6506007)(53546011)(8676002)(81166007)(86362001)(4326008)(6636002)(8936002)(5660300002)(7696005)(186003)(52536014)(82310400002)(54906003)(55016002)(356005)(33656002)(70206006)(110136005)(2906002)(921003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: b6912019-afb5-4593-169f-08d8175f736a
X-Forefront-PRVS: 04433051BF
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ka1t1yEakexsAqWtXFhq9Ti2ARk2iGUQqUL5aKfM1XYHArp4uPeJRADqdGS2YDTBk2pKqR6FcQm/UFAO5WJxyAlKlEs0DPhQ2nd3XehKG7kxb0AY9PkosVeK43mG/rkf8QYZiPUpEPHRxuTbNUEaGlYj26ntl+0RRKAEXvn1XCwDzSu1ibfKyFYkd3IuXFfWv9khA9YKuICaFsQdbw5iqoVz9SLsIaTvjc7ESTksmisbuRTKqm1O1+Qo+BbGrTRcof+2YpxFhsAZMh185hEL3VWL54GGG0OjvG+NY0Cv26LT+JK6ER+OepJZygRa0n/8J0pEtAKvDxYIaafsoRWsFd68OU/Ny418Nlk2XtSCHf8/p/j52aLWksleczyOFH26aPys7K+aWJXClWCmbJ/GUi4zoGFoLKJg5HmrylKGyqw=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:23:28.3860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a4e0fc-12d1-4626-31e9-08d8175f7881
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB2047
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgc3RldmVuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0ZXZl
biBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSnVuZSAyMiwg
MjAyMCA1OjUxIFBNDQo+IFRvOiBKaWFueW9uZyBXdSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHlhbmdiby5sdUBueHAuY29tOyBqb2huLnN0dWx0ekBs
aW5hcm8ub3JnOyB0Z2x4QGxpbnV0cm9uaXguZGU7DQo+IHBib256aW5pQHJlZGhhdC5jb207IHNl
YW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb207IG1hekBrZXJuZWwub3JnOw0KPiByaWNoYXJk
Y29jaHJhbkBnbWFpbC5jb207IE1hcmsgUnV0bGFuZCA8TWFyay5SdXRsYW5kQGFybS5jb20+Ow0K
PiB3aWxsQGtlcm5lbC5vcmc7IFN1enVraSBQb3Vsb3NlIDxTdXp1a2kuUG91bG9zZUBhcm0uY29t
Pg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnOw0KPiBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1OyBrdm1A
dmdlci5rZXJuZWwub3JnOyBTdGV2ZSBDYXBwZXINCj4gPFN0ZXZlLkNhcHBlckBhcm0uY29tPjsg
S2FseSBYaW4gPEthbHkuWGluQGFybS5jb20+OyBKdXN0aW4gSGUNCj4gPEp1c3Rpbi5IZUBhcm0u
Y29tPjsgV2VpIENoZW4gPFdlaS5DaGVuQGFybS5jb20+OyBuZCA8bmRAYXJtLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtSRkMgUEFUQ0ggdjEzIDcvOV0gYXJtNjQva3ZtOiBBZGQgaHlwZXJjYWxsIHNl
cnZpY2UgZm9yIGt2bQ0KPiBwdHAuDQo+IA0KPiBPbiAyMi8wNi8yMDIwIDAzOjI1LCBKaWFueW9u
ZyBXdSB3cm90ZToNCj4gPiBIaSBTdGV2ZW4sDQo+IA0KPiBIaSBKaWFueW9uZw0KPiANCj4gWy4u
Ll0NCj4gPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXBlcmNhbGxzLmMNCj4gPj4+
IGIvYXJjaC9hcm02NC9rdm0vaHlwZXJjYWxscy5jIGluZGV4IGRiNmRjZTNkMGUyMy4uMzY2YjA2
NDZjMzYwDQo+ID4+PiAxMDA2NDQNCj4gPj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cGVyY2Fs
bHMuYw0KPiA+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlwZXJjYWxscy5jDQo+ID4+PiBAQCAt
Myw2ICszLDcgQEANCj4gPj4+DQo+ID4+PiAgICAjaW5jbHVkZSA8bGludXgvYXJtLXNtY2NjLmg+
DQo+ID4+PiAgICAjaW5jbHVkZSA8bGludXgva3ZtX2hvc3QuaD4NCj4gPj4+ICsjaW5jbHVkZSA8
bGludXgvY2xvY2tzb3VyY2VfaWRzLmg+DQo+ID4+Pg0KPiA+Pj4gICAgI2luY2x1ZGUgPGFzbS9r
dm1fZW11bGF0ZS5oPg0KPiA+Pj4NCj4gPj4+IEBAIC0xMSw2ICsxMiwxMCBAQA0KPiA+Pj4NCj4g
Pj4+ICAgIGludCBrdm1faHZjX2NhbGxfaGFuZGxlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
ID4+PiAgICB7DQo+ID4+PiArI2lmZGVmIENPTkZJR19BUk02NF9LVk1fUFRQX0hPU1QNCj4gPj4+
ICsJc3RydWN0IHN5c3RlbV90aW1lX3NuYXBzaG90IHN5c3RpbWVfc25hcHNob3Q7DQo+ID4+PiAr
CXU2NCBjeWNsZXMgPSAwOw0KPiA+Pj4gKyNlbmRpZg0KPiA+Pj4gICAgCXUzMiBmdW5jX2lkID0g
c21jY2NfZ2V0X2Z1bmN0aW9uKHZjcHUpOw0KPiA+Pj4gICAgCXUzMiB2YWxbNF0gPSB7U01DQ0Nf
UkVUX05PVF9TVVBQT1JURUR9Ow0KPiA+Pj4gICAgCXUzMiBmZWF0dXJlOw0KPiA+Pj4gQEAgLTcw
LDcgKzc1LDUyIEBAIGludCBrdm1faHZjX2NhbGxfaGFuZGxlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpDQo+ID4+PiAgICAJCWJyZWFrOw0KPiA+Pj4gICAgCWNhc2UgQVJNX1NNQ0NDX1ZFTkRPUl9I
WVBfS1ZNX0ZFQVRVUkVTX0ZVTkNfSUQ6DQo+ID4+PiAgICAJCXZhbFswXSA9IEJJVChBUk1fU01D
Q0NfS1ZNX0ZVTkNfRkVBVFVSRVMpOw0KPiA+Pj4gKw0KPiA+Pj4gKyNpZmRlZiBDT05GSUdfQVJN
NjRfS1ZNX1BUUF9IT1NUDQo+ID4+PiArCQl2YWxbMF0gfD0gQklUKEFSTV9TTUNDQ19LVk1fRlVO
Q19LVk1fUFRQKTsgI2VuZGlmDQo+ID4+PiArCQlicmVhazsNCj4gPj4+ICsNCj4gPj4+ICsjaWZk
ZWYgQ09ORklHX0FSTTY0X0tWTV9QVFBfSE9TVA0KPiA+Pj4gKwkvKg0KPiA+Pj4gKwkgKiBUaGlz
IHNlcnZlcyB2aXJ0dWFsIGt2bV9wdHAuDQo+ID4+PiArCSAqIEZvdXIgdmFsdWVzIHdpbGwgYmUg
cGFzc2VkIGJhY2suDQo+ID4+PiArCSAqIHJlZzAgc3RvcmVzIGhpZ2ggMzItYml0IGhvc3Qga3Rp
bWU7DQo+ID4+PiArCSAqIHJlZzEgc3RvcmVzIGxvdyAzMi1iaXQgaG9zdCBrdGltZTsNCj4gPj4+
ICsJICogcmVnMiBzdG9yZXMgaGlnaCAzMi1iaXQgZGlmZmVyZW5jZSBvZiBob3N0IGN5Y2xlcyBh
bmQgY250dm9mZjsNCj4gPj4+ICsJICogcmVnMyBzdG9yZXMgbG93IDMyLWJpdCBkaWZmZXJlbmNl
IG9mIGhvc3QgY3ljbGVzIGFuZCBjbnR2b2ZmLg0KPiA+Pj4gKwkgKi8NCj4gPj4+ICsJY2FzZSBB
Uk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX0ZVTkNfSUQ6DQo+ID4+PiArCQkvKg0KPiA+Pj4g
KwkJICogc3lzdGVtIHRpbWUgYW5kIGNvdW50ZXIgdmFsdWUgbXVzdCBjYXB0dXJlZCBpbiB0aGUg
c2FtZQ0KPiA+Pj4gKwkJICogdGltZSB0byBrZWVwIGNvbnNpc3RlbmN5IGFuZCBwcmVjaXNpb24u
DQo+ID4+PiArCQkgKi8NCj4gPj4+ICsJCWt0aW1lX2dldF9zbmFwc2hvdCgmc3lzdGltZV9zbmFw
c2hvdCk7DQo+ID4+PiArCQlpZiAoc3lzdGltZV9zbmFwc2hvdC5jc19pZCAhPSBDU0lEX0FSTV9B
UkNIX0NPVU5URVIpDQo+ID4+PiArCQkJYnJlYWs7DQo+ID4+PiArCQl2YWxbMF0gPSB1cHBlcl8z
Ml9iaXRzKHN5c3RpbWVfc25hcHNob3QucmVhbCk7DQo+ID4+PiArCQl2YWxbMV0gPSBsb3dlcl8z
Ml9iaXRzKHN5c3RpbWVfc25hcHNob3QucmVhbCk7DQo+ID4+PiArCQkvKg0KPiA+Pj4gKwkJICog
d2hpY2ggb2YgdmlydHVhbCBjb3VudGVyIG9yIHBoeXNpY2FsIGNvdW50ZXIgYmVpbmcNCj4gPj4+
ICsJCSAqIGFza2VkIGZvciBpcyBkZWNpZGVkIGJ5IHRoZSBmaXJzdCBhcmd1bWVudCBvZiBzbWNj
Yw0KPiA+Pj4gKwkJICogY2FsbC4gSWYgbm8gZmlyc3QgYXJndW1lbnQgb3IgaW52YWxpZCBhcmd1
bWVudCwgemVybw0KPiA+Pj4gKwkJICogY291bnRlciB2YWx1ZSB3aWxsIHJldHVybjsNCj4gPj4+
ICsJCSAqLw0KPiA+Pg0KPiA+PiBJdCdzIG5vdCBhY3R1YWxseSBwb3NzaWJsZSB0byBoYXZlICJu
byBmaXJzdCBhcmd1bWVudCIgLSB0aGVyZSdzIG5vDQo+ID4+IGFyZ3VtZW50IGNvdW50LCBzbyB3
aGF0ZXZlciBpcyBpbiB0aGUgcmVnaXN0ZXIgZHVyaW5nIHRoZSBjYWxsIHdpdGgNCj4gPj4gYmUg
cGFzc2VkLiBJJ2QgYWxzbyBjYXV0aW9uIHRoYXQgImZpcnN0IGFyZ3VtZW50IiBpcyBhbWJpZ2lv
dXM6IHIwDQo+ID4+IGNvdWxkIGJlIHRoZSAnZmlyc3QnIGJ1dCBpcyBhbHNvIHRoZSBmdW5jdGlv
biBudW1iZXIsIGhlcmUgeW91IG1lYW4gcjEuDQo+ID4+DQo+ID4gU29ycnksICBJIHJlYWxseSBt
YWtlIG1pc3Rha2UgaGVyZSwgSSByZWFsbHkgbWVhbiBubyByMSB2YWx1ZS4NCj4gDQo+IE15IHBv
aW50IGlzIHRoYXQgaXQncyBub3QgcG9zc2libGUgdG8gaGF2ZSAibm8gcjEgdmFsdWUiIC0gcjEg
YWx3YXlzIGhhcyBhIHZhbHVlLg0KPiBTbyB5b3UgY2FuIGhhdmUgYW4gImludmFsaWQgYXJndW1l
bnQiIChyMSBoYXMgYSB2YWx1ZSB3aGljaCBpc24ndCB2YWxpZCksIGJ1dA0KPiBpdCdzIG5vdCBw
b3NzaWJsZSB0byBoYXZlICJubyBmaXJzdCBhcmd1bWVudCIuIEl0IHdvdWxkIG9ubHkgYmUgcG9z
c2libGUgdG8NCj4gaGF2ZSBubyBhcmd1bWVudCBpZiB0aGUgaW50ZXJmYWNlIHRvbGQgdXMgaG93
IG1hbnkgYXJndW1lbnRzIHdlcmUgdmFsaWQsDQo+IGJ1dCBTTUNDQyBkb2Vzbid0IGRvIHRoYXQu
DQo+IA0KT2gsIHNvcnJ5IGFnYWluLCBpdCBzaG91bGQgYmUgIm5vIHZhbGlkIHIxIHZhbHVlIi4g
VGhhbmtzIGZvciBjbGFyaWZ5aW5nIHRoaXMgaXNzdWUuDQoNCj4gPj4gVGhlcmUncyBhbHNvIGEg
c3VidGxlIGNhc3QgdG8gMzIgYml0cyBoZXJlIChmZWF0dXJlIGlzIHUzMiksIHdoaWNoDQo+ID4+
IG1pZ2h0IGJlIHdvcnRoIGEgY29tbWVudCBiZWZvcmUgc29tZW9uZSAnb3B0aW1pc2VzJyBieSBy
ZW1vdmluZyB0aGUNCj4gJ2ZlYXR1cmUnDQo+ID4+IHZhcmlhYmxlLg0KPiA+Pg0KPiA+IFllYWgs
IGl0J3MgYmV0dGVyIHRvIGFkZCBhIG5vdGUsIGJ1dCBJIHRoaW5rIGl0J3MgYmV0dGVyIGFkZCBp
dCBhdCB0aGUgZmlyc3QgdGltZQ0KPiBjYWxsaW5nIHNtY2NjX2dldF9hcmcxLg0KPiA+IFdEWVQ/
DQo+IA0KPiBJJ20gYSBiaXQgY29uZnVzZWQgYWJvdXQgd2hlcmUgZXhhY3RseSB5b3Ugd2VyZSBz
dWdnZXN0aW5nLiBUaGUgYXNzaWdubWVudA0KPiAoYW5kIGltcGxpY2l0IGNhc3QpIGFyZSBqdXN0
IGJlbG93LCBzbyB0aGlzIGNvbW1lbnQgYmxvY2sgc2VlbWVkIGEgc2Vuc2libGUNCj4gcGxhY2Ug
dG8gYWRkIHRoZSBub3RlLiBCdXQgSSBkb24ndCByZWFsbHkgbWluZCBleGFjdGx5IHdoZXJlIHlv
dSBwdXQgaXQgKGFzIGxvbmcNCj4gYXMgaXQncyBjbG9zZSksIGl0J3MganVzdCBhIHN1YnRsZSBk
ZXRhaWwgdGhhdCBtaWdodCBnZXQgbG9zdCBpZiB0aGVyZSBpc24ndCBhDQo+IGNvbW1lbnQuDQo+
IA0KT2ssIEkgd2lsbCBhZGQgYSBub3RlIGJlZm9yZSBzbWNjY19nZXRfYXJnMSBjYWxsZWQuDQoN
Cj4gPj4gRmluYWxseSBJJ20gbm90IHN1cmUgaWYgemVybyBjb3VudGVyIHZhbHVlIGlzIGJlc3Qg
LSB3b3VsZCBpdCBub3QgYmUNCj4gPj4gcG9zc2libGUgZm9yIHRoaXMgdG8gYmUgYSB2YWxpZCBj
b3VudGVyIHZhbHVlPw0KPiA+DQo+ID4gV2UgaGF2ZSB0d28gZGlmZmVyZW50IHdheXMgdG8gY2Fs
bCB0aGlzIHNlcnZpY2UgaW4gcHRwX2t2bSBndWVzdCwgb25lDQo+ID4gbmVlZHMgY291bnRlciBj
eWNsZSwgIHRoZSBvdGhlciBub3QuIFNvIEkgdGhpbmsgaXQncyB2YWluIHRvIHJldHVybiBhIHZh
bGlkDQo+IGNvdW50ZXIgY3ljbGUgYmFjayBpZiB0aGUgcHRwX2t2bSBkb2VzIG5vdCBuZWVkcyBp
dC4NCj4gDQo+IFNvcnJ5LCBJIGRpZG4ndCB3cml0ZSB0aGF0IHZlcnkgY2xlYXJseS4gV2hhdCBJ
IG1lYW50IGlzIHRoYXQgcmV0dXJuaW5nICcwJyBpbiB0aGUNCj4gY2FzZSBvZiBhbiBpbnZhbGlk
IGFyZ3VtZW50IG1pZ2h0IGJlIGRpZmZpY3VsdCB0byByZWNvZ25pc2UuDQo+ICcwJyBtYXkgYmUg
YSB2YWxpZCByZWFkaW5nIG9mIGEgY291bnRlciAoZS5nLiByZWFkaW5nIHRoZSBjb3VudGVyIGp1
c3QgYWZ0ZXIgdGhlDQo+IFZNIGhhcyBiZWVuIGNyZWF0ZWQgaWYgdGhlIGNvdW50ZXIgaW5jcmVt
ZW50cyB2ZXJ5IHNsb3dseSkuIFNvIGl0IG1heSBiZQ0KPiB3b3J0aCB1c2luZyBhIGRpZmZlcmVu
dCB2YWx1ZSB3aGVuIGFuIGludmFsaWQgYXJndW1lbnQgaGFzIGJlZW4gc3BlY2lmaWVkLg0KPiBF
LmcuIGFuICJhbGwgb25lcyIgKC0xKSB2YWx1ZSBtYXkgYmUgbW9yZSByZWNvZ25pc2FibGUuDQo+
DQpPaywgLTEgaXMgYmV0dGVyIHRoYW4gMC4NCiANCj4gSW4gcHJhY3RpY2UgbW9zdCBjb3VudGVy
cyBpbmNyZW1lbnQgZmFzdCBlbm91Z2ggdGhhdCB0aGlzIG1heSBub3QgYWN0dWFsbHkgYmUNCj4g
YW4gaXNzdWUsIGJ1dCB0aGlzIHNvcnQgb2YgdGhpbmcgaXMgYSBwYWluIHRvIGZpeCBpZiBpdCBi
ZWNvbWVzIGEgcHJvYmxlbSBpbiB0aGUNCj4gZnV0dXJlLg0KPiANClllYWguDQo+ID4+DQo+ID4+
PiArCQlmZWF0dXJlID0gc21jY2NfZ2V0X2FyZzEodmNwdSk7DQo+ID4+PiArCQlzd2l0Y2ggKGZl
YXR1cmUpIHsNCj4gPj4+ICsJCWNhc2UgQVJNX1BUUF9WSVJUX0NPVU5URVI6DQo+ID4+PiArCQkJ
Y3ljbGVzID0gc3lzdGltZV9zbmFwc2hvdC5jeWNsZXMgLQ0KPiA+Pj4gKwkJCXZjcHVfdnRpbWVy
KHZjcHUpLT5jbnR2b2ZmOw0KPiA+Pg0KPiA+PiBQbGVhc2UgaW5kZW50IHRoZSBjb250aW51YXRp
b24gbGluZSBzbyB0aGF0IGl0J3Mgb2J2aW91cy4NCj4gPiBPaywNCj4gPg0KPiA+Pg0KPiA+Pj4g
KwkJCWJyZWFrOw0KPiA+Pj4gKwkJY2FzZSBBUk1fUFRQX1BIWV9DT1VOVEVSOg0KPiA+Pj4gKwkJ
CWN5Y2xlcyA9IHN5c3RpbWVfc25hcHNob3QuY3ljbGVzOw0KPiA+Pj4gKwkJCWJyZWFrOw0KPiA+
Pj4gKwkJfQ0KPiA+Pj4gKwkJdmFsWzJdID0gdXBwZXJfMzJfYml0cyhjeWNsZXMpOw0KPiA+Pj4g
KwkJdmFsWzNdID0gbG93ZXJfMzJfYml0cyhjeWNsZXMpOw0KPiA+Pj4gICAgCQlicmVhazsNCj4g
Pj4+ICsjZW5kaWYNCj4gPj4+ICsNCj4gPj4+ICAgIAlkZWZhdWx0Og0KPiA+Pj4gICAgCQlyZXR1
cm4ga3ZtX3BzY2lfY2FsbCh2Y3B1KTsNCj4gPj4+ICAgIAl9DQo+ID4+PiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9hcm0tc21jY2MuaCBiL2luY2x1ZGUvbGludXgvYXJtLXNtY2NjLmgNCj4g
Pj4+IGluZGV4IDg2ZmYzMDEzMWU3Yi4uZTU5M2VjNTE1ZjgyIDEwMDY0NA0KPiA+Pj4gLS0tIGEv
aW5jbHVkZS9saW51eC9hcm0tc21jY2MuaA0KPiA+Pj4gKysrIGIvaW5jbHVkZS9saW51eC9hcm0t
c21jY2MuaA0KPiA+Pj4gQEAgLTk4LDYgKzk4LDkgQEANCj4gPj4+DQo+ID4+PiAgICAvKiBLVk0g
InZlbmRvciBzcGVjaWZpYyIgc2VydmljZXMgKi8NCj4gPj4+ICAgICNkZWZpbmUgQVJNX1NNQ0ND
X0tWTV9GVU5DX0ZFQVRVUkVTCQkwDQo+ID4+PiArI2RlZmluZSBBUk1fU01DQ0NfS1ZNX0ZVTkNf
S1ZNX1BUUAkJMQ0KPiA+Pj4gKyNkZWZpbmUgQVJNX1NNQ0NDX0tWTV9GVU5DX0tWTV9QVFBfUEhZ
CQkyDQo+ID4+PiArI2RlZmluZSBBUk1fU01DQ0NfS1ZNX0ZVTkNfS1ZNX1BUUF9WSVJUCQkzDQo+
ID4+PiAgICAjZGVmaW5lIEFSTV9TTUNDQ19LVk1fRlVOQ19GRUFUVVJFU18yCQkxMjcNCj4gPj4+
ICAgICNkZWZpbmUgQVJNX1NNQ0NDX0tWTV9OVU1fRlVOQ1MJCQkxMjgNCj4gPj4+DQo+ID4+PiBA
QCAtMTA3LDYgKzExMCwzMyBAQA0KPiA+Pj4gICAgCQkJICAgQVJNX1NNQ0NDX09XTkVSX1ZFTkRP
Ul9IWVAsDQo+ID4+IAkJXA0KPiA+Pj4gICAgCQkJICAgQVJNX1NNQ0NDX0tWTV9GVU5DX0ZFQVRV
UkVTKQ0KPiA+Pj4NCj4gPj4+ICsvKg0KPiA+Pj4gKyAqIGt2bV9wdHAgaXMgYSBmZWF0dXJlIHVz
ZWQgZm9yIHRpbWUgc3luYyBiZXR3ZWVuIHZtIGFuZCBob3N0Lg0KPiA+Pj4gKyAqIGt2bV9wdHAg
bW9kdWxlIGluIGd1ZXN0IGtlcm5lbCB3aWxsIGdldCBzZXJ2aWNlIGZyb20gaG9zdCB1c2luZw0K
PiA+Pj4gKyAqIHRoaXMgaHlwZXJjYWxsIElELg0KPiA+Pj4gKyAqLw0KPiA+Pj4gKyNkZWZpbmUg
QVJNX1NNQ0NDX1ZFTkRPUl9IWVBfS1ZNX1BUUF9GVU5DX0lEDQo+ID4+IAkJXA0KPiA+Pj4gKwlB
Uk1fU01DQ0NfQ0FMTF9WQUwoQVJNX1NNQ0NDX0ZBU1RfQ0FMTCwNCj4gPj4gCQlcDQo+ID4+PiAr
CQkJICAgQVJNX1NNQ0NDX1NNQ18zMiwNCj4gPj4gCVwNCj4gPj4+ICsJCQkgICBBUk1fU01DQ0Nf
T1dORVJfVkVORE9SX0hZUCwNCj4gPj4gCQlcDQo+ID4+PiArCQkJICAgQVJNX1NNQ0NDX0tWTV9G
VU5DX0tWTV9QVFApDQo+ID4+PiArDQo+ID4+PiArLyoNCj4gPj4+ICsgKiBrdm1fcHRwIG1heSBn
ZXQgY291bnRlciBjeWNsZSBmcm9tIGhvc3QgYW5kIHNob3VsZCBhc2sgZm9yIHdoaWNoDQo+ID4+
PiArb2YNCj4gPj4+ICsgKiBwaHlzaWNhbCBjb3VudGVyIG9yIHZpcnR1YWwgY291bnRlciBieSB1
c2luZw0KPiBBUk1fUFRQX1BIWV9DT1VOVEVSDQo+ID4+PiArYW5kDQo+ID4+PiArICogQVJNX1BU
UF9WSVJUX0NPVU5URVIgZXhwbGljaXRseS4NCj4gPj4+ICsgKi8NCj4gPj4+ICsjZGVmaW5lIEFS
TV9QVFBfUEhZX0NPVU5URVINCj4gPj4gCVwNCj4gPj4+ICsJQVJNX1NNQ0NDX0NBTExfVkFMKEFS
TV9TTUNDQ19GQVNUX0NBTEwsDQo+ID4+IAkJXA0KPiA+Pj4gKwkJCSAgIEFSTV9TTUNDQ19TTUNf
MzIsDQo+ID4+IAlcDQo+ID4+PiArCQkJICAgQVJNX1NNQ0NDX09XTkVSX1ZFTkRPUl9IWVAsDQo+
ID4+IAkJXA0KPiA+Pj4gKwkJCSAgIEFSTV9TTUNDQ19LVk1fRlVOQ19LVk1fUFRQX1BIWSkNCj4g
Pj4+ICsNCj4gPj4+ICsjZGVmaW5lIEFSTV9QVFBfVklSVF9DT1VOVEVSDQo+ID4+IAlcDQo+ID4+
PiArCUFSTV9TTUNDQ19DQUxMX1ZBTChBUk1fU01DQ0NfRkFTVF9DQUxMLA0KPiA+PiAJCVwNCj4g
Pj4+ICsJCQkgICBBUk1fU01DQ0NfU01DXzMyLA0KPiA+PiAJXA0KPiA+Pj4gKwkJCSAgIEFSTV9T
TUNDQ19PV05FUl9WRU5ET1JfSFlQLA0KPiA+PiAJCVwNCj4gPj4+ICsJCQkgICBBUk1fU01DQ0Nf
S1ZNX0ZVTkNfS1ZNX1BUUF9WSVJUKQ0KPiA+Pg0KPiA+PiBUaGVzZSB0d28gYXJlIG5vdCBTTUND
QyBjYWxscyB0aGVtc2VsdmVzIChqdXN0IHBhcmFtZXRlcnMgdG8gYW4NCj4gPj4gU01DQ0MpLCBz
byB0aGV5IHJlYWxseSBzaG91bGRuJ3QgYmUgZGVmaW5lZCB1c2luZw0KPiBBUk1fU01DQ0NfQ0FM
TF9WQUwNCj4gPj4gKGl0J3MganVzdCBjb25mdXNpbmcgYW5kIHVubmVjZXNzYXJ5KS4gQ2FuIHdl
IG5vdCBqdXN0IHBpY2sgc21hbGwNCj4gPj4gaW50ZWdlcnMgKGUuZy4gMCBhbmQgMSkgZm9yIHRo
ZXNlPw0KPiA+Pg0KPiA+IFllYWgsIEkgdGhpbmsgc28sIGl0J3MgYmV0dGVyIHRvIGRlZmluZSB0
aGVzZSBwYXJhbWV0ZXJzIElEIGFzIHNpbmdsZQ0KPiA+IG51bWJlciBhbmQgbm90IHJlbGF0ZWQg
dG8gU01DQ0MuIFdoYXQgYWJvdXQga2VlcCB0aGVzZSAyIG1hY3JvcyBhbmQNCj4gZGVmaW5lIGl0
IGRpcmVjdGx5IGFzIGEgbnVtYmVyIGluIGluY2x1ZGUvbGludXgvYXJtLXNtY2NjLmguDQo+IA0K
PiBZZXMgdGhhdCBzb3VuZHMgZ29vZC4NCj4gDQo+ID4+IFdlIGFsc28gbmVlZCBzb21lIGRvY3Vt
ZW50YXRpb24gb2YgdGhlc2UgU01DQ0MgY2FsbHMgc29tZXdoZXJlDQo+IHdoaWNoDQo+ID4+IHdv
dWxkIG1ha2UgdGhpcyBzb3J0IG9mIHJldmlldyBlYXNpZXIuIEZvciBpbnN0YW5jZSBmb3INCj4g
Pj4gcGFyYXZpcnR1YWxpc2VkIHN0b2xlbiB0aW1lIHRoZXJlIGlzDQo+ID4+IERvY3VtZW50YXRp
b24vdmlydC9rdm0vYXJtL3B2dGltZS5yc3QgKHdoaWNoIGFsc28gbGlua3MgdG8gdGhlDQo+IHB1
Ymxpc2hlZCBkb2N1bWVudCBmcm9tIEFybSkuDQo+ID4+DQo+ID4gR29vZCBwb2ludCwgYSBkb2N1
bWVudGF0aW9uIGlzIG5lZWRlZCB0byBleHBsYWluIHRoZXNlIG5ldyBTTUNDQyBmdW5jcy4NCj4g
PiBEbyB5b3UgdGhpbmsgd2Ugc2hvdWxkIGRvIHRoYXQgaW4gdGhpcyBwYXRjaCBzZXJpYWw/IERv
ZXMgaXQgYmV5b25kIHRoZQ0KPiBzY29wZSBvZiB0aGlzIHBhdGNoIHNldD8NCj4gDQo+IEFkZGlu
ZyBpdCBpbiB0aGlzIHBhdGNoIHNlcmllcyBzZWVtcyBsaWtlIHRoZSByaWdodCBwbGFjZSB0byBt
ZS4NCj4gDQpPaywgSSB3aWxsIGFkZCB0aGUgZG9jLiAgVGhpcyBuZXcgZG9jIHdpbGwgYmUgbmFt
ZWQgInB0cF9rdm0ucnN0IiBhbmQgcGxhY2VkIGluIHRoZSBzYW1lDQpkaXJlY3Rvcnkgd2l0aCBw
dnRpbWUucnN0LiBJIHdpbGwgY29tcG9zZSB0aGlzIGRvYyBieSByZWZlcmVuY2UgdG8geW91ciBw
dnRpbWUucnN0IHdoaWNoIGlzIGEgZ29vZCBleGFtcGxlLg0KDQpUaGFua3MNCkppYW55b25nIA0K
DQo+IFRoYW5rcywNCj4gDQo+IFN0ZXZlDQo=
