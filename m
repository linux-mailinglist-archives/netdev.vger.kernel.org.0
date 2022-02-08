Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55F84AD9EA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347619AbiBHNbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379146AbiBHNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:31:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D720C03FEF1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 05:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644327037; x=1675863037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xp0tG5WSiP7IdiadWbJJftDRBnLJslsZtCgRb4NZ2ag=;
  b=BWJWFKIIcjdH5VMdrK5R7rBN9ys0JyfotpSmlBpItn8kQhYq859oUvj6
   bBhtMKAnGCXIB1OEy6CruBcXX45CPKPwbPiOfCPh6TgZNzkmyKVc42G3r
   MxlxCjm4lUfXfNzyiU+7BtLFsyzAA3S1iEEu0aW5W7LZHR2YP1d5bLJsp
   BXtc+1V0lkhYDeNq5+BhCq/3EqXf37hJUrn9tpNgoHWXtGSefSXdWkiQB
   TQCQ9IIDyMKo1P2n0Sp6IMEy/xBY7yb8B4v9fRDI43/jRgBIqgLeTFKHr
   /sadRq+TSSd73FN0i/OgNwC8oVeO1wgEqiz2UVuhELp0aqvT6W2neXxde
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="246535165"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="246535165"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 05:30:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="678104434"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2022 05:30:36 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 8 Feb 2022 05:30:36 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 8 Feb 2022 05:30:35 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 8 Feb 2022 05:30:35 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 8 Feb 2022 05:30:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSm4uJ9nYPb/4/0YZep3lfauf5zjaga7GoKJA81GmSz/VG9i628Z0XeBnHzS3YiGIJT8yUWOfHi+VBVfP2r0Ps8ZRrlwO2HyXikcNPRhIpFv4wuu4ATtGlO9Ra+YaPSaieHzayxyYlVOYtAJk1EcnJmnirYC2zJXUgziWfu3nzKcZtePsSgH9Yo4Yz9QI3ObOhw+T5JQEI7DYgodc9aAvM7K7/LRWXy5ZNpVOnfeq/g9KvSI0pXWLx01EfHBCydVm1oiEeMu22eMRVnWz1YlLfnXyb/LjBI6vNLBWh7AmNLBVOyABLizjdhiAKMFc1wwfhTEJlmuw5MYAWySPEYj0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjSW5yi95/Poknmry0bwDZNn2aJFepraTXU1mv7e930=;
 b=KPXAALNek5zKRLeTA7QHV+t+SwikTrZHe+YKkRbdx/LoB4Fj8WDSoDv/ZA7Tc+WLAUP4lx3GYvtQxv/exvly1+MvwSf9nY1MqJ9lo6/OwmZpqQ37p2AThRcd/Ni4HD6w7HqeGvUJuHHkey8zeYQPddwUbHmQ2gyQ7WfN+G2C2VopSI63AWK5lFIQ5sjJ7Oa1C4CCI6BH0BcCeRTNp4gFA2gdSso0OyXymQOuxg9efVzyDXvqKY82bBhJB8mSKsw8t2MbTBmln3deju/WnYbmqwLuckrlVT2MQIz2oYIhlPuTNC0TNiNqeJl8wdSvEXugEyH7GpRazt8dsQDe/+iUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 13:30:33 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 13:30:32 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@osmocom.org>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: RE: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device
 without FDs
Thread-Topic: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device
 without FDs
Thread-Index: AQHYE5zTRbNi3Iwp1UKjRr6c/FDo0KyFNS8AgAR+t3A=
Date:   Tue, 8 Feb 2022 13:30:32 +0000
Message-ID: <MW4PR11MB57764998297DC775D71753E8FD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
 <20220127163900.374645-1-marcin.szycik@linux.intel.com>
 <Yf6nBDg/v1zuTf8l@nataraja>
In-Reply-To: <Yf6nBDg/v1zuTf8l@nataraja>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf6c471d-1657-4831-0ca5-08d9eb072e91
x-ms-traffictypediagnostic: CY4PR1101MB2135:EE_
x-microsoft-antispam-prvs: <CY4PR1101MB21351EFF5F78C1986BE84AFEFD2D9@CY4PR1101MB2135.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W3Og4rg5yokf1vr311rGURSniDooBlFgJa2tqvsCYK1FZD/JVFkcIX86ce8fmEbShj2+uBJxJaAsVwGx30XEDqfsdb4wJKHmH1CCG568gDq53FNHw1aaHWlblJ1Lql2m9WxHA7nate+DnLD5q2SAHf9kpTY11+QvrOCarVzhiLV6HupN0/6s1al8YaVoC9gs1mnwgpU3W7iKH3Z+qJ8yX87UODF7VpkTeGfsNaKm0j6b+KnyjInA+AvEeJI1kl/gfcXbZYIW9TCbf6dJYCktzFb85clrLQ9gBCC7cmC7hfDrFQUTo01GeuPMXvOyWlYmd71LCQ4VqMnQDxyNbSJusGyYHSfEEoPKw6JcQfqJneNJlfflPoczHXzxdeqU5UzfLJH7hyJX91UOJupKEPDrOxQJQ5Ks2fIuocC0LHb8tEPNM12ZmpUDcY6WaksikU4HRgSXHmwtaB3XXdZ1uy54AT0d8f4T///W1cF/9GPLE1NFQVnErUnJxcpWRihKwUlw0+kQios0E76cFuLcPxX8etzHkWaE2JVNwQaRQvCMnRaHG5VT3+YXNwf1V/z9VmNIh3eulQHLmFbsh4haRwucip4PKPtVEfK69ZR2eoK6jG08U2DFy1FPfgAVo9zf6ZDISNs/wmqRxr8xaCEnpL2QuJwseizdFgM4WrH22GEyt56UOf3jwElhammwe5KFqCmbgfMP7wrByY0A01oG0AUvAVuEZotFskwlM8vXJDLcfzfafMbR/jWlGMYM8CqLaGx1ecSyEzr0/t9jgPj7nTDg7u7WpcqKYC8Palv4OUCv82g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(55016003)(86362001)(122000001)(82960400001)(66556008)(966005)(64756008)(66446008)(66476007)(54906003)(76116006)(8676002)(66946007)(4326008)(508600001)(110136005)(316002)(52536014)(2906002)(5660300002)(71200400001)(186003)(26005)(38070700005)(7696005)(33656002)(9686003)(8936002)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3nboboT54ihII26L2tdMmuqsUv5hX0P6wbg2+SoXLkB+Cg4pBgj67Y90Gd5b?=
 =?us-ascii?Q?Haxhuhs2KUbCQHo6d98L7Rmfmu1SMEfQfTls2kkep8WCqpWNGe8sKJ5bVrM3?=
 =?us-ascii?Q?HecNpdOJwW+X3srPsD/tfCSaT30fUasBrIw/6/1QAIsv/3rHVI1JR8kps2/y?=
 =?us-ascii?Q?aETdnJbI2TQCbykNhVjG+JP/FFZqnPjW7INYtSlJIgMjgIcek09XFgtcQZrP?=
 =?us-ascii?Q?8Ux1iD2e6dnnU7AMljWGVIGr3MSw+i/SDX+QSlgP9d3O3PUChGopKDoWbgrU?=
 =?us-ascii?Q?fWN6Ns5syFsSOmEg9/mhVGGi4F40kVqyfKoeZMIgKCdaGk70bpzqkOdBs5xt?=
 =?us-ascii?Q?NY4pM5swfqRR2y16mNTKZAIic28iiW1IU4Q4paNbkyKyWtmo+M8laMQu6n0g?=
 =?us-ascii?Q?VDohmSyZj2c8TDCGZNoaj3NQZC5QIcil1QaiOVAuoKY/U5lhRE6r+TiYJQJ5?=
 =?us-ascii?Q?yX+pNhYpusySP6va5BzEsFDl26l4JwDTdj6E2IO7PcubGkRKxX3z3QUoX34T?=
 =?us-ascii?Q?i6/29Xid9jXuUHXJcqICfcDnFbzg9opcoqzfj8fnRrVDGd7KikPq8j+f55kd?=
 =?us-ascii?Q?Eh10u84HySp8n80d6meDn4GNLdO/qAtXEDoCD5lN37uSZWAY4tjP4CHRUWcm?=
 =?us-ascii?Q?Z93qUN0mj0P8YP2uhq7LCilnYyqU/R+kael/OE/J8g3TeghUFVFupb98fkR3?=
 =?us-ascii?Q?WEeyV1QzZNrWOc58JK2FZMEzvrx0EIQ77Sh1an0m4Lf+nRoWXvNvAmeza9MQ?=
 =?us-ascii?Q?FfXP8nw31dbRSGVfYZmmlCMPwP2CAjI78On2NUa7f4lld2gTci+St14Vs6HB?=
 =?us-ascii?Q?qVt6DcybmPdK+2Q3d71Qlv6kbR1ITooajBy7VBbFcaCay5aSNXSwZR9npkPt?=
 =?us-ascii?Q?cByWzKAEtFBj8G5tewjqaHVuFK1KkkffL5p1i7MkcAiVXb6PQ9g2ImhHb86A?=
 =?us-ascii?Q?NZpwv38SdPI9oYMDlyxSjkZXmGMNT73ZqtQXgMEwZsyomD2VDuYewCYBiEU8?=
 =?us-ascii?Q?n0xOVPbzllDB2/gqJ6nrbniikPBVPY4RsKpbiKu0FOpyi9Mk9TDW+V4tuw3f?=
 =?us-ascii?Q?9zAD56eRzC6Ck4MYBsTTkH0HtMdQ5VlMfDu/s97mNK+mS0q1XA3T/h01la2i?=
 =?us-ascii?Q?c13Xwfimza3X0jVDdHxjRyRBirBl6vrexkH6NsJtKb5BXxsQH06Y1JGLsnKh?=
 =?us-ascii?Q?FAjHl2hDIq1i/GQP1B2KFXAjT53I2heW2AlEqlvil4TjdSEWIDvVF9W129IT?=
 =?us-ascii?Q?MkB3fyWC7G8+jlWQoGTjZsB3WJcxC+1/JBEfyZtynjV4JNUQtuRdOXrBCYPK?=
 =?us-ascii?Q?D8Zu5R7y5dH7uRYHjtTcGct6ixOreTdThuHgtCd9x0c9PQbZ+zPLZFu8RNQZ?=
 =?us-ascii?Q?CR/r1ZqJxdNZqixEDVdH44OKTSsfWXce/7zvuHLFaOXoiEcFEA3WB5FDlxrd?=
 =?us-ascii?Q?MRQIaRSyHjcg93WBNUNn1cAXG/OrAzPd48YEuwxodO7wgeYtBmOnnnS+coMw?=
 =?us-ascii?Q?seSzRZM7BAaaJUwfdcIkoHegW0+KYo9zVQSh5QSspsjS9JBVHe0GD94pkl0Y?=
 =?us-ascii?Q?LCZuyauBRCszSOnL2ZDeXCg9gOvcMO6KpQ/euiFcX1QWi22TWP19ISHUnANT?=
 =?us-ascii?Q?GLWNtSNjn+RU3mwNDmzLWavz4HpkDNI+kHFjcfFlHHAM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6c471d-1657-4831-0ca5-08d9eb072e91
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 13:30:32.6942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Di89Mcr/+wb/0/yyR31v44enre/SG7OBGxerensaQxYCAuglppUaAScH/u+RNfRKutoz0mnZpiWGRYS7gJ8v3YwDLuFhd4Lszz7/y9IjBgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald

Thanks for the response.

> -----Original Message-----
> From: Harald Welte <laforge@osmocom.org>
> Sent: sobota, 5 lutego 2022 17:34
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: netdev@vger.kernel.org; michal.swiatkowski@linux.intel.com; Drewek, W=
ojciech <wojciech.drewek@intel.com>;
> davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; osmocom-net-gp=
rs@lists.osmocom.org
> Subject: Re: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device =
without FDs
>=20
> Hi Marcin, Wojciech,
>=20
> thanks for the revised patch. In general it looks fine to me.
>=20
> Do you have a public git tree with your patchset applied?  I'm asking as
> we do have automatic testing in place at https://jenkins.osmocom.org/ whe=
re I
> just need to specify a remote git repo andit will build this kernel and
> run the test suite.
For now we don't have such tree. I will see what we can do.

>=20
> Some minor remarks below, all not critical, just some thoughts.
>=20
> It might make sense to mention in the commit log that this patch by itsel=
f
> would create GTP-U without GTP ECHO capabilities, and that a subsequent
> patch will address this.
Sure, I'll add such comment.

>=20
> > This patch allows to create GTP device without providing
> > IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments. If the user does not
> > provide file handles to the sockets, then GTP module takes care
> > of creating UDP sockets by itself.
>=20
> I'm wondering if we should make this more explicit, i.e. rather than
> implicitly creating the kernel socket automagically, make this mode
> explicit upon request by some netlink attribute.
I agree, it would look cleaner.

>=20
> > Sockets are created with the
> > commonly known UDP ports used for GTP protocol (GTP0_PORT and
> > GTP1U_PORT).
>=20
> I'm wondering if there are use cases that need to operate on
> non-standard ports.  The current module can be used that way (as the
> socket is created in user space). If the "kernel socket mode" was
> requested explicitly via netlink attribute, one could just as well
> pass along the port number[s] this way.
Yes, it is possible to create socket with any port number using FD approach=
,
but gtp module still assumes that ports are 2152 and 3386 at least in tx pa=
th
(see gtp_push_header).  Implementing this shouldn't be hard but is it cruci=
al?

>=20
> --
> - Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. =
A6)
