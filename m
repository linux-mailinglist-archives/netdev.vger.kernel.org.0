Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73B6174BD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiKCDG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKCDGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:06:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A1E140AC
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 20:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667444782; x=1698980782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O7DKnWL5E9J0yXePVAydGpdrZBZ2Kms0JKgUqqysNwA=;
  b=Mg0XxqZ/6yl0hE9ZC7Ai2OYRBbHzP8Sz4P8BNTJtBNeNtsRCv2GEMzwm
   TM2//kJ75UJpFX8w0LDV7Yzrhr19MiibL9vGDcjvFfr6kllWe1RvN9pOh
   VQiR9Uj/ex3HpQAtfk7uWR57Kcph9VAyS0xn4m8mfitqQn8dr0YDjTR/D
   6N+tGcs77AacpInjvrRNN47SSYmdjZiG2FCWZ23E3fRTP5nQcp4SEE88Q
   Yaes5XVQnaDH/TBbBfsyMlExOjURSf0WCXeumvM14j5a5p1cG5qufYWvQ
   tQTHa5tjFnd3gI+e1R1NIYOyDv+sRJG2w87/uJXguUMBnuoc5n9uJOx1G
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="289284942"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="289284942"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 20:06:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="585630606"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="585630606"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2022 20:06:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 20:06:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 2 Nov 2022 20:06:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 2 Nov 2022 20:06:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbO8zw4W1CSfYURTCTbWwaJIzBOFcWUwYRDwTvCUbKCDF/70gpJXJtfewYuYf+C7dwYOUBzAvm70OHKK3aLvTR6HcXScqr1AXlI0VWfCF0tCsfoS0r1iLiapZUTg2D1Gt3E1RPgKcHtyPJNruJTY+7o4A7+4lO/hQdzwk1XQ1ejVoASkZ/kaeqT5FSpQST36P4fdJt058uE46n9ZwZatahRFoFJedAxAnxcyv+N0bk5bYpOLCZeVkUQNZQvD0EIgybkJCswnZKlMFiCQU1w3xmvaYGisHeUlznF6W9/YDQDISYL1ODUEUIEyF0wcW3mnfZw3FZoS2N0CRZDiEWDzeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7DKnWL5E9J0yXePVAydGpdrZBZ2Kms0JKgUqqysNwA=;
 b=VOcReLtcDnhRZr9kTN5R4mH3AUadHYUAypDGna1Hdg8rNE/jXaZn9sKaDF+/d8BT4N7Y3w04/LHbFuJXfGQ1XpFB07fFZXSrqMXOI9aSB3dMsBn+udq+eb4qKh5fH7Ny/IHa+97pVtlotbhPiXlyi0BqPGZ7D95QAt3sBy/bad+N6yprRCINiNu2/uQ2D/xbhC1LNrY7NWafFJINyoGefqmWirzJ8WsQyF/9pVa5jFVvPJIfN7NAPOuekHOYTC/2rWt76hbf6kXicmup8EBNa5uLxQqs7siW/u6JA1L20hsgrB3y902lKcdRHFxf5ejk+kwK6ICGSeFh9DRKZLh6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA3PR11MB7463.namprd11.prod.outlook.com (2603:10b6:806:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 03:06:19 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%6]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 03:06:19 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "fw@strlen.de" <fw@strlen.de>
Subject: RE: [PATCH net-next v2 01/13] genetlink: refactor the cmd <> policy
 mapping dump
Thread-Topic: [PATCH net-next v2 01/13] genetlink: refactor the cmd <> policy
 mapping dump
Thread-Index: AQHY7wLTNjD/RP4x20qTXaqv7mTS8q4r2O2AgACW6gCAABSQ0A==
Date:   Thu, 3 Nov 2022 03:06:19 +0000
Message-ID: <CO1PR11MB5089BBF3883243C1F924B4B8D6389@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221102213338.194672-1-kuba@kernel.org>
        <20221102213338.194672-2-kuba@kernel.org>
        <83cb45fe-1ae5-4963-55e8-6d1ee6751aa1@intel.com>
 <20221102185230.27ce05b1@kernel.org>
In-Reply-To: <20221102185230.27ce05b1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SA3PR11MB7463:EE_
x-ms-office365-filtering-correlation-id: 20ea77f6-4acb-4214-022c-08dabd486166
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZACYZRHmvsusNk7m3gYLL8qLbZlLwH+VEA74gzGo3DUrWhOUKUz5VNs6vJb1I4ypxwjhDzRrFtlTR2wOP2CVdmHPMS9aC9WiU8QXZIuDaHxcVwUpzYbeyZsgWpNEoj1YjwWHIcpULEKwJFkwckocaRNDlDT0cGRilnFXJwJaTq3DElOpU4C2Q0xIYKTYq/29LSxNThy0a25xhELL42EA9CGuOckpm3U1AFOsI4n61gMJVZ0THDa7gSya1m69kEc+P+tvB6lS7HjDmPeW4ConYBzYYYlIW6izstmryQNDlPYXU3XolBOEEg5ZDPIb6ikZJX59qmb1ZB4jYn2pROT5nlR6npDZBU+I4VXbi+N2RML/Ez/044FIjKvFvRRUoY6B0oo4oI8l9Mu1rzyDPz/+5DNHqmd6XwESgy/chThitUCpsVcfFxgEqP23sn7DZ6/T5xG6bUojf1qkFLRuYL1MaUSTP9cvTBU4iGUOiaTANv0rYqHpE6yxAF6fM/qL6IZSiqlGOY0Au1EAq040aZUMse2IKWNHX94/j7GKk674reIREUV0xX1qL1epdlSwnDv60Y0rzm+X3Sait2jsgFgHAkcpcxsEgwayk8KUZ47m3OAkAI5zGtddJ4/nGvPNNGHf0xxAVo6veprWLZqVsIPCjAi3GcD6kP4I3XmkPd8kCjeU8tVMkMGZhKGjq9wHgQZeMgQm/3462DIgkXSVFqA++l2YweVaAmlxltYUpKOFyqZTteaN7VHQP9bkVERczRBDK4p5jEmdjquvGcduwyPdXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199015)(2906002)(33656002)(66476007)(7416002)(5660300002)(64756008)(66946007)(4326008)(76116006)(66446008)(66556008)(8676002)(122000001)(71200400001)(54906003)(6916009)(316002)(55016003)(8936002)(52536014)(41300700001)(82960400001)(83380400001)(38070700005)(86362001)(38100700002)(26005)(7696005)(6506007)(186003)(478600001)(53546011)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JJstFashhTXMWgaQPT3eLarOcJMIuplGPky5OuJ6M+ps6+rO3s73fVYeqMPx?=
 =?us-ascii?Q?4pjaGvA02VjFXv5yQpy7G0JQgvUuys4dH7pztD2vfonSELg4koQV4JB+5zNI?=
 =?us-ascii?Q?Vv+FVyQYxBet6pYDphyr2jmGupI/7jciVCRkGWV2d8OFubSepVsh93mqiHFw?=
 =?us-ascii?Q?n4zlrx3l2aIMXxzQjT1JNtf5buMmD0egiKilNQ9dp4022F76sxolNWGBpUqp?=
 =?us-ascii?Q?DqV++WWuii+PjeOFHSik14x6pvrFgiGoShcjerh6GU9pTqKSMoqlX/aIOYxB?=
 =?us-ascii?Q?NbIGXXiFPaxyHWpfPCWA+gnmWC+fiWIx+s9D3cbhXFqbxjRqygiha+oRf2Zz?=
 =?us-ascii?Q?uQBO6cZAhI4TUFAvAz6rFLMS4ymWcMA0/6bABiqVItI3PY8Ns1rgOJyZCk3z?=
 =?us-ascii?Q?fjHg0/mQdPLvyeEEvRUYSlhnt0CO9lM7GTCTBFW7FGrA3Tt5bLSsPQ7RHoDJ?=
 =?us-ascii?Q?wvihEvuOaKrrPryXDlhmIhRdXKmTUZ05frYfSUFuowmln5LVrx2pv2+eqTkP?=
 =?us-ascii?Q?H+sD8nRWc5sm4oz24ktNAlt3fJ+/qE7mdehTR6iwzR9zFui/RPldX3elCiB+?=
 =?us-ascii?Q?kW0f2I4bADPGiqMw/JqQb8VIb3gcFRtF/Z/fIT33UtKEIaJtu/5OJZ7ETJM2?=
 =?us-ascii?Q?kBVJK+vX2oLppfY5NOrfu8AeK+pLjfgP0rWhTZKXQvou8I0NbptUfMmxCQA7?=
 =?us-ascii?Q?FSXQ/ZcI2ONfEi5FPIGNLvsOHnfP8p50FtwdRB6KyuVBYXikre1s7H2Z3+p/?=
 =?us-ascii?Q?oTvn+cgQLYxKty0OJhnB70S2Z5ispzVDkQ557Yt7UUNOzdZd2b/NXVE2tvg9?=
 =?us-ascii?Q?7k/HJXDPdiHPu3JojkMbtRxPTyJT3+swGuMfxoROF4iRL0I7PCrqNg95x72T?=
 =?us-ascii?Q?I4Ui29HqoBdQzn/iuc36/YQmYLCpYXAeoIjbl0dgW2gE0vm6095cGyS6YWPh?=
 =?us-ascii?Q?/TQGhypJfmDrub80bTrMVYUqpCB1k5G5kAjJ8BrMQODN0gtek6w7tv6NPwqA?=
 =?us-ascii?Q?DB2Qq8So74IgtqI45IrogTAXaHtJvvHWS8jns4bSv77nQa7GoLpEnX9GfSTs?=
 =?us-ascii?Q?xF7uxO1maCe+Qa0LHf/1DrtQeQ8sX1sv4725uilYSKGKoMjwr1hz/JXxuz6y?=
 =?us-ascii?Q?w7TLeIxz0EPGcRVpKyNO/XKISPq9hbFpOpPR53AtNZ3Y4cLP5h8HKON+5qyG?=
 =?us-ascii?Q?IQbb282DNoZ7LEO1jpTbzaMnq3P4kQkOzZeEf93AaPRxRfmExJAXAzng5lBy?=
 =?us-ascii?Q?8hDkP5aBQ1OOhqgEAFYkj8bREj3CdX9m8DvxGKS/Hf+mggkDHGSxezOP3w8m?=
 =?us-ascii?Q?47rsG/CILN8ZFyXIAXSzRcczUA1pMnSHwqJJHiFqcOFLfyhPInm2BhPV6t29?=
 =?us-ascii?Q?oBr78UKT5B9gUrFZjsscez/KL8eC+XI038+eeZHskGSmqx4ngsY0usETNc1z?=
 =?us-ascii?Q?M4ic6vboSVuMzKZ3NGpwj3irCVqHuOnEWbQSmsFaPtqjdiqr9YivHaSm1HYp?=
 =?us-ascii?Q?MsoUo5hOb8ioRb1ENzHCiGYpAsIwi5Mok/xN1Ntpp2u0CcybkW6f5sfy4ZRM?=
 =?us-ascii?Q?az8CI/KNMuOCpw7bwNRiB2dJYU96mI1HLOGph636?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ea77f6-4acb-4214-022c-08dabd486166
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 03:06:19.5091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dfQ2Ilt/1c98GoRW/urUemMRhX2GzY/LVu88Ed/Wig0vO9X02H6pDyAf5b34VVl0w9ql0awy5iHX5M2GrqmhEkc1+t7M/lCEQ2yMkbvRues=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7463
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 2, 2022 6:53 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; edumazet@google.com;
> pabeni@redhat.com; jiri@resnulli.us; razor@blackwall.org;
> nicolas.dichtel@6wind.com; gnault@redhat.com; fw@strlen.de
> Subject: Re: [PATCH net-next v2 01/13] genetlink: refactor the cmd <> pol=
icy
> mapping dump
>=20
> On Wed, 2 Nov 2022 16:52:21 -0700 Jacob Keller wrote:
> > Does the change to ctx->opidx have any other side effects we care about=
?
> > if not it might be more legible to write this as:
> >
> > /* don't modify ctx->opidx */
> > }
> >
> > while (!ctx->single_op && ctx->opidx < genl_get_cmd_cnt(ctx->r)) {
> >
> >
> > That makes the intent a bit more clear and shouldn't need a comment
> > about entering the loop. It also means we don't need to modify
> > ctx->opidx, though I'm not sure if those other side effects matter or
> > not.. we were modifying it before..
> >
> > I don't know what else depends on the opidx.
>=20
> I was just trying to make the patches slightly easier to read.
> This chunk gets rewritten again in patch 10, and the opidx thing
> is gone completely. I maintain a "keep dumping" boolean called
> dump_map (because this code is dumping a mapping rather than
> the policies which come later)
>=20
> LMK if I should try harder to improve this patch or what patch 10
> does makes this moot.

If patch 10 makes things moot lets go with this as-is.

Thanks,
Jake
