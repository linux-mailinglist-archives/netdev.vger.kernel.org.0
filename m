Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F729581995
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbiGZSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiGZSVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:21:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB26A23BEA;
        Tue, 26 Jul 2022 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658859690; x=1690395690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IMYsh6noWjN71ZkurHBxR4gpg2KN9PeeEKfgqagn0iQ=;
  b=I8k3VNNrK/GdwyUGi3Su8qHh9tOy1zIQGgUuC9HoBxck95GX5ocKRhiF
   p8KIoTT0ez0q8nf39QY1QIpFB4/Lw8CY/ftjhBZUQ8KvGRhdlo8F9KIZJ
   nLk1ej7EeJzw2DaHddUIgL+94W1hB9luOsZiLxkfso9nOmEYHklaFfYD3
   4liNqQeB6fRQv/JiVA1odGNSwcp9d0znU3I5yN6fHz+7UkAD6JYsOgS4K
   BvoXtu8gnR1UMqKxXzn8UqIXB6DAXmY6WSkBuC6zK302NRZl/jDarWLIC
   m2+/ksIKZztBiqZt9kpX5BKluXqQP3D3LnolWQ+jFmRO1Il4RZRFvh8Hr
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="374325406"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="374325406"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 11:21:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="632862792"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2022 11:21:30 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 11:21:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 11:21:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 11:21:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Re+JPTR9PrLkTweO5HjeU6OsFC9F65LuRfEtVMGO8HQ0OX4gzGk2x63AYBf7ALa04I1sCif3ZnSyaHrJuqgslIf96DBIn/fqStY3wH8PwOzDnHgMIM8EJVPCp7b99VDGsTmTrwYf7fyV+Vpfp7RtGBpQZRyENrG0faxFJ09cpPDaJ5Y280WIik/IBsDCkgI0q6yqQHHbl7xJ+jxEbf7gymVVrTouO7MeLg6lzpn2bpLvItNmcrVxXnyB684qkhRKQyLm3GAofWhFr/VL4ImZvsAPPMLtm1YB64L7szyJwf9Ni1rdknrMzKym4zg2p37j+FjztC3z1EwuUE8Ks3xWdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMYsh6noWjN71ZkurHBxR4gpg2KN9PeeEKfgqagn0iQ=;
 b=F0SRD3VO/EqiQw5/iZonKJmjBvqysTaR4ctKPQ2B3PBApcL/2WrVvq2JQhr3EF0YZwT1JxVUVBi3ejMc5N6lTZaR2Zpn5SFQz/at56CZKBLOsAX4fB7LcV37y0masKXCKgSptWUtpN0pB7OI6MI5QRxFJCLOflvRi+TYxd2wTb98Da9zGXRwkN0c8PTdu5gcYLyE4coqK0GQmgI6NiXovc7uaKqf9DaJwyoOVSzlb9kvaqal3a8WiECkoi1GCFMOvxYp2Mlb+ICKpq3bFItGVk1LSZZGVXlWLDRIX7F6OcYzUIJF8MF3fdR5zejCNNwPq8m5gXAii3SykAgr+/3AJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BYAPR11MB2806.namprd11.prod.outlook.com (2603:10b6:a02:c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 18:21:27 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 18:21:27 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAIMAIAAACQQgABOTYCAAR1N0A==
Date:   Tue, 26 Jul 2022 18:21:27 +0000
Message-ID: <SA2PR11MB5100E97945A244CA88598F23D6949@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
 <20220725181331.2603bd26@kernel.org>
In-Reply-To: <20220725181331.2603bd26@kernel.org>
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
x-ms-office365-filtering-correlation-id: 418cab29-17b8-4138-af5e-08da6f33a792
x-ms-traffictypediagnostic: BYAPR11MB2806:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2bMF+psTt5Y8WqTOkyo+4czQc/EpCUoR1WlSbRK4wFTPigL1oz4zRkYsn0cD1zi5xQc9lvxrwJdMjJfwYlvoZO5Ts5j9D9tEVnVI2nsilUFY/3pz1nbf+ll/8wW4+dKc4w8TzQAhl76Y1Lt7S/hWOwSbzWoy9uj4rVLs+EiHXvJx42UQBNcN72ydOr9c5ijX0zWxL4EiHrN2NxVSow9Ds2v2tTNrSpkZ6tGoifUnzt5yFY7ympHAunLEqtbw/Le4UxhiO1mMMqD9VOkYnQ2H6d6VNtd4w4+/VSB4hEEHZeEJ6D630q2pwDHaDNMhBqorYZtwGFFa/7SsbfXFF6xDrtk1iqqhapADIufXNe7hQJF75XNqSXresykeRilffonH2sbf37ccEoa6kR01k0iaoWcYSj3i2nb+fF8kxCv/TVRMr7gVM0KeUYQz3mNHpCPUHgjPwvw7cljG2hlsXTJLPjoEZ3he2h4FSqkxmBG1BG3Dhr/iD2q6mHy6+q559I+qtcoAfKg9KuLZBPqAJT6u6G3NPZtTlngmHZY8cTVnWpS8FFuNsEFVJnnyIiumE3VqhfCEGa2iOlBgzwVv1QqTjzkMEVjx04xwN760PeLtSELl2OLnmAQOj4QCjJoXi/ZBvumyIl4BJnwABHDmVFy/h52OYmRd7pl7JrUfiArSJXw5fKA/k4jsUVGO1Jc/ge71vRAG7XzXCv4TXr7mgx/6tkjo5hpuwxcZusBVxwv7pUj2S/IjhBAPvYSeAm4ck6nyMSfaplJGoHOo+5vDaG9qJrLVvFDqiIrk2PtD3k7zF8t4cvXPPE4eLBiRENdyzYM0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(366004)(39860400002)(136003)(83380400001)(86362001)(478600001)(5660300002)(186003)(7416002)(316002)(55016003)(54906003)(110136005)(52536014)(8936002)(64756008)(4326008)(38070700005)(82960400001)(26005)(9686003)(53546011)(8676002)(33656002)(41300700001)(6506007)(7696005)(122000001)(2906002)(71200400001)(66946007)(66476007)(66446008)(38100700002)(76116006)(66556008)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KWURQ/Pa/FOByW6OIts18B+6uuraYQ6vCalaln6uAIPc+dSw9gD4YOUYAxzk?=
 =?us-ascii?Q?Rj/laLUYh/fyhBlBpQqcRIsbPoUTH14YLYIyIeujwXTk9Hax/Ve1ry3XY1au?=
 =?us-ascii?Q?wOLVmh5hJkUT2kHCbJv7AFo8sntSjxtJUcW3tMcKG8jW27jD7OfEqPVVS7II?=
 =?us-ascii?Q?dZk9r57BW2pM5xRSn3XCbO187/3FbTAsC8YtmXWQdJBkPdZbIpSMGHQeEvKF?=
 =?us-ascii?Q?R5Wl4RLaI+B/ZYXcQhX3qGDihelyU9WbTi9p/CWkhiHsxtlGYX+fvDEXQWvY?=
 =?us-ascii?Q?K9uciyTx92rrYM5+RawZdAC8u5U2nsApPXOrdxFu4mNbCkcvjfATp0TnkBxP?=
 =?us-ascii?Q?VqUMzW7rRS39qPoKppDiG+B+/T87yO/2r0fAMclRRkK3lezDPXcFrh8ppYPr?=
 =?us-ascii?Q?nEzOizwrkLMPKkmaAmtVP00l38DDZQmoaAy2m5d5cuRKXYlmCd7Or7pTYy/r?=
 =?us-ascii?Q?lo55f0uCfMVgxtu4Yvq1wgp0+WZL3NF4bO5SSQsxblgvP7qyn+fLu/6VMSeV?=
 =?us-ascii?Q?fqTAJE3L8X0Abqlcfz3a+TXLmnunaD/64uE8xOpOXrAz7fZog8SwZ2NSUvDt?=
 =?us-ascii?Q?uVukq46Q2aBVW8AEwQ2ui1telHzugb1HosD1n3o8h07GhqHrsvT9I4UjYeuk?=
 =?us-ascii?Q?dCuc8YtS/ZGZSRkhT3VzKvLiaR9gGVhmdMVNAKVMq18IG7L+nsBSpP1/X7ZW?=
 =?us-ascii?Q?+A1U2z+KSz0sypWlMfzmf/IX0wNz5HtOO5ytAeHikn0l5kaSCvU6ZtukN9yG?=
 =?us-ascii?Q?bq4UFETTL1TZX5k9iXW/PrtXnTTp0/h2HiBcxsE1i0L7kBZEp+zxfTFJ7Qg9?=
 =?us-ascii?Q?Fa9ANkHVV3h+U6c5OCs8jc856R7QW6MCXoNOiEIbfqPeFyIAdbWkUynER+Fz?=
 =?us-ascii?Q?nOd1wRYNBPQWHClTbtQjR5Yqfw2g3TKRcgaiEuIrbGpe6FgJrL/bnqrNNKo3?=
 =?us-ascii?Q?gjXFieftv2h/Asaf/73GR+WKCxxZCQvvHUDQ4u3EiFvZjH6SyIBe/MVGYQyE?=
 =?us-ascii?Q?n9Rf0m9m63q7Bv3YfzfTO+AZLBPcYmnlr23KvUgKPlNbe734WefPcGJtrUL7?=
 =?us-ascii?Q?pZVUzfK9OUQJuFsaTioqBfDv901HetMUchepkuwOsj0TuyHN8gVB3t0rKImL?=
 =?us-ascii?Q?po45FPwlwCU7cwQyY0jGQcCs0YeQMmyj5XZ1N1mJ0RetzF2RP/XOgBH6YXg4?=
 =?us-ascii?Q?+4x+yOX8fD25s96SHjLZ1MIuLHG/BRn6aP02ojlSfHWmjWkkI9m/1PUyLYkV?=
 =?us-ascii?Q?H802oKZkexUV7aJ2GXpo5ZkZBPOAaHmwYwIEUCT4n1OufTTOOhPeJgDbt1P3?=
 =?us-ascii?Q?g+rFRU3OUGuGm8VUpulNTPicBnfPt2KFR+VpZ0JzNPCdxAERQXn2HS9k0dOq?=
 =?us-ascii?Q?3wVWZzGei5oEmvI+zH2zolHcGpq9LtJfZErbhl/bZPuEojSEpH2FClchsYCm?=
 =?us-ascii?Q?Bt99Q/R8iMM619goq/Q3Q+QiNA3PAZIlo6TbJ3a5pkNUUuW9QBtx+SMF3d8a?=
 =?us-ascii?Q?ACL8IXezaH+qssb5Mh8kqIBM6MKgCKAcBj33Bbls/SQPSbpZ5WXMFU3cEKtJ?=
 =?us-ascii?Q?4dDGCtdh93LLPolr6ZI60VkuFAqrABz037w/nj5M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418cab29-17b8-4138-af5e-08da6f33a792
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 18:21:27.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xJSScAkn6Ya+M8k+XtHyi+D8eW/ItTCv99mK5Kz00fb27NaveP32Es27F+yY7Yd3nAKZ89u1OXnlwYrefg38PoL80yNQWFd5WYT8Bt1Ca8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 25, 2022 6:14 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> Hm, yes. Don't invest too much effort into rendering per-cmd policies
> right now, tho. I've started working on putting the parsing policies
> in YAML last Friday. This way we can auto-gen the policy for the kernel
> and user space can auto-gen the parser/nl TLV writer. Long story short
> we can kill two birds with one stone if you hold off until I have the
> format ironed out. For now maybe just fork the policies into two -
> with and without dry run attr. We'll improve the granularity later
> when doing the YAML conversion.

I'm also worried about the process for transitioning from the existing non-=
strict policy to a strict validation of per-command policies. How does that=
 impact backwards compatibilty, and will we need to introduce new ops or no=
t?

I know we had to introduce new ops for the strict versions of the PTP ioctl=
s. However those were dealing with (possibly) uninitialized values, where-i=
n userspace may have been accidentally sending values so we could no longer=
 extend the reserved fields.

For netlink, in this case the userspace code would need to be intentionally=
 adding netlink attributes. I would think that well behaved userspace would=
 rather get an error when the command isn't honoring an attribute...

But in a technical sense that would still be breaking backwards compatibili=
ty, since it would cause an application that used to "work" to break. Ofcou=
rse in the case of something like DEVLINK_ATTR_DRY_RUN, the userspace may n=
ot be working as intended, and it might be considered a bug.

In short: for backwards compatibility, it seems like we might not be able t=
o migrate existing ops to strict validation and would need to replace them?=
 That seems like a very big step...
