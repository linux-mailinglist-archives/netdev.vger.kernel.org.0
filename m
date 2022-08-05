Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6258B084
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbiHETux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiHETuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:50:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECC61017
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 12:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659729051; x=1691265051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eisjkQQifxN9sqgkF4a477yQN1YBYblTMVUA6vGTTvU=;
  b=ZgAAC9GjQJpZY5QVklXCy7304FUx0vUcXDoc7nQSC73xfYoZ5rakF9c2
   Q2mBpwUrsqTg7eYILZdpMYHcSqykI7495Dv+6zqo4ZQ0P5EOLqRBTuBD7
   40fFNU5U/NqHNsiNWG6Aae6+QzeWtTGOjv7Q0r1Ks/XYNjPZVb1fXyR7x
   BnWZp9yisy+pa0rIUlNRUGZKD2F0UMmOdHtFV6YpDi15vUFJa3FxJycH3
   Px7cIfJfBj5e0dwC0NMltWIhSiiWDKaVZN58zsUYp7+9RWCPSX8hDIxSF
   jgpqLdM4ZR5H4jbPCnC65aR3t29KJ8NnkK9185e0hiLXZiiLmZKCghUCk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="290285298"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="290285298"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 12:50:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="671802982"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2022 12:50:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 12:50:42 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 12:50:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 12:50:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 12:50:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdLrcbvaR1SY7C0LfC/SJNu7AWnNkhk2+/1EwMmeZU9dp/LXO0dvHav2UQFGv1DlhVdexVJa4RRNzKB3+X3Zy6TU+GYGM/y4zepUQcvk7ijSr8qq26/LvHa05Og0Kt6UsrcpXx5qJeaGaoicxxi+koiISAY9CzpMsbqJf5uTeg4kD/s8XyLM+HrueZHiy+gKcDLqbCUVyLMAg4TJW/+F2s7vc/1zDl7th30HHdTNJs/oyC4e6UvSBDSZKA29dOyQ8u5RQSvorU39esRD0Y1+/WJ9BH4jaoAh08SYuU0TOKHam++LDD/byDC1RmMcYT4Qa7folWVGBxe/4e0mLLMFgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eisjkQQifxN9sqgkF4a477yQN1YBYblTMVUA6vGTTvU=;
 b=XbvaFCl8Jj/yGMNyAsDoBoFGLGukgVFf5S/vwlZjw/Mv1Z494nIxCx8iLT4TNvpSbMG9SKQTJt6MEnvQxCw+XqSbp53217hkBMiMIA6bEeC68DxHWOVD/3RVmFSrkBIdPt8fk8kr3V8IZsVSBIV5uHBhXHZ0DGip5uAGX5k7/lL/urTurNWLXyvBrdL6NN1T6iWso/LmxOGN0ZiBSOf4CaybrMve6KR2mKFssGTd28spuqayjIyFyOfN0DRVQEBHGfp66hxZm7575SF+RBuciL1nPlYCqdUNCti0dHKnMIeoAca8NkeGuXoT4bBLqPKUmCqeoIFbLH7DsI6gBPRfxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB6349.namprd11.prod.outlook.com (2603:10b6:8:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 19:50:38 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 19:50:37 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAIMAIAAACQQgABOTYCAELdroIAAJ2QAgAAPn7A=
Date:   Fri, 5 Aug 2022 19:50:37 +0000
Message-ID: <CO1PR11MB5089E7D6909CB026776934D3D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725181331.2603bd26@kernel.org>
        <CO1PR11MB508953EAEE7A719D2F9BF9F5D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220805115108.16149c01@kernel.org>
In-Reply-To: <20220805115108.16149c01@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 780b1d6e-2e07-4e23-cf5d-08da771bc4fb
x-ms-traffictypediagnostic: DS0PR11MB6349:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ad4zydZYNq98C3CE1Mg/hUnZqfIsRDYYosHD6CIrnehNByGIjOM8fkLpc0GyHlEbZ/KBHxEiEi6Q2oATHdFwmJVcN14GhFbAwBI9xnIbfox3+O6PhlmUzKVp/i7njNfF7wcaowirb3SqwqVNGlU03ctxlgoSPoUMc17nyqcmNjQRAorb6EmGqlnIfhcPLa0+pmEQKAJKnwCHs3GTj42iJXQU9nku2dmyPikWFvpanYScJcmrir9T2A3vtBsrUpqLEb9rvFalLR59srrWc37hR3ASso/4ZwnU2Gw2bPK9VoQHU1uqGzqDX0Q2kgkdkKbLwuJC0NbDrAtHA0383DWIGwUbjnRYUpijykSAaATH/n91K3AiwtnR1odHWerSRL/gVJs2Kc24tWWK3c0Ow12QXUPAv8l12qnTtr6EUXrunhHgbqSMNWcnp2OcQMJ4Eq3K6o/w0JKOemjrwuXjFug1vAM7kevGhjT8APe6ry1ebifuJ6A2jRZ6GridQw69t0Imsp2nKPI2yop3wB+SenBwYNGpFfzrHi7ghuaHh8SoGSdPA/Q0NXSeVnww8DFraFRy5XmUFkA4cH9gd5NJYSm8X3VlDSV4rN0UFcmXEEZme9hml5XceQbZHdBJQpYzsTT58heVOFapJtbiRyrr49UfXGJ2Xcgha/OJSrIUIzSKlZZqGDoyT8wKhM4YI4N+D0OKhD+y2kjdB1YzyBCshPCKBUotA76QDNl4vLI81P5Fmbv8asN8nJvUBtPKPkkVRH/UwcEUJR/Gtnp8wWtYGGs6lCiOjc8PoqvPojZj1QjZxLvElIeqqidgCVwCZr0qBtsBY1cg965C7YwyM75EhtRPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(376002)(136003)(366004)(41300700001)(38100700002)(2906002)(316002)(5660300002)(33656002)(4326008)(66476007)(55016003)(66446008)(66556008)(76116006)(8676002)(186003)(66946007)(15650500001)(83380400001)(26005)(38070700005)(64756008)(9686003)(54906003)(966005)(86362001)(478600001)(82960400001)(122000001)(71200400001)(6916009)(52536014)(53546011)(6506007)(7696005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mrRCPc8B+UM28XaNXQ2V62JAgXPmrehXISD4unbvaQjk5pd4UlCZF/OiogE8?=
 =?us-ascii?Q?Fkdownp4DCvtAhkOkxIgpZQ+EQbBjsCvb13M3/u6q1jkaSMtHsBzMOboE1MR?=
 =?us-ascii?Q?UZBKrVeZumI40IvbuipKxqJMtltQC0HY1XfqYFizUah0Zv0LPCYuj9BS0v+w?=
 =?us-ascii?Q?h9Ve35DlY14ciQh5nLxGerkmTMs5UANgQ2zqHHj9V0veWoy1fafZ6VkNNAfa?=
 =?us-ascii?Q?IoVIIDJ2ZxCcv89q1PbrmAAHgiHmmeLvz7OfZqDm5X5Kcny4qjlgGvdahHnO?=
 =?us-ascii?Q?kl6OdG27uBFISITYXyIhX+WGzJa9AyHFYBzkkjgSgqZ5wnPbunSX7Ab8EIqR?=
 =?us-ascii?Q?Zjq2TZwr1Jhg7YQwbJTTnfWjQdex9k8/Q5Y7PUPnu/hrLGHvWuKioBQGqFWz?=
 =?us-ascii?Q?yy3pfoXxEda+3LkR2gz5IQ0ZVF0N0dmtoowk1aCoY2Z9X1Jc73J3elN/M17B?=
 =?us-ascii?Q?JQ1ZehTzPkRBST7/TA3srlHgSKv9pcLVOUzK+QQNdqymF+kvAzSmcZKAFc6d?=
 =?us-ascii?Q?ZVbwU1iVbiofbOC+RZcN2lTUs1LRgevy+SobKJNv3NZIYyKXhS7xnYhSuxJo?=
 =?us-ascii?Q?qVz9RF0LSCpjgT+HlIfcF2iR/oms1DJKMd9IWSRbI7qn/X9+x9KeiZ5PAsqu?=
 =?us-ascii?Q?ryQv7TkdrH2Yy1WgUbzL/8CTREGEssniXW0/nrsgDzzrOur2ae7k5wqdrSw9?=
 =?us-ascii?Q?yb1kkBI/KhvnWYQNpdvKIC3/SxsChvyaJfed5Vs9KuQdDImC5t3UUP1BLzGG?=
 =?us-ascii?Q?3U1cfrDnjGe8R60+2+3P1/1ec5KskBQ4TLkpSwFdgbTPf7ZV5mn1HXzaWYxv?=
 =?us-ascii?Q?nLqTQAd9X/04K0YQnOj7gsjn6bsmnh5bTE1tdkRzemRvYjr/ODBuf1ZytPy4?=
 =?us-ascii?Q?AdYt84XR01uGemNSgTDrSDZeVfgKEmFfnx7uNuK6HSqPmj3YZp2O2ARKc/gb?=
 =?us-ascii?Q?T71wTIiYmhs57m8A+qb12673z8WZGH/rwVdSBQ1kmnsv2QbhOBbpLQlY7bhZ?=
 =?us-ascii?Q?f4ob3ZI6if+/fMVE9o9/I+NVAv8XqyjqcLEZg+Y6bCRUEV1LyQu8YOkjX1rS?=
 =?us-ascii?Q?u2pQuVIH5Bt2IZqVwkEqMRZIo5vMBzG3LOjWFxNqNG1stKXVMW9twUj8iDJe?=
 =?us-ascii?Q?cDYxEWvCFEv4J1vX/QgojbFJ90a16gN7jMYMRw8ZsmRZcqz2ox1+jgxPtI+e?=
 =?us-ascii?Q?gNiA7QSb50hfEzAy2Kd8t4lnyYVRDVSYFVY/MXGPFfI1F2UuFEQfd/HqdFlS?=
 =?us-ascii?Q?d8Dc9rmq0z3IBvSAzLz2gmM1QBeTSlk1xIkJ6Uyh7/mOB96QOkTgVyFKwTqy?=
 =?us-ascii?Q?ersca813Y//oA3pjh5jxmpjcIzmFB52Sy3YfNOIfMfuRnz2zPgUvUqbjomKH?=
 =?us-ascii?Q?ftu6Am4XXEHOnpFb23v9g6TyOwKJviDuBpPVrWo5f2f5EOZ7ZZc8XV2bo1YQ?=
 =?us-ascii?Q?xCfD01hN3+1iSEpKzQCIqUE5m8V1+CWWk/kFTj/YS3SH0vpZbsQZb2pU89Y7?=
 =?us-ascii?Q?NO8i5Qbkifv1knd2rWBPmN/9AxqmBQ59qMwP30SlSlcKlo3zZHE8UURQ3zt9?=
 =?us-ascii?Q?lAPDGY1prd9P0FubAV78vZBiLvEdBQNIpe3wTmnn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780b1d6e-2e07-4e23-cf5d-08da771bc4fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 19:50:37.8537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZRHLl7/jYXwkzM3GC9acbY1WsST0eGbMHWnvuQD+gJ7E+4nOC7vLo5qUIUNRE58x4OhZyesd6KhHgorZIE3FfgQQQym4p3842+kCH+ViDLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 05, 2022 11:51 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Fri, 5 Aug 2022 16:32:30 +0000 Keller, Jacob E wrote:
> > > Hm, yes. Don't invest too much effort into rendering per-cmd policies
> > > right now, tho. I've started working on putting the parsing policies
> > > in YAML last Friday. This way we can auto-gen the policy for the kern=
el
> > > and user space can auto-gen the parser/nl TLV writer. Long story shor=
t
> > > we can kill two birds with one stone if you hold off until I have the
> > > format ironed out. For now maybe just fork the policies into two -
> > > with and without dry run attr. We'll improve the granularity later
> > > when doing the YAML conversion.
> >
> > Any update on this?
> >
> > FWIW I started looking at iproute2 code to dump policy and check
> > whether a specific attribute is accepted by the kernel.
>=20
> Yes and no, I coded a little bit of it up, coincidentally I have a YAML
> policy for genetlink policy querying if that's helpful:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/tree/tools=
/net/ynl
> /samples/nlctrl.c?h=3Dgnl-gen-dpll
>=20

I'll take a look at this.

> I'll try to wrap up the YAML format by today / tomorrow and send an
> early RFC, but the codegen part (and everything else really) still
> requires much work.

I'd like to see it and provide some early review.

> Probably another month until I can post the first
> non-RFC with error checking, kernel policy generation, uAPI generation
> etc.

Ya, I figured this would take quite a lot of effort to get to completion.
