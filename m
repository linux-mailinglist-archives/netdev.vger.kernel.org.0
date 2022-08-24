Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92465A006B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiHXRb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239329AbiHXRby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:31:54 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D957D78E
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661362313; x=1692898313;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pilkyqOc9uBMUN9c/u/7N1SpGiAaO0LFzsrRRbibAhQ=;
  b=NulGYbsR8wE8X9YLc9ff+M9VQUQGKAL2lYLMMQUqVxYMsU62hRDwSF2J
   FgK/RwIcGce4zcHsSvZatjkRY5uQCDb9hOV42cyjzHCI0+98hqQnLtlr6
   AnfYkLFgO4BmfiiEazOtZOTwruaDceHWLttKyAFCE9cGSOylpnacYwBQ7
   cZghM9nZ3ludIJ7fr76ZPsuP1NdbLcY1R+vqAZu5Y9ExA/w5MU04ui5he
   XxKjI9k7XYWDECg/vgeYdbOGVPQEpy772LKNIxZhuxRYAgcMLFfe00GCe
   2En0fREAboyQKf/QUNqrBep3XU9icE4T+gUFSCcAwPpapJS8XmSIXpTEK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="294031268"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="294031268"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:31:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="699150697"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Aug 2022 10:31:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:31:49 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:31:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 10:31:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 10:31:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhcdUJAY0w2lINoWOXEQMLWSYPEsuq2hnQMTvbGRxiUt+8RCPj22tQI3RxirBya8zVK5TlW0ZUxdRgOD7L/HJEgxjLNDoib8WS/y/4nWsRBtXOVIDWSg73Vz3kQVSO3qdki+e5xplP3cZ9wMSBKSks3OqdOzGVueVA6xaaoiLq/NvahibbPRHlYai3kCgRlUyB04LP0ZzY/oaHE89StCKAhH9wPssLgwbck1mq7Ktr6W5BvT4tRmt7N2Ol9DrumwPvgMJsDXnSfPYMFSVfrnDntEMGpZYGA93+Bg4IXTw94/OsdZehh5TLvrTLv69BjM3tZFYyhzBWm+cOXNF7oyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pilkyqOc9uBMUN9c/u/7N1SpGiAaO0LFzsrRRbibAhQ=;
 b=R6hmxWOLYf7gEdfDrDBGvNYrt+BCHw4BLzmjfdGjnY6ru37cypoFTGaRfb99hUL+o/kmGFhPTTFh1PsRkXko1OKP01hGpPj1o4prwEYGoGKS/lZ0uZm2INbdSn1cqTUY/piK5iSHruLLR3pPvfb67qpoZSOVcPAOEhdBYE33V2h0tMjm9nJdAZEyJk4qogWnrQmT5Vz82uMQ2sl1oQaiglwPrQm2yc++Nq9arQuVXUGxaKR95gPuEmluvQFBAxlBzK/s/87lEozFEhbo0bg3lsfm049QUTvpBmP9njl6w+aWB1sioDoo22rv8Ptgr5f4mkHt5v+Ar0dVS1wolkBboQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL0PR11MB3505.namprd11.prod.outlook.com (2603:10b6:208:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Wed, 24 Aug
 2022 17:31:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 17:31:46 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Thread-Topic: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Thread-Index: AQHYtkkWIcI2dxy1T0mjsJmFZSav0K27zKYAgAA8AICAANiggIAA3yIAgACRicA=
Date:   Wed, 24 Aug 2022 17:31:46 +0000
Message-ID: <CO1PR11MB508905A2019ED7C98C2CEB6FD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220822170247.974743-1-jiri@resnulli.us>
 <20220822170247.974743-5-jiri@resnulli.us>
 <20220822200116.76f1d11b@kernel.org> <YwR1URDk56l5VLDZ@nanopsycho>
 <20220823123121.0ae00393@kernel.org> <YwXmNqxEYDk+An2A@nanopsycho>
In-Reply-To: <YwXmNqxEYDk+An2A@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3060458f-5251-455a-296d-08da85f684b6
x-ms-traffictypediagnostic: BL0PR11MB3505:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hlmdMCgJ9Lh6gljj32Xx9AovTi+qWQGuOmcJl3sCTMHc0cyTBbWln2dHhtLRJqj5SlTg6G2/1JdHkKjRTjzHWj7v3Mt8pvdPNbCfPE1q3Ldgbl+cKuSj978VplpHToLT+1IK14OZyT+g5NNbQxMSF1lYiO2h6qaBTesyJ0wKlEEji1usI9uecHuyUoHE8JS+X9Ocqj7TSM4yx7CYXBQsa3aURbxpaDpZJX8iW+/X/UraKnxkY5FuHPxpClGdu4XCKfXO5I6q9/DaCdHl67jAWD4OVmTmhK6t0Ch97Z4ISKSDhXxeH8YNRp57AnLg8AEYgOKZ/zjTzc7/gFqMt1JNv158n3/uKbNkzik1Iar2oGDlx3f0h8h9vp/mr0XAgIQ0lcyuf67FxfAKOH77zhZGwUCvFneTfasKwt/iUHhpJdgCILxNn2/dDqYC/RVt9RoyeJOqmi7D1qc/IH+Fmpr8gfog23KwOn+5tJ8Uk0dUNdnikeh6wqWVKXCeVLdQD6cBtF0iTfLeGBFFeJETQpHNwA2AXxdGChhrFpRlS95S+uBYGd0kJxWbuQEfw4GH4NedBFM+n2G3f18u+YXxuuW8dwqZwIezj4pGGqhQtZiKmjYIfSSnO8l1EkGXOPrnFTps6fA+K8mGtaHQ/fc+v4Sc09CYRzTG4d4KBNKAPb5qJjIJKmidssT9Uey8AZtN/WttjvVkUDPxofQ89s8huKc+gdDskil/ga8c7XJgW7UKoHhUAjDE1iTFV5GurCxZh7cNKG/QUhqYBlTvdY2szNyFHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(136003)(366004)(39860400002)(110136005)(122000001)(54906003)(4326008)(186003)(83380400001)(38100700002)(86362001)(71200400001)(316002)(33656002)(76116006)(38070700005)(66446008)(66476007)(66556008)(82960400001)(8676002)(64756008)(66946007)(478600001)(41300700001)(55016003)(2906002)(6506007)(9686003)(8936002)(7696005)(26005)(53546011)(5660300002)(52536014)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?foMgBateO12sgZcE81FTSRD72L4xtTrjowYQGMHROlVvv/k83EhWUsdhZg6a?=
 =?us-ascii?Q?55kWBDEgBoIWXwmBfNQkvZQANIo20gGE5VRO1f1Txt3yRN/jGzBSZ/BFJMVI?=
 =?us-ascii?Q?DH9sW1/zDxV2toK/jE1JeaghiZc+GFjxPpnGDjqOnIUUJIEdt7xULYq5WZQA?=
 =?us-ascii?Q?vRtGQLgNs2L0QnQyk9mxMb6zdZ3Lh7+YM3/eKsfjQa3gl6LMlyVgcZHirjqY?=
 =?us-ascii?Q?nUkoinTr4Umckf0YJHAl8l451hqJUAXpXzlDp81yh7pEDusd/1/BCKS2Be7f?=
 =?us-ascii?Q?BQ8WIB/rqel5ZaZx30vACi4WB5x6yAq3+Bq9ic2qoVTSIPxvb4+oBL+ZUP6b?=
 =?us-ascii?Q?KPY1+MWPi5gdJWcgGNlftzqbZWrLSF3fZxdvC/jAzoHKPtd5rRAgY/FdkCGT?=
 =?us-ascii?Q?tP0PRpn1G7YLm2ZVRxeFwAhH41zMpKQbNOoyQA504yn0DCZww7lBQOajEkIC?=
 =?us-ascii?Q?tlz9jO1wC+q1+mf9USQ98qMVkcYldsFdckNkC9TUVCtAj2UGpDA8P6KexojR?=
 =?us-ascii?Q?mDqzU4UkcFqDNQWqbmsc2D6N0YY7nIBa6S58MHDs5ZQy1eBd7Aoi3EbODKim?=
 =?us-ascii?Q?A6uwW6Y6kfy+Sb/KIjMbFJZBIgotYzDuHPlyEnOl6WPTVLxUDyf2l+AmNjq+?=
 =?us-ascii?Q?xP3zyNhIiIyTZu+ukGwH0cD5JQ5idlYyH1JeKYfJvhbV9fECwIQD+HloOM3V?=
 =?us-ascii?Q?+AShrM+6XLlIxU738ebDU8UnJktowyaM9T1j7vb/iRf/0caI+XgTQdNpOO57?=
 =?us-ascii?Q?c9zKNXFtv9WMpF7P6zDSzhHfGmT2bFtShRFiy7awcCM3se2xBFXRq5uSzHUH?=
 =?us-ascii?Q?ncrpOQAwQlBbeHirKcx+YsnsEra06oHnzLHRL+og9K+PFApziZRUxI/8dIvk?=
 =?us-ascii?Q?xIEB4+MzeJbUpzhgYgENs7pi1Ka9HMluUOZkAhIF9W+5b1tGflo4398Tz1dy?=
 =?us-ascii?Q?/6ETa04IA773jK7D2SLurk11wCz/22rnVluojzWLggVDDLQqk30Vf+iJxgr4?=
 =?us-ascii?Q?HmVIR/GQ0Mp9TF7B0cMQLAI4FAQEJBzhwHm/oYc52/VTtueGMyjjEO03QU93?=
 =?us-ascii?Q?oGut8uD2AzwEFrNYCRU03DTgozztnSmSQIoJZR5VaLQrQzNVcdBxguSFYwAX?=
 =?us-ascii?Q?QBa1ZRsxWaR+ZrCG63/UjBOM7aPV9NSBqq2vAYkNMJllLmOQzQY6jU49o3Ja?=
 =?us-ascii?Q?xLfxyBs787xYNc+u/qLaIRJJdhU26GRU2y7fvcjjnhYeSGJW/03o6i9W1cCv?=
 =?us-ascii?Q?nyhJ1eJxl/rB8nIePxXn1BC4ODuyhOGWlfeYtMNyKUz7rUQ6erXu7ff8ELhS?=
 =?us-ascii?Q?UkPh3HkZNJ9U5WnXwnZVbKSpJI0MegF99PI5OD879x/SCUiXNxcsVa8qrJx9?=
 =?us-ascii?Q?4oL2g/ST9r0UPWSHMttsGayNTzW61fW1cDUTAk3mJfUUzwbu+bEf/rGHX44n?=
 =?us-ascii?Q?vuUbd88yM6D9nh7tHaS7YeQjMV2pYG7f+iZmTQg29Kxen790DQ4zmDHbtmvQ?=
 =?us-ascii?Q?o5JPjauWRfxtXs/r905L/oNXHWXsZ5oCb/H7HGxXGWXqodZNv4p9+Yu/O7PO?=
 =?us-ascii?Q?tZR57Dpfdrsl0Z40pajISrVzxm0QFvUIUTctL8jH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3060458f-5251-455a-296d-08da85f684b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 17:31:46.1169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U41SdUTuRaMjbkg6zrsu+nXeL5nd+PK/IE8KKP5b5lC8b46ZxskMaIv9GiwoRAKf+t2FRe+wua2J3e5C6a8iZ1tshLcSP7+FBYcGYrCCcw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3505
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
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, August 24, 2022 1:50 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; idosch@nvidia.com;
> pabeni@redhat.com; edumazet@google.com; saeedm@nvidia.com; Keller, Jacob
> E <jacob.e.keller@intel.com>; vikas.gupta@broadcom.com;
> gospo@broadcom.com
> Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about =
version
> representing a component
>=20
> Tue, Aug 23, 2022 at 09:31:21PM CEST, kuba@kernel.org wrote:
> >On Tue, 23 Aug 2022 08:36:01 +0200 Jiri Pirko wrote:
> >> Tue, Aug 23, 2022 at 05:01:16AM CEST, kuba@kernel.org wrote:
> >> >I don't think we should add API without a clear use, let's drop this
> >> >as well.
> >>
> >> What do you mean? This just simply lists components that are possible =
to
> >> use with devlink dev flash. What is not clear? I don't follow.
> >
> >Dumping random internal bits of the kernel is not how we create uAPIs.
> >
> >Again, what is the scenario in which user space needs to know
> >the flashable component today ?
>=20
> Well, I thought it would be polite to let the user know what component
> he can pass to the kernel. Now, it is try-fail/success game. But if you
> think it is okay to let the user in the doubts, no problem. I will drop
> the patch.

I would prefer exposing this as well since it lets the user know which name=
s are valid for flashing.

I do have some patches for ice to support individual component update as we=
ll I can post soon.

Thanks,
Jake
