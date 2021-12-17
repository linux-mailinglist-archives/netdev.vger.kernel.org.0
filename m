Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82E0478F8B
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhLQPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:24:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:26880 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238151AbhLQPYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 10:24:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639754647; x=1671290647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/dMLIo5o9vy+QiKz00nCfU6neejo/Als5Vz8Btp3ihk=;
  b=IkJ08X3m/KigmlwOmRinb4/D1/3c4BdkW40Gzx8oVMcFO4rmgiWuWrqO
   wET1ilK9Wvo9UchRgR3IovXwhU1hp+qyCNXHWED3o+W6P8vYNFsz/WcGt
   y1+BcMoJprJnp153DM4waFUr2tMsuRbTXJMDaxV3O7AgT8KRkAYwRSMfo
   UWdXeXuXKjsG7jcnyleJcP8RrrHo1D6l/MV852zLQipMR5BLK5KC8sDvU
   GdkWaVhorT2vGfnhGg51jFavgUytbvXbxDAq456dzBy0/1gd/CQXB40jN
   wGdfEEOk0ZcJj39iWSIhjPUTKml8CwKP5nUxmnPqtxuRgAaAc/Ih8ELvq
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239582314"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239582314"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:24:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="612155791"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 17 Dec 2021 07:24:06 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 07:24:06 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3VLXhPrWTdm4H7/HWV08+b6D6szYStbq6GnOl0cyzyPdYraiD1RODZqJLJgOBuA2KJl0gGR2H3BI4tsCJ1SXMk3JN3lRPJBnGWoYDa0A41aow+8ZuRgBR086DyKRa+pjxVWEZ3na9/w3k8dEPLiYr0y3ACCSpv+M9+wfjrQMFtkZj+vJtsvOILqUWaco8+ybDfmz2H9fcZtfyfSKzvQbdIvllA05DJdp8HAoLwIbHy71FYBDo1MVa/jMIT9urT1gCY6h/elTc//4IxYds9qhhIdjyhlTxUjcdbYXwSYLRAx9gtkEYe8sc9NSsi1th+hGMu4pgk7t2SP2Shh8P7yLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4b5go4/YtsGyYB0Q19mpjUk98wcmRiZkowb3TI87wqo=;
 b=n3QuZykJCapCztl4R9GM0LAsnNoMPTlpAvNQ6fc8qhaFAsiSKGWq8mIrDqjBfPIZuHfiLnvjswvcEf1CJkngDVfGSf0Y7YoyAvtn866/4b24aKKzDwj/WMh9N0wph+9iXBkqKQ/dSiWS3BJybDoQ08Ib554tkZ9pxC40os1E7Qb93GeNZQQ03pgRt2/OXVR2Tej40LeFlCMK6CY4fXE3X+pwCVwhxBBaIiaU7L5A28e/VUtSKrLx8JsRkdObOO+BjM7W+FyZqL7SMT2vtGJQDaeQsOaqsyz1vVhT7gULVLvOd9eOIMbhCu9DUau45B7jWsV6dp0v9IqFrCHDMKrvUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR1101MB2105.namprd11.prod.outlook.com (2603:10b6:4:51::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Fri, 17 Dec 2021 15:24:03 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4778.016; Fri, 17 Dec 2021
 15:24:03 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Mathew, Elza" <elza.mathew@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2 intel-net 2/6] ice: xsk: allocate
 separate memory for XDP SW ring
Thread-Topic: [Intel-wired-lan] [PATCH v2 intel-net 2/6] ice: xsk: allocate
 separate memory for XDP SW ring
Thread-Index: AQHX8DaezqwWNW2rwkqtV/Jw09wv+Kw2hPFA
Date:   Fri, 17 Dec 2021 15:24:03 +0000
Message-ID: <DM6PR11MB3292041274105D441B44A7F8F1789@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
 <20211213153111.110877-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20211213153111.110877-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f2fffb2-1977-4e93-86cc-08d9c1714269
x-ms-traffictypediagnostic: DM5PR1101MB2105:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR1101MB210535662AD6AED4BF572749F1789@DM5PR1101MB2105.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pASCGXVtZ8gAYZtL22Rb+ARX0ayFLN0/ZYLhmIqXU5hvLEGHcpkfdqMcWIMQXyiBGaGBx0RbijAcuS7M5VXPz6+N7b8z4Ucb21I1z5MkTvsPUNmhGgoMLpf/61hypPFw/9EjK0sfpJ6AGDAP7sS/FcO0/09n/Ynsvfx/auiCGn6lHK4Z52yBvLSoPnNR6iueTYcbbULLCV4BY4jkHrNukVNroZGsZNABxLReGCNqoY6MjxYOb0y+Lelz92LeqXJx23J1PfS+zlho1LQYzmZB/5rSYIymBc1Kwl4JLt8qhSf9w7YXHubVxo+3mP4kz5cQdZKh2rMegdrRgRdyILhKWimFIvjyO2TQH90FUSI4LIHl0jY+s7x3WsJEdDsUn3sh6ttBjAgRdiAtbwHR/LLs/e7Fuy9P1qyizERFxVXyYLWnDfVhMLgd2+9vqW0sFcwg0bAgiJcpny1lQQh3bQGIlNi2jTU4T1HKY7Mu+KruIQMHFFWcUYGYmWs7MrbN4pNnS+AYloW9OpHgTRHG6BuczfSzCvBLDJJiI2RyX5SQUtfcB6bXmRzG4o1/WOUbW31Tcwwf21dgo/tkAAbYKTmgegmahoB8VdN4oV2hn3L6SvwAPvNJpAfPtB7T515V8L0vyojQ+gzFL3pyrkQWUzVw2cS+rOz6juw88GDh+dTCc/aVS4gxQgfR0BDDOLpbDOhHDavnpc5RlDT8pfhKI8muzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(82960400001)(5660300002)(8676002)(8936002)(53546011)(6506007)(71200400001)(54906003)(107886003)(122000001)(52536014)(55016003)(110136005)(316002)(38100700002)(186003)(9686003)(4326008)(2906002)(66446008)(66476007)(64756008)(7696005)(66946007)(508600001)(76116006)(33656002)(38070700005)(83380400001)(86362001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xPZpOfG1Oejbra+qqAOHBPkoPis80SYjxf+TALh//FjAeSZ5bbwv6gMLHUAS?=
 =?us-ascii?Q?rS7IVzbTU4N1C3NqJP60yII2jvD4Ex2R+HhhQBWJBtIqjay47w9FGNOUgNGl?=
 =?us-ascii?Q?UplegAM4P+ajF/Pa1W4k9LKyp+Xn+Wf7VpMpcNzNsCQWsrhCK/g85DWWvkA3?=
 =?us-ascii?Q?j/NgB17+fMmP5ORUoDZbtt+ekxisQenmuM8RTn1LP8sGHJtUUPJFDHujrAuF?=
 =?us-ascii?Q?X25VRqnAWt6BTqnaBmBqeM0iQzCmX2k3quArXMFdmO77Z4wNSCwg+1OvnowK?=
 =?us-ascii?Q?OpTe/pBf2dzFWKryVZC/IdZ6wLPFJCkjFg1XgbPfFhUVyKAhHOKnk9pdoFd6?=
 =?us-ascii?Q?lW6JiBITw62q9X8/n06LkTnVKlkub/9gt7iR+3fT7hbFOaaZjEl+dI4b8Nq4?=
 =?us-ascii?Q?63F4+RvpUW2Uhzi9c5/l4l9bkqk4FSA1BgiEkvqAv96UyjleyWrCiasM5vP2?=
 =?us-ascii?Q?jyhG94xkIpHFr2dHqYS0yqtn1XRr1JnlRSjAdK1QoidWzOBJQWu8R/f/2ZKy?=
 =?us-ascii?Q?uA9c97QG5Z1b4GZbHThIBJX2ramh1eYYdXjeZcML4bXwRx17k3VWv1FGlm6+?=
 =?us-ascii?Q?xM9OEDHXZPBPpN1c5KUD1z3Us5wbPEKMuKQeCfrag2p52wi5lMXRSz7LbzCh?=
 =?us-ascii?Q?4Ke9x3n2JxMxE3USewIU446Xk8vIcjL7laxNhnKoyBAcaD7UuKHaTZH4+Fkb?=
 =?us-ascii?Q?1euT6857Rk6isaFtp91zW9hXj12JAjCKfjnTS0ry855GAWGbN7u0DLqd2BrA?=
 =?us-ascii?Q?uX1UFrxgMgKpFO7bJdqz9GeO2vRk7OsiLxq3RyezfIwVGmjl5O7wa4p7GBZg?=
 =?us-ascii?Q?GWgedFHF+xvNizra/O3wacZlEbiZeLmhsF2Nw00e0HBoqd/gpzEAh5hdG50Y?=
 =?us-ascii?Q?vZsBf7VH+IrP+ReKoFXpqjrZR3StVQbFEROTFl8JjNKSEM+ItUa3vSdK3KhI?=
 =?us-ascii?Q?4bHTyX2TtNRiVE2FjERCY5nEkZFtuPd1XuIEI6pYpbKmh3hAwdfTM+5ShJ3G?=
 =?us-ascii?Q?k4eGD46QB1Os/lU8BoEcRkWbBneUvwqfF6Se9Foh0boZUS1AFm/RstuevOnP?=
 =?us-ascii?Q?TeZvFZn8LCbEsjjz/BuJt7YZbMElixnGGwfbp4DKUaUpc/O4mb3WYy5/mGdU?=
 =?us-ascii?Q?1dKWTlyXUHLz7V0u7LYFkMiWAn88h9dJUHUmu4b+zadLgWfoo9uwhHWEUx3N?=
 =?us-ascii?Q?bcNstNQDE0TPXMXYbciZpEdI7qafoNKEbgqZe5ldWjxf3nIawxOs8/gWZSdP?=
 =?us-ascii?Q?uwe446hHNYv2IpoHPL3RTeQeywyUx8yMMHkIoefIptVRbI/Lwt8aJOLqtb1X?=
 =?us-ascii?Q?GgpEB97vWk/vdCkuTVDk7K+UlL7oBn7sbjLUra/vQunWXYnfuDn5mjZQ9NYS?=
 =?us-ascii?Q?JVT7SnipS017BISTW5Gysv0bVEZA85mibw3ge8CujlvHFkmEaHgdoa4vDGuU?=
 =?us-ascii?Q?oV195bYfZW/qavnvMRaGu44AgRr8JWCkNJJgOieG7pn/t2vC0vBPuW4z1ID8?=
 =?us-ascii?Q?90lH+ROaT7M+PyvLA68c3SKCcqkk3bbPMvH6A9F+VPHpkk4L6j4qObcUvPez?=
 =?us-ascii?Q?zv0Ec3zLUt0jDsSkJqGITjh/hjq1S6t/7znbKMWk3S9U+CyXSwEtkdBbAVAS?=
 =?us-ascii?Q?Tj9wK+BkX2DXUWNr1pgTrFZz0/1knj6OkhQ4eC9xQnUSqn2U7xu2YihqfQlg?=
 =?us-ascii?Q?66vulA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2fffb2-1977-4e93-86cc-08d9c1714269
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 15:24:03.8219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wToS8NRaBQE8Ya9T0D1zBRucgTDVvZmB70BBTOIBG24n7d/+PWf6w4INy8V8DUTzL9EabnKQr35G4CpIg6nlXfD9OCj97lgNdUPvOnj8aU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2105
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Monday, December 13, 2021 9:01 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Mathew, Elza <elza.mathew@intel.com>; netdev@vger.kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 intel-net 2/6] ice: xsk: allocate se=
parate
> memory for XDP SW ring
>=20
> Currently, the zero-copy data path is reusing the memory region that was
> initially allocated for an array of struct ice_rx_buf for its own purpose=
s. This
> is error prone as it is based on the ice_rx_buf struct always being the s=
ame
> size or bigger than what the zero-copy path needs.
> There can also be old values present in that array giving rise to errors =
when
> the zero-copy path uses it.
>=20
> Fix this by freeing the ice_rx_buf region and allocating a new array for =
the
> zero-copy path that has the right length and is initialized to zero.
>=20
> Fixes: 57f7f8b6bc0b ("ice: Use xdp_buf instead of rx_buf for xsk zero-cop=
y")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_base.c | 17 ++++++++++++
> drivers/net/ethernet/intel/ice/ice_txrx.c | 19 ++++++++-----
> drivers/net/ethernet/intel/ice/ice_xsk.c  | 33 ++++++++++++-----------
>  3 files changed, 47 insertions(+), 22 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
