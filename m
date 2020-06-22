Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B961E202E53
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 04:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbgFVCZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 22:25:45 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:2158
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726992AbgFVCZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 22:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+2wgkCfswpinypFIlzV4ZjoaDq7c3n4X+13S8yhCs=;
 b=2MFZ0jBW7ET5bqtdkbHSK6B7dO/HDEGG1leJ9u22eMDhUazH5FrpbGdfCbcF2d363ZnwEUR9xh23wzkRPf/I2Edzc1h839r5FRs8Elu8nNdGUowlgSIDyM/aJvLi/AXNgm2kEEDOOFoLt/CI3hZvSiPQksjHPyjRqtDv4LAgliU=
Received: from DB6PR07CA0160.eurprd07.prod.outlook.com (2603:10a6:6:43::14) by
 DB6PR0802MB2485.eurprd08.prod.outlook.com (2603:10a6:4:9b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.24; Mon, 22 Jun 2020 02:25:36 +0000
Received: from DB5EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:43:cafe::f3) by DB6PR07CA0160.outlook.office365.com
 (2603:10a6:6:43::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend
 Transport; Mon, 22 Jun 2020 02:25:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT003.mail.protection.outlook.com (10.152.20.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 02:25:36 +0000
Received: ("Tessian outbound da41658aa5d4:v59"); Mon, 22 Jun 2020 02:25:36 +0000
X-CR-MTA-TID: 64aa7808
Received: from cda8fea7d4e9.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C8F0FB60-374B-4D68-B388-6C246FCFADE0.1;
        Mon, 22 Jun 2020 02:25:31 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cda8fea7d4e9.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 22 Jun 2020 02:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oX72EJUQkN0E10fEpWlHPfxyymiL6FtPIZH5P8uyB2htnxmoGgLMKUeH2cPVogGVDxpehk9CbrTi2E7tbPbLo8eRaUjgJPTSuE5BL5XQeRd8n0tg58e9AkPRX9LsNXvedCtOkXA6S8hMKL1uQn2RfscRg7vAxu76GqMtPuC3cDID9qNWDgSmyAn9vtu/eHUAcUyzz8a1nSnH3gRHHd7G27MerghzLGRvG+yWvGcLU0BnuwyNrgFIFTt1xzT+1nuqMwXbxyOmkDDp7GPtHioVKsddzIjTiToNljcE/m1QTnDaT+1+iMKaWLiUi7ZKj104bX756pPF2CAn0xLHn+ksgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+2wgkCfswpinypFIlzV4ZjoaDq7c3n4X+13S8yhCs=;
 b=XtKgHxvkNlPiJu+/xIABormmXweAIp80eA03flevRCmURvdVZw2zqvkDrCSC8sTj0H3RX/iOYmt/FWJcgJ/JxLD+36Qg1PhXiebSBxCG9R4vIKiCdC4uOpYhAUb4VbZLvjJG4y6sBquKip2tcSnf72rU3MjmbKAcL4Kx2MdMi5UbctsFxfqfvknqlG9CA5edHeLvcS3nw2bxuGgjAV7lEsrMm9yoAi31f24A9dATZ1daFNdg2/vZ5lZuUoZACJGLPIV4SH/rqXJ3hOrYWucLucqdS2ZXkPlyWbXzEydAYZBNPNIYBVFkgSmMa+sv0shlHDD4X84GRS/vP2qgBkVj+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+2wgkCfswpinypFIlzV4ZjoaDq7c3n4X+13S8yhCs=;
 b=2MFZ0jBW7ET5bqtdkbHSK6B7dO/HDEGG1leJ9u22eMDhUazH5FrpbGdfCbcF2d363ZnwEUR9xh23wzkRPf/I2Edzc1h839r5FRs8Elu8nNdGUowlgSIDyM/aJvLi/AXNgm2kEEDOOFoLt/CI3hZvSiPQksjHPyjRqtDv4LAgliU=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2169.eurprd08.prod.outlook.com (2603:10a6:3:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 02:25:29 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 02:25:29 +0000
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
Thread-Index: AQHWRhxz06Mst+c5/kmb7LupZG0AtqjfwQIAgAQdABA=
Date:   Mon, 22 Jun 2020 02:25:28 +0000
Message-ID: <HE1PR0802MB25558F9A526C327134C7A7EEF4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
 <20200619093033.58344-8-jianyong.wu@arm.com>
 <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
In-Reply-To: <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 8e68230a-6bd9-4394-b465-26611406ea1c.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b08a9a8-d690-4ed5-fd06-08d816538c76
x-ms-traffictypediagnostic: HE1PR0802MB2169:|DB6PR0802MB2485:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB248571F8CFB13AD07A448B31F4970@DB6PR0802MB2485.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: s4u9hcUEDmZ6upZriXZs9u0gzSPWcCDXKOapDSqatV+PXQZyVOXMya1eczkmMCXmtgMF/CxcYV7/T8xX/CP8vbfaljFowQkSTlW3S8MiuElhZip/Q5sr71tHxWvoRMidtK6USp7HZPzvGFjXjpKnEODhqB8dDl/uJohGKonsT0FzzqXaWni0OAeinDMee4xQHTQM8qY8K8jisscE7EVytAeLN4g2MVyubu/w7/KnYaUbbh0DyC9s7vs4XxqsrnUSzuh4DPNWdfpOB1I6fsnXSt4y6ZQC7d0xM0mmluyBAK77X/Gn2KPGB7m4i1MkYu3dVNma0K3YtlllzVazCAzmZz3ZVNqDBwjrpGe8z+SIdh1HxvOK/tNU68NYlgqnSoyR
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(396003)(39850400004)(376002)(136003)(4326008)(66476007)(7416002)(71200400001)(316002)(7696005)(110136005)(478600001)(83380400001)(33656002)(54906003)(6636002)(5660300002)(55016002)(9686003)(64756008)(6506007)(53546011)(66446008)(52536014)(26005)(8936002)(66556008)(2906002)(8676002)(76116006)(66946007)(186003)(86362001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: haS+UhtPdUkMQm/hn0ir6BtqzBTlSHyCICM6wdXLHnVvRSrOVZCK7lu5cWWlDhZv6+XQiRRqoKmOBYyA/3psom3nBx1EVnn3Xc+z3T3pchUn9V+3Dy9G8iaBTiABBneRgG/apQ1dXIlBpUW3Bf0y1DLe9v3dkVrT61ca08ePx7rdWFrtf3gvTdrJfFxX8b1ou6XUMySfzWLWB9aJHyeSg5FRUWSvmBIn75QoXAQgeYtbWeV2x86SOFZZdp2hkh91NKFi+LC13iu9U9v+kkoOfgG47yo46Kuu7eyAbf4b5nbdwCuk+1mrxKVm+WGGaieoASRh9yqvnz6TvzLNUm//OjmCKiMO0iF0nvESMAS0N5mrc6drDUM2cvWu4uqea15N1Zjq9vMXXeJMuDJnur/E+bD3/+FQ3/6rYblBfddbXQGE9M3RrQC5HWaUncz7Uwj4Vyfc7IG4GHh8f7J7VCf0mhkXiDHYWDZr3uS+sUwWl0c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2169
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(376002)(396003)(346002)(136003)(46966005)(8676002)(53546011)(6506007)(186003)(2906002)(8936002)(82310400002)(26005)(316002)(110136005)(9686003)(55016002)(7696005)(54906003)(6636002)(33656002)(478600001)(83380400001)(86362001)(4326008)(336012)(450100002)(356005)(70586007)(82740400003)(5660300002)(47076004)(52536014)(81166007)(70206006)(921003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9945d26c-0156-429c-d823-08d8165387f4
X-Forefront-PRVS: 0442E569BC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5DRDGGtsirtDY/8Vjv1RoQ5K32Dp7fUJB+XdUeEckPdMnWf5f47xwrY7hZw7gVx/Q/QvBjYZDqDxASXGpbIVSXUP7sdF8VksG3fs9rnDr7H6jaUyrCcaoq7+MdM7de9Tji/5WtXBRyTHAESjI2cHxoBT7Ta85JxDtNJylRVOONrAKd093Xg1PjHwHkHQ8OYvt+R/4mtKC+M8oksQpm+YOb0ejpZOEHY+C/rr1J43LrZfQYzIqcReztsSxOl/kj2g7VSwAuCCUUvvEBcJoh2cIhTrh0xTrt61xMBosj9RaT7maCs9GQWP1dSzAtAuQmAXaQdlBWO9bg5KKlPTzgFFPQZIoq3EZyivFFRLenAHtoMIzWatjtG0d/FCoCa6ijpGMjHcO00YTnFiLdxPKralR+lXoAhX5HHb+tcwWPo7E4=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 02:25:36.7500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b08a9a8-d690-4ed5-fd06-08d816538c76
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RldmVuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0ZXZl
biBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSAxOSwg
MjAyMCA2OjQ1IFBNDQo+IFRvOiBKaWFueW9uZyBXdSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47IG5l
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
cnZpY2UgZm9yIGt2bQ0KPiBwdHAuDQo+IA0KPiBPbiAxOS8wNi8yMDIwIDEwOjMwLCBKaWFueW9u
ZyBXdSB3cm90ZToNCj4gPiBwdHBfa3ZtIHdpbGwgZ2V0IHRoaXMgc2VydmljZSB0aHJvdWdoIHNt
Y2NjIGNhbGwuDQo+ID4gVGhlIHNlcnZpY2Ugb2ZmZXJzIHdhbGwgdGltZSBhbmQgY291bnRlciBj
eWNsZSBvZiBob3N0IGZvciBndWVzdC4NCj4gPiBjYWxsZXIgbXVzdCBleHBsaWNpdGx5IGRldGVy
bWluZXMgd2hpY2ggY3ljbGUgb2YgdmlydHVhbCBjb3VudGVyIG9yDQo+ID4gcGh5c2ljYWwgY291
bnRlciB0byByZXR1cm4gaWYgaXQgbmVlZHMgY291bnRlciBjeWNsZS4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEppYW55b25nIFd1IDxqaWFueW9uZy53dUBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+
ICAgYXJjaC9hcm02NC9rdm0vS2NvbmZpZyAgICAgIHwgIDYgKysrKysNCj4gPiAgIGFyY2gvYXJt
NjQva3ZtL2h5cGVyY2FsbHMuYyB8IDUwDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4gPiAgIGluY2x1ZGUvbGludXgvYXJtLXNtY2NjLmggICB8IDMwICsrKysrKysr
KysrKysrKysrKysrKysNCj4gPiAgIDMgZmlsZXMgY2hhbmdlZCwgODYgaW5zZXJ0aW9ucygrKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL0tjb25maWcgYi9hcmNoL2FybTY0
L2t2bS9LY29uZmlnIGluZGV4DQo+ID4gMTM0ODlhZmY0NDQwLi43OTA5MWY2ZTVlN2EgMTAwNjQ0
DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vS2NvbmZpZw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQv
a3ZtL0tjb25maWcNCj4gPiBAQCAtNjAsNiArNjAsMTIgQEAgY29uZmlnIEtWTV9BUk1fUE1VDQo+
ID4gICBjb25maWcgS1ZNX0lORElSRUNUX1ZFQ1RPUlMNCj4gPiAgIAlkZWZfYm9vbCBIQVJERU5f
QlJBTkNIX1BSRURJQ1RPUiB8fCBIQVJERU5fRUwyX1ZFQ1RPUlMNCj4gPg0KPiA+ICtjb25maWcg
QVJNNjRfS1ZNX1BUUF9IT1NUDQo+ID4gKwlib29sICJLVk0gUFRQIGhvc3Qgc2VydmljZSBmb3Ig
YXJtNjQiDQo+ID4gKwlkZWZhdWx0IHkNCj4gPiArCWhlbHANCj4gPiArCSAgdmlydHVhbCBrdm0g
cHRwIGNsb2NrIGh5cGVyY2FsbCBzZXJ2aWNlIGZvciBhcm02NA0KPiA+ICsNCj4gPiAgIGVuZGlm
ICMgS1ZNDQo+ID4NCj4gPiAgIGVuZGlmICMgVklSVFVBTElaQVRJT04NCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vaHlwZXJjYWxscy5jIGIvYXJjaC9hcm02NC9rdm0vaHlwZXJjYWxs
cy5jDQo+ID4gaW5kZXggZGI2ZGNlM2QwZTIzLi4zNjZiMDY0NmMzNjAgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vaHlwZXJjYWxscy5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0v
aHlwZXJjYWxscy5jDQo+ID4gQEAgLTMsNiArMyw3IEBADQo+ID4NCj4gPiAgICNpbmNsdWRlIDxs
aW51eC9hcm0tc21jY2MuaD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9rdm1faG9zdC5oPg0KPiA+
ICsjaW5jbHVkZSA8bGludXgvY2xvY2tzb3VyY2VfaWRzLmg+DQo+ID4NCj4gPiAgICNpbmNsdWRl
IDxhc20va3ZtX2VtdWxhdGUuaD4NCj4gPg0KPiA+IEBAIC0xMSw2ICsxMiwxMCBAQA0KPiA+DQo+
ID4gICBpbnQga3ZtX2h2Y19jYWxsX2hhbmRsZXIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+
ICAgew0KPiA+ICsjaWZkZWYgQ09ORklHX0FSTTY0X0tWTV9QVFBfSE9TVA0KPiA+ICsJc3RydWN0
IHN5c3RlbV90aW1lX3NuYXBzaG90IHN5c3RpbWVfc25hcHNob3Q7DQo+ID4gKwl1NjQgY3ljbGVz
ID0gMDsNCj4gPiArI2VuZGlmDQo+ID4gICAJdTMyIGZ1bmNfaWQgPSBzbWNjY19nZXRfZnVuY3Rp
b24odmNwdSk7DQo+ID4gICAJdTMyIHZhbFs0XSA9IHtTTUNDQ19SRVRfTk9UX1NVUFBPUlRFRH07
DQo+ID4gICAJdTMyIGZlYXR1cmU7DQo+ID4gQEAgLTcwLDcgKzc1LDUyIEBAIGludCBrdm1faHZj
X2NhbGxfaGFuZGxlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gICAJCWJyZWFrOw0KPiA+
ICAgCWNhc2UgQVJNX1NNQ0NDX1ZFTkRPUl9IWVBfS1ZNX0ZFQVRVUkVTX0ZVTkNfSUQ6DQo+ID4g
ICAJCXZhbFswXSA9IEJJVChBUk1fU01DQ0NfS1ZNX0ZVTkNfRkVBVFVSRVMpOw0KPiA+ICsNCj4g
PiArI2lmZGVmIENPTkZJR19BUk02NF9LVk1fUFRQX0hPU1QNCj4gPiArCQl2YWxbMF0gfD0gQklU
KEFSTV9TTUNDQ19LVk1fRlVOQ19LVk1fUFRQKTsgI2VuZGlmDQo+ID4gKwkJYnJlYWs7DQo+ID4g
Kw0KPiA+ICsjaWZkZWYgQ09ORklHX0FSTTY0X0tWTV9QVFBfSE9TVA0KPiA+ICsJLyoNCj4gPiAr
CSAqIFRoaXMgc2VydmVzIHZpcnR1YWwga3ZtX3B0cC4NCj4gPiArCSAqIEZvdXIgdmFsdWVzIHdp
bGwgYmUgcGFzc2VkIGJhY2suDQo+ID4gKwkgKiByZWcwIHN0b3JlcyBoaWdoIDMyLWJpdCBob3N0
IGt0aW1lOw0KPiA+ICsJICogcmVnMSBzdG9yZXMgbG93IDMyLWJpdCBob3N0IGt0aW1lOw0KPiA+
ICsJICogcmVnMiBzdG9yZXMgaGlnaCAzMi1iaXQgZGlmZmVyZW5jZSBvZiBob3N0IGN5Y2xlcyBh
bmQgY250dm9mZjsNCj4gPiArCSAqIHJlZzMgc3RvcmVzIGxvdyAzMi1iaXQgZGlmZmVyZW5jZSBv
ZiBob3N0IGN5Y2xlcyBhbmQgY250dm9mZi4NCj4gPiArCSAqLw0KPiA+ICsJY2FzZSBBUk1fU01D
Q0NfVkVORE9SX0hZUF9LVk1fUFRQX0ZVTkNfSUQ6DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBzeXN0
ZW0gdGltZSBhbmQgY291bnRlciB2YWx1ZSBtdXN0IGNhcHR1cmVkIGluIHRoZSBzYW1lDQo+ID4g
KwkJICogdGltZSB0byBrZWVwIGNvbnNpc3RlbmN5IGFuZCBwcmVjaXNpb24uDQo+ID4gKwkJICov
DQo+ID4gKwkJa3RpbWVfZ2V0X3NuYXBzaG90KCZzeXN0aW1lX3NuYXBzaG90KTsNCj4gPiArCQlp
ZiAoc3lzdGltZV9zbmFwc2hvdC5jc19pZCAhPSBDU0lEX0FSTV9BUkNIX0NPVU5URVIpDQo+ID4g
KwkJCWJyZWFrOw0KPiA+ICsJCXZhbFswXSA9IHVwcGVyXzMyX2JpdHMoc3lzdGltZV9zbmFwc2hv
dC5yZWFsKTsNCj4gPiArCQl2YWxbMV0gPSBsb3dlcl8zMl9iaXRzKHN5c3RpbWVfc25hcHNob3Qu
cmVhbCk7DQo+ID4gKwkJLyoNCj4gPiArCQkgKiB3aGljaCBvZiB2aXJ0dWFsIGNvdW50ZXIgb3Ig
cGh5c2ljYWwgY291bnRlciBiZWluZw0KPiA+ICsJCSAqIGFza2VkIGZvciBpcyBkZWNpZGVkIGJ5
IHRoZSBmaXJzdCBhcmd1bWVudCBvZiBzbWNjYw0KPiA+ICsJCSAqIGNhbGwuIElmIG5vIGZpcnN0
IGFyZ3VtZW50IG9yIGludmFsaWQgYXJndW1lbnQsIHplcm8NCj4gPiArCQkgKiBjb3VudGVyIHZh
bHVlIHdpbGwgcmV0dXJuOw0KPiA+ICsJCSAqLw0KPiANCj4gSXQncyBub3QgYWN0dWFsbHkgcG9z
c2libGUgdG8gaGF2ZSAibm8gZmlyc3QgYXJndW1lbnQiIC0gdGhlcmUncyBubyBhcmd1bWVudA0K
PiBjb3VudCwgc28gd2hhdGV2ZXIgaXMgaW4gdGhlIHJlZ2lzdGVyIGR1cmluZyB0aGUgY2FsbCB3
aXRoIGJlIHBhc3NlZC4gSSdkIGFsc28NCj4gY2F1dGlvbiB0aGF0ICJmaXJzdCBhcmd1bWVudCIg
aXMgYW1iaWdpb3VzOiByMCBjb3VsZCBiZSB0aGUgJ2ZpcnN0JyBidXQgaXMgYWxzbyB0aGUNCj4g
ZnVuY3Rpb24gbnVtYmVyLCBoZXJlIHlvdSBtZWFuIHIxLg0KPiANClNvcnJ5LCAgSSByZWFsbHkg
bWFrZSBtaXN0YWtlIGhlcmUsIEkgcmVhbGx5IG1lYW4gbm8gcjEgdmFsdWUuDQoNCj4gVGhlcmUn
cyBhbHNvIGEgc3VidGxlIGNhc3QgdG8gMzIgYml0cyBoZXJlIChmZWF0dXJlIGlzIHUzMiksIHdo
aWNoIG1pZ2h0IGJlDQo+IHdvcnRoIGEgY29tbWVudCBiZWZvcmUgc29tZW9uZSAnb3B0aW1pc2Vz
JyBieSByZW1vdmluZyB0aGUgJ2ZlYXR1cmUnDQo+IHZhcmlhYmxlLg0KPiANClllYWgsIGl0J3Mg
YmV0dGVyIHRvIGFkZCBhIG5vdGUsIGJ1dCBJIHRoaW5rIGl0J3MgYmV0dGVyIGFkZCBpdCBhdCB0
aGUgZmlyc3QgdGltZSBjYWxsaW5nIHNtY2NjX2dldF9hcmcxLiANCldEWVQ/DQoNCj4gRmluYWxs
eSBJJ20gbm90IHN1cmUgaWYgemVybyBjb3VudGVyIHZhbHVlIGlzIGJlc3QgLSB3b3VsZCBpdCBu
b3QgYmUgcG9zc2libGUgZm9yDQo+IHRoaXMgdG8gYmUgYSB2YWxpZCBjb3VudGVyIHZhbHVlPw0K
DQpXZSBoYXZlIHR3byBkaWZmZXJlbnQgd2F5cyB0byBjYWxsIHRoaXMgc2VydmljZSBpbiBwdHBf
a3ZtIGd1ZXN0LCBvbmUgbmVlZHMgY291bnRlciBjeWNsZSwgIHRoZSBvdGhlcg0Kbm90LiBTbyBJ
IHRoaW5rIGl0J3MgdmFpbiB0byByZXR1cm4gYSB2YWxpZCBjb3VudGVyIGN5Y2xlIGJhY2sgaWYg
dGhlIHB0cF9rdm0gZG9lcyBub3QgbmVlZHMgaXQuDQoNCj4gDQo+ID4gKwkJZmVhdHVyZSA9IHNt
Y2NjX2dldF9hcmcxKHZjcHUpOw0KPiA+ICsJCXN3aXRjaCAoZmVhdHVyZSkgew0KPiA+ICsJCWNh
c2UgQVJNX1BUUF9WSVJUX0NPVU5URVI6DQo+ID4gKwkJCWN5Y2xlcyA9IHN5c3RpbWVfc25hcHNo
b3QuY3ljbGVzIC0NCj4gPiArCQkJdmNwdV92dGltZXIodmNwdSktPmNudHZvZmY7DQo+IA0KPiBQ
bGVhc2UgaW5kZW50IHRoZSBjb250aW51YXRpb24gbGluZSBzbyB0aGF0IGl0J3Mgb2J2aW91cy4N
Ck9rLA0KDQo+IA0KPiA+ICsJCQlicmVhazsNCj4gPiArCQljYXNlIEFSTV9QVFBfUEhZX0NPVU5U
RVI6DQo+ID4gKwkJCWN5Y2xlcyA9IHN5c3RpbWVfc25hcHNob3QuY3ljbGVzOw0KPiA+ICsJCQli
cmVhazsNCj4gPiArCQl9DQo+ID4gKwkJdmFsWzJdID0gdXBwZXJfMzJfYml0cyhjeWNsZXMpOw0K
PiA+ICsJCXZhbFszXSA9IGxvd2VyXzMyX2JpdHMoY3ljbGVzKTsNCj4gPiAgIAkJYnJlYWs7DQo+
ID4gKyNlbmRpZg0KPiA+ICsNCj4gPiAgIAlkZWZhdWx0Og0KPiA+ICAgCQlyZXR1cm4ga3ZtX3Bz
Y2lfY2FsbCh2Y3B1KTsNCj4gPiAgIAl9DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
YXJtLXNtY2NjLmggYi9pbmNsdWRlL2xpbnV4L2FybS1zbWNjYy5oDQo+ID4gaW5kZXggODZmZjMw
MTMxZTdiLi5lNTkzZWM1MTVmODIgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9hcm0t
c21jY2MuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvYXJtLXNtY2NjLmgNCj4gPiBAQCAtOTgs
NiArOTgsOSBAQA0KPiA+DQo+ID4gICAvKiBLVk0gInZlbmRvciBzcGVjaWZpYyIgc2VydmljZXMg
Ki8NCj4gPiAgICNkZWZpbmUgQVJNX1NNQ0NDX0tWTV9GVU5DX0ZFQVRVUkVTCQkwDQo+ID4gKyNk
ZWZpbmUgQVJNX1NNQ0NDX0tWTV9GVU5DX0tWTV9QVFAJCTENCj4gPiArI2RlZmluZSBBUk1fU01D
Q0NfS1ZNX0ZVTkNfS1ZNX1BUUF9QSFkJCTINCj4gPiArI2RlZmluZSBBUk1fU01DQ0NfS1ZNX0ZV
TkNfS1ZNX1BUUF9WSVJUCQkzDQo+ID4gICAjZGVmaW5lIEFSTV9TTUNDQ19LVk1fRlVOQ19GRUFU
VVJFU18yCQkxMjcNCj4gPiAgICNkZWZpbmUgQVJNX1NNQ0NDX0tWTV9OVU1fRlVOQ1MJCQkxMjgN
Cj4gPg0KPiA+IEBAIC0xMDcsNiArMTEwLDMzIEBADQo+ID4gICAJCQkgICBBUk1fU01DQ0NfT1dO
RVJfVkVORE9SX0hZUCwNCj4gCQlcDQo+ID4gICAJCQkgICBBUk1fU01DQ0NfS1ZNX0ZVTkNfRkVB
VFVSRVMpDQo+ID4NCj4gPiArLyoNCj4gPiArICoga3ZtX3B0cCBpcyBhIGZlYXR1cmUgdXNlZCBm
b3IgdGltZSBzeW5jIGJldHdlZW4gdm0gYW5kIGhvc3QuDQo+ID4gKyAqIGt2bV9wdHAgbW9kdWxl
IGluIGd1ZXN0IGtlcm5lbCB3aWxsIGdldCBzZXJ2aWNlIGZyb20gaG9zdCB1c2luZw0KPiA+ICsg
KiB0aGlzIGh5cGVyY2FsbCBJRC4NCj4gPiArICovDQo+ID4gKyNkZWZpbmUgQVJNX1NNQ0NDX1ZF
TkRPUl9IWVBfS1ZNX1BUUF9GVU5DX0lEDQo+IAkJXA0KPiA+ICsJQVJNX1NNQ0NDX0NBTExfVkFM
KEFSTV9TTUNDQ19GQVNUX0NBTEwsDQo+IAkJXA0KPiA+ICsJCQkgICBBUk1fU01DQ0NfU01DXzMy
LA0KPiAJXA0KPiA+ICsJCQkgICBBUk1fU01DQ0NfT1dORVJfVkVORE9SX0hZUCwNCj4gCQlcDQo+
ID4gKwkJCSAgIEFSTV9TTUNDQ19LVk1fRlVOQ19LVk1fUFRQKQ0KPiA+ICsNCj4gPiArLyoNCj4g
PiArICoga3ZtX3B0cCBtYXkgZ2V0IGNvdW50ZXIgY3ljbGUgZnJvbSBob3N0IGFuZCBzaG91bGQg
YXNrIGZvciB3aGljaA0KPiA+ICtvZg0KPiA+ICsgKiBwaHlzaWNhbCBjb3VudGVyIG9yIHZpcnR1
YWwgY291bnRlciBieSB1c2luZyBBUk1fUFRQX1BIWV9DT1VOVEVSDQo+ID4gK2FuZA0KPiA+ICsg
KiBBUk1fUFRQX1ZJUlRfQ09VTlRFUiBleHBsaWNpdGx5Lg0KPiA+ICsgKi8NCj4gPiArI2RlZmlu
ZSBBUk1fUFRQX1BIWV9DT1VOVEVSDQo+IAlcDQo+ID4gKwlBUk1fU01DQ0NfQ0FMTF9WQUwoQVJN
X1NNQ0NDX0ZBU1RfQ0FMTCwNCj4gCQlcDQo+ID4gKwkJCSAgIEFSTV9TTUNDQ19TTUNfMzIsDQo+
IAlcDQo+ID4gKwkJCSAgIEFSTV9TTUNDQ19PV05FUl9WRU5ET1JfSFlQLA0KPiAJCVwNCj4gPiAr
CQkJICAgQVJNX1NNQ0NDX0tWTV9GVU5DX0tWTV9QVFBfUEhZKQ0KPiA+ICsNCj4gPiArI2RlZmlu
ZSBBUk1fUFRQX1ZJUlRfQ09VTlRFUg0KPiAJXA0KPiA+ICsJQVJNX1NNQ0NDX0NBTExfVkFMKEFS
TV9TTUNDQ19GQVNUX0NBTEwsDQo+IAkJXA0KPiA+ICsJCQkgICBBUk1fU01DQ0NfU01DXzMyLA0K
PiAJXA0KPiA+ICsJCQkgICBBUk1fU01DQ0NfT1dORVJfVkVORE9SX0hZUCwNCj4gCQlcDQo+ID4g
KwkJCSAgIEFSTV9TTUNDQ19LVk1fRlVOQ19LVk1fUFRQX1ZJUlQpDQo+IA0KPiBUaGVzZSB0d28g
YXJlIG5vdCBTTUNDQyBjYWxscyB0aGVtc2VsdmVzIChqdXN0IHBhcmFtZXRlcnMgdG8gYW4gU01D
Q0MpLA0KPiBzbyB0aGV5IHJlYWxseSBzaG91bGRuJ3QgYmUgZGVmaW5lZCB1c2luZyBBUk1fU01D
Q0NfQ0FMTF9WQUwgKGl0J3MganVzdA0KPiBjb25mdXNpbmcgYW5kIHVubmVjZXNzYXJ5KS4gQ2Fu
IHdlIG5vdCBqdXN0IHBpY2sgc21hbGwgaW50ZWdlcnMgKGUuZy4gMCBhbmQgMSkNCj4gZm9yIHRo
ZXNlPw0KPiANClllYWgsIEkgdGhpbmsgc28sIGl0J3MgYmV0dGVyIHRvIGRlZmluZSB0aGVzZSBw
YXJhbWV0ZXJzIElEIGFzIHNpbmdsZSBudW1iZXIgYW5kIG5vdCByZWxhdGVkIHRvDQpTTUNDQy4g
V2hhdCBhYm91dCBrZWVwIHRoZXNlIDIgbWFjcm9zIGFuZCBkZWZpbmUgaXQgZGlyZWN0bHkgYXMg
YSBudW1iZXIgaW4gaW5jbHVkZS9saW51eC9hcm0tc21jY2MuaC4NCg0KPiBXZSBhbHNvIG5lZWQg
c29tZSBkb2N1bWVudGF0aW9uIG9mIHRoZXNlIFNNQ0NDIGNhbGxzIHNvbWV3aGVyZSB3aGljaA0K
PiB3b3VsZCBtYWtlIHRoaXMgc29ydCBvZiByZXZpZXcgZWFzaWVyLiBGb3IgaW5zdGFuY2UgZm9y
IHBhcmF2aXJ0dWFsaXNlZCBzdG9sZW4NCj4gdGltZSB0aGVyZSBpcyBEb2N1bWVudGF0aW9uL3Zp
cnQva3ZtL2FybS9wdnRpbWUucnN0ICh3aGljaCBhbHNvIGxpbmtzIHRvDQo+IHRoZSBwdWJsaXNo
ZWQgZG9jdW1lbnQgZnJvbSBBcm0pLg0KPiANCkdvb2QgcG9pbnQsIGEgZG9jdW1lbnRhdGlvbiBp
cyBuZWVkZWQgdG8gZXhwbGFpbiB0aGVzZSBuZXcgU01DQ0MgZnVuY3MuIA0KRG8geW91IHRoaW5r
IHdlIHNob3VsZCBkbyB0aGF0IGluIHRoaXMgcGF0Y2ggc2VyaWFsPyBEb2VzIGl0IGJleW9uZCB0
aGUgc2NvcGUgb2YgdGhpcyBwYXRjaCBzZXQ/DQoNClRoYW5rcw0KSmlhbnlvbmcgIA0KDQo+IFN0
ZXZlDQo+IA0KPiA+ICAgI2lmbmRlZiBfX0FTU0VNQkxZX18NCj4gPg0KPiA+ICAgI2luY2x1ZGUg
PGxpbnV4L2xpbmthZ2UuaD4NCj4gPg0KDQo=
