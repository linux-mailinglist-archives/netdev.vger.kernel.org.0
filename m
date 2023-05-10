Return-Path: <netdev+bounces-1545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7221B6FE407
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86C2F1C20E06
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB82174CF;
	Wed, 10 May 2023 18:27:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1976914A81
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:27:57 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF1B2110
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683743276; x=1715279276;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wc9+K/yYlV4WisSQAVwUi+FbAlNMQ9kh7EaRuuQk2FY=;
  b=nRV5qqdbSvoJHEiCqWXkkMgg9+kL1SRM5eDkr0oKrecSANt3la3YYIY1
   zdVbPza9PyIvtZkrsFjC/B1iJCPKldc/wMwHCf19BdLoUudoedlWuQka1
   dsSqub06Mo9qvYN0TrtLMZtMeoQ8CbKlapvWK5VlOhzI2jSC9y0KS1T47
   V8S6Vb33fdQuXofj3yeF3cx4pEu73CHCas+VtfdNegdN6zYstif/O+XeC
   QRGYtBy7iajXmAwY9NpYeScPr5rYA1rOFfqTrBbpg6eyX8cM+LoBDHWvm
   KMjydigHSoTLJrzqfJQ93hUrBybDfSJ+dEr9qb3BP1zhm2EiDgoXPKF3U
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="339538795"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="339538795"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 11:27:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="730038104"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="730038104"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 10 May 2023 11:27:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 11:27:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 11:27:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 11:27:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOYyBHI0CcqWPM49Y7cfOOE+WW9c3I0MI8blSx3XaZsNRDcY27MrvcJFSza4i4IS9jyKFrtKAZzFmrPd9BE/AA2/cNPA3TEhHqaOeGyjTHbzkyoWV0F7TWBlIMy0hHcQ7iSJ2lxUo6cgxUESVOoO52NTuhpz+TZfibR8BjHBl38Yq8HKjGYmmaOOrwWv7EToXSDcSFHKbGTsgNbcmgrjUSDtpXx8ppye84Z1WUeRbVuVog5F7CGjAmIHaxNI7IRkNdsETDYXutX40FEr0cL1NhL7xCecNHHKaMhuzRUK5WBxPCotjx9kk2LQ6aNQHQfNuLUj0VLSM4fIxAP8vrojrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFKMLUVnovd8P8tA1vLO7UfMlp6q+h2VinE6Jff1VTI=;
 b=Hq8iEX4JSyuiBZG+gnuW0un8HeGpNIC3rT+yrfbQXnOt7U8dp+XoJid2RRenmUPkuuGD32sWLHdthIzMBbe/tO4RJAMTqARcX92bjtcwxq0vEeuVelQedeBiqW4JruGVjkUTcPPsMfoAlRlA070cP8d5WqjxJs9aVwIwXSpjPbDXEwfA8/fFdqNAlIkIJDu1zzvU9D6lCjS8tk1Yzkt8DFB7+7Dz4OFPIENbaZXrJ6dCDzmVpszIn4aVoYhGHJb2INp+8Idw6EB4Ey705++kQR3JExLUVPyLrayp3bX80/VCto6pd/85qSPb0I2l9PsHKzqMGlM9VqXKxMrN+w6hvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 18:27:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.018; Wed, 10 May 2023
 18:27:31 +0000
Message-ID: <88f371f0-206b-a923-7e24-5631de1e7b4d@intel.com>
Date: Wed, 10 May 2023 11:27:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [patch net 3/3] devlink: fix a deadlock with nested instances
 during namespace remove
To: Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <saeedm@nvidia.com>, <moshe@nvidia.com>
References: <20230509100939.760867-1-jiri@resnulli.us>
 <20230509202444.30436b9f@kernel.org>
Content-Language: en-US
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230509202444.30436b9f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: b33a3b98-8af5-4a40-9674-08db51843783
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ssBVPL1Clh/GDVw4FmIbfx8OmPJjPnWPmrzbeBQSxmojRage18bOB5BOXQ1eGt+E7HuI1ai1FRw48hfh2aq4msDMTpQcz44H4bYxG/mJxFxQ0VD9VuIgOke2j6h7ptPYdJmv3dzqGUmZTZfktx4/ecALqxDsFR+RnnokAu36BTt7G21dOU46o0urwWENqGfjK9zWk3pvL8XO/k4q9p7uA25DzagGZ2tPOA0de/O3VPUn9ioSnkze3bJbd9/yUAZbolES0l0DeRsTnFkFNZekKO3JAgVHpZnFTJwmMvSIfkE5UmWnd+wSayKtLVdPHS+5SLRrAgEc0jAg/Ac52DcEgCSkJO2pg/aR1/fk2KsZ7DTw/g5+dZlgJ9YgdvlEPwAtbZXyv+SeZkNXhKSLVAB2z9UVNxGeb6ORL408jxizkdzw4pTuuQo83NBAp2kY9pGLSXHMzEzKpsPyfBAOhKkU+RCiBSGxLYdFaJDcxbdnzsxB3SeLCOUM2HdApgBTAhcxQYZPCbfWrhge6M4za6Ts0h18IRpqrEGTZ6WJH8J8Np4eOwXFB5s7ltWU7ZN/URwGseppTC0pvBnwjxKN4ycUkpzGyi2PeuWREN2g9ugaQAoS0oUbG2XARxUqIGoxNC2sdDUQ3cxm42aw98Clkne4cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199021)(316002)(4326008)(66476007)(66946007)(66556008)(83380400001)(478600001)(31686004)(82960400001)(110136005)(41300700001)(2616005)(38100700002)(8936002)(8676002)(26005)(53546011)(6506007)(6512007)(86362001)(186003)(36756003)(2906002)(5660300002)(31696002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2Z5OUpXbnk1NjMzbGY3MkxPNlZGTVVRdGVKdGdaY0QrM0dvem1iMjVybjc0?=
 =?utf-8?B?bHF5bHErSmpiV09qV3BwYUU3Q0pWeUVrMzV1akM1cjcrNUYya0VRZmVYNGJJ?=
 =?utf-8?B?cDRBUnBhRmhrejlZWGpmR0VIcjlsS3dNcnViRW5UdCtXWTBhYXdTSkxPQmds?=
 =?utf-8?B?QjNPYlY0UEJsZjdITEFTN2g2ZFJCbFVVdFpkekcrL0hNMThDd0MwbDZIZFVi?=
 =?utf-8?B?WUhXcUdJV3VTY3VsSi9yTFJ0Qm1jcDQ4Z2ZRMkh4V2J3MkIwWHNqcmtnZDVo?=
 =?utf-8?B?M1lkWG5sYjVMMVdpTWoweHlWekhrb01TNy9hcEtNc0ZWVjRvdFBTTVRGQVB0?=
 =?utf-8?B?YkhTVXFxaDc5QVR2Yjd1RGRvRFE2eDZWYm5nU1pYUGkyTERRZ1RsL0l3NExD?=
 =?utf-8?B?emh5UVhucmdVYVdTOUlVS1VIV3kwNFlFdFVlaXcrcWlkcG1RWWNWSzZ0bUJm?=
 =?utf-8?B?WXhFMlpVL3JvMmtxVHV2VERFc3dJLzMzTFlPYVh0bDFWNXp3NElyWDdzZzlr?=
 =?utf-8?B?UUE3U2xLM3grbEZhVDEwS3dLWk9vOUtKbE8yRjlSaTVXb3VJTDZxUUxPTlFh?=
 =?utf-8?B?R1ZHZkE2L3RLeHJ6QmVTZERaWmIxeVRnclpET2c3UmJrTG1WZlFUTXNXSVRL?=
 =?utf-8?B?YWRBcmpwL1VjaEEwQjQzenptdDJ2MzFTbjh5Y0QvSHB4RU9ielpDSkFIeUo3?=
 =?utf-8?B?YjYwa01KaWRjVVh3b2M5bGNYZUl6b3FLeXVMNzh6V3FsVWF2bjU1a0gvb2JB?=
 =?utf-8?B?bVp1N25qUDQ2T1k0bjZLZjFNS3VkSEhiTk5NK3Nacjdhcldtb2FBeE1UdlhZ?=
 =?utf-8?B?bVFWenhZYTFWRHFSeTdodE5TT3p4cFlVdnp2QjdVZ3lmSWhKUkMyRi9CMkNP?=
 =?utf-8?B?dWFJQVNFS0RoTkxGWENkL1laRXVjNHJoOFlDNjdyUENvbjIrMGZFWC91YXBO?=
 =?utf-8?B?ZlBXZXc0cDRRYmhoTDR6bjRNNkZDb3lFeVU2VFRzQlhEUWVoWW95YzhEcTlZ?=
 =?utf-8?B?SnlUZHhVU2JHOHcyS0Yra2lyNHpKTzJmZHE1T1l4Q1NlekJncHMrZEFuYkU3?=
 =?utf-8?B?ZnNhLy8vdmJQVUxFVENmbndpN25sWjVzUlRacnFMMDkydU14dnYrUHFTQndm?=
 =?utf-8?B?Nkd3MTZ0ZkdiZHN1aHhFYmhSYlEvMmdORFdYUWo2Uy82dy9MamlmVmlBaTls?=
 =?utf-8?B?cGk0L3o4WUZXNHFuTnllUCtQY3Z6VUdXVGtJdEpJNkRrZ05CeWRvMU5RNUJX?=
 =?utf-8?B?bkN2WFNUY3hmNGhMT2hwQjZENGZyYklxRVpZb3pvamltck1pVEMwanhyYVN5?=
 =?utf-8?B?cHp4MExyMDFKT0pnWlI5Mncyai9NL2xZYlZ5YURudHRCbVorTEpYMUZ1bVNC?=
 =?utf-8?B?RnM3eVFXK2FJa3Zvd1VBM0c3RTdnM1pNSTczaEROZkF6d2hsWXRyTk85VmZI?=
 =?utf-8?B?SGlEYzZBakRlVlNkMklKSFFEMzhGcEM5TU11M21mNGJ2dWdkdmtEUmg0N2Jk?=
 =?utf-8?B?Tnc5alpEcnd0T2x5VTlYTElwZ0M3MDNocVlobnZYU004OEo1NzZMS05YcWFE?=
 =?utf-8?B?YzlMR3Zsa0FtSFlTNmlRZHJ1R2JpdDEydGpHdXJGSXB2ZlIwMEJSM2VGcTMr?=
 =?utf-8?B?dlVRTkR3MmptRTh3TXFvcWljRmF3Z3BnaWpQRTdPa2FnY3RGK1BMOEJFRGZT?=
 =?utf-8?B?Y0NjZ0pyZGhQVjAvSkJLdmxFRVRHS2lybSsrM1ZBRGFTTFdIMjIzSktQTGZk?=
 =?utf-8?B?amJlci9uV0kvbkMvTEMxTjY2UGtzUjZydjZ5bHNzQ1dNMUs5bHFpVVBpNWlI?=
 =?utf-8?B?cEtHMzFYUVhnaXBIMTBuVy9FVjh4V2RoVzUwQXlmMHJuVjZSRHZ0TGplelNk?=
 =?utf-8?B?WmNuR2lFMTNSRHVXR3Zid3dEakNqVHM1WUt2d0NDRjNtdEYxOXJDTHh3UGdQ?=
 =?utf-8?B?TWQwYVFrcjc5NnVqT2NNUGNZMW54U3VGVXFnZElyNldDNko2WFlRYVhCcDJm?=
 =?utf-8?B?eGp4U09wNld4MXRyMDFOdW4rRXc4NGZ1cENzY2QyZDhUUEFjMnhJWStNNmJy?=
 =?utf-8?B?NUk3T1V5akJ1OERrWnluNVdzODRDcFRPaTMvamQ1T3BjckF4bkpTZVRka1hr?=
 =?utf-8?B?ekQvdlQzaStYMGxydzhlcDVQdHR6cVhibE00SnJmczI1YkEwMmNkcGtLcmVo?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b33a3b98-8af5-4a40-9674-08db51843783
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 18:27:31.3814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdopqFShl9vDUcCJq3AJHaqefUyP+Hgq2oSGG0UIgCLnvS4Ma6yI7aTPELWWAJdKhr8Vp5zDNo+uuf7BDkMinN7rdsAIAV0ML3ewsNTGJaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5370
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/9/2023 8:24 PM, Jakub Kicinski wrote:
> On Tue,  9 May 2023 12:09:36 +0200 Jiri Pirko wrote:
>> The commit 565b4824c39f ("devlink: change port event netdev notifier
>> from per-net to global") changed original per-net notifier to be global
>> which fixed the issue of non-receiving events of netdev uninit if that
>> moved to a different namespace. That worked fine in -net tree.
>>
>> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
>> separate devlink instance for ethernet auxiliary device") and
>> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
>> case of PCI device suspend") were merged, a deadlock was introduced
>> when removing a namespace with devlink instance with another nested
>> instance.
>>
>> Here there is the bad flow example resulting in deadlock with mlx5:
>> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
>> devlink_pernet_pre_exit() -> devlink_reload() ->
>> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
>> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
>> mlx5e_destroy_devlink() -> devlink_free() ->
>> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
> 
> Why don't we have a single, static notifier for all of devlink?
> Why the per device/per port notifiers?
> 
> We have the devlink port pointer in struct net_device, resolving from
> a global event to the correct devlink instance is trivial.

Ok, so if I think through all the possibilities:

1. Originally we had a namespace specific notifier for each struct devlink.

2. Then we added a global notifier for all namespaces, but still had one
for each devlink.

3. Then Jiri's proposal here was a per-namespace notifier per port, but
we then we follow the namespace when the netdev changes namespaces.



But its simpler to just have a single global notifier that is setup once
for all devlinks. Then, when we get a notification, instead of looking
up the devlink instance from the notifier using container_of we look it
up through the netdev->devlink_port connection.

Ya that seems a lot simpler and requires only one notifier instead, and
wouldn't require namespace following code.

I think that makes a lot of sense.

