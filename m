Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C3F1E38CA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgE0GGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:06:41 -0400
Received: from mail-vi1eur05on2081.outbound.protection.outlook.com ([40.107.21.81]:27201
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgE0GGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 02:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcitqLKeTaQgdeG0IEuCYAeGnXtBgywoOrz1kMhW950=;
 b=EwJRcVvVS3tKApLg2FlOs9ALv0sEFvcTkDfstp4P3031lPPZ+JkGqRM581qc+vH8hTuNjwsToO2/QRzZFUD4egNJnz6k53d3ezdA9OZxBhSBLeZ8S8vp0pLbvlM38AhM7j7M3FroyvJ/XvRNrVZ9C9JUzqPjSQRgf5fQOhVEQ/I=
Received: from AM6PR10CA0032.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::45)
 by AM0PR08MB5012.eurprd08.prod.outlook.com (2603:10a6:208:15b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 06:06:34 +0000
Received: from AM5EUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:89:cafe::a1) by AM6PR10CA0032.outlook.office365.com
 (2603:10a6:209:89::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend
 Transport; Wed, 27 May 2020 06:06:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT040.mail.protection.outlook.com (10.152.17.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Wed, 27 May 2020 06:06:34 +0000
Received: ("Tessian outbound 444e8e881ac1:v57"); Wed, 27 May 2020 06:06:34 +0000
X-CR-MTA-TID: 64aa7808
Received: from 6e6718970187.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1B9FFBDF-13B9-4A9B-BE95-C9EAAE0D8488.1;
        Wed, 27 May 2020 06:06:29 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 6e6718970187.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 May 2020 06:06:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABQUEIK+6Anp41B+oKHhj7R61LCwn0lMhQZta3/RG6jKR04HoPPfnKrp3Js3keWv8kUGCWMXX3e3xLGCzcuLhhVbH6SGNpMKpJ1MSER4PQTMA2nWN7ZOs6zvNSE+OxXL2DBT9GuF9lPv43ksSX01qw7ZBUp7PENHB9Sm9WXc5w+lYMi9MoGYi3l1Lpvwq142Qrftsu7xXldmRYp4K6W/Vl8JtDyiQju5ITByZG32xors9XckHYXF3onzwY6iIhRuySNJZf1CcmOpVqQD4RyHY9PLeLoafQNAlRoobkN4bNJZAx+GXEKbcnnD4scuxe0a68FAB2LvMaw9vpEp6VcyxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcitqLKeTaQgdeG0IEuCYAeGnXtBgywoOrz1kMhW950=;
 b=hug9CNotI8JLo/sFeE0wAQ4L/Ul43cmimP7KooS5EaIMlgcqlUkRELQ4kyXrSMJL67GJ8Q+aqRUcRw7jnfp1MlPiAKGLj77xZxlvdpfcw5SiweYybtAn6wTyEXrwYumDIkOC3QjrtMwFrlURxoYyx6jljeoAac/z4tetHwyEIxCtJsrPc3NGk6o9+T/9nMAXtTtfCnlyJP66SVHgfgYxuN8KS+GmGUdNGE8tw3p9nyKY4SkNxy2TAEdZB2V/XhsKjlXJmVPvF3/sYvG8h/vxziSHO51AEr0vKqtUvSRkAMS4o4vou+iCVspqfvYT1044xXf8BaOY46k1F62zoC5Pdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcitqLKeTaQgdeG0IEuCYAeGnXtBgywoOrz1kMhW950=;
 b=EwJRcVvVS3tKApLg2FlOs9ALv0sEFvcTkDfstp4P3031lPPZ+JkGqRM581qc+vH8hTuNjwsToO2/QRzZFUD4egNJnz6k53d3ezdA9OZxBhSBLeZ8S8vp0pLbvlM38AhM7j7M3FroyvJ/XvRNrVZ9C9JUzqPjSQRgf5fQOhVEQ/I=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2169.eurprd08.prod.outlook.com (2603:10a6:3:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 06:06:21 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 06:06:21 +0000
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
Thread-Index: AQHWMBRiyrp0i3ftg0yKp1NgeF42Dqi0J4kAgAPjibCAAi7vgIABMhxA
Date:   Wed, 27 May 2020 06:06:21 +0000
Message-ID: <HE1PR0802MB255517F2326218D49FF790CAF4B10@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
 <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
 <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <d7ec2534-95e4-ae79-fc53-4d48a4ea628c@arm.com>
In-Reply-To: <d7ec2534-95e4-ae79-fc53-4d48a4ea628c@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2cd23df7-1eb3-47eb-90a7-a33cca88abba.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69ea4bc5-0288-4e3c-6d56-08d802041c0b
x-ms-traffictypediagnostic: HE1PR0802MB2169:|AM0PR08MB5012:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB50127EFE0EF6F5726A9CF891F4B10@AM0PR08MB5012.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: NiWyQG6u4RdcukCIkTeODIr7eFa02yz3yxzEZH4tsO1FJ9ZtN59o2kd2rB+4+hi6KKGT5rMIIoHoTjr2+DQhzCxENVmt281xd5wOrX7LOHGXzb6413wiipCxAP4Kb/PyCrl39AqK/AO7sILgfh5uVCw3VIX7msW2pylAOylAx8/fUnJMmpf6nrK0trV98dv12KlHxpwzMhlj+hJzfEV5wvNG9nU+5WPLy2nIBO2eBZYDGEz0iWMlY6yCva7spwVc+0tTerBvxh6XmiW+agGqk3Ki8g1Qe7E7KqhD7QubItKxUYP7mcAX7+0gqU3+EE9qGJf2nMJXZm9xqvHIPSiBNvXRsZJ+12CcE2NoqoWy4zIOLt+1kfyPg59XVVdkGzDe
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(55016002)(26005)(64756008)(9686003)(186003)(54906003)(8936002)(110136005)(71200400001)(2906002)(83380400001)(8676002)(33656002)(6636002)(86362001)(5660300002)(316002)(52536014)(66446008)(66476007)(66946007)(66556008)(7416002)(76116006)(53546011)(7696005)(4326008)(6506007)(478600001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SWm53WceJrknF8fwVi76VQyKxHBokldasWp0pXrDwFjv2ypS8hkoOPyysocEVIsbVqypsAJjAKDbhYQScuNNlmoWm8JRS8D6FtoHvJc4jNhRrf1Hcpl/+szctNlhCVyCM8w5/7yJktBUaqNwZK9no2VPkwaqPED7X9+h7DHw6YbtZ0EBKyzY66hoK3I/VKKs4yVTTbigdpHfi8PHPXq2Xol78YDphi4iGgupNg/gDNGjhg/wCA+cjJr8oOUK56ezNwbW+tZmU/pEHfCzP+9xz9pVRKI7rT9YY3oV8D+atqm0GYBJv4Gy6k0WOy3vVHYsrvJKGU9fS1SOiWabSatGXkDY9oAg9bS/I6YWL4R5Cip3Ocyil4ULOxKx1KH9lCOhjmm4K364QMU6i73EhUySyNIsFC6GLK5n4t/F5XgInZFMoJwhm37BFT5Bl004MYKvNbovB+SQhYjuoiAasA+Yz3F9tdLilIJevJtm6JxX1kA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2169
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966005)(6506007)(53546011)(7696005)(9686003)(186003)(2906002)(26005)(33656002)(52536014)(82310400002)(70586007)(356005)(70206006)(81166007)(47076004)(8676002)(82740400003)(6636002)(336012)(55016002)(4326008)(450100002)(316002)(54906003)(86362001)(36906005)(8936002)(110136005)(5660300002)(478600001)(83380400001)(921003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5337b053-3830-4ee4-c445-08d802041426
X-Forefront-PRVS: 04163EF38A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlJR5zeqQc1U8bOKuHBXX+PdShpUu4giax5D4Z1Dhsojt1U5GqwjxtuTCrzuuP5B0/tQw/z7FC2jRUaZA6YVy34yvcQqCiFWrSpr1pPt8yTDyTC9m98fSGeWc92xKV0qCtAFK6G4LMEBAEdr1r12/bAq5bAr8lWJLyAecR/11Jiv39I/vy5GULtp4YkxAP4qyKExWWcftd9nZNxbzLMogP5QU3TGIRRrJw+zVMmbXXkECHu1znRzFFdQDo9XgIBI5Fxji+Yv77C5Q2vagEmlE6h5W88BhwvQc9P8cSeFbM3ekzdqlTGDq4Z/EOPh+YW3VGnpzt7JwElat6ZO1TzR1ZabnT+2trlsJFxp6cDNyYTCl7GnRwWLCr5vby5lrj1akCYKwZanyhNmMQsCTBEG5N9xxYnkvBWH/4LWnMOoSnk=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 06:06:34.5261
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ea4bc5-0288-4e3c-6d56-08d802041c0b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5012
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RldmVuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0ZXZl
biBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1heSAyNiwg
MjAyMCA3OjAyIFBNDQo+IFRvOiBKaWFueW9uZyBXdSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47IG5l
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
Y2UgZm9yIGt2bSBwdHAuDQo+IA0KPiBPbiAyNS8wNS8yMDIwIDAzOjExLCBKaWFueW9uZyBXdSB3
cm90ZToNCj4gPiBIaSBTdGV2ZW4sDQo+IA0KPiBIaSBKaWFueW9uZywNCj4gDQo+IFsuLi5dPj4+
IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jIGIvdmlydC9rdm0vYXJtL2h5
cGVyY2FsbHMuYw0KPiA+Pj4gaW5kZXggZGI2ZGNlM2QwZTIzLi5jOTY0MTIyZjhkYWUgMTAwNjQ0
DQo+ID4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+ID4+PiArKysgYi92aXJ0
L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+ID4+PiBAQCAtMyw2ICszLDcgQEANCj4gPj4+DQo+ID4+
PiAgICAjaW5jbHVkZSA8bGludXgvYXJtLXNtY2NjLmg+DQo+ID4+PiAgICAjaW5jbHVkZSA8bGlu
dXgva3ZtX2hvc3QuaD4NCj4gPj4+ICsjaW5jbHVkZSA8bGludXgvY2xvY2tzb3VyY2VfaWRzLmg+
DQo+ID4+Pg0KPiA+Pj4gICAgI2luY2x1ZGUgPGFzbS9rdm1fZW11bGF0ZS5oPg0KPiA+Pj4NCj4g
Pj4+IEBAIC0xMSw2ICsxMiwxMCBAQA0KPiA+Pj4NCj4gPj4+ICAgIGludCBrdm1faHZjX2NhbGxf
aGFuZGxlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4+PiAgICB7DQo+ID4+PiArI2lmZGVm
IENPTkZJR19BUk02NF9LVk1fUFRQX0hPU1QNCj4gPj4+ICsJc3RydWN0IHN5c3RlbV90aW1lX3Nu
YXBzaG90IHN5c3RpbWVfc25hcHNob3Q7DQo+ID4+PiArCXU2NCBjeWNsZXM7DQo+ID4+PiArI2Vu
ZGlmDQo+ID4+PiAgICAJdTMyIGZ1bmNfaWQgPSBzbWNjY19nZXRfZnVuY3Rpb24odmNwdSk7DQo+
ID4+PiAgICAJdTMyIHZhbFs0XSA9IHtTTUNDQ19SRVRfTk9UX1NVUFBPUlRFRH07DQo+ID4+PiAg
ICAJdTMyIGZlYXR1cmU7DQo+ID4+PiBAQCAtNzAsNyArNzUsNDkgQEAgaW50IGt2bV9odmNfY2Fs
bF9oYW5kbGVyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPj4+ICAgIAkJYnJlYWs7DQo+ID4+
PiAgICAJY2FzZSBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fRkVBVFVSRVNfRlVOQ19JRDoNCj4g
Pj4+ICAgIAkJdmFsWzBdID0gQklUKEFSTV9TTUNDQ19LVk1fRlVOQ19GRUFUVVJFUyk7DQo+ID4+
PiArDQo+ID4+PiArI2lmZGVmIENPTkZJR19BUk02NF9LVk1fUFRQX0hPU1QNCj4gPj4+ICsJCXZh
bFswXSB8PSBCSVQoQVJNX1NNQ0NDX0tWTV9GVU5DX0tWTV9QVFApOyAjZW5kaWYNCj4gPj4+ICAg
IAkJYnJlYWs7DQo+ID4+PiArDQo+ID4+PiArI2lmZGVmIENPTkZJR19BUk02NF9LVk1fUFRQX0hP
U1QNCj4gPj4+ICsJLyoNCj4gPj4+ICsJICogVGhpcyBzZXJ2ZXMgdmlydHVhbCBrdm1fcHRwLg0K
PiA+Pj4gKwkgKiBGb3VyIHZhbHVlcyB3aWxsIGJlIHBhc3NlZCBiYWNrLg0KPiA+Pj4gKwkgKiBy
ZWcwIHN0b3JlcyBoaWdoIDMyLWJpdCBob3N0IGt0aW1lOw0KPiA+Pj4gKwkgKiByZWcxIHN0b3Jl
cyBsb3cgMzItYml0IGhvc3Qga3RpbWU7DQo+ID4+PiArCSAqIHJlZzIgc3RvcmVzIGhpZ2ggMzIt
Yml0IGRpZmZlcmVuY2Ugb2YgaG9zdCBjeWNsZXMgYW5kIGNudHZvZmY7DQo+ID4+PiArCSAqIHJl
ZzMgc3RvcmVzIGxvdyAzMi1iaXQgZGlmZmVyZW5jZSBvZiBob3N0IGN5Y2xlcyBhbmQgY250dm9m
Zi4NCj4gPj4+ICsJICovDQo+ID4+PiArCWNhc2UgQVJNX1NNQ0NDX1ZFTkRPUl9IWVBfS1ZNX1BU
UF9GVU5DX0lEOg0KPiA+Pj4gKwkJLyoNCj4gPj4+ICsJCSAqIHN5c3RlbSB0aW1lIGFuZCBjb3Vu
dGVyIHZhbHVlIG11c3QgY2FwdHVyZWQgaW4gdGhlIHNhbWUNCj4gPj4+ICsJCSAqIHRpbWUgdG8g
a2VlcCBjb25zaXN0ZW5jeSBhbmQgcHJlY2lzaW9uLg0KPiA+Pj4gKwkJICovDQo+ID4+PiArCQlr
dGltZV9nZXRfc25hcHNob3QoJnN5c3RpbWVfc25hcHNob3QpOw0KPiA+Pj4gKwkJaWYgKHN5c3Rp
bWVfc25hcHNob3QuY3NfaWQgIT0gQ1NJRF9BUk1fQVJDSF9DT1VOVEVSKQ0KPiA+Pj4gKwkJCWJy
ZWFrOw0KPiA+Pj4gKwkJdmFsWzBdID0gdXBwZXJfMzJfYml0cyhzeXN0aW1lX3NuYXBzaG90LnJl
YWwpOw0KPiA+Pj4gKwkJdmFsWzFdID0gbG93ZXJfMzJfYml0cyhzeXN0aW1lX3NuYXBzaG90LnJl
YWwpOw0KPiA+Pj4gKwkJLyoNCj4gPj4+ICsJCSAqIHdoaWNoIG9mIHZpcnR1YWwgY291bnRlciBv
ciBwaHlzaWNhbCBjb3VudGVyIGJlaW5nDQo+ID4+PiArCQkgKiBhc2tlZCBmb3IgaXMgZGVjaWRl
ZCBieSB0aGUgZmlyc3QgYXJndW1lbnQuDQo+ID4+PiArCQkgKi8NCj4gPj4+ICsJCWZlYXR1cmUg
PSBzbWNjY19nZXRfYXJnMSh2Y3B1KTsNCj4gPj4+ICsJCXN3aXRjaCAoZmVhdHVyZSkgew0KPiA+
Pj4gKwkJY2FzZSBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX1BIWV9GVU5DX0lEOg0KPiA+
Pj4gKwkJCWN5Y2xlcyA9IHN5c3RpbWVfc25hcHNob3QuY3ljbGVzOw0KPiA+Pj4gKwkJCWJyZWFr
Ow0KPiA+Pj4gKwkJZGVmYXVsdDoNCj4gPj4NCj4gPj4gVGhlcmUncyBzb21ldGhpbmcgYSBiaXQg
b2RkIGhlcmUuDQo+ID4+DQo+ID4+IEFSTV9TTUNDQ19WRU5ET1JfSFlQX0tWTV9QVFBfRlVOQ19J
RCBhbmQNCj4gPj4gQVJNX1NNQ0NDX1ZFTkRPUl9IWVBfS1ZNX1BUUF9QSFlfRlVOQ19JRCBsb29r
IGxpa2UgdGhleQ0KPiBzaG91bGQgYmUNCj4gPj4gbmFtZXMgb2Ygc2VwYXJhdGUgKHRvcC1sZXZl
bCkgZnVuY3Rpb25zLCBidXQgYWN0dWFsbHkgdGhlIF9QSFlfIG9uZQ0KPiA+PiBpcyBhIHBhcmFt
ZXRlciBmb3IgdGhlIGZpcnN0LiBJZiB0aGUgaW50ZW50aW9uIGlzIHRvIGhhdmUgYSBwYXJhbWV0
ZXINCj4gPj4gdGhlbiBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gcGljayBhIGJldHRlciBuYW1lIGZv
ciB0aGUgX1BIWV8gZGVmaW5lDQo+ID4+IGFuZCBub3QgZGVmaW5lIGl0IHVzaW5nIEFSTV9TTUND
Q19DQUxMX1ZBTC4NCj4gPj4NCj4gPiBZZWFoLCBfUEhZXyBpcyBub3QgdGhlIHNhbWUgbWVhbmlu
ZyB3aXRoIF9QVFBfRlVOQ19JRCwgIHNvIEkgdGhpbmsgaXQNCj4gc2hvdWxkIGJlIGEgZGlmZmVy
ZW50IG5hbWUuDQo+ID4gV2hhdCBhYm91dCBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX1BI
WV9DT1VOVEVSPw0KPiANCj4gUGVyc29uYWxseSBJJ2QgZ28gd2l0aCBzb21ldGhpbmcgbXVjaCBz
aG9ydGVyLCBlLmcuDQo+IEFSTV9QVFBfUEhZX0NPVU5URVIuDQo+IFRoaXMgaXMganVzdCBhbiBh
cmd1bWVudCB0byBhbiBTTUNDQyBjYWxsIHNvIHRoZXJlJ3Mgbm8gbmVlZCBmb3IgbW9zdCBvZiB0
aGUNCj4gcHJlZml4LCBpbmRlZWQgaWYgKGZvciB3aGF0ZXZlciByZWFzb24pIHRoZXJlIHdhcyBh
IG5vbi1TTUNDQyBtZWNoYW5pc20NCj4gYWRkZWQgdG8gZG8gdGhlIHNhbWUgdGhpbmcgaXQgd291
bGQgYmUgcmVhc29uYWJsZSB0byByZXVzZSB0aGUgc2FtZSB2YWx1ZXMuDQo+IA0KT2sgLCAgdGhp
cyBzaG9ydGVyIG5hbWUgaXMgYmV0dGVyLg0KDQo+ID4+IFNlY29uZCB0aGUgdXNlIG9mICJkZWZh
dWx0OiIgbWVhbnMgdGhhdCB0aGVyZSdzIG5vIHBvc3NpYmlsaXR5IHRvDQo+ID4+IGxhdGVyIGV4
dGVuZCB0aGlzIGludGVyZmFjZSBmb3IgbW9yZSBjbG9ja3MgaWYgbmVlZGVkIGluIHRoZSBmdXR1
cmUuDQo+ID4+DQo+ID4gSSB0aGluayB3ZSBjYW4gYWRkIG1vcmUgY2xvY2tzIGJ5IGFkZGluZyBt
b3JlIGNhc2VzLCB0aGlzICJkZWZhdWx0IiBtZWFucw0KPiB3ZSBjYW4gdXNlIG5vIGZpcnN0IGFy
ZyB0byBkZXRlcm1pbmUgdGhlIGRlZmF1bHQgY2xvY2suDQo+IA0KPiBUaGUgcHJvYmxlbSB3aXRo
IHRoZSAnZGVmYXVsdCcgaXMgaXQgbWVhbnMgaXQncyBub3QgcG9zc2libGUgdG8gcHJvYmUgd2hl
dGhlcg0KPiB0aGUga2VybmVsIHN1cHBvcnRzIGFueSBtb3JlIGNsb2Nrcy4gSWYgd2UgdXNlZCBh
IGRpZmZlcmVudCB2YWx1ZSAodGhhdCB0aGUNCj4ga2VybmVsIGRvZXNuJ3Qgc3VwcG9ydCkgdGhl
biB3ZSBlbmQgdXAgaW4gdGhlIGRlZmF1bHQgY2FzZSBhbmQgaGF2ZSBubyBpZGVhDQo+IHdoZXRo
ZXIgdGhlIGNsb2NrIHZhbHVlIGlzIHRoZSBvbmUgd2UgcmVxdWVzdGVkIG9yIG5vdC4NCj4gDQpZ
ZWFoLCAgaXQncyBtb3JlIG1lYW5pbmdmdWwuIFNob3VsZCByZXR1cm4gdGhlIGV4YWN0IHZhbHVl
IGJhY2sgdG8gdXNlci4NCg0KPiBJdCdzIGdlbmVyYWxseSBiZXR0ZXIgd2hlbiBkZWZpbmluZyBh
biBBQkkgdG8gZXhwbGljaXRseSByZXR1cm4gYW4gZXJyb3IgZm9yDQo+IHVua25vd24gcGFyYW1l
dGVycywgdGhhdCB3YXkgYSBmdXR1cmUgdXNlciBvZiB0aGUgQUJJIGNhbiBkaXNjb3Zlcg0KPiB3
aGV0aGVyIHRoZSBjYWxsIGRpZCB3aGF0IHdhcyBleHBlY3RlZCBvciBub3QuDQo+IA0KDQpvay4g
SSB3aWxsIGZpeCBpdC4NCg0KPiA+PiBBbHRlcm5hdGl2ZWx5IHlvdSBjb3VsZCBpbmRlZWQgaW1w
bGVtZW50IGFzIHR3byB0b3AtbGV2ZWwgZnVuY3Rpb25zDQo+ID4+IGFuZCBjaGFuZ2UgdGhpcyB0
byBhLi4uDQo+ID4+DQo+ID4+IAlzd2l0Y2ggKGZ1bmNfaWQpDQo+ID4+DQo+ID4+IC4uLiBhbG9u
ZyB3aXRoIG11bHRpcGxlIGNhc2UgbGFiZWxzIGFzIHRoZSBmdW5jdGlvbnMgd291bGQgb2J2aW91
c2x5DQo+ID4+IGJlIG1vc3RseSB0aGUgc2FtZS4NCj4gPj4NCj4gPj4gQWxzbyBhIG1pbm9yIHN0
eWxlIGlzc3VlIC0geW91IG1pZ2h0IHdhbnQgdG8gY29uc2lkZXIgc3BsaXR0aW5nIHRoaXMNCj4g
Pj4gaW50byBpdCdzIG93biBmdW5jdGlvbi4NCj4gPj4NCj4gPiBJIHRoaW5rICJzd2l0Y2ggKGZl
YXR1cmUpIiBtYXliZSBiZXR0ZXIgYXMgdGhpcyBfUEhZXyBpcyBub3QgbGlrZSBhIGZ1bmN0aW9u
DQo+IGlkLiBKdXN0IGxpa2U6DQo+ID4gIg0KPiA+IGNhc2UgQVJNX1NNQ0NDX0FSQ0hfRkVBVFVS
RVNfRlVOQ19JRDoNCj4gPiAgICAgICAgICAgICAgICAgIGZlYXR1cmUgPSBzbWNjY19nZXRfYXJn
MSh2Y3B1KTsNCj4gPiAgICAgICAgICAgICAgICAgIHN3aXRjaCAoZmVhdHVyZSkgew0KPiA+ICAg
ICAgICAgICAgICAgICAgY2FzZSBBUk1fU01DQ0NfQVJDSF9XT1JLQVJPVU5EXzE6DQo+ID4gLi4u
DQo+ID4gIg0KPiANCj4gSSdtIGhhcHB5IGVpdGhlciB3YXkgLSBpdCdzIHB1cmVseSB0aGF0IHRo
ZSBkZWZpbml0aW9uL25hbWluZyBvZg0KPiBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX1BI
WV9GVU5DX0lEIG1hZGUgaXQgbG9vayBsaWtlIHRoYXQNCj4gd2FzIHRoZSBpbnRlbnRpb24uIE15
IHByZWZlcmVuY2Ugd291bGQgYmUgdG8gc3RpY2sgd2l0aCB0aGUgJ2ZlYXR1cmUnDQo+IGFwcHJv
YWNoIGFzIGFib3ZlIGJlY2F1c2UgdGhlcmUncyBubyBuZWVkIHRvICJ1c2UgdXAiIHRoZSB0b3At
bGV2ZWwgU01DQ0MNCj4gY2FsbHMgKGJ1dCBlcXVhbGx5IHRoZXJlJ3MgYSBsYXJnZSBzcGFjZSBz
byB3ZSdkIGhhdmUgdG8gd29yayB2ZXJ5IGhhcmQgdG8gcnVuDQo+IG91dC4uLiA7KSApDQo+DQpX
ZSBjYW4gY2hhbmdlIHRoZSBuYW1lIG9mICJfUEhZX0NPVU5URVIiLCBidXQgaXQgd2lsbCByZW1h
aW4gaW4gdGhlIHNhbWUgbGV2ZWwgd2l0aCAiX0ZVTkNfSUQiIGFzDQpJdCB3aWxsIHN0aWxsIG9j
Y3VweSBhIHBsYWNlIHJlc2VydmVkIGZvciBWRU5ET1IgU01DQ0MgY2FsbC4NCkp1c3QgbGlrZSBB
Uk1fU01DQ0NfQVJDSF9XT1JLQVJPVU5EXzEsDQoNCiNkZWZpbmUgQVJNX1NNQ0NDX0FSQ0hfV09S
S0FST1VORF8xICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAg
QVJNX1NNQ0NDX0NBTExfVkFMKEFSTV9TTUNDQ19GQVNUX0NBTEwsICAgICAgICAgICAgICAgICAg
ICAgICAgIFwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgIEFSTV9TTUNDQ19TTUNfMzIsICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgIDAs
IDB4ODAwMCkNCg0KIEl0IHdpbGwgYmUgYSBBUkNIIFNNQ0NDIGNhbGwgaWQgZnJvbSB0aGUgdmll
dyBvZiBpdHMgZGVmaW5pdGlvbi4NCg0KPiA+PiBGaW5hbGx5IEkgZG8gdGhpbmsgaXQgd291bGQg
YmUgdXNlZnVsIHRvIGFkZCBzb21lIGRvY3VtZW50YXRpb24gb2YNCj4gPj4gdGhlIG5ldyBTTUMg
Y2FsbHMuIEl0IHdvdWxkIGJlIGVhc2llciB0byByZXZpZXcgdGhlIGludGVyZmFjZSBiYXNlZA0K
PiA+PiBvbiB0aGF0IGRvY3VtZW50YXRpb24gcmF0aGVyIHRoYW4gdHJ5aW5nIHRvIHJldmVyc2Ut
ZW5naW5lZXIgdGhlDQo+ID4+IGludGVyZmFjZSBmcm9tIHRoZSBjb2RlLg0KPiA+Pg0KPiA+IFll
YWgsIG1vcmUgZG9jIG5lZWRlZCBoZXJlLg0KPiANCj4gVGhhbmtzLCBJIHRoaW5rIGl0J3MgYSBn
b29kIGlkZWEgdG8gZ2V0IHRoZSBBQkkgbmFpbGVkIGRvd24gYmVmb3JlIHdvcnJ5aW5nDQo+IHRv
byBtdWNoIGFib3V0IHRoZSBjb2RlLCBhbmQgaXQncyBlYXNpZXIgdG8gZGlzY3VzcyBiYXNlZCBv
biBkb2N1bWVudGF0aW9uDQo+IHJhdGhlciB0aGFuIGNvZGUuDQo+DQpZZWFoLCBhIGRvY3VtZW50
IGhlcmUgaXMgaW4gZmF2b3Igb2YgY29kZSByZXZpZXcuDQogDQpUaGFua3MNCkppYW55b25nIA0K
DQo+IFRoYW5rcywNCj4gDQo+IFN0ZXZlDQo=
