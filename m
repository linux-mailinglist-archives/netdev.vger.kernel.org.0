Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D376982BB2
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfHFGcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:32:35 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:23510 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731712AbfHFGce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:32:34 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766O77g010064;
        Tue, 6 Aug 2019 02:32:22 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2052.outbound.protection.outlook.com [104.47.40.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yamruka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:32:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amwyKvTz5NJWx4nkHf3RhuNOQX5W7ZmiKqA/LZs9gR0CUe9sPP66q/BeulJOP0Txv6n/y6bzc34Xk1KvucdnKkuivOut4+ZvhppBXt8X4Wg208ARtYeI/TMs2pMs12mpghTVXBPVWkih1YEnybWzJtJYf6Uw2sInhA1I3V4u2wSawAq/T9rjwteMFW2c0Afb/wlb6q2Q/qpKpKtsxM1ZArVF/dy1ND0KJAW917jRYDMwsCTeFwjfiEdpwlX+aCl7Nrm5YBesUV1OhVnyweLjpR8e4Sx33z4HtJvC2faTsoLsV54efOWzJKuK8z2Z3LHEkqaa6jneLlaI0OrzMFzlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H51BGd3D4vXKdeL7TS9vUYTkqIdY+OC0BzI5JzD3doE=;
 b=TcbSxigKVWPrXQDqJNtaQxh1mwjPpMeZtWBQaO9eX1s6PBhk5Wx8TNXeeBY0Zf0C6+1nMpfikpaoJCVYCz1bUvgOGhlQWVbaAp9JVw8XtUdR77THEjC+6SZCr765AJMhmLUZ4+QstYo8k2GTb5ctXIMhK+ZkTezcozz4mHz+weadfLZVqLHp2ylw3G3Xzn7L1CDb1AsZPfDdPbZqZbDfpIHteLlElB6LmKD/xvNOMRaUrcB+k12vHFpwPrHq3/xmy5J1uw46NHLbwrCRaY5OyiYuNN6AIdgVL8IwztQiVKVDhvpcusOntxAHXpTnBjRPDb4IcWVTFNMG3fnTpbEgTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H51BGd3D4vXKdeL7TS9vUYTkqIdY+OC0BzI5JzD3doE=;
 b=0akU6CLtLdO1EIaeIOtqEUzmorfNEp5vtlX0yylid82LevWGJaGytGY/H5aQR+nDZyYLdOtM/ROxf1BuG2KG0NrWuB6y3QB0hAIAnuB7PR+rVGvM730zeQck55Pbs7lH53SlQ4PcFgcIjJTmXkjMIwgOpmCf9re3s7/g11WrqTM=
Received: from MWHPR03CA0057.namprd03.prod.outlook.com (2603:10b6:301:3b::46)
 by SN6PR03MB3501.namprd03.prod.outlook.com (2603:10b6:805:3f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.20; Tue, 6 Aug
 2019 06:32:20 +0000
Received: from BL2NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::206) by MWHPR03CA0057.outlook.office365.com
 (2603:10b6:301:3b::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.14 via Frontend
 Transport; Tue, 6 Aug 2019 06:32:20 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT060.mail.protection.outlook.com (10.152.76.124) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:32:20 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766WHZp011388
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:32:17 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:32:19 -0400
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
Subject: Re: [PATCH 01/16] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Topic: [PATCH 01/16] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Index: AQHVS5VjXT25F74l5kCSv2qgimoBNqbs3LQAgAFC2gA=
Date:   Tue, 6 Aug 2019 06:32:18 +0000
Message-ID: <b462efb8ba2f730017ccf168d7e3aba062e1227c.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-2-alexandru.ardelean@analog.com>
         <20190805141644.GH24275@lunn.ch>
In-Reply-To: <20190805141644.GH24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2013465D1F409479581CD5F90F029C4@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(2980300002)(189003)(199004)(126002)(2616005)(11346002)(446003)(486006)(476003)(305945005)(7636002)(7736002)(118296001)(2486003)(23676004)(50466002)(8936002)(2351001)(246002)(1730700003)(8676002)(316002)(36756003)(478600001)(356004)(436003)(26005)(86362001)(186003)(426003)(4326008)(7696005)(106002)(54906003)(336012)(14454004)(6246003)(14444005)(76176011)(5640700003)(70206006)(70586007)(229853002)(4744005)(5660300002)(47776003)(6916009)(3846002)(6116002)(2501003)(2906002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB3501;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9b9abb6-3439-4488-a9b9-08d71a37d576
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:SN6PR03MB3501;
X-MS-TrafficTypeDiagnostic: SN6PR03MB3501:
X-Microsoft-Antispam-PRVS: <SN6PR03MB350132D97E682ABB476511A3F9D50@SN6PR03MB3501.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: xodTPKwPOjSufPo3igh+/jItkaJ5NYP3dZhIwk17gOqj4CooLVSqcBvIDRbsgIVoln6bfq4usr1SFzVWl0viQKvE/slsBFF6cBXMEqLHCWxk9zl5RL7KWnT9IE33SFuk9RR1kKlmAOHGihOexOdYnG1eEEnbOX1xLpcSBQRfFmmr9W8rV/i/Iz6s6cVH4Xf0LYANbI00E4j+e6xFbsGA6WJfH5H/t48pUPRyyVXdjEkOfETAhxcfnK3q8ksyxBkFHx/AuWb7YbRPWfKv8XLYVaqiE+w4gciuHNWzBWMc7sTAstCVTG9TJplHtYOPThFEtj4vRJMI1N83gTeI9L7otPwQcgfx1+r6SI2AB1igGFMej6KXqI/QZ2+NVTjkKPCceXQsKZYbpyUHIlkPtp2Lo3wZBRUu0a110VF2FBg8Dss=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:32:20.2150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b9abb6-3439-4488-a9b9-08d71a37d576
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3501
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjE2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArc3RhdGljIGludCBhZGluX2NvbmZpZ19pbml0KHN0cnVjdCBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gK3sNCj4gPiArCWludCByYzsNCj4gPiArDQo+ID4gKwly
YyA9IGdlbnBoeV9jb25maWdfaW5pdChwaHlkZXYpOw0KPiA+ICsJaWYgKHJjIDwgMCkNCj4gPiAr
CQlyZXR1cm4gcmM7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gDQo+IFdoeSBu
b3QganVzdA0KPiANCj4gICAgIHJldHVybiBnZW5waHlfY29uZmlnX2luaXQocGh5ZGV2KTsNCg0K
QmVjYXVzZSBzdHVmZiB3aWxsIGdldCBhZGRlZCBhZnRlciB0aGlzIHJldHVybiBzdGF0ZW1lbnQg
aW4gdGhlIG5leHQgcGF0Y2hlcy4NCkkgdGhvdWdodCBtYXliZSB0aGlzIHdvdWxkIGJlIGEgZ29v
ZCBpZGVhIHRvIGtlZXAgdGhlIGdpdCBjaGFuZ2VzIG1pbmltYWwsIGJ1dCBJIGNhbiBkbyBhIGRp
cmVjdCByZXR1cm4gYW5kIHVwZGF0ZSBpdCBpbg0KdGhlIG5leHQgcGF0Y2hlcyB3aGVuIG5lZWRl
ZC4NCg0KPiANCj4gICAgIEFuZHJldw0KPiANCg==
