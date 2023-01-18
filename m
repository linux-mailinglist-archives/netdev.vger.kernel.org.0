Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7D1672A51
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjARVVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjARVVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:21:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E9E457CA
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076895; x=1705612895;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wMqiT7mH+4jhj9J1gyEBSc4+uBV2j/xiy3EWOaXfdsQ=;
  b=SnK32SpZuzKyEYEWI+ihRJUP+PYs+EHwiRD9eueHEHmS+rBlkLz+V6aE
   j6bFcBFaGLAYSSiUytRUn+IcYZQQbj0FqmnwqbHCmkVkm/YlRlT1yx22D
   YRsLsGOBnvPfU2jxSuEwFzjgdd4mDKbzGrXjRgEbZJROkCeWZCjU8pKO6
   CfTCBI6bN/xmO0Q4TtUizVnwAG8pAjHPnXzgxtaFQfpzJf3lT5psIn0m6
   X3H0PeewsYpiaX3A6Xi6OYjB+3dNagH5Evq1BUcNzaBk8j4UWRm//uEhv
   B1WXBK9WYFF03ma6gaIv54TPdwLYuPD4+t73NULfz0qsEOJiidCDrszmU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="326370130"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="326370130"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:21:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="728389076"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="728389076"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2023 13:21:33 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:21:33 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:21:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:21:33 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:21:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9n90tZbqirnYJcEo3peBhG2GHFt2kVusiplh/rnTG4hDEZWEyTxv+svUc6ctlO1gqdBjA86NteELfr3Wv4LeLtQAm11OkfoHBComez3gciN8vqF8QUyNkEM8icecyVuuukKsM9Ke8EmOfwdZYsEykchh+67pptNG6WSuVclsETS0s8zfc//iOIkEkuRDhEnE06yNLF12AEC/7nkmXadhG89/Hl9HlKkWhZAqTxJ+xdOWbxqTsujALyf6imeaXQDRQxKcx9B5M1xqhdL7lYFYOjN9VIFWn3N9Cm3skjPlrvAk1dA4cW7L5uAMapmL+PYRZbw6EFu0xTYgr9fa8ihAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXDXbJYByJW+Hcam4zfPfsUI+IV6+Dg5FG43s7E5rMM=;
 b=WuzA1SheotqziBdaMqS68jnu4vafAatZEOutAKDABtoDngCTzT7jGRixQWn5FfTRbLUbAizbOIG+kAs3OzNDIxAuKhQoUoNOEMU8lvsLHAt64EEEf+OnUYIy5ydZcuzEzvopy3b9b20UkD/fi/QzaRicUKEJt9mZh5ltCpc6p2YjzoDipmTZr8NJtYFvdtCrbiwIdMeRSAzgexGPAUW5WSIEbzLoleWDOyMPXaTWi8L52r4NlSBRnHsNe3fUoyagBqJ+0gXaOR4yWqHWL1LktoIVR2Jo0G4MIxFwyvJle1cQxnuZOJenglnA33/JqRLtr3M5MSNrtUnpzJhsFbMjAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:21:31 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:21:30 +0000
Message-ID: <98ab4dcf-6e7c-3fbe-bf2b-024bdd02075d@intel.com>
Date:   Wed, 18 Jan 2023 13:21:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 09/12] devlink: convert linecards dump to
 devlink_nl_instance_iter_dump()
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-10-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-10-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0122.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::7) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5366:EE_
X-MS-Office365-Filtering-Correlation-Id: f75b630d-6a7d-4b3e-139a-08daf999f7ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZY9wWLWMz1TWWh7xs5GhN6knK2phmqVhlpFzWcCHy69vH1k07ndzlrau1C2Y/GThczIW694OcGcY/cX40xtgOkGPnirl157PiDFcqaxu/dPOFCarrxcqtPAQ7+tySGnT5rXMfG4DN5PcQhcj9x9Y1EOdSdw7RHMA+HIBD39CoKQW1KzLXoJb6oRbUI9AvEYGBO65I3f5yMtVxaGxHbCIMKEI8mjXEGhF6rReyG1/qLvt7ppVfteoZL5jHQDnU0r+iA4f1VzI/0od1MIFThqW65C+5f0ab2IArK4oA/WpCJZWogRL3Ew5k2ZFY3qtQ7AUNZEIuBpOOC47tXOmJ6w2hK0AtB4F3KPhYKbO6t0HU1WXm2p7/Q87pOJ1GEkDUY8KaI+bL0a5V8wd/qfyAJwLIqF2Dl8LsWKxnp8WgWIBRQ8Nx4QzLynvQxaJI9EiL6cwU51ymlY5vY52o/OjXZklA2WZbXOXYSB3Z9fm+wSJureXxOxR+AiETtseB/sYpLKua+ETajvLcKwiQ8dJhTHPeDM8+JrHh76jAjb7LxPCEGN6IEfHMXS3zTDWstEJFIXmqaEisu7XiJeMaDYZVubbUuttQXFVZI4ZWMPe9hFDc7+uK3Y/k1hz2iExJl61RXtM5S7RCyLjTinAD/7CTw3WUcqo3zV7+UhchCBCQzPlpsiuo9bhc6x/9I9GRHYvorXVb7QdIFd4ASTyZG/UOQQsirhh+4ovq9KXY9BE1hEW1E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(31686004)(36756003)(7416002)(38100700002)(86362001)(8936002)(316002)(66476007)(66556008)(66946007)(8676002)(31696002)(5660300002)(2906002)(4744005)(4326008)(82960400001)(83380400001)(6486002)(478600001)(53546011)(41300700001)(6512007)(2616005)(26005)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vm1HcFpObEFwSHVIdEQyT1VTSXFUNE85SFcxMmd5T2s5R0ozaXp4bmJxMFpN?=
 =?utf-8?B?NWd6b1ZMWWpEVE9aMWphNnhLSjc1TTJjR2xSdmlic0Z4dkFkbEIzQzdBM083?=
 =?utf-8?B?OXJiby9oQVk4TmVnOXhDVmUveTlrcjBEVFd1aHVTZXNWMzRGVG14SGwyTmox?=
 =?utf-8?B?Z1ppd0hwTnVMSmVxK3NVQ0NBSEFscFc4SWlxZTV0N29IRFd1ajVwb2NIczNB?=
 =?utf-8?B?Z2JWR0xFTGRJcWZZYURiSXczeG9yek9NN01CVFlnQWNjQjVUTlBVRDlWV21h?=
 =?utf-8?B?eTdJNE9XWGpHcUlyUllwY2xENnBlWWp0Vzc5dm9BVzYrZ0ZKKy9vVkk3ZDJG?=
 =?utf-8?B?bSs4UWJMei9KRjNqOENXWW9FTWpIczVyUmg2WFlSUzBJcEFtbzVtTklqbWdp?=
 =?utf-8?B?V1lwTWFWdTBiOSt3YTdtTG1mR0U2WmJwWUlnOFFkcHVKTFhUbUdCc0JqY1Uz?=
 =?utf-8?B?cURjWHFyeXZ1MEJyQkpYeTgwa2Q4UjRJVjBDYUdwZG5uSlFxc0tlY3UrVFJR?=
 =?utf-8?B?ZUxWR3NFanVYWUc0VDcycXk1aWkzOEhIakN4bEZxSk5vSUJyRVBpOGZKdVVh?=
 =?utf-8?B?OEYxK0F1MXM2SG1KS2VTYmhHY3pUa2xvVGFKekIyTWZZRHhGNEpFdXg1dFdQ?=
 =?utf-8?B?cG5oWkR5alpUVUsxOUVBRUxESmM4bFY1bExxLytzUHZSVTVnaGs4N0NucktF?=
 =?utf-8?B?ZVlNQm90VEdXQWdDNTE5QS85VXVkYllVaU5qVW16Z3NHOTFlWlN3a003M2ZU?=
 =?utf-8?B?QnJPcjNJbENkS0V4QzhwU0FldENXYUZTdE5mWWtzUjdXblFpSHpXUWV2ZG5p?=
 =?utf-8?B?bE9qanJyU2w0VjZrdU94dTFmRCtkSGhGa0k5VVJUYVI5c3Z5R29KU1pFVENK?=
 =?utf-8?B?YlAvVW45MEZjSlVOajJGazRsak9nU01GV28vVk1YTG9lK1EzRnJvSXJBd0hM?=
 =?utf-8?B?dXUvR1ZxZzFoQzZTdFVMMzVWbEtPaTdxZjlhSlB1TWFudkNGMDVvellUYXdR?=
 =?utf-8?B?anhRZUEyOVIveWN4aC9JNjNSN0ltR3U3QlBlNGxrQk85dU1VL2c5ckRER0xp?=
 =?utf-8?B?U0MxVjNiMlRFZDdVUk9DdWdVM0Roa3ptS0JPaWU0WHRobWxmS3BvVXNGQ3F3?=
 =?utf-8?B?QnVLRThORTlNZjlxTjNSazQxeGwrM0VzYllUSzN3RytHeWlWdkhLbnhWNUFE?=
 =?utf-8?B?dEo1NWk2NHVzYmYxazBJcEQxSXBKVk01Tzc4L1RlTWtVZmU2VFlEWGt5OVVx?=
 =?utf-8?B?V08za3dRa1hPTFM1U25wc2tWc1Q4Zk5QZEdsMXNaaUJlYTkxS0dDWnM1K0tU?=
 =?utf-8?B?RkFvN29SUDlPWTZicDd3eVlvNWVVL0tVRDBCWDBwdXhSQWFZZmlmZ3RDWGZu?=
 =?utf-8?B?eVF0cS80eDlvdmhKN0JEa2l1UXd3U1psb3BHSjFMWStFNUtFVG9PMmhIREtJ?=
 =?utf-8?B?R3FGVXdjRzNWclVJR3JNQlVvTkRNMURiTVMyMi9UQ2VlMlFTb2YwRVRUazJk?=
 =?utf-8?B?RWdqU2ppa2tNRkpkN0N6MTFLWGxjU2tPLzVjWDludmlBRVZoNlJySHlRVGVv?=
 =?utf-8?B?cllhUktFWmY1WGY1ZjFmdnBJSzlkeVU3ZG5qVGlUL3RqRDNVZFJtWVNvaXZR?=
 =?utf-8?B?MXhWME4wc2oxeXdBQmNzaExsZTVQWkJldlhVaHFicmhtamVSclJGeWhsTU85?=
 =?utf-8?B?Z3hqNURHVXBWVENDQnBaVm16S2RyMTROZlQ3bHdTZlo1NE45OENUWWZXb2gw?=
 =?utf-8?B?Ty92b3ZjZ1VSdjkvMlNLQnhQYXZad1pmNUxrQjJUaHk1TmVVaHM2MzNXaWhx?=
 =?utf-8?B?NHY4S1M1RHBoRFI4L3duN08xQmU1RWVEcVZ2ZVQ3MHd1OVZ0eFhZNnVza2NP?=
 =?utf-8?B?L3JyZ3B6SDBSczBZbjlDZXVJUm1xYU45UG1FbllwNlFSZXg1TEE0Rk1ia0tI?=
 =?utf-8?B?eDZ4Y0NnclY3clZwcnE1SUp4eFNBR0FiNlhQcWI1RVRKcEdEeWNQZ3lkRmZB?=
 =?utf-8?B?cEJ5T0VXbnhOY21QMGNGME9TQm9XSEMrREppTjR5Um1TS0czVUs5N0RNSjlm?=
 =?utf-8?B?RTMrdUlzMkJ3bjRlUUVPM3NVbEtKenMwRFpBQTJzNC9FdWZSUWprRTdLQnJ3?=
 =?utf-8?B?dmQ1ckVNcXJQc2tlbzQ2N09BUEJOYXQ2N292TWxkQmQ3UXV6aXliTldRZTFx?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f75b630d-6a7d-4b3e-139a-08daf999f7ac
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:21:30.8391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yk+SoKRBzwufUDmGNhpTHjGw3knLpOPn1yZ6KIVpaRMcJnhU9nmsfYlgu2JfF2lUyfTXsQ+zzi6o8RvDrYgOHnOM/SHmAhcZ8f0W5jdTxJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Benefit from recently introduced instance iteration and convert
> linecards .dumpit generic netlink callback to use it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
