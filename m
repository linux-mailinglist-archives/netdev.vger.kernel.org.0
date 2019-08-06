Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1EA82C19
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbfHFGxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:53:38 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:62922 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731557AbfHFGxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:53:38 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766loeq009297;
        Tue, 6 Aug 2019 02:53:30 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2056.outbound.protection.outlook.com [104.47.36.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u5448ukk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:53:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkLSZRfMhZST0C7FUIzEFhFIna8p6n152/dOhKgCb+1DeM2cLaiQKC54Ve7PHqqNHZoTOQiNMt4dPHzujC2G3u7pRf5CrQGK/jqZvO4VX0M/myumIUvNsJYarVY4Ve0WsGTxF68qcUAsDTjTE7FGChW5iO7r3wLgI5QfgcASZrYuO/+Ms3Okh096dJLM6jR2cyIUDufyTl5gy1Zl/GHS64blUKebSItDx9r7Beoiqt3umYeY8MCNrcfvZqSySG1iVzS369pFGRmR7rO6WMNbZpIzFm5hQHeNn7nqKBrC6f2ehChO47EMqoAx8Dpc3VTPJplG5e27d9yyjvBo5K0cTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osV04teBO6DZLCj7BVjGdaIiaTnfkUgbwZgUaHvTmZA=;
 b=ECTIc8OHBBCTntk6qjSI413AQLA6Z9o3gkNael9LCaG4ncYNKloxSufFDf6QnRy76x2UYrQSYWY5QYdH4nIWO/GCdHg28CcP6eHigLmwCA8oXiA2ucE/T1knl7F0R5XC+M2ZE+dsci+We2Eu4lyKMV+EmjEsCbIYYLX/OrN1S5RSxmEqOmaWtSQ7/SF4eOytidxkgw8th2dbKWf2gAULMtXE15ifQr2qmbHF4v/ip7IqSkUiYssIMBHY0K29wdbDaYqzCk/oEn7dAs1w88j9j+Sr+nFa5G+PTkBaAhEPPVWYWPZlGi1p0cOkuPu6IPbyBV7fUFLnmPE+fDeDzCAcMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osV04teBO6DZLCj7BVjGdaIiaTnfkUgbwZgUaHvTmZA=;
 b=cQTyTeX18o8+38Urhuxpdjxxw2KetqjpfiRjVjsUghB0loFtzlHDgJ45buXTefkccOeS5lnWn24hoUp/M+ZDGlE8aYO/ZJ6Pgc5pZVn4/yz81QXjSDy21c+BsdZkw0c5xOTI/ujKCZt61spdP76gDpo70m9n9lDetnT9QDhUFKE=
Received: from BY5PR03CA0018.namprd03.prod.outlook.com (2603:10b6:a03:1e0::28)
 by BN6PR03MB3347.namprd03.prod.outlook.com (2603:10b6:405:3d::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16; Tue, 6 Aug
 2019 06:53:28 +0000
Received: from SN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by BY5PR03CA0018.outlook.office365.com
 (2603:10b6:a03:1e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.15 via Frontend
 Transport; Tue, 6 Aug 2019 06:53:28 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT036.mail.protection.outlook.com (10.152.72.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:53:25 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766rMSj015482
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:53:22 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:53:25 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is
 enabled
Thread-Topic: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is
 enabled
Thread-Index: AQHVS5V0IlrGd78N3UWpB4qyPDrHy6bt4j0AgABDNgA=
Date:   Tue, 6 Aug 2019 06:53:24 +0000
Message-ID: <5d3486c5575724f4d12bc58c9374fa95cb59ea3e.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-15-alexandru.ardelean@analog.com>
         <baac3842-bd9c-75af-83e3-9e89def1c429@gmail.com>
In-Reply-To: <baac3842-bd9c-75af-83e3-9e89def1c429@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B26F9490A75D441ABA7BA96E25662D1@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(136003)(39860400002)(2980300002)(189003)(199004)(476003)(5660300002)(23676004)(2486003)(7696005)(76176011)(446003)(106002)(486006)(53546011)(426003)(102836004)(436003)(47776003)(6116002)(186003)(3846002)(2501003)(305945005)(229853002)(110136005)(336012)(6246003)(2906002)(478600001)(126002)(70206006)(7736002)(70586007)(7636002)(246002)(14454004)(36756003)(50466002)(118296001)(8676002)(8936002)(2616005)(4326008)(316002)(11346002)(54906003)(2201001)(356004)(26005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB3347;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5caf9571-da7f-4b92-8f70-08d71a3ac813
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN6PR03MB3347;
X-MS-TrafficTypeDiagnostic: BN6PR03MB3347:
X-Microsoft-Antispam-PRVS: <BN6PR03MB3347F94587540D306033938BF9D50@BN6PR03MB3347.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: tLHMzKU2rFjwJ8oBYxEiXXfGFlSSnitImAyqXlLhj7q6rkcNhiH++pdXFVgdoqzWIOxy87a6YoXpTg3ztvlVvnrIcdu+YO5zmtsEtvb3hGU8uo/NkCzx8JL6jpq6PgzRXj0+XbfoOtGq+3siiOJCil6YXt8AA40di+dYU0zb8zbzLkf5d28FowqpF1vzoC97C1TNwMIgjBn11dUJedNj1ekM10MzWBhU/dHjPoDPMmJ85uFImPluRI6zyI2Yj78tYwGxoUaQ43Vd/na6KwN1zF+Uisz43A1wBIO9UPdeFtZ7wbAqwdA3bJvHS9M2jzgnfQqodFYWZ1axuxFLoAIgxZ3NXKrMEFpXoCq+/RHazuqrnqAMW9OjUyouKKim8bqeDth1Mu9/SaoL2UIVZS6t0k57+Q6tidKRY/qUZOoo2qs=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:53:25.9181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5caf9571-da7f-4b92-8f70-08d71a3ac813
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3347
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDA3OjUyICswMjAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IFtFeHRlcm5hbF0NCj4gDQo+IE9uIDA1LjA4LjIwMTkgMTg6NTQsIEFsZXhhbmRydSBBcmRl
bGVhbiB3cm90ZToNCj4gPiBEb3duLXNwZWVkIGF1dG8tbmVnb3RpYXRpb24gbWF5IG5vdCBhbHdh
eXMgYmUgZW5hYmxlZCwgaW4gd2hpY2ggY2FzZSB0aGUNCj4gPiBQSFkgd29uJ3QgZG93bi1zaGlm
dCB0byAxMDAgb3IgMTAgZHVyaW5nIGF1dG8tbmVnb3RpYXRpb24uDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogQWxleGFuZHJ1IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvcGh5L2FkaW4uYyB8IDI3ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKQ0K
PiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvYWRpbi5jIGIvZHJpdmVycy9u
ZXQvcGh5L2FkaW4uYw0KPiA+IGluZGV4IDg2ODQ4NDQ0YmQ5OC4uYTFmMzQ1NmE4NTA0IDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9waHkvYWRpbi5jDQo+ID4gQEAgLTMyLDYgKzMyLDEzIEBADQo+ID4gICNkZWZpbmUgICBBRElO
MTMwMF9OUkdfUERfVFhfRU4JCQlCSVQoMikNCj4gPiAgI2RlZmluZSAgIEFESU4xMzAwX05SR19Q
RF9TVEFUVVMJCUJJVCgxKQ0KPiA+ICANCj4gPiArI2RlZmluZSBBRElOMTMwMF9QSFlfQ1RSTDIJ
CQkweDAwMTYNCj4gPiArI2RlZmluZSAgIEFESU4xMzAwX0RPV05TUEVFRF9BTl8xMDBfRU4JCUJJ
VCgxMSkNCj4gPiArI2RlZmluZSAgIEFESU4xMzAwX0RPV05TUEVFRF9BTl8xMF9FTgkJQklUKDEw
KQ0KPiA+ICsjZGVmaW5lICAgQURJTjEzMDBfR1JPVVBfTURJT19FTgkJQklUKDYpDQo+ID4gKyNk
ZWZpbmUgICBBRElOMTMwMF9ET1dOU1BFRURTX0VOCVwNCj4gPiArCShBRElOMTMwMF9ET1dOU1BF
RURfQU5fMTAwX0VOIHwgQURJTjEzMDBfRE9XTlNQRUVEX0FOXzEwX0VOKQ0KPiA+ICsNCj4gPiAg
I2RlZmluZSBBRElOMTMwMF9JTlRfTUFTS19SRUcJCQkweDAwMTgNCj4gPiAgI2RlZmluZSAgIEFE
SU4xMzAwX0lOVF9NRElPX1NZTkNfRU4JCUJJVCg5KQ0KPiA+ICAjZGVmaW5lICAgQURJTjEzMDBf
SU5UX0FORUdfU1RBVF9DSE5HX0VOCUJJVCg4KQ0KPiA+IEBAIC00MjUsNiArNDMyLDIyIEBAIHN0
YXRpYyBpbnQgYWRpbl9jb25maWdfbWRpeChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+
ICAJcmV0dXJuIHBoeV93cml0ZShwaHlkZXYsIEFESU4xMzAwX1BIWV9DVFJMMSwgcmVnKTsNCj4g
PiAgfQ0KPiA+ICANCj4gPiArc3RhdGljIGludCBhZGluX2NvbmZpZ19kb3duc3BlZWRzKHN0cnVj
dCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gK3sNCj4gPiArCWludCByZWc7DQo+ID4gKw0KPiA+
ICsJcmVnID0gcGh5X3JlYWQocGh5ZGV2LCBBRElOMTMwMF9QSFlfQ1RSTDIpOw0KPiA+ICsJaWYg
KHJlZyA8IDApDQo+ID4gKwkJcmV0dXJuIHJlZzsNCj4gPiArDQo+ID4gKwlpZiAoKHJlZyAmIEFE
SU4xMzAwX0RPV05TUEVFRFNfRU4pID09IEFESU4xMzAwX0RPV05TUEVFRFNfRU4pDQo+ID4gKwkJ
cmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJcmVnIHw9IEFESU4xMzAwX0RPV05TUEVFRFNfRU47DQo+
ID4gKw0KPiA+ICsJcmV0dXJuIHBoeV93cml0ZShwaHlkZXYsIEFESU4xMzAwX1BIWV9DVFJMMiwg
cmVnKTsNCj4gDQo+IFVzaW5nIHBoeV9zZXRfYml0cygpIHdvdWxkIGJlIGVhc2llci4NCg0KYWNr
Ow0KbWlzc2VkIHRoaXM7DQoNCnRoYW5rcw0KDQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0
aWMgaW50IGFkaW5fY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiAg
ew0KPiA+ICAJaW50IHJldDsNCj4gPiBAQCAtNDMzLDYgKzQ1NiwxMCBAQCBzdGF0aWMgaW50IGFk
aW5fY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiAgCWlmIChyZXQp
DQo+ID4gIAkJcmV0dXJuIHJldDsNCj4gPiAgDQo+ID4gKwlyZXQgPSBhZGluX2NvbmZpZ19kb3du
c3BlZWRzKHBoeWRldik7DQo+ID4gKwlpZiAocmV0IDwgMCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0K
PiA+ICsNCj4gPiAgCXJldHVybiBnZW5waHlfY29uZmlnX2FuZWcocGh5ZGV2KTsNCj4gPiAgfQ0K
PiA+ICANCj4gPiANCg==
