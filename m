Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F01651570
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiLSWOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiLSWO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:14:28 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A27E41
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671488064; x=1703024064;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oqUUVdYN9kprpnImyANMEmaCB9FwvswVM88EWxcmQr0=;
  b=IUVEuPbFAa1HMmSDBLLK8ym7YLDuNyNhdJTbAFCPRMi1+FL9fj9QNvv6
   Bw0mFpxurP6mV3pjoAPdvnq+OnY+Ge8MBo7XMsPQQtx2/a6/lggNCCwZW
   5vCy+lJOdj8e10Bd/7XkMtlfL6b217Egc2DdDYiEl/W4rIeKm2H2FjYBp
   Kk3Tr7ekpVqyJz5ka5pyJKlBHLCekyYqVSQIWdBFSC749aIACAI52/EOG
   E/JN22OwyAHP0t/Ajc5YTvsbgbK/RICawNBEUDJwzd8nVa7+YA4FXc7QF
   8Ef8JGFkHhPYBT4ZilEcEnIwwcN4TqdcQjBbNq+/aMxy6IzKZJv5m9g2r
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="381686529"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="381686529"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 14:14:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="896177248"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="896177248"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2022 14:14:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 14:14:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 14:14:22 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 14:14:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M99qm08pDmiOYAyh5jDMMjWNsxy1op9E+ZlNl31/ElmxOO7o/Pw7ug7Qnvr/y7hhXuquNu2KvsuXrX4FgI7oPQ7r7/UymBYS9N1gXc755eST/DDbLEOgPtfOPo1EYkgyZEEJmT03Cpkzhz7G3YB8gbYsVSIHpOTw4wlISgZYu57geq1SY0itFiXMohahZSCM3zNr+3yiwNXvdbU7YM5Q4zzIpkwL+nSYsGfY2Q+fKAdBdyh2Wq4bMNjgPuSyArFzyk0TreF0uXjDc3bo0JqMplje65MGmPUoQqvlwpoI/f/XSWX/ICiwKs9t0rZcF6B4Uns67622gMLJTQsMJ8K2Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9j4XSfyV2e2kApw/Q1zuDP9FErZUp1CXgwEuWdewXQ=;
 b=c9Ol4lnkIaVdtPJzuQZyLrWjbLBNDZkNdZt2qNadHSN1jAa9i1jGHi4nKSI5SLPh6pqmiN2sH61NdkG4P0KNbgyoBId+QyM38U+71qkJ/rZ22qptHV2OeTuHSFsTWXbu8NvqZDG95DGShj5ML6tmd+IVFCrgNEqXp89NQbTafN9U/hbrmx1QoKkrWFYLTozx8McuHJ9KQRHl8bGS+BDaClVEDNCJq7I4b6RbC0YxXr5awqDKkUDe1tGrysoZxnA7bzTuj7/S4t5xGuDPdRkTotHhNfXqiBQUM86nC1fJnFupVzjEuSPn+JKZ6tapn+3vI2lfynrjBmq8wbO/ZknpAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB6394.namprd11.prod.outlook.com (2603:10b6:208:3ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 22:14:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 22:14:21 +0000
Message-ID: <1aa72500-79cd-810e-947c-172bbc4db513@intel.com>
Date:   Mon, 19 Dec 2022 14:14:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-6-kuba@kernel.org>
 <ac6f8ab5-3838-4686-fc20-b98b196f82c8@intel.com>
 <20221219140210.241146ea@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221219140210.241146ea@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: e97eab43-0cef-4068-0dea-08dae20e60c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2YB+1UYMno/grkqSyWX3MdsgBjUFMwW+SacKcwGcc1z9Sf2vOvODYUJ1M2+pqoZv7e8MF+/1ZaK3iWuDP3iiyQ9pWlLcFOjCXPNwRdrABOtge11CtxPAni5W2yRhk8iLXnRPOoDp2wf7JAnPJkHOLY+pRM2p4wAUisE96u5ETSdgweaLSsp6EVrAuSJc417tiiOaSupIrOt2WFI+zZGzsfc1UdHHvz65clU7Pe0Qmpdw3LtoPAzyiZ/XNQ4QIkezUpkxquhT9ouzI1/ZaHf+u2KZkUtd2OF5o8pt3okFg1YbPKS3O9SWJXli2fcSq/I9Wf5QiHW0viGUKHgO2ZK7Z5P57/P4sy7Zz1e8mD5k+NUR0znXG2ehWDM8FFZPL7uvDBNcv8VD6ar8FLd7vRc90bs1sskBI55coLtdMwZoXWbkaPzff2V13fjwoCLbLpDMqOjnIu4vRGtPqfKXlrE5d7524nHqeZ6+0/y3hLXx3gWKSwFRRbGgMLgTNlgx406LnqzFE8kygmjGo3ztBUkLWJdxgn2oOLbg0oS90eHUJQ6xvCvnX9sIWEOsCKDH6Ej+YLc0U+kticvmNou6PjYNHpxpC4Zp6C1oimyqCGKmPTrQUybGWR27+vDDE9ADESQBUquiS14TbPnunG5M+LM14i/RV0ZVpjTz5jqGUi84fyk6cW0ebwtJHMH2LHohG3Xb0hyE65WYvP/FoU+8Oxt188BnUuuXoy+ZEC8FZ06j94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(2906002)(31696002)(38100700002)(316002)(53546011)(66556008)(4326008)(66476007)(66946007)(8676002)(6486002)(6916009)(2616005)(86362001)(6506007)(36756003)(478600001)(5660300002)(83380400001)(6512007)(6666004)(26005)(8936002)(31686004)(82960400001)(41300700001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGJKcmdFM0ZUSjdMRXR4U0ZuUHRNS0VaaTlYa3liZ1htYko5M3YrdG02UzhG?=
 =?utf-8?B?WjVHNkZNcXVGTC80U2pVTlRNeElnSVlvajNGS1ZHMUZMaEs1ZlU2S2dwL3dG?=
 =?utf-8?B?eDBKYnhuMTdUMXdLK1NHY2FTcFplay94M0QyT2pZN1dsMVFXMTRtTHRWNSti?=
 =?utf-8?B?Z2h1MHFGcTJSWVZsWVpoMGdsREwySyszSlQ4SjBtdEMrVGE0TnlPMStyUjE5?=
 =?utf-8?B?SmxkSFFIdmlMRU9iYm04Z1hLdFp6d1VSL3RBaEZQZkQ0L2UrcytIRjdGTXRD?=
 =?utf-8?B?T2N2Y0hINjFDN3RqQ2tVbU9HY1ZFWlFGVzdZNEtDYXVqTHpmOE9nd0ZBQzNR?=
 =?utf-8?B?eTNteWFMM2tSZmkrcHQ0MG1JeS9LNEc1L25pWHhJUVhlYzk2cVVBT0ZPVHhQ?=
 =?utf-8?B?ZkUrcDNscWVtbGFsNkZjaWNGUEhGTWNxdXp5WEtyRFowWDBxYW9pQU5keVZ5?=
 =?utf-8?B?NFJ0Q0Y2TWxMNUxLNTdMUjZqbHNxYWUvK3g2TzlJOUsyRDQxRVplSWdMcFY1?=
 =?utf-8?B?R051OTRqNEloR01GWCtTbU56UnhLTXFvd0FBRVIwMm04L1diWG0yTGF0Zk5l?=
 =?utf-8?B?UmJLMDBjMVFTbDk2NDhLVWZUQXloMThobDQrVXdINi9VamNkSEZ3K3AwMHpH?=
 =?utf-8?B?clRmalpwZmhiZW9wWUQ1MHRUZzNpYVp3RFAvV2NjdnBOSXNDOENVcGd3MlZW?=
 =?utf-8?B?alQ2aWVvUXFwNkJ0aUZEc0ZRMzE1T1FwcGhIeDNIODJnaU5tQlcxNkhsZjNS?=
 =?utf-8?B?N1BCN25MVEV3aWdjRjlMYXZ4aDF4Zk9FL2dvZmNFTEV5VzRsbTd6anU1czV3?=
 =?utf-8?B?eWRFTXplVjZkblhXWENjQy9MNWdDVHQxeHVZTVNyWkJBRmRKcXRzbU9ITU5H?=
 =?utf-8?B?bUhzeFI4cHFIUHdKM0t5eVcxVythUkVGVUxyU1JDWmJyR2pVOXU2czhwU2Mw?=
 =?utf-8?B?M2RNK3B5Z09EWDFVeisxWFk4bHdMTUVXWFhDK0pueGpVSFlZdDhCcW5iZWdO?=
 =?utf-8?B?T0tlSWdJZDdidGcxY0NPaU5TM2ZLQWluRm0zRkxOdUpESXYyNjVHcFZmYWxY?=
 =?utf-8?B?UTVwcHZiNTJoMmRSenFEWWxWMS9UMEpBbklKbDgvQkovUzh0Wk5QOVRva1Ar?=
 =?utf-8?B?YSs3TGpPREhsZ2o5Q1NJNno1VFkrdXI4MFEyazJxWWV6WVhlcG5BV0E2RjlL?=
 =?utf-8?B?Vmh5cTEvMHo3TVVKOVEyeWMrOWVQVElITEhWRWFYc1Q3Vko0ayt3eDBsbE5J?=
 =?utf-8?B?ZmNPcG1nUEE0U3lhKzFYRkdMVWFQV04vVGtyeElQZ2FrelRuOHVZUTJCYjFD?=
 =?utf-8?B?bnNSVWRLY09obUJJdDBLNjVrYTk3YzhtRTZTZWovL09BanVzcjczeHovUW1D?=
 =?utf-8?B?d0s2NzdiQldBRnJDMEVzeldMTEQ5eDFlZDRwSm9xdGwydUxVRGFxaGFQaUMx?=
 =?utf-8?B?RmIxQzh3WHhOc0ozWFc2dzBkOS9VOGdEekYzZ1FnNS9sU0tXYzcrSzNCbG5s?=
 =?utf-8?B?dnZWMFM0MVY3dGhKbFNNdGpQV3JqSmhja2lCbDZjVjhmR2JOUXlRZkZvQVdK?=
 =?utf-8?B?bjRKcytVRWJsaURlYjVpOEY4SzdjQnBHZnA5NFVzTnF0dnpLV1JndjdNazVN?=
 =?utf-8?B?bXBFVGM4MkNQM1QvWWVmdlg3bWhZVFlKajdLQS80L1lFU1FHYkJ1QkkvbWJS?=
 =?utf-8?B?aDJHV05PWmw2VHhwNDJuNUs5SHpBSUdIREs1YmIzcnB0ZVpvcGw3N2VGSWEv?=
 =?utf-8?B?bkFGU2xGdGZVSlFNWjF5a1J1SzE1NG9QMVRWRUJkYkRKS1pOVVc0UXExaXdk?=
 =?utf-8?B?Qml6SmdlbjlSWDBCQ3NUNGVrQ3dpYm5WL0s1K25oRDdLL3FlenBpN3lOV1Q0?=
 =?utf-8?B?ZytDcUVHWEo4UDdGSkJKb0RsWlIzZGFaUUpteTBRRGRZMCtoRWZ3bmFXN0kx?=
 =?utf-8?B?dW1TeDJhNWlFTWo0YmVGQXNFc1QyeDRQVG1rMnZBODVQMEo3U1Jhc0hsMlA4?=
 =?utf-8?B?WXJhVGx2Q3RCRDBvc2lKdzVjRlp4WE1mVjNmU1dEcEdGaWhHQzFSQW04Sk9Z?=
 =?utf-8?B?SHhEL0l0a0Q5SHV0WVlFb0gwbERsWC9XODk5dU9keVpqL1ZXUCt3bWsyVGRp?=
 =?utf-8?B?Ukoxc2taM0NkWFdwbS9wY1VRTnJtLzg2MnJQbkMrVzBXcG52TFNIZUJWMzFv?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e97eab43-0cef-4068-0dea-08dae20e60c9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 22:14:20.8492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/23rj4H3J3HwbXg5zMTvvkh61iK7Hidd9OAIALyQO9MpH8NvMjwE2zACyGFXsG8lw1lQTgAZYn19vgD1oRiCElpmmQBk0HbrIUdkYJxKQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6394
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



On 12/19/2022 2:02 PM, Jakub Kicinski wrote:
> On Mon, 19 Dec 2022 09:56:26 -0800 Jacob Keller wrote:
>>> -void devlink_register(struct devlink *devlink)
>>> +int devl_register(struct devlink *devlink)
>>>  {
>>>  	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
>>> -	/* Make sure that we are in .probe() routine */
>>> +	devl_assert_locked(devlink);
>>>  
>>>  	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>>>  	devlink_notify_register(devlink);
>>> +
>>> +	return 0;  
>>
>> Any particular reason to change this to int when it doesn't have a
>> failure case yet? Future patches I assume? You don't check the
>> devl_register return value.
> 
> I was wondering if anyone would notice :)
> 

I'm fine with it, but I would expect that devlink_register would want to
report it at least?

> Returning errors from the registration helper seems natural,
> and if we don't have this ability it may impact our ability
> to extend the core in the long run.
> I was against making core functions void in the first place.
> It's a good opportunity to change back.

Sure. I think its better to be able to report an error but wanted to
make sure its actually caught or at least logged if it occurs.

We can ofcourse change the function templates again since we don't
really guarantee API stability across versions, but it is more work for
backporting in the future.
