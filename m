Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC736475DA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLHTAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLHTAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:00:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD74D85D37
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670526016; x=1702062016;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SLPsRWgE5K/qZdskkybKlc2mJ5CT+YnXeeqYhEmMyaQ=;
  b=NxNQ0t/ctkzMnm60aPifTpazGyKBwDyuYjuO0q24lzS04isVgf8ilw/a
   ADa+iLg8VKdKCWd69F/WADXZ/wMI16kZuNtLxpiliWS/NtjNacJIRU/kL
   /Jb98Y6QasQaiTlCbZNU+dcaKMRaOS5CJ0E7ddW6sV0YawyYDSLg/3dRF
   vo1f4d+XewjQ0BOPbc6TsodO3C/32gr6cxPs8enVbyIbigsgnzJzfV7OF
   MKQMlm2HretVIxi9QO1sp66Lu//gBJ6Yvczu/7quq47hAl/oHfAWsco1y
   YJanveglfv9soT+DuBMQQuixB+sOXxnkcXUt2sr5PbSof50t4bXgl4oJV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="297618881"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="297618881"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 11:00:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="597458494"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="597458494"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 08 Dec 2022 11:00:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 11:00:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 11:00:06 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 11:00:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxqAjkSt9UgaosERaTbuzLUtncoJs6meo6pwm6ht/L0mEaGnLcu9tEq+pTxPfILOVhhPxNVVT3P9vZ7ZWl8njxOyZyAH5oVgpqrkFc4DF+qUHdoNz1531L+OT1Qp3Uz2IS0iMJKreRfCSfSGT/tmIPzDfH29EqpYH5VcQtOfAJWOYV+zCUqJUwKrHj4OJOkiy79oJRI88i4fEaqXz5w/lIUPnf+WTHRZBi7qATGmVCEV9tfqs4unJ5cwITsD8sge23qiqUPtOFLIU9zqz7iaS9zu4uF/kzuBhNkwhgJS2Zo59xPbvKK074QA+krEsDsQEf3t93G6QFJG/U0vL5jtpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJT0hE6OnpRFs4pFlRjMiSSTJi0Ii1K30t7F1p8xhug=;
 b=Ka7B4Be4xZ6krx5jUAsDvnbMSyelaaVaOpzYfyuhjCsj1Xo8JElXkDtl8d2xQd7gXKSsUxfnOHqwnukv7yb18GEL0bk/31iJPUWvKP3JM0x/zFluqDDlsR5YCFXjwtUygB33esCCeow+x0yH5GGv9pUXTmLDAustZNoiL9mbZz+DSeCuHXpNon+9gz+fDDFKORxrYYlstVNnJ4CDkIu/qvL9xaUy4fU2Js1/LrjX5080UjGpUt1XfX+MnWYKL4xAHc2QSzvvWu9Cy27VnpKA2qWXtYxipr62L2i8C7/VmdhthRXTkrLiTwhwNZQrfH7I+Ug4CR6mVxo1H/2nbjdQQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB4857.namprd11.prod.outlook.com (2603:10b6:806:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 19:00:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 19:00:04 +0000
Message-ID: <bfaf41d2-b70b-12ef-ca79-bd96807c8fad@intel.com>
Date:   Thu, 8 Dec 2022 11:00:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [patch iproute2/net-next 2/4] devlink: get devlink port for
 ifname using RTNL get link command
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <kuba@kernel.org>, <moshe@nvidia.com>, <saeedm@nvidia.com>
References: <20221205122158.437522-1-jiri@resnulli.us>
 <20221205122158.437522-3-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221205122158.437522-3-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB4857:EE_
X-MS-Office365-Filtering-Correlation-Id: e2890174-3dcb-4d8b-a7f3-08dad94e6a46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nNoP51RUu/uo8Y3NQEDdUH8sjiUS2CUw/eMpyxrIMWHinjuS0gFnIPJyfLRrG/Ud+DJtfUtAB+9nqYWN574wB1nKFXE6c/pFAPU9+1vmyfMSNXcknBynx90J/EycXW3G9innPlw9OdapjDlr+5iA6WPbQfMiqzVny8dUSuPtwxuhrWjhb7AI6WZZpNGV3izhMqXDcrOgmm8cHJAjOYpY2jAI+nrztlcvg7ycAH9UF2DU3CjoOzKgy95xjYPaP9E0LG3GK3Qj5IdkV1Sy0JRztR53Sia7qSimEQ+TAe9FYJrdkYs51Wk1fZ3OspK4J0bE0NtRw7xXV03fQ6i4fItXLLrAJgeBbIqVLIMe5E/VpUXT2oOD+L7FhPLfWYMwWWoyfo0TNkfO/98GSvA6wAf79rHNvkstbgJQoY8ZR8anFcglBwKRNt6gyemsmG4su4pkHKeB6Z09ISchmMeoRO2Sy8O6Xh6l0A97L7CL/6QmGd9QGril9Oeq8IsZVkfATu7svwkGpbyj7PZOrCCf4cXk6c9KxWFcWnX4FyiDiW+tqsZDcCaVeCUKcZoA0euPYwxafAoCY+Og1LKzcZVAFnRiwwB0cpmfHNFOrmL/JjGK/9wphJQo/6DmpFgfv3z5aLcOBjwn3JwnCUs+zLxwaFIagMJjw7gno3jq5VPIUGYjT11OK5SUUGYfUp35kq4bVgnUuC0KzIC6kvhtmc7HfrbxY1oxPFAfhaelXjy3hVCOl0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(83380400001)(8936002)(31686004)(41300700001)(186003)(5660300002)(2906002)(82960400001)(478600001)(8676002)(38100700002)(4326008)(6486002)(6512007)(66946007)(66476007)(2616005)(316002)(66556008)(26005)(6666004)(31696002)(53546011)(86362001)(36756003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU5CZU1CNkVxWDBCazhMa1ZKT0RHNFJPOVlyODRUbDVZZEZkcjBtWE5DMUNm?=
 =?utf-8?B?S3hiVEV1TzVMMGdPNDhtZ3RmSmdRMVpEVW5kWDlkQmpMUDhDR1dhNFlpRGNC?=
 =?utf-8?B?R3k4dTJ0Nm9adDhUNUJZdjdrQUN4c1Mva1RPWEdMVDVKRENmNnpvano4NWYy?=
 =?utf-8?B?SytoWmRzZlJJRCt5MHBpMnFrMzFHVERNNktOR1FYRDd5aGZuNU9jVnUyY2lz?=
 =?utf-8?B?alNEWVhVemI0UnJBUGowclhoNHpJZ0wvaUZZOHdtQTVST1ZrZHU4WnZrMjZJ?=
 =?utf-8?B?SzFRQ05nNWFZQ0ZHZURVZFkyTUFvM2JzdjRBT3JMYUhJZTJYYXlPaGlLM0hz?=
 =?utf-8?B?eWxzNEtqM0Vtdk5GRGc2Ri8yWjhnN3ZwQmt6NU5uY3hCditKZG1NZE5CVmFY?=
 =?utf-8?B?UlBJQ1Bic3ptbHVyVk5rdDNid0F1RGNMR01kQkEwSlJJKzNmYmhtSi9mdGtn?=
 =?utf-8?B?L1lERUlwNEF6cDZnL3J2RFF0T1VXdWE1Q082ditHOUJyQ2pST2Vjak9GY2hM?=
 =?utf-8?B?bitxaERJUXNNcXUrSGVpNis1clljYWhyYUorV2dwbVZYTko5bFFnTUpsQ1RT?=
 =?utf-8?B?TXR0WElYYkROaTRwaVMzMys4SEp6UFl2U011V3dleEJVazUya0t1VjVNRTgz?=
 =?utf-8?B?RERZaysrTjdkRWRqZWIyS1d1NVFhRGlENWxzMmQzVlN1TUFSSFlPMW4wQUNL?=
 =?utf-8?B?WW9idWZEWmc5M24vSllxZGFjamhRbVJQS3NObnN6UVRrRUd0T3ZiV1VkQ21u?=
 =?utf-8?B?QmM5eE9RU1c5NmpOYXJyY0h6R1N0OVl3OU9PRWZ1NzhuTGtJUGJ2Y3RqcWlt?=
 =?utf-8?B?eC8wNzl6SnIwb2lvQThRMlArK1RyRjZhejB4TzJMVHBRaGpZa2l5VG1hOGov?=
 =?utf-8?B?NFY5Y1ZWRlhVaERScDk2UHY2RWd1Q2JDNElqYkxZaEVxSUkxZkc0bHgwOWxT?=
 =?utf-8?B?NC93Q0lBeThSRWcwM1NnQVk4OTRaOVJYTFd3WVR5aXBSVkhZMFVhNUJPOUVz?=
 =?utf-8?B?S0RRU2FVN1hWMXppVXNsdDRJV0w4OEJ4eStyWXhzblFrRWZvYzB4WUt1WWFj?=
 =?utf-8?B?QnNSNUs0Ly9TZ0Uxd0o2UkhxNnVQb0hXckZuaStueWdDWVh5S1ZwS085NmJ4?=
 =?utf-8?B?cTllbzFhWmhvajJuWnNadm5TTkRCNmFJRjE2N095ajBoREw0KzgzZzRFRm05?=
 =?utf-8?B?K08yRzdnbnpVdWt0VVFHMTVBcW9LTVhZc1hKejJnNW8rZ1l2YUF3dlRKV20w?=
 =?utf-8?B?RnFPVC9LbUEvcjdwTHZraFBYdmY2SVZiQlh2MlNPaHRZM0xBMWFYMGFYN0Fi?=
 =?utf-8?B?U3ZZRGZCQjc2QUhGYVFPdVRvRllaK01PT2o0M2V3eTlpOGphTkhyblBiRHNu?=
 =?utf-8?B?ejYyNGVOdkV2T25uL0FXQXBOYjJvY2QyMGE2VC9QVnpsVld6eGtDMm80Q21L?=
 =?utf-8?B?dnpHWVFxMTkxV0RNQmRzUEZWV3hVYlBmai9QdkFoUitpYmRUdDNIMDlmUy9R?=
 =?utf-8?B?SmVqYWIvZDM4UXJRZEhEMUs4NEVCazYrUm9FOTVPKzkxUEFwZk9jRUFiZnJG?=
 =?utf-8?B?d0lYZVd6SDkvYVZuRU81UVMrMEh3NGxSSW9TaERKN1hvd0ZhckdsTFZjeENH?=
 =?utf-8?B?ZG1TNWZqbC9LSlAySmNPck5oWjNzQWNiVGNwYmVjR0JFb2U0Um1GZktaVmR6?=
 =?utf-8?B?VGdKOEV2NlFvMlBCc0pCd3RMWUVic0JZNW5NeEJtYVUyZDNnbmNJR3pxRFlM?=
 =?utf-8?B?dWhjL1htRnNKOE9aeHo2UlRYUlZsejNnU2ZxWHE0NTR0aTlsNWQ5S3hhbDM3?=
 =?utf-8?B?VC9RTEhKdnZoTUM2MlloQWlIRHQ4ZzduQnR4Vm5ZRWxUZklFdXFxcFFzTzA1?=
 =?utf-8?B?NEZhVEhYTjJQdzkzM0dMeWtLTHl2alFvK0g5bjhVbFcyYjZnTmFUZVJIWXJN?=
 =?utf-8?B?Ni90WklROCtiYkVicWo4b0JEeGlnUWh3Zmt6clVEZld0U0FZbzV1N1F6MGsx?=
 =?utf-8?B?REwzQ3YycUMvNVQ0bCtEdS83UjliRGhubVBONmRnVjE2T0g2eDZOanlLU3gr?=
 =?utf-8?B?bFpZemJ2WWVwQlpVbUFyRWRwN0Y5TnlEcWZOV3REQ3k5cUpOVVBOVDJMaXJY?=
 =?utf-8?B?Sk9vTGU2Y0xDSVc3K0RlWmlpdjlaV3dpOGFoVUhueDdtak12OVVLaHE0SDBq?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2890174-3dcb-4d8b-a7f3-08dad94e6a46
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 19:00:04.1302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLVsHTYzFc/f22zqhN/EJLNApYCdCN6uZX7nYhlKbOPq812yMCM7+SwU9rk6+knlQ6OnTAvSMsLurtvrnl02CHx9lsG+Lz1XJUJimqYslkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4857
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2022 4:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently, when user specifies ifname as a handle on command line of
> devlink, the related devlink port is looked-up in previously taken dump
> of all devlink ports on the system. There are 3 problems with that:
> 1) The dump iterates over all devlink instances in kernel and takes a
>     devlink instance lock for each.
> 2) Dumping all devlink ports would not scale.
> 3) Alternative ifnames are not exposed by devlink netlink interface.
> 

Oh neat I wasn't even aware we could pass netdev device names! That's slick.

> Instead, benefit from RTNL get link command extension and get the
> devlink port handle info from IFLA_DEVLINK_PORT attribute, if supported.
> 

Makes sense.

Code looks ok.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>   devlink/devlink.c | 96 ++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 91 insertions(+), 5 deletions(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index d224655cd0e9..80c18d690c10 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -43,6 +43,8 @@
>   #include "json_print.h"
>   #include "utils.h"
>   #include "namespace.h"
> +#include "libnetlink.h"
> +#include "../ip/ip_common.h"
>   
>   #define ESWITCH_MODE_LEGACY "legacy"
>   #define ESWITCH_MODE_SWITCHDEV "switchdev"
> @@ -797,6 +799,81 @@ static void ifname_map_del(struct ifname_map *ifname_map)
>   	ifname_map_free(ifname_map);
>   }
>   
> +static int ifname_map_rtnl_port_parse(struct dl *dl, const char *ifname,
> +				      struct rtattr *nest)
> +{
> +	struct rtattr *tb[DEVLINK_ATTR_MAX + 1];
> +	const char *bus_name;
> +	const char *dev_name;
> +	uint32_t port_index;
> +
> +	parse_rtattr_nested(tb, DEVLINK_ATTR_MAX, nest);
> +	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
> +	    !tb[DEVLINK_ATTR_PORT_INDEX])
> +		return -ENOENT;
> +
> +	bus_name = rta_getattr_str(tb[DEVLINK_ATTR_BUS_NAME]);
> +	dev_name = rta_getattr_str(tb[DEVLINK_ATTR_DEV_NAME]);
> +	port_index = rta_getattr_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
> +	return ifname_map_add(dl, ifname, bus_name, dev_name, port_index);
> +}
> +
> +static int ifname_map_rtnl_init(struct dl *dl, const char *ifname)
> +{
> +	struct iplink_req req = {
> +		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
> +		.n.nlmsg_flags = NLM_F_REQUEST,
> +		.n.nlmsg_type = RTM_GETLINK,
> +		.i.ifi_family = AF_UNSPEC,
> +	};
> +	struct rtattr *tb[IFLA_MAX + 1];
> +	struct rtnl_handle rth;
> +	struct ifinfomsg *ifi;
> +	struct nlmsghdr *n;
> +	int len;
> +	int err;
> +
> +	if (rtnl_open(&rth, 0) < 0) {
> +		pr_err("Cannot open rtnetlink\n");
> +		return -EINVAL;
> +	}
> +
> +	addattr_l(&req.n, sizeof(req),
> +		  !check_ifname(ifname) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
> +		  ifname, strlen(ifname) + 1);
> +
> +	if (rtnl_talk(&rth, &req.n, &n) < 0) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (n->nlmsg_type != RTM_NEWLINK) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	ifi = NLMSG_DATA(n);
> +	len = n->nlmsg_len;
> +
> +	len -= NLMSG_LENGTH(sizeof(*ifi));
> +	if (len < 0) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	parse_rtattr_flags(tb, IFLA_MAX, IFLA_RTA(ifi), len, NLA_F_NESTED);
> +	if (!tb[IFLA_DEVLINK_PORT]) {
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	err = ifname_map_rtnl_port_parse(dl, ifname, tb[IFLA_DEVLINK_PORT]);
> +
> +out:
> +	rtnl_close(&rth);
> +	return err;
> +}
> +
>   static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
>   {
>   	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
> @@ -842,11 +919,20 @@ static void ifname_map_init(struct dl *dl)
>   	INIT_LIST_HEAD(&dl->ifname_map_list);
>   }
>   
> -static int ifname_map_load(struct dl *dl)
> +static int ifname_map_load(struct dl *dl, const char *ifname)
>   {
>   	struct nlmsghdr *nlh;
>   	int err;
>   
> +	if (ifname) {
> +		err = ifname_map_rtnl_init(dl, ifname);
> +		if (!err)
> +			return 0;
> +		/* In case kernel does not support devlink port info passed over
> +		 * RT netlink, fall-back to ports dump.
> +		 */
> +	}
> +
>   	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
>   			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
>   
> @@ -858,14 +944,14 @@ static int ifname_map_load(struct dl *dl)
>   	return 0;
>   }
>   
> -static int ifname_map_check_load(struct dl *dl)
> +static int ifname_map_check_load(struct dl *dl, const char *ifname)
>   {
>   	int err;
>   
>   	if (dl->map_loaded)
>   		return 0;
>   
> -	err = ifname_map_load(dl);
> +	err = ifname_map_load(dl, ifname);
>   	if (err) {
>   		pr_err("Failed to create index map\n");
>   		return err;
> @@ -882,7 +968,7 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
>   	struct ifname_map *ifname_map;
>   	int err;
>   
> -	err = ifname_map_check_load(dl);
> +	err = ifname_map_check_load(dl, ifname);
>   	if (err)
>   		return err;
>   
> @@ -905,7 +991,7 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
>   
>   	int err;
>   
> -	err = ifname_map_check_load(dl);
> +	err = ifname_map_check_load(dl, NULL);
>   	if (err)
>   		return err;
>   
