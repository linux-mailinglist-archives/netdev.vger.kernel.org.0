Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D586BB385
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjCOMpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjCOMpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:45:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0805A54CA;
        Wed, 15 Mar 2023 05:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678884255; x=1710420255;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wSSSG5MnRH7TxtLXFlUbCOXCGDfe7vwrVBgOEpINp58=;
  b=ABS6AxqngBEC3TUkOcF+a46/gzmJFTgP2s8AbEZSdOBkADGGU4SxZltJ
   JnPaZgBpQ8uw3SRFtiTgrLsM6WybooUR7eV7QNXV4rshsYvF0K9kOOSlV
   O8IoL+jOAmVJl1PQA3NLjo+r0bkzEz9be2vdqfzoxoFxg8AN75CfmT5rz
   5q0NHmHjrz6g7MSEwqvNXO0Kgv48J1FdFuFGmJEQDIvAM83fj7prR5zXy
   j3N8bmKDK/Cgpg9AieB7EQ+x0w4Uf9msp03TQq3fCToJelhlwnTuT13rb
   G5nFP9FRlZXL15rS/HXGcPpgeZg89Rd5Au3jfPbhA2BMoEcgmrfcETU/R
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="326047800"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326047800"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:43:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="709672220"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709672220"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 05:43:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:43:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 05:43:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 05:43:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGA060rxa+jl4pBuiTLHXV+TMChSXUl4CIJre6lBXCDr5ci0WaFsvXCI754aRbG1z0xdcxY7MhWvaLNu6cCgD9vVo0LNG3m9IorXbbET1SrrCXwj8LYtGmjXJvgk37wZEb0VCwubiE4OrW1lEXo7rjqBgZOEF31pKl/toAYnyAFqf5d0VevsGwixC4pt/wZXSNSSd7kKrnhopx5DPs3mTfeG3QFu/h/AC6bT8TUVqLrZiKoUu/6E8djnTfhnkOasTEwI/xBCae0gB7+RcGQwiS++TRbZOH2G7BvZN0IBtxon8LNMyD6BIh97eXU8p7hvp5nEdx0Hcmbhjb0qZBIQng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyAAR7jgLplXxfHbijvd+KF2BYC0TOv+umVJDZmjpGs=;
 b=nQ2R0oKwwJH0MFdqw8Oh6KMrijMrYT1Fdfewh87T6MxEj5waWWoA8dg5gAl6HRJ5tkQuLRyV4iW9j8O6mTxrPYSxmL+zuKQOf+yHARNsKpFv8LkBCkPKS05l92Maag1pcOMpyTO/+kzx+ZNtNH1jgs4LMAezzYExi3jUzjncA4CbZmU9/0R+9nE6bnvpbmjPFg8zUUIKrY7FPrsqPOSNkFSp5kDx0xmOijhe2QmiZFrGzzFE9ekXvkykmIzplHPppElMtjnzkqxL90DjI+/XAvEnhQBMZNio5ZBO7gms99XRRRhypvcJHM/E/Nz2ds+klCQb9SYS3cQ2EuvFnkLpXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by DS0PR11MB6469.namprd11.prod.outlook.com (2603:10b6:8:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 12:43:20 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 12:43:20 +0000
Date:   Wed, 15 Mar 2023 13:43:17 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     <Durai.ManickamKR@microchip.com>
CC:     <michal.swiatkowski@linux.intel.com>,
        <Hari.PrasathGE@microchip.com>,
        <Balamanikandan.Gunasundar@microchip.com>,
        <Manikandan.M@microchip.com>, <Varshini.Rajendran@microchip.com>,
        <Dharma.B@microchip.com>, <Nayabbasha.Sayed@microchip.com>,
        <Balakrishnan.S@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <Cristian.Birsan@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
        <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH 0/2] Add PTP support for sama7g5
Message-ID: <ZBG9ZVjitIT5rMf0@nimitz>
References: <20230315095053.53969-1-durai.manickamkr@microchip.com>
 <ZBGvbuue5e3vR8Fs@localhost.localdomain>
 <cedc50dc-bbfa-d44c-1420-f72acba4bb81@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cedc50dc-bbfa-d44c-1420-f72acba4bb81@microchip.com>
X-ClientProxiedBy: LO4P123CA0452.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::7) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|DS0PR11MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: f93254ee-b0aa-4677-3a00-08db2552dbb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjCHHta+WY21ijuIDkojMUu38JMHiEeG/rfRKpIEGrjCWFwGBetZaC3mXW+nmk+ApuFlFUILh2CR+S1md7yYLTPERuUtHa/vba3IW8IAq3F9y2V93QX7HESJiv3Tsmn3SZSRY1drHkaF5RML/kV4kABbchFD/2ye3936ztvXiTdafo3W2yIgzYmcao/sEWh/6w6zbpqJWIgpHY0Jvevwo2xfov6It2E5uFx/FGl7DQ4diqfTf/I+UREv1WcIfMgmpnxIHqr6KEV0BHd32SbZMwjbRNhZfmk8mdj4qaIRUWjr94ttrK9063xX4iEYUgt1dL8f+o+PbmqGncEEof+3PfrUO9lepZMgs1Jh7ayl4aRr6sUzotsLJAULNtei6LNFnytLLShGBK0LkNt7VuLzxd3cSwkd5WSV17S9KCd91rok3S6SpYn4cA3C3PER4iRu4FBKR0bpi4R//UQpk6AjSxxOeyOmVnqS4kL7FLKuhehhUH8XjRaP4qusat7te2WpK4Lr64HyUTapRYiskhVjzCk1HXUWWhfZd/sAccOuc3dzmKlLCGi0yWKV4uT921ZAgfV9sOpqfPxRe3FzN5tIJRMamZoU54lLOtg1qPgNQWkZMY03RV2fko0sVmyTyuU10rDtO52OyTdIVtwKNfqumIfdaWD+rA0KZlruSYtKIsIQ0oU8sEfQGIGTr2XrixXr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(86362001)(82960400001)(38100700002)(7416002)(8936002)(41300700001)(2906002)(5660300002)(4326008)(53546011)(33716001)(9686003)(6916009)(186003)(26005)(6506007)(6512007)(83380400001)(316002)(66476007)(6666004)(6486002)(66946007)(44832011)(478600001)(66556008)(966005)(8676002)(138113003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tk214Ef7Rkw7qVDvkF29xJG5y+eIN1TGkRZkweueRYNPgUMUhE3OhjHoMq88?=
 =?us-ascii?Q?PI2QY2/4GT2is/gQOMPZOC5z/3e35bJ051XkNPID3aZFJQEdClHfYlzKPnUw?=
 =?us-ascii?Q?EMOuPJUEzSUK9Z6FnCEOG91nvhmKCZlHq8FSXm/AoWwrpVoKkcnaZj+HegZa?=
 =?us-ascii?Q?WQkxLos//SlLiKjQEKZY0hY6YDDbtMBRON6nS1ltyV3ykhYE46YiHLMwyzg8?=
 =?us-ascii?Q?dMjYZx6b0duyZcOBT23jvtwFnUIf7LqvQvtBlOGgP5Yg9ihFHLes6pKSfYLh?=
 =?us-ascii?Q?0rdm6s6W/gH+EUu4NA2IG+g9q8eAV/P/DRxnFCelqEOJkjeLrnPZht2/9x2S?=
 =?us-ascii?Q?7K4aQMc+NWylVpX6WdzTOtzKtBWINp1YRT6z59NpaKtw02BFAowN6RGlubTP?=
 =?us-ascii?Q?KS7l1CABhAG3KZhmv4J08KyfGsCt0b2tG+JuoMg2ca1reBmoq8YRs1ZcjXlI?=
 =?us-ascii?Q?HLbtKcfwQH3WR+M4UTgrRvGt72IF4AG52mkrAcBLtlsS7AhFAxLI/lyDiPVQ?=
 =?us-ascii?Q?Xq9lvjVVD9s7BDqcsO/KWv4Oh3OV6I0jjtxAxERP2MKDOhiivHyMgQu93R/f?=
 =?us-ascii?Q?7qs/nr6LioB6DQ7Ejqn9dLxejYY2dVRzJ7r215N1VE9zx5TqjEvwtw96RniU?=
 =?us-ascii?Q?Hwpp1oDhe2wg8w6FybkhlTnm4XuiXDYOpuFxar1zHgrTOe1S9RS2hSambgXQ?=
 =?us-ascii?Q?5xMXKYw5J2Mujgdbt42vIe58TWlAwpgdTVu5weReTioQ7F78GrAm9Aw/TVBe?=
 =?us-ascii?Q?YJZJ0QzvJ2rjxrBL7qzdiCsYR/P8QvDCDaodHbHf6oj0VOPs1G74Rev+UqQw?=
 =?us-ascii?Q?wh05SjHAAj9WlfjaL5KtmxGb5UEiSJpLjx271P6hZty1TT796uasE7YisIK6?=
 =?us-ascii?Q?d0+zGWIUDhUlPrH1ar1EN6sFuC4Umk8K6rbBY/vdbPYYY4MNzbTJPuftODGs?=
 =?us-ascii?Q?bxOo0Q9+iFUYF0hOAwmE5jXXHKkEjurXAYhxFiwQhRezzJoaVI6gvKCihqkQ?=
 =?us-ascii?Q?3EVu3SoCs+TrjtUD5ycR29zgFBmNgNgMHqmfZrbUlwQLM5pmQjNirOaZzJUr?=
 =?us-ascii?Q?5cpfbcE5xWk5AhW12qNFmhU2a5u/WVC17h2n/aA0EuwOwuug7LSbpPseczzB?=
 =?us-ascii?Q?KmPV98Y4KuGYxOkvUSZ30R/Xrl/FKSBQDpzEqgsmBy/YdfvQbIyC4a5zVBwb?=
 =?us-ascii?Q?RPgbR4w4ze+T0O3j0V1S1XJp2q+9l2G3Zlz8reI//02rr+fVP53Z9o38sp99?=
 =?us-ascii?Q?a5Zyr67cq/5ROa3wvvU7wZ0GUjQy74firAGYKmzqiShFvu+LW7Mrb5M5OqTe?=
 =?us-ascii?Q?k7whrvXUokkyvY/VH97OTERMsSOvRfUyaTKJe2wKhfe6gDCC5hqlYSEGdCyl?=
 =?us-ascii?Q?wSvzhTZowBBl7dO+SS/jfDwwsZWzxUfvJYp2Hho3WbBcl6YM6ZaIeaJK24JJ?=
 =?us-ascii?Q?ioN/qkd5CzlRkMoHoCKu6hnTmVoqUfMe8tXz71+Mm1vP2zLoHvbCjTrSrjU+?=
 =?us-ascii?Q?cNaOtRwCWtrd/ZduJO1APo3m8xUjjuZVAC6cF8fml/EhAniKPgyUA+lAswOt?=
 =?us-ascii?Q?+lyf31BaMhlbR/m/U8Hmm0SzvERdZML59s6TYn1bKSB1xygtomhPqTFyYzUq?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f93254ee-b0aa-4677-3a00-08db2552dbb2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:43:20.8368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WNKNZFaRlKv3YBQup+UBRNCXktxZWdcmEhmyJVQB0Cc5pxdjK0wfAGGsxvdNiOqU4JKGnAZ1ra/zNDAIOhdiDYX3ajzFivPzHRh3AtiF0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6469
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:56:15AM +0000, Durai.ManickamKR@microchip.com wrote:
> On 15/03/23 17:13, Michal Swiatkowski wrote:
> > [Some people who received this message don't often get email from michal.swiatkowski@linux.intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > On Wed, Mar 15, 2023 at 03:20:51PM +0530, Durai Manickam KR wrote:
> >> This patch series is intended to add PTP capability to the GEM and
> >> EMAC for sama7g5.
> >>
> >> Durai Manickam KR (2):
> >>    net: macb: Add PTP support to GEM for sama7g5
> >>    net: macb: Add PTP support to EMAC for sama7g5
> >>
> >>   drivers/net/ethernet/cadence/macb_main.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> >
> > Side question, doesn't it need any software implementation? Or it is
> > already implemented, or it is only hw caps?
> 
> Hi Michal,
> 
> It is already implemented. Here the scope is to just enable it for sama7g5.
> 

Also, since commits lack target tree (net-next?) I'm not sure if the
patches will be picked by bot and tested.

Piotr.
> >> --
> >> 2.25.1
> >>
> 
