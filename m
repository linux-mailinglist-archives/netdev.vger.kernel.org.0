Return-Path: <netdev+bounces-8100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8ED7722B11
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31F481C20BDF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9266E20698;
	Mon,  5 Jun 2023 15:30:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0F11F93D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:30:32 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDF2135
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685979030; x=1717515030;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Hj5+q6nUucTvwxL+ILXrUshCS0jIB+lF0KmYMbtl380=;
  b=f9m+co8Yg920Nt7VFXvS9vR+pAdWQs3IOZg9m8ifaVXoJ775QN4dmqsk
   QSq7ImB5uJIWjqAiYbOPWz8M0jtbmsaqBEPdaf70lO8bwPOglxnswSYAg
   prc8AVmuv/zsgfK2PUe6dc3Gu6UQVGFOGOelv5bP+/mEtQ54s/PVkiEqi
   jMD16tGuRkPyJ9ScdehNBcTVD6KrFnoeuBike8H773VsSR7iri7QUN/Dn
   0OqcTKQ5J+cCGAzXIXYvf5djpJgpt4DPw/n+kE8cJl86MbDUuZTVhoFKW
   n9IaKAArwcX5jNZ9xO7hamhaIL7gS+4PMLEzLGQazfhg5SYUZeYj9dIQk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="345991891"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="345991891"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 08:30:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="882949139"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="882949139"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2023 08:30:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 08:30:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 08:30:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 08:30:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7oHi1eI9djF87gZroXyJTxUQtOKKEh4c9jAj3+l3PPOwXVE+JXGIyMBUZb9e4J5K+NoLR34nu4b9haO8Hs5333IZg7jofZphfF3ZLnBRQI/7AyYCMw2iPqztuYfS8ndp5cjGagSm6mtIggf5IVqvwfwi3ESczJBaE0/fMVTfs1oeLaolZXhsij4nhvebVYfGjwSpCG5PzeV1WvNAQp4Y9BjqUA0EThc6lfZiaqpKA4Io7qXUYbgUzzGPzfKFswtTA+KYjmrGpBvg+G6ifs0QgGw1H6ypy/9JtBEjb4ZEJzvOPi+t7qXsn9RQEhCIcyqmmczrfSVA9ykhmw/LiBQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OY+EG55rdFXwhZX/MWXH8YMKCBx4LbhQd1ifX/vwwM4=;
 b=ZIVpQcSB64AKQOmB7nODV5PE3pz7XUrY7BQhkP1aZLMV6nbLUYLtbRcmXLI69K5y5troBJ/N9UrXN914lLa/+Lsm/JXogemgRVqTx6b9LTKbBr2V5QYxwzIpzshO0eYMzRzDzEGSlg389QwomsH4aNUV2V466VmlgdLPx/6Jrrz50rFMGv7gGt+E9r7U5UidT0g/vG/7RJDw2YzQH5+EProSAa7UG/5Vd7RVCBYpI4Tir1Vu9cYT2bmklDnZhnhMKamCgVO6QkbFqj1XaoiKkwioVxjBcCQ4dSpqwIsRGiP6LtMS+F96ftdjRShB6Sjd1dN9UAXErEDcMDhwDrnaxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 15:30:26 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 15:30:26 +0000
Date: Mon, 5 Jun 2023 17:27:32 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
CC: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>, "Linux
 Network Development Mailing List" <netdev@vger.kernel.org>, Eyal Birger
	<eyal.birger@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, Patrick Rohr <prohr@google.com>
Subject: Re: [PATCH] net: revert "align SO_RCVMARK required privileges with
 SO_MARK"
Message-ID: <ZH3+5E/9f1XmQg+o@lincoln>
References: <20230605081218.113588-1-maze@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230605081218.113588-1-maze@google.com>
X-ClientProxiedBy: AS9PR06CA0204.eurprd06.prod.outlook.com
 (2603:10a6:20b:45d::30) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: a45d2df9-4f0c-425d-19d2-08db65d9c811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YglPp9XZNmKo7QtWSVdI2LwrsdmAIvs+cbZ4zrP5mpXSbqQovLNIK+sw8tcqdAXd3LB5UDacLu3yCZ81tQsqZ2Vg+2F0p68+SuL4zwa9VqkY1rhAd2nXDxYfJvh7dl7sfNNppfXsh4i5RJxUGcy3HF0z6tSUExpgyoeM/n9YNIkziL4NtdfHfLQi7GAOrrjQ+kVDK7sKdHWF2vHe5+BDF9CoHoNGsC8GxRXDystn2VWiFtaezXC6k3qTtBqLE+hq4fsj0dDPizjQF1d8HBKMxFp1jOTfjXVnby6CeBXUhH7KvZ9qaOdjjl8rtzwmSj1Q2S1Uogcz8tzwDKrj72VE3nT52YPCAsIYYuOwqWtnEQRb6CxwoTG4ORhd6vgxzNQmehC1j0gGoZurqTg2iXXC9jlKb7Mi7OLkjmTIrvjlphcR4UWZLx1LxJ8Pz2miKkXNr64pn6+5LflQNPr2MFYsAIUpTHTNIMV3nPRIPAVgrjYM7qP+h5vOPtjIqgj77aXB0UvYyJp0ZqpdYlTRek8LVtfHLpjYSf9/j0n/lh4xG9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(66574015)(9686003)(6512007)(26005)(6506007)(44832011)(316002)(83380400001)(4326008)(6916009)(66556008)(66946007)(66476007)(6486002)(6666004)(84970400001)(186003)(33716001)(478600001)(54906003)(2906002)(5660300002)(8936002)(8676002)(82960400001)(86362001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzM5d09ZRFhCNEdmZVE5TTVkMmxXcWxwbW1Qelp4blNKZUZvd3k5WjNsYXlM?=
 =?utf-8?B?WEE4cmVUNHBEMEZocG9oRFJxR3g4NG5PeENScVZrOXRiQzlSSko0Q21KZjBX?=
 =?utf-8?B?NlVsb1Z3OW1XUlBRWHFiRGZGZWFiRk8zRzV3YTBubTVUMVRuUDBLeHdwK3ZM?=
 =?utf-8?B?VnhKaXA3TnN0eitSQ3d1RFRLckxzZ3M1YzAvazBjSGtvZU1oK0ltNG9sbllP?=
 =?utf-8?B?aVhUK2JBK01zNVdtT3VSbTFmSlB5M3p4N1lINFgxbXl3dmVIZVpubTdnWkdQ?=
 =?utf-8?B?UGs1T00rUk8wbWVLNytIamxXcVArdVJVdVBNdjV3eEdkOGFFNzhaejBydG1W?=
 =?utf-8?B?L293R1Z0UXlMOHF4ek5TZ2VyNE90S2hnR3dERmJvUnRTdnUvWUFEUDNGNTZt?=
 =?utf-8?B?YldXVUR5M00wdjJHNVgzdGpOWDVjdzBMaUZTeG45WmtLZHZKWHJOb0NEd0ZL?=
 =?utf-8?B?R2xiQnRmc0FmRnBmWnlES1lYb2ZXamZLSmsvbWRmclo0c3ZpNGlpRXZMc3Y2?=
 =?utf-8?B?Y3QyWXY3QnNvaWZhUjFaNTl6RVlURVY1QXBUWXhOUjVBT1NWZ25xdWZjS1VO?=
 =?utf-8?B?VVAybjU1TlVDV0k4RjBKQVlHQ3htVnd5YmdaSFI3eU9UTEpaYi9GdVZocEJv?=
 =?utf-8?B?Y01ONjlyYjhBZlczM2VuUC9ESGdWbGJTaGN3dTNhSC9zbGlMc0t3MGVaMS9s?=
 =?utf-8?B?VUVIVGpvMG91TXEvOVdQSzhWVWgrZDNodHg2Y1MvYnJRSEtHRVNPMEdIMjBq?=
 =?utf-8?B?L0RCQ3BFeXVLelJ4dzVVcHZ5NXViNDFXUXcvazkzZTN2MDlHRTNJa2hZZWN4?=
 =?utf-8?B?emQwWDZBaWhTc3RTMGxkTFZYdHlFdEU0NkFPbVM3M1Z0VUNiVCtoVEl5ZjlY?=
 =?utf-8?B?ajJtYmtnNURKb0hYd3RmYW1qdWNCWS9YbzRRZ1FYSUFBOXpDdFg1WjNoR1M4?=
 =?utf-8?B?dzduajhldk1sK0ZvZkJicmpqQ2t3ekRMRDh5RTZnRlJRTHZkOXd6T0l1RUhn?=
 =?utf-8?B?bWdGVVVtS0tEcEpHTVhYNkhkVnAweTlxaVB5dlRVWjRBK1Q1bTE1bTdBVldT?=
 =?utf-8?B?WlZ5MEIrQTl3TFRZRldreWNta21rQkR3bVJ3MUk3bjZBbk5SK2JxSnU5eDN5?=
 =?utf-8?B?Zys3Y3E2T0FwbS9rQ2NYc1BXWHNJVi83WjJjNno0b1BIUkcwL2NFVXJIWXBw?=
 =?utf-8?B?MnFSbUpjbldnZlNhaVorL29ieG5ZQXB6SzVDV3BNTzVycGxMdVRaK0pZU2xO?=
 =?utf-8?B?TVhrVGVyTWZaa2YrdW5qYkx3L05lSDk1SjFFOWRTZ2pLakhtTGpWOFJDZEp4?=
 =?utf-8?B?bllsWFU3TFlFNGdYOUtmQlQvaE13Tnl4OUdFTFMzci9tbzFNUEhxb3oxeHc5?=
 =?utf-8?B?MVEvSmJYSU9Cd0tuamFoV1VqaXdqWjlzZkNoTEtiM1BlRkdxYWV4SENwdjI2?=
 =?utf-8?B?YzlVaDVXdkZVMkRoU2luVzMrQmlFbXduT0xWVnFLZkNQOWdoOFhqaDFheWlV?=
 =?utf-8?B?emN0RzY0Mk9LVUpuSDM5TXg2Y3ZzV3BFQVUraVNWUzBrV0Z0T2FrRUhkbXU1?=
 =?utf-8?B?SWRyOThjdUdvNHQ5ZjVqc0IydkdUYmFmTGlXYVZrYVlZeURwcERQN2FLd3pi?=
 =?utf-8?B?UHUzeGY4TlJvOXZiSTVHTExMZFdvMEZRUWFleE5yNjVBZUhNRUdFSE5UVjcx?=
 =?utf-8?B?b2p0WFpRN0RYYzBxdnQ2NTdzU3dsWXBvTDhtWHZTYlZheFFxUWxRZnMrM3Y2?=
 =?utf-8?B?Ty8vallZT1dwWC9MNHNHaWpSdmtGTzVQWXlaSGpVTjJrMm41blpleHNoRks4?=
 =?utf-8?B?NjNmblVFZkF2WEs5QjJrMUFsWHhleHArdm1pSXVsOGVUNXowMUVEN3ZqbGgz?=
 =?utf-8?B?ZldjbU44L3EvWHdKRW1mTUtpejRBSE52SlE1Zks5MEY4WnF2Z0tmbTR6VlVi?=
 =?utf-8?B?M3FpUUNFSmJ1OWtTZ3dLTk1pb1Y2bVhMZWFlNnYxVnZGdVBvL0t5OTRnZlVp?=
 =?utf-8?B?RjlzQmlxYTYyRW94eWdNM3hrb0Ria1kzVzVBUFVpdWpOYXVUblFleFNvckdI?=
 =?utf-8?B?ZmUvb25VSXpPMjlCcHhac0FTaXNwdzhNa0k3TENkbUpsd0N1em12dTRqbDNn?=
 =?utf-8?B?cFBkZHRQVDZCQVNSNEcvWGtoSGhpNC9Tbk1xbWVzdjczbVZXTG16NmM0eGVr?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a45d2df9-4f0c-425d-19d2-08db65d9c811
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 15:30:25.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Art/YPwvv0ajX9TbFEqAI5+4BijrfTa9OHI+Wrm4qCk6j1k80udVkzFSN/X5SUNQYxCNxDry6ycZ+mAYab1WPQCdTdO86DtCz7pbl3kvpcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 01:12:18AM -0700, Maciej Żenczykowski wrote:
> This reverts:
>     commit 1f86123b97491cc2b5071d7f9933f0e91890c976
>     net: align SO_RCVMARK required privileges with SO_MARK
> 
>     The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
>     option for receiving the skb mark in the ancillary data.
> 
>     Since this is a new capability, and exposes admin configured details
>     regarding the underlying network setup to sockets, let's align the
>     needed capabilities with those of SO_MARK.
> 

No need to copy-paste reverted commit in full. Others are supposed to look it up 
in the log. The proper way to reference another commit is [0]:

Commit e21d2170f36602ae2708 ("video: remove unnecessary
platform_set_drvdata()") removed the unnecessary
platform_set_drvdata(), but left the variable "dev" unused,
delete it.

Have you checked your patch with checkpatch? I am quite sure it would not allow 
copy-pasted commit message.

[0] kernel.org/doc/html/v4.17/process/submitting-patches.html

Also, please add patch prefix with tree name specified (net/net-next).

> This reasoning is not really correct:
>   SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
>   it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
>   and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
>   sets the socket mark and does require privs.
> 
>   Additionally incoming skb->mark may already be visible if
>   sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.
> 
>   Furthermore, it is easier to block the getsockopt via bpf
>   (either cgroup setsockopt hook, or via syscall filters)
>   then to unblock it if it requires CAP_NET_RAW/ADMIN.
> 
> On Android the socket mark is (among other things) used to store
> the network identifier a socket is bound to.  Setting it is privileged,
> but retrieving it is not.  We'd like unprivileged userspace to be able
> to read the network id of incoming packets (where mark is set via iptables
> [to be moved to bpf])...
> 
> An alternative would be to add another sysctl to control whether
> setting SO_RCVMARK is privilged or not.
> (or even a MASK of which bits in the mark can be exposed)
> But this seems like over-engineering...
> 
> Note: This is a non-trivial revert, due to later merged:
>   commit e42c7beee71d0d84a6193357e3525d0cf2a3e168
>   bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()
> which changed both 'ns_capable' into 'sockopt_ns_capable' calls.
> 
> Fixes: 1f86123b9749 ("align SO_RCVMARK required privileges with SO_MARK")

I have never seen a reverted commit referenced with a "Fixes: " tag.

> Cc: Eyal Birger <eyal.birger@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Patrick Rohr <prohr@google.com>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  net/core/sock.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 24f2761bdb1d..6e5662ca00fe 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1362,12 +1362,6 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>  		__sock_set_mark(sk, val);
>  		break;
>  	case SO_RCVMARK:
> -		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
> -		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
> -			ret = -EPERM;
> -			break;
> -		}
> -
>  		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
>  		break;
>  

Both code and your reasoning seem fine.

> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 
> 

