Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF81741A325
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 00:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhI0WhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 18:37:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:58854 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237575AbhI0WhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 18:37:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="224227851"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="224227851"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 15:35:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="707473627"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 27 Sep 2021 15:35:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 15:35:39 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 15:35:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 15:35:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 15:35:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEqeZQ4uaDd0AL+PTpO5IOAONOO5zOOYvY0KIRpXJLJw3z0EIBYH+lvv94Tey8nOvjbP3VcjFPkiuLhvzcgwbCUZN+0PDqZi0//xqjc3nX5Ko7QPR57+beV3m/gk3rRdeuZSABOnvvBWv1pWy4jH2Iplf5Xxer5uhaU57xE+EisAn7eUO5lBK/UyxvG65jN/qQNg6tPtdtm5ze4MRum+1Y/C2BMTL2gii4PUQkIe5LdAruGJQaIecK1emg0GTk+u/QukuN/gmiEVqu78qWwqogt5ryjLopXD2CnUY/QDKUTBsQHFpH8K9j0xpmcSxXxHRelhx4nJZ8gwKMg7v3X6dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VSHUsBd5G/O9SlZlgABlXhMH2RxpD4cjyX7SLj69EVk=;
 b=DeHIEepZYY8tm2E7lAVEK4GRwHbHrIKvZI7MpcPr/e31dXIGIMc4O8JrOiNyZZtSoxdew0x+qlneswtNUP9UZOb1SHQGFJ5DfLpLnXo/HonZEwDGq1rat2eGvFsAG0jkiWDRgWPXxP6yiPN9s+Yk7/H3tYwSY5GxuTcre+p2nui4Gb40rbqV3RL5p/t5Zwtg++uj1HkOHKDTU6TE33GzBifqHev0iVEmJ9eC5xg1h4S6Zy5VMN0eV0wEc/sDMIoS1SzxU30rkFqTTDru03c992CILSVDRY1K55hR1xTPHtOMX2QvFaCUWtLWUnQ/pd6OVXLLjUUBvyEhRBcEuhU0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSHUsBd5G/O9SlZlgABlXhMH2RxpD4cjyX7SLj69EVk=;
 b=tlPE6YSjELn1AnAhPlqe1FhD5jSkjtAOPI6tx9jj1XvhAHgxSwUIMxF8L9YZvbiA/N2siRGXUVaE0/eaLv7BYzfhstTHwTuaukPy+ZQrxh17RKTf2/W1FjOOVeUp5dJgTKfXpmsB3kEGNdhPOIKgbf4tg3vI4wqGV/l94woyMRE=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 22:35:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adb0:ecb3:3ddb:8d3c]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adb0:ecb3:3ddb:8d3c%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 22:35:34 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] igc: fix PTP dependency
Thread-Topic: [PATCH] igc: fix PTP dependency
Thread-Index: AQHXs6IOGDZvzKltAUSzD1rjhyQtZ6u4eKPA
Date:   Mon, 27 Sep 2021 22:35:34 +0000
Message-ID: <CO1PR11MB5089ACD68BA016202174D9A2D6A79@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210927131730.1587671-1-arnd@kernel.org>
In-Reply-To: <20210927131730.1587671-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e3dff11-120f-4f47-b58b-08d982071f03
x-ms-traffictypediagnostic: MW3PR11MB4633:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46336EA46CB997EDE583AC55D6A79@MW3PR11MB4633.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L2np0DlqxaVMUm92uS1ikJzPerfoJl+ghVdEFbfI1Kpm/5YEy4Zgh7Pwecp6NKMyDMMrM49KMkXHi1DTvkG1MUfEjhxlkJHmIYSdMCurQLnrIC7+Km6Ct8sbzOalWBGW6lGcIOC4bzxJ9GAGOocviaeyz2loHxlnhLXxHEvmtMw+PGOtSvrK3rvc+EGyLwqhMRPzIPqT7YTzMLRGOu7Cmi67O2Uyv0TX9cJ5wK/PTM3QWyLL6ecOPIDDdqwT0JdAEnu98MIxqEANT6JyQq5SecIXXzPPp1Hvp+RAbUBtv0KUTtDPS65oe3f25cs3bYMEzwLMs4oeYi5jC3mnrwUit0Rar3F9lYENatIf9Hzn8N0nnPE3vmEwF31I/6G5JvKzeuxVHt5WCzCabN9PoXFPs/9Lm2d06Ajr5nI3iKI6HAldxBeZ333NvBDXqnHGhkWBPnNpNrZ88FuoIrOzlwoK2oeqXV15eHZLzLCiSqzL8Rq3iHaGgOIANj/GyQtWCD0uJb3gP3QFIVFt4XbtGj2ZTIrJPweY/ssNBiqI4BGqf1CsGYkhQgrdBaZv9BDTUCn1LF4NsLKEo5JWnf2k61lXhRn7w1HDDCWVTfFmvsaQ7+PGi4X/kqGwcVNPY1b08jHcLft/f0tbtxKgaYwsZxB4HAEh3DtCZCrHxf7ktiFPVQzNm+TXSPKb+VtLOJ5nS5jFKr4GG5T6kjdCxmFJcrujvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(122000001)(38100700002)(7696005)(66446008)(64756008)(66476007)(66946007)(66556008)(508600001)(4326008)(26005)(33656002)(6506007)(38070700005)(71200400001)(7416002)(186003)(55016002)(52536014)(86362001)(54906003)(110136005)(316002)(83380400001)(8676002)(9686003)(5660300002)(8936002)(76116006)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7P6lBvBt9Alxa0X8TO9t25/TGKzxN/YZQNFy6WmHwC3fCZQb29yBR+GAvKJk?=
 =?us-ascii?Q?fTd+1JKfjc/VonIefx8ap3YTkKnWKAFRLWvE386xGbLRp7vdIWQbTtiNtDJG?=
 =?us-ascii?Q?QqBBa1rnHpSbvq+YsFoA+UeVOQPulnZrkIFV5CDG0NWvvNLS8V8nUuqCvtX0?=
 =?us-ascii?Q?pHIpLB1Hh6vWABS85qYK2jgQzIqNR3ojhVl9rqnBeG01Q7EWt+VLc6mTc+j/?=
 =?us-ascii?Q?8bNdjgAxILz9siolUhpVnoxsuNA8zFmhfDlFml/DgtWRvgsEAST/6e/EmgDF?=
 =?us-ascii?Q?F7Ti7gmYr5w5cZSOmx8u+mSL3fed4VOfIR+igenWVgwq6jKXGFo8kEKpx+lz?=
 =?us-ascii?Q?/hxJrtscL8ZSNV/K9nZZbKWXvio19YytrcDfCOBM2XiTKK9CU/PYbEjNPiZY?=
 =?us-ascii?Q?KHpM1HR6sfDcE+UhvbdfZRaWoByMh5BgWjWyG9d2Nt3l+q1qdf1lFk9P/Fot?=
 =?us-ascii?Q?Fax/vWC39hZigXP6Vfpwboy4GU7pxOtL4cJC2hFPaUsflSg97YOuxbNO7d9O?=
 =?us-ascii?Q?W1ACGL7bUn4aOf+9dbuAr8Tiv6poZRRFCjK7dLiaY99RiiV6hZqrxcQlkoX0?=
 =?us-ascii?Q?8JLj991yDdQcvzfecceYbO3hD49yI0ayBP2EAazJbdFmoDsIq2Mia6Bof9XX?=
 =?us-ascii?Q?j1yoX5+W45U2PksQaXjkOPhEdDZ80m57aQ9xDzTX+ZSkyueS8IqAcylA4bhl?=
 =?us-ascii?Q?1jOZXEyIpRpyviJP89aGhTpzFrRn+AjF7az5WAfsJnmA6PbVL3sBJE+47SBw?=
 =?us-ascii?Q?39hFiJ7Uo+OR0Ump27z07FIAmQOlEMi3t20XlQduxYzgqFvv8Q4dHyI/6JD0?=
 =?us-ascii?Q?rxXM3dSJWb4qmR4PgvFMsfQQVZTQxmWbaj/RE/3s+w8Vai77HFmslwwkCdSV?=
 =?us-ascii?Q?MG02esQpO+Ql2zF1uYgNPCqrzHeCnf5Yz+Y9v2U6sQwGF43RftGKQ62UrZBb?=
 =?us-ascii?Q?mVp+bRDzYlNo3GJcGKabGZJIadsNcA8jm1MkCzBjR9uNPwa3dGNbhXah1U0Y?=
 =?us-ascii?Q?91BEJUikL7ecVUSgRD/gDapKKnUtmFwn2yi2xo6v3XoHSOX2bN/ahtogehaU?=
 =?us-ascii?Q?oBfDWeIGqFs8UKLpGBwFeVMbSnzo2Dek2nq6aBcqIqp1tAoJWEILX6marK0R?=
 =?us-ascii?Q?99S3V3+fJtjiULnb+87q5M98qFWA78K/u+1kqKbGGRTJrYiWaxL6UZNiPf5Y?=
 =?us-ascii?Q?sO4p+UUvUZNItt0/6RqDRU/mYTUzZ2yYh4BK4KJ7cd9TUlNEsDIUB9R/G8eg?=
 =?us-ascii?Q?gONnJfoLdCCLm6CGpjHltllwTPeJbqguwtQ/OOZQv96R40Ck5OyVWvLdJZBM?=
 =?us-ascii?Q?bZk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3dff11-120f-4f47-b58b-08d982071f03
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 22:35:34.4373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eapbzNw1hEy/lO+GmuI4e0Vhm6uKI4+BxrPGL1bH5Y/ozK1dJKJlSTqHK9LyUInbcZEhEAZXHaMCgYqLiCohYKfFjwScGe5CSVeS8AM4XQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4633
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann <arnd@kernel.org>
> Sent: Monday, September 27, 2021 6:17 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>; Keller, Jacob E
> <jacob.e.keller@intel.com>; Saleem, Shiraz <shiraz.saleem@intel.com>; Kur=
t
> Kanzenbach <kurt@linutronix.de>; Ertman, David M
> <david.m.ertman@intel.com>; Shannon Nelson <snelson@pensando.io>;
> Richard Cochran <richardcochran@gmail.com>; Vladimir Oltean
> <vladimir.oltean@nxp.com>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] igc: fix PTP dependency
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The igc driver was accidentally left out of the Kconfig rework for PTP,
> it needs the same dependency as the others:
>=20
> arm-linux-gnueabi-ld: drivers/net/ethernet/intel/igc/igc_main.o: in funct=
ion
> `igc_tsync_interrupt':
> igc_main.c:(.text+0x1b288): undefined reference to `ptp_clock_event'
> arm-linux-gnueabi-ld: igc_main.c:(.text+0x1b308): undefined reference to
> `ptp_clock_event'
> arm-linux-gnueabi-ld: igc_main.c:(.text+0x1b8cc): undefined reference to
> `ptp_clock_event'
> arm-linux-gnueabi-ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in fu=
nction
> `igc_ethtool_get_ts_info':
>=20
> Fixes: e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

-Jake

> ---
>  drivers/net/ethernet/intel/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/intel/Kconfig
> b/drivers/net/ethernet/intel/Kconfig
> index b0b6f90deb7d..ed8ea63bb172 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -335,6 +335,7 @@ config IGC
>  	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
>  	default n
>  	depends on PCI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	help
>  	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
>  	  family of adapters.
> --
> 2.29.2

