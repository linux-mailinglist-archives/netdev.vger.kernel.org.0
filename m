Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C096C34CB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjCUOw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCUOw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:52:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01C63C1D;
        Tue, 21 Mar 2023 07:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679410374; x=1710946374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VGrZI69F+7R55vw38BSxyQTiTAoaoYWDCfSRv5JeZBU=;
  b=NX+b37etvrX2UFk0R93xmVt5nBFlTDSrOgqNX0vIKuLbDetlKx/l84Z2
   IWvhueK1ZFheaTkKTtl4HZHLmYy103sUQDQrkZqOOug+ivhH7nNiNfoAl
   3u9YzELa7HL1EexQDcGlvJWd4Sb/Gj+fMpMQGHfBSXiBMZusUxnXyVfwm
   CGfDbi5d5+pe2RbC7ZSuRb9oTxy5ZpQB1WL7BNOU+Ov03LOYvmRYTj86L
   Pn29F9JwD1hRLojNmNcM7YdWahTWRqFmV50Suc2FqV8+MwjxgmnXwfEXf
   ntS2st3cPBaYawFo1C6tk3VQHttBGUHzcErDAVfor72wfjIL8ldU3HRPW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403841203"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403841203"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 07:52:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="805405459"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="805405459"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 21 Mar 2023 07:52:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 07:52:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 07:52:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 07:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aytgw9hYJLfMmEi5s7oWCC9wTNmp5tJXceaRBc77lhOvk1I4os+EqAXpR9FUegm3vncp4Fw3OZ6ga25BB9rRoPmPBLsAYTCMzdsgMRLOkPpo7QsrJKxNTvZP5tZobdEzSDiRG+xCTi4XjHDfvyhcVsuaghk/F4NdJxXruQ6bpq+CjRGyOkba35tgGSEyCw52o6M7oTpzzrLT4/fI/oEOSEJ1B2kmcu6qfWV/PenzrBB6KBVmwUSYotr208wrorgtGTKdUVb8TGRnvfZYWuZcGtf+YoWzg7wTqZeFoiL423ztyoCufoHH2dvXrhsEoiwj614MyML/n3HX6QCKCa3CXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3XOSvoMzfXoISJjmprk+IN/YcxOi+C1yeU0FN/Jqag=;
 b=KPKZe1pFKreS2cGvgCGmrVhxUPloBZJwH2Z2WbDh54LfWVBWjbec4et+80h/EN65TzvYmjfvzT4fyjPBrQ6AReoMVr0vehYp4+VtyG01Ofbt3AILEb5E1xWB+fgoCxPmq4NyQzzUsyYtcekDoUDjbMuOniEVaBihWhMppWS/cjdimbFamiM3bGIFnPQVSDIMrgVs6whJ/mGjSgo5KOeuMaQgARVAyL4YtoKtrsSxerRjJ51wjbYtL6FcIOGFKFzEUF63fjg4pzMt/m9o2E+oKq11xJAySwdx5Z4BZo2UABVUnnXh3IZPsls3LTPMxO4mk1/t8/RwihWZbQiNSlPNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 14:52:34 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 14:52:34 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Nicolas Pitre <nico@fluxnic.net>,
        Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZVVb9Plq7k2o7S0K9BdoAv1tvk675DoOAgAELboCAAJbOAIABMVyAgAAKrwCAB8YEAIAABm0AgABj+4CAABQNgIABDuWAgAAWIRCAAAURgIAAAgVw
Date:   Tue, 21 Mar 2023 14:52:34 +0000
Message-ID: <BN9PR11MB5483DA8ED31B3294C60FC827E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org> <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
 <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
 <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
 <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
 <ZBmq8cW36e8pRZ+s@smile.fi.intel.com>
 <BN9PR11MB548394F8DCE5AEC4DA553EB6E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
 <ZBnBwa/MLdH0ep3g@smile.fi.intel.com>
In-Reply-To: <ZBnBwa/MLdH0ep3g@smile.fi.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|MN0PR11MB6059:EE_
x-ms-office365-filtering-correlation-id: 9f7cc54a-c0bd-4218-61cb-08db2a1be7dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXrMuBlD5ah5dTg7REjsn8fwl4DZLXBL7/Wf5eO6nSphB150RcwoHUmbgcSrAI6ec14/wbWTYs0EFSMdPKewbjdLmU0lhutQsEOfyGn5Ya+pie3fXVLX+cbC86QlmsHVTI257DnVT4qTEpQE1axns/yLGNIKrEbMSwjL9VTOwwPIL+rxvS3mx7GyzMF1rlWiIsEj94wBuYdwOasg44Bjii1WJTltSTe0SqVggzpDJpQsWHMk7HBGOEiZZcYpFLixofZLEYhllvARYCCx0t87ff+zi31d/kqNn7RJ9oHOxXo8HfluduWeAuJOexPYwrMb4gmZ2/SFIrjwA1urPFCbivgvpDm1GsEnsyr3Y/qQ6IveJDe3KoLFMaeyORY12MfM/ENLTqy5BymbcgG5UqMsy0tRYg7MnUw3sRHNDruaRSlKMPv3Wb/wQGMW3ml1YZ+BHm6nG1eh/f1aJxRLDBvHse+CKlVVTiqJmtb/CosRf/uPEJIIqhofYhhjGjYH2NMQIk28fN0ulz3DxiJhOSjbMZTlvCiKvbkHDdr1JCbwEA6LvztEJY1LYRSHHp1dhmHVdEu2sRXyhoXiOIhADBFQLmDXX3lopqTJu+bkH0rW6Y0J1z4aj7FCia9b3Hi5+0IWR32b6tR8R7S5MpJ0VKcB7KKNC2H0vwGJFy99pgPJfCrSiPxVCW3L+iB+B9/UF1RkCAVwY5Q1M13GV3vY3KUwzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199018)(6506007)(186003)(53546011)(9686003)(71200400001)(7696005)(83380400001)(316002)(478600001)(54906003)(8676002)(66946007)(6916009)(64756008)(4326008)(66446008)(66556008)(66476007)(76116006)(8936002)(41300700001)(52536014)(38070700005)(5660300002)(82960400001)(2906002)(38100700002)(122000001)(86362001)(55016003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y0jG4fVDRPPVvp1zgqYuSo2+Hyr5k2YM1o3J3XIxotizSQBGvd2rMYWYDy27?=
 =?us-ascii?Q?fj9xK3y2Xu8nfvHBD7GgwmKjfpxM2MFbYLRAxh8MyooiG23AXFcgwqqcpTb0?=
 =?us-ascii?Q?OvyF3c4eB1dWA+QUV/BzdUPRV66C5IDtMF1f1+rosJS0pQaCyV0yjeynkLyP?=
 =?us-ascii?Q?E6O1wk+TFatjPvUmkKfvSbFUJsEPN/Ggvcwpx2s4rBguU8y2XdCtL92Ulch+?=
 =?us-ascii?Q?lzA3mD7CltqmUbc0ZMLJetPdzkOA7QeUaP4OadXaMVJjv6kEh/CpWRPxJuAn?=
 =?us-ascii?Q?zWn+a0dxDCCLJ4HAt03cu6ZpOya0sy1drWDPOkiOL6NFKTKvPz3t06HkBy4b?=
 =?us-ascii?Q?jKKq6ZwOWs9bq5YqPiW0RKX/WIeRVQh3kbviNb47PgdRQ6iYqxdF6TCaBvbj?=
 =?us-ascii?Q?iGUv/BMF5rZ1liNFNLPXV8ERM855XTHFcv19BvsqQCVOVZjamk990za+HryB?=
 =?us-ascii?Q?6h+1VrPHkc8wp1m8WJguCDu4OdnYsSLuk7cDBMfVrCphjRurQNSiiPRa42oQ?=
 =?us-ascii?Q?LxrPRUl3jNgMSp9qJbtoiGDKvTZ1P8onVBcXu1UmyidlO9bxkO6F1Y3ZlqMi?=
 =?us-ascii?Q?ry7BR8VWTvXBbzDq5uPwDvcMi02QsrsT2ZVgiCP7zexx1f358X7u1VDg+X1O?=
 =?us-ascii?Q?PERzt/GXMJ8RWse5W6xYqTMDMIaRCLBOQVXriD5KSNBphudOXogfJMMnD8tr?=
 =?us-ascii?Q?LY4zcRspQH83zW0UrgG7GAKp2OIAMTQoob0cO0jocyLPd3DX9CHqTV7WSGBx?=
 =?us-ascii?Q?Yt2qicD+atvJ+N0pS/8GT0+yuQlOefD/pcSwIcWY9H0g9kN9sBZuqoaWvj7P?=
 =?us-ascii?Q?Q1+wm2kPDGsQb0CCcdswKgzpWYKvqK90kmeqil3YAHwyBLEEUq4p4RSlcFLE?=
 =?us-ascii?Q?79F7cNnZFMBrVYGGq0qjwmbo5c0m9NnTeW5UbVX5EUxlm8PMXWDSjNMWSmsa?=
 =?us-ascii?Q?W9P1zgwnJLVTicKtT5MsmakxW1vnPvdj8cIUAYm8j6kfhobxc/Cs72SSowlJ?=
 =?us-ascii?Q?7hDMfpWxpI2efi87LrjWW8Xz4yqZnhl4Yby6o2UQZ0owKc6uBbvkC+wPst52?=
 =?us-ascii?Q?QkRH5Fj7srvQnNJagYeK0QhpklHEGxTcM1SLk27CyGWjjJy1UHBrKtwhfbw/?=
 =?us-ascii?Q?Gt35jZBnq/0pYNqXtITnhIEs+Pz5Zh9xKr27wOdfAEpr1umIHDbm3oXqac40?=
 =?us-ascii?Q?ZDZV5HONiU+PS55FADKyUh2A4k1QRDLGgjA07URsWY+OtwlFgvzJasUXFCDr?=
 =?us-ascii?Q?2v96uu7bdBObuNusha5IvN0RbjBYeYwzQMPV/Y4nyEYrFWSqUNTUH3lzMlaG?=
 =?us-ascii?Q?f3zI3KvlPDHdMkjxSDAoJ/agxeolaWz5944vSSnEy0ptZj0JuwWREaw8JnMo?=
 =?us-ascii?Q?qCmkCNUl6eOT6Gmlzk7bmlmAkREq1ef60Ui0AFqRrQ5XzWGb17YqKnFly283?=
 =?us-ascii?Q?wZYZkulR0vWp7HpBQ3Zsqv0crxQ98DDWZWrjemrG2IDEP46RH2mV7RpbZiZc?=
 =?us-ascii?Q?IUIA8MmATJIks4lWHLp80Roa21yCeSEOI/AndWeekXuQW+sWGvsyiPKxk9c1?=
 =?us-ascii?Q?EZQGKnRsNT6HcyFIYgvq5iN/hAEWIFCUdk2COXV+5Wnb+gXvb1TJREnc07CT?=
 =?us-ascii?Q?98ww9gl8JfS24vzkGwk4Z5TR2lv1d8YIoUJT/fCRGLhp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7cc54a-c0bd-4218-61cb-08db2a1be7dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 14:52:34.5429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvVr2jOi2A2nrzcVeVIV9lPtu3yoyuMzyY3uhj774ntZs1p3rLmv4Zv4YSOWF6faYpeBPYnCT9YQ/lN5m0tHBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6059
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Tuesday, March 21, 2023 10:40 PM
> To: Zhang, Tianfei <tianfei.zhang@intel.com>
> Cc: Nicolas Pitre <nico@fluxnic.net>; Richard Cochran
> <richardcochran@gmail.com>; netdev@vger.kernel.org; linux-
> fpga@vger.kernel.org; ilpo.jarvinen@linux.intel.com; Weight, Russell H
> <russell.h.weight@intel.com>; matthew.gerlach@linux.intel.com; pierre-
> louis.bossart@linux.intel.com; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Khadatare, RaghavendraX Anand <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Tue, Mar 21, 2023 at 02:28:15PM +0000, Zhang, Tianfei wrote:
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Sent: Tuesday, March 21, 2023 9:03 PM
> > > To: Nicolas Pitre <nico@fluxnic.net> On Mon, Mar 20, 2023 at
> > > 04:53:07PM -0400, Nicolas Pitre wrote:
> > > > On Mon, 20 Mar 2023, Richard Cochran wrote:
> > > > > On Mon, Mar 20, 2023 at 09:43:30AM -0400, Nicolas Pitre wrote:
> > > > >
> > > > > > Alternatively the above commit can be reverted if no one else
> > > > > > cares. I personally gave up on the idea of a slimmed down
> > > > > > Linux kernel a while ago.
> > > > >
> > > > > Does this mean I can restore the posix clocks back into the core
> > > > > unconditionally?
> > > >
> > > > This only means _I_ no longer care. I'm not speaking for others (e.=
g.
> > > > OpenWRT or the like) who might still rely on splitting it out.
> > > > Maybe Andy wants to "fix" it?
> > >
> > > I would be a good choice, if I have an access to the hardware at hand=
 to test.
> > > That said, I think Richard himself can try to finish that feature
> > > (optional PTP) and on my side I can help with reviewing the code (jus=
t Cc me
> when needed).
> >
> > Handle NULL as a valid parameter (object) to their respective APIs
> > looks a good idea, but this will be a big change and need fully test
> > for all devices,
>=20
> Since it's core change, so a few devices that cover 100% APIs that should=
 handle
> optional PTP. I don't think it requires enormous work.
>=20
> > we can add it on the TODO list.
>=20
> It would be a good idea.
>=20
> > So for this patch, are you agree we continue use the existing
> > ptp_clock_register() API, for example, change my driver like below:
>=20
> The problem is that it will increase the technical debt.
> What about sending with NULL handled variant together with an RFC/RFT tha=
t
> finishes the optional PTP support?

I think sending the other patchset to fix this NULL handled issue of PTP co=
re will be better?

>=20
> >       dt->ptp_clock =3D ptp_clock_register(&dt->ptp_clock_ops, dev);
>=20
> 	ret =3D PTR_ERR_OR_ZERO(...);
> 	if (ret)
> 		return ...
>=20
> ?
>=20
> >       if (IS_ERR_OR_NULL(dt->ptp_clock))
> >               return dev_err_probe(dt->dev, IS_ERR_OR_NULL(dt->ptp_cloc=
k),
> >                                    "Unable to register PTP clock\n");


Would you like below:

        dt->ptp_clock =3D ptp_clock_register(&dt->ptp_clock_ops, dev);
       ret =3D PTR_ERR_OR_ZERO(dt->ptp_clock);
        return dev_err_probe(dt->dev, ret, "Unable to register PTP clock\n"=
);

