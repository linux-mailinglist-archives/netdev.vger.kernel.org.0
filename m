Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284706E00B0
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDLVS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjDLVSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:18:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A908698;
        Wed, 12 Apr 2023 14:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334270; x=1712870270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fsm2B0CG85is4PXze/MdeX4AjNMpWDTEjXd+MTG0JWY=;
  b=kQFUVC4Z950hqMHYvBZGE+0mIEMU22kdcWIg40EVQ3PJdoQhKz273mEm
   +085V8GWOok9Be3F8Yeun52xw23v11LLfRB+ehigDqZ2lR9ANXDmEJxhU
   stkCdiHKp0oHvpCAQibUDOnx/Q7cJvdMUnFhtuSEXfCZ3Jocr8kf75EA6
   meVce2+cCBL8w/jMsOg25EHEupO2SQmRniG4D1xDAK42DXMet4xVP+PXQ
   Ch6jjiK/YyYZO5Qw45b1JfTymcvgOQGUYj4hPvTvv2xV/bA8N+xdqsxzD
   JWIFHwu1C3gh9FkvVl2zp0Yn9Kc1L82Wxi8Bt19r/60V+6WDPg5Ie6GD+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406857982"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="406857982"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:17:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="721732660"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="721732660"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2023 14:17:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:17:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:17:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:17:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cwj7eYAcL9me/sRYJ7ey0e02n9gkrOvhH2frN9mpGSldfGUaZfL21alMYOAjXk9OxoeWd9h/9y3Pxr6jZGEZhQ1YdBCrx6BJnNXQRsNEyZKntjfToFHkM4bT0yzRT62N735sb+H6pKsNf0T5zJdC3F/kGiOgEEyRuG4E+1sUsCv2ngv+MYlu+CGwUkKNUgcNQQDupUPbdBCoBBN0jhI6/r/2SgGzLNCSsm+nl3RbbTQDU4uDFq3EzQf2Jam0l78mOAlEZETWr79aIQFE+kBCjajlaGlH2zGhI1Z/UuKgrhEB//GBHFhSR0Fmyyw24K9B7YEmM5Gia5j0cJzs7qG9ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCF3qropeSxtM3q2XJ6JVsqD4ACy0Yd6U9nZPhl1IHI=;
 b=VJ7VoE5stj2URMJDda1PaGsiYOiH2udK5xnNvWWnqgjH1x0koaZrYyfYIMq4X7Q4HOQ1zy1kWggzRGAH3w8SptIwybPb2qVszNahm6y5nsZk2p6+J46vDHI3kT4OsEaAtnvYBwHjWh40IqAizkqfgfLUorSwJjSzHDmOUlLFI6Tpplpq9S3QkwTGd/7hhtNbEbnc7E1mpQSRbSy9kW9tEai62iwk9m0YBp8ypyb0qugaNARWF05+WC5qVDoNEYtv0I7BXoiBIyX8gOgkq+ngi3DtNuvP826NmrsfSJu6Z31BTlVo81bTLbsTtIU0ExmI9Hega44qlfIlLsFqXE3oJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:17:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:17:41 +0000
Message-ID: <9b03f43e-3816-8aba-f6a6-3bd2d410726e@intel.com>
Date:   Wed, 12 Apr 2023 14:17:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 3/8] net: mscc: ocelot: debugging print for
 statistics regions
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        <linux-kernel@vger.kernel.org>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
 <20230412124737.2243527-4-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0070.namprd17.prod.outlook.com
 (2603:10b6:a03:167::47) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4a198e-8458-409d-b0e6-08db3b9b59a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhJjHxQczMZbbKUO5HaYFOdm1XU9Y0qfsiYWbv0Z5Ke7S727hncMps5l9Dd3PXjXaYqqJ1OIvxy0+dM3DuncJcALE4DY0QAcRmIfEw9iX9WUEMo/BoM4j3zFROX1DQhrcSbP8FDveg38slkTO99VHQbhTFDsjXkYJpEynJa5QTYsEECoLfIKukT5grwt+Xxsh6oZbhNMUlMriX1A7PssLGEGasnzDlCdMdeA0KfDUAI88oKpZKdTOMon0L/In3FLFdZ+WtPEFGNxde+GD6l0YB7bjSYN5N8Jp97SiOWKnnn1QA0hdMxzPdom0gOfQGAA6Ui4uBGI2XH0Fs3tOwouL8Xqffk+ov1TAdptiII3jwM33IvLw+YTByidzqLgLVKElecE/lJKME8e4/hzbLp8NA1BJk30iDw0ibxbbZGmkPcIgbEDhEFqpH/oUkQuUGp4/URtOmtVHR6BTR6aDmIYHE/bNUgUBw1z7l9fGI0doyMio0Q+Y66j0pTJerbzjYRuZsnPwxAGdQ3ES+acB8Eo/OAGurt56a8ZcV2nFcfVHONOK3mowZ4k0vNaXvS8nO6C4I5HI9nWWxOjjjtSm+btY/e1LfU9/LjEmM0cO0S3FlXsLtmE87YaA+yueLq0ltwEmTOq9moJ2Qd1j6uecmx/+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199021)(478600001)(53546011)(6506007)(66476007)(26005)(186003)(316002)(6512007)(7416002)(2906002)(4326008)(66946007)(54906003)(66556008)(41300700001)(6486002)(5660300002)(8936002)(8676002)(82960400001)(38100700002)(31696002)(83380400001)(86362001)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azBjTURKRUhTVXNCMEk4ZEVOWmsxb2Frd0ZkU1NkS3FyZnJlN3hWcE5pR2t1?=
 =?utf-8?B?MVBaakx1VVMrVDlScU9JZ08vbFg2MDkwcndwOFowZVZvNGowWWZvbzRHQXpx?=
 =?utf-8?B?TW93YitPeUw0TkVTTWRDbWVtbDRnWFZYUzdpb0tiZE5YcGJCKzF1enFzS1RM?=
 =?utf-8?B?Y3dZeHhETzhHRk9wRDdCM3lRaGN0d0JiaTlnRmdXc1B1ZWV3YlliaUE1K2Fv?=
 =?utf-8?B?WTJRaGV5MVgvaFVVNHJNSTI3OWlZQ1gvekxrd0Mwd1YzT2ROWWxJNUNwT2d0?=
 =?utf-8?B?eGNiSHljRVlRVjZ4Nlo0c3l2WFlIZ3c4T1dReUIxZnZPQmJTYkRYVm5mZzFE?=
 =?utf-8?B?STVHM3ZmN3doZU5mV0JVbk1KdVBXa3dRSW9WNlZEb3QzYkJCcy9WOGJGT0hn?=
 =?utf-8?B?ZHBwVnplcWtDNDhOdjlWSTJkaER4L0lYSlpRQjFSbDNVRWs4SlZFUmNIR0I5?=
 =?utf-8?B?aGRXWXB2eEZqK2czUUJvMHpVTncweXNCWUVQMkZVZzVERmRvZHovZEtrVERI?=
 =?utf-8?B?N1M4RzJVSms1bDFwUWo1cHJEUTN0Nm9rRnZ4VXg0R0tzWGd2dlF4ajZzcjlQ?=
 =?utf-8?B?NWl6b2RoZVRJUTIvN2I1elZTYmhpOEhaSktzbkJXRDVGRHdkRlZSS29YNk1J?=
 =?utf-8?B?ckNTcWUvSHFHMUdQOHlnbGYwRWJXZk5ROW9tWTNnZm52eTVUWVBPY0dFc0RT?=
 =?utf-8?B?cll1UjMyck9HSzY3R0h3OFZsa050Mlh2N0tQcG5ad0cwUmxJcVprQkRTZFZY?=
 =?utf-8?B?dWp6SUl3YW9MclhpMUhPUTQ4NGphai9JWjl5Z3o2WGxlWE1YZVE0Y2VUQjhl?=
 =?utf-8?B?WklweGVvVDVTRldDTUJYT2Nhc2pyT05VNFFBOHJJWGZnMkNXZDl2am5JNlFR?=
 =?utf-8?B?dWJKcmdONHZzSkYyVWZ2VDhBSDdRbVNHRGNUa3BmaU9hY3FlNWdQdHFBMVJq?=
 =?utf-8?B?Umk4M1Vxa2Z4UTZJMmsrSkJOdUw0d0hyRGw4OVV3TENTcEwrMkI4WlB1Nk5L?=
 =?utf-8?B?aFp0WHZ1eUR0eDJkYUFaVm9XQ1ZxdHVKc1p0SzlhM3BPL21xdnREREgzVkVv?=
 =?utf-8?B?Y2kyQnhaMURDZDVtaVhubXd6NmNnQ3RTazZtbmgvSTNOMFFvMW9xSmcvNHJ5?=
 =?utf-8?B?eUZZYjNtLzdyRnRaTTQ4ZkM0NWdvZEdxbE1kMEMzdkovYlJGSmUweGFjcURo?=
 =?utf-8?B?amxiMGU4U013aTB5QlJrZVh2QmpYTXRwNUtNR2dBWjZUZnJIZCtpZHpHQnhY?=
 =?utf-8?B?Wit6K2VnR2o5VnZBUG1EcU1kYzgrMVF6Zkprb3krK0lTb053U3NRNmd5OHZD?=
 =?utf-8?B?b05OcndWSHBnZUFFWVdQK2FRdDEybWNEcWM3S3I2ZUd2WWJJcDl1YW91c1lV?=
 =?utf-8?B?azhpbEFJZ0VIRHk1TFQvWEZ0bmYyL1NrUHFpVEhCUXlwbmRBUzRUbDV2Mmsw?=
 =?utf-8?B?T0tOOTBUVFViVGZHUVlDUTRUR2RLZ1dPV21tamh4bFdFcVc3TTlSSUlabThO?=
 =?utf-8?B?RDlqMUJ1YnhzN3dqOGNmYkVzK1Bqd2pFWldkU2RCRUtBQncxbHQwcnRVSm9W?=
 =?utf-8?B?NmYxaTJwYWVPeHJLZlJSaytQRVQvQ0g2V2hpdGdjQWkyNmlNWXFPWGpRNmZQ?=
 =?utf-8?B?WTkrdDhuS2Y2aFJ5OHJqdUdKZmo4UG84UWF0TVVkRjc3QUV0Sjh5U0svYnBF?=
 =?utf-8?B?Q1VjR2N4ZkplYWxLYndBaEFtMVJidkdFSnMxUFIvTlBWbkc3RkJZT3JpSmJN?=
 =?utf-8?B?aUFUSzBZd3doR3NxNkI0WGNpbmNTK2JQQjJTRG50aWs3aFFjMXlGOWVYakhE?=
 =?utf-8?B?dVdVUzcvMjE0V0c3TmFma25YcU5LTUVORWJaOEpvTDhkd2hQYWxuVEQ4MHRV?=
 =?utf-8?B?Tk8xVEUwaS9adCsvZFVSMTROdkJTckNCYnJabnM0WXlLVHVzQ1llbFYxYmhB?=
 =?utf-8?B?SFBLbzlDTnM1Z29oL3JtdXZMNW94Ym9NRUQ3THFtTVl3eVBTNlIxc2oxUEZv?=
 =?utf-8?B?NVljTUZBSjJPY2lOeFVWMEd2TTVibFozbXdPZ2RiWEFyM0VyaWhkaW9yeDRh?=
 =?utf-8?B?QUlBclN3MUh2eFhocktWNElQQWZFRXNBeUtGOTJkQytSSW9pUHpzekREZkdE?=
 =?utf-8?B?eDQweXZlWkI3WjkwNFIzWWwxRUIrbE1XSlhzYW1VMTFsL3NaOWhTZFNCR0tI?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4a198e-8458-409d-b0e6-08db3b9b59a7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:17:41.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41D7rSdqGriGBO2szYDH1/h9xxD1+80sU5g2zMAj2j3FftBYbMNsdBhnbpAKn0I/F43lw9GnHNq5LEa2x25gaxhkpFMnVbGLQlS0hNCMWmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> To make it easier to debug future issues with statistics counters not
> getting aggregated properly into regions, like what happened in commit
> 6acc72a43eac ("net: mscc: ocelot: fix stats region batching"), add some
> dev_dbg() prints which show the regions that were dynamically
> determined.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_stats.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index d0e6cd8dbe5c..b50d9d9f8023 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -925,6 +925,15 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
>  	}
>  
>  	list_for_each_entry(region, &ocelot->stats_regions, node) {
> +		enum ocelot_target target;
> +		u32 addr;
> +
> +		ocelot_reg_to_target_addr(ocelot, region->base, &target,
> +					  &addr);
> +
> +		dev_dbg(ocelot->dev,
> +			"region of %d contiguous counters starting with SYS:STAT:CNT[0x%03x]\n",
> +			region->count, addr / 4);


This will load the target and addr every time even when dev_dbg isn't
activated, but thats not a huge cost.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  		region->buf = devm_kcalloc(ocelot->dev, region->count,
>  					   sizeof(*region->buf), GFP_KERNEL);
>  		if (!region->buf)
