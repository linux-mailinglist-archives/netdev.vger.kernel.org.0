Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C6E1C2446
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 11:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEBJJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 05:09:31 -0400
Received: from mail-eopbgr20049.outbound.protection.outlook.com ([40.107.2.49]:13700
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726488AbgEBJJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 May 2020 05:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBpM4vLQkQdo2i+JbrFsNSNQK5wnxZIzHw2suzRC6M=;
 b=qQNwtR0+GK/25ABzttbhMMF7SqvErPTsT3H3Lity9nmUWXlzTGaSYRKJq1SsUxG/2SeoI8Xk9vhM63UDnVwTvxLeQfs4cm9K6q5Un39hdFvio3pVNRpi5k1rOFvNglHNeY4IHjAw+NbDPBnKhfEbBYIAfW0A1hJRadq6zF6JQA8=
Received: from DB8PR06CA0061.eurprd06.prod.outlook.com (2603:10a6:10:120::35)
 by AM0PR08MB3233.eurprd08.prod.outlook.com (2603:10a6:208:60::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Sat, 2 May
 2020 09:09:23 +0000
Received: from DB5EUR03FT062.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:120:cafe::f3) by DB8PR06CA0061.outlook.office365.com
 (2603:10a6:10:120::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Sat, 2 May 2020 09:09:23 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT062.mail.protection.outlook.com (10.152.20.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Sat, 2 May 2020 09:09:23 +0000
Received: ("Tessian outbound 5abcb386707e:v54"); Sat, 02 May 2020 09:09:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d7090e413c09c1e9
X-CR-MTA-TID: 64aa7808
Received: from 1392149b8590.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CC8A66DC-EAD2-4B9C-9508-0A1780F8D052.1;
        Sat, 02 May 2020 09:09:17 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1392149b8590.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sat, 02 May 2020 09:09:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4o2EFsKMHNl9KDNuoQb9asyS9YVgmXJX/MACuWylimpnkUMrE+45ye2qFfiypTEu5+62Y0w5KBj4rcesSkDzoPAGc4UjYUEgcBPT2sBWowKk0UBjJ9SbX4F142E2tYgk7LFRBrxAC9UW/kUXpwve0K61horbQVulFOPHMJTU4K+jGgeAlf1ZXjQIwwdCFhVc9Lb3bE/6Yn+YqKAe6FCBDgW1WGA3yB2ZWWyUm3QyoAFUCDa5DDKKtbNoV/cbO0KXfk2vlfiBw+YD7Aa8a3HEf31lLrYMt1Y9gKy4+p/wWDymUzdtausglN+slDOb02XtvxbIk19n2sPRTeVZoG+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBpM4vLQkQdo2i+JbrFsNSNQK5wnxZIzHw2suzRC6M=;
 b=ngwX+O7DSBCfYKwUYtjZBuEBxDl5/nUIMf3OICnnnL2pGD+zJnfk7WFHvWswy/kXNLJI1t8fvQeCxXgIa60tNFiMC0iqu0Lscan6QdwjwDFLvxSs60x+K/2MHKYp23NP+f5xEV1mo7zMKvaiTQaA7c1dhbdBYbVog+o16bM2vqkwpNUrOwFXU8Hfjjwm7uI5KcYsDJQ2sX/VOq9Q3VfWsDwuL3P95bbak1Au6dIjgQkeiu92iggOK1+2JuXJAb4KvnQaXvsAn+hVUizveCMQ4yg9w+Qy2TZJX+hk9dLQFUnXQtIqWo6NFeIYIKFZd6swISSVY0svtIB+024UUhSKpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBpM4vLQkQdo2i+JbrFsNSNQK5wnxZIzHw2suzRC6M=;
 b=qQNwtR0+GK/25ABzttbhMMF7SqvErPTsT3H3Lity9nmUWXlzTGaSYRKJq1SsUxG/2SeoI8Xk9vhM63UDnVwTvxLeQfs4cm9K6q5Un39hdFvio3pVNRpi5k1rOFvNglHNeY4IHjAw+NbDPBnKhfEbBYIAfW0A1hJRadq6zF6JQA8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2348.eurprd08.prod.outlook.com (2603:10a6:3:c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Sat, 2 May
 2020 09:09:14 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 09:09:14 +0000
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
Thread-Index: AQHWF4xRpK0ubTCCx0eiqM1JOH1VE6iDV3gAgAQ/ngCAAIMxgIAF/0YAgANt2ACAAwwzAA==
Date:   Sat, 2 May 2020 09:09:13 +0000
Message-ID: <1d418fdc-1a5c-7723-3d30-448a22faac53@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
 <20200424103953.GD1167@C02TD0UTHF1T.local>
 <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
 <20200430103646.GB39784@C02TD0UTHF1T.local>
In-Reply-To: <20200430103646.GB39784@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c219a22-eea4-4375-8ded-08d7ee788171
x-ms-traffictypediagnostic: HE1PR0802MB2348:|HE1PR0802MB2348:|AM0PR08MB3233:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB3233AF0F63A79CF879344874F4A80@AM0PR08MB3233.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 039178EF4A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(6636002)(6512007)(4326008)(6862004)(31696002)(966005)(31686004)(478600001)(36756003)(66946007)(5660300002)(76116006)(86362001)(91956017)(186003)(66476007)(66556008)(64756008)(66446008)(55236004)(71200400001)(37006003)(2616005)(8676002)(54906003)(53546011)(6506007)(2906002)(6486002)(8936002)(26005)(7416002)(316002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: itaKgl9Od6qN5wKW4TU4wmqJvA4B/GNOxCzo3IOUxMc12rbOdQY+yNacCl6zXkvCHz6IybxCQBrhzmFk/5X5yvI8BlQSmoSMRR0Ag2j7U8x+cZvPim/c5FbE/IXlxGhakTPFOTANVVXrKKqdHZDevupEcN1Cq9Z15ZeTKwBnNGGyLsZueuhnztApC0lHxtrqr29VdGdSuKHfB6phj426Q5jy9kzbsnOrxFviD/MLCRbkdMFOg/5pskpmNMs8adddgqFAwahVzgyQB9AOWSdLOHDYOL+z4BU2dhnJml/wpXqhnUc9uvsd2B7L2kqwtu27N5FGFk1kEiOhreEojK9yoBHkvn0BpjrK+Evn7YP80mUdN60U9Z9MY++JaYToWuSbDY5rFDuAQsCqzGtouR47Tz7Zxg6vaQP1329ubphA2JfZvwozbUohU3QpJNPu4LdcBXpg0dJU51TWSulKbQfRmsBDpSkc8FpNjwn4DLT+dxXkTSwy5ZNHd+MKCFcVBnlkcYSvHih8kStxLRr+Juw95b820a8xSYNeWeXGhcfCe0e6hscFm7Y3ywbhqzotWRdm
x-ms-exchange-antispam-messagedata: Pzarievv2D2ov8nTlNNtin5xrV4qSO4QQCrg94omFBluCnKREVG/Vu0EdqqGVCb0esfx8Daq/J+LaDIXoawAJRUlUb/i1CWRguLrPIQSROUgpBl+YjF3x5C/7mgg8jl3jRtJOAN8vQheogTHwtV2DFPRqg3Yk4iLf05hAahDfiWvJNsERB0cnFvJpMq1wk4x+YZ0DDSvC+L8cSp/XjFW1jbeAfP2n8eGO5ZAXPmgAYul3EeESDybjHuVFCK5qYGWyxxNQZDzGinAOb/yWEJTqZwcCJBv1ccJzsRFOjdgzAlgbtmWbJ2qaKcWqH0qBqkjAmNjIkPcPd2JGlbPcOxcYrsOWq1Hq5Z/4/8LUk8FBvaiVPceIDKpaJ0gnU1oZ75qaIQ9iwmC+oLjlIZX3cunURSPkJe/eiY1O+K2OIVzGImfK4ZH9oWn3gMU0B8BlAI4YBJA11kTZUBkB63c0a+KzieVUxLV7f6LNI1LejenX0HFySdbKaN3I//mltbMCoo+NpfyZ1TY1r8UqwoNFoNZK56ltPofJKAdQOsJXKKa5VtV4wmbs9n3beLLdmBxsoThFpohTvKY/iwd4+rnvH21AslSuIL6Gy/+FRZpw+IHa0mACvsefXjy7kNDQ12LG2m0uKK+XpsMJr6ST4pdQU8nu+fDSfnOEfbxTgvTxnPYA+TfAxqDxAoBqOO6pPrq80jrYKlnbqvySnXpsrkn9XTzcaUWh1rcg3e8lEin0PrjScPBPU9qo78c3D4xBbJCV3IvOvBzyx9kiQ81kgRIVrhhUhMKoJAHGZFU5+4TOq2hSaQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24C5D66CA26DA04ABEB7817FA2CB77FE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2348
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT062.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966005)(81166007)(6486002)(356005)(82310400002)(86362001)(336012)(2616005)(186003)(966005)(53546011)(31686004)(26005)(8936002)(8676002)(70206006)(70586007)(36756003)(31696002)(5660300002)(82740400003)(47076004)(316002)(54906003)(6636002)(450100002)(2906002)(6862004)(4326008)(37006003)(6506007)(478600001)(6512007)(21314003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1a0d667d-2875-4fe6-8a87-08d7ee787c5d
X-Forefront-PRVS: 039178EF4A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02/GL5kUpBYcxgXSccINjqV8ZImI+TirWfAmugJjG1v5CNETG6F5/K7mv3/pOssW9+xZOMyfbdlSAdUaVzJe74axihGsR6lyZSlq9dhvZ8hgJHKKV8KbidC5BJh78FC3CPma9AA8cz3QiMTbjAH42vvIX2rByoN7b5jGDDWYl541K7JroEw4N9LyJ7SSULEAA/vHpDWspi9nTPuPMpqyboRKRLr4O7MPo+tzhF2cpLIJUlKSddFHSpRRTa8kCIidyIf4qVyl6dTmppoUQxZu/X/MKdDNWHd4z1X0VP7mkjwIzlra7QXzlVAUV4VsuPWYrSpmlUUB/WFhYBgyNxgBeW/NAnMwsIQlxUvoZDl4g708/Xw0T0uchl+bhU7FUQFERJRjoloMPAbTAO2+325T5xc3DQKzPneT6pChu7pR20WkIFP0MTyrCI+CZflYOWgwXA94dsZ8lgR/3CS/u1q2njvQd8mkeeMi9pYbb0jk6Fl9pd9G4/T/L+YE4LONze6U4h0JKvbbJve1U0ZdAi29812AjkmW2CSgI/94mj8A0iu3BloE4Y2wDvmhFlFxS6CDWc+h3ilFBJ9Lx6kZc+8dpZeyv7YBNj8IhSV5ew27a2xqUmix+Pcc5562X/pTKw0Y
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2020 09:09:23.1213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c219a22-eea4-4375-8ded-08d7ee788171
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAyMC80LzMwIDY6MzYgUE0sIE1hcmsgUnV0bGFuZCB3cm90ZToNCj4gT24gVHVlLCBBcHIg
MjgsIDIwMjAgYXQgMDc6MTQ6NTJBTSArMDEwMCwgSmlhbnlvbmcgV3Ugd3JvdGU6DQo+PiBPbiAy
MDIwLzQvMjQgNjozOSBQTSwgTWFyayBSdXRsYW5kIHdyb3RlOg0KPj4+IE9uIEZyaSwgQXByIDI0
LCAyMDIwIGF0IDAzOjUwOjIyQU0gKzAxMDAsIEppYW55b25nIFd1IHdyb3RlOg0KPj4+PiBPbiAy
MDIwLzQvMjEgNTo1NyBQTSwgTWFyayBSdXRsYW5kIHdyb3RlOg0KPj4+Pj4gT24gVHVlLCBBcHIg
MjEsIDIwMjAgYXQgMTE6MjM6MDBBTSArMDgwMCwgSmlhbnlvbmcgV3Ugd3JvdGU6DQo+Pj4+Pj4g
ZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9oeXBlcmNhbGxzLmMgYi92aXJ0L2t2bS9hcm0vaHlw
ZXJjYWxscy5jDQo+Pj4+Pj4gaW5kZXggNTUwZGZhM2U1M2NkLi5hNTMwOWMyOGQ0ZGMgMTAwNjQ0
DQo+Pj4+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL2h5cGVyY2FsbHMuYw0KPj4+Pj4+ICsrKyBiL3Zp
cnQva3ZtL2FybS9oeXBlcmNhbGxzLmMNCj4+Pj4+PiBAQCAtNjIsNiArNjYsNDQgQEAgaW50IGt2
bV9odmNfY2FsbF9oYW5kbGVyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4+Pj4+PiAgICAgaWYg
KGdwYSAhPSBHUEFfSU5WQUxJRCkNCj4+Pj4+PiAgICAgdmFsID0gZ3BhOw0KPj4+Pj4+ICAgICBi
cmVhazsNCj4+Pj4+PiArLyoNCj4+Pj4+PiArICogVGhpcyBzZXJ2ZXMgdmlydHVhbCBrdm1fcHRw
Lg0KPj4+Pj4+ICsgKiBGb3VyIHZhbHVlcyB3aWxsIGJlIHBhc3NlZCBiYWNrLg0KPj4+Pj4+ICsg
KiByZWcwIHN0b3JlcyBoaWdoIDMyLWJpdCBob3N0IGt0aW1lOw0KPj4+Pj4+ICsgKiByZWcxIHN0
b3JlcyBsb3cgMzItYml0IGhvc3Qga3RpbWU7DQo+Pj4+Pj4gKyAqIHJlZzIgc3RvcmVzIGhpZ2gg
MzItYml0IGRpZmZlcmVuY2Ugb2YgaG9zdCBjeWNsZXMgYW5kIGNudHZvZmY7DQo+Pj4+Pj4gKyAq
IHJlZzMgc3RvcmVzIGxvdyAzMi1iaXQgZGlmZmVyZW5jZSBvZiBob3N0IGN5Y2xlcyBhbmQgY250
dm9mZi4NCj4+Pj4+PiArICovDQo+Pj4+Pj4gK2Nhc2UgQVJNX1NNQ0NDX0hZUF9LVk1fUFRQX0ZV
TkNfSUQ6DQo+Pj4+PiBTaG91bGRuJ3QgdGhlIGhvc3Qgb3B0LWluIHRvIHByb3ZpZGluZyB0aGlz
IHRvIHRoZSBndWVzdCwgYXMgd2l0aCBvdGhlcg0KPj4+Pj4gZmVhdHVyZXM/DQo+Pj4+IGVyLCBk
byB5b3UgbWVhbiB0aGF0ICJBUk1fU01DQ0NfSFZfUFZfVElNRV9YWFgiIGFzICJvcHQtaW4iPyBp
ZiBzbywgSQ0KPj4+PiB0aGluayB0aGlzDQo+Pj4+DQo+Pj4+IGt2bV9wdHAgZG9lc24ndCBuZWVk
IGEgYnVkZHkuIHRoZSBkcml2ZXIgaW4gZ3Vlc3Qgd2lsbCBjYWxsIHRoaXMgc2VydmljZQ0KPj4+
PiBpbiBhIGRlZmluaXRlIHdheS4NCj4+PiBJIG1lYW4gdGhhdCB3aGVuIGNyZWF0aW5nIHRoZSBW
TSwgdXNlcnNwYWNlIHNob3VsZCBiZSBhYmxlIHRvIGNob29zZQ0KPj4+IHdoZXRoZXIgdGhlIFBU
UCBzZXJ2aWNlIGlzIHByb3ZpZGVkIHRvIHRoZSBndWVzdC4gVGhlIGhvc3Qgc2hvdWxkbid0DQo+
Pj4gYWx3YXlzIHByb3ZpZGUgaXQgYXMgdGhlcmUgbWF5IGJlIGNhc2VzIHdoZXJlIGRvaW5nIHNv
IGlzIHVuZGVzaXJlYWJsZS4NCj4+Pg0KPj4gSSB0aGluayBJIGhhdmUgaW1wbGVtZW50ZWQgaW4g
cGF0Y2ggOS85IHRoYXQgdXNlcnNwYWNlIGNhbiBnZXQgdGhlIGluZm8NCj4+IHRoYXQgaWYgdGhl
IGhvc3Qgb2ZmZXJzIHRoZSBrdm1fcHRwIHNlcnZpY2UuIEJ1dCBmb3Igbm93LCB0aGUgaG9zdA0K
Pj4ga2VybmVsIHdpbGwgYWx3YXlzIG9mZmVyIHRoZSBrdm1fcHRwIGNhcGFiaWxpdHkgaW4gdGhl
IGN1cnJlbnQNCj4+IGltcGxlbWVudGF0aW9uLiBJIHRoaW5rIHg4NiBmb2xsb3cgdGhlIHNhbWUg
YmVoYXZpb3IgKHNlZSBbMV0pLiBzbyBJDQo+PiBoYXZlIG5vdCBjb25zaWRlcmVkIHdoZW4gYW5k
IGhvdyB0byBkaXNhYmxlIHRoaXMga3ZtX3B0cCBzZXJ2aWNlIGluDQo+PiBob3N0LiBEbyB5b3Ug
dGhpbmsgd2Ugc2hvdWxkIG9mZmVyIHRoaXMgb3B0LWluPw0KPiANCj4gSSB0aGluayB0YWh0IHNo
b3VsZCBiZSBvcHQtaW4sIHllcy4NCg0Kb2ssIHdoYXQgYWJvdXQgYWRkaW5nICJDT05GSUdfQVJN
NjRfS1ZNX1BUUF9IT1NUIiBpbiBrdm1fcHRwIGhvc3QgDQpzZXJ2aWNlIHRvIGltcGxlbWVudCB0
aGlzICJvcHQtaW4iPw0KPiANCj4gWy4uLl0NCj4gDQo+Pj4gSXQncyBhbHNvIG5vdCBjbGVhciB0
byBtZSB3aGF0IG5vdGlvbiBvZiBob3N0IHRpbWUgaXMgYmVpbmcgZXhwb3NlZCB0bw0KPj4+IHRo
ZSBndWVzdCAoYW5kIGNvbnNlcXVlbnRseSBob3cgdGhpcyB3b3VsZCBpbnRlcmFjdCB3aXRoIHRp
bWUgY2hhbmdlcyBvbg0KPj4+IHRoZSBob3N0LCB0aW1lIG5hbWVzcGFjZXMsIGV0YykuIEhhdmlu
ZyBzb21lIGRlc2NyaXB0aW9uIG9mIHRoYXQgd291bGQNCj4+PiBiZSB2ZXJ5IGhlbHBmdWwuDQo+
Pg0KPj4gc29ycnkgdG8gaGF2ZSBub3QgbWFkZSBpdCBjbGVhci4NCj4+DQo+PiBUaW1lIHdpbGwg
bm90IGNoYW5nZSBpbiBob3N0IGFuZCBvbmx5IHRpbWUgaW4gZ3Vlc3Qgd2lsbCBjaGFuZ2UgdG8g
c3luYw0KPj4gd2l0aCBob3N0LiBob3N0IHRpbWUgaXMgdGhlIHRhcmdldCB0aGF0IHRpbWUgaW4g
Z3Vlc3Qgd2FudCB0byBhZGp1c3QgdG8uDQo+PiBndWVzdCBuZWVkIHRvIGdldCB0aGUgaG9zdCB0
aW1lIHRoZW4gY29tcHV0ZSB0aGUgZGlmZmVyZW50IG9mIHRoZSB0aW1lDQo+PiBpbiBndWVzdCBh
bmQgaG9zdCwgc28gdGhlIGd1ZXN0IGNhbiBhZGp1c3QgdGhlIHRpbWUgYmFzZSBvbiB0aGUgZGlm
ZmVyZW5jZS4NCj4gDQo+IEkgdW5kZXJzdG9vZCB0aGF0IGhvc3QgdGltZSB3b3VsZG4ndCBjaGFu
Z2UgaGVyZSwgYnV0IHdoYXQgd2FzIG5vdCBjbGVhcg0KPiBpcyB3aGljaCBub3Rpb24gb2YgaG9z
dCB0aW1lIGlzIGJlaW5nIGV4cG9zZWQgdG8gdGhlIGd1ZXN0Lg0KPiANCj4gZS5nLiBpcyB0aGF0
IGEgcmF3IG1vbm90b25pYyBjbG9jaywgb3Igb25lIHN1YmplY3QgdG8gcGVyaW9kaWMgYWRqdW1l
bnQsDQo+IG9yIHdhbGwgdGltZSBpbiB0aGUgaG9zdD8gV2hhdCBpcyB0aGUgZXBvY2ggb2YgdGhl
IGhvc3QgdGltZT8NCg0Kc29ycnksIEkgbWlzdW5kZXJzdG9vZCB5b3VyIGxhc3QgY29tbWVudC4N
CkkgdGhpbmsgaXQgaXMgb25lIG9mIHRoZSBrZXkgcGFydCBvZiBrdm1fcHRwLiBJIGhhdmUgY29u
ZnVzZWQgd2l0aCB0aGVzZSANCmNsb2NrIHRpbWUgYW5kIGV4cGVjdCB0byBoZWFyIHRoZSBjb21t
ZW50cyBmcm9tIGV4cGVydHMgb2Yga2VybmVsIHRpbWUgDQpzdWJzeXN0ZW0gbGlrZSB5b3UuDQpJ
TU8sa3ZtX3B0cCB0YXJnZXRzIHRvIHN5bmMgdGltZSBpbiBWTSB3aXRoIGhvc3QgYW5kIGlmIGFs
bCB0aGUgVk1zIGluIA0KdGhlIHNhbWUgaG9zdCBkbyBzbywgdGhleSBjYW4gZ2V0IHRpbWUgc3lu
YyBmcm9tIGVhY2ggb3RoZXIuIHdpdGggbm8gDQprdm1fcHRwLCBib3RoIGhvc3QgYW5kIGd1ZXN0
IG1heSBhZmZlY3RlZCBieSBOVFAsIHRoZSB0aW1lIHdpbGwgZGl2ZXJnZSANCmJldHdlZW4gdGhl
bS4ga3ZtX3B0cCBjYW4gYXZvaWQgdGhpcyBpc3N1ZS4gaWYgdGhlIGhvc3QgdGltZSB2YXJ5IHdp
dGggDQpzb21ldGhpbmcgbGlrZSBOVFAgYWRqdXN0bWVudCwgZ3Vlc3Qgd2lsbCB0cmFjayB0aGlz
IHZhcmlhdGlvbiB3aXRoIHRoZSANCmhlbHAgb2Yga3ZtX3B0cC4gSSBhY3F1aXJlIHRoZXNlIGtu
b3dsZWRnZSBvcmlnaW5hbGx5IGZyb20gWzJdLiBhbHNvIHB0cCANCmRyaXZlciB3aWxsIGNvbXBh
cmUgdGhlIHdhbGwgdGltZShzZWUgWzNdKS4gc28gSSB0aGluayB3YWxsIHRpbWUgY2xvY2sgDQp3
aGljaCBzdWJqZWN0IHRvIE5UUCBhZGp1c3RtZW50IGlzIGEgZ29vZCBjaG9pY2UgZm9yIGt2bV9w
dHAuIGluIHRoZSANCmN1cnJlbnQgaW1wbGVtZW50YXRpb24gSSBnZXQgdGhlIHdhbGwgdGltZSBj
bG9jayBmcm9tIGt0aW1lX2dldF9zbmFwc2hvdC4NCg0KSSdtIG5vdCBzdXJlIGlmIEkgZ2l2ZSB0
aGUgY29ycmVjdCBrbm93bGVkZ2Ugb2Yga3ZtX3B0cCBhbmQgbWFrZSBhIHJpZ2h0IA0KY2hvaWNl
IG9mIGhvc3QgY2xvY2sgdGltZS4gU28gV0RZVD8NCg0KWzJdaHR0cHM6Ly9vcGVuc291cmNlLmNv
bS9hcnRpY2xlLzE3LzYvdGltZWtlZXBpbmctbGludXgtdm1zDQpbM10gc2VlIFBUUF9TWVNfT0ZG
U0VUMiBpbiBwdHBfaW9jdGwgaW4gDQpodHRwczovL2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXgv
YmxvYi9tYXN0ZXIvZHJpdmVycy9wdHAvcHRwX2NoYXJkZXYuYywgDQppdCB1c2VzIGt0aW1lX2dl
dF9yZWFsX3RzNjQgYXMgdGhlIGhvc3QgdGltZSB0byBjYWxjdWxhdGUgdGhlIGRpZmZlcmVuY2Ug
DQpiZXR3ZWVuIHB0cCB0aW1lIGFuZCBob3N0IHRpbWUuDQoNClRoYW5rcw0KSmlhbnlvbmcNCg0K
PiANCj4+IEkgd2lsbCBhZGQgdGhlIGJhc2UgcHJpbmNpcGxlIG9mIHRpbWUgc3luYyBzZXJ2aWNl
IGluIGd1ZXN0IHVzaW5nDQo+PiBrdm1fcHRwIGluIGNvbW1pdCBtZXNzYWdlLg0KPiANCj4gVGhh
dCB3b3VsZCBiZSBncmVhdDsgdGhhbmtzIQ0KPiANCj4gTWFyay4NCj4gDQoNCg==
