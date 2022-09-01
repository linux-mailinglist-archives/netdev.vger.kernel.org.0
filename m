Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148895A9635
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiIAMDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiIAMDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:03:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC0BAA354;
        Thu,  1 Sep 2022 05:03:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0lnIljc5RGjiDymxocKLkbGjdVjGSk9FcknAgUw/+uu5mV1yP3yNe//kIUj1yxStoPnH3/+Fovyfkt6+TuXjTgP1yuR0gv/FO6qD1ty3mHJfnwAFvSV3kBpeSrTZFETjpmSP26o1nB7jCzzfGfveorBWP/k8+bNPfwLp92jFnxg594LBOa/8k5EZcBafcqtZYmT66ZRsxrMPJgK0FKq5hHmBqefkUjwKXM5A6i0D1pzGDf7364GUUB148CeQpm19LXpI1cg8Yr2WCBlCzodijP5YmHHjGIZU8en4HxZJJRp4ThevUn7JPyTwyRDneUCZDPqFoa9r3cxYRsAWElDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngMHQhCgTb5LVJq5OQC2zws+WH2ocjC/+w6it2Gulsk=;
 b=a6mrKeD6FSrlyN0gSgJ16J+AStxnj4+7ltjzXGUm7ahBVk+5qCZ7dm7e4+w+IAtz6DI1ndFO8PwLbXA2FOWVmJpeYaZRqgEcffjx0VJJaHlBnzXDHAJbV0gXPUGAwC+b/06mxQ8sbzhvNp0wnzEp4bQO96/ink9xRnIrIE0971vhxGNPmtanMtFuah7qtlLyA1xUxeBnv33Y1sU2j7KcK3W63PYhIRS4GmRtB3zVxSqTY/6w/Ny5pcbbCcRMyCI2Oatx9JtJDNRHHRx6AlJ+fXBob6Pa7e1yzBZ27zrAfCdNvBm+zqw9Ho9a+1rve/x/9rnWtjP/bORi9stU+HFxMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngMHQhCgTb5LVJq5OQC2zws+WH2ocjC/+w6it2Gulsk=;
 b=dJmXiS4h0cW+Lb88C+yA4IM5pH7Nsx5izYjQSf6wbiaxoHEmkSobb9NhN4pB1yngP0bV5eJYhlAx6UOPqBXHukHM9MS7s+CcscINQ86i1xuKMi4k+ipkvadiQr0gYT1V/vNJgJefJiQIW7Ifx6Tz1l8RxRay+koRHyvmzMY0zyWYUp0tU3aW1zM9EosAVY+CZ+n7iDhe4ELpKa0izdLpfHf11fs03zjMtbQuYEplKWBrWTSaYaD8+m6WQgCuFd1pkrD3e4Xuibkl2iuI+Isd/P8JV2wdun+nSQlC+kdvRiG26NTdW8b12zDpXp7YyuIjpfXPRQo7wnBu+dLr5RCU6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH8PR12MB6964.namprd12.prod.outlook.com (2603:10b6:510:1bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Thu, 1 Sep
 2022 12:02:45 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a%7]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 12:02:45 +0000
Message-ID: <ec9c1279-6871-a6b0-acc8-12a29e707543@nvidia.com>
Date:   Thu, 1 Sep 2022 15:02:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Ariel Almog <ariela@nvidia.com>,
        Bar Shapira <bshapira@nvidia.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220626192444.29321-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5P194CA0004.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::14) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec795be-c37c-437e-4574-08da8c11e19c
X-MS-TrafficTypeDiagnostic: PH8PR12MB6964:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7YQG3Jn/ol3t3B9iQJGSh3GAdO5ycBvutS3xFOuLLyQpgCcH7YRIxEmZEbCzH/g+kNv21UKpGAimBLOn2Mj/3MetND3jT+WDCi6K5vhTgsny1ZiVTReIoG15xKO6RHJKr4YZxQtL3zL3nv5gBnmX3afY3f2JltPBU/mOdMNOrtFFb3flaRsNRn4+lh900pSbMcTzVkbddbbhOkprvQywwn5Cu0DwjwiJYnG09Izflfq8CmNPObx6rWPhzR7OW0Oqcl2c5FbsolpdYALeIscIuHYTL3wNJAe6A1j8eGRSSzHYvZIpZJuMoll4uf9dp+Hc+gxQUPyHI+xf4Ebkz5q307QNWaRJsGIjYsHo79dQ6V33QQQszGbNuywgZmZBGBz8FSPW7Qq4NJQXdy32SwftK8FQdbhz2Va/ZJKpQQk0lo3MQxAxLrzURXWlOEwsC8JF0pQmbLJEstKZ/c40z3Z75IRpAy5mDBHqCxhWYarbeOoI45n9HjNqnxCmf/0VlaOXppq14rvqktRHORPwQJ+eE0V/40NSCoERCHEEWmCtPncbC+ZiQamzQtEg2LKel7nRamtYSk099N5tvg05moZ4dYezWkAPaEHVovz0PzGWWb2oxQ1Eja5QAcEnlLUO+V+PEKQFk2NSndK0U67zoepNbj0x8oWUuM/VXXj3T30FQDPLJU6BiuShYigKKrcnIyDPVys8y3Rb0KAqPW3UvF1ofx0AxJQQD2M13e/mpGIOQAHtcRzGKlADeSZbLAl9RrSKkkw+4qDgUbETX2RghM1F+xXndcGDdlahNU5dLAbPikE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(316002)(6486002)(478600001)(54906003)(8676002)(66476007)(66946007)(36756003)(38100700002)(31696002)(31686004)(66556008)(110136005)(86362001)(107886003)(41300700001)(83380400001)(2616005)(26005)(6666004)(6506007)(4326008)(5660300002)(186003)(53546011)(8936002)(2906002)(4744005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MURVNm9mdHNobGdrMkZYamlkMHYxNEk4bXA2eFJsZzZaNTRMNzJJeHJ0ZVgx?=
 =?utf-8?B?R3dGWDhsUTl5SzR2TVhURDZOT1g4dDl5R2JnTWZnMW50MjZrNVJkSDJ3cXJt?=
 =?utf-8?B?L3VWV0RueXUzc1VWTWJDeWlBNUVBMjl1bXJua3RwM1A4akRlUEg2MmEwMTVq?=
 =?utf-8?B?VUtQTzV4VnZKUXJQWTgvVGFZcUs2R05Gc3lEeGJUVmZLRjZBbXludkRMWC9m?=
 =?utf-8?B?NFBFTVR3TStIcWRqWXAzRFFWdmNoM3RTbDBtbTlaUTFWVjl0dVR0dmhhbHF2?=
 =?utf-8?B?Nmo5bGlxeDByUU9FYytyN3lLRG96Q0ZtaXBoVndPNFZNRCtUQ01lTXNHRWgw?=
 =?utf-8?B?bS9oY1JYZnRaMlcwazJkekdiNzRaV3dDWWJGaXhsRUcrWkZiTHlONklnMk03?=
 =?utf-8?B?eUhuZXZGZENaYUJsUlNvV0wwcHZCNGN0MUthdEUwcnVBcmdWT1hyMk0zZGZO?=
 =?utf-8?B?ek9vbWhvM0ZXaUI2Um1qbzNLSlNqcjVrR1BwZXFjUTVJeFJiYVFvNUdwNXRZ?=
 =?utf-8?B?OWplWllnSDhEb2hLU1VJNGRWYTFMNUVFRVIrdC9Vc21mYjYyYnJjUDdOTEkr?=
 =?utf-8?B?TWF5TFRkRG0rNm5BOCtyM25MNUlUbTBHZ0w3cjBrU2lsSXFqRjJBSzlzTGRR?=
 =?utf-8?B?Z0JwZVJQSlFybEQxQ0lUNE4yY2w4ZlVnN0xZYzQzN1ZPWnBrR0lwYWN0bVgw?=
 =?utf-8?B?dTVDOVZ0LzlYd0h0RHdNTmtRSnZTc3dkTWtiQzRPODFodlRyVVVQNks2UTVQ?=
 =?utf-8?B?L25DSDA2Y2ZxS0NPY3hQaDhxOVFQNFJzeUhEa2ZIRVhGWE1CUUtLczNreE9L?=
 =?utf-8?B?aldOdk1tYzZSQmVYbG55enRLZlJ0b3REemNlRDdHVW9YQ2RlQ1JYeFJuM003?=
 =?utf-8?B?RkNjVUR1amtGcW05VG9ENXMwdDhnYXl2L1VFT3U2dU41USsvODgrZU96b01Y?=
 =?utf-8?B?NzBub2NBdVVaOVZZSThsQ0sxeWloUHEvNTh3Wjg0LzFXNVJyYWtENFJoaFNp?=
 =?utf-8?B?T3NqUG1BU3B2Z2NHbnpZeW1VVEYyeFpubzJRUXVLZVN0eU4rR3c5RkE1MnBH?=
 =?utf-8?B?ZHdmend1S2JZZ2dCU3p2djh3eldGUFJhRXUvSU0wZ3J2cWV4ZUJjSWRqTkE1?=
 =?utf-8?B?SFovZEJOZGRiZlBFS2hJUTFBaTNucjdUQzJscHFwbHVGUU9MbHJJMmR1cVJF?=
 =?utf-8?B?WFI0K1hUbTA4ZDRFMG1uN0ttUFh4ajdSRkJWc0U3WG5lM3AzZDZHMW5PYTNw?=
 =?utf-8?B?Rm9LSnpTZmdMOVU1bFIreVRRRlRLSSt3a0RsK3VGakNQYUEwT3Q5UHR0aUZF?=
 =?utf-8?B?WXBQUjdjT0E5cytRSUd4OGJMUXBsclQ2QUZTK1gxQmNGZ2FRVGM4ZmtvRXdR?=
 =?utf-8?B?dEhPRkF4WXZ0VjMxOEI5R2dwOUYxTHpYQ0lkdFFqRXduYk1KYWt1Y01kUTZD?=
 =?utf-8?B?WHFhN21mK2FiOEJVL2dRbkduZE5STnhydnJUUzRUY0V4dEMxQkpuazVRc0lD?=
 =?utf-8?B?bG5NekxoeXZEZ3RRalB2Nmt1d3UzSGw0cFhhSnVwb3A5OVh2Tjc1UFl3aCs2?=
 =?utf-8?B?Zlh5NTJ6c05QZDkvQmRFTEtwYXl4Q2hpYm1HNWE2SzV6b1FBVzRvYzR5MEtP?=
 =?utf-8?B?RUk3Z2k3Z2dnaEU2SDM3ZWgvSDhBbW5yNnZHZFc5bWZpMEJmTVhrbVNLejRv?=
 =?utf-8?B?RkhQSVczV2dGUzlIRjVzMGJXeEZxRkdGY09WbmNmU3Z0MGlWMkIvWC9TdzVm?=
 =?utf-8?B?alpFU0tYZGJsWXhvMTF1VmZUMHEwc2JnSzVmaThTVmNDVmN6ZFg4ZFJVT3pi?=
 =?utf-8?B?WXUwb0Y1dERTRGMxdTBDSmVQKzhUVmh2Mi9QV25EWHowK2p4YnhKRTEyUXk4?=
 =?utf-8?B?U25DazU1cEtBVHA4REtPSGREMDh5eGgzVS9HWTdMczJ0Z3pGekY5d1RpS2Jt?=
 =?utf-8?B?Qktjb1VDcVZnWmFlWVdzZmxxOVRXRGNsTUlzeXkwMnZyNm40RzVUTm5mUUtm?=
 =?utf-8?B?aURDa0FjQzY5bU4rV2ZPamR5L0hEb1lJMmhCQjlnWVF6ZEp0OFh1YmkxcWUy?=
 =?utf-8?B?TU96Ym9ob00rNTBhaVp6SXVPWjh3TmZmQTJldVNSbkZNK3ArOFRRdlRlY2xq?=
 =?utf-8?Q?4E8Kdb+lrPMWrO7zzGTEJiiDd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec795be-c37c-437e-4574-08da8c11e19c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 12:02:45.5825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeWhrQ/f/++6cK0Jt6/8b15GXgm8FiLwke0dbmq6orgvb3iWdbULwbREdx0GRFE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6964
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/06/2022 22:24, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
>
> Implement common API for clock/DPLL configuration and status reporting.
> The API utilises netlink interface as transport for commands and event
> notifications. This API aim to extend current pin configuration and
> make it flexible and easy to cover special configurations.

Hello Vadim,
I'm trying to understand how we can register our mlx5 hardware with this
DPLL subsystem, and honestly I don't understand how this is going to be
used eventually.

Is there anywhere else I can read more about this work? Maybe some
documentation explaining the use-cases? Is there userspace code I can
see to get a sense of the full picture?

Thanks
