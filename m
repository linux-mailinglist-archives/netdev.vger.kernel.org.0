Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A742C82BBF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731787AbfHFGiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:38:05 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:44090 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731560AbfHFGiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:38:05 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X6xN000891;
        Tue, 6 Aug 2019 02:37:55 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2052.outbound.protection.outlook.com [104.47.38.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb22x14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:37:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq3zEjmWYX0U5GyJlrDLq9FgWAfBapw2j7veVUGEXS+oygtAF/XDs367ZFVzLWmF4yzoULLWXkP8kudEsl5QTdWv6SviXmU7jk2BDBgqYt0778ZAuUMIyIUyb0PRMhpnHyKPl/p668JHV1MmJVSNWvRZLVJYHqaVjvfCP3frDoHOr5Wf9nIF8Om6T8rlcD4ypRwIaTf7FlJwXc8ONdsdj+lQaV44B9aNL60BBrtCkMirecelHEZDEbN7xwimL718hNXenvu92jPD8gMoBi1M/NZ3wwH3fb+bjdscg3BAB88ghmMoYITHRuUi0twrpsu2ccbjthlX9sKK+KkeadcQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65bwwt1ixF0MpP37ZInPrbz3Of488cjmUaQ5Qq9LAdw=;
 b=C2op/x9SB1KfFw7HmYe/XRSa2V+gUiU0PMdMkBmW2tz0X555B3nXYLtpsoXyXQ7nw9pW3bIQ0dOd0yGcOjJiJX58GhXNMD60jxQ8cqz23ix/sGfpQgvBQXOWeYoHUrx79RlDxhHPVBC7nDbIyGvoIbk/rNtImT94CtQvirJkJpfzpacb/OGsrXfQb+mv12ua0LS8iteGFAzpalOkY2GwZnXG2ol5ebHXRLLGl3Uv/KQ/Hb8bwFleq1y7KfeHuNZdN1RNUbvUVW+oLS+iXsLhMxo+Fca1Hfi8+f4uF8Ck6IKc3pvTuvbf+XvECKt8Cr0AZRw5AeVNDfmYJ8G6LUmsvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65bwwt1ixF0MpP37ZInPrbz3Of488cjmUaQ5Qq9LAdw=;
 b=b1LNPiKy/ZAxSA8TfVwd2jkRnhtRsMiROReDYbLaO96f3YoA9Fk1yARiMWvDrg6SOtVFq4c54JiaykS9ihZwYg5vXunWgmoAwzt6wYSu/rvF8TRiUXiRui2Js3NYYbh1P+hkFDgNhdZxP+wd+XCWUcFOV82mvluG/GndL4j9GIA=
Received: from DM6PR03CA0028.namprd03.prod.outlook.com (2603:10b6:5:40::41) by
 BYAPR03MB4853.namprd03.prod.outlook.com (2603:10b6:a03:138::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Tue, 6 Aug
 2019 06:37:52 +0000
Received: from SN1NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by DM6PR03CA0028.outlook.office365.com
 (2603:10b6:5:40::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16 via Frontend
 Transport; Tue, 6 Aug 2019 06:37:51 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT003.mail.protection.outlook.com (10.152.73.29) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:37:51 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x766botD008675
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:37:50 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:37:50 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH 03/16] net: phy: adin: add support for interrupts
Thread-Topic: [PATCH 03/16] net: phy: adin: add support for interrupts
Thread-Index: AQHVS5Vm+EKbbNZ5cUCCmWe/myRXVqbs3gGAgAFDGIA=
Date:   Tue, 6 Aug 2019 06:37:49 +0000
Message-ID: <505c4a1a1e7ae4c9d9f93bdc0977a7ddf111c63d.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-4-alexandru.ardelean@analog.com>
         <20190805142123.GJ24275@lunn.ch>
In-Reply-To: <20190805142123.GJ24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C7C455E1A4D5641967AAFEEF2F9E308@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(396003)(346002)(2980300002)(189003)(199004)(426003)(436003)(246002)(336012)(5640700003)(2906002)(186003)(70586007)(86362001)(36756003)(102836004)(70206006)(316002)(26005)(54906003)(47776003)(5660300002)(106002)(50466002)(2486003)(23676004)(2351001)(2501003)(7696005)(7636002)(7736002)(14444005)(6116002)(3846002)(76176011)(14454004)(1730700003)(2616005)(446003)(478600001)(11346002)(6246003)(4326008)(229853002)(356004)(305945005)(118296001)(8676002)(486006)(6916009)(476003)(126002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4853;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 913ef0d6-927f-4c3d-b250-08d71a389b07
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB4853;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4853:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4853613FC53FAD0EA55509C5F9D50@BYAPR03MB4853.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: DUrrrW1Na5wBvL+3aTgZbOrrtvd8/F5T/29qKetzE1c+iI6nETOr+DApoupnIeE2TpoySMebIZJLOKSWXTNSE6r0Y7+yd0IGSl43emS0zlrCyMBdhN+oA331DhYf3dQBeq3mWdvcl6lAr/Coiokj3DbosDyGD5dLeZqPW/7w3BCXkk0PnR1xLHP3NT/XIACbOXVp6ZfrK/Ay7aL7atZo8tlWaUnEphTUPZQNzsj5D0sP80ltGN58fFTsJhT6Tk8R8KKZrtaQlk+ZJbKwpY8ivwHwz12yMdmP0Ifx3/EDGVyHqqeMpbNx1YAD6tok3xpTc9rLNxx7Cmiu/amPt5mTWHdGVI9PzarEwoiBHjp8j62hc4LYW/W2bdEUHo2wrpespzAYhpPdBQrPJsJhbD8sGuRQ9hsGNHLNPogFVdi2A5A=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:37:51.3524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 913ef0d6-927f-4c3d-b250-08d71a389b07
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4853
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjIxICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NDBQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoaXMgY2hhbmdlIGFkZHMgc3VwcG9y
dCBmb3IgZW5hYmxpbmcgUEhZIGludGVycnVwdHMgdGhhdCBjYW4gYmUgdXNlZCBieQ0KPiA+IHRo
ZSBQSFkgZnJhbWV3b3JrIHRvIGdldCBzaWduYWwgZm9yIGxpbmsvc3BlZWQvYXV0by1uZWdvdGlh
dGlvbiBjaGFuZ2VzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVh
biA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L3BoeS9hZGluLmMgfCA0NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2FkaW4uYyBiL2RyaXZlcnMvbmV0L3BoeS9hZGlu
LmMNCj4gPiBpbmRleCBjMTAwYTBkZDk1Y2QuLmI3NWM3MjNiZGE3OSAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC9waHkvYWRpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L2FkaW4u
Yw0KPiA+IEBAIC0xNCw2ICsxNCwyMiBAQA0KPiA+ICAjZGVmaW5lIFBIWV9JRF9BRElOMTIwMAkJ
CQkweDAyODNiYzIwDQo+ID4gICNkZWZpbmUgUEhZX0lEX0FESU4xMzAwCQkJCTB4MDI4M2JjMzAN
Cj4gPiAgDQo+ID4gKyNkZWZpbmUgQURJTjEzMDBfSU5UX01BU0tfUkVHCQkJMHgwMDE4DQo+ID4g
KyNkZWZpbmUgICBBRElOMTMwMF9JTlRfTURJT19TWU5DX0VOCQlCSVQoOSkNCj4gPiArI2RlZmlu
ZSAgIEFESU4xMzAwX0lOVF9BTkVHX1NUQVRfQ0hOR19FTglCSVQoOCkNCj4gPiArI2RlZmluZSAg
IEFESU4xMzAwX0lOVF9BTkVHX1BBR0VfUlhfRU4JCUJJVCg2KQ0KPiA+ICsjZGVmaW5lICAgQURJ
TjEzMDBfSU5UX0lETEVfRVJSX0NOVF9FTgkJQklUKDUpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMw
MF9JTlRfTUFDX0ZJRk9fT1VfRU4JCUJJVCg0KQ0KPiA+ICsjZGVmaW5lICAgQURJTjEzMDBfSU5U
X1JYX1NUQVRfQ0hOR19FTgkJQklUKDMpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMwMF9JTlRfTElO
S19TVEFUX0NITkdfRU4JQklUKDIpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMwMF9JTlRfU1BFRURf
Q0hOR19FTgkJQklUKDEpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMwMF9JTlRfSFdfSVJRX0VOCQlC
SVQoMCkNCj4gPiArI2RlZmluZSBBRElOMTMwMF9JTlRfTUFTS19FTglcDQo+ID4gKwkoQURJTjEz
MDBfSU5UX0FORUdfU1RBVF9DSE5HX0VOIHwgQURJTjEzMDBfSU5UX0FORUdfUEFHRV9SWF9FTiB8
IFwNCj4gPiArCSBBRElOMTMwMF9JTlRfTElOS19TVEFUX0NITkdfRU4gfCBBRElOMTMwMF9JTlRf
U1BFRURfQ0hOR19FTiB8IFwNCj4gPiArCSBBRElOMTMwMF9JTlRfSFdfSVJRX0VOKQ0KPiA+ICsj
ZGVmaW5lIEFESU4xMzAwX0lOVF9TVEFUVVNfUkVHCQkJMHgwMDE5DQo+ID4gKw0KPiA+ICBzdGF0
aWMgaW50IGFkaW5fY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiAg
ew0KPiA+ICAJaW50IHJjOw0KPiA+IEBAIC0yNSwxNSArNDEsNDAgQEAgc3RhdGljIGludCBhZGlu
X2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gIAlyZXR1cm4gMDsN
Cj4gPiAgfQ0KPiA+ICANCj4gPiArc3RhdGljIGludCBhZGluX3BoeV9hY2tfaW50cihzdHJ1Y3Qg
cGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiAr
CS8qIENsZWFyIHBlbmRpbmcgaW50ZXJydXB0cy4gICovDQo+ID4gKwlyZXQgPSBwaHlfcmVhZChw
aHlkZXYsIEFESU4xMzAwX0lOVF9TVEFUVVNfUkVHKTsNCj4gPiArCWlmIChyZXQgPCAwKQ0KPiA+
ICsJCXJldHVybiByZXQ7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+IA0KPiBQbGVhc2UgZ28g
dGhyb3VnaCB0aGUgd2hvbGUgZHJpdmVyIGFuZCB0aHJvdyBvdXQgYWxsIHRoZSBuZWVkbGVzcw0K
DQphY2s7DQppJ2xsIHJlLXZpc2l0Ow0KDQo+IA0KPiAJaWYgKHJldCA8IDApDQo+IAkJcmV0dXJu
IHJldDsNCj4gDQo+IAlyZXR1cm4gMDsNCj4gDQo+IFRoYW5rcw0KPiAJQW5kcmV3DQo=
