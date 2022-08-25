Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FCD5A1ACA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiHYVEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiHYVEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:04:51 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09FC167C0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661461489; x=1692997489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GAHCrO5MtLLKoS9J5WKUt3W7tLgzYwVHyvYnslXaVQM=;
  b=SkIV7qklQsyTB3Zt2gE4nkYcikqNf0eG7YQkt9nJDrFinzZlH5unKldf
   NNxBmdJLfkfe5LoSGLL/9bKzHHNRNrJ2utRxC+DIdRCLGcC3VSQAQOrCf
   ifcalHmMwOJsqdnRTeWPw2jOImcflue3mlMzaU3+DYjILU8eG38hJVpUn
   YtzEf6V122rBqsnz55dMmACTXH4rphsX4xjUlheDVCEBFqi4eA0+5Rkx+
   4UGRS5InLqgCjRca8bHZY6U67zbSkZYW3YsiXMST2GzjjxasAFtKIBYpu
   S7FvT/5cQbMiLIojipIOxYJ/L7mkYpmo1QIyp5QKaUFt5c/9UKeaogwL3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="291936717"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="291936717"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 14:04:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="606542500"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2022 14:04:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 14:04:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 14:04:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 14:04:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx6lCtrEQPjzojzeDgO+9ip4IV8NiNagbbClAZ4E4Rl/4ZKyscuuGtWJZBg+7JXOrTKvNaHQc5s839Wh0IXr4RuE7ue8otLZvWB5PW+KTXII6ZHq//JYoQaY5dPEVnSihHXv6JPFBDN380SYSCA3F5I6wU/T3zmzVmMLoWaTnAYuSaZClEzU3syViD9ZuO5ZZbv2m2G3jGafTlvb9OtSKtpa1w0BD7oreHhAS3EuRSOOKTwLgOV9sajju6nxZTjW5dZcGAz3WwBFE0n0n13nOCG+C2SAX9lKlg5WhM5VcOLvAuKS+7BwTxjHTbwlCsMz8lFaBfEaezec4gQwk5wHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAHCrO5MtLLKoS9J5WKUt3W7tLgzYwVHyvYnslXaVQM=;
 b=mr/AdyZ9g2dT04F0AARvQmoGvRKvzEezo7EVF2wJDUCIuKtebrqSxzRD4ENLr/d0yNVTsBQA6rQw2LQ7GSK6YGj5xh/eBrEdOKiJKuuqcs/jbtv/SznI7lObb0EiPMOZNWiSZCLppQzYhkX5j++EiOLTaHQzmMAQT9brSm2mDhqftq5Est/FyGMpTe0LEGnz8mVFKNuvOS6tw5KC+DzogECaBsgjITBUnIhSl1Vot4U7NT98esO5rSFQEbQEnQCD6AnwjYgMYqtxoDTc3XMdBlS7ZdJjcrDCoNDkplK6ZGPsKphOH+2tvhyHxd61updrmtEIOgcY3L5+adD1C7s2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 21:04:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 21:04:39 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9CAAOPjgIAAnPyAgAAHflCAAAlpgIAAAyXwgAAwQYCAAAa1MA==
Date:   Thu, 25 Aug 2022 21:04:39 +0000
Message-ID: <CO1PR11MB5089F11D12E8DC1500457095D6729@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825103027.53fed750@kernel.org>
        <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
In-Reply-To: <20220825133425.7bfb34e9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3253640d-1011-4638-f0de-08da86dd6cd6
x-ms-traffictypediagnostic: PH0PR11MB5658:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJWqpUokKsoAYCkt9+QDAuXZF5CAi6nF6Coj2ss/ErA47BvZFqeSsqDRqwbJmO566ShzF0vq3NKAZa3XGskbZcdkuQzzwQP/0d5aDBFUvln7ajNTJr13DVI3EFpLO4ozh5+p0Fx/3ersydPAVQ9Mn45IWNRn5viM2uBXTbrLbNaC61+7mnMHSYlZXrIxn0u/brQYsnAmA8+twkUVAbWUusWiY//NDjbw/7LThPLK8FWyTb+ao8Nn/OoNtqFK3Ric7nR/w7maQuvddotD8BszWd3yuAWdo+nSVhJtLKggqavNMv6OL+bfFIoMuE3SXUyNa9e6imIKIQiIIJgiaNZWDUFJtcYtcFHQbX/avDrE5kP5lkS6iLuNY7cfikTfwBYBJ++iQcltK2P3DVNyrukbmChVpsh43aD+fwbJTp7A6U1DBHJ9Qq431/xNwRvHDUsFriB9cz+Y/afu61e34zUVd0cSsX6dkZFZwRjxDTkyOEsS3zgjANVe8iQT9kvMF0WRygwS1ZMNxA3RSPYVrSWTkQuleYgMEhNm9jHIQ+hl2Ykj9b/xS9M4X/JjCJJficmrrDQ9f9bvZLrzQK4E7KhgfxjA3t+k3Zq4enQN11C3H7F4/1Rd/7R0ZD0OT8y2HCJboX+8DErtDGztgRxOnjpHwsG6ceyyZdiJogE7vuzCI1ixRmgaRI9/GioEvS+upkcbjYMSkIj1gyGOvR2lDEuibi/l+7jWKZeuFZBfUSnm6FoUfNmui+mSnGbwklGjI/KORCi2JnpiaTnCHsPnskIouw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(366004)(396003)(346002)(7696005)(41300700001)(5660300002)(6506007)(66556008)(66946007)(4326008)(8676002)(76116006)(64756008)(66446008)(33656002)(478600001)(8936002)(53546011)(52536014)(66476007)(86362001)(55016003)(122000001)(186003)(83380400001)(9686003)(38070700005)(26005)(82960400001)(2906002)(38100700002)(54906003)(6916009)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7+Qf6JKKOBTSsCVvkSXksJOoHF8mGEO4KeiM/TofsnGyKgR2fPExCiuKHert?=
 =?us-ascii?Q?GUB1NR34mOpskD93FapD/doc8MczoNRlVD+fF5L7W38CV5/JpciWbeH5XSKQ?=
 =?us-ascii?Q?LkNl5rJqkvAbSe0BPMnO/KmigxzFTPHyzEZyC3r2XSm4DXhLLuRDx4foFREZ?=
 =?us-ascii?Q?X4X0/eQ4qMrn042cEJWMGbAKmEuVurDrHwhgWWgAtGb4FUJ0SWKZkf9IgjyP?=
 =?us-ascii?Q?uet3iNtg6DhrV30Q9sfHsGOuUVuAdNEREk5edHb16tgYrAWD6Ppv/v7oeZ0g?=
 =?us-ascii?Q?Vv+wFvIuFJNITftnkRNo9SB9EKrV2axlwzAghepXPgSqdxuO7saIxXOgW7/6?=
 =?us-ascii?Q?txMD8HDel88lt/H70ZOU1Hne9ChUAJ+N+9SlUu0Gg34kB+FGxTq5Mtmhe0XU?=
 =?us-ascii?Q?+Ijm99D1sr68YhPZO8bbpIW9QGx7Jl1Cvz+e5U5TXWCA44XJARp/rvD3WZAe?=
 =?us-ascii?Q?kP2xTghd34a0iO4YJxcmdpkNk8eU50o9EoWwN1K1+pjCJh98ICIyjSrAi3ad?=
 =?us-ascii?Q?FD0aThbUULTGa6en9pKTKKh5YrZ1kUUJzIgJajSgiEoDQKsorlb47rYFofBq?=
 =?us-ascii?Q?r3uehJ87je/2YRA2ieScwNlQEJ9OSGaQ4HFZ5CmhKxgSEigHwmVS5nicwPZs?=
 =?us-ascii?Q?JLQmAYO+uWVKG94sIb4aXg+Cx1CE30AUVlNXaT9nmPYCPWKchSQQwuY61x1J?=
 =?us-ascii?Q?WCVtt8t7RWe8AIHBml7UuSQ6l17vOZJv+OpXSl16upeuC3vMBwk/yrSBc3xb?=
 =?us-ascii?Q?4JvOcqDvZQjy8FSwpZwyrb72OscrKbAKjH02YV+ps8QOflDWE1xRJYO6gXk6?=
 =?us-ascii?Q?IANum+hxgbIZJTxv6QM7fGkcxIoQWOzRYdLqh/7mIW8sv9L0UcQ++3P7lVzp?=
 =?us-ascii?Q?/b1BNKrMbrsCFK/+JKpx0aCJrVQh+FsbIoqaSubVt4YysktTMBpog47aW3nU?=
 =?us-ascii?Q?5b6KQ8Z6xJYFRKmZMTIDpjfHNVXzkHqSmDZQCVBoJVzrUd7kr3NPURWDh5Yf?=
 =?us-ascii?Q?HdkopzYwAok26mGzm/lC9CqUrrq5fKEkyVHVUNuei1TKJu1xT8c5kBYsxbh1?=
 =?us-ascii?Q?7mCyQF4LmDCeS4V7OCnlrPb8A1NbBZz/R0g3n5okF7QgJBQM+qEBWXF9XG9I?=
 =?us-ascii?Q?WXdwrXIsrpsDwvlG0wOvnrdUWZJfPqjluJq7sdYcimKAuzf7R8WyMCv43JkV?=
 =?us-ascii?Q?Q3CgsHn6hL+yL0R7EnQw0ULruhRO69R1MNYU76VONY15pFehM9wJ4eTETi2P?=
 =?us-ascii?Q?ccjsfgCsMnK8ssazXXa1l8BVRjTaJhhK6vTEQ70Q8Y0E/BCyaHmcq8s3YIsn?=
 =?us-ascii?Q?KJJOaDkq9XDvRwoM0GrphIWZ6p6J+ZLJQKcTCvqdUIpjuckqgzL0I4fCMLY7?=
 =?us-ascii?Q?SRJnZqAo+mFsgJG59EQpX1Rv7+VsHkeEmWKwZAge9ID1rNydqh5U/nN91xAW?=
 =?us-ascii?Q?CzuEbP72JlDdi2UI48LagIqbWhRFZ0fqvMMVV7PN5kT2w/1z5+dqhB+XpNXG?=
 =?us-ascii?Q?C6MAG68OXpFwKtYeEibQbjDxcJfAOvF7ftmIy3MxxWCKa7g9ZXL6wnJVrlUJ?=
 =?us-ascii?Q?8FQL3NT0UAPs1L+Yt4k7RvTyTTc2e9n0BZJHA0aH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3253640d-1011-4638-f0de-08da86dd6cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 21:04:39.7797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tw5QjxqS5YUBTjWSVNoRO0T8VwuHl17F9B2XCwgWCNBmFCi+CpIoqJXGyLbEo0BAZ8GV8LvLskFjKDEUglDuXzo/vzbiTD3v6TedVau/RsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5658
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 25, 2022 1:34 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Gal Pressman <gal@nvidia.com>; Saeed Mahameed <saeedm@nvidia.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
>=20
> On Thu, 25 Aug 2022 17:51:01 +0000 Keller, Jacob E wrote:
> > > Update your FW seems like a reasonable thing to ask customers to do.
> > > Are there cables already qualified for the old FW which would switch
> > > to No FEC under new rules?
> >
> > Not sure I follow what you're asking here.
>=20
> IIRC your NICs only work with qualified cables. I was asking if any of
> the qualified cables would actually negotiate to No FEC under new rules.
> Maybe such cables are very rare and there's no need to be super careful?
>=20

I am not sure if that would be related

> > > Can you share how your FW picks the mode exactly?
> >
> > I'm not entirely sure how it selects, other than it selects from the
> > table of supported modes. It uses some state machine to go through
> > options until a suitable link is made, but the details of how exactly
> > it does this I'm not quite sure.
>=20
> State machine? So you're trying different FEC modes or reading module
> data and picking one?
>=20

I believe it is trying different modes, but it is selecting from module dat=
a for what to try.

> Various NICs do either or both, but I believe AUTO means the former.
>=20
> > The old firmware never picks "No FEC" for some media types, because
> > the standard was that those types would always require FEC of some
> > kind (R or RS). However in practice the modules can work with no FEC
> > anyways, and according to customer reports enabling this has helped
> > with linking issues. That's the sum of my understanding thus far.
>=20
> Well, according to the IEEE standard there sure are cables which don't
> need FEC. Maybe your customers had problems linking up because switch
> had a different selection algo?
>=20

Right. I believe its because some combinations in their module data don't l=
ist No FEC, but still work with No FEC. The understanding I got from the fi=
rmware person I've asked was that the list of whats supported is recorded i=
n the module somehow.

> > I would prefer this option of just "auto means also possibly
> > disable", but I wasn't sure how other devices worked and we had some
> > concerns about the change in behavior. Going with this option would
> > significantly simplify things since I could bury the "set the auto
> > disable flag if necessary" into a lower level of the code and only
> > expose a single ICE_FEC_AUTO instead of ICE_FEC_AUTO_DIS...
> >
> > Thus, I'm happy to respin this, as the new behavior when supported by
> > firmware if we have some consensus there.
>=20
> Hard to get consensus if we still don't know what the FW does...
> But if there's no new uAPI, just always enabling OFF with AUTO
> then I guess I'd have nothing to complain about as I don't know
> what other drivers do either.
>=20

It's been frustratingly difficult to get real answers here.

> > I am happy to drop or
> > respin the extack changes if you think thats still valuable as well
> > in the event we need to extend that API in the future.
>=20
> Your call. May be useful to do it sooner rather than later, but
> we should find at least one use for the extack as a justification.
>=20

There is at least one error in ice, and I'll update other drivers that prin=
t error messages too if I find any.
