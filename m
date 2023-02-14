Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED1A6967C8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjBNPRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBNPRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:17:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99F818147;
        Tue, 14 Feb 2023 07:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676387831; x=1707923831;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WLfviKR68tfNRa81W18kyBJsekbZaWgoc8ZQplWeoQ8=;
  b=dxyB7MmgaKefK9w/wrzI4mjh9x06PRJDDifYxPn4efH3khc1fEIOIFbL
   TRfkdyGQacjV6VTtU4+ngrp3XmyDyWEfynfpkb0HH7R5urMpLeM3FPBX8
   33N89whA3F4NdgMNtDi7rS6LwwumEYk/duGWSNLzUEZA6OFDI6qDIOtHl
   MXWjFmEhPUAc0H7Bv9EppdcAjckeT+eYCO+N5wt/SQi7+xgCTczDIvip3
   LQllxyL+PRs1fTtAnQPZRrTdeiJAqU7clTl2iaehBFMz0aSX335bv2eYd
   rtr0aGDtim2TyABRvG4It+AVMVVHGOYatOPkKw5YbsbZzrVhVjWbcVAJw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="311541074"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="311541074"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 07:14:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="843198667"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="843198667"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 14 Feb 2023 07:14:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:14:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 07:14:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 07:14:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4usCTQWHumigP8/DuZZAPJFlhOeae41GxSlDqIhG/DEX48EiVB+2XuAs5pBzf/O9Ork8owjEr6UIujJG+IPLKV6F0UPSgzMDM59Ta/CB3F6JQSTfqvh0JByAzkWDlNjrJc1hUB3LFthGeD8ySNl/pmNn/SHs4O2vrxDrojY2wpcsZ2yYeSvlIahrxEsplVNMHhmMb6/OLyGMmIa1XOqVKjsD/AXh0NS0APgpuCVGD25vodiNojWqGTgTy6smtcfQLyEdunqLWHatJsPrIscxn5spdk9jPEQnTPA2ZzLkqdRdxQCPKwtmuDuWKu/XIcabgv9WFxXLW7DiEZXc/I29w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zbgWaAvcta/qNWonQbK9hcWzzcnFarEaW+bHCyIwjM=;
 b=YjcObUTINByaIJ1QsifnLp0JDsQ6fbXVxf31gcGgbNTcCwcYO+27RfQmq1oC6IdeVFJE+gF1QMiRf7Fxx8BpcBAh/ERTXA8CJ4cmXLU08fhyBa0lkcasqziWlXf0qqjJYhA2X+HkVyrzg0n2UKRBTnyae5kHSDhPMYVMqBjam+ticFf7mnyoc3NoRb5ZfrUtXSk2n6+w3ImfozLk+sy5+AVJGCjN+eoMI2YawSLOuxszR294hfR5P1f96e1wdQwEUu48NoFccPSH5HZ9HPNxRwd4dZec9p6qE5c0cyGIoBDdyIgVHvknrHIpuf1KwYQNGDLikodUxRGUYHfhOtLcwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB6068.namprd11.prod.outlook.com (2603:10b6:8:64::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 15:14:15 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 15:14:15 +0000
Message-ID: <b6143e67-a0f1-a238-f901-448b85281154@intel.com>
Date:   Tue, 14 Feb 2023 16:13:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [xdp-hints] Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable
 and fix RX hash usage by netstack
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>, <bpf@vger.kernel.org>,
        <xdp-hints@xdp-project.net>, <martin.lau@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0187.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: ae6f766b-d7a6-43b4-bad5-08db0e9e22db
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7uLw9jzyWBmuPiItFsZgrgxxsCOXvd4SPgUxDM1EzAFKO8BSRpCq6YqvSDi2BnNrh2uTfWMfXjqFKeEjji5xSwvOkCX3CQfrbhzx00kITsOiUqqD29dNV6Nbc749UOE252/im8bD6YZCnsvSEPE/HJOicfcsiLISJ1i1Jt5odzoAcI6E4TZ/TQmas5WwJ+eP/8JDUOk/t7iT+0dTb9YUX7NGHxVXCCChpXeenAoe2QwOeOq1v/6mDVTOn73uWm+mgX8wCXUhphx5gUiRM0XxpieaskRN3qdduD53At6f/zuIrKPxdDPM0HiseoebRNp80RkNsS9juVfnQpsZzuN9+iduth0ANLb/fqQoZR1nPpvZCijPAWlIWJlLsEAca9BnX6DzbsBxmM4RtkRyp/7ZEjhrvla2aF8jNYDqiFJAl/s1Au9vivmxvZHv4SWM2TF2ahS7IwlArLZPmaxL+1NJNzgZC+tjG3Pmae6t1lPCR+PIGSt9dqTfEERpUQK8W1z6u0b7PIsGDietsdKNklLg4B221JsWABZMhbJNYMCsorp483oZmsLHTz9df1Ti91c+9DbBkq2k9qmoxj/Uu57g40FFJAS8Gn8qSX9AxT6o9hk6HsRRjo1SiodMl3rd6VF0SMzMN6Bi9J9PF/3SgbysB2CrXRHgVaz4SCp7k9X/zAfrWw2VbZOjsKnnv6+n6I4DFHF/UXAB+HmYaXlmkTZJSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199018)(4326008)(6916009)(8676002)(38100700002)(31686004)(316002)(54906003)(36756003)(41300700001)(83380400001)(66574015)(82960400001)(2616005)(66946007)(66556008)(66476007)(5660300002)(2906002)(7416002)(8936002)(6506007)(31696002)(6666004)(186003)(26005)(6512007)(478600001)(966005)(6486002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amh5cUxqN0xqMUlrZGtza1JUZXlMdWFBVGRReDB2Sy9Yakw4cUVHQ2tqQlgy?=
 =?utf-8?B?NFZoY2R4ZERZSy9HbitPMVpQV0hlakFuYVpPVWxEZWZPRkxpUlhFMzBLMWZu?=
 =?utf-8?B?Y0tOQ0tjd00xMWZ5QWpPV0VsTE1KUS81VnVWRVhKZkJFOHZvRnF4ZUdPcmYy?=
 =?utf-8?B?ZCtKSCtJNkxZNzZDbFA2cFV1QUlGOEhDc3JXUjFuVHowdEVMUG11RzVvMUxE?=
 =?utf-8?B?VDR1Z3BlN2tCajlsRnFqbjRjNk95cnVZTEEzLzhxbnA1STdUaVRrblRrT2dp?=
 =?utf-8?B?a1RrcEtyaGVUU2JaSXdIbHNraDRhUmhCV3ZEeDg3dG5abE53OG1BbHlLeisz?=
 =?utf-8?B?dnJnY2pPZWpGQXk1VDUzU2s0Rmt4RnZ4bnI1U0l0RTUwM1VOK1FzL2hTOGFv?=
 =?utf-8?B?bkxHVEx5OFgxYVBQU1Y4UVNWdkd6UVQxL2p6Y2VsQVluQlhlOHRnL1I2Z2Ew?=
 =?utf-8?B?Smk2YjJjbjNWY0lFeTV6aHR4b1ZtemJIWFJXNXE2Y0lXNlVOSm5lK2FOTzZq?=
 =?utf-8?B?STJhbjV6VkhwZitXU1kyY1JWdU1pcFQwYnFlRXUzQUJKM00rNUlxNHdFZkdQ?=
 =?utf-8?B?djd2WTZwMnNHYmRNZkpZWGpHQTMxelFXZTYvOG9mZEpJSWNLTXJVQzd3T0Zv?=
 =?utf-8?B?WnRJWnlGd21LNFhMaitWYWp5SUk4S0xnL3Fpc2xlMnFaQ3hxNXlKeUllRCtq?=
 =?utf-8?B?dktrUTFzamYxa1FlSXBjbTZqZXQxRUZKTFhlSGs4V012SGZEZTlVRTE0Si9V?=
 =?utf-8?B?eEs0OW5SditoU1Jsd1pNQTZ1Nm5tczFnSGIzb1BYOTVCRHFSM0ZrNUFaNEw5?=
 =?utf-8?B?MFllaCtIcmhoVlBHQnJZa1FTRDdUZlZQMHJZcy9FZ0JQR3l3eEluWndxVkkw?=
 =?utf-8?B?S0F1ZmdSZGFjWHRqR3FoTzFWNFkzVGprNzBMb3hDdUwyWVpDTGY5dkhUN2JI?=
 =?utf-8?B?TE1XU2lWb0xOa1BweFl0K20zbWo5RUNmTmtzUUVnd1dPV1ZUQzllaFVxS1lZ?=
 =?utf-8?B?UXpvZUVuTFl3ck1FM3VtTGd2Z1ZuQkFmYmxZWThJbmwzcEJOby9BZHJoZU9N?=
 =?utf-8?B?SnoyeW5Gd2hJVWh2MzJydjNDeVZWMDJvWEdwMVJWZWxGeEFZZW5UdWNzOWJl?=
 =?utf-8?B?alZnZisrNEwxc3JrRFcvbXprTE04OVU5a1lCMnk4VFlwUHZ0bFUxdTRYY3FN?=
 =?utf-8?B?TWVPRVl2aFlJV2lDWEU2cjZnOUp1djVNNVBwR2ZVdFh1NVBEQmU3U1dKUUY3?=
 =?utf-8?B?bm9mZWlNZ0pyOTZmNkcyakI5ZHVSRzNaaDk4TWRKeW9JRjU5OWo3K3VqbHdz?=
 =?utf-8?B?clNFc0gzNW5VcWNjaUdqWDgrSlErbDdMU2J6WFFlVlhHREhMdmRyQ1ljcC9E?=
 =?utf-8?B?MmFBZDE2dis2dmJQUnUvRmkwU2x6WlBPQlMvYUQrRXhoblZjUFRDNnlBSFZ4?=
 =?utf-8?B?bXlsVXNzS0NFQS9zcmw5eis4OVlPcFZEcEN4OU9IOFZDWDY2aXlVV2QwZ2Jl?=
 =?utf-8?B?ZWlKUk9EOGVyTkl6S3IySnhKTTQvQnM1T2d2b2FRNktOWVBuc1ZmK0xISEtX?=
 =?utf-8?B?UVZJNnR2U2xBMCtYV0VBZUxtby8rbWtVRFUyeFZnU1JLa1NsdTZhSHBKY0c5?=
 =?utf-8?B?aGhaWEhIbzA4Mnh6ZDluQmQ0UXJ6cS9JUEhsdzcydmtJVytWQWJFRmUvczkw?=
 =?utf-8?B?aWdRZ3FTTVNHRmN3UGp6UVdKL05YVTYrYTVTUGh5d1kwNHRzNjFKREwwZW1i?=
 =?utf-8?B?blFaN1JzOVpRM2UrRXVKU3RWQkliUnc4aXlMakdUU1ZWdlBmTGxaTkZ4WnBJ?=
 =?utf-8?B?c0RJZ1cvT2NmeUVyM0RKdGk4SkdOZlZ2QUNZbEtleHRaRk4xNFhCRVBTSXZC?=
 =?utf-8?B?a01tU2cxbUNqQzZpbnVMQ1E0cGc1c0FRY2F1Mk5LYnFWcnE0ZGFvaHhqUTZz?=
 =?utf-8?B?MTI5MlVSUlNzejZpL1QzeVVtb3BwRTc0ajdSTDEzYThvdzRCN0tYbVR2eXEx?=
 =?utf-8?B?dWVJMU9ZalRkUFRMMDk2NitYK0xZOUt2NjhyNUVSNzYwUjdLWWc2MW9abXdL?=
 =?utf-8?B?RjR4SHBTMnRrNDVKa2piOUVRYjBuY2wvbUsrS3RpWkluN3lGWDVIMEtJUnBB?=
 =?utf-8?B?WUxwUVNtaHJCanBUdE9IdnJpbTZsODdjTGEwL1Q1L1pzbWVVbTdMcWd6L1Nt?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6f766b-d7a6-43b4-bad5-08db0e9e22db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 15:14:15.7066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QuDoeRPI5gfjRX5Fnx73FIKY+V0KwcEuvmQbp/PiOIrE8hrgXViHNIaER9aZqRkAaHv82+vH5Tp+67hp24yF+QISz1OmuUCGsoymjou/jY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6068
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

From: Paul Menzel <pmenzel@molgen.mpg.de>
Date: Tue, 14 Feb 2023 16:00:52 +0100

> Dear Jesper,
> 
> 
> Thank you very much for your patch.
> 
> Am 10.02.23 um 16:07 schrieb Jesper Dangaard Brouer:
>> When function igc_rx_hash() was introduced in v4.20 via commit
>> 0507ef8a0372
>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>> hardware wasn't configured to provide RSS hash, thus it made sense to not
>> enable net_device NETIF_F_RXHASH feature bit.
>>
>> The NIC hardware was configured to enable RSS hash info in v5.2 via
>> commit
>> 2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
>> forgot to set the NETIF_F_RXHASH feature bit.
>>
>> The original implementation of igc_rx_hash() didn't extract the
>> associated
>> pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest
>> portions of
>> this patch are about extracting the RSS Type from the hardware and
>> mapping
>> this to enum pkt_hash_types. This were based on Foxville i225 software
>> user
> 
> s/This were/This was/
> 
>> manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev
>> 03).
>>
>> For UDP it's worth noting that RSS (type) hashing have been disabled
>> both for
>> IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP +
>> IGC_MRQC_RSS_FIELD_IPV6_UDP)
>> because hardware RSS doesn't handle fragmented pkts well when enabled
>> (can
>> cause out-of-order). This result in PKT_HASH_TYPE_L3 for UDP packets, and
> 
> result*s*
> 
>> hash value doesn't include UDP port numbers. Not being
>> PKT_HASH_TYPE_L4, have
>> the effect that netstack will do a software based hash calc calling into
>> flow_dissect, but only when code calls skb_get_hash(), which doesn't
>> necessary happen for local delivery.
> 
> Excuse my ignorance, but is that bug visible in practice by users
> (performance?) or is that fix needed for future work?

Hash calculation always happens when RPS or RFS is enabled. So having no
hash in skb before hitting the netstack slows down their performance.
Also, no hash in skb passed from the driver results in worse NAPI bucket
distribution when there are more traffic flows than Rx queues / CPUs.
+ Netfilter needs hashes on some configurations.

On default configurations and workloads like browsing the Internet this
usually is not the case, but only then I'd say.

> 
>> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control
>> supporting")
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

[...]

Nice to see that you also care about (not) using short types on the stack :)

> Kind regards,
> 
> Paul
> 
> 
> [1]: https://notabs.org/coding/smallIntsBigPenalty.htm

Thanks,
Olek
