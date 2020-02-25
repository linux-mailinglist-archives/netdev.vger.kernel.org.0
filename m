Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03F916B949
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBYFq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:46:56 -0500
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:6043
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbgBYFq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 00:46:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abclxvFUrOWYSawqDJwBW6QboySIbIJQoxSdwoFmVErKh827DYFPJlxFIpCiVSXA9AY1eAlhHE9WCHdbVlaCabL4yhYphjGUBWo3kHEyjckCmUPFvIvfcd32H/CvMMZKaZt34U7zia3YFZIgQ/tLAQ23Gq1aCx47Cuur1zrK0yitveOjzagZJDLlxXm8OimtS3QvsqLe0EJz/QzlmYDREifFdOhM3C1g2GdipA2qFdK92Ui3bS1AfDqu0E3k0TtdbghWJpPTMLF4SdpPhAK3DjdxkVelhh3Y3A+YL1wgId4Q0x44YhzuJCpJSUIvp41vZRcpJPt9kXFaie9ck5226w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC1MOtrTWPcJe98sMVqClYOp0m3PqeDoWXJZYSOXZmY=;
 b=VUKBrkUA7Kc3AKfSjoQeUwaGPv7oY7Mwy4FHR1bpUSh5DIpJlIqv0TMAs56+Vp1YTa5V0SGrCzBNqv/w8ML0qtttBUaB8tW9owRiriDUxAQ6F1qspIAgBDJLbZ8bwcH3PloJnrC5H34McrpW7jhJtcHJl4CPeFRqCHNd0K33/b9Y2r5EQzPjV2F+FtW+9IH45EveOtR7O4TC3TF8f57aGUE8pWLxy71OEhA0E8o6mgHDr/XiwDPOcMme4aSnnYigJEQyfTImVvvYhSB1EA2vzbQ17nFmXro4k73BK5NLLL6ukY+jlo70LCgZlz0chTg4TnDga0HZSgWN9+MtJUGFWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC1MOtrTWPcJe98sMVqClYOp0m3PqeDoWXJZYSOXZmY=;
 b=hL4L96fVoOt/n4LuH2VxeVIDyANzvGyNtJITdK7g+biEli2CjxpBdi6ah/LznU8ahdYfANMnR87zWyRTjoIso+d91zKKxTJRsN99zTbtu4UwnVSjYPKwAkwTlV5ixVVN7Qul7Ti9qghXUCjxdjD8o3EkRJHN6eC7bbfRNjsdjrI=
Received: from SN6PR05MB4237.namprd05.prod.outlook.com (2603:10b6:805:27::32)
 by SN6PR05MB5519.namprd05.prod.outlook.com (2603:10b6:805:c7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.9; Tue, 25 Feb
 2020 05:46:42 +0000
Received: from SN6PR05MB4237.namprd05.prod.outlook.com
 ([fe80::4da8:aefe:5436:af32]) by SN6PR05MB4237.namprd05.prod.outlook.com
 ([fe80::4da8:aefe:5436:af32%4]) with mapi id 15.20.2772.012; Tue, 25 Feb 2020
 05:46:42 +0000
From:   Rajender M <manir@vmware.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Performance impact in networking data path tests in Linux 5.5 Kernel
Thread-Topic: Performance impact in networking data path tests in Linux 5.5
 Kernel
Thread-Index: AQHV6wVoaIB7e06hTEGauTCQiUGTXA==
Date:   Tue, 25 Feb 2020 05:46:41 +0000
Message-ID: <C7D5F99D-B8DB-462B-B665-AE268CDE90D2@vmware.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=manir@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0aef368-ad2a-441c-a1e7-08d7b9b6173f
x-ms-traffictypediagnostic: SN6PR05MB5519:
x-microsoft-antispam-prvs: <SN6PR05MB55194CD02D98B55FAE19C5CED6ED0@SN6PR05MB5519.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(199004)(189003)(66946007)(2906002)(4326008)(36756003)(76116006)(6512007)(66556008)(66476007)(6486002)(26005)(186003)(66446008)(91956017)(64756008)(6506007)(71200400001)(478600001)(81166006)(81156014)(33656002)(2616005)(316002)(8936002)(54906003)(86362001)(8676002)(5660300002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5519;H:SN6PR05MB4237.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VvXeSRV4bjBGZ2RmS77lSYafRB444vtqIy/BLq8VOJmchcVjnmfgghJGc6UpRmDDMsae89P7xRdIVRLvn7HxSgvnLtM80wyKSm6ml9o3nQQZ5vFJzuPkzcogQbP2K5+MjMfhoBiXby8Qcy/53oQo6ZytW1pfNj8l3JsCNQkniYK3TAb8JC4LPoq7Dc0KeIK45+EJeA8DhUftpapaVGleMe+jnTDB4JPJvxN7PoOLGhvOiYZTSBXr396FeqR967IlxQKTDZkG645MInTt5I/vDFcLxRxD1/3r5Qxv5sENLpKbmqixJkVnuJF351Xbey7JcDtXD/R6igA9XBCILYcbFbnJXtULTn3yNgsxEfg9FvpHl4wkt7ID0PD/Xch8zWM8ufNjQfYhpOpc5vzLIoSVvH5KdC8ccHxZXfYvHMSq/fu2UwD93FA9ZNKDe8vG7zXY
x-ms-exchange-antispam-messagedata: 6FH8yZtHlYT0PAJDjj2Rn2IGl0PvVq5fmlARpOQv6z3l/R5cNnksiqQcRB8G1A2UAjij79wuIBnOacif9quXe6TWV3ebvUJrPxDo0RhXnPuj/KlbFr9LO6FFzwFAIv23LLp1NnhHR02Z3gS6VhSRoA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <138DFD3516CB2343A670B2253A68C154@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0aef368-ad2a-441c-a1e7-08d7b9b6173f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 05:46:41.9967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IA9vimh4V1/e8v3N672hxyOkIeOWsupONmxbm8NzmsugkdyrKNVECp+yIPMFPr34pj3JLPtakYCAQmaI86lvuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5519
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgcGFydCBvZiBWTXdhcmUncyBwZXJmb3JtYW5jZSByZWdyZXNzaW9uIHRlc3RpbmcgZm9yIExp
bnV4IEtlcm5lbCB1cHN0cmVhbQ0KIHJlbGVhc2VzLCB3aGVuIGNvbXBhcmluZyBMaW51eCA1LjUg
a2VybmVsIGFnYWluc3QgTGludXggNS40IGtlcm5lbCwgd2Ugbm90aWNlZCANCjIwJSBpbXByb3Zl
bWVudCBpbiBuZXR3b3JraW5nIHRocm91Z2hwdXQgcGVyZm9ybWFuY2UgYXQgdGhlIGNvc3Qgb2Yg
YSAzMCUgDQppbmNyZWFzZSBpbiB0aGUgQ1BVIHV0aWxpemF0aW9uLg0KDQpBZnRlciBwZXJmb3Jt
aW5nIHRoZSBiaXNlY3QgYmV0d2VlbiA1LjQgYW5kIDUuNSwgd2UgaWRlbnRpZmllZCB0aGUgcm9v
dCBjYXVzZSANCm9mIHRoaXMgYmVoYXZpb3VyIHRvIGJlIGEgc2NoZWR1bGluZyBjaGFuZ2UgZnJv
bSBWaW5jZW50IEd1aXR0b3QncyANCjJhYjQwOTJmYzgyZCAoInNjaGVkL2ZhaXI6IFNwcmVhZCBv
dXQgdGFza3MgZXZlbmx5IHdoZW4gbm90IG92ZXJsb2FkZWQiKS4NCg0KVGhlIGltcGFjdGVkIHRl
c3RjYXNlcyBhcmUgVENQX1NUUkVBTSBTRU5EICYgUkVDViDigJMgb24gYm90aCBzbWFsbCANCig4
SyBzb2NrZXQgJiAyNTZCIG1lc3NhZ2UpICYgbGFyZ2UgKDY0SyBzb2NrZXQgJiAxNksgbWVzc2Fn
ZSkgcGFja2V0IHNpemVzLg0KDQpXZSBiYWNrZWQgb3V0IFZpbmNlbnQncyBjb21taXQgJiByZXJh
biBvdXIgbmV0d29ya2luZyB0ZXN0cyBhbmQgZm91bmQgdGhhdCANCnRoZSBwZXJmb3JtYW5jZSB3
ZXJlIHNpbWlsYXIgdG8gNS40IGtlcm5lbCAtIGltcHJvdmVtZW50cyBpbiBuZXR3b3JraW5nIHRl
c3RzIA0Kd2VyZSBubyBtb3JlLg0KDQpJbiBvdXIgY3VycmVudCBuZXR3b3JrIHBlcmZvcm1hbmNl
IHRlc3RpbmcsIHdlIHVzZSBJbnRlbCAxMEcgTklDIHRvIGV2YWx1YXRlIA0KYWxsIExpbnV4IEtl
cm5lbCByZWxlYXNlcy4gSW4gb3JkZXIgdG8gY29uZmlybSB0aGF0IHRoZSBpbXBhY3QgaXMgYWxz
byBzZWVuIGluIA0KaGlnaGVyIGJhbmR3aWR0aCBOSUMsIHdlIHJlcGVhdGVkIHRoZSBzYW1lIHRl
c3QgY2FzZXMgd2l0aCBJbnRlbCA0MEcgYW5kIA0Kd2Ugd2VyZSBhYmxlIHRvIHJlcHJvZHVjZSB0
aGUgc2FtZSBiZWhhdmlvdXIgLSAyNSUgaW1wcm92ZW1lbnRzIGluIA0KdGhyb3VnaHB1dCB3aXRo
IDEwJSBtb3JlIENQVSBjb25zdW1wdGlvbi4NCg0KVGhlIG92ZXJhbGwgcmVzdWx0cyBpbmRpY2F0
ZSB0aGF0IHRoZSBuZXcgc2NoZWR1bGVyIGNoYW5nZSBoYXMgaW50cm9kdWNlZCANCm11Y2ggYmV0
dGVyIG5ldHdvcmsgdGhyb3VnaHB1dCBwZXJmb3JtYW5jZSBhdCB0aGUgY29zdCBvZiBpbmNyZW1l
bnRhbCANCkNQVSB1c2FnZS4gVGhpcyBjYW4gYmUgc2VlbiBhcyBleHBlY3RlZCBiZWhhdmlvciBi
ZWNhdXNlIG5vdyB0aGUgDQpUQ1Agc3RyZWFtcyBhcmUgZXZlbmx5IHNwcmVhZCBhY3Jvc3MgYWxs
IHRoZSBDUFVzIGFuZCBldmVudHVhbGx5IGRyaXZlcyANCm1vcmUgbmV0d29yayBwYWNrZXRzLCB3
aXRoIGFkZGl0aW9uYWwgQ1BVIGNvbnN1bXB0aW9uLg0KDQoNCldlIGhhdmUgYWxzbyBjb25maXJt
ZWQgdGhpcyB0aGVvcnkgYnkgcGFyc2luZyB0aGUgRVNYIHN0YXRzIGZvciA1LjQgYW5kIDUuNSAN
Cmtlcm5lbHMgaW4gYSA0dkNQVSBWTSBydW5uaW5nIDggVENQIHN0cmVhbXMgLSBhcyBzaG93biBi
ZWxvdzsNCg0KNS40IGtlcm5lbDoNCsKgICIyMTMyMTQ5IjogeyJpZCI6IDIxMzIxNDksICJ1c2Vk
IjogOTQuMzcsICJyZWFkeSI6IDAuMDEsICJjc3RwIjogMC4wMCwgIm5hbWUiOiAidm14LXZjcHUt
MDpyaGVsN3g2NC0wIiwNCsKgICIyMTMyMTUxIjogeyJpZCI6IDIxMzIxNTEsICJ1c2VkIjogMC4x
MywgInJlYWR5IjogMC4wMCwgImNzdHAiOiAwLjAwLCAibmFtZSI6ICJ2bXgtdmNwdS0xOnJoZWw3
eDY0LTAiLA0KwqAgIjIxMzIxNTIiOiB7ImlkIjogMjEzMjE1MiwgInVzZWQiOiA5LjA3LCAicmVh
ZHkiOiAwLjAzLCAiY3N0cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTI6cmhlbDd4NjQtMCIs
DQrCoCAiMjEzMjE1MyI6IHsiaWQiOiAyMTMyMTUzLCAidXNlZCI6IDM0Ljc3LCAicmVhZHkiOiAw
LjAxLCAiY3N0cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTM6cmhlbDd4NjQtMCIsDQoNCjUu
NSBrZXJuZWw6DQrCoCAiMjEzMjA0MSI6IHsiaWQiOiAyMTMyMDQxLCAidXNlZCI6IDU1LjcwLCAi
cmVhZHkiOiAwLjAxLCAiY3N0cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTA6cmhlbDd4NjQt
MCIsDQrCoCAiMjEzMjA0MyI6IHsiaWQiOiAyMTMyMDQzLCAidXNlZCI6IDQ3LjUzLCAicmVhZHki
OiAwLjAxLCAiY3N0cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTE6cmhlbDd4NjQtMCIsDQrC
oCAiMjEzMjA0NCI6IHsiaWQiOiAyMTMyMDQ0LCAidXNlZCI6IDc3LjgxLCAicmVhZHkiOiAwLjAw
LCAiY3N0cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTI6cmhlbDd4NjQtMCIsDQrCoCAiMjEz
MjA0NSI6IHsiaWQiOiAyMTMyMDQ1LCAidXNlZCI6IDU3LjExLCAicmVhZHkiOiAwLjAyLCAiY3N0
cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTM6cmhlbDd4NjQtMCIsDQoNCk5vdGUsICJ1c2Vk
ICUiIGluIGFib3ZlIHN0YXRzIGZvciA1LjUga2VybmVsIGlzIGV2ZW5seSBkaXN0cmlidXRlZCBh
Y3Jvc3MgYWxsIHZDUFVzLsKgDQoNCk9uIHRoZSB3aG9sZSwgdGhpcyBjaGFuZ2Ugc2hvdWxkIGJl
IHNlZW4gYXMgYSBzaWduaWZpY2FudCBpbXByb3ZlbWVudCBmb3IgDQptb3N0IGN1c3RvbWVycy4N
Cg0KUmFqZW5kZXIgTQ0KUGVyZm9ybWFuY2UgRW5naW5lZXJpbmcNClZNd2FyZSwgSW5jLg0KDQo=
