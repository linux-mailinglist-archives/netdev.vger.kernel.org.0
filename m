Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24835F869A
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiJHS2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiJHS2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:28:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D12037F95
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 11:28:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcayVppkgtvq0GoEpykFe7ah1QEt9h9QV/ED1BoAVjPpAln6i5qnOPdi81P869q7XHiAKwjFy527gipmgFzWhZBd2ZWIqiHEwbIqKZcHx1WGs2qHGWgXvpTJlDpgQyZqzD9tYBKviZkeojFvWrDcuqhUVzSfKRHhvD90exv7L9HzdEf6Aa3sj/si8WQLuxb92upl57+FxdM6s7DAnAHxJXUYG5v0Ur35Ro6vuiYE+idQj4yHr6t/srejmQMqCFmR3LZ0QDM1ZirDrQSNsSWSa3xovwSgYi5rcJKxPvAbgsDv8ny2bqh3cdS5GwG9TXiKHqv68Dov/hA6ZbZEBLDalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPUDm/Z8hGTale2KdzuShjqK5WY9YN0ccTeU4C2WKvI=;
 b=K1KpGn+1ER6jvT2FY1irDu6kvCEOuqfD+mjRn1uJ3SipxY1p+cNUBMLmPUNUtDaN/6NSamx8salWmmHTpWZi2sOFFIAqyw1Tx5n4bo1xfY46DxAvkrJ8gsASTFh3RuSQO9H+jy2Nb8sO3wQAjhfRhNAfzvuniOZxA3Gxtf+t8JWgTmx9YmXzASQTmIevw5mhsZr6O/8j5EEJs1Q/+9VYuDpNfTVUJv40ppKzM5airQ+GADJghZDYd1uJtpA+vimR453C/mSxPhaHiBYnZlC7RIJBKQBevdcICnhHaKHoFdKxc1V2HqCGUSJANFI62JU90n1SBpbzhCihJgI+pULLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPUDm/Z8hGTale2KdzuShjqK5WY9YN0ccTeU4C2WKvI=;
 b=KiDVt1B1hYICcJlQKOrM3qClrlWuhSIHVant4leGLAtv4G/yI8XBGKjZ0Fv4GWpd6DQoKGYwk6yRpvjIN5IL2YBf1TXReZ646Zk05Odys9P+opmn/5twnQl+n6S+U/oUDJ4lzM5FAFaTA5Lb6Me2InR3EhdwzcWWgoO8rvblSA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by CY5PR12MB6600.namprd12.prod.outlook.com (2603:10b6:930:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Sat, 8 Oct
 2022 18:27:59 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::2841:da55:ff5b:30cb]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::2841:da55:ff5b:30cb%6]) with mapi id 15.20.5676.040; Sat, 8 Oct 2022
 18:27:59 +0000
Message-ID: <2331b6db-ad19-16b7-6ceb-209b6121808b@amd.com>
Date:   Sat, 8 Oct 2022 23:57:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net 1/3] amd-xgbe: Yellow carp devices do not need rrc
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Shyam-sundar.S-k@amd.com, davem@davemloft.net,
        netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-2-Raju.Rangoju@amd.com>
 <7a1b3750-1b3d-a9b9-ebba-3258c90fff7e@amd.com>
 <20221006172654.45372b3b@kernel.org>
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <20221006172654.45372b3b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0160.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::15) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|CY5PR12MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: a4879b8f-2a50-4d7a-f3b2-08daa95ad381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDyMPGp8pXnpk7Y9hTR+9xV91EVKbNL24xwnAxBt4BJBQ/A7pVDysKYAL7qDGFhpH1bzCNp8kGWl5/wpSMI4148FfhoFIsHet2WSHVovjDGAznfBNPv8MsUCWwaX9lNpp8ZFojCGgs6Gq3iT65Cvnxd6Vafxc9xowAA4wA9xTRSSp6FtSNyzje4pPwCxzD+eCJOnYvTG66al5jaLG+BuqQ8EhwT/cLh11CzpF1lVFM3YqNMmTy5rVj3/odTfUHKlKLPMIDW1zg7mIh0mKPvtfKI0N8SApy2uufdsRcLJfTVO2+AfhArtLDc0pdQLU6TQPWp0o/r5Wi+ImTrJVrnJ3XCmubpHqrC3K53CHOeVQrGk6fY71L+EC7H5gOxVe8C1yKwXLR5wUgEcgkmrWiJuRJAkkBfkKwmhRN3+kt6I6ZcdXtF9z1sbALCx4jXCkk0vhCQjzVnIOhT+UWlOa/WhyCC9MM4ESbMgDFKZpLh24v9Y8NIuoKVvBYE2bZRvdKcAatSrk12HIXlNtQNibf4uw/5n77W0qOQKuzQICcQWSz0szakuyOHiT88NqbE2W+YkikevBpbaCfs2Hv+kAjVSdPJ/CIbh6+lhiRChT48yHjb0HNJDmD6QyASPohR+0QgEi16es3Sc7CkN5nx8mDoCp8bcj43oKOX4L0Yxk8BhvOyJMjPc9i1CPwC8Pf+G0fkKZXWXjFBf1Rm0O5+GhaRst/o00w1PBJfPbfOrbVRTZ2/CEdjI1jyvCw8UmvoQwB1MJqCQqbzEq2+0KOnObP3YHT/XoNb912D+jdWirzRBjyk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(83380400001)(316002)(6666004)(26005)(6512007)(6506007)(186003)(53546011)(110136005)(478600001)(6486002)(38100700002)(6636002)(2616005)(66556008)(8676002)(66946007)(4326008)(66476007)(41300700001)(8936002)(5660300002)(2906002)(31686004)(86362001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVpKZjZGVi9oWUR5RWhtVjlvMEk4b1ViaXVUeHpKSGxlRUo3dFJ0RVozUFYv?=
 =?utf-8?B?cWZBMHNEcTNhV2xxeW9iUkRQNGFvSDVMVnJtNS9Wc0ZNQnJCOHJiWU8vWHlR?=
 =?utf-8?B?YXZCQ2QrOHNuY2x6VHBjMWJSbzJWU3Bka08yYXJRbXdSWGpkMkFRYmV2US9D?=
 =?utf-8?B?eGp5T3pVL3pIQ0JrVEN0eERpMzdtR3ZZNDM5eW1DVXl2WFg3amVaWCtzS3Jm?=
 =?utf-8?B?aERaUlhuaDZxdTVBVm10bEtwTnhxQVpFdG9jMFM2MWhxUFkxZXFMT0NOdEJ5?=
 =?utf-8?B?L09Wc2FGeVBtRE1kbHlnTXRqWXB1ait1cTdVbmc1eUpabDk3VDJzYjJlT0xk?=
 =?utf-8?B?QlI1UTRHcjVoaDlWR0ZUQWxyY1dBeFZnWUczZkhxOFhYM3pQTE05MytLMXlI?=
 =?utf-8?B?di9JTCtXK3FpRSs2T0VqZXV4RDJKZms4TU1iZ1JTK3pZR2o5ZWJ0bmRuQndQ?=
 =?utf-8?B?QWxjS1poa0FLeW11ZUEvaTVVSDFTSmJEV29mYllmZUN2NE5uTlNDNGl4SXg1?=
 =?utf-8?B?bWkrcUxYS2lpOHRZZ3IrUWl2WE15eGMxMHVxRXNDckZyckcyUWxYdWRHcnFT?=
 =?utf-8?B?ZWpwNy9FSlFqaEZneWpCU1ZySmlxV3RtSHp5Z3d6S1JhUUl5Tk1YNkdFaGE2?=
 =?utf-8?B?WkJlSmV5dkl0UytZSDMwMzFxUU5nbUh4cUtiZFJQWXEva1JDWkdIRXhWQ2N5?=
 =?utf-8?B?Q0JCOWx3SnNqYWZrSE9veVhHOER0My9NcXVtSnhQVmpoMm9BQVJucVR1WHRE?=
 =?utf-8?B?QUNQSi84dElUWmh0dkFITTBzN1cyVW85ZnFUN3pCaXpHa2lZWFNldnRiUEt6?=
 =?utf-8?B?ZGgzNEJoOFg1Tzd4K0QzQ1RqcDcxVjloSG1VdWxSWDJicFpIK1dsYTZlQVI1?=
 =?utf-8?B?d1c3MVFwaVVqZEdvZ0lDbHQ0SWUwQ3lIYmtqUjVJVXBKOTlnWkp0cmdlYytj?=
 =?utf-8?B?SSsvU2gzT0hTT2NrV1dmR2orb3pyV1huWkgxb2l5alA2OFFXMlNyZnlJUXlU?=
 =?utf-8?B?aVhCTnpXbGU1TEZvK0NMYkZOREs4UFBxNWRkc0FQM1ZkcG5DWHNmenhqZmNz?=
 =?utf-8?B?bHVTRHZtdy9TR3F0a0JzRVNnL2YzdTd5R1lQZnlHUEVKZnBkcjl2RjZ4UDVE?=
 =?utf-8?B?dlhKYzRhZTN2V0hwbHZZWUpxZ01rd1VQV3J5RXAwc1I1QTNmMDJIRE9XOXg0?=
 =?utf-8?B?Mm5uNlFiaDBsV2J3RlA4NFd6eVlUdm9ZWXhyZlJZS0hCdzNJVDJNYkFBVENG?=
 =?utf-8?B?M2lUbUhvbmZOZzhRc0pIRjhtWDdNc2NqZ0hkYjBJaFVXa3dlMUU4M3dPQXdi?=
 =?utf-8?B?cjdIdFVrM2xXNGVGUFBnSGRLQWZrb0RhR3FIVVZUbjNsY1pvK3FDc2VyL0w4?=
 =?utf-8?B?ZDV4bEUreCtldFpELzY2VktmY2xSQ2c4UUdLSVc0R3l6OExGcURsTmQ3VGt2?=
 =?utf-8?B?SEFWdklUSWJKeGJtWVp6WjU5T3I5akgzQ1pTODhtUjNtUHhKSDB1cHRscE1R?=
 =?utf-8?B?YkFBTWppZU9sUmZRSHFoY0NDRFRycGE2ZVZLUDdROTkrVTQ2NW53OWFnWGZY?=
 =?utf-8?B?MVhmVFkxK2VHaU82b0VOYjlTckxKMVNSVEtWY3gzWU1BN1BEeVpGQTRwa2k5?=
 =?utf-8?B?c2l5SlVKWEd2c09uTUYxNUV5L3kyd25pYVZOV2xBQXVZQThyYTNPL2JOZG1U?=
 =?utf-8?B?NnpwMkJROUMzQi9LNkQ2aEx1dmlFS0IwUmllazdMK2ExWTBPaEQwYlFPazB5?=
 =?utf-8?B?NkRpdnh3TlZ1dThTN3dqYithNHZUOGxSNFIwQTV6QSt3cWRQTnNXdTNBRWNY?=
 =?utf-8?B?L2Q3UGlWZTg3ZmFrd3ZMWU40Nk1QditMSEo1YVFJOExHemVMQVJaWXVWYjBM?=
 =?utf-8?B?d2M3NE8vdHVDOHNWSUowMHJYNFJhS1NURTJTcGFvMDVHcTNGamFKdXZKdHpw?=
 =?utf-8?B?c1EwazBTdG53bUwreDl3cDViOHllTnowV0YrTlRtTWUzVU1Wc29GOFc2ZUZt?=
 =?utf-8?B?bHRoYVF0M2M1VmlrR2tDbzA4ZGFXVHhQTHA3MzBJakFPWFpkVkx6ZS9MYUlh?=
 =?utf-8?B?b2FuTk1iSU1zTTN5WVZVdEFjaldiYXE2MTJxWldORytRYjNBS1dCdDNvT3dK?=
 =?utf-8?Q?tfptysAio3tCicQwEEBbFDCMu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4879b8f-2a50-4d7a-f3b2-08daa95ad381
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:27:59.0734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73VFhhBLdzr9izxBK+LzqwHVMmn8NVxxwQo/GZu2B/hTtUZ6+8GcPRGIygMrjBQZlG9EpqToLl3M5dEoPeDV5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6600
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/2022 5:56 AM, Jakub Kicinski wrote:
> On Thu, 6 Oct 2022 09:32:34 -0500 Tom Lendacky wrote:
>> On 10/6/22 08:54, Raju Rangoju wrote:
>>> Yellow carp devices disables the CDR workaround path,
>>> receiver reset cycle is not needed in such cases.
>>> Hence, avoid issuing rrc on Yellow carp platforms.
> 
> Not entirely clear why this is a Fix, TBH.
> 
> What harm comes from doing the reset? You need to describe
> the user-observable harm if the patch is a fix.

Link stability issues are noticed if RRC is issued on Yellow carp 
platforms. Since the CDR workaround is disabled on these platforms, the 
Receiver Reset Cycle is not needed.

> 
>>> Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
>>
>> That is the wrong Fixes: tag. Yellow Carp support was added with commit
>>
>> dbb6c58b5a61 ("net: amd-xgbe: Add Support for Yellow Carp Ethernet device")
>>
>> However, the changes to allow updating the version data were made with
>>
>> 6f60ecf233f9 ("net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices")
>>
>> so that is the tag most likely needed should you want this to be able to
>> go to stable.
> 
> FWIW the Fixes tag should point to the commit where the bug is
> introduced, not where the patch will apply. The automation will
> figure out where it applies.
> 
>> With a change to the Fixes: tag:
>>
>> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> These devices are only present on SoCs? Changing global data during
> probe looks odd.
> 
