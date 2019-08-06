Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0AC82C14
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbfHFGxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:53:15 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:20056 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731557AbfHFGxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:53:15 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766ln1h011790;
        Tue, 6 Aug 2019 02:53:07 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb22y50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:53:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTlaN8rR/QIChemStLo6HkkBFOuae9/j5KRBhHWunJNwEgU+dfspiYu5BhWuO3/auSKbrM+kXIZWiEg0P2rcwy/aTYvC/DOuu4u9sl/YjDIYIKKDKtc3fWKxvqVnUFnMgQsuOcWerzkS5XswMBwdRhBkpc6WlLe4ICDgv9HeV1nuN2RU+Q8Cx8pIL/puopqVzLuNd0RNCdnAp6Y8l0TdVehvymqvlZ6nc5bGtooQyjS7KuTi0rRcedpMMBxAepKQpIe048oaieyXYjbRLEvcTYCnibgi6DHw85gMcsCN5HG6kpPIHIVecx4AjZaPrXBdNeuAwk4Q/89H0dIiTRoEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdvYstPcaL1NuJSsr6l68sH6XUZliFHPrN4KQv6aeIQ=;
 b=I62lOFmbDFGkfF11qZZV3goZ3U9UdxI1K62/QK4Owp9UrYg32f8IggGuGKhqc1DnM3JrOQIOhOIfauYQ41HrsyqUjv4iCg7DsdnfNYGMKeU3rZnjcDD+4FQqaSYmzxs4VHB4l4Wv+4ljwaXtm4JRMMj+0SbCtgRwosXEbwaQOfiLhVuiVczoUDGbS27+js2RjnBhKO5Hwd6VGl1PDsePFeHqAh93cUaxT9yLMaY7kFwJvXVP8BRY7ZPN+XTwZwprOiRIBMGY6avXdrI4/fdJB7gHPEg7n8RBI9SytLYkktXSk+urgOZRnuhOLltMz2SwiixAOhlb+GMzs247iMZkQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdvYstPcaL1NuJSsr6l68sH6XUZliFHPrN4KQv6aeIQ=;
 b=0Ecymooz9IGaKhqs0SVP5k9WRKE6c7iTyDabg1KTedxgFc35RlSHHnUpD+RwqT3vEOjVuP5KBCoMo6jBm2OOaXPUnuGNHXGOI0e+jhN4Dsf8fYG2XrwTF0pZDhEx72IeiJx8zM3dl/Ry9S9doU8DfxTggmTam7m7tfrgzcT2sQ4=
Received: from BN6PR03CA0053.namprd03.prod.outlook.com (2603:10b6:404:4c::15)
 by BN3PR03MB2324.namprd03.prod.outlook.com (2a01:111:e400:7bba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:53:02 +0000
Received: from SN1NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BN6PR03CA0053.outlook.office365.com
 (2603:10b6:404:4c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.12 via Frontend
 Transport; Tue, 6 Aug 2019 06:53:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT017.mail.protection.outlook.com (10.152.72.115) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:53:01 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766qwcS015443
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:52:58 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:53:01 -0400
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
Subject: Re: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is
 enabled
Thread-Topic: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is
 enabled
Thread-Index: AQHVS5V0IlrGd78N3UWpB4qyPDrHy6bs7wEAgAE2VgA=
Date:   Tue, 6 Aug 2019 06:53:00 +0000
Message-ID: <d664ec07de0ab1f84e2f2b680c39257fcbeaceeb.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-15-alexandru.ardelean@analog.com>
         <20190805152214.GS24275@lunn.ch>
In-Reply-To: <20190805152214.GS24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F354B85D7EC014F861666E3E1570ACB@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(136003)(39860400002)(2980300002)(189003)(199004)(5660300002)(118296001)(86362001)(70206006)(8936002)(70586007)(5640700003)(26005)(8676002)(1730700003)(6116002)(3846002)(2501003)(6246003)(6916009)(4744005)(316002)(106002)(436003)(14454004)(446003)(11346002)(229853002)(356004)(478600001)(2351001)(54906003)(50466002)(126002)(476003)(2906002)(4326008)(7736002)(7636002)(426003)(186003)(7696005)(2486003)(102836004)(2616005)(305945005)(246002)(47776003)(486006)(336012)(76176011)(23676004)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2324;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f360af-d551-4960-1c25-08d71a3ab9a2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN3PR03MB2324;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2324:
X-Microsoft-Antispam-PRVS: <BN3PR03MB2324FA735CE6B41B63CCD47EF9D50@BN3PR03MB2324.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: WRlH+noz4M4BZo9Q3Fp48XiveTm47/gb9rFea8VloNfSGv6Bqt261U+Xt1bP3G049vkteLBMoIvWqzr+8kK3wZMHlWPfMwXqEeVup8NsKLMCTfyv9FxrPAuIcLbEz/RPJ7K4vvpReQnrnv7X2qCzx8AEa9RAQVhXCF+LDijhVDmG3Lbo3ghBQ8qnDQrfLGR2n/3VpEgHFwNch4OE4YZypRhyNoPjQk59RHhmQCgKDUER8ZXanSHQD41UE3tCkPcFc4+EPNKiUusZ/ROV2C858Ril1EoltT4VMTmrOmV7Bh39lZmgHkBznUiFEuiUQQfJ67nvFnawGz1HSy/2vgAi2jMWWyhiQ/0KQS3uPl55EuNhw3TJVKakK4xgDf9nUmuKmFzOxWlvoUY9TddNDX5rZSIIFdVRAoxoMMRrLzRtBNo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:53:01.6813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f360af-d551-4960-1c25-08d71a3ab9a2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2324
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=861 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE3OjIyICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NTFQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IERvd24tc3BlZWQgYXV0by1uZWdvdGlh
dGlvbiBtYXkgbm90IGFsd2F5cyBiZSBlbmFibGVkLCBpbiB3aGljaCBjYXNlIHRoZQ0KPiA+IFBI
WSB3b24ndCBkb3duLXNoaWZ0IHRvIDEwMCBvciAxMCBkdXJpbmcgYXV0by1uZWdvdGlhdGlvbi4N
Cj4gDQo+IFBsZWFzZSBsb29rIGF0IGhvdyB0aGUgbWFydmVsbCBkcml2ZXIgZW5hYmxlcyBhbmQg
Y29uZmlndXJlcyB0aGlzDQo+IGZlYXR1cmUuIElkZWFsbHkgd2Ugd2FudCBhbGwgUEhZIGRyaXZl
cnMgdG8gdXNlIHRoZSBzYW1lIGNvbmZpZ3VyYXRpb24NCj4gQVBJIGZvciBmZWF0dXJlcyBsaWtl
IHRoaXMuDQoNCmFjaw0KDQo+IA0KPiAgICAgQW5kcmV3DQo=
