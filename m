Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406F2520541
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiEIT1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbiEIT1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:27:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2422D7EF0;
        Mon,  9 May 2022 12:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iif52KIbc7UtlQosb9JXA6BqqP2uwSur/XlUofmPzfvzRYd6FPD2eBun6YNDUcYxqOqGI/YVOZytmKxnBjQDI/Hi6oRvazsL0vokWjxFRdOK5KaJge5tHEIsK9L8zqa+gHVz2mTByHTWeCpk0tNM8rbrgPdtLZkwL2Nkcta7Vn0Y+20BGSYyK7dzdSPK4R9s5HJGbdT/U6c2rSQBFTTu9jT6564EBg/qzyHi3gU/tLXpfvk6MgvaGg6VFoxZUInlPwR3keRMOCVeJLwNFNnj01JcpZz3N/Sij89nHj1krkjg0keiSXzjZMvaTNZZOwONJjPme20Z0fbtKeXdra0sJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+z3PrZmUdo3glU6VG5FTEyZ9SxHRnhCwi9qdzAJqgfU=;
 b=IqKAT1q2/mALdR79w9vRwEKi3pSYch/Yj1fB99bhYYDVpm+TllTpSQ3PfV2BhiBxnFvGBsbkZiVyc/p4TdqBPaCYYkmNk/NZvCJHwKsg0mcCrQ0RW6taKlfhF0ImIR3dop+WZMhV02M+91p9DrW7Ze2QVSXaYG2o1tLsTGe1dFh3ytXuvvQcq4TxPe4MnVgdoHyZdRS/TfdA50Je+rB7c9keKVV2iq31kYeLhl5bJUTBgVgKzOXZczPhQ6M4nxoRgtXLepaaSs/cqdFr6Dduzmd0S7A3cViigkGxBHATsFf472wOMybMS1vKd/z3ObKuAJiFtRn8MBGmIyQmKX8ECg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+z3PrZmUdo3glU6VG5FTEyZ9SxHRnhCwi9qdzAJqgfU=;
 b=eXEEGpO6J/f5NHhK49R0aVpcsk6LgSVWsTNCnQpeS6r8xJbEAefkwh5boBC3Bl4a2LAhOlU7BWzfEjXi4o3AHt+VWC9EXud0y75/vmSDnaBWibGMXgdwr/KON90mCNybDoHdF2hPHuV4PRV+EZalfP6nheFyq3hWokPOfq3BXHaZS+G55X9ErDIRU1o4JV9bi0eEVNRYjm6zH0yhte1TdLn3zvfro3Opf9QQPN017S0srgMCMvnwgPVFj+yag263vYcYCa+KQs8XjO6aTWELKJn1P8PMgfhGqrG/s4w7rABlx7iBGMyCP/mO/9R84TXxI5ZZtWnzidJKTMKOFlmXiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by DM6PR12MB4893.namprd12.prod.outlook.com (2603:10b6:5:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 19:23:22 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 19:23:22 +0000
Message-ID: <bd1daca9-f628-7b28-a0ca-f34115287552@nvidia.com>
Date:   Mon, 9 May 2022 12:23:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: using mbuto to run kselftests
Content-Language: en-US
To:     Stefano Brivio <sbrivio@redhat.com>,
        linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
        netdev@vger.kernel.org
References: <20220509173140.549db406@elisabeth>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220509173140.549db406@elisabeth>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0188.namprd05.prod.outlook.com
 (2603:10b6:a03:330::13) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd69e67e-e719-4083-3984-08da31f161b8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4893:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB48935E3A0356986444272D14CBC69@DM6PR12MB4893.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9QwGgfc2R9ycc87FdLnQmgVNxGm3SZ10ZNa3AMKApqdilL7FQ1fWYLGAVOzZeK8/Ea4Lzz5f9zwId6xzxNj27FLetictC+AuFhOI6LBVOntlr2M9ZSonTDefxugMLU0Ex1ORMxbwMUcGY8Bq2DJn7C68LlaaR63v3BiNHmSKi2c/nUCJAicIRK8nUxXIgaKBo84LhcAi+S9bF+nhfkkrZ/ldR6KMFM5PxAqsuTUIgxiZ3mxfAt/yA6MbaH/yYuPldSOrBmCsi4AMba/2uKA6QVd0vHxl2OJi3uToVniD0A1t0SrbxT27z0TXwhMtp8c0v3Ei5YOzrrNB7RqxqlBJ9Tjyfi4B63YwJS40fZUb5joguBtPkl0yKhGsKMVVnC83/4fwz1jiS6WYw+KdWw6XqMiEfGfa1o7c8f7cRk5PDJRTCjKfA/AL7/b7o1o0c28yNE0Yg0I8SYmzbKc84lDo5EmCqqud/oxwPyPA0vyzlIscHP37KU9oLIyoFRKdVe0ATGNZ4mPd96Za/9eVLoq1jFQFR3XCEiWSEGeWN+IbhCCmlOQdBDCrP2VNXB2ffStZ7aiWBkOZRPiUyoPad5rU3T7Pd15Oghx07TLWNxhU9nNRLMkyhtUGWzkKB2eyptoG7+lWCukWP6fQoS0W2oy5F1MmMGAOsu6/Wq6bLUP3r3V7DnRqDYt9iQ0afLpFUxre7rp0NA1T+DnCRIRSCBEyrUlX8rsBFV/pK5ISHVbwn5Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(31686004)(86362001)(6512007)(66946007)(66556008)(66476007)(6506007)(53546011)(4326008)(5660300002)(26005)(6666004)(31696002)(8936002)(36756003)(2906002)(186003)(4744005)(8676002)(508600001)(6486002)(966005)(316002)(54906003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3RwYnovUXhIZzd6K2lRR09uNDhDNWU3UXcrL0JEYlUwQ3NGTWFFdE1UV05E?=
 =?utf-8?B?aVlrYkxzL2ovdlVhR25DRXpscUgveFZJV1ZsZm93WFpqN1ZCUGZOaUt6L21y?=
 =?utf-8?B?NXFBVUxjQmdIbm5MckxOWnFsdy9ZYUZJaUYrbEJqVXhoQndsdjZpM0F2L3Vh?=
 =?utf-8?B?YnFncEVqdFBJRkxveE9BS3NEVHRUQ0pTRXdEK0t1SDUrQVA3YllWb2xvRXNp?=
 =?utf-8?B?SVZhWVNKdjdwWjVpUUZySGN4bHpxdFZDeXgrT3o0dWk5Z0tqdlRpWmFKNm9G?=
 =?utf-8?B?OTJuazhMSmI2bERrdHBWZWg0bmE2NGNxcVJpZGpTSW12K1JzQzU2cHg4RWJy?=
 =?utf-8?B?MlNyNmNjajFteE8wWmlaZGdsbERYbW9UaS9GTlZUY0ZLNXJzNG14VTJlNWlr?=
 =?utf-8?B?NFBOTng1empkVnFUQ0N6alVFT3NDVEtPV29Ycmt1bFQvTW9wVG1jM1BEdmdo?=
 =?utf-8?B?STJKVERwUG1GV3hyeG1UQUZvZk4wRnQrTkx4dE8xSHVrQmtDd2pvdWZsOURC?=
 =?utf-8?B?b3pDUXNvUFZMS2ZsdjZidlR5YytRRjlIUzBlUTlNcjl1ZDUrNGdIMmpUZnp6?=
 =?utf-8?B?aFRDaHE3WHhXczJYL0VQdlRRVU42MWZoc1Y1eTdmZ1Y2RU1aQ21RY1NQUExO?=
 =?utf-8?B?MEMxRlhuMXFZekhSaFNnekRLNDU2NW1GZ3dpZEhUL3VLd1p1RjE0MG5zSndZ?=
 =?utf-8?B?MmZXc2NMQkM5K01iTWJGbHhmazdpMWZKMGNCR0c1d3ZVNWliQ1V1SUxZWG5r?=
 =?utf-8?B?RjQrc3RCUkMxWThWbnlQVElLRlFKNGppOGlLSDFTVjBwNFBCeGt4SjZJbmp1?=
 =?utf-8?B?Rm9hWHF4RHNDTnIwZGFNbmFaMzhiZ1ZmcU1GMXVTa2UyY3M2VjZEbHhIeCtI?=
 =?utf-8?B?d01ac3FPdkN0QXB3M2tzaW5GbjhOMkVZdkFURGh5bTh4S1F6WW9vT0wrS0NF?=
 =?utf-8?B?ckRra05xK29VQmc3VTBnVXdEMGJBNUhXQVBFU3c3NFNiYmtyY0JOQmJnTU9a?=
 =?utf-8?B?blh0dWlDM3BYMDJtVnU3MnRRQ3lnU2p1SmtYODFYM0tMZ3BBK0xMZ1h6c09l?=
 =?utf-8?B?Q09hQ29JNWNHeTg3Qjl6amlzbEZ3cmFFRVpSUWhJdzNxVnhhMFlLbzZneDBG?=
 =?utf-8?B?SE9BUHFIR3A0NGxLakVrNEt0ZlQyeVkvN3dSQW85SGtiRFB0RnptYUZXSnh6?=
 =?utf-8?B?TUs4ZkV3K0NQMEIxUTNaOThMRXZweG9qZEYxRkFtcXNiaDkwemJ2VmV0Wm9t?=
 =?utf-8?B?UXVseVlJemU2T1pBZEg5WGNpRWo2eU9HWXNTZHR1SUM3UEpadGg3KzBCU3RV?=
 =?utf-8?B?K095ODJHREF4ZUh0YmNPcWE4c2pWVlZPNXA0RkpyVkVlVERhWHFnTEM2RXVG?=
 =?utf-8?B?dzZkcEFNb1VkejEzeFZhdGptRnJENVc4eEtYSVlmY09Ua044cGJ2TXFSTm5F?=
 =?utf-8?B?ZFV2aGRNckZIUFRDSGJNQmQwZnIxSDB1NCsxK3hNYVl3cm01M1FDK1dKZVpL?=
 =?utf-8?B?MS9BRERZWEFzNjAzL09QcVZMWmhLbHQzeTQ4NnJGWFBucFJqL3NqbkJrckdD?=
 =?utf-8?B?V2xXVjZNV3ZyZDhsUmd3bVN4UUV6cVNSNS9qWFlEZnRpMHZlWUdYR0xLR2ZV?=
 =?utf-8?B?Ri8xcVJWazdyUHdKZ0cvd3lDRnV1ZWdPUjNvSTQ4OEdYM0h4Q1NnL0hMam5a?=
 =?utf-8?B?VjRVeXdXRzRScE5YbEVwQ2hJNDk3OUlOZ0NzMlptM25NcjlEeXdSS1dNVXdF?=
 =?utf-8?B?RWZTby9QVEJyNXZwVVk3YXZsdExIMlA2NERtOEFHUlpvVFBQNzJBQ2ZlZHh2?=
 =?utf-8?B?SWNZb2Y1eVZRajZ3ZlQ0UEN6Z1lwVUdxVlhyM3lveEl6K0xuUWF3VnhWYzJE?=
 =?utf-8?B?Zll2dXN3c3NjSnpNN29sMDkzbUFoSjVPcTZZWVF6dXlpdUsvSlgxR3lZVlNM?=
 =?utf-8?B?QkNTRi9oN1p6Q2ViWVZUMnpzVmtzUTVZL0FMUEthMzBiaHlveTFKaUxHT1dP?=
 =?utf-8?B?YUFzcERGdGdtemJ2eVZGR1pYMFd1N2xVRmY3WmlHNUVhRTlEaTdFNHhJck11?=
 =?utf-8?B?WGdwUWFzdjQ1VkI3MU9jOUhuT3pKRXhZR0oyTVNOV01rYWVudDZLU3BzdHAy?=
 =?utf-8?B?ZTBSWkJ4NmJZTWJ2VUtBdTRud0NHR1g4Ukh0bWQzaUJSN3RSR3oxWG9aTzht?=
 =?utf-8?B?bmpUbGZPSUpzdkZ5azF2NWt4emZ0WXpEdy9qVm5CaE5vREJCZnlHZGI5Wkxl?=
 =?utf-8?B?UU9LQkREK1pTMG9OakIvZXhmTWtva1RxSU1FN2lpVk9QbGVhaUt2blkzVTh2?=
 =?utf-8?B?R1FST0YxcHJpM0k3OWdiY3I0eWYyeUhubWxjUDhmS3dMaml5SEN4QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd69e67e-e719-4083-3984-08da31f161b8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 19:23:22.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYjNVZ2CJpM6BW8lEX+sI49hAY4m+jLSPY/7KQZ1dTbF9t7adgk4iK2kcvAmDLgOJrp7OP1TZ8e/PUjbxWUeag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4893
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also including netdev@vger since it is being used to run/develop net 
selftests.

On 5/9/22 08:31, Stefano Brivio wrote:
> Hi,
>
> Thanks to a substantial contribution by Sevinj Aghayeva during the
> Outreachy contribution phase, mbuto (a shell script building initramfs
> images that can be loaded by qemu) can now be used to conveniently run
> kernel selftests in VMs. The website at:
>
> 	https://mbuto.sh/
>
> shows examples with kselftests and a link to the man page.
>
> Comments, bug reports and patches are all very welcome!
>
