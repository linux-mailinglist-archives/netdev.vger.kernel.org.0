Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454506956A4
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 03:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjBNCXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 21:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjBNCXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 21:23:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0EB1ABC7;
        Mon, 13 Feb 2023 18:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676341412; x=1707877412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MdI+htEBC4isYFVhSiVNLjboT2k3FYS2iIuX344HwkY=;
  b=PetvLtUCgup58eQLOYSB+O+c/toIiQFqnU2Y+BaRN0ySXIhSJQQY6gHE
   712Ic5mL+La9WU0CBeFPN0O3EiCIVPVr6hbjZ9KrRXakm2vTtrS0B/U0f
   5HZwdHAhUckNkVnY4FltihmX7HloMrcjdYeUVzdnD7hw2gwoCid27BgiU
   IHCPk6DscAHqkmBtQZ+J9RwDzlOwQyF+qWDPQn/ogVS/k07ErhC6Xnkmq
   f5HTtzBudZDgD8fB6Y7TFEXvzpsg63jyebjEiN1GkoBXkLUQi/xRSxBVG
   sQ/ISsvxYy+gwiBmzzUMbvLidS41V8Purd53xsPdqrV2VTW3a1aV/TQ+r
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="331059679"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="331059679"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 18:23:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="618866595"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="618866595"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 13 Feb 2023 18:23:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 18:23:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 18:23:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 18:23:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 18:23:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiQDVneurTrFmMj9owB6EERzybf5aJpOu9osGZRaE8vFgWMAUwavZyQXMXlARh6EXf5Oc3GIAPDDUz0LBG2RGDCgJgIdypw5OaxTBBHwxgwBucsx6WLUBBgG8r9MEllUsLWS5PMeYzExy0xyShTqUxq4BKJ/n3KLNWuVXOhIo0L5LXoJJIXFKkNAPtP60aTPgNA6hLfgnFDfTRA0Zei+fGI/iL3YA5zhE0SVr7N99jC03RVRI6CSQAz4kma0n6G4+uhGN037/OgpEHg5SZovPW4xlYrS4bMzv3c9QG7BVF1hU+OukTJT8UZX/0IdKno0/0bHKd5wAzI+e2tnlpslfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdI+htEBC4isYFVhSiVNLjboT2k3FYS2iIuX344HwkY=;
 b=iKJ3H+fnXlst7a455+TAAQMY1gawQV0aUz24MFYgiQLVZxtD76i1Y1LM7V25/ICDVzQ3xtfA1B+WB65seM8LBq2Tzn+3HD7cO9NplQDFnZ1j3iGl9RjUlPDxYi8magMnnV7MLv21yyVtUTcRiJ6k2gOiRkZiiSwu8flkfikT9drZVGBLW2htjJJvmZxOornavrL7XgptbgRGx3u0Bptll1V03RxgvZzQ4ON7Ft4pKrEaGE0idYVeDfTAD4yrkGxgJSW9+SSwxj5YNqTJqNzpzUVUz1GcCDtQvnWyLkieABgGRIs0Yx/dYYN2sjbI8rRxQUtp/8FPFCIR1rvi4XsvkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by DS0PR11MB6327.namprd11.prod.outlook.com (2603:10b6:8:d1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 02:23:20 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 02:23:20 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     Jason Xing <kerneljasonxing@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jason Xing <kernelxing@tencent.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net v4 1/3] ixgbe: allow to increase MTU
 to 3K with XDP enabled
Thread-Topic: [Intel-wired-lan] [PATCH net v4 1/3] ixgbe: allow to increase
 MTU to 3K with XDP enabled
Thread-Index: AQHZO2dLMmr9MYkhEkebCD9OTimy+q7Nv0hA
Date:   Tue, 14 Feb 2023 02:23:20 +0000
Message-ID: <MN2PR11MB40459B16A67226F780FE76D7EAA29@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230208024333.10465-1-kerneljasonxing@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|DS0PR11MB6327:EE_
x-ms-office365-filtering-correlation-id: 51b59d54-6a83-4d6a-2a1f-08db0e32708d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5+VrkqqsibwHMuhPD7MvXn94Aq7Gb3KHegZgtZp3McPKTOjXWcFkqR5HmcaC0N5i1TxlaLNfK0FuGCixHBy01y2NSk5rpopT8SxHwmJLMySlFJnDHGv1s2RCU787u78zh40aTwiWkJlEaGjXLGFjEKh1WH38DepgLccob1sD2adyc6mpcle7ux5fU6BvuImGi8SWgH1mglylhrctbavFBppj6R/RNQuzA6PKD07ClSW/F/n01qfN/2r3/9tEbDzC+aDYwG5BnDE4s3eWp1CdwCE1r0BLlIoOJziTaEfVcL3WdOmPv8R9P+6WVpaGRZ8DqsV2zE7Fgkq6H+Rybudfw8TAb7Zif7CkbPe2I8jYipdHYU8usmP6cuEjFGg2U8egJYUlFa3oqn+I2XyIvRzaFhxdHifEC9nghJVPrYtFI4gGEo+/KqmggB21/Gkg7954GvnV+MUxqu2zybYmusghB8gdd3rnXLDEJ5pLQHcXj0G49YtrxJYelyCmy/71YdQQqw42PpwEs/7IK3jMru+wGKJtQMMUwZvH3fg8dfiJ7JhjJfywZiO7kz+XnaHsGjAtyTJAG+wAlBI1HE9K72fvL6j9Ytw+9CeXlNumZ7SMhtub5hx4d8cGAQgsWeTwJDK3sVoq0f5meZ4PDNiPN2NEZCzddg8Azhp1QyhYZ4VIP91gqzGncAoURE+7jXYPQAL3iP5JozPwA2q4NQn3QItCtUPbYpMBcYyq1bLsvQAkCTk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199018)(7416002)(38100700002)(8936002)(2906002)(82960400001)(921005)(52536014)(71200400001)(5660300002)(66556008)(66476007)(66946007)(4326008)(122000001)(64756008)(8676002)(76116006)(66446008)(26005)(41300700001)(38070700005)(107886003)(110136005)(6636002)(55236004)(86362001)(478600001)(33656002)(54906003)(7696005)(186003)(9686003)(6506007)(55016003)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Khk6CR8oQwki4u+tiKTUmR9KZ1FNCqNfNftkfRGiO1qD2uwxD2srRjnpFQW3?=
 =?us-ascii?Q?X2O53PIrf1SNc55nPuPJ/s5kuGSx2wKkGymRND4GCyNFzTXVj+M5PSwi9Ek2?=
 =?us-ascii?Q?hsNPvsi+68lPIbUIBgXtONXAc6HfhTaOYvoRLmKqvGyygOHMHesIkAQvkv8x?=
 =?us-ascii?Q?C86ILQOnGL/t8NUVqSWyYUEicWXPFV8CIVsKrVOxMlEZ1zdYeq4dQyocHl1X?=
 =?us-ascii?Q?mYgA+/SOw38vNXVMen+BqlnV9vZ+7j6TDMVHnhAThKmV1Z7eXfe+rX9zltOB?=
 =?us-ascii?Q?dZoOKbl3jKu6icnSASMeGTHrUWl01JNRuVOrZJR7Adj0XEdvCBEHMiyCzKTO?=
 =?us-ascii?Q?uT/utc4tpJCDqCtrllZAHcj5LeM6+LHKazizPcY24Xivt6bex7tULYYTtrGk?=
 =?us-ascii?Q?E3NH2febegX+mtpYXKmkIhL9z8QhkxnJazfxankhTwTjDLYpfHggmgZzTbpm?=
 =?us-ascii?Q?6MqCRFQUyaUmmp8qOwPp5r3klqvVWaZ5fkcgkTdDA+Jj11wEG9LyZqFkN9NG?=
 =?us-ascii?Q?p3IV8XdwyA5p3hi7EoQaCDij5zN853Gko/C6oadLSsh6UZ4r+j/UczmmInGb?=
 =?us-ascii?Q?CjD3KDuf1A018WJ9V3POETDFNnaMDAbllQ63TRoxQMG+f4aN5/it+JBkBdQj?=
 =?us-ascii?Q?eDtth8E13k/q/Dxaz/i6aeku0l4sF4comkRNzvk9sZX6UmODn4i0CwtN1eXm?=
 =?us-ascii?Q?hwrVj5LCGy676qQm0H2RIvudD+n1RdfQrwlavLFA57k4rOa3fNi3BFuzVRK8?=
 =?us-ascii?Q?PPFIWh3oyJPSN7RMk56OhnbuFPWU2oeLzU7awcTl1WKmrpD9ukbmD3EJ3XQU?=
 =?us-ascii?Q?9En7UCzezG60T0VB1lXow9KZ2HTkaGc0QN1JOEmANGeET5AcY7s3f/Z+4Sdg?=
 =?us-ascii?Q?RUGz+01vT+1xls6+gS63EtikiJ0QrbQ4utSzTnhrkyVRxyEUdEIw8c7ExGtT?=
 =?us-ascii?Q?3dWRiGhrTywK5bIIj0tPUX3wvhr+YV9oEtL1ynMnBEXHXgT4ahaWT/rWnWDz?=
 =?us-ascii?Q?juuYkYou+BsXCK4nncmMK6HngGL/8fMBkjfUwOpxp0+QlPDwctkO9x9aJnFU?=
 =?us-ascii?Q?tGlVsxriLh2NIY+0xtwnuOLJ6oNS5TaL5B/nPorEKtS4+XYSqlOD8FESZ6i1?=
 =?us-ascii?Q?g1zj7FxVwL8h00I7N/dq2841mYbTSwVGeMLtc0NsAbrOtTofRiCbBX5prIKz?=
 =?us-ascii?Q?mb1xyLOS33P+oI3C+DKPEXo/Icnp7SV7yVhqPjpLMxvnapeHbB7rOlDgxPF5?=
 =?us-ascii?Q?N9zrmcPVF4Yb8TGIGLv9y944qtPbHhOI/ww7tSYTGR30CZVeVD3/7/3xOq0u?=
 =?us-ascii?Q?HA5YOLIkfq+MBnwgW9ViYHUZ3aWB8EwgypkTeTGVLb3SYc5MvzlWj7JYwKUg?=
 =?us-ascii?Q?PJqSlhxnFWHbShCtD4sh+se+J62+ombMeOTb5IJCMwnttF9xc+mYqR3jNmvd?=
 =?us-ascii?Q?PEQ5My0PRuVn7PIcUrSCR2JY3vWEZ1t5unI0GCldE9FMkwWpgze6/bYSuQE/?=
 =?us-ascii?Q?pC0ZKDsZG3R0PSJlz1bNhFMKT4jCRctGPpS+iKKkvufeSz6VWpwgPxspSMfW?=
 =?us-ascii?Q?T2FrO+WjmLvatw+XuEkpkT9LFbh9grg6uczKYjsy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b59d54-6a83-4d6a-2a1f-08db0e32708d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 02:23:20.2041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ZeIS49DKIJAU2dbNmh8+PCfU+ljY8JT2IML/6YOZyGwkQfXKFeh3lA0aHp578wRmqX5h0ViBIvmEQRFgkmEnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6327
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Jason Xing
>Sent: 08 February 2023 08:14
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; davem@davemloft.net;
>edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>richardcochran@gmail.com; ast@kernel.org; daniel@iogearbox.net;
>hawk@kernel.org; john.fastabend@gmail.com; Lobakin, Alexandr
><alexandr.lobakin@intel.com>; Fijalkowski, Maciej
><maciej.fijalkowski@intel.com>
>Cc: kerneljasonxing@gmail.com; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
>bpf@vger.kernel.org; Jason Xing <kernelxing@tencent.com>
>Subject: [Intel-wired-lan] [PATCH net v4 1/3] ixgbe: allow to increase MTU=
 to
>3K with XDP enabled
>
>From: Jason Xing <kernelxing@tencent.com>
>
>Recently I encountered one case where I cannot increase the MTU size
>directly from 1500 to a much bigger value with XDP enabled if the server i=
s
>equipped with IXGBE card, which happened on thousands of servers in
>production environment. After appling the current patch, we can set the
>maximum MTU size to 3K.
>
>This patch follows the behavior of changing MTU as i40e/ice does.
>
>Referrences:
>[1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP") [2] commit
>0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
>
>Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
>Signed-off-by: Jason Xing <kernelxing@tencent.com>
>---
>v4:
>1) use ':' instead of '-' for kdoc
>
>v3:
>1) modify the titile and body message.
>
>v2:
>1) change the commit message.
>2) modify the logic when changing MTU size suggested by Maciej and
>Alexander.
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
> 1 file changed, 16 insertions(+), 9 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
