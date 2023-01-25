Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D4E67B914
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbjAYSOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAYSOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:14:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1A8360B2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674670457; x=1706206457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8qYmZGzaYykCY1+7FMAXuHZjQoM+sDYldQZIfn3By18=;
  b=ltZBsP0MuvtTX5C/os79giw4+iI7m5zSXqBXvwaL8Sdy4ysuwOW4wA5d
   bKixIh99WnMyKWM7IISHI5T06oFdUaflrd7rPnZeNa+vwooI1goQ0CfIZ
   OF8NSjrG90CY2OsiLFBFoWW+8Z7gZhL5iK2PVCc+PNAirqySx3b7RcuV4
   yzppov5jCL0vC216+s6nsyxSMoftnWZ4Jx4oCXem9FerAyH80mu6H+CdZ
   GgerWFbo2DjK8Y7cyAhg0qDb6h3oAEMDTvo1B1VWa7hnZMcCBPJ0m8JGc
   24PxJDmfu0NFKHvrBtt9Q7LuhKIrqIE2vDCOuKT9H0j9WNZVFAO4VM4Rv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="314537379"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="314537379"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 10:13:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="693056023"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="693056023"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2023 10:13:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 10:13:56 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 25 Jan 2023 10:13:56 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 25 Jan 2023 10:13:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BadPGQPBymzn5uhQagG8VM3w9NRlQVE8Y87ivG5k49AW1ofhM0wOyoogAC6IOo2iV2Yu2bDo9DHZhP399unLFnfSNQ6bFaVqxWT9BZccfapbMlnR1ww9cyC0TvDvTv2g+kRwwTIBvWCo+hjmL381kfJTjHqD+NBT+cu2oyjRS7AXl1t6tmjWmV48xPadFrlDgP23JhVd0WOpijQdzsxtwbgvVNivgk3yWEiFhazqEpZvPzJXsXS9sxx3IzwhNd2+T4pJ4NHogRyDDtvC+pW2ch85aPrQBpq5Y7aH26TFfEZ5e4+iEPVJv9nfYswsgEtz3bchl60ooRqQESIl/aPHEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3pJa3H425debB6K0rxdkQKzYDQTzfUeNK7y5KASr3M=;
 b=kDxbq6GOsJTtTk5/n7xMRM6FEXF6Xg/f5q5SS3iOuxBq+018Iq+5cUgSLVFk+/7YR4SJn2AxocSgdQVP6eYhI05zPbXG4PwJe83vMyx2JSJv7hAzsDO86xxsPWBYL1UOG/ftOfklhC/Cqxxg5pIBTR1FADlytnifv2Xmvkz3XvCQ04+PKgwPbd9sI+GsDYQgtTnCVDJ+STYdZ4XThOwucTx6WL74CtE6yd0e8HPWLgcE2xFlI2xo0OTdEVVwzLbZ5GRkB60+hjClSzGli7TYmPqPwoTzKzhjh4HcuM9aWKkJg4oTYUtawPjwNzD3wxO+xLgNXseYrhbbIaT3xec9bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB6845.namprd11.prod.outlook.com (2603:10b6:806:29f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 18:13:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 18:13:54 +0000
Message-ID: <22ddf616-4df0-c558-2b38-43da1919040b@intel.com>
Date:   Wed, 25 Jan 2023 10:13:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next 00/12] devlink: Cleanup params usage
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <aelior@marvell.com>,
        <manishc@marvell.com>, <gal@nvidia.com>,
        <yinjun.zhang@corigine.com>, <fei.qin@corigine.com>,
        <Niklas.Cassel@wdc.com>
References: <20230125141412.1592256-1-jiri@resnulli.us>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:930:1c::27) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB6845:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c813d58-ecdf-4590-3c70-08dafeffeb3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxYGnj6FQu8J6dy6dlW/Yh35gqqqzdVcwkbAsr0EujxlUN3SgTUgVO62zJZTrsLwlypS4fsB/aDqtPMNDC5TkssgSmxVRXk5hSqgVxTZzQkjZZ+jt4gwofr0AntJ1VcrpQpFhOBIUf4nwrpaQ2bXU/2dkr8q1V4qbSG6wd96+L9P9qJ5Q97QVQpoUzzfFCRyW082Z1dLdYtDCpC+uvqcgAEmrzF2fySRknhl7GVva+O+elNcm2pwSoEXIyBgzOLAntX/qa55swQnbVX+kMgrr4r/8V7HwRhQa2E6X2OFjD/eiZ3o38OtMIAjpYmSiupFMjnTtDut+UwZ6YH7a4HjRyr/i9LENJ1TWwEKbR5e3dPFeJuF5rJg5ywhVtqbFl2PI6ERqwpTv8bEJrp0rtmB0mTYAsMk+MFy/Kk2Ibg7KeXRrCpRhWVJrY3/UZCfA063+8xHWz9rS7CE90j7CkgNkbpdSRR7hm0EzH/lEJpPTolvU4mKrngShefpI0AnneZEWyzMXOYy1HDuzTFuUHpRK/mxK4dUIEQpIHgnznjaAhHE9BXuxNZHFmjWlPHv2jJ30zZYyd+7AaZ24KoqwX1ITemVcOcqRpLj9InDqkvQEhRq7HPoa2k7jp3BqYuWeJe95OAYCrE+SUyRkq+TD5E+SscBBgTFZzz9Q47mSWC2ovTTXHX1LLYhrTrrJ87PceRifgsGc6nZ7n37aBx7rg9S+OW2NNBc6yojS64qPOeouIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(38100700002)(82960400001)(5660300002)(86362001)(36756003)(31696002)(8676002)(2906002)(41300700001)(7416002)(66476007)(66556008)(4326008)(66946007)(2616005)(6506007)(83380400001)(6486002)(478600001)(53546011)(6512007)(26005)(186003)(316002)(6666004)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDNaMzc1MjVYVExWSGw5bHVGVWdZVG9mS0s4OXllR0xUZnVlMjc0WXhldXY1?=
 =?utf-8?B?dlQ1VjlxR3pYUWxiamI2cUMyWkRTT0ZXMFczR0phOTBtVHBWZ0dCWlVrVEti?=
 =?utf-8?B?U1NNeVNtNmMxWnFHcUJrdm9iUlFNMzZwaDNaM1pJYVE4M0RHRUFoVEx2c1Vj?=
 =?utf-8?B?L3liWTh2Ykt4K2Iya2tGS3gxN21VZXd6TmlCRVBqWUowanQzcHp4ZFQ0TUdH?=
 =?utf-8?B?RElxNEN6SHFRcTJBOWxTendCRDE4WjU0amh5ejRSOTliSy8yYkFmZkxLRkVr?=
 =?utf-8?B?ZUN6eFcxOERLWDAyamd5emV1bzlxVVNBYVVuRFU0U3RpQ2tqY25xUlJ0cEZy?=
 =?utf-8?B?RDVnR3FBNVNBeHVVZVh6bXFBV2pFUnJPaElYS21XNEU4STl2NnBrbDlUaC94?=
 =?utf-8?B?YlE2djgwQXJ5d3F5SGZSYndqSG1LUkI2OXVoWlVYRUx3N0tTTmVwcXRMMFMz?=
 =?utf-8?B?MjgwaVlJTi9OSm00STV1b09MNTEzTnBueVRPeG9ObW5VSTVUUDN0aU05Y1g5?=
 =?utf-8?B?dEpBSVpMRlorbk5kZUQ3bDgyYTdHdHZHajVIZ3FkRThIVWxIYm1oL3NYTU5Z?=
 =?utf-8?B?cWRqTmtyN2pjc0xRNnhxOHg2SlVoVTVUQnNvQkFlU25CbmN5ZnVKT0kzQk9G?=
 =?utf-8?B?STBCQ3pOUFBQTjdndGJmVUFXcXJHek5Mc2FRK1hzTzluNnh1dkUwL0V3bGxR?=
 =?utf-8?B?OVdlMDJqYzIrNjRDdzN0ZzJVMFM4S29Tc0lIREZnbG95UDZiOUJWMHVyTXFT?=
 =?utf-8?B?bVRpM0JkNlQwY2oyQ1d1Y0phNUx3VVFNMmtRNkVUWjV2TVhVTklrVDFXc0hP?=
 =?utf-8?B?N3JCcHpUR2l4VTZlQzh4TWd5MzhHN05IYlFqUjhjSS8rai9pZW5MbU03RjhW?=
 =?utf-8?B?TTdPOEFpRmR5MEtpOXE4anNENk4rMUdFakxkYTFDQmVCcFZ6SnV0VHo2RkZm?=
 =?utf-8?B?ajZtRzF4SjR2OHlnV3E0K2dyM2VMQ1FiSnNJbFpHN2dWVk45MWNLR0dDbmM0?=
 =?utf-8?B?NGJUUjJiYWpURWFESFl2SitPcCtENXFwOE1yc210QWZDRHlKZjBXOG4wMFV1?=
 =?utf-8?B?TkVmZk5aQXE0L3B4aHRobFk5OFRUM0owb0s3bk5HZEpBV3ZwL0xXOEpaQThU?=
 =?utf-8?B?QmVDQ2Z4QTFuY0J5c2poRlY0TDVOSmxtTEhrYm83aW44eG5LK2NBc1IxZjRB?=
 =?utf-8?B?WlREbXAxYmRGZUo5VTNuanFYYXJzRFR0aTluV3BBL2g5dmk1TXJTb05pWm1M?=
 =?utf-8?B?Y1pmZkR1cmJ3YW5OY3JVd3NvbTBsYXJnbWRvOXRhZ1ZXVHRqakVBa2treDZR?=
 =?utf-8?B?YUJzZlpxYmFDN1VEd0dLTUQ3TFV1Y21vU01uM3cxUnl1OHZYaGE1ckh2eVpT?=
 =?utf-8?B?TVRDOUQ2d0U1c3FmUDZHTXUwRE15T0lJbHhBQkc0eXVuWTBXcXVQSnI2dkJo?=
 =?utf-8?B?K3IxOXZwSXhWRUZGTnY0SHY5WkFwQXZwNWRJRERXMVdGc3FqTFRLb2hYS0pY?=
 =?utf-8?B?V3N4WlYvS05obGY5Q21raXlZeWU4SDhNU1diOXluQlJFUUVqMy92OWpiUUxi?=
 =?utf-8?B?TTU4dXN4bGhONXlKNlA0QVhmWlFPYVY4Y29RT2ZTRkNqR3Y3TVR4NjVNWUQ0?=
 =?utf-8?B?K1hkY1FqYXV6aTdhVmY2TkRrK3FHV0RaTy9jNHNnckhJZjRIcXlGcHlaNm90?=
 =?utf-8?B?cnFjUnBjd29KRzZmTm1ZRnNxaWdUeVB1WlIwbVZjSWVXN0pscXBRUTlZMXQ0?=
 =?utf-8?B?MkkyWkFPT3pnRFlsYzRybFZNL2NqaEdUd2RjeTJsd3hrSTV4VlY1MVVZa3pm?=
 =?utf-8?B?U0l0ZmQ5Q1ZIMk1pR3JQY3ZWbnBsUmh1emNmSndNdVhCY3pBcWMyT2RibTJa?=
 =?utf-8?B?alhoSTFIYmVub0ZrMEJTMFd3M3dLWis5cG90T0QrWFBSdTNhKzZSWkk4dmY5?=
 =?utf-8?B?OW5VTzlqUFVDbUVQNVNrTGM1ZUNzNEsvYW1ySXlYdis5YVVCZDZsT2xaVnl1?=
 =?utf-8?B?NjBqUTcwOHFwSkI2QmE1YUZYcGNDRnpFZS9DVVhldEFsQWF2QzJJUEpPRlF6?=
 =?utf-8?B?b2lpdndwVzdZSmliSHNiLzJyaWN5VFlWaWVtdjZrd21DRHZydHd3eHZWaHlT?=
 =?utf-8?B?aTJSV0c4a3FtRkVqbmtMNXI2ZkdMQkdTWktVbGZrbHROVzNvbWNwbTFQeFNz?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c813d58-ecdf-4590-3c70-08dafeffeb3f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 18:13:54.6235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qylDLPAX51q5ms1EqRFMFjWTRvfehZu+WWhU3z51cg/gqHeyqKjyoSObRy5Y6tQlrkYtsD+S15lYZ9PwB6xTVsvuT5LTguX3UmiwkSI8Cnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6845
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2023 6:14 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset takes care of small cleanup of devlink params usage.
> Some of the patches (first 2/3) are cosmetic, but I would like to
> point couple of interesting ones:
> 

The cleanups are good!

> Patch 9 is the main one of this set and introduces devlink instance
> locking for params, similar to other devlink objects. That allows params
> to be registered/unregistered when devlink instance is registered.
> 

Makes sense.

> Patches 10-12 change mlx5 code to register non-driverinit params in the
> code they are related to, and thanks to patch 8 this might be when
> devlink instance is registered - for example during devlink reload.
> 

I like the cleanup/organization this allows by moving the parameter
registration closer to the code that parameter integrates with.

I read through the series and everything looks ok to me. Thanks for
cleaning up the ice driver!

The whole series is:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Jiri Pirko (12):
>   net/mlx5: Change devlink param register/unregister function names
>   net/mlx5: Covert devlink params registration to use
>     devlink_params_register/unregister()
>   devlink: make devlink_param_register/unregister static
>   devlink: don't work with possible NULL pointer in
>     devlink_param_unregister()
>   ice: remove pointless calls to devlink_param_driverinit_value_set()
>   qed: remove pointless call to devlink_param_driverinit_value_set()
>   devlink: make devlink_param_driverinit_value_set() return void
>   devlink: put couple of WARN_ONs in
>     devlink_param_driverinit_value_get()
>   devlink: protect devlink param list by instance lock
>   net/mlx5: Move fw reset devlink param to fw reset code
>   net/mlx5: Move flow steering devlink param to flow steering code
>   net/mlx5: Move eswitch port metadata devlink param to flow eswitch
>     code
> 
>  drivers/net/ethernet/intel/ice/ice_devlink.c  |  20 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  80 ++---
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c |  18 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c | 283 +++++-------------
>  .../net/ethernet/mellanox/mlx5/core/devlink.h |   4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  12 +-
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c |  10 +-
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +-
>  .../mellanox/mlx5/core/eswitch_offloads.c     |  92 +++++-
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c |  84 +++++-
>  .../ethernet/mellanox/mlx5/core/fw_reset.c    |  44 ++-
>  .../ethernet/mellanox/mlx5/core/fw_reset.h    |   2 -
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  22 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
>  .../ethernet/netronome/nfp/devlink_param.c    |   8 +-
>  .../net/ethernet/netronome/nfp/nfp_net_main.c |   7 +-
>  drivers/net/ethernet/qlogic/qed/qed_devlink.c |   6 -
>  drivers/net/netdevsim/dev.c                   |  36 +--
>  include/net/devlink.h                         |  20 +-
>  net/devlink/leftover.c                        | 185 ++++++------
>  21 files changed, 521 insertions(+), 450 deletions(-)
> 
