Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1F8016B
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393061AbfHBTwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:52:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732050AbfHBTwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:52:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x72Jnmxw017737;
        Fri, 2 Aug 2019 12:52:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mH9hjeZfxmyBAuM8FTadT+BpaJFxYg3VcTXGiYZlpJ8=;
 b=pMCUiMPFotj2hMh/KBSDvnNFHanvkfBiNqAxn9h90X9HdLdwIgklhbD2peoufTw6zzqJ
 DJ/8sFqXeg0I4iu97yscRROzlUtjRYvE2DDnvhxoz4p1aj6+fjN289Q79qrzoGizmH2h
 uBoyMHNQFvKJkKNKEUqGkmRQqK/56LJvvSY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u4s2tgnew-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Aug 2019 12:52:22 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 12:52:21 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 12:52:21 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 2 Aug 2019 12:52:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3vXQK55BVj0oxhSmYaL0ZZOk2D0k+7SmrJbU/7ZuhXfXKvf07l2UrRiOc6i5X2fk33k5eIxS1LacS0MePOmwuDa3XfcD0+37Zs0tCROsEt3otGaYCmhaDb5NQtrxG3fbMwrLtmXLWw30axrr4p9ALSMsz10n6FhmtFZZyDUMNJfsUUDub3oCYFyU+YmfIp36o5BrRX0LKc9bExpdlPVsecatrq1SZ5NE1ZPEiT2uIL5Q8sFqfefhqi4Ca+H0Q7Hpex9gwfkBvdR4Oft6KyURzhWOsYdtX3UEqUAitnaTdKcQZAKbh6KB7nixOianw+vMSKWeLqy681VnW4MUzWEdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mH9hjeZfxmyBAuM8FTadT+BpaJFxYg3VcTXGiYZlpJ8=;
 b=G/M22fcFVRgz+Ud0V9IQVOH29A9Q308hp5TYzRH9KxZcrUOciJe/uTeoC2zTNb3VV7xGTnTvMeA0+tpmnZt6jJRi8hVvW+xPjdAnzF8gFqDf8tB9Yss+t+7+K9xsTft7yizdb/1ynOEXCpIQPJL+DDkwOtqqUm0pi9kEfhhKTydRVmil2gdtDtsR+TdkaXuCXapr8IMHKPDls5OHVtJCYO1ZvlWBKehOmScPe7ks+ZMP+JvGiWeud7RmR2FTNSAn9PaNLJmOUiarp1AQtprYG9WLu82U7XXBqc5bThDbPcdzjsKPUpYwB8uK9h/Vl997cJ7Xw+TO5aoIerpax3kosw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mH9hjeZfxmyBAuM8FTadT+BpaJFxYg3VcTXGiYZlpJ8=;
 b=Mjr8XkkETaV3COrVbHrE5lH1sz9YcGE9T5slIngndyNRGTvCCZKpvfnL5mlF/sXVmXKi17aYJSWNHE0Uiie/1CP3h5EPhh0Q4hKw/dzPIXAjBG2UD0Nse+bmy+3bqKroizBbBss+z+ExJCEQ4Jmm7LtNj2469kDjtAoQYp5l+nc=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1437.namprd15.prod.outlook.com (10.173.234.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Fri, 2 Aug 2019 19:52:20 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 19:52:20 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Arun Parameswaran" <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next v2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVSMVriqE6kdT1zkiFkU6ZMcnUQ6bn8aCAgABUaIA=
Date:   Fri, 2 Aug 2019 19:52:19 +0000
Message-ID: <7e397b2a-b2bc-19e3-5104-a596e88e2a9a@fb.com>
References: <20190801235839.290689-1-taoren@fb.com>
 <20190802145011.GH2099@lunn.ch>
In-Reply-To: <20190802145011.GH2099@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:300:117::33) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::a280]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8def2c45-9998-435d-56bd-08d71782eda6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1437;
x-ms-traffictypediagnostic: MWHPR15MB1437:
x-microsoft-antispam-prvs: <MWHPR15MB14372A0602BF155B808019E6B2D90@MWHPR15MB1437.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(25786009)(86362001)(53546011)(386003)(64126003)(6506007)(65826007)(476003)(2616005)(31696002)(36756003)(14454004)(54906003)(58126008)(305945005)(7736002)(4326008)(68736007)(6246003)(6916009)(102836004)(316002)(4744005)(8936002)(7416002)(53936002)(6512007)(71200400001)(46003)(14444005)(71190400001)(99286004)(6116002)(186003)(6436002)(5660300002)(65956001)(65806001)(76176011)(31686004)(446003)(6486002)(11346002)(229853002)(81166006)(478600001)(66476007)(66446008)(64756008)(66556008)(2906002)(81156014)(66946007)(256004)(486006)(8676002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1437;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hiYmUzoxZHp564T0D/9zotoMYrBc1wqNMONrh7MI5Vo6qPVtuY0dE25Cs7T7cyGCyQ4o6lVLybe3F6jAOQbC0dcV1tQLEaNinBpJe7MnvRVhsud3r2FYzuLjvHNDtKZqcVyJ0zjukplYNoSd+9iOZoJNQyNudNdtatuayaWlQAaUFOl4rcVOKU+CXZdfNSZ+a19N8ox/JQ+NU2c0hg6iMoPqKh2gCxkmBfsAkldWtDChAhv4h5vZO0y6E4caR6tkoeqs589oDzmPt54nH3LS6YNLuMG7sMcb8pyNZVwAMJBgD9wF2MNurTQIKv5VdVv/nk1zhsT3GP7Ghkq9kTW3Bf4uUBQ3x6rLrQNQZ/vRIMOdfGhjJ0SQxbAp6lUtnHqLalzyPCYxgUU9SObjQi4woKMWCCA0bY69J0DljRiyewI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B59241895C3EB94697708B33E039DD31@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8def2c45-9998-435d-56bd-08d71782eda6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 19:52:19.8765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1437
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=746 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020209
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yLzE5IDc6NTAgQU0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4gK3N0YXRpYyBpbnQgYmNt
NTQ2MTZzX3JlYWRfc3RhdHVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiArew0KPj4g
KwlpbnQgZXJyOw0KPj4gKw0KPj4gKwllcnIgPSBnZW5waHlfcmVhZF9zdGF0dXMocGh5ZGV2KTsN
Cj4+ICsNCj4+ICsJLyogMTAwMEJhc2UtWCByZWdpc3RlciBzZXQgZG9lc24ndCBwcm92aWRlIHNw
ZWVkIGZpZWxkczogdGhlDQo+PiArCSAqIGxpbmsgc3BlZWQgaXMgYWx3YXlzIDEwMDAgTWIvcyBh
cyBsb25nIGFzIGxpbmsgaXMgdXAuDQo+PiArCSAqLw0KPj4gKwlpZiAocGh5ZGV2LT5kZXZfZmxh
Z3MgJiBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJYICYmDQo+PiArCSAgICBwaHlkZXYtPmxpbmsp
DQo+PiArCQlwaHlkZXYtPnNwZWVkID0gU1BFRURfMTAwMDsNCj4+ICsNCj4+ICsJcmV0dXJuIGVy
cjsNCj4+ICt9DQo+IA0KPiBUaGlzIGZ1bmN0aW9uIGlzIGVxdWl2YWxlbnQgdG8gYmNtNTQ4Ml9y
ZWFkX3N0YXR1cygpLiBZb3Ugc2hvdWxkIHVzZQ0KPiBpdCwgcmF0aGVyIHRoYW4gYWRkIGEgbmV3
IGZ1bmN0aW9uLg0KDQpUaGFuayB5b3UgZm9yIHBvaW50aW5nIGl0IG91dC4gV2lsbCBmaXggdGhl
IGNvZGUuDQoNCkJUVywgc2hvdWxkIEkgdXBkYXRlIHRoZSBwYXRjaCBzdWJqZWN0IHRvIHNvbWV0
aGluZyBtb3JlIGRlc2NyaXB0aXZlIChzdWNoIGFzICJuZXQ6IHBoeTogYnJvYWRjb206IGZpeCBC
Q001NDYxNlMgcmVhZF9zdGF0dXMgaW4gMTAwMFggbW9kZSIpPyBPciBJIHNob3VsZCB1c2UgdGhl
IHNhbWUgdGl0bGUgdG8gYXZvaWQgY29uZnVzaW9uPw0KDQoNClRoYW5rcywNCg0KVGFvDQo=
