Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148866E14E5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDMTMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMTMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:12:06 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A4A7AB3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413124; x=1712949124;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gzRSW8NRFzd6iXgW+BrFyWaMKBA60HodvFLwDhVuNEs=;
  b=l2bgkiBDvq9xLRAq0Ic0CVFOu4yByeT/bTB3KUrL57aHdxN2fbEavLn6
   U7H088gohWMPhzbYMZE/y5QEnfavTpEvvHiJMkizCTWpjtYSWsWsAgUR/
   qSbv52K7BvdNxH3ByocuIEFQ6oxFqSgkr0oAEz0pR5oYBNEx0grQKe2lx
   7dhw5hu3N8IkCtL78+6sFK/gl3FgcUxsqaW7GfDzVDdQRC/FWY2WurNWT
   xJaHyC4RHU4yTTW/jDqGKHhcP3MlIzVZR3d6MRqnZUST7Nd530KatzKMR
   s2lN7alvoW7YZxdCKX+46EDz3E/BL1BeyIRzNYykzkWU+3RVBgw005HtY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="343037161"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="343037161"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:12:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="833239586"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="833239586"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 Apr 2023 12:12:05 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:12:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:12:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqGgTALDzlpdEMqc3v+DYT14BXU+qbtvizsXS9H7CbejG5aB4b4r9hLKP61/XiRWwUSjIOOGL0KCmoKT3YBXdz/trAg0muL71VgZCEmP50NsK/h34GmQ2Mj6ZFNkqRW37dkORSGyF9qnSfQbMhIzk/0cBEISdcY25EtSjwmcPxm4XEb1Arseqi/fNhulM1uAqzcPWX/0OWgLudgyq0afWbH7hazDp1QPngPYz8YGHbCu8RTMQo/UVGPJawnQaggMcCm5YuR2pACnkTOxVzNuCICgzpMqcp/EYVl0GU1xXFR7O4IOqq/0giZLofmKVI5ITb7PIkRpcEmG8RAzzlAJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCU3ItYuoslG+Od8SGTQ4YJ0AiaVX3Fbfcyi7Jrsmtc=;
 b=Nl3aQwm1EiJV3tN5iLNwul2L+iqXQMmV9SA41rxUhDKD13KoyXI8JN3Lfd4dBF7SqvG3nweEezD992U+PVDiWy9Ixg4wimjxGF1HNHDsAM59nSsJCGQ6HlvLm+IorXgz5fMrZXG+v6w1nbDuUntxydDG67T4u2vM2XqIgv1/iEh1dtNT5grfZJMkFBTE8pzKxRmm+W+3zXLmiWTB+NkRhD+tZVyki1VHknnhn9Xbcpou8xbJlEDx5p96Wec97Vjlynb9Bc+KNBVp4l+//rqdujpOFPXJ0EMtudnj64fc4GYJ4uocu+uY10Kujg/opW+zeiciB5D7pP9WXCrpGG6gVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by CY8PR11MB7107.namprd11.prod.outlook.com (2603:10b6:930:51::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Thu, 13 Apr
 2023 19:12:02 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%6]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 19:12:02 +0000
Message-ID: <bc8457a8-28d7-3c79-9272-314f8be5cc09@intel.com>
Date:   Thu, 13 Apr 2023 12:11:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 14/15] idpf: add ethtool callbacks
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <willemb@google.com>, <decot@google.com>, <pabeni@redhat.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
        Alan Brady <alan.brady@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-15-pavan.kumar.linga@intel.com>
 <ZDUunmuPmM0E3Rx3@corigine.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <ZDUunmuPmM0E3Rx3@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0120.namprd05.prod.outlook.com
 (2603:10b6:a03:334::35) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|CY8PR11MB7107:EE_
X-MS-Office365-Filtering-Correlation-Id: b461c91e-15b8-435d-1714-08db3c52f677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNAOjmbOqNSb8OeBlgsD1RwAPHQ6EhVo8suP19lEUahAYvomDUPZkvPrzuNT0BlZsrdM32ak2mEBIeTsn6wHl45/n/qYDhb07W+YGg481aazSThGOCF4TUamtPsM3wukPONzefvVkMRxEToREwnrb26WHjTsnPDkULl6ueaIRDGZbELKo8I+mEj5shsQKXo0Gz1Nv3X5GOnwYhEdnaC0DYltWhqLNpwOqhoKiaRAmPgt8CaXsMx8TwbNQgQs6Z6dpS6Wta9sxn5SPz0lJ7yr7Fk0LOcAKQ5+cGdOMXJgmuV97ci3zqSW+9ShKRWCHZnZ4O4CtbK1SwpwGsQFT9JDzIUeW2dXhji92Nm2sg7dcNZp+ixXPG/oac+TAq7hIrW2Ux8qwJzfOF/LRvTESj+FkA0ywaPi9GeBAX/8g7voLZF/npJMaPf1bQFsEsoJCeFCx/+G5ptVvjmQr6wG+Oa0K+8wrQY4PJthSAo3hl5ejsaFUqFIXfo+3VekMOh54z12xGBnjqNQRQTbuA6IKczZmMStym2xMzZv1yZnE8/cXLDiXFNdnLrRrDWe9+j6zar/wr+GLGfBxWW4/PPA1oNmcJS0TeoeGlrQlIFTICdg0Ow6EMX8X5dz+aDsZMDeZTvN6CdHwjOulx0kB8O0FvhLUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66476007)(66946007)(66556008)(478600001)(6486002)(54906003)(6636002)(110136005)(5660300002)(4326008)(8676002)(82960400001)(38100700002)(316002)(41300700001)(8936002)(107886003)(186003)(53546011)(6666004)(26005)(6512007)(6506007)(2616005)(86362001)(31696002)(2906002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDd3bzErZTFTd05tSmRackxJcHZQY0RxV09UajBMUURnNytHS01rdVpvNUFa?=
 =?utf-8?B?ZDNxKy9mdmgvWHZNVnNqaWJ3a0FzcTBSa1FQUDRQTjRwczNEWlQvOHdOWm91?=
 =?utf-8?B?UEJBU1czSzVZc3NZeUJBTzJQNXY1RUJoWG5pUTNLSGFqdTUvNlNkSmQxNk5R?=
 =?utf-8?B?VWxvTlFOYU1qMEtuQmhMYTEvVHNidmVJYWE3SWdjRndNRUN6UEtpM1RoNnFY?=
 =?utf-8?B?aVBNc2JyNVdZUDRYRXlKNGpvQ0EwV2ltdk1SUTlMTHFEajZORXd0TEwxUGsx?=
 =?utf-8?B?U2p1U29WKy9rK1ZwUERBbTREbGpXSDFnampDVmtzaXdKKzI4VUFrT2RVT1p5?=
 =?utf-8?B?am93dFh0U1Fsa2dJQjlUbE1SdU9JaEhkT1NjM293U0hqOGd2eW9aQm5vTmpw?=
 =?utf-8?B?eGt1R0M5bUpkM0h4RXRyWHQ0M0hnaHFTVUhCUC9uTG80empzTHB6TkdLc0t2?=
 =?utf-8?B?cEM2cFRsZkxXcGJyalJTbzN6SnJIVGlaa1BLM3QxNHViaWZaSnMzRlNDNzgv?=
 =?utf-8?B?aW1nZkhnTnJwaEh3RWMvU1RPRVhvRmF2emo2QW9jRUtZbGFsb0pONzZZdmtl?=
 =?utf-8?B?VkZlcDNyOU1UZktGQ3NuWUNLTU5XNGRxYWYxNHRTc1U5aGsweG1ReGlWbUo2?=
 =?utf-8?B?ZHk2c1BhaWp3YVZ0NHZvWXRPM0FiV0MrWXJrWVgxa3lLblNOM0VBU3RwcGJV?=
 =?utf-8?B?bWNrT2l6M1NkU25CQXJnMS9nNE9MN3FTYkZqVXVaalNJVlpWVmNzRGhjbVlq?=
 =?utf-8?B?Y0VJeCtUbjJBLys2NzVpZ2R0QnNMMXJjR01JbFBveWpHcDNPOHl5WWpVNzN2?=
 =?utf-8?B?Um9tY2dmamhjeThjL0lSaVpyTzgxbktKbkRGRmdBZ3RpRHRBRkttc1FtVXph?=
 =?utf-8?B?YXZHWkJqRktTMkVod01SdklSSm5SdytlMUJ4dkdXeGpmK1BWUnF4T3Vid1E0?=
 =?utf-8?B?SW1obERBeEF0MlVqSkErWDErNnhWRW5iQUVrRGVlRFlScTY4RzJzbFpoWGdB?=
 =?utf-8?B?YitkM2laOTM4ZnhoTSt5M3Y2T2VYbG9TSndFdUFhbGU5aGJCZVg1eXdNMjlH?=
 =?utf-8?B?QlpoQUFtNktWak9WT01GTjVNK2ZaWHBTdlNMKzBPMGhqRVNwdlBJWlZ4WVJC?=
 =?utf-8?B?a0lUcjF4UHJYeTJKV3NlYWhIdDR3c3crYUNod3lvRjZUVDBkNEIzU2Vjb0Jt?=
 =?utf-8?B?dWZUc3dIbHhVdElFcVpFRlM2Y2FUM1J4Y09aOG1QZHdtS29Sa0NvODg1YUJ0?=
 =?utf-8?B?VUtETFpzVWlOWmhOdTN6VHJNNlFNNmhEUUkrRG1COVFNRXdUUmZra2JOTWFT?=
 =?utf-8?B?dngzVE5VNy9BY00yN09OUjl1L3lrNlNRc2NpQjZoZjZUVVRFRmxaelJVTmJ6?=
 =?utf-8?B?MzAzZnZOTjhObmQycFczb0s4c2hNZUlGa01JK1JjVjhqU29Eb25WOHBLTi9u?=
 =?utf-8?B?dDBPVzNOMHZXTXhYM0pUWHdkNFo4dy85RWtCQWNYUEN4bG96SldqMkFZY0p3?=
 =?utf-8?B?d1FsL01Cc1Y2dE1UeERDYzJHWHZjb1lSYTdRWnVBMno0OUVzNXRYMVkvNDZh?=
 =?utf-8?B?eWpvNURjOE5SNENYTkZNS2xUNWkzdHlqUWIwVFJUNk1NWEsyUG5pSzZxZjZB?=
 =?utf-8?B?R2lnZzFUV1BER2EvMUh1SWRhQm5FQnVublM3VkpjbDBWTEJsMUQzbUFDOVBa?=
 =?utf-8?B?bXRqTkNBQTB3NEFqNzk0Zkt5UWNsdWwvaTc3bE1JRTJWb05PQWRWR1ZZSUZP?=
 =?utf-8?B?SGhtZ0xnV3RjTGtEK0NONkxhZUtnbFhFNStMeG1OT2c1cHZXTnhsMTAzUnBT?=
 =?utf-8?B?Y05KUzdud0txdDViemFlL0h1WERQY0NSWWZGSmM4NUkwSFRobHppWVo1Sml4?=
 =?utf-8?B?eHQwanVrU1dVQVl1bEpoZEZVRUhnZllPMHhlWUhTaFpOREhLZXliOGs1NTBt?=
 =?utf-8?B?TExLOWRpRmVtSEVvcHREa3NyaGZDdmlDRm1nOXpVREowdWF6WCtiN0lnTSs0?=
 =?utf-8?B?bi8weHBSUlFVM1c2OGFCcXJETWEzVGpRdnZTMUNMVk8zb3Fsc1IzV0Z1dXly?=
 =?utf-8?B?eGEwUXBBR2s5K0toQnh5R2E3K0JvWU5GL1VtcW1BdkhGSkFlQ2ZQNkNiK3cw?=
 =?utf-8?B?SStFSktyMnJReVdqOFdXYS84SVhFeFhpNnBDdjI5dWdIWFRYdTFGRVdycDlq?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b461c91e-15b8-435d-1714-08db3c52f677
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:12:02.5217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eAhwiGnG3MGFJgFlDLxljKIlbfRV1UtlLpJ1TKQwo8zUwvGb6mZaX8HBGiOv8A8Gefm6wZMjtM2IuKrsnYppZ1lGH9pNMSC8o+NdeTov15Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7107
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



On 4/11/2023 2:55 AM, Simon Horman wrote:
> On Mon, Apr 10, 2023 at 06:13:53PM -0700, Pavan Kumar Linga wrote:
>> From: Alan Brady <alan.brady@intel.com>
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
> 
> ...
> 
>> +/**
>> + * idpf_add_qstat_strings - Copy queue stat strings into ethtool buffer
>> + * @p: ethtool supplied buffer
>> + * @stats: stat definitions array
>> + * @type: stat type
>> + * @idx: stat idx
>> + *
>> + * Format and copy the strings described by the const static stats value into
>> + * the buffer pointed at by p.
>> + *
>> + * The parameter @stats is evaluated twice, so parameters with side effects
>> + * should be avoided. Additionally, stats must be an array such that
>> + * ARRAY_SIZE can be called on it.
>> + */
>> +#define idpf_add_qstat_strings(p, stats, type, idx) \
>> +	__idpf_add_qstat_strings(p, stats, ARRAY_SIZE(stats), type, idx)
> 
> Hi Pavan, Hi Alan,
> 
> FWIIW, I think __idpf_add_qstat_strings() could be a function.
> It would give some type checking. And avoid possible aliasing of inputs.
> Basically, I think functions should be used unless there is a reason not to.
> 
> ...

Good catch, we'll resolve it in v3.

Thanks,
Emil
