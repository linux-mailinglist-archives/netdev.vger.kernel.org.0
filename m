Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E17E2D2B5F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgLHMs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:48:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:49790 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgLHMs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:48:58 -0500
IronPort-SDR: /SG0s/XEB9TaGDje9HjzQWKxz9UoYb47Vo6f1RoI+l8lDNHYb8CpDOE1AOunnZsoI8EGCBqMJj
 E747VR7u1gNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="153119763"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="153119763"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 04:48:14 -0800
IronPort-SDR: +l0cMFrKLh7XRsIhUJYoSEUylafnn4X+/wby9OPttjCIX3vJtqp0C2+4IEVKB8fn+3uWQ1XYrj
 FmrWSDJsq2sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="370374846"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2020 04:47:58 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Dec 2020 04:47:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Dec 2020 04:47:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 8 Dec 2020 04:47:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUthU5neeNNG6rprNZ1k7NhsfBlL6CCrof3WRGgbMuVSGeZv7NE3DOFmKov+t4EQs+lCQmwV9eXHDUrHzChIVB+gNNzPF1pwKwNCjTbQR4FPJqKKRQMI3EBtdPrOO6Mbgf2T7waXJH5Hbrq7e7QVebiMpUtwzWfnbU/PZwFjro5aSAe63Fgw3GBSItYcDA7P/Xb+p6AUtmJ5eC1l0pR7uVBlL3TDcvhS7Xo5OtGdOPc31rwK8QsViuPCNKzKYL8FTgEmToYiPlJARqFjJ6xVK8NjjG7Fe1MWg113hTt9Ag1CZOnZUsOiW9YGHlmyXxb3bp5lcMpDqcz0fCCiCv5mYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8yw4KOBhvGPV00AQC5KiMNww4PhZWWI/xueFWRQZZQ=;
 b=dhOM+utbdCZTp9trw8h9V/8kKEGkKkN2Uf0gTqC23cNfuOu73+5bnNw/9unmfsDapAs2Zimhz5u/oPBCdV6wBHxBRwnlScaZeLydlu6THwVA2TQ4NRFgvVUkIRvbL666+zKECTOYk/i+iK0lVnTkSC8Ex27Gar/Rz0FR9QxeaK6QqhfbpdcdhvHVvD7OXiaMeujH/9kH5JughVuAiqrRtaX1mjXXBaEhnURynSpniwEk93AEK0fO4eBJCzJvEpDCjjKelNyId/9USPLzzCKVwfcjk6ZWbDxNj9VoI3m2St2lS0S8vVfrFpc1YmPo8ALqcWQu/kvbritlt/xdcPgBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8yw4KOBhvGPV00AQC5KiMNww4PhZWWI/xueFWRQZZQ=;
 b=FJ5Dq4gSvCzLGe6pIPNnZkZnvjhs7Z8/UZ5O1WMgF3pWCw95ROugmE5/KktI0AAGydL+en4BkERhXqGciU3T5dc0GiwBmM3qb4GYKr9iPtx8p56IXT5vvonKGBf+RgwDrYqu55CtbyJgjkUauLO/AspXfHhrlIUz1Z6msP8ggqI=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MWHPR1101MB2350.namprd11.prod.outlook.com (2603:10b6:300:75::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Tue, 8 Dec
 2020 12:47:48 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393%8]) with mapi id 15.20.3654.012; Tue, 8 Dec 2020
 12:47:48 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: RE: [PATCH v4 1/6] igb: XDP xmit back fix error code
Thread-Topic: [PATCH v4 1/6] igb: XDP xmit back fix error code
Thread-Index: AQHWuEzroc8+fcAnikidrdvpYXVLK6ntT7JQ
Date:   Tue, 8 Dec 2020 12:47:48 +0000
Message-ID: <MW3PR11MB45547A2D522453E8ED989AC29CCD0@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
 <20201111170453.32693-2-sven.auhagen@voleatech.de>
In-Reply-To: <20201111170453.32693-2-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: voleatech.de; dkim=none (message not signed)
 header.d=none;voleatech.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.79.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eccb945c-3a53-43cc-735a-08d89b7777f7
x-ms-traffictypediagnostic: MWHPR1101MB2350:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB23501DFB269691116E4858229CCD0@MWHPR1101MB2350.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5odlTy3n/TxDl23rgGq5YXm4AzsYoqG8fLvEfVyKYBSchvqkEX2MwfdNXQwTW/lqynhe2yCRs5HIq1TUf9ou9IzFVXOCKzWiKljL2oTJAZWnDBofCnpBPLxIScTpul3JdDdIUEQzDW3aEi1gXpwFfoOugxynaJJkPSwzjzqVBRF7rF8cTQVIgX+4rlpIb7VxoM44gWd7v3sHnm2GmKk8hsH7WR3TMi51EBCKyTsLPkEmfAFIR6sOVV6EOrDDWh2U3leo6flWkhZhWD5pOIAXC48a+1YxEAwn3r/O5xekvV3SSQNfvABgSZoX+N+I8P20lPPCTrOzrf1EUJePLMX6oQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(316002)(55016002)(8936002)(86362001)(4326008)(71200400001)(54906003)(33656002)(8676002)(478600001)(6506007)(83380400001)(64756008)(52536014)(76116006)(26005)(53546011)(66476007)(7696005)(9686003)(110136005)(186003)(66446008)(2906002)(5660300002)(4744005)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5XynXT1QDeNTcWX5e6tXBzAvtUbTubU/5oYL9yhxC/AZdVqXTt4waNdwpPpn?=
 =?us-ascii?Q?jJVqLTpDU86ouW3TdKFFvhlIQ8YxmAar3HDVD+DI2ZBJtWghQ4mt81n2xeJH?=
 =?us-ascii?Q?o6jlO1U1mFSYAw6hqp+e1fjdSIAPj87EXtaa60yWCoD67EQspc//oasTPic0?=
 =?us-ascii?Q?q40j6y+PSjm2B2z10wTUewJrKbaMKuYzjm3q394RcEWNdEIWRNaoHWJOWRTN?=
 =?us-ascii?Q?BAj6UBFrBG5Z4dGgIRe9Pk5sRzszKAPcReGOSHQPZ2x18d+xUnNRBHOFsSwQ?=
 =?us-ascii?Q?7XHAepwk76k/G/1JJvk9mII7M8TxBzZMhWhfWMn6KpghbDwX++7ZNQyvZHW3?=
 =?us-ascii?Q?BKwZ2eJmo2fIs8TEZOxhxqCpN5K1JCSx/FxePJkAJ8wFNeGIVaM4Hl2JeGL9?=
 =?us-ascii?Q?nZ3KRt3TXj97XdcnFYE9xSE0wBbwzNVTS/hD5mslAnpkNtO1LRlmWhKHTCCY?=
 =?us-ascii?Q?HhWhhry2vdxSclSP6Ta3QUPvw8wkBala6k8IfuZxQL2n/JzEDpfSX/6yMKLn?=
 =?us-ascii?Q?t/Y8EfjVJYf2DF4gcH3JqvFhQfifSFfmBs9euOZGM5nwZL7soHhz7KN9gHTy?=
 =?us-ascii?Q?CAAP3+X/SsZTOi3U/eq/bzGwVfANEpmKXkD/5tkq2r3Vs+8js9Yz/ZaK8219?=
 =?us-ascii?Q?IiOoiuFUrgevcZs4hLRhPYBbGoUBwp2buCJF8AzXR+EWovcdg5vphXU8Lut0?=
 =?us-ascii?Q?/uRJt2xDR8v0ve2cZytCLtYe74FKaWIjuRIj6XVOPt+lqj6lb8TpJK8GRBMQ?=
 =?us-ascii?Q?QOGtDQYtvnslXkpJyhjtJgbP0kw/f8IJigccuAAS9bjBGBLdd0C+NnM5OHI2?=
 =?us-ascii?Q?ifeovydI5dccl9Cl1ZE5XT92CtinooMIaEIxcV5glGSsaTov4k4RGHgDc56F?=
 =?us-ascii?Q?QsSaJfQoHre4bN1fAhEx+NBTY0i9UxU85JsGPBqPt1iJ10UYNdeN1Io0+DD6?=
 =?us-ascii?Q?LTQHzBnI9urg2eJx4gXN+KfqGeIHNO6DQUVz/16GO0Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eccb945c-3a53-43cc-735a-08d89b7777f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 12:47:48.7844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0WLYqpidpeGSEw1s5gdQxiAvNiSXifnZPstssA1Dz9zgnDs1haoy6IMtb33fhNFGpmbp/oFoH2NC+F+QgZWk88Y7jE0KvvGwBfQuag9freY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2350
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: sven.auhagen@voleatech.de <sven.auhagen@voleatech.de>
> Sent: Wednesday, November 11, 2020 10:35 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; kuba@kernel.org
> Cc: davem@davemloft.net; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Penigalapati, Sandeep <sandeep.penigalapati@intel.com>;
> brouer@redhat.com; pmenzel@molgen.mpg.de
> Subject: [PATCH v4 1/6] igb: XDP xmit back fix error code
>=20
> From: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> The igb XDP xmit back function should only return defined error codes.
>=20
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
