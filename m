Return-Path: <netdev+bounces-10886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 313D2730A70
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6103F1C20DB3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACBC134D5;
	Wed, 14 Jun 2023 22:11:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12562134A7
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:11:44 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C49A6;
	Wed, 14 Jun 2023 15:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686780703; x=1718316703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2/x/fGxVvPuT0zbA0XVeB+wisbpLZqBZUVieyd/MnbQ=;
  b=PrSiSPTBKm3CdIJOi6A3GdfAVQ5yjJgR6LCBf4aFhO8ufGguWKxMtcSh
   yg/cp7g/N2J5UBonUo5h9hKJxKFG4+Ng6OO3c76i4vgxjUi86XqUndAF0
   0rk3lqw8sy/2wI0EJ29aD5BcAwBSCSYcsGPwTFMdsq+tzL6g6sc9ctMjr
   KKmiBdeC847hlX8MLUKKfTNbap7uZhLvlq2AZaSb17Ne4r370r/2Qim0z
   fbSKfOD1PhOvSFnVmwgie37dC3zVH7w1yUWxnCchHEshETktAdNNPp5rn
   SWSInedpt2FP/y59GguYLtcUN61RJOQuNLPTwlwLT+yUHG7GRy1lhGlky
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387160575"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="387160575"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 15:11:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="689546503"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="689546503"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 14 Jun 2023 15:11:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 15:11:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 15:11:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 15:11:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdlQs+TdLORVULmiWgJRkXzsPbKPIYVzwOCQZwaVCGD1rBw5wJ7YgH5IL77Nqud8nZjKknzY6ckQmuOZ07IVrdNFTOOQtf87cibLoDCd9+ezKb53F6HaAzy5xy9Og1qPG0VEYeoboh/90GcfFEDdr+sfQB5AduXiBjp3wwS3kV1HnLVdx1dWrqmtW0sbma7qMLieQBAf6KIPyKuW6y0SkZTRZiw/9vLYTWfPCRBv/xWsAQA9NJ/1C2nuGbuXPVEbX23pF3MhzFnhEMuuWfO4kAo5b92ZOh7dRzM08A9aqPu3NAuyg2rv2QQ85C0mdNFQXbf+qx/eryPgMDe11vAhaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNVSPACubiQWi3+PQOkgJ6GqwKuirn2b4FwTcBcuWps=;
 b=ms+IEfLUfO5Az/7xVRj0M6kZFb410vOokt/2m8Y45VCfPe0ezlJyxFibhDzO2PB8sZobEePLE87HC4lsEjOsHqT/3xkhLu4sOuegGm1Vq58XdJxlA0skh/LuiorgMERm5mbY90b9xd2t3nQGH3h80R5fmd0GSqqIP6pEBhl0VzR0L94TdWYA23oaJ4aF2ghfok+cV6LC0ApcyB3BppCm9pAdaNbaT9LeS18sui/gJJXO0CSkqwi/5cJqCzpPHucEa2VPxm7uzCoqTfbDbjNJvGUpT/jfbPVn1qDHRM1dOjDjlQ8R3uz8dFWxJDtcrta8i+wWExSqAs7b0uWF+weG2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SN7PR11MB7140.namprd11.prod.outlook.com (2603:10b6:806:2a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 22:11:39 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 22:11:39 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: RE: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Thread-Topic: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Thread-Index: AQHZnk2DP+viVSY2G0+N2yPHRycjpq+JelUAgADC5aCAAFRWAIAAQ+mA
Date: Wed, 14 Jun 2023 22:11:38 +0000
Message-ID: <DM6PR11MB4657A5F161476B05C5F8B7569B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
	<20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
	<20230613175928.4ea56833@kernel.org>
	<DM6PR11MB46570AEF7E10089E70CC1D019B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230614103852.3eb7fd02@kernel.org>
In-Reply-To: <20230614103852.3eb7fd02@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SN7PR11MB7140:EE_
x-ms-office365-filtering-correlation-id: 86f19c00-56c7-46a4-e137-08db6d24536a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3mNwOgVUAfpKSkJhSNQDA2saO0kqPl1VTB66b6fIt56C0Viw+1dVZBi2zrYEBktx4JzSnGBn4GCJD9384JJhPPjkb/OWwyRnh9npD3p0v4LRvToyUZuGevPEwLMdy/A5xWaSOKUCJqNPnX+Z18xunnArh96a0svMQB3HZsesrvyqRzK74nIyS5f8zTvePBX4anUwvVMnzKzY2ku0u3IBiiDVc6cg4TRkURmzHaDC9PzsMI9vHiOD6YhRehB5fqcMdpzbQzl9Ofjm3iSUPfnO2X48ghyJkPZoaAniyq3jTarb0wfpRZ5A/IKDkkbFYAiDf8Ir0tcys5QRvnBnPk8b+MvSmRhrOuXFMo1LO4/satiX0cECI38PD4EOuilFEtLsrZoSRAy4Wsd/4W7ET5+jnSwSLzBdj6eLuGR4aECCFrysG/EE5GRObjFBSmms/ljBDHhU9MOTL58YhfN3OSU0BhDzqL81V++w2YvpQ6781pQW9szLkJPFA1/hnvazt0X3Mo24gBcYoHyG9kfjn06vhNj3mC/pED2/BtCWwMp3rzxivpbH6Arj/MH/apODbSub8gEm3ztc12SeKrsoV+UGW3QJxxa+FPpa6nr/Q8rrHzw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199021)(83380400001)(5660300002)(52536014)(186003)(55016003)(6506007)(2906002)(41300700001)(8936002)(9686003)(7696005)(26005)(8676002)(316002)(122000001)(54906003)(38070700005)(33656002)(82960400001)(478600001)(38100700002)(4326008)(76116006)(66556008)(66476007)(86362001)(66946007)(6916009)(66446008)(64756008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gzctWfywOWVrvKDCsN1J11hTq+8rCvBqJzw0ZP+Xw+cR1AXSSCjJ+LT90HYb?=
 =?us-ascii?Q?YxgtjVJ/07rHw7ueumhh6gwSpQ/7HEqqHqxXa6r1nW9EhmgcyJKSEUNryxEP?=
 =?us-ascii?Q?M6SYKGkWam2AOFXNpfQosIl/JWPBGioAS/d6XdIDBKdjeUEutMC8JzyDlr6z?=
 =?us-ascii?Q?L2g0Ub/IxSipFTqyhO0oBpQo5s9CuT5fdQmRnlzF2iHnvwgLCFmfQSsz/utm?=
 =?us-ascii?Q?MSABI9MIEORb4n3etzBV+9wOCPEqMuz7OqV51aTJ8fiWZ+xca/KUPAlDcIaP?=
 =?us-ascii?Q?+pFqwFiN3sEgSajF8QiByghOqf6JOK69bnoFKQl7voDks/Y9MUniZqtWokQt?=
 =?us-ascii?Q?/SYq51r8Hx82kC4WDqxbuUGbinMPEiPTM36sEONa5rKyBN7RTCu9fnYT3X0U?=
 =?us-ascii?Q?ud4fhgO98s6tpPC+ZwdYoKwzSiV2tx3j9tlCtBEU6TvWzd2/1i6N5AqVhDnO?=
 =?us-ascii?Q?TdrXPpm8jd4pX81jPPlrhXN6jJKy8Hqe8LnjSBqBc+TWOrn+lQig1ByghV/1?=
 =?us-ascii?Q?LzZnyP96WgJobU7JIl4cFdqWPII2du8IbcfnFKh/JJnfMvVyRWPTDAj0ri7Y?=
 =?us-ascii?Q?hr7Ix6DXjZc4nQyASKqdSDDaFRHLyVvsXRKQlD9V7RaMGMPmXEuBu9qIspY9?=
 =?us-ascii?Q?WgYxognvxMce/VwAIVetdxEf5FkLBf+7qAjqmeIzsBTDVQZEaeABHlngAw1k?=
 =?us-ascii?Q?x5oBVBxqLW08jsEUWkIZwP3tz9PqxjjYrpwW58FgNIAtImig/ZxEyCB1t/LQ?=
 =?us-ascii?Q?r8wNS+zS6VGft5HgR2OT4o0wJ3ClQka4zF6KdVtMURom9LjFj8Jp6z+T7Nd2?=
 =?us-ascii?Q?kGLh/6b0qtgXjp5nTJ1SC0aThe+a4hfwPAFBALaAn1Bvgb56FHtWRoC6yD+l?=
 =?us-ascii?Q?QVakygaG63jCb7/JZwRI8qYVGCJOLf7NsLqTZMblHio2Oqc6QOTKNL/PdhwX?=
 =?us-ascii?Q?bpbvD6yNi1PaAgDnH8lA19J8KkwgzsxZxsuw02i4c6msi+S/c0BRzi8cS71d?=
 =?us-ascii?Q?Or/qobZtLOKXnVFZhQZm0YC+vgR6kYv47FofNVcny7W+/nAVMTx03ePjb4Kn?=
 =?us-ascii?Q?fdH78Foeagq+8KYQL/7XVUxGIeQxT4TqV0Kh6DvUGb/IywXeGgVTIP4pFErp?=
 =?us-ascii?Q?cXYYGQdCHgQX90hAJlTsL5k2lRKzDa35fgpw+zqPJtAM68Z/dZoN35bNug1A?=
 =?us-ascii?Q?fs1Fih68bxipJd0kNvyXXM1Vn0LcTZj8+M1SxYjx+OFV2tRFXwU1sf5uX6IT?=
 =?us-ascii?Q?yJzXoBb/lJcUzKzOhb6k8BnSKhvfVllAjvbk/A3Uc3TxMLl5sB81hfNZUfK+?=
 =?us-ascii?Q?Ed/x+S9Wgw8t4E4IPo5ZP9lbkkoYFX9E0N1WUwASvh7XThDo49rKwFCVMqbV?=
 =?us-ascii?Q?66AZWSTVw6cJpguTWAGjZA3xn6v8t1aD0IAZcCNJOUa434akfV8f1lRDeTdz?=
 =?us-ascii?Q?A8uGagZ3U221ygCnYkfc2Q8zPEGsa2WAVdRyvtmITPXb0d1pLd0VLoAQnCGE?=
 =?us-ascii?Q?e5f3+ykc+A61DgXWUsk5NjgdXXAXxAw802UR56abjFvkHDLz919NvAuh3azj?=
 =?us-ascii?Q?enA/CZR/S0/czl4J2GO5yk0QOnoZ5I5CJ/gPkHYQOAtSchxHPJmEp6zRtcDG?=
 =?us-ascii?Q?OQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f19c00-56c7-46a4-e137-08db6d24536a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 22:11:38.8784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IqGmeFNK93cEzJFuV2eRGwzTFlgY2navbT1qpUZ+pddzD7veDtQi84Z7LYa0kOABtc/ZW23isGBAAtTgu8HemVECq5Ng4KyhcjXAi3cimOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7140
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, June 14, 2023 7:39 PM
>
>On Wed, 14 Jun 2023 12:48:14 +0000 Kubalewski, Arkadiusz wrote:
>> >From: Jakub Kicinski <kuba@kernel.org>
>> >Sent: Wednesday, June 14, 2023 2:59 AM
>> >
>> >On Wed, 14 Jun 2023 01:17:09 +0200 Arkadiusz Kubalewski wrote:
>> >> Including ynl generated uapi header files into source kerneldocs
>> >> (rst files in Documentation/) produces warnings during documentation
>> >> builds (i.e. make htmldocs)
>> >>
>> >> Prevent warnings by generating also description for enums where
>> >> rander_max was selected.
>> >
>> >Do you reckon that documenting the meta-values makes sense, or should
>> >we throw a:
>> >
>> >/* private: */
>> >
>>
>> Most probably it doesn't..
>> Tried this:
>> /*
>>  [ other values description ]
>>  * private:
>>  * @__<NAME>_MAX
>>  */
>> and this:
>> /*
>>  [ other values description ]
>>  * private: @__<NAME>_MAX
>>  */
>>
>> Both are not working as we would expect.
>>
>> Do you mean to have double comments for enums? like:
>> /*
>>  [ other values description ]
>>  */
>> /*
>>  * private:
>>  * @__<NAME>_MAX
>>  */
>>
>> >comment in front of them so that kdoc ignores them? Does user space
>> >have any use for those? If we want to document them...
>>
>> Hmm, do you recall where I can find proper format of such ignore enum
>comment
>> for kdoc generation?
>> Or maybe we need to also submit patch to some kdoc build process to
>actually
>> change the current behavior?
>
>It's explained in the kdoc documentation :(
>https://docs.kernel.org/doc-guide/kernel-doc.html#members


Thanks for pointing this, but it doesn't work :/

I tried described format but still ./scripts/kernel-doc warns about it.
Same as 'make htmldocs' does, as it uses ./scripts/kernel-doc

Also, if the enum is not described in the header, the docs produced by
the 'make htmldocs' would list the enum with the comment "undescribed".

It seems we need fixing:
- prevent warning from ./scripts/kernel-doc, so enums marked as "private:"
  would not warn
- generate __<ENUM_NAME>_MAX while marking them as "/* private: */"
- add some kind of "pattern exclude" directive/mechanics for generating
  docs with sphinx

Does it make sense?
TBH, not yet sure if all above are possible..

Thank you!
Arkadiusz

