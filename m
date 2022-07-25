Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB2158058D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbiGYU1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiGYU1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:27:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202F6BC9B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658780827; x=1690316827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9vOfY9AklsbacVGVAbGPamIZmEA+Wcc6n9AoVm789xc=;
  b=jLlEveDKsjCq0W9hULDrIg875BPxxRkIIewtExhgnRGkve61855ARvwr
   psim8VRpOgWAhGLImas4ZW85EU0Q1ndtv4nSOpKvJLQfs9gELyKxqf+Is
   BXyUU31CEy4u8TuhJA6aKBBqV3VBY3n39vLWNHMWLxDC82lbdW8Yh+s8G
   wVrO40z6LdStyM36eXhDMVBGWQJd7V6SmPXUF7IrPNdmobvFfsocUuK8i
   D3uqW1MWa1VBltjGqQFAyMYIgs7gjoQI+NKzMbnuvYEgJ3mhMNohO88WC
   543DRFJTVz3arpLJI+4i7XbYPcIAY27wXkT6sISIm+s7Zts2NHP1BNZrB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="287802022"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="287802022"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:27:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="702629157"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jul 2022 13:27:06 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 13:27:06 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 13:27:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 13:27:06 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 13:27:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrFiR8RYpVRRTkczn9NWmssJuqDrEizqJx1UDd8FRc3DVIbiwPlq1QBtpvtDlc0GTlt9Gl+QSI1N8iTj+y99bsEefavwvHQmUeErcRfGaew0t3+sB4F9O7ZFIfefOON6M2mvLdDqGZoW3i3A8Nq4S+1VqKNgaxV3RKqoRW5EPlXkt+44mpncqzV0vD6jFIlbQLLWf+rAZ6SMsihICRxm1R7Y66CHA0wgIusyXl2GwatZoD9XzdDMYroRIaU9kdzJ9AFhLKcP3geKo/BaP7M1egYF7i1f/cNV0wuz6pwJjF4aCClajs8o4jzUfp1v9LamW+MSnH6SOo92wN9U0VrUsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vOfY9AklsbacVGVAbGPamIZmEA+Wcc6n9AoVm789xc=;
 b=UVUTIBsNeTd+67DHJtDGGaJLA7HsuRm72yN1wpJVebGm8C/wfwadzx/WNoPkGb3CBKmu8SAuKnYhgyA4MJfrhRUHEnzwnpnDZhRABNxBxbClJYoK/N1paQZCKkVfeQ5dJ2th8AS9onQtjmAPHSuo8yTWZfYJ9gVfy7NlhnsQyhkyKEhsU4y8/Dt3nmx9PagiTSMkcVryTjukELPNsWUV+Pfbbk682VpzTMLWA74snefK3uyQ5eTUinM3XqT5BFqMuvIySf+rOjAj4k/hsc+85gngDdlxi1GsbPfWl3eXZShZ1KIQDZ/+Hvbwv5rc5Ri69fnyMbxMkY6FUFm88Fqtdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by DM6PR11MB4473.namprd11.prod.outlook.com (2603:10b6:5:1de::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 20:27:02 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 20:27:02 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bA=
Date:   Mon, 25 Jul 2022 20:27:02 +0000
Message-ID: <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
 <20220725123917.78863f79@kernel.org>
In-Reply-To: <20220725123917.78863f79@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c4726de-3c40-4dd6-8ea0-08da6e7c08c2
x-ms-traffictypediagnostic: DM6PR11MB4473:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IXRAOn1LvqFf8dGREZy+Yy8WSMgE1ppHBohq3DtGYxiBJ33wcT/lJRVuMoqbE5ycDbfqwQeTJ4dxICpOl4a4E3wkdg1hd+CNHn7IgN0mCSl52nQ+Ffg/fkZy8QAsYHvmOlL3TH7yehPP/Ez9SmgK+afZb2W/ugOcH1exO48vTJPa3uhG3z9CDBXgK1C1jNedeu5l+JHIIpDMz5UfHgc33wn1Id7ZxVUbC7VdHYJlMF9fkoFbAuwyomev7SZVWrUykH7/81H6DvhoWLCoUIqsNjnRf4la0uQfJOeZThiepURsQRMQwqhPJj1es7Fe7GI6+U60L1NAY8OH/wvx/yFrlnxBeFB3BUeZOp7tPEu4QO/wj2k5oVmKfm4wHrCPqoGaFr/Uv5p42+N4RsSqfUx8aIAgYyHcTAhfPjPd/P9t+48LTo8xQL5Pciw130WydqdxAzj/X4FPYCHpss1EDOnIYH/WYPNzBIASsY1pPm7JVNQWPqSpXn/T6m6O6AoVYiQHjLsMHfreGykVFX2snnJpcI6224zUBItcG2mIfXyVEVhTVRSPfwqd2MPSzonrNWsAUCJxsXQ7JxwPJnejsAqDCMBTLykQ8acA5g8pqvCg/CtmBh52MtG7FTV2wBh+mGey3Fnam2/grnGZJXz1/ficCfPsxfY2m1FH2lQjrpkZhMvwj4agaHb7nstboN41A6SBhNI27m3mf/LNm2C6GDwPvYWAfdi6h87AyuAa3vi5Lm/C3A9a/HSKEdM9o7b6SaiXuaL7Ri4Tefg/duurOARzwk8VaIW9FuPXe2/hOwiiXE3lca6l8fFh2wor8bZRqtjM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(376002)(39860400002)(346002)(38070700005)(316002)(9686003)(82960400001)(38100700002)(5660300002)(54906003)(122000001)(8676002)(64756008)(26005)(4326008)(6916009)(66556008)(66446008)(41300700001)(76116006)(66476007)(86362001)(66946007)(71200400001)(7696005)(53546011)(33656002)(55016003)(15650500001)(6506007)(478600001)(52536014)(186003)(83380400001)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lw/60v1xNHyApHwnrvyi1oeE9mBrOli4Cz8nuM/SmoIUEyDAfkoJprHtaDzy?=
 =?us-ascii?Q?pMyYl1qIvcx8P5xsT6mpvWNZnkIQZuIQu5eX2ZZc9v7EPajqvjYX2ohco/2v?=
 =?us-ascii?Q?RefJlN12imwHvqMZiqnA8r87iDuhtUwMCdSykqGFB/6zKMdaFqgWV4G1ofOL?=
 =?us-ascii?Q?rGyMIUcciXFNMDAbiguYFNYaGMDP/5d34dJOWBSRPVcfeovue0i5gOS0jfE0?=
 =?us-ascii?Q?UWuRBueV92iLyehCTLJCpQ9S2YQ3p+ZeKAKKeitX+eNK9jHhuBoNN+8I0kEY?=
 =?us-ascii?Q?HJbBFWcy79xD3FsLZJEj15ozpPjtImfEE5GYvFsI6Y/h62c4DD4M8cJq1N5s?=
 =?us-ascii?Q?xlB4KWF4zpTNZrahbU53sA+LPz4UwARbK0g8SyBFaL0vYK9PEcfUyyUzNMiR?=
 =?us-ascii?Q?DJe97vDyHvMdqHjbgTaUKGHOGbXGS7rhRlrjJU/gkozoxbkL2UQ35FkEdaEn?=
 =?us-ascii?Q?7AhxyJqJox82mr7ftcGI7pQfTcHDtSh93627EZxS8dNKrkjw7931W2z1dCXH?=
 =?us-ascii?Q?SdC6nCn5XqP89G+KhnGSrfhGnp6jxTHWOymOztvrcRyyZ0JA4Ftg/0wDneh+?=
 =?us-ascii?Q?vvxUYA6lLu1ltH424qUFIS5asCicqoimQPr+mTLZ6XrV/G4YWwk+JIFmEaLA?=
 =?us-ascii?Q?293eyMmK1y1KoKrRrTODeR0g4DJXNpg967IvTdYtnxB1yORo4dC6tamZnm3N?=
 =?us-ascii?Q?+iow+gpLytUqUW5n2BrCcIi0b2poWkKVHFUxSk5MXxjSld42V1tzMKVb+2GP?=
 =?us-ascii?Q?HzaGKv3z5e5o0AVm6SN3M3I4enZhJUVAcJebntCnlUsJUGNcZriwuDfWlNbd?=
 =?us-ascii?Q?6bteWGlYOLA2IiRyUuwtIGyHL6eoTwoU3QzY457iEM5FoWpynLUnWChfTEcN?=
 =?us-ascii?Q?6sTHT6IEnPVudVheKMgoU9xWAYgl/51/z/wT/Gh+f0RNat7nOyyX/rNCduF/?=
 =?us-ascii?Q?6h0bvJ+2ckLhMWrDKyzzEuNXfGzprTMuLYGy3PeML+u/aSpPbH5N5W2P1+lK?=
 =?us-ascii?Q?rpqnb9Tecn+i6opfF7IiLetUHUBev9Pk/v8f269vfN9qAjezQKHgtZ3qp/zu?=
 =?us-ascii?Q?G7FAjyvwNelzdjH+l0YkIWHT7ihcMrCI27p8dRhGNUZUP0G3858mgE8z/PFB?=
 =?us-ascii?Q?0CxY0vxDExmuDQhuGzsOPwSq31X1X2/vbgl811ZwhdHx5NEvy7p1ZKefZ93p?=
 =?us-ascii?Q?jFsnBkqZ07f2lWAgYmvObVPzcaRBYm4DgcUzhe39/rIjPHG7+rjCyDx4eWKZ?=
 =?us-ascii?Q?EZj5yLI415QxQTQpijGNTuLiFFS5rUQSoSgrkGh7llzwh7H5pXeJCcpt1+kS?=
 =?us-ascii?Q?LJY7uZomoR8AIVsshlNZO+YlZMBcztmhJ17pCS2SNR5L36jKq0exEvQpCA5h?=
 =?us-ascii?Q?Ru5B+3CqgQ2BVKZG4z3the9PUJzkZNTj8miQze2ISeq6m4DZC6NjjQ4vR0qN?=
 =?us-ascii?Q?V856+yNKiI/vz58QtWuL1mi54V/NOS2MY2jT1fj0wQhqeI7g09ojCj6UcObM?=
 =?us-ascii?Q?uwxTIVmXNUyw00qgCt0J/aJBE6okv/XqVOV7Ta9OluGDCdB4eIg2sB31w9J+?=
 =?us-ascii?Q?e7ZoWyMcET65i2GUBx2FYXmpH+4WmIZCfHQJV1O9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4726de-3c40-4dd6-8ea0-08da6e7c08c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 20:27:02.8158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: olE+2DvovWx/UmZDA+HuHpZqjczL3cFh4EamGlc/lGI9R1unnwncpGDMSgdxaDRuFnRT9ilO+ORF7cigVLS0avIo32KbeyC4WJ+Vut+ghSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 25, 2022 12:39 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Mon, 25 Jul 2022 19:15:10 +0000 Keller, Jacob E wrote:
> > I'm not sure exactly what the process would be here. Maybe something
> > like:
> >
> > 1. identify all of the commands which aren't yet strict
> > 2. introduce new command IDs for these commands with something like
> > _STRICT as a suffix? (or something shorter like _2?) 3. make all of
> > those commands strict validation..
> >
> > but now that I think about that, i am not sure it would work. We use
> > the same attribute list for all devlink commands. This means that
> > strict validation would only check that its passed existing/known
> > attributes? But that doesn't necessarily mean the kernel will process
> > that particular attribute for a given command does it?
> >
> > Like, once we introduce DEVLINK_ATTR_DRY_RUN support for flash, if we
> > then want to introduce it later to something like port splitting.. it
> > would be a valid attribute to send from kernels which support flash
> > but would still be ignored on kernels that don't yet support it for
> > port splitting?
> >
> > Wouldn't we want each individual command to have its own validation
> > of what attributes are valid?
> >
> > I do think its probably a good idea to migrate to strict mode, but I
> > am not sure it solves the problem of dry run. Thoughts? Am I missing
> > something obvious?
> >
> > Would we instead have to convert from genl_small_ops to genl_ops and
> > introduce a policy for each command? I think that sounds like the
> > proper approach here....
>=20
> ...or repost without the comment and move on. IDK if Jiri would like
> to see the general problem of attr rejection solved right now but IMHO
> it's perfectly fine to just make the user space DTRT.

Its probably worth fixing policy, but would like to come up with a proper p=
ath that doesn't break compatibility and that will require discussion to fi=
gure out what approach works.

I'll remove the comment though since this problem affects all attributes.

Thanks,
Jake
