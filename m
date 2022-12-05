Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E106424DE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiLEIlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiLEIlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:41:36 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F53A17069
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670229696; x=1701765696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bVSXW/35NS7KPyqRSSE+Mz3VoYkD6dc6dLGUM7FaMxE=;
  b=MrGHhNhPubv+cH2Vd0iJyEhNtext86XmTVDkCMzGd6peVWNu3OpYFOl/
   6AxHaTdFeOsCKfObvyBFmb30FWK0jhb53FLZszfnFfkhhyH+DnXxQjbKe
   l0VGSioYZhSxeh1xgRbatPF0TEcSz2Awv+T8cHJwc5DHtIAw+FZRBCvhp
   FNQhD3Gha6gQltYAxNNEKDyAUnjNPdfFRn45Zqg13ChHer25cQ0lYRkmi
   +961cqjZyaYrCQwqCWAuQ3mpKpgvMYSW/9INjxxN8EdCYM556O62SeN5Q
   kR1OL3JI6M2h6YWb/nyzgSbsYnnbjyY4mqAaNs/ht2uTe2mOgW7YaZPfU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="380589878"
X-IronPort-AV: E=Sophos;i="5.96,218,1665471600"; 
   d="scan'208";a="380589878"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 00:41:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="645743689"
X-IronPort-AV: E=Sophos;i="5.96,218,1665471600"; 
   d="scan'208";a="645743689"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 05 Dec 2022 00:41:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 00:41:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 00:41:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 5 Dec 2022 00:41:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 5 Dec 2022 00:41:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFvuYX5/gZtru/jKOzEwwrkt4OdDNDrDScIWiRg1jPhfHIf56SiCHWELHH30LFlhKzDd0YoL000tVDGxXbom/YI3Y0Az3zzId9QhHeLgLGxdUw9/Vs6mGJDFkFibinuJmF2DEKEUvyGKY3MRcPy+0Ndv2yv8aXXDLBpiy1VuCJrRDXKpQplEplGWdyymV+i9ZK0J4zKPFuT+1KiYZuls7RmaHnBR5GcfleaXGu5LPz38VsnARTnOOwoxevGtA035V3CbSZP49IyKZ0MyKjS+2giVzfa215Wz/qJFzNrM/nWXOuUFfMqMpbx/yDchCpCt45kyCnIK+G2/4uEiZ3FcLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sa5UGTpZYhB3TF987W9MFtooW2YquzHnuSqJicDJS40=;
 b=QlQRrRGumiLys1nNJXKfibBBW3EzeLrgb5qsGQ2lqSn2KFKZ0sPU7ZQFd3xqgyEumj/hIBoyyndBbUIrfbPSfjBBveT9l0jhuF9oOekYsZtD+1YhU6DkGEvs6kVphIMJav0PUbLLC0Cn1mwwKI3CaV7yzjtDdg7G3UUbKrcQGoBWkw62R2Y0h0XkSng4R63R/q3FvyLTejGI7dqpqU61y/D6Vl5EznL4zBfEKeCge1PHGtX5WrP7QA9TSezgaebCTXemddeb1hAsG49ga2DFlqjyVzh4+BUWJ9II8djkNiw2evVlz2J85cgPZ8nkppjpJdILVF3psUyVRsPQKht5Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by IA1PR11MB6538.namprd11.prod.outlook.com (2603:10b6:208:3a2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 08:41:31 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::57ba:a303:f12f:95e9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::57ba:a303:f12f:95e9%3]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 08:41:26 +0000
Message-ID: <24bca169-1f7b-4034-9893-5cd1f1c0ad1b@intel.com>
Date:   Mon, 5 Dec 2022 09:41:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next v2 0/4] Implement new netlink attributes for
 devlink-rate in iproute2
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <przemyslaw.kitszel@intel.com>, <jiri@resnulli.us>,
        <wojciech.drewek@intel.com>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
References: <20221201102626.56390-1-michal.wilczynski@intel.com>
 <20221201085330.5c6cb642@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221201085330.5c6cb642@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:207:1::19) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|IA1PR11MB6538:EE_
X-MS-Office365-Filtering-Correlation-Id: afdc1a9e-8b58-42f7-9eaa-08dad69c7ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LDWfCgopAshaCCKauPHUzAMLUqWt1Guc8FZsRiG4NMQoMTgWeB3naP9IViC3U/vT7iQ8Oc/P7HacQ78j0JLg29Ppha113dSlsXwuG649g8syBxpRx5leg4AGIr3tWSjjBZjODwuogCH6FgMua5vxB29t/3FJOZpN+I0Nw6Y1Mk/2OkrukNc6HIhyPKOjSaXyA1ZtnKfo2Gt0fGQE98yETf/xYrGI9y0tOUVJV/iGrTk5L52r1eua4w3dr6Y6OWuOSr95z/jC39VXh2R2QCa8UvRVhgenJwjVQD5Z2vBNVVE//qZJuOysazt0GjE89dSf1Ck4Y4OD5/0v0EC8bpLHR4gfvl20oeYRt63HpMvowqryDC4PAz7aahyrZ5YHxUGs9KzG+iZ1Cc7Bzrq/Nq69XVR4sUatWzHF/6bnuM8Z6Hzg58wTBLMgNBmABITDI3CJ/UbXoKbrPViTyL24xAptUlwWg37IDKA5328zkI8fs4e71PIJMvvxI1NWwxvNUdW43CagVFo9hrBFQb5ArlyJCxXGeFTh06bfi39kEsppZlSCpKSgu5ke4FEuOSsWIgkzaDuf0hlptKF8N5JWPn94sAkZoMK/swmcWAiLrtVoVKwUvgyhEm0qIrm7yTGUuMEBsBfhTxgeoKNgFpYmm4sLvOSUYmroE6hndleYEobZ5h+jK73UMinnjO6feeKQjBUmiJYntY5da+IULQKmcAMLSK5GJ2JerpHr/1uOHotOBhiT00vUaHqW5DfQ8HLNL6Db
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(31686004)(86362001)(31696002)(478600001)(6506007)(53546011)(966005)(6486002)(36756003)(82960400001)(2616005)(186003)(83380400001)(38100700002)(4326008)(8676002)(5660300002)(4744005)(41300700001)(6512007)(26005)(66476007)(66556008)(66946007)(316002)(8936002)(6916009)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bU9yZEVWR3YwZGpZbm1QL3gvQm55emY2ZjJDaDBKZnU4OVVCYjR1aG1HM1ll?=
 =?utf-8?B?ek1BeEQrQlZ4Z1hNY2JmbEVFYnlpZnh4MGwwWitwbG1yNmpCeWJkZDJyWXVS?=
 =?utf-8?B?b282cnoreDg2WVRxcS8xSUJ1OElMVE9RYjRFdFBGdGJhWjlyRHJiSHVvTXNj?=
 =?utf-8?B?RlhlSjliOXowMkJ0bHJZRFNJS1hvSno3c2Z6YzNiU3REcldSMERkZ3dYU2FS?=
 =?utf-8?B?MUVZeVZWOVQ4M2RLZDJpa0xhTytJL0draVVoZ2RYa2loL1NlaWVtcVVVTEJZ?=
 =?utf-8?B?aXhGYUdpUThKT2dmM0RVSVVxQ1BpVGZJYmVrVTZXekl3azFRcHlTY05BbTYv?=
 =?utf-8?B?YkFKU2UvdDIwQTQyVWFCM0dOUHNjK1gwRExOQWsxUlB0K3ZaaDVHcWhqVnRr?=
 =?utf-8?B?Syt0S3BjVFZ5V1B5VmhZTm5MVmVNNGdsbzF2QlZFTjgvNCt5YzV0aFJhR1U1?=
 =?utf-8?B?QldNaUdOTURIYmM2di9sQWNlcFhlZ2QybDlJOGtVZmd3VXIyeG9oM1k2anEx?=
 =?utf-8?B?MC9veCtlVkI4YmprTkFRdzd1eXhmM25pbnZPY0ppSEhjUW1jQWd5dW9qSWkx?=
 =?utf-8?B?M2I0amFIdDE2NlZER0h5V21DZDIyMXF3YUVSZzBIa1AraTM4UHYrUjBIdjJV?=
 =?utf-8?B?bFRPVkh2Z3VSOVdqTVArL0lvL3B4SFI4ano4WmlDQjJaRlBaSGlMNnM3ajlC?=
 =?utf-8?B?dmlkMWFCWVM4cDdBbEovZ0NRYjMrQkdKTDl4Z2RhUU9YVHVncVZpK0pZdnl1?=
 =?utf-8?B?N1oxL3V0RUlvY1hYZ0FLR2djdExRYXFqR1RPNEJBbDBUUjRMZVhIMkkzam1O?=
 =?utf-8?B?Z1NodVRIazNTdWFnSW00SmtXOU9KWjlSUW5rOTQ0b2RqTnZFL1JxTlVERlhH?=
 =?utf-8?B?Y2ljazl6YXV0WmFYaUVIZGQwL0JMM3QxK0p3TXBzRnJ2MC9oSVZBazB3S2tw?=
 =?utf-8?B?N3dzSERYMGhVTjFtMUFSWXNvclRud1NWcENKVHBxSlN0QmVZdGlQWldweU1j?=
 =?utf-8?B?V2lGM3p6T0RFaEIzOEdlZktwVnNDcEVnV3FLSHRjOHpOUSs3OG0zRjlFRjVs?=
 =?utf-8?B?bk9SSVcwOThSVlpoQk13a010blhMWnVCOTVaa0lLTVpCT014VW92UnBLekZQ?=
 =?utf-8?B?VTlac0xwT0lRY3c5eG9VdnJENnpuL2FWR0xvdzk4a0tjQTFwUzg0SFhjY2FJ?=
 =?utf-8?B?TWNmbGZialA2Z0UzaGxQRXJwbW85Zmp1MHI4WjBjRTNwM2hmaUF2WEluaFE0?=
 =?utf-8?B?Q0FtY3N3UVFkaU1QV3NPNE8zV1JZcUVtcStaQzY0d2xLeDNDWUo3Q1cwT1E4?=
 =?utf-8?B?dW0wcWlBbVBGWENCbnVpcXF0U3BxWGNyTzRVNThyaFVra0FRWWQwN3BqR2tZ?=
 =?utf-8?B?eUlnNEVocS8yTWlUNDdrMEJkejJka3N2OFBYZmQ0N3pKd3lhZWFNOEtYYUEy?=
 =?utf-8?B?eDN3dHNIemlzUjYrYVZPOEFpemdWV1lwblFaN2lLaHcyWHc4NXNtcW1sTllG?=
 =?utf-8?B?RkgwTTF0Qzg1K3F3UC9LdjltMy8wM1dueko3UHduUGl6c2lFaXI2N0tjSzFL?=
 =?utf-8?B?d2MwYXNzSVpiakkrYXZyM1ZUbkV1RDI2QnBxNTVLSkFoUUpmTHlDZGErNDg4?=
 =?utf-8?B?Tys5SXIxSWtQMFFXcWlnUE1iMWdNTzFxenZOQlA0ZkQ3MTYvWEhJbkEvSi9W?=
 =?utf-8?B?dnA2cWMrc3lEMm1yQkpuL3ppSitVckc5STNzVGZ1U2hCRmdFUGVZRXF0dDBx?=
 =?utf-8?B?b0ZUNkhoYi93R09Wd20xRXcvK0NXUTBBcGRseHZDaklpYkd6KzBhc2RmYkJO?=
 =?utf-8?B?R29DZW5MRTNKbmxRbkk2K29kN0FPZjhhUmlEeDBhQ0UvYWVnVklleTZKdUxm?=
 =?utf-8?B?bVZNdlN4QmcyRmNKMGtWVUlRWjdwdG5zVzV0Y0lNbHBSdXNsNmg1TVJBaXNx?=
 =?utf-8?B?Q09IMm52dnJocEZnRE9BUGphc1NWT2haTCtJUDlxd1JESHAvQzE3ckhleVVv?=
 =?utf-8?B?cUt2ZjlNbjBkT1VmS21LUXBBY0ZreWwxUW5HRVBpbjdjR3lTb0tCRk1IVnBT?=
 =?utf-8?B?M3A4Q2EyY2dkcUdyeWR0ekNsdmo4TE5EQnE1NXZId3NUNkd6ai9BZCtsV2xv?=
 =?utf-8?B?MVRCNFduZmk4cG5YY2pqSVBDMXdOaitrRVBEMzh6VEFpY2ZvbSt1QkNiZGpU?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afdc1a9e-8b58-42f7-9eaa-08dad69c7ec7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 08:41:25.9424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+f+mBqB1ILg7/qA021+64Q6UcsqrlcuoJuxs+c98MI1kIYz401m8bDZvDBIzBCfyf74sidHgj5623aghuw5BuouDuk6N4MhXj4pPTEHVQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6538
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



On 12/1/2022 5:53 PM, Jakub Kicinski wrote:
> On Thu,  1 Dec 2022 11:26:22 +0100 Michal Wilczynski wrote:
>> Patch implementing new netlink attributes for devlink-rate got merged to
>> net-next.
>> https://lore.kernel.org/netdev/20221115104825.172668-1-michal.wilczynski@intel.com/
>>
>> Now there is a need to support these new attributes in the userspace
>> tool. Implement tx_priority and tx_weight in devlink userspace tool. Update
>> documentation.
> I forgot to ask you - is there anything worth adding to the netdevsim
> rate selftests to make sure devlink refactoring doesn't break your use
> case? Probably the ability for the driver to create and destroy the
> hierarchy?

Hi,
I think it's a great idea, possibility to export the hierarchy from the driver
is key for our use case. Would you like me to add this to netdevism ?

Thanks,
Michał


