Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D50E82C11
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbfHFGwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:52:36 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:29142 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731576AbfHFGwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:52:35 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766lthj009349;
        Tue, 6 Aug 2019 02:52:28 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2057.outbound.protection.outlook.com [104.47.38.57])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u5448ukh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:52:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noaoNYil5NjkkSerQDmpRYNLmHZD5qjyJvWrLPFMcLBHpmoEYwF0GnxNT5+XlBCVYe+4xoY8ffNsWDj47WVntEZZwgxgGtSu4m33qITfIiCSjiuGHmEfDlmdtWXzYTct9nJGizarqckQRI4TIq/22204VSS0X21Bw0MNANhWt3ippZ5v7No8FgqqoTA/h90+hsKAMAQ+vCS4/A8ef9Ng4v8QZ8U4FdqN3L3Jn+b4/VVDWaSImbWMsbYYVexCcaJuodPez1p4SS2mvMBHEKx2IMmslAuU3o+ZKep6thvbw9laqW050EuaBHjibRLog8D/30eH6uVrDXYobQsmkRNo1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLigmoh4xAwlzqHhCki32rv1JVOk2iGMbM6+vBUCzwA=;
 b=X7PYpNNCASEZiskr0OhaGVZ46pd7uMBwMCbkNTYAz+4o3DqNz+PkRIFmCif8+B/t3llDNBPViSOctFwifDkIQdvEZgdwVyKuSytXYHNlA9iNAQNSqgNdxL26L4ur7PRVlo5FMmshXOlXTT3D+rIw+d6UOX8MithgIIcfHwKytcxToi5dPQmi1AjheD+cl5OAz5n9hqGwheCdYuLDiB7EpxGlB4Ief5+sEIpH1fxt7eGg+Z5cJTaSc0PF/q2JXQIwaMZCEWaWFttUsySc+JOr5ZdqqI3c9E50EHmowzQAzSPTG1bOn5Hc+3LHtVu+DtjbNDqyCqtVdES8u9yu3UPZJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLigmoh4xAwlzqHhCki32rv1JVOk2iGMbM6+vBUCzwA=;
 b=INxRrZP5hcb8HHzDyQA7eYwxWPcvQGDaDZ4c2HRRcXVnye11xnA+3L3WuizCaWNv3TcMxxV8fYCODK14VQQ9INXi9cNKxV1ijOGme1ao9KR+D1MememV3jUZwAMjMhXosFdL4XEUuWvws9mJSk1LAqMSZrwjMgU5bv51t2+lUH0=
Received: from CY4PR03CA0001.namprd03.prod.outlook.com (2603:10b6:903:33::11)
 by CY1PR03MB2346.namprd03.prod.outlook.com (2a01:111:e400:c612::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:52:26 +0000
Received: from BL2NAM02FT019.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by CY4PR03CA0001.outlook.office365.com
 (2603:10b6:903:33::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Tue, 6 Aug 2019 06:52:26 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT019.mail.protection.outlook.com (10.152.77.166) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:52:25 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x766qPbN011632
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:52:25 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:52:25 -0400
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
Subject: Re: [PATCH 12/16] net: phy: adin: read EEE setting from device-tree
Thread-Topic: [PATCH 12/16] net: phy: adin: read EEE setting from device-tree
Thread-Index: AQHVS5Vx2HddEM9xW0+Jz1Xv/36V8qbs7iSAgAE3CAA=
Date:   Tue, 6 Aug 2019 06:52:24 +0000
Message-ID: <9487cadc364828244d246a3d8e8b2d437fbd03f8.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-13-alexandru.ardelean@analog.com>
         <20190805151909.GR24275@lunn.ch>
In-Reply-To: <20190805151909.GR24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E080FB38D39B1940AEF71AA96881FD78@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(2980300002)(189003)(199004)(36756003)(6116002)(23676004)(4744005)(86362001)(76176011)(54906003)(7696005)(356004)(3846002)(316002)(5640700003)(118296001)(106002)(5660300002)(2906002)(70586007)(102836004)(70206006)(229853002)(2486003)(47776003)(186003)(14454004)(2351001)(7736002)(8936002)(126002)(486006)(336012)(305945005)(7636002)(1730700003)(476003)(2501003)(478600001)(8676002)(246002)(4326008)(26005)(6246003)(2616005)(11346002)(426003)(436003)(6916009)(50466002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR03MB2346;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 624e9ae1-2cc8-475e-41fc-08d71a3aa41a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:CY1PR03MB2346;
X-MS-TrafficTypeDiagnostic: CY1PR03MB2346:
X-Microsoft-Antispam-PRVS: <CY1PR03MB234611C79053D59647F5EA16F9D50@CY1PR03MB2346.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: kOGMtFWoq2py7x7EIDtp8Y9KpsqKpybMRx8Nj6Td3+k3YF0KCU/BaYJ9dko3cwefh/6Dr+DZUo+vNFsEB25Z+rcBfvQXLMaV59Fs8ccUO27F+jAMbm5NQklUX73d4jSLCCfRJNSu5y4J++deUVnoo4gh74EFlyvz0RMcE8EdlY0bJMzs/IrLTPJ7+UC3HbDa/83+WKXjHTeOlpBN00fFjl0HGGRowTHSnpPQSbQq5Hp4eslg7PrC2kNKIOhbt+8N5tTuW0WjH6MjW2SYrsSbJDbQFSutxLu8UIHA+h7JtqEvG7aaW/2MBWn2ExbGdQ0spgWRLaTXWt1yCAX7njZBQqN5Orwxe34QLF0h7XwAyaK/D/Xo/Epu+11E8ciMlkB5slqk9LwMnczhEdgte42qRdLrzky7RkvpafUU+X5gtd4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:52:25.8863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 624e9ae1-2cc8-475e-41fc-08d71a3aa41a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2346
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=670 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE3OjE5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NDlQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IEJ5IGRlZmF1bHQsIEVFRSBpcyBub3Qg
YWR2ZXJ0aXNlZCBvbiBzeXN0ZW0gaW5pdC4gVGhpcyBjaGFuZ2UgYWxsb3dzIHRoZQ0KPiA+IHVz
ZXIgdG8gc3BlY2lmeSBhIGRldmljZSBwcm9wZXJ0eSB0byBlbmFibGUgRUVFIGFkdmVydGlzZW1l
bnRzIHdoZW4gdGhlIFBIWQ0KPiA+IGluaXRpYWxpemVzLg0KPiAgDQo+IFRoaXMgcGF0Y2ggaXMg
bm90IHJlcXVpcmVkLiBJZiBFRUUgaXMgbm90IGJlaW5nIGFkdmVydGlzZWQgd2hlbiBpdA0KPiBz
aG91bGQsIGl0IG1lYW5zIHRoZXJlIGlzIGEgTUFDIGRyaXZlciBidWcuDQoNCmFjazsNCnNhbWUg
dGhpbmcgYWJvdXQgUEhZIHNwZWNpZmljcyBpZ25vcmluZyBNQUMgc3BlY2lmaWNzDQoNCnRoYW5r
cw0KDQo+IA0KPiAJQW5kcmV3DQo=
