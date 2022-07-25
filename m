Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7045805E3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiGYUqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGYUqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:46:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C966165CF
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658781964; x=1690317964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=33hQJQqe+sJK2mM+IsO2nYhvUen3O9ZN6RagIisqqQA=;
  b=VvbIScQVQXjB8Kd/PAdD4jQKZ2xtaCOVOy16pjup75oWjG1NFxD/7DHT
   cyguJt+b1GN63IbMrMwNtWe2y895aPEuvsgnuI5sw9rjq+ArNLkLzep9P
   IOHNfOF4ZUSwLdGC9u+ALu6L1yxY1MnrC7QMtmYnz6ioPyA1ia5nES2+z
   4x5mQ9cBQ0xZyDNWlaj3SQe2wGOfuUieVkJOmQT/FshvCWGPUiWv9j0U9
   6Uig59+zTRvLv2ddBJ/+AofewWpJjyZOiVEZajIEYUrpgSIhml7YZbOiJ
   QaP03s6MD/gW8R/VhB7h8R4i94zgBctBeIlxmlS7GgWbU6yMVI4ZGYSFg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="349492744"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="349492744"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:46:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="627609828"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 25 Jul 2022 13:46:04 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 13:46:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 13:46:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 25 Jul 2022 13:46:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XleI2xecPzm+J2yIBm6Scp52a6VNvt422x92csrzyJQe8nYppUQQ6Dir3U/TRjtLloCYB2Rkq5itVEMkG0NceZY67PIDx5luk5ykf4R8sUl3pTp9PR4gfK7strc1T5Kcqoal3eTbX0btSOSKyHUZIhDJZqjSVes9ouDerkvw0ztUugONOLu9a585kFPJ7nlysXkbMl4eoWwjze6NAoxuPDHPqVGiNjpgyaKO+p0S7lygVBLmMHeQ0CEPWCPfSZHrle6lUvGn7vN6OP8LZcjOwPwjU5uR36EpA8HZW9VQMbS+hkzlFB8LO2E8ug0co60tsFVotaDkM2JsWitStGLMxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7XgROPOjLM0mL7Aziw8Ukto1hNEWASr0KCLULgk9wY=;
 b=kMUqeQpk8xfxpx7KfInj0DdIaxMbVS6Jiky0/1XXB3APwLgVvAOMyUbqO0sLAoqIA+NHppK1/C0D66QkYqrkVYk/TuE8MIbwkRjdg6JYirrTgfaXFjUKxPEtMDZ3ieUw1/PEDwn5n/TGf/Sxc2vvtRhxiU/YFIjIZd8BQDq9Z6y1ddtp6zywOyimgMmqLT7MB/M/84cnYVE872L6WVi6NRSmj1cLj8gswwnW3EVu9ZB+Xx71QxtAmAJl10RyLx49x+MkjHyNlWEexpotcx6Z0Sa845DytdqiSZrXjPsQJ0YhHDM6UftDRp3ctsYIHvbHkwiLS7MyEYkEM31oXXBtxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by DM6PR11MB2586.namprd11.prod.outlook.com (2603:10b6:5:c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Mon, 25 Jul
 2022 20:46:01 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 20:46:01 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAIMAIAAACQQ
Date:   Mon, 25 Jul 2022 20:46:01 +0000
Message-ID: <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
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
In-Reply-To: <20220725133246.251e51b9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6f6ab5d-2f9e-4f17-0482-08da6e7eaf94
x-ms-traffictypediagnostic: DM6PR11MB2586:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /7HwkzBbkHR2s4vgBtSjhhXIX/c001b9+35mHfHEv4FYnTTUzlJ0UKK+xckX+sx2X5L7YFrcd06HBad6Ws7pwKZ2OnRPVATsjtXNwL0QnJzEhltmR8v2DnxmyiZpwfyXoWMp7W/bXrc7tFex0ZMH7GDPfLYaZFgV77sbVs0P6/Iox8bO75PZerLHpojDszvt/BemtqB7p3LdSWN+30fC5BNjEs2daSF5BGquMHCFwmU0SER5UrU6pNJLJsUQt5sY/KnVuRTMpFsnxJPcZLU+ovnoc24BvXFbeX74EiZ0oqk+5O/mIO9kIgQljst9/lsWatqMzd1McsZy2AjtvWZK8UuZ9mckqX/g+aOrbr2wV9mG0SLKcBG9Zz+bvONEMs4JB3A+WP4amHM/S+y7+38RE9rU6+LkCM+REG08fA293bRogR7iQnsa6SK4iE4rwWspOxed3YVShIX6DeixFD705VyWveD/2TbUCYdz04pB2RWCPbL2RslaJBBumU7ro0GZyJGNnC0At4D2XX3PhsE4XiQ9p8AAFXq7dT32V2gqIacXUbFMYZWAf2MfCFXczqaQVHRAa8zthMlxDeEf0qoRTB8u0KZqxY7ugBQFYl1CWbhQNS1CPpepXJfXbY4CjhDzKstNulIfmMc6xT03Nv1Pex5ExdKrIHBWcRti5DKDWtjrF4vxulDHx317ZL3v+PXyhBSvCqqRnsvO5tAYybUdF4gDFWWJrbHDLukHLmrTjdPyt18ZRtwtD/LV4V5pTK51RnFtCne24Ylcqwma8XArovA+QyyX1w8Gf/HSwlIL6VJG50sclzfuL7UEuqYGokgk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(376002)(396003)(136003)(346002)(6916009)(83380400001)(54906003)(316002)(9686003)(7696005)(53546011)(55016003)(6506007)(33656002)(478600001)(41300700001)(26005)(86362001)(186003)(52536014)(8936002)(2906002)(5660300002)(4326008)(38070700005)(82960400001)(15650500001)(71200400001)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(8676002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XTthsfTY3yrCMdh1DSvhp8oQkg0gMaR9Cr3JJoQ4A5r8nOFJVY/8qozqFuV5?=
 =?us-ascii?Q?5/NMAUE0lZs2ujTQ6lCDM2aE7Uoretayij1dvQ+k6Tg3ShyH+DwryLmUOB2Z?=
 =?us-ascii?Q?hyIiK67FRm6LF5/74sKz4w+sfRocA9HmOudzHfBJqiXFR0eHNWXRz2Zakftc?=
 =?us-ascii?Q?P0fG29OYo4yb3QlKRp30PP1UvxftbRzVVUYjyY0taHiy8AsyNqE4Kq/80lm8?=
 =?us-ascii?Q?BlRd7/yAnbz97t4mjXQvDs2LROZ5bsAv1tBLobwOVeeBnh7DZxWdY+3ZZwa/?=
 =?us-ascii?Q?Ia3n8CMWkrim041HkL/DlQa23bDdi6tE0FRjycjw4l1KrHWUakBZq04KA18l?=
 =?us-ascii?Q?3gsDdo9+FlMQdVQmPtKyH1BKVEHjmHN10+CCW84Do8j21V/IfrSn1r9PNwiw?=
 =?us-ascii?Q?eFBA2H+7W2H5PqbhRk4qmhdZiiJpSnNff6B+vacRGMGdGJbjqnD6YjanTK62?=
 =?us-ascii?Q?Qb46eRt5LqyREuTjhNuSrEwT4nCqa411kp7c4gHxxUFLDXoC+Fk1wQ8hp8rw?=
 =?us-ascii?Q?xjL7Cv5zZr019jVUtqrJhNclPfA7lSfvkUeXKEHafzg9HG3IRA4uc/b3RijF?=
 =?us-ascii?Q?PdsYyKcGCBZlTGK1mZqTgxtkrObAxg9McPsph15o2nFc7YgbAVR+rptFGfjs?=
 =?us-ascii?Q?XS0B5qd2dOIDl6RTTaT4NTdmMBPqycDc9Z93ftsps4jtROOSwKcoIViRcWXf?=
 =?us-ascii?Q?Outn3zi/x72hUSLA2f4gnFZfvfwBgpRRPcQ0x2iriV7deZgXd9Bb9rkbiaUR?=
 =?us-ascii?Q?a4lb2oXGhHLndcxWlV0KOZwDNCkNkY3g0ELFRNVHI08MCpMawcyQtzKcmZqU?=
 =?us-ascii?Q?X+lNshp+TitU0jSWSYiRp/n0AmOFMAHM7GrmXPksIxZ6uCBANBodzCXMV8Ud?=
 =?us-ascii?Q?b4nK0r/B2A0l2PMIqDq5a7IQ5W8+BOUcCN576FhI77xayBb63J07HaS6zmB4?=
 =?us-ascii?Q?mCAVdWQcYi7JfC1vZr5OMwWSjCruSnCrGh7nJ2Ss4XmU4eoLEDD5XPL1Vlu1?=
 =?us-ascii?Q?Sbi6+wlXSPLOddmGRCAbUjtcsI9B0dWix7rlUGsHTJgK3pJ2btTqDUaO2Psg?=
 =?us-ascii?Q?vmMmvkoq0aiGOXZ49q23IYbMhedSYdtgr0touC+Z8+XmKC89wcIZ/i/4Ht82?=
 =?us-ascii?Q?DLemI9osbyq/MOpRfZNBYS9auKFKDw29impy1HbgVP7jenrI++0u3ctj/Meb?=
 =?us-ascii?Q?HAmoyTQUyNTy+PoFqjPKU50yiQC3HhnOpmyEkgwoOUd9wnx08lWggIq6lBlz?=
 =?us-ascii?Q?/dYjARhlDXZizdUOiN5RGQwxlbO10CrsL77MOgWNZ8/dd58z7FLVRSfPCtg2?=
 =?us-ascii?Q?IdJNmL/ObkoNjec7+/qsvco9phyS3+7RZkF0Ht/FL9dKth8BpG1Qc2/a1xfC?=
 =?us-ascii?Q?QDnfR14ucHDJVp9sexGPdt4EoHNibZG653iw/Jl+ufSVl9zoZaIqfiabFocx?=
 =?us-ascii?Q?QZ+KWVubq7/4Tx70nrDHyDZ++YcacyabFFanJW7JTMnFpgRUB2j22I7lVfVm?=
 =?us-ascii?Q?3iQvAD3/lOtoA5XK55e4d2sxitDOKXgXsprPlFqM+Rsj9bf/r+Aos1JOK33V?=
 =?us-ascii?Q?ndz7lpE2fD4kBAnV6FnjyZfSNlkOZaiMa7MA6/Ko?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f6ab5d-2f9e-4f17-0482-08da6e7eaf94
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 20:46:01.6525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 50Hh+pjR94kOCFCn9z83fu+08At4cUTQYlebKmLpRCMTcWGVkmXB+PPzLcGnJL3uCQgrhJbrhUT3pVypR+AHR//Vz/NJv0pb75/Mtbdr1/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2586
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 25, 2022 1:33 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Mon, 25 Jul 2022 20:27:02 +0000 Keller, Jacob E wrote:
> > > ...or repost without the comment and move on. IDK if Jiri would like
> > > to see the general problem of attr rejection solved right now but IMH=
O
> > > it's perfectly fine to just make the user space DTRT.
> >
> > Its probably worth fixing policy, but would like to come up with a
> > proper path that doesn't break compatibility and that will require
> > discussion to figure out what approach works.
>=20
> The problem does not exist for new commands, right? Because we don't
> set GENL_DONT_VALIDATE_STRICT for new additions. For that reason I
> don't think we are in the "sooner we fix the better" situation.

There are two problems, and only one of them is solved by strict validation=
 right now:

1) Does the kernel know this attribute?

This is the question of whether the kernel is new enough to have the attrib=
ute, i.e. does the DEVLINK_ATTR_DRY_RUN even exist in the kernel's uapi yet=
.

This is straight forward, and usually good enough for most attributes. This=
 is what is solved by not setting GENL_DONT_VALIDATE_STRICT.

However, consider what happens once we add  DEVLINK_ATTR_DRY_RUN and suppor=
t it in flash update, in version X. This leads us to the next problem.

2) does the *command* recognize and support DEVLINK_ATTR_DRY_RUN

Since the kernel in this example already supports DEVLINK_ATTR_DRY_RUN, it =
will be recognized and the current setup the policy for attributes is the s=
ame for every command. Thus the kernel will accept DEVLINK_ATTR_DRY_RUN for=
 any command, strict or not.

But if the command itself doesn't honor DEVLINK_ATTR_DRY_RUN, it will once =
again be silently ignored.

We currently use the same policy and the same attribute list for every comm=
and, so we already silently ignore unexpected attributes, even in strict va=
lidation, at least as far as I can tell when analyzing the code. You could =
try to send an attribute for the wrong command. Obviously existing iproute2=
 user space doesn't' do this.. but nothing stops it.

For some attributes, its not a problem. I.e. all flash update attributes ar=
e only used for DEVLINK_CMD_FLASH_UPDATE, and passing them to another comma=
nd is meaningless and will likely stay meaningless forever. Obviously I thi=
nk we would prefer if the kernel rejected the input anyways, but its at lea=
st not that surprising and a smaller problem.

But for something generic like DRY_RUN, this is problematic because we migh=
t want to add support for dry run in the future for other commands. I didn'=
t really analyze every existing command today to see which ones make sense.=
 We could minimize this problem for now by checking DRY_RUN for every comma=
nd that might want to support it in the future...
