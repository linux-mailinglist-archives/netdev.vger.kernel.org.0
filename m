Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2C6EC43D
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 06:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjDXEI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 00:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDXEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 00:08:26 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A5B271C;
        Sun, 23 Apr 2023 21:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682309304; x=1713845304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3ENYRb2UWht2Sr+Z6tRo+3xDvXiOPJLsUZsZ/btkXHA=;
  b=D5+JcnYBVH4owSP7saKq7hYRXRhZEnbUYcFfSddb8bIq9pxw6OViMory
   suIizre1nPKyaw5nkQCs2y+lpQBsW1O/U+PkVGCQDd3ImbLyCJHvT+AWO
   /1p6zqE285WIeQ4/hJxS4/mUg1596LE90vVWtvy27mO7xV+hH7x3rlzxj
   qDaEUjX80MbFYygVIwr0k4vIQICVilUlGI5G8zg7REIj9ixlepLtmN2Nr
   zXNgo3N2m19ZlKtRc5PyEnT0WkXQlR/xsf1xlN3K+IXW0LUVjCRMGoZ/l
   iWtaVCog3KdQt1EK3StMty5UqKOs0DSldDDwEHmTKuLymrWKZLAlTf4R2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="411630611"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="411630611"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 21:08:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="757534767"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="757534767"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 23 Apr 2023 21:08:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 21:08:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 21:08:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 21:08:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 21:08:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpPQw65XAa7FU5k6vtiSD9usUuDA71t9SmFHlSIXKxmk6I3QlaECnz2gSjGzsXV8t4uqUNSrvBVkZ8IKm4KSV6UXspKbZ/t0sAe5jhRRiqhaifRjMRJL3Eax54Qn77PyH+kgaVWHmtzSv5nO1Qh2MyLps7pw7ZLenSa3lDa87Hs7+TPxT7lAhwOYnvgLeOq7A8J0+KINggXC/D0CiOYafuUnn7s+MkXrgrfZBUdHAgaUCkB/PYXnMNjztie/BoheNLmWLR90x8+18aNwjC7auyi2P5dtLTrnu7ZO8IMwcWAYBJU/Cvu2MVrprmZnYbXG/yVgy7Q9r3X3b+pGhmuXoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRWwYfRNIPXC5C+7JSJtvljEX1vjsFd+09COQOlb8xE=;
 b=oHvyCGChZxIE/Qm3ViQQCo9eb8xlHWUDXfqZXRJyl8QNmAWvNFNxxUwDKouKhdXsxT3ZYL2i38Wev6dhZUDPPecjnhlz6B8RIPiI8828nEPx2wrw3anX0/5Cprj+ihRH0KRNSkJPR+u7geVNAeZHJEbejORRSLbIsQFldzmGRs07OuEQKX7YmRIWwpGExgRs6takIcAxcqN/X1cXtaO6nZEj5aNkrStoLN6gIsqW+knHAbZqiHA3Q/DaqGzdXTEVt85YdO3fl3LztJWQEQ2FeSsNxmCkUnnSWGxCmrHvHPWQ/5sRQ2SQOnO4BPiVUDUMkUTCWmDwsjjDEKf6fCmFxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by DS0PR11MB7785.namprd11.prod.outlook.com (2603:10b6:8:f1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.32; Mon, 24 Apr 2023 04:08:20 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::2100:c02a:b4c4:c8a6]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::2100:c02a:b4c4:c8a6%3]) with mapi id 15.20.6319.032; Mon, 24 Apr 2023
 04:08:20 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     John Hickey <jjh@daedalian.us>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Shujin Li <lishujin@kuaishou.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xing, Wanli" <xingwanli@kuaishou.com>
Subject: RE: [Intel-wired-lan] [PATCH net v4] ixgbe: Fix panic during XDP_TX
 with > 64 CPUs
Thread-Topic: [Intel-wired-lan] [PATCH net v4] ixgbe: Fix panic during XDP_TX
 with > 64 CPUs
Thread-Index: AQHZdmJmROmiD13VOU6Jw+EaZnUixQ==
Date:   Mon, 24 Apr 2023 04:08:20 +0000
Message-ID: <MN2PR11MB40458F7BFA0EEA533384764CEA679@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <ZC2IYWgTUFCnlKc9@boxer> <20230413230300.54858-1-jjh@daedalian.us>
In-Reply-To: <20230413230300.54858-1-jjh@daedalian.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|DS0PR11MB7785:EE_
x-ms-office365-filtering-correlation-id: 51ef2f1a-7f18-423d-4031-08db44798a0e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RUUSsN2mAbd4TvP26GphKvgTqtoxs37UJ80bNzMeYWj8RoftshCklnIzksbVZ4+blK1gZC9TQ2Xx6hlflPuU6vZ4pMqTSlwSv1jc8Xn+FggS5gIpRSbIb4qeBZzoQwpHKMllPskqypeUR04+L2/Ec5Qymp8hgIuxJNjqmUlck1RSVj2QT1YrQ0s9Sz4jYmEVrgZZW7b0zbGgGAN3TFnM0bbLS0cJ4l2UcyFqUg7CBV4dldtIrSjHwffCOXOuY9nA+uAAwiwP6xSP//LXbcMhGSY9bFcne8C5IevPW8IGRcg0WTy5KKvwXDl0osyXtln+x4wjEFYs6xKgdHIBC3Y7N7xsacHkF8CXVdRcoc+rQcOf+EPfxB644xDoHPIe43MQZaXYb/CYCkaMa9qAdOIvZrIJo2vreCMNGxifouiY1AnDedtL5+1JnPckPkH1NeVmGE+OX9BLEdcGEQIW6a5SaojbgbLVbaQzo8KbxxYRzZmlIZJ4U+TBlHIqYLxvj9aYmMQdyhxeT0f3K7fK/QhoLTtQcdbbFRDJbZQCbLBvtSIfp1wQfIml//a5GInLhtFNYBTodcHQJ8qFFndRnKMjfvZ/+2Dga6oWmNjf3wYPHtUeOD4a+6GEWizAEIzhuqFb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(9686003)(6506007)(26005)(38070700005)(55016003)(83380400001)(186003)(82960400001)(38100700002)(122000001)(66946007)(478600001)(76116006)(86362001)(64756008)(66556008)(66476007)(66446008)(8936002)(8676002)(54906003)(7416002)(110136005)(52536014)(5660300002)(71200400001)(7696005)(41300700001)(2906002)(4326008)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+999+U3T0/IWRyZmNpjlwH2PwTNLIPmrhTpabSAS2o0kzXdt+VFJmAnNZ9Ht?=
 =?us-ascii?Q?lXIrKMFZDUxOi4O5dy9jB+detUFA21ffZJBwNi6ZWEEplfvxlucMLqdCe2oo?=
 =?us-ascii?Q?B+/86qAlFT87z418lH38276PDEgSxBRfKr6/cBqpiC3SJqrpq1eLpqZLWz20?=
 =?us-ascii?Q?VP+V8TOJDCK697xDqUjfpZnSBV4jMNSPziMccfoN+7+ugsBvUNxFnuK6v7yt?=
 =?us-ascii?Q?uzALi0oIuQpnJYDAkcrMn8nGh3CYEtfR0sLgk1dY5pVg2yUkLzlbytO/iVn+?=
 =?us-ascii?Q?ClbtJekYLBrYM1x/PQxe4JRUnOkN4r70HENZcZbkVNq8RlPZC+0wWqHvi5tZ?=
 =?us-ascii?Q?cWbGB15SpUN8hv4yJlv0Ky2TSw/wpkeU85e4sCBxEZ93orRANB7IKPri2FwP?=
 =?us-ascii?Q?hiplL5cCv+zqrPS5F+tyWe/F5g81mDm/i/YA79LVA1f5Gr6wH7yIyxMhcso8?=
 =?us-ascii?Q?AGLznKFJMnJK+2b8r9ewdM6OBkcq6sC+eVqz2c7oEueZOP166mdFKSxzbjBS?=
 =?us-ascii?Q?PQ0fp09DewbRAljp6YdaKuX7ZeSSobPAi2OK3hdFzhdo1/q5uuvIqO9cba6n?=
 =?us-ascii?Q?s9a3nLH/eSLolR0d3sFW6O6pMUEuav0nqoIQ4k9UaVhMjgTyZBDx/9sCip2v?=
 =?us-ascii?Q?w5DSrrear4PoB4DDPJ/2C1kSvFsJmXTNXEDnSKK1WKP7ger0/NzOxT1f6n8Q?=
 =?us-ascii?Q?b9Hkpaa7itwrCjEie1akbDHyE8twHWI6EuAjxPGvyT+iFZeZnzeWAl44W13s?=
 =?us-ascii?Q?CsRXrtVzu+ioEAh4AuGv31OXjy2Fd4JXiGVwHHMIJMTUpg2lKJFb9m2tElKc?=
 =?us-ascii?Q?B+hESwVLXZg/kzqI3lpIQGaZ8hS85DvjglYihpBuRQCPzbqOZ0zXXS7vBFzV?=
 =?us-ascii?Q?E8GGEkUaO/twq25hNdbVsWVK2Y9fxGJPzMHZHOnE99L515APalGFDoQQzQds?=
 =?us-ascii?Q?lIn7MaQhav//87U3JvpfDzYMQWb7JLIxBGCBX3O+JQUGqECGE6p2Vkdw1ZrW?=
 =?us-ascii?Q?3BrtJoVPm7/IuO/jDXX1JB4ldNegw8AfD+OFuZfLpDiovaGE6oaUh/YOYllA?=
 =?us-ascii?Q?AXqAh0YcHZjSdhPzm5VpxHi/V+ZSIadY5B50BN83I9Jeh4eOOM3+aaPk2VP8?=
 =?us-ascii?Q?P6ayhWQQaa/r+3Qqnol4Kb9N/Sxby5eW47x6SCW7ux0tfhudzWvUODh9h3Mt?=
 =?us-ascii?Q?p5ei8iyJzV4thHytvSzjCgfM0ZYaGY5ypEpX0uB1XGdbqf/6uZ532JiE95Q0?=
 =?us-ascii?Q?NBb2quIVPQ+JRtCWaXPqc/2r0mqbP7bo+IGtdQf8qgdMpaPVqhIHspPkkpUd?=
 =?us-ascii?Q?hFwAeBnaNkIzy2RVpHxDtVmTmhibzMarM3kHPbAnc3z6Lb7wKZ6YlttlVrq2?=
 =?us-ascii?Q?PfDr/8K/9E3NOSk0fuf+fmVcIXRohwT/p/7AcLkvuw4Y9VfeDbP9jL7Emh7z?=
 =?us-ascii?Q?UM4e/pG0fNBajhPgwboCnIYbrYu5boT6XldSB08IIojz41xk5wTOKnfwwGpw?=
 =?us-ascii?Q?QZxtBR16x1EcjlZ9H/kYWsB2TK0w3hGJEfFZG0f9G/JpE8jfJQI0GIz4ctRZ?=
 =?us-ascii?Q?V/Mtilbstykb/aZUsncNVZJoZGUzTLTX52wGDv0J?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ef2f1a-7f18-423d-4031-08db44798a0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 04:08:20.0470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OjX3VYrWlH4jdplawQygSPJ657dljRsDq/gsXXmDOaFCknYqn1+/HnA9ZH+unXIO1Y1H7rqMy57BibIrG0QWcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>John Hickey
>Sent: 14 April 2023 04:33
>To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
>Cc: Shujin Li <lishujin@kuaishou.com>; Alexei Starovoitov <ast@kernel.org>=
;
>Jesper Dangaard Brouer <hawk@kernel.org>; Daniel Borkmann
><daniel@iogearbox.net>; intel-wired-lan@lists.osuosl.org; John Fastabend
><john.fastabend@gmail.com>; Brandeburg, Jesse
><jesse.brandeburg@intel.com>; John Hickey <jjh@daedalian.us>; Eric
>Dumazet <edumazet@google.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; bpf@vger.kernel.org; Paolo Abeni
><pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; linux-
>kernel@vger.kernel.org; Xing, Wanli <xingwanli@kuaishou.com>
>Subject: [Intel-wired-lan] [PATCH net v4] ixgbe: Fix panic during XDP_TX w=
ith
>> 64 CPUs
>
>Commit 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
>adds support to allow XDP programs to run on systems with more than
>64 CPUs by locking the XDP TX rings and indexing them using cpu % 64
>(IXGBE_MAX_XDP_QS).
>
>Upon trying this out patch on a system with more than 64 cores, the kernel
>paniced with an array-index-out-of-bounds at the return in
>ixgbe_determine_xdp_ring in ixgbe.h, which means
>ixgbe_determine_xdp_q_idx was just returning the cpu instead of cpu %
>IXGBE_MAX_XDP_QS.  An example
>splat:
>
>
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> UBSAN: array-index-out-of-bounds in
> /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
> index 65 is out of range for type 'ixgbe_ring *[64]'
>
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: kernel NULL pointer dereference, address: 0000000000000058
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page  PGD 0 P4D 0
> Oops: 0000 [#1] SMP NOPTI
> CPU: 65 PID: 408 Comm: ksoftirqd/65
> Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
> Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/2020
> RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
> Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 b9
> 00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f b7
> 47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
> RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
> RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
> RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
> RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
> R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
> R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
> FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ixgbe_poll+0x103e/0x1280 [ixgbe]
>  ? sched_clock_cpu+0x12/0xe0
>  __napi_poll+0x30/0x160
>  net_rx_action+0x11c/0x270
>  __do_softirq+0xda/0x2ee
>  run_ksoftirqd+0x2f/0x50
>  smpboot_thread_fn+0xb7/0x150
>  ? sort_range+0x30/0x30
>  kthread+0x127/0x150
>  ? set_kthread_struct+0x50/0x50
>  ret_from_fork+0x1f/0x30
>  </TASK>
>
>I think this is how it happens:
>
>Upon loading the first XDP program on a system with more than 64 CPUs,
>ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
>immediately after this, the rings are reconfigured by ixgbe_setup_tc.
>ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
>ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
>ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if it i=
s
>non-zero.  Commenting out the decrement in ixgbe_free_q_vector stopped
>my system from panicing.
>
>I suspect to make the original patch work, I would need to load an XDP
>program and then replace it in order to get ixgbe_xdp_locking_key back
>above 0 since ixgbe_setup_tc is only called when transitioning between XDP
>and non-XDP ring configurations, while ixgbe_xdp_locking_key is
>incremented every time ixgbe_xdp_setup is called.
>
>Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this bec=
omes
>another path to decrement ixgbe_xdp_locking_key to 0 on systems with
>more than 64 CPUs.
>
>Since ixgbe_xdp_locking_key only protects the XDP_TX path and is tied to t=
he
>number of CPUs present, there is no reason to disable it upon unloading an
>XDP program.  To avoid confusion, I have moved enabling
>ixgbe_xdp_locking_key into ixgbe_sw_init, which is part of the probe path.
>
>Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
>Signed-off-by: John Hickey <jjh@daedalian.us>
>Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>---
>v1 -> v2:
>	Added Fixes and net tag.  No code changes.
>v2 -> v3:
>	Added splat.  Slight clarification as to why ixgbe_xdp_locking_key
>	is not turned off.  Based on feedback from Maciej Fijalkowski.
>v3 -> v4:
>	Moved setting ixgbe_xdp_locking_key into the probe path.
>	Commit message cleanup.
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
>drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++--
> 2 files changed, 4 insertions(+), 5 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
