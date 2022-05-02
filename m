Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA29516BEE
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383095AbiEBIVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbiEBIVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:21:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9AB3190F;
        Mon,  2 May 2022 01:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651479460; x=1683015460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mQSxDc6AnoSmayWV5vSGp3/hSb4d5dA8qPKNuEkQi2A=;
  b=YnuS6/58F4etS8bf9dzXksnUlIJkg812S0QgY5+1y6mZAuu0FEEC+Azx
   GcKS+u1PRpfSLJ893wl8GVwk7K8H9xu9GAIRKY6mi82rPpsoBG5cm8deK
   aAAVEnpBqkJl1itFzbxjgj7arSxP7FV/PHs2IRt1gThTakm8akEGMzdgf
   kBMWeYZKDG/C54U1V3bLS6zV3qXlEERUWnFGHzUYfy/iz0NY7TUN+JY7l
   U0KxBqH+kMt4O+M+ayGORC50B0yrLJJmJb6L6s8l60KlqiivAXFka0dF9
   44Yqit4Ze8Qv9OGdczw7MlETpmzgDFmP+o2q9wP4mh+jvhDT8VrrXPBUs
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="266732921"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="266732921"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 01:17:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="535750378"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 02 May 2022 01:17:39 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 01:17:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 2 May 2022 01:17:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 2 May 2022 01:17:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/fdPONySa42wRiUKm09Iu8CV6XZp/R7jR3fP/PznlqHKtw8tQGN5HD2zH3Pg8vKnPCzwcoeF6C2f9a+4Alq3kZOcILUn6HaTX2EUkOacvUaxj6AOc4GvTcaFskDA3P8SAK4/xCXk9gooaII5KJN4NyNpYEhzQiJX3V798A0ZkEi9naMxWH1lEKpORtWf9RXSYzAMbMR5CQHPFOlsmTFkNSItCGrd5XI/u+5QgsGmNlDNdoOaW0D6eAD/0j8bpjjQUkAk+Y8DOCJtTUQc/13fTcnJBjXA9gArqz88MQB2AOHP9GNhyRso6l5I8NqlTufOO8NLKVIiz5UGtHya30ZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZKdmVaU9EGM9/Y9oCm9CP3gDYJIaFd7Qo6AvC+ubls=;
 b=nYVlg1jBroLkGrAUUvOdGHNrOevEyxtXS1Oj56ToC29ICi7dAxEiAzNagGRCW3oHM5LUBdDtQXBXWfZKi1SOVE6iS54/5XPzn7nLr9XYxN5jjKEq7jIMcPhcTFBWqA5+dolXzDXNrckw3m6z5H0Ii9ey2gbrFQBfeDRvcqU26/5cErUPnI2xuI2JlMIVgDnmP6LDqaegJ1EhLWx2QZdtYSsMu2FJSUrK6IrZ4i2ed/Q9lW/Be5FS0RdUGb7XlC9k/By/N7/wmAj1cfD2rjqYTi5dMjJRLfIWyy1pOCMwqTb0Y9d8dyll0L6SC7IGuRlT/pbyMO/IZvIzlT1XCI56zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3590.namprd11.prod.outlook.com (2603:10b6:a03:b2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23; Mon, 2 May
 2022 08:17:32 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:17:32 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Raj, Victor" <victor.raj@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] ice: ice_sched: fix an incorrect NULL check on list
 iterator
Thread-Topic: [PATCH] ice: ice_sched: fix an incorrect NULL check on list
 iterator
Thread-Index: AQHYQs2qcyGuccie4kiSQSnllar1gK0Lc9/Q
Date:   Mon, 2 May 2022 08:17:32 +0000
Message-ID: <BYAPR11MB336781C93921216983F8BE3CFCC19@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220327064344.7573-1-xiam0nd.tong@gmail.com>
 <CO1PR11MB5089C7298CC46861FF41D3E3D61D9@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB5089C7298CC46861FF41D3E3D61D9@CO1PR11MB5089.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b6722e0-3082-4080-f633-08da2c1434c2
x-ms-traffictypediagnostic: BYAPR11MB3590:EE_
x-microsoft-antispam-prvs: <BYAPR11MB35905CFA850E12DCA1B9AD2AFCC19@BYAPR11MB3590.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LyEGmDA6/njbVBRKvn57Bg0cuOzuEMwZfYzBJvbEgs7SkkTxrtItvAS6xXaUIN7p79ZSmx97/qHnGK345nh4XclcQ7X3/8k8r3QQlk3+KqI2Kf2sbGqzqzPehdlhzy+wHVZh4adT7IVpyz9WExMnLKQ+BhNSOjJyUlpfiF5WVvTifbRlfLss9HjbK6Mj9I7vzdvwwYmGw8SGvXjgfl2re6LnorVBPfvtxd276HCvBUiyxVTOgxWh80vI0aE+J+GQZVyl4AkyQfJOc9hCY4yAj0LhLoG2txYD3amrlie8aePMIh1SV1Mu6h+g9huzKNXBi085IobTrdw351eHit/WwDMMHk+Us5i5uVoV1XHcPF+aIeEQj7P+EHkyCqqsTRor33pPTkyKgFbW+ld8wq8Ui3d2yKMa8h76gStydz0onQftchUPmzGO3IcdmVwwDyYhLa2jIRDSbyf9ztUA/IyWN+lO6SgnhAgPvn7m0+/p21dnewdj7LVoJt+oV9VGHT868Ole93NNJo0G4KbdOhN8RHx/BjKDqjusqWCdSW3aekn8hP6kbk6XA5GgcOUrHHPa1OVQP8rvobCcwYqKM1meWYJCPKF7zXQZl7tUCUdzW5LCpgXflQyt1esNc2DJe9R5VYJj3kbv0R3IceHQH2XD1THHgYCigDt6ePAjmKNtGdHCnZn9it8ifvy9uAm2grR1CivXtJQp/4QBLA4y1JbGeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(2906002)(86362001)(66476007)(64756008)(52536014)(66556008)(66946007)(66446008)(71200400001)(6636002)(316002)(82960400001)(33656002)(8936002)(5660300002)(122000001)(38070700005)(76116006)(38100700002)(508600001)(54906003)(110136005)(83380400001)(186003)(6506007)(9686003)(53546011)(55016003)(7696005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZKjAxYKNrEo2Q9EnLiL/L1SZTETO+wi/mINmBV9KR9ys86/Z4m//9EGxF3Ri?=
 =?us-ascii?Q?+ceUjsOgTaSDdGwNVXEWjfQPb7AzBrMfha2QEuLIPVZRjHPCfCszCGPzg+po?=
 =?us-ascii?Q?TLNUgm+7Tl55mGVlZJEvbQZC69RPWAEzGPui2n2jgVkKG8iqrcCRLCm1q/HN?=
 =?us-ascii?Q?HLN8bueb1YsRI3xuQN1FmbiNp/RQC2WTBtCsWpGuzkKaKUq9UkZXcqE0Enq/?=
 =?us-ascii?Q?NqkOR3EsZaZqhbdLTCDUjY4a6P/tqiZT7DMI6tc46bRr3R8y16wW/AGdyF3t?=
 =?us-ascii?Q?B4G3QdeE/x6RGgUOT6lhQN5weHihbdYDO0/BI/AHmxzjpwMpc7TEE5hLp4Rm?=
 =?us-ascii?Q?CxcPuhi2LKJxcFzYvPRcgVImi1/ycHMa1UBMij5dGD0kjiOqiFUbWqfSKcLg?=
 =?us-ascii?Q?QxdeJFwj8Y//qylNysUPp+lD91qhU6ZQWEnGlZMseKYAEs9kgR+PbMiYxuJV?=
 =?us-ascii?Q?4O+g1BbeGyG5PGdKxb2oz3Yc5wbsqamCv21dNsKdVwK9C3tq/S1bwGFdCHva?=
 =?us-ascii?Q?YtU8u5pUwwUt6NoiVNuQ65pqAaX38ao+g60H2SiPiPCNI4uCjVzGATL72Zvn?=
 =?us-ascii?Q?EYSqMRwvk3BSY38nVwhGCUKLwQQLTHZ/0NNKiq7QdCF5Z1j62BFbr1Og31GG?=
 =?us-ascii?Q?UWh/co//aPwSVFlOmSrma3KyHzi/RH13lPWAyb/OyJKHeGa6IqSlMVBBJin9?=
 =?us-ascii?Q?fPQZGtQVrdnbmnFq4bcebjcjI0AsHiH0WF+z91jXzXFBk5O4HnP0H6hUk7aB?=
 =?us-ascii?Q?EcPhVmj+fW3egoXYrAb6GI1jrolZpZ2cqBf1w6COrbh+SUM6CHami/PO2n89?=
 =?us-ascii?Q?kFBNzH+O3tatZlvaUHJglA+p1hk/ReiulwuHKTfliSuQr+Eqlnof3pPszD2R?=
 =?us-ascii?Q?uPIX5ZHZLm7nJq+OETMdhVjY8kOxWkdfjKzFabnSfQY0idyc1WB6mvsrA5ZZ?=
 =?us-ascii?Q?37AeN8m3NgBHNAMq5y0Fm0wH2YS6ctvoTXvKPqh+7LYZYBJ67G9bj4qBPA2X?=
 =?us-ascii?Q?s65KkfQ5SIGZKTPfkgyzZA5NF3BBSyc24SpJEt8O/ZzKcur4yEPvUY7BvZFn?=
 =?us-ascii?Q?jFM8mgFMHq9BwD+Jk6zmdlLMjGpfirf9tOXzyJ7tDqBma9pX4EGzKWbJbjYJ?=
 =?us-ascii?Q?FkLcqyHpIyW2fPVvqMGdEPgDSuoHE/2OQaVJLEOGzFAridyT9g6sG9mUjDHJ?=
 =?us-ascii?Q?/rlc79mmks4qql04iMkJZMQX3Q0/wZlayjv/CpdY+hrnrNyAqjLu0GLic5hE?=
 =?us-ascii?Q?zWdc7xmfCKepv2r+JYh3a5G1cs5trrzRai7xW8u2jkMuhOG0Gwh6C1Kgwhiv?=
 =?us-ascii?Q?VrD5NV1a7gGcamA/IN6VsgU23PGuIpXSVaQdJzaCV/ekk81uoOelbtKYi6wG?=
 =?us-ascii?Q?eTEEGM1AoCvbyHhaG7gemS6C+LKxg6RnlD47gEK1W+fl0M6SsW+yXXuEr0/f?=
 =?us-ascii?Q?eTIRG6bicxiIxy/YHaRX436RDPc1N8LJgmt5BCicXXB8hUeJ+BVdVn8Grc1+?=
 =?us-ascii?Q?PPTx2cvcGxHAZiCPz53e319wgcPGA0m8n0Yz2Z2avivTMxYW8pgYb3hxCJYQ?=
 =?us-ascii?Q?aOJBbndt25v3MnFKACKOJGEGc47FGEGcDoYPsIc8btCz2qN8XsQPI233Tq2l?=
 =?us-ascii?Q?vbRohcfMRiHPzZJTc04KcYZm2dgSh2YFgrFwfQFYOsDeakF7NQNJmirzSrpK?=
 =?us-ascii?Q?cWdJgQx5jLovHbfY7A5hJc1t1mKUT75r21Gdf5iT9rmqNDAfKrPYvh9/qm0O?=
 =?us-ascii?Q?ldvmjYlGKg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6722e0-3082-4080-f633-08da2c1434c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 08:17:32.1881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KEaGjIljMtlFIXS7x+Y/jnFBhdECe9ojxGDvNwU70IX1jAXqiRiHBWItxN0kfgjPR1GML3HfQ/WhYBdgqjqDeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3590
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-----Original Message-----
> From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Sent: Saturday, March 26, 2022 11:44 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com; Raj, Victor
> <victor.raj@intel.com>; intel- wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux- kernel@vger.kernel.org; Xiaomeng Tong
> <xiam0nd.tong@gmail.com>; stable@vger.kernel.org
> Subject: [PATCH] ice: ice_sched: fix an incorrect NULL check on list
> iterator
>
> The bugs are here:
> 	if (old_agg_vsi_info)
> 	if (old_agg_vsi_info && !old_agg_vsi_info->tc_bitmap[0]) {
>
> The list iterator value 'old_agg_vsi_info' will *always* be set and
> non-NULL by list_for_each_entry_safe(), so it is incorrect to assume
> that the iterator value will be NULL if the list is empty or no
> element found (in this case, the check 'if (old_agg_vsi_info)' will
> always be true unexpectly).
>
> To fix the bug, use a new variable 'iter' as the list iterator, while
> use the original variable 'old_agg_vsi_info' as a dedicated pointer to
> point to the found element.
>

Yep. This looks correct to me.

> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>=20
> Thanks,
> Jake

> Cc: stable@vger.kernel.org
> Fixes: 37c592062b16d ("ice: remove the VSI info from previous agg")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sched.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
