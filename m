Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A105368355E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjAaScy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjAaSca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:32:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A18F59E50
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675189880; x=1706725880;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yfTe0Hu36BN/OLL4hQi0XZ55KLiJeah8zQh0QbId850=;
  b=ZTrOVndszXloHjYIBMY7lrWewvmHfh1fjYN+nZg4tbVAojNQCEnhucsw
   GSA2kqeVa7OksjYp/uMiI3D79IK9C+x1se7VqRRi4stJbdLjS7A03k0TT
   KnL3755H6KyVnhomUgvHFeTzfs70ONF3Qd6t55pq0MlWkxfnCtwziJMMP
   +7iUf2Z2XZTui41M8rTuCj3DCMa3CilNHZGyVZlUFNsn+R27iiS3VaxX2
   ktiEfCpcTM51MijHvcMBv2Tk82YK+B20aqKct8yt6yi4z8u9fR7pIa/zS
   yoqlQc0vk7T7GJHcFKr37keqTz1rOMedMSJy1nBB/EovCPBmrqZ6dCsTl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="311540555"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="311540555"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 10:31:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="614557163"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="614557163"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 31 Jan 2023 10:31:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 10:31:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 10:31:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 10:31:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJmyAojTMpg8UzaQG9XNJiZcWH+yBkVd1j/LyMz1oa/twDnEeETnpU7RrtNXo3L2m3n2yC344bfpSnVO4YK68EXFRCVSHoeCYvl+wbpcXV8TPqX0uuLs1Gmr09IMduzXaMBxzQTqMG9+jfnnLXJo/Qy9MTj0Hk6eCeryWaAfbpaVZ52zK14tGXRkI/9hZiHJ4hA+tVxMCrSbhGaLDzbgcwH2S2BHNOc2PGpssU6eX+vsgenxuSQ4XpIUrU3lfNFSof9HfYDvqDm0I4LwegxoSNxrGDdlYKxHzenOCjMlgUKnEmxaH+KI7DCDG0N2veZzhAWRSiia68jjdsP1VNf2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHeRkRzSkrgW8GzWuG+KGmXUgsUoLTD5k2yhnGeesqM=;
 b=GUfMYGkjEdOt4Vu4nJkYuwtRVoASUpBz6vz/lV2dE6ljOtqkdcLv2dTBOEo3mPYAEam+kaYhx+KNUeMFSA2nz+du+767LwIdmsMpzUPihCM9hgG+LQEERQ8fx0AKClLZoG3bfq30V8rsMAlilclkgnewBl5fT7h5TFKu7Z+8f7dy3B3egttFqvPVnfUa4RUPUPz5aQgfRjNgaFTOINl+KleqwXnIIuyvdQCybAx/4mc0mmI4hxwjUJZy0It2BNUmGw2kYdWC7rKGgEVU+CHt53kpp/XdT3xgzPmvyknHAWKCuirn6eh6eftbudaQCy2pvCDPrYN+gLHIYxx9WIWurw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6335.namprd11.prod.outlook.com (2603:10b6:8:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 18:31:10 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 18:31:10 +0000
Message-ID: <6fcff035-ef18-b8ef-3424-fcb30ad4511e@intel.com>
Date:   Tue, 31 Jan 2023 10:31:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next 1/3] devlink: rename
 devlink_nl_instance_iter_dump() to "dumpit"
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <20230131090613.2131740-2-jiri@resnulli.us>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230131090613.2131740-2-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0153.namprd03.prod.outlook.com
 (2603:10b6:a03:338::8) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: 8431a13f-1751-4a59-5afc-08db03b95332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3DsYqUwST023F8YuTZ+Yci4Se3wlqcRfVRVslXUwneHWQOIZ9zBx9TjaETWfGnBNr5Iva8de9ZY2YYKibxtzbD0PfHTgnZTcDHJv5f/fx3z838IHv9ARcBtfIMMUyflgR83kJVLolgfZEeo+Qnt80Lfhg+Ql4HXtbnzLgl6oHkastyk3uKrFIvBoo0w53HslBGiI+9+DH0Yy+6yQfAcyG2b0gRANMtX1fK8Mu2gP2bnYnBUqJMvqvhnEbetnvJeuGucENLX3+UeOg02c7tHktLTQK7CN2NgXUzVRRG5H3rGtllaQfgJA8L/mG90eHboBibpCE04JzX3YbOf8sgJYISZMisdD4+gK7I2O/l21xf5GFEX5FxAoWzi4r/pqnvbgLH4UdsyWulrHtuqmiDJJ7c+p2TLs1sxV5IqgEp41oqRdCN5fMC3pMZw08Za1r2yRVi3VTOeSJAGNvxN+p/udeRFusWud4kuqHCdub2YwakT7B2FX/RNrd/s45JNXy0uI07hwgq9x84aXvFOnv/y18Y7pBwt4gmCcQBeN6umBQzAtpO4rRduv7JdLdyRM6cxemLZITpKRLSJy0Zk6mWaAVAzIYw1bodpzgXkhKvTUlUZZTKnPfJuGINL6FpHumNmpVVnTvKxRRv/IxK0tgJdGUvg4vLfWP63B9mbumFfIheLa38HYcNY2SiQv9Zau2OQIj2o1sMVQNeOKzmH3HaT3Lwvt1CrNUMGGYzj5NmMoP2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199018)(8936002)(31696002)(41300700001)(86362001)(83380400001)(82960400001)(6486002)(4326008)(2616005)(66476007)(38100700002)(66946007)(8676002)(316002)(66556008)(186003)(53546011)(6512007)(36756003)(26005)(478600001)(5660300002)(6506007)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?am1GV1hOSmFZakNvRDlZOFU4enUyN2gzRnBWRUxVY01JT0RwNHl5Ykw2U2xD?=
 =?utf-8?B?Z3ZpbXFRV3JLSjAxa0xrMTRUZlU3czYvZGN3bnBjN21nZGUxUDBDSHlzSnpt?=
 =?utf-8?B?R3dJZ3poeGxqQTh5dllHRFdpRlh1L1d2ZXRSY2M1dXVVTTVQWUVBOGlRMWhB?=
 =?utf-8?B?aHBSSkZSWDRTN0F3VFdiTkNtZEV3K3k3Mml2dmJxUmZqNFUzTWgra1hWNUZI?=
 =?utf-8?B?SnVDNnI2VXR5cUdGRDAwR1ZJcjRyKzFSQkIydmdTZGlDYTV4UTdPSHN5UHBY?=
 =?utf-8?B?Q3FjaE0xc2ExUDRmbzRacElWY1BJY0ZybXd2Qllsc21RbW9KcXdQWWh4QWg3?=
 =?utf-8?B?NGZYUUxMbkxFRkx0UVBCeDl1WlRhRG9kcTdQRUxCYWJYOHRmK2t5bWRBN0pT?=
 =?utf-8?B?eGNHQWdYL1Nta0llbHlXOWNzSUtUSU5iSDJLbWk4bWpOWlRFaG16bEgwWTZD?=
 =?utf-8?B?VS9vYk4zVnllS3NGM2I0ZmQ2VUh2UGtzUWZVbEl1U2svRHFWOVcxdURRekFo?=
 =?utf-8?B?SGVBZmxKbGpRM0hnWnozS3pibTRCYW9PWWlJcFJ1UERPSXlYb1dDbHZhaFhW?=
 =?utf-8?B?N3d4cytVTGQrU2JVYU1ydGlkUFpTTUZyYVFNOWUwRmJzR2U4TDRDNGxPZWpO?=
 =?utf-8?B?ajNvSGptUzdQKzA0Sjc2a0FDTUo0NEs0TEdqeGE2UzBwakRNZUl4RTFqbDhW?=
 =?utf-8?B?Z0FjSk9vZ1Y2NHdzQ2hyU2Q5aVF2aTl1NGhLeDArTHpOcC9nN0x5ZFl4bUZm?=
 =?utf-8?B?cytweit1c1JqTlppVkI4OUdNemJmS3RQbjZDcnA4cHJ3dnRBYU14c0poTkl4?=
 =?utf-8?B?MjJTOGRSYkgyZEYxZkZjS0syajd3TWlra1RsTUoralUxT1hkTTdoNjN1TS9V?=
 =?utf-8?B?WlRqTTMzM1ZLUVBxZFRTWGtKbTRJK2prV2p4WjRMSUQrQ3hZQklxS2xMZGhL?=
 =?utf-8?B?WENaQUZaRzQrei9uQ0FlZ3EyVURYMWpJSHFWUFZGMG8xdm5hMjFUYk9LM1JQ?=
 =?utf-8?B?ckdrOHc0QzIwZXNpaUxaTmpJdlN2eEFab0F2UWZpOG9RdXNxUDVBYVA5cm1u?=
 =?utf-8?B?Z1QwekVDWWpSLzFsQ2hVQi8rRGlMMFJZQ0Joa0tlQU1pWWhqdU0xVWpTdTdJ?=
 =?utf-8?B?ZCszanJQeWtJeUNROXlwbmY5WS9EZ2VDSzFpM3lrdmZWVGxqTkhUVXhPelZM?=
 =?utf-8?B?VVNaeWN0VjZoY2hLbmZlZ2ZaSnlYVStWb2djRE1lWjVLSWZvbjJ1T09VSmk2?=
 =?utf-8?B?c1NQNGFwVzMrOEQ1amNsU0FKSndMSURTemtNbnNCRWFhZldEa0RxYXEzanJR?=
 =?utf-8?B?UDhQMWIzZ3puckV3NEIzK3NudnN5VWJTTmwwMG93amJrcXVpSGZ2WVJjb2V1?=
 =?utf-8?B?VVZpN0Q3a1pFMW5VQUdJdU5rYmhnRGNpVDZ4aGhWM0MwLys3eURuWHpTVktr?=
 =?utf-8?B?M3hZakNNaCtYNmUzTDNITkdRWldrejk4Z1MxcFBneFhSanpLSXZSQjVtUW5N?=
 =?utf-8?B?OVUzUjQwZWx6dS9sQmUyTm9mOTY2VWNiU2pRc3hacFVOTXplbkI1Qkxkdzds?=
 =?utf-8?B?MUlVaDVGUWR6MFFjdTE5d3ZvQmZVajZSSG5ZN3VIY1c2cDFjemt0a0UvVTUw?=
 =?utf-8?B?cVFjQk9CUk5UMGFRdmFMZnNBR3hqdlhwcHdkZUlMR09SblptWjBFakdZMXFJ?=
 =?utf-8?B?TG9MMjZEQ2diU2QxL0NUaVh3clR3OWFUeFN2aEg0NlRWOTVKeTE5aDBNOFpv?=
 =?utf-8?B?OHVMMWJ1RUtpTmFDdlhlNU9oUTdIRnFlb0xSVDFwREoyZmY0QTEwazVyRUNj?=
 =?utf-8?B?SDZEOGdMQUNTZ1R2M0pia0UzcFZGL2Nna09CVUlLYWFXb2xEK3QwdDBiZzRo?=
 =?utf-8?B?NFNyUE15R2JmeHhTWVlHODFFWXFNY2tTZDI4ejNDMEUxZGtrRndBL3JIU0RP?=
 =?utf-8?B?L2dPdWpmMlh3WEZQZmZWNDlHdmI2VTQ5Mms3RFBnMGh3U21BV0VsTE03L2do?=
 =?utf-8?B?YUlnZS9iTmdyU09XdVlZRzdBVVNxaDNHaFI0NExXeXlqLzZtajNtM2doZHNj?=
 =?utf-8?B?V3lxUzh6bytpWlVvczN5YlhpL0ZYZHV3MGxZV2UvZVYwWnVHL1REbXVOUGlD?=
 =?utf-8?B?bXVNWWJ3TkhtR3pOTHViRzZiU3dma3lBcmVtYjFOZXlrSng4TXZYNVVhVWM1?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8431a13f-1751-4a59-5afc-08db03b95332
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 18:31:10.5667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogkN4bht36eZ/VXM8kH0vib4dVCKd59iLnvgFD+IX13o3eWAwccgMbMvQSvqv/xU08Y/H6LvXkbWScNemGdar4XyvXBhGnPOhtRyhdLSFR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/2023 1:06 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> To have the name of the function consistent with the struct cb name,
> rename devlink_nl_instance_iter_dump() to
> devlink_nl_instance_iter_dumpit().
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---

It's a few extra characters, but I think i prefer seeing dumpit in the
name vs dump. I understand that the use of "it" comes from the fact that
.do is invalid. However, being consistent seems better to me here.
Easier to search for dumpit as well vs dump.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

>  net/devlink/devl_internal.h |  4 ++--
>  net/devlink/leftover.c      | 32 ++++++++++++++++----------------
>  net/devlink/netlink.c       |  4 ++--
>  3 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index ba161de4120e..dd4366c68b96 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -128,8 +128,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs);
>  void devlink_notify_unregister(struct devlink *devlink);
>  void devlink_notify_register(struct devlink *devlink);
>  
> -int devlink_nl_instance_iter_dump(struct sk_buff *msg,
> -				  struct netlink_callback *cb);
> +int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
> +				    struct netlink_callback *cb);
>  
>  static inline struct devlink_nl_dump_state *
>  devlink_dump_state(struct netlink_callback *cb)
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 92210587d349..1461eec423ff 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -8898,14 +8898,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
>  		.cmd = DEVLINK_CMD_PORT_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_port_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
>  		/* can be retrieved by unprivileged users */
>  	},
> @@ -8919,7 +8919,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  	{
>  		.cmd = DEVLINK_CMD_RATE_GET,
>  		.doit = devlink_nl_cmd_rate_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>  		/* can be retrieved by unprivileged users */
>  	},
> @@ -8967,7 +8967,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  	{
>  		.cmd = DEVLINK_CMD_LINECARD_GET,
>  		.doit = devlink_nl_cmd_linecard_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
>  		/* can be retrieved by unprivileged users */
>  	},
> @@ -8981,14 +8981,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_SB_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_sb_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
>  		.cmd = DEVLINK_CMD_SB_POOL_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_sb_pool_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
> @@ -9001,7 +9001,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_SB_PORT_POOL_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_sb_port_pool_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
>  		/* can be retrieved by unprivileged users */
>  	},
> @@ -9016,7 +9016,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_SB_TC_POOL_BIND_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_sb_tc_pool_bind_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
>  		/* can be retrieved by unprivileged users */
>  	},
> @@ -9097,7 +9097,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_PARAM_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_param_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
> @@ -9125,7 +9125,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_REGION_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_region_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.flags = GENL_ADMIN_PERM,
>  	},
>  	{
> @@ -9151,14 +9151,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  		.cmd = DEVLINK_CMD_INFO_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_info_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
>  		.cmd = DEVLINK_CMD_HEALTH_REPORTER_GET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>  		.doit = devlink_nl_cmd_health_reporter_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
>  		/* can be retrieved by unprivileged users */
>  	},
> @@ -9213,7 +9213,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  	{
>  		.cmd = DEVLINK_CMD_TRAP_GET,
>  		.doit = devlink_nl_cmd_trap_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
> @@ -9224,7 +9224,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  	{
>  		.cmd = DEVLINK_CMD_TRAP_GROUP_GET,
>  		.doit = devlink_nl_cmd_trap_group_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
> @@ -9235,7 +9235,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  	{
>  		.cmd = DEVLINK_CMD_TRAP_POLICER_GET,
>  		.doit = devlink_nl_cmd_trap_policer_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
> @@ -9246,7 +9246,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>  	{
>  		.cmd = DEVLINK_CMD_SELFTESTS_GET,
>  		.doit = devlink_nl_cmd_selftests_get_doit,
> -		.dumpit = devlink_nl_instance_iter_dump,
> +		.dumpit = devlink_nl_instance_iter_dumpit,
>  		/* can be retrieved by unprivileged users */
>  	},
>  	{
> diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
> index 3f44633af01c..11666edf5cd2 100644
> --- a/net/devlink/netlink.c
> +++ b/net/devlink/netlink.c
> @@ -196,8 +196,8 @@ static const struct devlink_gen_cmd *devl_gen_cmds[] = {
>  	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_gen_selftests,
>  };
>  
> -int devlink_nl_instance_iter_dump(struct sk_buff *msg,
> -				  struct netlink_callback *cb)
> +int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
> +				    struct netlink_callback *cb)
>  {
>  	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>  	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
