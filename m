Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27E8457218
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhKSPvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:51:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:52526 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229936AbhKSPvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 10:51:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="320648553"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="320648553"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 07:48:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="594414118"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 19 Nov 2021 07:48:21 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 07:48:21 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 07:48:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 19 Nov 2021 07:48:20 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 19 Nov 2021 07:48:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoun9H1kVeRRLfgFE/xA4MQkvGio5NLrIk/RbJUsDlcHznR0Wd/EkSfjfx1SCiA4jj1/kfB9tDqPhMMDg0yW69cOwHe5g0marRowOXtvCF8Gzsh8rGlpG3gHtwkLZ4n7qSQHoTDsBqM6LNmGdtbeFKq4/c3wk27ZLu/mR+T4jf5OX9JOSkGBR4Igz7+6V9CGTLpSPf4L+yZ0zCH/RNSxDXPcKj2dLly0T57WiJCGscdr7bMAXbjk2P/N7t/sXoke/FJ3tUHLvmw2Lvx9HPGmcjfb/ag9PsWdHTFtSZulAp3ybImhRfwoEj3fFUQYjS+/lsjkuvEQlAfVYNxxdlMERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4aUQ5kFsrKisL1xazpoxVm8Ljid2SG7TPlsW2b06Gbk=;
 b=D4tv99GdGUFrbNA76OoLasmShVb+eUS1JK6FY+9FEEa4r0pXIX9hzgDZ7iFGZBRbAEMrooqML1kABXonyli/QK883Gp7O0tKtXbVMwjyWC0YCTbBRD1Nr6Lxr88FyhrPpmp6gWrqceAtOFwQB1Zi2v7ZNEhsOb0mDNiJ0ZvjIsJ5Do8n8IMLAim+HpnKBcwJyiJyWqZZinm732jkYMgqRVbhRrSscrvWOS1p/QKPlHtINsdu5x+kE+Q/KYHuOP43TVDpPTj8DCz+Sxaa0p8PGAOfCcKaOWk+gmGb9yEg8ZWpyXA0xi8GeqK4V4Qsv9Yr8me7QxZr14KlgLgdZ306xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aUQ5kFsrKisL1xazpoxVm8Ljid2SG7TPlsW2b06Gbk=;
 b=KXLcNnQ8m/PtSD6fZ5w+VwiKQSyrypL9Yt8nz3YIhD0ytLx4d2vG+0py2L9J/ty9MvR/Hsd+bEMV3I2fFGGTNv2jd+UStr4TFVcUmK+xizqrRPFmuhq1ge5V8BiPXSF8b+R0fLVcjMXZ/ZY7wHfuAUvWGv7UC3zQO+8lQsdkHpU=
Received: from PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10)
 by PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 15:48:13 +0000
Received: from PH0PR11MB4791.namprd11.prod.outlook.com
 ([fe80::3439:fc74:680b:8766]) by PH0PR11MB4791.namprd11.prod.outlook.com
 ([fe80::3439:fc74:680b:8766%3]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 15:48:13 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "Jesper Dangaard Brouer" <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "brouer@redhat.com" <brouer@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Subject: RE: [RFC PATCH bpf-next 0/8] XDP_REDIRECT_XSK and Batched AF_XDP Rx
Thread-Topic: [RFC PATCH bpf-next 0/8] XDP_REDIRECT_XSK and Batched AF_XDP Rx
Thread-Index: AQHX2rz04f2C6hNUIkOAw3chF6vlUKwF51OAgABwpHCAAXBIAIADNhdg
Date:   Fri, 19 Nov 2021 15:48:13 +0000
Message-ID: <PH0PR11MB4791ABCE7F631A4BBEAF1B5E8E9C9@PH0PR11MB4791.namprd11.prod.outlook.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
 <5a121fc4-fb6c-c70b-d674-9bf13c325b64@redhat.com>
 <PH0PR11MB4791D63AFE9595CAA9A6EC378E999@PH0PR11MB4791.namprd11.prod.outlook.com>
 <87mtm2g8r9.fsf@toke.dk>
In-Reply-To: <87mtm2g8r9.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca711157-4b16-47a0-0a6a-08d9ab73febb
x-ms-traffictypediagnostic: PH0PR11MB5112:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB511263AD5FFA7D773AE59F398E9C9@PH0PR11MB5112.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /pZOsIharzXCrUDP6dHq4wMEjWonKhFoXGoxtJMbOwAv4qb4mEArBABnF+dK2Z6Q5amAYzVNGcll9hfSTt+Ha7xoLjWY3e/QTyq73LgMVDnEVcON0F/ZrjgHQIE5DOAtDb5/RreFzGPuQQhI7BgpnyWrk9pV1k9soiLU78WB7tb7ZHZvmZCqCXcjZ2xavfijHDqP7U4q+zJ7NYi1c30WL3UizqedhivHmV8qFsuht7j8Wl99L4ks757YcQmkZ7m53FkwSd+XH3xCLx+Bn84LJYl7jbNjdQpyJyr4H4OJVnWzV3lh1acAtJpc3ViQ+v1PRTcCcRTnOE/tZ+PBeBE21yzCAdvKNaMeAiuSGAgKI++CKaR7Auzl/pZ6voZy35eVm1vBCtNVAoUjC2qNdAFOx8O2J4XyOe/7ueeR+SQgX5iSw/D3I4xACSyvCHzn8RsDR7oZLwI4ASn7ur/R+GjHt7dEJDVykFPSM60pberVGzXSpDdL9oCFXWksBiXLwr7BYYXmMTxdgrmLm1mqfIyJbOdYz1XVSfn2JGx/vFY4MFdk09vPGOLTsci2WOJrhZ6lxCHtIWZe3fXtsSc3/geJCkPD8dE5Rrwd+j0gicz6sletYyAPgic2RReb4bYTa48hQHkQs8ANaJfYIbohC2TkUwf64zMtOxkGy4hI3DgdpCyaa0iu4yl0wHBsX4lWMa9zTCqQjQahcMVea2BTue5l2rC5fodNOOSgKKRA23VZVkM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4791.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38070700005)(6506007)(122000001)(316002)(508600001)(7696005)(8936002)(2906002)(33656002)(64756008)(66556008)(52536014)(38100700002)(66446008)(86362001)(54906003)(71200400001)(5660300002)(110136005)(82960400001)(186003)(7416002)(66946007)(9686003)(76116006)(4326008)(107886003)(26005)(66476007)(83380400001)(55016002)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?LwG4/EqfSoej7H4FUbPV/ORgYFd/ClwnaXV7q6cmli+PKoLLunOzC0fRoX?=
 =?iso-8859-1?Q?olnXwSyLwpB4FyYxJlqW6/1dzHdkLEl8c33Gf87rx8LAbBssiXSh+e5AJ+?=
 =?iso-8859-1?Q?Oddjbwvof1uohp2CNiZcCr5Ed3nDA/DK6rdLnWwGvT8Mlo5TDrH2v7cBDm?=
 =?iso-8859-1?Q?eGj3hu0SVA7nmlXfwoI1YD0hMidhge7z8mHINqvNbZB9HxzThbNqFxoYsn?=
 =?iso-8859-1?Q?Bq2h90mVm/5oJTeSh6oJsNIi/MvizPTMnmUYsSABqZM0nL17FFfpcT9LYr?=
 =?iso-8859-1?Q?Dvp90RMh0MyOgQ1a7OQfUYL4cmIjgRgGXkGM2rv2UdCatrFrbdU7xsF3E/?=
 =?iso-8859-1?Q?QfLHuVR1Ho+IldjXMJYIZowMju4u45zL+fT+fPIrebi4w9u4ntxbEWUt+p?=
 =?iso-8859-1?Q?y6c1VCRal3+KIS7jnHzQ1ndF21rM6f/FQ77tPUsW9kNb04B9Cv7ei9yC6m?=
 =?iso-8859-1?Q?aUy4Wl2T4QpdlfoGJsFOumFPzo4a57BQbIc1ej8UDleyCXzxFo9JCKYU30?=
 =?iso-8859-1?Q?Dbp5nKcAwHHzoxmhpLHBXLdKGk5shQIqA9MPQ7IibBgPlsIPc4BsCAkVNW?=
 =?iso-8859-1?Q?ClyAJJcrvTxIC5kHQziyYeByPbG8cu8a9wT0s/8O9zfyUKVXLKI1a3vBz3?=
 =?iso-8859-1?Q?UgWfHSVIDaCajFAg698OJ3AXFgWuJ4Dwvd/EG7FFd8zuoxgXf6riU+YK0Z?=
 =?iso-8859-1?Q?MAkKoQuTmXiy170/cM4XqCnLUij1I2BASyBpGUw2G4WoKA1ol7MNo377n3?=
 =?iso-8859-1?Q?jn5Mrqk5jZI7pSSAJBAzX6N6z6QH4ebg8bM+34AVxjvOFJiMBZ9kpD4grm?=
 =?iso-8859-1?Q?m/ZhmR0xOOpN8WxgIOdTBBhHfR5gfJAG5khkdoo5AzqrgUbNz99j2DI2Qy?=
 =?iso-8859-1?Q?QFn5uA+gFvPf13BzYHa5gInCJyPqTD9hEQXBZjWwpqxlM2vcxyWdq4fHf3?=
 =?iso-8859-1?Q?pIDT4Ju+/aaejA8Ch7Lm1zoD3jDnajSk2qgUoBWGfh7n9qZpEtV8Y5HdIT?=
 =?iso-8859-1?Q?lk0RuX9BEnqhDeg1n/6wcBnkDsCVI3KpbGRwSMKZrkSmVt1rfI6nXJB1ed?=
 =?iso-8859-1?Q?0XXQM7iM+tFSvjdQeUYa/hkRv47Q59I0vSmx+MYvDOoFA4a66kjfYZYHYL?=
 =?iso-8859-1?Q?N7IBj2KX2GbYH2pTSQ7ZTKjLXU/HR1imgyQzPEDbgr9VzK90g7cPZPqkOP?=
 =?iso-8859-1?Q?J+czQAAoF751mtzuKriSyAV43VIV2V9AXBo76QQKrrjsaYPLXmI+X30cUX?=
 =?iso-8859-1?Q?j4nF6W03UcHjhifa4Ze8U2YFB3PA23ZzLMn9oAnd9BzmNQyYr8A9nbsXTz?=
 =?iso-8859-1?Q?h/E2LjcCx6AM7YqzzLc97ZaI5ix9wN831HMWhaZs7F9HyR2PS2j4O0P4aI?=
 =?iso-8859-1?Q?0NaH7ULqljwh3qVraclJ95rYVMNgk2iqK7EITMQI8UHC6quUuIxIqp8+cO?=
 =?iso-8859-1?Q?1GrW6ot1lajP8vUgsj+vYwW1mnYY+NuWCjPINodLPQgNQHum9MkbANM8ru?=
 =?iso-8859-1?Q?A9Csg3nUPNCYt8YWvBq54mYgnrqMQdhWa5nnUs29WiA1nxLeePSUzf3Mmf?=
 =?iso-8859-1?Q?LYBu9/nzCchmVJiQiDCBLbAnIZ+a8tYW/rHGXs8Yc9BK22x4T/A+DE5ped?=
 =?iso-8859-1?Q?7AIXk63yBSfFzrxfH9Ne2MivGN6/Inbtwtx8/EbOz2RxqWJwYqu4D48A?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4791.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca711157-4b16-47a0-0a6a-08d9ab73febb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 15:48:13.1790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ri5jxAqYMbX7JwZwM76xGxj+2JGm4ZpyT3RLlOl6qfIP5hCychoE+6ahNtV7nwHnoPm2d1FAJdEuCt70GUj65A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5112
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> "Loftus, Ciara" <ciara.loftus@intel.com> writes:
>=20
> >> I'm fine with adding a new helper, but I don't like introducing a new
> >> XDP_REDIRECT_XSK action, which requires updating ALL the drivers.
> >>
> >> With XDP_REDIRECT infra we beleived we didn't need to add more
> >> XDP-action code to drivers, as we multiplex/add new features by
> >> extending the bpf_redirect_info.
> >> In this extreme performance case, it seems the this_cpu_ptr "lookup" o=
f
> >> bpf_redirect_info is the performance issue itself.
> >>
> >> Could you experiement with different approaches that modify
> >> xdp_do_redirect() to handle if new helper bpf_redirect_xsk was called,
> >> prior to this_cpu_ptr() call.
> >> (Thus, avoiding to introduce a new XDP-action).
> >
> > Thanks for your feedback Jesper.
> > I understand the hesitation of adding a new action. If we can achieve t=
he
> same improvement without
> > introducing a new action I would be very happy!
> > Without new the action we'll need a new way to indicate that the
> bpf_redirect_xsk helper was
> > called. Maybe another new field in the netdev alongside the xsk_refcnt.=
 Or
> else extend
> > bpf_redirect_info - if we find a new home for it that it's too costly t=
o
> access.
> > Thanks for your suggestions. I'll experiment as you suggested and
> > report back.
>=20
> I'll add a +1 to the "let's try to solve this without a new return code" =
:)
>=20
> Also, I don't think we need a new helper either; the bpf_redirect()
> helper takes a flags argument, so we could just use ifindex=3D0,
> flags=3DDEV_XSK or something like that.

The advantage of a new helper is that we can access the netdev=20
struct from it and check if there's a valid xsk stored in it, before
returning XDP_REDIRECT without the xskmap lookup. However,
I think your suggestion could work too. We would just
have to delay the check until xdp_do_redirect. At this point
though, if there isn't a valid xsk we might have to drop the packet
instead of falling back to the xskmap.

>=20
> Also, I think the batching in the driver idea can be generalised: we
> just need to generalise the idea of "are all these packets going to the
> same place" and have a batched version of xdp_do_redirect(), no? The
> other map types do batching internally already, though, so I'm wondering
> why batching in the driver helps XSK?
>=20

With the current infrastructure figuring out if "all the packets are going
to the same place" looks like an expensive operation which could undo
the benefits of the batching that would come after it. We would need
to run the program N=3Dbatch_size times, store the actions and
bpf_redirect_info for each run and perform a series of compares. The new
action really helped here because it could easily indicate if all the
packets in a batch were going to the same place. But I understand it's
not an option. Maybe if we can mitigate the cost of accessing the
bpf_redirect_info as Jesper suggested, we can use a flag in it to signal
what the new action was signalling.
I'm not familiar with how the other map types and how they handle
batching so I will look into that.

Appreciate your feedback. I have a few avenues to explore.

Ciara

> -Toke

