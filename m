Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634704EDED5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiCaQeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiCaQeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:34:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD051FF42B
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648744347; x=1680280347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hnkhxN14EEHhBIO0AT1KjMsDOmbMrrMw1sU9I6yNFm8=;
  b=MHJD/p9Elddn8+V+qMz76vULZ8uM6XI7rAm1Z3wURrMnUNgeQZ0usF/M
   dv0c/9Ruvkpc1q9bn/xDBDZAaijKYt4W2YIgWexYcoI4RXZnYlBMVE7DV
   oe1KrZ2C4a8DGZzXAUQzxkSDPv2LDs2X2ROSiJDiDNr2FXd4tk7vhPLY2
   5dalv5GWU5utCIjfSKrlyb9jIsDbJL/ELrNBRoD1zP0tlMW0XD0aQMpHY
   oeeCEGchkyh/fAQXxa2m5r6hKO8NyvPJ9CeQJfYY3kQ5e0u46+QSxtBGt
   WyTRspsyK2f2B5T52X1AfyiLtlkxwqTyYHdqaG44agw28ihEqyLUGyTE1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="242038400"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="242038400"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:32:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="720527980"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 31 Mar 2022 09:32:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 09:32:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 09:32:26 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 09:32:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSPFSy+X0V3b2fYR8UttW6sral171lxL5mHe0AT/gJVbsG8F86N33LxtHuATJzqfm2Fs3w8PpbhJJlaiu30BKr9D+wP4Hf1TBid1VAfqieXvHrKQTv4fs3sU7eYgDDHG/Bp6EyFQNld6Zmw0ux6rQ7KyhB2mnPFbhEe35k94KXBMaaQQI4Yqw6YMZllao+U2GHqdffti3OQScj2vmuZkwFDdX7NTDpqJZPzWe8uq9pMbZ4dLiBADfGYUwb8kEruXNOmyDztj98oS/lzinN324D0Q0ohYgtwLuK7WB/3mK7N3WY70gdXAjFSdrfA/q5uZavDlPToWkJTqHUeQeSdIVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQU8+IIYppRmVXsh0E1BD74mv+h+rNq9KzSmwacL8QM=;
 b=AlnTx8aN1ELoC/W8HIYmL3Wbwb0Tiz9Ns4AbkJRs3/bdQJB0Ww9zAXmG+gQkuRIOhnATyhG0teVZ19T8QoF5KqraOOtBP71bhaFtYKArDQAmiYCkX/GFwSN98kEjSXsftxtiyI+iSbxQG8Zt2jUGy4K3WgeMSGPbRMcjFjiII2ndsoBM+ZkBEtSUm82zX8AYCwqMW8/Z/rNnsakZ+kaIocZNjDed9RWB+rO2BTOb/aeofdZ7vsEYPMDp5E/YQs1rhtv5z/zbYSYUXdcVuVyrHUz82okBc4w0TCMwY2mcNPdri6SyMV3aTpey1Rz/wJYMf7VXUGfcIB8yfOIs3mOdQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0062.namprd11.prod.outlook.com (2603:10b6:301:67::34)
 by BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 16:32:24 +0000
Received: from MWHPR11MB0062.namprd11.prod.outlook.com
 ([fe80::c3c:359:d9c4:3a54]) by MWHPR11MB0062.namprd11.prod.outlook.com
 ([fe80::c3c:359:d9c4:3a54%4]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 16:32:24 +0000
From:   "Michael, Alice" <alice.michael@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net 0/3] ice-fixups
Thread-Topic: [PATCH net 0/3] ice-fixups
Thread-Index: AQHYRRsrHW5+AjwSFE220QatcFICFazZrzsQ
Date:   Thu, 31 Mar 2022 16:32:24 +0000
Message-ID: <MWHPR11MB00623E688B1F85DB7E9C32FBE4E19@MWHPR11MB0062.namprd11.prod.outlook.com>
References: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4449737b-282a-4e82-7382-08da13340951
x-ms-traffictypediagnostic: BY5PR11MB3863:EE_
x-microsoft-antispam-prvs: <BY5PR11MB3863805D86A8421EA009B2BAE4E19@BY5PR11MB3863.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G6VJ9HcGNH9xz1MwJv+GC6cDTw5sDjk8ERjAE9LibVXI27Q6hIMcnbwxuAaiKMv2GcKkC7onpUlZIOHVmuFYAk1rMaSshYYs44HOi1kCcskBVr8pf+sGNFx8FBa8PDjsrhI/V8+kYvVii6ZCsT+qUHbtPMEU6O4OXT+EKFEU1jGyJlD1fqnxML4KLFoOF+OIJjAnRhMQy28ikvhRXg4FhCacjHZNSZ45ppRDWP2cf5zlVFQKK6NFXisXGNHb7T8BhL2V/VA5yI/N2cL/rm+mt23lku1DhBmpO791o6zO6QgwAhOsWZ2vPSXpZnRpXDi1H3uuLOwrCHZPaaYXQ+itDJjHa06fpxAfiswC5Qgz/KOivc38IVNmHqBg/0WFquIiN+/n3YxkmbZRzuF47VFLSLvWiJmtlstZi7oBL0NzcZ9yR1MR4vC5Y7hYE0X/Qe6j4nUV2xgfGZ1b4u65UhTN40uKM5rGd/U/+FPi4kXQUd5hFbz2EO5ppZrSo9hxdTMr0setDU8NvRyh1bMNzCMCbMxbMLF4U3OiidGQoK8hEXocG/LhzfXWg5j0Wb7rzsaO6dhE7O70fj4q2FqRqSpRfCx2Z+GHEBBDEQe7cVFzh8Bl2ti8OLe1zS+TMaBVp31SZC+kn83501GP5DDjiwQqJlUD3Hx7vQ9W1DMhrR3BB7JIvtREZqn1+FoJwivLuJVN9eJdp9TVkoMQNex8LloGBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0062.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(33656002)(186003)(26005)(2906002)(66556008)(9686003)(52536014)(53546011)(4744005)(508600001)(110136005)(86362001)(7696005)(82960400001)(8936002)(6506007)(71200400001)(122000001)(38100700002)(5660300002)(8676002)(66446008)(66946007)(55016003)(64756008)(4326008)(76116006)(38070700005)(316002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dhzQNMgCvQd6vJ/2B1+PmR84v2+moPGZAVrSlxyOpBe4v8OFhOLTDWob6rZS?=
 =?us-ascii?Q?IAeIvJzbVtSrx/YKaVmDAiJ+EFxgi6sYPmylFxqqmd5qKOXMJfJLKQtrk8Tg?=
 =?us-ascii?Q?qXXR0tLs6og7RyZX54ZSauqbmNN8l9qxqustFLbH34C6fdyRg2BjXme1xR/U?=
 =?us-ascii?Q?X9zcAyzGE9S0fa1NWwCivsD9E3lo/o/KURmR+7Xlp5C5gEmWcqGf/VN+wF6u?=
 =?us-ascii?Q?pTazunyOq/9h+dFnSNHNtGajVSOr7ZsynhpqqFOFnmO/ou2Z1MXnbsVUi+vN?=
 =?us-ascii?Q?VuJ8yzpye3GWH/3jQUOBrVT0q7MYVjXFQ4W8PL/MTfd6swWN+OfKAUEJsS7r?=
 =?us-ascii?Q?gKGWP9xBTSTMco5R9A2b9ngfifSvStsObyYOBW3uVgz53wTgSnmIQjpX4PpS?=
 =?us-ascii?Q?f7iq5EvrtZ8p3tZJRMHZ2Ho+9Jb7g7INEKZBxVfUpn4XgCxC8BEEkICAHJm8?=
 =?us-ascii?Q?owTmEeew9b38BqHVkn4HrV1WUh1nLUBb2CkDIk7Um9qec9w6Nm/WYUYfX8j7?=
 =?us-ascii?Q?w7XxnRzCPTIA1kZG0P8j+rK5oXFAoUYEdgOrP8IBASLc9bzujLbY/Pi3YrKy?=
 =?us-ascii?Q?or1Bq8eLaCr2YBuMsXpJrTqm9QFix987iyiYIvspevk3AMAxrwhemzgxcgEm?=
 =?us-ascii?Q?4nlms6mTPx7zC9kzLQcYY0JPeWq2//v4uV2NExXEec7l79bEjzzOMgDjMsTQ?=
 =?us-ascii?Q?uqqVkKn5mGGVdCqU94qXJB6pFwUcqZxx4JreWQtHuk4Z7QcR656P8BT28TqM?=
 =?us-ascii?Q?+CYgPf1PhhP9xJAWZCAq7/zrhzENOXYO3K6fQM0rmHcfrZO/CQhhzAQQKoiL?=
 =?us-ascii?Q?wCKx9ROpfhKdXeAMfi9/a8KzYUNCHM3etG6dfX+E3Hf/9vSGmLRx3XGBcSTE?=
 =?us-ascii?Q?fgn/qUW7qiZZgQ4bOO9YulBxXHHo30SkNYM6RQJ7AxtAOnUVE51Odl+ncAXY?=
 =?us-ascii?Q?zPBeitay3030VGJ6jdu7Hk6KqIfr3THajyQx/o2Lf6CEXGfv0wym6GrxmXmR?=
 =?us-ascii?Q?GdjrphY6vQb8D++e1+pJ9TpPsX2zEpxoDcx3fzOr+H+6Ciqlu5noLFb9BcbB?=
 =?us-ascii?Q?HdbWzSAM7bsE7d45n/K82WZEgSGPoBEuLLE22gAQ59j/6PlsZUrtuYmm+M6l?=
 =?us-ascii?Q?S0YdOPeh8Ad0pO9YPbHjXyu0FokUZOmEC9rK0DoNXS3cSzb7yDwze4Xxit61?=
 =?us-ascii?Q?vHIHU94wECQsXUfu+Bf5Q/2RMdR2FHrT1LNwyV8nrCc1dI0RaHc4r3XqMrDt?=
 =?us-ascii?Q?h/aO5rYluny5z+0DMG7z00Un1t3+nTs9F7FJUF4qPSB7DfqC/CcVHhb2U39H?=
 =?us-ascii?Q?wAPXgiosPAV1OPnsLA/YOa4riYMoyI+TXDOX849dhCa5JJPTmVP+wMB/N0Bt?=
 =?us-ascii?Q?AXwlBKjFLVKGOosh/5DTj60AJoImpd13Oh8qr/kTFRLvdZMnn0eICpLlTsik?=
 =?us-ascii?Q?f0aNn/tK2OMeBtXotVuhzIu5sRxKZvxFGzSiKslwxy1e1OWzBoYHj7cjtwFZ?=
 =?us-ascii?Q?A7uboXZCkE3xDRdmVRQ2xovcZcE9KiEsyTZm8D3KI7B/g3P3Ay4jH5SeX98M?=
 =?us-ascii?Q?lOzKfsR8eC8LrGuJpkHmvib7wX074kSn3gGu4v3wWU8fudxOaMRJm7F7b5s+?=
 =?us-ascii?Q?fYyulBHIy+vqY9YugEZcODQcXvm8/X2b2iey6z4phlyBbWuGtjFFa6PTyI/M?=
 =?us-ascii?Q?SnBFC9VGF4KC05NuCURJK4tOnBPUxhOK97ZiKRhdBn0pzay2T169PGnms+cP?=
 =?us-ascii?Q?vszkOs1bqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0062.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4449737b-282a-4e82-7382-08da13340951
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 16:32:24.1281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8GHECOoZtYq2cJ4Hbqi4sS1PhUFjmyOnothMPfDS9jH9LzLB/RH+xwVKT2Qb7B/wuAvzcr1hNwcYxG9MHhw1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3863
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>

I did send this series and was OK'd access to a machine to send
these on Tony's behalf while he is out.
Alice

> Sent: Thursday, March 31, 2022 9:20 AM
> To: Michael, Alice <alice.michael@intel.com>; davem@davemloft.net;
> kuba@kernel.org; pabeni@redhat.com
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> netdev@vger.kernel.org
> Subject: [PATCH net 0/3] ice-fixups
>=20
> This series handles a handful of cleanups for the ice driver.  Ivan fixed=
 a
> problem on the VSI during a release, fixing a MAC address setting, and a
> broken IFF_ALLMULTI handling.
>=20
> Ivan Vecera:
>   ice: Clear default forwarding VSI during VSI release
>   ice: Fix MAC address setting
>   ice: Fix broken IFF_ALLMULTI handling
>=20
>  drivers/net/ethernet/intel/ice/ice.h      |   1 -
>  drivers/net/ethernet/intel/ice/ice_fltr.c |  44 +++++++-
>  drivers/net/ethernet/intel/ice/ice_lib.c  |   2 +
>  drivers/net/ethernet/intel/ice/ice_main.c | 121 +++++++++++++++-------
>  4 files changed, 128 insertions(+), 40 deletions(-)
>=20
> --
> 2.31.1

