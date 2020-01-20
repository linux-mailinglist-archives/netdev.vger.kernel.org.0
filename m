Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEDB142732
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgATJYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:24:46 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:41827 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATJYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:24:45 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 04:24:44 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1126; q=dns/txt; s=iport;
  t=1579512284; x=1580721884;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=w5gy+mcO3Z007wJ0dmVi8kkf5xmjybGH+tMjTtxLK8M=;
  b=Q3LkZy1bcse4uUYH3/orRoHPE6FFF0eqOvPOh00oKdnhr+KmHT6CpGRE
   M5pxCdUj9VyRq9aKUaoRazCofPqd+kwji+e6abW83zTbwbIrz952YAXX8
   0yllRNdF0iJKb777zDUuIeAchkyvO2KDY5B9x9A/tQ4q+FZ7b237eXM0B
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3AwWOSiRMQBkMxMm0FzsQl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBj7IfH2cSE2AOxJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BICAC9biVe/5FdJa1lHQEBAQkBEQU?=
 =?us-ascii?q?FAYF7gVRQBWxYIAQLKoQSg0YDinyabYJSA1QJAQEBDAEBJwYCAQGEQBmBdiQ?=
 =?us-ascii?q?4EwIDDQEBBAEBAQIBBQRthTcBC4VhFhERDAEBNwERASICJgIEMBUSBA0BBwE?=
 =?us-ascii?q?BHoMEAYJKAy4BDp9iAoE5iGF1gTKCfwEBBYUHGIIMAwaBDiqFGwyGbRqBQT+?=
 =?us-ascii?q?BOII3By6BQgGBRhkEGoRXgl6NaYJsnwEKgjkEhlJnjm4GG5p3jl6IYZIlAgQ?=
 =?us-ascii?q?CBAUCDgEBBYFpIoFYcBWDJ1AYDYgBCQ8Lg1CFFIU/dAIBAQeBHowmAQE?=
X-IronPort-AV: E=Sophos;i="5.70,341,1574121600"; 
   d="scan'208";a="419520609"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 20 Jan 2020 09:17:38 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 00K9HckU012013
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 20 Jan 2020 09:17:38 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 20 Jan
 2020 03:17:37 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 20 Jan
 2020 03:17:37 -0600
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 20 Jan 2020 03:17:37 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVH5tnaIqc8WuxuXTd+gbafP3qHio0MlQ0HQ141sjiQH0zo4H2Mba9GsyDO3wNQ4LUU/sizIm8O+4767UXeKv+ttMDKTVx2nFwdhtMc2DoLl8g6j9beR2iPhfhgyCMbwtqKNirCwrkXL6jAEgisQ9LXzCy5agt4niXXd/Ah1aYLFsWdo/21mt4Usd1JlzCGmGxtj6CIQBlBqQPzZw6tTzJHndaphW+5PE0UQoX6R+5pdSDSsL/HBCURGsH1PVF6EYSo/X8Il0OSdQ3GD+MRAkUISE6tDan/8e8jeywZkd+vHeUYDVIPaseICs4mNR7tInmoEjJEcrKDMijsGXu0x0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5gy+mcO3Z007wJ0dmVi8kkf5xmjybGH+tMjTtxLK8M=;
 b=Czy8jl9khfLvZokWdoQA23fx6je0+pfbTFE+x5s3AiLgdViJKQ4nRDalP+84oLZ4mbThZRa4nNuSd4IZmR0KxoB/qlD/wt8PxLmVdJrbj1pivA2TkEZMkp/NkySNblrWrb+w3X7YQ5yE7P9Ox6KPe7iAIcNUrZBfIix6Zrt/Jyx8YHT1HRZqM8KxzO0GPKjqzMKYLY1uPS+UBCe1F3cBcKjPloR3td6SK5D+g6MZHjcVx1IMp4aFvwao/vcAcJFS+jjTyidEov3iMOygmTIorZDRiD068V+Ia/zErFvR5wH+8bynVvFMy26zgrvaks7ASU25zdugdrMEqXIWYo51OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5gy+mcO3Z007wJ0dmVi8kkf5xmjybGH+tMjTtxLK8M=;
 b=XoRd6gU1cihv/fmjy2C51Oz8CDMx3zBy7SdEaViFO7hNiCEs3RFC8YaF/Hb3KmBDPGYMIae0S85ywgzrGceNLSk4bNcg0GXlPVrFP0KZuFbVNdK6anzA2NjB6KSAv7GjHOqDuLkyzKXuoXx5FcNiJuPkniA3h/sMfw4i6qCpLNY=
Received: from BY5PR11MB3862.namprd11.prod.outlook.com (10.255.72.11) by
 BY5PR11MB4372.namprd11.prod.outlook.com (52.132.252.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 09:17:36 +0000
Received: from BY5PR11MB3862.namprd11.prod.outlook.com
 ([fe80::8417:581e:6261:a36a]) by BY5PR11MB3862.namprd11.prod.outlook.com
 ([fe80::8417:581e:6261:a36a%3]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 09:17:36 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Regression in macvlan driver in stable release 4.4.209
Thread-Topic: Regression in macvlan driver in stable release 4.4.209
Thread-Index: AQHVz3JzO8uHcCgc5kms+UsvKqCsCw==
Date:   Mon, 20 Jan 2020 09:17:35 +0000
Message-ID: <01accb3f-bb52-906f-d164-c49f2dc170bc@cisco.com>
Accept-Language: en-DK, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hegtvedt@cisco.com; 
x-originating-ip: [2001:420:44c1:2578:965c:d737:527:20d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6cb5de9-530d-4f3e-67c1-08d79d8996c8
x-ms-traffictypediagnostic: BY5PR11MB4372:
x-microsoft-antispam-prvs: <BY5PR11MB4372BC322DD62152350ED9C0DD320@BY5PR11MB4372.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(199004)(189003)(6486002)(31696002)(86362001)(4326008)(2906002)(5660300002)(4744005)(31686004)(54906003)(6916009)(91956017)(76116006)(316002)(6506007)(186003)(36756003)(6512007)(8676002)(478600001)(71200400001)(2616005)(66446008)(8936002)(81156014)(966005)(66946007)(66556008)(66476007)(64756008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR11MB4372;H:BY5PR11MB3862.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xCFilK9dNDgaNZ5jgj7TBqUTtdH2BxhrLaZYSrTyPkNl+s5Bg7i+uGOupM/ibKHmPKObAS50aSmCARLKfcpZNteovLmFJhuV0GJLsezjxWagVIDlo/tsIoyn4hOU5+MB36NcfvbCrQJ+iKPVzhZVDUUGlNGlA+e003zmpAmc3znJ3J1ciOjjsqoAZ91wkBt2hB3pKI/Ah/SC+ksxL2EyFLwmpCurgkibX17zQ0B8SQPEB8yVvNho2wmVqEHPMEN7f0dUDG8q+L+BjM0S65x62Vy2Nnf9z/7tautbtK0mhDndHQZ+4o7OZlsPyusNIQyFG8Mv1g4j9Y9djK7fKVKjYPlZMmX1j032i5QrecDcC28JGJvJwz3e174uIFk8L9YxYBWoVvwCpmB4gSdQ01jdt2p4is5ZA7wk9hjPHPuG133t2ef+YUjKIP8CbRuZkRTjhUq3S96NKivDZKHht66ha1NoPojNjWlxTcsvDwNwgu8bcuvU9o2kOLKPFwJRO+w0jO5JBg0N5LQYvChnKdzL1g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <978549D51982604CBFF22E5D4DB104ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cb5de9-530d-4f3e-67c1-08d79d8996c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 09:17:35.6434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I0jPbQAQgRnYl5e4oiwhs18T20IsldnsfgNQhxB61uxl4dfA8QvaqivcCE7y2FtSJWkDgrbS8e/OOPTE7uAeSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4372
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCkkgYW0gc2VlaW5nIGEgcmVncmVzc2lvbiBpbiB0aGUgbWFjdmxhbiBrZXJuZWwg
ZHJpdmVyIGFmdGVyIExpbnV4IHN0YWJsZSANCnJlbGVhc2UgNC40LjIwOSwgYmlzZWN0aW5nIGlk
ZW50aWZpZXMgY29tbWl0IA0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvc3RhYmxlL2xpbnV4LmdpdC9jb21taXQvP2g9bGludXgtNC40LnkmaWQ9OGQyOGQ3
ZTg4ODUxYjEwODFiMDVkYzI2OWEyN2RmMWM4YTkwM2YzZQ0KDQpUaGVyZSBzZWVtcyB0byBiZSBh
IGhpc3RvcnkgYmVoaW5kIHRoaXMsIGFuZCBJIGRvIG5vdCBoYXZlIHRoZSBmdWxsIA0Kb3ZlcnZp
ZXcgb2YgdGhlIGludGVudGlvbiBiZWhpbmQgdGhlIGNoYW5nZS4NCg0KV2hhdCBJIHNlZSBvbiBt
eSB0YXJnZXQsIEFhcmNoNjQgQ1BVLCBpcyB0aGF0IHRoaXMgcGF0Y2ggbW92ZXMgdGhlIGV0aCAN
CnBvaW50ZXIgaW4gbWFjdmxhbl9icm9hZGNhc3QoKSBmdW5jdGlvbiBzb21lIGJ5dGVzLiBUaGlz
IHdpbGwgY2F1c2UgDQpldmVyeXRoaW5nIHdpdGhpbiB0aGUgZXRoaGRyIHN0cnVjdCB0byBiZSB3
cm9uZyBBRkFJQ1QuDQoNCkFuIGV4YW1wbGU6DQpPcmlnaW5hbCBjb2RlICJldGggPSBldGhfaGRy
KHNrYikiDQogICAgZXRoID0gZmZmZmZmYzAwN2ExYjAwMg0KTmV3IGNvZGUgImV0aCA9IHNrYl9l
dGhfaGRyKHNrYikiDQogICAgZXRoID0gZmZmZmZmYzAwN2ExYjAxMA0KDQpMZXQgbWUga25vdyBp
ZiBJIGNhbiBhc3Npc3QgaW4gYW55IHdheS4NCg0KLS0gDQpCZXN0IHJlZ2FyZHMsDQpIYW5zLUNo
cmlzdGlhbiBOb3JlbiBFZ3R2ZWR0DQo=
