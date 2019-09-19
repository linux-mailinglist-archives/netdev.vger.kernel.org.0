Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBDB7695
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388936AbfISJqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:46:39 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:22444
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388893AbfISJqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 05:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2j3RWGXGUS3WpdJ7KP2KwCH/OYvngwX+b/395TqE64=;
 b=hwKzPH+TRMnjEPQaRZfebutqofsOwMhV7l+nfLVSmrlsvIuIkKHI3zR7lsBvO5vyxipPrAitom5+gCrIRytVpNeoUzXWu9vmcFcy+K44Rq/t8dnuwBm3Uoe4tYjlc7oyjUkc4J/5KcRm8AnZIZZE9bXt3/TgpEKK6U58QdNiGm0=
Received: from DB6PR0801CA0061.eurprd08.prod.outlook.com (2603:10a6:4:2b::29)
 by DBBPR08MB4556.eurprd08.prod.outlook.com (2603:10a6:10:c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20; Thu, 19 Sep
 2019 09:46:21 +0000
Received: from DB5EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::208) by DB6PR0801CA0061.outlook.office365.com
 (2603:10a6:4:2b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Thu, 19 Sep 2019 09:46:21 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT028.mail.protection.outlook.com (10.152.20.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20 via Frontend Transport; Thu, 19 Sep 2019 09:46:19 +0000
Received: ("Tessian outbound d5a1f2820a4f:v31"); Thu, 19 Sep 2019 09:46:17 +0000
X-CR-MTA-TID: 64aa7808
Received: from c001fcaa8126.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.6.56])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B0D9F232-FC9F-45B0-A428-E7604FD6AEC4.1;
        Thu, 19 Sep 2019 09:46:12 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c001fcaa8126.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 19 Sep 2019 09:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFxSFP5kKoptOwh3rPNu/ZqjX7HJpHZEmVX9aTtfqL2mjT0/NlgTrkwuXO9N00Lw6Su1nkMptZX9X/h5JhHCd++GART7qTLABJJUcC9/kvmUNzKskMxSHsM84i+sM9D9dK58gvDh3WOri+87gxQxS0AiWBT1Z0XsRohO7GzeXYMP5LjS1fGeAEUsYR4b3WJXT4+CMDfm5gy5dzfG85WIHDGIVMLgnSmMat+4BLZN9GY8sx049lOnzN4bclX4lJUL/8T/iW5IvhjCc3ylHcVQQOscr33SVeMvZdD9QfA66f9cZr5USvVTpyh+n9Jxmrb9A98iT1oVDMu6QnKe84KKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2j3RWGXGUS3WpdJ7KP2KwCH/OYvngwX+b/395TqE64=;
 b=Npd/Z2vI0GI46l/bZ7NycbFXfGFa1DlYuwYoDEjOjMEoGJNQTbByfe5mwsUZLIdr5JufWEpF065h3u9p2TmVBSBuUvRHj61tIjw2l4H46EJnWCwi9Nzz6vfmlB7xowko/9j8tjkivC2VScDiaEN+tXAsLfyVo+BBQbCMzSFVNd3NbVr8JQN/NimpSv7nLjP21E/yhqkvXQ8xS7axI95N7Yzu9DghsEDa3kguR7ju2DEjBHcLdqbMIiTuFjGo6UqQjoD+G4XG8sWqAiApm51yYZz8D/jWWsXEvBBry4873UJWAABOzsYO7QcnPZawv3fXTfz6tnPyjVNJ0xUbM4rrDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2j3RWGXGUS3WpdJ7KP2KwCH/OYvngwX+b/395TqE64=;
 b=hwKzPH+TRMnjEPQaRZfebutqofsOwMhV7l+nfLVSmrlsvIuIkKHI3zR7lsBvO5vyxipPrAitom5+gCrIRytVpNeoUzXWu9vmcFcy+K44Rq/t8dnuwBm3Uoe4tYjlc7oyjUkc4J/5KcRm8AnZIZZE9bXt3/TgpEKK6U58QdNiGm0=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2028.eurprd08.prod.outlook.com (10.168.98.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 19 Sep 2019 09:46:09 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2263.023; Thu, 19 Sep
 2019 09:46:09 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhA
Date:   Thu, 19 Sep 2019 09:46:08 +0000
Message-ID: <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
In-Reply-To: <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2e0a5818-cc41-4d73-8165-d60d3ba1c970.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 2a69928e-808b-4a56-c3f4-08d73ce6395b
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:HE1PR0801MB2028;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2028:|HE1PR0801MB2028:|DBBPR08MB4556:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB4556EFE5A1ECE6B048EC1AA2F4890@DBBPR08MB4556.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 016572D96D
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(189003)(199004)(13464003)(55236004)(66066001)(9686003)(26005)(4326008)(256004)(55016002)(74316002)(229853002)(478600001)(25786009)(6436002)(7736002)(7416002)(6636002)(71190400001)(6246003)(71200400001)(305945005)(14454004)(66556008)(64756008)(76116006)(66476007)(476003)(11346002)(446003)(81166006)(8676002)(8936002)(81156014)(66446008)(2501003)(66946007)(102836004)(6506007)(186003)(86362001)(33656002)(316002)(53546011)(99286004)(76176011)(7696005)(2201001)(5660300002)(6116002)(54906003)(2906002)(3846002)(52536014)(486006)(110136005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2028;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: p8uNAZGXspSUZHH/OmMePywXIMOnnaHJBOctabF6nM1dosVkcnfZdLIF3iXTzY+RCDLft+GJBe7nqEvOXoTU2OrSUQQaoL6b/wNzu4haeDI681+U9IpSa4x6yLO7EXCAA38wKuWRjv/l0fNEpfQR8RxQFnwwuja5eGwPCUm2VdlqMGZYqcx7mqTrCGrS0+x9jBD9zF5CvYF7acrugEbExxiz8utNbbbJuRW9r5xll7j+2b83y7G2fyrUZqRN3PG1KQA5JmRkLjWlL8WDyS3NNIG0HYy0bEG8ngRXrM591gcyVw369r6UR0EjaHoOOqM0eihvpTBZn5ThfdVNvm1N139HGEB4V5Nn0FJyEAH/qnLktCZNfeYMJ7OISflTvbqU+HZWCdqd3Uh9T70NVjYilZNt/wFqFXVl8a7w0LuoCR4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2028
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(199004)(189003)(13464003)(4326008)(2486003)(76176011)(6506007)(26005)(186003)(110136005)(7696005)(54906003)(23676004)(99286004)(2906002)(22756006)(102836004)(316002)(53546011)(229853002)(126002)(336012)(476003)(63350400001)(74316002)(6636002)(305945005)(6246003)(3846002)(6116002)(107886003)(9686003)(55016002)(446003)(11346002)(436003)(486006)(47776003)(81156014)(81166006)(8676002)(50466002)(8936002)(52536014)(86362001)(25786009)(66066001)(26826003)(70586007)(70206006)(2201001)(7736002)(14454004)(5660300002)(478600001)(356004)(2501003)(76130400001)(33656002)(450100002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR08MB4556;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: e77ef40a-80c9-4255-b6e3-08d73ce63323
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DBBPR08MB4556;
NoDisclaimer: True
X-Forefront-PRVS: 016572D96D
X-Microsoft-Antispam-Message-Info: TeE+bBt6YsPYaS/JAiuQCTwh1winwTAKEK5JTt8qz8HiJyl5ALZq+u9NuKzNZxUvnF5jpFVO0d8pL8lZz3n1HDB5IsB5xc4h7x7SmtLVWKstU//ASuW4KpHL5JIWfBj77nXhH3j8592QtQN8cksc1Km4jeIK/BC95+1wrpZfWlcxkU/VLlO/72oZEQMox31EIf8ZykAIL6QRaXMtq9f38WBBDFIkSKpuJvTikrthL0MikJGTZcCVdF4XtaRfV8qfiRHIYL/VjdsItRFLhGpmGzPKpamTdH58srcazpSxDyMo+8kR0EmyTvPCLV9RV7npZUjBBGnBcrNfEn0bzOZRsbANC4LVoNex1nlg/HTz9nF3DFKqviI6mMXu59+Bdd2s5fMF4RdGMLMqwA4kYZn2n42suGAgHrb4lSt20lv0s00=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2019 09:46:19.7843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a69928e-808b-4a56-c3f4-08d73ce6395b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4556
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1i
ZXIgMTgsIDIwMTkgNjoyNCBQTQ0KPiBUbzogSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENo
aW5hKSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHlh
bmdiby5sdUBueHAuY29tOyBqb2huLnN0dWx0ekBsaW5hcm8ub3JnOw0KPiB0Z2x4QGxpbnV0cm9u
aXguZGU7IHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb207IG1hekBrZXJuZWwub3JnOw0K
PiByaWNoYXJkY29jaHJhbkBnbWFpbC5jb207IE1hcmsgUnV0bGFuZCA8TWFyay5SdXRsYW5kQGFy
bS5jb20+OyBXaWxsDQo+IERlYWNvbiA8V2lsbC5EZWFjb25AYXJtLmNvbT47IFN1enVraSBQb3Vs
b3NlDQo+IDxTdXp1a2kuUG91bG9zZUBhcm0uY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgU3RldmUgQ2FwcGVyDQo+IDxTdGV2ZS5D
YXBwZXJAYXJtLmNvbT47IEthbHkgWGluIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEthbHku
WGluQGFybS5jb20+OyBKdXN0aW4gSGUgKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8SnVzdGlu
LkhlQGFybS5jb20+OyBuZCA8bmRAYXJtLmNvbT47IGxpbnV4LWFybS0NCj4ga2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjMgNC82XSBwc2NpOiBB
ZGQgaHZjIGNhbGwgc2VydmljZSBmb3IgcHRwX2t2bS4NCj4gDQo+IE9uIDE4LzA5LzE5IDExOjU3
LCBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIHdyb3RlOg0KPiA+IEhpIFBhb2xv
LA0KPiA+DQo+ID4+IE9uIDE4LzA5LzE5IDEwOjA3LCBKaWFueW9uZyBXdSB3cm90ZToNCj4gPj4+
ICsJY2FzZSBBUk1fU01DQ0NfVkVORE9SX0hZUF9LVk1fUFRQX0ZVTkNfSUQ6DQo+ID4+PiArCQln
ZXRuc3RpbWVvZmRheSh0cyk7DQo+ID4+DQo+ID4+IFRoaXMgaXMgbm90IFkyMDM4LXNhZmUuICBQ
bGVhc2UgdXNlIGt0aW1lX2dldF9yZWFsX3RzNjQgaW5zdGVhZCwgYW5kDQo+ID4+IHNwbGl0IHRo
ZSA2NC1iaXQgc2Vjb25kcyB2YWx1ZSBiZXR3ZWVuIHZhbFswXSBhbmQgdmFsWzFdLg0KPiA+Pg0K
PiA+IEFzIGZhciBhcyBJIGtub3csIHkyMDM4LXNhZmUgd2lsbCBvbmx5IGFmZmVjdCBzaWduZWQg
MzItYml0IGludGVnZXIsDQo+ID4gaG93IGRvZXMgaXQgYWZmZWN0IDY0LWJpdCBpbnRlZ2VyPw0K
PiA+IEFuZCB3aHkgc3BsaXQgNjQtYml0IG51bWJlciBpbnRvIHR3byBibG9ja3MgaXMgbmVjZXNz
YXJ5Pw0KPiANCj4gdmFsIGlzIGFuIHUzMiwgbm90IGFuIHU2NC4gIChBbmQgdmFsWzBdLCB3aGVy
ZSB5b3Ugc3RvcmUgdGhlIHNlY29uZHMsIGlzIGJlc3QNCj4gdHJlYXRlZCBhcyBzaWduZWQsIHNp
bmNlIHZhbFswXSA9PSAtMSBpcyByZXR1cm5lZCBmb3INCj4gU01DQ0NfUkVUX05PVF9TVVBQT1JU
RUQpLg0KPiANClllYWgsIG5lZWQgY29uc2lkZXIgdHdpY2UuDQpWYWxbXSBzaG91bGQgYmUgbG9u
ZyBub3QgdTMyIEkgdGhpbmssIHNvIGluIGFybTY0IEkgY2FuIGF2b2lkIHRoYXQgWTIwMzhfc2Fm
ZSwgYnV0DQphbHNvIG5lZWQgcmV3cml0ZSBmb3IgYXJtMzIuDQoNCj4gPj4gSG93ZXZlciwgaXQg
c2VlbXMgdG8gbWUgdGhhdCB0aGUgbmV3IGZ1bmN0aW9uIGlzIG5vdCBuZWVkZWQgYW5kIHlvdQ0K
PiA+PiBjYW4ganVzdCB1c2Uga3RpbWVfZ2V0X3NuYXBzaG90LiAgWW91J2xsIGdldCB0aGUgdGlt
ZSBpbg0KPiA+PiBzeXN0aW1lX3NuYXBzaG90LT5yZWFsIGFuZCB0aGUgY3ljbGVzIHZhbHVlIGlu
IHN5c3RpbWVfc25hcHNob3QtPmN5Y2xlcy4NCj4gPg0KPiA+IFNlZSBwYXRjaCA1LzYsIEkgbmVl
ZCBib3RoIGNvdW50ZXIgY3ljbGUgYW5kIGNsb2Nrc291cmNlLA0KPiBrdGltZV9nZXRfc25hcHNo
b3Qgc2VlbXMgb25seSBvZmZlciBjeWNsZXMuDQo+IA0KPiBObywgcGF0Y2ggNS82IG9ubHkgbmVl
ZHMgdGhlIGN1cnJlbnQgY2xvY2sgKHB0cF9zYy5jeWNsZXMgaXMgbmV2ZXIgYWNjZXNzZWQpLg0K
PiBTbyB5b3UgY291bGQganVzdCB1c2UgUkVBRF9PTkNFKHRrLT50a3JfbW9uby5jbG9jaykuDQo+
DQpZZWFoLCBwYXRjaCA1LzYganVzdCBuZWVkIGNsb2Nrc291cmNlLCBidXQgSSB0aGluayB0ay0+
dGtyX21vbm8uY2xvY2sgY2FuJ3QgcmVhZCBpbiBleHRlcm5hbCBsaWtlIG1vZHVsZSwNClNvIEkg
bmVlZCBhbiBBUEkgdG8gZXhwb3NlIGNsb2Nrc291cmNlLg0KIA0KPiBIb3dldmVyLCBldmVuIHRo
ZW4gSSBkb24ndCB0aGluayBpdCBpcyBjb3JyZWN0IHRvIHVzZSBwdHBfc2MuY3MgYmxpbmRseSBp
biBwYXRjaA0KPiA1LiAgSSB0aGluayB0aGVyZSBpcyBhIG1pc3VuZGVyc3RhbmRpbmcgb24gdGhl
IG1lYW5pbmcgb2YNCj4gc3lzdGVtX2NvdW50ZXJ2YWwuY3MgYXMgcGFzc2VkIHRvIGdldF9kZXZp
Y2Vfc3lzdGVtX2Nyb3NzdHN0YW1wLg0KPiBzeXN0ZW1fY291bnRlcnZhbC5jcyBpcyBub3QgdGhl
IGFjdGl2ZSBjbG9ja3NvdXJjZTsgaXQncyB0aGUgY2xvY2tzb3VyY2Ugb24NCj4gd2hpY2ggc3lz
dGVtX2NvdW50ZXJ2YWwuY3ljbGVzIGlzIGJhc2VkLg0KPiANCg0KSSB0aGluayB3ZSBjYW4gdXNl
IHN5c3RlbV9jb3VudGVydmFsX3QgYXMgcGFzcyBjdXJyZW50IGNsb2Nrc291cmNlIHRvIHN5c3Rl
bV9jb3VudGVydmFsX3QuY3MgYW5kIGl0cw0KY29ycmVzcG9uZGluZyBjeWNsZXMgdG8gc3lzdGVt
X2NvdW50ZXJ2YWxfdC5jeWNsZXMuIGlzIGl0IGEgYmlnIHByb2JsZW0/DQoNCj4gSHlwb3RoZXRp
Y2FsbHksIHRoZSBjbG9ja3NvdXJjZSBjb3VsZCBiZSBvbmUgZm9yIHdoaWNoIHB0cF9zYy5jeWNs
ZXMgaXMgX25vdF8NCj4gYSBjeWNsZSB2YWx1ZS4gIElmIHlvdSBzZXQgc3lzdGVtX2NvdW50ZXJ2
YWwuY3MgdG8gdGhlIHN5c3RlbSBjbG9ja3NvdXJjZSwNCj4gZ2V0X2RldmljZV9zeXN0ZW1fY3Jv
c3N0c3RhbXAgd2lsbCByZXR1cm4gYSBib2d1cyB2YWx1ZS4NCg0KWWVhaCwgYnV0IGluIHBhdGNo
IDMvNiwgd2UgaGF2ZSBhIGNvcnJlc3BvbmRpbmcgcGFpciBvZiBjbG9jayBzb3VyY2UgYW5kIGN5
Y2xlIHZhbHVlLiBTbyBJIHRoaW5rIHRoZXJlIHdpbGwgYmUgbm8NCnRoYXQgcHJvYmxlbSBpbiB0
aGlzIHBhdGNoIHNldC4NCkluIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiBnZXRfZGV2aWNlX3N5c3Rl
bV9jcm9zc3RzdGFtcDoNCiINCi4uLg0KaWYgKHRrLT50a3JfbW9uby5jbG9jayAhPSBzeXN0ZW1f
Y291bnRlcnZhbC5jcykNCiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOw0K
Li4uDQoiDQpXZSBuZWVkIHRrLT50a3JfbW9uby5jbG9jayBwYXNzZWQgdG8gZ2V0X2RldmljZV9z
eXN0ZW1fY3Jvc3N0c3RhbXAsIGp1c3QgbGlrZSBwYXRjaCAzLzYgZG8sIG90aGVyd2lzZSB3aWxs
IHJldHVybiBlcnJvci4NCg0KDQo+IFNvIHN5c3RlbV9jb3VudGVydmFsLmNzIHNob3VsZCBiZSBz
ZXQgdG8gc29tZXRoaW5nIGxpa2UNCj4gJmNsb2Nrc291cmNlX2NvdW50ZXIgKGZyb20gZHJpdmVy
cy9jbG9ja3NvdXJjZS9hcm1fYXJjaF90aW1lci5jKS4NCj4gUGVyaGFwcyB0aGUgcmlnaHQgcGxh
Y2UgdG8gZGVmaW5lIGt2bV9hcmNoX3B0cF9nZXRfY2xvY2tfZm4gaXMgaW4gdGhhdCBmaWxlPw0K
Pg0KSSBoYXZlIGNoZWNrZWQgdGhhdCBwdHBfc2MuY3MgaXMgYXJjaF9zeXNfY291bnRlci4NCkFs
c28gbW92ZSB0aGUgbW9kdWxlIEFQSSB0byBhcm1fYXJjaF90aW1lci5jIHdpbGwgbG9va3MgYSBs
aXR0bGUgdWdseSBhbmQgaXQncyBub3QgZWFzeSB0byBiZSBhY2NlcHQgYnkgYXJtIHNpZGUgSSB0
aGluay4NCiANCj4gPj4+ICsJCWdldF9jdXJyZW50X2NvdW50ZXJ2YWwoJnNjKTsNCj4gPj4+ICsJ
CXZhbFswXSA9IHRzLT50dl9zZWM7DQo+ID4+PiArCQl2YWxbMV0gPSB0cy0+dHZfbnNlYzsNCj4g
Pj4+ICsJCXZhbFsyXSA9IHNjLmN5Y2xlczsNCj4gPj4+ICsJCXZhbFszXSA9IDA7DQo+ID4+PiAr
CQlicmVhazsNCj4gPj4NCj4gPj4gVGhpcyBzaG91bGQgcmV0dXJuIGEgZ3Vlc3QtY3ljbGVzIHZh
bHVlLiAgSWYgdGhlIGN5Y2xlcyB2YWx1ZXMgYWx3YXlzDQo+ID4+IHRoZSBzYW1lIGJldHdlZW4g
dGhlIGhvc3QgYW5kIHRoZSBndWVzdCBvbiBBUk0sIHRoZW4gb2theS4gIElmIG5vdCwNCj4gPj4g
eW91IGhhdmUgdG8gYXBwbHkgd2hhdGV2ZXIgb2Zmc2V0IGV4aXN0cy4NCj4gPj4NCj4gPiBJbiBt
eSBvcGluaW9uLCB3aGVuIHVzZSBwdHBfa3ZtIGFzIGNsb2NrIHNvdXJjZXMgdG8gc3luYyB0aW1l
IGJldHdlZW4NCj4gPiBob3N0IGFuZCBndWVzdCwgdXNlciBzaG91bGQgcHJvbWlzZSB0aGUgZ3Vl
c3QgYW5kIGhvc3QgaGFzIG5vIGNsb2NrDQo+ID4gb2Zmc2V0Lg0KPiANCj4gV2hhdCB3b3VsZCBi
ZSB0aGUgYWR2ZXJzZSBlZmZlY3Qgb2YgaGF2aW5nIGEgZml4ZWQgb2Zmc2V0IGJldHdlZW4gZ3Vl
c3QNCj4gYW5kIGhvc3Q/ICBJZiB0aGVyZSB3ZXJlIG9uZSwgeW91J2QgaGF2ZSB0byBjaGVjayB0
aGF0IGFuZCBmYWlsIHRoZSBoeXBlcmNhbGwgaWYNCj4gdGhlcmUgaXMgYW4gb2Zmc2V0LiAgQnV0
IGFnYWluLCBJIHRoaW5rIGl0J3MgZW5vdWdoIHRvIHN1YnRyYWN0DQo+IHZjcHVfdnRpbWVyKHZj
cHUpLT5jbnR2b2ZmIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuDQo+IA0KU3VyZSwgY291bnRlciBv
ZmZzZXQgc2hvdWxkIGJlIGNvbnNpZGVyZWQuDQoNCj4gWW91IGFsc28gaGF2ZSB0byBjaGVjayBo
ZXJlIHRoYXQgdGhlIGNsb2Nrc291cmNlIGlzIGJhc2VkIG9uIHRoZSBBUk0NCj4gYXJjaGl0ZWN0
dXJhbCB0aW1lci4gIEFnYWluLCBtYXliZSB5b3UgY291bGQgcGxhY2UgdGhlIGltcGxlbWVudGF0
aW9uIGluDQo+IGRyaXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYywgYW5kIG1ha2Ug
aXQgcmV0dXJuIC1FTk9ERVYgaWYgdGhlDQo+IGFjdGl2ZSBjbG9ja3NvdXJjZSBpcyBub3QgY2xv
Y2tzb3VyY2VfY291bnRlci4gIFRoZW4gS1ZNIGNhbiBsb29rIGZvciBlcnJvcnMNCj4gYW5kIHJl
dHVybiBTTUNDQ19SRVRfTk9UX1NVUFBPUlRFRCBpbiB0aGF0IGNhc2UuDQoNCkkgaGF2ZSBjaGVj
a2VkIGl0LiBUaGUgY2xvY2sgc291cmNlIGlzIGFyY2hfc3lzX2NvdW50ZXIgd2hpY2ggaXMgYXJt
IGFyY2ggdGltZXIuDQpJIGNhbiB0cnkgdG8gZG8gdGhhdCBidXQgSSdtIG5vdCBzdXJlIGFybSBz
aWRlIHdpbGwgYmUgaGFwcHkgZm9yIHRoYXQgY2hhbmdlLg0KDQpUaGFua3MgDQpKaWFueW9uZyBX
dQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBQYW9sbw0KPiANCj4gPiBTbyB3ZSBjYW4gYmUgc3Vy
ZSB0aGF0IHRoZSBjeWNsZSBiZXR3ZWVuIGd1ZXN0IGFuZCBob3N0IHNob3VsZCBiZSBrZWVwDQo+
ID4gY29uc2lzdGVudC4gQnV0IEkgbmVlZCBjaGVjayBpdC4NCj4gPiBJIHRoaW5rIGhvc3QgY3lj
bGUgc2hvdWxkIGJlIHJldHVybmVkIHRvIGd1ZXN0IGFzIHdlIHNob3VsZCBwcm9taXNlIHdlDQo+
ID4gZ2V0IGNsb2NrIGFuZCBjb3VudGVyIGluIHRoZSBzYW1lIHRpbWUuDQoNCg==
