Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E659E9C7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiHWRhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiHWRgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:36:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511357B280;
        Tue, 23 Aug 2022 08:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661267986; x=1692803986;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JLTBgpD0w4DOztbvu40nEPqLSHOMc+AFfZEiH4LhLSw=;
  b=f8MXqVUCuNJGbF+vGlaoYQIkIoV9msYHjJVx5UyVMKYhNLvcZ3ho/btg
   rtoF8xFy+N7QUOIwsoohqy0h7W+rS29gKakWZvnk5kkBxjDtFZg6vMch1
   tnhCuixnK9JiVD1L1RUJneVtbn3Iqtln8kBramZ650ek+UGQ3vy9coVCc
   JhH3cucWpQmcAntsO/4TVCur1qysbV+bL4PnllZDz9UigOJEhBxIUM3Ns
   35JDfEuvEEYNMuKV07X3m2W41a7xKRQyvzcq8q588Wk/HODX/0QdmfG0D
   pySsve4aDMpsxYYcRsLbZnn8slyT/23u3u5s2TA6T9bJOog68eTfdtgv5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="293715984"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="293715984"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:19:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="586031079"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2022 08:19:45 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 08:19:45 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 08:19:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 08:19:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 08:19:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b15O7kPI8wZrg8z4pELijknddONFFpEp5A94Ss32Q3RdTc4VdrMun8/+w/psgcgCBTasdETNhRlBA+c/Hl7HlZVg4mq5bE15XroGdigDv8mlhaCoW8zxk+1m8HRPZHcjso6KD3Uk2ugTP5D0ct6biCTocd//ywtiW1rRPx5nfv8Y0TaIrAqZs2fN2tOw0mmV5DOSkOE/X+RIP86kKmOvI4Y5sUr6YqskWsAZmg0PQLzwGjG8l57sEbyDEcSB0Q7wfvwSU0SwAcCpjIHOLSdpr9Mxoe6hFnSRBktl5jEAAAD83bTu8csuxRRrPRxxpGrHQMqO8C2ogh80pnlV9thkXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7gLIm8ygTt9oky89G7cI8SV3vMlTS8ukUBe3YhG2og=;
 b=goAh2DPZ95yIv/XEkE+Fe3LgcKVjMt8FPkvx7dppeMxdz0e5niET4nahDSXJi21X5txSdml5bO781VXABgugQ037qJK0DnXDX20M9BjyuFFN5T1OqUsQO1v1yTEOwyhPnPWFkyqBrwRPTOtg1jFF9ooT1kxqAJnjYBwyrWtwi3DyXSp9pP4CVvHXCEv21AxTWNCQPZ09RG0NPluYHtp1tUSO4c118Ix0ABy1oxESEAkLxIsIXShi27ChMi6LFDq+cLtS8wGEMXBmbQlv5WoeR8N+FXYtlED/EQaxP7NW0cp5qGHIPUIndPQDThcDXwOPWb7gNT0KO1uA4MzdC63wCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM6PR11MB2714.namprd11.prod.outlook.com (2603:10b6:5:ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 15:19:42 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::28c9:82b2:cf83:97c8]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::28c9:82b2:cf83:97c8%8]) with mapi id 15.20.5546.024; Tue, 23 Aug 2022
 15:19:42 +0000
Message-ID: <0056a39d-d7dc-34ea-3a71-6d5d3835c2d5@intel.com>
Date:   Tue, 23 Aug 2022 08:19:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1] drivers/net/ethernet: check return value of e1e_rphy()
Content-Language: en-US
To:     lily <floridsleeves@gmail.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
References: <20220823060200.1452663-1-floridsleeves@gmail.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220823060200.1452663-1-floridsleeves@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::21) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bbf82a3-c1f3-47af-3360-08da851ae770
X-MS-TrafficTypeDiagnostic: DM6PR11MB2714:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUI+Kd/7HZcyIIY7Gtj0gD+Fhms0zb6tWeMEWoy6ajQxSabS7eeLGO0jMxb4WFFjYdYyLPjsey2MJPPCK6Nfqp/fOI3SuCKIMMsmtClNHZUZ7CqcxhKqpQyDpj2o+z2FMYR+xHIaYRZ3/6Sw8arZ/MBPOOyevHU04kb2RcL6d6+yl7yCW/Idp4O64rXVuuaxPQBGibPzc0wBbQ7cAhgBMSYoaaYezJ+1WUmChVKKXKb/ry3MwVnWTgWJkQBa30hejfWdjx/Ar5bSGO0HZh8+U7FmpjNrNKLfNLA4aZiImR6Zqg4cE8miSrRHdjdZyZ3nHgY5JUmDmum5TxIRenAxE/YjqKAvgU/FZop1YYTK17+Oeuv/0XhcsNKbY/jE9Dl21IZYyiDrJUd6pH7oksw3nJTSS4PbC1NTQeNyeXJJepvMLGe+CHFZNJL3FYzRvHgzNk/4+yWjRyAMDoT/gwcKJTkZgbJ1i/SVMk6XRRMaJfa9r/7eF8SqUHUVKBZhJHL4RuAVjgBOXebIq9OLOBd7Ip/8S4ufggM5kplI2tRoj+khsTkUVOe1wzamIZXW4GEkoUDiBWOTYOe/PQswCw0L+y/0+aXZ/pewC8N9RuxB9Rj+ue7/5fs31P6VUV+BKTz9OIz9lZ9SUirgkRQiONGwlQF6HTqA4mBMdcuUGgFh3miLtG5ONUhxddU8HAvgmsh8woubMtRI7sp3fozLsF4KyuWMhTWf7D9VJ8V4d+3ATFggDdWNjtdzJBxC60yfA3Krflbfi3ZJ5tEy+U19l6BMVNPEOLM7MBkBip5C4bdCfd1AJkOjSh1pxEmuGqXdu2cgljRX7beqcbvBGSecDt5gqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(346002)(396003)(39860400002)(66476007)(4326008)(8676002)(66556008)(66946007)(36756003)(38100700002)(82960400001)(31686004)(86362001)(31696002)(478600001)(8936002)(6512007)(83380400001)(26005)(186003)(6486002)(6666004)(966005)(41300700001)(6506007)(316002)(53546011)(2906002)(44832011)(2616005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTlnWEtMMmxtam16YzR1b1E4Z0x3UXNTcFlBaHNabE5ZdXBiWW1NOEtZbW95?=
 =?utf-8?B?K2VFUXVTUU1QcGprdGwxZUpPZ0V4WTJ0VDdXWTVaTEk1eGY0eDA2azR1aFg4?=
 =?utf-8?B?MzEyZWo4TGlDd3BNbzcxcitmWWQrM1d3d0w1VUFTYzkyUzhqTDFVd3hsenBv?=
 =?utf-8?B?YmxWcVZZRndiVWNvK051MVorNXllN2I2NDlkSnFEUVg2ak13dHpOSHJxUzN6?=
 =?utf-8?B?Ym44MHc5WjN3Ymc5aHc0U1MxWWRsUEVmaDdLcjNrWFhHeWRzZG1kekdOWkVk?=
 =?utf-8?B?NWdtWVc3Z3JQTTRlYzBPVWZHZzU0cjhGeXFaUm5hSWF6RTM4Q3ZQd1kzNVFu?=
 =?utf-8?B?TXJhb25HeU9pTVRsaDA4L3FLbkFjblR2b1k0VzhlaTY5TzBvTFdRc3RLL0Vo?=
 =?utf-8?B?MGRrRm5Ma1BRcExwOW5YVkdKMHZ3OUVKNlR4TlFoaXZ3MlB6VUJpSnBpRTZu?=
 =?utf-8?B?NUppK0NXalpKUDQxT3BiOFlnYi91eXhCYVhVVk4xcU9SLzN6RlBnSFZhMElF?=
 =?utf-8?B?NUZMaEprUEYzeVp0RmxGOTU2U21WekhDemhveGFVYzhieWc0aWZSTmcwQkUx?=
 =?utf-8?B?TmhxUHV1d2tmT2Myd01RY1JDc1pHMzZuQWROazU5ZENqcDk1cHh2aHc2Wi83?=
 =?utf-8?B?UFFQTjhqMlV0alF2TU53akpVQ0lVNUFSUkMxUk1aK3h2ZTNEb3RLKzVuSTVj?=
 =?utf-8?B?Mng2MGRVa1V2WGJpSzRKTlA3ZXJ6SGF3c3dyMUVVMHg5WHlvdmRtVzNHa1J6?=
 =?utf-8?B?ZTA0d3NCWUtnT1ZQbzJlWGNiYTRxV3cveG5RTmp1c1pXd1UwdU9Md3M4Kysx?=
 =?utf-8?B?dHhMbVFpd2wzUk44QmZ5bTUzZU5vSXl0cWJvaUZ4S2hRR2NrZWwzK0pmcGZa?=
 =?utf-8?B?THVWanJ6NW96ejFlL3J5TmJpZGo1djJoNWVFM0g5WWE4ODhqS25JbkxXRzdj?=
 =?utf-8?B?WHd4ZXFXa2ViamliYW5wS3B2dUIrVzRJMi8wYm5tQk5Gd25LNWZseSs1ZFhh?=
 =?utf-8?B?WWtnL1F1ckdjWWJYZm44Wk5ldGdvVHRqYTlGUlpVR0FTZ0lzcW5tSzRWcmU0?=
 =?utf-8?B?TjZpdDZxMUpQZFNiSXVWdnJEdXFzb29iQXUwM2hpYStNWVlPLzlzaGtaTUhQ?=
 =?utf-8?B?SDFoaHFOZXBJdzZvTkROR2V3VWM3VDV5Z1J4czJ1ZnBEREFsc0hEQjVMMXNW?=
 =?utf-8?B?Y2VnNXY0NmVQcWhBVjY0UTVCNUl0ZzlLa1ZTYW10MTF1TUVybmJxbDJlMGx5?=
 =?utf-8?B?RHQ3S3JHZENqR1doblBZakt2dVpUTmxTZ0tWdytNNXRDQ1dsOWZVTDVkNFV6?=
 =?utf-8?B?QWlaZnFka2NFeWRkNjFJSWZUODJTV2J3WnNpbDd6SGV6U2g4TFhUY3VsWDN2?=
 =?utf-8?B?V0wyb1hzMW1VVndvM2NvaG1rT05ZcDMxM1JyQS9pbXhjbG9XeHhLTllQQmdq?=
 =?utf-8?B?c2VCTGh0eHVCbHF1YzNxdFZCeFUzY0orT1ZtSjhpREVMNk1jcWhtOGhRS3Fx?=
 =?utf-8?B?Sm9VdDB1K1grenFsdUJqZjBuaThvQlJtRFJLQlBNb0ltYnpOcmpHcFlreFBN?=
 =?utf-8?B?UXRIQUE3bFR6QW1WdDZieFdRWko4QWtsVWdZd2YvRDQzOW1pTXptM0pjTVVa?=
 =?utf-8?B?MmNWVWd1R2RLSjB5TTExM0VZMkloNG9oaG5jb3lZWDNhcEdWV2x1dnp4cWRI?=
 =?utf-8?B?TEtVWVEyWnRCT1hoOHhXUThmcm8rUUZDR0dna1VRbHBwOUMvMnFsR0I4dTRp?=
 =?utf-8?B?TVZ1THVGeVFjQTY4Wm1SOUE3NUx4RVJSUWVBalZ3U2ZaSXVSV2FaNk1MLzlt?=
 =?utf-8?B?d3VLSWhKZThwZEpYUFBZYWdGcEQxd1lJZUpISFBzOWJSRWRndFlyZklaKzhD?=
 =?utf-8?B?bkRwOXdzeG12djhxT3JQRWdpcXc3SVNycHA4RU81VXUzRlFYdC9nSGdGaVha?=
 =?utf-8?B?M0hGb1FYbnhDdnVIdlZnazV3dUY3NGlBQS91U2RkYVZiM1d3T0d5N3ZXeUFn?=
 =?utf-8?B?aG5aYzdabmNOTkpMaTk1SjczZDdVSEptZGdsaWF1cytjQzFkVExCSXh6aGN0?=
 =?utf-8?B?OWYrcElVMFd5OVRNYnMzYWNHSkZWMHZyUkpxRmJ0YkVpVFhjd0RNeFVoSXhR?=
 =?utf-8?B?czhFNXRjZ0JPQTYxQ01uYVh2bDBiSm16R0x0c3pXb2pRMmV5QkNWRzB1ckFS?=
 =?utf-8?B?b3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbf82a3-c1f3-47af-3360-08da851ae770
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 15:19:42.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b65ZAVat7G4NVISd32MOOHpNKyKc6Fpf44+AixULED7XgvwEw0Sg/eeTgD8dexbYw7xdnWQOQ1+GOXLXuwcr/M9pMnPvAeCQw0ONCSrFBv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2714
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2022 11:02 PM, lily wrote:
> e1e_rphy() could return error value, which need to be checked.

Thanks for having a look at the e1000e driver. Was there some bug you 
found or is this just a fix based on a tool or observation?

If a tool was used, what tool?

For networking patches please follow the guidance at 
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html


> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> ---
>   drivers/net/ethernet/intel/e1000e/phy.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> index fd07c3679bb1..15ac302fdee0 100644
> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -2697,9 +2697,12 @@ static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
>   void e1000_power_up_phy_copper(struct e1000_hw *hw)
>   {
>   	u16 mii_reg = 0;
> +	int ret;
>   
>   	/* The PHY will retain its settings across a power down/up cycle */
> -	e1e_rphy(hw, MII_BMCR, &mii_reg);
> +	ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
> +	if (ret)
> +		return ret;

Can't return value to a void declared function, did you even compile 
test this?

Maybe it should be like:
     if (ret) {
	// this is psuedo code
         dev_warn(..., "PHY read failed during power up\n");
         return;
     }

>   	mii_reg &= ~BMCR_PDOWN;
>   	e1e_wphy(hw, MII_BMCR, mii_reg);
>   }
> @@ -2715,9 +2718,12 @@ void e1000_power_up_phy_copper(struct e1000_hw *hw)
>   void e1000_power_down_phy_copper(struct e1000_hw *hw)
>   {
>   	u16 mii_reg = 0;
> +	int ret;
>   
>   	/* The PHY will retain its settings across a power down/up cycle */
> -	e1e_rphy(hw, MII_BMCR, &mii_reg);
> +	ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
> +	if (ret)
> +		return ret;

same here.

>   	mii_reg |= BMCR_PDOWN;
>   	e1e_wphy(hw, MII_BMCR, mii_reg);
>   	usleep_range(1000, 2000);
> @@ -3037,7 +3043,9 @@ s32 e1000_link_stall_workaround_hv(struct e1000_hw *hw)
>   		return 0;
>   
>   	/* Do not apply workaround if in PHY loopback bit 14 set */
> -	e1e_rphy(hw, MII_BMCR, &data);
> +	ret_val = e1e_rphy(hw, MII_BMCR, &data);
> +	if (ret_val)
> +		return ret_val;
>   	if (data & BMCR_LOOPBACK)
>   		return 0;
>   

Did any of the callers of the above function care about the return code 
being an error value? This has been like this for a long time...

