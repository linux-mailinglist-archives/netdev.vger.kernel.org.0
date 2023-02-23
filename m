Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8AB6A131A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBWWzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjBWWzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:55:20 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5DD11EAA
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677192918; x=1708728918;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eALm+2HzOv3Ppx4hyRV3oFijTXIgijJEJocZcJAmyMc=;
  b=CVIlopoJvhkGGLdQuM3LaM9hlW1R2qrUE+oqOgnprWPmiggsPtvQhUiV
   FqP4i3w7Ek1Zx2KgyPOHqfRa+qmHj9Sq8mAYCdM3LuY89wpOuIQMNkN9B
   f28/gNmhijCkoakXqUTsqNLB02O7kae6e5gp6HvDV7T/6bfTJ+9TyPepK
   7jw8G2iUKR/j1NUgoUh6uNsSkvMzzLatN0SEthXnv4zE0Oszn/f1TO0dM
   AWSA8zsIucKavRB1cypS51hEjFqV9YrfEe7cWAaUd3Srs4oDU2xcDA5lj
   wMebu0wIFIiBzHhWypUQ5Y1AXr3He/4gAeMzEA0jVfGgYM9TZ4rKLwps3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="332024458"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="332024458"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 14:55:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815527649"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="815527649"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 14:55:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 14:55:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 14:55:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 14:55:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFL0cPRoV/5ImxJ2NLpxwM6TDa4KNADMu1tt0lKV9xoAg83L9MYQbzP1+hCfUCWkorLKQwPMQcNfeq5Pr8rmXVx70dEsp16YbOhTbuL/fOULoyO1r8uto24tLc7AXBsMEffYBSEiogwSqcCi2u/c14iw0fC7HL2akgWE4K0Jzd3JyvhDog78hoZhe9hbVnh+cjy8S8F7sfVrH/xeBs3PpTCRfFS126EtH3FN+51hupfcE5WUnu3mHK++6/Q9nN4L2DU6iAl48BZvcjtj3p977NB2Esxzj5PNpjqxp+qg7pli8qUDFqUE+EFJKgNwGPusjB44o/zbjjT6sKkRXvf2eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYEGAKTyg0AFWNXmXkYnN04INZcVqnUiy4v5QzA6q0c=;
 b=dItOA/P5yO0QNYt5MFOPsv4sy21ZNS5W7bxYENh5G3hiclViqQ/AZBqOmkvDzWAgg51MWdt2/D/mH9wNStVUN6gXH+GNyXhEg6rkyCncUfteZ/8gEHOiJlB9HJ14HORFiyU6W0Dw38yII5VV3NTe4o3QiDDDYNFN2hM1ayTxDxbSxsJmNyb8NSVX69m8IY5zprPFj6IyOuYonQFWokVFGlpV4zyH/lqtNdAQ/BxHc/NJFZU7HpGiQkNISbXIae02nyVwBoGp2iPsnb/vqQ/6Iih8ZHC70fGc9Jg9mbPjb0vZUlM0ShdccvHRUUSg/V3tB31u78bHEiwH9eYUDaeXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB6678.namprd11.prod.outlook.com (2603:10b6:806:26a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 22:55:10 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 22:55:10 +0000
Message-ID: <7af17cfa-ae15-f548-1a1b-01397a766066@intel.com>
Date:   Thu, 23 Feb 2023 14:55:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [intel-net] ice: remove unnecessary CONFIG_ICE_GNSS
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
References: <20230222223558.2328428-1-jacob.e.keller@intel.com>
 <20230222211742.4000f650@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230222211742.4000f650@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0163.namprd05.prod.outlook.com
 (2603:10b6:a03:339::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB6678:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b082a14-bf11-40ed-af5d-08db15f103a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGWgnKO/ZwTk6UAZFaF2NA69V6Hn6DBstIMOSFwOV5enrBEO6i4OO82NQfdIje9KxvLrM9v9Nd79lUy49mwUdmxRenU1JiZp2gDngXc2z1qjB/35fZYrsxzXllkMWcKdcFLHTA+qcUt8RUtmaHkbWI20lv08dxissHixFG7XKgr5O1Uz3S8XJVzJ15YZduLuLUD38hnOV5BmSp6hzNtoRU2tONE19YSs8kvxxE17gio2Ru/p8cXjuH5nhnXUcKutMM5qggJHPsN+xzP1Q/qo5+CesynAeCNG5w28uhyzX1DEuRB4sa2U3PuHNJGdLyByn5tn+CdVMcR8mqbr6jbtPtRA4gLaC0lkOp6GrPKpQ2Oyt5Yc3n87yMObft5sc9cXKngGmEP3iKbjWLezTLgbt7i/myooqcCOc4zibKEe1V0B/nlRCHDZ2FLCYoFwafoByRRpcZIm8+RCzdXconFvnbz4QhHZkyN3Gc9s+z+IE9ANdibg814y8PZsumBNZikrvzSCcg4Iuly6+/jNXHcNjSYP8yRj6pRJHJYYLXVtNCMRQzxhcE2TexqtAjATeuGpAVdde6qqTx92lkvl3tRDn0GkpdvOoJHZgLartewPwUtcb3PTwkiQUsYC7cnsWPdb/zoZXnKiNp0BgfPhnoCFnckVoX27mx+vp+ylv2j0pCjxJlS4ap0L0Cf8ZRhEfVMDaOh4jx6TtEJf9LcBhtxi83l4IhO/q3ztbR7ulrdlC+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199018)(2906002)(5660300002)(36756003)(83380400001)(2616005)(54906003)(6506007)(186003)(82960400001)(26005)(38100700002)(316002)(4326008)(6916009)(8676002)(66476007)(66556008)(66946007)(8936002)(6512007)(31696002)(107886003)(41300700001)(478600001)(6666004)(53546011)(86362001)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkZsdnRaYkh6NjBCS0ZTVHE1ZTNQQm0rMVkwdy9DbUwxTyttdWQwQTdISW80?=
 =?utf-8?B?NjVSQS9GUlpYZnR5K2V4cVdtTDRRanA3eXorRm9NTzF5SWh0WldvMUZhR0Uy?=
 =?utf-8?B?QXJLWnZXSnlXNk0wUFF0c2RZMDZhRy9WcEEzYzlxK3hYUW1vajFqQTh5SDZm?=
 =?utf-8?B?aHQ3SytWUVUyWmFpVnpIdkNoREp2VUpVV1lMOE54eUhoU1l1c1NvbnU1T3hK?=
 =?utf-8?B?Y1o1VG5xSU9DT0s1Y2x5WTJmZGdWU1VzQXBKbG1VNXFnOTE2c1JCbTZLT21Y?=
 =?utf-8?B?eStpRVFBc3N5b0JpWWZDRGlLNUN5UFhXUWRNWFdkRXV2NjRJZitpeXVuUXdk?=
 =?utf-8?B?WUd6YVR0RkVlelozWkFicmJwR1F3b1k5K25YME42cVhBMkhsRHk1OVpJYUh2?=
 =?utf-8?B?T1V5K2hWU2lIaGgxKzQySkRGN0tjSUtJeEZGODF0TDZVd3lmTEZnNmpuZ09M?=
 =?utf-8?B?UEtSVENnVE9YbmxzK2RxZ2tES21UVlg3TUR3R0xWbmZJdzBmcG41S0tGZG44?=
 =?utf-8?B?dTRzU2JtbHJmaldid0ZxWWh0MHJ6cGRQaWcvMkZsZEZOVFVlU0lnaE5RYWIv?=
 =?utf-8?B?ZE9oaEJZMHoxdUtMYkk3bndKQjhhSklrN0lmd0FHZVUxQU1Oc0dTK1RvcE1y?=
 =?utf-8?B?RDVxblF4dWdjemdod0NCU1JnVVMrd1VPelFvVURJU1JvSFl2NWQwTWJvVmVh?=
 =?utf-8?B?aVhtM0k3UGQyTC9CS1lWVmNmaHVNQkRNNTJjdjVaYi93U0lwT2xKL1RsTlZQ?=
 =?utf-8?B?UGE3eE04bjJmSkgrNnhsc2RpbDI5K2wxTmswMmNpd1BmV0F3VWJzcUlZY0Jt?=
 =?utf-8?B?VFg2a1dQU1VTUmczVzdOQzFsVzY1MlVpV2pxbUdwVDNmSm1GekYyWmdaM3ZD?=
 =?utf-8?B?SUZxdHNVZ2ErUS9DVkZXL2o2SlpTVkt4ZCt2d0JDeTlLTVdVem1vL3hSbDlG?=
 =?utf-8?B?SEZ6UWZ0NGVLOE9kdUd2SzFneldybVpDVzArcWFCcXM3QlgrdFhaWm9rZW04?=
 =?utf-8?B?TzdMYkszWURnTkJaam5VRHJGNkhGd2xnWnNOdkVVVHdJOGhJb1NETkZCaXQ2?=
 =?utf-8?B?WUY1RFZYeHFtdXVPdEYrcHliN3ZlU2JpeG1SNXN6NE9wT094dCtSRGFYSjd4?=
 =?utf-8?B?aS9pRUNIZHVkQXpNVko3OXVKMnNVcWo0VURzQ09JREg3Y3ZMaFhpRCtCOEpO?=
 =?utf-8?B?NzNPajBoa2x4VlpkNXFsZys5b1ZlOXhlNDdWSkg4VnQrNlF3cG9LR0RNUGVQ?=
 =?utf-8?B?SUZFaUIxcXlHdU1xc3F5cUc3Q2I5ZnpBY3pocEpJUEtPMVk5RUtoZjZPWGta?=
 =?utf-8?B?b3pXQnR0T2R5dENvYXNwaXExSGU3ZHlhQlFoQW91ZklGem54eHJqZlJEMENE?=
 =?utf-8?B?cy9jUEF6S09SOURBQ3JnNnZObnpTWkYrVFVIMVNIMysrVUpLdnIxMTh0SURP?=
 =?utf-8?B?MWI3UTJXTlhvckpPdTl2QnpLS2xxdU1MeDNaMWo0M28vZzU2QUxmREtnZElX?=
 =?utf-8?B?MVo2NFhwR0JHVW8yb3pFcVIwTS9adEU1VG5EV080cnU5WFZXaHkyVWpsbG1j?=
 =?utf-8?B?ZkRKczdIbW02T2VRWVVkSTJ2UzJXdEQyckRFcXNuaFhEdFVGb2tnZFVaRm5i?=
 =?utf-8?B?L0tuclpMYTJvVE5qZXA1c1I0N1kzSzkraUtsNU1vVjFtOVUyM0I1RGp0R3BU?=
 =?utf-8?B?dHhUTHdsbWlNTnY1aVhTUHdMcW9mMUxxUHFvYkdaTkhjTE5CV0xoTXo5RVBH?=
 =?utf-8?B?eDVlWXh6YS9CZVpkSnBjZmF0U2JyWEJOQWdoa3JDUys1VVB2UFp4MkhyMk5Y?=
 =?utf-8?B?WW9BTmFyMG5CZndEWFJDMlZEbjhmN1VBSTNleS8vbFVhbHBHdXNYMVk2ZlVY?=
 =?utf-8?B?ODdYcXl0ck1hYlRzZ2FsUktidWdlUUIxd0k3WVFkalZHT0E0dTNrT0VqeWdx?=
 =?utf-8?B?MWl2RWdMNUdFTGZWNHpnT2Mwc2ZPTkU5RzNtYnQyTk5hV2hBWWxiZVhLOWNZ?=
 =?utf-8?B?THdUUWg4LzNGbnAxT1Z2UENQcnJUa1FCcktnK1BEM1NraUNFZE9VODNVWGZa?=
 =?utf-8?B?eFBodkluY3dxbEVYNjBlRE1KVlhNZzQ4eXNVcU94TE94NkE1bER3TmJJK0p2?=
 =?utf-8?B?cmxXeGVQZUFMUVpUaDMwT2EwNEtpd1A0aTVudDhObUw0RWg4RmRtM0pRSEgv?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b082a14-bf11-40ed-af5d-08db15f103a1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 22:55:09.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pklTiU/6L5V1OK1xVf3tXqnxYJ09EJ//l8HJbYAWNER2FYPbgj9cT6Em0Nq/QPjSuFes0IGonM6SFjmwz3rYD9ESma1dzA7r2Ymq8bAfLG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2023 9:17 PM, Jakub Kicinski wrote:
> On Wed, 22 Feb 2023 14:35:58 -0800 Jacob Keller wrote:
>> I'm sending to both Intel-wired-lan and netdev lists since this was
>> discussed publicly on the netdev list. I'm not sure how we want to queue it
>> up, so I currently have it tagged as intel-net to go through Tony's IWL
>> tree. I'm happy however it gets pulled. I believe this is the best solution
>> as the total number of #ifdefs is the same as with CONFIG_ICE_GNSS, as is
>> the Makefile line. As far as I can tell the Kbuild just does the right thing
>> here so there is no need for an additional flag.
>>
>> I'm happy to respin with a "depends" check if we think the flag has other
>> value.
> 
> Sorry for late response. Do you mean depends as in keeping the separate
> Kconfig? IS_REACHABLE() is a bit of a hack, makes figuring out what
> gets built a lot harder for users. How about we keep the IS_ENABLED()
> but add a dependency to ICE as a whole?
> 

IS_ENABLED's problem is that it can break if CONFIG_GNSS = m while
CONFIG_ICE = y (not that many people would build it as a builtin...)
unless there is a dependency involved, but the original code allowed
building ICE without GNSS.

We did the CONFIG_ICE_GNSS but it lacked any dependency on ice = Y, so
it was getting set regardless of whether ice was building.

The solution with depends I was referring to is Linus' suggestion with
adding depends on ICE to CONFIG_ICE_GNSS, or otherwise putting it in an
"if ICE" block in Kconfig.

> I mean instead of s/IS_ENABLED/IS_REACHABLE/ do this:
> 
> index 3facb55b7161..198995b3eab5 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -296,6 +296,7 @@ config ICE
>         default n
>         depends on PCI_MSI
>         depends on PTP_1588_CLOCK_OPTIONAL
> +       depends on GNSS || GNSS=n
>         select AUXILIARY_BUS
>         select DIMLIB
>         select NET_DEVLINK
> 
> Or do you really care about building ICE with no GNSS.. ?

This would probably also work, but you'd still need #if IS_ENABLED in
ice_gnss.h to split the stub functions when GNSS is disabled.

The original author, Arkadiusz, can comment on whether we care about
building without GNSS support.

My guess its a "we don't need it for core functionality, so we don't
want to block building ice if someone doesn't want GNSS for whatever
reason."
