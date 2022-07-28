Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043F95846C3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiG1T6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiG1T6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:58:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB61EAF8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659038284; x=1690574284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A+bWJKlA4GZjdpfNCT959hcQAigWm8QFnDjpMGLiSk4=;
  b=CbrClalVEiO+wn0wLA5P0KXJC3BzeA03Wjb0gcWYaIbZHKaK7o2Udptd
   GAX2i4ozQrJ85HjodcMFri5GeHuMatCRUL+kc1UDsI12KqeF+C76cJ8O0
   cPPoyEwmyGEfh6d00cODCiCA8eq0b14OkRbaxFX5lUVG0aW06Af4TFm7/
   OzgePxRxiGzWqyZ8BVQh2T3YpgFFuoYaXPJcAkrp5JEHLzfUIvzF14DLs
   C6VKdxadDqo2pYuiJ80QirZoZvAVFuNrXPSCJrNU8syUxSk7hmVeQ/+13
   ts7pT9cBfK9IWk8dqlZZVwZbC400iPPk2DfnwNp+ZSNx32PBB5CuQlDBD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="374907084"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="374907084"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:57:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="690465258"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2022 12:57:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 12:57:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 28 Jul 2022 12:57:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 28 Jul 2022 12:57:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ze6NIgJsCiI+diPZ1Hya/fQDzWgSl+mlPFpabta9Nekizp1oqm8a5Dbirrty2X7duNGeAUgYy5r7iTc3hOjYszaPlfOjwUzy+5c8m/KHgQSB9v8RkWEAjiFTDEFEbyUhsIxJxEqoQeun+mLzBFLqmBHU1wd8SwDctz4DwtCaQKX2ZyiLaqwlPNeNjACzUiEjGCZngobzvmiM2LeqwcYVoHMmdeMxP5ezfiQgHBJnF0h4thhSXl/fTTtL4fK8PpOl2h5Gfq3suTpyTUxdrNeWPof7xKzPQkDt+RN+vGNJP+fK1hrQYpWflMZbYgLyZbuM9PaPIG0NlJzn13ESQn/eUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQgVu1e6VsGsSxy1cDcITwuYnIYhQgK5ZPBIy6s92OA=;
 b=DH/904f/iTDFf1UXnoVK+vdRCX08LEXta2GAjlY0aRCkFrVZ9qLWWx06fKoQgzpJOmECt/aE5WqLRP1e6JbZ4J5MijM3s3VUyuSYGLvDe8d+PZsFozv1wI3j7FVRYXL0nH8gXyvmqcNLukFaUbZz0yWXmcAguZrnhaYlKZVcV61yB1YX7wP37M4eOgV/dRBhO5MmyyY37liJscNbYrCghiPXePazx5060s2Lwa2Se9U+nTpb5GlN4MIjeR/XU26ocTK45BVjMbAoyYr5y6+ZUg35iNXz2qgbbF2fQ5Xv5hgReoFArhCxjoO0saSWx3dvY1c8Ef5uZ1XZGRo66GDfQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by MN2PR11MB3646.namprd11.prod.outlook.com (2603:10b6:208:f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Thu, 28 Jul
 2022 19:57:45 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::2139:9648:f6e8:dafb]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::2139:9648:f6e8:dafb%5]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 19:57:45 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Zhang, Xuejun" <xuejun.zhang@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
Subject: RE: [PATCH net 3/3] iavf: enable tc filter configuration only if
 hw-tc-offload is on
Thread-Topic: [PATCH net 3/3] iavf: enable tc filter configuration only if
 hw-tc-offload is on
Thread-Index: AQHYoEkakxPjj3e550OxoS73DH+LTK2P8wuAgALdkyCAACyCgIABG17Q
Date:   Thu, 28 Jul 2022 19:57:45 +0000
Message-ID: <IA1PR11MB626675129982A482E03ED0C3E4969@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
        <20220725170452.920964-4-anthony.l.nguyen@intel.com>
        <20220725194547.0702bd73@kernel.org>
        <IA1PR11MB6266229ADD3AF60477F4FE04E4979@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20220727181039.19c7622a@kernel.org>
In-Reply-To: <20220727181039.19c7622a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bef1754d-8546-48fc-ee6e-08da70d37064
x-ms-traffictypediagnostic: MN2PR11MB3646:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RLoaVDFgb1lPFYBRueca9d4ieMQn3a2NXsg2L+gnkBYl+/22peNkWiMtX0sUGtzTmHC1seDVTAxL1AWhA9tpZdbAJrDYNYb927N+4BH0AhysJfvnyMj0U+X6Am1K10MfRclgJHIIBU9nGyjteBcEL+5FRQIs/BZMJvjAtTrCIEwWyhiZa7jX8BG0+jxryUSIzGRuHFWYkNV8rQGMPh/eFjclwGbb4FO0o3J91HqHazhKGXi3MxOrfaQFJJOetCLpGTbUsPkRAQdaNY6jGmdacbjHICRcSA9uxPg6+dTucH/VqPQDWSxmq0SjiTIULA40bmsgvMROE4qmTV9bFYQ16/cjFpRiIz2aesxNPqK1pE9hu7gC1yY9duOzY5A54mdEu9kK//zC65aeU8vL7GUmso9uRAT/KT7/r8fD1FJbZoGuQPCR77tfFNo0VubZKt2Lyjsjihwt+rJZclFuSplL6XU14P+ozgwsku7Vo7pT+xhJHHRYH8t6U/B6hvGzoSq9jxIfKnkPxDwqC6/GaSYAg06czB3VZYiI7tIIe72GU66p/pkGV2K7dCvI2BSHnSGR7rf/DYB/iD3NeXl1WRrcZ4uqWR1XWUjshlwcS8URh1HJnldoixMJmlRg8IC+GyByi8TN8zfs+cNK3QMl4ryLgGBb1VmS1HvPt02Vua8fD/ts2W4vGP1dsnAsyCAprr70No5Q4wfV/rrZXN1rHx3aWhnKPSMmzTaIPatz0D+rEXx9GNUdvbzzyV+fzPOqJVr2hBz4uLh/JGQCjq6X29QvzLfGDfnv62v9M3xrv8Dl9pv7kQ6voQCdWFHpq4NPM1P5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(366004)(396003)(39860400002)(38070700005)(186003)(316002)(54906003)(83380400001)(6916009)(55016003)(82960400001)(122000001)(38100700002)(66446008)(26005)(33656002)(66556008)(66946007)(9686003)(478600001)(76116006)(53546011)(52536014)(66476007)(5660300002)(8936002)(4326008)(6506007)(2906002)(7696005)(41300700001)(107886003)(71200400001)(86362001)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LfYcZFlcJAKAITtumqf8+fQx1z3U34GvR3dWfMmh29b8Ip6TX7xdiujWofhz?=
 =?us-ascii?Q?gvB+EcqV/KpDrudakIspC5OeN9VjL1rPZHxZSqlJDEzDhbR4I7aM/W0SIOlO?=
 =?us-ascii?Q?/G4oNevdU6AGSWdfSnlGu+o59CO4/C/wnTtthzdaGPIMWki3Xsned1V05lMP?=
 =?us-ascii?Q?pV7j8yKcP4whCJ3EAO13BhxMHxvfDPBk7+zZ+xIuM6X2DQN3rb+6PvSOVA8m?=
 =?us-ascii?Q?SKx0rOUHFdxtuZixxu4AnjZPiivU11z/8QvhUQuYF2hJRqu40x+uM+6OKcW6?=
 =?us-ascii?Q?rMX2BP5PtZxvQCNr0hWMwQAFCIH1J7a1HxmEIPl61om5X3b2eKJUdu//AYoF?=
 =?us-ascii?Q?9VpghG6PmPD2CyCK88zFpekY7Ns4lWZc1Rzpg4AZBEanX5q7fhVphDjvmeTz?=
 =?us-ascii?Q?UdE5cLpjAfYympIIKOLldD24O8QwFv0NEaqU5S1FdRifIunetrQoTsAvzq1Z?=
 =?us-ascii?Q?pJqYo4BE25+Lf1X50+qlbq8YBmSUBJGrXcCAD+hgaotibm2YX75764HlHY4X?=
 =?us-ascii?Q?DD8G/BxySTSNscA8bkmbxHKEJmq7D9DYO8/XR31gVR/oTrmneQ1s7E758h52?=
 =?us-ascii?Q?bpoAWtadtgGtSKh7t/ubsou5B0rxbp92KIdFTxw//RqENj5Num4SyxEeSWL7?=
 =?us-ascii?Q?KPPbcit6mFSxMdt5m0Pn4snoXaQb1cOuPRKRVW9kr/F2Z/qct9ob76Yix3IX?=
 =?us-ascii?Q?QyxsIFJvreuTq2Hi6OAojnzbU2GY5KE7RxJgNIVMFmmV6RnoENMLBM3eJB6m?=
 =?us-ascii?Q?82XnnaxF0dGfVOWmXAeobjODZ4EkCTcYOHOcvC2vkGbpzAkpv3Hp6icje9ID?=
 =?us-ascii?Q?LuzI/7l7k5mCJ2SN0hl7HIm/dd/wGwkJ+TtlS0If6ILexJ2dQongdT5E0I45?=
 =?us-ascii?Q?zZ6Djyeep1TVSswE7V5KQUXosnLm2ZdFzhCOWHCrg8Qz3wtZtABs53BZyvQK?=
 =?us-ascii?Q?J9/itkDT4yxmyQ6Enyw/7v6hPW1Oz8ICdoA1XWsuAzFuQXz2p5OvHTRT2ZVk?=
 =?us-ascii?Q?5tMMXvTrwu1AAfZBQkOvmF9TDz/dI3qAISLpmSxtTfcGLICK3MQQNQQow4ac?=
 =?us-ascii?Q?NJ7yWldrUiOI5dlyj49VZ6xlmzJ3TqjwrjzOW9hWK6YyGAr/x1eSGOdq9+bB?=
 =?us-ascii?Q?jjWoaapsI2QHiExqQlLXPY7HbpdN5RDfYKSQ/9QkFo0JruFfH1v6JmtmVY0Q?=
 =?us-ascii?Q?KAZuUfuWdPzBBwzgo1nDkmOsxbVhKV0sb84QrMyNtw8Dy6Fy4cWVsBNx58T/?=
 =?us-ascii?Q?J4IPGBjNVLQ2fl5942zPyPQnJfNHstVzE6p2W6Hq6e3eeiZW6m5QWEWndCUx?=
 =?us-ascii?Q?BMkEIvmlRQr5IqVrjGHZpKSmp4/QMbc8Di8LQkUhCv7lUBtKK4vVypOPaINV?=
 =?us-ascii?Q?jJjZzhCAo230J1nfMe1qnfaiIFNXnPttfxJ6rEkcChSdLLQMFBV3DYgbec4+?=
 =?us-ascii?Q?cvClLev2fm7HGEOL55ngmgIWIkQocJbfdU9ZcySWgS9rCNh2b0nrzxnBDj1z?=
 =?us-ascii?Q?WPZrz9I+z1Bb1M8neAVgpUK1dWqSF2Im/7rP5POaGDLDT1lYxIb13Jf9GnbR?=
 =?us-ascii?Q?g/Rvhaf5mA3SWcJ44jMigpMJmJHkq3LADPIVo780+MwAFiBomQVXvNxc7x2r?=
 =?us-ascii?Q?WQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef1754d-8546-48fc-ee6e-08da70d37064
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 19:57:45.2259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fo8PVBcJ+PmAhXs4NNk0EvcocmnkjSfcZE6gSg7uCxtBKslpmzrTfsSwAyHgi0siml+JvYfo1tZIFBmpaQy2wKCW8KQFMb0ufAY0k+wwLsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3646
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, July 27, 2022 6:11 PM
> To: Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> pabeni@redhat.com; edumazet@google.com; netdev@vger.kernel.org; Zhang,
> Xuejun <xuejun.zhang@intel.com>; Sreenivas, Bharathi
> <bharathi.sreenivas@intel.com>
> Subject: Re: [PATCH net 3/3] iavf: enable tc filter configuration only if
> hw-tc-offload is on
>=20
> On Wed, 27 Jul 2022 23:37:27 +0000 Mogilappagari, Sudheer wrote:
> > > > +	if (!(adapter->netdev->features & NETIF_F_HW_TC)) {
> > > > +		dev_err(&adapter->pdev->dev,
> > > > +			"Can't apply TC flower filters, turn ON hw-tc-
> offload and try again");
> > > > +		return -EOPNOTSUPP;
> > > > +	}
> > > > +
> > > >  	filter =3D kzalloc(sizeof(*filter), GFP_KERNEL);
> > > >  	if (!filter)
> > > >  		return -ENOMEM;
> > >
> > > tc_can_offload() checks this in the core already, no?
> >
> > Hi Jakub,
> > Seems like there is no check in core code in this path. Tested again
> > to confirm that no error is thrown by core code. Below is the call
> > trace while adding filter.
> > [  927.358001]  dump_stack_lvl+0x44/0x58 [  927.358009]
> > ice_add_cls_flower+0x73/0x90 [ice] [  927.358066]
> > tc_setup_cb_add+0xc7/0x1e0 [  927.358074]
> > fl_hw_replace_filter+0x143/0x1e0 [cls_flower] [  927.358081]
> > fl_change+0xbc3/0xed8 [cls_flower] [  927.358086]
> > tc_new_tfilter+0x382/0xbc0
>=20
> Oh, you're right, we moved to drivers doing the check it seems.
>=20
> But you already have a check in iavf_setup_tc_block_cb()
> - tc_cls_can_offload_and_chain0() should validate the device has TC offlo=
ad
> enabled. It that not working somehow?

Hi Jakub,
You are correct. tc_cls_can_offload_and_chain0() check in iavf_setup_tc_blo=
ck_cb()
is taking caring of it already. So, this patch is not required.

I had tested with ice driver since it was same as iavf wrt this check.
We will modify ice driver to use tc_cls_can_offload_and_chain0().

Thanks
Sudheer

