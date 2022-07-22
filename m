Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F0C57E8B7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiGVVMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVVMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:12:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99547B504E
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 14:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658524350; x=1690060350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9FuJ8VRKy24W/ibOqPWavm4uRMhtBO3EYtLFVyQ5Tzs=;
  b=e+DKpPjIqKip4bATYRe72Ry3L87XCbmBJAbf8UNX1SP4S4mvInqzmUeX
   nrCFm9a41+xw9evSKwvLZIDKBmDw7mV6apVKWYuzvqDJtrE0rglJ0CQNC
   RNOi203jbn1LT4v0mExGJCR+4142Zo8etgw7grOOms75SD4MG0cIgIb1y
   IksCgOuuZZRG434Fn5XUKEuQH18kJdqKPd2S16csOl98+yHBYAsawsMr+
   K53VeVHhG9upXp4184sUQvAxTFj3A9aQFkTZuqLTa5oS/AMrC6Wzyq7i7
   ppKX70EVk6IeAMHmBjE7VRIIEOaWCzKVWOPY9TWoAS5EiWKCH4MxFIs8M
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="349105952"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="349105952"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 14:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="596090411"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2022 14:12:30 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 14:12:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 14:12:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 14:12:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Jul 2022 14:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUZvNyQsyUlSIRju82Tx+peFjhTbgVPvHhxLV3U+yfSG/a+8nPR8qSdTSLgcllshZjukil9KcYQGmpDKf9jHsSBYdiI9XRSBmaOO7JiQCzQX65b8z9YggKgwr85jFTjMBqpj5USjfaInoD6SYVdz+6Tw9onr0p3A9UJpn+HadrFvjism+MTRcKs0ifbHbaCXd3wP27yl+CAixMBnYK6xA57ztOAIUf8EE8WKkR1AxQwnT7gopJefCRrqQhdNYLESJUhNo7ewWZkq1QU5QkWhTIAUOZhFzFrQfU0VQWG32viKPfUEaxBQZs3MT6M49ZAXVxgAUP2qbqSOY4euUEAPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dzi8pUjLikvqGpCJBjJ4vlZPX7ts1A2ztvz0oPITJFY=;
 b=INqzdSR/g2BvuSWdyu+K0ATbNAJFJTDOWCyi4y8mIyYX5mHDVtUGGwwTyQBdyN6aNVFlnycHtSxqmkvwJ/9zEWOZr1BXUnA7MVeeOZ/qGdsFfZoFhtw7AB9+gAqKlBDsUeRaGItRyKUIZwPrwZ8ORd9HgBuGWmpCcD7AHaQvKo4dly/uD1ZIJglcEE2Yp8A91gVkh6ALEjHJdJygg/8Y6t+E5tDqJzHBF1388LwPJDqS6yTrNLLPCa2clAw4eVbk/OAutGc2iBjNOyTORFWQghNmadOkDxCdtRej8xL2l1QEzgOB54gDnl5WtaEQRZgFmskDHy8pcDKpLZnOZQiHHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6359.namprd11.prod.outlook.com (2603:10b6:8:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 21:12:27 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%7]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 21:12:27 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uw
Date:   Fri, 22 Jul 2022 21:12:27 +0000
Message-ID: <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <YtjqJjIceW+fProb@nanopsycho>
 <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
 <YtpBR2ZnR2ieOg5E@nanopsycho>
In-Reply-To: <YtpBR2ZnR2ieOg5E@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99ccc501-95e0-4040-15c5-08da6c26e183
x-ms-traffictypediagnostic: DM4PR11MB6359:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/3fFVu4oYhItcOY68Pj/AnDl5zYJuGx7xQ0YoPYu1dz7IGjJdZFV7A/qwf2QkAAqA0aO1FfVXiwIIz5ZJEu6ubUIYb3Nc5pp7Dm0+epKWzYs2j2H/S/a+cGcPOiLeWpdV6/b0+R8XOk1sXfQ5UGeePnhGvKO7NAQuvEWQPpIqmVS9/YH7k1lCDh72kdVeNCxhxpP5/rAwXhL9iAJtuCSeBwx5VRkU0HJ2hzwRLgO9K49QfoKN84Js5Gf2kITc7RRxyBlwuvZNutVOKRZ1lZA3fNEnMfviQS6vSRjieiFYRa4emRPQvOlKSBnUZo43+NkF/LSnhRCGRqSTrLmlW30A2INdMGNfSTSodXCm4g5KIvcGPQ4goK4nsS76q4C9LQlrt/6+bPi87T+cT+Ny88nKZh/wGBrpTCdOgYvmwY7iSXzhjHgVKGUcvroIs2MLH3XIOnyvXNr9GWgr/43IMJzlwgBOm6Vr1XYBjrXHXhQJK+c7oHLgYfTAkrUo2eHyEeRqdUwGyCctkcMebd+5t1YJ5EMV3aw8BWtqazb0zKLcSe+eJID4W/XWNxvHMrcIwbHTH0/Ki0vX9S/tW+X/UKPsBRWIrzBql7cUyxI1K6CLbagvw900Fugv2825eYMu4LZc93tJfyZbme4kedzVd7FS3H0Q2LPcjrc5NPs4+YJe8KtgPRv34loD325ssbEL81BCs2Dhn7AP86quczjxOa8J8yF6y6rSLKA9fZ+VGbW/Zd54178wp1/1Ed65SRCZIBazzhIFKKdut1X6ACUps1rqpWq5qKSudVMyGUSi5waSawZWxJtmal755ZUfTWg3OY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(346002)(366004)(376002)(33656002)(82960400001)(86362001)(38100700002)(71200400001)(6916009)(53546011)(122000001)(41300700001)(478600001)(186003)(316002)(9686003)(26005)(6506007)(2906002)(66446008)(8676002)(64756008)(76116006)(4326008)(5660300002)(8936002)(66946007)(52536014)(66476007)(54906003)(83380400001)(66556008)(15650500001)(55016003)(38070700005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sx2I0IhJVZXk8OtYTUvGfgUxc6NxRYDUSs9sXKS5ovmaP+f54oIIvWkJJixM?=
 =?us-ascii?Q?Y2iNMBxmrN6mNkmJskmvyVyS53nZbtYK2QzDYzcRi26IPzyqOHYPuV2g9l6x?=
 =?us-ascii?Q?UMAHmF6Pz8eVDbzuYnlg6GAZQHyrV5zAmy84pseI2I57TKOMOBRIpooDOQQV?=
 =?us-ascii?Q?e6jYScKMVAy5AyKn/LLi6YGfA0QExHHocLDO9QIE5qLeW3C1ob3sj2Xahzeg?=
 =?us-ascii?Q?atBwADRdDPll7676jOnqt107GPyV5JFkFa6r6vIMp2z6o8ryj+60nfaJQ1GY?=
 =?us-ascii?Q?K8KQ5ft+7aO51aMnPEHNay88JcUJGv/nOVqK0xxFqzhyUd5t7U6ebKxfJPag?=
 =?us-ascii?Q?5snbcm47tZLv2WkyWtKAUvMFAnM7IFdVgZ+n414z+FepU0NHAVpkkoSvKF58?=
 =?us-ascii?Q?QYDC41dnWj/Sl/b0FFku5JQMC/MKBsxkkItZW9iU+lYiSHPiHifpGLL70jIe?=
 =?us-ascii?Q?UyyeymlncXkIe71uc+dXfRGrubdAoA8wstZPLKNOlYqBgLu29ZI/S3pHe2pS?=
 =?us-ascii?Q?qMNxq2bnkp1du2KgiROgTuS5/G714Ly9pfrJ03/sUUpFOrkPKMmTwp/zxiHq?=
 =?us-ascii?Q?24BMr22mUQY8r6oKCHq6yFB8Dp5MrvjETfZ/EYE0y2ADbJO1EQsWSTeSE2OW?=
 =?us-ascii?Q?ReG7LXOhLZ1IJ1hZHqKgLPPomj8yfinlFSUkYFkhgXF63aeAIj2t9KFiy/2v?=
 =?us-ascii?Q?X1h8YXaWf7GniQoZ7RuRs/AiCz0efDnfwGlOp1Y+cRWYC7VBjYO5eRCv+Kyf?=
 =?us-ascii?Q?YQdn1Z9Fgzaiv3JnHm45qkcfbfAngsW8ZSbvyUGxpWK6VWKUB9v8fztkWKE9?=
 =?us-ascii?Q?bTFtYrVKg0ymvPJEtyLJgfoDgpC2V1UfT/qxt4ZjiSLHH7y/ROkRLycNcARS?=
 =?us-ascii?Q?DnzRmIdhjT+VieG5d/BPOw/Mk4D9hM/G+jkwJVhz5e9rbL0jaEcFBGVzeRRR?=
 =?us-ascii?Q?ardamwjGQMHuvFzZ/zT8vA70Jlrmgo8YV/WatV474DLWHuqhWg4AYSRfpQ9c?=
 =?us-ascii?Q?DCL7HFPPVx4UoqyIfKWz7L9G7+XkpZSoQasRKhnA5BXlRxt0EV3jkvVbVC/2?=
 =?us-ascii?Q?oPFs/lEi4X8c2HSWKqcs834/2it/4+1de7W8eSOsO5KTorsag8JpbJP65oI7?=
 =?us-ascii?Q?Utg88hfOGADjRjHVeYGj1M9tzD1pV+k47jPArV56TziYcYyV2lDbTUCJEMfa?=
 =?us-ascii?Q?Pz+MilcD7rCn89M2OtJiY5ZTpz36VECywbug6SoAmK0X12ScaHeO9dz2Sb3F?=
 =?us-ascii?Q?qzjiyyZc951es5Rt5AV4zVkrMQ9be5c41vsN1uZBQ7JFx2v1flfYfZ12tN+j?=
 =?us-ascii?Q?PTJNR9RAsnXerp7q+CtYcBHal9quaT0PsNViroSeoFnIx72HkHpw2fe7VTiX?=
 =?us-ascii?Q?O0I5o+dQZ1v8FuJaxcQ6a6eUZaZDGqtINtPqrCNT1yMtj124/0otC8RCG8C6?=
 =?us-ascii?Q?9Kucvhc+LQDoCuRNEXaLvOa4NId++hPFfZQypcXGNvxES5XLwSb+wjeictLJ?=
 =?us-ascii?Q?0lwJF/X/0oe5TTD7tg5zuHZVKo0Dj+I0EXv2Hqi8vihKUWni06q0KmWAlecU?=
 =?us-ascii?Q?l5SPXkp8iIqnCXmp+z4Co12aR98uPrfMUteeyE3B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ccc501-95e0-4040-15c5-08da6c26e183
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 21:12:27.4211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wYC9ZAhKUZ+2w3xnjIFKq71zPN4MJ8nuDlnwdrReV4t+OoC7qZCTxo80eidgNPnPURyBQN8yRJP2xrdvbD3x5RK2IJf5x65Rcd+YWQbQy8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6359
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, July 21, 2022 11:19 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> Thu, Jul 21, 2022 at 10:32:25PM CEST, jacob.e.keller@intel.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Wednesday, July 20, 2022 10:55 PM
> >> To: Keller, Jacob E <jacob.e.keller@intel.com>
> >> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> >> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to fl=
ash
> update
> >
> ><...>
> >
> >> > struct devlink_region;
> >> > struct devlink_info_req;
> >> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlin=
k.h
> >> >index b3d40a5d72ff..e24a5a808a12 100644
> >> >--- a/include/uapi/linux/devlink.h
> >> >+++ b/include/uapi/linux/devlink.h
> >> >@@ -576,6 +576,14 @@ enum devlink_attr {
> >> > 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> >> > 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> >> >
> >> >+	/* Before adding this attribute to a command, user space should che=
ck
> >> >+	 * the policy dump and verify the kernel recognizes the attribute.
> >> >+	 * Otherwise older kernels which do not recognize the attribute may
> >> >+	 * silently accept the unknown attribute while not actually perform=
ing
> >> >+	 * a dry run.
> >>
> >> Why this comment is needed? Isn't that something generic which applies
> >> to all new attributes what userspace may pass and kernel may ignore?
> >>
> >
> >Because other attributes may not have such a negative and unexpected sid=
e
> effect. In most cases the side effect will be "the thing you wanted doesn=
't
> happen", but in this case its "the thing you didn't want to happen does".=
 I think
> that deserves some warning. A dry run is a request to *not* do something.
>=20
> Hmm. Another option, in order to be on the safe side, would be to have a
> new cmd for this...
>=20

I think that the warning and implementation in the iproute2 devlink userspa=
ce is sufficient. The alternative would be to work towards converting devli=
nk over to the explicit validation which rejects unknown parameters.. but t=
hat has its own backwards compatibility challenges as well.

I guess we could use the same code to implement the command so it wouldn't =
be too much of a burden to add, but that also means we'd have a pattern of =
using a new command for every future devlink operation that wants a "dry ru=
n". I was anticipating we might want this  kind of option for other command=
s such as port splitting and unsplitting.

If we were going to add new commands, I would rather we go to the extra tro=
uble of updating all the commands to be strict validation.

Thanks,
Jake
