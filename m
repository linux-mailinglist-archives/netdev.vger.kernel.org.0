Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2978060F4AF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiJ0KPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiJ0KP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:15:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346C443E43
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666865724; x=1698401724;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rc6XWMZSYiVAjsojoScVIDqwrOfIauJWzBpeBbIRTxg=;
  b=Eg0VZojgsgT5MEadl/4Re/mPNOo8TziLmdrHW55ZAB+a30CPxiyA1dDY
   ca5ft/rBimebiDM7mjf/qcR8a6kBYYBgBEgLzb4dD/M6UE4AQVjIcAdss
   psZKolvzGvYnxaXTo0uxR+Us8uljSdayoDBRbHoCDc2xiodS3nt1td0yJ
   OXjtcI9a0kqBJYYOWeSGrJ7UeycC7zrZdPkw7AsSQMwepjOO3I9W2rwhV
   4JKFZFXkvMOyrX2sEMD4lf2snb4zitdUswDT5XWQno2LQQHOZ9R9VviUj
   zGElbCSW0uiR8khNQZsmAvzCY2iy90Jjwscf6pmURnjYwooh8QsV5UaFy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="372397142"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="372397142"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 03:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="877531980"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="877531980"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2022 03:15:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 03:15:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 03:15:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 03:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e27tcKAXxnfau7givyexarYwYN++ddhmrtqA3KoEIrRFzJT36E4kONNdbxvqSQfNafqZPyqViNBRZRgvptPA0iIPlVv9ucfJwXNMmw9XBAtvtgTTsqGObHd6KruPVcOsbB3kSkiz16WV3NWOQ0ICC7gg+uTJ8k7qmKbnE9Yp6HS8MiemS9VIBXJf4cE10GnVgxhp3kk2UYpgPiYA5vwWij/mnsn+exBD8IG0UgUNoc07yd9h99zVOD9t+s674sdJeASp5yqrKIjiwsTR98b0WcQqja9reBblu2ZyyIJexFb76jAlSylJ/ik7X8TphB4P7NpFVfXLl2WrSGz0lZZd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1UV5NJruI43/7kM42Mg+tTifTYw85Ej7helcvxZlfs=;
 b=NaSfdW0BG/8/DspHzsXr0MKGcFx9CY/rn1r0Fcnh9j80e3ywLFrocUTQI7FeCcaLKtFC+t/BwjcToTFZTTtIhzpLSYNXxy71tugfrdsYLUs70e6y9vLYCQ3VHmI1SvXfc+6dc4KB6RD9XI6v2sE07dol+SJDQVZO0xh+Z3ynscN4UKF/CD4J5L8dLLFr13ci9ha/umPoW/WGrOJSyVCapjFnz8x/3AuvyXyEhgXYraVgzHFbjNqc912VHR1wUEgflnyE4n5T4jprTvwf5P5mdKXRFu9UOzLPbftzCKKVbG6fSGxlO05fC4V7pp1vrShG9O8xJrFVO5upikSCOgfI9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 10:15:20 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::cd3d:b715:5212:2291]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::cd3d:b715:5212:2291%5]) with mapi id 15.20.5746.023; Thu, 27 Oct 2022
 10:15:20 +0000
Date:   Thu, 27 Oct 2022 12:15:14 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "Czapnik, Lukasz" <lukasz.czapnik@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next] ice: Add additional CSR registers
Message-ID: <Y1paMsCSAz1lCZBQ@boxer>
References: <20221026112839.3623579-1-jacob.e.keller@intel.com>
 <Y1lKM8RyqnPUbEv4@boxer>
 <CO1PR11MB50893AEBD9F728B41BE57FD8D6339@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CO1PR11MB50893AEBD9F728B41BE57FD8D6339@CO1PR11MB5089.namprd11.prod.outlook.com>
X-ClientProxiedBy: DB6PR0801CA0061.eurprd08.prod.outlook.com
 (2603:10a6:4:2b::29) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: c40b0632-1d49-4409-e2c9-08dab8042741
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUdVs/EtQCAd4VqP6BdwXpD0iMde8WwhSuXM2wEc4fNd4epVEa7rQrUNOG5Xsn8jACLqDgNvRRckynUZHqL08D01buJ/9yCcwiF/xlWppAkHMIp2H4we+cCxgl3dLwV+aCLfzcnAFNj5k+Smk/rkHV5yKFHMGGbcLi4FcBERMnA86Rjys7dFexckulxaxDzythLuHs92v+7KdkZWpL+BVDDrM3NDtHQ8tvSm6NAc5Kvt86mht5Wok+6HuyffM0l8Womg9WBPgaOMRZeXRdnQaDcfdxC2eCaekcD0uaYjBnjLuhQU25+84kfC3/iJ9zOGBNd+pQ6uHePRIeWOSP0XHXrplT1HMVJWUGT7iEUhY4OsJEUzEHlvK45vs9/YjsM6uzl+ZOwW40fkrzbix38SQvC93R6EnaW5NiG0fTUD/WzsWtmjlrxczwmC1YkN85RPPAXULvpnOu+ltUsCSLGaQRhzDF5pbO7ZTVoLOknyOg8s6QVA5Y+ndTlhWxNp/bM4P5q73jy+dIyRBpUJUyUiSWYMCCc77UhHvE2m7s+SLHyWvLYOOBhVPGzkY19p9Ov2kgKhkJ3X0s1ejf3sl8wvXUbOrDFxRSXKlHAmja1Jau/2NpXCsybV/x25SQOBSXBIImA2ker+GTzjDF0y3/iR31SuWHr/8g0A+FzO43Q/xEGzsjxUmmOETWACgcZ6lBFgGAY8NUmvqF77qQIHhlYH0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(54906003)(86362001)(83380400001)(2906002)(26005)(38100700002)(82960400001)(186003)(5660300002)(6862004)(44832011)(8936002)(8676002)(66946007)(6506007)(41300700001)(6666004)(66556008)(66476007)(33716001)(6512007)(9686003)(478600001)(53546011)(6636002)(107886003)(6486002)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SaBAHd9s0i6QZiWwABGa/wgqCdo3VvnfVMoT25Vo6WgvhMjnBgCg//VEfBy9?=
 =?us-ascii?Q?SLkfIE/diYEqbzoSSLmTKOsuvFhZHvUlHZRhpo2CijmcNRrvX7QFnMb29tC0?=
 =?us-ascii?Q?imtVIiNj6wezz7N0NNfkR5kdGl7mbU68iPMPrJc8aVMRyXeKNOLtkx2QzrNc?=
 =?us-ascii?Q?45/yjrgcbCG723lnIicGCi8501oE7Z8Amb0AxS3k2oK06lQSee/UAN4tSoTv?=
 =?us-ascii?Q?kBzwRhFkTNHha+ahXBqd917UX3Fs5F/AsJvp1Q+P7lmT4XCz+cyVzA2pRJ7d?=
 =?us-ascii?Q?bZnIS8pZ1SXvT9OiZkmWqHA6cqyuMo1t5YWMJJd9DPxSNYZvMw5y2AtWNrBP?=
 =?us-ascii?Q?+apHxjwaiaBOOtOxNCrSxanOCknTUznxWchaZpFAqICHe/pLKoHLi4TwGSem?=
 =?us-ascii?Q?g6m/O2MCqHIwFEZZ1sQ3rBmMxlHM6ihVT6CZsTL8RJfpvzIFmRAfRs5L8BOj?=
 =?us-ascii?Q?fTxSmNpBCKUagFCSJm9U7OUNeneyf8p0fnSnpQdy1vS77Wd3sG8b9mTOuTsE?=
 =?us-ascii?Q?MkcH2tkRc/Ot1t1xhOk2w4YS1U0FYptqJYjGN8n0dNTcvA9TpFYLZ1kvYFfk?=
 =?us-ascii?Q?ptBAQgcBg91lN2DswCCfFlj5Ze78kY79vBQhMhRsGCcMh0EJ3xzfqkY1Rjso?=
 =?us-ascii?Q?gsRWIwmW/Hyp9GzLJTSn+ffPgwH7loaR2Jl4DrbPaHw4xccEUjQLMAkfDSsA?=
 =?us-ascii?Q?sDJE7tV0HjGP0FUqf6fhRoadjxszzi6pk3OzEGspnUjS8fwgMdQPHlaW218n?=
 =?us-ascii?Q?WEVafe88FDdB3DINXzuSB8hipXm1tRVBvCjHQHP5iI6n1PAwQLxc0TftRR2+?=
 =?us-ascii?Q?ql9CJmrgL+YpMJcfJf92pXPaKcWyyzYShx8NiiJzYEKaNb5xGK3e8qNQJUpl?=
 =?us-ascii?Q?PWPbKym9ATkehQK3bN/pExc6vGjD/ATk1hssjMzdn+LHk3EjnXzcS7Kn3jHF?=
 =?us-ascii?Q?TmDVbEf9zDvvYXx+5UZVh4eU8HfkBiJuUFnszQqK7QhCoKGwDDq+jE4ftN0b?=
 =?us-ascii?Q?5Ji75kiOlwktTIhMgvhEnuLbwAeXvu82Lv09xgA6tOs2PVmtxiVz4EqKGj8X?=
 =?us-ascii?Q?iqPXIlcIIS2QxyMRWzjQR3XLoxNlhdg6Q7Wfjs6GKwlrY2FnbeCghN3bS2jG?=
 =?us-ascii?Q?U080kzuLzoshl1Vc8jpWfPTxEwOAYZLiuyyjfhibe6vVZ3sUT4DzaaZAJDic?=
 =?us-ascii?Q?Ru/sFmbgG/sOCdSNm1emWHiYoOeN4FACpuCr/4AefoPQRQ3zKWe7y6f27PjV?=
 =?us-ascii?Q?q7WPSH6qN//rEZf3CL93XhpRcgArXe7ceO3EsVplKfk8Jm7UcRzl/38TJstu?=
 =?us-ascii?Q?9O/jf9bK5VQ+Qs0mbUJy/FzD+VPzgvPRU8UnfCNqG1YZ4RC7IR9Yk5KBQlgd?=
 =?us-ascii?Q?hACIEc0l7YY6Asl2XGD2nToSfcPO2QKTrDNssX1dGgh31N7D+ewuaDXck+rw?=
 =?us-ascii?Q?4TylQH47h3qHjuufsmpqqqIHxqHSka7X5NBrmerqZWaS7BovKxMZBh9ZlraL?=
 =?us-ascii?Q?kKuMW1eD+nNZkfq6JV8ZjEbMprybUMa9YWlcLXNhL0588muWqxkRZPgqjbSa?=
 =?us-ascii?Q?goL0s69+dziiQTkTOM3yjoszFAE4liCpPqbji7cBlBZCZpnWfAV4ehJO7CV9?=
 =?us-ascii?Q?ZchSB+tc7aWGSgnO9yNS6ws=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c40b0632-1d49-4409-e2c9-08dab8042741
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 10:15:20.6387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5u4yZRpO2KsBvmNj5DWbOKsMXyfCwCi7cTAUo7hfKake54CZWio94yrk1iULcdPtgIaDaxKXlD9bCvrZzZvJIRjQxm2K87tXGQ8Q7SYkVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 11:20:22AM +0200, Keller, Jacob E wrote:
> > -----Original Message-----
> > From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> > Sent: Wednesday, October 26, 2022 7:55 AM
> > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>; David Miller <davem@davemloft.net>;
> > netdev@vger.kernel.org; Czapnik, Lukasz <lukasz.czapnik@intel.com>;
> > Palczewski, Mateusz <mateusz.palczewski@intel.com>; G, GurucharanX
> > <gurucharanx.g@intel.com>
> > Subject: Re: [PATCH net-next] ice: Add additional CSR registers
> > 
> > On Wed, Oct 26, 2022 at 04:28:39AM -0700, Jacob Keller wrote:
> > > From: Lukasz Czapnik <lukasz.czapnik@intel.com>
> > >
> > > Add additional CSR registers that will provide more information
> > > in the dump that occurs after Tx hang.
> > 
> > So...where is the corresponding commit that would actually utilize some of
> > these additional regs? :p
> > 
> 
> I'm not sure I follow your question. This commit adds the registers to
> the ice_regs_dump_list which is used by ice_get_regs_len and
> ice_get_regs, meaning that their contents will be output when you dump
> registers using ETHTOOL_GREGS. We don't need any other driver side work
> to "use" these as its just extending the table of what gets dumped.

Thanks for explanation, probably would be good to beef up commit message.
At first sight it I thought some following work would be needed somewhere
on ice_tx_timeout() since Tx hang is mentioned.

> 
> I guess we could extend the userspace program to include the set of
> registers along with useful names? @Czapnik, Lukasz do you have such a
> patch prepared?
> 
> Thanks,
> Jake
> 
> > >
> > > Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
> > > Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> > > Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at
> > Intel)
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_ethtool.c | 169 +++++++++++++++++++
> > >  1 file changed, 169 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > > index b7be84bbe72d..f71a7521c7bd 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > > @@ -151,6 +151,175 @@ static const u32 ice_regs_dump_list[] = {
> > >  	QINT_RQCTL(0),
> > >  	PFINT_OICR_ENA,
> > >  	QRX_ITR(0),
> > > +#define GLDCB_TLPM_PCI_DM			0x000A0180
> > > +	GLDCB_TLPM_PCI_DM,
> > > +#define GLDCB_TLPM_TC2PFC			0x000A0194
> > > +	GLDCB_TLPM_TC2PFC,
> > > +#define TCDCB_TLPM_WAIT_DM(_i)			(0x000A0080 + ((_i) * 4))
> > > +	TCDCB_TLPM_WAIT_DM(0),
> > > +	TCDCB_TLPM_WAIT_DM(1),
> > > +	TCDCB_TLPM_WAIT_DM(2),
> > > +	TCDCB_TLPM_WAIT_DM(3),
> > > +	TCDCB_TLPM_WAIT_DM(4),
> > > +	TCDCB_TLPM_WAIT_DM(5),
> > > +	TCDCB_TLPM_WAIT_DM(6),
> > > +	TCDCB_TLPM_WAIT_DM(7),
> > > +	TCDCB_TLPM_WAIT_DM(8),
> > > +	TCDCB_TLPM_WAIT_DM(9),
> > > +	TCDCB_TLPM_WAIT_DM(10),
> > > +	TCDCB_TLPM_WAIT_DM(11),
> > > +	TCDCB_TLPM_WAIT_DM(12),
> > > +	TCDCB_TLPM_WAIT_DM(13),
> > > +	TCDCB_TLPM_WAIT_DM(14),
> > > +	TCDCB_TLPM_WAIT_DM(15),
> > > +	TCDCB_TLPM_WAIT_DM(16),
> > > +	TCDCB_TLPM_WAIT_DM(17),
> > > +	TCDCB_TLPM_WAIT_DM(18),
> > > +	TCDCB_TLPM_WAIT_DM(19),
> > > +	TCDCB_TLPM_WAIT_DM(20),
> > > +	TCDCB_TLPM_WAIT_DM(21),
> > > +	TCDCB_TLPM_WAIT_DM(22),
> > > +	TCDCB_TLPM_WAIT_DM(23),
> > > +	TCDCB_TLPM_WAIT_DM(24),
> > > +	TCDCB_TLPM_WAIT_DM(25),
> > > +	TCDCB_TLPM_WAIT_DM(26),
> > > +	TCDCB_TLPM_WAIT_DM(27),
> > > +	TCDCB_TLPM_WAIT_DM(28),
> > > +	TCDCB_TLPM_WAIT_DM(29),
> > > +	TCDCB_TLPM_WAIT_DM(30),
> > > +	TCDCB_TLPM_WAIT_DM(31),
> > > +#define GLPCI_WATMK_CLNT_PIPEMON		0x000BFD90
> > > +	GLPCI_WATMK_CLNT_PIPEMON,
> > > +#define GLPCI_CUR_CLNT_COMMON			0x000BFD84
> > > +	GLPCI_CUR_CLNT_COMMON,
> > > +#define GLPCI_CUR_CLNT_PIPEMON			0x000BFD88
> > > +	GLPCI_CUR_CLNT_PIPEMON,
> > > +#define GLPCI_PCIERR				0x0009DEB0
> > > +	GLPCI_PCIERR,
> > > +#define GLPSM_DEBUG_CTL_STATUS			0x000B0600
> > > +	GLPSM_DEBUG_CTL_STATUS,
> > > +#define GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0680
> > > +	GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT,
> > > +#define GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0684
> > > +	GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT,
> > > +#define GLPSM0_DEBUG_DT_OUT_OF_WINDOW		0x000B0688
> > > +	GLPSM0_DEBUG_DT_OUT_OF_WINDOW,
> > > +#define GLPSM0_DEBUG_INTF_HW_ERROR_DETECT	0x000B069C
> > > +	GLPSM0_DEBUG_INTF_HW_ERROR_DETECT,
> > > +#define GLPSM0_DEBUG_MISC_HW_ERROR_DETECT	0x000B06A0
> > > +	GLPSM0_DEBUG_MISC_HW_ERROR_DETECT,
> > > +#define GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0E80
> > > +	GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT,
> > > +#define GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0E84
> > > +	GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT,
> > > +#define GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT	0x000B0E88
> > > +	GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT,
> > > +#define GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT  0x000B0E8C
> > > +	GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT,
> > > +#define GLPSM1_DEBUG_MISC_HW_ERROR_DETECT       0x000B0E90
> > > +	GLPSM1_DEBUG_MISC_HW_ERROR_DETECT,
> > > +#define GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT       0x000B1680
> > > +	GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT,
> > > +#define GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT      0x000B1684
> > > +	GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT,
> > > +#define GLPSM2_DEBUG_MISC_HW_ERROR_DETECT       0x000B1688
> > > +	GLPSM2_DEBUG_MISC_HW_ERROR_DETECT,
> > > +#define GLTDPU_TCLAN_COMP_BOB(_i)               (0x00049ADC + ((_i) * 4))
> > > +	GLTDPU_TCLAN_COMP_BOB(1),
> > > +	GLTDPU_TCLAN_COMP_BOB(2),
> > > +	GLTDPU_TCLAN_COMP_BOB(3),
> > > +	GLTDPU_TCLAN_COMP_BOB(4),
> > > +	GLTDPU_TCLAN_COMP_BOB(5),
> > > +	GLTDPU_TCLAN_COMP_BOB(6),
> > > +	GLTDPU_TCLAN_COMP_BOB(7),
> > > +	GLTDPU_TCLAN_COMP_BOB(8),
> > > +#define GLTDPU_TCB_CMD_BOB(_i)                  (0x0004975C + ((_i) * 4))
> > > +	GLTDPU_TCB_CMD_BOB(1),
> > > +	GLTDPU_TCB_CMD_BOB(2),
> > > +	GLTDPU_TCB_CMD_BOB(3),
> > > +	GLTDPU_TCB_CMD_BOB(4),
> > > +	GLTDPU_TCB_CMD_BOB(5),
> > > +	GLTDPU_TCB_CMD_BOB(6),
> > > +	GLTDPU_TCB_CMD_BOB(7),
> > > +	GLTDPU_TCB_CMD_BOB(8),
> > > +#define GLTDPU_PSM_UPDATE_BOB(_i)               (0x00049B5C + ((_i) * 4))
> > > +	GLTDPU_PSM_UPDATE_BOB(1),
> > > +	GLTDPU_PSM_UPDATE_BOB(2),
> > > +	GLTDPU_PSM_UPDATE_BOB(3),
> > > +	GLTDPU_PSM_UPDATE_BOB(4),
> > > +	GLTDPU_PSM_UPDATE_BOB(5),
> > > +	GLTDPU_PSM_UPDATE_BOB(6),
> > > +	GLTDPU_PSM_UPDATE_BOB(7),
> > > +	GLTDPU_PSM_UPDATE_BOB(8),
> > > +#define GLTCB_CMD_IN_BOB(_i)                    (0x000AE288 + ((_i) * 4))
> > > +	GLTCB_CMD_IN_BOB(1),
> > > +	GLTCB_CMD_IN_BOB(2),
> > > +	GLTCB_CMD_IN_BOB(3),
> > > +	GLTCB_CMD_IN_BOB(4),
> > > +	GLTCB_CMD_IN_BOB(5),
> > > +	GLTCB_CMD_IN_BOB(6),
> > > +	GLTCB_CMD_IN_BOB(7),
> > > +	GLTCB_CMD_IN_BOB(8),
> > > +#define GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(_i)   (0x000FC148 + ((_i) *
> > 4))
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(1),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(2),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(3),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(4),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(5),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(6),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(7),
> > > +	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(8),
> > > +#define GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(_i) (0x000FC248 + ((_i) *
> > 4))
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(1),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(2),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(3),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(4),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(5),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(6),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(7),
> > > +	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(8),
> > > +#define GLLAN_TCLAN_CACHE_CTL_BOB_CTL(_i)       (0x000FC1C8 + ((_i) * 4))
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(1),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(2),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(3),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(4),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(5),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(6),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(7),
> > > +	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(8),
> > > +#define GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(_i)  (0x000FC188 + ((_i) *
> > 4))
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(1),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(2),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(3),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(4),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(5),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(6),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(7),
> > > +	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(8),
> > > +#define GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(_i) (0x000FC288 + ((_i)
> > * 4))
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(1),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(2),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(3),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(4),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(5),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(6),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(7),
> > > +	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(8),
> > > +#define PRTDCB_TCUPM_REG_CM(_i)			(0x000BC360 +
> > ((_i) * 4))
> > > +	PRTDCB_TCUPM_REG_CM(0),
> > > +	PRTDCB_TCUPM_REG_CM(1),
> > > +	PRTDCB_TCUPM_REG_CM(2),
> > > +	PRTDCB_TCUPM_REG_CM(3),
> > > +#define PRTDCB_TCUPM_REG_DM(_i)			(0x000BC3A0 +
> > ((_i) * 4))
> > > +	PRTDCB_TCUPM_REG_DM(0),
> > > +	PRTDCB_TCUPM_REG_DM(1),
> > > +	PRTDCB_TCUPM_REG_DM(2),
> > > +	PRTDCB_TCUPM_REG_DM(3),
> > > +#define PRTDCB_TLPM_REG_DM(_i)			(0x000A0000 + ((_i) * 4))
> > > +	PRTDCB_TLPM_REG_DM(0),
> > > +	PRTDCB_TLPM_REG_DM(1),
> > > +	PRTDCB_TLPM_REG_DM(2),
> > > +	PRTDCB_TLPM_REG_DM(3),
> > >  };
> > >
> > >  struct ice_priv_flag {
> > >
> > > base-commit: d0217284cea7d470e4140e98b806cb3cdf8257d6
> > > --
> > > 2.38.0.83.gd420dda05763
> > >
