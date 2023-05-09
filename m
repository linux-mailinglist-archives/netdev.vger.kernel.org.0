Return-Path: <netdev+bounces-1042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2306FBFBE
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D40552811DD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E98020FA;
	Tue,  9 May 2023 06:57:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CEF37F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:57:55 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58A772AA
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683615472; x=1715151472;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=prbwHw0kFcSRAPb1Cje0Tk0dW6CCNIaRnDsf/xQmJug=;
  b=LanmZNptkqbFt2jGhNsd4mpsj1JsAaHK+SWtxlfmzOfTJYazGjpcG2kB
   dkZUo8IvIAfHqH9wtVdlPYowIAPVX0fD/OSKp01Z6bQQ/TAsAoCkJ2fq5
   CwS1txfWZffjTsvuOr7oZ/vwvZv2Uhg2M8JPC73J7X8MAJuEfPWAEJj47
   jsOXk0BtwCYL/sFHu/L/kHbqE+IurVGB0JoJQWUvkr75PY03jGJBa6W7F
   0VzFfsc8EWCfz8Rsx9knVi5Xrm/qQRO1pIsGELihLCN7OlD9vwWkEi+A0
   eT10nWTQUtsNiVYxpwzbRNOXWq9EKxYvPOszJ1/B2TDfqHfZfoSu4l7Jg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="334271812"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="334271812"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 23:57:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="873054164"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="873054164"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 08 May 2023 23:57:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 23:57:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 23:57:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 23:57:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 23:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd9HuN1IyEmym1GKxyuw4p5zG5gX8UfDDctH2Q/QP7LoJZD7njbsR0U57MhLsaFgX1GlqZpzGnwgpcTLCyksrGH5VwKXftpTEsbkgl3J7GiQSD+ZlnWH2ZVY/6ENHrJt4Z+1Avw8WovxOGkoR6WIo+x+bS7d+gxAXzZsNsYi95O7RYZe2NwVBgsnuLtH/rD/8y9a3Ox23PpyAzQ3hX2zXVEnT11eZLZIRbFA0iTv1ZPOoBzUGc1zcU3nhUvCXQpQ/pw3nkQn1p/a2y6ycffvZGJyAR4J1TG1mKvpd2lDYrEMRzx6XPDRYJwboZ3hQqqz5ia4Fb4xkZzrkKedzvn16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bryb4JdSVg+4Tce6GFp5Ayh6uzfOf+VeECX4Y9wPii0=;
 b=ft7rDuoHfclCePc3hy5cdzd1x5pR7FonNRPlYk54JYBAJR58DfhmBFRQVqflKU5MPbzrHTtN6iYmp/QPZ5pOG6SWx01W6O1QcoGRU2t+3boeJ2iqQoDi23nTct2aSouHQQKkAusGLUHNRFIaRyBTj0Av21F8noAtwuw8PyNSbkv67OVnP8tQJRnnG7icJVqpD+Ld+FncSdtHJ1gidVbBMUltaEdMg8ZpuRKk/xKsz2+HUX/XOCNI3Z6LsKBVKrUEtM4QX85B3zkRAOxmpW6HL5TTCV/8sbY0wgdgayLLA+ebG56oOjcz9vUmkHKxUIYevT8KwG3/rAqs01KKuphQTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MN2PR11MB4565.namprd11.prod.outlook.com (2603:10b6:208:26a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 06:57:44 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 06:57:44 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "edumazet@google.com" <edumazet@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RMvuAgABRCkA=
Date: Tue, 9 May 2023 06:57:44 +0000
Message-ID: <CH3PR11MB7345C6C523BDA425215538D8FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	<20230508020801.10702-2-cathy.zhang@intel.com>
 <20230508190605.11346b2f@kernel.org>
In-Reply-To: <20230508190605.11346b2f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MN2PR11MB4565:EE_
x-ms-office365-filtering-correlation-id: 3a830676-9ef9-4aa9-29bb-08db505ab0ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hz0HtN8m5+zOQFO52kgzTZjLIp4FsdFXo33rzsru5lJauEIQXgVRe3pDTfQZH/NNsmEsiOvVQaFEr1ktyhI59XRjV/ha28g6XAf+WLuypTCjU1YaIpP5COS8Nsjjj/DIZiKd0RYtevoZDH2sUJLHQVM4PRXAyDAluXCZeFHbJ0rPu2ooibvY1yDdGleKCRknuniFw/moMkSm/bZNZC8ADNh7BxGqt8tmrjlEY3Ssj4sx1SLyohXHuY0M7h3uXdlErR1S81YScNZbMZJpCQnuotvLGXdBQnrTUI8n5Z1V28D35T253p8+cL6HbxJZ3vQVzzX3Efh8tK2LNr8r04xLlIvhlHw42djwATGVB42L4u0kn1En9HgiCof9YlyOFXA/dvnmJyhs6hg/rzMi4tF04dtHb6N1vsbIqZzWQkEHooldl5qG2IFgJZ9T2Cy+IkHd2s1HZjDm/9naDBfw7Eo5BZ4j3DnYc7EUOmi33h3Qv3+wlfDd4imDizqSm8LSL7bKDR9eg80nHvPprNTZpDSSaNNQfFtlDRSNqndTSnnQSRTasmT30VJqsZaw8ZCZr/n5WwIIQqw3e9GAwl5QmHE4zyn3m14WxFQ1DqErU5FoPcf7x8jBStyohIDnZP7+Caqc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(38100700002)(122000001)(86362001)(5660300002)(83380400001)(82960400001)(9686003)(38070700005)(6506007)(53546011)(186003)(26005)(54906003)(478600001)(7696005)(71200400001)(76116006)(64756008)(4326008)(66476007)(66556008)(66946007)(66446008)(316002)(6916009)(52536014)(55016003)(41300700001)(8936002)(8676002)(2906002)(4744005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3HLYROcueRL3eMhcx7UgTuOHkmGsXYAMllrBzvoRh3dFsu0JK+w7LAp16pP8?=
 =?us-ascii?Q?RO+6V1m5CN9actEaxOGd9zF+5e5ulS88J79DV+lHiVCocQIFZOTY1OcvUpOg?=
 =?us-ascii?Q?mAi0pKWIsnwTGDqNbFAIUl6qGJgtkXd1uYMOX9DjdnuliDUYLWBcPPDJiB6q?=
 =?us-ascii?Q?ZFUwPSQx6Ubs9pMv3T84UsVa4kipMavbkuLEBItf325WZvTLDDEY2sU5VN7b?=
 =?us-ascii?Q?uAp6yaCUWlLL5E9skLSgCDLjXs8grCF+yXWb8wjlHwvlm2/vsw7ZmITYVvVi?=
 =?us-ascii?Q?EzBXhPiKIXJbNJltKsVqyioxzjPDiyXxRPnOdMbv9M/h0bx2OiXdKHjMjzF+?=
 =?us-ascii?Q?F7AsBsmvJsLgdPr/xRjWEwn0AbenH6zQFu/+wriNrAiDey1lnGOdk1/kZ9rJ?=
 =?us-ascii?Q?aovwDQ8Ld6xHpEai3XO3IjYhvSdQppoP91eqxmFkrqOqEnzftERBUs+YtpJu?=
 =?us-ascii?Q?LY8UMYAyBVIgsLq3G81LNiEZActIum32Xon051RCuh1GU6WxcrQNlargOROq?=
 =?us-ascii?Q?U+G1CV1YX9Dk9iv/MmKBrviv2UIgPJjS0XW1ueMPc/fXIRlXljAu1u9i/OSw?=
 =?us-ascii?Q?kZqELZHDVkBnPfH3vz/vW3pfUwA/rpFPleR1ooiBc6+Ri/PLiF/62v2XYE1B?=
 =?us-ascii?Q?H450dl21AGMcgKOGVDaQRHwh7UOKk82m3olTpd3+JAW54Poqn35Yg3RYMzl6?=
 =?us-ascii?Q?C7L1H7VSU1pkuhG5Qzsas/0Z8dsXdHqsEnZ63bYUZKtcaDyC0wFmgRP6c5R1?=
 =?us-ascii?Q?Z/WCW7d/asKpDnIYj2onRVIW004QhJcO6xO1Brfl9FQHEDOGYWDKk3M6XJyQ?=
 =?us-ascii?Q?zdXzq0OpkVOP+WCGVii5YMvt4yUxFAxK/RFquj+UBZJKaqMm2+8jIodYVE/Z?=
 =?us-ascii?Q?WyWibylfZmcDit0+YbmlpEXxEZMzMc6oIxSWtv4JgNt1BiqWgOeF+GFSVbY9?=
 =?us-ascii?Q?kIIOhUwRgG570bpC6ftqQa9wpHsO46X3lXlKEeUtQcWRwrW/xmOE04qWk5IF?=
 =?us-ascii?Q?HfcBZ68y8xzTMge4pvkcsZzMv+65fHGZ8m/PXPN67+Aff7qlSLULUFaZ/DMe?=
 =?us-ascii?Q?KpLFaHZEEeZuFDD4G2zmmKRnNiNeY6FLVCJWoYhioDgiaPa0h0419obTDNl2?=
 =?us-ascii?Q?TULMNY7IP3LNK/cdj6heFuudFRxOw6d0CqEHbwlWhOkkxOSuZjHxHA7kWKyc?=
 =?us-ascii?Q?9Aszcvjw+VHhTyAMzrjHRI8v7S6dryLoGZRXMpHRubbM0FR7wQBZAv5vksPy?=
 =?us-ascii?Q?4bTpy4H2Yx27uDBv0PHAsdoHGKYdYVHl/h9rFQVdlsAv/SfIS0pFeWGrk+wf?=
 =?us-ascii?Q?LScrFdtgJBy8S5cnKNB9rWTz4egGVT0qq6+6pfzG4yaWnzRiByeg1er6VOGX?=
 =?us-ascii?Q?XKmiYJ0MGdgvyLBdgXEtCjf+tiaXMymaX5zE87HxUFh36dzotZWXB/97FEAU?=
 =?us-ascii?Q?ztkfBGS6XGxJXrGPIqwhESSyAUyLKGP9xcJXUGe65KKQL+UXFGE/FvSVtWKL?=
 =?us-ascii?Q?RVmz0WLzPGK4zjF1R0YaCDJ8bojL8ZlpTDd7T2KS6tkiA56/5oIEx3M44TxO?=
 =?us-ascii?Q?aGMWdafvznGJFe8j73zBrbvvXtDfZZ3kS3saE5YG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a830676-9ef9-4aa9-29bb-08db505ab0ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 06:57:44.4162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h0NHIn5HWu1w3bzQSBXsar/coxvI92tKFrh+ZGnMHTF6hCGGWPEQzPQlt0v7fi+TOZkskozpUd4bqjkba3uieg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, May 9, 2023 10:06 AM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: edumazet@google.com; davem@davemloft.net; pabeni@redhat.com;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> > Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> > possible")
> >
>=20
> Ah, and for your future patches - no empty lines between trailers / tags,
> please.

Sorry, I do not quite get your point here. Do you mean there should be no b=
lanks between 'Fixes' line and 'Signed-off-by' line?

>=20
> > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > Signed-off-by: Lizhen You <lizhen.you@intel.com>
> > Tested-by: Long Tao <tao.long@intel.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>

