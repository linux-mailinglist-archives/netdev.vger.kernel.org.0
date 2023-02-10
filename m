Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD165692753
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjBJTpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjBJTpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:45:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D17821B5
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676058284; x=1707594284;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0ggUzkZvE+3x1wBhOKMcfO6Vlqcqhco9yZtu359J77E=;
  b=MdOmpJo8Bf/knc0qsblTHbaTSKpmIzrpDyPchnwFEA7DVH2e+uB4Qgel
   n0d81Gngcw0cZBwVFfVhZO/PAklu/IEu5X5Iqv3GOb32fgt9a4KubUS6B
   UIiYfnnQqW3DK7eXoAPW37Qc2F03eYAQ6oqbC/UMFE1DrAdCPxZFbkTw2
   NYn13xfW7UiaidFksusjFi0n6jNh4SOepLUa+Blv0L+SW0U91wrCuKTV3
   RvkC7aTzYwMLyIsT9Xquu8TePKH5odGK76hjFGspZ8OjpkKC33pAG0vdt
   /gTfOY/7DHOWaCvyhOFUKXCy6KBygwktMVuEnhXJzZFDpdg4JrNGMeusw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395123763"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395123763"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:43:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="777051228"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="777051228"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2023 11:43:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:43:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:43:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:43:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:43:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZWNdvfITmi1v/3qozCI/TTYyGetZh9Sgb7sT24j9vzCz//SEkTWM9Cjb29QkAliOwL6x+3N4FzOqrqj5VIuDzAC2AQ68NlDX8bdVcH4vflAJmyFduibX/3KQDCIBZ5oK35+ERn8kQSNGGnQjB40XLBr+W+lzzH3MJSA/P1+MpJnY55nTovO2cZ9mKVJ0Jc9pEET9cKn3O4JG4P2rvpdrz9JLiy9L7Xrfef5JmbMZHKcpEr6nekONw7S393L97//Ceg0AvQbYY/qnsJLxtpEvFM5qR3lB+zbp+Jx8IyaKlZdPwkwzXZs84IMcQx+lQvSheqzz4h0BuhZQKODd969RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEg0tNm2H20mgsssWMtPX+Jdu9B7xD3QQwqZMeVze5o=;
 b=gp41dXWHiORgqcCdHziQZJiltqu+OTgecr5K5meQeSNmgMP06WfMWN/g7oQof26+SD3ZHjZf5X/ply9W4UBgrwgiYoAF5dmEX0w+iejMYDynRiUmGikz7cJ5/zuvZsDXZajEC3wNL8xBi3gEBDdKoB/4ZIl56BtmsmWp/skFEbuMMYTM1g/viDhvjbC8m6kA1WfYjWyeMPBCNEdEoeOGGq1aMYaJMuh/i0Cqj9q9LnW/a4kvK1zV9EPVy0ipbsl/8TbV3iKBCNbN0Q+NkApa6gIFdFfGyLpXTJMnk52Nh4+tnxT0M7CVuVO4f3fp7MQeMNKnqT01kWBPLJlx4uagkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4946.namprd11.prod.outlook.com (2603:10b6:303:9e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 19:43:08 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:43:08 +0000
Message-ID: <ce11f400-5016-3564-0d31-99805b762769@intel.com>
Date:   Fri, 10 Feb 2023 11:43:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next] devlink: don't allow to change net namespace for
 FW_ACTIVATE reload action
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>, <moshe@nvidia.com>
References: <20230210115827.3099567-1-jiri@resnulli.us>
 <Y+ZDdAv/YXddqoTp@corigine.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y+ZDdAv/YXddqoTp@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:a03:80::37) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: 50326123-1f76-49b4-cd41-08db0b9f08a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dp0ol6T2it4JsQ+Wt6Ddo/5Cz/PQnN60XhufRUV5neJFYeWtLdXovub3r1DpXX10b+n89jnT1KMXn1Ar8PIakS358fyyoRCZGwZprwYbsem7S5yLAlp3oSFZoy9oAhDOZh70xRAtS1I7ndNjcbKh3Z43k5DJ1CXWtHBHKZ+h3DiD0iOJWFgungZYM5IaCI1+nSJJyVPIpZACA89AKOf+TQJ7LjR6xYMRXIN934wJuTe3By5mthJSOgDXFoMCf+u7ifh6jTM+SrFaVjEiaMSLqPY39m2ME3ht5Dj4BpeUg1FsU2XX09qM+V/BxPVU5wcIjSi6HBDl1S5nfyt3hid07ffIHTw9YiVMKLC0CM2mWDfzYRtetM+eSSOy4NL5Od6sCsnC/wMDdkdCE50SwTPuelKM6I5qc38YhWy87fio97kA+u8Llx1Fp2ySp/+LishTmiO4OCd85xWbwa9fkgVss7wVgg33uNcVTb0JNFvX8SDzphH/ueQM534+BSXHxpMh3YqeoggeGbye1CoIXePxxbjGY/Ze+XbkF3e26qBiDGXw1In6yqwGSEdFMI6c0unacoMrkyG97+w2o9OiDAMRN0v9ljHSDqI8dkdyxMc5zwHGMKpigyuuDkB0C934aOW5sQ289bWS0/HyrML7sVOzkEnbYbn5MDILPFq8jJHUU6KPyeUMZzpMXF57FH/Ge+n8Er0EzC3ocvrf3Z8gcJM6V0dsDQ55kjnq7umDfvZcZ+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199018)(2906002)(86362001)(82960400001)(38100700002)(31686004)(2616005)(6486002)(186003)(6512007)(53546011)(26005)(31696002)(36756003)(6506007)(66946007)(66476007)(316002)(83380400001)(66556008)(110136005)(41300700001)(4326008)(478600001)(6666004)(5660300002)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUthSWY3dHh2dXY2eVVEV3pGYUpndkhNck8xSW54Y0RUb1NGM05LeWk3ZHZC?=
 =?utf-8?B?RG84cTlHUWx0K3JKWlNPazBqMnlGRlk3dVFuY0JHUGpJRE9PbU96SjJmdDYx?=
 =?utf-8?B?N0xBMnE0QWxHZVI0djJDWmJSS1dvTDVFU2l5SCsxVGVRTzUzb2p5N0syaU9G?=
 =?utf-8?B?c2xsWXpIcExBSldOUjErc3FTWVRUUVdheFhybmp0U0NNWEwvazd2aG01bGlS?=
 =?utf-8?B?SktxdWJ2NXc5M3hPUGxxWElsMXF4WG1ZOFA1YkhlZmpZdDI1QWlEb2VOR1ZD?=
 =?utf-8?B?QW1YUERHNWVWbDRkWWVEZ3JmazNhditqeEdVZ0tSMHJJcDViU1ZKNXhVRFY5?=
 =?utf-8?B?ZUt4dWJnZlJxVkg5SnNoTXFTZUNBa29ZWkVtOXZRUEg4VXFVZnpCa2puTmUr?=
 =?utf-8?B?UmoxSllHbHh1dUtVOEtGYmdoSDZDSDM0UGdySDhpaWMzS0YxbUxkVFQvVmxr?=
 =?utf-8?B?REFtbmMzRWZZTEt5U3lva1JpMlFHdk5BYkMvWnRsOXVqTUcrK0Q3b0FVVnpV?=
 =?utf-8?B?UjVRMDRBdU43OHdsd0pmMEJPa0d0MjlqL2F6WGdlL3U0ekZsZ2NsU2dHSUJC?=
 =?utf-8?B?bWZCdlJtczJTUEVBSFpqMjAveTlUb0hHbENaY0EyVlZxWThhMW5jTzRzVnA4?=
 =?utf-8?B?Qk00OXNtT1Nuak1RL1VYSnhJbTdnYkJEaCs4cWxKTmJSZS9RaW9QYWJIK05k?=
 =?utf-8?B?VVpIc3d1RUlTckc1dDQ1VWF1YzRwY0o2OGFaaldDcHFadmxvZEFmTXdJbWUz?=
 =?utf-8?B?Nm9RTTYrekZjL2o1UEoyVzNmQzAzM2ZKK0FpZXlLQ1doUGVEMnB2czJDeFE2?=
 =?utf-8?B?NFZrZWJOQ3ZOdE1TK01wUWV1NzQ5eE1OaXZZSjlQa1BGdGpJWEZmaUNLK0x1?=
 =?utf-8?B?YmIvNExxSzJkN3d5SFRreDV2cTgvTG1naUpxYWR6V3cwclF4REVrMmFxMFRD?=
 =?utf-8?B?VXJSbVRMaFdqZWF6bGgzekpLZTFzb0MzL080Mko3aXBsdnVHUFhYSlhxNWpx?=
 =?utf-8?B?alJkVmVJbmhwMTdJUGsrdGJhcjJJZFloakZmWGtkUFJhY3F0V1M3aTJyUW12?=
 =?utf-8?B?dDJRd2RQM0pOVkVKc2tCOGZOclFTY1dLZ3ExcUJLdVZHSDJaQU43Tzdnd1RY?=
 =?utf-8?B?c084TGlKSlJSQTVTOFF1S0cwWFd0WENweEVETnU3OVk4T0pEeTVFZ1lhZWJm?=
 =?utf-8?B?MDlnODRYVExiSVZKSStKeDNxV3pkZjBRVEZjWCtYbmV2elBHaldDb1NnZEp4?=
 =?utf-8?B?T25kYVBWWlI1b1pES1V6SGdDc3p3MkxtcDVuS3pESjNlQ3UydHpEZVZKSFNi?=
 =?utf-8?B?dTZ4cFB6Zm0zQ3NtQk03Q3h2SHRHRHc2eHpGbXNHdGZCNk4yeHBiWU1GYkM2?=
 =?utf-8?B?RHE5bUhUenkyNmFZbllTWDVyMkJwNDFOczVuS0NzazFNTUJvMStSeTRMVWVI?=
 =?utf-8?B?cnJqSEVFTXpMaldKVFFwUUs4WUY4NThUemFwT1JSaisvQVZubzFLSnFYRm02?=
 =?utf-8?B?RmlCNVlZWGU1UHR2azRxbFZyR05nMjRLQVh2MVl0WUVHQkJ0V1VNN1YvY3Jx?=
 =?utf-8?B?bERBM0NBUVhicE10Tyt4eHkrL2pWMHBZNWMxeHZzMFlleHFWemEreThGY1Nl?=
 =?utf-8?B?K0F2Q0NNQXpMZmMyMzBPN3UyK3hHaDU0dnBUVDRvcUtpWWhyMURCMmcrUWtn?=
 =?utf-8?B?cXdpaWdNUGlLQlBHTjJ6bDJEZU1xM1hVVDNkSWxuN1pNQ3JBdGF1dnZEaXFQ?=
 =?utf-8?B?SVlmWHl6cnE5QVNYdEcweUU2Q0Z4L2dLeFg5aTFZZXhaTlV6U2hwVHNTUUNl?=
 =?utf-8?B?WjI5OFEzbzN2QVo0M3hJbkZBVytjaU5NOFJJY1dHV1FCUllNb2ZPK0JCMm9k?=
 =?utf-8?B?RldjcHo1dEN1VHZ3djV2MG5jemFqVkRxWFJkY1FYRENxaEdzYmphV3VCeUMr?=
 =?utf-8?B?amtKMTV2ZWkxcldlQmNJRk9UQ1lReXBKbVJLdUk3czFzUENTekE1M1hzRFIv?=
 =?utf-8?B?c1VLZ29Vd05iQy9zcHRETEw1WnRKSklXdnI5M051dzVCeVhqSFhFUGlXS3dI?=
 =?utf-8?B?d1hWZ1labjJUdTVETnNkaWIyZ0hsbGN0aElKQ29WaUp2am9GcTUvT0NRWk9O?=
 =?utf-8?B?QVRXZ1c3RXZQeG5yRDJPQk5neXZYS1RlS0x2Q0l3bTlxQUttUWMyZDZ1WDU2?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50326123-1f76-49b4-cd41-08db0b9f08a0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:43:07.7528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7rF2ZmNplZCFK9qfARELQQ90pzGJIzTNCRsJhf9oBTNkY1xlhCWCMX0WET+NBOXuIpTtrEvG2IFNNjILgXql13U0Tyr33X09Iy4puujm+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2023 5:15 AM, Simon Horman wrote:
> On Fri, Feb 10, 2023 at 12:58:27PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> The change on network namespace only makes sense during re-init reload
>> action. For FW activation it is not applicable. So check if user passed
>> an ATTR indicating network namespace change request and forbid it.
>>
>> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>> Sending to net-next as this is not actually fixing any real bug,
>> it just adds a forgotten check.
>> ---
>>  net/devlink/dev.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/net/devlink/dev.c b/net/devlink/dev.c
>> index 78d824eda5ec..a6a2bcded723 100644
>> --- a/net/devlink/dev.c
>> +++ b/net/devlink/dev.c
>> @@ -474,6 +474,11 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>  	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
>>  	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
>>  	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
>> +		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
>> +			NL_SET_ERR_MSG_MOD(info->extack,
>> +					   "Changing namespace is only supported for reinit action");
>> +			return -EOPNOTSUPP;
>> +		}
> 
> Is this also applicable in the case where the requested ns (dest_net)
> is the same as the current ns, which I think means that the ns
> is not changed?
> 

In that case wouldn't userspace simply not add the attribute though?

Thanks,
Jake
