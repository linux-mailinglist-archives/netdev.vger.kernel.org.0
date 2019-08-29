Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E33A153B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfH2J5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:57:16 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:22741
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfH2J5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xc4ZrCyW811FkZIFqCZo5i24YA7IDeDdshyVXBwRmDQ=;
 b=yn1eR9tgiRS6eW+zc70m2uJwS9AliK2DoAsYlq5Lwt9b19ZuUqEb85ffuwXv5nnlm9tKiSx4RIgxxf8m4PduRobwpr7wH8u8K+hzAwoGDmkNopF+ByKia5s6EWlVniWWcjRXcHQOnDetY0Gv6gDzU1nqf6zvMZ+4Uii9Awxq5To=
Received: from VI1PR08CA0114.eurprd08.prod.outlook.com (2603:10a6:800:d4::16)
 by VE1PR08MB4959.eurprd08.prod.outlook.com (2603:10a6:803:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.18; Thu, 29 Aug
 2019 09:57:07 +0000
Received: from VE1EUR03FT012.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::200) by VI1PR08CA0114.outlook.office365.com
 (2603:10a6:800:d4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2220.18 via Frontend
 Transport; Thu, 29 Aug 2019 09:57:07 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT012.mail.protection.outlook.com (10.152.18.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2220.16 via Frontend Transport; Thu, 29 Aug 2019 09:57:06 +0000
Received: ("Tessian outbound eec90fc31dfb:v27"); Thu, 29 Aug 2019 09:57:01 +0000
X-CR-MTA-TID: 64aa7808
Received: from bb9bad6f9577.1 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.8.54])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 937A1F46-B9E9-41D4-B2D3-745714CF4007.1;
        Thu, 29 Aug 2019 09:56:56 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-am5eur03lp2054.outbound.protection.outlook.com [104.47.8.54])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id bb9bad6f9577.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Thu, 29 Aug 2019 09:56:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSdhCj8HPGvoyC+R/jDMbrSoY6LzLlRCSBSvqX+GCrtcRllFzNPjuBxKjE11k5DDbc21GsMV/TJ3a/0t5FLS2SOakXoIRl/ueZZU/UgoDZ4+AhwuIalr36ZqVp6lFkYSWMGNkc8tXstOj3S8ukB/7i5ThV8gJiDqniBGynOeQtIEFqsCN5QLYLef1NRYrIIU8+hpkrMABWZszkjN1Qwcz4XsGfoe6o4V78fgnUS/V43R1ifSqVenbUsKTiVVRUROy86BrSsnieFKmOf3eZHApr2ZWMKKCtkmeLNsnrDNs83O5+/UFby6Qc5f/PCqmmlU0cRbIn7J5JY3rBbOaWi1rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YdhQzkNVqtoK4H50JF6leVctLJTxjjkzRs6zj7mQGU=;
 b=J3eQo65QHNOa7y5055XafhxZSr2vjbRtwLRh6byl1uXX4HBPdfPwHRt279mhAOGOZ6ThKLn8PhZ/3FJw9b/D2vEKw0nWG+HQr42cQC4LW2KFjlYFiN6NdOYKZR8Cw8fuYE2KuLHIPZQmXCtHcMN7sQKVPeik/7jpmBV1AUfnnQc+zVE3IR8kUB9c6eP1xC7YvvBK3Dx8hdOmOYbT2WW3Z8sXtyFQl2oaBiT3sljfLIsFN0gzwjHxSkr+EGOIZJPKyP+aG5s8FPnhVtL4IwlAtA6JBJl6dMqVc+zYBrDtTTkujF619T9Lh2ubX8kHradyLQZvCK6N6DAp5iGMeHUbuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YdhQzkNVqtoK4H50JF6leVctLJTxjjkzRs6zj7mQGU=;
 b=y9ARkafuA5inJGaG9DVK9i2660/qNxZbzplYxmJwSIpFLmLvd/EvQZEQwpYiF/UZU+GQ2CSmRvhO4EY67j8oDJNZyGcOHRrM2YpK4ZrfuRjOyGn5ZPvq3nkKBMmnpzvDqykv81axc7U0uoQ2PzLcxoqVqg5D9GEqqsOEWSAMf/o=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 09:56:52 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b4eb:389:7890:7be0]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b4eb:389:7890:7be0%11]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 09:56:52 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>
Subject: RE: [RFC PATCH 2/3] reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [RFC PATCH 2/3] reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVXjSk0dP/sLV4K0SdGkHEsCCQGqcR1m8AgAALS8A=
Date:   Thu, 29 Aug 2019 09:56:52 +0000
Message-ID: <HE1PR0801MB167689109E12FA0C013257FFF4A20@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190829063952.18470-1-jianyong.wu@arm.com>
 <20190829063952.18470-3-jianyong.wu@arm.com>
 <4c6038f5-1da4-0b43-d8b7-541379321bf1@kernel.org>
In-Reply-To: <4c6038f5-1da4-0b43-d8b7-541379321bf1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d5ef293e-2aba-4f5e-8458-1529d541603f.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: f9cc3bc1-7ecf-4f3b-ca86-08d72c67401b
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB1676;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1676:|VE1PR08MB4959:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB4959933A52785E4F6C555399F4A20@VE1PR08MB4959.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:483;OLM:483;
x-forefront-prvs: 0144B30E41
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(13464003)(199004)(189003)(81156014)(14454004)(6436002)(55236004)(53936002)(102836004)(33656002)(81166006)(6506007)(53546011)(6116002)(55016002)(2501003)(6246003)(476003)(76116006)(186003)(52536014)(3846002)(446003)(9686003)(26005)(8936002)(8676002)(5660300002)(478600001)(486006)(6636002)(316002)(66066001)(66446008)(64756008)(66556008)(66476007)(2906002)(74316002)(54906003)(110136005)(66946007)(11346002)(7696005)(2201001)(4326008)(71200400001)(229853002)(25786009)(71190400001)(86362001)(305945005)(76176011)(256004)(7736002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1676;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: Ug4NDpwAzN2SRmEScnBQNbt2j5YYSRKt+xZJ2ljjIUz2X4B7k/ZQLzGOXjjhcS1Aq1eqr8BRmkHwYusNbZbJzlPXvrb6dkHCn0FMVOwWKpthq9RrOT9AvPTUZ2Y9Uz+dUxqyqqaIfhSv9rS+xHD460+2vX7GRkth3HdR0d8Qr3sw4RB8iPtnabBAMg6vImcvBd0XrpdpllqH1UIl2T46nbN/CJ+frdqEyUs4AJhKgaueo0/6m9TvzU+UDuy9Nr31ui8z7Bse+DYN/O9ITIlejBCqU9oDh7NPRm3D+5m+0Izvw9fInSkS1bC2KgWH4dFVovPvcTkZVP7C0QCfylZgij1G1f7PhqbfDhL7/6lcw9acWdCY23bw5HXOiJLAYwOZJ2dUdetBOb2icOs6Ks+hPtpPbhVUuxi4SXbsvnFJ4yI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1676
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT012.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(2980300002)(13464003)(40434004)(189003)(199004)(70586007)(47776003)(70206006)(22756006)(2501003)(26826003)(14454004)(2201001)(8936002)(86362001)(66066001)(81166006)(81156014)(33656002)(356004)(9686003)(55016002)(126002)(486006)(476003)(7696005)(5660300002)(110136005)(6116002)(54906003)(6246003)(14444005)(102836004)(99286004)(50466002)(52536014)(2906002)(76130400001)(478600001)(2486003)(8676002)(23676004)(6506007)(53546011)(63370400001)(446003)(11346002)(63350400001)(436003)(26005)(76176011)(336012)(186003)(450100002)(305945005)(5024004)(74316002)(4326008)(229853002)(6636002)(3846002)(36906005)(7736002)(25786009)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR08MB4959;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: bddd3b5f-694c-42e2-07e0-08d72c6737fe
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VE1PR08MB4959;
X-Forefront-PRVS: 0144B30E41
X-Microsoft-Antispam-Message-Info: wgwi7cBKsyFrCmMw3ib5n/C7ec1juOYotFCBkuQ2HHhQAUGZRTb1p69+wXSo0Z9iXNUv6emmE+QUxlu7ddLfQLlmwvuvmQcrFzeM66IuYyDI1dQG1Ken24f8Jgc+d3aHv2Zi+pX4Qv2xHjSPdnRmFj+L3FV8CUQlYXEVFx3BkVYxMFTCuditelPbWEog1jOPo9Cvp+HOa6Ky+YDpm9dtN/1UwtUl3vKI1RMZ4pcPAO8WPct27zfETMhJ7SQ3sMpPK6+M5LAJbD5wAqThDx3aoo1531edLcGU8nJmZWVVsMENbBi91ARPq82vJkGeuy40G6AMjJ0WMDzrjrKHVTuIqXbBbBKhW1Zh9uXwVJfC/BqVY1Husuj9EhfY0PckIgky7fwUMgpseWl396eIwIpBvNVut05YW7iDecbAV4Q9ut8=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2019 09:57:06.3169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cc3bc1-7ecf-4f3b-ca86-08d72c67401b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4959
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI5LCAyMDE5
IDU6MDkgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9neSBDaGluYSkgPEppYW55
b25nLld1QGFybS5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBwYm9uemluaUByZWRo
YXQuY29tOw0KPiBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tOyByaWNoYXJkY29jaHJh
bkBnbWFpbC5jb207IE1hcmsgUnV0bGFuZA0KPiA8TWFyay5SdXRsYW5kQGFybS5jb20+OyBXaWxs
IERlYWNvbiA8V2lsbC5EZWFjb25AYXJtLmNvbT47IFN1enVraQ0KPiBQb3Vsb3NlIDxTdXp1a2ku
UG91bG9zZUBhcm0uY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU3Rl
dmUgQ2FwcGVyIDxTdGV2ZS5DYXBwZXJAYXJtLmNvbT47DQo+IEthbHkgWGluIChBcm0gVGVjaG5v
bG9neSBDaGluYSkgPEthbHkuWGluQGFybS5jb20+OyBKdXN0aW4gSGUgKEFybQ0KPiBUZWNobm9s
b2d5IENoaW5hKSA8SnVzdGluLkhlQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENI
IDIvM10gcmVvcmdhbml6ZSBwdHBfa3ZtIG1vZHVsZXMgdG8gbWFrZSBpdCBhcmNoLQ0KPiBpbmRl
cGVuZGVudC4NCj4NCi4uLi4uLi4uLg0KDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9h
cmNoX3B0cF9rdm0uYw0KPiBiL2FyY2gveDg2L2t2bS9hcmNoX3B0cF9rdm0uYw0KPiA+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0IGluZGV4IDAwMDAwMDAwMDAwMC4uNTZlYTg0YTg2ZGEyDQo+ID4gLS0t
IC9kZXYvbnVsbA0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS9hcmNoX3B0cF9rdm0uYw0KPiA+IEBA
IC0wLDAgKzEsOTIgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAt
b25seQ0KPiA+ICsvKg0KPiA+ICsgKiAgVmlydHVhbCBQVFAgMTU4OCBjbG9jayBmb3IgdXNlIHdp
dGggS1ZNIGd1ZXN0cw0KPiA+ICsgKg0KPiA+ICsgKiAgQ29weXJpZ2h0IChDKSAyMDE5IEFSTSBM
dGQuDQo+ID4gKyAqICBBbGwgUmlnaHRzIFJlc2VydmVkDQo+DQo+IE5vLiBUaGlzIGlzbid0IEFS
TSdzIGNvZGUsIG5vdCBieSBhIG1pbGxpb24gbWlsZS4gWW91J3ZlIHNpbXBseSByZWZhY3RvcmVk
DQo+IGV4aXN0aW5nIGNvZGUuIFBsZWFzZSBrZWVwIHRoZSBjb3JyZWN0IGF0dHJpYnV0aW9uIChp
LmUuIHRoYXQgb2YgdGhlIG9yaWdpbmFsDQo+IGNvZGUpLg0KPg0KT2ssIEkgd2lsbCBmaXggaXQu
DQoNCi4uLi4uLi4NCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1nZW5lcmljL3B0
cF9rdm0uaA0KPiA+IGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9wdHBfa3ZtLmggbmV3IGZpbGUgbW9k
ZSAxMDA2NDQgaW5kZXgNCj4gPiAwMDAwMDAwMDAwMDAuLjEyOGE5ZDdhZjE2MQ0KPiA+IC0tLSAv
ZGV2L251bGwNCj4gPiArKysgYi9pbmNsdWRlL2FzbS1nZW5lcmljL3B0cF9rdm0uaA0KPiA+IEBA
IC0wLDAgKzEsMTIgQEANCj4gPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAt
b25seSAqLw0KPiA+ICsvKg0KPiA+ICsgKiAgVmlydHVhbCBQVFAgMTU4OCBjbG9jayBmb3IgdXNl
IHdpdGggS1ZNIGd1ZXN0cw0KPiA+ICsgKg0KPiA+ICsgKiAgQ29weXJpZ2h0IChDKSAyMDE5IEFS
TSBMdGQuDQo+ID4gKyAqICBBbGwgUmlnaHRzIFJlc2VydmVkDQo+DQo+IFNhbWUgaGVyZS4NCj4N
Ck9rLg0KDQpUaGFua3MNCkppYW55b25nIFd1DQoNCj4gPiArICovDQo+ID4gKw0KPiA+ICtzdGF0
aWMgaW50IGt2bV9hcmNoX3B0cF9pbml0KHZvaWQpOw0KPiA+ICtzdGF0aWMgaW50IGt2bV9hcmNo
X3B0cF9nZXRfY2xvY2soc3RydWN0IHRpbWVzcGVjNjQgKnRzKTsgc3RhdGljIGludA0KPiA+ICtr
dm1fYXJjaF9wdHBfZ2V0X2Nsb2NrX2ZuKGxvbmcgKmN5Y2xlLA0KPiA+ICsgICAgICAgICAgIHN0
cnVjdCB0aW1lc3BlYzY0ICp0c3BlYywgdm9pZCAqY3MpOw0KPiA+DQo+DQo+ICAgICAgIE0uDQo+
IC0tDQo+IEphenogaXMgbm90IGRlYWQsIGl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uDQpJTVBPUlRB
TlQgTk9USUNFOiBUaGUgY29udGVudHMgb2YgdGhpcyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRz
IGFyZSBjb25maWRlbnRpYWwgYW5kIG1heSBhbHNvIGJlIHByaXZpbGVnZWQuIElmIHlvdSBhcmUg
bm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1l
ZGlhdGVseSBhbmQgZG8gbm90IGRpc2Nsb3NlIHRoZSBjb250ZW50cyB0byBhbnkgb3RoZXIgcGVy
c29uLCB1c2UgaXQgZm9yIGFueSBwdXJwb3NlLCBvciBzdG9yZSBvciBjb3B5IHRoZSBpbmZvcm1h
dGlvbiBpbiBhbnkgbWVkaXVtLiBUaGFuayB5b3UuDQo=
