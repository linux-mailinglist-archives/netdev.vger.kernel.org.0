Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F8463B5A6
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiK1XJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiK1XJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:09:25 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6BC2B637;
        Mon, 28 Nov 2022 15:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669676965; x=1701212965;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F7KyQUzdceXS70Hy3yXe6uP5uwum7IYfhv671wjSwwE=;
  b=BXm83W+4/BxV8GjBAjiUVHfzwK6wZxt3z0giNdLKVvipArPd6Ea51ibA
   tZ5GNKgiSQdcvd8pBqsLAnZe2CiYWvkeelRiAZzkE0XnsaOra2BeBH6TF
   Ni55ZMRSDioDgECEK+dKBAyGsR4J1yU+4EAgD/lGPewkjRlxCNkmej2mP
   Ga515rSZadaMwLj5pJY88uyuf5BEW+qDFSImN8qZkCrzajUYufnbQtp8S
   jqeSQiRgtJTf+eryg6DTaGrWLX9qpAsAhI46QpqL1m+Fpi0ZTKt30Ts9P
   mo/QLi9W7ou93SKA/T0pKEVoIIT4sNHTFgAwPyaGiAvOq1Xngn6vWjb1w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379229690"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379229690"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:09:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594046020"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594046020"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 15:09:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:09:23 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:09:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:09:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJS9ZNwdBcMcjexnjHjZ4TwVqw3uUabK8rkbnuro0CJZ2N7u9lf0KShYYGHJGoV6+ospMS8HbWn9Z8ycp722H1YPdudAFZqyq3Nc9BwyTXa4iFsZNW+Fl9XeXUbRfqQ3WQaCTasonlyaxxcQHdt5EN61zUfPfGPRAgvtpO7m04OftS2TGT8SUUkD85VTgiThnt/UTU1DukOX923LguiyWmn6fgC4186U0Fbq3Mm8JOHbO0eKX5xjQM0VWpbsCoGrVBa0f029FfayjUGkzVX65TqWa5itePVwDruF9zzVDCI2QJZeWcjNDn5w6k2sOMRXlIJBgB8FwMNNb9a9zubbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vU69Bxa5aVU8KOoHkujsjyH8GHixS3bkRdQaHwybsQ=;
 b=bY4PN4WXgAAuzjKMOa6+u+HAJKOM5NIngdwjrST3Y1k0z1Iy3PfvYuEyZx1omXjplzgOudPriSQqUmz9F1zZkH6ic4Hl9HXEQglCHSCkX6gy0ZW5F1eKIZDCGsmgowB0ARxhOG+oWxLd1zRcoRvpJbtQERWPPUrWEuBHxXYFUIHm3rLcMDu3X2K/CSG2XGc8Q14dkAeLCghUUSVJND19Pul5UcQTcunWJL3tHFtj3fZgrRNaVavWYYEEYsV7WSbfFCBF/wR5KltFZ9DYnDZ7PbZzz8gyJZM1PCIaZfJVwWHn7FXDWzx8DkPwA3llHxEPyuVbP9G/NwPn846bm/DWyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:09:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:09:21 +0000
Message-ID: <7f0a7acc-4b6b-8e33-7098-e5dfcb67945f@intel.com>
Date:   Mon, 28 Nov 2022 15:09:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 00/26] net: dsa: microchip: stats64, fdb, error
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <Arun.Ramadoss@microchip.com>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221128115958.4049431-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c285c69-d686-4d2b-e036-08dad19595ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiBhkTIWi6YDd3En2NqYhzYevMy13NR4xTu/prmPWf4ROD+4lmSwpjQy+hGUsPtL5ngDnahz1AKiqIA+thB2hkUgtd75h4aqERsEPKwyP6EMePJgcbwBxC/com5FyILFmoijQwGDIdnEg9OWztz+oYNqpn+6FYiSYr/tNshR83R1jCXXK1tWb/H7sWttENwtV6cp6LdNzsl5uEhWI20Wb1OJvbc/G8LuksWKqJ5soVr6z4F+GX7pXysWjmy15CWk9EuMKLnQzyz714uuIVtei/8nMzS0RClE4K9PNValUiSChLPBdhcWn240wUEb6z1PglL1bKApcqmS2SfaeW63qX7BPL1uPovtpXYwvwCwKyzuSVc1t1xxjC/XAPVTGHbaUQnTWq8grEdsJRvb87ButmAFS0vMVkRu0Jp4VeBrc7RzOWgJ0IeR1vPP+y1/3xCzosxOJCGE/setohUhHFwnYPF6yoaCBN2cnGrOPIGM3l/v6ngbCLXdddhSdzTy9pOu5gNPbCZuqtXTrub08BSXeJHpFN9Rt2upf82sm6WujQbNVcicPg8EHjSGilH7/GrQ9EbxiC52iMFHWaoCl181kBjEExcFx9Yx5Y0DTc+7FT3P+/QXwM/zEf1ZmCubay+PzBAzN8Gbo4bD23zwEotcbM5vTk2hWmwzG0yyDuxnpSQkFHpg5I6YlFMlELYbwOLXI4Ae2wgSbCoZWoQnCt0sahZ/iP0T97qTgqTtZw762ZyB9o9SW8d1uZkHUwfoYb55
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(31696002)(31686004)(6506007)(6486002)(478600001)(66556008)(66476007)(4326008)(186003)(2616005)(41300700001)(36756003)(8676002)(26005)(7416002)(6512007)(316002)(53546011)(110136005)(5660300002)(2906002)(83380400001)(86362001)(82960400001)(66946007)(8936002)(921005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXJTVFBmbEpxR2xxTDhhZGxScnBNMlZsSmJIL0Z2a2dhWDRHbHk5Mlh1Sndx?=
 =?utf-8?B?MlVzZUtReFJmMElGZUZ5K1lTcG9DU05odERBUXpuSitiRWs0ZXk4THpsQmMx?=
 =?utf-8?B?dTExK0dSbjlDSmNoaFFEUHBPdWcxV0hnRkF4dFJjd3k4Tms2S3lDK2ZPYXVi?=
 =?utf-8?B?dmFBcFNobm10bXd0SWUwdUtzOGpWN3hHS1ZqSjdITHlrSXgydkJmUWlqN2tM?=
 =?utf-8?B?VkhBOU1mNCt4bTlva0pZMjB0NVNSRGRsdVBTSFBDRWp6ekFsVlB3L00xalFt?=
 =?utf-8?B?ellvMGliL0lBOWR5U3QzMlIxSkxLc0FCOVJlNFM4TXAxOFVqdm9WWG5weUYx?=
 =?utf-8?B?clZIWEdnNDBTWXZYYm0wWW8zYXRHVVhwN0tNU1MvU0hFTEZPYU0rQyt5dXFJ?=
 =?utf-8?B?TGlLZEJDcEFZTjlvQW5NSFJ0SDVNVHc3elJ2OFF3eFJPTjA4bVU1RWxNK2Rk?=
 =?utf-8?B?MVNaTVl2T2wxNk9DclhOdElpaFE3K1RhQXlBbTl0aFpnUC9FZnZVKzJFQmxu?=
 =?utf-8?B?UEw0R3VoUE0rejJLb1lTN2dVRTlLRGhHdCtNM0tRZzlMbTdNb1ZIYjcxZXg5?=
 =?utf-8?B?Tld2L213OHNYUHBPQkNsdE9nQ2JxZkNha3owS0g3UElScElUSHJBSTJUVXZI?=
 =?utf-8?B?TndldFZPN2lTOUtMNndZVURnOXVhZlNzSGZ5czlobzVpclQ5c2R4dm9YbGUz?=
 =?utf-8?B?WEtGNFZFMFNqUWVRYW1BeU50dVY2UGgzaFdqUWdFZHNxWXU5bFFXZDkyVTVS?=
 =?utf-8?B?STdLbFJuQ1R2WG9UcEVYVUJTMzNUcHVyQUk4WE90VkZncW5tTE5pY1VBVktm?=
 =?utf-8?B?VWZrcE9uK29UZnJMMHdLL1pZOUtwNzhBYUlZTEZac3hRNWZycUJRc2RRSXdx?=
 =?utf-8?B?WFVmRDA1NkhZNzNHOTczSWEvVW9RUU5YbHAveUFVMTErN3hpYWJxTFh3NG81?=
 =?utf-8?B?M3pERTUremozZGNDU3pXVzFibHRkYkdUM3Vlb0RHaWI5S3BaTGp2cnVuTVpr?=
 =?utf-8?B?RlhFL1lscGxZWWNWZHUxQmZJR3FHa1hmL3ROYk9iejAyZWhJZDRkWlRRWjJs?=
 =?utf-8?B?UFRIMFBvMm5ybTdVdFZzKzFCZGM5ekRkMS9hY0xxbHN5VHJ0Rlk0VEZGTUhj?=
 =?utf-8?B?b1p4VEUyRUhKOUZOSDgvUXpzV1IveU80TlNHZFdmcmFiWFBIVVZzc293dXEy?=
 =?utf-8?B?YWQ3ZXppaDNNbktRb0Q4Y0FqbGRnQWR1NDZrci9PZXg2UUNUaFl4ZS8rQ2J4?=
 =?utf-8?B?VnlDa3RyQmd4TnlLWGI0NkVvN1NGQWsxdVNHcjZDOGhzZnBsRlZ5TE1laFM5?=
 =?utf-8?B?SGw1cElMcjlocHZyNEUzVzBZOGk3RVFXbEFuSU8rbVpzN2ZjRE0veGlsVXRO?=
 =?utf-8?B?L1lPRy8vNHRvS2t4eTg2QVBwNDZKSTlvRDh1RUs4S3A3KzJnNllrM0JDcVRC?=
 =?utf-8?B?OFVpL1NWZmdmWE11bEJlUmdpWVpIcS95eG4wbTJ0WTZsT0RBNnpaVGZHQk5u?=
 =?utf-8?B?TnhhTXJGb2JHK3lpd0lJaTRKeGthSnlTNzVSMnV2SCt5ZmJ0ZEZzZ1IrTkl2?=
 =?utf-8?B?cll5dm14elRKZVhNbE9ST1M2cUpvYVduTGFyaEFnd3psR3FLR2taOG15S1N6?=
 =?utf-8?B?LzFXS25SS1JWcEhzMS9LV1hMdnZ0WGQwbHNBUzh3ZXYzclhKUU1yQ0FxMXBQ?=
 =?utf-8?B?bURjbUJuaDVGa3RGd0JkU3lPRGc0SG51UWdkOEJQMFluM012bzJTOG5Rd05V?=
 =?utf-8?B?d0ZlNkpOYjJrSGtnRFBYbzF6U0dOdUVOQjJDb0FMRmFmbVhERVY2c292N0R6?=
 =?utf-8?B?S3lkb2h1ZlI5YmRaN0lhSkd0WVZvcmFOeEZoUlg2N01ReU53bUVTYTErM1Bh?=
 =?utf-8?B?T2hJZVBSQmlxV0p6Ykd1eHdYUXJTOWJoSUNZcDZTbWJTaWhuVGkxUzQvUkpj?=
 =?utf-8?B?RW1NZ2ZnSkUvM1Rrell6N1NUYzl6OVNxTEd4akFKTkc2UDUvY0M0dWlBdk1u?=
 =?utf-8?B?TmhyMGdpd3Bqb0d4TlE5L2dudkcrT0VlM1paZGNmbzh0MURzbjcrYXVGR3BG?=
 =?utf-8?B?MGpGRGtnNEpmQ2drUUU1SzRIT1BQUnRkSTVjZjhmbkovMlhTQWw0aVozWHlE?=
 =?utf-8?B?Mlc3VVIxbkNDL2c5M0pTVlFVa1BMb0wrZmM0b2JKZDdxWXdCRFRDajl5bS80?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c285c69-d686-4d2b-e036-08dad19595ae
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:09:21.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/Yw/tlF6Taa+MWS95tHL7EVefYkDaNPo09BIiruCobjVsHliwSib9F6o9KJcvBFFj+jkaEt6ccdayOFMKcm94kpmxVWUDi7K2CrPWoHMHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
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



On 11/28/2022 3:59 AM, Oleksij Rempel wrote:
> This patch series is a result of maintaining work on ksz8 part of
> microchip driver. It includes stats64 and fdb support. Error handling.
> Loopback fix and so on...
> 
> Oleksij Rempel (26):
>    net: dsa: microchip: add stats64 support for ksz8 series of switches
>    net: dsa: microchip: ksz8: ksz8_fdb_dump: fix port validation and VID
>      information
>    net: dsa: microchip: ksz8: ksz8_fdb_dump: fix not complete fdb
>      extraction
>    net: dsa: microchip: ksz8: ksz8_fdb_dump: fix time stamp extraction
>    net: dsa: microchip: ksz8: ksz8_fdb_dump: do not extract ghost entry
>      from empty table
>    net: dsa: microchip: ksz8863_smi: fix bulk access
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): remove timestamp support
>    net: dsa: microchip: make ksz8_r_dyn_mac_table() static
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): remove fid support
>    net: dsa: microchip: ksz8: refactor ksz8_fdb_dump()
>    net: dsa: microchip: ksz8: ksz8_fdb_dump: dump static MAC table
>    net: dsa: microchip: ksz8: move static mac table operations to a
>      separate functions
>    net: dsa: microchip: ksz8: add fdb_add/del support
>    net: dsa: microchip: KSZ88x3 fix loopback support
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): move main part of the
>      code out of if statement
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): use ret instead of rc
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): ksz: do not return EAGAIN
>      on timeout
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): return read/write error
>      if we got any
>    net: dsa: microchip: ksz8_r_dyn_mac_table(): use entries variable to
>      signal 0 entries
>    net: dsa: microchip: make ksz8_r_sta_mac_table() static
>    net: dsa: microchip: ksz8_r_sta_mac_table(): do not use error code for
>      empty entries
>    net: dsa: microchip: ksz8_r_sta_mac_table(): make use of error values
>      provided by read/write functions
>    net: dsa: microchip: make ksz8_w_sta_mac_table() static
>    net: dsa: microchip: ksz8_w_sta_mac_table(): make use of error values
>      provided by read/write functions
>    net: dsa: microchip: remove ksz_port:on variable
>    net: dsa: microchip: ksz8: do not force flow control by default
> 


My understanding is that we typically limit series to 15 patches. Do you 
have some justification for why this goes over 15 and can't reasonably 
be split into two series?

At a glance it seems like a bunch of smaller cleanups.
