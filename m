Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CAC6BB810
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjCOPic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjCOPiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:38:22 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FCE6A404
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678894695; x=1710430695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n01BoFNpe8VzazZL67vT2AWY+UJ+1QJXDlM7QqrT1OU=;
  b=ATGBeVCR8JkkoGtCV014MDL4ri1XFA0ILKE7mKMmHRxDGeo/WB4t/2qs
   RZuDD0cmIqw5dqfRWSKdYdWujMD5sVouO2ydIorVL3VTyHEx48mCetxsj
   rj7wdTnBFhIkFtYWFLZ0vB6FONywv2CpqB9mx7PESBihIbbQTuLBl9cJL
   CEA3hdg21FLcC/zi5J1o2MMHJNK6YhA8hJj7fBp8os9P3fGevOvnj7VvN
   Qy2PEQrozhygpDmTGNIrl49PrnOCBciohCCt1n1sjnN+TA3Vk9W77Fc7u
   uTIDyq9b67rIWWavKUWSyJUShEUlUhovJWcU7uZcjcdAncsROL2z4jQd7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="321577054"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="321577054"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 08:37:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="748474951"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="748474951"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 15 Mar 2023 08:37:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 08:37:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 08:37:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 08:37:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 08:37:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdK35+J7jBNwMJFrQ90yQ/PQUEgQoHJRWOhyekcgBVCsZQxnCQk5gjcw93h12XRTi04RFY5l2x2wKm6VY7LUr9eswerECTUGIVqp/Uu4RmismBtSJdgx2GCy4768/fufNZU4AlvQvhx4EVVn4sHukzWFXdp2qR8EQVDPlqA5Gu9ESwM9iwDBx3u96X/DmxMiuOQOVirjr4TDQCAQEJRTaW0j6us4L7Ilnez2DtHWR2tkWOdRpLKEuQik9VI2en3SqvCpgou6ybSVUI/09unbrXi5BS3KEOhrcp7G1wUj+VwDMrrDdBRw1e3yJ5LzFzaL/AQb1O//y1+k+JHbAjcopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n01BoFNpe8VzazZL67vT2AWY+UJ+1QJXDlM7QqrT1OU=;
 b=b91OuUMcHLLP5GRY27Q7sFIzIgMMZ1s2MGJ4LgN4gWrshNzSX2oV66QLdU369NpDiHtrdO/U02OSwUtRRjs7IEuqnUWaHIISOYmUfsB0MPTItOquSLiPS+PasNS9pe0Y4whZjjGGCAWCew2fJQjV06CnG74oncO41L8UQG4JLULq09DLyCNccmLr0+EeTEIIVQnzbIj4tp0c/0ILcnBMhNBZRC7ycbtMUJ+cYUXtpvmApjPewWlKXjD7BLgPrgCeJ/DGYu74y8On9+IjDijeaEQky2Yhv4nLXdDutEbfvHG2YY3v0fCPeP2iA/85PEpBKll02raAF44xT/KSBA0JdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by SA2PR11MB4793.namprd11.prod.outlook.com (2603:10b6:806:fa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Wed, 15 Mar
 2023 15:37:51 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::250f:ee9b:4f38:b4ba]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::250f:ee9b:4f38:b4ba%4]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 15:37:51 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Jakub Kicinski <kuba@kernel.org>
CC:     Edward Cree <ecree.xilinx@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next] ethtool: add netlink support for rss set
Thread-Topic: [PATCH net-next] ethtool: add netlink support for rss set
Thread-Index: AQHZUtOPcdTl3zIDTE2vNdyJzYtbc67znDIAgAWy4JCAAAhoAIAA9mCAgAA47ECAAL+hgIAANfMAgACEruA=
Date:   Wed, 15 Mar 2023 15:37:51 +0000
Message-ID: <IA1PR11MB6266629BD9346CCE12794026E4BF9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
 <20230309232126.7067af28@kernel.org>
 <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230313155302.73ca491d@kernel.org>
 <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
 <IA1PR11MB62665C2D537234726DAF87D9E4BE9@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230314212427.123be0ee@kernel.org>
 <20230315073732.jjcxv2ywkbw6vvuk@lion.mk-sys.cz>
In-Reply-To: <20230315073732.jjcxv2ywkbw6vvuk@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|SA2PR11MB4793:EE_
x-ms-office365-filtering-correlation-id: 560c0a7c-edc6-433a-0b27-08db256b3c9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ICrTkYwmtt7t4lqNcsJXx90GA1fTaWDR2W1p74EG6YJKWFgeBEL6Gg+qWL0hn2OKfwk7i36weH1HaMqa8gEXQ2w2OAtTUpMJJGtc95qIons4etm3Ke917IOFTeBoyRAHrwLRlxTieJiegg3UurdkREp7tZnoxFBSQ/N6y9FAoWTzSxe1zIq/4QE1fzm8Xbe4B9gxQlJi+jp0j9BnoWMPFV6ZwYbsgxY8slDqkqdJDnjV2lBaQ1hdVl9lpJJps5t+ELFo1uLAqgOZk3TBB+u0gV042IMVwCNYObEqaUw+FK2J1wxFPIV0SlJ6xQq/UQWtn2OJA1/HbVGytSBgzgXJbjjwU/rOdVIUhVIKi2wJ2JSYMAgEp2gx+NV9qMbNinUrTVpWbE5fkbkzSUz02/XNc6r+J7ntdwl9BkBSsminkYr66MAT1lo6XOlBsV1OI/t702CnXGtX53TXtCEcRjFHKQCQ0J+LyGOPWUs8F6+NeU0miBu0r4n1nhcaBfazL+NjJR4OJAAgPfltFSdtEILHenL+iLm6ZjznLnW2D0YOq9rQdtbTZzU4phD/YAVAwuEpXM9B4BNIvy/EIzBT/eniaqIQb2NPWzqqyXc5DtBSWcJa+9V21Znr6IXZVjuasThlTXSg5gFfdxZMeNVDSi4fhN5hsUnyqFDKnWfHTZAmdlOVPETQQ5gJliZsc3Td5Y9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(110136005)(66946007)(2906002)(38070700005)(4326008)(26005)(66446008)(5660300002)(8676002)(8936002)(4744005)(52536014)(64756008)(66476007)(7696005)(76116006)(316002)(54906003)(478600001)(71200400001)(66556008)(86362001)(55016003)(38100700002)(107886003)(53546011)(33656002)(186003)(41300700001)(82960400001)(122000001)(6506007)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qt3MeaeVi8mbX3ROGHiTcjFjD7yVxNxxIoeehAC+2YMAJL27YVPLmkVhJJWk?=
 =?us-ascii?Q?So3PZn6fOufTZDfUjV5PQcw5iAsyNNz7Vq7hjgDjG8SDzU+Q266zS8z2aNfx?=
 =?us-ascii?Q?6US5nRbRyH2DuUKJEyfSTMma7YIgEcv6zpXTafaEnNhTPKZfNGcdOklruaEq?=
 =?us-ascii?Q?tekLLAW4UqV6OqVfQyz4prPKyYB/FGC79B5W6/g6seHxERKRz3j4+lEh9Bzb?=
 =?us-ascii?Q?YhDIz/6sRlOJwsePbc0sdVQIJDwfneBXtaH8lnow+l8TkFvowzFU4dBGRG2L?=
 =?us-ascii?Q?CEZrEwxT/g8cMkKLnQAd+9vsSSC1lH3fPiIMjh76T0gOaqEIbhGm89YqIBo9?=
 =?us-ascii?Q?PHC1kjhRouWlRoNf7rLsnklUQhAkBHe8XwWmXTpKw1d8O5IcSrAxuYcs4X2M?=
 =?us-ascii?Q?D7aiKIALaktNQ3bJwOX2NKy15LiLRq2lIXtYnYPnxtvXAzXIt9CaCGHPaX0V?=
 =?us-ascii?Q?z6uaAvk1498Dzdh7F/QJQ8Fbbz4diyEVNkvmVV399VXa+eIXQQ5O3rOBtHsh?=
 =?us-ascii?Q?a1AtgaIga3CHkocm1N6hEg26rsiz6PvwEvLOx9wO5LoYrmssqlz8NIFdytC8?=
 =?us-ascii?Q?YGlUywOLa4g1n9YqdUJUrbUewmWaK8OxDLHdwe0nytTrb6QvUooWRSlCquId?=
 =?us-ascii?Q?WRgi3Dy6xw2Z5YQY6WASaSWQ28hsDvunyUsEYQBYgOjQi83qQ1N0OXBj4PsY?=
 =?us-ascii?Q?9+eX/ND8Dch50X7oIeyHDY4BGwCpscMosi7ZQGX45bCUzQKnwxqD38MTnhjB?=
 =?us-ascii?Q?vzX8r0r7dVOOnMBaiKN+QeomyCp/+AUeDkcgUxBsSbSrLszw36G8WL+Ka8rd?=
 =?us-ascii?Q?s6WdbaPY32LWoy1WSPIDwUU+oGMjw1mQkzv6KTk+kwJPfvEzalmCDwcaAQl+?=
 =?us-ascii?Q?W6fT5Zjpp9q5ulImtZGLvvcxo11x0+pIo8Gzo8v6CVQ0DnJI9vFqIjvdr7M8?=
 =?us-ascii?Q?qZivWMufALhCacnnHhWXwqIu7J0e7kUmcaEi6vanr6dtRzYLB/lAV+iaG6Yf?=
 =?us-ascii?Q?JtNoxPcOqJy1+zoSovDWBysUo9S7FUuWEnkafcA71ku89HENOqq7XRio+3rU?=
 =?us-ascii?Q?inMEIrxGbd8LYSEA2t+6LKbETFUsW/dmoiyBsIho94h846CV8felvdm6SLn1?=
 =?us-ascii?Q?waecQIypRqGKQF/N8AWxmKUvhELGdJTZKRSBkUxfVwqyeVVtiPpV6vh6Shap?=
 =?us-ascii?Q?ywiXHf8jEVZsRtpJHKe/4Od9um+EVOixz+GKfOggZfp/J9nsPyme/+luq2SY?=
 =?us-ascii?Q?UswbZ7DyJrECX019LcnhXTmsYkubeSQvGNphFbnmC/jJV3PhmiHoBjG5uv6L?=
 =?us-ascii?Q?p8w8J6dMcy1uQgWkSMMwEjJ8XHyNld6bAPM2meGep+Ido0EpPpNj2MhJhJjs?=
 =?us-ascii?Q?3HRQnIpV/MZWoIU4Qah6JVnAmqDei4zf/ZUthTEDkpjxkPlfoPxDIMtpCsQl?=
 =?us-ascii?Q?tfrJMQnoNoDrCUAoXRPB7tkqU1HBmy8ZApynw97Cti/eRH1t///YRwOHJZYx?=
 =?us-ascii?Q?o8NhlMKSHFAp+FHesOKjr7YufPtvFtx1naHajNkEu1RHxnOgTDi0BHckRAQh?=
 =?us-ascii?Q?AXqy6oOtVsl6v+FQIzB1vbKaPgZopxHqtqkxMGGkIlj2+wYvnTSqVwXdle0U?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560c0a7c-edc6-433a-0b27-08db256b3c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 15:37:51.1530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RENS+vO7Z+PawnACCicUTUYyASgT+1/q71fNxSBfPVBjDgDwnK5ieWaMHx4AF0DQlAbQpCjonEP5Bnk39s3VIpS6hlY7GuzRVFGT5YHBvGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Wednesday, March 15, 2023 12:38 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>; Edward Cree
> <ecree.xilinx@gmail.com>; netdev@vger.kernel.org; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
>=20
> On Tue, Mar 14, 2023 at 09:24:27PM -0700, Jakub Kicinski wrote:
> > On Tue, 14 Mar 2023 23:51:00 +0000 Mogilappagari, Sudheer wrote:
> > > How to get devname to be WILDCARD_DEVNAME ?
> >
> > Isn't it just \* ?
> >
> > $ ethtool \*
>=20
> Yes, that's how it's supposed to work:
>=20
Thanks. I had tried with just *
