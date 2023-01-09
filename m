Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6118662E34
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbjAISKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbjAISIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:08:51 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270AB183B0
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673287671; x=1704823671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9mxJVugQuapULfFM/OHMsrk32pbHCSpNjSGkYLObsJE=;
  b=ZUSwzz9NYV2ols20jt8Q8OMQOPiAyk77hJxOr6zJfekXZ/6qCm3BiaNJ
   hTcVVd6GuqNWNoGlInQLnESYrdHY7fF63YUDEqMFdGqHfLkUYxIqWcq9j
   kxoHoNxyZkrBM7T+fGgb5dnK2GRSO6wLs1wNQ8Xny/YyHcFZcTCQMTi9f
   UnJgbmpNTUp0JqeZIQv4P1lU+ZEiZh7c4UyUrZHsirRSScr4V3QiZ5lzV
   BP1LoM91F6BG1buVJpDnQUFJTjU2gR++ceDlcqMeIBE2Yx61CUQg1Gkwb
   QKTknnOwk+o5ksoEyQxbk/Hep7cjBONsPxknf2fCBgq+Elzxt1muY92hq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324947469"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324947469"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 10:07:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="764396348"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="764396348"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2023 10:07:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 10:07:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 10:07:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 10:07:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9ITheNy23rRdoNwCNjRK1XjFIe8beLWDRwWrSRC08Cq+eBQ1ehfOrbYo31cOxQuhRFXAC93ldfBwTV/XZZZeiqSIlnJUzUN5uHkfMMDbVlS085d33sB1+FFNU9gxQ9dJbk9fyEXXGJ5QAiTM1esp18z7oNOS6zU9v1onXYCp+OhY9UT8rT2vd8y4e+Jw3l4tqHWeByG2L0JyzjEw5LS/+gevIRwhl4Yd5VcexNNPctR1CwtU9B+je3apvzFlJT3eKo8p/iY6EVxIJ3aBDLRk6HFP88Q8GO5pP++KgtFCAc0PHIdzVKRZXkBPUHrib8VXPu5VoglPi4WzUQc+bdAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uP4I8NE1GH3laClJIK0PlTcL+A4M++wrQ/I9CRh0LE=;
 b=aJ4Sxi0W2wHPuSjrjRrFX9i/wZ137C+lm6J90YjGqodBpmwwKXgmKBIjGoLYHpspEMRjqlfePYiVOOK4MNHeBgOlXzt/9/Fk14LZTk4HdRLIy7OnLo77LkBvdgjJ4+zd+seg5uu+MYnXk/GaiPwAZLxL2NaY5cdn2CTzkE6f8iF8aQa+guf3QmzYkpyi8SnCXyOGDMdGk21NH0dioEL8VO3DtHFr7717aHB/mFC4eTRg24uJEXEWJ6eYxgRe3wkdGzYutARlRb5NQIhaGxKBs6p0e+ZCnM1nkr9PLT1g4rn0rOO3xPhKnSAICXhPY2Pnlsu0mjIzAwW906GfAJ0KSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by CY5PR11MB6368.namprd11.prod.outlook.com (2603:10b6:930:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.18; Mon, 9 Jan
 2023 18:07:45 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c%9]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 18:07:45 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for get
 rss (-x)
Thread-Topic: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for get
 rss (-x)
Thread-Index: AQHZGyNj5InCPxiluUWC+3R4NpNH/K6L37UAgAXGb0CAAFLegIAEdCuA
Date:   Mon, 9 Jan 2023 18:07:45 +0000
Message-ID: <IA1PR11MB62667E12E921F5D2D56637DBE4FE9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
        <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
        <20230102163326.4b982650@kernel.org>
        <IA1PR11MB62668007BA5BA017F5B46708E4FB9@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230106134133.75f76043@kernel.org>
In-Reply-To: <20230106134133.75f76043@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|CY5PR11MB6368:EE_
x-ms-office365-filtering-correlation-id: ea136d41-1927-4cbf-9071-08daf26c68f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5f4G5P3H0A369+QXZ6A5n/0zV+lnnI1qe8Kzr6fo8vC0UlpaPeM6oTFS9jngnwhsLI/UYIO5SWCw9YF/rnhfEI/9dAOkJ+lB2AXUxFQ/zug5MgVEzMzVOJkMBdGxa6od7ij+h/rt7M3kc2uKOtx5CmXeOQ/uoPAOR1GLq2amQx6zQnYGqzbGWKc9afqgAVAIaHO/j2qOdDI9uM9GsemDXKxh2nB3G/1XW2O3+dP+VtMCEmRqKIsacN0puZhIax5+hoaO+9b36bIpIoSm6UVJ77ual84aIjZN/BPQYPPRd2pqzScpdxH8ru9nCTvAemdHKgMrY17KCyKjnXmfZkevdkjbRxSTeTIPf1wMfSxwLa57vBgCD4pQPIAyaJ7cDZDZ3fkbiuOsXI+fP/Ov4VxDKzzswUvxE8fSb+wYifOhmcB8TD84AGqUfGb7rc/BH1kGNB/Yz7infFy+07om/z+YB+RzOiHOvS2gG3YSt8W9o/nDyv4KMBcvVpYjdMTWN2jcNtJq3E0t0OOHyAqdq2u/cjcVWopYIvEa0Ev8yiiHVjmqpfnysjqTAIZBgQ61+MtzbGGse+tuMjGhgKe6S5iFdtluLE1fjptRvxCEhoajDb9f3f9Ew8c1Sf2Dzexx/iQZT+gVT8bMH0RR0It+02oTUT+x7dTTNEZrIk/qdV0AY2WkrDCK85ivPAHyL3mg8eBftILuetRb05+mW5kzvHT0MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(71200400001)(478600001)(316002)(54906003)(6506007)(107886003)(6916009)(9686003)(53546011)(26005)(7696005)(186003)(76116006)(66476007)(66556008)(64756008)(8676002)(66446008)(66946007)(4326008)(41300700001)(52536014)(55016003)(86362001)(5660300002)(33656002)(2906002)(8936002)(38070700005)(83380400001)(38100700002)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VnxWwDNi2iBuH+Vgw0dXwvtK7yzBOCtWufDp9y/aYyFB7qtze92KJELd/Zo8?=
 =?us-ascii?Q?09flyb24j9WEo/9MUxhQvgtrqFgkNxOmC/ZEhtcchNdKzyVz1OnN0scWg/5A?=
 =?us-ascii?Q?Cw65RkCvBEofDbToYm2UeZJxXo7tUVQAEWPIq1fDgxfoKDSBQZ3CxEl3OJWk?=
 =?us-ascii?Q?Ji2lvaj64lx0taL7eNOMzSZtr+LZ6vxeGavKAzatMfEY33NPymPWoW/UIdOI?=
 =?us-ascii?Q?GjMAyftum+AM7UnTL+NEICkP/CrH6u9Cg3y6qKkpei2dC8oDjOGjSA0gi6zv?=
 =?us-ascii?Q?8cISGTK5SdmEAf2/oFGzP423L6u9DwjOv1IaYgdRnp3VeE5eIbNlz+BK1LsN?=
 =?us-ascii?Q?8dEk6Et8F47CCbHmtFirO3dBjWb9t+ySZsWif2nn4iYm+o8Z2+9HiGMDDItR?=
 =?us-ascii?Q?2QTfefYNFBTneFoQ4GYzR5FvAGnMxvgU6jrAQmlruDZQpDuohch24ohAA37z?=
 =?us-ascii?Q?/+37FMSawecNlDGiraxieY/YWM64W5Nn1MtTngacsqM7Kv3Mobu5dI5lw4wm?=
 =?us-ascii?Q?yyg29ro7SorPfXAhrdhiLHdwbEgxgDgReINBraM9yn5TUNw/IP/DZv+0ovz9?=
 =?us-ascii?Q?+I/CB1KCXh8kM5w5jaNQD9I4VLTBoH+EZNUUxi5AL+4fg0O6qM7FhYGbTElw?=
 =?us-ascii?Q?MPFqPIv4oyuxsOPX3rKGc9oTKoEEC9hUuAoDaycqBLeiFaEX/7xY7BBXW7ZX?=
 =?us-ascii?Q?qJww4aRFG4chgbQk5YWGJ/xLxxxptmz/8c2Yo6G/IspipkRrPZWTc5EAYRw6?=
 =?us-ascii?Q?qb9jv7Auf+aORvn7HAgd/1uNND4anc999cJ+uhv5rA61//sfBgB7lnhbI8tN?=
 =?us-ascii?Q?7XRcLysyParmV6D40t/X9xlPyMqrxnhM4hCIaSME/gc6s2rOKbcdEDaA8sNV?=
 =?us-ascii?Q?E5nWD7Wb6FwssLC+yTwiWt6GK1N44Dofz7HugRq1D+nKzkAUxXAFBtYUcB0i?=
 =?us-ascii?Q?XYg7yWAazxGg8rctholVdjU0xYyloqsQrTOMFRoR+IBeLsqDdWhQefDTx0IP?=
 =?us-ascii?Q?TydjMrjOE2UvgTxI9TrwYhEHIDK9Dgb9AzFYHUNcELQhSP+8DLBoOEuKLauY?=
 =?us-ascii?Q?SE1yi4hQlJpP5Cm6RRfc7XbySzJCy8jr1eaEQwt6PdXwPHBOoJiQhqpDSZwS?=
 =?us-ascii?Q?VqRkrMv3KWJ/6ajPIcMdtkrpfaHwB9XjyZ7nT9ge6Rd4Ney26rX3XFsRoC2i?=
 =?us-ascii?Q?R5uu6lMpsuv7SDAmYM35woDRHxBdOM+jlzXp/K2f9xtzZLB/Y7CnEqlg+ZxK?=
 =?us-ascii?Q?8uejnTHS0s06s/cv2jllMmEY7J0zjsyAGkeurfINDPmdjwKa0cKvUvVKRpS+?=
 =?us-ascii?Q?W6hA4KULxBc3YxmQGd3KnzUr9lg4HpDlRVrUu6aymdJaT6gGHfgPC4hkeUsS?=
 =?us-ascii?Q?4PcB6ChiskXYjh3iPNt8A3Yt1vPab12+8PiNINvsl+dIKmDq4C63HGw67Tiu?=
 =?us-ascii?Q?fO2x7EJ2mRpFhwtPXDfmoEni2GNIBavdpIe5HLp7gLMcGeNOPKvFDy9DCwEZ?=
 =?us-ascii?Q?lYmnv97AXJ5LYUgr9EukGTdMwpyZnH+hp9L4zJPgn67VL8CYx/0FJDYoauRo?=
 =?us-ascii?Q?QEQywy1SGOLn+KC7oUWNA4yo1ao4iCL6qhfnVE1E6rcZJwU8jJGbKQy4tLCI?=
 =?us-ascii?Q?Pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea136d41-1927-4cbf-9071-08daf26c68f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 18:07:45.7151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pTk0BOA46/h+nYPvJn2/Fw5GmV10QWSW1Oyj5F9a57YdqlqAr/y6B4xVC6l6tuV69t6gNTm8WvHTps7ZuF462wQjK9KyK+2Y78KVLdDpcbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6368
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
> Sent: Friday, January 6, 2023 1:42 PM
> To: Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>
> Cc: netdev@vger.kernel.org; mkubecek@suse.cz; andrew@lunn.ch;
> Samudrala, Sridhar <sridhar.samudrala@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH ethtool-next v4 2/2] netlink: add netlink handler
> for get rss (-x)
>=20
> On Fri, 6 Jan 2023 17:41:39 +0000 Mogilappagari, Sudheer wrote:
> > > > +	rss_hfunc =3D mnl_attr_get_u32(tb[ETHTOOL_A_RSS_HFUNC]);
> > > > +
> > > > +	indir_bytes =3D
> mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_INDIR]);
> > > > +	indir_table =3D mnl_attr_get_str(tb[ETHTOOL_A_RSS_INDIR]);
> > > > +
> > > > +	hkey_bytes =3D
> mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_HKEY]);
> > > > +	hkey =3D mnl_attr_get_str(tb[ETHTOOL_A_RSS_HKEY]);
> > >
> > > All elements of tb can be NULL, AFAIU.
> >
> > Didn't get this. Do you mean the variables need to be checked for
> NULL
> > here? If yes, am checking before printing later on.
>=20
> tb[ETHTOOL_A_RSS_HKEY] can be NULL. I just realized now that the kernel
> always fills in the attrs:
>=20
> 	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
> 	    nla_put(skb, ETHTOOL_A_RSS_INDIR,
> 		    sizeof(u32) * data->indir_size, data->indir_table) ||
> 	    nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data-
> >hkey))
> 		return -EMSGSIZE;
>=20
> but that's not a great use of netlink. If there is nothing to report
> the attribute should simply be skipped, like this:
>=20
> 	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc)) ||
> 	    (data->indir_size &&
> 	     nla_put(skb, ETHTOOL_A_RSS_INDIR,
> 		     sizeof(u32) * data->indir_size, data->indir_table))
> ||
> 	    (data->hkey_size &&
> 	     nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data-
> >hkey)))
> 		return -EMSGSIZE;
>=20
> I think we should fix the kernel side.

Will do this.=20

>=20
> > > > +int get_channels_cb(const struct nlmsghdr *nlhdr, void *data) {
> >
> > > > +	silent =3D nlctx->is_dump || nlctx->is_monitor;
> > > > +	err_ret =3D silent ? MNL_CB_OK : MNL_CB_ERROR;
> > > > +	ret =3D mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb,
> &tb_info);
> > > > +	if (ret < 0)
> > > > +		return err_ret;
> > > > +	nlctx->devname =3D
> get_dev_name(tb[ETHTOOL_A_CHANNELS_HEADER]);
> > >
> > > We need to check that the kernel has filled in the attrs before
> > > accessing them, no?
> >
> > Didn't get this one either. similar code isn't doing any checks like
> > you suggested.
>=20
> Same point, really. Even if the kernel always populates the attribute
> today, according to netlink rules it's not guaranteed to do so in the
> future, so any tb[] access should be NULL-checked.
>=20
> > > The correct value is combined + rx, I think I mentioned this
> before.
> >
> > Have changed it to include rx too like below.
> > args->num_rings =3D
> > args->mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);
> > args->num_rings +=3D mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_RX_COUNT]);
>=20
> Related to previous comments - take a look at channels_fill_reply().
> tb[ETHTOOL_A_CHANNELS_RX_COUNT] will be NULL for most devices.
> mnl_attr_get_u32(NULL) will crash.
>=20
> > Slightly unrelated, where can I find the reason behind using combined
> + rx?
> > Guess it was discussed in mailing list but not able to find it.
>=20
> Yes, it's been discussed on the list multiple times but man ethtool is
> the only source of documentation I know of.
>=20
> The reason is that the channels API refers to interrupts more than
> queues. So rx means an _irq_ dedicated to Rx processing, not an Rx
> queue. Unfortunately the author came up with the term "channel" which
> most people take to mean "queue" :(
>=20
> > > +	return MNL_CB_OK;
> > >
> > > I'm also not sure if fetching the channel info shouldn't be done
> > > over the nl2 socket, like the string set. If we are in monitor mode
> > > we may confuse ourselves trying to parse the wrong messages.
> >
> > Are you suggesting we need to use ioctl for fetching ring info to
> > avoid mix-up. Is there alternative way to do it ?
>=20
> No no, look how the strings for hfunc names are fetched - they are
> fetched over a different socket, right?

global_stringset is using nlctx->ethnl2_socket. Are you suggesting use
of it for fetching channels info too ?=20

ret =3D netlink_init_ethnl2_socket(nlctx);
...
hash_funcs =3D global_stringset(ETH_SS_RSS_HASH_FUNCS, nlctx->ethnl2_socket=
);


