Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B4B8AEF1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 07:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfHMFtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 01:49:09 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:28424 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfHMFtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 01:49:09 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7D5m2KZ017454;
        Tue, 13 Aug 2019 01:49:00 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2051.outbound.protection.outlook.com [104.47.37.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9qpayhcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 01:49:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Twz9NsTRKnzJdLpY3liuTm7o26D9u711Wj28z5b4HwfGcFhsclSl9l57onIsrvaUtGCARph9FWKG3eO/khV31L3nY8scYwEGePMgpDYns3BzVShHLIQjVxEtBzigCzjA6Gxbc2HAtb231450QwhIbFnRDX89JbCyxQp33IvjF8ZeTNOGJ7sGZh64AwiSuOkvTjxCK3NZFbdy/2d1L4dEK68j5AaK+VyjroegcGusV3LIJ1wcfRHU3JJzMxicRNzWnBiFVWrw+QbE8ffIrUMAr7/X95JMIubRVmYthPTNvol9d7O1x0qGhoosZYMUya3u98EfwUJAfFMU+W4uXvQ53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRWgDAP4BUMw+tpX2aKB6ZhW7vBhe7ZxunVCZ/HeSIg=;
 b=ZBR9XW+WPZUi0HrdePOS3IJ1XS8R1dx6TcznELUzju6SlxcXWxXR+P5vOiTKofzE8+av6o0VoSMj76zYWkBxu5T4Jzz4EABIjdlZoFpQzamzbAdmU1PzFkQOdXVl0auZ0iJzIUwqiMNhNQCz9Q1CESfDjVnmg0BXvz/WAcr639uD5u+nG19kjPUGm6jkcJAygz9eUGL0f/FeA8wTepTZj0LkfSaaWv3ryVQVBCvq57zuDk0fuilmgFzVeQnn3uzq0JX1pySSwP8ERhNNIVf6T02GZiroGKE6vmO/fETUvZuC4Jdrh9/arAhA+WhYmUDU7qXE0i3m/ZfUVmCgjE3Gjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRWgDAP4BUMw+tpX2aKB6ZhW7vBhe7ZxunVCZ/HeSIg=;
 b=1Px8vKzH2SQaR3aiq4r1uMVvdYRQAg+L44gwB3AgkiT3tPEE7qrvIFEVmFN4l1XT6EepfyjNr1jHiQ7j+PPayHvx6c6+M27NztljvnwCFqXfR4uZ/KHWcbJELtl8fk4LW3QlN/qZKIXfQTeoybG/7lnxRt7e1+yZ20NcQpzM7oI=
Received: from MWHPR03CA0019.namprd03.prod.outlook.com (2603:10b6:300:117::29)
 by BN6PR03MB2563.namprd03.prod.outlook.com (2603:10b6:404:5a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Tue, 13 Aug
 2019 05:48:56 +0000
Received: from SN1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by MWHPR03CA0019.outlook.office365.com
 (2603:10b6:300:117::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Tue, 13 Aug 2019 05:48:56 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT046.mail.protection.outlook.com (10.152.72.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Tue, 13 Aug 2019 05:48:55 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x7D5mpWc022279
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 22:48:51 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 13 Aug 2019 01:48:54 -0400
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
Subject: Re: [PATCH v4 13/14] net: phy: adin: add ethtool get_stats support
Thread-Topic: [PATCH v4 13/14] net: phy: adin: add ethtool get_stats support
Thread-Index: AQHVUQB9ToIHSOhtHEuH64MPKOTzBKb31s2AgAD/0AA=
Date:   Tue, 13 Aug 2019 05:48:53 +0000
Message-ID: <c3fdb21c40900dae0e52b02b98fe27924a76c256.camel@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
         <20190812112350.15242-14-alexandru.ardelean@analog.com>
         <20190812143315.GS14290@lunn.ch>
In-Reply-To: <20190812143315.GS14290@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <62EC167CBC703842B2016E467A3C42D8@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(346002)(39860400002)(2980300002)(199004)(189003)(54534003)(6246003)(426003)(436003)(86362001)(50466002)(47776003)(478600001)(476003)(8936002)(36756003)(446003)(26005)(4326008)(6116002)(2906002)(1730700003)(8676002)(336012)(76176011)(246002)(186003)(3846002)(2616005)(102836004)(126002)(7696005)(486006)(118296001)(11346002)(305945005)(2351001)(7636002)(7736002)(2501003)(23676004)(70206006)(5640700003)(14454004)(2486003)(106002)(356004)(70586007)(54906003)(6916009)(229853002)(5660300002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2563;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32760237-f47b-4969-0544-08d71fb1ee0a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN6PR03MB2563;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2563:
X-Microsoft-Antispam-PRVS: <BN6PR03MB2563E9E9A91B651B2F5BDE83F9D20@BN6PR03MB2563.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01283822F8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: W/scqU66dhwqBQsrk4/rmExodkVXZ9RPHi9aEas3dfOmWkf12Wz9ao+lslHmly2NfuuQbkv6zzpEnmPbAGH5x9RqMHrPJXFtKk+N7HczRznb4KTzylfX2/HUOTSkx2Zsqcq0vPHg0wadz8rg4sECzQGr5RlM2ZDaqWy9Q3+3MEx99QlGist2mY8FIMBdYG9f/zTW+JK5l9Il9kzBsoxSfzQlJ2Ni4AqU2scI/8EGf1kRdpKMz33GG0nsdo2ajrAjCldcOlcfo0pNlJQCKSwI9x+82IwMdI+afFZTiuvk+ofBPcvTIY3JdJLtPG1OtumaSwmof40BvRC5ocuQQF5vBZndh0ykYXVTRcKZb/gOoiDXWEXHjA5a2CzPP6FAzLh1Wbwv5Cy06cvWeJ3GkBG31HPXmyPDQhRuRoljyFaU9vY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2019 05:48:55.4927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32760237-f47b-4969-0544-08d71fb1ee0a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2563
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130063
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTEyIGF0IDE2OjMzICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArc3RhdGljIGludCBhZGluX3JlYWRfbW1kX3N0YXRfcmVncyhz
dHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LA0KPiA+ICsJCQkJICAgc3RydWN0IGFkaW5faHdfc3Rh
dCAqc3RhdCwNCj4gPiArCQkJCSAgIHUzMiAqdmFsKQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmV0Ow0K
PiA+ICsNCj4gPiArCXJldCA9IHBoeV9yZWFkX21tZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQxLCBz
dGF0LT5yZWcxKTsNCj4gPiArCWlmIChyZXQgPCAwKQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4g
Kw0KPiA+ICsJKnZhbCA9IChyZXQgJiAweGZmZmYpOw0KPiA+ICsNCj4gPiArCWlmIChzdGF0LT5y
ZWcyID09IDApDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJcmV0ID0gcGh5X3JlYWRf
bW1kKHBoeWRldiwgTURJT19NTURfVkVORDEsIHN0YXQtPnJlZzIpOw0KPiA+ICsJaWYgKHJldCA8
IDApDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwkqdmFsIDw8PSAxNjsNCj4gPiAr
CSp2YWwgfD0gKHJldCAmIDB4ZmZmZik7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30N
Cj4gDQo+IEl0IHN0aWxsIGxvb2tzIGxpa2UgeW91IGhhdmUgbm90IGRlYWx0IHdpdGggb3ZlcmZs
b3cgZnJvbSB0aGUgTFNCIGludG8NCj4gdGhlIE1TQiBiZXR3ZWVuIHRoZSB0d28gcmVhZHMuDQoN
CkFwb2xvZ2llcyBmb3IgZm9yZ2V0dGluZyB0byBhZGRyZXNzIHRoaXMuDQpJIGRpZCBub3QgaW50
ZW50aW9uYWxseSBsZWF2ZSBpdCBvdXQ7IHRoaXMgaXRlbSBnb3QgbG9zdCBhZnRlciBWMSBbd2hp
Y2ggaGFkIHRoZSBtb3N0IHJlbWFya3NdLg0KQ2hhbmdlbG9nIFYxIC0+IFYyIHdhcyBxdWl0ZSBi
dWxreSwgYW5kIEkgZGlkIG5vdCBsb29rIGF0IFYxIHJlbWFya3MgYWZ0ZXIgSSBmaW5pc2hlZCBW
Mi4NCg0KVGhhbmtzIGZvciBzbmlwcGV0Lg0KDQo+IA0KPiAJZG8gew0KPiAJCWhpMSA9IHBoeV9y
ZWFkX21tZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQxLCBzdGF0LT5yZWcyKTsNCj4gCQlpZiAoaGkx
IDwgMCkNCj4gCQkJcmV0dXJuIGhpMTsNCj4gCQkNCj4gCQlsb3cgPSBwaHlfcmVhZF9tbWQocGh5
ZGV2LCBNRElPX01NRF9WRU5EMSwgc3RhdC0+cmVnMSk7DQo+IAkJaWYgKGxvdyA8IDApDQo+IAkJ
CXJldHVybiBsb3c7DQo+IA0KPiAJCWhpMiA9IHBoeV9yZWFkX21tZChwaHlkZXYsIE1ESU9fTU1E
X1ZFTkQxLCBzdGF0LT5yZWcyKTsNCj4gCQlpZiAoaGkyIDwgMCkNCj4gCQkJcmV0dXJuIGhpMTsN
Cj4gCX0gd2hpbGUgKGhpMSAhPSBoaTIpDQo+IA0KPiAJcmV0dXJuIGxvdyB8IChoaSA8PCAxNik7
DQo+IA0KPiAJQW5kcmV3DQo=
