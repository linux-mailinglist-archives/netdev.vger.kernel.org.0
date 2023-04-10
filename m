Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C56DC88B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjDJPdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJPdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:33:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6732B4EF2;
        Mon, 10 Apr 2023 08:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681140832; x=1712676832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T1z6BxaugSjydJy6lku0cHkh2+9LTE4hV0X6Y/v44XI=;
  b=erkPNUL7NLvhjxXbdkUYHPQs5PELcqpuLuNVU8cjS44Z2Y2Wvs7jpcNC
   zq/HaVyczkQg7YpjW+qYMKOxtuxRH8G/eQJ3nisHHWgbK/noy47q/Ac7I
   LC2ecX7rDTOn7l4TXxME03fK+MtfDh0CSYYgwvF3HmwelQflAdgixvPw4
   IeI4G3bK9XG25cecwZP+QgbA0z8cocvVxl/+8bsDxVEkWco/OceFs+cXz
   uOYA0y2e42ksXVEumqlxf+LDhPVsOUYgmcWTAvLRgnfKl9BrRVES+6Wga
   cil9UYPxTNYu7EmCybK+hvW+/A5zihlAqklUYCYr4+G4LzGq4KwRnvIZk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="429666337"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="429666337"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:33:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="665642464"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="665642464"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 10 Apr 2023 08:33:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 08:33:51 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 08:33:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 08:33:50 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 08:33:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD6sKvHNgeCTzndc+ul3yzLQ0xkk+GPGbihx+aLMu7xtHDPx4DKTw5pREDmSZFt+WvNxXnZGD6fuxe80BkhGkaikFDn9sOjW4kxwpT7qkCaQx10l+9lQK4lVoAA1WBl+Tw3eD0+VgP/xLtXd2NMA9g3bHf2tcIKF2YZB/DymgsSATdwa25AiHCKZyImt0H4tj+UBYi9lTHlJ6UkrNHGFJ6CiWnq73+pVNlyC1/s/VoHB/jIZT1n9oCShMJD6o1A0iXYAXvsch29QoD2pdr3/lBSzRlLWvvor8h/OdDD7zHranqMZlMuglfbHLF6Q8u9Xk8GY6pfazEA+JHHOn72RSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHdkmtq+EaZs81BzxzrC91ypv9+2gWMrVUEDIV9LpVM=;
 b=jIf7qE9UZ7XAy12WseD43YgYtJwRJLm2m2MTWu5H20um9aPyztkXoyjgSI+eOUFUhATGPpqRI08do8vBy6rOXslyEoeCBK9NbZ3Lvn1FgplZVOQYBB8rTzPxtKLPLBih9oBX+gB+3ii+8XsX5GC2BM/VEFuifCOqq3/fJBw9H8qMkWUbS2W4S3gLGJ1P55+p8hWliFNkFPjIDDg/w3xzBztmK+c1VxW1Ulk2CdwsQYaIgPIt9vXc9f9am8FDQ0YS5tbZsgI+C/iQpAQxLofScbvKRiq86r7YCIWm6QKpKzjJNHJ8ObysthOftNyxZMr9a/3stzl4vSxg7wW9q2+//A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CH3PR11MB7867.namprd11.prod.outlook.com (2603:10b6:610:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 15:33:48 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 15:33:48 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: RE: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Topic: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Index: AQHZa5S9mRB50P2QwkG1pXlh2ZtnBK8klgKAgAAUx8A=
Date:   Mon, 10 Apr 2023 15:33:48 +0000
Message-ID: <PH0PR11MB58304A6BD97AB6DEA58067D5D8959@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230410100939.331833-1-yoong.siang.song@intel.com>
 <20230410100939.331833-4-yoong.siang.song@intel.com>
 <ZDQZeSe5OaFlNKso@corigine.com>
In-Reply-To: <ZDQZeSe5OaFlNKso@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|CH3PR11MB7867:EE_
x-ms-office365-filtering-correlation-id: f9b172aa-80bd-4303-bbf4-08db39d8fa7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aJIAfFuOVH5uE/vv1kQ4J2NveFfNsUDkzcYsQa7l6zdS23HvFjMaBkWTj/v6R/chdElQzRsGjAlW6dVeKYhzGhi34xJlEDjDsYNZFvuGFUdVmp6w9U+BVBmrXRJT3jf87wtF0OPRniQhcPteJRBBL6nU2IAh0royh0xVIA9oyi87CkWnm4ZFLK3dhje+num8cNUbg2UQgeymyHr1UQpTIlITpcGgUOUu+/6J9RKmm3c7co6D8MXABGtVfSXGC2sIcXa1QajaWSkfoPXZEIfFAPmEdw1Bk3VPRLHeZj/9k77m+F676AW72IXoVxOZUiKKtAM866U2ipGu8fh7VHMT2FF/oBVbWeRnnslHWNxke5yo3xk9btlw1jpySq9I4R7RM5bQrx3eWKMG/BwA/u37j+PpEOrMBpXb4oE0dANcr5GK0Md7KDYwjPcnq4PNp/2PmHZpCBO4vUKYfRnTkvtHQqeEoiwJeLrmMf+vWdaZxS2lNGFnRjCaAH/V82AN7z49vIDiAMe0seslcVS25lz7/bW3YESvx/5S7eVsr88eLPL0KnSJBcKNFVgC84AOspdVoxvQ0P3SuFnBLarJ4n9qpBN4HQvCk4PVrHuec/PjbEw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(7696005)(71200400001)(478600001)(86362001)(55016003)(33656002)(83380400001)(38070700005)(82960400001)(38100700002)(122000001)(2906002)(7416002)(54906003)(316002)(9686003)(186003)(55236004)(6506007)(26005)(66476007)(8676002)(64756008)(66446008)(66556008)(8936002)(6916009)(5660300002)(52536014)(41300700001)(76116006)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wz6sFGgLiUdqnn7XcaOGvH+1ScmAUgp+t2g6OzLb1BB+tSdw2Z63yRx/GGeY?=
 =?us-ascii?Q?ccpmXtvoihUZkq4mfjA/pkwRlJ6PrYuBWGQfef1+Lbc0MvptkMEZfcfSN2pt?=
 =?us-ascii?Q?39QykykUDTS779ShzYFGW1VvKxj7SA6LfWSQpszEUT29WDPP8vZsw7rYFolN?=
 =?us-ascii?Q?R3qRF+jmH8k8KWEsQeIB84qHXRlhwtAYiprbzaUqpSPFZT7mmBb101kxBwg9?=
 =?us-ascii?Q?mZiIX+Y2l9zz+S8dCXgQKNKTayAEsKfi3/ITiTXUdz1a8I4MJRQD/H6JW0t/?=
 =?us-ascii?Q?mPzvbzXUwZKXtR3WUAsES5hmAitUEDN9WraYUYZodyUyZvgakJP0H+KPV6b/?=
 =?us-ascii?Q?MKaag2AWAlX9SbS33NV1P34g4pN9o+GdpgsFfBFeMKAs1tfLNvlCo6kj1ygK?=
 =?us-ascii?Q?GNTydaol48kXMuooyTbENSWMzQxnEmqnC8Rc8BPDkEb07hbZ0ThjzWIX7xE5?=
 =?us-ascii?Q?jEPtvZgeonwKGgMM6lp6CF5Oht0d3clE4fJtHznc3VKRzF4z8OkzcEVXtEaG?=
 =?us-ascii?Q?BIZXjulbEwxchEFmK9V/hZiIgf9x2yOTne4xhtQIRqN8mbzJnba+bY4iwYfK?=
 =?us-ascii?Q?QmH6NXpmVBCAJb7ZdYKcC70KwbmFbbWEVG5YXRMyPt15thuSe6MI1Up5Xvzg?=
 =?us-ascii?Q?Ts84k1CaBICBqzhUBALhYA+divFmIluonWROlodLU+isLTOVhghHuDkW/82S?=
 =?us-ascii?Q?se2BUlxg6moOZoB5mAPIs4u2TauVbVT9qvZBgJKbZbxWEuujz5tZpQf9c6Sd?=
 =?us-ascii?Q?BV0z/OTXjs53LDA54h3ls1ReC1848LVwj3WCGunoMQ0Pcwm1PqLVJjrHzuhv?=
 =?us-ascii?Q?+eIeo5Gy0h84o6GUnIOVskoqrG7oz9QBUkbk8PWpAU+auy630loV0sR5DLBk?=
 =?us-ascii?Q?okqtf1RcU5LHaSh/YdpvOvao2PkArE7B391+PtSjTaJJIuGA7K5N09oyS3SU?=
 =?us-ascii?Q?5ZjMNP5ZZJjJRAZCVuhuhf32st+b9gFFWp1S2VMaqkh9TE85kyfnllyZahBj?=
 =?us-ascii?Q?fTVvfclxnz44G95vR9rJn/YxttODo/+Yu4GrDfN0anmdYw9SpQDdki9M/iaW?=
 =?us-ascii?Q?Jjj3nfpXOWUNOGnIfD9KISlVpKJQ0YIxkBGlMb8bLsfCeN24cQ4I/bfoYASn?=
 =?us-ascii?Q?Fh7cM0sF75P46vAvNhpuTyYJfAzVHRpI6qU9wK967HY+XfF1GLGXFdryeg77?=
 =?us-ascii?Q?gxAlaqVAeyFTCU4rBvaBUsZSQtVxsE6mj6ca/hGRLyYtBEPKmeI7CJbIFFnc?=
 =?us-ascii?Q?TvSh+PDZ2YtflXzi+RJx/37zQ2WHKlRyhZM4FoKHvHD2xeNUxe5KEwZ1iKN7?=
 =?us-ascii?Q?RoGixhRk5xbPiM/hcq1t1nmwaMeGDcq9Z/mgeN6hTA2gQR7Gkn4ryj8JdiEP?=
 =?us-ascii?Q?5ar19NH1ooIOUQd3jxjWoQGpbrWbK4bjo8e6f2DAmHM+qPw2qcSzVvUVnN2I?=
 =?us-ascii?Q?F2VKx2lj/TH24ggjryBVG28bZ8cEKT7LTqnjQFR1oN9wO99rbhQi2kjopASU?=
 =?us-ascii?Q?W+ZZ+dsMIPFwe/DzlQulJhjFtfR3tM52/Lz13JWcIJwnVUHLTvvT4fGInKUj?=
 =?us-ascii?Q?r6QT/vubAFJWYraZeB4g4HGB01ey/FG2uW6Slyv7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b172aa-80bd-4303-bbf4-08db39d8fa7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 15:33:48.1373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jPn45OTNDhMM+PkC2AtMVt736kbKGXUkhA295h4UlWgcCbT9N3ggJ66QudPrlOS6kEA/o9o6WsgINyb5wZYumgF5JMJLGVjgF3qkj2qbDQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7867
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Mon, Apr 10, 2023 at 06:09:38PM +0800, Song Yoong Siang wrote:
>> Add receive hardware timestamp metadata support via kfunc to XDP
>> receive packets.
>>
>> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
>
>...
>
>> @@ -7071,6 +7073,22 @@ void stmmac_fpe_handshake(struct stmmac_priv
>*priv, bool enable)
>>  	}
>>  }
>>
>> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64
>> +*timestamp) {
>> +	const struct stmmac_xdp_buff *ctx =3D (void *)_ctx;
>> +
>> +	if (ctx->rx_hwts) {
>> +		*timestamp =3D ctx->rx_hwts;
>> +		return 0;
>> +	}
>> +
>> +	return -ENODATA;
>> +}
>> +
>> +const struct xdp_metadata_ops stmmac_xdp_metadata_ops =3D {
>> +	.xmo_rx_timestamp		=3D stmmac_xdp_rx_timestamp,
>> +};
>
>sparse seems to think this should be static.
>
>drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7082:31: warning: symbol
>'stmmac_xdp_metadata_ops' was not declared. Should it be static?
Yes, you are right. It should be static. I will add correct it in v2. Thank=
 you.

Thanks & Regards
Siang
>
>Link:
>https://patchwork.kernel.org/project/netdevbpf/patch/20230410100939.331833
>-4-yoong.siang.song@intel.com/
>
>> +
>>  /**
>>   * stmmac_dvr_probe
>>   * @device: device pointer
