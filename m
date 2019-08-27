Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4859F178
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfH0RYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 13:24:15 -0400
Received: from mail-eopbgr720064.outbound.protection.outlook.com ([40.107.72.64]:35111
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727057AbfH0RYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 13:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc0b/wUKmW3Jnsh6INcy/iCfW3keeBXNucKMAnsJ7vXgy5/Jj5cFjob42cSM5ICUiJHw8rX1sm2vR10jhSoA8bufMS5xiII5YmdXP54rjzMepnL5b2lEs36kodlB2l8RwYvZn2PfRGhRToQR9djjKUD21Lnqq5tVVV1Q3K+zYbEUIMn7SRTKkAXXUAVeZ6bBlSXsl/J9bjtp/+vcHqKLXIAqP8Z10avKl4Pcmo6YPBfPCeR1qKW1vSQtklBWogor1JWUjy567nObTKHvt/xFvugaSpKwrH17qbt9Fu6Yn5al29T7hwou7M8gEMCgaVGFE+lnq1JzXeo7U6DeVp5W2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQD3r5+lhnyWR9gNk+pyBbBR7iZS8FJdHOOHJm62+cI=;
 b=hHmyj8RVru92IHsYTDyVLzDBkt2xBbxqD/qmi1CE7iNltgIsbeGwryXI4nvH/NqNGMRrTliwmodtG8Zu4UEHc4JDKt8Sdfj6jAo2sRb+jjcDJ/yGYbd2dJFoFsfzVoem/hViUELxJ/fm6Aq9ZBo+/786C6fwzYl4UiEoOg5LYzmYOgBkxhKQSJbKgsZjOCBvu+mWPMgRkkF2L8kmlkkKjZuXFER1NKCa+/Y3/1cXq70d0Vv7dv9XD9cMQIDVVc4H1IiN5DXzWQddPHrKLMdu7u49Y8hcunQl81WEZ9vVzJfrAtAMB00kGsd9XRPCGmvKYydgIgDvTYfB9Kx8yJM+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQD3r5+lhnyWR9gNk+pyBbBR7iZS8FJdHOOHJm62+cI=;
 b=eqPUK1ljW2X2L+vvR71dDS+7/Icz5Uqs+hAv7SVatLdcMMBN3kbmW5kgVFKstYqVIH1rU/1/amezMzJuGgygNprs4d+HzWl7KSW40WVCHAasUQb9BZYZ5c4rXOwi5V0nXDkgeMOxuCDOSUSM2QWMifpWT55PTZgesEkvH/9dXJY=
Received: from DM6PR10MB3548.namprd10.prod.outlook.com (20.179.55.82) by
 DM6PR10MB2825.namprd10.prod.outlook.com (20.177.216.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 17:24:12 +0000
Received: from DM6PR10MB3548.namprd10.prod.outlook.com
 ([fe80::fc74:7d8b:ad3e:7b8b]) by DM6PR10MB3548.namprd10.prod.outlook.com
 ([fe80::fc74:7d8b:ad3e:7b8b%3]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 17:24:12 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
Thread-Topic: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
Thread-Index: AQHVXLIZy/K5JiGguEabjs4Jnc4A4qcPOmyAgAAEqoA=
Date:   Tue, 27 Aug 2019 17:24:12 +0000
Message-ID: <db87d29f160302789f239cda2074ed35ae67da62.camel@infinera.com>
References: <8dad6e3cf2e6cb0086b0a6f75ccdb44822a15001.camel@infinera.com>
         <20190827170729.GD21369@kroah.com>
In-Reply-To: <20190827170729.GD21369@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39487cd7-12b5-46c4-ebb1-08d72b1360c1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR10MB2825;
x-ms-traffictypediagnostic: DM6PR10MB2825:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR10MB28251D7335146B82FFC6CE41F4A00@DM6PR10MB2825.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(199004)(189003)(36756003)(25786009)(486006)(66476007)(91956017)(66556008)(64756008)(66446008)(76116006)(66946007)(11346002)(446003)(86362001)(53936002)(5660300002)(6306002)(71200400001)(71190400001)(3846002)(476003)(6116002)(478600001)(2906002)(4326008)(2501003)(2616005)(45080400002)(6436002)(81166006)(81156014)(8936002)(26005)(66066001)(8676002)(6506007)(14454004)(6512007)(118296001)(102836004)(110136005)(305945005)(316002)(99286004)(7736002)(229853002)(76176011)(966005)(4744005)(186003)(256004)(6246003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR10MB2825;H:DM6PR10MB3548.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y8XPU8s8dexh+w4I596KdR9lwtYt2xV5wEU+ImYxq+oaaDqFNmiO7BaoLrZ1mjx1nSwoYZpJmsW+ItuDA5gPV/S+fG9Stry3qRCXa4X7HwC6vTVAlhbr6G+/pIIvGIpBEXvhmnrw2xUTLM4lVsa6nJWxPcSzltAMI2z2U6L/if+Dl3a+/tdCjV3VsbHwDiZvaLQhoEawZRB/j48g5Ix1lhxWvhzEt1gb/ltYR+FdtASNoS1pJJi4lAiIYus7PLwl2l4JzfD853P0DcCLZPXSkFJ2Zw9x9R+NVHoHmZ6pRluHR8W+B+6BObVOeVyFRoU5jiQsRe2UKx3sGNkRu2iv1tJ04Ol/mTotjEbPFbq9NkbBIsMpMKIuBrhdnME/j5/Zw+XxJOYD2xT17VHeocOyJ49huYCfmWWB7Kc9YPA3Nd8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3ECAA8CB7A8AA4EA19CB021430AE0BD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39487cd7-12b5-46c4-ebb1-08d72b1360c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 17:24:12.2819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyXOs3FJCz7L4sjUJlqxfqDJDDEQ9zWvCgfIfeeSohqn0f6wxA0bWcAFt8WO1HfWtsQLI7WidgQ3GKeLK7sBjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2825
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTI3IGF0IDE5OjA3ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiANCj4g
T24gVHVlLCBBdWcgMjcsIDIwMTkgYXQgMDg6MzM6MjhBTSArMDAwMCwgSm9ha2ltIFRqZXJubHVu
ZCB3cm90ZToNCj4gPiBJIGRvbid0IHNlZSB0aGUgYWJvdmUgcGF0Y2ggaW4gc3RhYmxlIHlldCwg
aXMgaXQgc3RpbGwgcXVldWVkPw0KPiA+IGh0dHBzOi8vbmFtMDMuc2FmZWxpbmtzLnByb3RlY3Rp
b24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnd3dy5zcGluaWNzLm5ldCUyRmxpc3Rz
JTJGbmV0ZGV2JTJGbXNnNTc5NTgxLmh0bWwmYW1wO2RhdGE9MDIlN0MwMSU3Q0pvYWtpbS5UamVy
bmx1bmQlNDBpbmZpbmVyYS5jb20lN0NlNzBlZmEyN2Q5MGI0ZWVjYjFjZjA4ZDcyYjExMGU3OCU3
QzI4NTY0M2RlNWY1YjRiMDNhMTUzMGFlMmRjOGFhZjc3JTdDMSU3QzElN0M2MzcwMjUyMjQ1NzQy
MTY1MzEmYW1wO3NkYXRhPU1odTBCcWxNMjFYWFlkUiUyQkMlMkY4d1hyTWt6QktKcEtVWlpaWHo1
N3NBeXVRJTNEJmFtcDtyZXNlcnZlZD0wDQo+IA0KPiBBc2sgdGhlIG5ldHdvcmsgZGV2ZWxvcGVy
cyA6KQ0KDQpPSywgYXNraW5nIG5ldGRldiB0aGVuLg0KDQogSm9ja2UNCg==
