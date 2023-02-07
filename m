Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4008C68CAFC
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBGAQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGAQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:16:08 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E355128D29
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 16:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675728962; x=1707264962;
  h=message-id:date:from:subject:to:cc:
   content-transfer-encoding:mime-version;
  bh=sDjVUi9HfDodiXMBg+rHty0WoTD/ghOUoGyg/SDDSoE=;
  b=lJMUMu/Yrt/L65/4uu26bwM3yykaeL+VuN+FoGohsj4/gOt49nqdZDjQ
   6RslDKe1sndYPHbVXf5QbvWpn2ZbPK/6jeExhxGMMEqypEoLSIyV3FcUL
   UPTuD+lX2TH8itgp4NlAh1ffxJQZwSPdzsDL9FwB2j+WR4BlxrYlooNyU
   gVr3n4DIOuQ8TylxPoNHkn078dl4Qfie5TkM3JNCefvrCDKuCnG4txMLN
   dqPN139yd5HP8m94ydeTG22zuJVAqlQts3Nwm5vCtBYZWjF6DxMY56pdK
   LLaMT7MPZs1NKdgXbLvmndUWPZ9Qb/oYuzuAIxpYG0wdmnNGUNJGHwlE4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="331491065"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="331491065"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 16:16:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="755428925"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="755428925"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Feb 2023 16:16:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 16:16:00 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 16:16:00 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 16:16:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eiwb6vMH3RaKAsZslAxQ/rQFy36TyW5R2NJ2mXyu+HrK1CMS5c12RzD8ja+XPq/wmUFGyGpyuTxMk5PvPU9hfmaTpRWq0m0EMtIk9UDxSY6WCVAa2idVwefeqInEhTEG9jReOx3J11wINFDEtYTEIpbjuBLFKVfXal9/fPEWJiJoE2HnUBC5lcJ5NON75yXsl7CIYjnnWmQ5+wOW7wbf5oFFTcEVjrwEypJP9ik5eewAFlGV+2gUs/oRkIAYK/wIxIxAJD06ewiVJhS//xfCIGX4gGLDz07wVmPqMtuFQb2WR5BME0p2orUW2x1k6eQq0D0lK1v4+4AdoIR3sNB0wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MK0SgbH91vDyuI/zRFa1XEanYuZSef2/W5h5pAegxsw=;
 b=WrsZJKhPSPnAH6YdWk1uOFWnFHBUoYjMzut93B+yxR7HkdMiomGkdnD4Ux7DpNWEJJ16AawzLRgngA5Oj2UW6kTbutmrbdEOBUfVx4WgxVjm7RapTiWbfVVNhYLkW0QvNDNQbny9b+iOivpo+2n9BReslS4LYA77ucjK64j2CELHEZvw3s5dTOl2FRUBXaM8RKo90A8aBLASG5l/3gXH7YQTKQ5D6IbmDjbTO7hrQ0jaGCLEM4nym0GKN1HJEqHVqa8JvzbCxRWG3SNXXcqcV+IlyyFf8FaXJrar6lP2jGYkubxdwWmrKLZ5EPTAx2/+DqU6dHySe+GlWoP/LyivEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by DM4PR11MB6239.namprd11.prod.outlook.com (2603:10b6:8:a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 00:15:58 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f%12]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 00:15:39 +0000
Message-ID: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
Date:   Mon, 6 Feb 2023 16:15:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Content-Language: en-US
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
Subject: Kernel interface to configure queue-group parameters
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, Saeed Mahameed <saeed@kernel.org>,
        <alexander.duyck@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To MWHPR11MB1293.namprd11.prod.outlook.com
 (2603:10b6:300:1e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR11MB1293:EE_|DM4PR11MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c44fd1f-1c8f-4f4f-cfb8-08db08a070ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rEoT15oO2h5ihJcJ/WbBiwR0w/lJplOpNGNxwzH8hduC2ykMXjtJcbStwM6gZCFq67cFpUjOs2xFiPp3YDvqgWQOKw+0aSlblao37DN8lxHEY7f7GMXx6ZbcG0LBKKpNviZXCQdhmx1uSvVz4oWry0FrFH5WIVVc8vEB6zViggSipMePXrvnMQMU/1QBSdSBsJmSS5hsIswUpOMJSB76iYep35YzDub629nNcxw0dqZk6KJc6QQdR5Wd/RQ/amYbEfD/42d3byfZ7brhRNwyJcG9r5Eyb0BaryfSSvNkt4bblXkpGiLvk7Bx5x6OZF91fc+FVuUJhO31rBeSwiJm3yu9Ptw/4tNxq/HY+FysmN+UGzBdq9HLm8s1s7KTCjUH19LrBJWx1Rs6kkLm5MwtHG4HEWjB0Olq3kVtOmQzUhYNA/dXiqKSKhC1bZJECMT0K/hkEx6sWs+rdkJTl5ONhJ+0+XkAivndnP9+C0/41NRdJSXvpk6BNqM9C6DIxGOaMExGEobRMFg/wfB/taZHuy1cdtNtwlM+4ctkic8Yk8pUbFunG6EU/LzEaEJsGydaT3N+s5IiJErbebrBtFsU7eXslM0YEjrEuYi9XrElEBQlQMYxFkqXpxDvxs/tcdug7KTTLSFyR9nUgsqH8NN/7ImxgCKbYfycVeJn9Viya/cai6wzhRDVZVlOU98lvUSFAjhu9hA+M+be6rSP5l8m/UdPnbkHoSdOqpLcqc5Ed7Pqfv3t32A0jxKgI4ca6L8+AcrkJoY5ZWFTEMNqNy1zMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199018)(66899018)(31686004)(54906003)(316002)(4326008)(66946007)(66476007)(82960400001)(38100700002)(86362001)(31696002)(6512007)(6666004)(107886003)(186003)(26005)(2906002)(6506007)(36756003)(41300700001)(8936002)(6486002)(2616005)(5660300002)(8676002)(66556008)(6916009)(966005)(478600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2RlR2ZPdElOQkwzYldNRk1jS3NiZkJZNHFLV1VFdmNZMStOemlKbmc2WkpY?=
 =?utf-8?B?ek1qY2w2NW9yS2c2N0s0emtHZ2IwR2VvNkoweVlDR0xaUlpIdjlhOVIxSmZ0?=
 =?utf-8?B?QTV3TmlUcjdLNTdPZmFVRzNEdTZiWlRKaWMvNWtPc3FrRmM3enBEZC9nN2NB?=
 =?utf-8?B?U2lPN1ZBYlJxdkZpanJDOUo0bUUxY2lPWFVNRGJUZzNwQ1BDQXpzVThBcnZN?=
 =?utf-8?B?MXdlR0RiTUxRNWdlU3R0MzRDMzBTMjBXNmloWjVRc21Eb3RYZHlydFRRT24r?=
 =?utf-8?B?UjVhNFI0THNHYUtVR3JmeHhNUEtCZ0tSM1JhNFFPbEdaQUpLMEwvZWdlL1NM?=
 =?utf-8?B?bDhJWmdmK1NhTktDaFZUWFlIRXVyeDJBelBoWWFkcG9NcDc5L3ZMNW4zTnRn?=
 =?utf-8?B?dWd5Qm10eERhWFlqS2dMaUdNZ3paQkl1YlBtSnpWK1o1ZDlHL0FKaGg0T25y?=
 =?utf-8?B?RUJrS1FwQUNMdEsvOFFHcHNVdUR3OFNOTWNQbDF5S2I2cVhtbCtUMnRrL1Z4?=
 =?utf-8?B?TExFUHNXN3hsME9zRnB0OEErcFZPMERSVWJSOGMvZkRqcG5CTHFmWW0zNEpF?=
 =?utf-8?B?amo0M09IZUs5c2ZET2tzeHVWOEJBbzZJZTZmelVSRitzV3NOcWlmYmtzb0gy?=
 =?utf-8?B?WVV5SmZGRERyRGlWTWh5S0ZDcTNVQmNxM20vdkpENlBhK09DcTA1UzBpeE1R?=
 =?utf-8?B?NXduTk14Uno4OWVJd2duNkhBOUo3STM0TFcvMFpOZVFrOWZVa0JBb2wrREg1?=
 =?utf-8?B?TUk3SE5KbWd1R3NqbWxVVi9PUS9YaWs2TU5RaFNSeStZQXNnelBZaXpSZmdT?=
 =?utf-8?B?dTRsY3JkT0xJcUIxcndUeGhmTjNTMVlhbUNUMDc2eWQ2MDVBYXVSVHJ2NzlY?=
 =?utf-8?B?M0o5dnNhTEFCN3NBVWZwOS9Od2d3ZHl0ajFqTkgzS0JVSWRQTXRocXdueXZZ?=
 =?utf-8?B?TEQ4Q1VMM2lOb2taM0djNW9TTVIvTmxaMEN1dTJFc0dxQk13dDJ6YVlIb3gx?=
 =?utf-8?B?d2drQTRBMmNiTjMrZW9SNGtOaGJiVGFtamx4UEt5MzhDU1k4WXdOaVhENGlY?=
 =?utf-8?B?Zi9XeUR3cUIrbUI5YVQzczU4Mm90SmIrUkVFb1F4WnR1cWNWRTdFdnJnckxr?=
 =?utf-8?B?WWk5YUs5eXZvd001TzNpZThqU2ZlSGw1YXc4ZTdBa0pqYUNZRnFmSWJVZ3Nz?=
 =?utf-8?B?TFVKalJFbFNkYk1UdGlJWGF1L05OMGFrcjFLa0d2ZWJreitLbWxTK1NnTUt5?=
 =?utf-8?B?S1pKa1RoR2FMeXFZMmQ1bk54a0Y0Y1YxajAwUDRFVmFaUnZJSUp1dit6YzJM?=
 =?utf-8?B?N2Y2R0FDbys2SlBrVjJ1dVV6OTdlWXpTWmRJc3ovdnJJY0pqRitMeWpjREtt?=
 =?utf-8?B?L2s0VUpyaEZkTVZDSWpnWGRjdXE4RnVQbWRNeGh4WlNscDRjNE9qaU9QU2VU?=
 =?utf-8?B?UFlBWTE1YXpaZzQ3cFJHTXlzeTBNVm95UGpSdjhiYlJlZXNRM2FsWkk3dmJJ?=
 =?utf-8?B?dThsVFRKa3k0TnVGMXI2a3RLd3ZqcFlOTCtreHZzRW1YNEJxTDFqMXZKSXpO?=
 =?utf-8?B?M2FDRzJHZ1FsdEN2RHovL1UwL01ndXFrQnZRcGZEendUZ3IyMkt4RDMxWUxE?=
 =?utf-8?B?ZTlhNFBNckNpV1VVbUIxZWF2QlA0RklDMXkzbVZxTVdCY1lTVjBaQWlleDZT?=
 =?utf-8?B?LzJKOGNnVDA0OTF5dHlSMzQyZHYzYjNQb2F6cGNvcXAzZUg0N1lpNHVFSlE0?=
 =?utf-8?B?Ly9kdEFTcU5meGR4cjAxbE9pQTdRanQySXBtbGVLQXNXWTlzUnFlVWM5Nno2?=
 =?utf-8?B?UE02bUxxZzhRVndhQkpxMGtIaUtoeXV2S2xtWXlSUTM3L0YxRzloM1lsdVRM?=
 =?utf-8?B?b1JyMEJ1Nk5GUUFtYk90Wjdra3hOOXFPUEYxaThTUW01VEQ2c290NGk4ZEk0?=
 =?utf-8?B?clYvN2JiNXJ2VzUxQ0UvTVgxS25ta3VsTGprWTI3NGg5SGs0TEgwZmFicURi?=
 =?utf-8?B?M1BOWXNtNkxrYjFjbGQwZktGL25LdXcvdFdubmd1bE1CSnhlOGtLbnh6U3Q0?=
 =?utf-8?B?NXNOTjkydHBiRGovdnc4YmhMVjZ6OVZxbkJaRkJCaEljdmRSY3UxLzYvWm82?=
 =?utf-8?B?YVZESjBjZy9PV3pkZ25rUWkxRml1QkVubFJvUVM2c3haYmxKWnNsaHlqTC90?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c44fd1f-1c8f-4f4f-cfb8-08db08a070ca
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 00:15:38.5686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ipzzbQY6NqUygnjh3B8eLWfzvJk6OzPydmpEbVocmAN0IFKioYmV9AYCyPm8rMOWJyYo0JUQEULVN/4xaGQPX1UmyUhYnnrYfLpYZz9loHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6239
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We are looking for feedback on the kernel interface to configure 
queue-group level parameters.

Queues are primary residents in the kernel and there are multiple 
interfaces to configure queue-level parameters. For example, tx_maxrate 
for a transmit queue can be controlled via the sysfs interface. Ethtool 
is another option to change the RX/TX ring parameters of the specified 
network device (example, rx-buf-len, tx-push etc.).

Queue_groups are a set of queues grouped together into a single object. 
For example, tx_queue_group-0 is a transmit queue_group with index 0 and 
can have transmit queues say 0-31, similarly rx_queue_group-0 is a 
receive queue_group with index 0 and can have receive queues 0-31, 
tx/rx_queue_group_1 may consist of TX and RX queues say 32-127 
respectively. Currently, upstream drivers for both ice and mlx5 support 
creating TX and RX queue groups via the tc-mqprio and ethtool interfaces.

At this point, the kernel does not have an abstraction for queue_group. 
A close equivalent in the kernel is a 'traffic class' which consists of 
a set of transmit queues. Today, traffic classes are created using TC's 
mqprio scheduler. Only a limited set of parameters can be configured on 
each traffic class via mqprio, example priority per traffic class, min 
and max bandwidth rates per traffic class etc. Mqprio also supports 
offload of these parameters to the hardware. The parameters set for the 
traffic class (tx queue_group) is applicable to all transmit queues 
belonging to the queue_group. However, introducing additional parameters 
for queue_groups and configuring them via mqprio makes the interface 
less user-friendly (as the command line gets cumbersome due to the 
number of qdisc parameters). Although, mqprio is the interface to create 
transmit queue_groups, and is also the interface to configure and 
offload certain transmit queue_group parameters, due to these 
limitations we are wondering if it is worth considering other interface 
options for configuring queue_group parameters.

Likewise, receive queue_groups can be created using the ethtool 
interface as RSS contexts. Next step would be to configure 
per-rx_queue_group parameters. Based on the discussion in 
https://lore.kernel.org/netdev/20221114091559.7e24c7de@kernel.org/,
it looks like ethtool may not be the right interface to configure 
rx_queue_group parameters (that are unrelated to flow<->queue 
assignment), example NAPI configurations on the queue_group.

The key gaps in the kernel to support queue-group parameters are:
1. 'queue_group' abstraction in the kernel for both TX and RX distinctly
2. Offload hooks for TX/RX queue_group parameters depending on the 
chosen interface.

Following are the options we have investigated:

1. tc-mqprio:
    Pros:
    - Already supports creating queue_groups, offload of certain parameters

    Cons:
    - Introducing new parameters makes the interface less user-friendly. 
  TC qdisc parameters are specified at the qdisc creation, larger the 
number of traffic classes and their respective parameters, lesser the 
usability.

2. Ethtool:
    Pros:
    - Already creates RX queue_groups as RSS contexts

    Cons:
    - May not be the right interface for non-RSS related parameters

    Example for configuring number of napi pollers for a queue group:
    ethtool -X <iface> context <context_num> num_pollers <n>

3. sysfs:
    Pros:
    - Ideal to configure parameters such as NAPI/IRQ for Rx queue_group.
    - Makes it possible to support some existing per-netdev napi 
parameters like 'threaded' and 'napi_defer_hard_irqs' etc. to be 
per-queue-group parameters.

    Cons:
    - Requires introducing new queue_group structures for TX and RX 
queue groups and references for it, kset references for queue_group in 
struct net_device
    - Additional ndo ops in net_device_ops for each parameter for 
hardware offload.

    Examples :
    /sys/class/net/<iface>/queue_groups/rxqg-<0-n>/num_pollers
    /sys/class/net/<iface>/queue_groups/txqg-<0-n>/min_rate

4. Devlink:
    Pros:
    - New parameters can be added without any changes to the kernel or 
userspace.

    Cons:
    - Queue/Queue_group is a function-wide entity, Devlink is for 
device-wide stuff. Devlink being device centric is not suitable for 
queue parameters such as rates, NAPI etc.

Thanks,
Amritha
