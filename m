Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3798D34E9DC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhC3OGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:06:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:23164 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhC3OFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:05:55 -0400
IronPort-SDR: kIChQ0Yv0c5NBvx/rFvquKzvHPhquUr9NX0pKk520UC0X7OZ7AcPgGRpki5eL/XUKiR9F2I5Js
 y4AWsQz3CNvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="255763302"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="255763302"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 07:05:11 -0700
IronPort-SDR: 8Bb9Bdc+A7Vv2JPYufAW1szTL1ecTkdcO0dfg6BJldghy7HOw0Sb8XK88nbMw4KTDW+azKZPpH
 XPX8t0QnUskg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="376847097"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2021 07:05:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 30 Mar 2021 07:05:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 30 Mar 2021 07:05:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 30 Mar 2021 07:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCdEWUhw/gxuguqeRQf2WhvNi+IayzEvqJ+MTm1Id40kh/0n0aYF1XeW/4c3vwngfjaHABcNa2sozmM5Twpvtj0msCYkiPbjxqf6B7K9RNFME0T5/XW/Ke+ljiv83rDDip20Va1VVSqTeXo13Mk2vNFS3Y0smdxW8iZtPqvLpgavQ0sGVNpo1W8arCsb/sKZGTuU5k42DzqM5eKWoC/gpHj/DhXhod9YAJmKT8jxUvuw31UrAZIq8kD/zT9Sc+K9x+sE7DJjJ1ElnscYeMvWlZSnBGuJDBTSg626eQqzi60IZk7sBFIz9vuWvZTBVBi1JQp4mZDPqIebSGKccXbuQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqbjAFHuA3QYrkXwlT8ZhwEPzh2vor2TVAg3oj7DLg0=;
 b=WYu5251f7fS8lFSekToTiXw3u0Br8XpLBvZMgq/NSUkX3Lb7qxbQj3c1IqeW/WrBleVyINeKjVWDO5NAlOCVi8tGbqYP1KShUeyCSt8ENpUyLRk2oBjBtm6xYPP1Shcb8Fy6oiZGKmS79oRjhVW/YLJOQNxw3cgC/R04tC4kQNDRPFa+EPtp6bR8zTh66FnDLXNVvMN5Emn3momRMjALY9bMqaJ9/L3Ubn2xGNhr6xgoLeF0yJ+vhnaNJiVAXwETN/K1fueoDVFOioB8Fke3nyroytp9joM6xAr//tcOI/oXKiPWJyXEewC3Is09rnagzlo9obE2vktdh+Li2mMV3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqbjAFHuA3QYrkXwlT8ZhwEPzh2vor2TVAg3oj7DLg0=;
 b=jYkcKPqTeHOgzP0gBrhpJutwgy1uh/wMCtIEjZ54sSjCjeaV+7FKI48H5RoozG5+CSfT2GndNW+RdcqMB55XfuegGcvzJnKXe/NOSmFQbrNbjrk1G7LktTZV0PyVnpXnA01BOkcOSl/3e3b3FkmWHXigF/krgmbZy4mcet2WZJw=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB4628.namprd11.prod.outlook.com (2603:10b6:5:28f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Tue, 30 Mar 2021 14:04:37 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 14:04:37 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/6] stmmac: Add XDP support
Thread-Topic: [PATCH net-next v2 0/6] stmmac: Add XDP support
Thread-Index: AQHXJQ7MivnOY7OF00eUAeEu0F0oIqqcgGgAgAAOXOA=
Date:   Tue, 30 Mar 2021 14:04:37 +0000
Message-ID: <DM6PR11MB2780A28A3E483BF832C36DC0CA7D9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210330024949.14010-1-boon.leong.ong@intel.com>
 <20210330150448.1eae9a6b@carbon>
In-Reply-To: <20210330150448.1eae9a6b@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.169.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dfb6f0e-dd46-4e10-be8b-08d8f384c12b
x-ms-traffictypediagnostic: DM6PR11MB4628:
x-microsoft-antispam-prvs: <DM6PR11MB4628B92773FC67C1603262B6CA7D9@DM6PR11MB4628.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: thHQSI5Aa4t80aEINRy8N1j8BmJ5j/+7AXOZAi7ksuI2QsNAWMNf7O811wBYkpud0e6TVoO0mDR1weRc0DHgcPN7bQwQPmMYdPrDUhAZovN59mnETo7x72H8vhD4b/LdbdG44hh6sUeOD48VzjupsAghJembqT1X5pwwVmz2z4DleUwknxndsKT5Uc18I0BMsYRx8jqJ48CINFa0KQ9eCl6I73KCq5xVvRtuIQnpxFp/+DHmLE67Bn7VyrQj0uMOi2s2IpXNp1OCmpA3v1FniPF6qabAgMRZcbt7MDrOTlwK+aZsixbescly54N4pD12Or76H2SoPmpKHk5UJM3JX1JSEP+kTka9MaC9Ihl4W9+TxleSA5YXIV+ecKInRzxmib5WNjYwmRgcl4h5dS00L4G6fFzmByvYTgzaTJu2iNIlxd+xtwnihVEbFrhpQGxHsIVfdgmBi0MfMu9yrVFYsYpOHSn2WNtf3F9t+I/ho8fxdtkhwH8trw/YxcuVe4Lz50uUR9TT6bDNdAk3zFceY1rOzFKqe88o7WflIN7zH6qS8+VZ8uKUUnke2SEEfNwyz/TC+o7LtTyBn5zhckwRPIMPvkjCQc3HNwhoplVUBWJFXjZgvw0W7qf/X9B+1hWi82CBVi3i7G/Zei+xQ5xLJFZA3IX0wKc0ONjK5IuxV14=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(136003)(396003)(55016002)(54906003)(6506007)(52536014)(7696005)(6916009)(71200400001)(83380400001)(186003)(66446008)(26005)(2906002)(316002)(38100700001)(64756008)(8676002)(66476007)(66946007)(7416002)(4744005)(66556008)(86362001)(33656002)(5660300002)(4326008)(478600001)(9686003)(76116006)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/Augx2fwX4oLF0a2Qx54uG9Bxybiq9uvJwsIJXxPDuRnfSb4O6kspOGgz167?=
 =?us-ascii?Q?HHDNwqvkW4XUnPy0gGLc1Arsjvh3AuVT/vexFEVCe9zhyQw8oPptQdSly6Da?=
 =?us-ascii?Q?F9NlZ2ND8/9dP80slsDs8giPQ2jSI1YiZg87Rg+uyPKvGPt7HY9ipSfbWC6J?=
 =?us-ascii?Q?gOOPeK2NhkRFu3cQYPbnzfGhj1r4B9na3R/8SiIYiH1feUuLlHK/sc3G7sRH?=
 =?us-ascii?Q?cxiJ3m3WVGDGQ64vvQXI4H5IrRK4/Gjtg5Q1oI2tkphS7N4avEikBqdiuXE9?=
 =?us-ascii?Q?1g6Eapfc6EQ8WNtaP6ArZVTqB2myVU/p5f6Pq+vIrdWxCkh2yYXft3ru+ocU?=
 =?us-ascii?Q?9E+GINpzF2vWnbp5S0eP74GSVvBTffSjnIkvCLiG0pRgeWV0CgRMe8m+oBcq?=
 =?us-ascii?Q?z4JQatT5vdlXMGL8W/MDZXH+8QOPGA8BxvK17TCJwuPg2Y+K9uWUFFxhsF4b?=
 =?us-ascii?Q?9/auIsS4JsL/QQrPMZTI4zh3qXb47K+x5TAjfZqY59EOIfhbZKa8kTFb8Upg?=
 =?us-ascii?Q?40HfBRuQhZgz/ZlbeOZ04C8d8Ax4yjaKGulsu/zlC+Sd33lEbBq0dTYns76O?=
 =?us-ascii?Q?QzNVMTYmhetj5zoFgVp0jiAEz0eCsn1WeNn6YQvP2/B4kFJiQWmunhdRi12e?=
 =?us-ascii?Q?dsxDsJ99AuU4AZMvtoZEXPwvOZ5mABWfLy+59tYkrdxr7Ot426UyM7Q0dbk3?=
 =?us-ascii?Q?ZAJIQH28ZmzoXfzyYHDAEZae7BNOtAp7WU/ZgBsqXRKCNp43pwimgzIrRL+b?=
 =?us-ascii?Q?oZzcZpLlMeDRilTOvPphZU2mmZIQUFxLqr/zailCPasgsrpQKL3pvjzCfan6?=
 =?us-ascii?Q?IXtwIQdb5iw3mdLGe+MuyPK6JcI2nziwExkEbrqthORuVFB/zHW7zxrsKX5A?=
 =?us-ascii?Q?/HJbgwn8xbfMOBkOSY+UqVBC/YSAIzvNg8qh1m/1FA6/BsKHEcEOofsFFoXC?=
 =?us-ascii?Q?29wqv50c47kllxZmmeGPgOPefQE69A0OhESNqj3WGyAhAVwghJ0To7kKX2nt?=
 =?us-ascii?Q?8thfuvnzdpq8GIvuk9VCcsoZ2r3uw7HxJsj8ZwOeh3vLWSZ2Uy5NI8N6bTZC?=
 =?us-ascii?Q?3C/Ja2ixiPb3OxvGM0IBd2pOiB0dB7Esk8iTg2c1dgsnFROYdJtw3yaNjRJg?=
 =?us-ascii?Q?DkbziiUpLzg2mSAVszQItmbMQe3J7m67eybjyg9UUcu8ig/+fd7woOJN8JJQ?=
 =?us-ascii?Q?5U2byctgJupnJqAvg3Khj6yvlDX0o9ULILN63Qxgd2SXGTh0CSWsReiLKTKz?=
 =?us-ascii?Q?PPI5GAhxgHLJtUaNeagCUX23w8C2XEj/ExpkdfOmVlzarUYR9JyMA799Bbby?=
 =?us-ascii?Q?Rv2PUmJuYkTyrJytY5a6Ho/P?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfb6f0e-dd46-4e10-be8b-08d8f384c12b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 14:04:37.3957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BwiC56dpHvygwjOgshzOUTOZkIhaDAGu4VP6xyiFqLMIG+KqedjfLFCBcwId0zXcW4UMjQy5+C7zi6qCVYRqsTi8wiZ5tTTZXdPNRZFX05M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4628
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Are there any (developer) boards available that can be bought online?
>(that have HW for this Ethernet driver stmmac)

At this point of time, I am not aware of any commercially available platfor=
m
yet as the EHL product is newly launched but we expect some of board
vendors will be start shipping them mid Q2-Q3 2021. I will surely provide
update if I come across something in future.

>I'm interested in playing with the hardwares Split Header (SPH)
>feature. As this was one of the use-cases for XDP multi-frame work.



