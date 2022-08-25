Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42F75A1826
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 19:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbiHYRvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 13:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiHYRvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 13:51:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B00BC81E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 10:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661449869; x=1692985869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wG2W82QH0xS0fIij66tJ1NhbPNjAW38C3sqyDk2tKdQ=;
  b=DKZIOHKLmDJHBJ7roEviK9/fJLvVNpQ9y6W91eN4SJ++Hr5uDgxOd4/T
   Bb9U+PkWDcQ+JFfHqPt6TrSwc3fm+jBhzx9suCZXqID1BTStzTytTbqGx
   h3jDe0pJg6yxLFKFdK37TCZyYFiSZ4laKmWvZMCnCRjxwMQ9Dre3ah7Xk
   whot+90G6n6SCun6MM7goBMMnHEIgCV4dj30Z+du9+esXpIJqQYpUM5WZ
   YQjm+u0clgB6tQb4/UQsDE4ghM2r4GlVa2TOsuc1aXLTUrF+KBlJP7bm9
   Czc8ZSEVnzLQekz+Q3La5CUtR48lplwiDa+oOETZyPvuWwq0bjvmi+onK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="294318486"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="294318486"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 10:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="610264238"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 25 Aug 2022 10:51:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 10:51:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 10:51:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 10:51:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 10:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGhuINPr6D+9j6s4RZxRcZuI7vmLUqGMsubb8SUBZgIvtHpGbRr3Vw5dmkoW9HIJDnSHQlwcHNEgrcTeYLcaGlIjmLZJueJVxiAyVw2FvB/jlD/IWgkOft1eaFEbVTtG4uEi4eKw6vTYFquzrgwLhKaaaXACh6ovpub4hzBRx6JL2jbSoX3Sib/h3y6I1yHZeCGZ4XHaJFawZZnukYhBn/fONwtxTWPNd6FPqrpOi1UVujhpNWlkLv21Wk2tfrD2fOnkNNrdJCj96L6Q+fwe0doTNyDbDxPeky4TZ5xyz55kUXLJ5VOOl55wenuQPh8TqVn2EMUeBQkD4D75TQnKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wG2W82QH0xS0fIij66tJ1NhbPNjAW38C3sqyDk2tKdQ=;
 b=Rl+qOT020JrFq1PaIQK836IIGnK2SjbjR5HUeXgkwPVnQcyMqFc+QE+l8x55g1jy15sm5Le9gNNDJSOkWZsBex06nwtJ9SPm9wUaCQYYvTA7jZeIXT1hoDfgxqvO/Y/y4D2jwu9n/phpDvXtTlaqWL4M47s1csnniXlzaXvOoIaXo79sMCiBY5DVzVLteo0xAjKIJYf/3Hna8HPXuP/Nie8lXAuw46go4nc4s4g6kstQdptTWoHZgh6hMf2DDCvNRJUgt992LFajINKcCP16PZ0Qmnps5VmvwwLAfH19T+zXGcgqYgaVMI08BPmmFH8QvoNEjlWrus/4khnTy5gJAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 17:51:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 17:51:01 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9CAAOPjgIAAnPyAgAAHflCAAAlpgIAAAyXw
Date:   Thu, 25 Aug 2022 17:51:01 +0000
Message-ID: <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
In-Reply-To: <20220825103027.53fed750@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59768bf0-8b92-47e8-5fbf-08da86c25fc6
x-ms-traffictypediagnostic: SN6PR11MB2720:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CSxgEpW7kCfXedBTMFDBHtqbU+h9BdiMzG2iwLkk9AyVzSOxj1/7Kzed9caEVj4DCsyzhcAHpo4EIsWucY1ETaVaPsYy+etEUFTAfUD2Dff0KiPYOnRLkmv4z8Y7pLV/ttgsWYkYDZENZx3rdkBchkBFGP96cFLcxIJXGnj3sJry57XCIszKQ3c5ssUkBfkLRSwxqm1D4O6CgLR1o4XOtmFpETRSmHZT0Se5u6lnV2wiFGmAhmdLACBOReMnfcyaFQzgdjWozVqHGDrTZwtynCggMhGc/WB4Laq8wgUZIYwv93x8h4TNDTdLE+xIPjFB4mOm7ua9XcGz3mYATBd2VJZdn74rIuZ1eb4ExzB+k92E8vpopaTl4rAUQvis+PavduNy08DQCrBJzvuFcxBDhNYBVUZ3xTK7vZVWyurTpSAbbbNZFN5akzQKvgMytkdSef5rFrqzy2QLs7Bx4M1PD5bSlKJXg1DNCDLavDFmS9wh1I4Bwf4+oeExIaFrWThlP6QAqEjRiIwJR7DccbaNhr191soZ+7YuMcXRpCnpZNd3tjU8LBKP5eXXzxkmaaxmGbYWlBFcVI+Gssi67ehLuhihSX/fW3eq13FThLEEUo3nL4XSRpJ7deHpa2Vwzs0kTdVycXq3GbeEx2Fej2tkCMEaDoBsyy47SOyXU41uVqUU5kT7WAes0ECa08mPb4bebPx1jGSQpFoAhOwSd76pVk5kzTJbQNbCRp96oE8qcklIghN0HytumoMnSoNcXeGrgGqgp2BIv47UzjvkITZpaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(346002)(376002)(83380400001)(8676002)(9686003)(478600001)(55016003)(66556008)(66476007)(66446008)(76116006)(5660300002)(6916009)(64756008)(316002)(66946007)(52536014)(26005)(53546011)(6506007)(7696005)(71200400001)(41300700001)(186003)(33656002)(38070700005)(86362001)(82960400001)(4326008)(122000001)(54906003)(2906002)(38100700002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/6T5r2hUPqL6vsB7cA+hBGkKwzFuG4ZBpxt0c2/KBHJzNT9l0CXNbnTD1ppi?=
 =?us-ascii?Q?pYGOWGDByZq6F7hHbOyOEEHvSCqrtAkhK1eUNRULlvwfq+6+unlUD06FZGSU?=
 =?us-ascii?Q?l5Faijpsnkramgl0I6+1ME9Rg0Cpk4Sg4Ow6pzy6NxHYo5VBSxTVqh7hCOAC?=
 =?us-ascii?Q?h2WuBwuVM2+jHXOKYqXtlAkyBzCjneUfnyg0aNHIS3ys79ZdzywWwyYl71lU?=
 =?us-ascii?Q?+TvYOoYfbVdoJ1U90mTGf1MDr4Xjkk3Ey2P2oF1xlKGu5XgpYzdGQJQVxjDs?=
 =?us-ascii?Q?QNmEoX3D3xuYgVjK+K/1/coa4syS44vkEW5UAVWC7BftF9YerPUY3rygwoyv?=
 =?us-ascii?Q?/e0LM7j8+qIzdjMkYh+WhKQk1rgQbC/sd54rdmCUsOoiViVg8SaN+EvbsZ4N?=
 =?us-ascii?Q?ue6FT1zYTiT19nERhJYWkv0JqMnvNPgkIqQYje/qluVDQQoygP8ElPQkbhEw?=
 =?us-ascii?Q?/3fTo+/c0XadV1HyhfpxaTmmM5F+vy5cxMxcMh1y5oTHd/Mz+fD3j0BkcuDF?=
 =?us-ascii?Q?Pj9sLxcevvuwCpE0tHCk1fL6ISxnHKY4EjjNtu6ZJHjziWW8Rqi6HlpUAkJY?=
 =?us-ascii?Q?9HMyHmhI0FugVD2ptjfPBhEANw85VLSBUjVELrqDdvUMyWGfd1qK0HC4QUDw?=
 =?us-ascii?Q?2AGNRNC7Iv6RLXQ3m8AWeaGJhqYNq4luKLSA6qvop4dq23eMsdoacXSpKq64?=
 =?us-ascii?Q?1QoDhsd8SKzhHw/lh/LqN0FfGwvQezaTmKQKzlDhv4H5CNzZjAbOFPlhgmPw?=
 =?us-ascii?Q?6MYcVrqOqnehRT8nOBb49RX3GdddcwHrpk+G6oG1wo+C9OHglYfUBqu41O8p?=
 =?us-ascii?Q?AWqS/HM6KLDLYB8o1MuCeJHUlzFLoKbpJRR3nuEd1unvCHbjDbdmOZIc5oMY?=
 =?us-ascii?Q?HNUnbwVU64iCiG5olanD04d6Q1kkOIS7fSNSoxO0BohqYbTJwsUfhEcYWe63?=
 =?us-ascii?Q?DhV779HhrcVOpVIK7FVy/3n3ki30sZmtgI2Bo7+qHOaPcZSMtA6BsQ2Dj7hX?=
 =?us-ascii?Q?Vs6LklhIdRyt1wXDgHk2J1f9ykuzuD1rRtsEthSdqsFr032b0ApjPNa/aAAm?=
 =?us-ascii?Q?3roFKYunL1AQl21pJd0C/W+R8NdJnFJzhppaUOVUsHUEPLVJj0REqApUje1D?=
 =?us-ascii?Q?CsLvVkX8OcNphzPH3QP9iVAS9aZ523UtyP6QWfQQ0PbUhNA4gSKSX+6KhZbW?=
 =?us-ascii?Q?PgHe+V8vwiKkrjJ1ocsZgZs5i4Dtp6QgtDIMgJvcgd/G1z9eVTdWgOdgWfZ+?=
 =?us-ascii?Q?EX7ObL722xBrGa9pd0+IKQVTd/ano8dRf1t146bTogaM8gQOfExvEIFnLBlu?=
 =?us-ascii?Q?U59zqYQUWvWFkk8NaeNJHB8wdI3yhfrznooq3GlI4LdyqhZy7LUpYsFSO4KJ?=
 =?us-ascii?Q?wMx4UW1Q0KhTGwiVAiibfA+KpISNismOYYbNeEVjbFkYzskQil0EcAPx8mQm?=
 =?us-ascii?Q?9Sl9/s/YYpukG32RSZyz52NLwch6FxZYBvBYeujb5dzJK+m4zqcNROCI8uho?=
 =?us-ascii?Q?Ip1WEeATqqeMZxi4XC4dmeYYN3GRuOEPurgVG7dk/HyvKvFD3BVQK5hDSHlY?=
 =?us-ascii?Q?Qal7bE938H84juAn+TwiJlnD+xEOdcRhJsKr7ymy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59768bf0-8b92-47e8-5fbf-08da86c25fc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 17:51:01.4803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pru3XPCxu4+JFnL6wRk5BFlPHUuRxPIR0pjEHFSB7aVcwQLfzhI5wkI3bHfPjJ6K/m9N6bWyMv7uWupZS5eP4+TTyXL12JarNpdLgnCjl5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
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
> Sent: Thursday, August 25, 2022 10:30 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Gal Pressman <gal@nvidia.com>; Saeed Mahameed <saeedm@nvidia.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
>=20
> On Thu, 25 Aug 2022 16:57:50 +0000 Keller, Jacob E wrote:
> > > Sorry, I misinterpreted your previous reply, somehow I thought you
> > > quoted option (3), because my fallible reading of mlx5 was that it
> > > accepts multiple flags.
> > >
> > > (First) option 2 is fine.
> >
> > Even though existing behavior doesn't do that for ice right now and
> > wouldn't be able to do that properly with old firmware?
>=20
> Update your FW seems like a reasonable thing to ask customers to do.
> Are there cables already qualified for the old FW which would switch
> to No FEC under new rules?

Not sure I follow what you're asking here.

>=20
> Can you share how your FW picks the mode exactly?
>=20

I'm not entirely sure how it selects, other than it selects from the table =
of supported modes. It uses some state machine to go through options until =
a suitable link is made, but the details of how exactly it does this I'm no=
t quite sure.

The old firmware never picks "No FEC" for some media types, because the sta=
ndard was that those types would always require FEC of some kind (R or RS).=
 However in practice the modules can work with no FEC anyways, and accordin=
g to customer reports enabling this has helped with linking issues. That's =
the sum of my understanding thus far.

I would prefer this option of just "auto means also possibly disable", but =
I wasn't sure how other devices worked and we had some concerns about the c=
hange in behavior. Going with this option would significantly simplify thin=
gs since I could bury the "set the auto disable flag if necessary" into a l=
ower level of the code and only expose a single ICE_FEC_AUTO instead of ICE=
_FEC_AUTO_DIS...

Thus, I'm happy to respin this, as the new behavior when supported by firmw=
are if we have some consensus there. I am happy to drop or respin the extac=
k changes if you think thats still valuable as well in the event we need to=
 extend that API in the future.

> There must be _some_ standardization here, because we're talking about
> <5m cables, so we can safely assume it's linking to a ToR switch.

I believe so.
