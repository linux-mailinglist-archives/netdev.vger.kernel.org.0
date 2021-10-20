Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7D8434B00
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhJTMR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:17:29 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:59201
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230265AbhJTMR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 08:17:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Toj0NWuSoEVaqp2OOyYqh8fns+vXhAqhsVreQeVViZWaSi93ErGPfiBEpFqclq2zZoZgd1WKLQIkpkaQUUbbqs2qG683LQEoGHNnXuNu0Zu/w16dzh26d4Euv0Yfw05qJdXVhz4BINT39YToFjz22MxoUj2gxb+aPmWaJS0vd/MKP71xCygJVtsDCi2biXnFZ4m97SZyETISUSORzZhfXbFQb4FV7tVqvHKwU+ZG5E2wWsYYNfsE7LIP9F4yi8NumTVAflWp1FsEweXhFY2bKnrCPUimxjZkPd6uYr5mnfDfitUMB8Bz0dZohdXkoGAPDxd1xIhu655YPfwOC70YBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RihB78LHNG8yCF8rC7fVPzBAu2JZPGnQi2Ytje75HqM=;
 b=gkGLh1R5cq1sRgabfvtCSE0CyYeI/1NW+loCcPBB+lOTyajkRyeRqag8kllERGZJYsH7UvaCA7pOTO7UMMWO4bNXqYGRF+YjsnH5gkjeA5WWbqBqCL4zPSppPZEzGAnYLmQLRhMM2Mc+QpOVUMwgW/iJzTscvOVv8evi/oBTo6Bx8phdZWqoDL61PL+jKz19GyCne0UAs5U33fTzuAGhIUycHWnZo8zpqXFewh2HdlpXrypnbAU6FfDtrkKSpVU1VKJrVfD68QWtlEPrWOsEMyrW6ASWAaEuLdcfReecG7/zuCfkqdrKbDLnzhnh8lmR7e2MPTP1/p+DtHtlHt+NMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RihB78LHNG8yCF8rC7fVPzBAu2JZPGnQi2Ytje75HqM=;
 b=deTHw27Cd8GfnWXU2gqw/saUg6kRHuP/SxoqxYY8JhcrB2MK4iwLm6vtUWDAG9XctJ9qo5EhAvc6RM2ElLLBEmS9brjMEx1rldkMKDZymq/s8IxiL3TT0+3TMuEfMAJxaxLrT5ooeSKo7HfC6d2KTF5c9w7V3BlMGQ+J6+DvwhSqCyiZDpAyjjp0kj4WV86ZCBLYBLVqu/3jgvN7fejhPAwXzsd3hCkJzPOn3HInwQRjAWzty6BAAIgLrlAAlqYPrtLNFFWRd/OLybkvI+LcwAexQnF8BzUZvCVzEwJBazd0oLmOVL6zHvZjIUp4rcWmMWx2dJ3P0SKxLSigRYgHag==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5447.namprd12.prod.outlook.com (2603:10b6:8:36::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Wed, 20 Oct 2021 12:15:13 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 12:15:13 +0000
Message-ID: <bc778829-1fd3-f108-020b-85440e55f116@nvidia.com>
Date:   Wed, 20 Oct 2021 15:14:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCHv2 net] net: bridge: mcast: QRI must be less than QI
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org
References: <20211020023604.695416-1-liuhangbin@gmail.com>
 <20211020024016.695678-1-liuhangbin@gmail.com>
 <c041a184-92cb-0ebd-25e9-13bfc6413fc9@nvidia.com>
 <YW/tLekS17ZF9/w1@Laptop-X1> <YXAHHBYtFfXbd1hE@Laptop-X1>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YXAHHBYtFfXbd1hE@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0098.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.28] (213.179.129.39) by ZR0P278CA0098.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 12:15:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d7e96b6-fded-4ab7-c4d1-08d993c344c1
X-MS-TrafficTypeDiagnostic: DM8PR12MB5447:
X-Microsoft-Antispam-PRVS: <DM8PR12MB54472130B0DF87956D510EE7DFBE9@DM8PR12MB5447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgvUAcynlLm735wjbugjW02PAfV23eyNVm2puwdUIwFIWrWWTMwolSLsN0Sk8QJS4c0JhjxC3b9q8VYlEcPvsCLf/DJAvSfZduqAE6PADfjC+1/1058ZrNdJnHB448KwOzLPepObjQNc7sK4FP/J2aMV0rNaMvI9zmoGrBuj50VEGhy7C7nLDhkU7iwwgqkrJzxzPiSYx/M1J6XvbNYrJnjW12Gg+OGTQ1efh6NNVUeQkOxo2eBmCCcW7pouVSy0Jev36khlzQ/p6mvaORiqc3nBOtRoCNbvqArBY3PcD6F/25LUSwFhwggmpEaxGN8a9AToMNL6fI+mxqfV/apwyqbsqF4ys6Fktqj3E/iQuPa4nYqpwv2btp9JSNrBd+PPBiXeVVxn6wIcQkmb2DClNeHhKFUHFwqvdDaiLo6cC1A19MyOg6vVPt3rPSWFDYcN+l8OiUoqdOou7dVaWUz8YxDIs1qdETZxahCkCJ5Q439qluOedUAaETyvwnIEEAl/ZzRle3pRPGb+oJqX6gB747Po4YMPaYh3Oo5IKXBUqyfVhJMWbRX3G/rmlnOSy1ENupJurImuL8ncZFC5fCwUn2FrksiF1EBZGMS1/GuQQOmfzDra1CecrFyBxUQX6LDSOCPP8eJ+rtJRwxWjHwV29DA/DItONywdHc71ZXAvu5rUidWNK4fKW+e+v+V5mUUneOnWryx5eG35YE/inc2Wd6mXfSShEAYO/SEBsDRU6EU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(36756003)(26005)(53546011)(6916009)(86362001)(31696002)(16576012)(316002)(6486002)(4326008)(38100700002)(66946007)(66556008)(66476007)(6666004)(31686004)(508600001)(8936002)(8676002)(956004)(2616005)(83380400001)(186003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk5XZ3JOajlqUHhXNUNjQ0xqNEZTeWJOVjhiNVJhR3lLYWhzRFNsOFlXbHdV?=
 =?utf-8?B?ZThwSHhpb0JGVVlnbVNWeHFKZW1iaUdOd2JRTG5ZWHZCWWNpUGlXdG9XQk9W?=
 =?utf-8?B?NGwwbnZOMXR1S3ZKd3h6OTJ3ZER1cFV2VkRsTFlDMjdsMjRWenF4OU9hemcy?=
 =?utf-8?B?ZzhPTmwzeTNQOUpBYkhWUDI3Q1VyNW9sTUZHcWdaaHhxU0tycUkzbkY1aWs2?=
 =?utf-8?B?VjRQbFd4UHVFWmJhbVhFWFZ0R1dnbklkUTlTT0xBSlhJMm54eVJZMG5zUXNk?=
 =?utf-8?B?Si9KVjQwRUoxSCtVcDRqN21OTThpTVN0bGg0dGRNSEx0ZXB6RmZhQmVpczJj?=
 =?utf-8?B?eGJWZ08xOWJYcENOa1AzRzVHTmt3NVVKb2ZrVnV1VzNmaFBkdkRSN1hpcjZO?=
 =?utf-8?B?VkhBTTE3RkZXT3hnM0xrM291TmprdTlBaFlReWgwOWhDMFU1NndaYStUanZF?=
 =?utf-8?B?QzhwMFFmR2JVVTdIdzZ1VmVCN1lRQkppU3Z5SnpPU0xzaGwyYU9XZEMrU2wy?=
 =?utf-8?B?alBPTzBCOEVXaHNoMGVSaUdqWml4ODBGTmxpQ2U3QUJZeDE4d01xRzZpbDlZ?=
 =?utf-8?B?LzRwdzI3T28xbmtpcngvS1VYUE9CbnNIOXJGVHJZajNhTzFRUi8vQjBYbjcy?=
 =?utf-8?B?M1pVRElxeUVXeFcyQzZWeWZHVjNGOWhXY041VHJldEZNVnhaaTZYUDBBRy9r?=
 =?utf-8?B?U1IzbExwY0FZdks1Kzhhb2RqbnpGZ09zT3lDZEV2MThyZE9PQkRncXYwUnBE?=
 =?utf-8?B?amc5Vm5aNmJwOVIyMlJCaDZEWGZmeHhKbnpXSW41N0lpbmtpUmlmdnRFUTEv?=
 =?utf-8?B?VUlOZTNUaUJmMXNqWWlSemNOVjlSWHhjdDh1MGJJcTJEM21Nb0E4cVYxQkF5?=
 =?utf-8?B?UmtqQkNQeVg1ZllzaUFiWGliMDRXOEM2a3dDWFVQb1k3aGsyQ3BDNmM2UVdv?=
 =?utf-8?B?dHFlUG9uYUVpZlViNXN5ZHhwdm5IWUJLVmRDazJhZXd6emJIMTI0bGFhcTZs?=
 =?utf-8?B?RHdpREpsanpCZ2wrVCtacDRVTm1KN2hydWZSSnFNeWhFZzNrenFjdi9ZdFdI?=
 =?utf-8?B?M2Vxd1JxSVVDYzM3emJvRFNwVEoxM3o1RE1RZ2lVQkZHdXlsZ0EvUG9DallF?=
 =?utf-8?B?ZVpWeW02UFdGQlZ4cHNHamRhdWUxbmNsSlcwRDBFcFBCeUx1RXZhMjV2R2ZL?=
 =?utf-8?B?QStkZFhoaDdsaS9veVU5SjRpRUpmWXJRUWtBVjV1a1MvNTJ2NWdyZmkwdzZm?=
 =?utf-8?B?U21DdUJxcG9DQlF3ZXV2VUlQT2xDa2d0MllpK0pNZHZ1MTJlVms0dzczTjF0?=
 =?utf-8?B?Ymg3b2pwVytLRGhFT1lQSmhlYlJNeXFCMFNEL2ZxUk5wVmVhNDgvV2pVdjhv?=
 =?utf-8?B?VVQ5d3JHRzE2b2NkaGtOaldrSXdOdGk1TnZoY0RNVXNUd2h2bXZLeVRTR3hu?=
 =?utf-8?B?bnZqSjZXcE5VZlU5Y0J2TUNlcUljaDRSNXFPczV5RmF3aDhlZ3l4S1BNQU9p?=
 =?utf-8?B?NXBUcUhEaWgvVDRKRnZtNHArd1oxcnRCc2hKMUhXNVpZKy9jcU53MTRFMSsv?=
 =?utf-8?B?WWxmMC9wOXgxeDIxUGtMbmpXQWwzcDl5UC8zc2hNMXJORWtiaUw4VHZUQkIv?=
 =?utf-8?B?blpKWDkzWDlZaGZkd2d0bk9WOTZpUHF2dkl4d05YLytrMGxBMFkrbTZoR1Ey?=
 =?utf-8?B?V3pDUE4vV2Z3dFNqamdkbHJ0ZHc5UHRCRkV1VnBadFEyTUpyZzU0NXFYTXYr?=
 =?utf-8?B?SVptdHVGQ2NQeklaTjU1S0hJN3Y1dUFBZXBYWXlSN0oyWmRaZXpjSEJsNmJR?=
 =?utf-8?B?cVZJdk9pMjBOVTJhMzdYSVRpWGVkeWdpOTUxWlRub1BodWZnMFVLc0pVTVp1?=
 =?utf-8?B?WXdmRHlkYTR5blA5YVJWWXZPWEdIdnRWcHVybG9BWVAwSFVqYkdDN0JYYXB1?=
 =?utf-8?B?c1RoMDV4Tk1yekdOTnVzU3RlWXhocWE0aUVUSFhHUTJ2NC9QZzEzWk5KRS9x?=
 =?utf-8?B?dXRlb2l1b0NiOC9hS2tZNEpIVFVSdnhNbk9Qa2NsZ09OcGUvaGh0L3lxcFk2?=
 =?utf-8?B?ZTJaSVJtd3VWc0VUcVVNdjV1anJHZktMKzYweHA3UjhXdmxjaDFqcko3ZEZK?=
 =?utf-8?B?OURlV0tiWkR3NUVKTWJGUnJGOUxjUEJXaFEzN2RZN3hhVml1T2FaTCtveHFs?=
 =?utf-8?Q?YT8I3IFpQQrl6RhUbMwhqw4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7e96b6-fded-4ab7-c4d1-08d993c344c1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 12:15:13.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUNZU78aarZD+9NL5ZuyhQhS+XprYREhkrR6tUt032q8pWWxZSn5jRxKZsfrD4tAcq+x6TS9WbL18QIiGTE7iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5447
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/10/2021 15:10, Hangbin Liu wrote:
> On Wed, Oct 20, 2021 at 06:19:25PM +0800, Hangbin Liu wrote:
>> On Wed, Oct 20, 2021 at 12:49:17PM +0300, Nikolay Aleksandrov wrote:
>>> Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
>>>
>>> I think we just discussed this a day ago? It is the same problem -
>>> while we all agree the values should follow the RFC, users have had
>>> the option to set any values forever (even non-RFC compliant ones).
>>> This change risks breaking user-space.
>>
>> OK, I misunderstood your reply in last mail. I thought you only object to
>> disabling no meaning values(e.g. set timer to 0, which not is forbid by the
>> RFC). I don't know you also reject to follow a *MUST* rule defined in the RFC.
> 
> I know you denied the patch due to user-space compatibility. Forgive me
> if my last reply sound a little aggressive.
> 
> Thanks
> Hangbin
> 

No worries. :) I obviously agree that it should be RFC compliant, but we must do it
in a different way that doesn't risk breaking users, it goes also for how the values are
computed. In the future when more of the RFC is implemented we might need to force
compliance and that might require adding a new option, I guess we'll see when we get there.

Cheers,
 Nik

