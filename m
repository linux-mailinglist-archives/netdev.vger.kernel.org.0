Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB7F4AC166
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiBGOje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441814AbiBGOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:32:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597A1C0401C1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:32:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeRXlRb2xF1U5sJ3wHbkxIWlIyRce4Qtg362+eFFoutJY1NScsiGWslOTH2u5xwv+tWfh23FUjrUGo5lgGhBKtViU+8e89gw6uB5SDpPv6FZqvimWvJKZvUyOOOvaG0m4SRod6j1O/Uyft9CH9wJf+y19NPF/QAQP5dzAauooxvpFlQaL2TsJJMpS9OiUdhM67RKnl6LeMey031c4Q8n53NqGlR73kNsho3OQxaKsV5/UW/1NUMSKHU/oeQCsD/lROFNge3bXA6+da3VRIJlQyFC3I9xtVQB4WY2H2QD2QftsYUV5zdmb8Qapj/2qnz9aUqhAq/ON0PD0B1fStTXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9Oh8DN2+hTgKnSgwJ0b96RWCPbDgzI0b0valIgZCpY=;
 b=FzEdayz5oIw6KE0eT3TV+WazrAU1RjdXZXDGLn12Py2L+xPafqz2qgpUuGE3fLcex5Kp5/IMnvl2i1XyyQKGIxOi3+2o2lC/iggYL1h64SLqwOzsF6I0iNypMdolXOFMk6aHWFocP0Fr5XfyG7s5iLwa/j2T7YE3CQp9x6IbOkA2U5CjD4Ev2iOtBwQOjmGqVheN2Ti3My9tNG1Ok0ATAJ8l9WFM4EhUU5+AqeVLWs/DxDt1q+JTKcfAUPbPokevbNKfYnkVFqeNn9MOaPVu8Z0+JdgMqUplrfSl68LUMCIs+1TJdqOE86x57B76dY+8JL5QWD6ZNkAx0uj+WPE/Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9Oh8DN2+hTgKnSgwJ0b96RWCPbDgzI0b0valIgZCpY=;
 b=TDKqohbCUAaIBo1pVI+M0Hv+WDAY84eySLu5xYdZfgmZZlPGsyzgVxjihGldAZJlcEqvh9pIKJ9g4MVKpn1lJCorJV0bEshi8PfwVdamLILE+X7h8cSU6ahuhFLiC3xjiDFxxUNt5KZU3ohN4mGqFHu8BTP28EEFXa7Rgb3kaUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by CH2PR12MB3880.namprd12.prod.outlook.com (2603:10b6:610:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 14:32:53 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::b9af:8be3:36e5:1a13]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::b9af:8be3:36e5:1a13%7]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 14:32:53 +0000
Message-ID: <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
Date:   Mon, 7 Feb 2022 08:32:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Thomas Kupper <thomas@kupper.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0401.namprd03.prod.outlook.com
 (2603:10b6:610:11b::35) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab21ff1f-7069-49f4-b261-08d9ea46b986
X-MS-TrafficTypeDiagnostic: CH2PR12MB3880:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB388040941A3329CBCF760BBBEC2C9@CH2PR12MB3880.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOwfA+EAULVAJ3PLcABREh3n6vrGngTDShNLUGwWfE6ih4A5kE2eNb9KQiUbXx1KY7t8LtBFJUhBE74CHylmcZwpTHlp9N/mJlNX5Fwk4q/Yhe70at7A+eVotVMZmp6vcN2atIllR3EFpzv2zecfgG4+r053hpDS65HSVdjBQJEOkavrLQhIVhJ5YARbAANCl0Pb+8UqRm051yEHYb6UAx8oljA2+e+AvWoNsSICulmU5rbcjcfL/kEIVn1TkSuBwgU5uHX7aUWX2QYzmp69hnrsuXrKcOsgOpOEgmhr/gRV6YFmoX5s9oKlEDG73usRLJvoMqF4B3i+TqDWRRiYKjeBwF6HIx7rN3iLwp7lIutxjtENiJg7U28DWcHPcRvwtlmFVoKnISO5BNo7EFWaBw/3VQNlAUBCeEtKgLbA5Pfw5Xv+rxK/sQqciSvNzAbm/ae8iyC5jl7qyKsmKY8qV65yDUfopZfSfg1f8pE+XLjTtHmjTYCbJXiADAxmkPuQCER286BM+4rYtiIBTQsNUTsVTYk8yv/pol/wlFlmvNXXakPMqRwIYbRNUc8pcrMyMHuEMwj1XLQm7v8qPYNwfqV9OlsUCdiZV24NjRQOpd5XuPpoJ2+CE1/gAoj989be5jyEDpoq7bZFs3vRub14rjt/E817PM8ndZfAoQN2da3VungiYc+H9xIbTLW2uyH9Tl7KH1lkS2sczNp+Z+qYVqWwiS6vnzRMK4NnskcipHHLfv3JTtsnxDT5VvyspqQH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(6486002)(83380400001)(186003)(26005)(36756003)(6506007)(6512007)(5660300002)(31686004)(53546011)(6636002)(316002)(31696002)(4326008)(8676002)(66476007)(66556008)(2906002)(66946007)(86362001)(8936002)(508600001)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDBDSWxwTkFzbncwcFNCYzZVU0NmME9xKzJXbDJsUXk3NzlPTlhqc0xTN29Q?=
 =?utf-8?B?dlBDcklRdG5HL05TN1grb3pXbnpiWVdhRW42MmZKaUgyWkNXaVFaN3NYdnRz?=
 =?utf-8?B?SnBrMHExWGsxUExxSkR0MU5lYmlDNlZOaDRlSTJsZ1NKdGVrUkhHZG4rMWFW?=
 =?utf-8?B?Vk5PTmdaSTFMNEk4c3ZReDlHSUE1aDBXVzVYajNxaE1sdEt1TnkyVDNLd0tN?=
 =?utf-8?B?dmRZWU1iZmgrVjRBZXVKOGUxajQ4eG9raENnWUxBK2dTT3BGUnB3eldNS2FK?=
 =?utf-8?B?bzNtZGgwSERlR1B2K2J3T0kxZTJwUUp4ODByL0h1N0lyY2MyVDlLV3VueWdP?=
 =?utf-8?B?aUZlL1k4c2xBRXI4UDlTNUthTVBIRXVGNjJXQzNsSVpnWE1DekNnc1RpeWl2?=
 =?utf-8?B?WnBpK2RwR0pIcUZLbkRZUTViRCsrKytwQ09UWVE5bVExU0JKNnRQVlJveGZj?=
 =?utf-8?B?OS91cHFmQlRCSy9YOGFtbC9KSWp3MTNpeGVlekMrU3RSSWRsZ1k4NnRsc1gx?=
 =?utf-8?B?NFlqaUQvNHVrdE5IREdGOTFyNWJJTThwRVNZMHVqQ2crWXVDS240RDRkNmdP?=
 =?utf-8?B?VlNVMlBKKzhDR2JoQXUwTTlOVVRnMGY2TlJNT2hXNFRKbkRLK1Q5bFlhaEJC?=
 =?utf-8?B?VEM4OS9MOUY3VTFVTXNKQlBJSjMyTlM0NHJ3V1hsbTR5WTZON3Q3NWlZaDVT?=
 =?utf-8?B?NHdPdTRveTNlbUsyUW0wY0dnOC9MR0M3dFJna3kwQzNudUMzbkhtcHhPZEdk?=
 =?utf-8?B?RUE3OHJjc3lCNnArVEljQ0NaZ2ZqaFRWOHRpZTRYcDFoMHI1aFluTWlIL1JZ?=
 =?utf-8?B?UlF1QlJUcEFzazBXSk1Sd29wVDlNWUVuVDF5V1E1LytpTFZ6Rmg1ZEQwMWJa?=
 =?utf-8?B?MVBQZXVJZUF3MCtRdUhVL1gyajVBd0R3WTFvZWlGMGJ1QTVLZXlGamdwTG1q?=
 =?utf-8?B?ODhya0ljdUtqM1JjTnp4RUU5cGpDbkFZYy8xQXlFZXpYWlpadTVUQUFmNzZU?=
 =?utf-8?B?cjI2Q1FFUnlqSUZ3eWlsYmxseUlIQWxsOGF2VHlkYkQzam1UcFgxS0cxdit4?=
 =?utf-8?B?clRZUUJwSHdlQUlPMDF4OUpNK1VMaW5VejRBdm5kUC94anlLeFhQRDEvQzNQ?=
 =?utf-8?B?OUo1Rm1weWJld3ZsL2Eyc0U5R2hXRGx6OHVIY2dSVWZ0Yk00Q0FFQ25Vby90?=
 =?utf-8?B?RW1QZU5ZcFhENkVIZFJnVEtaZjJRbVlJaktDNFMyWm9yZVFsYVN3MjIwdjVE?=
 =?utf-8?B?S1JiUTd0NW1Iay90N25GL0tpL3VKYkJ4c3V4VFBkNjdxd2JKeDBKNzFaWkRM?=
 =?utf-8?B?RFcyanV6U0FZenorZ1c5amFEblAzTnhkbHZ3RUp0RW5FMnpxREJKWEdvaXdM?=
 =?utf-8?B?VG1DSmVyckJpQ2hYUUVXbzZqRGlCTmxhQkFhUUJ1UC9IeEZIUThwTXA2eU5I?=
 =?utf-8?B?SUZhZy9XckZEV2lrM0NRSWtZa3YvaTRQRTFqOGlVem42TEhHbGlyd1JoSU9z?=
 =?utf-8?B?NzF4djIxRVdyRFROT2p4TDgrSzFCMS9EeHhJb2VzcGE5OXBNUHRjYUdtTUdG?=
 =?utf-8?B?ZnB6TUxtRmpSN1VqY0c2bHJPOW0zV3VJOCt4aWgzUkMxNXd1L0I1M2haRmRy?=
 =?utf-8?B?Tnd4VnFXZDAxbUl0RG5GK0tIZ0JHeE5yOFpZUGh3WURTdW1EZUdmNnJCSkxE?=
 =?utf-8?B?TVFJdlYzSDJvWktITkhzdDdGRENQWU16dytjMmt6M2VDNEJrSmJ3cHk0MHNN?=
 =?utf-8?B?U09aYmNCVnZVclJuZ0hmSDdxazJmbnlyNjlSejh0MWZVcmN0M3hvRU95QTRm?=
 =?utf-8?B?ZkZOK0ZPbWNibWVpQzkrRVdsYVVxVHJheUVVZlZGNHZ0TS9xRUF4WFpKb1k0?=
 =?utf-8?B?VmVwcGJhRFArcnZvQzllc2tkbHQ5VEc1bmhzNGRQalhleTU3WDhuTzlsUjRG?=
 =?utf-8?B?enpSRW1JTlh3czN6d0d4SjI4MXNyWUZDNnVQUDdFWUM1VExRdUpTRTFSK1VT?=
 =?utf-8?B?MGI5dk5SRUEzOW5NY013cCs3Y1JzekpnV0R3a1c3bSs5TDNtRWFhRlFSenlw?=
 =?utf-8?B?UEZtNlhXU2lDNXBLOE5qY0QrdzJpM3ludENRV1BoeGVIOS9wL2s5ZDJ6TGFV?=
 =?utf-8?B?VU1GZ3NVQWgvVWtWTEdscDdaeExtM05NQWVNZzExSjJnL3JpVmlLbFJqS3By?=
 =?utf-8?Q?/VVgYZ8SzgKfW04oQzCP+R4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab21ff1f-7069-49f4-b261-08d9ea46b986
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 14:32:53.2577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftqWYFwYwMRORTCxM+OAO8ViA9mizZmCiYLm43uIXVhMNC4iA6EYJqj9V8/pNHef+mlVXrq6Pr/nz7Iq3vfFXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/22 12:14, Thomas Kupper wrote:
> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>> On 2/5/22 04:06, Thomas Kupper wrote:

>>
>> Reloading the module and specify the dyndbg option to get some 
>> additional debug output.
>>
>> I'm adding Shyam to the thread, too, as I'm not familiar with the 
>> configuration for this chip.
>>
> 
> Right after boot:
> 
> [    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
> [    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
> ...
> [    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
> [    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
> ...
> [    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
> [    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
> [    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
> [    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
> [    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
> ...
> [   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox command 
> did not complete
> [   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset 
> performed
> [   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
> [   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
> [   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY configuration
> 
> Then after 'ifconfig enp6s0f2 up':
> 
> [  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
> [  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
> [  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
> [  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
> [  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
> [  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
> [  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs) vs. 
> 00000000 (enp6s0f2-pcs)
> [  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
> [  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
> [  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C
> 

Please ensure that the ethtool msglvl is on for drv and probe. I was 
expecting to see some additional debug messages that I don't see here.

Also, if you can provide the lspci output for the device (using -nn and 
-vv) that might be helpful as well.

Shyam will be the best one to understand what is going on here.

Thanks,
Tom
