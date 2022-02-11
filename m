Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3194B2961
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 16:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349442AbiBKPs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 10:48:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348352AbiBKPsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 10:48:54 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E881A8
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 07:48:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnbvvkNAASx/mH5+7vfQLA0HS75pFa1S+mx42bBZLnZk3+do4KugVvJQpDAzinOq3FoZwNFcqcyqS52Ohx18nsmbzHvcJxKCHr6/MS3R+0vRnwqmdmkDq5CbiO/kXmwc6Vttp5D8D8H73m0nj83gsEJV8W3Dl96/cba2hbXyU4qA4OaOaKjOFckkzAut1lb5jOwsCgl7vshadO6dlagDUlIaMlzbROqa1Td1zfRfp/XsruSn1IAbqeKqtg0NxyX1Sow6BuRMkcgaeH1ooEri3BRtdPRt9UFxEnO7bX9jQrrct/atybqQgCrHuZptHc4iduNEOTjH3Btp2qoZ4GqHpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoyH1du/WNdLJ9VrvCkgHzmeTl59rbQPMRqFtDOuowA=;
 b=V7oCX1nxqWHZKffDlTDueMJRgZ5MyFotzho1ewZ1EmrJmoBmU7vJFkE2J3Re740F1JqEa/PXU7hN50fuBJH/S2wDg9hdBko1pACAn4bfKDKOTuOA+t/tsiAHkvQdIb0RbYALlLUSJKxI8U6TG/IaAHX8CGP2dTZo93jeQWNIsb+q02Bx78H0aPX426WeQwRt2satua5MnB9peMiExO/ddUaRjMNRH60PShmUSm7T43d2KT8l9fnIpyPxKgYruBdrgdbEbIGlTvFxXhYeOvrO90bp6csiUStPMJpRcRBBcs05DEjmmsdJQ6bnfsx8wg/iotDqtjAElmb0lVcDMNr69g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoyH1du/WNdLJ9VrvCkgHzmeTl59rbQPMRqFtDOuowA=;
 b=h+bU0ERanHUHHO0NTeTGfjrhF4x8fY17kwAAPPNHbycm+j+UfssXgMpCL0+WgUoTyqTSS+cWUizNRU2aPW+xfAvkojkjR45bAU+la1kZPHdQhDCFmJJF0tb2FAdm9vCM2CALCi3uOT38EjnU8W9CrFJuALHdt2r3eYk2+or66hw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BYAPR12MB3429.namprd12.prod.outlook.com (2603:10b6:a03:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Fri, 11 Feb
 2022 15:48:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%7]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 15:48:50 +0000
Message-ID: <57cf8ba6-98a7-5d4a-76d0-4b533da06819@amd.com>
Date:   Fri, 11 Feb 2022 09:48:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Thomas Kupper <thomas@kupper.org>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
 <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
 <14d2dc72-4454-3493-20e7-ab3539854e37@amd.com>
 <26d95ad3-0190-857b-8eb2-a065bf370ddc@kupper.org>
 <cee9f8ff-7611-a09f-a8fe-58bcf7143639@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
In-Reply-To: <cee9f8ff-7611-a09f-a8fe-58bcf7143639@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c1d2f6a-b7b4-4eb7-ac08-08d9ed75ff8b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3429:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3429BAF4CC79A53F472DC3C4EC309@BYAPR12MB3429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZP+pshtf/cAMxfTWQBGFrWyinoM3B+5ZGIodZqgfVpSqHAkhd8ER2Lod69bQ/ojpHFrvnne/Aicy3w0trP8mghl++wDnn5ZFUlylYoAYIU5JA9TXwq1wVKFxMOMjYrgKfS76n/K5WoKRSUCFDXI4T8+/KHHJrzUQggki4wSBgODOGvv7hYKX12oMorG0vKAoIe9jEk/OXM4kp/7zXbtM/Wn9rDIIIspNk0mIV/vnj7OrEPykH5/ipuz9K4RAiBjM4h31WL01l04lqfCqOezY060jESkIZSejg3pIdaOiGntiGRm4AfjOGp66YEMtk9eRiT1/om6bs16VgfQpjMhCbdoiTjBhyG/SpKfhoAqS1+bqfi7+VeagEj3bFaV8GCalhLJcW47Yu+QtdIewm9dkwB4xhF+KClW/7jENQkJhyMY3YIf74F+QoqGgxdypRHITFDKsk7M18V2er51EAy0VN2fRIKexAfCv/qp1qz+fKTUaMNMtvDHw4BBmGiN//JBJ48V8C7jaNEbOO9yDQN/GdrOYl+dvpVXTKQAS2ysl8JK2W0+VNcWoRKWXL57rMORMCoRl30wpLJmM9dWHhfGHWBPuZpRH1bnXXut4e3yFyl1qiYy0DOBO8UYSoHVlZ7KvGFDiuA1rI+p5bR+Xg8bWVQe8vRFCT3Bau0XjJuEOfDfpu4brmadETASeVzx3/vfFmZ96pNElTqWJL60lCgYh9ByiXceJrK0zQjfOM2gnJgrzrCO05lb0x8hp5ZF03CWj3Ev3pbaGYrBvabaasiYzokoKwO5p6o97X2XAAqmgY9RAhFwW6gHeLMFYBql7yA5hyb0AnQWnISncF6EqV7LWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(26005)(186003)(31686004)(2616005)(83380400001)(2906002)(5660300002)(66556008)(4326008)(66476007)(86362001)(31696002)(6512007)(8676002)(966005)(6486002)(316002)(53546011)(8936002)(66946007)(508600001)(6506007)(38100700002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVF6SzFYM0pVY3JwUDJEeTdkcXBBQlBDM1lMZU5zd1U1VVN2UC9iWU5pL0Zh?=
 =?utf-8?B?bm9PNWZ6UFpscTBPcm1lQkZSVDA2Q0QzQmt6OGNiRHNVYmY5U3M1SHU3dnFK?=
 =?utf-8?B?bThubER4UEFLbzUrWHkzUzdoeEFXbGtwMEFmekxiOW1kZFZLMDZ0aEwyUkEr?=
 =?utf-8?B?cWdpUWJvNmJPQ081UEswdWMwRzBXUWZsSWIwaVM3dnJYNXZ3bGZqM2pmcVdy?=
 =?utf-8?B?Z28rcU5BZW1tYUpoMnZrdFM0OHhRVGovK09IMWdkbzhMaTR1eVBDSHlpVmhx?=
 =?utf-8?B?WXJFRStYMHJPNXlrS0F2eFdXYkdBWVRMaU51TXd0Wjh6Tlh3ZW00TjJ1TmZl?=
 =?utf-8?B?Z1RWa3lrL2xzMnlJcGxKQVY1RjlmVnNNOHBSMG9INGF3Qk5zaFVpZjdWUGxC?=
 =?utf-8?B?djZML0dBcjhtRUZoQkdQTi9tc1lMSnE1Q0k4bWZRc0pMYzh1TkJ2TXE5K3cr?=
 =?utf-8?B?dTgyTmQ3ci9FY1R1dVc5MUtFditHUmVNb3dneUhTbE13UzZXWHZjUTRjUWg3?=
 =?utf-8?B?TVN4OU9IWVpDZmdOTFFKVGJPWkxKUFVwdFI1VTU5K1p3SGVNR3YvRFNCUkEx?=
 =?utf-8?B?aVNiOFpLN09kUEkwSXgwVlJWMTZjWjlXMUVKK1RKR0ZxTVVKelBlS1hwNTdr?=
 =?utf-8?B?alN5R09BY2FkRHBSS2pnbDR0bFhDNklLZmdWZCt0OUVDMk50WXdvNzZ4TldM?=
 =?utf-8?B?QUt0cU9MY2NiMWpxalErc1JhVGVBZDZGWWoxQW51YzQxVGRjOTRRbEJWejhF?=
 =?utf-8?B?Um13ZGJlTWRCdko4ZHJubGpTbWhEWEpPQndCNGVZYTZmYVMwZG8rdWwwcDFp?=
 =?utf-8?B?cEFTU0hPdVdTNDVpbFp1T1E5OFlRN3VDMWZmVDg2NkdCb2crVnJDUjBzNVVU?=
 =?utf-8?B?TCtXclpEdWVGT3IySjRqdzZUamk0N1VUcnJqUUM1dllvNE5lczRZSENKSG53?=
 =?utf-8?B?Sy9WUklFalBoOGMrTy9LbFBSUGpnR0N3ME1IK1RldTRLa3BSTC9sSzUzdlFo?=
 =?utf-8?B?UnVRaGVRRjRsdmxraU9IRFBIRDJiV21rNEFiM0dGd2crOHdNS0kwMFN2YWx6?=
 =?utf-8?B?Qk1oMlhWbHIyWVJwd3I4Wk1KY1oyejVnVUtCNGF4UTU1U2VmR0FjQkIrUFhv?=
 =?utf-8?B?cFR6c2Y2bTdxdDZsUkhuSDZHK2t4b0srQWtYZjNzVktOdFZiWEo4Vy9ad09o?=
 =?utf-8?B?WWJuL2J6T05Kc1Q1NHMyUWhlWFVYYm9tTC9sZnNsY3hyS1dXaitLK081ck5Q?=
 =?utf-8?B?cFJxME9ZR21JbXRwbm85dkxCdXhHZHpZWld2alJybGdERmllQWJ3YVVtUUhD?=
 =?utf-8?B?b1gwajJqenYvbUtXMWszS1NtOUxxL1NNRk9WVEVsUUVOUTdEejBsMzE4VDBn?=
 =?utf-8?B?dlZJa1RaV1RMRVNROERzblJlQUpRQnRFaENlQlNiUlIvcVM3Wm9xKzIwUDQr?=
 =?utf-8?B?Wnp1TlNMM1BBaTNhQndrWGxHdThSUitWNFE5U0IxY29URW9VRTRHa2Vic1Ba?=
 =?utf-8?B?d2tJQmRHZkQzZXdOVlRxZU5pOEZNL0dtSitpTXZWRDM4L2M1UCswZ1BXL3ZZ?=
 =?utf-8?B?eUJvbzVGZVI5RjJMQ09TM283cTdNZjRGV01oOEVPMW1zZFdSWHpIYXhWOFdo?=
 =?utf-8?B?cVdCM1hLNzdseTJiL3RtN2treVFCSWxPZ0ZYV09JU0cyQjJ1cjhkck5rT3Nu?=
 =?utf-8?B?aTlaNVIySTFJMFZLS3F0Q1hYYTFxam1reFNrZFk5RVVkZTlDU2t6YzNVa094?=
 =?utf-8?B?dXM5N1RSekZ0SUdtaGlzWnJhN0FqQ05pMGFoZDg0Sm1nSEhML0pyY0pWcHJT?=
 =?utf-8?B?cEdraWpiU3diclBDYmFSWnZsM0RZbDdyeW9IWVE2STNEQ05CbjVzRFE3UGFG?=
 =?utf-8?B?R0ZxZm9CN1pJSkdacjBJUlBLVHdyTzNGcWppQmdPdU1zR3IxNXRyNTcra042?=
 =?utf-8?B?enJzZ3pvR3ZWaU5JR1dPTGJsd1F2OXBDM0tISUk5bDA2S3g4SlQxandKYWxs?=
 =?utf-8?B?TzR1b0dnUFRXcUt6ZkFGY2p3OUZERlJBczZFMStxV0taYVkyeGZsdndwRHNV?=
 =?utf-8?B?cmo1L2JxQzZDV2RSK0cyNWViWHhXcXJ5MEdGZzhvaG9BYlJXOVlML3B6TVlN?=
 =?utf-8?B?RU8wVzRta05GNzAwNUFEMnpwZWRMZ1BKUlBZNk9US3k2dFQ3c2JobFIzTTJl?=
 =?utf-8?Q?ayVBF4ywmIMSXvZkokdm0OU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1d2f6a-b7b4-4eb7-ac08-08d9ed75ff8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 15:48:50.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4GUNE6xciN5S4KsFk3pNiIlLApWFFCdGiSG2ZT9sESdAYVMWzVf+vquIWJauMEmDf8Su7TnOsYEK57/8aZDjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 03:49, Shyam Sundar S K wrote:
> On 2/11/2022 3:03 PM, Thomas Kupper wrote:
>> Am 08.02.22 um 17:24 schrieb Tom Lendacky:
>>> On 2/7/22 11:59, Thomas Kupper wrote:
>>>> Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>>>>> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>>>>>> On 2/5/22 12:14, Thomas Kupper wrote:
>>>>>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>>>>>> On 2/5/22 04:06, Thomas Kupper wrote:

>>
>> Thanks Tom, I now got time to update to 5.17-rc3 and add the 'debug'
>> module parameter. I assume that parameter works with the non-debug
>> kernel? I don't really see any new messages related to the amd-xgbe driver:
>>
>> dmesg right after boot:
>>
>> [    0.000000] Linux version 5.17.0-rc3-tk (jane@m920q-ubu21) (gcc
>> (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37)
>> #12 SMP PREEMPT Tue Feb 8 19:52:19 CET 2022
>> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk
>> root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0
>> console=ttyS0,115200n8 amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
>> ...
>> [    5.275730] amd-xgbe 0000:06:00.1 eth0: net device enabled
>> [    5.277766] amd-xgbe 0000:06:00.2 eth1: net device enabled
>> [    5.665315] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>> [    5.696665] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0

Hmmm... that's strange. There should have been some messages issued by the
xgbe-phy-v2.c file from the xgbe_phy_init() routine.

Thomas, if you're up for a bit of kernel hacking, can you remove the
"if (netif_msg_probe(pdata)) {" that wrap the dev_dbg() calls in the
xgbe-phy-v2.c file? There are 5 locations.

>>
>> dmesg right after 'ifconfig enp6s0f2 up'
>>
>> [   88.843454] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2
>> enp6s0f2: channel-0: cpu=0, node=0


> Can you add this change and see if it solves the problem?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=68c2d6af1f1e

I would imagine that patch has nothing to do with the real issue. Given
the previous messages of:

> [  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs) vs. 00000000 (enp6s0f2-pcs)
> [  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed

There should be no reason for not being able to obtain the IRQ.

I suspect it is something in the BIOS setup that is not correct and thus
the Linux driver is not working properly because of bad input/setup from
the BIOS. This was probably worked around by the driver used in the
OPNsense DEC740 firewall.

Shyam has worked more closely with the embedded area of this device, I'll
let him take it from here.

Thanks,
Tom

