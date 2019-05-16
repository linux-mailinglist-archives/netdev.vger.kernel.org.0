Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAD20A27
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfEPOwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 10:52:22 -0400
Received: from mail-eopbgr690082.outbound.protection.outlook.com ([40.107.69.82]:49017
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfEPOwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 10:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIIdObAOted1+rjqWzICMsPRRNqK5OdW5/2CrPjOX/k=;
 b=sIPg0QfPe9Be94tPhGsu4whVpaFgMPQ4oXsEhjLE+pZHC7LbnpT/7ZZebc4hEsYQu77dFUWE2FnhKcG5hFff29YADdLngjpoNY3jvuOK6FhHQ1ouI+LUVRXysLMp+j2XmEwvKLMS9P8lphB6aQNbLORcpxzyIqbwSkJ9exV0qXA=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3659.namprd11.prod.outlook.com (20.178.231.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 14:52:18 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 14:52:18 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 0/3] aqc111: revert endianess fixes and cleanup mtu logic
Thread-Topic: [PATCH net 0/3] aqc111: revert endianess fixes and cleanup mtu
 logic
Thread-Index: AQHVC/b1PV+w2kCA3k+U61CtBuK4Pw==
Date:   Thu, 16 May 2019 14:52:18 +0000
Message-ID: <cover.1558017386.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0010.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::20)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6432c361-cf2f-4503-ee65-08d6da0e1791
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3659;
x-ms-traffictypediagnostic: DM6PR11MB3659:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR11MB365944108E39A80581DF65BC980A0@DM6PR11MB3659.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(136003)(346002)(396003)(376002)(189003)(199004)(53936002)(6436002)(4744005)(99286004)(54906003)(316002)(14454004)(2906002)(6306002)(50226002)(6512007)(6486002)(73956011)(966005)(478600001)(86362001)(5660300002)(8936002)(305945005)(66066001)(102836004)(72206003)(476003)(81166006)(2616005)(36756003)(66446008)(64756008)(66556008)(7736002)(68736007)(81156014)(66476007)(8676002)(3846002)(26005)(6916009)(44832011)(52116002)(71190400001)(71200400001)(107886003)(66946007)(6116002)(486006)(256004)(186003)(4326008)(386003)(6506007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3659;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AUnRD++7MJhwa1yh/eRfeb0/oSBmC/LqFT4t6WFqTcR6q4I7GlTr00Ghltj1+AFiOmylRJ1Cr7fIWex9Uq5JXe633vilguJrmAgnen2gSVdiwbnv0Ko8BGFdDAjpJmx+Gey/MdWQC90oVk4r+Z0F/VeZ621cRHH2geWYBtUxOOhdW2MrrD1r9N7r6vaFGg5kTeAYPNoiBg5dqz15xgpSyknqBW4m3ZO7idPt87LSfkEAslZC4UViVFIU1Iecr5mRzQKlsIf6RZh/5oY1k2kUxqGflkTNyIjQzqBcMdC5lgq/fULPM08ckk7ON9dBoUtZk3Vy5sG6F8uXUlwFz88Hd9dSt3cvpnHSNf5QLIHOtgSL++rjNMyl+ThIFmYcZLbBXSRP0BAmNpjYCaapF2WK/QnOdXJPg8rwWW64Sow6wZo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6432c361-cf2f-4503-ee65-08d6da0e1791
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 14:52:18.4258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNClRoaXMgcmV2ZXJ0cyBuby1vcCBjb21taXRzIGFzIGl0IHdhcyBkaXNjdXNzZWQ6
DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8xNTU3ODM5NjQ0LjExMjYxLjQuY2Ft
ZWxAc3VzZS5jb20vDQoNCkZpcnN0IGFuZCBzZWNvbmQgb3JpZ2luYWwgcGF0Y2hlcyBhcmUgYWxy
ZWFkeSBkcm9wcGVkIGZyb20gc3RhYmxlLA0KTm8gbmVlZCB0byBzdGFibGUtcXVldWUgdGhlIHRo
aXJkIHBhdGNoIGFzIGl0IGhhcyBubyBmdW5jdGlvbmFsIGltcGFjdCwNCmp1c3QgYSBsb2dpYyBj
bGVhbnVwLg0KDQpJZ29yIFJ1c3NraWtoICgzKToNCiAgUmV2ZXJ0ICJhcWMxMTE6IGZpeCBkb3Vi
bGUgZW5kaWFubmVzcyBzd2FwIG9uIEJFIg0KICBSZXZlcnQgImFxYzExMTogZml4IHdyaXRpbmcg
dG8gdGhlIHBoeSBvbiBCRSINCiAgYXFjMTExOiBjbGVhbnVwIG10dSByZWxhdGVkIGxvZ2ljDQoN
CiBkcml2ZXJzL25ldC91c2IvYXFjMTExLmMgfCAzNSArKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyNSBkZWxldGlv
bnMoLSkNCg0KLS0gDQoyLjE3LjENCg0K
