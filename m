Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76B263131C
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 09:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKTIkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 03:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKTIkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 03:40:35 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD858140E6
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 00:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668933633; x=1700469633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BvWCCBeGG1H74trm5C+K3wqIrwsz61nMadbx8Nqo2xc=;
  b=H/RsLGp+e2+o/FjvrCN1uDWnQXpzWQgPDvF96I1sDz+8qm6hkSs2Tqdl
   7MjzqBPsOeHnADDfg8/x7ik0KXljYT25zRmuR9UOJ3Ks7WeI5FanR37pt
   mzgr5km27Vuszs+mUZ5MMxr4uxsGKwDuX1qRra42uaGb7dZ7hZOujsw3J
   0lHkI1MsKwsII1jhq2IF1N7cSPfyIISGX9O6g6cK8x+pFDQl9MOVtXplB
   4YTmccWR0ugUXtPqcKHEaQbknp2L0SCFdcC85HhEijqCWDtc7sv8hTWVT
   22uuVMxQ41icKYvUvzdHyU2UiplmGipRAt5fnU9wR47LjuMF83gPynEoz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10536"; a="296743212"
X-IronPort-AV: E=Sophos;i="5.96,179,1665471600"; 
   d="scan'208";a="296743212"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 00:40:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10536"; a="746528054"
X-IronPort-AV: E=Sophos;i="5.96,179,1665471600"; 
   d="scan'208";a="746528054"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 20 Nov 2022 00:40:22 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 00:40:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 00:40:21 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 20 Nov 2022 00:40:21 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 20 Nov 2022 00:40:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXhteGGlYiPqjxsm5GKEbc9noEr+Fu7XdKf19+gD6J/pKuZsTcTIpFiY7ZOGTOIdt2QpI5sGtXhREPxxPcIEkxGCSVZf9wIOKuEes15LmwYc69WDGBu/skLgRpz6lxhiK6Or9RRifIVHPyf1iK+fP43jGMrbRiVo65vpCbU446oCg47Q6CLnvRwDuLnaMah5PYrOknRW2JSQ+9Vy80ceZMZQ6dr3LvYXZXJNg/dv6DUv9Jqycl1829t8na84CP2GBfdL6DmM2UDhJqveywLaroJBIvdTlPCelpQStQcI7ithcWhUSgC/bzhYpulHYDWqceiBZnd7IuSrC3otjo3Sxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rR99evjUTRJSaJEE2JQW6HudD7dSku8odjmrO1FYhd8=;
 b=C0aNs+j12iQW98Jfw+c0WeWpm0J7kwmug4+FEKfHE6ZxJuhscUCY2tGujjUhcSaZ4jTBeh3P9TD2bLk/BdqM+Ett7aGa+MvHKj2++740ouU/jDegZOudJWy7D9hDy9lN4UuXBM1T8Wf5ZO823W//x+cGPF1PrDExkATJrVahpyhqs3kz2LYmokeTeSp1f2erxQtFWRZtSIA1irYR9nWouikAy6Xigsk6ALaFPJogEPRzTO1V0GNDeLnlPw1HTuLM6LVadoqaClWviwfotSr61rHKUaBodF4RvQtBsfQkAxqRUAQLYha95rJ4C++GYGgWZO9N8q1lJKyYuC6pKxO8Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by SA1PR11MB6783.namprd11.prod.outlook.com (2603:10b6:806:25f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Sun, 20 Nov
 2022 08:40:20 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07%7]) with mapi id 15.20.5834.011; Sun, 20 Nov 2022
 08:40:19 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next v3] ethtool: add netlink based get rss support
Thread-Topic: [PATCH net-next v3] ethtool: add netlink based get rss support
Thread-Index: AQHY+hMgFozJboAxXUSKmfPfCVKJN65Ef6MAgAL4bHA=
Date:   Sun, 20 Nov 2022 08:40:19 +0000
Message-ID: <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
 <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
In-Reply-To: <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|SA1PR11MB6783:EE_
x-ms-office365-filtering-correlation-id: 04e24182-8b70-4ee3-c8ff-08dacad2db1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4hY/kalIpIOAyjhN4GV2m2nweTOUMP8SWdtufDqkfTMDfy20heANVjJhCj5suOane7fx4d5lxMOyBOnGwZxuSGyhZYqUIywhw8SoD49ML4RnwExQzOXRz7PX1pDriWRM3uvIx4P+iN5nlJtZFEcqKh2lYjhEfGFEpcjhDLG1I1imIkI5l5gtxz6AzAMG/vbGwjBM+AgRes8ept/O8ECfEXD0+TEqMgQlcIP6JDx+djaYIMgvasul+YswjBnm0akdcwgt98rzix+MSo0BG/hvNzpCFbMcO4CeDPAfFe1YEyr8QJ0LDPAg0nPg1mD1aGX8OO2XlYs4PComOKTyQCw6qGi/0wgy3ASPY2oMdCCWT7CJ/mMAdV1FRmHQk6BUvuLmyeLmueF8efjPgkm/eogrU1SZIFkDmeBXI63wBQTXqkB2WCA6eF7FNOhwkSwitc0mS3fSI09LIox5F2BREoLhuguwWnf0Aqp1g/i2Kpwcj3IgPpR3pAf2Ss7O+6DOrVaqygpfE0aWPdMYhbmag4C/S3lcHndSiAlKIknFjEus21Nh8/h//mkEb6zl45oy7oAtlFS14ei6CcN3Cv5i2FTaQx8auM695fpyJp/HJwpOJaygT3eCGTZGjh0m5Qylm6IuW3hC8rOyF7gvMgLEtYaLjOFedwTAkTl3XE2d/0nxQ4xF3z+HWFop6eMbFtL576wsKLW3OBoTibd2aVuLdFeCu3xCs+rayAZgivbF1B5Z5/c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(4744005)(478600001)(33656002)(5660300002)(76116006)(9686003)(26005)(66946007)(66446008)(7696005)(8676002)(4326008)(66556008)(6506007)(64756008)(6916009)(316002)(66476007)(54906003)(41300700001)(186003)(52536014)(8936002)(122000001)(38100700002)(38070700005)(82960400001)(55016003)(2906002)(83380400001)(86362001)(107886003)(966005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fvezF31GqOIpfVHUjIH0sHavMPl6rtdLYnC3bhCk+NNtUFHKbFqzt3stb2zj?=
 =?us-ascii?Q?ifkvJbfxc/ITwIAKgw7IPOd0LN+V5GD+XjLvg1epvKmG2JS379UzPTiYY8cX?=
 =?us-ascii?Q?8guDVmqakUoBKd0SckEh5CMFDTzuKj1ld2vb8mcmXJQ81Jjage7X17ZLC66P?=
 =?us-ascii?Q?0vq52vKsYQkmaFhS4KzAP+TCqBoTw5eYkG6wDO2ZDxjzuWI2YV6EhEoqr6HE?=
 =?us-ascii?Q?GvyiiefyAXk9OULf96TLz5fnyjGG8YL6CPzcuu5Iz9sWBxImOKAViMVIa03z?=
 =?us-ascii?Q?CIxanY0PZykwYA8N0LiWWA1rtuAC7rlNAkOBe9knDCDoKVcQCWvI2XcyWtkt?=
 =?us-ascii?Q?DthdMmt1EabH02qfAI7hhLUIcCyUBgKUfgRR6TiiYz2ojTJSVixekJABeIzQ?=
 =?us-ascii?Q?ei+/WNw/WnLKWQUOMvFIIvTG0gF1wGAsjO33oRWcBfxCFUt95oHJ79Q7S1Tr?=
 =?us-ascii?Q?ec+oP0OAcArSHZuzMlzCjA2luAtY6/WPnvstHsHqZBnSbx5RnS63jDj+mMST?=
 =?us-ascii?Q?+iM7W87zWE1TRLz15mcpmN6iJpNCf66KW/qoP/hPoYa1+QfTgD++Pnw1aPt5?=
 =?us-ascii?Q?2VSgV98Mwcrd/r0uRn6fruCy07QL9lBmqhptj640b3Yb/kWcXMQaC3tIY3dL?=
 =?us-ascii?Q?gH8NEkfAP/rrt4DUV1xziB2z1+kWM92rZOddXJYPEBXz8Otdi3iVg6M1f4+F?=
 =?us-ascii?Q?TEOzPqLKJy+eGM0xH75s7ILhCfk3YMbS0ezl2KqtmotkztMHhbq2oRUZV6fQ?=
 =?us-ascii?Q?GEmIgsnKp76fwtIaoU7oZ1MHO2VbrKHQtvIo/wUA7P7kwrmykl1oSSGhwCCM?=
 =?us-ascii?Q?x7nFa0RZGYFok6Pjb/1schegNt1eScu17BlrCfM+fuBYtisr61LTmefRmw5H?=
 =?us-ascii?Q?ylgP9uiGN0uen6L7cOa7sBk/ETIb3VA5RWwfCnxGZ72/VAx9OH6BtZxEFiH7?=
 =?us-ascii?Q?otIFiEbH3IDkVgcPTeJpIZlVbZT0RBZfYXvxIby8DJ6FPKUHG/JRy7z3MHma?=
 =?us-ascii?Q?smJTP8dSQzKq206Vi98mlFVofmel8EARk/amkVWLH3OFwYmQQzwcF/T1csuQ?=
 =?us-ascii?Q?HmknGJpe/aRNlBfe+wZY0lfIED5hJ4158ephEbzW/G0493h9j9m3dJn2QbP+?=
 =?us-ascii?Q?hQXaODN2XWzb717fBx6wtdgb1qYizvGbFPHATz3Mg1S7C57s7bTByT8eFlTF?=
 =?us-ascii?Q?VVWYlnfiscAjFmfY6pv4pSK5egKpJwBsMQEzw3OPajGNleVAzMLPHhZnvgvD?=
 =?us-ascii?Q?wTZYPq5wiwk8GHejW7SRaocnSzLGrf0Nh513t6X0zhQwIC+RND411/ydJyq/?=
 =?us-ascii?Q?iYdk0QQJIF2B5Lsvq96wGufo3gN2YfEUOno4XEPQ6kyYHDRZRemrYpEciDDe?=
 =?us-ascii?Q?nOUWbRBjmMYT5lRBEbVtSrfvc/AsgDMdprC4rBJZzE3aWiptPypGwlQ4AlwQ?=
 =?us-ascii?Q?EkwhZaVB25rsM4wLRzLlHeh4KTwM9h5gYufBE1lwi8xwzVEIKSG5OaIE4BiG?=
 =?us-ascii?Q?67d32lUqRiYRrRz6tTVBa/n853zS9aXAbhhrTk9HIg8x32M5KU83zVCT8ZxP?=
 =?us-ascii?Q?2ayHni98/I4apSU5hRGwePDPkpFK4cpTTaL554NnKAocA2j7dJJQOtQpJ3V8?=
 =?us-ascii?Q?+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e24182-8b70-4ee3-c8ff-08dacad2db1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2022 08:40:19.4270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qBddkqn694kt1/tu/5UJLhtxkY0XdMI2j0mN/HccT/z3HDAc1tqfDzZ+hBxdBUDyOeHekSdaAOafEETPgoTS5nfITFPa43yaDxC60iXefE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Francois Romieu <romieu@fr.zoreil.com>
> Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss
> support
>=20
> Sudheer Mogilappagari <sudheer.mogilappagari@intel.com> :
> > Add netlink based support for "ethtool -x <dev> [context x]"
> > command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> > This is equivalent to functionality provided via ETHTOOL_GRSSH
>                                                    ^^^^^^^^^^^^^
> Nit: s/ETHTOOL_GRSSH/ETHTOOL_GRXFH/
>=20

Hi Ueimor,=20
My observation is there is mix-up of names in current ioctl implementation =
where ethtool_get_rxfh() is called for ETHTOOL_GRSSH command. Since this im=
plementation is for ETHTOOL_GRSSH ioctl, we are using RSS instead of RXFH a=
s Jakub suggested earlier. Why do you think it should be ETHOOL_GRXFH ?

https://elixir.bootlin.com/linux/latest/source/net/ethtool/ioctl.c#L2916

	case ETHTOOL_GRXFH:
		rc =3D ethtool_get_rxnfc(dev, ethcmd, useraddr);

	case ETHTOOL_GRSSH:
		rc =3D ethtool_get_rxfh(dev, useraddr);

-Sudheer
