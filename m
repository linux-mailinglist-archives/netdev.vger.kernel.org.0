Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D11D6BF0F4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCQSp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCQSpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:45:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F53C9258
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679078725; x=1710614725;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qgHSMvhSCXHZaP5QOdL4GF/MvbeqkbNsdl5LzN8hifg=;
  b=DQNBIrcrG5lgvnYbfzfrMoHvtdajbscRHIFxNPpngqUAc89cxdeszqKb
   9owJXp8ItUGCHofAFfkM0/eCc4NXIMJT8xbEuWhLcgB+HgalCKQFlkouF
   3p3lfDzlXFI8VdA3uJYKx5n4CXF0+klVR3z2+8wraAfkYIzYtcQFHtINA
   /siHAkaOuia3lwaEJaFj2NkgOM7n0kBs5+ui99YBPGHwSgozwSWBTntxN
   0wGh38C5UwJlezWXFOrZxcayZ29dVlO0b0kVbqXxtvZtXqgTl9SqaCYxw
   F2fwHZdKQ3T/lpPEBRqMjn8JBfjiHwFsg5b6AZ+D8ItxcaHjxKadKRjO6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="424608382"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="424608382"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:45:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="682776196"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="682776196"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 17 Mar 2023 11:45:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:45:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:45:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPx1n1/l2aVeSNkcDLhXSXEm0yKm7iS8AobPb5Ae8r15gceDXmPiXiJFpY2UNbRSiTyO43SuWGoWlal1mNB/wH2a9kKxRi8REXWjP2k1US4pKbvIuyCISxH7w1JpMcJTmUwuQku026efd9v5p0AzfhUGLZoRXzx0dkNWeizNGI07oilYOXYCVwX6ZUOCMh9RcjcUTxyLQUoojaQwwoai8hfrtEc3FiC71Hf2Np3+MVEgZZpApF15vXdcu534E1xeU9tZrXINUPsLGnNeQGUN1DM8/GYnOt8Xp4kZ/EWO4fadWV0LNSlx8WPerWQTjTEWcj+DNCd7uOKVpadWWlzqFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGAyZPJkXw6kALvQLRe570cj88+R7/4hLo30Fk3TDNk=;
 b=Ut5eIpmh7vz2/wQpiQNA1hkm60GMZGxODBvp48f70Ha5FMsYjVYs3ug1/+y2eLSa2cMb534q93O/dWqRVz0F/IfqqWIgAUbyAOm287aTDXUn7311ck3bVVBVvPVO19VuGLBPGsMd2fffBRTtWEFvcNqIkt2WkvRgS/5BSgZtQ0Bh+ZQw8cqR/uohIpxI/1f8bqPM9k1FvdFUP4IzMJEiyOp1VwCDe62W0B1IAH59DgcEgwGtv9xq98m7yiRthWMbzqoojqUxGiJ5B7Zmo7m4Yz2ldx2XHumG317esegbw286oHpHum2ibpIt4UNSZTYB7n/+70u05TeNOxXJ44Kqsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CH3PR11MB7675.namprd11.prod.outlook.com (2603:10b6:610:122::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:45:14 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 18:45:14 +0000
Date:   Fri, 17 Mar 2023 19:45:14 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Nick Child <nnac123@linux.ibm.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] netdev: Enforce index cap in netdev_get_tx_queue
Message-ID: <ZBS1OiIsv/ys/FE8@nimitz>
References: <20230317181941.86151-1-nnac123@linux.ibm.com>
 <20230317181941.86151-2-nnac123@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317181941.86151-2-nnac123@linux.ibm.com>
X-ClientProxiedBy: FR3P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::7) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CH3PR11MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d675996-7e9c-47a1-05f5-08db2717bee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+tHKwlcoZT9frS+kescrRBG2BxjfDZ6yX4YhFXuIbUlwEJYN+5Wgr1BZ99I6dGXMaDU3+93BeK3ve8hWnW8SUej0T7/GsifzaFMNlJgwqy83hsa9MQd4t/+Shs4nZ2n5D/Z/CEb9zL5h5YH7dRVls3c4JUGNGLQoSoJV+ZwPtRiFHTtoiAXH+30P7XVt56UKCPy4sABicAoubtsYxBHm7qnnzpYvTc7GxbhpCWrUoF455SJgVNxWlXnQcn10LpD5ZS3HTHKYh8yP0vjJ3svMNz9jGQhD9fNwiKPRi12y6YwTk8eHaLYdkz2E2NWdZUzpj+BbK01Q9JHQRX+ew6wtja+AUTk1QwQGM1B0W9+EUg8kTETH3Qcdk9jvDuu2CL2G65HKidrth/By7Y5medZi35kPsXpmEcwAGDBSmBsh4VxRaqVDpCXZmj1oK4aIx7M2g7GKUH7LArLI75i+GRFbUn/6NLb863qo7VwMV5n9+zRK7zfjmLSGRqCh0kpmYWfh4TVjDzUWKkyHVK21rwopcebcyZk8+dznX/V8JZlb6bHZtg7DrfAvaoCyLlgY4n0qePzTIo6LYAU9whF8OlQWPn4F3PVIlABqqufUKSBmkHi+aez/m0ZIYHvFUsDA5xV9L1u5pIYPwWsZVSe+ocF0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199018)(86362001)(38100700002)(82960400001)(2906002)(41300700001)(8936002)(44832011)(5660300002)(33716001)(26005)(6512007)(9686003)(6506007)(186003)(316002)(83380400001)(6916009)(66556008)(8676002)(4326008)(6486002)(478600001)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?06WbjZX01VWd5pzX6MIcPcJPtWwOsYU87AoQHWfUL5G2mqD0mvrPLnX2zvby?=
 =?us-ascii?Q?H5aRLmOTBjvlBh35gc9UxOwBpMI8CqTlIi0KcLGyWzmcAdhABRzfNt6Zyk51?=
 =?us-ascii?Q?PF3ZdHe7shPBJx6yd0XFynLf0QKFyvhWsu4m+vZgDPCkPQUKq9WpTZvwVbvJ?=
 =?us-ascii?Q?UvboXZGz3S4iL/sypnJcFSOAXooyTEAtr87DRqr5VDGZdubwE6Go/OsF0DGy?=
 =?us-ascii?Q?AVI1aY6iRiDvZ0e4+6kSdXGihhbZ5bIxBBa9o0Z4xssu4OjXrnNXPC+90Yaz?=
 =?us-ascii?Q?JWeOx30bme65/WVsVbw8pJc1W9/8xl1TKacI9hn/apcGJQXLd2/pcf38u88o?=
 =?us-ascii?Q?f8JtrCGDhDCI1VD9h2gKtV/7/QfbMPqU8GCCvS+bboYHeJJ/x2/qdWYvtmqx?=
 =?us-ascii?Q?2EzHdS6S62U++Wm67O16/CU+nJs62CV1c0MN4GUhLrbEE9phNSxxDS6dGXNw?=
 =?us-ascii?Q?V+kbwjsSsmViVP5ubgKp0/PvWp+v0piZISIJSyQzjvnP2YjQAhF8cUEVmwFg?=
 =?us-ascii?Q?V+l9bg8JnZY5W/aLaMKCk/KbBAUeGEphmTgh3wDJ7Jn8Ro7J1GJbSjeJVtB2?=
 =?us-ascii?Q?Ow/v+Eu8/wDD3QkM1HgvEsZCKiXfhUxGh+nd9RSVZ87d9NBFHk5SHMDbd5Lb?=
 =?us-ascii?Q?dAgce5WVZ7caElAiGg1RJVEvQXSfrIFimcJ9KBaHNUnNlxw6yEDIIwe3He/e?=
 =?us-ascii?Q?aQdEem2/BnLeVrdl/3WYPT4aZd8PrZKJSTqtjSFp47oMjOrQ33xSV6CNHTR/?=
 =?us-ascii?Q?RoWmxb7mzLDXTafRLGX6cFH6rALFlKpw9wJIeVZlT09g1pMCDRv7aNyYIQHA?=
 =?us-ascii?Q?D2rslafTl3rh4vaHlAUSdu7I3tK7gPQgHbU7aAYOPMX3HAiqwBJwzNg2DT5x?=
 =?us-ascii?Q?QQXu5XHxDWLYMNEVo94GV3wA25N3cw51ljDebHs8BXe2kkA5PpO3yCHWPUP9?=
 =?us-ascii?Q?aSfmrTAsDrBTKxUYl3O7ooESVDfoNX1ePJ+pN/kGb2BwTo/jWbhSwXFMORsA?=
 =?us-ascii?Q?oSU6XJvImYemq7cO6cl5BeDbWhRUX0wlWHdQsJX9ZyhCNjyWuBzU2MD5CjiM?=
 =?us-ascii?Q?P/dGCvjGpuXzHm+q6mBgNaT5Jx/n6L0rwWcXNw8P+jGmnisVcSfV5wPjVzH5?=
 =?us-ascii?Q?QkNqzXg7UDxNC+AERBM2HYzhNlw48YFd/oMK9NGeHy6f0al1wAkg+eyr75b8?=
 =?us-ascii?Q?+3KodUeJqS+PV/1ZEJnX6cNy2wj6W4k1yPJ6Tofs3411wVaU9X6TO6WmKqqo?=
 =?us-ascii?Q?5f6z3QIujw/pWyDQ5EDMt3rJqkxx2/y6mFVjuOF/YPiXaS4Nj0K07FZ2+4BS?=
 =?us-ascii?Q?/pbUQW3NG4h+EBfvpbqN+GszFsykVHKym2jBzU7yhFN1r6tgGQ17zOSnNkZO?=
 =?us-ascii?Q?d+/m+Es4nSMmtzWWsf7TRNcqUm7nZC0aYx33b0wAMeDLxRwBOu+Ygznsn9Nj?=
 =?us-ascii?Q?uVYFNiyF92l3eK0mLIwwPDGk21/DQF17xnBq+Bdo49JxdbkEqwwZqvGeGr80?=
 =?us-ascii?Q?Nor7xKRt+HAg3ddHcPPcrbtouiRJe2H9oYoouU3pf5w5JjJ+EPcLOAa/vxeB?=
 =?us-ascii?Q?r+OO3NEZJ03ESWWX2omdp+urIWj3quqDPrF5CkFCPKz4+skF9p95bpURlmXU?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d675996-7e9c-47a1-05f5-08db2717bee5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:45:14.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7YVQs9SMZFe1yacBjF2BxSKjpBwYEFJhdxfd5U6osyMsHFxD6g9uaSeRiKLb1ermnbVEfMqyJ6/MdUcgLROAaYSKO/HUPE2Q3nX8xKQg0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7675
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:19:41PM -0500, Nick Child wrote:
> When requesting a TX queue at a given index, prevent out-of-bounds
> referencing by ensuring that the index is within the allocated number
> of queues.
> 
> If there is an out-of-bounds reference then inform the user and return
> a reference to the first tx queue instead.
> 
> Fixes: e8a0464cc950 ("netdev: Allocate multiple queues for TX.")
> Signed-off-by: Nick Child <nnac123@linux.ibm.com>
> ---
>  include/linux/netdevice.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 23b0d7eaaadd..fe88b1a7393d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2482,6 +2482,13 @@ static inline
>  struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
>  					 unsigned int index)
>  {
> +	if (unlikely(index >= dev->num_tx_queues)) {
> +		net_warn_ratelimited("%s selects TX queue %d, but number of TX queues is %d\n",
> +				     dev->name, index,
> +				     dev->num_tx_queues);
> +		return &dev->_tx[0];

Why return first queue here instead of NULL, wouldn't that confuse the
caller instead of return proper (NULL) value?

Piotr.
> +	}
> +
>  	return &dev->_tx[index];
>  }
>  
> -- 
> 2.31.1
> 
