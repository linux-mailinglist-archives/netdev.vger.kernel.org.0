Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549DC5A0065
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbiHXR3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbiHXR3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:29:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC3E7CB6C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661362175; x=1692898175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z+MAp943wuKQb3jvUQqu3rm5C8s7xkATrPwEFY0Wdx0=;
  b=WdCynT4w73bb7PPUClwDlHM9NThkwwib5aIJsSNW1GdzMXNgtzKHGf6D
   poJFC+PkF1sZ1Uh5OezYjf6lxyPPiIU2xVrP2Q7z9llHmAlJ1kv07pAGe
   5sXdhX/zQrEfZfObtIvH/hiWBN7n4itQ6dqU+cmC30Udc5z77/VlWNr1X
   UApZX2i4CYT569rBFh78Doyu/iuD7KdAiCmbBsUaXEOi4S1XTcdqHhTkE
   fAaHpl8FSAw717RKvOl3WzCEuzjrfkzQw5h7C+FTv4++UGI69C4184rzM
   mdEG3O6zlip5SlRsHrPx+XNghHqHnKtIftoBfVVI3Slqo87C81dzeyUG5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="291596833"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="291596833"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:29:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="785704394"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2022 10:29:34 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:29:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 10:29:34 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 10:29:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmoz0OgWPQujCHf9Sv9xAHu3Bk6UazE78IBmPdHukRUfQIe+ryCRNTanIQvoV6Hoo3FcaKqjS997kLj6sVK3/eb/mAPqZS/oicEPaodS0M7trOiJfVjAMJGnE+h5SYRbY0P0Uj2NMPoHBqr7kezZN3HrZdCIGXe9TsHSHjwUVzyq/Z59MJmexHnFt7xZoaRN6qz2EzyWFXdfCM8XDuOY8zStIvDZufJW40Pq8BAM2vAyIpkYW7Vjf2teBggR2GJTGCuqadrsgTtf4SncTn+n/sA2CA2OuzrUknB2vkc3adcUfAIwvcxqTGV7OEo7NF/yYh8yNhYtLV3iwq0T1zIvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlpPlZl5toN7AAunNiw5VKxlvbq4GbksyMU+Hu9UiN4=;
 b=Uk3J4JnRKT2tQC5m203Jmskip7jM3PwQdoswxTAJCIZXu0VmSqbQyfChqertcHkGc+UQGnHqONo1xmBshASBqyocfp4jN8E7VKRpkGWOURJ4kkIlJfUEmxIhsB+eh5p8tme4jqrAZFxRDR8czkPUA+E+h4kcd8+r/orS7GR7VmLNFn8l8LE7q5FLX74Lcfkh062199IuMOixWQFTxVyDw1VVJSTE7FSABdNUgiOGQdqYE5cZDs26OGBf7mCSZmixL1+jA4DQJYBoNv9pvpnLHRB1IRVI+5jh/Qx858j7++ftB5ZTzoaWJfJAX+7uZxjtn+Dp7dY3HbuhSYlkJL8gHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM5PR11MB1564.namprd11.prod.outlook.com (2603:10b6:4:d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.22; Wed, 24 Aug 2022 17:29:31 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 17:29:31 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Greenwalt, Paul" <paul.greenwalt@intel.com>
Subject: RE: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Thread-Topic: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Thread-Index: AQHYtwG/f8zW/T1x2kmfvh0Pne5Gi629DlOAgAFBZtA=
Date:   Wed, 24 Aug 2022 17:29:31 +0000
Message-ID: <CO1PR11MB5089DF4A594B96E33E7656BDD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
 <20220823151745.3b6b67cb@kernel.org>
In-Reply-To: <20220823151745.3b6b67cb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7755bcd3-01fa-4b14-5a6c-08da85f634aa
x-ms-traffictypediagnostic: DM5PR11MB1564:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nkbjj7Yv1x3Gv5KR/akn6MzsyuXxdJkcldBkN7gm2kUJvFTk1knDSOENUb88ccEu2CHk3+4JsOSVZTtdAOid6vN10vE1dDySZAKttbqYR46er9k+HhoV8DMYxl3cinBPV6qq1wiftOLaUgE0MIZhdU1v6cHhj7KLau9kP47WqmaXL7FnGW9V2vfh9RWMVGkgd6AEkA4uvp1XYOBs8SU5G1F1oYc930nrdtTzMupTqU7l4FnAklwry2JiZ2WHW2KQumvMTBeo0tNCInir4AS8NudTqNEAxdyzcel3JhRH4X2Dz+CuEZp6YaCWr3ve7vAHrs5MjklrejTbZ/sREuvlbnCY18a3MqA+D7E7YqZKaPdcpXLcF3B6oFTQuj0TCapnAuLUjK52/lIh5TTtx1LcZW6acj4FPAiLBXizCVrHKFGXdjp0GS8xzsDcFy4R6ESyg5mrV3tNzhBpq7PnmufLRudgQ2YH3kyEHFtsKo8T49SQs3T3iu1EYnwcAX5bZyC3un/6boVZPC3nM5crgN46BEQIZDeOinT1L8Mk7/lu3fkzLv7K6I11NtXqygjw2TAN5XXQ+bL/QLbtfpEn4caAl+BBkdenCMC6+8OTbzsFRIEDLP+Zx8zADvmj7JFjJW0VmmOICiC5lOiN38tKFwQDqTh+Qk4QjroIV3rGpSfBjNEdQtXnfU6eFEoVinfxWzhUwh82J7X3WhpqR4cL8QOmoLgC7z5wky3oI5jh2/K0WyvxKUZPsHBmS0YO1tTbHt9jcttkkNrDNsXk5Krku3LsPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(376002)(136003)(366004)(396003)(66556008)(54906003)(6916009)(55016003)(82960400001)(8676002)(66476007)(86362001)(66946007)(76116006)(52536014)(316002)(4326008)(38070700005)(66446008)(186003)(83380400001)(38100700002)(478600001)(71200400001)(9686003)(53546011)(6506007)(7696005)(26005)(33656002)(107886003)(8936002)(5660300002)(64756008)(122000001)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3py25Ts/I1Tes8QW7LfSmQ1u/HPbnbsLs4spa+wxViNok3z/fzmgjDaZ5Yvf?=
 =?us-ascii?Q?TuVrjk0/cDOtFpH8kIaUdFZ4LkGoPqD/jImyvjDlrcZT8qXbPbRGzqGXPyDZ?=
 =?us-ascii?Q?lrfXx5PbQtqPY4SSJFbDmEabRUMdrUq2yyq7vuJe5J0dHRwJGtu4IoLkKQXI?=
 =?us-ascii?Q?plDkD+6lBwegrxl6D4ey5RWcsxQnklLmVD8d8UbT5qVWU8j8T3yVAGbHhlXG?=
 =?us-ascii?Q?s3QNehjiHKNiDQqIzEu5vpTYEV9DNDsQHvI41DQJxYWwO7vHyv2i1TcIR1M9?=
 =?us-ascii?Q?5W7sM+BeT4WtEDVmG8EJK1QQ/Suu+WdUb2FfyytWEAKTwZwEkNsdcG2U2hUd?=
 =?us-ascii?Q?UQGodIbEsXU94i/lR3PRHQn/vMCfD03TO9IQ157rATo69/clyYrN5SMzmvsh?=
 =?us-ascii?Q?IQLRwGeYkUzTblj141cYln9QEQWWTmjgYNf0ZS0/PjWOCD4PiDhubG8lTD1g?=
 =?us-ascii?Q?Fwo+BqQhEFzfUaITvsIoLUuHoue5vdNSYRmG/NIVcs6pYiYCgfADXSsy4k8F?=
 =?us-ascii?Q?tq3afVrlWnLaVrwDMT8bcdGUGwrt94yEj1zAFllexj7CoRim3LlempdFPVHD?=
 =?us-ascii?Q?AObBXtyNHqRK8jkOusLBa4GAA+sExNzBLaDcKyZG3wB3pE/L55Y83PNXFUzP?=
 =?us-ascii?Q?5W2xWPBB/SWRBbWWEj171tsBJ3IvySvj6mOoKEbGzzYN18ciKVrNvmsIC7YS?=
 =?us-ascii?Q?Zd8PmYuRMfaUSGDTxlhpriFXtTYD9NDvYa3D67mH9okwq1yhfY60QpIzCHID?=
 =?us-ascii?Q?6qzMxsy0CMe543q579bdb4Z3JYJFgRp5vI+8tVECbnV+JcwMHsACTHRq95g2?=
 =?us-ascii?Q?mPjTYjg0vyXrb1Y1cUV0KpQi2W7L1J3yIxahcsTuCsaeXt9ySd3lAwPEpYyP?=
 =?us-ascii?Q?fyQrWuHpFvjWoO4dQRVyrQ+wpPgBVtTWZrr1QGV0Yy47N4OdJ/iZQJma1X7R?=
 =?us-ascii?Q?jj35sqolM9IHy0IAMaH93pYhx08QS2UIRT/BieeZI0h4FoHo1mdCu+VKBmWI?=
 =?us-ascii?Q?tYjjTw+pydFvBA/HJFiQUsc42CAmom+dm4g0gXD+BlR72jzTMU9YBgCqLk5C?=
 =?us-ascii?Q?mTIITwev+gCi1N8urNQ1C6XzWsoBXnsyHwWgSrU8ylZVJtCKEixpcfC2WapR?=
 =?us-ascii?Q?YenTIbhgvQqSu5RpuIkmTWwqdd64j/aOVgACCMe3gBlzXMs9bDgpKr8zALYI?=
 =?us-ascii?Q?QoVl6P5sZpxmM58rMI1cH5212vp9jp4DouZwJH7jB8GJbwDlwqxFV5tC3SQh?=
 =?us-ascii?Q?eoWIUO4JBv2pCd34E2e+3aF7hb73iIqy+HxLaaIdUyV+OITG5uPtK8S0UO3g?=
 =?us-ascii?Q?8AAVGXarcCpcsBopgYF02RsXpLFgJ0AKX399b3qM+VbNV+y1ZUgEhDmKHfVe?=
 =?us-ascii?Q?q6wNdmUNZN9m/vCxqKhuNVdSKXEac3FrMmXSJJIXir6NdKfys+HFY5GkKYWP?=
 =?us-ascii?Q?A4yCnYO26MdNaFPXhr4HX+7fJYJMYzY0BW5jgkGWW063U6PEReZGb1+aPcSK?=
 =?us-ascii?Q?YORJNojS7Vk12i3XMOB36JCNx2u/TPUvolqdfr7LoaOQPs+IYXqU+B+GKxOA?=
 =?us-ascii?Q?pVp8tp8G3NY7Px02KbEHDsad+7xh6v5kbHHoZYdP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7755bcd3-01fa-4b14-5a6c-08da85f634aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 17:29:31.8062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBvx4KnGxZuG9k2BewS98wWHVK9EulQIDyz/aaFWJw50tlxqMRJV3NbvDHMCDCt8uHLaTQlO/sFtzA4Pnac88I5ghizdRdaHq/UDBtIdzz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 23, 2022 3:18 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Greenwalt, Paul <paul.greenwalt@intel.com>
> Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC =
disabled
> via ETHTOOL_SFECPARAM
>=20
> On Tue, 23 Aug 2022 08:04:38 -0700 Jacob Keller wrote:
> > The default Link Establishment State Machine (LESM) behavior does not
>=20
> LESM is the algo as specified by the IEEE standard? If so could you add
> the citation (section of the spec where it's defined)?
>=20

Hm. I am not sure if its part of IEEE standard or if its just the name we u=
sed for that section of our firmware. I'll get back on this and if its not =
part of a standard I'll rephrase this a bit so thats clear.

> Is disabling the only customization we may want?
>=20

Of that, I'm not sure.

> > allow the use of FEC disabled if the media does not support FEC
> > disabled. However users may want to override this behavior.
> >
> > To support this, accept the ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF as a
> request
> > to automatically select an appropriate FEC mode including potentially
> > disabling FEC.
> >
> > This is distinct from ETHTOOL_FEC_AUTO because that will not allow the =
LESM
> > to select FEC disabled. It is distinct from ETHTOOL_FEC_OFF because
> > FEC_OFF will always disable FEC without any LESM automatic selection.
> >
> > This *does* mean that ice is now accepting one "bitwise OR" set for FEC
> > configuration, which is somewhat against the recommendations made in
> > 6dbf94b264e6 ("ethtool: clarify the ethtool FEC interface"), but I am n=
ot
> > sure if the addition of an entirely new ETHTOOL_FEC_AUTO_DIS would make
> any
> > sense here.
> >
> > With this change, users can opt to allow automatic FEC disable via
> >
> >   ethtool --set-fec ethX encoding auto off

