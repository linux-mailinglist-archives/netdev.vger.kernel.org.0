Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4506D4EBDB9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbiC3Jg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiC3Jg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:36:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0246434BA4;
        Wed, 30 Mar 2022 02:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648632913; x=1680168913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=14HEeaDzuMBgceqz4MQyjlm8H/QFvU+MD+O2S/hv6uU=;
  b=bed6NFa0n3o8MXi2kmxaLqZk9G67xET6OTXcEquRL+ZQZjfq+6IWOxlJ
   dVLpqbJ25JG+BxEpIxZ/pk6GkpEr+HbWtx9u2h9Xvmxer1WCtbb2RABSO
   scUHtCGo4fnitx4ZsnRzaq+UIesO31aHQCHmbFoIbIZ2ceKqgf1X1R/GJ
   llnkVgl64ZsyHFW4DUl3zuHTvKVwOafudMfrYWzvP+MpoCCAjfYXX0Sr8
   YRIj7134yVp+N+vQEP1Kh1ZBEU0FjFAIsO7QJz0m7Sad7GipER6AURJOO
   bcIvzmDJBymwMmI1D6ZkmWuubsTmd5/xmnvYDZDJYJ/dAumW1TZ7cbEDn
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="284406315"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="284406315"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 02:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="565460440"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2022 02:35:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 02:35:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 30 Mar 2022 02:35:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 30 Mar 2022 02:35:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fn6j6Yag0Dq9MLOHie1PfeCXsMkzhw5Mx3fa4mXG7zj5uyqMNmMP1CfxgKa+eU0Mr8VEVX0KGzPVmtly8tkxSPElfHAtMoGstwxmXy0GseFYnIHxGYCShGISmgD2ygZ93WpzXehQZIdO2Gxnnc9mziSVkejAf9UrJQMzGOnoj10YTEWYpLzxsSWHD9rOYcazZILEdtyBToGwcIbL4aikcy5wmduGj9ExBXj6c6SE1+aSqYXbEo+LXr68wJ4ffEmphPJf2f0PpyXeFuMaXGTLKU5lOOGs2+6nKMkU3Lisus3LL+RrYbvHnsiyc6tebn6pZGww8st19pOo7oLhD+ZfPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3uSsGKtATaxNb4sgIgOhVjpJGx2XXrBR7KA8pD9NHU=;
 b=TTiF+7VscFeyYXxqF3nRx9PjaNN6OB6i1+Hq/NroSARyluza59rU+ijZY8t1zVnO6PkBLTtxeh/l7EkN+34gLUn4mtUZCdOk6bXGixNcwKzFp+sEOA9b0JMBUNDeRKKd7ZyEOEolaR0d3BOlWsOGpseJeZDPYzbDCw0B6StE2H2gF7gSLEXIokXYCWaywA22Z7bF5oKaJJRc0nE9mEuRQUGGYfiv2C4ssl6ewvF/hcZG/o13Og10hBr7W5lzaObNfnjhnJN6+oa6+PszZfsdU3Vs27WRmaz8MvKdwzVxDBBPFQ4fSkQCpYoLk2yJaQGpqr/vhLZAmCUW/U068r2cHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN6PR11MB1505.namprd11.prod.outlook.com (2603:10b6:405:c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 09:35:02 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::4d30:465a:d9:a06]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::4d30:465a:d9:a06%7]) with mapi id 15.20.5123.019; Wed, 30 Mar 2022
 09:35:02 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH intel-next] ice: switch: fix a braino in the new dummy
 packet match definitions
Thread-Topic: [PATCH intel-next] ice: switch: fix a braino in the new dummy
 packet match definitions
Thread-Index: AQHYRBfQBwsbqLRSV0aGB36+xtYJkqzXqpeQ
Date:   Wed, 30 Mar 2022 09:35:02 +0000
Message-ID: <MW4PR11MB5776E0CED116112C8B92199EFD1F9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220330092046.2727362-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220330092046.2727362-1-alexandr.lobakin@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efb69db2-6ac2-4c97-2c1a-08da12309119
x-ms-traffictypediagnostic: BN6PR11MB1505:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1505977E01E29796449216C4FD1F9@BN6PR11MB1505.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a0WP0xT4evSRUQ3VMGUv4993TwVGJLBWOai7qteTyY4r5sbHiFgW8b/fUHhlRorjSEqkkG05ChEoVRcXOxSaROhXyq3H5y/us/NI3WgYP13kEQnuAwD9OVFpqIxPcDXR2oy/X2dfIkM8Spbd0MkLqXyNO5U7mb/KIR75ysjbFPE3rDMgLqREKJvVagKCbWDv5VJjBRFtAjtNkEw4TihGD8PPzrtE88QBiUxFD4R9uSxTNVhYbxTLTv9fPGKGlSjgIQBCTILOm3es33QyPV8TvK6ReFYXdRQvo4DbVxwD6iSBBPupUyjZHAsadNe4o2CHelgeCto6j/D6KiEdRl/PMfzMMr9+RlXEyO7AjvTU1b0UZx5DdM+Tkc0ULfbLzW8NTDWk61oyZhlJhtjdQiyN6g2xX4NisFV2Pw+JGq+Lw94DVpyL7u91zjkZSDS7puRprIgIuzCIkMb+0EmJtDHi2aurBTKf9tZMqAX0lXaL+MnO47biV3BlQDd19nDtiNr9qXbeLhvzMA7Wd5w1ZS36xJ8EzXB1IDgidoItvQyTlv6paceCW6AonopwkbmiC2LmccA+Vu2pRh1LFQL30YJUNAAheV+cza0ElqUFAXDIJK4mfwWeySRsavDJxGUnTFh/2WOEDdhmXaXtmfYb+ArtZ5G+UIbaUxarjlXJSmDqrzqUiqJ2DN2XlC6KXB26bnV8BPXpUBr6iE4PLxKdKrYPUWDHPirImXOnPzPe7Tx/ws7Ccpl04XEhiL7p6afxb94RQFkypJTstpXEV+ranN6AmYcDWxeAZoMxpwfUCh+P4F0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(45080400002)(86362001)(76116006)(966005)(316002)(8676002)(64756008)(122000001)(55016003)(4326008)(66446008)(186003)(26005)(66476007)(71200400001)(110136005)(508600001)(54906003)(66946007)(66556008)(82960400001)(2906002)(6506007)(52536014)(53546011)(5660300002)(38070700005)(38100700002)(7696005)(9686003)(8936002)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?/jh1iwNG7gcTzPDaxIWxQTDfKsiMc4K4QSG/vRIlm7nHeCq7XJVYGLzFPL?=
 =?iso-8859-2?Q?8ZPfCUUnHsrGKWJ2LQfcYoL3K/M/HqbXlY9xfMpNCUqgq4GPctb2LsyhCt?=
 =?iso-8859-2?Q?t2B0rAqQ9s6tqzhxGB7gFS3rFJRWzRgDFhN/VTnOWrKFOgw2dqeYGRCnES?=
 =?iso-8859-2?Q?YMFWwZOHc5a4IZFI32GRtTeE3sFUc0m8n8fyJjGYBPHCU/JnEi1ab5CcYp?=
 =?iso-8859-2?Q?QCuCQ8n5rsMB9hY1QS7dtXd3TnRQE0IH32AWrdDM9JdvFD09a2Y1zMVfUc?=
 =?iso-8859-2?Q?eaxAJ5wgPMcQJiIXRA1Q5PvLjWc/nvGxzKNquAe5GshDj11HbrduxETQvw?=
 =?iso-8859-2?Q?M6yLreOW2w2WnseT0fhaqfMNI1CAgyv9VonMqDZybcQsrILSTysvafgAgi?=
 =?iso-8859-2?Q?BioBeDK70NuHsSD/OtHrjcq9YO7qUim5dtKfpiBhEv6db22hrxHnP42Lye?=
 =?iso-8859-2?Q?Cc7uLmJgbcN92Z7YRfcbQhiMvb3g4OnUYT89Mx7J/9DWaRmMS+f0Ze6RGY?=
 =?iso-8859-2?Q?BQ14pAOnrg0GAYRAG2pPl9bg7kKexnXT4DnFatJdgfgK6KabBucNsmvfgM?=
 =?iso-8859-2?Q?5TEMSZjSWgchrM3tvo5sepc1H/vaefEDdD5ShFkrwhqkzkmGmE17+5ZB6n?=
 =?iso-8859-2?Q?kbIp1qoI5bHk/FNhbde7eEQA0YizS+f2qLj38+/9AfAW+TWwyDSMJrSy6k?=
 =?iso-8859-2?Q?OwCMPukItRHdi9Q7gXUNvE0/5oO2M9KZUw/2bjVVy5jA1N9ZKgDk6oa0l3?=
 =?iso-8859-2?Q?g3bU4EjACizbLEdfIjOqtwoA6dLSAoFBcmmlDAAlG6ccFod9DCK9vAPZON?=
 =?iso-8859-2?Q?ONZidy2aIQSSHVGvl0D26nhnN0mCGilUWy1grTvD8zKYvtqkCS/qlM4MZf?=
 =?iso-8859-2?Q?gxLzfG7/rhXgD2g/T7sCR003iasrEb8QTGYzGo4mBTfyRE6SDQuDAFWno5?=
 =?iso-8859-2?Q?C7Y8QyIixzUdsg2FMO/321A5flSLsGM/Skcw9WzMBzne3ipbrBtq1cXm5m?=
 =?iso-8859-2?Q?NmZilG9J698O4JItwB/EmD40STHrzA9VnVC6YsfftCpuNOF07pYal9s1pk?=
 =?iso-8859-2?Q?HrNbbMoiSTcE+adTmy8TdY24YzfFUWMURtnIx/8bvNA4pEF9UKvYEVEZH/?=
 =?iso-8859-2?Q?ydOcN4/UmKUWDo7fjN7VkEDttPTK2zdyco8oI9iL9XEw3kEHtIKbB/fHKi?=
 =?iso-8859-2?Q?xCZ1Up5RN4e5XzTmJ+v/NegRXtQS0rETL2RRJ8X2LHUYNx8nA4rkT/x+GF?=
 =?iso-8859-2?Q?Kvz5IHjpOnMAOG896blPQqFVBFuSaiSKkFJH/WgETV+g+LTMx3e95coguI?=
 =?iso-8859-2?Q?ZXzurQPLq8R1hEWK/BEzqfiXGk5IKOEF4RGS82PJMtkU9vglPQLwcuNEWu?=
 =?iso-8859-2?Q?rKsLyvG4b3ygGCcv9U651LpWNrpptOS730ykj1klYqjjAyRketWsPSUUr0?=
 =?iso-8859-2?Q?0tprKmbgIiPttatkw4toRuR4+G21j1A60Ozbtv7QYPmz6wfNxJYjc2dZU7?=
 =?iso-8859-2?Q?jISAbNpkCW/ZRJElTvS2SZmsi2Gy6iDVu6SO4dXuzD9tuo+mQ98p1wv7nM?=
 =?iso-8859-2?Q?Dbwxn0xz9ksBYu1lJzk1Z7jw2P4amoMk5oNemMq4YGl4M/7ipDOv0o5TdO?=
 =?iso-8859-2?Q?VlJNiLhKVdcl+6USh56Wl9lZAbX0Q4MddrVJszbgg74Iwh7G6DpRVwQd1h?=
 =?iso-8859-2?Q?r0yTpDexJnMfHrswunAdmhToTxxMInInpBIbplcdkbr/pAM3aTkWZQgJ0c?=
 =?iso-8859-2?Q?JfLEB5HKaZrswwLS/2I8k713PFXTxD6pq3c3nbF8F0TvRMdpilUF7Ov9Wk?=
 =?iso-8859-2?Q?F8nLV6NCjg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb69db2-6ac2-4c97-2c1a-08da12309119
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 09:35:02.8110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PfjLEuZr7kvWp1jxtn/8YRxT8pe3YVc0TG08EO70iFbka6N8VPOOQJCIkwJ9fuUcdF3hgR/G672IEISl2Q4y2HJuS3jsPogddrZ6Et9O4Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the fix Alex!

> -----Original Message-----
> From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> Sent: =B6roda, 30 marca 2022 11:21
> To: intel-wired-lan@lists.osuosl.org
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Fijalkowski, Maciej <=
maciej.fijalkowski@intel.com>; Michal Swiatkowski
> <michal.swiatkowski@linux.intel.com>; Drewek, Wojciech <wojciech.drewek@i=
ntel.com>; Marcin Szycik
> <marcin.szycik@linux.intel.com>; Szapar-Mudlaw, Martyna <martyna.szapar-m=
udlaw@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pab=
eni@redhat.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH intel-next] ice: switch: fix a braino in the new dummy pa=
cket match definitions
>=20
> There's a trivial mistake[0] in @ice_dummy_pkt_profile due to which
> it incorrectly states that "plain" TCP IPv6 packets should match on
> the flag 'inner IPv6', not the 'outer' one.
>=20
> [0] https://lore.kernel.org/netdev/PH0PR11MB5782637EA9771D3ED4E56012FD1E9=
@PH0PR11MB5782.namprd11.prod.outlook.com
>=20
> Fixes: b5c7ae81ff90 ("ice: switch: convert packet template match code to =
rodata")
> Reported-by: Wojciech Drewek <wojciech.drewek@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
> Tony, please squash it with the mentioned commit on applying.
> Thanks.
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/et=
hernet/intel/ice/ice_switch.c
> index ed7130b7abfe..496250f9f8fc 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -1276,8 +1276,8 @@ static const struct ice_dummy_pkt_profile ice_dummy=
_pkt_profiles[] =3D {
>  	ICE_PKT_PROFILE(udp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_INNER_UDP),
>  	ICE_PKT_PROFILE(vlan_udp, ICE_PKT_INNER_UDP | ICE_PKT_VLAN),
>  	ICE_PKT_PROFILE(udp, ICE_PKT_INNER_UDP),
> -	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_INNER_IPV6 | ICE_PKT_VLAN),
> -	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_INNER_IPV6),
> +	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_VLAN),
> +	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_OUTER_IPV6),
>  	ICE_PKT_PROFILE(vlan_tcp, ICE_PKT_VLAN),
>  	ICE_PKT_PROFILE(tcp, 0),
>  };
> --
> 2.35.1

