Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA56EC662
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjDXGjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjDXGjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:39:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12234212A
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 23:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682318362; x=1713854362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sywqx/C4QqnzsKnBvuCNghktWfh6zgR5kHnMhvICZjc=;
  b=asew2TWM5dlLBRm6XPZZYs4nIggi/z1U6gdkAZhRA09Sh5BDBTUMJ07P
   CVJGF+pfAdnitYL3eW5tzLM4pv4qE64lLRiOt0jpaHenQKNZr5+K16wFf
   Gm4ww/FgZd5PG3wJwQW60b1YoC8lYsnxHp6dG6NYvA/QBUgi4yc6QAxSU
   NV5ew3sslnVtLDsM3R0+AxzxYZ1GuGKYT6+ssmQbu9A2F8naHn0qmKy4N
   KXCKBsabOVrW+lsgbs3d+DZNzGx0vSllvd1DZgpvwAtmTXSMZbVmSlJk8
   neHvQET9zkUBmNhzV+Q6ZII/RYgQHLLzo2g9ni15qGwc+ypt7TwKvA5ut
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="335260249"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="335260249"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:39:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836841765"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="836841765"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 23:39:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:39:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 23:39:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 23:39:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GK+V9K+A0j+xEnXJgdu+oCOAnwZazq+ddWVrvdW2cCmUDmvaWhGuHhFDjakINbbghGquohGkVMegSiSCVi1vxHo85nmWB57LynyE2CyCUfTfu/udbd2tPjQdmfHCGqOcue5TGga8D2FCaTZgqFrg+8Y0Eu8nI9cq67KIw6jHQ5Aa4doOSquUEUMfgRzfVdUKjIRAevVIjHsC0xwhX1I0FiQJ5yoBabg5XHf3yQV62RRskO/iyc+e2k5Az6V81KujMAvK1864/1RajRSQzYeOmZzphjHQ9UZs9g7TY2KFqFic0d2X3xgl1sGyKHVSngza+kKK9NRkkRJLs0z9nuA9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lO4vz823LaM/GUY/0Rnh1vOfHjsmN6mVsSFcuhNltLg=;
 b=SpR1dcB741DoYOy7EIhK9DscIF3xhcSx23DfUbqvcIJvIj6byffkj1P+kEuAKZ3esfbTpB83Y6MroMHA0vaUVGYaXxG9SaXo78NZB6mCd4SD2i3EMH0Z3zZO4GjlY7wow7Vr43Ry79KfzU5FrkkE/4JjxxiZaHZUuK7ECxoTN2yPp1TP+GIldw9LT9tV52zIQ5R31WcRV01XU7AsexZ/QiHRfPCZemWnoUbxJKMEB50DgCg8+B6m/pal0wEZMDHn+Nzj9ECHh/1KllP/gkTz6YAtK/k2KdAYy3FsxVcooFdave7LzkV79a8Ged7qZOG3CaY7GFZeZE6AXCe3khxzTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by PH7PR11MB7477.namprd11.prod.outlook.com (2603:10b6:510:279::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 06:39:18 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c%2]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:39:18 +0000
From:   "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v4 3/5] ice: specify field
 names in ice_prot_ext init
Thread-Topic: [Intel-wired-lan] [PATCH net-next v4 3/5] ice: specify field
 names in ice_prot_ext init
Thread-Index: AQHZaXQV+Jpprd9nwEuKd0phI0trha86G+vw
Date:   Mon, 24 Apr 2023 06:39:18 +0000
Message-ID: <PH0PR11MB50132369CBB75469B454467996679@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-4-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230407165219.2737504-4-michal.swiatkowski@linux.intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|PH7PR11MB7477:EE_
x-ms-office365-filtering-correlation-id: cf6a7c28-dc97-4a4f-d2f6-08db448ea141
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nigG8clwHLhPTmX2dylzxo7gacVdUKq6MYD9h94uieSDTTFkgl4kBI6fwGdhnZXteYrlLhu/H97MKHeQR9c7mOnuSZnaSwaDVohSbuWYS2iCJk1EWK+Op9s1NyNMZPfWbcFfHpq6YHsmm0RD1FQU+QN8veJXPNDSU6KLyC/HW1+0XKHlc4bq5Cu9juPfajHqyFqksNMDbMf25mlUKqWGyoGkYFfRoAiCgAwuPjZjUn0Cnjqc2IiUVkQHTKQ+mGkQfQ9wf4KGtusqasQWYDldju7Td7B8fgeZuXbL+3hD5FlYuUBY6COLxOWmN6hgg3aK3DUF8NdV9ZX5uhQcSTJ8si0ztrtCxgmnX2a+OhbX5M40IVCNFhTC93k3ZQpTQh/ZIKOc7mvpzYPxIMxYNwquqnCp0aFdSjZATdKnQkumbVxnxbdspsbHreA5rzkKUE9yU3AJ22TuVJx1m4evs3WODjXxEhSW9/Yt+iqHb72dUoQu3WqeeJvo0UGhYJgFNGRwQqv80VqZ7mUjlq4U5GzujXKwZOWrPhr+kCpewGE7c59eVuArU770JmgjCjxkKKjNW+pazosrc6TNMks5fb0tTiCvCu69+cQz9CTSnzy39ThyWl4tqmxLhwjTanzau2jH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(38100700002)(122000001)(82960400001)(6506007)(9686003)(53546011)(26005)(55016003)(186003)(83380400001)(33656002)(2906002)(4744005)(8676002)(8936002)(52536014)(5660300002)(54906003)(478600001)(7696005)(71200400001)(38070700005)(110136005)(316002)(4326008)(41300700001)(64756008)(66446008)(66556008)(66946007)(76116006)(86362001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w2qxov2jUaecjDeDNhVtIos5bENyYXE7MF8knR1CwmbaI1uKtjSa/qC49ndg?=
 =?us-ascii?Q?1ZAEDwGuk7DH0yYgbPHtfmyWVO9/PQ8dMWRIRtE0hZqNvt22Fs9WOEI+OKOG?=
 =?us-ascii?Q?j/niYWLfC8WckhsDfbEoYuo+FRVz+ZBZtnla/4jYgYHwz+pxQfVt6Fuhb3eq?=
 =?us-ascii?Q?onnbn1JAk05GaoKp5YQdrDpASVsDo4iy+Kr1QwN9u1O75arZbJSxDpnAbIBa?=
 =?us-ascii?Q?sEqWGHAF+Bkg4tTmoQWNyjDGJ10an/EcFXk50XbRreU/yiyhHBHAjq0d4+rr?=
 =?us-ascii?Q?G6NFSFyMwFPjiuwY6DckVhm4UoGpOAVB1L0Uwv27cBQ/TcuYVCvV60jvYtRU?=
 =?us-ascii?Q?41hrwVZbqfRkXBlravTQNta++L7+muAc4OcBtkFUALsKIetxq/UtT2orRopq?=
 =?us-ascii?Q?wloWOEsdp+NU8EcHUCmGqEoSd4JjH6v1FSD9f05kR6+altLoFkc8tsHlHMTj?=
 =?us-ascii?Q?LbO/osVCaVKKISiweHSG+ndmNoo1YCFXtaFfNooY7O7gcjQj4f3Jwa6TmSHw?=
 =?us-ascii?Q?vcDofAd+dLxt4BKZzFvlee4H5kmhpEbpQFDTyo1cZ8llFHlmvZz86MoyMGyd?=
 =?us-ascii?Q?TDuZ9SCkuJedJet5BsNMHxlPX5EByjVCkWSaX2UmLuBvqJrCkc09rElbNMrA?=
 =?us-ascii?Q?nAGCWE0LzkQLLS2gu26xw2Ub78VnV8XM6/hZTHe6N+P+jkn759eCeOKzxMCT?=
 =?us-ascii?Q?QEIGHc/sdxmdllP2+qFlmyBpCvN9BPj48C7sdndFNZgo3Aqt+L0fOJyxKpS9?=
 =?us-ascii?Q?i5OMsNEXEO4Y8wsBFMKWCTyBEa5KThsLH4O2hOHXe3CkLC7yE2xEEQ7Ms4C3?=
 =?us-ascii?Q?wJFwQMVSQ3IpdmDL8MhpoCH/BWXG9ZK2VMtVCPu7n14JZubR6Z1X0lvb6E7b?=
 =?us-ascii?Q?KvwUkuQDNzipBPmeUJ3NuFzDopWxn0vWubsdG90JZhcfX9kxwXrdtjbKJCi3?=
 =?us-ascii?Q?ygAlRhxnT4aYwIWhIxajXrZgaVGmdIVnghS1CKEZ3uf0nJNvDhvXhjlWZlzD?=
 =?us-ascii?Q?avoOZ9oof6xt7PJYJ5qoenkcL7rIkkKbWAqGAlHhmJx3VVpdlWCHWvNN4yDi?=
 =?us-ascii?Q?BjjJ92FdbmOewX/pU97dC8HvfQZ6ziIQT8twp6MWTgZ7UN66jntwyxYEhKMs?=
 =?us-ascii?Q?Nd9dDBCmvDxbC4JoDPnvIi/vfpFRWcBMMg9LWfuaKhgbR2twNsbpq9jUSE4b?=
 =?us-ascii?Q?hYnrFr8kpbB8MNNsHCHAcFBL5Nxm6CMgoBwRWqlPqzKRs4tKrHER0WgmH/aS?=
 =?us-ascii?Q?/K2X4Jw6owF2pZgzFX1vEVvZ2EOers4FS3wuyHYIV487qVvD3kTEE11QZWvP?=
 =?us-ascii?Q?IO+Q7SV4eohokTWWjLHW8Pv1IaPv5ilEB7ZNEcyXn8yKwMhHXHafkFbQYPus?=
 =?us-ascii?Q?4uSAsmAkuxdHBvOIqmcw8H8/AnFjeIyY0WMohU7gPPpmtaNocBZvO1MREy9K?=
 =?us-ascii?Q?U5KIrA5jDnvvbovyS20IOzCFyq3zsmqkhNX3+vRWE5GovNKaibHxWPjcOCNk?=
 =?us-ascii?Q?EDe+1skj04/TsV72nKqed2mqffPGTjFE7OG+kH0iHZa6PVF5UJINhaZog5KJ?=
 =?us-ascii?Q?RdMYOUQlCzZE9BO9Yp9AmqXJjEzpdY47FSgn2Q7HLfHFwvAuLp+LdqUycDvl?=
 =?us-ascii?Q?jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6a7c28-dc97-4a4f-d2f6-08db448ea141
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 06:39:18.3942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YQTtv6T5aCoTVqgENK/44TdOxlaLlp7NuI4Q+icQI+FHX8IKWr1WipCeZr4LsmueRoomOj6HYTRbftmJU00I7mtQhzVdMXw7j0MelC3aJKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Michal Swiatkowski
> Sent: Friday, April 7, 2023 10:22 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next v4 3/5] ice: specify field nam=
es in
> ice_prot_ext init
>=20
> Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
> macro to rewrite anonymous initializers to named one. No functional
> changes here.
>=20
> Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 51 +++++++++++----------
>  1 file changed, 28 insertions(+), 23 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
