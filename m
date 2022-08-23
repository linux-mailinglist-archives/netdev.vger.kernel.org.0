Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045E159E3EC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbiHWMm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 08:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiHWMlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 08:41:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826839E2CF;
        Tue, 23 Aug 2022 02:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk3wVCQF7XkEWjtmaTD6i4bTAfQVERgtBW/9+I7ss4F3a+PvPGEgYNsoaYWuv57NmK4wAV4ggSOq1M6dUOF+9+eSQsYE8GQznX+kkQIotUUKSOPHJR5HIsJtJF9TyBkWWXMYA6z1T+Oh6qv9TYLnCQHJVSAGRJ2SuOgjECSjMzo4C7HrrjRpGr4kcjjcG+E+Ivqp+qd3BarlDKma7Gt57GKLPZnfQ/ObhvsVBQoyrxljMbpO16Oo5kixj5Wvixge4LcpuLtRG67FO1maxYtuVqYnM3VWTqfYERbE3DgHYQsLwgbWhw1AkkS+Up8uBiEbCBOTM3v9IbzoL+EDAN8RbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvC5oy8u9XljxPECQ+8Ds2040Wwvq2MQhl/R6ed/Xn4=;
 b=NophFi2QYFzLCbJ3eesmXV6jEZ6FgkvcLEmxJHnucpzGWtMZNb+nmAOwxeTG1E1j+g75QYxoB5dN5PP5ghFtGQK9Ns8mkL68rnG7BCNB/dp/VsVanUbU71kksEEybF4N06d6S7hsOQRcVWl5/8obvAC8jh7im5Dsf1ew8LbFXt2pu7vFGwEk1AaT2wZ+l2h/auEgPPazfNxXOAHxYNjozMafW57/lLEH4JD+REmm2i0uYQivnnQF/HNu4G2E0T9nqcnlCcRwTXQ8avbRVQ+oSutW4AkhNeJ5yQL5ES2TOG9Uha9mL6xvup+NuVhQ94nFN+G/KBszec7bzqT8uWwUlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvC5oy8u9XljxPECQ+8Ds2040Wwvq2MQhl/R6ed/Xn4=;
 b=sa++8eJ6m7jlVFd9w/nkCQqj6jjElHwr5Nt0TA9u1KF24A+AL7qE2A1KGMWRHxS8i4ROlotx+NYQik0fz1yT86wyW1AQN2qZxJzdYZAqGMVzwXI2YxLfun4OZ324uqnHfcxkXSelUPRmAKG9jvm4NK9bdQYsTMCvHhc3xZVXNkJwzeNEe9BQ4hbFporTSB2cST6kMyFJiQJA7lT0BqIfKuxch+LUKl15FCnaPnRJCMe3lyavVYOTKQhHZIazGN9MhmeUaJvbF48hcdibUiO713j4sKezbM6z4K6FY572ofml0Q4yYgf8tdkVZkfBrLPVkPqVJB7njfzu2Yga1xDoxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Tue, 23 Aug
 2022 09:49:10 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365%5]) with mapi id 15.20.5546.016; Tue, 23 Aug 2022
 09:49:10 +0000
Message-ID: <aaa31105-6b1a-c026-ab26-00b6b99094b1@nvidia.com>
Date:   Tue, 23 Aug 2022 12:49:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/1] netfilter: flowtable: Fix use after free after
 freeing flow table
Content-Language: en-US
From:   Paul Blakey <paulb@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        netfilter-devel@vger.kernel.org
References: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
 <Yv7FauVMX2Smkiqb@salvia> <11b87f33-98fb-e49a-5f63-491d4f27e908@nvidia.com>
 <YwPw1ZqiiuGdCGeB@salvia> <379a510a-310d-7479-6751-995c6c05ff7e@nvidia.com>
In-Reply-To: <379a510a-310d-7479-6751-995c6c05ff7e@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ab30852-ce0c-49c6-b68b-08da84ecbaa8
X-MS-TrafficTypeDiagnostic: SA0PR12MB7003:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHOG7Lx+WX8eCNXyfpgGPLnOQI2pQ2i63yiMZkI1S2VhICQqJTIcQCkRo5ySG8F6zyBWKMnIMw4qhipfh3M+QubIDuNHjh1164OK5kgKcl0cNaAwszs4H/oOYF/3l6FNg+IMlnX65oOIUxXTlgVlh5UcA34zG6c3Fvki/Yp30BXcDwa94GohKf+1zxk42U7ptpe6pKy30FPXVlGnZ/v44XcwmEA+b+aBllwIza6oaQucifsYYhJQuwVa+r09fC6Pk+gQMaZ66Moz0HqYkLZihm6qxiWrvb6kvYozZWVEzGZmtxJJLoGVBJ3Lz5GG3PPyX6bkAR1Gi4QdzsjPl9KCWV5tw+BwABl5r4H4QHLlq444m07bf9YF+RIj5ajz2j6/JKXbP4rhpeAjFsbSzvYVvD3OojZLYQLth44OOyOrKvwS2S/1ZWqgOo4yUt0RMozpFnYR0qKsZL/6pv0pPVjSIoTmrl/U5SV6u/E4ECtHYtyAJcc4xrmCp9d5dZ0+WzR5tGSsQBQd/xRAEpsXWnyI9iuCiGLZ92pJJylLA2YL+rT8jOIKEwHltZOhCnOKp5foFupAi11FB8OAY0RIFEbkzQtkgSmZW2MAjoe+Tch/Wlv3/nkeL6ntF75QCe8xCoyhdERyUOkARBNVp7GzHna69oLuQgQ+aBsbvN+0/iZ5hvSqfaJPqljBV3aGozfWLA3ng57y8VD2XOkcPG2LlJbWsabib2nY/IB2x3wyp3W0UjzmTpmSRyVoQ9LdXBXGbXr4bYROf6pnWrEmX5pw61aZL/eSqlRAa0MEmUnN+st/W34=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(6666004)(6506007)(6486002)(41300700001)(478600001)(186003)(26005)(6512007)(2616005)(2906002)(53546011)(8936002)(5660300002)(316002)(6916009)(54906003)(66556008)(4326008)(8676002)(66946007)(86362001)(38100700002)(31686004)(31696002)(36756003)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHo1SndKKzFRQUFEMUJzMm9jdFV6NlRKT1Y4QURoN3BRYWhpUTFkL1pDQnRx?=
 =?utf-8?B?WEwxQ1N3SnRkd0ZqMWZTUTRpbzJhaHhUZVZPTjJYSm51ZURIajdKMkFFdjUw?=
 =?utf-8?B?cjNERnBpRHdSclFqNnJ3VFhrMkEzUHhvQ253SWpTM21rWUZmOEFoRmZub1BO?=
 =?utf-8?B?RjhIT0luNGZGd1ZYRkFZVlpoWW1TM2pIalBPeC9WQXdUUkkzdlFPL2dkOExJ?=
 =?utf-8?B?MTFZaTRXWGx0Q0sxUVpwMmhpVm9hQmR6cm9nQnZNT3dtQmsrQVNSOXp6enZ0?=
 =?utf-8?B?UnVNbDBpeVhMbllENURQeFhhekk5ZjJBYkRRTzBEbnhYc1FlRjQxNjdqQW94?=
 =?utf-8?B?WVF0SEFlTTA1c3IrR2h2R2p5alJ5L1RWZDJkMzk2MWxGbFNTK2kzdExuRENv?=
 =?utf-8?B?Qm1HME5TbnJwWHBKOFpiZHl5aVczVVVsMUJ2bk1jQzE0UXp3eWk5Q2Jnbmt4?=
 =?utf-8?B?TGdIYU1WR2pwMlNDYjF3OUFIYVd2M1FsSnhJL2dhdFZObUFKWnA1dE5zU0Vm?=
 =?utf-8?B?QkF1V1JFaHV5VE94VEdlYkpmU3NwSXQyQWNMYWczQU5zeVdUMFZNa3crZzdh?=
 =?utf-8?B?Uzl2Vm1jUm5NRm9od0I3cEFIRWJCRGpEK0VhcWR0WklJcWc2Q25wcUJubmxN?=
 =?utf-8?B?UlliK1lVRmFLaEFUYmw4WGIvYVUzaFdoMHdtWnFJMTA4b1VkV1BOM2N6WUc4?=
 =?utf-8?B?R01iSlo4S1UvQVN5aWdwZlJlRkt4Zlk2MTlQVnRxMG1yWWhnUDNnOCtaYTlj?=
 =?utf-8?B?cWdUTW9FUHJXTy9iM0ZhV2k1ZUw0U2NNQko3K3UvUm9KdmFIUlBCdjJHWjJV?=
 =?utf-8?B?YWFBYVpJNDFwSmFLU1ZHdTBjdmdBWk5MRzBNZ3djTmpHWTZwaWtOa2RUMUIx?=
 =?utf-8?B?b2I2Q09qTHR0LzNYZVFlbXdiV0gySXBrWXUwU2tvZ3lTOXk1enpkOFZSSTdx?=
 =?utf-8?B?MmhXY1k1bWpDOTRYaVZWVnYwd2QrQkxQVlM3TTdZV0F5Y3A3U2hXMStDVkdY?=
 =?utf-8?B?enlzdGJyOWNpaUpnNzdRWGhLSWRHNi9xSkVwRFJuZHlsckkzU1lJUWhUYUpx?=
 =?utf-8?B?RzR0ai92RUlaUFp2RUxYdHlDUENzSEZYeHBzNmF1YW4xc3k3Vnl6UnNhTmJz?=
 =?utf-8?B?eXptM1BhR3JudEtySTVFTnRrWnZFMXFBNkxCNG1MT2F5Slo4U09BWjE4ZWZL?=
 =?utf-8?B?ZWUva09GN0wwbHVYcW9ZZndCdVhkNTU2eDlUUmtIRlRFQVhtNndjYmN0eEx5?=
 =?utf-8?B?b2V6TUttSXhqRlpGc3JSSlJFeENGR1VvL2RwazhXeGJzSG0rVk50VUl4Tk5i?=
 =?utf-8?B?eW1ORTQ2aldmY2hBMTFMdHM3UnQzZzc2QkhDNnZ4OUNaQ2p4QXY0WFBrUHNa?=
 =?utf-8?B?MUM4dEZGMVk5by9oaDhXS0hod3hEdmprdlRxVTVPK3BJL2Q5WlMxK204TlIy?=
 =?utf-8?B?clVWWnh4d29EcHhrdVlHWDFHeWdEUXNSVjREL0tiKzRiYVA1SW1BY0E5aWJR?=
 =?utf-8?B?eHIrZHhZRjJsRHpkM2hXV2FaaUNyZjg0SzlyNkRodmVtSllqem8xZkRzbk8y?=
 =?utf-8?B?SjRwVVhBekZOSVorUXN6Q2RiY0ljKzlOYkhZVDYwUHk5TEhGRnZRcHZabFYy?=
 =?utf-8?B?M0hKRFR3dDU1dEVIZWdkcXIrQW9BNytFNVZLb0FXRVFlenFVTTYvTzVzWTg4?=
 =?utf-8?B?QmFrdFA5YXF3UUQvU3M1QWsrcUxqT0NpQjNkSDJoaWF3QnR3Tmh4Nys3ZFRR?=
 =?utf-8?B?SjNjb01pcVphN2N3VHNBZlNYME1nTUkwVlU2S0NNV1VaS2hqQTdOK0FOVFdI?=
 =?utf-8?B?NVhKallnNjVqYlI0eGpoRTA0RTg5ZThsbEVHaG5LeUZ2bWRaVzl5UWlnd1NZ?=
 =?utf-8?B?Q3F3VXRpUmo3NFVLT0d6VXJmTzQ5OGFqVVFsRWE5ODU1MWhyTFd3WDd6Y2VD?=
 =?utf-8?B?cEx5RmsyWWlXNStucy94RisrKzluajBmaFVSUWUwcjRzUGFta2UyVmxuQWM5?=
 =?utf-8?B?cjV1OEhwRm9VWHBIMGdFaENXNjFNY3RiYkRkZ2lCak9XeW1nblNxU09KNXpk?=
 =?utf-8?B?S1dzdXBSWmNoVERQd0FCNmpBVUdyc0YyUlBlWVl5NTYzSTBVSXpLY3U0Q2d5?=
 =?utf-8?Q?mrH3J9NIeXJq9kbFe7X74OYKm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab30852-ce0c-49c6-b68b-08da84ecbaa8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 09:49:10.7926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnLPKNl50sJqZX/aMREsVAK0n+V48lbjvlvzcjSjxGT79hGfOsek9nEDrO9AEJaa7h3Jjrt6tmIN+xIEWCvEoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7003
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/08/2022 10:56, Paul Blakey wrote:
> 
> 
> On 23/08/2022 00:10, Pablo Neira Ayuso wrote:
>> Hi Paul,
>>
>> On Sun, Aug 21, 2022 at 12:23:39PM +0300, Paul Blakey wrote:
>>> Hi!
>>>
>>> The only functional difference here (for HW table) is your patches call
>>> flush just for the del workqueue instead of del/stats/add, right?
>>>
>>> Because in the end you do:
>>> cancel_delayed_work_sync(&flow_table->gc_work);
>>> nf_flow_table_offload_flush(flow_table);
>>> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>>> nf_flow_table_gc_run(flow_table);
>>> nf_flow_table_offload_flush_cleanup(flow_table);
>>>
>>>
>>> resulting in the following sequence (after expending flush_cleanup()):
>>>
>>> cancel_delayed_work_sync(&flow_table->gc_work);
>>> nf_flow_table_offload_flush(flow_table);
>>> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>>> nf_flow_table_gc_run(flow_table);
>>> flush_workqueue(nf_flow_offload_del_wq);
>>> nf_flow_table_gc_run(flowtable);
>>>
>>>
>>> Where as my (and Volodymyr's) patch does:
>>>
>>> cancel_delayed_work_sync(&flow_table->gc_work);
>>> nf_flow_table_offload_flush(flow_table);
>>> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>>> nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
>>> nf_flow_table_offload_flush(flow_table);
>>> nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
>>>
>>>
>>> so almost identical, I don't see "extra reiterative calls to flush" 
>>> here,
>>> but I'm fine with just your patch as it's more efficient, can we take 
>>> yours
>>> to both gits?
>>
>> Yes, I'll submit them. I'll re-use your patch description.
>>
>> Maybe I get a Tested-by: tag from you?
>>
>> Thanks!
> 
> Sure I'll test and post.
> Thanks.

Tested-By: Paul Blakey <paulb@nvidia.com>

Works, thanks.




