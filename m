Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61FC4DBFBA
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiCQGxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiCQGxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:53:20 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2115.outbound.protection.outlook.com [40.107.215.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40399BE38;
        Wed, 16 Mar 2022 23:52:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpMSq0W9FxkqXdXQM5Tkq9KtDRdLIYJ5B7JkzQcz++W7oIdGxWFSQq+NBzOMuK6lGPMMPGI7XHVyKiLwoAn+vnVHN42b2I5tqH99p7aJbHBb/b6XJeoSpINzPDZjE5Ms9T+eZTzSiuun6CymsufhwUZ1+drEadeROslmOY9wm2421pZiFWrEd5s32pVjFeaf/czaK14ARIlA0oQZj9TOdjBaXZNohxY5KDLHz5roteBCFHFQbEbX8mfFKBzzYdEzdYDC7vX4QkPaXlQffafz/KtyOTHytAlRQfmOjvqrOU28LO8rxF6W3wxLmllIcSwmda2fAebn11B/5IxgAaDplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzHd/AlbQWIw66Ext+NH2rgaI1dhjO/c0r9FFu2DftE=;
 b=Jq9pQx99yWU6rUoRUOXH8/bu85M6oSCup0YwDlNVONMdXzjx3ogb/fqYdqbecVFy9MOwnUZua+vAE8inDNhPoo6LJ6p4rHzmadncck9b+2hcGZhytHhRxjU1rvvMaK/JIyCf3Fk641cZY7PbEPdeZ2MRG+pWlo8FpJzqZ+BDhsa2Dee+7n0pheQCLAMKH2Ipgq9OkF+teNk7aITQaHL+dQ+h1wwX8QswSbJx7RdX35P0OvPH1wMrUoiYv40OGxmz/2gXKzkcAxKRnD0Kt9vX5dYip0jcRJMaK4Ok4n5eyGXcY8UfusJPDr9YdwvtV+37wmIOGtwNGz8UHLn0xk0PqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzHd/AlbQWIw66Ext+NH2rgaI1dhjO/c0r9FFu2DftE=;
 b=flwxBC5Lvx00NRlIaiKTeThIkAlWXKSZg+3VOvuHYK4wYA2JQ85Owoa3GTfqvrw0TTQao3dw833qa9XGpV1Rl7XTpabwOab8OjmBrnLVnK7ez8+URGduTOOdZebNnRuY8ftxXEPa8pV07GtFK7X3Na+P6z0jnz6URweKXPYPIW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by KL1PR0601MB4082.apcprd06.prod.outlook.com (2603:1096:820:2f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 06:51:55 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 06:51:55 +0000
Message-ID: <1d21ee8a-837d-807d-14a4-4ee1af640089@vivo.com>
Date:   Thu, 17 Mar 2022 14:51:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] selftests: net: fix warning when compiling selftest/net
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "zhengkui_guo@outlook.com" <zhengkui_guo@outlook.com>
References: <20220316115040.10876-1-guozhengkui@vivo.com>
 <20220316202251.382b687e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Guo Zhengkui <guozhengkui@vivo.com>
In-Reply-To: <20220316202251.382b687e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0053.apcprd03.prod.outlook.com
 (2603:1096:202:17::23) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abe26f91-b6af-42af-90ab-08da07e29f4c
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4082:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4082F3469E0BD329C33DBBBFC7129@KL1PR0601MB4082.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ohaWy2s8i6CWX6AKE1GvKCoiAmvICgKX2TeueJ5HYEQok6Hsa3JAfLuKptujhgOv2XRIIC0Dxwyn4sLBT+xfJrS+DpfNjf+Eg22JFXSwvARdRSiBE0eVMhiMVSQ1Fy82ocZcPHgc84NNu4UQmvzROETR4RV2WyZOBGp/9dRvfteij4W9cIgUH3OeN1KMeLlHv90FWRW/g0tGNJZBno9tgeYFEn+HS1989D3/c4Z/8qPBz2Zxi74ymvoIU9u2LwlybEIRjy1z7aqntlbn0XNgV/WNTuWfbo6nUG3avlvRkcqF7b1bSP6rO8qKFSHbWlNjBl4g5FlPvYkumlgH69aXKTb8dRWdv16/3JX1SegZTnH0wZqhxgGO0ENjcnc5s9U73yRia5rIkBez58zPhuKREWM49SFSYBEsLiwFXujBq1ieffQ8Y0NIRx06HFhfzi09ZMI+fr3r5PVuRfUKlvcPIVp/L/Yw5WAP9q4909ly2VtX6aAhhoI3tDL1GJKr6Q7UVnFJ+fCJ8TeCnRX765uFMp/DUtuhvDpFylvS5Wz9dkQtADEe1lldtsQFNt8wOdGYiLgNaDwT1IrQhrrYdIo9lj2LMPoQEsKmPwcwooytGXu/9ieJLBsFc4VLhLAeWAGYjDVVRXrDIPel67j0BxGzDocBb3f/Pkud7SCH2GWF4vKuSk4LcV/0zp6j+sED+JYa7vD0Xrg4vOC0pRKPsPJbbt7M/C1T698WI0FwoN//cD5HEfZOzNxzMgON4oZxNYZuo3L4KQOasRzil4YAyjkSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(31686004)(52116002)(36756003)(6506007)(6916009)(186003)(54906003)(53546011)(38100700002)(38350700002)(508600001)(8676002)(4326008)(8936002)(83380400001)(6512007)(6666004)(6486002)(86362001)(2616005)(2906002)(31696002)(316002)(5660300002)(66946007)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGIrMExrSHRWK2xaZW1ZVFlBOFM4TzNBNEVVa1YrQzJ3V2tXaVBRaTNZRWpl?=
 =?utf-8?B?K2dyVTc2eW1oYzdWdW1SdkMxZyttKy9BS0pqU2pvRVplVS8veEt5Mkx0Z3Vr?=
 =?utf-8?B?RWxyUEJTYnFXRUJRdVdmRE9pVzRWZ1pock5HUW8rSU04OHpRTUpyVklGSXpY?=
 =?utf-8?B?b01sNXp0cWlDMCttM3diQ3VIOVQ2VVJTa0xQdkRmUzlHbUtZbURncnVGSXBB?=
 =?utf-8?B?dVYxS0lnNWlzSjBBZFVtejhTL05SUmNtc3ZyV1JROWd2eEhkYnZDVXhDeTI1?=
 =?utf-8?B?djJJZjlBQ2wxdncwa0gyM1JOU3EvNTFYcmRMVTBsb282RlB4RUpST3FRcVhM?=
 =?utf-8?B?VUxSMGMwU29WTzhVa2VNOFRCTEJwdmJ6QnZjTDJJTmk4UjlRRU1QZkxrcTBG?=
 =?utf-8?B?bGZpdVVQWWMvRnZ4TjhCREd2UUR3bFdGK2tZSmRubHRrcTlMY0d5YUhsdk5Y?=
 =?utf-8?B?ZmNoUmU5Y3krRDEyaXlEUXJQaXRoOFpObFBxL04xdHlaMGhUTlVvS3RjQTZE?=
 =?utf-8?B?ejB4Q0lxQUd4Uk4xVzlrQy9FV2E5YThKQmlSV1dwdDE2cFJPSmxLR3h3b2ls?=
 =?utf-8?B?ODl5K2FhNlZQbEFhSmVaTWtUNHY4WTZhVFA0RzBkZXBMZms3SFhrTXJaK05Q?=
 =?utf-8?B?SmpzdDI3V2F3dmJVbFdGQUY4L29sc3ZkV2hBck95UVFMLzJ0bGFHNlFydnda?=
 =?utf-8?B?Y1FMODlmL2FnZS9HV24xT1l2eXBORk9PZnJabnpJeks4encrL0VxZ0NNbVpN?=
 =?utf-8?B?K3hzZjRJcnB2cDMyQVNVa0VJeTdKazkxZHUrYXVsRWpEUHBTblJrMWFhUDRk?=
 =?utf-8?B?TEJMbExUeXRzZENwemorNTliKzVvRHg5cWFiajVZejhMWXliYWhERFhmOGpp?=
 =?utf-8?B?Y1daT1BjZUk1NGRTR1RxL29MWVpNTzVHblBzeC9Ib2NYeTV1TTRySnJpb1Nm?=
 =?utf-8?B?akFTMGhIeEVnUWpUS2FGWEpOV3Zpd0hOam5FY29NZ1R0cHVxOENWV2syVEpm?=
 =?utf-8?B?NGk3R0tSYlVUL3F4QUF2MHB5NzA5L1RzWWJZOGYxUEJWcUMxaVZRTmI4T1I1?=
 =?utf-8?B?b2J1TzZSdm9hWHpvTmx0N1MwRFhhZFNoRHo2cXNkcnNrZzNtMHFRb3Q0UURy?=
 =?utf-8?B?d0ZpZG5aSFhYRkNsZXprZU1nUW1aMDNHblpJZEdrWEU5SUFmeWY5TUljRmRO?=
 =?utf-8?B?b2tFU2FFZGZwMlY4UzJJMS96dDc2UWpuUkZJTHV5K29vNS9pS3FlTytaVEti?=
 =?utf-8?B?eHptOElZeTk1SVcxZm9hTHJ6RFB5OGRpMndzQlpDUXFIZ1ZnSjdod1JvMW5y?=
 =?utf-8?B?NUNEMGFWTkdGd044YzlISFBRR3hrVkU2NEkrbFMyWlpVUzgzTUVpMzZFdmU3?=
 =?utf-8?B?a2lDM1VwcDc1QmRiRmZWbDQzdEkyZUVvS1NuL2NjQ2ppaXlQeStHNHRrMFBw?=
 =?utf-8?B?Ulc0MFNuSE1PbjkrUFVqQW51Z2ZsR2FYMkIxNlE3Wk5MdmdxRTJtVXlmVGtV?=
 =?utf-8?B?VkRQckxJTzZOa0FSSzhjcFJpZHd5THdyeVdVSStOcEtwTlprcDRjUGMwL3RM?=
 =?utf-8?B?RU13SkRrZTFWbU0xNTJYQjdqbENwcVNuVncyUHRScEVvbDNSTGE1UVdJTG1R?=
 =?utf-8?B?dWg5Wm00c0FnVUF3emcvVGZaTTAreEU3UHp0Y0I3S3FIeUE3VFJ2d0taZW8x?=
 =?utf-8?B?cS9nQWZLU1Z4RmJFS2RLWVBOa0xQQ2FxYThjd1cySGZWY2h0NFU3REY3RXdO?=
 =?utf-8?B?UnkrWlVQYUtEaFZkQ0NFS1JJQ1EyR1l5N1EzNnV1ZkdiczJPMnlUdE8zblh5?=
 =?utf-8?B?bVRSOVppaU1neWxGeFpHeXl1NEFTSS83Z0FmSkNIR1hDZEdHTmtlM2ltSUps?=
 =?utf-8?B?ckRRMkg5RjY1Y05zaW1LWXhPVVpLT1pOUnRLS1Q5RjRibmQxbUJkTkcyRG40?=
 =?utf-8?Q?Z5knw/XHgmIK3VDQcceddstDo6EpwDhc?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe26f91-b6af-42af-90ab-08da07e29f4c
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 06:51:54.8100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vp4lyXToj6zCfv0VDlgSoExcM84TXbh2gU4VshT5siL2Idizhp2p+EDwMkSrKxo2dATpVRKt2keTP3zLronFXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4082
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/3/17 11:22, Jakub Kicinski wrote:
> On Wed, 16 Mar 2022 19:50:40 +0800 Guo Zhengkui wrote:
>> When I compile tools/testing/selftests/net/ by
>> `make -C tools/testing/selftests/net` with gcc (Debian 8.3.0-6) 8.3.0,
>> it reports the following warnings:
>>
>> txtimestamp.c: In function 'validate_timestamp':
>> txtimestamp.c:164:29: warning: format '%lu' expects argument of type
>> 'long unsigned int', but argument 3 has type 'int64_t'
>> {aka 'long long int'} [-Wformat=]
>>     fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
>>                             ~~^
>>                             %llu
>>       cur64 - start64, min_delay, max_delay);
>>       ~~~~~~~~~~~~~~~
>> txtimestamp.c: In function '__print_ts_delta_formatted':
>> txtimestamp.c:173:22: warning: format '%lu' expects argument of type
>> 'long unsigned int', but argument 3 has type 'int64_t'
>> {aka 'long long int'} [-Wformat=]
>>     fprintf(stderr, "%lu ns", ts_delta);
>>                      ~~^      ~~~~~~~~
>>                      %llu
>> txtimestamp.c:175:22: warning: format '%lu' expects argument of type
>> 'long unsigned int', but argument 3 has type 'int64_t'
>> {aka 'long long int'} [-Wformat=]
>>     fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
>>                      ~~^
>>                      %llu
>>
>> `int64_t` is the alias for `long long int`. '%lld' is more suitable.
> 
> That's on 32bit machines, I think what you need to use is PRId64.
> Or just cast the result / change variable types to long long.

But it should be '%ld' instead of '%lu', right?

Zhengkui

