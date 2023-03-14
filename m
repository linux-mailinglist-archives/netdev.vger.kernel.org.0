Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68B16B8BCD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCNHQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCNHQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:16:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F0918B0D;
        Tue, 14 Mar 2023 00:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678778193; x=1710314193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kffmGS3kwBU8NyFmhEeZ800VaFy//yxpWZAO/jTuLx0=;
  b=KNUEIBkSGqGN3FA6GUOzvykIrsInn0wiAC5aksZ2Ge85i6YE3676LeQh
   0uKK0bD/xU5S9uGwIWN2LW0rC8k0mlGTkVGYgXtGyZ1RVsC8J8jjq4OqK
   iX0D5R+Mzke5/MSIztvlJHwE3sBJB6mxxXRkIl4w5KMIWzmjnObsp1kSg
   jaHI2Q7WkdFJZxDyGhdVHr4DpQY4i5T8WYcD7fXwbOMbvLjbp4PDkWzhq
   pNw56BynGUJ2/maS8bbjXHPGQi6OkpB3HKVJQqGk5KLCwpvIW7z5aPW2U
   f+/MD6HfEpKKtKI5p/KjSFItGN/nSOPRy379EnGurVk9CbTdgGxgJ8aOQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="317737843"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="317737843"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 00:16:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="678991848"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="678991848"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 14 Mar 2023 00:16:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 00:16:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 00:16:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 00:16:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 00:16:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0SFHq92DM7MWNT4xtZ7VOGUw8zrLWWrcmcXg6j7L4z39EoI6yFsq5G8fKwGHKRTsSAHr9IMjla1frbbk//3VRZj6DIhVTKP82pJwh84+rzAZf8K/sPT4E/MuTdDbg3qsP/vdmNbogJ51DDV5fiYnLA3NsS5pxPvSHPgB179NcDehDXDqoiLpf2Ql9g4A+XznvaERdzXwUSNY1zE8yV5vh2yWmvTRbl91wlC5z0l+K2RdeMr0NMt7zGDTHuG1JaQYXv1M1mDdb0hkHpsqei5Gtio2uAmIZtFdwTA7O8lrNaeB+tE5Z3I8jTCfZ7GwWs7+z66l8g0ZPo92O8gxCbDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baXfaK/mps7kKUNxhsonY9Y3BQE2rcuxXEBMdsfAk34=;
 b=YzcARy2MxoawiQFP8rqnfU3GuCJ5ZIlGj+oruvXj6/ZTb67u4PD3Fq78Pv7dq5fq+yQaEH/Yh934NWJzDkkIatVQ75r8UKTqv4fu28X9JPZUL1t+ZG5by66L3rKrpIu9yGXvlVkU/3Zq5rCNR8QHx+NiS8mfzgcrTSBdGRVxy4Of2GBug01H5dD973N5+MxLeb4xWukpOX2+1c+EDcKVNDA/Hp9Yop3dKN8GXw77Vot8UM4p/NmX5Q/8zUECmyXA/Ltqcd0yIMW5lWcIdD5cIUSsDW0xlGbJspTdNZjPRL5ZZ4tPcWIhjP6AUjusmQvvtFG3wfyApshVtBLim9e4Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by DS0PR11MB8072.namprd11.prod.outlook.com (2603:10b6:8:12f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 07:16:29 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc%8]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 07:16:28 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZVVb9Plq7k2o7S0K9BdoAv1tvk675DoOAgADPMsA=
Date:   Tue, 14 Mar 2023 07:16:28 +0000
Message-ID: <BN9PR11MB5483E675D4FA5B37B2A86F76E3BE9@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
In-Reply-To: <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|DS0PR11MB8072:EE_
x-ms-office365-filtering-correlation-id: adb4401a-2e36-4f07-a4f0-08db245c07c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HyCfgjmB/fDzkcFS2Kk59CF99pHI3gpTZOpGHBWVVD767eNp0GYQl0RRNwgh44Jp+O6QAeV9DfZmFNHI7i7GMga5pBOIt0B98ofiRLsjMKJCwtmKdr0QggTEmr7oemgB79zoGCghYpw6Q3DIaEILrU0C1vd0BbXpA9XRB4vjPeS41lhAhBSHoZwo/wYt+sAfjDDePavF7FY62kQSy1ztdeRJDWhiDpfD0q+o9ytb5lREXnVaZ9jG33FZ1/Dylhc7Z/zzPAI4V5sLEmSrHraAYxsJ4HDm8KOoN3uYg3YIZCAP0C5Cjzh5B/9ayRkFz0UaDXte0LgsyJ4HCVeaH7r8STUeIwpukWcpPWERDER0QrmQIoBedXemo8MYnt4fA5bbg78Fpu6PUL27i7Iie9mA5Ttd0E9Ye1sjgR7aDU6a/CmtUGK3Lln3wGHmhIYF2olV2OhEPH6rp2tnChRBM0aLB33jv7BjbPbEb65T7asX75MxckxGhZz/Rawek72cpHYKke6yj9abynLJ1aoXikS+/p14S++5M+i3pEU+57HAphsdG587iw0sinf4g2wWV7Rjnxqh7K5F/syr9rrM2iPWMshkhDE/HdjFkCsNNl1EaFr0pDGyTJPVRmfIfLELPCdEjPj7BtIcmsNVpYtvqn4UxRG0Mihx2NNe7Vh4YbTlefda5iPoQ0KU+8eK/MByLbB5VU5a3AnJHAtkyKQaTbRztA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199018)(86362001)(186003)(9686003)(33656002)(38070700005)(53546011)(6506007)(38100700002)(71200400001)(2906002)(122000001)(82960400001)(7696005)(5660300002)(8676002)(41300700001)(55016003)(478600001)(52536014)(83380400001)(316002)(8936002)(4326008)(6916009)(66556008)(76116006)(66476007)(64756008)(66446008)(54906003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TT1damXJNzTondMj5i5le9Vf//xzo04MmDwqFFgWxHEhWl9G9mAyishdPgLx?=
 =?us-ascii?Q?Jl43GWB7ipK4D17Ngv3oKNunUb+cZ22CUnzayGDkft9PUk/ekdOb1uULpOuC?=
 =?us-ascii?Q?g1xHa0c594xlYMuG63FvJ3ZapBO4VRmnJd6g9CaRtx/VKxSduaj3uFw7M3HX?=
 =?us-ascii?Q?kPTxTekayLzkYqUvT2zQUhENJlfkj0rE3IJSmtAK1YvyUxIrBg7fBwQDsGBT?=
 =?us-ascii?Q?bHAuuNteO7tTBhLst7uvwXfk+XHOmbAJkzWBraPF79jHx8syUw09s9Cccfj9?=
 =?us-ascii?Q?GIWaeAjo/vS+lhlCX3QA3QBWGIJRxY944+e0d6TO+37DoUizEb0DTb7lUTQF?=
 =?us-ascii?Q?17+Ti4ATRwGtGSlJ3bKB5n3jWAI+TUZhF65z8qvAxfHDjQ97YNELatMP1Jtb?=
 =?us-ascii?Q?HrXOfzUVkN6+xNh7ItoTWE9f0L5z2FKXAgxjukf2raIw55gyrcEs2VTKWhKG?=
 =?us-ascii?Q?z1tY9kXPPK59qUWzPX3k+z6ZbnsX3QB3e1tB1ZLCwHexz8Et87vnu7egC+8K?=
 =?us-ascii?Q?SxatPcIS5lTcEuGfXxqsO8lKbmqkzNIjlZhtKCbVhx2eHoSZgLpJ52eOq3Wk?=
 =?us-ascii?Q?1YWH14/DmsBen4r+g1vivcXf8Uv9GccI1jxWOPFazX5a+nFuy02XcNMEFAS3?=
 =?us-ascii?Q?KW2F+/LGLXry0odkq0LqE6z98jQsKb5WyLFdnMLcjaDq4HJ6blwAAhPUrZ5i?=
 =?us-ascii?Q?aWKII0+gdLhRFaNj+2wVTIKuTSSplG9RKuCTNQbwnyJiM4OhDeFA83Ap9mka?=
 =?us-ascii?Q?OeIrDjGE8vub1nS9kVUSPzj+EeTk82Mnf6VlcmBK1nt1NoggS9Sf5quS8Lxo?=
 =?us-ascii?Q?w8iwjAF5QhHVI3YerCvV3+2dyR+U14KzvK+jDbutCXxmLvvgBscING/7Gw+C?=
 =?us-ascii?Q?1KD85m4VlbG8C4LgmhHfZ/nVWSdFv6WB61rC+mqNFyMNe+eeZgXrRb3FTbEb?=
 =?us-ascii?Q?iIk+sCks1N5/vsyVy6oe7GMmGFYAoiN83+vSICTxMJ0qpCpkNscx+JOZqp2k?=
 =?us-ascii?Q?Up7kRwk1DKZEPzaFglS3BGSok7XSRu5jGViMOKQTbnkvENElGSoJaxfM4I27?=
 =?us-ascii?Q?wo7QN5Ou2vY5rDyLqqYFVIntmpcLIv4ZZhoAB3G0LyzIsAMEM8yoqN2d9Z+7?=
 =?us-ascii?Q?NHRq80l59UO6vMC/OCcCATjLHF8/tFXnxn+z73PNulpqur9g+Qtp3VE/TRxA?=
 =?us-ascii?Q?lj+RfJFe+VVBRhRT+2cgY1zJOGYbz0pS7NB6Hz56UwDylljuyycMcpnqwEVW?=
 =?us-ascii?Q?/ePnrCrNgplFVZ8N8Z/YqKQhaPQRyFv5HgRhDGvzr+t6wJtXpT4SGQtp90sA?=
 =?us-ascii?Q?Zy93rUrqirgPz1IYWwp7i475TvLSWsX0wM+jz2xgZCKtXEZd5HV7dH+woEzu?=
 =?us-ascii?Q?4gBTU6mP2q24Pe3C5F6zpB1ikY3qbH+Z6FXWgDkt5S0sBP5HsRW2bQmsFcH1?=
 =?us-ascii?Q?vksPxy+xukyw2RQhrgg2SzXYLDsN+QXqvxHIUiO0Hub5VlTRV/oK8KBDaNdA?=
 =?us-ascii?Q?lp20tlIZa4bSlNQv0vMloHSBw7MTc5/0xRaQbaZp0Oqkdw+P9ksOBD6sSpgT?=
 =?us-ascii?Q?jdeCEue9P2xALHtFKvBSXA5vNnB4lhc+GQLi97jeESW9p5UQ+sn7oKSf+J2B?=
 =?us-ascii?Q?BGV/1exaec6Ppw25bkHkAuiO5e/RLIe57EwhA+xAdb6q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb4401a-2e36-4f07-a4f0-08db245c07c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 07:16:28.8285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tl6ln5ejnZjWY2qdikiZ8ZqPZAGt75PsQGRtyzkXeouOCSOCwDkcTYP2kgFIvhMJhVvlaagW28bAh86yGbWoPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8072
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, March 14, 2023 2:50 AM
> To: Zhang, Tianfei <tianfei.zhang@intel.com>
> Cc: netdev@vger.kernel.org; linux-fpga@vger.kernel.org;
> ilpo.jarvinen@linux.intel.com; andriy.shevchenko@linux.intel.com; Weight,=
 Russell H
> <russell.h.weight@intel.com>; matthew.gerlach@linux.intel.com; pierre-
> louis.bossart@linux.intel.com; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Khadatare, RaghavendraX Anand <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Sun, Mar 12, 2023 at 11:02:39PM -0400, Tianfei Zhang wrote:
>=20
>=20
> > +static int dfl_tod_probe(struct dfl_device *ddev) {
> > +	struct device *dev =3D &ddev->dev;
> > +	struct dfl_tod *dt;
> > +
> > +	dt =3D devm_kzalloc(dev, sizeof(*dt), GFP_KERNEL);
> > +	if (!dt)
> > +		return -ENOMEM;
> > +
> > +	dt->tod_ctrl =3D devm_ioremap_resource(dev, &ddev->mmio_res);
> > +	if (IS_ERR(dt->tod_ctrl))
> > +		return PTR_ERR(dt->tod_ctrl);
> > +
> > +	dt->dev =3D dev;
> > +	spin_lock_init(&dt->tod_lock);
> > +	dev_set_drvdata(dev, dt);
> > +
> > +	dt->ptp_clock_ops =3D dfl_tod_clock_ops;
> > +
> > +	dt->ptp_clock =3D ptp_clock_register(&dt->ptp_clock_ops, dev);
> > +	if (IS_ERR(dt->ptp_clock))
> > +		return dev_err_probe(dt->dev, PTR_ERR(dt->ptp_clock),
> > +				     "Unable to register PTP clock\n");
>=20
> Need to handle NULL as well...

It looks like that it doesn't need check NULL for ptp_clock_register(), it =
handle the NULL case internally and return ERR_PTR(-ENOMEM).

struct ptp_clock *ptp_clock_register()
{
             err =3D -ENOMEM;
              ptp =3D kzalloc(sizeof(struct ptp_clock), GFP_KERNEL);
	if (ptp =3D=3D NULL)
		goto no_memory;

              ...
          =20
            return ptp;

no_memory:
	return ERR_PTR(err);
}

