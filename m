Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217D2485735
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbiAER2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:28:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:22992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242258AbiAER2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 12:28:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641403684; x=1672939684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cq/W06HQA6WRziCW/0CW8YF63TrmCpZPGz+MjSgZ2IM=;
  b=Bc6q4BmAAodvwFbOMGi4nH16zv+lH1Av/1bTee5woDIBzC+OCKRRILBD
   390qaC6kg8lzlwOPWL1rjoEzW1oUjGTnZr0l2FsqO4RnQmg+BhZR/Q4yo
   RhcvS5ZQGbyFVYzEZZzlnTfYL4J7tZj+ZtY/NQgVdf8XxXh+iMG8VO0jF
   1ueMf13rwzFRm3GSOna72Tkepx1+Ocn9iG29mwKx8tQim0NVePM1GkyTx
   qzt9fhjpa8f3Bv1uDVctNdCvEVNpTzjPS2aiPSDZLMaeQaU7hw8cGtWpL
   Q456Ibx0jk9HnSu4XaDULerMR1JmhlybmZ0RmXbq1ngiRiSGzljvRcVz5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="266771399"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="266771399"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 09:27:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="591096920"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jan 2022 09:27:58 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 09:27:57 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 09:27:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 5 Jan 2022 09:27:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWeQwrPSA9RjUZ/Dc8CN19WUMvbTx6MEqnbtgJCr3Q7TEyfmZ+g1hyvFllH0wqLi1PbcMDOjaAmpEI9mzba3PpmMo0Q2srshmIWnilpSBB3prjy9aw81Y+5j/7+xXAMVqL9obRDqM4h8Zv+u7AHq1sIpOI5OXCkRSEzN+XOfjR4q2UBGwOBT/YRkG6sI8dnPf/E7Q7gmA21zZBQcarrGavDpHROqnbAc8CMqc0PRDO9wiSEnbqSTpQPImRC4YJ5Dn2Tmb6IwEWwQDhBDcDUIWyTl6JUkYl8zIFea0zX03xNPW1aZarzRM6pZszGwrnuPfcZkeqt3hNEeP1jzBPt6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoVsD7gyqAtOnT8r9LNQ23PS1aV7MlJBUEkJga6PdJ4=;
 b=F5vQ0thqTnxdSHxgiOpuD/pWYhzZ32DU876BE2UdFbenaVqZOzySXNjPh7etvU7pIG8mnC9qG+4fLOZgn/aR+ag3uNOjhvVwaAKbUzAV6CoMbqKjX6OPvs9kg1ALRTKPm2mOpuat+eTynJTkgk76CT1QFHG1T0Yk26seKRlKRsFzJ3G1Ni+8MvteH1SjR8i+7IP5qM9WORbkNrztb8jBBul0Sbw7MmRBOS5+lWaOt91QfFLgFISpDHnZmvhiZ1wJx+Ohy9ur5JExEpml8BlM1gc/scBwDJQR7rybJkGWzyHOZWkm0h4b7DQlDUu4VXsavn2Ql9Z0sc+96cnQZ29Jog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3159.namprd11.prod.outlook.com (2603:10b6:a03:78::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 17:27:50 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 17:27:50 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Use bitmap_free() to free bitmap
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Use bitmap_free() to free bitmap
Thread-Index: AQHX+mZjE0j0S2ANv02yhpl53DTJeKxUvhCQ
Date:   Wed, 5 Jan 2022 17:27:50 +0000
Message-ID: <BYAPR11MB3367AB75CD4C3E312F7CF4A7FC4B9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <d139eb69eb12c9793a2a3b65e94f74d4cee2a39c.1640529439.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d139eb69eb12c9793a2a3b65e94f74d4cee2a39c.1640529439.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 666a2cce-1216-4afc-2a5a-08d9d070b2e1
x-ms-traffictypediagnostic: BYAPR11MB3159:EE_
x-microsoft-antispam-prvs: <BYAPR11MB315942C118FA1FF3F69CA8CFFC4B9@BYAPR11MB3159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WC2FoJf448staa/SIp00A3AWsGzSggZGSWJMbO3JoyzrfLS8R3ZUpMJacCXK7lA/+RwOXGngx0lWh/7PbMM4trvNn43+iFD/vCUiwvnhzKr4Fw4pDG56lYLmctz0e6QWTw9d8BiotEy70fWJEreiy+wIcNvINJQ34EkW64mLw46iqarRqgOmXdHMIuVcrJDWXVnu3oZ2qfGEG9IGfoVaqhKifVzZwQ0AvGMA4+juAIKSo4S9QI6Iz4u9lJXq8tz0wSs4tKFnIGaUFmr+sEG7itMHG29l6uKZZR2vJoCHGLYIiJhQlifHTUWPEcyfOkTpQ0XHHoSITLq/HsWtj4MmHKVwBr/bhWWz5u7o8AMjSe62m7sNtLPZRLLhaQXuNHAeFaf3K6fn2HOxK5U3GYle+sH8saKa1FHesJobVP6G954K86zdfVNy/zHG4K5f5ImG/looSN82wJwqwXwkss/UXSTeIoRva5gMAt/FESpkPmtfu+ftfk/TzDA8QgZTpA9K78/wSYJAfojpqyux85LjDv3QNQBsnshEzLAy6vzf9RZtjrvija2gp4NEQe5wh+UGGeiNFUbKEcW+bo7HnWZzjBU/xc6SnjPVg4FSVd76fzP2vBAX6A7Da0rmeVq8SuLfzq77lgLL8JqAsapJwBnYxFFJAY+rXwLAD+0GVatl1dMwqh2iAxkkVZT610cUowoucMBl0D/V7b7EwBoN4Iv/8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(55016003)(4744005)(6506007)(66946007)(82960400001)(4326008)(9686003)(38070700005)(83380400001)(38100700002)(7696005)(66476007)(86362001)(8936002)(66446008)(66556008)(2906002)(53546011)(64756008)(71200400001)(110136005)(26005)(5660300002)(54906003)(33656002)(122000001)(316002)(508600001)(8676002)(52536014)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oJuh0dEXTRoZmciLJq/ntCrC03H3tal0Ouwu0mN1cwx97Q2Q+1yqx7ZYOHzJ?=
 =?us-ascii?Q?jqJcahuTdG5zHkQh0xl7JF74kUXImK86Gs0RcqXbp0zuWZq5It2ilDop34dK?=
 =?us-ascii?Q?6I6E9LBU3kRqMJ8yqSYibR7kWwAwJKj0e9rohe7Q66PjI/eTu9EGd2+r7TFS?=
 =?us-ascii?Q?JPbeYJPlZuEQZD0hKmqubiDR2M8OpTe3RyqU2IncEUG2y8BMfU0bIpBS14UY?=
 =?us-ascii?Q?jYAtpzLnhsP21gnHte26bfZ05nP3KdFthNvctuAzUSVyCwXOJo9umyw2hcHB?=
 =?us-ascii?Q?lB2VkpR1tfX6S90mJTj6KBwbXFboF9i8SV02q2jczvyOghSZZMEYypyznFdD?=
 =?us-ascii?Q?oaynTTWjWioy5Rq+d+aqxWhEPSN9Om8aGab6q8hcDbARE4jBLzzCBDnQsFiH?=
 =?us-ascii?Q?kch+4eA+dHOX3X4TsyuXYtPf9HaqJV2G+5bZy72b0cZitl7elfhFJnRQmPrr?=
 =?us-ascii?Q?LvP1jeMMUlHR202vxDhs/Bk3gOAN1qywlhnbQbvwL6AFfkaQ/ADOoIhaftpB?=
 =?us-ascii?Q?77VqYt1783F75SPfOLw272UJA/PSADFwV/e9prBH313mEVoiHwnyjGRQgG/3?=
 =?us-ascii?Q?1BXmipfc48YqtL7e3mM4tHyqPwcydq2TP6MU9JKxehwMfBDsKHB59AZNYe3o?=
 =?us-ascii?Q?hsuOfh5JkZbPpAsCKPLh8YvUupAk+GKI6sHmihR1GQ20qGm5TQ0hS+fQAW+m?=
 =?us-ascii?Q?6f59VrWtaB2hJXrULkqQE5g2aiXdMhuKrnbw5jJOcvSxvvpUCA9lYIQQ8ycJ?=
 =?us-ascii?Q?I4cWyDTai5yen7BTzwYJw1SpZ+FckOoIkek4+iLclcf1TvaQobEhRsklvd9X?=
 =?us-ascii?Q?mBsMlR1zD52Db/8l2bpbMv9F8/Y7cHA0Sc5mahbp8TpN6BttORzkDT/S9EVW?=
 =?us-ascii?Q?nqHtyVlJZ/CmaOYO/U1qooTuXC5M/m7MZZLDrkTagr8Kf2BlrdBhWDdiPPn0?=
 =?us-ascii?Q?vRNtRjVD8pavLtJR1W5v8wQwAF/Rc3CMUJCFrPinPDC4uHW0V/tdUdhQgDAq?=
 =?us-ascii?Q?7i4eKpUPn7XMdCYW/8ouCypcxz484X7I/mCJfbevQhbHjzGG2w4jseo0a8YA?=
 =?us-ascii?Q?2UVhqyl05aJ1cWWqTy4eUxwVVjVs5QQuhoS8ea6URMbcqigkMKaT6+Veu7l7?=
 =?us-ascii?Q?RrwKXqDFZjab+JUWT+kxVWdh/dURlYYX4ooAszWDNDufPlyxUT/pdUWKll1/?=
 =?us-ascii?Q?emEONfs1SiZjANeqY4ebScvN/2laCkgf1eYSOofb9L2T36Eu63cCP0bnqy5Q?=
 =?us-ascii?Q?Q4hVzjDSuUz/styjLmdT3M6PqjdA2OgfjbWU9RVzTkDTYOxa3yIeDOAaNFRf?=
 =?us-ascii?Q?Q0zUdI5uK9WY8kHY809k47R3in432ZJ1tLM9Zh4Mbt+3DKqPn4VbS1whsPLs?=
 =?us-ascii?Q?QpUQdK9T9SptRZvdrQe+nVucXAJGwcD9FBEteRT63rK2yUQ/ydSWYF0Ylpn8?=
 =?us-ascii?Q?HNHaFT0hy3CQ9N++Iu5joJFGkQD01uX3TNJs7iKg1raA9W7Y+F0KDWhluklc?=
 =?us-ascii?Q?ckfvPCDma31pOkSEZS+QcdDoJIf2NXCgp2a+IIPPk1uuRjaUzKdrc6BpfNY9?=
 =?us-ascii?Q?YYc1MP4/539V7EGK3FEjLY/2N/qiEtopjUwgWUlytAa9u4qZyjatW0uBdZiD?=
 =?us-ascii?Q?9w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 666a2cce-1216-4afc-2a5a-08d9d070b2e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 17:27:50.4870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZW6JnzCUnxzMc0YV1JveZSKy4CsYeUDkG/eJZfm7Mkn7cdL19zs6VVp4XtD+JKrpeiwB3mWrAqz48pWG7aGWzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Sunday, December 26, 2021 8:09 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe
> JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org=
;
> linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] ice: Use bitmap_free() to free bitmap
>=20
> kfree() and bitmap_free() are the same. But using the latter is more cons=
istent
> when freeing memory allocated with bitmap_zalloc().
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
