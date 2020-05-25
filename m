Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE61E049A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbgEYCMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:12:07 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:47618
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388090AbgEYCMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YoSmT7WS0Ndsv47A1pmnmGimdg5mugN7lyM40VV+o=;
 b=d3PWjUhXz3bc3ZzZVFEiOzFRMs9RKXlp5peJLeShtjTONojKwhnb50/inwPM7x0bbk9R5407UglasyxaVxp6eNbGBUx9QrI1rv1SdELvYVNIg/gWtoiLLIRGhm9OxiwTLTu72FUVkHnkNJP1rI42aJLqo6gfGvuVqfyXjhG/RkI=
Received: from AM5PR0601CA0031.eurprd06.prod.outlook.com
 (2603:10a6:203:68::17) by DB8PR08MB5164.eurprd08.prod.outlook.com
 (2603:10a6:10:e7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 02:11:58 +0000
Received: from VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:68:cafe::32) by AM5PR0601CA0031.outlook.office365.com
 (2603:10a6:203:68::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend
 Transport; Mon, 25 May 2020 02:11:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT038.mail.protection.outlook.com (10.152.19.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 02:11:57 +0000
Received: ("Tessian outbound facc38080784:v57"); Mon, 25 May 2020 02:11:57 +0000
X-CR-MTA-TID: 64aa7808
Received: from 10dd158996a5.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id BA220C70-94CC-4857-A31B-FE3EE6AC0425.1;
        Mon, 25 May 2020 02:11:52 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 10dd158996a5.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 25 May 2020 02:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXpgNEsa0tqK5CdY/Jj79NnH0p1GPPgthSzW4ec34A7Il9y5phzbd4iEU7QnFgFEC/z/PwcBAKsQdiLBAZzDp+xvC0N+Y6kXFc5jl/rHCfvyh4PTe70NtqITD/UhiK3xvcDSS38lwutWVvTcriVnjy6d8ytfVk48x4BVW8Tp03IC+fCOTjimkAW9hSfMgIPkCACTsOz45khJU4EpZ1Hn+BE0iQ6XZWdFbSL/h8fPd/AxwfhnrUowz5G9f3oxL1YKD8YXkFBn2iyPav5lZEeeQGfVEN51ebBmqRVYEbu+42B25VfpLXYRtsd/qSv1x0owuUVxd3ijEkQyMTsIYU3yMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YoSmT7WS0Ndsv47A1pmnmGimdg5mugN7lyM40VV+o=;
 b=lwqQMXb5zUI7SrXCDgLWBhZ7Cr9uA1rd86sZaORa1t42VWp5TTyfWuxO4jhqvSKC/AN/TFs0olN5GOgwz5DW5NLFtzmjp361RaJ/CcL0ypDC6fHJwH2Gg/MnXBwE5NUnWAM3pGQ0lvm9js/4p6+SDHC3ePRM7h4Rdb4V/rilaFAZVYUTAgd6lLm9Kay4DJcdpODk6f/zAv+IsvELsGlFmi+p+PinGTbPcKMJtFkOkGnsoTDa1AE0WFzAW+PfNJv9HnmApN7dX0Diq+LgojCCpVI+YgRIF83ziG2FG3Rp8AFu5l/mLTuAyUoDhu7BE563GzF4UNdaloG1R/mEKsaIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YoSmT7WS0Ndsv47A1pmnmGimdg5mugN7lyM40VV+o=;
 b=d3PWjUhXz3bc3ZzZVFEiOzFRMs9RKXlp5peJLeShtjTONojKwhnb50/inwPM7x0bbk9R5407UglasyxaVxp6eNbGBUx9QrI1rv1SdELvYVNIg/gWtoiLLIRGhm9OxiwTLTu72FUVkHnkNJP1rI42aJLqo6gfGvuVqfyXjhG/RkI=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2443.eurprd08.prod.outlook.com (2603:10a6:3:d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 02:11:48 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 02:11:48 +0000
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
Subject: RE: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
Thread-Topic: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
Thread-Index: AQHWMBRiyrp0i3ftg0yKp1NgeF42Dqi0J4kAgAPjibA=
Date:   Mon, 25 May 2020 02:11:48 +0000
Message-ID: <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
 <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
In-Reply-To: <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: ce3b9103-893c-4ae7-915c-be7da61ac5e9.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d51cb491-8fce-4471-9303-08d8005100b8
x-ms-traffictypediagnostic: HE1PR0802MB2443:|DB8PR08MB5164:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5164A217E82C8E15A7034D17F4B30@DB8PR08MB5164.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +zaMIu5jRJzSeLCnoFbFR4aEOOMCpbAq7AeEn93OldWUps4bmEUhCf7Glyoas4WSzKEEY/ea1NITrSsL9DevrhSurumEs50mNwbpBQ1jGtIcb5fAs79s8ZvmRZKV5HDmvBb50CWWjsDveymhiU2cYQwjtfLYOPpB22ohMhsAE7VQByMKWt+Q6xq9UFDdygj1zMQIMr7CUW8gww32NyHHhTiFmL3B1KWe+38RE7x+07NBjOlAIU1IKi8Hd7Mtq67iZrc5ddkjUl1pbwwN5mt7uxL/0lOpPMv9c0v6N5Z1a0+kJirUjMdSsv4JGzymWTgVz2lMKpTA0fjrDkEKOI5SmEQBGNwa50CpHajVrwubMszCGXx+qHpnC0bVDs1N3ST6
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(366004)(396003)(136003)(346002)(376002)(66556008)(55016002)(64756008)(8676002)(6636002)(66476007)(66946007)(186003)(86362001)(52536014)(33656002)(66446008)(2906002)(110136005)(5660300002)(54906003)(4326008)(7416002)(6506007)(71200400001)(53546011)(26005)(8936002)(316002)(9686003)(478600001)(76116006)(7696005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5VmSj1yL4DaQ0nweIlNUKH1FJGnygou4FaNtmYzoqvxyK05oAtIOaIYvJQ9u4HjPfc0VPs5J72DSN4t3QaLyr9vZTlbm/xqytpdJb0Lu+Qs8k3HxpkFM1u+o9G/07WYtxW2D+pNQSRYuaoB+gKpgMErE2xwdpnaYF8zd2IXbVIvxDSTPex8NkjrZ+SdquLuvLhKStz3WVKs5kfAf3uGZHExJk7wd6Lp8dYsjRo96CueGfP+J6X0J11frglLK4oaXUJakyrntyPwdKkrgaX33LY772nBKxct3IzbqIwigVh1JCViJXgEuy9CHbb5o35jJk/MFJxm8/7+EKk570bJMWB5q141Vd+TsIAEYOPTqZBfwYYCS4VwWvTf++cep1v73gASSFdiss7cliCBVYnMYJKO9ZosxcG8kFMP33tCtKBlrSIMISdideI6v+U0vNj2G7Djw8N7ZoACsR7scXPRpVRhT6VOrejwiKIRfBZiIbjY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2443
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(376002)(136003)(396003)(346002)(46966005)(356005)(336012)(47076004)(82740400003)(81166007)(8936002)(52536014)(70206006)(70586007)(33656002)(8676002)(6636002)(82310400002)(478600001)(54906003)(110136005)(9686003)(55016002)(450100002)(4326008)(2906002)(53546011)(7696005)(6506007)(26005)(186003)(316002)(5660300002)(36906005)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 81e19192-6ecb-446b-64e0-08d80050fb18
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GMXGxbZ9JM5iXa/VUnN8/CCcMJSZxqhx8/emZZwx+jIUshlzsMKGPX7C4WZA8TiUyRNCRQBKI7LKpt7Vwsk2RjM58HbzhAd+HRqRFMwsXZFVQggwD/02BC++W44GjGK3l0XqwDc/u2Ot1tXdoO1aWSmvTvCP2C89eFh/Mf2zIZRdf4S1/0ysNMh4H+gD+SMuM2cQ71QLHjuQYM6X680aSBdK6O1KSJplgJ+Y/GniBayiw1k8ieAqboLBg8i02e0UjO33jyq+a5idnB+aWJPVmCyAvgwlamxE+MH6aGTqBCARCeZs7QSPsKFIUltSoTuyYNwe5Oj7nqbQMHNv9+P+dCG3uYTh+1sg1yf1eCnt3leYlyeVo1Orr4Yd0CI+2agawkOZw2mv/ARa803953+CBgujnQbva0LqAvaUKDUfL0M=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 02:11:57.5231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d51cb491-8fce-4471-9303-08d8005100b8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RldmVuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0ZXZl
biBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWF5IDIyLCAy
MDIwIDEwOjE4IFBNDQo+IFRvOiBKaWFueW9uZyBXdSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47IG5l
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
amVjdDogUmU6IFtSRkMgUEFUQ0ggdjEyIDA3LzExXSBwc2NpOiBBZGQgaHlwZXJjYWxsIHNlcnZp
Y2UgZm9yIGt2bSBwdHAuDQo+IA0KPiBPbiAyMi8wNS8yMDIwIDA5OjM3LCBKaWFueW9uZyBXdSB3
cm90ZToNCj4gPiBwdHBfa3ZtIG1vZHVsZXMgd2lsbCBnZXQgdGhpcyBzZXJ2aWNlIHRocm91Z2gg
c21jY2MgY2FsbC4NCj4gPiBUaGUgc2VydmljZSBvZmZlcnMgcmVhbCB0aW1lIGFuZCBjb3VudGVy
IGN5Y2xlIG9mIGhvc3QgZm9yIGd1ZXN0Lg0KPiA+IEFsc28gbGV0IGNhbGxlciBkZXRlcm1pbmUg
d2hpY2ggY3ljbGUgb2YgdmlydHVhbCBjb3VudGVyIG9yIHBoeXNpY2FsDQo+ID4gY291bnRlciB0
byByZXR1cm4uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKaWFueW9uZyBXdSA8amlhbnlvbmcu
d3VAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGluY2x1ZGUvbGludXgvYXJtLXNtY2NjLmggfCAx
NCArKysrKysrKysrKysNCj4gPiAgIHZpcnQva3ZtL0tjb25maWcgICAgICAgICAgfCAgNCArKysr
DQo+ID4gICB2aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jIHwgNDcNCj4gKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gICAzIGZpbGVzIGNoYW5nZWQsIDY1IGluc2Vy
dGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2FybS1zbWNjYy5o
IGIvaW5jbHVkZS9saW51eC9hcm0tc21jY2MuaA0KPiA+IGluZGV4IGJkYzAxMjRhMDY0YS4uYmFk
YWRjMzkwODA5IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvYXJtLXNtY2NjLmgNCj4g
PiArKysgYi9pbmNsdWRlL2xpbnV4L2FybS1zbWNjYy5oDQo+ID4gQEAgLTk0LDYgKzk0LDggQEAN
Cj4gPg0KPiA+ICAgLyogS1ZNICJ2ZW5kb3Igc3BlY2lmaWMiIHNlcnZpY2VzICovDQo+ID4gICAj
ZGVmaW5lIEFSTV9TTUNDQ19LVk1fRlVOQ19GRUFUVVJFUwkJMA0KPiA+ICsjZGVmaW5lIEFSTV9T
TUNDQ19LVk1fRlVOQ19LVk1fUFRQCQkxDQo+ID4gKyNkZWZpbmUgQVJNX1NNQ0NDX0tWTV9GVU5D
X0tWTV9QVFBfUEhZCQkyDQo+ID4gICAjZGVmaW5lIEFSTV9TTUNDQ19LVk1fRlVOQ19GRUFUVVJF
U18yCQkxMjcNCj4gPiAgICNkZWZpbmUgQVJNX1NNQ0NDX0tWTV9OVU1fRlVOQ1MJCQkxMjgNCj4g
Pg0KPiA+IEBAIC0xMDMsNiArMTA1LDE4IEBADQo+ID4gICAJCQkgICBBUk1fU01DQ0NfT1dORVJf
VkVORE9SX0hZUCwNCj4gCQlcDQo+ID4gICAJCQkgICBBUk1fU01DQ0NfS1ZNX0ZVTkNfRkVBVFVS
RVMpDQo+ID4NCj4gPiArI2RlZmluZSBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX0ZVTkNf
SUQNCj4gCQlcDQo+ID4gKwlBUk1fU01DQ0NfQ0FMTF9WQUwoQVJNX1NNQ0NDX0ZBU1RfQ0FMTCwN
Cj4gCQlcDQo+ID4gKwkJCSAgIEFSTV9TTUNDQ19TTUNfMzIsDQo+IAlcDQo+ID4gKwkJCSAgIEFS
TV9TTUNDQ19PV05FUl9WRU5ET1JfSFlQLA0KPiAJCVwNCj4gPiArCQkJICAgQVJNX1NNQ0NDX0tW
TV9GVU5DX0tWTV9QVFApDQo+ID4gKw0KPiA+ICsjZGVmaW5lIEFSTV9TTUNDQ19WRU5ET1JfSFlQ
X0tWTV9QVFBfUEhZX0ZVTkNfSUQNCj4gCQlcDQo+ID4gKwlBUk1fU01DQ0NfQ0FMTF9WQUwoQVJN
X1NNQ0NDX0ZBU1RfQ0FMTCwNCj4gCQlcDQo+ID4gKwkJCSAgIEFSTV9TTUNDQ19TTUNfMzIsDQo+
IAlcDQo+ID4gKwkJCSAgIEFSTV9TTUNDQ19PV05FUl9WRU5ET1JfSFlQLA0KPiAJCVwNCj4gPiAr
CQkJICAgQVJNX1NNQ0NDX0tWTV9GVU5DX0tWTV9QVFBfUEhZKQ0KPiA+ICsNCj4gPiAgICNpZm5k
ZWYgX19BU1NFTUJMWV9fDQo+ID4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9saW5rYWdlLmg+DQo+
ID4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL0tjb25maWcgYi92aXJ0L2t2bS9LY29uZmlnIGluZGV4
DQo+ID4gYWFkOTI4NGMwNDNhLi5iZjgyMDgxMWU4MTUgMTAwNjQ0DQo+ID4gLS0tIGEvdmlydC9r
dm0vS2NvbmZpZw0KPiA+ICsrKyBiL3ZpcnQva3ZtL0tjb25maWcNCj4gPiBAQCAtNjAsMyArNjAs
NyBAQCBjb25maWcgSEFWRV9LVk1fVkNQVV9SVU5fUElEX0NIQU5HRQ0KPiA+DQo+ID4gICBjb25m
aWcgSEFWRV9LVk1fTk9fUE9MTA0KPiA+ICAgICAgICAgIGJvb2wNCj4gPiArDQo+ID4gK2NvbmZp
ZyBBUk02NF9LVk1fUFRQX0hPU1QNCj4gPiArICAgICAgIGRlZl9ib29sIHkNCj4gPiArICAgICAg
IGRlcGVuZHMgb24gQVJNNjQgJiYgS1ZNDQo+ID4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9o
eXBlcmNhbGxzLmMgYi92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+ID4gaW5kZXggZGI2ZGNl
M2QwZTIzLi5jOTY0MTIyZjhkYWUgMTAwNjQ0DQo+ID4gLS0tIGEvdmlydC9rdm0vYXJtL2h5cGVy
Y2FsbHMuYw0KPiA+ICsrKyBiL3ZpcnQva3ZtL2FybS9oeXBlcmNhbGxzLmMNCj4gPiBAQCAtMyw2
ICszLDcgQEANCj4gPg0KPiA+ICAgI2luY2x1ZGUgPGxpbnV4L2FybS1zbWNjYy5oPg0KPiA+ICAg
I2luY2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9jbG9ja3Nv
dXJjZV9pZHMuaD4NCj4gPg0KPiA+ICAgI2luY2x1ZGUgPGFzbS9rdm1fZW11bGF0ZS5oPg0KPiA+
DQo+ID4gQEAgLTExLDYgKzEyLDEwIEBADQo+ID4NCj4gPiAgIGludCBrdm1faHZjX2NhbGxfaGFu
ZGxlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gICB7DQo+ID4gKyNpZmRlZiBDT05GSUdf
QVJNNjRfS1ZNX1BUUF9IT1NUDQo+ID4gKwlzdHJ1Y3Qgc3lzdGVtX3RpbWVfc25hcHNob3Qgc3lz
dGltZV9zbmFwc2hvdDsNCj4gPiArCXU2NCBjeWNsZXM7DQo+ID4gKyNlbmRpZg0KPiA+ICAgCXUz
MiBmdW5jX2lkID0gc21jY2NfZ2V0X2Z1bmN0aW9uKHZjcHUpOw0KPiA+ICAgCXUzMiB2YWxbNF0g
PSB7U01DQ0NfUkVUX05PVF9TVVBQT1JURUR9Ow0KPiA+ICAgCXUzMiBmZWF0dXJlOw0KPiA+IEBA
IC03MCw3ICs3NSw0OSBAQCBpbnQga3ZtX2h2Y19jYWxsX2hhbmRsZXIoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiA+ICAgCQlicmVhazsNCj4gPiAgIAljYXNlIEFSTV9TTUNDQ19WRU5ET1JfSFlQ
X0tWTV9GRUFUVVJFU19GVU5DX0lEOg0KPiA+ICAgCQl2YWxbMF0gPSBCSVQoQVJNX1NNQ0NDX0tW
TV9GVU5DX0ZFQVRVUkVTKTsNCj4gPiArDQo+ID4gKyNpZmRlZiBDT05GSUdfQVJNNjRfS1ZNX1BU
UF9IT1NUDQo+ID4gKwkJdmFsWzBdIHw9IEJJVChBUk1fU01DQ0NfS1ZNX0ZVTkNfS1ZNX1BUUCk7
ICNlbmRpZg0KPiA+ICAgCQlicmVhazsNCj4gPiArDQo+ID4gKyNpZmRlZiBDT05GSUdfQVJNNjRf
S1ZNX1BUUF9IT1NUDQo+ID4gKwkvKg0KPiA+ICsJICogVGhpcyBzZXJ2ZXMgdmlydHVhbCBrdm1f
cHRwLg0KPiA+ICsJICogRm91ciB2YWx1ZXMgd2lsbCBiZSBwYXNzZWQgYmFjay4NCj4gPiArCSAq
IHJlZzAgc3RvcmVzIGhpZ2ggMzItYml0IGhvc3Qga3RpbWU7DQo+ID4gKwkgKiByZWcxIHN0b3Jl
cyBsb3cgMzItYml0IGhvc3Qga3RpbWU7DQo+ID4gKwkgKiByZWcyIHN0b3JlcyBoaWdoIDMyLWJp
dCBkaWZmZXJlbmNlIG9mIGhvc3QgY3ljbGVzIGFuZCBjbnR2b2ZmOw0KPiA+ICsJICogcmVnMyBz
dG9yZXMgbG93IDMyLWJpdCBkaWZmZXJlbmNlIG9mIGhvc3QgY3ljbGVzIGFuZCBjbnR2b2ZmLg0K
PiA+ICsJICovDQo+ID4gKwljYXNlIEFSTV9TTUNDQ19WRU5ET1JfSFlQX0tWTV9QVFBfRlVOQ19J
RDoNCj4gPiArCQkvKg0KPiA+ICsJCSAqIHN5c3RlbSB0aW1lIGFuZCBjb3VudGVyIHZhbHVlIG11
c3QgY2FwdHVyZWQgaW4gdGhlIHNhbWUNCj4gPiArCQkgKiB0aW1lIHRvIGtlZXAgY29uc2lzdGVu
Y3kgYW5kIHByZWNpc2lvbi4NCj4gPiArCQkgKi8NCj4gPiArCQlrdGltZV9nZXRfc25hcHNob3Qo
JnN5c3RpbWVfc25hcHNob3QpOw0KPiA+ICsJCWlmIChzeXN0aW1lX3NuYXBzaG90LmNzX2lkICE9
IENTSURfQVJNX0FSQ0hfQ09VTlRFUikNCj4gPiArCQkJYnJlYWs7DQo+ID4gKwkJdmFsWzBdID0g
dXBwZXJfMzJfYml0cyhzeXN0aW1lX3NuYXBzaG90LnJlYWwpOw0KPiA+ICsJCXZhbFsxXSA9IGxv
d2VyXzMyX2JpdHMoc3lzdGltZV9zbmFwc2hvdC5yZWFsKTsNCj4gPiArCQkvKg0KPiA+ICsJCSAq
IHdoaWNoIG9mIHZpcnR1YWwgY291bnRlciBvciBwaHlzaWNhbCBjb3VudGVyIGJlaW5nDQo+ID4g
KwkJICogYXNrZWQgZm9yIGlzIGRlY2lkZWQgYnkgdGhlIGZpcnN0IGFyZ3VtZW50Lg0KPiA+ICsJ
CSAqLw0KPiA+ICsJCWZlYXR1cmUgPSBzbWNjY19nZXRfYXJnMSh2Y3B1KTsNCj4gPiArCQlzd2l0
Y2ggKGZlYXR1cmUpIHsNCj4gPiArCQljYXNlIEFSTV9TTUNDQ19WRU5ET1JfSFlQX0tWTV9QVFBf
UEhZX0ZVTkNfSUQ6DQo+ID4gKwkJCWN5Y2xlcyA9IHN5c3RpbWVfc25hcHNob3QuY3ljbGVzOw0K
PiA+ICsJCQlicmVhazsNCj4gPiArCQlkZWZhdWx0Og0KPiANCj4gVGhlcmUncyBzb21ldGhpbmcg
YSBiaXQgb2RkIGhlcmUuDQo+IA0KPiBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX0ZVTkNf
SUQgYW5kDQo+IEFSTV9TTUNDQ19WRU5ET1JfSFlQX0tWTV9QVFBfUEhZX0ZVTkNfSUQgbG9vayBs
aWtlIHRoZXkgc2hvdWxkDQo+IGJlIG5hbWVzIG9mIHNlcGFyYXRlICh0b3AtbGV2ZWwpIGZ1bmN0
aW9ucywgYnV0IGFjdHVhbGx5IHRoZSBfUEhZXyBvbmUgaXMgYQ0KPiBwYXJhbWV0ZXIgZm9yIHRo
ZSBmaXJzdC4gSWYgdGhlIGludGVudGlvbiBpcyB0byBoYXZlIGEgcGFyYW1ldGVyIHRoZW4gaXQg
d291bGQNCj4gYmUgYmV0dGVyIHRvIHBpY2sgYSBiZXR0ZXIgbmFtZSBmb3IgdGhlIF9QSFlfIGRl
ZmluZSBhbmQgbm90IGRlZmluZSBpdCB1c2luZw0KPiBBUk1fU01DQ0NfQ0FMTF9WQUwuDQo+IA0K
WWVhaCwgX1BIWV8gaXMgbm90IHRoZSBzYW1lIG1lYW5pbmcgd2l0aCBfUFRQX0ZVTkNfSUQsICBz
byBJIHRoaW5rIGl0IHNob3VsZCBiZSBhIGRpZmZlcmVudCBuYW1lLg0KV2hhdCBhYm91dCBBUk1f
U01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX1BIWV9DT1VOVEVSPw0KDQo+IFNlY29uZCB0aGUgdXNl
IG9mICJkZWZhdWx0OiIgbWVhbnMgdGhhdCB0aGVyZSdzIG5vIHBvc3NpYmlsaXR5IHRvIGxhdGVy
IGV4dGVuZA0KPiB0aGlzIGludGVyZmFjZSBmb3IgbW9yZSBjbG9ja3MgaWYgbmVlZGVkIGluIHRo
ZSBmdXR1cmUuDQo+IA0KSSB0aGluayB3ZSBjYW4gYWRkIG1vcmUgY2xvY2tzIGJ5IGFkZGluZyBt
b3JlIGNhc2VzLCB0aGlzICJkZWZhdWx0IiBtZWFucyB3ZSBjYW4gdXNlIG5vIGZpcnN0IGFyZyB0
byBkZXRlcm1pbmUgdGhlIGRlZmF1bHQgY2xvY2suDQoNCj4gQWx0ZXJuYXRpdmVseSB5b3UgY291
bGQgaW5kZWVkIGltcGxlbWVudCBhcyB0d28gdG9wLWxldmVsIGZ1bmN0aW9ucyBhbmQNCj4gY2hh
bmdlIHRoaXMgdG8gYS4uLg0KPiANCj4gCXN3aXRjaCAoZnVuY19pZCkNCj4gDQo+IC4uLiBhbG9u
ZyB3aXRoIG11bHRpcGxlIGNhc2UgbGFiZWxzIGFzIHRoZSBmdW5jdGlvbnMgd291bGQgb2J2aW91
c2x5IGJlIG1vc3RseQ0KPiB0aGUgc2FtZS4NCj4gDQo+IEFsc28gYSBtaW5vciBzdHlsZSBpc3N1
ZSAtIHlvdSBtaWdodCB3YW50IHRvIGNvbnNpZGVyIHNwbGl0dGluZyB0aGlzIGludG8gaXQncw0K
PiBvd24gZnVuY3Rpb24uDQo+IA0KSSB0aGluayAic3dpdGNoIChmZWF0dXJlKSIgbWF5YmUgYmV0
dGVyIGFzIHRoaXMgX1BIWV8gaXMgbm90IGxpa2UgYSBmdW5jdGlvbiBpZC4gSnVzdCBsaWtlOg0K
Ig0KY2FzZSBBUk1fU01DQ0NfQVJDSF9GRUFUVVJFU19GVU5DX0lEOg0KICAgICAgICAgICAgICAg
IGZlYXR1cmUgPSBzbWNjY19nZXRfYXJnMSh2Y3B1KTsNCiAgICAgICAgICAgICAgICBzd2l0Y2gg
KGZlYXR1cmUpIHsNCiAgICAgICAgICAgICAgICBjYXNlIEFSTV9TTUNDQ19BUkNIX1dPUktBUk9V
TkRfMToNCi4uLg0KIg0KPiBGaW5hbGx5IEkgZG8gdGhpbmsgaXQgd291bGQgYmUgdXNlZnVsIHRv
IGFkZCBzb21lIGRvY3VtZW50YXRpb24gb2YgdGhlIG5ldw0KPiBTTUMgY2FsbHMuIEl0IHdvdWxk
IGJlIGVhc2llciB0byByZXZpZXcgdGhlIGludGVyZmFjZSBiYXNlZCBvbiB0aGF0DQo+IGRvY3Vt
ZW50YXRpb24gcmF0aGVyIHRoYW4gdHJ5aW5nIHRvIHJldmVyc2UtZW5naW5lZXIgdGhlIGludGVy
ZmFjZSBmcm9tIHRoZQ0KPiBjb2RlLg0KPiANClllYWgsIG1vcmUgZG9jIG5lZWRlZCBoZXJlLg0K
DQpUaGFua3MNCkppYW55b25nIA0KDQo+IFN0ZXZlDQo+IA0KPiA+ICsJCQljeWNsZXMgPSBzeXN0
aW1lX3NuYXBzaG90LmN5Y2xlcyAtDQo+ID4gKwkJCQkgdmNwdV92dGltZXIodmNwdSktPmNudHZv
ZmY7DQo+ID4gKwkJfQ0KPiA+ICsJCXZhbFsyXSA9IHVwcGVyXzMyX2JpdHMoY3ljbGVzKTsNCj4g
PiArCQl2YWxbM10gPSBsb3dlcl8zMl9iaXRzKGN5Y2xlcyk7DQo+ID4gKwkJYnJlYWs7DQo+ID4g
KyNlbmRpZg0KPiA+ICsNCj4gPiAgIAlkZWZhdWx0Og0KPiA+ICAgCQlyZXR1cm4ga3ZtX3BzY2lf
Y2FsbCh2Y3B1KTsNCj4gPiAgIAl9DQo+ID4NCg0K
