Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C235A580650
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiGYVTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGYVTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:19:47 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073EE23BF5;
        Mon, 25 Jul 2022 14:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658783987; x=1690319987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VFnM11NAndUBRu6AYKk6UzE/VKK+eY/Cv1xREbW3oxc=;
  b=Pk8uKmrgzAA1Q4nPJazSmfAxC+7hfWI9N771mkgwGVNDdD1q8OHNTBep
   KL6pyHcrR85jTbfuwgg2gG+bvXEzar16FmuDpEn/rnW1vmYB5IFNmzyQz
   uIkUIS8f3HJ4Rxd4Js7EZrSS2EWZLAAGi/1uzoVSCSw87mzCdzen521Sz
   ZyWeAwdIU/r6o87P018ByunvCO5OVd/dA7tqONb1X1bf4gmkOzaJS2K5X
   SLHhT+7w76mM3CE9DqAFFXClDw42S0hlWsMpZHw/6LPKTiOVln4DtojFo
   mnYbH5BqBrIrhTD3lpvrUNkl0+np2HMSiMd8LqRV4weJL7LzutJcm5xlP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="349498040"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="349498040"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 14:19:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="632504197"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2022 14:19:46 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 14:19:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 14:19:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 14:19:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfqXzqSUf9p3fhRL5nSdLRpdGHQkunIoVuBHHmrat4/MDcwKlTW/wPRuT7mNVsMzfLeEEiGrZR+8PWJUXaRlQmW3KRyyBuxekVpIvxVXUjfI1Rm2ozkO/ZAa2WpFX6LcroMwy/h5+gV+ZtDq0isM3ObgH6ILM0ddhzjpuyv8mXZVWevbooly1gc0AVyrhNblG5a3B+B+8hUSLka0cDags09X3TZrhRzdoMyHaBU5r+7ClFmvVJV/XdEy1pBb/lCN9qCT7JW1nIQ44/Y0RnsoKGQdo8DgsML7YYgamhNMnevQ5NHCAMUZy1vbsk05lRqwtXaIGT0R3FCXcpOFgVVzWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFnM11NAndUBRu6AYKk6UzE/VKK+eY/Cv1xREbW3oxc=;
 b=aWkeTgCobuaAbsQWZxKyN/EaON4EG4KJdl6MjqYImlz09kSFTAQNQnhApV7zQbq5THRPnw2qyYHtTj7+PB+Oeo14/ffF8cxqcY+CFvXAtyHMDkNDaZKXsTwqUrJlMLdrakQBRKp1auNIuRU6YAdgxgtn8I6KIuU/ajnWcJuYO+zJenZsuDVT6SwW36bbYwsZKlgZh5JlGJ5dacEmuMxehECmLxR6V62w+DBWgQ9lO2H6vNkwK9Bk2fyeMdy0JitQiKi2b3cHzA/PBpmziFvstc0xlmLAuStk3e/VTAtMcaYK1Gya5NWCV9AoGJS3L1UvGGpQ+JkUA5IqgUIIuEs1TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BL0PR11MB3171.namprd11.prod.outlook.com (2603:10b6:208:62::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 21:19:44 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 21:19:44 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [iproute2-next v3 3/3] devlink: add dry run attribute support to
 devlink flash
Thread-Topic: [iproute2-next v3 3/3] devlink: add dry run attribute support to
 devlink flash
Thread-Index: AQHYoGkavhZOFZPEFUODGj22P6MV6q2PleEAgAABepA=
Date:   Mon, 25 Jul 2022 21:19:44 +0000
Message-ID: <SA2PR11MB51008D6191E91D4782ACA99CD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
        <20220725205650.4018731-4-jacob.e.keller@intel.com>
 <20220725141314.01771885@hermes.local>
In-Reply-To: <20220725141314.01771885@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7445e760-a5cf-4916-6e25-08da6e836556
x-ms-traffictypediagnostic: BL0PR11MB3171:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y1w7pPK1lrVN+NFlczqLc6QjENtiEE/bea9RVyxeWoJn+yAXPDiPUU6Hpnbwae66R3mwxJioJ7VWfqEXZkNH/ENVvSiMOwqS9ll+ghdGqAMZQAzddb50mYnt2dFsjxl75M2hj5Lf5NHF8/57g0kipk+uAs7S3veiWOo50Ij4Y96q+nCnXDf4JjOpJx+FKROXzWSncnmAFuvl3F2EH7iOWRN4pAqtPBzUCNyPRaZCw5AcDtbO/GkRfjREuZQVmFQRQOePN2edgy7huoINFKWxD0TstL6ZQ2wCzZa+O5l3ActqKsffo2FwDgz/2kr4S0CyLxqfxMBVE6qlNcD7/5eC1XYmBr/pYcR9DTzpmqsXqGe3k8qxtcAzVrn9Dlag0Es9c0wUWMZ6XwwVVxbEMyNm5eIPwi1otGOoDavigrT8WVtK/sPKwmkbPXP+bhnexy7nDvGoV1UIqgFUJNPLVkqna0Ro6TLOwIWeeIFnHaDkbpvGC+jZuj6J/e46Lbc0Frrlgk2HZaTPWy2toHPOJUZjTfDtlsZN88/oJLtntTtDcTadOGVB3AWTrwISW2KtDQwhVtlj71hmdd4x9FMIO3/Wh5EQmg8o9bNJSCAJApZGSwZqzXT7UjBj8WP+eeRYGnNzZXVDb8aO9SmnCcCuk0gYmTngJ8cB3dp56U7WN8Nh2oo5P6MRRhamT+PNx1HvSyRs7kRT9Ps+GNLxTOj7mudZafyO23CqQ2urZ2R3cDaV7YUNH+fOldhSSo8zon6fwnQFA1iXrIsBReouqCkb8s3J+d8haX71gfFKbdLnRhbKiNyLRcl2Q8yrF/04tktLaLQu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(346002)(376002)(396003)(83380400001)(53546011)(82960400001)(38070700005)(66446008)(64756008)(66556008)(66946007)(122000001)(76116006)(316002)(66476007)(54906003)(52536014)(8676002)(4326008)(6916009)(5660300002)(7416002)(9686003)(8936002)(26005)(478600001)(2906002)(38100700002)(6506007)(86362001)(7696005)(55016003)(33656002)(41300700001)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iuxd9LFPYw5UjRKH7ycqRHzZ16pesvDU5M4phhWxelMerTi0jYltP69pIVXV?=
 =?us-ascii?Q?F8+376pLDWHtA+OM0kPi5lUZtcYFGm58oVyxOB5LgUapFZE94uw+MuXhj1kZ?=
 =?us-ascii?Q?5khF9Rqdo084CvmHQz3nNOX/KEV7XWwCD2coAx9cy1ATnsWCPksjdcMjHG5/?=
 =?us-ascii?Q?VbUd8Z6gb6+S6br255+B9bJbq8DR51SyuEM5IdEMejt+UplUN2pJw8iaJmuF?=
 =?us-ascii?Q?uN0b6JmzITHJo9NusibGJQbcFJAfic9cwazoXu861ApfDNZSO61nKlJaHgDS?=
 =?us-ascii?Q?OfleLu0yIDG63R+MKSZucDbVxdnWvnjDkZnHjQJCpgh0W2I5UErbEaJzJiEo?=
 =?us-ascii?Q?bDrxkaCC0/2ZAzIby2bkERTGZEN3NOKlfOfUHJEjUIHQM79mBmrxxmfHLN6S?=
 =?us-ascii?Q?FM09PN6ZtTLoQPsDDC/ikr2lCL7dOCPVL+CCHI3CHMqfnUcbiA8nT9DcNitq?=
 =?us-ascii?Q?S8keBRqFZ1KBqqGCGM0O0sLMW7a6+iBwt5s/stsdm2J0g8vHNdO20Lsly3Su?=
 =?us-ascii?Q?s6RTtvPLR7W2ki/xHYelhI+4xgYCBKH234RgVK+GqoiT/YcSNapFDSORUNr5?=
 =?us-ascii?Q?kikHUAP3y66HoqpN+VZmeWlXuQGvp6gElJT3RfOvXGfpSmIhwONIAZnkov0r?=
 =?us-ascii?Q?jBIywAiXcDSierECwK5hvOx8xqsYh5FvYRyGoHo1mbF7h2HlnSlw/7utw0qw?=
 =?us-ascii?Q?V6VgMBwCmnAwxn8EETnuDnZ8FKe9cgp2UgRwfHZF+yYsyc7us2pYyv4eluzC?=
 =?us-ascii?Q?Qs2YsXvRjc1Kw1el/iS4s+zRtwtttT6cCGEx6gzTfhQpDpFSX9kzEZyfLonc?=
 =?us-ascii?Q?V8g7L2O3l3+9HnSx/gsr0tGn58y6j4z2/6TVRCUISEQsHIJtnkwU/htSx2lu?=
 =?us-ascii?Q?NRhs5LxhThXSGONDE9TDC5y3jYblUOrjDJXSWisxzp4+dLCRwh9qQgkYfntk?=
 =?us-ascii?Q?/dWCgHYF7RuL2syKQ30ZPaGivjFWlfx+24O+teFLm+OtJHzAysu+EHxs7Lu/?=
 =?us-ascii?Q?3HX1YoXPDTSfkfqNH2Teckh613fdMdpBD8Wq5hTRUIzAsh3UUcwU8HSBkl7J?=
 =?us-ascii?Q?Uvgbd/3VEu9Ki1YqfP0caqHUYlua3MPtqA7kKN7bg7VtoLAzwxZD20zioJes?=
 =?us-ascii?Q?tlWCW0c3iEnNqePl1jxysCaxW09SRLJRsjdxDuEQkibEQhy8pQc3wAtb1l5A?=
 =?us-ascii?Q?eUBGjCafdPWkO/y5XLhVj5ryCpyRUpz/hGOFZ4WgsxL/9b4jFUQUYHMIqLSo?=
 =?us-ascii?Q?abtCjXyYtpezQcxe4YCvmYRJycsv8eAJFiM8un1ewo3T8fv6F/Y1l2BhTc2e?=
 =?us-ascii?Q?UjywaAwbKohQF3yuu87kzSSGS9NMDk1rxjYkslyyEH5xK2BIMGjtK++gzsW+?=
 =?us-ascii?Q?IloXJzbRJG1BHWpuQuEd1MpyXUYcKCBwUJ5IFQ4VoBAX8uc0sAOVo6tgaokw?=
 =?us-ascii?Q?sOCJ4FSFv3/ahkK4/AFhtICZijWaia1va/xnSXP9dZpfDx7kmYA3/7GgNcVG?=
 =?us-ascii?Q?UUQgqZmcQ1LNuVvoJbHXuVzzpHEUmYwccJrDrQD3byFhMS7UvQ/D2DYxzXaC?=
 =?us-ascii?Q?qzRnkfmuXAIZiTn367JDeq8pmxYmJNwMcyV2GegY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7445e760-a5cf-4916-6e25-08da6e836556
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 21:19:44.5813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t94sQuV3j6+3xGN/qN6czUVSqL3KNnetN7LECmMf07QRt/lK+p/lHAFatJGl7MAcVmNjiQ3YCX/9vYUEmFvT2hhAkvz/znsI0wnhRikWpg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3171
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
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Monday, July 25, 2022 2:13 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; Jiri Pirko
> <jiri@nvidia.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> David Ahern <dsahern@kernel.org>; linux-doc@vger.kernel.org
> Subject: Re: [iproute2-next v3 3/3] devlink: add dry run attribute suppor=
t to
> devlink flash
>=20
> On Mon, 25 Jul 2022 13:56:50 -0700
> Jacob Keller <jacob.e.keller@intel.com> wrote:
>=20
> > To avoid potential issues, only allow the attribute to be added to
> > commands when the kernel recognizes it. This is important because some
> > commands do not perform strict validation. If we were to add the
> > attribute without this check, an old kernel may silently accept the
> > command and perform an update even when dry_run was requested.
>=20
> Sigh. Looks like the old kernels are buggy. The workaround in userspace
> is also likely to be source of bugs.

We've known about this problem for a while.. I think its more complicated t=
han just switching to strict validation, since ideally we want to validate =
attributes for each command separately, and not just accepting all known at=
tributes for a given command.

Thanks,
Jake
