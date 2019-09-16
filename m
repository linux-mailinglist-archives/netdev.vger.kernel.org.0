Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F5FB34F7
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfIPG7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:59:11 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:64242 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbfIPG7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:59:10 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G6qkfE027590;
        Mon, 16 Sep 2019 02:58:48 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2055.outbound.protection.outlook.com [104.47.46.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2v0t2936fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 02:58:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfzxcNuYNkiMQahrEXwPMIQyG8p5ZXCKczq6D3IIT1sKGDTZzwem2mKQYZxCbNpIzQf2huyzlMUBqKGVZfC7qYJjYE5T88vYsA57Pf9RUoZwEx7fo8xdHnppYVsnBOon3ku8nhPuJ3GXbkRRwhVGfvWsQQg474gy57cQpxG/jgp2hIejO16zKsesS2X5x9O3cmSmh/ybbhtZZyoK0SwjnFCmZOpulQ5b4rl8CWMoQ75I25BhTD30kA02hNtt4iWpy0+EgH3M1iSnIb6K4pxwGaa8dKQgDY7axAwzx26hn/FR1sZQvh2iJGTbTdhEtjTI0UWrZArwPfKCgK003uSssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkK5K3uknWpY2TrkhuRXmUmThRUwY6AbEUanMQj95hM=;
 b=nYi3smPX38OyjA3VLXiWFOZB2LZyyyYhsjlJRmnkcrHHgkFQ/b/OOdxeDZSQ0udFbROipweJyp4exNLPVnTHdOjdC7FQuaP35/2WzA3wG5okaq0v+dPJsTD7mAvM9vlOt8LjQKwsAdVqubYCkCKV6eNa+9/MhwIKCMqbDZYSqQSSJoPIk6YnTQjPk/EIZP2BHbpBJlNPRMFTalcYtqZx2YIMBfrG+RkFTEjXXjmsoodhKtaloDIvPM3FUh91JZHznKBvrUASIULVpW/WYk4+iLmQDoQ6IOb8Fp9tANBkQBv2nx1CEcqcz90WN9hyytTLAY21FS6yiczSfBlQhwrNaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkK5K3uknWpY2TrkhuRXmUmThRUwY6AbEUanMQj95hM=;
 b=vvdTXhLw3EZMKqY4ZV8leJdVJTJQjAS2SvIBG284uN6BcHYb1/MqqsH2QjxApWIWb3an1GIhEpERmdg6BIwCxI3ykdH9/+9lzoq8uGdOBIn+M+TRs9iZelo0GXM2PFAio1RQu0cdTjmSrc51xDsHRGMmiqzdY28PmkP0+HsLpxM=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5174.namprd03.prod.outlook.com (20.180.4.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Mon, 16 Sep 2019 06:58:45 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 06:58:45 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: Re: [PATCH v2] net: stmmac: socfpga: re-use the `interface` parameter
 from platform data
Thread-Topic: [PATCH v2] net: stmmac: socfpga: re-use the `interface`
 parameter from platform data
Thread-Index: AQHVaVTi4HKe60y1t02IETURYvxs6KctGpiAgADLGgA=
Date:   Mon, 16 Sep 2019 06:58:44 +0000
Message-ID: <7d2b366fb6969a2baed5639e3f8935fcce5e2f4b.camel@analog.com>
References: <20190912132850.10585-1-alexandru.ardelean@analog.com>
         <20190915.195149.86866545205816280.davem@davemloft.net>
In-Reply-To: <20190915.195149.86866545205816280.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03fecbbd-131d-45c6-2a66-08d73a73511d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5174;
x-ms-traffictypediagnostic: CH2PR03MB5174:
x-microsoft-antispam-prvs: <CH2PR03MB5174A710AB1F42F86F303CBCF98C0@CH2PR03MB5174.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(39860400002)(396003)(136003)(199004)(189003)(25786009)(6916009)(76176011)(54906003)(6246003)(6506007)(186003)(102836004)(66066001)(36756003)(71190400001)(71200400001)(1730700003)(81156014)(81166006)(76116006)(6512007)(66446008)(66476007)(66556008)(64756008)(8676002)(66946007)(4326008)(478600001)(26005)(6436002)(118296001)(6486002)(5640700003)(229853002)(53936002)(7736002)(256004)(86362001)(476003)(316002)(8936002)(14454004)(2351001)(305945005)(3846002)(6116002)(5660300002)(99286004)(2906002)(11346002)(486006)(2616005)(2501003)(446003)(4744005)(81973001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5174;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aKlPfpGhOBb5E4ZNzy6+N3EvPrVWLsgKB2P9lBskMg1xYPV3bEEy/4+BPVxi5YnKoy1mVov8b85fONrTryRCat0odr9yFTNVMHId3dfBffqm4TB2gnOmFouMC5YNqhS3VHmu/BKWShcIqShuRxwbMhFH4ymSMakNDsU6Iu42g0u7vhprg/GKJ1JMmAsMMpVJxQQKVb7bdAos5bbpAw3L1mPdt45LtaeOK2E67GMJFszUnRtI8lfOrMuGSfqj1mOnpFBM+C5mGS3kWrITbfN9a+15Al5aI5zJDPAWXN/P/xBYyRiCqDoXbkvqHC6gvqrMiJrV3TSQD+LudKO4zKEckL8OE4eAhKnL6OcSfCH7n3/OcGybLWs4nhrAisbm1XaQw1YY6+/qNLmAvhVPKqhKADo7p9ltPUj3rXZZnbxLeY0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B83A354A738D9749AACB0B5254A76BBB@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03fecbbd-131d-45c6-2a66-08d73a73511d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 06:58:44.9778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pdD2n7BFFOs2h06E+FOmHttl5okgxl/bG9my6AH+lFrJj1Aw6571jIROrZzNRbcFTFZZ1XHqBYIoI4YCevPkB0KFbKH0gB32+iLIWXAUlzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5174
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_03:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909160074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDE5LTA5LTE1IGF0IDE5OjUxICswMTAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IFtFeHRlcm5hbF0NCj4gDQo+IEZyb206IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFy
ZGVsZWFuQGFuYWxvZy5jb20+DQo+IERhdGU6IFRodSwgMTIgU2VwIDIwMTkgMTY6Mjg6NTAgKzAz
MDANCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3Rt
bWFjL2R3bWFjLXNvY2ZwZ2EuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFj
L2R3bWFjLQ0KPiA+IHNvY2ZwZ2EuYw0KPiA+IGluZGV4IGMxNDFmZTc4M2U4Ny4uNWI2MjEzMjA3
YzQzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFj
L2R3bWFjLXNvY2ZwZ2EuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL2R3bWFjLXNvY2ZwZ2EuYw0KPiAgLi4uDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50IHNv
Y2ZwZ2FfZ2V0X3BsYXRfcGh5bW9kZShzdHJ1Y3Qgc29jZnBnYV9kd21hYyAqZHdtYWMpDQo+IA0K
PiBQbGVhc2UgZG8gbm90IHVzZSB0aGUgaW5saW5lIGtleXdvcmQgaW4gZm9vLmMgZmlsZXMsIGxl
dCB0aGUgY29tcGlsZXIgZGV2aWNlLg0KDQpBY2suDQpXaWxsIHJlbW92ZS4NCg0K
