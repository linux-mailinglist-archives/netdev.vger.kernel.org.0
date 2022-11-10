Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD7162381F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 01:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKJA0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 19:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKJA03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 19:26:29 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BFC28E31
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 16:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668039987; x=1699575987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ljaGyWhK+OFUoVttlRD7ZwgRwBEr0WGU/HZmkJZRHpA=;
  b=RERRJqt1rVP1widw50CsnEOncoGhFWt44LzI/W1AV1hIAD6b8IZktR1d
   dnARZ0ckh9ZgSEEosxjv837Txxu0xmTmjzavRZGkRHQHnZ2+CbcatOQUD
   nDwLqOH4LuagJHBDtiu0lQvv8D81+lSU0jZk7Q6hcVhs2dvQEmXCVYYqi
   I3dqfRVKBSyNzTKQwEUbNSsPtwPvq/XwwN1fiforLe1VrfVtwsqFroF8b
   L2U37pNxL2TjbzpRApUDGOyANLTs3Bb/b2iQBeTPvzyfkuzRcwQXlchGe
   uHlDujKd9K+iB+xkGhNngsBZdVCobfmSsBYb0Yobzg1Meg+rArAeYmEqJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="291558194"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="291558194"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:26:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="811832691"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="811832691"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 09 Nov 2022 16:26:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 16:26:27 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 16:26:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 16:26:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 16:26:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjlG9r8o0rDJVpvASueskYQSa2pD26XO+II7ooiarjK2KTaUQAC2P416/mj5Sd2evGLLzZicixagRTnLi+j09+ro0NBMK/X8urYVWxKnX0RIXKCjye0B4iXiPpdC8JXN+2VC2Oy1XAXOKkfidN+QcX6WuPPN93BbUGT6eGH+ovmpy6cqqAzOCZSjvbRQzI0aJLLlImJZDJvnB8d6cN+2fOFM0vwKhbn5BW2SHBQUXBmHrXtXO4jvawDwQ1jR0Mt4JQRGS2J/2F9VnB4PmOpfS/cBFq3CIdGvfKvx9GgK5XnItSddv021p4AopYr+aWxfwjZ8O+3Yxa8Q0JucD8MCLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrRg4nIALhuS1H9TJiYguPXFRgCjLeGHjx7WsDKbopo=;
 b=ffFjCP1BY9lG3oeScD0+keDDpdN9EJtbKtDsO8KR8lYsSwU/owVfDQ7PCr/rR43ZReJgssNe7FMRzGR07N1NBS3AiXyphoW4qtd2bx4PRGknfz660o4JdwhV6E/JZEOzdoRvSAyKIkyeuoiI+aG4++9k04J5uLgQknVxALGUR2/W17+EeDZm3hiHX41ejocG6qiLGFliKoSGdkoSz+RTaG32Wm5UOI5TShlTDAuxr32DG9NJE3Dxh6brWnNBeHkYq7iahdVLTvqAt/wBLPKFUedZ09OazOqzKbK7EiX0ilmQoSMtpqP6rowMm7dS/roA1JGI2sD8/8+LoKrjVA1Cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by CO1PR11MB5010.namprd11.prod.outlook.com (2603:10b6:303:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 00:26:24 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07%7]) with mapi id 15.20.5791.022; Thu, 10 Nov 2022
 00:26:24 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Thread-Topic: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Thread-Index: AQHY8KdfpSb+i5x9bkm0AFWh/WFpPq40UYWAgALOQhA=
Date:   Thu, 10 Nov 2022 00:26:23 +0000
Message-ID: <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
 <20221107182549.278e0d7a@kernel.org>
In-Reply-To: <20221107182549.278e0d7a@kernel.org>
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
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|CO1PR11MB5010:EE_
x-ms-office365-filtering-correlation-id: 8aa0e3ff-fc3d-4bfd-ba2f-08dac2b232e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HbObw+Q4+LT9DNzkSMHkcDZMcMvbU3y2t8v6KO/kUmjF/vEPVTFgv+j176MhuAy2U+0llc7aKYAfyVRmh/e+nAJOto9WUAplY0DgsiXapdegZ0F4Y7s6ioHHL1QEnWtJuIfjm4e5gee+6mo8/R40LuHdvZDQixB3GpLmFyMcSD/dXolkTtDL6R7Nc0vr+JXptUqoNL6uHOYSW2h8e2jmLU+4vHjtkX4CMsEuv5nvxjjJfBGUHpW4/dPDOJQjJ+MNiw4v4ZyC7qDYpzxu3+7DlkhQ79ZZKG9aq8DrQpEIk6bjmVbjpV57ycarg7vhNGETeS75yJlzxoKjaPRWuFwxo4wXv5EC4CZLh8I/+4CaFxc50E013Ogvb5MBYLceV8UHq2be+FsOKwDN/IQcPhzuTVot09J+7WHBZp0z7/qVnYP6rLcnVnoukdwjpeSbx4B4CG1ZHj0iKogwH+zvlHKId1yXznWDwi0Fb/MFtma0Ykq5n2McT8WhV2eqE0jVstlaQNLlVMdkEqPLWoIBtgBjNgz8y9DiBQlBFXZlTiqKDTMYvAC2g4YFF+4PkxXuLSCEAhox/S+I9jWCjI0ZgtEzTvf+Crdea2lxOeEvFq7wFrrUq37ABV7CIzkrJysmh0fGYnGH50yMxdy7T826LEMdWNYs7Zty8ztGM4pX10fvwv7uhbvGhX0E0MuzGDtLIbRzA0O4EB5q/RW1otRiOEV3vATPWFGbXK1csLgkL6IOJw2hM10en3oaMcrmH/sxh2ISMdYnyGueuUtCZwHYMyfTxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(33656002)(86362001)(38070700005)(7696005)(5660300002)(2906002)(82960400001)(53546011)(83380400001)(38100700002)(9686003)(26005)(6506007)(186003)(122000001)(71200400001)(52536014)(66446008)(64756008)(76116006)(66946007)(66556008)(66476007)(55016003)(316002)(54906003)(6916009)(41300700001)(478600001)(8676002)(4326008)(8936002)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8n8P2Th9CHN0q8nT6Cl6WaDZ1743RmItK/wTq7Wa08EVmaerG2dByW115WYJ?=
 =?us-ascii?Q?CknDUcnddLaApgW0Cpkzksl3vY/XJH19vVboRkpPlBRDZ5ndFgaj95rkq5Oy?=
 =?us-ascii?Q?ZiVyhawAnq3QsTomKOj69ipr0qt8bZmglSu/p8ikmgrecBXPGMDYw+cXoE2p?=
 =?us-ascii?Q?p+msozJT7iHfkmELJAMdipI+31IkAxZhghAywLeCDRKXtUbwaHC7wT0/Hw13?=
 =?us-ascii?Q?mxKCOVMGnq9cDSTlO+IW3QZczbrbk2aAN4bIrxDBjzoSvbaFxvD2i3oICFYy?=
 =?us-ascii?Q?3cY4D0lYMM0jGpqSBEqJxzppnsVpH6DLMA7jFpttRqGng9Rc2ZsmCnfwqwi3?=
 =?us-ascii?Q?+CtLy0ZAISOhSnCNRLKmsymTGTPYT/lsfI1T1q0EPq9/OvfcXSLJOVLpJNQ5?=
 =?us-ascii?Q?Dc84zSr1CaSdwVhJO4sOQO3ZxOrmnysXNI0hBh397r5SptmvjPWDvIosKIkx?=
 =?us-ascii?Q?HkrFV1LCOXGnWSYFjx0GI4zgSKQxu91kHvrTaWDlPkiWRhQ3tzKjeqNR22XB?=
 =?us-ascii?Q?MyJbrKHmW3oAVuHQM6nGbniIhn+dbC1PxdFi1MWCsS7c9V/Kebj64ZYAwcXP?=
 =?us-ascii?Q?VU0qYN7LXySXA7K3iF413GhQvSUpEfzj/AyWMWKqtO1+iMNOgL0LQ/v4gMAC?=
 =?us-ascii?Q?QWA73Xuji7guRfeqCRWW69b10elwzjwnpc0SyjJTbvtQ05QG1yDFm7EJs90Y?=
 =?us-ascii?Q?5MQyiqz/zviMJaZZRsQVqQjYljrBW4o5qJhu8ryyGe0jqGdfxBUqHDw5HStS?=
 =?us-ascii?Q?46psU96ZhD2AMbZxts3aJtirJPPjPvyvknP+uzbeByEQ3qCagwTBqA9IgZrq?=
 =?us-ascii?Q?Vag7blJLo9UGMafgLZWMtntj7PkEYP5DG2DWcGD2E7tT4WCwEkcuHXaEeAA8?=
 =?us-ascii?Q?6PCgOhrlommvCgGQfo3zdJ67f+rZ22hXvRJ9STIRTdYWSMNPvdaM85jp1A3b?=
 =?us-ascii?Q?SK/qvKcuNJ9p6APIi+g/hr228Co2jPhPkXoX0YdLLqhyf1U/xJD4jcZXvkFw?=
 =?us-ascii?Q?TOAvfhlsipny3sSxH9nBZWZ9PGE0ZSkE/87WwpfUMVeYjS1aiAsLI3dyCupk?=
 =?us-ascii?Q?60t0zXYfTU9m9rUk46PaUogDHgBIpk5KzUUsiQNM+vFOKJ6RFQKz3vC/HE0M?=
 =?us-ascii?Q?hHOp5NV6Wc7VylpAjHzBZC13UCgMC4v6K2NBitayCvc+ZcikpDKowruo4S8V?=
 =?us-ascii?Q?CnMr58Em1GT++cBco/jm6M1kFX3P+ZHuwwQcCBvC2K87gkplZe/hSZfaumNh?=
 =?us-ascii?Q?pCYzo7vtX+7Vf0oRLnU5JHzjBNKmnfVH4dFN/4IBvvIsmmwNpvfxepOPSEFD?=
 =?us-ascii?Q?8Q8HppXynQOjYTreQdnRApRUH2s2qRTxWkN3kQfwqjwZLvNxlbToqV7VtlcG?=
 =?us-ascii?Q?DJWYRlEpU7ln2EXurxazJ52Kv+2WAfgBwYfDdDp9WHvZ9tDBwOl1Q35bv/0+?=
 =?us-ascii?Q?2RcYJCwVKZtj7GSRPsO76Ev30BD/aWnrT8lSIBSgHbpnPAaAKgRY10o7BAI2?=
 =?us-ascii?Q?PQqYQlicAe/M+dFcCAWZwMH0pwa65YpO1Ig2astIGIB1j90HIKGJF6jlwHAC?=
 =?us-ascii?Q?8ke1NvgzqoDP9wgB+fVm4OFHfDuJ7l8rZzcvVvtAKCN0jv9Y7D+VEHUWU9+b?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa0e3ff-fc3d-4bfd-ba2f-08dac2b232e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 00:26:24.0023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kIuTCMj8L5fWBZrfzDIOYwFn1IMPH13BSHEU09amEDYpHTS/yzcPc8MDaSSWoZVGKayyrW7J5/131hpNFs/s5PSCrxWHpqL9YbJudQLper8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5010
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, November 7, 2022 6:26 PM
> Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh
> support
>=20
> On Fri,  4 Nov 2022 16:42:44 -0700 Sudheer Mogilappagari wrote:
> > Implement RXFH_GET request to get RSS table, hash key and hash
> > function of an interface. This is netlink equivalent implementation
> of
> > ETHTOOL_GRSSH ioctl request.
>=20
> Motivation would be good to have, if any. Are you going to add new
> fields or is it simply to fill in the implementation gap we have in the
> netlink version?
>=20

Will add more explanation here. Goal was to implement existing
functionality first and then extend by adding new context=20
specific parameters.  =20

> > +RXFH_GET
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Get RSS table, hash key and hash function info like
> ``ETHTOOL_GRSSH``
> > +ioctl request.
>=20
>=20
> Can we describe in more detail which commands are reimplemented?
> Otherwise calling the command RXFH makes little sense.
> We may be better of using RSS in the name in the first place.

This is the ethtool command being reimplemented.
ethtool -x|--show-rxfh-indir DEVNAME   Show Rx flow hash indirection table =
and/or RSS hash key
        [ context %d ]

Picked RXFH based on existing function names and ethtool_rxfh
structure. If it needs to change, how about RSS_CTX or just RSS ?=20

> > +  ``ETHTOOL_A_RXFH_HEADER``            nested  reply header
> > +  ``ETHTOOL_A_RXFH_RSS_CONTEXT``       u32     RSS context number
> > +  ``ETHTOOL_A_RXFH_INDIR_SIZE``        u32     RSS Indirection table
> size
> > +  ``ETHTOOL_A_RXFH_KEY_SIZE``          u32     RSS hash key size
> > +  ``ETHTOOL_A_RXFH_HFUNC``             u32     RSS hash func
>=20
> This is u8 in the implementation, please make the implementation u32 as
> documented.

This should have been u8 instead. Will make it consistent.

>=20
> > +  ``ETHTOOL_A_RXFH_RSS_CONFIG``        u32     Indir table and hkey
> bytes
>=20
> These should really be separate attributes.
>=20
> Do we even need the indir_size and key_size given every attribute has a
> length so user can just look at the length of the attrs to see the
> length?

We can split indir table and hkey in netlink implementation and sizes=20
won't be needed anymore. Above format is based on ethtool_rxfh=20
structure where indir table and hkey come together as last member of
structure. Will update it in next version.

>=20
> > +static int rxfh_prepare_data(const struct ethnl_req_info *req_base,
> > +			     struct ethnl_reply_data *reply_base,
> > +			     struct genl_info *info)
> > +{
> > +	struct rxfh_reply_data *data =3D RXFH_REPDATA(reply_base);
> > +	struct net_device *dev =3D reply_base->dev;
> > +	struct ethtool_rxfh *rxfh =3D &data->rxfh;
> > +	struct ethnl_req_info req_info =3D {};
> > +	struct nlattr **tb =3D info->attrs;
> > +	u32 indir_size =3D 0, hkey_size =3D 0;
> > +	const struct ethtool_ops *ops;
> > +	u32 total_size, indir_bytes;
> > +	bool mod =3D false;
> > +	u8 dev_hfunc =3D 0;
> > +	u8 *hkey =3D NULL;
> > +	u8 *rss_config;
> > +	int ret;
> > +
> > +	ops =3D dev->ethtool_ops;
> > +	if (!ops->get_rxfh)
> > +		return -EOPNOTSUPP;
> > +
> > +	ret =3D ethnl_parse_header_dev_get(&req_info,
> > +					 tb[ETHTOOL_A_RXFH_HEADER],
> > +					 genl_info_net(info), info->extack,
> > +					 true);
>=20
> Why are you parsing again?
>=20
> You hook in ethnl_default_doit() and ethnl_default_dumpit(), which
> should call the parsing for you already.
>=20

My bad. Had used other netlink get command implementation as reference
and overlooked request_ops->parse_request.=20

> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ethnl_update_u32(&rxfh->rss_context,
> tb[ETHTOOL_A_RXFH_RSS_CONTEXT],
> > +			 &mod);
>=20
> ethnl_update_u32() is for when you're updating the config.
> You can use plain netlink helpers to get request arguments.

Ack.

> > +	/* Some drivers don't handle rss_context */
> > +	if (rxfh->rss_context && !ops->get_rxfh_context) {
> > +		ret =3D -EOPNOTSUPP;
> > +		goto out_dev;
> > +	}
> > +
> > +	ret =3D ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		goto out_dev;
> > +
> > +	if (ops->get_rxfh_indir_size)
> > +		indir_size =3D ops->get_rxfh_indir_size(dev);
> > +	if (ops->get_rxfh_key_size)
> > +		hkey_size =3D ops->get_rxfh_key_size(dev);
> > +
> > +	indir_bytes =3D indir_size * sizeof(rxfh->rss_config[0]);
> > +	total_size =3D indir_bytes + hkey_size;
> > +	rss_config =3D kzalloc(total_size, GFP_USER);
>=20
> GFP_KERNEL is enough here
>=20

Will fix in next version.

> > +	if (!rss_config) {
> > +		ret =3D -ENOMEM;
> > +		goto out_ops;
> > +	}
> > +
> > +	if (indir_size) {
> > +		data->rss_config =3D (u32 *)rss_config;
> > +		rxfh->indir_size =3D indir_size;
> > +	}
> > +
> > +	if (hkey_size) {
> > +		hkey =3D rss_config + indir_bytes;
> > +		rxfh->key_size =3D hkey_size;
> > +	}
> > +
> > +	if (rxfh->rss_context)
> > +		ret =3D ops->get_rxfh_context(dev, data->rss_config, hkey,
> > +					    &dev_hfunc, rxfh->rss_context);
> > +	else
> > +		ret =3D ops->get_rxfh(dev, data->rss_config, hkey,
> &dev_hfunc);
>=20
> This will not be sufficient for dump, I'm afraid.
>=20
> For dump we need to find a way to dump all contexts in all devices.
> Which may require extending the driver API. Maybe drop the dump
> implementation for now?
>=20

Agree. Will remove dumpit for this command.

> > +	rxfh->hfunc =3D dev_hfunc;
> > +
> > +out_ops:
> > +	ethnl_ops_complete(dev);
> > +out_dev:
> > +	ethnl_parse_header_dev_put(&req_info);
> > +	return ret;
> > +}

