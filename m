Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D5360F38C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiJ0JVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiJ0JUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:20:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954CF222A6
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 02:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666862431; x=1698398431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pN/vUmSHCPiaAOn4APCiihyCaQLAJBEt0BzAWaxjqWo=;
  b=Kmt/MB2P/2P/bzwH20EwE3g6iQTT/WS08O8/tEUbXQICtBucBqA8kKd1
   nWXpZCdDlseyUG4feZKPH4n6R88REKdOkvmlZLtPZY5e3l9g7bCU60Jsp
   E1xgC7VnUGl9XcKBL7yHALTsqnjVHv9gq8/A/r1826imOlBeqOE6+NRGy
   p4ChCPgD0rRpe+maCy/cT+Rz5st7jfiKoDBLMwn17dmC6hN1r/WXq3no8
   ijGcblD8LqV025yMmJ3/yWi15Z2557QQv+9HozepDEmesLifMoq7kMNQy
   JGyz64YwMeXRZCr7sHsrd4RXxPEhVUugvxAcv8e1+bDMeWbcwo5e/3hSP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="308168295"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="308168295"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 02:20:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="663550415"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="663550415"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 27 Oct 2022 02:20:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 02:20:30 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 02:20:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 02:20:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 02:20:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeEO7F8AzhJqDO39lJJhUO+IJ0kBMHy9Roof6/McZzJYP57/s9hnobz8MhPDkPL8vUI3t3Lru9EE6v74KQrXNtforw1/VjtVGlO2i+zuyhzmv4155V27VocMhPAWSzwDYhOQpaP1cfKTJvbJpVQ/hHyJcXRIHo3Q2aDu9HTsslj1ujCFHpizA262BvFqsuvh2kB+zFYWKyOeP4rFr2Kp1fZjmwHgDKUQM7X9scWcF566Hy9gl/+4loBbir50yWZNuzuWtdXHIyYy0EiIcB98CTnJSu7tJwp23ytlgx7m0Wa4aDF3PPGc8ztkhM7HARv0hEPTJT7EWvC9FACkOA1pRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zH4vd+lJ4iBlkgQz5/5WLREMNnY0yVLG0tdjONJRw58=;
 b=gJhC8P1y0bqTM2qzG+aQUuHW+7JSN2pMyyez93pTy2hXXj7jFAcrPgD8xj4PU0AEhhaRv4pKwXyH2cKmBdOoQXBWyc49Nm1r3wN9gEUGUsXBYTstY90Qr24Twj/zNZCF63x7oQD/N6bLKCtgVp/KQ/Nv74mNVQyu36EUDpRVgy5lBTmpHafKnJBlOMZHQd0uS7brh7dchWVPsldF84bTyWwcdadCYCPn1r5UZz5gVEkTE0Q/5swHmdyjoghH5NPjkxmKGliNuZ7iMCnKrOw46Tvze72pFZQk3DG+ivt2gbc9EEt8qaMcb7el7WZJb9YdsnUno5slc77UeXpNGYdhXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 09:20:22 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%4]) with mapi id 15.20.5746.027; Thu, 27 Oct 2022
 09:20:22 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net-next] ice: Add additional CSR registers
Thread-Topic: [PATCH net-next] ice: Add additional CSR registers
Thread-Index: AQHY6S4YSaHoW1W8BkqxrFj7SIZoyK4gw2eAgAE0CDA=
Date:   Thu, 27 Oct 2022 09:20:22 +0000
Message-ID: <CO1PR11MB50893AEBD9F728B41BE57FD8D6339@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221026112839.3623579-1-jacob.e.keller@intel.com>
 <Y1lKM8RyqnPUbEv4@boxer>
In-Reply-To: <Y1lKM8RyqnPUbEv4@boxer>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: lukasz.czapnik@intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|PH8PR11MB6803:EE_
x-ms-office365-filtering-correlation-id: f33f84cc-8336-4aa7-c17b-08dab7fc798e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: //jdMqY2TN6n0BYyoJcSXiGYnf3OXf4hL3MZ/PoPT75a1Em8L4z2a5JB3Uqk3+8Mw3UoEmRse8uzLgMxdY2NzndZHk6GWzuiXEMqvi3vBjwbf5y8fKIpM3NyBLjE5ckKNjn8lMFDZFojoDa/ip/t7rR9ZOU6GuAq7xmVVNDGuA0oNSXLSjWSyt5nWfQ41yRxXVCkbe9ICZA9UbvEfZFRdNsHXwUsyCtimyN93N2yAP5ks7xPL3HwRvrNdA35TBk8QL2NSa4MrkBxZesUXn9EB9Tez1Wd/O1xRRqkq7tqDG0OF6tB2u8YgG6fYuvSrOrbS6vHlxaiWxywvV1D39MMqQxnY/KNgLswubiiKkonqSdO7JBkTazzHttHh+i4/LGNG3zcJK+pa+DeUzWesH2JnUNA/S2AGvyqzs69KQYeZN6FaqfqrhEk1m5aPuVH3yzgyZ7sIbK6REmsXJPmvAUZ7LJYCqhkjmupNX/Rv0I0sFDpA5cs6ymM74ID6ZaEFJAOBqaOE7mKwLjwBSyCthrjh/oRyqOX/OZ94G8tWDFtYXN2EsIpFW0Xv/AFoeg14fPZhv2tQx7dinwW6o8IIAGQpO/RNtUy/Lv9aKO447d6p5ofAOlc2kKXqf86LdbVG53Fb+Z/lL1aERNKv0nbqyhCR/SNxk8nE2eUHDEsEYSQv0yLRrqlRjr9+LkqrUoGVPGmY4vM/QXey9ONvUP55hyDslQ5r6cJBmldS/M0qWh4A46w9WdQDlmjbUPCbenGvFei35BvFufwuNgZKLhDAMu3TA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(9686003)(186003)(82960400001)(71200400001)(2906002)(38100700002)(478600001)(122000001)(33656002)(38070700005)(66556008)(26005)(54906003)(7696005)(6506007)(4326008)(83380400001)(64756008)(66476007)(8676002)(76116006)(66446008)(316002)(66946007)(110136005)(6636002)(55016003)(52536014)(8936002)(107886003)(53546011)(41300700001)(5660300002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?USxsbKS14aNB9wGW3hWxG0I+i/8ww5nwGjKGM+uxNgjZ1sQ5vJ7NY9PsDom4?=
 =?us-ascii?Q?+cKjJqW50vEuaD9W6q+a8p0P3gdbUqiOQoQogJIr5dn8OEMvBqHOLHEuN9sb?=
 =?us-ascii?Q?X5MfEnZWkqY6uN+qBe6osuMWlaOXM6ALUmmM9tkV/lkskEpE7CW7DdXtf3Ge?=
 =?us-ascii?Q?hBqhIYd7Wirtup+Qo49gXT9NxubOGeeGMw0Qn6rvUYLThxAAjn7swIOuJwGv?=
 =?us-ascii?Q?JwhSrh9Q9Gd2Er+m+R7xKMv1KdJJALJdtShOIEGRFNj0IipLRD/3k4NFUFjT?=
 =?us-ascii?Q?x5USGmnZTx3K0TpTaNBbA04PNLfTRZBe0+/e5Bk444STk7IgMGbHq/QaIQci?=
 =?us-ascii?Q?lzCGA9CF2OPeVWuaCOFgJU0Y4w3ScTBDIkwPrSqVBf+8tL9Ic96lXMgb5QhI?=
 =?us-ascii?Q?fuMfGuU++s5MZ+yTIBl/GizHVNcFQXbfKEwdONtdZAr9F5McD6lBOFVgbRqp?=
 =?us-ascii?Q?e07oIJO7oPNVSyESKq21V3bWQKJnBvSn5eXzvc2bicp6eArWSVAH6seuGA9a?=
 =?us-ascii?Q?96kiF1EPmWpzjVEK3kXEzgpoMtThqt4bs+C8uFY+D6+xyJHwfGOSpFz74HUY?=
 =?us-ascii?Q?NZtnXfHGRRu5Lg94mjWWZrVGTh7273BTWxl1cfO6tpHMKTGfZCZZU4UDqpan?=
 =?us-ascii?Q?wHAJNDRsxxMp6YdSxjm/u1oMl+0sXHNSjfJi8Ox6qx5Y3QXJmtCBLn83LjTj?=
 =?us-ascii?Q?a8cJu3aZx95FTBBbitKx0ZYs3TrGbCjsXiCppX1YcoKXzfld8URyTpQlxbh2?=
 =?us-ascii?Q?CuEUAWStN/l14HuhW6MpT7qpvKlalhNZBfxd2GettSS6MLWkza2HgQMAGHs1?=
 =?us-ascii?Q?WWqiFSG04SgZI5tA8ftOmFQCq8aJouJBtJ5zyylCgW6kFjD8+HL5HN0z1DqA?=
 =?us-ascii?Q?l7NpktjVGk5s/SgMVzW4Pm64dqVd9jiN4uvsqGjLdX2Wu/yO/9D03kxnTlbf?=
 =?us-ascii?Q?q5jT6JLNbG10XWlSSteDXToc9XWfZbyEfxj6ptSpS6pBI+O61iRwvSWWJdau?=
 =?us-ascii?Q?d9vtp0WSgRz3rytgeY1dsvgc9mwkEcmOYy/t+zd/PjHtN0E4zJacLY/19BnG?=
 =?us-ascii?Q?VAMhwuyIDyxaw5bpcH/WMQVm3M/scg74IoIkTpJYb75pSIfoQkwPLg/bCOU4?=
 =?us-ascii?Q?/+Y41cG8XQkX7/as4KRcM0Q5pxekctQS8jMDRaLf64vb3XG6K63U5/SZ47LJ?=
 =?us-ascii?Q?ZKQ5apu0Rri0vIs54a06oGMexcT73nZkOeWpt6tfyheGJ7qk2BVDw2QK6fND?=
 =?us-ascii?Q?5EZeXCxsmD5n7QnhpGePsk/7NzuFddR1kiVtxoyHs6dXParc810Ur0xNOZLF?=
 =?us-ascii?Q?zVlbNOnKKF9L5fcpo1H2+jC7QdSluupBmsWiyXoWEDBu9ILLb9cLP6xhtTak?=
 =?us-ascii?Q?dsBG/IKfiEjyypWWwEk64NigOcpRh4FYGG4dYyNLoLm+U+i/ycw++lOmqCGo?=
 =?us-ascii?Q?jl1fM8ema0nYXkTQDauK9ry8ezC0sNyQ0i47iE6LoccYGRUPEpkjpLL0kjwd?=
 =?us-ascii?Q?Ws5IIiF9+UcN/4RNE6rSEbhdUsAnrafS358M30ryCKVQaDzfxye/ob1SXOy0?=
 =?us-ascii?Q?Ybvo/DTNLMJxRdm9fQripupBnTCQmsHSIUGWfmMF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33f84cc-8336-4aa7-c17b-08dab7fc798e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 09:20:22.5074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V3XqdK9lHdLJbeAFNxiLrwtdxzEREjlVzqRMQv+OzmOhzLRbAPdNQkQZ3fCQfPN6SEpkZJk3M6jM+t4qw/cfBUoqouqpsoVlMFcYL6tlts4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Wednesday, October 26, 2022 7:55 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; David Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; Czapnik, Lukasz <lukasz.czapnik@intel.com>;
> Palczewski, Mateusz <mateusz.palczewski@intel.com>; G, GurucharanX
> <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net-next] ice: Add additional CSR registers
>=20
> On Wed, Oct 26, 2022 at 04:28:39AM -0700, Jacob Keller wrote:
> > From: Lukasz Czapnik <lukasz.czapnik@intel.com>
> >
> > Add additional CSR registers that will provide more information
> > in the dump that occurs after Tx hang.
>=20
> So...where is the corresponding commit that would actually utilize some o=
f
> these additional regs? :p
>=20

I'm not sure I follow your question. This commit adds the registers to the =
ice_regs_dump_list which is used by ice_get_regs_len and ice_get_regs, mean=
ing that their contents will be output when you dump registers using ETHTOO=
L_GREGS. We don't need any other driver side work to "use" these as its jus=
t extending the table of what gets dumped.

I guess we could extend the userspace program to include the set of registe=
rs along with useful names? @Czapnik, Lukasz do you have such a patch prepa=
red?

Thanks,
Jake

> >
> > Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
> > Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> > Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at
> Intel)
> > ---
> >  drivers/net/ethernet/intel/ice/ice_ethtool.c | 169 +++++++++++++++++++
> >  1 file changed, 169 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > index b7be84bbe72d..f71a7521c7bd 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > @@ -151,6 +151,175 @@ static const u32 ice_regs_dump_list[] =3D {
> >  	QINT_RQCTL(0),
> >  	PFINT_OICR_ENA,
> >  	QRX_ITR(0),
> > +#define GLDCB_TLPM_PCI_DM			0x000A0180
> > +	GLDCB_TLPM_PCI_DM,
> > +#define GLDCB_TLPM_TC2PFC			0x000A0194
> > +	GLDCB_TLPM_TC2PFC,
> > +#define TCDCB_TLPM_WAIT_DM(_i)			(0x000A0080 + ((_i) * 4))
> > +	TCDCB_TLPM_WAIT_DM(0),
> > +	TCDCB_TLPM_WAIT_DM(1),
> > +	TCDCB_TLPM_WAIT_DM(2),
> > +	TCDCB_TLPM_WAIT_DM(3),
> > +	TCDCB_TLPM_WAIT_DM(4),
> > +	TCDCB_TLPM_WAIT_DM(5),
> > +	TCDCB_TLPM_WAIT_DM(6),
> > +	TCDCB_TLPM_WAIT_DM(7),
> > +	TCDCB_TLPM_WAIT_DM(8),
> > +	TCDCB_TLPM_WAIT_DM(9),
> > +	TCDCB_TLPM_WAIT_DM(10),
> > +	TCDCB_TLPM_WAIT_DM(11),
> > +	TCDCB_TLPM_WAIT_DM(12),
> > +	TCDCB_TLPM_WAIT_DM(13),
> > +	TCDCB_TLPM_WAIT_DM(14),
> > +	TCDCB_TLPM_WAIT_DM(15),
> > +	TCDCB_TLPM_WAIT_DM(16),
> > +	TCDCB_TLPM_WAIT_DM(17),
> > +	TCDCB_TLPM_WAIT_DM(18),
> > +	TCDCB_TLPM_WAIT_DM(19),
> > +	TCDCB_TLPM_WAIT_DM(20),
> > +	TCDCB_TLPM_WAIT_DM(21),
> > +	TCDCB_TLPM_WAIT_DM(22),
> > +	TCDCB_TLPM_WAIT_DM(23),
> > +	TCDCB_TLPM_WAIT_DM(24),
> > +	TCDCB_TLPM_WAIT_DM(25),
> > +	TCDCB_TLPM_WAIT_DM(26),
> > +	TCDCB_TLPM_WAIT_DM(27),
> > +	TCDCB_TLPM_WAIT_DM(28),
> > +	TCDCB_TLPM_WAIT_DM(29),
> > +	TCDCB_TLPM_WAIT_DM(30),
> > +	TCDCB_TLPM_WAIT_DM(31),
> > +#define GLPCI_WATMK_CLNT_PIPEMON		0x000BFD90
> > +	GLPCI_WATMK_CLNT_PIPEMON,
> > +#define GLPCI_CUR_CLNT_COMMON			0x000BFD84
> > +	GLPCI_CUR_CLNT_COMMON,
> > +#define GLPCI_CUR_CLNT_PIPEMON			0x000BFD88
> > +	GLPCI_CUR_CLNT_PIPEMON,
> > +#define GLPCI_PCIERR				0x0009DEB0
> > +	GLPCI_PCIERR,
> > +#define GLPSM_DEBUG_CTL_STATUS			0x000B0600
> > +	GLPSM_DEBUG_CTL_STATUS,
> > +#define GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0680
> > +	GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT,
> > +#define GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0684
> > +	GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT,
> > +#define GLPSM0_DEBUG_DT_OUT_OF_WINDOW		0x000B0688
> > +	GLPSM0_DEBUG_DT_OUT_OF_WINDOW,
> > +#define GLPSM0_DEBUG_INTF_HW_ERROR_DETECT	0x000B069C
> > +	GLPSM0_DEBUG_INTF_HW_ERROR_DETECT,
> > +#define GLPSM0_DEBUG_MISC_HW_ERROR_DETECT	0x000B06A0
> > +	GLPSM0_DEBUG_MISC_HW_ERROR_DETECT,
> > +#define GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0E80
> > +	GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT,
> > +#define GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0E84
> > +	GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT,
> > +#define GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT	0x000B0E88
> > +	GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT,
> > +#define GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT  0x000B0E8C
> > +	GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT,
> > +#define GLPSM1_DEBUG_MISC_HW_ERROR_DETECT       0x000B0E90
> > +	GLPSM1_DEBUG_MISC_HW_ERROR_DETECT,
> > +#define GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT       0x000B1680
> > +	GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT,
> > +#define GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT      0x000B1684
> > +	GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT,
> > +#define GLPSM2_DEBUG_MISC_HW_ERROR_DETECT       0x000B1688
> > +	GLPSM2_DEBUG_MISC_HW_ERROR_DETECT,
> > +#define GLTDPU_TCLAN_COMP_BOB(_i)               (0x00049ADC + ((_i) * =
4))
> > +	GLTDPU_TCLAN_COMP_BOB(1),
> > +	GLTDPU_TCLAN_COMP_BOB(2),
> > +	GLTDPU_TCLAN_COMP_BOB(3),
> > +	GLTDPU_TCLAN_COMP_BOB(4),
> > +	GLTDPU_TCLAN_COMP_BOB(5),
> > +	GLTDPU_TCLAN_COMP_BOB(6),
> > +	GLTDPU_TCLAN_COMP_BOB(7),
> > +	GLTDPU_TCLAN_COMP_BOB(8),
> > +#define GLTDPU_TCB_CMD_BOB(_i)                  (0x0004975C + ((_i) * =
4))
> > +	GLTDPU_TCB_CMD_BOB(1),
> > +	GLTDPU_TCB_CMD_BOB(2),
> > +	GLTDPU_TCB_CMD_BOB(3),
> > +	GLTDPU_TCB_CMD_BOB(4),
> > +	GLTDPU_TCB_CMD_BOB(5),
> > +	GLTDPU_TCB_CMD_BOB(6),
> > +	GLTDPU_TCB_CMD_BOB(7),
> > +	GLTDPU_TCB_CMD_BOB(8),
> > +#define GLTDPU_PSM_UPDATE_BOB(_i)               (0x00049B5C + ((_i) * =
4))
> > +	GLTDPU_PSM_UPDATE_BOB(1),
> > +	GLTDPU_PSM_UPDATE_BOB(2),
> > +	GLTDPU_PSM_UPDATE_BOB(3),
> > +	GLTDPU_PSM_UPDATE_BOB(4),
> > +	GLTDPU_PSM_UPDATE_BOB(5),
> > +	GLTDPU_PSM_UPDATE_BOB(6),
> > +	GLTDPU_PSM_UPDATE_BOB(7),
> > +	GLTDPU_PSM_UPDATE_BOB(8),
> > +#define GLTCB_CMD_IN_BOB(_i)                    (0x000AE288 + ((_i) * =
4))
> > +	GLTCB_CMD_IN_BOB(1),
> > +	GLTCB_CMD_IN_BOB(2),
> > +	GLTCB_CMD_IN_BOB(3),
> > +	GLTCB_CMD_IN_BOB(4),
> > +	GLTCB_CMD_IN_BOB(5),
> > +	GLTCB_CMD_IN_BOB(6),
> > +	GLTCB_CMD_IN_BOB(7),
> > +	GLTCB_CMD_IN_BOB(8),
> > +#define GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(_i)   (0x000FC148 + ((_i) *
> 4))
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(1),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(2),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(3),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(4),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(5),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(6),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(7),
> > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(8),
> > +#define GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(_i) (0x000FC248 + ((_i) *
> 4))
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(1),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(2),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(3),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(4),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(5),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(6),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(7),
> > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(8),
> > +#define GLLAN_TCLAN_CACHE_CTL_BOB_CTL(_i)       (0x000FC1C8 + ((_i) * =
4))
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(1),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(2),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(3),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(4),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(5),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(6),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(7),
> > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(8),
> > +#define GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(_i)  (0x000FC188 + ((_i) *
> 4))
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(1),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(2),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(3),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(4),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(5),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(6),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(7),
> > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(8),
> > +#define GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(_i) (0x000FC288 + ((_i)
> * 4))
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(1),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(2),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(3),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(4),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(5),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(6),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(7),
> > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(8),
> > +#define PRTDCB_TCUPM_REG_CM(_i)			(0x000BC360 +
> ((_i) * 4))
> > +	PRTDCB_TCUPM_REG_CM(0),
> > +	PRTDCB_TCUPM_REG_CM(1),
> > +	PRTDCB_TCUPM_REG_CM(2),
> > +	PRTDCB_TCUPM_REG_CM(3),
> > +#define PRTDCB_TCUPM_REG_DM(_i)			(0x000BC3A0 +
> ((_i) * 4))
> > +	PRTDCB_TCUPM_REG_DM(0),
> > +	PRTDCB_TCUPM_REG_DM(1),
> > +	PRTDCB_TCUPM_REG_DM(2),
> > +	PRTDCB_TCUPM_REG_DM(3),
> > +#define PRTDCB_TLPM_REG_DM(_i)			(0x000A0000 + ((_i) * 4))
> > +	PRTDCB_TLPM_REG_DM(0),
> > +	PRTDCB_TLPM_REG_DM(1),
> > +	PRTDCB_TLPM_REG_DM(2),
> > +	PRTDCB_TLPM_REG_DM(3),
> >  };
> >
> >  struct ice_priv_flag {
> >
> > base-commit: d0217284cea7d470e4140e98b806cb3cdf8257d6
> > --
> > 2.38.0.83.gd420dda05763
> >
