Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3BD82C00
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731945AbfHFGrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:47:48 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:4478 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731930AbfHFGrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:47:48 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X60U000891;
        Tue, 6 Aug 2019 02:47:38 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2052.outbound.protection.outlook.com [104.47.48.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb22xtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:47:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7v14b/6F+9TL2BQHTc9t9WMqptm+cCB3tLDu4IvabpT7Yv1HK9wMzZbdT3sPoZY7ZsFHJvbezV7PJPHmUNRJrQ/QRE18wQh7VLqBfivnhcPC330hwjGIHwMVOPXhmoZKCZx6RAIkVCp14Jj0fjcOLp+wbs+qloGWCW8MNG5rdoB6hiP6INai3/VgpfPiNEJ5gzi5RkdgkFG84sTbbLMda3ESnV1I+nibaVW+RZDfmh2OElrJ159MfSm17hb34bZeJI9m9HRLUScG+lcGUiGfioJzx+yTX+EFe/CsSAtJLJrBBEYJKiRlHph6KC5oBf3z2Xk/ZTYL98T6f3j+zHAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YciPv2UcJdgTkd6/mYRkiA9FrB79F2HMQd+ZIxymGZ8=;
 b=Pt8tpv16oI5aY2SX77TTxdtAXkr+8Ubu7NMWMDPIYhIgqWVnTSA3TrW+gCikMqYDK/whbwgy5fuV0/nYAs8eBC8QGF8eKJqoUB7dbKq3xlvhzxlMY8gsG5bcF7URL7gw9lXBMIHey+//NvS2qYaQAXQ3ycnfyX4/lz+qRgY6Xe4mbTpqoFxQithaTTHZbDMvgqMnSNC1OSsAHqPj5NJt3aEOI5yw5UxSZTwWd9QVWxJaBh2EBfIZ9HyPKhO/l5hc6MZIKHwV+i3PEh8N6aZ00dtFIRbTW1A7A40W0jrU9V9lU8gvWUOBj8XUbySOFJC4Zlb/p2wpisl/TLs4L42epQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YciPv2UcJdgTkd6/mYRkiA9FrB79F2HMQd+ZIxymGZ8=;
 b=iHgNDdfVz8F+EBXDE6yf6jUauaC/heEOt8gyUhEYGsRpIbEnfCuXFJxKaZ/46lTZAMWGlOnRwo9qwdYJ7tJi13i9hK/Yk1IrcsPQnoL+LOx4lpwylByoxeACKrqnSv5JsA76+fNFlxtP3tnqpOoJ14WUWKtzyYi3mvrrnbG2pn4=
Received: from BN8PR03CA0015.namprd03.prod.outlook.com (2603:10b6:408:94::28)
 by DM5PR03MB2746.namprd03.prod.outlook.com (2603:10b6:3:41::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:47:34 +0000
Received: from CY1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by BN8PR03CA0015.outlook.office365.com
 (2603:10b6:408:94::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14 via Frontend
 Transport; Tue, 6 Aug 2019 06:47:33 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT060.mail.protection.outlook.com (10.152.74.252) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:47:33 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x766lWYW010768
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:47:32 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:47:32 -0400
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
Subject: Re: [PATCH 10/16] net: phy: adin: add EEE translation layer for
 Clause 22
Thread-Topic: [PATCH 10/16] net: phy: adin: add EEE translation layer for
 Clause 22
Thread-Index: AQHVS5VvOO7G49/+60uqEu73Cm2nIKbtYXIAgADCWwA=
Date:   Tue, 6 Aug 2019 06:47:31 +0000
Message-ID: <134b73f22109d7f16207b032a0c286af85bca210.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-11-alexandru.ardelean@analog.com>
         <20190805221150.GE25700@lunn.ch>
In-Reply-To: <20190805221150.GE25700@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D231F71C26129643A1B4C7A37705F07D@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(39860400002)(346002)(136003)(396003)(376002)(2980300002)(189003)(199004)(36756003)(23676004)(4744005)(229853002)(86362001)(76176011)(54906003)(6116002)(7696005)(356004)(3846002)(316002)(5640700003)(118296001)(106002)(2906002)(70586007)(5660300002)(70206006)(102836004)(2486003)(47776003)(186003)(26005)(14454004)(2351001)(336012)(7736002)(8936002)(126002)(486006)(1730700003)(476003)(8676002)(2616005)(2501003)(7636002)(478600001)(4326008)(305945005)(446003)(6246003)(11346002)(426003)(436003)(6916009)(50466002)(246002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB2746;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8153f7fa-dd15-4d4c-360e-08d71a39f5d9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:DM5PR03MB2746;
X-MS-TrafficTypeDiagnostic: DM5PR03MB2746:
X-Microsoft-Antispam-PRVS: <DM5PR03MB2746B21E8FC35E604723C093F9D50@DM5PR03MB2746.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 788uTHTxxMUHnbIhwUoBYmDqZ3auzDPuZBNNOP29+bn+13ku49aeGIFmobFk637L5RjxPIWYFQ4tJyviJOkHx8m0mh+FCNfyplD2DiPMF6lhCoQuNl/9REuIP1Vi6Thf1/sHRhyKbhh96+0o2s8pvCOgpl5O39yuDWagyUgHWQnE60L6G4fm9cGTNgAG2LSR4zZACrfv3j6o0+vYeamZsKesBzQ99TqzvJ+GtKRkp3ezBoMxzn3G2o0tWddkeOO1cJGt/8LpL+PsrhQa1yVWU5xhbv5w23eBq4L+pbWUzRuik4Vt0XGhdZ0n/wq4H0F+QVozVIX6xYgh0uQgbKMqn/0kM+RHNffoFzv/rExUK1WHVU4iORTEjlYOs0aytYNbP9X4UVLktXF11DLNdcfqemfF81mhJXnx1258Sez1RQY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:47:33.1121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8153f7fa-dd15-4d4c-360e-08d71a39f5d9
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB2746
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=919 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDAwOjExICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArc3RhdGljIGludCBhZGluX2NsMjJfdG9fYWRpbl9yZWcoaW50
IGRldmFkLCB1MTYgY2wyMl9yZWdudW0pDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBjbGF1c2UyMl9t
bWRfbWFwICptOw0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJaWYgKGRldmFkID09IE1ESU9f
TU1EX1ZFTkQxKQ0KPiA+ICsJCXJldHVybiBjbDIyX3JlZ251bTsNCj4gPiArDQo+ID4gKwlmb3Ig
KGkgPSAwOyBpIDwgQVJSQVlfU0laRShjbGF1c2UyMl9tbWRfbWFwKTsgaSsrKSB7DQo+ID4gKwkJ
bSA9ICZjbGF1c2UyMl9tbWRfbWFwW2ldOw0KPiA+ICsJCWlmIChtLT5kZXZhZCA9PSBkZXZhZCAm
JiBtLT5jbDIyX3JlZ251bSA9PSBjbDIyX3JlZ251bSkNCj4gPiArCQkJcmV0dXJuIG0tPmFkaW5f
cmVnbnVtOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXByX2VycigiTm8gdHJhbnNsYXRpb24gYXZh
aWxhYmxlIGZvciBkZXZhZDogJWQgcmVnOiAlMDR4XG4iLA0KPiA+ICsJICAgICAgIGRldmFkLCBj
bDIyX3JlZ251bSk7DQo+IA0KPiBwaHlkZXZfZXJyKCkuIA0KDQphY2sNCg0KPiANCj4gCSAgICAg
IEFuZHJldw0K
