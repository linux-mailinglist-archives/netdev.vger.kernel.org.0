Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD95D598EC3
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346494AbiHRVGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346669AbiHRVF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:05:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C56DAA19
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660856569; x=1692392569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xODQHIuZAEidsfRhFlUvazcwFAFsVQrV6jqcXYhHhCQ=;
  b=gwzxBIITejY8Nfrx1mhY6vz6d3K0kujA5rFDuY/7uW7mUiCGC379nMwt
   SzsG1qarGT0JJMwNDu7R8DVqooUdXBoF4/kKCPRrvmj085uePPLxc3WD2
   O8D883AoYsnj1RDFKP1lFmFcmFT0BKOtXX269FBQkK0UUQothoVOV5Ii8
   +MQgb6rRw4XbSL1eNy4ApOTcP7IgAjUhJhwurQ1911WGoG7zsxpEwtA6G
   ruE9lPSeZizJP5bSlIBr3kMNlq0IG2ENahvajSysEtrR7ciI/OwkxML/R
   EA62dSlISqK/Cj7a54adPF9hDjYvWoej73WRi0/SZHnot8CV7ePMZ5IFC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="290436717"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="290436717"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:02:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="611136792"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 18 Aug 2022 14:02:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:02:26 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:02:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 14:02:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 14:02:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khX1oSgfbHzp5t0vnrQ53M6exhjWx6vsfvzAYT7FeNHOFpirwzsvfdXECrhghpiCWWj+zUIVzHqKOFyrb83KahTU8onsipuo8OQzb6aACwMReTnZvuzOQXzRVjHmfFbsxw8YRDCLeZ36xwlLBjNTSPu4qH5WRNzSLLOpmKajsQWHgbERoDLFozwIuXOjnX+WLj3BHlXcC9v3VEGTyNy0L5r1rjL1MwN3hCTwxF45FDdQ6YJrhafiXnYr6sJFfkIhwCkYdN0ZM/fbxrqr8gLerI8qwsXWeOYRGjjdNGWA0wLUyRllmhAhwM290omAqBL6ycWnNw7K992ktZAkvD0lCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xODQHIuZAEidsfRhFlUvazcwFAFsVQrV6jqcXYhHhCQ=;
 b=iylrPxtINt1BIutIGmJ7V+Kw+GvqCl3BEyaPXhz8pxYV0bIvd15q/+wGVqBjjMCEX2wlbix/qMMCguQg2xCpRtpaoZcROtZFVEoAeykE1Yj1RWqcZVeq77ai8/r40Q1QHhWHLLY3L5RVy5mWLDGBv5ED2bv4xxNsHKQEL0E66lJaLRkPUCU/o5S/jcBzUXtnkWoven3toLeaCtrp47/09eLi+OLRAAG7VRimwZ5ROQcSI8mymiwtq5cXwhaOP4usiX8itqjEdeUdVuNLwqpmQFCCu8HAMu87YGdSNPoNzIIOnBtvOON11o0kvEvEbtcMZYyreKuDW2f3bzd9GAqauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6778.namprd11.prod.outlook.com (2603:10b6:510:1c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 21:02:24 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 21:02:24 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "moshe@nvidia.com" <moshe@nvidia.com>
Subject: RE: [patch iproute2-main] devlink: load port-ifname map on demand
Thread-Topic: [patch iproute2-main] devlink: load port-ifname map on demand
Thread-Index: AQHYsty1vjaLBUJtzUyZBg/Utpu7l620Z2kAgAC+WBA=
Date:   Thu, 18 Aug 2022 21:02:24 +0000
Message-ID: <CO1PR11MB5089EA4C3AAEB9DCF621229DD66D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818082856.413480-1-jiri@resnulli.us>
 <Yv4JFNvAQ7jCyLlw@nanopsycho>
In-Reply-To: <Yv4JFNvAQ7jCyLlw@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e5408c1-a29d-4427-876f-08da815cf314
x-ms-traffictypediagnostic: PH8PR11MB6778:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zHx2sRJofY28qlqvtTVuhqMUhSbSISTjzyRK/9rInxeDlGG2gjTmW5gU+Fph7k0KAPZWd+zLeLYBS/QL/kvWajssApqKNPMafzm52pBRjNJmoM5ZjnX9MPntvL2QBvEYvzF3+/brzV6S+tSeer4taG4TNJxB884CN6XlKRk1sfN6RgM5J6vq/VP1HpxeXMbIcyA2GsYLjl8Td8s0TdS0jOwMTYNiQqDrVi5O/GCrQsoXOM1j40n9OK6xEcD02Jb5JZ575p3SEdtsMxdv2wIV0DuX+aSZdwMplc1pNgzch54gpXHiHybOQ0Z2Uwfh4MvNXIKqrPVpSH5rOG7xbKPkaSif1Q2oZj2lO7zryZs7rhRu7oapG6lcQ9/QUYqjJQu8yunya00i7+eTcBMq+3sVr+bQzC9YYUSHoRUijfG1IY1fjZtMuZjkR/v2D0lLJ7dNjuXhzfA7zwMo2RU7i//IM01NnXFpFHSBXhKChN3nh/DGU7bBemgG6VVMP+LKin2tlTqPn7svDvKoaU745q7ThK8Glk0LxOG+9mR86/GcbjytmtC42xBXbc7pDl7fyZUfXMiIcC+JjjbaElCEMNpQQ+Lm5MiWfo06JnmGIqLyjGxqzf6gOoQMPSCk8VSLoRrcNEX2HBtENdIKbPMTsadMVbrG3/MWViElMv1sHPbO0toAhitfBgVCc7a/Ny7J978IbcnXh+v666NukiPOgSHaYj0BJ8fFbS+JxD/rJdYb9H5Kf5UQElwTWPc5fBnrfp51
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(39860400002)(346002)(396003)(366004)(54906003)(26005)(9686003)(316002)(41300700001)(45080400002)(33656002)(86362001)(55016003)(110136005)(38070700005)(2906002)(8676002)(66946007)(64756008)(5660300002)(7696005)(66556008)(66446008)(4326008)(38100700002)(122000001)(6506007)(66476007)(186003)(478600001)(83380400001)(71200400001)(53546011)(8936002)(52536014)(76116006)(82960400001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?69QAZ3hceed+3xws31e0PxkDrsebVPzX9i3n2k6p4sRduhvvknoW1WUZd5AV?=
 =?us-ascii?Q?bp/wqLA7YY34i2WUoEPpRG3UMNCsqU3hAwnb1K3h6MklwupY+gy32UFokddq?=
 =?us-ascii?Q?ZurPALcSWuzm9RoPVxdlGoT5P0hG9yJSMEMyYiXi+FuLkzMoZY+JZvIYMxwk?=
 =?us-ascii?Q?idzceW+lDIPDqzYkMMYZb+D1XCvKOCF7RueTxzhA02qHjkOE8ILZfRNOQajm?=
 =?us-ascii?Q?W5lPnd9JXO6Cq3EzgwvIbDUD3PtQkUR+F72vqGji53AHd5IDUVQt1/hLG4AD?=
 =?us-ascii?Q?etHgsMGt32AVTe8Vp6prMK0jznPh42iTwqnWs73GfSXKfsCtcRldK8rd28ne?=
 =?us-ascii?Q?AoZtxnU1WPPEYwd+5Pifi/vkYdjicPL3si6ShSLO8ajXvBUqdG5IpH4rNIz/?=
 =?us-ascii?Q?Ew1anW58G7L/xqlbmIzWjqhbf5K8diRsTlOI42XQqQHknZ+EK4tsWWkA02aa?=
 =?us-ascii?Q?nfqb3IZfjMtV4GO4m8Fsz5CWQWnzI4MeFFmNV1yMlC+jjbX+hWMUtP9W5jUk?=
 =?us-ascii?Q?2TaSSfdYCmXAwiJO5s7VJFx7yLJ8VlAWY5i2acub8he3yh/im9DNvKttB6wz?=
 =?us-ascii?Q?n5Bl577mmHnvshbJ75rRBRSzMxJjhXHck07wBTkvf6DF5POSMU5IY29A385/?=
 =?us-ascii?Q?K8z+QBSBC3U4V39/izFVdIPTqZjXQgAhC3ifqs+LsH6AdefHIZt601Z4lBJL?=
 =?us-ascii?Q?lQDydJRlFJxiQtMec5WSVnauj1eVkjeDsMFHHHK6Hboc8VZRJbRG5n2c9WxI?=
 =?us-ascii?Q?HlWm2EDNz529PAGnfoOtKO8MwK6YrCGmlTz9UrKj3X1DfQU/J5meOOkiGDtO?=
 =?us-ascii?Q?XvQvlMfkuMftyail37JyGhYJUcCKDDNSVdopD9azpVMvkjlOrHStCBrYxSTh?=
 =?us-ascii?Q?uTGX+YKRaSMh0w4npBSSuQ+rFNA+iOm+2e03e+qCGn/BBYdcvm2t6meqQxOY?=
 =?us-ascii?Q?6g54cAOtTlBAMx5cIFUOalyQFz2f435cFoAD4UNMhA98d8554rawRrEzsFxQ?=
 =?us-ascii?Q?LWaCehhjrSj7j8yxq7asbwVmClyTbPT5Em+3iPO/V/1vqOSRt65hMJHo/Sjh?=
 =?us-ascii?Q?6P0Z+3jX3yGV6tD1e8ewmga6EXCW12vclbFUjpuMdtOosiphBpI1P3lHDfKf?=
 =?us-ascii?Q?KtrC0986WycrQ2bhI7t/JLmVusxfJRPB3AXHiqyh6ywxYWm8Y/fSi5+7wOsk?=
 =?us-ascii?Q?csny97nTshWJbPIr8zWsJUoXyVAd87A4BlmwrqFA9i/JGI2iAKcMfdZlzNkK?=
 =?us-ascii?Q?4ZWc1qLCbJrdB9QNXiaoafznOzMSWzAPSBXKGPiD9g+3HOf0LjPoZXCQidwi?=
 =?us-ascii?Q?DYzlMSH6adTQxHqL1X7feOYL17pJl1clIjmQjxfhWZrvlZR4J6UIu95UiRUy?=
 =?us-ascii?Q?9YwNevvokCj3QXGo9NRxBLXVbP95gDguFRvG3ljD3iINRg5xKNPN7eVyxm6L?=
 =?us-ascii?Q?Q2q2gWKd0LPYyHiMjRZL1Iyasl7sUSsmZuyLocJjQV8isGM3JLqdgOLc7vCO?=
 =?us-ascii?Q?9cKZEcBVGPysYlJSVNel/Z5YY/HqmI6vvd3EU7yPQeeXDefFZQe2W8QePIDZ?=
 =?us-ascii?Q?p8A1JFipL6IZc8PJmvWFrW0qm7BHm516EKWBquGk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5408c1-a29d-4427-876f-08da815cf314
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 21:02:24.0904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bMIxl0HqbnG2fP8aga+E47u5OXh3IGPmX+D1uP3x76o3PS8/EDPZDT+Y3qAf9frMDA1PJ07V6kEtf0dXEWY73Zrapu1t4/XsoUYqRr4YRjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6778
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
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, August 18, 2022 2:41 AM
> To: netdev@vger.kernel.org
> Cc: sthemmin@microsoft.com; dsahern@gmail.com; moshe@nvidia.com; Keller,
> Jacob E <jacob.e.keller@intel.com>
> Subject: Re: [patch iproute2-main] devlink: load port-ifname map on deman=
d
>=20
> Actually, please scratch this for now. Depends on Jacob's "devlink:
> remove dl_argv_parse_put" patch. Somehow I got the impression it is
> already merged.
>=20
> Sorry for the fuzz.


I'm about to send this series. Sorry for the delay, I got a bad cold earlie=
r this week which knocked me out for a couple days.

Thanks,
Jake

