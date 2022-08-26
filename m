Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EA75A1DBE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbiHZAke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbiHZAkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:40:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D739D134;
        Thu, 25 Aug 2022 17:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661474432; x=1693010432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KjiV+/mWKWZMWfqFtFHKSNTrD5zbVH0mxeRnFiDaRBc=;
  b=fPN+DhvojzuuwEevGCazXrzE3iOvOW3/9M1JyHTE3ByPB+6qkacCKiAQ
   ByLT+Z4vjvGTFPshozpd5FLwLLkhrNjCzojETi1rDLUDvw+BEz23yMlyJ
   Iiq42oFrMPGvtuXyCq4tjkkcOHIvDf4uwJ2KZZYW6edzfN8jSFaz642YR
   SQqVOZIpv4r8YfPxIR/+HX8aDL5Cdwx62z2HXAkw1Ke0oxawGvtcSQkBL
   opMIrNY+LTYbp22HZPOzNbsXrqeKBxnOT5+hUlaB4cHNeGgBnLMPyedHD
   Cu9ESB9Kui11IkmsVRBlurlhN5tJmVv5ByAKflENWdbINkbsRrNJuXr94
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="281361034"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="281361034"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 17:40:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="678673817"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2022 17:40:28 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 17:40:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 17:40:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 17:40:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gu367k8jn5CFrXwX5ue2Lj2M/wZVkIExpRK1xNCHC3x7QOVQKES6U1Mf3Ltlq9g8eLZyei4lwNpMX1lizOeVoMjt8h7drkoTKVuBoCGi6qagSkw2QdGrcAZtYZ/cHROJWNqG72U+sg8xy1BI+VlnZZDNThBvirv+LvMagXTXbi8Winn2XQmvzy18GObBsaHVsXu5eKVGfpOg/2Yq4+McROD5IpI3Jvznfm6WeC/0PHfU0tV+ehYNuLQE9OVt6Z/RLxORsbQaEIoL+1hDCVFEM8kc/fh4/qVmZhDpGeAlAL3U7Xyuk/awfnV124+esaLOrk5XRicb/HquO1FLHQcolQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjiV+/mWKWZMWfqFtFHKSNTrD5zbVH0mxeRnFiDaRBc=;
 b=CS634Lzk7T77nGtfNxvHwMQ3oBhOAhi/wcn3PMOmoZcKego0tVCPjVPdVOM8Sj7kOwQTuUm3DTU1CeZFRVwJSFR54LCjUJ00F8nVpsXnsbbKgM7QVNCjgMNT0y7ZQq1eESFMxen2efd9JNiIjKlyp2aVbqA851RhDLwOS69JXuJD0aR2dRt2IM9EZIDZwvvyAZ+Hp9sQChxB7JDAZ48IUkgXt4QBitgbF9ksIQcWkVs3GYkmMbEPLdIMSBm1ywro9drnUdTbiTlT6rvQIitkxdpINWggIjsGoEs7KsLXwcqLJdfSzBfVIFcUdZF1z3J04lhNq8yQObFTiQk2PZRP7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BY5PR11MB3975.namprd11.prod.outlook.com (2603:10b6:a03:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 26 Aug
 2022 00:40:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 00:40:20 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [iproute2-next v3 2/3] mnlg: add function to get
 CTRL_ATTR_MAXATTR value
Thread-Topic: [iproute2-next v3 2/3] mnlg: add function to get
 CTRL_ATTR_MAXATTR value
Thread-Index: AQHYoGkYnhcVdo++8kaRrdbuzzFs+q2QRtiAgDBA9fA=
Date:   Fri, 26 Aug 2022 00:40:20 +0000
Message-ID: <CO1PR11MB50890D5A3470D9921711A91AD6759@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
 <20220725205650.4018731-3-jacob.e.keller@intel.com>
 <Yt+b3XGbAixaf124@nanopsycho>
In-Reply-To: <Yt+b3XGbAixaf124@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37275ba5-4060-4f96-ade4-08da86fb8e4c
x-ms-traffictypediagnostic: BY5PR11MB3975:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: otT4CzJ38UullBJDYSJapZenYLZZ/DgM3PH3NbcTTH9CLeS1lLuDC93GdVweH9O6+PiM9OJO5HtldEO1mKimHHFra+yFH3Q0VLaUlMhKOrj4ZMbs3MPTh0hyIyds0iWt5xYhjCj5cbRt0oAMjw5P+TmFn1yRnCDdSEmYk/5btxsWO//W7vWk6twIQZyi8owP5CiqHCycNgP+b4Slx0A7G1AzVezziSWANBSSy8cG+2Z6TRdGd+sK44OfNpifSEqlXr6llpbLX0rQ7kKJjPYL3Nvc1TwAWRQUz4jL/0s+WKJITZFuJkYQgF76OQsBnZJv7i2q2dVKdIU8dSGH/cnPfDCI9T134fjWDWgk81v2Zj2GhaADqSMnDpsi2uWPSyCVB1rjUxEWdiv3RiaUYLfRRRCTIQ/qPnmALRFp464KWqyXULaK4cSpjv2PdK96nMY6PXULdjiXZT3oRysWzkdOVBxKStXNY8jtNKFdM+XP1Y2fEOPvSSKpjUhYBcr1zoZd4MNKgBI1y2YBX8DDNJE0Nl+PWVaua8NKXIHzoaysWGv5S8znmrZSXxmuk0HZ2QypPGUjm20IsU1WIT0e230uh+2s9XhYh3ZgigC1MygfU75Cv3dxEhMSlbTlvTiVKc30iPe/AHW42tfengzGcJV06sEWm86PBgI+uhK4ZSt9mK5Hif4smpCz+ZDktxJ1ytexiZ+9HCXHoiVJeKs2tAaKX+8A+am9lBjDV9DfBp97f0lN+0QjV3w9rpW0WwFvJwP4a1gHOxn1+5KJF976J80fMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(376002)(39860400002)(478600001)(53546011)(41300700001)(82960400001)(86362001)(33656002)(38070700005)(9686003)(186003)(6506007)(83380400001)(52536014)(26005)(7696005)(55016003)(6916009)(54906003)(76116006)(64756008)(316002)(4326008)(66476007)(66446008)(38100700002)(71200400001)(5660300002)(7416002)(66946007)(122000001)(66556008)(8936002)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OMsmHdScfM2M2sTJfmGKoYnM3h4MUbqujQVyWJ7GQsPIT/KOqnA/jgZ6c/B9?=
 =?us-ascii?Q?sbLTwUP/65ArniqpLxcFbYdOeQl8JC0xOUTtggplkx6D+6KvZR3eyJpFpjAL?=
 =?us-ascii?Q?53a9dcApfdjR3XbRDE50lPFJ71v/YPCTM8AOs5q+o45y6hw1GSAC8OhnvAho?=
 =?us-ascii?Q?x2wT/KcbSPWygzFSBCMJgIBdK5gzy2sM+xzmRIrIFrifMIFBgyZthkFtM1HD?=
 =?us-ascii?Q?nnbJA7lIennXqIf5ff4fx/JvFTneHXS/puxk/gAKkHDN8XaRkv6JSz4fcZ19?=
 =?us-ascii?Q?/QXLd37MTKv0YQzNBM3IbOf9Dhb8DAIzg4oXGlNysdhoMizLizS/Wjer9oRp?=
 =?us-ascii?Q?8LcvGrg8s78L46ZEGOXuOtzDy0lj9AmvlbJCoAbEbVkIkr4EU2x+mVSfvRms?=
 =?us-ascii?Q?VWkzfrchcktsR0F8ZxjsL/T1HWG0F8n7smNc/ButC7irI5Pkxa/Awu/bVyAn?=
 =?us-ascii?Q?EuIhRe1Edeph2H0ls2lV5LlUlicABwrhU6GNlZ4qW7Uwu/y0xvtcwsw+6t8+?=
 =?us-ascii?Q?H8PWOAehmO3+ktr4PD24+JQIfA8PYVqOVMpcue41WittjCysSA2OK119XiU1?=
 =?us-ascii?Q?IwJFCrX8MevRkQplkIQYcVERsjAx25j1yGA+rTHsfGjga2aStUHYZKHoj24L?=
 =?us-ascii?Q?mUV8KRYCgBnqt8KWxU/cMNJ7OqUoBIXBL6DQTgj20VUvu6xWrllKuIJ2nsP4?=
 =?us-ascii?Q?OpeFT7CjMPn8ViwVekDB/7DkMopjM0ymcL3CHztwuA1nIiMJ5QQtxhY8GM0L?=
 =?us-ascii?Q?J0TaKZPOzAEnG3swCVmPSlR7HAIHOgdDEbjLXtzHnL/BEwiW7+nxIW9i1JIM?=
 =?us-ascii?Q?cA29Y+8Qvx1K6T3WMtVBRzoFfSnSbRgejaWOSe6D/gdkSupFJoyj94X2IYw1?=
 =?us-ascii?Q?/MTuEmSvGvf6XtoBC7gHfGiOGHxpml+M71KNE+ZgGsPuQFdA96W3iFDt/bmk?=
 =?us-ascii?Q?2reJKI45sLAkwI6uGN0Ezj/uyO2ddzHclLl7TdEAI9Pl5ji3CcRzhyOyTwG+?=
 =?us-ascii?Q?g/mwrR5VinxBcLk0xKv0xYiutq4IOA3xZV3wDBZ1t7TOGbsU46/45hSp1o2b?=
 =?us-ascii?Q?Ilsdj6VxP3VbuFaNvEVTmrCh6DfQsP/JB617yhzoVxl1Wp+i3RGzuWd/5lab?=
 =?us-ascii?Q?8rXWEllWqTC1Rp4sTKqZ7d48W1sdVo5f9Y0TIUz5WDUMbwiWWbPbnrJgIHPN?=
 =?us-ascii?Q?rro+HHmfMD706J8zw09EDvlS8jUoL3SR2GzHMxsq3KT/YyeVn+50KIGUJIH0?=
 =?us-ascii?Q?WQzsG3G+f0cTms9cS1ztoodQgD0TqnjtZCgcV74B/cl3svTNxl+B+nTnMQ32?=
 =?us-ascii?Q?XeNmYFagWNqDi6WqPZW7Q6l3iLb6Udr1Re0tD/OtMM2oAvFucF3UjtGPSfBl?=
 =?us-ascii?Q?yya+dX5GMJ2YkYh3YbqAWK9Nwn15c6ZZWFeZwq3OqqXVwOqJjKVrbZ4xItrD?=
 =?us-ascii?Q?TJ7eQj+WEcLngHJ0aytZ+ngSXpbxHB6x0WskrgQzHRIPSF8JI3K8vUWuHKph?=
 =?us-ascii?Q?IjK3Cy5QoAz/PqcqbqXtVmJwgkGmgUJGFvW/ULUX/rnxyve4x6ik7ISxX8sB?=
 =?us-ascii?Q?O2or0IPB6h1mnv+1sG0C3FtuUolW5wlYEAiKY6fr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37275ba5-4060-4f96-ade4-08da86fb8e4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 00:40:20.8025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALWBKWvWb0/yEOsntBVe1Vg+kRSCl98OBwq07fmgZ56/EKZsPv0e4dJ18D0yRDd7n6C6sMee4+yNKeI1RbbPN8uIBfnERcqRgpK7u62Jepw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3975
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Tuesday, July 26, 2022 12:47 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; Jiri Pirko
> <jiri@nvidia.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> David Ahern <dsahern@kernel.org>; Stephen Hemminger
> <stephen@networkplumber.org>; linux-doc@vger.kernel.org
> Subject: Re: [iproute2-next v3 2/3] mnlg: add function to get
> CTRL_ATTR_MAXATTR value
>=20
> Mon, Jul 25, 2022 at 10:56:49PM CEST, jacob.e.keller@intel.com wrote:
> >Add a new function to extract the CTRL_ATTR_MAXATTR attribute of the
> >CTRL_CMD_GETFAMILY request. This will be used to allow reading the
> >maximum supported devlink attribute of the running kernel in an upcoming
> >change.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>=20
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

I had a new approach which just extracted maxattr and stored it hwnever we =
call CTRL_CMD_GETFAMILY, which I think is a preferable approach to this. Th=
at was part of the series I sent recently to support policy checking. I thi=
nk I'd prefer that route now over this patch.

Thanks,
Jake
