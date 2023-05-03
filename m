Return-Path: <netdev+bounces-215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B4A6F5F14
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 21:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67EA92817C8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0960DF67;
	Wed,  3 May 2023 19:26:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8727029A8
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 19:26:44 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E9E6A77;
	Wed,  3 May 2023 12:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683142002; x=1714678002;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=slMgmYOSxKLgS8bbjGFOb1rliN6mtZHs/LGQ9p8/u/8=;
  b=Cyh8Eg+861YMBEgt0ADniAx/IUOICr98OWIxwoHq6vrDBdf/+k238CI3
   zWW12Fg4dVOZdEF0vIg3llQDyvQdpejl6yKaxJjT9YaK2rW0MzGdoSrbg
   4k/dkDXndoB/YTueGZkRQvUzFfp/E2sc6WAON8gWSNtjIg27FisfSTvn3
   uscxP9jcdSYtOudn4uODh43A5SmS1k+TvTCTZSaRwtdl97kfBWWn/N84E
   WgKsc4u+jYytzctOyVgTaxkgV6BGybLn+QwNuAMcXxHV53X2jjGl1d/wl
   PvdQKFiA74x+LJB8FiFJ1E64uU0NrBWHi987s59XULMEqUVBlLt49OdFN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="435059496"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="435059496"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 12:26:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="690819175"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="690819175"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 03 May 2023 12:26:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 12:26:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 12:26:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 12:26:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 12:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRD2X04yZlWSNQZym1hsyYlkNMWDBNIFApbP939rgEImcxmQ4fHVIEyFZi/IZB9Rs+IG6h6kiwuVoHKAFIB2m7Z9HcS3W5NtLxRXyOkpcPZ71cQywmXSrng3tizQGQftNP5MU6CujrNpZC4Whx37gfxP4ZtI0FfMp9qEHXLt7FI4gKoefl2XiKr+7gtqSVcM6hYnxeZdWqhNm1cKpl7oHe72lzWUTDs7r1jgFOzugTuhl07OmE8zgOYGswdE08dGR3aSQ86c8q8X9Q+GeD2wJG2GHPtBtR1aV/epbxcy4ZdgvgFQHKnwz7P7ir/NN4X+0rSvg2+QlYOfaeei0uSRXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZL1kt+ZplBqELcrr1xQeMrLqN6GShfAcqWjajzH3Qo=;
 b=P08F2rMtvFSPX8gqr3h/Q7UbDDFoa0RmH2103hBMzLGicLHJ6/51q2YPvUyQ8YADOOhznaS6EVGJbsHe+tvK6bEgqhGgSTHg4816KkhutnmsNAW5J+Jw0kfAvU/S7WIXKe5qV67VUTeGEvVAVbLDbUyLxiIVgn8AK1nOJU7949C0c/+A+Lwj54wh42w+QDdO36N4i577tVwLiZZ2qwplVOi4oJhAcMH7ZKcW2dE8+nke3oAz2j4RkGBtaf3UA5+1SQH/Q/fn8Rn5ycLph+ek0HxS249N2DHcUCqOAeMGbofVt+/BoMfv4AshxTzttABYbwrHulGnZTGVgvQWuz3iVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20)
 by DM6PR11MB4609.namprd11.prod.outlook.com (2603:10b6:5:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 19:26:37 +0000
Received: from SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::5194:555b:c468:f14f]) by SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::5194:555b:c468:f14f%7]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 19:26:37 +0000
Message-ID: <60859f1d-3ca1-8318-705f-2964834f071d@intel.com>
Date: Wed, 3 May 2023 13:26:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net v4 2/2] iavf: Fix out-of-bounds when
 setting channels on remove
Content-Language: en-US
To: Ding Hui <dinghui@sangfor.com.cn>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>
CC: <keescook@chromium.org>, <grzegorzx.szczurek@intel.com>,
	<mitch.a.williams@intel.com>, <linux-kernel@vger.kernel.org>,
	<huangcun@sangfor.com.cn>, <gregory.v.rose@intel.com>,
	<michal.kubiak@intel.com>, <jeffrey.t.kirsher@intel.com>,
	<simon.horman@corigine.com>, <pengdonglin@sangfor.com.cn>,
	<netdev@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
From: Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <20230503031541.27855-3-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::11) To SN7PR11MB7420.namprd11.prod.outlook.com
 (2603:10b6:806:328::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7420:EE_|DM6PR11MB4609:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e9eea1c-54af-433e-3a77-08db4c0c5001
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EdZ9ZjJnVO0xJKjW3I6I/XxaMKnEebno73q7Dflpu+Pg8Yvy4K6yP1xasgVt+E4urL+7axQUBPTiImDSPeOC29KIAWvtWPjheM9JW9U2DZ2rEWM1dQDjbPsMfBgg6mq6IX6yGfTqtEo9s3bXSsZD5nbx/osrg6f7t+hwBBwePxuTusQKtE9aYUfskyl4iU244WwK70PDFvGLYRw26ggFLEcEfMQiDGRsmLAYGQ+2bC86gUz/KujbktYNfaxqursgrKwUwT1yUWU6zfmSVhbkG8lJKdEQ5tarotc3rgxDrN2D3y/wo+gm3ooB+Hrc40gc4n9ru++D8Og3HbziTnRJ9Is8zt9h2AciRNYdkOuS0SI2VqLoSJE9RehCJ1lVxSxaDYG3QogzklZllwkBJYJdFbPIqubSfMQYl0Nawb6jM9ZVE3blVE2hKaRnhEHwacuz0EP9Br8pOj3yEEE8SlU+g+xJXmfqKQGhYufkd+zqoTj96MBYLL6A4f5DVPproy46jPfsPchp6HvI3sGCH7OIm/9SJK7DNzzTLXP7Vrm2jcKKVBboF5+6Poi6hycDk7KX92PA61KyXYz3Vi9yipNQKeen7Zfx46bEExGTq0+E3um0NWHKxDavjIndcB+BqU2nOA9YHLoBY90sLsGBcJ7sGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(38100700002)(66946007)(316002)(84970400001)(6636002)(4326008)(31686004)(41300700001)(6486002)(6666004)(82960400001)(66476007)(478600001)(66556008)(8676002)(86362001)(31696002)(26005)(5660300002)(7416002)(44832011)(8936002)(6512007)(6506007)(53546011)(2906002)(2616005)(186003)(36756003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R21XekRIUFNEL21tQXc2NmZBZE5mOGhUYXZjYUorQ2p2dVBjQ1NZQnBwREIw?=
 =?utf-8?B?bjJ2U3FJRmVRellyQmcva0pPZ3Y4UkFYTEk2dm15eEZtOE5CSEZGSTdiTC9v?=
 =?utf-8?B?VlRWeUJhNTYrSGZOM0ZtMUZ5RGJ5b2Q3djQxcSs5UVlSZWU4UWdTWmRrckNx?=
 =?utf-8?B?LzhkbU4vbjdoQTNFZzcrdDZSVGg3OWdzYlhYc2IwNGJJSFl5cEFpWUhmTTl1?=
 =?utf-8?B?Z3JEWnNtK2o0ZktYaHJzN0NxNC9tRXVjMSszV1c0SDdNL1VNaXArNVN2Z3Za?=
 =?utf-8?B?bzFxOGZEZEhBRWJtZ3dOU3hFTCtPSkxZdDhUUzFHZG9GKzdLNmlZV3RtKzRj?=
 =?utf-8?B?QkgrSlY1WTRvR3p2bUFqVjRHQWJ0M0Z5NUVONVRnWVBOeWEwejVIRFBxTVE0?=
 =?utf-8?B?QkJUeVpnSEJ0bm5qMVJheXl6RzBHOW5tVEgrYzVNNmRLdXFFQWVIc05NUHE2?=
 =?utf-8?B?ZVlNNldPN2xDOGdHQWcvaWVnNGpWTGd3dkhTTitaK3BSeGR4eDdZZVl0QWRX?=
 =?utf-8?B?UjlvdWRLbkVDc0tQRUkzUmlyeXgvMi9OWG8wWjJTZ2grbG9qQUJ3M2o4K3FY?=
 =?utf-8?B?dkV4RDFqREMzenU3d2lGSlY3ak1wbVFiYWh0ZFhhcFB2MTZZU1ByV1FiVHRy?=
 =?utf-8?B?UEFabGVKcnp6VlA2aTYxdVJlR1RoSktERktjbWpzTG8vbXFVUEwxSmFPZmZs?=
 =?utf-8?B?VU5qcnE0OUNnbWIwTGJVem15cThISVVZZHhoZ0Z2djYydjltaGNmcTM2UWw3?=
 =?utf-8?B?U3NGdmZ2eGJCREFvRzVqdkM2NHpVSStDMUtDZjZQeWpTcmY2dFZMMVMrZ0F3?=
 =?utf-8?B?NnEwVmJDWWxkUEdHV2JKbTVnNElTd3FydHVudlVyVGlRbWIxSjRDb1BaczVj?=
 =?utf-8?B?Q1NRTnlvV3h5RTZoRGFPSXlDdFFGWFZmcUROYlgvdm5URWJ0bmxSTmpqbTN1?=
 =?utf-8?B?aGJJNmZ4ODQ3Ymw4dExaay9OVUdJbjhkazNzd3VJMk90SlBRdXhPd25QN3g2?=
 =?utf-8?B?Z0FXanVPWWxhNURaT20rWkttVFlLL0NSZVZ6RjMxRk5VZTNSSzM2U2k5bHlk?=
 =?utf-8?B?dTZsUjJnd1dmWXpQdXFxeTVXMjFQK1d1V0ZSdnNkdnlzeEFaeGJSYk1YUk5X?=
 =?utf-8?B?ZVp5LzZJSWF5MkZzTmMyMDA5emhRVEUzeStseDhaVTRYVUVwUElxQlU0Nml6?=
 =?utf-8?B?TjVjZ1l4TzdVSVVCditVS09OcU13UWs2U0lQMHU5VmY5bDJXTHJhdEpJaWYy?=
 =?utf-8?B?aVppTXI5ck00S3JLRi83ZUVBSVRqd2NaUGoweXV6ZjlXZmlNQnFtM1FISnF0?=
 =?utf-8?B?NktQM2VRZy9hT3dRQStOaklLK2JaWFpHcnIvbWcycHVUbjg1SlVGZGM5RGk3?=
 =?utf-8?B?bXpCUUtQM1dLckI1S1QvNnpNOStRT3RHQnQ5QWpGc3RGb0dOWmt1aEJFNUl5?=
 =?utf-8?B?TjZ1bjc1Nkw4SDBBSHh1NTdwS05GNzVJdFE1cmVVQUhJeGdKcWpWUW5wWGxj?=
 =?utf-8?B?b2l4RUNyY2IySWt1TzVhRjVNck0wcWljSS9CKzVLK0hUQXM5alFDb240eEJU?=
 =?utf-8?B?bXBKdzROWG0wQXcyN0NKTzZaWW1kSGhTWDliUzk5OWZWTGQzODVqdzJPeitq?=
 =?utf-8?B?M1JDTnpMWHV3ZDh6N1ZiNVcwa09DcVJxa2Y1bis4MnBZcGF1Nlh6WWpiMUFu?=
 =?utf-8?B?bTFRZW9xU1FvUGNuczhmdkxZWlFIeHk5c0dPM1BQekZqMmRhTjV0bWFXSzdz?=
 =?utf-8?B?ak9HVG9WZVRSbzEwcmdFZk9QV3ptU25GbzFHNWFrWFlsM2lVR3NOSGJ2dVRL?=
 =?utf-8?B?NElaRUFQNmxab290UWFhR0VheExHMW1kNGRtZVpwM0tTQXpXamExTVJVL2VT?=
 =?utf-8?B?dVkxbi9LdVdCaHhYTlYwMEJyZ2kxdm04NlBUdTduMEd5NzdJNlBwTWZpNmMw?=
 =?utf-8?B?a251eXpEQldYUDdMTmhOY0hxWWNWTkEyMnpEQ0VXQUx2RC9FT002cDRIRHlJ?=
 =?utf-8?B?QVQyc01UQWZqZjYxSEhPMk5vWWd0MDM0aVRxbHE1YlFNeUtDbHlvNGNySXFE?=
 =?utf-8?B?cVFneTFTTU12NklTUGtzRXVibUhyU3ZPT1VibXhVUmw4VGdyWFpoaGRTTU1W?=
 =?utf-8?Q?oNWFHNWBiSqZj7S6JDHr26dng?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9eea1c-54af-433e-3a77-08db4c0c5001
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 19:26:37.1765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iyQNKJBvJxySflyudnO1bPzuhk1gApUq893PyHtuUiUy0Q4fbLmjolaqGPREPr6vLOJsmlNLOMYKzDI0QZLeTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4609
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023-05-02 21:15, Ding Hui wrote:
> If we set channels greater when iavf_remove, the waiting reset done
> will be timeout, then returned with error but changed num_active_queues
> directly, that will lead to OOB like the following logs. Because the
> num_active_queues is greater than tx/rx_rings[] allocated actually.
>
> Reproducer:
>
>    [root@host ~]# cat repro.sh
>    #!/bin/bash
>
>    pf_dbsf="0000:41:00.0"
>    vf0_dbsf="0000:41:02.0"
>    g_pids=()
>
>    function do_set_numvf()
>    {
>        echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>        sleep $((RANDOM%3+1))
>        echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>        sleep $((RANDOM%3+1))
>    }
>
>    function do_set_channel()
>    {
>        local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
>        [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
>        ifconfig $nic 192.168.18.5 netmask 255.255.255.0
>        ifconfig $nic up
>        ethtool -L $nic combined 1
>        ethtool -L $nic combined 4
>        sleep $((RANDOM%3))
>    }
>
>    function on_exit()
>    {
>        local pid
>        for pid in "${g_pids[@]}"; do
>            kill -0 "$pid" &>/dev/null && kill "$pid" &>/dev/null
>        done
>        g_pids=()
>    }
>
>    trap "on_exit; exit" EXIT
>
>    while :; do do_set_numvf ; done &
>    g_pids+=($!)
>    while :; do do_set_channel ; done &
>    g_pids+=($!)
>
>    wait
>
> Result:
>
> [ 3506.152887] iavf 0000:41:02.0: Removing device
> [ 3510.400799] ==================================================================
> [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400823] Read of size 8 at addr ffff88b6f9311008 by task repro.sh/55536
> [ 3510.400823]
> [ 3510.400830] CPU: 101 PID: 55536 Comm: repro.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 3510.400832] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> [ 3510.400835] Call Trace:
> [ 3510.400851]  dump_stack+0x71/0xab
> [ 3510.400860]  print_address_description+0x6b/0x290
> [ 3510.400865]  ? iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400868]  kasan_report+0x14a/0x2b0
> [ 3510.400873]  iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400880]  iavf_remove+0x2b6/0xc70 [iavf]
> [ 3510.400884]  ? iavf_free_all_rx_resources+0x160/0x160 [iavf]
> [ 3510.400891]  ? wait_woken+0x1d0/0x1d0
> [ 3510.400895]  ? notifier_call_chain+0xc1/0x130
> [ 3510.400903]  pci_device_remove+0xa8/0x1f0
> [ 3510.400910]  device_release_driver_internal+0x1c6/0x460
> [ 3510.400916]  pci_stop_bus_device+0x101/0x150
> [ 3510.400919]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 3510.400924]  pci_iov_remove_virtfn+0x187/0x420
> [ 3510.400927]  ? pci_iov_add_virtfn+0xe10/0xe10
> [ 3510.400929]  ? pci_get_subsys+0x90/0x90
> [ 3510.400932]  sriov_disable+0xed/0x3e0
> [ 3510.400936]  ? bus_find_device+0x12d/0x1a0
> [ 3510.400953]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 3510.400966]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> [ 3510.400968]  ? pci_get_device+0x7c/0x90
> [ 3510.400970]  ? pci_get_subsys+0x90/0x90
> [ 3510.400982]  ? pci_vfs_assigned.part.7+0x144/0x210
> [ 3510.400987]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.400996]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 3510.401001]  sriov_numvfs_store+0x214/0x290
> [ 3510.401005]  ? sriov_totalvfs_show+0x30/0x30
> [ 3510.401007]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.401011]  ? __check_object_size+0x15a/0x350
> [ 3510.401018]  kernfs_fop_write+0x280/0x3f0
> [ 3510.401022]  vfs_write+0x145/0x440
> [ 3510.401025]  ksys_write+0xab/0x160
> [ 3510.401028]  ? __ia32_sys_read+0xb0/0xb0
> [ 3510.401031]  ? fput_many+0x1a/0x120
> [ 3510.401032]  ? filp_close+0xf0/0x130
> [ 3510.401038]  do_syscall_64+0xa0/0x370
> [ 3510.401041]  ? page_fault+0x8/0x30
> [ 3510.401043]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 3510.401073] RIP: 0033:0x7f3a9bb842c0
> [ 3510.401079] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> [ 3510.401080] RSP: 002b:00007ffc05f1fe18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [ 3510.401083] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3a9bb842c0
> [ 3510.401085] RDX: 0000000000000002 RSI: 0000000002327408 RDI: 0000000000000001
> [ 3510.401086] RBP: 0000000002327408 R08: 00007f3a9be53780 R09: 00007f3a9c8a4700
> [ 3510.401086] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> [ 3510.401087] R13: 0000000000000001 R14: 00007f3a9be52620 R15: 0000000000000001
> [ 3510.401090]
> [ 3510.401093] Allocated by task 76795:
> [ 3510.401098]  kasan_kmalloc+0xa6/0xd0
> [ 3510.401099]  __kmalloc+0xfb/0x200
> [ 3510.401104]  iavf_init_interrupt_scheme+0x26f/0x1310 [iavf]
> [ 3510.401108]  iavf_watchdog_task+0x1d58/0x4050 [iavf]
> [ 3510.401114]  process_one_work+0x56a/0x11f0
> [ 3510.401115]  worker_thread+0x8f/0xf40
> [ 3510.401117]  kthread+0x2a0/0x390
> [ 3510.401119]  ret_from_fork+0x1f/0x40
> [ 3510.401122]  0xffffffffffffffff
> [ 3510.401123]
>
> If we detected removing is in processing, we can avoid unnecessary
> waiting and return error faster.
>
> On the other hand in timeout handling, we should keep the original
> num_active_queues and reset num_req_queues to 0.
>
> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> Cc: Huang Cun <huangcun@sangfor.com.cn>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> ---
> v3 to v4:
>    - nothing changed
>
> v2 to v3:
>    - fix review tag
>
> v1 to v2:
>    - add reproduction script
>
> ---
>   drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 6f171d1d85b7..d8a3c0cfedd0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>   	/* wait for the reset is done */
>   	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>   		msleep(IAVF_RESET_WAIT_MS);
> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
> +			return -EOPNOTSUPP;
>   		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
>   			continue;
>   		break;
>   	}
>   	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
>   		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
> -		adapter->num_active_queues = num_req;
> +		adapter->num_req_queues = 0;
>   		return -EOPNOTSUPP;
>   	}
>   


Thanks.

Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>



