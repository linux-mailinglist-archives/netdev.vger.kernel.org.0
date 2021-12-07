Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A44046B3E6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhLGHdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:33:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:39398 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhLGHdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 02:33:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217542560"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="txt'?scan'208";a="217542560"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 23:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="txt'?scan'208";a="515162584"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 06 Dec 2021 23:29:52 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 23:29:52 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 23:29:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 6 Dec 2021 23:29:51 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 6 Dec 2021 23:29:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap0wsQzE3X+YlOYeKyvXo39/Lgv88S/66KfInH43FYaXOvKMbuKtDLamcGPezSgcx9qbqcZBXVKYU396AVucpIFtQPfiaRTOADom8ri2ILs3/OJsYn0wa2AWVwFO+eN7nL4sMNn3bFsnW83FP538daQbdYwemhoueRS/uhAGRN/HyZ90Qa3sjyIy02Wuf2no1JXupgSk1wZWx+F0tU4iqgAw1aNl07OegbV2xRcy35a538Z9gxrvKSxsM/zDYAoGtD2o/NmOGJV5o8wHhzwtVoqHBFI/iHFvP7UlH9CyC+4EOA6Sc5qEax7R9RXGwUnFd8pvIEnWO0C6uHrVRWC5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9P1mrJJBSwWb1wuEBTyNmzunbP8uW7EydKceaMMPJw=;
 b=k+Up21zCWyDe3z508/gwEDmaxyxC+nYJRONaXWFEz5kHFetp2o7BEE2FY+VU2HLJ7rMgS5Gty44qHjxwGJ2gYlSI5txKgkAQHwXyRBx42RCzzPQwolmmjCtytKootx/rjlLGDyjKOmdrNTploz20p0LVF/7HSW7QF2iAxhGHwO+FZr+G+n3w2427KJjpLWQ7V4KOFGkverp+UKe0VZkr6um3diElLPOQpvyp6uEKq3qcLT2YcA1YLx8LzRLgRNlp3T3eI2hCBD33c1VAa45jlnJ1wr1WXUOe/Si+A82PEtLp72yOYcszDFlOuayAPCoF7iN+B8sXJQu+iYmPMn3IAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9P1mrJJBSwWb1wuEBTyNmzunbP8uW7EydKceaMMPJw=;
 b=OgsFf+CrF8Eu1EUxZ7eV/Yrdg2pJkvj1LgftqUrkS45pOM4z9CrwofueVfQ9im+bZ/SLpnHl5CckIDgdFmdviU9YUkqOxD4cNT44nRTp4D5rp+19dFxmczUvXh3rh3jQts8J/lAfezow347sgPziMdQoafpZ2dMQlRIkQRZQwNo=
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by PH0PR11MB5952.namprd11.prod.outlook.com (2603:10b6:510:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 07:29:48 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 07:29:48 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Li, Philip" <philip.li@intel.com>, lkp <lkp@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>,
        "Li, ZhijianX" <zhijianx.li@intel.com>
Subject: selftests/net/fcnal-test.sh: ipv6_bind failed
Thread-Topic: selftests/net/fcnal-test.sh: ipv6_bind failed
Thread-Index: AQHX6zot8Ol/TwF2TEmB0Z3Cqf94Zw==
Date:   Tue, 7 Dec 2021 07:29:48 +0000
Message-ID: <PH0PR11MB4792DC680F7E383D72C2E8C5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 56759d86-a193-c695-f89d-5768fcfc1f1c
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3942a498-1f1a-4b78-d455-08d9b953597a
x-ms-traffictypediagnostic: PH0PR11MB5952:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB595204311FE8040F7FEA0489C56E9@PH0PR11MB5952.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:295;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qVdu1+WEX+qNYwnCLqlk1A6DfGXeDCnhPyF+fcNOLD8OAZxZjFcph7F4XFG3nOLmo8j/JnnJT7KkAAstWN3cuS1Ly90oikLDW/P8eND61i7/2Hd17S+ATjbFWuAbHB4exhoeXu7Vu/we8F/CIQGrQpIYHDlGPG9/lJHFaz9DTQS3dzh8lefne27Ci+ML+c7uKNcnzEU+7D8ngD/VQoaYEQSz40+Ihs49ZgGT2COiiUBbx2Ayo7hA0uD8WlPhbsfJk6xADNbaZOLKFQE7GtzsVefNon9+LdTC2bPn5diBGcTolbX8DpBBN14iIjHsux68vtS4Tx9DIqgFhRqJIBKOgn2k4SQHkMVEsf4t2NKE6iXLG0QuIQf7wZii2lS0FXg9M8EyKcAI2vSwDQ+RLcPQGB3v/2+hxKYhs8DKA6orxXRm29nCgPcEt6EdPdLvMHhShLjbWijJkQ7azd+jOsNUS4K1+syO18APS4IKrxH1jKqR2Skq926Ej4nAc/DXi4HQtzefBmQk0cPKJBLdGyIeul4LrtTjgcepXFpvvYfdMhiM1whTbKa2lImoNuSramJNvKgFZwqj3LUSpfoUGX2G9nW4NJewL/a7MLJQXuYMh6pnr/Au1fz+FPSiGkk/ru7c/pa5P/n0j8MD5JHixUzB7mP5Zylh39ak+Qcuysu+hCXyNsEKtQZEC4C3yp35zbQjeFxXbKcNqe8aBzN0NCqoeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(99936003)(26005)(66946007)(110136005)(54906003)(71200400001)(86362001)(91956017)(9686003)(76116006)(6506007)(55016003)(33656002)(66556008)(8936002)(66446008)(64756008)(316002)(38070700005)(66476007)(52536014)(2906002)(122000001)(4326008)(186003)(7696005)(5660300002)(4744005)(38100700002)(8676002)(508600001)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?psuTjZywwsWR6LnpMgKfTZuksEdlwNelj621QYcTIiuw7g89snCkoV6xA2?=
 =?iso-8859-1?Q?kYqqFwZNwF/o2KRM/Do2layu/TDgp6/TBKm38nThh/Lk1bq5YveAA8Ffmy?=
 =?iso-8859-1?Q?O+HvI3V58mc5CX6m9yqUvkryAzZWZw4sETTDzUnlNBGr+pFJuFBw27Nn5I?=
 =?iso-8859-1?Q?QN6uRkDuF92PNWmwU4XCw1WK7dj+MIdkk2Te/SJcNs5tLDnyBYObqqblg/?=
 =?iso-8859-1?Q?mVrW3xksHXjr6uIrdNgwacEoMmhsLf3s9mhXIzk1/ztbeV86yl5UsR/TFA?=
 =?iso-8859-1?Q?8b3YRXItYGdWQDkhvg2ZhyyDBUQQEkG5+xOix2SvmmzmB0nfngsbkjI0ih?=
 =?iso-8859-1?Q?uMRUJqSfELtgSchw7Iz0/6T0PSS9xthtv02lnu/HA9ytHuI2W2Bq6eV9vd?=
 =?iso-8859-1?Q?YgsJ4sqjKnHP5draO7qxb47bG3xSQ2T4r4baTiS5tbdKUzdjjm10FnMTQK?=
 =?iso-8859-1?Q?ilMxro7SE4TTgHofzgz/yjObQAhzQ3BLtI83OQa/yCYc9GdRFAbVbTdvZC?=
 =?iso-8859-1?Q?bh/jRNkl/nctmaDf4qglBOGJTpmTFdgLgmi4D/d8R1JzxofpHMdP345QHy?=
 =?iso-8859-1?Q?wdxYHMZMJzemTPIJYDY5dL/AgC5lfAEfKN5BmY9BrwRIES1mvVly50Bq9b?=
 =?iso-8859-1?Q?nIaSse53NqWwOjbzUlz2udhEwAEnz/AdRLZnwWtaD5gGkUs2g49uoIoUUF?=
 =?iso-8859-1?Q?3iP8DExmrPFE4Lqo8eU1DV6sVftbZkg1d4RtuW8MOMPTa4ij1LbYRC5DST?=
 =?iso-8859-1?Q?gDv+50sxOnl/MDdnulzgHJEIA0Dqf9Gp8WqkK755nF69I2RgJNc1mjo/LJ?=
 =?iso-8859-1?Q?BOQP3vccB2zKwnstqC+TiQOs+ZHGaZm+ypkTngHr2UoxzHh7VAY32TO/bi?=
 =?iso-8859-1?Q?VfR+CwDgRll9jfKJ69H8D0pn0SK4JUG/Prwha7YxUPY/SWxN28IzMpNCjS?=
 =?iso-8859-1?Q?P2g0fB8WlJPoJ/KoACmps2qz+VOeI/6FExK/h8SRXqVmGBfLofoFwIwSAw?=
 =?iso-8859-1?Q?6Y7rNrPg9HcWm/j1sByyglTa3cLAyTy1Dp7Es3g6O4CeoQoMpSvidxps0s?=
 =?iso-8859-1?Q?vXBtxW25CgN0Xnk0SQwMFV5NLs6aRDc3fbReRuX/kGhQRX5FOaR83sv2TO?=
 =?iso-8859-1?Q?u+TBl1yuwiSdyFWzhnIVsCm7zxT8tHONr+wkbIWpQUpylCXNHuACbmCqh/?=
 =?iso-8859-1?Q?kC7FhNVz6CGpAJgMv+WA48DaMh30wZRofNX9Kqye4iXv1azEQIZQYH248l?=
 =?iso-8859-1?Q?I2B+hdy8JXuJEwVupf8tekpoRASq3ZhRoGXTxGhmn4fR+euExZXY3JnzBH?=
 =?iso-8859-1?Q?r3XcqQJnb7DetgDR+IK/qZw7+aaHrSQX0a5Q63EqPo6du0QhT8EvuoB5Aj?=
 =?iso-8859-1?Q?SagDm5xRsBDrmR4cGdKLtQYOqt/Zo/uV4ivQ9qVncZUHhmnWJdSu356Orc?=
 =?iso-8859-1?Q?vPWd3hFbNqt/4QmZfjHQSlWTYV+F89M7cwUbAZ2E18fLX4f+Ipf5P4gBFx?=
 =?iso-8859-1?Q?Tm7T7CPHlmClUQXXqK6k71pEuHgeC3HnyDL1UVi59PIdDVZtJ++pzA9KXn?=
 =?iso-8859-1?Q?w1EHWl0JrcZJleyYQcWbeL2egKAaR/zEV7mgGYStJFRzr56RxRAn7lkC5M?=
 =?iso-8859-1?Q?ELdisncTaVpXaBu2IhZHs98sT1FTH2MV/LwcjY8kH8DpB5bpLbxe8ytg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: multipart/mixed;
        boundary="_002_PH0PR11MB4792DC680F7E383D72C2E8C5C56E9PH0PR11MB4792namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3942a498-1f1a-4b78-d455-08d9b953597a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 07:29:48.3326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OJWDv9XWfjyOtK7krD25bxw1SYpt8m9O2C+sfHk3eddnD4msTmCN7c33nSnTQNQQzOxmuuKvXwkPZgtcZWt9+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5952
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_PH0PR11MB4792DC680F7E383D72C2E8C5C56E9PH0PR11MB4792namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

hi,=0A=
=0A=
   I test ipv6_bind by "fcnal-test.sh -v -t ipv6_bind" in kernel v5.16-rc3.=
=0A=
   There are two tests failed.=0A=
=0A=
TEST: TCP socket bind to out of scope local address - ns-A loopback IPv6   =
   [FAIL]=0A=
TEST: TCP socket bind to VRF address with device bind - VRF IPv6           =
   [FAIL]=0A=
=0A=
 In fcnal-test.sh expected command error not occurred.=0A=
 ipv6_addr_bind_novrf()=0A=
  {=0A=
......=0A=
        log_test_addr ${a} $? 1 "TCP socket bind to out of scope local addr=
ess"=0A=
=0A=
 ipv6_addr_bind_vrf()=0A=
  {=0A=
......=0A=
        log_test_addr ${a} $? 1 "TCP socket bind to VRF address with device=
 bind"=0A=
=0A=
  Did I set something wrong that result in these failed?=0A=
  The test output is attached.=0A=
=0A=
best regards,=

--_002_PH0PR11MB4792DC680F7E383D72C2E8C5C56E9PH0PR11MB4792namp_
Content-Type: text/plain; name="ipv6_bind.txt"
Content-Description: ipv6_bind.txt
Content-Disposition: attachment; filename="ipv6_bind.txt"; size=4895;
	creation-date="Tue, 07 Dec 2021 07:29:04 GMT";
	modification-date="Tue, 07 Dec 2021 07:29:04 GMT"
Content-Transfer-Encoding: base64

Li9mY25hbC10ZXN0LnNoIC12IC10IGlwdjZfYmluZAoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCklQdjYg
YWRkcmVzcyBiaW5kcwojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwpObyBWUkYKCgpDb25m
aWd1cmluZyBuZXR3b3JrIG5hbWVzcGFjZXMKCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMtQSBu
ZXR0ZXN0IC02IC1zIC1SIC1QIGlwdjYtaWNtcCAtbCAyMDAxOmRiODoxOjoxIC1iCgpURVNUOiBS
YXcgc29ja2V0IGJpbmQgdG8gbG9jYWwgYWRkcmVzcyAtIG5zLUEgSVB2NiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBbIE9LIF0KCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMKQ09NTUFORDogaXAgbmV0bnMgZXhlYyBucy1BIG5ldHRlc3Qg
LTYgLXMgLVIgLVAgaXB2Ni1pY21wIC1sIDIwMDE6ZGI4OjE6OjEgLUkgZXRoMSAtYgoKVEVTVDog
UmF3IHNvY2tldCBiaW5kIHRvIGxvY2FsIGFkZHJlc3MgYWZ0ZXIgZGV2aWNlIGJpbmQgLSBucy1B
IElQdjYgICAgICAgICAgWyBPSyBdCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMtQSBuZXR0ZXN0
IC02IC1zIC1SIC1QIGlwdjYtaWNtcCAtbCAyMDAxOmRiODoyOjoxIC1iCgpURVNUOiBSYXcgc29j
a2V0IGJpbmQgdG8gbG9jYWwgYWRkcmVzcyAtIG5zLUEgbG9vcGJhY2sgSVB2NiAgICAgICAgICAg
ICAgICAgICBbIE9LIF0KCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMKQ09NTUFORDogaXAgbmV0bnMgZXhlYyBucy1BIG5ldHRlc3QgLTYgLXMg
LVIgLVAgaXB2Ni1pY21wIC1sIDIwMDE6ZGI4OjI6OjEgLUkgZXRoMSAtYgoKVEVTVDogUmF3IHNv
Y2tldCBiaW5kIHRvIGxvY2FsIGFkZHJlc3MgYWZ0ZXIgZGV2aWNlIGJpbmQgLSBucy1BIGxvb3Bi
YWNrIElQdjYgIFsgT0sgXQoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIwpDT01NQU5EOiBpcCBuZXRucyBleGVjIG5zLUEgbmV0dGVzdCAtNiAt
cyAtbCAyMDAxOmRiODoxOjoxIC10MSAtYgoKVEVTVDogVENQIHNvY2tldCBiaW5kIHRvIGxvY2Fs
IGFkZHJlc3MgLSBucy1BIElQdjYgICAgICAgICAgICAgICAgICAgICAgICAgICAgWyBPSyBdCgoj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNP
TU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMtQSBuZXR0ZXN0IC02IC1zIC1sIDIwMDE6ZGI4OjE6OjEg
LUkgZXRoMSAtdDEgLWIKClRFU1Q6IFRDUCBzb2NrZXQgYmluZCB0byBsb2NhbCBhZGRyZXNzIGFm
dGVyIGRldmljZSBiaW5kIC0gbnMtQSBJUHY2ICAgICAgICAgIFsgT0sgXQoKIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwpISU5UOiBTaG91bGQg
ZmFpbCB3aXRoICdDYW5ub3QgYXNzaWduIHJlcXVlc3RlZCBhZGRyZXNzJwoKQ09NTUFORDogaXAg
bmV0bnMgZXhlYyBucy1BIG5ldHRlc3QgLTYgLXMgLWwgMjAwMTpkYjg6Mjo6MSAtSSBldGgxIC10
MSAtYgoKVEVTVDogVENQIHNvY2tldCBiaW5kIHRvIG91dCBvZiBzY29wZSBsb2NhbCBhZGRyZXNz
IC0gbnMtQSBsb29wYmFjayBJUHY2ICAgICAgW0ZBSUxdCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwpXaXRoIFZSRgoKCkNv
bmZpZ3VyaW5nIG5ldHdvcmsgbmFtZXNwYWNlcwoKCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKQ09NTUFORDogaXAgbmV0bnMgZXhlYyBucy1B
IG5ldHRlc3QgLTYgLXMgLVIgLVAgaXB2Ni1pY21wIC1sIDIwMDE6ZGI4OjE6OjEgLUkgcmVkIC1i
CgpURVNUOiBSYXcgc29ja2V0IGJpbmQgdG8gbG9jYWwgYWRkcmVzcyBhZnRlciB2cmYgYmluZCAt
IG5zLUEgSVB2NiAgICAgICAgICAgICBbIE9LIF0KCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKQ09NTUFORDogaXAgbmV0bnMgZXhlYyBucy1B
IG5ldHRlc3QgLTYgLXMgLVIgLVAgaXB2Ni1pY21wIC1sIDIwMDE6ZGI4OjE6OjEgLUkgZXRoMSAt
YgoKVEVTVDogUmF3IHNvY2tldCBiaW5kIHRvIGxvY2FsIGFkZHJlc3MgYWZ0ZXIgZGV2aWNlIGJp
bmQgLSBucy1BIElQdjYgICAgICAgICAgWyBPSyBdCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMt
QSBuZXR0ZXN0IC02IC1zIC1SIC1QIGlwdjYtaWNtcCAtbCAyMDAxOmRiODozOjoxIC1JIHJlZCAt
YgoKVEVTVDogUmF3IHNvY2tldCBiaW5kIHRvIGxvY2FsIGFkZHJlc3MgYWZ0ZXIgdnJmIGJpbmQg
LSBWUkYgSVB2NiAgICAgICAgICAgICAgWyBPSyBdCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMt
QSBuZXR0ZXN0IC02IC1zIC1SIC1QIGlwdjYtaWNtcCAtbCAyMDAxOmRiODozOjoxIC1JIGV0aDEg
LWIKClRFU1Q6IFJhdyBzb2NrZXQgYmluZCB0byBsb2NhbCBhZGRyZXNzIGFmdGVyIGRldmljZSBi
aW5kIC0gVlJGIElQdjYgICAgICAgICAgIFsgT0sgXQoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwpISU5UOiBBZGRyZXNzIG9uIGxvb3BiYWNr
IGlzIG91dCBvZiBWUkYgc2NvcGUKCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMtQSBuZXR0ZXN0
IC02IC1zIC1SIC1QIGlwdjYtaWNtcCAtbCAyMDAxOmRiODoyOjoxIC1JIHJlZCAtYgowNToxNDow
OSBzZXJ2ZXI6IGVycm9yIGJpbmRpbmcgc29ja2V0OiA5OTogQ2Fubm90IGFzc2lnbiByZXF1ZXN0
ZWQgYWRkcmVzcwoKVEVTVDogUmF3IHNvY2tldCBiaW5kIHRvIGludmFsaWQgbG9jYWwgYWRkcmVz
cyBhZnRlciB2cmYgYmluZCAtIG5zLUEgbG9vcGJhY2sgSVB2NiAgWyBPSyBdCgojIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlw
IG5ldG5zIGV4ZWMgbnMtQSBuZXR0ZXN0IC02IC1zIC1sIDIwMDE6ZGI4OjE6OjEgLUkgcmVkIC10
MSAtYgoKVEVTVDogVENQIHNvY2tldCBiaW5kIHRvIGxvY2FsIGFkZHJlc3Mgd2l0aCBWUkYgYmlu
ZCAtIG5zLUEgSVB2NiAgICAgICAgICAgICAgWyBPSyBdCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMg
bnMtQSBuZXR0ZXN0IC02IC1zIC1sIDIwMDE6ZGI4OjM6OjEgLUkgcmVkIC10MSAtYgoKVEVTVDog
VENQIHNvY2tldCBiaW5kIHRvIGxvY2FsIGFkZHJlc3Mgd2l0aCBWUkYgYmluZCAtIFZSRiBJUHY2
ICAgICAgICAgICAgICAgWyBPSyBdCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjCkNPTU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMtQSBuZXR0ZXN0
IC02IC1zIC1sIDIwMDE6ZGI4OjE6OjEgLUkgZXRoMSAtdDEgLWIKClRFU1Q6IFRDUCBzb2NrZXQg
YmluZCB0byBsb2NhbCBhZGRyZXNzIHdpdGggZGV2aWNlIGJpbmQgLSBucy1BIElQdjYgICAgICAg
ICAgIFsgT0sgXQoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIwpDT01NQU5EOiBpcCBuZXRucyBleGVjIG5zLUEgbmV0dGVzdCAtNiAtcyAtbCAy
MDAxOmRiODozOjoxIC1JIGV0aDEgLXQxIC1iCgpURVNUOiBUQ1Agc29ja2V0IGJpbmQgdG8gVlJG
IGFkZHJlc3Mgd2l0aCBkZXZpY2UgYmluZCAtIFZSRiBJUHY2ICAgICAgICAgICAgICBbRkFJTF0K
CiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMK
SElOVDogQWRkcmVzcyBvbiBsb29wYmFjayBvdXQgb2Ygc2NvcGUgZm9yIFZSRgoKQ09NTUFORDog
aXAgbmV0bnMgZXhlYyBucy1BIG5ldHRlc3QgLTYgLXMgLWwgMjAwMTpkYjg6Mjo6MSAtSSByZWQg
LXQxIC1iCjA1OjE0OjIwIHNlcnZlcjogZXJyb3IgYmluZGluZyBzb2NrZXQ6IDk5OiBDYW5ub3Qg
YXNzaWduIHJlcXVlc3RlZCBhZGRyZXNzCgpURVNUOiBUQ1Agc29ja2V0IGJpbmQgdG8gaW52YWxp
ZCBsb2NhbCBhZGRyZXNzIGZvciBWUkYgLSBucy1BIGxvb3BiYWNrIElQdjYgICBbIE9LIF0KCiMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKSElO
VDogQWRkcmVzcyBvbiBsb29wYmFjayBvdXQgb2Ygc2NvcGUgZm9yIGRldmljZSBpbiBWUkYKCkNP
TU1BTkQ6IGlwIG5ldG5zIGV4ZWMgbnMtQSBuZXR0ZXN0IC02IC1zIC1sIDIwMDE6ZGI4OjI6OjEg
LUkgZXRoMSAtdDEgLWIKMDU6MTQ6MjIgc2VydmVyOiBlcnJvciBiaW5kaW5nIHNvY2tldDogOTk6
IENhbm5vdCBhc3NpZ24gcmVxdWVzdGVkIGFkZHJlc3MKClRFU1Q6IFRDUCBzb2NrZXQgYmluZCB0
byBpbnZhbGlkIGxvY2FsIGFkZHJlc3MgZm9yIGRldmljZSBiaW5kIC0gbnMtQSBsb29wYmFjayBJ
UHY2ICBbIE9LIF0KClRlc3RzIHBhc3NlZDogIDE2ClRlc3RzIGZhaWxlZDogICAyCgo=

--_002_PH0PR11MB4792DC680F7E383D72C2E8C5C56E9PH0PR11MB4792namp_--
