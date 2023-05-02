Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB66F3C80
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjEBEB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjEBEB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:01:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EDFE4B;
        Mon,  1 May 2023 21:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6DCIsx9zzqNjAgUwIzJpKEvqDoiIW3kpxFeeZ34pFT+z6/oB90XVUIxMSkUnQg0D5IM5L8Vzo5nCkBUbn2jd69NbbJoXvKPiBpsgRw49XQJpk9q9clxBOxWJWaADNODEVTogontT+fyo/+5X9jnkl4ktdj5W+szhys2bGvBV3v2foJniv4Tanhwi5MNY06w0wGr8QFjzkb40HGW63whWxrzAjhR6VRjTWHgZ5Y9nGJQhfP+SgUYPKTepWgdj15VK4+qsB2VvBirdJmBKKrSDnZbDMsWnijuhpfM+cD0JNwtzHWO2gz583YWwEXqakWdIvkaVXTcjeyNBpOkrBfjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=na8HlN+nIIEm8myvWucWjNxw6N+t8vD/aJrdVXUaBR4=;
 b=Ii27sDILB9KyDFdu4h/aP88feXIA/0si9kpk+MR2L6fXVKH8P0z0drGfYSdbj6lEz2bpCzDXevNg/5xozzW9sJA3oD14xvRhs9W5fvRMtGLrf/ycWUnmFeJRkuGM/nrxRP+Z6+BdADWssYKDUWlmOZZtbVbuepTLJdGV9uW/7A6WobeQOdsfYPi7JM7TgVaILQ0xHG3BHxd4lOq/oiwFoPBJpCgaWVhTgvQD+o5EzfapJEgwf/bpMdBA0iCF62pfV59cvOZxJP74ppZxBE4En1uixizsNL4CWbky3IC7wUvAIgqc3OCnMB5E31DhqobLnwSo2dYUCtDJI9+FdyWgLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na8HlN+nIIEm8myvWucWjNxw6N+t8vD/aJrdVXUaBR4=;
 b=IQvaVd1I2WjJnnjszXkmYgnauSJI3KncuGC+48h6PWey8QPxtP/xMntiAuaamLMEW4pgbJM8KADn1qScWaK0rWa64VRj+KD9+vQflghPoE28DCxbT6RRpyAM60es/vHsMbd8LWlga4wIeH3NZv2QXmwCqRmVBjv4XDS/ba/8Htk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB8244.namprd12.prod.outlook.com (2603:10b6:930:72::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.30; Tue, 2 May 2023 04:01:22 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 04:01:22 +0000
Message-ID: <84bc488b-5b4b-49ec-7e1a-3a88f92476f6@amd.com>
Date:   Mon, 1 May 2023 21:01:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH] pds_core: fix linking without CONFIG_DEBUG_FS
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc:     Brett Creeley <brett.creeley@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230501150624.3552344-1-arnd@kernel.org>
 <20230501153502.34f194ed@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230501153502.34f194ed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0073.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::14) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB8244:EE_
X-MS-Office365-Filtering-Correlation-Id: 463cd557-efaa-4dc9-9229-08db4ac1e43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+BDxg1XSbjA/nUTQ/lEy98sXwCzSaLzhe372mF2yHU3jqrtCk5CpSjpd+n4g+2bpshetm1n+GfYOq3syW+7JRH3hPDdvwZhf6HkYbcQB+vstlHuqs4/SoCsn//dJ/5LAF8OoYR2GBQhtitdh1l8YJ+BGWAStSajIAi7Z3rTKNkAMY8M8v9x0YWDf9aqYQtPzCz+7RmMHiWhh7Ey58MB8O/IsltrKlwunH9vN7YBtnmpoH8k+wkBLRICf1CGGamgypNPJfs/BkBdSdW3uJoh2piXW0pKHrnQHtHqLoekPl7sbnKXej7pxSO6GJXQesZDSAt58BnzxxUZW/BHZ8qtTSxUjNAvwuemqX2MECKqRrLajtmp2VDW2WZXZM3FO6etwezl0Ugu0+ZgkCXqa14jubQNgzvTI0prfmrqdgZNpEqkNeHCRHL8wWY33qeQN4hnnOgbd7CdhfjdHvkHPJxqPNxd2MBXDenH1pElGCa1MxqlnjyD5Lksp5tsV/XLd38I9lwXuILCRMW3sWXlNHc6k8Gzew91ms3++avNrx7QLr+L8Q7mDVCZaOxJbIAJM7MA9YF3n3yfiqGjTwshzGH11TAJafl3zQYVGQvyhPAMNDXaZqGZHLjnN7OCKp7CqMJTfJvK/MHwlyAYtCLsRZGCGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(31686004)(316002)(53546011)(26005)(6512007)(6506007)(8936002)(5660300002)(44832011)(8676002)(31696002)(86362001)(478600001)(66476007)(2616005)(186003)(110136005)(66556008)(66946007)(83380400001)(41300700001)(54906003)(36756003)(2906002)(6666004)(6486002)(4326008)(38100700002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGdXV3dKS1kvVlNIV29mVitEcklxTW9OSjFIcURBeEwrSDNZcVVoNGJzcnlR?=
 =?utf-8?B?UitDN2dqbmgwZStqUWtyWE9iOThjY3hWSnZMV2pBNUo2bGcxeTJDMVpPeHZY?=
 =?utf-8?B?bDJwTmlVTTFOY3BxUjNVa1h5emRGdTVTOFFtbFhUUG1XR0NUbkQ0WE9QY2FG?=
 =?utf-8?B?Sms5dWI5WHJKaHV4clVZOWdnMnI2bmk0Z2hBeGpaVExuWjYrYXNpREJRVmhD?=
 =?utf-8?B?S2xUYmh1bk9TMEk3UExVcU91bVdBRlZmQytBOFFDTWFTWTZieHE2eWJzKzg2?=
 =?utf-8?B?alE0ZjUwYm9OK2VFSytUY1FTTkxPelp2eVJXb0lIcDhkMnZTRHpuaHFabWFD?=
 =?utf-8?B?Qmo2Myt0eVAyZ0ZsUHo5dFBNcGJLMENtSGZFQnNqUlpURG15cTNQQkNjN0Fs?=
 =?utf-8?B?c011dVo2bmVJRDcxU21yaGNOcVhLSFN2ck1pb293QkNoZ3ZGTTl1cGRuV0tQ?=
 =?utf-8?B?dU5DNWFwcDRlTE1lb25uNTBnSXhTU004VWFqMzFvRVhYUHowZEtFRmMwNFhX?=
 =?utf-8?B?RHp5TUhLZ0UxRlFxOCtjK1VFTk9FSzk3Z2d3VEdNV0tLMktId2NvWWdnM1Vv?=
 =?utf-8?B?OUt3Vkg3RHNXanFGamlrbVZNOTBYNjUvMVE4allWZHcvRFF3M2EycGFhYUNy?=
 =?utf-8?B?R1hPUmhhRnhmdEhzZ2hnV0I0aTFwVFd1bGlwamEwTStmQmQ0UGp4V2txc1Jn?=
 =?utf-8?B?c1E1WmlDWk5DOEdGSFA0SnpDV1JHREJXWjdGQ3VoMlRGQnZ4ZjBZWC9hN2lw?=
 =?utf-8?B?a3p4RDA2Wjk4bmN4SXNCamp2ZlN5N1ozcGJjV0F6SlVVeVA0NjhvOEhCSUV1?=
 =?utf-8?B?VXQ5QVlmQUlQRzlka3VIeUlTYnYxaTJPSk5JZVo3VGFsV216b2pVUG56c3BQ?=
 =?utf-8?B?Nm03Z3ZmbzlNQnB1Mkhvb0dLd1h6RXZYRkxHQ1Z1UTNjK0I0VUE1SHpoM0Nk?=
 =?utf-8?B?K2F3OVphR0E1WmJIL3hianVNTTJ3Rm5kRG9sL01UVXNPTFNBV3VsRjVmNk9G?=
 =?utf-8?B?M2tlMHllZmxGRWRCaUtuK0R2Ym5FSXI0dTR5ZlVBZW84VDlKbStuUEJsUUNG?=
 =?utf-8?B?NTFlQzFRYkVkUkVHd0Zia0tKZEQwL2ljUFpRQXQxc0taRTZBVjRaRkwzWnN3?=
 =?utf-8?B?dit1WHJ6eEFFbXdmOXBjMjNnZGhVVEl3SkxaL0MxUkREYTBWblduUDlwU1Bp?=
 =?utf-8?B?KzR5aS9HNXhqbjRqdWwrQ2RVWFpSQlNqaWRzVmxIdEZnSFNJRzJnOWRKQWpC?=
 =?utf-8?B?ZmtHanhLRjFYWFRLaEpOTXAyanJYamRhNW1SWHBRVWVIVTFqTGxDWWg2ejd4?=
 =?utf-8?B?UU8wTkplMkIxRW4zNVpjL2ZHUDkwOVBTZGdDcmd0cjFkcDdqVWtnblZidTBI?=
 =?utf-8?B?MXBHcS85RTlrUlNiUEV1RTRTNHp5OHRXSVZ0eitzdGp3Z1JHUWxMRlR2MTQ1?=
 =?utf-8?B?V0tWMkVRcG5yMnY3QVBYN01Uc3pXTCs4YUw0TWgxYXdPS1hGQWMxTXdjSThP?=
 =?utf-8?B?V1VtQ2JEN29oNHcxQ1JkR1g5T1lXak5oSlFoRXRJcjN5RnR4bmsvT2VXL1R3?=
 =?utf-8?B?cHRJeC9KYkF2UTdpczIvZC9ncjlwbmtzYUtORXloRmRmR0JNSzl2U1hVV1Jv?=
 =?utf-8?B?WjN4OW51SVplREJ6Zjh3YUo3Mlk4aDBWMlJkRjZCQ3o2bEJkYjBNajM4K2J3?=
 =?utf-8?B?VThKV2JFVW13ajVndlZoYkg1dU0vZXBkUkx5Sk5mWEI4QnB4ZkxhWlQxNWZt?=
 =?utf-8?B?WmY1WTlNTENkSUpSSnVDNWlicmV1ODRQU3d2TjUyOUdINmQ3R3ZQbE1EcGdt?=
 =?utf-8?B?Q2NMUjEyaTg5UGN1dUJqa2dvUVlmY1hzYjE0TFpISHdObklQdFhZU3FIbE9V?=
 =?utf-8?B?djZJZ2Y5SHQ4TGVEZ05IK1NHT1RFbGViZHVJQ2xxREdSOXRVWGdFYVVKVTF6?=
 =?utf-8?B?ZmY0TTVFL01tTzNwNHBwbkMvYjc1eWNJYmdlQW5SRWhybEduc0dJQzJLa3pt?=
 =?utf-8?B?UXlEVUFJTEtXVWFrQUFJbEtPRjhKZVhyQ1lyQlNHaGlISzJrcGN2ZW42bDJs?=
 =?utf-8?B?NFVKUUdVSG0vTVJyN3BnSUV5ZDl0UGRXTjhUOVZkdENQbTRGRTB2NDNWaCt4?=
 =?utf-8?Q?WOP9/32OrkLoVad92ZmQwrDXT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463cd557-efaa-4dc9-9229-08db4ac1e43b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 04:01:22.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybdFzqnCQACD9/oK/Yg5iN+bJAeOVlsZlzTOZY3dopf7uiQ0P8tcChfOLNElPx9MoiAPKcSYHYerTKVO7p4rgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8244
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/23 3:35 PM, Jakub Kicinski wrote:
> On Mon,  1 May 2023 17:06:14 +0200 Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The debugfs.o file is only built when the fs is enabled:
>>
>> main.c:(.text+0x47c): undefined reference to `pdsc_debugfs_del_dev'
>> main.c:(.text+0x8dc): undefined reference to `pdsc_debugfs_add_dev'
>> main.c:(.exit.text+0x14): undefined reference to `pdsc_debugfs_destroy'
>> main.c:(.init.text+0x8): undefined reference to `pdsc_debugfs_create'
>> dev.c:(.text+0x988): undefined reference to `pdsc_debugfs_add_ident'
>> core.c:(.text+0x6b0): undefined reference to `pdsc_debugfs_del_qcq'
>> core.c:(.text+0x998): undefined reference to `pdsc_debugfs_add_qcq'
>> core.c:(.text+0xf0c): undefined reference to `pdsc_debugfs_add_viftype'
>>
>> Add dummy helper functions for these interfaces.
> 
> Debugfs should wrap itself. Doesn't this work:
> 
> diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
> index 0abc33ce826c..54d1d5b375ce 100644
> --- a/drivers/net/ethernet/amd/pds_core/Makefile
> +++ b/drivers/net/ethernet/amd/pds_core/Makefile
> @@ -9,6 +9,5 @@ pds_core-y := main.o \
>                dev.o \
>                adminq.o \
>                core.o \
> -             fw.o
> -
> -pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
> +             fw.o \
> +             debugfs.o

Yes, that should do it, and should have been done in the rest of the 
change that I made after Leon suggested removing the dummy functions 
that I originally had there [0].

Tomorrow when I'm back from vacation I can do a couple of follow-up 
patches for this and for the other config tags that Simon pointed out.

sln

[0] https://lore.kernel.org/netdev/20230409112645.GS14869@unreal/
