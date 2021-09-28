Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC21341A9B4
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhI1Hd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:33:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:43771 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239083AbhI1HdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 03:33:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="211722978"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="211722978"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 00:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="437102156"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 28 Sep 2021 00:31:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:31:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 00:31:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 00:31:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lb6Jdn2I43igkHvnlnW29hn/GtSCVJ4NEpvs8ivskVjgGJTZTmujPelIxPmFwJUZpR9R/KE5KgQrOoIFjtsCRwmi7xQq0Y5LgMRZ4oAXaJoamU/6tfej17sH80fMxcwR3FEG9zmzID0erS0j4TL3I/8NBj0hkU0B7ERgXHfFJnMJmP2BBDImJL39cDkHtil3iWNXKAcWlBnbmp0H858VCBLho7iWvlSc3aDtBVCkj/OwurvPWs6LKDwt1CVwZyC9J7zNcOHnr1Rc1pOnN5VMJALQZP1AGVZwcHXAe1FtZgbRmAreQrTyGMBtoLLz6uXMTzLnyTwHnjMCNf3k28hUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7TreN8Ba8XOsJ7+E/5FKQ4z3mjty3sDtjtkaX0ggNx8=;
 b=KBVaCuHPbzemfWVcRS/+VzNWGErVyM6m3qhKwvCO07RIvCBjhJRnPWXMetRoQiO3Bg2XJ3o/o/y01XjXJvkEF241rBHgk8iWrnxryGVhsIUe8O9y+7kMVcXq5ckCKro/kslwz/AOdnxihiFdqlgsPd4/G+cVdbnBLEt1S71soM55Idt5y9HWbxvzkSfK5NbEVeOq1DNCGVzttpG55WPdVLjna5rddh2jCmQaeRSuZDRICvBjYXNnKKoFiC2OwBBxQMFa0bGgwzyDh/FXB0SSmkiZBPqhvBo4M8Ww5O9xbaq4VVqsdKuM1r2eaHOyTzPJSFm4zeQOhmzekgq96u9VSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TreN8Ba8XOsJ7+E/5FKQ4z3mjty3sDtjtkaX0ggNx8=;
 b=Np7zaspi8iprrh/8MmLeFSRUPQP92FyBMr8fsBssaPr6PzT3sPKTDu5OJN7lg0749c7dMiaBbDAZvI2Qt7+pqTaBGLya+sthPHgCU8OsbzttZMiVg6ug09lVAl6hoRDRoR4nqIAYKJ4vBogYqpDfuj9WuKwCwZvP19dvEmtQlc8=
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by MWHPR11MB1296.namprd11.prod.outlook.com (2603:10b6:300:1d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 07:31:25 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::44d8:67f3:8883:dec7]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::44d8:67f3:8883:dec7%3]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 07:31:25 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     "Tham, Mun Yew" <mun.yew.tham@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: Update Mun Yew Tham as Altera Triple Speed
 Ethernet Driver maintainer
Thread-Topic: [PATCH] MAINTAINERS: Update Mun Yew Tham as Altera Triple Speed
 Ethernet Driver maintainer
Thread-Index: AQHXtDht7M2bvX29Z0isrz76daj8e6u5DNTw
Date:   Tue, 28 Sep 2021 07:31:24 +0000
Message-ID: <CO1PR11MB48206E39FEB84F36BC237B08F2A89@CO1PR11MB4820.namprd11.prod.outlook.com>
References: <20210928071056.11588-1-mun.yew.tham@intel.com>
In-Reply-To: <20210928071056.11588-1-mun.yew.tham@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25ee8c21-a404-4248-4fd3-08d98251fa39
x-ms-traffictypediagnostic: MWHPR11MB1296:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB12968636CA68072D21ADC36EF2A89@MWHPR11MB1296.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qsnoyNYM9o4BdmYLouX+vcEQov4Up4+2ClB74PDLgX7+M7SgaXbYYKQviPszEbFiKonbbgd6Lysxo+wiblRvNf/kgoxR0HUjD1DEFzxNckwmZCVSmoHVVTx71VIggBTwMYX+w6ucGZPPA6yVKpe0fZsAGXOzpHqmMMRtRXIP76S/iaahtHuczgMcJRinagwSTJgE4zjO0GG0BaHwlV0Cm7uvNHjF3yMXTel4TrSxN/XKoGU1qds6/QE7IYDMmfgFC/eXvFfj5ppN6FmBGJrTxoT67qvSYnJ2RnEJGgePzrE6q4aeiPjkdvfzefX8T1lkTXWXfEJVsoeHTJZWFXqGv7Ah6TV2yrvMM8bSyHkf2hi7f8fvz6cwqBKC8kMLJI+WvDK4a/IU/HLOKxrixBlOUsbq2xqh2H/45jhwmEmitXHwjO+0CEjfqVlrT9f5G40QTzfEYvmRpPksXR5V8TI0qWMMTb23H2/OvnIT8U5jjwOvgwe7TO286rB83zGYDTA9JmwSRbKLBAMm+wOSDOiEg4lPTpYgY9aairv/1/Bq53C/hmKnyGtHxgQ+RAaI4emp+5JE6eVxkKHbF86aO11nYdSrHIp+0xLbNx2bT+Pl4D7nHAgMXtUhm26xiEG/AfvDWJ6ODpbbWt/EmR3JI+kgcBIstCjrH9LmmPsWP12zphY6gCuJtuTrFOleOWglFBWwx6sGzk8oiTXSvmDoqBdoVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52536014)(33656002)(66556008)(2906002)(38100700002)(7696005)(86362001)(55016002)(6506007)(8936002)(64756008)(8676002)(26005)(5660300002)(53546011)(186003)(122000001)(316002)(9686003)(66446008)(15650500001)(38070700005)(76116006)(71200400001)(66946007)(54906003)(66476007)(508600001)(110136005)(83380400001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3df0xeH8mlpg/shtGcNtbY53Ho+DzE0MItSxZky9XehxE6te/UtOzuuH1e2X?=
 =?us-ascii?Q?fz/PAa9dtrnBr/DfdQe7qk7PCzX56t016uREhnhqKnDiRQB7wj+ealdJzDjf?=
 =?us-ascii?Q?US2Dip/TA+62XU8hwEaNV+6GepUZpOWE6mLR+YaVJDIcvr4vECx9wNGm6RYe?=
 =?us-ascii?Q?ABAZVH7NUgh0pd1ltTFAvvhT5YjyxP35fRzoqhn+P7oVHmUAL1X8m2JRSd3J?=
 =?us-ascii?Q?R342UqRBxbCMkPcbWjaY/hjCEB420uAN0D+aJ5QR3friPwTU+r+m3T1sUg9S?=
 =?us-ascii?Q?UiZCvXg0TPWwn0uRw/ykV0NIYN+LbdqTcYXQbj6mnbcUdSt4/HubTfzFj2q+?=
 =?us-ascii?Q?DuYycTIZnemtm1SmCXFgVQXM27r65bh6EfLPQ35i2p19kZ9mAGOETcZw+E1w?=
 =?us-ascii?Q?GhBn1sKmEpAmYC1LydNiR97mAFeSebcmR7wd974TLM5r2o0GGjsjXjIIrNdD?=
 =?us-ascii?Q?3K/Q7XcTc8M0i6HdbwagBflfPTwwrzE0lFAUusK2aiNL65PEOt4Jxff2wrR9?=
 =?us-ascii?Q?C2+iEdIiyHlvouYT/i5rGkjTLzCLv4KXqM1E4UbxxbwnR5nRcNcidDmFSLBu?=
 =?us-ascii?Q?N+Z+d+C8Si6LVeZrBB2aiLy5gSZaQck9nr0VihSI4u3nxevlFaB2VuixTcLG?=
 =?us-ascii?Q?65h8MmagUEIo+Jdio5Tieaz8P+hbzTJkDsCFG6I/uE35wMIEZB/i8MZv1sHV?=
 =?us-ascii?Q?pf8caE9xb05tjGCM27/Q6dWaTd9UP8DFSALNPMAehjYZdaYOrFvFX1DkIvvo?=
 =?us-ascii?Q?IOoJO91Qb2dmiGKix/N/66K9awqU7FhvqkH2R96Y2Fd+Yyzq08u5APk+wdeV?=
 =?us-ascii?Q?qVV87SEaelO3ojbvcY0FAnppudwvIL2e6xisM9dlmKwM7HKklCULFyLQhxZC?=
 =?us-ascii?Q?j47P9QZVEW4ly8/4s5VPwO2j4KTaiYqK4uUfPDd4SAxDlXLLqJK8p8mI0mFm?=
 =?us-ascii?Q?obwFiAJy3bEKCX/QtbnzhrGQxSpyo/6ggnFU851d8BZ4g6UOkRABZ+ggMAZH?=
 =?us-ascii?Q?9qDtGAyFf1ok3jik7f34jzi8260LUKnh4VrU8jSpd/621yIboxGuydDzJTlf?=
 =?us-ascii?Q?TATl0QdajDrbJ5hzM7HEn7HadnPbgCPxMtxy/D5l0nOrR83+/LflTgrnhojm?=
 =?us-ascii?Q?3NhIwtICSsBda5tDbMj1j02ZsIkVQ4hqHQTI2zfrQHBXXOEXvlyu/jkf7/4o?=
 =?us-ascii?Q?3TgwPqJN47F6ijDScvq/Fe0rAa4l+H4oVr88stRsiGZEo4imtljWKBxoX160?=
 =?us-ascii?Q?nQdz0g1mw5ardsm+EVmBN6xUZK5KRYp7Vd0N2gTjItydQ/DRiKH54nC/V2dV?=
 =?us-ascii?Q?oW+7+SqmZcaXPBCathUzIWp9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ee8c21-a404-4248-4fd3-08d98251fa39
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 07:31:24.9795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L5hcHe1WfD2jWY4s3ViRHs428I2GilRsC3JdZiXXx6fUNrqKf3ube/OfDR+p5xZvP90av5kiPs0CwBwj14p6NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1296
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Tham, Mun Yew <mun.yew.tham@intel.com>
> Sent: Tuesday, September 28, 2021 3:11 PM
> To: Ooi, Joyce <joyce.ooi@intel.com>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Tham, Mun Yew
> <mun.yew.tham@intel.com>
> Subject: [PATCH] MAINTAINERS: Update Mun Yew Tham as Altera Triple
> Speed Ethernet Driver maintainer
>=20
> Update Altera Triple Speed Ethernet Driver maintainer's email from
> <joyce.ooi@intel.com> to <mun.yew.tham@intel.com>
>=20
> Signed-off-by: Mun Yew Tham <mun.yew.tham@intel.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7f4615336fa5..4a591f1ffdf2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -831,7 +831,7 @@ F:	include/dt-bindings/reset/altr,rst-mgr-
> a10sr.h
>  F:	include/linux/mfd/altera-a10sr.h
>=20
>  ALTERA TRIPLE SPEED ETHERNET DRIVER
> -M:	Joyce Ooi <joyce.ooi@intel.com>
> +M:	Mun Yew Tham <mun.yew.tham@intel.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/altera/

Acked-by: Joyce Ooi <joyce.ooi@intel.com>=20

> --
> 2.26.2

