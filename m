Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DBD5AA7B8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiIBGFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 02:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbiIBGFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 02:05:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BF132043;
        Thu,  1 Sep 2022 23:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662098734; x=1693634734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sj21uggCgvBUUMVa0YFfGpH1F5ADzg4Fy21psdW/wW8=;
  b=hojFkCeWwFZJYpfSGb9v7uT/+Grk3K74ERQ8G0bVe0NGNOqGtX2ve1Gw
   +DuvhOxC+f2j98WgstO36Eidw59fYhFFgwXO7wtdHD1HpqFm1wl/EjXJ8
   OtlVwF/uRY+oCH2L8TlTNFuOkfnvdm14BvaiFm27c3WOES4AXPqm9ISOd
   0Ew5AZNfZ+NBMk/Lb0O6p80dJpeBo51tqU6B0yChduQgkp4Zlt/40Ioy4
   B0uQ+Sn7mrrxjREA7kV8Bz5nFo/qUXrmI3zh+dTvt1vQtzTbhJC9POyjo
   3mOVZTG0KLTpFuMEaPzmz20WDyJZHiuqhZzw0Kk2WE2j1hfBbH0/0YLel
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="359861473"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="359861473"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 23:05:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="563849002"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 01 Sep 2022 23:05:32 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 23:05:31 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 23:05:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 23:05:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 23:05:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNRm9pZUjaiAn6vYF+3scw2+z1RQggmBKLY9BvsK0jB95DbZiwqXrVLq1jMhq5ZdR9E6DK2UHi5kTJglxbmNi93Z1fs4phHOBiCrOpCTdjswkAbZYDOoZ9s/P7uKqKpLePjpylodJigjeCGshbFUkQ/iBvPRQygp0A2pRulFq5OT1mBfjmHWX5ezX6/CH5QXHt3ioBBIJuudIkpX495pB99BcBD8AxlpLhsxjFI5yh22h55magpRjnB93b0Q+65HMBwn9lsJkjoSgM5yDUx8xkCbMqPcA93P4FCks2tq0qwF2jsEXfjBFCnQLsbp5lzMpNqOswg53ctQZbBG59wIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIncHbaOAQipeIcQeXpB7M+hV6TkfrH5PXRwxwuCFsY=;
 b=JSNvyeyBDh7PgNmx8b5HpvTo0WZ/Wir5zP5y8+RYuol44+v6hC+eT6BwEvK+HNmTCbPSS8OU+fHHQpvPa6zgS/fQIW4hy40AdJ0hbCqjGd1eK1OK0+xuaZ3eH1WMMEB3TnNlgJ1wj2gT2Crl9qTUZUvSctJGTqLObTHRskaHi3YhV9G77908VibKU5VB0PuqX1nWmm1uzK0rNJmQP7DCziJbLGz0nlltLt/iqqftNHYWj7gn2VAvntCkDk1L98Mb/D+knKurC35rWKq9eyEJkDws6FOtQP/pOjMUHq1rxI8skzTNp+IBDqB3qHFybQOU7meBnuZVQYHytwrP3yOqmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 CH2PR11MB4423.namprd11.prod.outlook.com (2603:10b6:610:44::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.19; Fri, 2 Sep 2022 06:05:29 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::f43a:da9a:b75d:e4bd]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::f43a:da9a:b75d:e4bd%7]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 06:05:29 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net v2] iavf: Detach device during reset
 task
Thread-Topic: [Intel-wired-lan] [PATCH net v2] iavf: Detach device during
 reset task
Thread-Index: AQHYvEjp4Yu/q51mJ0mt3lC1j4/Tc63Lq1nQ
Date:   Fri, 2 Sep 2022 06:05:28 +0000
Message-ID: <DM8PR11MB562163A58A2B970434338D2EAB7A9@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220830081627.1205872-1-ivecera@redhat.com>
In-Reply-To: <20220830081627.1205872-1-ivecera@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99792f8b-bdd9-465e-c634-08da8ca9230e
x-ms-traffictypediagnostic: CH2PR11MB4423:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGEIIH9JFK9L1BvinPglplt721vLJIDl3ZGYx9wCitiuXMvtvaqwSXvu35E5vWSPPsr5/bTvDaU2JsAHu+b46HRC1LKSTh4Jvp0askd6euPIoREO4HdkCCV6XGKkgxtOImdbNDAd8PBjKPNS9FWmzdkPH7ZgFoNBmNsLyhpJO9FRfZ2D+2F8lGGIvwPkZrSw62pLEFfARxJkRQTTzPznZq3KD2TDOmrcalu0Jx060zdWh01cuQGD9YSBwBBC4ns5F2jexUA3kIZCaHTvQURQHjlaRY45nSGE4K1DhMhZ4AC6GgAeq99eMHgjlzF1/nA6H6NiZxMkwM+PPYmCfAPMXMMDxn3P3UltOCFcuidaLprAtqBFZtR/Yj1CSgPwlzspOZGd8dJvxdzBvAY+szR0NuVZ0jC8uraRQa7kSXAN9a7Oz1s7DauooHkc80qok+9JyI6FIAKpmJp6Pj6Ed4K3V3+7xq21ipuEwRMh2OfzHnbEjFw22W8+yjfkiUUXUaaqXq4ZDiW6jld9WYO6qA+TkRDh/1m/1kuNvje6zzJ3ggLJZLRWlZyA+brJvWFizTC7LwiEO88vQyXs5AgyL/kYWfBDsorHg73OSj0P8m7N/3GM7oz1491WzfbY8fK8d0RI/2IwTlaO5tgypnVtaz0YjWIHbJmg9jhwUN7tsc6BBbHJxjyQ4zGqSkQmfxPkdpoffBNVzXQlJZkqSkX2CXmsYkl/qetuY9LKt4u+Zn1WKOOg2R5KgvsT33oi9Z9Dwiz5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(376002)(136003)(39860400002)(86362001)(9686003)(82960400001)(76116006)(26005)(53546011)(71200400001)(33656002)(6506007)(41300700001)(122000001)(83380400001)(478600001)(7696005)(38070700005)(186003)(8676002)(66446008)(55016003)(66946007)(8936002)(110136005)(54906003)(2906002)(316002)(64756008)(38100700002)(4326008)(66476007)(66556008)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?259cyaadjsm9ES7g4ox9+AfF7GsM+YqeY1Wl/MkQHYnubC8xIQTof9Q8jopE?=
 =?us-ascii?Q?QpxUsgiGVtSsu141DErEBrEYFFcKabgz1istVvtXz19slG6qUkqxMHpWB/Zp?=
 =?us-ascii?Q?zrWV8VAQdwYQCcVjRYKGR0m2plO386AqLLZYQV4iWpEf/b27GwoilPbER3RO?=
 =?us-ascii?Q?ztSLS4eFfhM9fycqmY8kvsh2zgbDvrWL7ATMko0sS3C2BDIHmw8GqBc5pkdD?=
 =?us-ascii?Q?q9PXwW2GPXR4uciczGNNxon+4WsQvpdCAmBl+J3IaRFtvzp91jlU4yu6MuAn?=
 =?us-ascii?Q?OPp/lvd167bSMXwOMHOJTuX3spOtm1z+MK/Fkn3YiAi11VO19+8WSFTTZ9Ir?=
 =?us-ascii?Q?SjjYnE2ddD1o9FD0TWcA7fRSxlQE5zS4Jgc+Tnv91I5fBzHuQhWhyIbss7SM?=
 =?us-ascii?Q?B9N04cCTmoYzqUFYXzoqDLDv9vgaB3sWTS21ZnRERyRGM0da6CU9Cd0yCWEy?=
 =?us-ascii?Q?+tS+wxme6O2MKS6TMBhweYbt3k2aYry7GMZ6fHvZSQxKtUtbwOxE0IOeh0Sv?=
 =?us-ascii?Q?HMkHWZ87/UqahrqyWvzcUJarENKdLGdKFwNYjKLrRl/mj5AsVl4KsVTlu5eG?=
 =?us-ascii?Q?ibacifZ3Vr8ja08AlfRgQCZKXlNUSWtGp4akZ5z+6OYw3L+vv/7Ar98riZKi?=
 =?us-ascii?Q?sInK1WBbg89seIIjqf9+nLADau3NcK9khn75YYGU4clSrpsOEqX0Zwbh38Cy?=
 =?us-ascii?Q?f2uSjdVdBOXEAIubPkmWtJo6nQr/c5Ip2hU49rsBFUXXw8iOZnnLJImhYrs9?=
 =?us-ascii?Q?8qnHhh8MdMVzkmnkcZMeAxOgr4toImZRB6DMfDlU8vXbrpSJ87B51QqWB8w3?=
 =?us-ascii?Q?P6ZRv5NV6ivbM+GcOHihBmJ44MjPUJW4lqC5teCHB+5ecUlX49h3Zxlwhk0V?=
 =?us-ascii?Q?bnqPNSm1z5Ej80kfTbhFaRTLpNAyw+n3UN1tYodrcnO/Frs3AdxnhMojnfdA?=
 =?us-ascii?Q?yOKXLidGnw2oEJENHkSnA1T0iEL0GwOWjm/9YsR0wQNae7i0EFjISv4iCFWc?=
 =?us-ascii?Q?JawBr1n17aUlrCNIm9KpAgNJBpNUxMT96zx4DREhKuRkJJ7Qmeba8kRcKeYS?=
 =?us-ascii?Q?UVysaRYqbxoxcdqHFMVpWOiIB0O3lvSZPBzIyOwK+TN77Y4oCbf69xt0FsxS?=
 =?us-ascii?Q?l0mXzTGHxue8U1+ZLD/ZUrGANrz89GhWBFtTx4+kS6Tx7xcuF6scSvlRXXhJ?=
 =?us-ascii?Q?IeapKVrKAHdwOeY6U2I8Y/JmkgHG15qLnazvtXrp7qnofLRBKQ2Cf3gh0rAO?=
 =?us-ascii?Q?4YbwIA9M4o9k0EqQf5uJKLzSwjDAAPX/ZBbXYekpOknCRC2gvP1sGD6DQmrS?=
 =?us-ascii?Q?RLYIRImiLEQZ+OeQF/UskcJ0Nro5wqpLV7b60qQy4zharcZlRNwlmX7+RYjQ?=
 =?us-ascii?Q?b1qwbsHCDUgfmCGG2rs5kLjUoHNxu6bkQPyKa/xULtBWlq4IPH2pX2cPQqU0?=
 =?us-ascii?Q?+hLMG+DW9sT0Ap5W4603ULCiYKKs1obdUnmUAvSxquOI6QX5KW7OThESGWTH?=
 =?us-ascii?Q?pe4iUnXZSLu3sJmKZsyBIfVBVDSL1awtZlj8zLy8ReMOglkEBmDranO8f2bA?=
 =?us-ascii?Q?+lb83hAO4MPMXsLCq+w2ue8GcTGza8dPRiXO75sYBjLiUnKIi5umbv/ghlNR?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99792f8b-bdd9-465e-c634-08da8ca9230e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 06:05:29.1254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BMIwJ8De5yBc9jdK02rJb/n3K1Ry+Ixsph00sfMOM9zGXPLJOMaQJ3Q5W2gkOUyG4BNh+ncUhEHIYD0LlvwbWEeK92zbE+310pZivVVOlVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4423
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ivan Vecera
> Sent: Tuesday, August 30, 2022 10:16 AM
> To: netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>;
> Piotrowski, Patryk <patryk.piotrowski@intel.com>; Jeff Kirsher
> <jeffrey.t.kirsher@intel.com>; Jakub Kicinski <kuba@kernel.org>; Vitaly
> Grinberg <vgrinber@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net v2] iavf: Detach device during rese=
t
> task
>=20
> iavf_reset_task() takes crit_lock at the beginning and holds it during wh=
ole
> call. The function subsequently calls
> iavf_init_interrupt_scheme() that grabs RTNL. Problem occurs when
> userspace initiates during the reset task any ndo callback that runs unde=
r
> RTNL like iavf_open() because some of that functions tries to take crit_l=
ock.
> This leads to classic A-B B-A deadlock scenario.
>=20
> To resolve this situation the device should be detached in
> iavf_reset_task() prior taking crit_lock to avoid subsequent ndos running
> under RTNL and reattach the device at the end.
>=20
> Fixes: 62fe2a865e6d ("i40evf: add missing rtnl_lock() around
> i40evf_set_interrupt_capability")
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>
> Tested-by: Vitaly Grinberg <vgrinber@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index f39440ad5c50..10aa99dfdcdb 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
