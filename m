Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E06669C0FA
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjBSOq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 09:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjBSOqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 09:46:54 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2041.outbound.protection.outlook.com [40.92.98.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423F62688;
        Sun, 19 Feb 2023 06:46:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXGfEIyc1BuyXNSUIEIuUn8Y6nC9So+T64TmHMjKy/5OiZmopJqQ/LPPr45fhzCbgXi8Y1tWh9Hp/ElF6Ek5k3Lg7vty8jaOXg+UQkNWvTrmSRAqLYImdA1VH3cb0m1GXCVsy6rmDoC7JF5lvcOEXugZF88Cj/x9jWulPbSChJAmZhEfolQX0AUM+O6heDWRHj+L07R9PLENpnc1XE+GsJSIZffII6/dfKxxmZyjQVe63gmFUMiDDibEPn9p3r5e+NAzk+AUaowmQ/HoLN0yG5tnWpT4aZdkrmVcdvmsO1fRgsWMjqxlXrYV+KibbqaysDynVxLI6VRP4jffGhybqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfp61u0quqvcZOsPJ2IwqJ6fTYOg7hwh/swnTPDgcYg=;
 b=Fl2RwM26Vs1VoVXgKOex7d0kK+L62N9lmQlFejOiYUjriRdxL3WXM/bAN6UeRWLHH64WrbeGtkQCLd4wiO/tpuDHN9J6yZ2ES3PST5KnwiIwtOwEDCdxEBfmcqLgdJFqUSjXFhYpPKuU1M+WPJUlgLoHTId1AVNKtC4HuD8hrCVCXN7H9xePlW9OxK29Yx/nh1u6UWEB78bZH3oT0xm/MioFXf4b3vlfmKAkXHcGbrIGVUdLzOO7lhbjiJpDKvJAFR2eVvpYTcxM3S84n4ArnOkjcI5erKTbk2hoZM8a6UmoSOu5gKcIVpqQjuyU5kHOuyyGYoG831c7Y5UuAcF8UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfp61u0quqvcZOsPJ2IwqJ6fTYOg7hwh/swnTPDgcYg=;
 b=K82yz+b+uoCb0GUEvAKbYlZ9sNoPttZqCMTFQSawxeLtdVIbonTRkqgD0F6h+BsifItwhTYUyNHiAoCYrvuklkivboYdc3/wPVPBmB3j3ptSRoh57Hq33LG/ph2VsZ37fTghSBQVnaUz/E7CJkd+0xyeOLkp3I2m5v50RIovY9eWKMuRQtCl1WO+PmGqI0Tn+fM8DSfeuJmQWt1FO4LLBM39/+iomsKVbscsI+wwWf+m+jNXIMhGmr4fzSw4iY2i+HFquhz7JvwpQfEFfpnAXojCVESCpc/5wnIv40inoaueoonl+fs1eXGNCaSAdRsGvQKTRcCWzg8/T8wwd8bsOg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYCP286MB2640.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:244::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 14:46:43 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 14:46:43 +0000
Message-ID: <OS3P286MB2295A23718762BB07BCB6007F5A79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Sun, 19 Feb 2023 22:46:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute
 put sw_flow mainbody in stack
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y/IqJvWEJ+UNOs6i@corigine.com>
Content-Language: en-US
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <Y/IqJvWEJ+UNOs6i@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [wr3islCALYiv9WJMDiNUiQjJ0tBd1STZ]
X-ClientProxiedBy: TYCP286CA0039.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::13) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <b0c41af6-34ec-87cb-b137-6552840d6de1@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYCP286MB2640:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e989fa-d9ae-4879-576f-08db12881e44
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MHbCZHWtbEpvnUTmYzHQnEnn0bhbqEHbrZ/c1mthKqXz+Zyh4fZIPvUBra0+r2/Cxe+aGr+iQhNa7UIQsS+ML4Xh5ILYa3Elx1It/F7xOv7fR4HtPUCLiYiarKk005zlU3BrxcNqCkyPs+RaoRiLLHMhjDtnTayzvMO3YdpRgkodBYLaHVogSADioJPKrOeZnjC8tCKpXHfZk0bJLtL2Vu46s2qNFCRgtPhPqybi34bVU7nhMfUc4zPFqsheCNuFXX3gNzaf8msl6O9q7zxTOldqia9j/rGLqiTjFKU46JZWHXsVfwXLh/dGZfek8OMwjTVFBWmVnOdZ1hmFaL0BlmzjgyfF6Um6fGmE0yHAna7uBGNST53jDMKk/+mzDnPWnfTpP/JGuvboxVfpyExNec7P6krIgCA6p0CYgmeoDLl4D/07C15imX6NCKdSfTwA0gOg2INBwLinvhq0Sty1KY4fBTJ1W7uJ75zdSCf74N2omk3XQHZdQisEoestXTNk4AaWee8fnSZzO+zi647/UUjsblEQi6EdTc+yBNAIfGNML2Q0I1ShI9506C7iiBnhviBk346EyUggeFbIg9rn2dZ9fpTa4yGwRuQDVyQjgVjZdVbQVomz7IMi0ik4XpSbVZKIhca0FAcWEAneyxfQQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWNnRWM3ZGFxQXFaNzVZcTRHTndVcys4Uk5rU0I4N3ZGYmJRczgyVDZGc1Qv?=
 =?utf-8?B?SFlvU0JST05QNnIwT1B6T0JGSmxNRXA3OXduU20wYWtpTWhMNjBReUQzYzdU?=
 =?utf-8?B?bWIya3ZmV0R6eEgyTGhadktERWdDZFhtcjlaWWlBNC82TnRQWWNuL1NlV0Jk?=
 =?utf-8?B?c0dLV05sTTkxaER0VkpoNWNNY1U5MXpSemcrTlVPbkZ6Q3FTRU5qNkdaQ24w?=
 =?utf-8?B?eFZoSjZ4aUFtajMxSkFYR3BWY3FZM2tXR2NXc2xTcmlyby9QVUN0aDYyN01h?=
 =?utf-8?B?M2FNRUJwQlNZTTJFZ3FsWUJHcHRwUXNiM0hLWlByRjVOZTVRa29rOW9ZYU96?=
 =?utf-8?B?YlRwYnRPM1hyY3J4UWZRU2tWNTFJL3FYdTY2NVZhQkJOc0lEL1FhckwzME9u?=
 =?utf-8?B?T2x4bVo5WlNBQ05KdXpOZVBGNzF1SUhLWjBaTHd6UDhuaXZIbzZXRUpkUUJx?=
 =?utf-8?B?U1BBempwdStEbzI4OENSZ3UvVFp6YnlHOXQydHNaQmJNa3BCRThRUmFJS0xG?=
 =?utf-8?B?VVRDQlBxMCsxNUU4Mml2K0tNdUc5UHRMTG94L1BZTjU1S3JIMGRJMWV4cjU1?=
 =?utf-8?B?TCtmSHdOTERreERPQWxBT1gzaEdUNHhMSlNtVGdEUTUrNXFJN29GOFBoK1oy?=
 =?utf-8?B?aU5NcEk2a2VXRVBXa1NWZ3J1Z3YrUG92OW5lQklPc2xUWTVmV2ppTkJtbktE?=
 =?utf-8?B?Ym84OUUyV2tWOG1sQkRNNzQxWGVuOC9kRzRSZUQ1Ry9vTXloNWZhSUdET1pC?=
 =?utf-8?B?ZTYvWUk5alZ2biswbm1wZXZGNTNncGpvd1VvazB6YXc0YnE4Y25JYmtQTmJ4?=
 =?utf-8?B?UFN6dUxOOU9aVnRyWFdxM3lmREtGR3NFRThucXB5emxoY3NxcGxsUVpRUEV4?=
 =?utf-8?B?c1pVc2NYM3Y3eDhwNG53TkIrSGxjWGRwL0srREhwakRNUFYrZEpadEFqVlJC?=
 =?utf-8?B?bEJJK0RKbGgvQU0wNFBuSnZaV3l3N0tVQ1RINXB6S3hZc1VNbysvUGJ0OVpC?=
 =?utf-8?B?RUkxeUZRTlNScmdwVXFQTUhhd1JHYzJxdmdPT2tDaFNOLys0aDlLUUVkZXkz?=
 =?utf-8?B?OTc1R0N5QXQyVVk0cUFTOWNqdkJNZzhQQnVWUU5zL0pCdEhYM3FDcVpUUlZv?=
 =?utf-8?B?L1lWbzMzSkJqYlFsS3cwcU50aFV6dW9NZEszWjRyOFBTSEpLWHpYTlBSZk9T?=
 =?utf-8?B?eUNQZElDUkZ3VjltcjJqREgvSzF4cmhVVFloYzJlalUvTUlKb1ZCYlV5L1lm?=
 =?utf-8?B?Z2VGckJLVnppa3BGOE5INUdKTzhlUzZKQ3FxaXNpcXA4RFI2TnhCeFI5a1Jq?=
 =?utf-8?B?Q2VXU3JKZ0pBRjBmeUVIamwrRTJTNlJRSkl2RkhVQ3NNK0lqTmtVR3hGRFBH?=
 =?utf-8?B?L1g5UEI1NzhsNE5mNThZVWpRRGQwL2thcVpqTXlzRDhEcGltOFdQU20wMm42?=
 =?utf-8?B?SEtFMGdWZStjRndLVDV0TzhSZjZhREs1cDJzTlk4T1NBSG5Yb3JUQUEwVVMw?=
 =?utf-8?B?MkxmOGlBaVhSRnJxN2I4OXYraU9UWDQrdmlsS0xpdjlnaldXYWFiS0xxTExX?=
 =?utf-8?B?SVQ4bHhnT0pjRnRaa3JzRHdCS05FNXJXbFhPNjhTV0tuUWVRbGV5UVFGcGw1?=
 =?utf-8?B?eFM4WHZrdlZwTkVrayswcGI3Z3o4SVlDcS90TG8ySU92Z3MyVHFHSXhHNk10?=
 =?utf-8?B?Y1R3MjJFTDZiTi9lUVRFRlh5Mm1lWC91L0JUYWNENm4raHNrYWJzNUpBPT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e989fa-d9ae-4879-576f-08db12881e44
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 14:46:43.8203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB2640
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Simon:

     Thanks for looking into this.

The revisions i proposed are complementary for the same purpose, and 
also reside in the same code segment.

I named them 2 items to clarify the details. Maybe it would be better to 
name them 2 steps in the same revision to avoid confusion.


And yes, i do have some performance result below

Testing topology

             |-----|
       nic1--|     |--nic1
       nic2--|     |--nic2
VM1(16cpus) | ovs |   VM2(16 cpus)
       nic3--|     |--nic3
       nic4--|     |--nic4
             |-----|
2 netperf client threads on each vnic

netperf -H $peer -p $((port+$i)) -t UDP_RR  -l 60 -- -R 1 -r 8K,8K
netperf -H $peer -p $((port+$i)) -t TCP_RR  -l 60 -- -R 1 -r 120,240
netperf -H $peer -p $((port+$i)) -t TCP_CRR -l 60 -- -R 1 -r 120,240

   Mode Iterations   Variance    Average

UDP_RR         10      %1.33      48472 ==> before the change
UDP_RR         10      %2.13      49130 ==> after  the change

TCP_RR         10      %4.56      79686 ==> before the change
TCP_RR         10      %3.42      79833 ==> after  the change

TCP_CRR        10      %0.16      20596 ==> before the change
TCP_CRR        10      %0.11      21179 ==> after  the change

Thanks

eddy


