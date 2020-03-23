Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7BDA18F919
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCWP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:58:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:33737 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgCWP6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 11:58:52 -0400
IronPort-SDR: qrSIRuBD+kGkzCEdXN+TKnyDfCPQvCndvexHZQF2XSlG1vsdjlPHaDGMXcfj9jdzBJQIqQyXMp
 R1f5nz2gUVpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 08:58:52 -0700
IronPort-SDR: bI9P+fHyYLdwddyK+pMPp46wvpxE2Ltt8PZPS9R7aAbJZ15TEHI3AEbdaQqcB+T+E7x4GkkDnl
 INLthoolOXDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="292609073"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Mar 2020 08:58:51 -0700
Received: from orsmsx124.amr.corp.intel.com (10.22.240.120) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 08:58:51 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX124.amr.corp.intel.com (10.22.240.120) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 08:58:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 08:58:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IT5O3erJIRMaxdqai5EcSNyYkejbFJ3lTJCw/7ktpsUcRCspKMpodTjO28XskifWpt7xF73aBbySAoh1iFkdeROhTgAkCutCRn9EWNTIRMxiBlLu8lpFF351NT1vhUMlny9vj4QjyoPd8NTc/88merb372YiQgSCZ8DkNjF+VKJ9EXtiKFodVFQl/+yuM3U+53WdyhyvpB2huzfzD/O0cs/fCoCQxtv02QtTyxFbI4tm8OLCpyymnK4XqAQG3etDZLRzpdQnp+XA5dJ1ghc16XjVEkkKIz6SCvuEE1/FWPBhk28utO0vkiotJxDdq46Szqk4jlbEins5SQLW3q4k5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7McYHirRbfi1U8D3cbUBi8pKGjOrvig5EdA8G3uT6oQ=;
 b=jT6WWldRl0TlgaJ/kD9yn0oQVXnlrpz7L0dlQkAjjuMyyp8msIy/2frGd7aRnhHsSIp7PWlaPW39gmGo06fx0ZX8+lY9dY/VY9UGugk/102PSH82kd0/KAqmpQ7LX+Vm9mYXWpvtAe97LL5PT8IgdRGkDJ3H+sWjjfYVs7ya/bM2V2yEF98f4SdW+ONP43vsbS0Ljzt1V5V4tUX8rk7dMTJ4aBHYAIoVxCHM+2dE//ftuv5QXSEIoF+g4r76G7AIXm/af9jgBMm4FueKqUbF8Ihj00NLIeHBhPexYpZMjMdMhSJmBBIhLFkoz1pXWYw9U151M7S/rQ4ube7R+AwZ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7McYHirRbfi1U8D3cbUBi8pKGjOrvig5EdA8G3uT6oQ=;
 b=AQehhYNvlkNw7mN5qzOQz11W0WEtvY6r1NOPEp5XCdDs/fDX+dwPjajC84h+7KfPjgS5EnSLMFRMgQauZsVtzG43nsSYR+xOZKB8H2V9jxdYc/jt9Zy1spYrN+Hf3BfNhk+PJEN+QsXPzFo2Mp/Y+WwEaAEvTD8gVnhK4QjaUOY=
Received: from BYAPR11MB2757.namprd11.prod.outlook.com (2603:10b6:a02:cb::16)
 by BYAPR11MB3541.namprd11.prod.outlook.com (2603:10b6:a03:f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 15:58:49 +0000
Received: from BYAPR11MB2757.namprd11.prod.outlook.com
 ([fe80::f8aa:496b:6423:f5fc]) by BYAPR11MB2757.namprd11.prod.outlook.com
 ([fe80::f8aa:496b:6423:f5fc%4]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 15:58:49 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [net-next,v1, 0/3] Add additional EHL PCI info and PCI ID
Thread-Topic: [net-next,v1, 0/3] Add additional EHL PCI info and PCI ID
Thread-Index: AQHV/td4enDl9+8HrUO1gB7pWXIGI6hV9HGAgABj8vA=
Date:   Mon, 23 Mar 2020 15:58:49 +0000
Message-ID: <BYAPR11MB27572653F861E6015D14D32588F00@BYAPR11MB2757.namprd11.prod.outlook.com>
References: <20200320164825.14200-1-weifeng.voon@intel.com>
 <BN8PR12MB3266C3C3CE39D141DF15AA76D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266C3C3CE39D141DF15AA76D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=weifeng.voon@intel.com; 
x-originating-ip: [134.134.136.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49bfd803-c872-4752-8224-08d7cf43137c
x-ms-traffictypediagnostic: BYAPR11MB3541:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3541E30F00E0CBDC43AB5FA488F00@BYAPR11MB3541.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(376002)(366004)(136003)(199004)(6506007)(26005)(186003)(71200400001)(316002)(54906003)(110136005)(7696005)(86362001)(76116006)(52536014)(66946007)(66446008)(64756008)(66476007)(66556008)(4326008)(107886003)(5660300002)(9686003)(55016002)(2906002)(4744005)(33656002)(81156014)(8676002)(478600001)(8936002)(81166006)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3541;H:BYAPR11MB2757.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t/X7uErNXYmANdKbaffMdvm+MX/gGWgZzGiEGZoYvw9Q/WgVDSg19e2v2L52DI+cBa8chcVUKjlSj22qtRSrms2D+Uyoj70UgNg95vghCPlPPEvYO7W57Gr/jk5xFsWvx8psUPymMG+2e0wiVampaqWLDMmA4NQtGwcs1mXVvpWpBefiSViT61poiRaYe7CvHX2I+H5D8O4SemZs1UDP4NKToezPh+/dlfb1P9nZ1ouUQ6rmCrH+VhUV3+AXVFI3hO8n3yrJOj+1P0YChN6XntU1SxlR/HxWqxDagCf4LIS1g/NT6c9cLh5Z0t1y6MmKE08mwxGTygvLjAIl4tzERyV+fH571yh3yv5udfdnLNtqhqtkcK1Dp5qjK+QszxqYOwsxpUyKFbtq4GA53Df2K5+uW6i0LawZ+ka2fojBEEw8HcufILwfFCz7scErCIRuTiiV60sOqsjUi9UVQLSFwQsMmKcoa0MatMXuSDWHvncplDIt2GfG7RRH6XCq5jnn
x-ms-exchange-antispam-messagedata: pDauFUVR/BSnUKvMZHfCJ8CeiEKifzX8h8LGqEf9x8JqWtbpoKnDLFaFY24lcsi1TpBzE1Bvf+mCBhgmaVGuUDUdTQKT1xGUPIL28mmlzbFDu5DrpGuXUkpX5IehJiVQ3kJX7RMDXp9lvu2M8LYyPg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bfd803-c872-4752-8224-08d7cf43137c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 15:58:49.1590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uaBIrwXmuv80XUQyZYmeRLRDY1Fw2slnENSoyJaPuxcKfGZ0QD/gak+8g1GRu4tRcOSCbHGa6h7g9B45TUiH2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3541
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Intel EHL consist of 3 identical MAC. 2 are located in the Intel(R)
> > Programmable Services Engine (Intel(R) PSE) and 1 is located in the
> > platform Controller Hub (PCH). Each MAC consist of 3 PCI IDs which are
> > differentiated by MII and speed.
>=20
> This stmmac_pci.c is getting bigger and bigger ... Can you consider
> adding your own PCI driver (dwmac-intel.c) to stmmac tree ?

Good idea. I will rework on this and submit as v2. Thanks.=20

>=20
> You could even submit a patch for MAINTAINERS for this particular driver
> as it's already done for others.

Do you mean becoming the maintainer for this particular file?

Regards,
Weifeng

>=20
> ---
> Thanks,
> Jose Miguel Abreu
