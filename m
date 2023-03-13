Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A29C6B84CF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjCMWeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCMWeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:34:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4766526CC3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 15:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678746861; x=1710282861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vdI5Tj2evfNHyM5dMMBFsTKL4kyxDsjl0z2POGVkVsU=;
  b=ZWyY5slvxnQRzSPbrB+dKOTlDA0sd+Y2tB+XXZnXdKkQisebeWd1pTyr
   7xROyeNs1mzw2tOc3sxaKnlophskgkU5NIdCmxTZj73HRNFKu1roq6HVD
   M79aBrMMx4Pwa8RH/o83cvTIJdCn/xFzVcqUSC7ATXWyTok8IYwbvaOy8
   HPq8Z+EzKxkEugi99sJTMYIw+ZIqCMc2XfUHIk4vOBzLfPyQvOeB9O6wH
   jTzf1oNVgpojTQZI/pbG3UsXjLQ5+EpupOwbchTp/QifPxDPOUL0Uh15m
   WQwOsnjIqR2Rx3p1DShe1q0w+8KOcEFEmfvlTZMPrBSPua7yIR0I3q1NA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337300261"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="337300261"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 15:34:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="789086214"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="789086214"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 13 Mar 2023 15:34:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 15:34:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 15:34:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 15:34:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 15:34:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpND40H6YhRwK/Q+3es5gx3SNgK3r7yVyqeyaROl4Y+DA8iI59QgJOS18Z1ydkGFzxyLNWz4Bu9O6XvXfycN0T1jjJKfqxNVUSqYH5+kNCLLM3/H0wfOllPaKp42dl3zeCeQOxGiAzTWkMgucB+X9FwlYAVMuc+7cqo1Ggl6DWfcK/BPMMaJekAu0akhNJLLaaD+itr3D4fGY8K1G4biCX6Q9IrVZKNHIiTvmVntbppA0YFTjwRkXkZmuqsnn3Zh6opPwwzisk+fZ+4/r4ojCTXphjeHb5F3/DyDdGx44wXzeQy57x57xBEw678XS13mm64HdvVOIEbmbxCFH0sSlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWuh69tiz5kr2rFtZcmiPGqWawZf+vA9wZ5flQM7o5M=;
 b=S5e6ivhsdnvins6P7Nryyjr2cj+R9iYfij05I0tYzQqw4CTHu1EJjig9OftuSPuIqIXwFevMSN0gLVxYfRiZl2pb+9CRpoVfTx2iR38KL8FwNZB0EbyOgOuKS2ktAF+KpnhNJlIzaV9/YaCUhCLG+NjSsY3tCI4/NU8yf5k6y+BmAWiCYV8G8FM9mBOpBfQZNukGqGjxSvBkp0pTbWRWIKxxOcANOEDzXWLTMedgtc88PORtK1vBGZCN5WwrMiwG1fRk2LywZjCSZSQBw4NQQQdLAh8BEmUkhfP5NIbeFeNYVrAcEY/CqyTZSvAkJQRR8Tm34EiKAu7QEF6bi6pC3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by IA1PR11MB6098.namprd11.prod.outlook.com (2603:10b6:208:3d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 22:34:17 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::250f:ee9b:4f38:b4ba]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::250f:ee9b:4f38:b4ba%4]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 22:34:17 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next] ethtool: add netlink support for rss set
Thread-Topic: [PATCH net-next] ethtool: add netlink support for rss set
Thread-Index: AQHZUtOPcdTl3zIDTE2vNdyJzYtbc67znDIAgAWy4JA=
Date:   Mon, 13 Mar 2023 22:34:17 +0000
Message-ID: <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
 <20230309232126.7067af28@kernel.org>
In-Reply-To: <20230309232126.7067af28@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|IA1PR11MB6098:EE_
x-ms-office365-filtering-correlation-id: cb12b5cc-39cb-427c-a2fc-08db241314d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RnKS08dOw/Ptt+jpRMVdMUNLt6S34ov9zvLQhv/kjXBpUNhwaQDygU/wGNSHJPdtZIs14L+eg0IVFgGIyJ3izABbHP5gG7sidTSrYINvbkWixBcCA7ylCEksybhAcR3081e60GuyMOel7P4iQnULpmhe+RTVUqe10zGZC0hhc40jg2yUD2IgTYNfnPkHC5wJlaiPotGk8oMoyj1xUDmtxzipxXVpiQZIjLkJ2dVy+tcjMfJa1eiTRpf6ZP9bPh3vs9n780IaBcK9B2XUWot/omw8hs2AaHZkdoMCY5J+OcaH5PEDbo5jebWFzMO6GobNmv01MSyQYnucy+abin5uIe/r2HAmEcJp3mCGZMaZEWtTuZXnlspel5JdKOqhzMZzKKdojVBffW4JbHLvJ4dLbMGmx8A+YAWYfqT0s4YBoTskvU+1M84TzMWTotKeLUhBhQY0X8aTJoFMgA1Lb9Q//gfpaGz6Y4mWo/JzNrgbkvk8mW06e3GyWBnA2/ybO9kF/Uayp5J68rYKxed1UX9niIKWZDi7rnL007r1eCz/Ajju3kICXNe7FIzCxTDPFg3g7OtgUnK2RfYT6Wq+qQj1fjOYUXZCIrg6mL2hjvjgHzF1K28x9Uk/MYxl0i5nol0ddezaTXhiPGHrw0T39hNS6AvO/4t/8b/9LNIWDLCvkK4Nsixg+Vjv4mUjMNba0V9n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(83380400001)(54906003)(186003)(6506007)(7696005)(107886003)(966005)(478600001)(53546011)(26005)(71200400001)(9686003)(38070700005)(6916009)(76116006)(4326008)(66476007)(66556008)(52536014)(8936002)(66946007)(8676002)(64756008)(33656002)(55016003)(86362001)(66446008)(316002)(38100700002)(82960400001)(122000001)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+s603v0JDccF4UCEJVW4n46lnBOSlWE94lLrqiqnjn9KF6UO+PwzQjwy5ph6?=
 =?us-ascii?Q?aLM+0uirl6qTo0s3VvziUgT5/qYG9v0s0Wqs7b686K17osPRDCr3R7hZQSac?=
 =?us-ascii?Q?njXXr9dY1ikpeX4hsiKAVSwB3kpda+3WfbYEWevHsGg7tQgKu27vtKlIyax7?=
 =?us-ascii?Q?HTIZ6zMbPvnyCE0FLZBH0fxoSQECC2ToA8ZqU/buDBkPTaNeZj2uRc85UPhP?=
 =?us-ascii?Q?qFE1jVHWOwI10ISkGbtkI9sS8kjV6RioCHt6sKGwOSX4FlYmUdN7D0WKxzGA?=
 =?us-ascii?Q?WAAUbgy5RtStfKxRr7AKunPISZMsJCspt0Bdem7wmGZt+j7jHU9QKwGtAzxl?=
 =?us-ascii?Q?xXlg7of+CjBHCH3aD/0bOJUxsX40HHZVDgas0CFsTiQjplMPqeemBJZgLj1G?=
 =?us-ascii?Q?KeOEW2fYYQ04Ie3pYfooLP0r1miLRkthXGe8iQkMsLroegOUcrl8y4tjQEWM?=
 =?us-ascii?Q?t9CcbzKD+gWdyrONfzIBg+0mP55gEWlo8yISHvR6Pv5CCZ8RC3fKW9qfUJvl?=
 =?us-ascii?Q?Wz+4KNC32M6f7r00IbFioLqm0CbxbifHs9/hRCtkhaoTfaTQs/uJqDKbV6t9?=
 =?us-ascii?Q?X7Kbjah0MuHzNLn6vQw2WgCUT+PZUVzrnaJLLMF6eipRjynh7v94aV5HfhuZ?=
 =?us-ascii?Q?DqKJCjzZivRizub2WJwIDaFxJayz8FZT+665bNwlASAYyc6S8p4tPhyMQwuN?=
 =?us-ascii?Q?P1SuRBdYAbUN6Hc7UugEOfiAB+67WP/R9lUQTYy+YKE2CINXv9BF5G36Nypx?=
 =?us-ascii?Q?9e388j5vZC5JKCmaDI6yDZuzk7ANKPQBRsrqz+U+y/giSBq3k9ZV24kC9JQk?=
 =?us-ascii?Q?TSQeGPc7mvChPTQLgJ9fmrmyGDkYc4XHpgQpfjfWFteVbblNcrQtVHqvG7Am?=
 =?us-ascii?Q?l006eeNGB3tZGe4x7u4qtxcBUeK24O3mtV2/CGdoTuzg0J5YnPmBZHTtoVML?=
 =?us-ascii?Q?PezXwagD25JjQ5yHOEeDZtGtT7GnIaLYf/lRtyB/41wy0tW3YEbevgmdOUWe?=
 =?us-ascii?Q?BhT0qTQdXyol+06z1Tkl2tj71P8GiB1AM/Gg+D2/Scwx94d5DRDF2t0aIewf?=
 =?us-ascii?Q?wAL0jQjpUYfQVBhzvRMG+oRVMG9gt39w/32ka5TC32rUxcIJ9aVhGfZj+Gro?=
 =?us-ascii?Q?TI5dMuWzLQAWKODfQFZzAEfGTGtQEO+vc17o/QTPnATqfc8G+JMDaXHe9T2L?=
 =?us-ascii?Q?gh/U6kLcnxev9IpXAlMhkMeeH7CDvBSyRmTVfdUDAJjsZy57GPNjE8s46F+D?=
 =?us-ascii?Q?h96zG/r+r0jRLaBN8QgP1pyLmqcCmKixuZT1jb1cQkzl1wm9T9u/pfGhhZiX?=
 =?us-ascii?Q?z8HN3EGP59BZBsTaZz8Qp/P01g7NWb9/wrszwolkiQujxrJUOFxYq6k6L7Nx?=
 =?us-ascii?Q?No0MFydWB6hMQb9ZlMwXois4+49xfckY1bNTJ1wHo+/Bcj/2lZOotdSeJzyg?=
 =?us-ascii?Q?B89vy7H/OEWNJotgkZhJSYAQQIfAnw9zcegNJeytQHlojhjMWkV79yXjl7uQ?=
 =?us-ascii?Q?bbguUuP4KZ7VrGzWdwZQtyqLtNq73ZabmlzzMsVjdbNpa8Y8BbITr20jriZC?=
 =?us-ascii?Q?sGMK5iH4GBrscY8ySzIn1dnSJu51RF0KAgQ8qN54c43R1mFyGBwljHaxyd4J?=
 =?us-ascii?Q?jQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb12b5cc-39cb-427c-a2fc-08db241314d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 22:34:17.4784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZ5sCSmI8p+/9WWLVLHt32y474rIS3oRViDzG9AVJ4cmn6bMb0eh+ehxmlmk0+8ov4Qz282qqFYyAvEm359lX1cS2wmVxb2d7zapQBIjclU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6098
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
> Sent: Thursday, March 9, 2023 11:21 PM
> To: Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>
> Cc: netdev@vger.kernel.org; mkubecek@suse.cz; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
>=20
> On Thu,  9 Mar 2023 14:05:44 -0800 Sudheer Mogilappagari wrote:
> > Add netlink based support for "ethtool -X <dev>" command by
> > implementing ETHTOOL_MSG_RSS_SET netlink message. This is equivalent
> > to functionality provided via ETHTOOL_SRSSH in ioctl path. It allows
> > creation and deletion of RSS context and modifying RSS table, hash key
> > and hash function of an interface.
> >
> > Functionality is backward compatible with the one available in ioctl
> > path but enables addition of new RSS context based parameters in
> > future.
>=20
> RSS contexts are somewhat under-defined, so I'd prefer to wait until we
> actually need to extend the API before going to netlink.
> I think I told you as much when you posted initial code for RSS?
>=20

Hi Jakub, we are making these changes based on below discussion:
https://lore.kernel.org/netdev/0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.c=
om/
Our thinking was to move existing functionality to netlink first and then
add new parameter (inline-flow-steering). Hence the reason for sending RSS_=
GET=20
first and now RSS_SET. Are you suggesting that new parameter changes be sen=
t
together with this patch-set ?=20

> > diff --git a/include/uapi/linux/ethtool_netlink.h
> > b/include/uapi/linux/ethtool_netlink.h
> > index d39ce21381c5..56c4e8570dc6 100644
> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -52,6 +52,7 @@ enum {
> >  	ETHTOOL_MSG_PSE_GET,
> >  	ETHTOOL_MSG_PSE_SET,
> >  	ETHTOOL_MSG_RSS_GET,
> > +	ETHTOOL_MSG_RSS_SET,
> >  	ETHTOOL_MSG_PLCA_GET_CFG,
> >  	ETHTOOL_MSG_PLCA_SET_CFG,
> >  	ETHTOOL_MSG_PLCA_GET_STATUS,
>=20
> You certainly can't add entries half way thru an enum in uAPI..

Will fix this.
