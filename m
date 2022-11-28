Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A3963B22B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiK1TXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiK1TW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:22:57 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D70259
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669663372; x=1701199372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yq7vDRhMVrBmdvjScuPj1VQ/QJPCe1tQsInY+5ZbHi8=;
  b=gq2rRLXgdiD6UWQ7R64FPgQj1sfuEZhcLi7QH+cNxnOft3LmOmYsKYv/
   76QJJXM4biMB5kOwpGJ+EgaQykjraOkHadTOmkcj+2EdVQR15f/uoC9rl
   gWlbhunJ6S36dqHIXq3S6SMFLzn3OfH33+2RR/8TcAII5aC6cCOPvJYNq
   SMS4SoFpvTALOt0HWp7hzLPs5St2cr9Ry8WsyeKX+dHoT7x66shqfIIrx
   yOIZ954jWgTsWqHvYF/PywYvNzI0kfSSFM5vgQSXaAMobtW+euEy+WQht
   etId1jA1pF5EmLddmeBP+rfsifdcOwlzAXNybWapdM1CuqU8OEhwZfMR5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="314957112"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="314957112"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 11:22:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785756732"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="785756732"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 11:22:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 11:22:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 11:22:50 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 11:22:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzLP9AwK/lfPHA976Wcx6BvZgaixTEgku3M/StEgPhX9alloM7+tpySXde31cAMoHEHykYJ3Z1bnqU4DgUuwXaDLaRxmslYdMAGb4tpME4hZudpceUGFmKB/3IuDvCTlQALM5UxNh2DyeRaAhSFrixGyGYRrVKAueob3Zz7W+rPUHnkrZn7wIcBE80kC7R0Fq94YNFMP49io80rQC16ltBKg3S1zc56VQCyuR2wWkPUDGk8H0bSRGeJJzSK5JHkqxKX6Ke1E34T1JSbRlq1GzCXTe1AL0tr/kf2cbBP5R+AdR0cnzzJM8SZjJAr/MlAkBdZWwdOdxCl2x/CgWkXLEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yq7vDRhMVrBmdvjScuPj1VQ/QJPCe1tQsInY+5ZbHi8=;
 b=A/0Y9VDlWMKnqx79ft+wA2Vv3ryNA5NkyPfsgzshqXGuOAQUTNB6KePM5hkQeDhwTavPMqEv7XcPFGGhssERf3vTOTtWKpCe8Km6E0HpQ2h5znhYqNvaG2W4i5cHRD9Mqk491Y79DVgjWeoOVrhd8DXcweRbb8nhrWDKpoX7+qhwksay+BwUEpDv4//ni2AOtYykoENcPj2VdLewWEn5mabNNHGyHv/HhP1ULOy/HjBI+65eX5JgZ84nio0TXT0DzC0Eii39dkkd7o170D5uzxOUCULuEfi81FYZFyddi8o8KbPXGACvCCiFCo6kQ1rajA6Y3yhZdv1g3pdkuq5bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7888.namprd11.prod.outlook.com (2603:10b6:8:e2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.19; Mon, 28 Nov 2022 19:22:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 19:22:49 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 5/9] devlink: refactor
 region_read_snapshot_fill to use a callback function
Thread-Topic: [PATCH net-next v2 5/9] devlink: refactor
 region_read_snapshot_fill to use a callback function
Thread-Index: AQHY/3uZ2p5u0lMYtki/9oMA3wzSVq5NyriAgAbitOCAAArfgIAABj7Q
Date:   Mon, 28 Nov 2022 19:22:49 +0000
Message-ID: <CO1PR11MB5089C5B047ECAEB964E83F29D6139@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
        <20221123203834.738606-6-jacob.e.keller@intel.com>
        <Y381byfh6Oz6xKBD@nanopsycho>
        <CO1PR11MB5089966656A01AF44BD6F17ED6139@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20221128110007.0c362163@kernel.org>
In-Reply-To: <20221128110007.0c362163@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DS7PR11MB7888:EE_
x-ms-office365-filtering-correlation-id: 2cc9a236-0311-4107-ad6b-08dad175f000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kKGoMScyIuW4nTOwN3bwbNswFy7CSr5B1JoCzG574n6nmzR3jGKf8sYu3tajRoQyr8HSYeqjZrk1tnn9nv/F9KLsuY8tmev10spj+kJyKbV8UBkyKNN0hxpxFj0k+BCbniS2E1eys5NVNMve7Zcds3VkuB6H7xXIllSItSXLB7qvfMA1PhUZrC+40QGTN1a5BkCP01czN1nVo3LBNG8XQ/2qrgVvCNahrbGU44tRyvsZNpB2DgTUm6rOsaDEn0RHTrU/8L1cMuytZoM7njU5TDfxv3N/mhPIuPwlD0L8mmoFFB8LYAZtRAW9vRb2UYPoxTqD4KSNwUSCyhv6mpSvalUxeQvlO9nZSDX2kdxw3QyY54kD450gaJgZOGDjSsj9IGsWVrsQhOAQthnDbGYqnGC9RWaTveQoNi5/LMD4cnIiK8ZBpy4Ii6y8o8RbQ+/JtoJeJP4fYxUy0xwk6lm4eoCoeKPpBiAiUURWVUvKsyBLk+d9naQZ4dG4Kb6FwxapMNLzggUh8DnElFM0HGOg5qoBMXb2bzOp796DZA3P7VPzSR2SoetFTs4wmGAGNTh26Y3+DHET/FYqup/4blV9QrsuXi9o7AYfV9lp3Pq979Bt/bro/3YJ5NMT9y2rnh0XECmFQzMT4LZ7XiUwvQZAESZRmIbXYBc2pqhE621ej8mYrYOhw9UCgi/EKBrxaUB9W16H8DHLvH1OrCKX9tdjUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(4744005)(8936002)(2906002)(122000001)(38100700002)(55016003)(33656002)(83380400001)(86362001)(38070700005)(186003)(478600001)(82960400001)(52536014)(5660300002)(64756008)(76116006)(66446008)(66476007)(66556008)(66946007)(54906003)(6916009)(316002)(41300700001)(7696005)(9686003)(6506007)(53546011)(8676002)(4326008)(71200400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?idhwjXf71D7XaTJ7UkW6z1bFvq2COyh0OTlV0cbXuqUvYr5sLNsNoXs5TUdQ?=
 =?us-ascii?Q?OUQ6NFCwdDLsoMdBy9QV/UTZKqIi0+xUAR0tbSmCsBvSjmBGMRsQbVC0M63l?=
 =?us-ascii?Q?faV8cUxO5xkOEZy44dhyKmfPci1sAbU7zZdgobTbq4Nf4NlTzmENaEW/wpis?=
 =?us-ascii?Q?Qj8TKYe5tT2dqqYix2Q90ANl88mjfpgszaRsxrc54HRYToQ85tXOGsk9aC08?=
 =?us-ascii?Q?GN7tP7vLWH2+SDEYclK53DtTpH4ox5hxNkWKDrfzq6KBbKy4nc+1zJ0fWizm?=
 =?us-ascii?Q?V5nXTM0Sjz4GQD9scySGbD1ZQ7lfuSV/b6ZeLl1YWkQol1tBUvlYVcvFV/j/?=
 =?us-ascii?Q?XpPX2p1LGksDXmADhfXXyRkdKYYsoC8pCntEdk6mj4FafiUbyTeArLOiwqoA?=
 =?us-ascii?Q?0SLDFQqAR+q4Pzgw6AlzVMcT7G4zKT10bEFbKKtOKBamyJ2VsO4BXNo3K0Dk?=
 =?us-ascii?Q?Kb8XP1FPYQ6I6NFRuAQeyzbjhKhoRvmkNAH1NwLjvhIzl3D5wa58rWFkb5Jx?=
 =?us-ascii?Q?Vlxzrdt5muYDLjwhYEK/YRSSSJkBi24aYPrXsu24Su0e0BlepQG7Pv4844MY?=
 =?us-ascii?Q?nG27AQBGqRcrgSvey4eAVzv4E8FpBjVOnEZgTtw48ic8euaAyJRb+iVcywBi?=
 =?us-ascii?Q?hXA428L9+VOL4D644IEw5wk8SwytNH/kFK0wf1+XFkG1aRqQdwxCUAg/KUXt?=
 =?us-ascii?Q?zdhNsZSNInSAWqBKReT92vzF6oAxZ3912QucceperSBPEfnPOyh3pEmTrkk0?=
 =?us-ascii?Q?QVi9mZMcvYo+v0zjt+rRFx5H2oUclG+TCpRAODLAMc0fINvnxiaLeAKxCXXA?=
 =?us-ascii?Q?r5Vik3W+EGTtS/m6xPe5jd8tFFIrNrKYkKcAAW5l12/CYqoNebeWVjsDFX7A?=
 =?us-ascii?Q?hj41GYz6ODSJMriA9lEl6EsXJL0UgTnzTiwW20rbTBNFgKAzj0sBZmANz6r4?=
 =?us-ascii?Q?IcRyeXgM8THx/IDvs0s4S+mfcVAvhnnHy7WIyWrKUfS/2H2U6LTNUf84h/sm?=
 =?us-ascii?Q?k82QYQQyrn1TJV4hgc8owQsIlT+5mcu0SdQaAQlZwsB+qaCymzPb0/qATI/P?=
 =?us-ascii?Q?R8vEerouyakkQY/L7maWx+UmEpRifjfYac7VW3PtzSXbEZwSZGUnrUmAIDLA?=
 =?us-ascii?Q?aHEpL7kgoCMfgq2urmJrpGZIfUEoHGqJ0T3Cn20m4cU4gGfiF4cBz/oB8euf?=
 =?us-ascii?Q?fdNHZICvkkqObATb9Fkn6RS6WmYF+csYbmBM+M15T9aljKfx4fyr+WkfcjHY?=
 =?us-ascii?Q?A6OB3X+64oF3Twk3JP0bjP7mFMOL54la/LWPrA/sVkgVJBDOPzSILhNlxDz3?=
 =?us-ascii?Q?wa1Icl6OGs0IF3KQ3sNNLvASuLAFsmy56UefXug6Ciy0TsPbqXMAsMiTt/b5?=
 =?us-ascii?Q?pON35nrjaCyz9j9epVIDnDTmzcf1SNki43Jr1r0cfz11Epk8gxomM6kOcxci?=
 =?us-ascii?Q?TRF9Ak9VPoP0XEqDso7DzbHky7L54h6VD5klo0FeiVfuHRWv7dkk/KnlRCzo?=
 =?us-ascii?Q?1cwDh7zaAXUmhQxuodelIIkDsshCL20TS8rkJ/EHACX7xnRQ6N30ZPOdjstZ?=
 =?us-ascii?Q?mNGsRUflHio7SHFSt0CCGgT23OewEYLh+mBMM7wb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc9a236-0311-4107-ad6b-08dad175f000
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 19:22:49.4301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vRsFvLJyksYdHoRV9mqiBZahvNh04Wpctp7+BdJQrtEKH93Rp4k5wypk1M/W23PlrXSXkgZ1b9leac4itPUmwG70Orkecb36GnvEFKXEbGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7888
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, November 28, 2022 11:00 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org; Jiri Pirko
> <jiri@nvidia.com>
> Subject: Re: [PATCH net-next v2 5/9] devlink: refactor region_read_snapsh=
ot_fill
> to use a callback function
>=20
> On Mon, 28 Nov 2022 18:27:42 +0000 Keller, Jacob E wrote:
> > > Hmm, I tried to figure out how to do this without extra alloc and
> > > memcpy, didn't find any nice solution :/
> >
> > I also came up blank as well :( I can take another look when sending v3=
 with the
> other fixups.
>=20
> You can certainly rearrange things to nla_reserve() the space in the
> message and pass to the driver a pointer to a buffer already in the
> skb. But I don't think it's worth the code complexity.

Fair enough. I'll leave that as-is for v3.

Thanks,
Jake
