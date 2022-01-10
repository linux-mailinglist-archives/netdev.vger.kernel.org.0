Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB397489610
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbiAJKNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:13:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:54879 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243650AbiAJKNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 05:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641809600; x=1673345600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U5uEDwXFa2R+RjYSh2J2Wxn4DBZ9iQPvKxh2ojOtfUs=;
  b=K5I5Am+9cTDfjlgtiecMJ9TNzMGmO69Ky7002ldFyuTfz6R2mucNsWp/
   +gkkKZFvkTURlV/+cqKp7DAqcRG0y0otEOtbWd+8kcAARBV1yohqSMzzx
   rcg3oUNvnKPDC4KlvIInW/wLJ9bJT+2VCoKbE4vct2yUy9LR2iFpn+CrA
   6PPXl2AYzUvBbHtcoEuxyUC/lBh27nslnW4nQ8GqDvb/mm4x15wK8f0Ns
   pusl+KfvLphdLY52EcslRJHztJa25JNPnJpxCPbygQyPmkyMVMbYHAY7Q
   rQGuPa+LbyjLof+dyYDYBNNyByCPphSaNxR5qmufmvZMtz8x1KgNEWfP+
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="223890629"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="223890629"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 02:13:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489953660"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 10 Jan 2022 02:13:19 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 02:13:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 02:13:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 02:13:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUxQFmIhHBGSbFThARfeQH9EdXg5qgvX46yF/sEQoWP+/fcZdrYTJEgOrcDCdFBeQ4l3FxFwRgNGKyR3UZJMHWWlWqHxjeblkCCsRbnsjpV1R7hwEZd/LBkRufVwn6hFchGieeJxd7G4/Yw++HfRN0fcy7XnElNvHfCD1gYcCFpMZn/Rm4Zm6hJ04pxYXDL/LFwX0VRuu4xWYaSd15SC8Ou9hs/0h1jItSNB8an1A/BVsrRsu5FkPndNPHyCVAmBfr4jCBi6uKxbgPZjERW0ASnl32OqEAmwxT8HNXGVhl+uZKkVwI5/bCGpwbnxSBSd6RHgxbKZVmtzYLOLFd8lXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9BCW0+Sndr1Yo8/ACkMX6556PDG0DCs4ZAQ4Kv4cbU=;
 b=YK+gWbVTzgmZcgCVbMKephlOnXX+0GaelhLa6irwi7GXFci1XwziYIVJsOb+3AwXUKkG0AcKLwrG/ZOsRdak+02omcaLtEfuUJH5ZPXaKMLkLNIzfnUJyt36OglWYk0dO/QpiCAGbxHQj+ACve0qPwZNVI+y8+mdZUcBxuzciJwm5BgdRCmRBilWk2DT+iXcASfXTB2KI6Xiy2RgfNf9l+2MBC2NYJtvmtNJBViwiLOXr4vMzA7FOEXCGXo+BF3Ssbw6mtt0GIW5kmzPcqylrg93cPdeSgOjKEfHI4WBS1wVcBa5voWSUYc4+4Ovw9HAaExXhak3+hQcmGzob/IdwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB4153.namprd11.prod.outlook.com (2603:10b6:5:19f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 10:13:17 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 10:13:17 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>, KP Singh <kpsingh@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 4/9] ice: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 4/9] ice: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Thread-Index: AQHX7D0HTX5HBo8JUESTUj5tOMV396xcPJ1w
Date:   Mon, 10 Jan 2022 10:13:17 +0000
Message-ID: <DM6PR11MB3292FE1773DEDE04685C35FAF1509@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-5-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-5-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: 71ca4535-703f-49e6-1dc4-08d9d421d25c
x-ms-traffictypediagnostic: DM6PR11MB4153:EE_
x-microsoft-antispam-prvs: <DM6PR11MB41530DC2F1BC8DD55EF91B8CF1509@DM6PR11MB4153.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 57vMGQ5r9oPktxgqE+lmlbtkInoBxmFfTF38w1yqymdXODWFYAzZ5xgWQSsvmUkCKfBAhcqGAoC1wT6lCjasXeZa8wQPOhbgw/2yCsLn83SJzJ2ScmwF03lOjGi5NcCWICkduLoL0sb6EsTfKlc69b7frlLKAIYQpbOGbu7llDmEl/mhQ8HFrSr/noUqlwykuCxdrtJ6rPi9LfRoYJjVBKv0EU9xnB06bpGgH0jDTRZpiYKD8P+rE9A6VKtjVTS2EPANoz95IZCZDlEqVOY+xjV4nHBeFUi4OpRdIS/sHcrf6L+sc3vbFlDerIT8NHP2h9qJ9RJIojQiuYLH/rwQNXoBgSdxKIZjLIjvULLBi6dBmHwULUz664JChSphCMWSr5fYbnLwKWmvOtQBBWh6GK9NBxsf4zyuVVaxkeYroN3z2WIS0Tr3krbTd0dDt7zlQNOrmsIntNzT2idhXPxE5QrsIX0Ey46r6UZElZ8/zliW6SxXhU3Dg7uGXIA4mrbVJ9JlFW7Alur9xJHbhWBkskbEPzptQ/zFwCGxU+ucdtbGlk0XUVslA7+Hue+gv1P0A7lUmycWhdSnxd0MI6DMHAZf9ZFsY4Gi4pCL4COpndMW6clIM3ZvxAuHD2jAgYVkUy6pviRSHQNOQ10EIpnmfeetp43T4/x5D7HWDkdU2BZCKi4WRgBo8vvpLJOih6gL1xy2kCwBs2xImoQ4BSXsbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(7696005)(316002)(8676002)(508600001)(4326008)(71200400001)(54906003)(110136005)(38070700005)(38100700002)(122000001)(186003)(76116006)(52536014)(26005)(82960400001)(66946007)(2906002)(66476007)(9686003)(66446008)(64756008)(66556008)(7416002)(86362001)(5660300002)(33656002)(53546011)(55016003)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?15qYl2sKOlengDS9WHg8+qfQFh5pLjNF+/geUr7fiN3Zu4hAau36MINTsd?=
 =?iso-8859-1?Q?l9l4r5E5GZ/l1fwJaQ712lojvfZFNv0GetCEJWMFZm3fhDSPQpeqqn11TV?=
 =?iso-8859-1?Q?+y2G5Hvldcc7C12zuKYVIaeGUCHYKi7xbQuPkvPWPd/rDn/3HD9lpUNMrT?=
 =?iso-8859-1?Q?GqZ42oAzI2ZkvoL9sjKUsXMfL5k7KuPhmhUrxfFjB0xMMDqtHtwwDM5bs+?=
 =?iso-8859-1?Q?resH87j/TFYpHXS0XWewls+5pFLd8zGCEOcdS1vLaeSbK6nzJLA1znoUua?=
 =?iso-8859-1?Q?+k5BstLGJk5yYVBjKUcVPFIVgmgts8PXeSiYYwnufZ9UvkqYhr6HV2bImj?=
 =?iso-8859-1?Q?IwXxIzKgWm56b8OEjhqvj4Xcj52ZDFwqyYRh1XWwfaVZ5Gyqbh+rHVxF2m?=
 =?iso-8859-1?Q?VjJjCcIPicX0o4hWE5/mQ1QtbBoR2S2uV0LcJ+UiAjYusb0Uo82nsyPwzg?=
 =?iso-8859-1?Q?KnjigHZtXZ9NGujhHcD6AfkT4y3c940+b5zpKzTfe9pV8rAjHe3CfjVWsy?=
 =?iso-8859-1?Q?zRpljWZOSuSVSoSPSXKMv4T+f+1Q2vi238IPKZ84vFJk3UPF9zuLvkTZ89?=
 =?iso-8859-1?Q?Bd2JzVS8EuSW3IMtWEV3SZ9+ayRp30VIWQdfOXs/YpbPXMhEacb30A0Qyo?=
 =?iso-8859-1?Q?dTCHwcNgl5YDzQ3IgdgIQwbKZJ1Nf9DiAICfYi0WOTfLWvyidx8EHXrZgv?=
 =?iso-8859-1?Q?/uX7AxHeAJUhGfIKbv4z7SLvaCFei0CbGhTZuoyt+W8xRHqeXJtnwMq/xk?=
 =?iso-8859-1?Q?Rfe3a3EIVCbEtA+LmfvE4Oas5kFng2T5UN/QYykZxNwtE28AkaAYXihvoj?=
 =?iso-8859-1?Q?H7OcGEx339R1PHj9eZte1qLtUPdsiP2No5AAtuWUMe2z+ckkqch1ZCy40q?=
 =?iso-8859-1?Q?cilgZjFL8bA9TymDlFiFDKeHVBCOhbE0AOGSLoRo+UiLxinxsans+hykrR?=
 =?iso-8859-1?Q?xLLnQRvzQ5NYjg4y1hyGRhjyhsgHx3+0/96scAs1Bvp3gkvgP4AALHG2gH?=
 =?iso-8859-1?Q?3YxiHiUtyBJ7lfofEXTsfKozWIJXggFqRo5Xs0tymu4UPIKy5GHWUwnItC?=
 =?iso-8859-1?Q?OHF2L5zoxPMwC7UL0M3Es6DOe2x/wvaRCsogjT/FKI7BXVFruHGyGO7FkR?=
 =?iso-8859-1?Q?1wJUrMEk8upXHgm8fWOckTID6vbQSk0YUJHQ2PRjxWse6oXflD0PnOcccU?=
 =?iso-8859-1?Q?l6bM5oU49V8YGcpease6qLsIyxwbwOeWDLWGbWzxp3sD/GwCUFFnZaX5LS?=
 =?iso-8859-1?Q?CX7SqUM56WlnuFj3l8mUQ5a6O1uBWF3TouyUD56YNkyGgWoOy1fF/6Kbjf?=
 =?iso-8859-1?Q?iFEpVeG8W+zWWE8IDd5+kOq/3syQbFK4FRO4KlOZoVLtQAjJrTFl3SrAhS?=
 =?iso-8859-1?Q?9JlizQMMv0+ypDjS8XKhmKA4G1YgqjNaA09Qd22hzModabPXGXGPUG+23l?=
 =?iso-8859-1?Q?8Jww1h5aJ3ighOvlzPMTsXL15vfgFi64nHywnP9GFykULZWCgUPC3x9PRG?=
 =?iso-8859-1?Q?w7zr41aBRniXa1hRvQ4tG5paYMyfy0bNhRWWm+5rkW8DpWC9/DoTMfcweH?=
 =?iso-8859-1?Q?rTnthIjUkP3ma4RLboa0DxZEjZInBr1u4Cj5lr/SD4O3HW9oXNcOluPsiq?=
 =?iso-8859-1?Q?FB1qgJjST46acV0r2hA7DgRxAq508bei6T6Ig4KKq+U4JctFgu0eD3MiLc?=
 =?iso-8859-1?Q?lQoUPWRIIGKZonYJL2DKkvhR2/tCLNSi07w7jzbDda+jmqPVHn4fds+mHL?=
 =?iso-8859-1?Q?NWbw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ca4535-703f-49e6-1dc4-08d9d421d25c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 10:13:17.7428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGcgUDQ+0MVN7d/6WO2reiA5QtL7DsPyn4F7HYxefBp8inxzvPzl8JcX8EbdnA6xZdZisBoQubHp3aMACrrxu4wsJlA6tWZimoskGwmZrVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4153
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Wednesday, December 8, 2021 7:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Song Liu <songliubraving@fb.com>; Jesper Dangaard Brouer
> <hawk@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Yonghong
> Song <yhs@fb.com>; Martin KaFai Lau <kafai@fb.com>; John Fastabend
> <john.fastabend@gmail.com>; Alexei Starovoitov <ast@kernel.org>; Andrii
> Nakryiko <andrii@kernel.org>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
> netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; KP Singh
> <kpsingh@kernel.org>; bpf@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH v4 net-next 4/9] ice: don't reserve exc=
essive
> XDP_PACKET_HEADROOM on XSK Rx to skb
>=20
> {__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
> + NET_IP_ALIGN for any skb.
> OTOH, ice_construct_skb_zc() currently allocates and reserves additional
> `xdp->data - xdp->data_hard_start`, which is XDP_PACKET_HEADROOM for
> XSK frames.
> There's no need for that at all as the frame is post-XDP and will go only=
 to the
> networking stack core.
> Pass the size of the actual data only to __napi_alloc_skb() and don't res=
erve
> anything. This will give enough headroom for stack processing.
>=20
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
