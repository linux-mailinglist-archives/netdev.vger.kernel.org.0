Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730F363697C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239488AbiKWTFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbiKWTFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:05:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC1B13E19
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669230335; x=1700766335;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1mIJYrRAZEJXTQ+s+MwLTfvPQNLrnnx4wN6/lriBoDM=;
  b=dUjQHxpLHyEwTFGjDpMg77NVvtjopopZYnucE0SBkcvCIvNZBIowoeX0
   YWkTqE9ohME+hoGZPWl1ODYC16vfsGhRb8Or1+Iu4IEt1O3j/fFnq9Uwk
   J4YYNo0zkzvH7+WMQQ1kk/G3bEQA0wmBqR6eVYcl98q2+70G64GfRiSns
   Ycs3hOLvkiItTEV6HRLuppsgU79qYf0CDrARqayemQ1mlYbmIyM/vjQGl
   Bz/18ITOpd0G7PFhssVMFCDdSqOZlvkPCVlif//Uqj7bIV1dfKxTTgz65
   0f78rzfekIM5sGDMkMAvYDGsEUlRk757w66HhDyN4krkQ2RDfM1hJ8qqs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294528947"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294528947"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 11:05:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="641934013"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="641934013"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 23 Nov 2022 11:05:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:05:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:05:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 11:05:34 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 11:05:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVrfvfUEK1JkFqO2nyXZdVjFkha02gx84LHC8zDeRZpNjubDoLk8CpGDVr94Ttsj/nK5inC7gMmzkOzsQAUr0+d3Nd6ualVKo9YegOw/NfK0cNyXReECaGFIctc0CZZcDy2MjSTRgPnnlJ0TKNch+FO7JetlbmudtxOLLDp2PEUwwmDaOfsLIvGE9aoV/SGLauG8YUpCv0BNAadn4klh/1RV4OgBhbxQkuRTSsnE/y5Rygu+waFZtFUzsMouGuVlta8cokrt0Wa0BsnniCNVDVnrkxu+4W98e9LH0i2KpKydn2WRzB0itx0tyno/zUJNIbKMFsaU1vv/8clNljsrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mIJYrRAZEJXTQ+s+MwLTfvPQNLrnnx4wN6/lriBoDM=;
 b=cycr7c2GzCLKu2r7vN0t+obvIwvhsU9JOkWfqSXQ0jVsmnwCoMNouAKRp1ZkOhmNKQsUXviNoT4Spt87+MglayfjTJWOMdnGMDE2BfCTUeKuSeZ0YjkhXVGgLPIFts8dZG+S6/Gjtq0JyqDHMTrD9bH2f1TgTVCpSbzGnIX96S4Vxx6aFwgpazPb3ydxHqsRX7pLxE8+THsbVhQtyiQZACl8uTgpbCARD2eJC2MM/oSK+L8kiosDJdaTYHdkXgU2ooacAGfRw5+wIMsdlDq1JCf+omyzb/Rwx6TTq36bCmvqmBmHpQuOP/yNi4TO5getZW7pv20ymNsgomJQBXfY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by DM4PR11MB5568.namprd11.prod.outlook.com (2603:10b6:5:388::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 19:05:32 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07%7]) with mapi id 15.20.5834.011; Wed, 23 Nov 2022
 19:05:31 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
CC:     Francois Romieu <romieu@fr.zoreil.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next v3] ethtool: add netlink based get rss support
Thread-Topic: [PATCH net-next v3] ethtool: add netlink based get rss support
Thread-Index: AQHY+hMgFozJboAxXUSKmfPfCVKJN65Ef6MAgAL4bHCAANqJgIABb8yAgAMbToA=
Date:   Wed, 23 Nov 2022 19:05:31 +0000
Message-ID: <IA1PR11MB62662B44F2384B24FAA2BDD6E40C9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
        <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
        <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20221120210217.zcdmr47r6ck33cf4@lion.mk-sys.cz>
 <20221121105841.214ce8e2@kernel.org>
In-Reply-To: <20221121105841.214ce8e2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|DM4PR11MB5568:EE_
x-ms-office365-filtering-correlation-id: 066410b6-43a9-4131-be6e-08dacd85b173
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 66wakR96f9oW3NqOxXtzfRJ9LPQhBCNdop5jQcFBP05gsVFkCYE9iSC2o2RXqUaAEdqNfUbr4Wft8mV96lPem8dcAVArr1LWObv9Je9vx7fY88irEhkBWr3FUsdC0qJfYN51OwgA4M6AIhErCtaWB57G5Lj4Mx5QZ6sqx0LFLMWeSJo6fgXt3tOPLTCouoEMGU++mUtZ3dyvicB/DfTFsUnshhW1U2zsfRFrR/7S2l0dtMWOIr2ZjM8XPjjyOcLEpBy3vR+V9BC4aWzE0wyBcYjP77popVwyf4tLhR03fp9zyZpiwD7r517FPNH3HOkuV5O+KR9uI+ZdplAk4yMcl/qs5JYjH+tPzeWO0s8LV6AnM3D+wxukKH6aU1hTb46B85h2D8wByqQ+iRYIK3kYdvfKEVhlO+qjgSFCzC1cdBWjAPtj8X6iSv9VIF/dTTwpYLhwyDvW2AIgwlEsCfIhsCpSO6upA/xSkAc/7Cdz0TKLkJOIW9plWM2tB3Fxwbq39QGOvRcD47NhkIl+u1rVFzUocjja1P4qoIz5LfqZCrRUnaZulStLirYJFokrTCVO1ikywZ5PWDzPNWUn2mY3DwFOSonZBfonOIbJ7zGiwBmHmq5DmTa3/JiQ9Uj3OqLMQx06I3lBKpwSCbsRIGWaHxBx4T51ilayjL9gQHBzI17IKDQ+X5RACdArbcA0cSFGqJ70tdsLlULquGV2VLDFmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199015)(33656002)(86362001)(2906002)(55016003)(5660300002)(186003)(26005)(83380400001)(9686003)(38070700005)(38100700002)(82960400001)(122000001)(478600001)(107886003)(8936002)(71200400001)(41300700001)(76116006)(52536014)(54906003)(6506007)(4326008)(7696005)(8676002)(66946007)(110136005)(66446008)(66476007)(64756008)(66556008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UI4l/YENHiBIvED/eP8+ASnk7UJlC7ByfbpoKYAzrp3LBFTLAhFv4yOkah3m?=
 =?us-ascii?Q?gXTW2vjCW55WM7ZWwUTm6YlKgOGmQGeExDoaDCfo3grEbPb/sUMOZELPYevF?=
 =?us-ascii?Q?eDVX4FvNBthQ2OKUHsMsSXPWLLx/IEXTiPWbm++A7M86MPLKmVM0MZuBBsVx?=
 =?us-ascii?Q?/ZAF3TitxyPBkxvq4Jvp6YbLhDTdqrnmFaL4jwN2YlS9hJiuZB2bpWSGPoL/?=
 =?us-ascii?Q?AB04RRLqci6nhUEpVADZKQV0ycqQXIlqobNTPQjulLBfNkgU4YJ0RMGYGs4y?=
 =?us-ascii?Q?2yBoKiLO4LsWoLbvAOSy1C/c3hPudEH8XitwhF1iSk5VuZzQaR5uAuyduh60?=
 =?us-ascii?Q?10cmwgq0MlRISWxVJbwblcpolSI9orf1CbHVmo6ZRuO4NfXQIl/A07w8p86q?=
 =?us-ascii?Q?/kt63dtMIDnktSDTUmiFDRcOPsNKvDTa+XXnSBqJheD4PHVOXmRnkHf1uWWR?=
 =?us-ascii?Q?ZOSTYtG93W7ztthOO7RKO+XqUNk0KUaRDm24sHVLdVPboNbIvl2m3q9f+DKe?=
 =?us-ascii?Q?Z+gHQDaLs51QHO+PXOtWYO8rc39f7TY3fq8QwylnTUwnOpcOt4LywpteE4Sd?=
 =?us-ascii?Q?gmwVaxiM/I9DioKjqcS/N/3lSe2AQ2wY1G7eUfNgvqEtqT9mERN1FA/bUv6T?=
 =?us-ascii?Q?nNdIIDkRb4ZmAwMZ9SPGSWLST7vNjeoeRlQ13Zg7+CdBqEbMPDy+nhomrcGY?=
 =?us-ascii?Q?q6sCxzXP86+YHqGasgklw5h8JLolzUlaPugrappGYHl8no7xgXnGDO7bo9LO?=
 =?us-ascii?Q?KeSaXqX6rcC2Ll7igsEDRrMOM+2D0CHvgiEvkLgeiSJCgEQ2dTBl3BsJCtgt?=
 =?us-ascii?Q?aJp554xfRxcalvwtWNNcUtbbZ8CDASRO5sBbVHwIr2GEyPdEDttElJUE7i6n?=
 =?us-ascii?Q?/YhimoGk8j3evrnZhbuxjMrxIreFLWL/QI5+SOez+M8KllQaCGCZdOW22vaf?=
 =?us-ascii?Q?frTCfOHz2x8zPV5aR666Jn/V3PalE2DeDDeQRLxioVu97cXz+3OjU1Ai+BkT?=
 =?us-ascii?Q?bGt7upzgz2g75En7h/FJa6zIRd9CcG+jMGn/a8tV3NrVOoBeqEe/lmYt5g5A?=
 =?us-ascii?Q?8BusiyYEX5OfkccP8Gf6m+N8WDdukwDFm9vCmOtz2XdeLZSxAj6NPiu9EYJa?=
 =?us-ascii?Q?BOzFwGqWMbXmBbqauJZ0eNwO9ASJZMvUPKQ0Jzv0beina/uXZHaZwKDGJMrH?=
 =?us-ascii?Q?QnCGiH1NAS8UmpJwEVLPUhykylvH38XledrJFcXKBVNBYE2YNe2tuPDd0Vit?=
 =?us-ascii?Q?zdDQtx663oG6R1AMzElA6namqxlUtbUM2gAqgc7k0d/mgsjs/jiO5EF5elqJ?=
 =?us-ascii?Q?oMR1is2dD0geI/ssPYrUaAjolJUIkZgDtNXpmAttR352f5blKXMbmDJ/ULAg?=
 =?us-ascii?Q?METiUeRJtQ1R1csXleUh0C1pdfKuDxE+l0H4Kc5HDMPQhxriOF2CXfEQKcE4?=
 =?us-ascii?Q?nJo76nlyJlL3OJQupaMSW5ihImdsMuHAKSsoQ4M6eeBFZBeFU/wB8dLFBFJZ?=
 =?us-ascii?Q?p3bXYWx/vJFkKZ9esjjDVaMiXfsJh7NApgzOCj/9VyFM8DAaoHPUNClSihoe?=
 =?us-ascii?Q?BNBwd43JpAjrwJKWLjrzPvqsQQqAui76PRd6AAy8ECVnCPeuiRosEd29Rr/M?=
 =?us-ascii?Q?RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 066410b6-43a9-4131-be6e-08dacd85b173
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 19:05:31.7374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ec8TNCvN8Oo6vRMUdavHUq7DXJPlBOi4z9iVVDfs3YgQSMdZahWMuJG6jD2aG4WmKY1a3jBYUAHbTYHt5Sb8F+NaRwCbM+VDkzkViFN4o24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss
> support
>=20
> On Sun, 20 Nov 2022 22:02:17 +0100 Michal Kubecek wrote:
> > That would leave us with two questions:
>=20
> Here's my 2 cents:
>=20
> > 1. What to do with ETHTOOL_GRXRING? Can we use ETHTOOL_MSG_RINGS_GET
> > as it is? (I.e. should the count be always equal to rx + combined?)
> If
> > not, should we extend it or put the count into ETHTOOL_MSG_RSS_GET?
>=20
> That'd be great.. but there are drivers out there for which rx +
> combined is incorrect.
>=20
> Maybe we need to add an attr to ETHTOOL_MSG_RINGS_GET which core will
> fill in by default to rx + combined but broken drivers can correct it
> to whatever is right for them?
>=20
> We can either create that attr already or wait for someone to complain?
> The same info is needed to size AF_XDP tables, which was a bit of a
> unifying force to do the right thing (i.e. make rx + combined correct).
>=20
> I'm torn, because I'm happy for the driver authors who got this wrong
> to suffer and get complaints. But that implies that users also suffer
> which is not cool :(

Based on this discussion, I added ring count attribute to ETHTOOL_MSG_RSS_G=
ET
in v5 to return queue count info also to user space. This simplifies user s=
pace
code by avoiding another netlink call to just get ring count. If there are =
=20
concerns, we can pull out rings attribute and send v6. =20
=20
-Sudheer
=20

>=20
> > 2. What would be the best way to handle creation and deletion of RSS
> > contexts? I guess either a separate message type or combining the
> > functionality into ETHTOOL_MSG_RSS_SET somehow (but surely not via
> > some magic values like it's done in ioctl).
>=20
> Explicit RSS_CTX_ADD / RSS_CTX_DEL seems reasonable. And we should have
> the core keep an explicit list of the contexts while at it :/
