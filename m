Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD8F973C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKLRfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:35:21 -0500
Received: from alln-iport-1.cisco.com ([173.37.142.88]:26091 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfKLRfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:35:20 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 12:35:18 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1356; q=dns/txt; s=iport;
  t=1573580118; x=1574789718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7Unz7nbgza3kY796VeNSUaH1cru6qflkTg2MKexK1XA=;
  b=JU9gk9OPxzNZi173H2N/sy+7HCd5K5AXuETSJZrvGNiMBWT52Jx5WPvb
   lbp+iEm3rdEat7yYZ2HVgzME0b2CB8Oa1SaudR+qd/JqFp4XA/ONTgB3X
   rikRKgiklKvOjk0sfGkHTmML1bJ38fzVxJeKrU1QUtqC6E1AowNoY5fFb
   Y=;
IronPort-PHdr: =?us-ascii?q?9a23=3ARw0XTBJEmEsevpaNu9mcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXE3hJfvmZjc7NM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CmAACN6spd/5pdJa1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWwFAQELAYFKUAWBRCAECyqEKYNGA4pxgl6YAIEuFIEQA1QJAQE?=
 =?us-ascii?q?BDAEBLQIBAYRAAheCBiQ2Bw4CAwsBAQQBAQECAQUEbYULByUMhVIBAQECARI?=
 =?us-ascii?q?REQwBATcBDwIBCBoCJgICAjAVEAIEAQ0ngwCCRwMOIAGkRgKBOIhgdYEygn4?=
 =?us-ascii?q?BAQWFCBiCFwmBDigBjBMYgUA/gTgfgkw+hC4XgxAygiyQDJ4ICh2CCJVEG5l?=
 =?us-ascii?q?5im+DWJl2AgQCBAUCDgEBBYFZDiSBWHAVZQGCQVARFIE/jneDc4pTdIEokDY?=
 =?us-ascii?q?BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,297,1569283200"; 
   d="scan'208";a="362420705"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 12 Nov 2019 17:28:09 +0000
Received: from XCH-RCD-003.cisco.com (xch-rcd-003.cisco.com [173.37.102.13])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id xACHS7Zl027365
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 12 Nov 2019 17:28:08 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-RCD-003.cisco.com
 (173.37.102.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 11:28:06 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 11:28:06 -0600
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 12 Nov 2019 11:28:06 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUuI+hCUVpQxjRd/WUSahPA6804SdCCjQMyU3y39f3KjnqrUUyrg8v70MO7B8KuCEbTf+bfid8Cj+oOqYvyhuZbFgX56fTtV/jizpBjhZQNu2Jh5fyNkL02e2FruETZ7zCswi6BK+SBhzSg8qWURf0ktWStrACnp3ZA8NGvkT9LBdiTQhOLtZvycDMlfbkePs6tm68aHA9rT0ZtXwGR4Wz3BnDdHRzjLdnU8TlJT4jb4Yc3HS4zNTPmohEZLKkh7IbmHhtw/PvGNOG+Eshw8Yq/yt18qkBhwNKogQpSERZU7xzlvAvwSeSPhg6WlLCt/xJjumCrj44HQTiMAn/rjSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Unz7nbgza3kY796VeNSUaH1cru6qflkTg2MKexK1XA=;
 b=nkIUW6eLXtbKTk7wgqJ52N+VN2YlLBUvI+gtTp8E+xeI6O5AgwzJfed7afxgPJM8FgQovUf54xsfBrb7VMfsgAAVVcz+OKP8jc8S5y+y/4RWJ9sHtCMpiQj4Hsen4zV9l42uZ0YjDQ+724aZ9c3FzWRZpR31o3P8/YBdmF8QqBCA9AUvgLn4HkhA+dbIObjV3PMBoVeluwVPn75zkL+odzc15K9ehrsoP9wDDlvbQqqBTPprTlFyPoRZt7bo1PPcz3IXt/Fd4NFVMsA/U5Bsky3IIDzHcs/Ij/lJlZFjQYPAIX3KEY0kAX8sISxOimrc/ZamlCs1AiV5iMAHRhqJsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Unz7nbgza3kY796VeNSUaH1cru6qflkTg2MKexK1XA=;
 b=m4FcKOxmQgWStNWDWgTyn/99Pa9sG50O4+FmrQbcSn5ixjl1zbhB5hIrQCSHPwyXHVrZB2I33v3RpENsD9bvfMeDTyV4VAbODU1qhgxlaYVM7/gPOiL1w/xjp02Egu603vjawLm8okIJCu9W+OJl1wB7GIUULmGahGuBkfFrjpg=
Received: from CY4PR1101MB2311.namprd11.prod.outlook.com (10.174.53.140) by
 CY4PR1101MB2358.namprd11.prod.outlook.com (10.173.193.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 17:28:04 +0000
Received: from CY4PR1101MB2311.namprd11.prod.outlook.com
 ([fe80::703d:f3d9:40d4:55fc]) by CY4PR1101MB2311.namprd11.prod.outlook.com
 ([fe80::703d:f3d9:40d4:55fc%5]) with mapi id 15.20.2451.023; Tue, 12 Nov 2019
 17:28:04 +0000
From:   "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES HOLDINGS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmXjf3wbj+LJfjk+2lQ/PEvIoiqeIHUyA//+nmACAAGFwgA==
Date:   Tue, 12 Nov 2019 17:28:04 +0000
Message-ID: <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
 <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hramdasi@cisco.com; 
x-originating-ip: [2001:420:c0e0:1004::125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 839e9ae9-fae8-4bae-71ed-08d76795ad03
x-ms-traffictypediagnostic: CY4PR1101MB2358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2358669009C849C2DE4D09DBC9770@CY4PR1101MB2358.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(199004)(189003)(46003)(107886003)(6512007)(102836004)(186003)(54906003)(36756003)(6436002)(6246003)(6636002)(6506007)(478600001)(4326008)(99286004)(6486002)(446003)(7736002)(229853002)(11346002)(476003)(486006)(305945005)(76176011)(316002)(86362001)(2616005)(25786009)(110136005)(14454004)(256004)(33656002)(2906002)(8936002)(91956017)(76116006)(66556008)(5660300002)(64756008)(6116002)(4744005)(71190400001)(71200400001)(8676002)(66446008)(81166006)(81156014)(66946007)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR1101MB2358;H:CY4PR1101MB2311.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ns88OxAxub1gMbAASI6q6wp4jfjkISnLU9DZWsuh1xy0dLOBe2KAJBYTkNjiPj6mP1yp9PiLthn4jAXTCQNRzZugufRRxlYpsmoRRgmZWdt21MeQJ+UJAQ6evbpTxwLsyFwllVJxooNqUEaDZjAffsc50rprlefTNbehXekt7c6NkhPnw3A3qhYGFr/25V/wmMiWhOXcmzM75PD1rVF0WT/uAVQNDJZKoBB6LqRoi2jbgL8ybFihtp30sIToti4J/k/Wp7ALshTj4F7qGVvtUE5kiGTqLoSfWMf3tjAedGCt9+TempQV70z80Z3o/JrdTqu49HqwgjBkSJccYWIxFYYiSVC/oZQsktT7xBw0jKIebEMtP+o57wuj0Vw/gkICC6HJ7Qg/+gsfAvE/XFq6Tfh5IP0Mqw6VBNd74PtYw/VdhXa7laoh5vpvlNQgs/uo
Content-Type: text/plain; charset="utf-8"
Content-ID: <5280D6E954541B46806613B55185DFA4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 839e9ae9-fae8-4bae-71ed-08d76795ad03
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:28:04.5467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y/ZthEcuAyoO5SPYUoj6gygexiA9FasilfQQhsb+My01cwZOL+QSr3x9KHp1HCiVN5W8NOtDoatYsnl5v0iYcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2358
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.13, xch-rcd-003.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgID4NCiAgICA+VGhpcyBpcyBub3QgaW4gc3luYyB3aXRoIFBBRC9DUkMgZGVmaW5pdGlvbiBv
ZiBtYWNjZmcyIG1lbnRpb25lZCBpbiBwMjAyIHJtLg0KICAgID4NCiAgICANCiAgICA+IEkgZG9u
IGtub3cgd2hhdCB5b3UgbWVhbi4gIFRoZSBkZWZpbml0aW9uIG9mIHRoaXMgYml0IGlzOg0KICAg
ID4gIiBQYWQgYW5kIGFwcGVuZCBDUkMgLiBUaGlzIGJpdCBpcyBjbGVhcmVkIGJ5IGRlZmF1bHQu
DQogICAgPiBUaGlzIGJpdCBtdXN0IGJlIHNldCB3aGVuIGluIGhhbGYtZHVwbGV4IG1vZGUgKE1B
Q0NGRzJbRnVsbF9EdXBsZXhdIGlzIGNsZWFyZWQpLg0KDQpTaG91bGQgdGhlIGJpdCBiZSBjbGVh
ciB3aGVuIGluIGZ1bGwgZHVwbGV4IG9yIGl0IGRvZXMgbm90IG1hdHRlcj8gICANCg0KICAgID4g
MCBGcmFtZXMgcHJlc2VudGVkIHRvIHRoZSBNQUMgaGF2ZSBhIHZhbGlkIGxlbmd0aCBhbmQgY29u
dGFpbiBhIENSQy4NCiAgICA+IDEgVGhlIE1BQyBwYWRzIGFsbCB0cmFuc21pdHRlZCBzaG9ydCBm
cmFtZXMgYW5kIGFwcGVuZHMgYSBDUkMgdG8gZXZlcnkgZnJhbWUgcmVnYXJkbGVzcyBvZiBwYWRk
aW5nDQogICAgPiByZXF1aXJlbWVudC4iDQogICAgDQogICAgPiBTbyB0aGUgZHJpdmVyIHNldHMg
dGhpcyBiaXQgdG8gaGF2ZSBzbWFsbCBmcmFtZXMgcGFkZGVkLiBJdCBhbHdheXMgd29ya2VkIHRo
aXMgd2F5LA0KICAgID4gYW5kIEkgcmV0ZXN0ZWQgb24gUDIwMjBSREIgYW5kIExTMTAyMVJEQiBh
bmQgd29ya3MuDQogICAgPiBBcmUgeW91IHNheWluZyB0aGF0IHBhZGRpbmcgZG9lcyBub3Qgd29y
ayBvbiB5b3VyIGJvYXJkIHdpdGggdGhlIGN1cnJlbnQgdXBzdHJlYW0gY29kZT8NCg0KSXQgd29y
a3MgYnV0IHRoZSBzZXR0aW5ncyBkb2VzIG5vdCBtYXRjaCB3aXRoIHdoYXQncyBtZW50aW9uZWQg
aW4gcDIwMjAgcm0gYW5kIHRoZSBiaXQgMjkgYmVjb21lcyByZWR1bmRhbnQuDQogICAgDQotSGVt
YW50DQogICAgDQogICAgDQoNCg==
