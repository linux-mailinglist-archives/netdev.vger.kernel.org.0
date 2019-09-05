Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61F3A9B48
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbfIEHKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:10:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7218 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727900AbfIEHKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:10:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x857AXs9015648;
        Thu, 5 Sep 2019 00:10:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=vU54gZjxiVxvJl2eoW2EscWr256c2EwuGn7IFr80evw=;
 b=Pd93E1BQ0OMoyqne6LWZKY7XnHIYDF12Zc2WWU3LIsO8MjCKqa2Vbto4K/v4hrR2RsCN
 lGW4WBMIwXxxA5ePlUH6ih/+9W8mPnVZpUiuQ9tF0mjl75kujDBfNlwcctCNAwUZwRK5
 maZaJ712ZSjts3PCy90vMg/cYSU5XcqV1ZE3YjR6tXeTz93gz4010O6Drj9DvWP2NeWn
 x7wtEV3Q1k8/PMlfUfd/N+APx7GP3kybUDBDd13I3HkjUc2iHj2FH70qqwkv0h6rDVWn
 z/+rpcguw7M8wKJjqbeCEUri8JnaDtChEljNbhj5LMGUipUZYCd4KGyzWuwCVwSle/Q9 iA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uqp8pj97t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 00:10:33 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 5 Sep
 2019 00:10:31 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 5 Sep 2019 00:10:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABe0f7QRyo0/j/f350CeDao1spHIr+1ZpAKiv8wq/JbUgoayoinOKZKi6Fj12l/emscAToMWouQi0oyaAFXN7YaTI6vC0VzShEyNBy8OBpqIagL4KOIIZaGtUkZW9JfXAiystKrbwqScPrTCBaQPbZkyot+lvfi1mSiD92RdlYwYxoS3hlyRAZeMFipSB6JGHsFAKq/49VC4JyN2Rsy6sG6wCgWZp3geKa9Rj/h+Ke/JoJ78GrMo0452nBv+kbnBYe2jKs2sfoEbhgQDe9YKFaiBPCOsv6ZkbBF3fbNEY9gQed270/TYlJRTvfeKf0+N8u/cn39Pwd0kEuKZ1Ozz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vU54gZjxiVxvJl2eoW2EscWr256c2EwuGn7IFr80evw=;
 b=hobx28RN6GvblQUq8UlN+6KSxeLG6s0mUtVy7iSPmV3fEasOQfdCcxGSWvlyaW3QMpKIF7ar0oKUE8wx4gNxxyhlQXRI65Kl37cR69mx6BViX1+NMqTeih+dYEeuTjv3+DDhbFxUjE+aELmDRjf+J5nw/PPbvyO2FMIwXKHPsPJW9MWC6uN/QvMST8hFh/AThopv9h5oexTfR2yAb5rmpfIaKn7bn0orhZdPiousC86z/EkJkkXabWaChWX4N8SligjDkqDE7rq1md7Hz+pRf76VN5867uJa/AUrk6EhO7Xwcfu6ouVCqm2NOZapCZjS/bbU9ZlNEsgC9iOHxVjhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vU54gZjxiVxvJl2eoW2EscWr256c2EwuGn7IFr80evw=;
 b=FAYCydVrsPnA+PeRdTT7CLIHyIHB4EUe/rgrwjgn+1ZkYNfIt49TMJMNJK8ufGwUF5qpy/OhcCD8J01Y5Z5ADFbVx6ifGh3VmXTM2oTKiURJHk0nI1ED67Fwd73N61Z9gH4RJX+CgJyIN78z/0D/PxhMU+3cq02y15dJu1JoM6E=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2413.namprd18.prod.outlook.com (20.179.83.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Thu, 5 Sep 2019 07:10:29 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9d49:7d09:abb5:34e8]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9d49:7d09:abb5:34e8%7]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 07:10:28 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Krzysztof Wilczynski <kw@linux.com>,
        Ariel Elior <aelior@marvell.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: qed: Move static keyword to the front of
 declaration
Thread-Topic: [EXT] [PATCH] net: qed: Move static keyword to the front of
 declaration
Thread-Index: AQHVYyuGjobw/PbCY0StEUp6RayVWaccq3cw
Date:   Thu, 5 Sep 2019 07:10:28 +0000
Message-ID: <MN2PR18MB3182E7412AECBEE5408AA0EDA1BB0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190904141730.31497-1-kw@linux.com>
In-Reply-To: <20190904141730.31497-1-kw@linux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08d7c0a6-ae37-4f71-0f09-08d731d02202
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2413;
x-ms-traffictypediagnostic: MN2PR18MB2413:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB241357E0BDA14655DA61689EA1BB0@MN2PR18MB2413.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(376002)(396003)(346002)(136003)(199004)(189003)(6506007)(6436002)(14454004)(53936002)(25786009)(55016002)(4326008)(316002)(110136005)(54906003)(99286004)(86362001)(9686003)(6306002)(7696005)(33656002)(66066001)(71200400001)(71190400001)(966005)(186003)(102836004)(14444005)(76176011)(256004)(6246003)(486006)(26005)(478600001)(446003)(11346002)(476003)(66476007)(66446008)(52536014)(64756008)(7736002)(74316002)(305945005)(229853002)(76116006)(6636002)(66946007)(5660300002)(8936002)(8676002)(81166006)(3846002)(81156014)(2906002)(66556008)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2413;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gIe3uZsahRDTLmtFbb1dB+mjp377vUV858xvRjMEbBPg8b0JfKyXZTmUES/SP2enNu74vR+rwENg5zqReRJhtsCT9Xh6JIEfVpJfe+XCdflDVRRuw1lFsjkXnr9WAR1NDzQ1rdyPVjnVuLVcPyzRbAEHmDO06tZza8iKwcxtapYkPXesOwrlB+W8Kq0Jqp8mSCXKab/H5IuFifkFpec2BGshsbsBKFCwL6C4cANBmy4OV2QiKPxc8GB74eol97FxZPxZ3OiWvdwc+pSLTlnJHcAlQc8ljFuIsZ/QZbf5JtNZqpVi0NNLHBbnE0RysTACbur8q9Z/FFVdKOx8NhfX9Wa/srEAavME/SzfukocAopOSlabKMo4CDBa9F3nNHvxy5rLO/WAbESS+e+obKOcq3Ish2NTR9qK19Q59/WH0Pc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d7c0a6-ae37-4f71-0f09-08d731d02202
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 07:10:28.8943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FV0tZyMGemrBkhPh4JnTADNF9x+kZRqJsWr+PRJe5gyRDC7YZBlrUzDrEyg3BI8UnKSP4DCQgfd7EqG9qa9RYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2413
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_02:2019-09-04,2019-09-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBLcnp5c3p0b2YgV2lsY3p5bnNraSA8a3N3aWxjenluc2tpQGdtYWlsLmNvbT4gT24g
QmVoYWxmIE9mIEtyenlzenRvZg0KPiBXaWxjenluc2tpDQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0K
PiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBNb3ZlIHRoZSBzdGF0aWMga2V5d29yZCB0byB0aGUgZnJv
bnQgb2YgZGVjbGFyYXRpb24gb2YgaXdhcnBfc3RhdGVfbmFtZXMsDQo+IGFuZCByZXNvbHZlIHRo
ZSBmb2xsb3dpbmcgY29tcGlsZXIgd2FybmluZyB0aGF0IGNhbiBiZSBzZWVuIHdoZW4gYnVpbGRp
bmcNCj4gd2l0aCB3YXJuaW5ncyBlbmFibGVkIChXPTEpOg0KPiANCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcWxvZ2ljL3FlZC9xZWRfaXdhcnAuYzozODU6MTogd2FybmluZzoNCj4gICDigJhzdGF0
aWPigJkgaXMgbm90IGF0IGJlZ2lubmluZyBvZiBkZWNsYXJhdGlvbiBbLVdvbGQtc3R5bGUtZGVj
bGFyYXRpb25dDQo+IA0KPiBBbHNvLCByZXNvbHZlIGNoZWNrcGF0Y2gucGwgc2NyaXB0IHdhcm5p
bmc6DQo+IA0KPiBXQVJOSU5HOiBzdGF0aWMgY29uc3QgY2hhciAqIGFycmF5IHNob3VsZCBwcm9i
YWJseSBiZQ0KPiAgIHN0YXRpYyBjb25zdCBjaGFyICogY29uc3QNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEtyenlzenRvZiBXaWxjenluc2tpIDxrd0BsaW51eC5jb20+DQo+IC0tLQ0KPiBSZWxhdGVk
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMTkwODI3MjMzMDE3LkdLOTk4N0Bnb29nbGUu
Y29tDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfaXdhcnAuYyB8
IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX2l3
YXJwLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWVkL3FlZF9pd2FycC5jDQo+
IGluZGV4IGYzODBmYWU4Nzk5ZC4uNjVlYzE2YTMxNjU4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9xbG9naWMvcWVkL3FlZF9pd2FycC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX2l3YXJwLmMNCj4gQEAgLTM4Miw3ICszODIsNyBAQCBx
ZWRfaXdhcnAycm9jZV9zdGF0ZShlbnVtIHFlZF9pd2FycF9xcF9zdGF0ZQ0KPiBzdGF0ZSkNCj4g
IAl9DQo+ICB9DQo+IA0KPiAtY29uc3Qgc3RhdGljIGNoYXIgKml3YXJwX3N0YXRlX25hbWVzW10g
PSB7DQo+ICtzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IGl3YXJwX3N0YXRlX25hbWVzW10gPSB7
DQo+ICAJIklETEUiLA0KPiAgCSJSVFMiLA0KPiAgCSJURVJNSU5BVEUiLA0KDQpUaGFua3MswqAN
Cg0KQWNrZWQtYnk6IE1pY2hhbCBLYWxkZXJvbsKgPG1pY2hhbC5rYWxkZXJvbkBtYXJ2ZWxsLmNv
bT4NCg0KDQo+IC0tDQo+IDIuMjIuMQ0KDQo=
