Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39308427328
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 23:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243448AbhJHVpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 17:45:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:29288 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhJHVpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 17:45:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10131"; a="213737391"
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="213737391"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 14:43:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="523111616"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 08 Oct 2021 14:43:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 8 Oct 2021 14:43:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 8 Oct 2021 14:43:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 8 Oct 2021 14:43:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMpGGLNUbt4J9FdwXRs17LQOOIHv5dVSAb/mdP+41JG1SDTCDjUyjJ8HQ3vhQOnUOu189wfreoMaFDyR8MDjHlsT9Cu+77PlHO1sFhUuBpFrgg2v1u/Vc0xVJZtMU04gxxCZ8lFwV4wlMc6NbIg+NHQ517eru2WYYss7UQQJ1UsNV4sgP/0ciTQMF101TRb9YrfSNQVTh5/ksMryXwF86+7VkOEF7ZWV15AClQ2vsQmpXmJNiG+b7MxvvpUQp6gI1fLM4q6VQS+SjdfhOfpzvQfgFoBUWSSts+ht+xLL8zPYPLscRdzxdehqZyPpW+eXij4ldEK4ngYnmRKyUsV/Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rrPf4FsI1bpxzCwfENPXqwRRIA3DUKZaCFI5a8GD63k=;
 b=X2gE16NULKNBXDjYS1JV3H0HmON0TBOJovuNRkS8jjG/8QYJeIERZmCEwo+l7TMp88Jhv1KYznDPXtvay7h8g74VqAQ5WR6wNDi8ELceLkYVYCoKm1LC2p3Z8pDUkMNf2dn9x2uD7UFEQ8Dz0e36fvU7EfN2FhDevaZ14AmAqOf+LChNpcqWpVSARB+mvTCyBS1NvBR+nd+utB6wcPI2ZvZqkcF/Vgk60cRt1mIi4Smcm3eCuLSkTuwXGXEYKkKjcpSZodAyoXbUkq3wMMmCT4MTao2lb6FTTpdESYVH9n9rZBrNkF4cya0/o/pDa9HwocyeA6GbvrBTGXRkpIfOAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrPf4FsI1bpxzCwfENPXqwRRIA3DUKZaCFI5a8GD63k=;
 b=ngbBcQnv32oxYLtOoGFr35m+t7mzu3MjFzyj+jex7Xl9lDlGLJcLkWoRU0hhTeNg95rZhRCXhgNMyvbOaBEUxRMBN82V0nLF2M+N5jR8OAI0n4KVZv0FPQWKD+pZizETZ0h13UOGbc7ZeHKpyItbE8qE+eHh6DOgoLIwAYtYRDg=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 21:43:33 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8%9]) with mapi id 15.20.4587.024; Fri, 8 Oct 2021
 21:43:33 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
Thread-Topic: [net-next 0/4] devlink: add dry run support for flash update
Thread-Index: AQHXvDEgAtyYxjU5D0ijvkxpgH04qavJCiqAgABgN4CAADgc8A==
Date:   Fri, 8 Oct 2021 21:43:32 +0000
Message-ID: <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
 <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46b32ad2-c4d3-4bf2-8700-08d98aa4acf1
x-ms-traffictypediagnostic: CO1PR11MB4881:
x-microsoft-antispam-prvs: <CO1PR11MB4881EAF2BD6E5DD703D7FBFAD6B29@CO1PR11MB4881.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vocOomk1DZj1i8WdbHomnLU1irXccKSOCQnSJZloCw01LUsZy3VusTYnqYGCCs5pgI8j9qth1xADj60jm/R8jnaa+bqIiwU2zSOpi7zFHzC19+NK7EKHFkeEZ2XblXBo6TCld6KjztciF6PcFrlZGaMAu9LM/pmbdvRi2R77csM74+2ldq59MJyD//LKGFhCRSCqIupOmYr6C6ou5i6dkUybniOhkiIstKz8TSd/jktDRtIcoo+Erl4NlPXwQ/xsD31wLM0cofRdp2MVuLtnqIT8gXeLcE72BKIFZ55MxmJqI3GEEDhEj0U+uHwfb9dDyk/hzIrXFsF2lPVr4pk2NZK/4pnCoA8nVz53chaNF2tNJBlABmB4LlYzvNxEpmeDIiVPlLPQ8W3eYiqxKXyjrV5qU4ev9PkrsdVfvm0i3uv2dInNzIAZIfiHqn3FKCabG+xN+KORa4U8gL5sdhRFT30JsU+Q5JFeRfQvzRbwXg9Y4Akp4vvbzjv9RejtJCS9Cu1eU0vtKWe8EEboecd7QNxSCmILZ30l8HhzosmWLAzowNkWBCQOpzFVdDYytvV7acTTnWTYQmGN2/MjRZ/Di3shPSwnT6c1VBXXWojwkCdRpsLbsVY/5ZbEdprGcgP9NzLuQTUJZl6dUykKP8eSd+wwd+phvHV+h0Uj4hGxGTkSCkcSULb1bv1Y5JUYEEAOo3UvpqaE2+PP811r0EerJrKE0MOMxQahbtbZxPcKDhyCjlVbIzaGtjrhoYhsxU3QxuB+jgYdErBne1GoLTTBSzW1KYslcNhvclF/Ad23QNA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(15650500001)(26005)(66476007)(186003)(64756008)(66446008)(66556008)(33656002)(83380400001)(53546011)(2906002)(6506007)(55016002)(508600001)(7696005)(9686003)(66946007)(76116006)(316002)(8676002)(38070700005)(52536014)(8936002)(5660300002)(110136005)(38100700002)(71200400001)(4326008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k0TdztXMF0JLgsg8u5/4WpDzTs7c2wXa+r+++j+WwQR8bZt+rN/di/vj1qm5?=
 =?us-ascii?Q?Zz+/rKEkMaHUcF8z5cNhe3MZabOlKRX/oREtKZFJo4YQ7hVoagnI7kL6PMwY?=
 =?us-ascii?Q?M99W2WW0dleWYoDc1ujg2Hjuf8KWV+5dNwLasHMVk35X2V3iWom65goG+EBf?=
 =?us-ascii?Q?CjecADEDnEgNNTHfKNMrVvtSEtEymZIojU5u2epjmD8FbwS5vqoe73qojOgf?=
 =?us-ascii?Q?gy64iPV+CmpHdFKS4JcN9M9FD7ignocQRdJwARIzMSHb6Lv0i8r84JNqnl56?=
 =?us-ascii?Q?EYFEZzMUs0C9kXwmwED2NqMvJBmWyKEPUs+r7CAv99PqTLPL0TuyrpPdeulX?=
 =?us-ascii?Q?ymYa/PZ5LDSA/zBrHHWBYQyMqxNMVq5RZu221X4i6v0D1R4HdJKtT/jxJgZL?=
 =?us-ascii?Q?Il4MafTvTfgMW0fXPbKA5+9toPWakmiIwGVeoGYWbpVQevu4vRJjutUR4wkv?=
 =?us-ascii?Q?yS0brbM9ciio3M6bCjtshAGvhnZ7JHFSZyITlB1LT9t4MBppuVT/d46uAJWp?=
 =?us-ascii?Q?O+eknbAse5ak+k4ZV/MBJrwPbh+gMxqcBPm2xHTtXAuFPlWtzBtjmMABd7GH?=
 =?us-ascii?Q?6UcvjDoaxapIPnq7rv6/nmB57gf4eoFEc3QSroxUKHZYf+wvIfu0B5/DvJoj?=
 =?us-ascii?Q?mhf18YpMAvdYOZVtuG6Uv9cOQq6XAE60k6nk3ORECGAhIwfbdbBi9oCKE1SM?=
 =?us-ascii?Q?1Lx10xWtTX9rPYTqbbsBorKdCjnxJwqlTJ6Zig2aC2xmb8pBznFbUxhJ3hg+?=
 =?us-ascii?Q?Zdq/Jofroo2IsQK5qq582pHO8IMi4z5r2a7wAueY83bjQvgv7BqYNd/JFJoi?=
 =?us-ascii?Q?JhViz4Zoz8gU2612rnqC9GQk+2Ki1if+UXTEiGdlPrhoagw6Fg0gTh6TVf2J?=
 =?us-ascii?Q?jYvWmR23GMXSGmWrlc4pEE3j2G3/IWkGs49SWRC89rqw66rxw7h/1+EfvCok?=
 =?us-ascii?Q?cEZs6DpuIElerDxXTS79K0r525FdbzwsVbSQmlbUr7NGTg+qQz0drUrdgPnJ?=
 =?us-ascii?Q?x0zAsGGsXMosxP/tXy0t+czBN5ljrLB2o/RX+DXxMq1LQFacjO5mHFGCC5x1?=
 =?us-ascii?Q?BvvMJE8UFBcZwFzioJQH6+Xlrs0CCmgNzwVuNjweNmRi50BS7ypsUFfJdO0p?=
 =?us-ascii?Q?3rWH/AqFLv7+RiwIiH/mu8cy4k4J9aY1cPrRV43OcOIbL4Qi1pc7Au1HwCE8?=
 =?us-ascii?Q?HOpVZYZ3bzFnLxnYmzfwtQv+sPQOnR/Mj90SII/nsCK2fLlmeIGMIK/prfGP?=
 =?us-ascii?Q?jgY/LfVpUbTgnXeVBmzBvmhUX7t3xRZaq750BNXrWh+ppY7Gq8k9py5ibdFu?=
 =?us-ascii?Q?9tZqVJuli00or3CUlpIn3Svj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b32ad2-c4d3-4bf2-8700-08d98aa4acf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 21:43:32.9101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7QbzjYrIVAnRks06GSjurorHCgjXO3lak7PAnmgop6329Fit815EhBjRFKWDUU/XaSixe+unjyjGwhk1+23Wn9h6RBi5jfAgbVu2b4BI5xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, October 08, 2021 11:22 AM
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org
> Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
>=20
> On Fri, 8 Oct 2021 14:37:37 +0200 Jiri Pirko wrote:
> > Fri, Oct 08, 2021 at 12:41:11PM CEST, jacob.e.keller@intel.com wrote:
> > >This is an implementation of a previous idea I had discussed on the li=
st at
> >
> >https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.co
> m/
> > >
> > >The idea is to allow user space to query whether a given destructive d=
evlink
> > >command would work without actually performing any actions. This is
> commonly
> > >referred to as a "dry run", and is intended to give tools and system
> > >administrators the ability to test things like flash image validity, o=
r
> > >whether a given option is valid without having to risk performing the =
update
> > >when not sufficiently ready.
> > >
> > >The intention is that all "destructive" commands can be updated to sup=
port
> > >the new DEVLINK_ATTR_DRY_RUN, although this series only implements it =
for
> > >flash update.
> > >
> > >I expect we would want to support this for commands such as reload as =
well
> > >as other commands which perform some action with no interface to check
> state
> > >before hand.
> > >
> > >I tried to implement the DRY_RUN checks along with useful extended ACK
> > >messages so that even if a driver does not support DRY_RUN, some usefu=
l
> > >information can be retrieved. (i.e. the stack indicates that flash upd=
ate is
> > >supported and will validate the other attributes first before rejectin=
g the
> > >command due to inability to fully validate the run within the driver).
> >
> > Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> > really dry run. I guess that user might be surprised in that case...
>=20
> Would it be enough to do a policy dump in user space to check attr is
> recognized and add a warning that this is required next to the attr
> in the uAPI header?

Doesn't the policy checks prevent any unknown attributes? Or are unknown at=
tributes silently ignored?
