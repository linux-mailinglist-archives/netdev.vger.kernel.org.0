Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B755EF4DA
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 13:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiI2L7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 07:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiI2L7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 07:59:02 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419AD25E2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 04:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664452741; x=1695988741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MCJ/vlkIpEyT668alxvZM0+dWRjfgoFx7Xo648gUnJ4=;
  b=ArZcEulkVr0X4QqyJehM5tZtkHDlpplVxl07LNzNg0lZfw5BuBXfWabO
   hCe5ZOKwwPRA6P8iRAeVjg1Wqle2HfretlR+VtVZJLFVS2kCO4WxOquce
   5BaAY57JLSGxKwxKq1bunpJ+up2W/sTkbH1u5ybOl8yHY562M+cJmlo0h
   ZtCobZUP1oqejmzfW6lxZ35HKfABIZfWw0hF0ZTcZkrIoNTFsrq6iK58+
   P7pKamZp5AdS8YdHrPHCkVHULR5wTUg2OHwRLN/X+Hv3vln4M/8K/9EhQ
   8O9FmhsoM4YtqxouXytSYvyhegpkLg/nkXHfhsnyYOSyhqSWWr691Es+E
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="388153966"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="388153966"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 04:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="764688607"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="764688607"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2022 04:59:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 04:59:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 04:58:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 04:58:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 04:58:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpzMECQD/ZSt60go32u8AocMLteltGx+2MIsyjzoAkyGf0Ee8kOidRbfT6ApIRCutemxOWL2Ah4Fa4zWqO5PQHEgoJ6anhpw7cYHpC+iGQ6TtWeRGZ+1FYqWN/aGQ9yP0N1QkmcHtFqsp9obqZDQUvppx9yTQHyHlcyCjm+SnNptRhBcFEtDZqvmPND1gjd5YL7iIehKyi60oXAPQdJ+Xea4dzzvK3pbNQzuV5ErkdrPpU8JjG9X2Z2jLYwDOrhptM76c0sAIlxy2SepERfwtXtgH6Ywl9Q7Mxv2JzQHlPeeqwnO72TbWBVM0XJe9gG7Z7sTz0cvRbJ8Sjifv5/bRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCJ/vlkIpEyT668alxvZM0+dWRjfgoFx7Xo648gUnJ4=;
 b=aeMNQdvRucXu5SF3TNNO6FCvVZFtpCE3vWIbdfAP6RRMe9U6+tGyUyFC6+CVT7MVB1ov2S4WEr/3fhHLMNNHRX7VOIdthIUIK/uxo1cI2t9B54mV78aoURymtyRXttlNNVEXhtv8xVS0kYjRNH4uluYXJvTpnVxsfeaqU8zlrXRmGoJRBTyPgTIA50pjIzgP8yEU+NjhdsnyU7AzihzRmbFrC4baVBU3tT4AW0uHzNsXE0WQC5Wj3I0fmJMomgJovmJMlJbkhx2z4fOQiIkcGInWN8PQgxQlgL+uetWfUWoGqGKc5ji9uU5JWrbnfiub5cWtSUw/eP258G53l0ehWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5SPRMB0012.namprd11.prod.outlook.com (2603:10b6:930:3f::7) by
 CY8PR11MB6916.namprd11.prod.outlook.com (2603:10b6:930:58::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.15; Thu, 29 Sep 2022 11:58:53 +0000
Received: from CY5SPRMB0012.namprd11.prod.outlook.com
 ([fe80::44ae:7bcb:96b2:f2]) by CY5SPRMB0012.namprd11.prod.outlook.com
 ([fe80::44ae:7bcb:96b2:f2%5]) with mapi id 15.20.5654.026; Thu, 29 Sep 2022
 11:58:53 +0000
From:   "Jaron, MichalX" <michalx.jaron@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Thread-Topic: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Thread-Index: AQHY0ecWG2TpjKMUNEeOmACNWrW4Fa30D7eAgADI8pCAAAvaAIABT6pg
Date:   Thu, 29 Sep 2022 11:58:52 +0000
Message-ID: <CY5SPRMB001280F71009BE8356684179E3579@CY5SPRMB0012.namprd11.prod.outlook.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
        <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
        <20220927182933.30d691d2@kernel.org>
        <CY5SPRMB001206C679A78691032E6E73E3549@CY5SPRMB0012.namprd11.prod.outlook.com>
 <20220928071110.365a2fcd@kernel.org>
In-Reply-To: <20220928071110.365a2fcd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5SPRMB0012:EE_|CY8PR11MB6916:EE_
x-ms-office365-filtering-correlation-id: 6065b8bf-186b-421c-8691-08daa211fa9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J60bwkgwWudfGgtDHr8B6UOFCTrcasGtNA8mLlVsTqT/DzjaqRDAidgN4Low6VYLdzRLYO/qjUWyZM2RYcRlktidIOjyb/1gUMaWmvXRqdg70uk/eBcTmmLdR8GreT3DxZWIKcJI6nSPn+JD8zimbiKFk3DjyafoupbGtD+sviZVhZnOyFoPNyU2EhEudYA2BXE0NfAA8UNv5JAr+6AMDkpYvnYbHnV2Mk/EoaFE0b9VRpgVftsFOBZxLAr83l78B6K+j7oCo2MCa6cdE/iA5c4hobGxLfwW2zWiee6T58ikTmTQaiqfzmV60/EjsU+2Hl3iNng/NyYvo8gwzJoQ7xlRsKtKaT2cvnbZTY7iU35Y44sV6Wnr2CzWBKnyHwfWGjvIClRyFVaWxe4cvLvl9jVFWvHMioE6xMAvqOyH4bnTjdvRRnKjMBE4cFkWCYla6eTf56VOSf/I8Aqh2Va2lR0YkyR623iq6ENsEJ3/ztFY5Z7tiLhcl51fJEUxcl38xVBDpJn4vEjzex8ySzq6G84jqdyHLcfjKT8+V8OtrDO4axya38c0C1QFeRLMcA6siRajdQ0lbQaclmwWNY3o6LTnMjPDUmwZQT/63nSCssM1D0o+HJpnnVcmUqLnwC2HHhhmpc6g8lrgNrHtXaStDSo5wSJ4dkeywI5nQ6k+1VkCoJW9v7zZle6Wk3Ad/5WN0TrlxnHooCAeQslX9EshQ7EAEPBSLQyqvNy/rmq/5jhcNpRS6yJp3xFULQWmqKCBNvnNnQbXC68ar00vJ90w4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5SPRMB0012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199015)(8936002)(66946007)(186003)(41300700001)(26005)(71200400001)(54906003)(53546011)(2906002)(7696005)(6916009)(107886003)(6506007)(9686003)(64756008)(316002)(66476007)(66556008)(86362001)(76116006)(83380400001)(33656002)(8676002)(38070700005)(4326008)(38100700002)(52536014)(55016003)(66446008)(478600001)(122000001)(82960400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m6fnkIqir732pJakvC9pEKSpXhXhM0RRb+cYYn9zxVJsDh7OTglbQH6fXYDI?=
 =?us-ascii?Q?ILTC0dR6esWa6UUNdX97/1La/RzJ54wLUlEMg7da4wI02bgdkiUu82hF92cZ?=
 =?us-ascii?Q?I/9M815zWZoQYFQjLdji/0ZtarTcWHcAo8KfiYpltGM+bYzx/xAYE+BnJp0u?=
 =?us-ascii?Q?QMpHz7Zvb825FrFlUnBSkKlXhyR//eBVKP3xGbYfwliz6S6Dkc3+C341Hysz?=
 =?us-ascii?Q?+1YSv0Vpp5l/S/WwB/YIXeFim+GRy4LJYMnOemASaFPQmOmGJ/fHU7MP5hfW?=
 =?us-ascii?Q?kiknkx/tGcaORuEFNuLg2WHNWt+LiF8Ht7bIOIS/FWN1C505l/wB+RMBEGNl?=
 =?us-ascii?Q?epzvb95DhAxaEd84SMLFYJWT7B4syRI6thz0wgaQduP8adfKn8erAw3d2KpA?=
 =?us-ascii?Q?Vzb1q0dylPPDuxgvS1e5w617+v9TqAk7RBqDJnzPKigZ1FMAL37fiu3ZkFvN?=
 =?us-ascii?Q?tmni2fVeTU6AyYJ6As7d5ihZNoHwq/tqsp0Ct6xyguRm5cdzvq/L/htwGWeV?=
 =?us-ascii?Q?aXnVKmgphnlwjdQDHXcfwOvTq2BVyvfVGNuTODxgVeiJDNSYyc/keA5gmBwm?=
 =?us-ascii?Q?HLjdaMDcLUZbT8iANgXoJ68xpZRt+kdtoPoJ8VWJ+5ITSJtqkubKs7Bwdp88?=
 =?us-ascii?Q?4mjwtwmfcf5ZUkNMiPEu0ZGw/7Js8/vB7G+xEBZY7qM697HVh3QMnGwWeU71?=
 =?us-ascii?Q?CMHOYP10VPQUrBxKPGe/AqQ3pvfKu+ckq2enVn4sWSPWBU6Lh06v6t+y4HF5?=
 =?us-ascii?Q?qiVJbkVDZYCAeVF5wEMssYbk9GzNxMvRQ2Cm8Ph+eofKBr7YxavGgDOgtIMV?=
 =?us-ascii?Q?Jm7/IGq4NaH85j/wz4kvWGIVI3oS49jCb9SBziF6vmWusceXHCV1BQtM5DQe?=
 =?us-ascii?Q?XNiRBLSowJKYhyOrF7xHhQfta2DU09Y9GW/L01Zb08FY31kqa3Shr+k6U7wB?=
 =?us-ascii?Q?DSlOCBGugYlgp94eIumbOAq7PgBKZkAGrj8a8LV4xRNtfXKmyU/8rYXVbbsE?=
 =?us-ascii?Q?1BkLv/4fRdDILWlA0SOU8hDejGJArvUrnNfQxP7wF9QTakoHV0yh9xFdcZYj?=
 =?us-ascii?Q?qyAQK/8z0ESJyqLTFKfFNt2qw3ILVRhpqdB6P3x1qjZN50CuCdlGZ6izksxp?=
 =?us-ascii?Q?hpcclqgV4Io/0XM91spvBRnkGSqxq4AvgAPMpM4uPvCZzvZGXnPcCmSlWiZB?=
 =?us-ascii?Q?EAhKBmGTlcTEbS1eCXEYodwqWYePJEcCOEQTYm9jqoD9GtHCHYzzGW8OyuOB?=
 =?us-ascii?Q?ehBeJr4l6X1nC0ayz2NrXzbk6V4uf7+vlM8CnBfW2T1Z2PoT4EYtgSQKgG7l?=
 =?us-ascii?Q?1Oz/RJ++7pp6sUxl5pdzF/2bgFK0M11pEqVYzDso2gUHa+aIlbPoT8PN3oYb?=
 =?us-ascii?Q?SjwSWh5YFZcNsppFa5iqb4ShBfBa7RoDIGD92UKhlrDIMm1ksLrQOFMIPKP8?=
 =?us-ascii?Q?XVowxA2c5+J1kGQAP+1AtFo5wM08jLCalPBuzoSZqe9Tj1gqCSZWItGHsIjG?=
 =?us-ascii?Q?YV95+qFoNnRLV2Ut+Sox6u4D328AqWR9ptvSyWZU6nTqJeNhvGheUjdZ91BG?=
 =?us-ascii?Q?phUaEOO74vuRjZ6U5tInTgTMTvHc0/wA6LBhZZKJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5SPRMB0012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6065b8bf-186b-421c-8691-08daa211fa9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 11:58:52.8608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCKeGh8RNOfrfgC5j6oJFbTwXgZnU65YWboRsy9HoSOPpSFefyZQKswcHjCNoc3On11/YciGW7LlD4drt8FGDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6916
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 28, 2022 4:11 PM
> To: Jaron, MichalX <michalx.jaron@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
> netdev@vger.kernel.org; Maziarz, Kamil <kamil.maziarz@intel.com>; G,
> GurucharanX <gurucharanx.g@intel.com>; Dziedziuch, SylwesterX
> <sylwesterx.dziedziuch@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>
> Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
>=20
> On Wed, 28 Sep 2022 13:32:41 +0000 Jaron, MichalX wrote:
> > > Not sure this is a fix, are there other drivers in the tree which do
> > > this? In the drivers I work with IRQ mapping and XPS are just
> > > seemingly randomly reset on reconfiguration changes. User space
> > > needs to rerun its affinitization script after all changes it makes.
> > >
> > > Apart from the fact that I don't think this is a fix, if we were to
> > > solve it we should shoot for a more generic solution and not
> > > sprinkle all drivers with #ifdef CONFIG_XPS blocks :S
> >
> > XPS to CPUs maps are configured by i40e driver, based on active cpus,
> > after initialization or after drivers reset with reinit (i.e. when
> > queues count changes). User may want to leave this mapping or set his
> > own mapping by writing to xps_cpus file. In case when we do reset on
> > our network interface without changing number of queues(when reinit is
> > not true), i.e. by calling ethtool -t <interface>, in
> > i40e_rebuild() those maps were cleared (set to 0) for every tx by
> > netdev_set_num_tc(). After reset those maps were still set to 0
> > despite that it was set by driver or by user and user was not informed
> > about it.
>=20
> Set to 0 or reset to default (which I would hope is spread across the CPU=
s in
> the same fashion as affinity hint)?
>=20

Current driver behavior is that maps are cleared(set to 0) after every rese=
t. Then they are reinitialized to default values when driver rebuild queues=
 during reset i.e. the number of queues changed, number of VFs changed, XDP=
 is turning on/off(we reset and rebuild rings) or fw lldp agent is turning =
on/off. Reinitialization is done by netif_set_xps_queue() from XPS API. In =
every other case of reset maps will remain cleared.

With this fix, when there is a reset without rebuilding queues, maps are re=
stored to the same values as before reset.
I changed commit message a bit to be more descriptive and changed one goto;=
 as it was not correct. New version should be sent already to review.

> > With this fix maps are preserved and restored after reset to not
> > surprise user that maps have changed when user doesn't want it.
> > Mapping restoration is based on CPUs mapping and is done by
> > netif_set_xps_queue() which is XPS function, then I think this
> > affinization should be performed well.
> >
> > If user doesn't want to change queues then those maps should be
> > restored to the way it was.
