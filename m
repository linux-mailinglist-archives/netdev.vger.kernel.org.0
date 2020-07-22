Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4322967F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgGVKow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:44:52 -0400
Received: from alln-iport-7.cisco.com ([173.37.142.94]:24841 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgGVKow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1770; q=dns/txt; s=iport;
  t=1595414690; x=1596624290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LKDrqtfwUTHpIBR94aPVSUerveVFDwvkMWzvLKF4cSo=;
  b=P+8QncJzw4mxghjIjMY/EOtTSDXq0AHVFGdL6mIhH2BXySXzjV/ptYNJ
   29gStbYCb5CMX7pm40pWOds32PXpHSTcOGXkr6K25YMHunNDweHMCjvts
   Zf+7RU4jIb8BhUV9IRJi5GwHSA+Mtufx7xpTgXFFUdrqaZ1RaxLkH2W/2
   4=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ao6kszB0j3z82wxuOsmDT+zVfbzU7u7jyIg8e44?=
 =?us-ascii?q?YmjLQLaKm44pD+JxWFv6dojVTTWp7c5e4CgO3T4OjsWm0FtJCGtn1KMJlBTA?=
 =?us-ascii?q?QMhshemQs8SNWEBkv2IL+PDWQ6Ec1OWUUj8yS9Nk5YS8P/bEfVuXq88XgZHR?=
 =?us-ascii?q?CsfQZwL/7+T4jVicn/3uuu+prVNgNPgjf1Yb57IBis6wvLscxDiop5IaF3wR?=
 =?us-ascii?q?zM8XY=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DwAQBtFxhf/4gNJK1gHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQIE5BQELAYFRUQeBRy8sCoQpg0YDjUiYXoJTA1ULAQEBDAEBLQIEAQG?=
 =?us-ascii?q?ETAIXgXUCJDcGDgIDAQELAQEFAQEBAgEGBG2FXAyFcQEBAQMBEhEEDQwBATc?=
 =?us-ascii?q?BDwIBCBgCAiYCAgIwFRACBAENBSKDBIJMAw4fAQGhdgKBOYhhdn8zgwEBAQW?=
 =?us-ascii?q?FEBiCDgkUeioBgmmDVYIvhASCGoE4HIJNPoFJgnSDFjOCLYFHAZBVPKJ2BgS?=
 =?us-ascii?q?CXZlmAx6fUZIFnwQCBAIEBQIOAQEFgWkkgVdwegFzgUtQFwINjh4JAxeDTop?=
 =?us-ascii?q?WdDcCBggBAQMJfI5DAYEQAQE?=
X-IronPort-AV: E=Sophos;i="5.75,381,1589241600"; 
   d="scan'208";a="515951491"
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Jul 2020 10:44:49 +0000
Received: from XCH-ALN-002.cisco.com (xch-aln-002.cisco.com [173.36.7.12])
        by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 06MAin9O028692
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 22 Jul 2020 10:44:49 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-ALN-002.cisco.com
 (173.36.7.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 05:44:49 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 06:44:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 05:44:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDKnhUgjK7jCfiygxgmUtvxpSKoCJPXNVZDU2jdroXgTULFc28plNMc/uHp3p5wFNKA0oqOZjw3Ccl7YV5HP54+/ELTVk8DdT5DBpgZwKGqTESGctgYAE5jqC3kZtwUyQcXufWPB34YzP97OVizqZO1a9lQ89HpVyv/snKUJricGfDvcTzeIuakEQeZUuekE/U+OAKhgPqf/dRTCHPZ6AKcM2VqmCRIFge82fRGg13c35qg8EJlEN8H/zBCupstd44s0CMJKkA2HLxuOQiADcsR1zZq3lBxn0F9dRNe48B4b1hRHxiRbW2tWiRJBVa4ZcrSZFDRfEy0QwA4tHAsl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKDrqtfwUTHpIBR94aPVSUerveVFDwvkMWzvLKF4cSo=;
 b=TadX0gulHoPBJoXk57Om4hkBvIvOPc9p1oECwm2BVJ4N4JbFgO1d2gWSAHds3FAACLHOreJ0ecZPd4/tWJKTsVUZM7nWGquFThlvaLI3oBEvzU4YICjQANkyWkKXaP7jeZTqI0FG+bs000vyinEM+EWPD4M7mHwlF/8V9R3MbZWZaZKydFm/HiVV/lNVhsf1QHqCAzfkVahvhRXrv18yyes1fxyxa5xhRvLJSUR4F8RfDGj3no0EptyFLDlsWFxoe7i7G7INC+xavWW/xPxYbzTbZkrUe4M7vfbuUegMkPwTWfEp40zQUA8BjAXpgHuzdF7/gO3tT8OaiyLBM57sjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKDrqtfwUTHpIBR94aPVSUerveVFDwvkMWzvLKF4cSo=;
 b=GzUxDF9Ekli9AqqqC7G15dpDTWBqIKwJQgIEbvehfgZonHc1YIYCXSe/cGgCqmIRLiTAOsbpYjAiAx0oaI7pmMC6hqi1dGzQrsKVfvyqM2BvjNqdbf7bn/UQt4lXbbegzO9M/gcQs731xwLZDnp1HEbX180F+ZDaMY/pa8lJqW8=
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 (2603:10b6:910:24::18) by CY4PR1101MB2150.namprd11.prod.outlook.com
 (2603:10b6:910:18::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Wed, 22 Jul
 2020 10:44:44 +0000
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766]) by CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766%11]) with mapi id 15.20.3195.025; Wed, 22 Jul
 2020 10:44:44 +0000
From:   "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        David Miller <davem@davemloft.net>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>,
        "Umesha G M (ugm)" <ugm@cisco.com>,
        "Niranjan M M (nimm)" <nimm@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Topic: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Index: AQHWXu1TxveMQ7VN0USTIMVfIXoTpqkR+jQAgAChnoCAASy7gA==
Date:   Wed, 22 Jul 2020 10:44:43 +0000
Message-ID: <D02BAA42-7BBB-4A65-AA1A-08A770219B8E@cisco.com>
References: <20200720164551.14153-1-srirakr2@cisco.com>
 <20200720.162726.1756372964350832473.davem@davemloft.net>
 <292C3F77-60F5-4D24-8541-BCAE88C836AF@cisco.com>
 <BL0PR2101MB0930B942CE2E4EB875EC38C2CA780@BL0PR2101MB0930.namprd21.prod.outlook.com>
In-Reply-To: <BL0PR2101MB0930B942CE2E4EB875EC38C2CA780@BL0PR2101MB0930.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.39.20071300
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [106.51.23.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 880b876c-b599-47b4-9428-08d82e2c3ef8
x-ms-traffictypediagnostic: CY4PR1101MB2150:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB21502470075396E222F515A990790@CY4PR1101MB2150.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7SCBkQ+5OxA696oOSLxsrz0sqlWZ/hM2UzidEu+jqC01GpWZQJX6cNf9ZDBC/YK23hZ8xq09WSrm/Cq6dKkyLqiS+c6fbWyKrIz7084tOSZrv6hXU4lk4WX2zRIeK5An7hehjrF0+vwvk3mqIAcOiBRTTBjx+4pi6KuDPdh+ui8Zgq8mfpAbCBo9P3dnDePqlYEEWy5ZQtZxWw5gToqpQNE52npwsw4WYVD4QF4d0xCfUmEdzW5FYp808E7LkYzZzVsH5bJwuMiLzDYPJE8y3wssbmK5Cj2yV6OoB4PxZyUNVx4dZFVoM6KACxMaJ29SLSd/k/F3CfoYTPshDBifgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2101.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(54906003)(33656002)(110136005)(86362001)(71200400001)(478600001)(5660300002)(55236004)(8676002)(316002)(6486002)(2906002)(4326008)(8936002)(6506007)(53546011)(36756003)(6512007)(66946007)(66446008)(66476007)(64756008)(66556008)(2616005)(26005)(186003)(91956017)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DY607qfLpkQ+7oSJWnMmhCF3ByIYhcvLKKdE1H849rjr6y2AIu9AlA0Wv1x1n8zsHChzCP0bGEvPc4pIB60zQNHpEsVgm0xRsxzFRUqnz7aFbSrCRBo7zenkWlPAF6S+pNfEomIuBaVkpA3iwUlooIY9z5RMFXBI+uijC4+NaGcFb+xOq4bXYYyAta1aOEVG3mLOq6eJ1aXZu1bzrA6HYqe3RDhBukV1vLe44mDHGU8WkZ8/dKxidaMbtHSPBE8i/jANCLfXwPUP/LAuw1lIMLquMQKlKry0Ruw+yJQCps8/BKdSIjsVL2CMFhf/3tJ3GxYU+bRSWYMa3YWRTcyWLZNW8BSAsoX2khZL26isJZxAhYZFsTv+RocRGyVWffJa1cD71KhjXvtkdNB4VCHqTGqUe35MJb5hu7D1slTj01MgtuYinoAPdGJi923QMrwkzR03FdWLFSJS4aogJbStQM5+tn9hkGFK/4s6zjPtyeI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C342C4C4FC03F942BE846750414500B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2101.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880b876c-b599-47b4-9428-08d82e2c3ef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 10:44:44.1043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /V6PKruLtM6YOx5OEqV+KN86+qsGfaVE5pL5zyj5xS/0Y1bt5JRr0ooSFAbERyua2auqGcRtjLVFoHKOdzGLXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2150
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.12, xch-aln-002.cisco.com
X-Outbound-Node: alln-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgIE9uIDIyLzA3LzIwLCAzOjQ4IEFNLCAiSGFpeWFuZyBaaGFuZyIgPGhhaXlhbmd6QG1pY3Jv
c29mdC5jb20+IHdyb3RlOg0KICAgID4gSWYgeW91IG1ha2UgdGhpcyBjaGFuZ2UsIGRpZCB5b3Ug
c2VlIGFueSBkcm9wIGluIGEgbGl2ZSB0ZXN0PyBUaGUNCiAgICA+ICJwYWNrZXQtPnRvdGFsX2J5
dGVzIiBpbiBzdHJ1Y3QgaHZfbmV0dnNjX3BhY2tldCAgaXMgZm9yIGJvb2sga2VlcGluZw0KICAg
ID4gb25seSwgd2hpY2ggaXMgdXNlZCBmb3Igc3RhdHMgaW5mbywgYW5kIG5vdCB2aXNpYmxlIGJ5
IHRoZSBob3N0IGF0IGFsbC4NCg0KICAgID4gSSBtYWRlIHRoaXMgc3VnZ2VzdGlvbiBiZWNhdXNl
IHRoZSAicmVndWxhciIgdmxhbiBwYWNrZXQgbGVuZ3RoIHdhcw0KICAgID4gY291bnRlZCBieSBi
eXRlcyB3aXRob3V0IHRoZSBWTEFOX0hMRU4oNCkgLS0gdGhlIHZsYW4gdGFnIGlzDQogICAgPiBp
biB0aGUgc2tiIG1ldGFkYXRhLCBzZXBhcmF0ZWx5IGZyb20gdGhlIGV0aGVybmV0IGhlYWRlci4g
SSB3YW50IHRoZQ0KICAgID4gc3RhdGlzdGljYWwgZGF0YSBmb3IgQUZfUEFDS0VUIG1vZGUgY29u
c2lzdGVudCB3aXRoIHRoZSByZWd1bGFyIGNhc2UuDQoNCiAgICA+IHN0cnVjdCBodl9uZXR2c2Nf
cGFja2V0IHsNCiAgICA+ICAgICAgICAgLyogQm9va2tlZXBpbmcgc3R1ZmYgKi8NCiAgICA+ICAg
ICAgICAgdTggY3BfcGFydGlhbDsgLyogcGFydGlhbCBjb3B5IGludG8gc2VuZCBidWZmZXIgKi8N
Cg0KICAgID4gICAgICAgICB1OCBybXNnX3NpemU7IC8qIFJORElTIGhlYWRlciBhbmQgUFBJIHNp
emUgKi8NCiAgICA+ICAgICAgICAgdTggcm1zZ19wZ2NudDsgLyogcGFnZSBjb3VudCBvZiBSTkRJ
UyBoZWFkZXIgYW5kIFBQSSAqLw0KICAgID4gICAgICAgICB1OCBwYWdlX2J1Zl9jbnQ7DQoNCiAg
ICA+ICAgICAgICAgdTE2IHFfaWR4Ow0KICAgID4gICAgICAgICB1MTYgdG90YWxfcGFja2V0czsN
Cg0KICAgID4gICAgICAgICB1MzIgdG90YWxfYnl0ZXM7DQogICAgPiAgICAgICAgIHUzMiBzZW5k
X2J1Zl9pbmRleDsNCiAgICA+ICAgICAgICAgdTMyIHRvdGFsX2RhdGFfYnVmbGVuOw0KICAgID4g
fTsNCiAgICAgICAgDQogICAgPiBUaGFua3MNCiAgICA+IC0gSGFpeWFuZw0KDQogICAgU29ycnkg
bXkgYmFkLCBmb3VuZCBvdXQgdGhhdCB0aGUgZHJvcCB3YXMgYSB0ZXN0YmVkIGlzc3VlIGFuZCBu
b3QgcmVsYXRlZCB0byB0aGUgY2hhbmdlLiBQYXRjaCB2NSBjb250YWlucyB0aGUgcmVjb21tZW5k
YXRpb24uDQoNCiAgICBUaGFua3MsDQogICAgU3JpcmFtDQoNCg==
