Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E49644BB8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiLFS2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiLFS21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:28:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596224B74D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:23:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbcAVjcvDu5shZQaEiDf3NKD12eRDEErNdyOZxlYFBzPlsJb42G89WAgRlQU3c+5H1Uh9fPJ0unZLq5slDZGDcMbQPhON7tAc3nG6uVx4b4sFeWHxJjopegumaU9TvZqYOnq7vId2SBXltJvaqS5CmvuxwqDD1SI2MO/ZWKnifES7bhMTWf/Zd1ZpAO5/ZnxYSbzhGV6W7FyGmF5PsTrSZw7mwYv++O9T2d4mtirY6eIR/FhSD9tfW6i9AvS4hpRLBfSEDBoOXorrbRlt5kpAoypwrQ1TKAfvPCFNbsLSVH/+FSvik8wt16VAymwObpYK4V182qvylBwaFGIyHeJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K6T02OBqWWMkgSEJaT7yP+lvZy6uGYE+qOjePlAo1M=;
 b=QIkm9rtFFqFQnyJirK86sB36VB3U/cN/KF5RS5A3g166QjCuO+wDZVGqjFz3W4yj8fyQrxFEDgrLWH62bxKDJlVwj38s/BznmQA6rE3sYnfialMcK8slPmQRsiCsvn/jnhhSN+nJYZQozpUflN8MnjInDPKMiqUAIllAjRJ5rgvnugNpuf8E8lw9VWZsnl0sfttB9og9bD1Ok1C/WdQllGLY2KkFK7+d7UAj0yV7vzsnxsyS9CNPtshW2JCEkLRmldR4S+dR8uGihig+Uiu9y9i3dDIowrbHSDGNUmTXq2SX1pWQwUFZoet0ZKwavGD6URbrx4LOnqZikF3vCUnhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K6T02OBqWWMkgSEJaT7yP+lvZy6uGYE+qOjePlAo1M=;
 b=NAdO6JzbrfLM/EIMbSlQ9HxJ3OIHimK05kHdt7n1cl6EGaA8tJRdvXFUTtP7oC7Dr2vFFCqLXKxkmrG+9JmiDVHyvRexI57x/BCHvxby3rtGqMwQbpxXz6wGdHSAsYFg9M2xwETYQMuz42rkdFgWNr6brrV6B0FNziHjW9MXh5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 18:21:26 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 18:21:26 +0000
Message-ID: <b916302e-8654-2e00-0618-0a2cb8fc757c@amd.com>
Date:   Tue, 6 Dec 2022 10:21:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 0/2] devlink: add params FW_BANK and
 ENABLE_MIGRATION
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <Y48EwzdfkwWsw7/q@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y48EwzdfkwWsw7/q@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0038.prod.exchangelabs.com (2603:10b6:a03:94::15)
 To DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: e72fb0e4-b4e6-4cb2-7345-08dad7b6b013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrp79IZyZ8Sviwm9aYfPBcyxFov1Ior7sV2gw6nX7eONhu+QCZXDxt6kJLsMVDD2LumeV4bP8H7/IhxVMCKfhfO/rf3GwcD8QlrgaYRaNwADeki9fgDYFR9N6D94V9Xv2aRrycW6ENUPHQleR5JeuLc+JE1HO8mxgmgKEljH/kBveBw0pfhHtoleJL8VK3uDz4gTWgpBu2qj/xTgdlKP05HMSgFvvFYuj9+2kALjjU+qQW7nhupNJgQQoTBtpEo/CMtm/3exuZdAfJPl+dUWAWjojtZRsmos/KurtNP+d48lpQxkgU1Y5GWO1ckEKlIM8/7nR876jYlLpMlhUDd9gxiA1lVNsjSNQOMuR9LgWIkYekyha13G37DiXtN+L79t/gz31Bcv8/MCIWChyi9jHsGlC0l3Kb/vvLkfRDUtKczg9u14lAgFHWG+v3RdWSInmpA1gf7YMjoPy9ioKPFakrHENHaeVlDhyfRbqkm8L5N7e7lujajGoDc8xQKJHRGeq7iqT7sp53oJ/Pmy/YII9blZyU2ehZIVx2FvP11uWBHMbQl+Qh25nBYNLtZrK67exrKYVyAIVML7QO9JiyyzdXstEfG+YROHquju3rRUX1H+rrszK6QENrwlMKn3A6/Nr2I623HC1/HwWtxCVcrvGjxRbSnvdEe4MQAOmJt7oWmTV5IvPAiUgVA0/ANvziacfIKsHoSzj6WmzfdN8794sfuz1aWtsfnFpNFaaS0op0bQWmgZ8VvRIr6YIGNd3QUm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(31686004)(4744005)(2906002)(44832011)(5660300002)(186003)(83380400001)(2616005)(8936002)(86362001)(41300700001)(31696002)(4326008)(8676002)(66556008)(66476007)(66946007)(26005)(6512007)(53546011)(6506007)(36756003)(316002)(6916009)(478600001)(38100700002)(6486002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE9IdE42N2d5OHN6NHJaUnVNQW9XT2N3dVRJQlUvdzU3MWFlRnJya2d0dEd5?=
 =?utf-8?B?SjcyUklqektvZy94OXYvc29DeXRjWVF5aXF0eDRIZjV2aU5UMXpKTysvMkZ4?=
 =?utf-8?B?OTVaMThsZU9CTUpMUnNtS0JlSUQxUGpneUFLQlpzMkhGZGJESGxvUWptK0x3?=
 =?utf-8?B?MjVibnFleU1QL3lxOWlHd280VTVsWTcrTVgzZlYxZWdWRHpyTkp6SzVScm1i?=
 =?utf-8?B?NnIvYW1LKzREWjVUS0YxNG96MXd6Y1FYRTFlWDZxRU5FdVF6L3RhV09keUly?=
 =?utf-8?B?OER0aUJFeGhnMXVMUTJWSzh4Q01EVDFNamg5U2xVWkdVNU10UHIwdmhQb0Nj?=
 =?utf-8?B?VDY3b1lhL0MwQ1d0Y0Jkck05WGlYV1BpN1hnRUh4elROeHdCeE9wZ0VUZFI5?=
 =?utf-8?B?Z0Z4eE9BQ0c5bm9RSjZyMzk1TUlHSjM2VHlmQm0wRVZYN3p0Y0ovOXdhc2lF?=
 =?utf-8?B?NzM2ZkNaRnVBaTdLRk1tRy9DZCtMNGlGK1lRUFpIMnFjdmJZeE9Dbnd3d2lw?=
 =?utf-8?B?VlBvVG1hRTkzOElJbmh4cnBUbndZRmVVYjZ0R043WE5jczUxK3AwTEpxZThi?=
 =?utf-8?B?UGhDK3ptVHd4aDRJVFFEU2RmTDhQTGcvdGM5VXJpcjE0S01kd25HUm9sRkpM?=
 =?utf-8?B?bExidEtKWEZJalBJSFB5clc1S0NEbjY5d2RvWWJxU3k3Q2pFY01aYlR1VGJ5?=
 =?utf-8?B?UVpOdGV5cWFVUU91RzVxOTczZk16anRxc25idWNEdGxVaTcwVHU4REtrZm1M?=
 =?utf-8?B?c0FtZUZXMDRRb3Q0NDhIRklHVW1JNGROem1veGE1eEpGa2sxS1d5YVVHMkUz?=
 =?utf-8?B?QWh4ZUxCYzZkVGVTSE9qbEI0N20xbnAzUUwrRGEzc2pMNlF2SEV0RmhoZHlI?=
 =?utf-8?B?U2pwT01HcjZLL3NHNGJYUi9HbzE5UzlidFg3dUkzQ0YzOXQyTzhPcmppaWNN?=
 =?utf-8?B?UWJRRm9CL0tSL3RveGkrQ204OFAydWNEeHAwd0Zjd0tFMGY3Uk84RjI5ODYr?=
 =?utf-8?B?dVdWVVVKRG14dGdSZjdSamFKcVV5RGhacnYwSnoyb25ReUYwU3dUQ04zMEo1?=
 =?utf-8?B?YU85ckluQ1FXMFhqOFQ4Z1g1SmhYV0VVeERBWm96dWRmazhock5MYnVRSzN5?=
 =?utf-8?B?ejdkaXFoeG1meHUrZnJ4V2FyZG4zdVlSODFPU210eTdvZHk0eXN1MnhQMVJM?=
 =?utf-8?B?RWNHcFg0QUErN0ZGbE1IMGJMeXlkdCtJNUd5dHpFSjNvRm5OSGVxc3ptLzZH?=
 =?utf-8?B?S2lRK2ljMFdkemoxMkFGMWJhWC95RW5IazdvZzVUdHdUN2xVSU9oMkY5ZGVx?=
 =?utf-8?B?ZWtocDA4L2REMzBaU0ZXWG41YkVmYmMrZExPUm52NlA4WjcwTTU1bDhVMFNa?=
 =?utf-8?B?YnNZSW1OM1Q4U21Oa3U2R1BiOUdITUQ5QzE3dDMzSmJtVkVNSHVLNGZhYnF4?=
 =?utf-8?B?aFBKd0dDT3c1dXg1MUpiNVpkSExNYzd2SGs5OHhkcjhaZTc4QmF0ZkVpSGt1?=
 =?utf-8?B?aGtCVTF2Rk56ZjdCNjloWW1VV29DWE9KdXdVelJzZ2QrdlVKMEphUDV3cFJn?=
 =?utf-8?B?ellwTjBDQ0Z3czNoYVpTNVh6V1lTMWdLUzM3NzZLU0QweTNLMWh1OUFmRmto?=
 =?utf-8?B?QVhFKzR4SW5YU0J4alJKa2FJL0xjY0w2WWNwMU5ITWluUmhuR0dNTkFmVWFr?=
 =?utf-8?B?Qm1DTXpLRHlTL05BUDBVVlp6QkpjMCtxT21LOElHN1U1OWthOUdrNHhvMW5U?=
 =?utf-8?B?elV6WjlNNEM0V0t0Y3ZUbXFDcVJmZTBTS2FlRTliT1pLQUUvWGxuWFZUQVJt?=
 =?utf-8?B?RmJFMWdjQUVzMTNSZW4rbHkraHFFb2ZFMUlRN0hRbkdDZGNtZ1Q5cjFGNnla?=
 =?utf-8?B?eTg4UUpFY0plekRaODBRdTNiRnRNVnFqdFkrR2xESFQyZkh4cUF5THJRWUNU?=
 =?utf-8?B?clREY0Q0SGVrSkxYZytSYTNPU25GSE5Ea1FjVTVrQ1IzYXc2bXltSnJFbTIx?=
 =?utf-8?B?c1VWQ0Q1OHhwUy96VitTVnFKMktYYjFRTFdNaGhGTWVLV3dYUW9EOURXYWR5?=
 =?utf-8?B?UWNpcXRPazhDVnpKajRFVDNNSDZ5MXZ3ZXRrSnB1UVRQY2NaUU5DV2ZuRGZ0?=
 =?utf-8?Q?0ITlbbQ9sJAJWJTfm+7VOXPJv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72fb0e4-b4e6-4cb2-7345-08dad7b6b013
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:21:26.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QgybSb29Euw42Dy5ZKrjkpLPqXKV8W//2rXxvHmW+70TWx/KEi4i7nSajeuspFaOJyCs2xSViyHUYJVLiHC9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 1:00 AM, Jiri Pirko wrote:
> Mon, Dec 05, 2022 at 06:26:25PM CET, shannon.nelson@amd.com wrote:
>> Some discussions of a recent new driver RFC [1] suggested that these
>> new parameters would be a good addition to the generic devlink list.
>> If accepted, they will be used in the next version of the discussed
>> driver patchset.
>>
>> [1] https://lore.kernel.org/netdev/20221118225656.48309-11-snelson@pensando.io/
>>
>> Shannon Nelson (2):
>>   devlink: add fw bank select parameter
>>   devlink: add enable_migration parameter
> 
> Where's the user? You need to introduce it alongside in this patchset.

I'll put them at the beginning of the next version of the pds_core patchset.


> 
>>
>> Documentation/networking/devlink/devlink-params.rst |  8 ++++++++
>> include/net/devlink.h                               |  8 ++++++++
>> net/core/devlink.c                                  | 10 ++++++++++
>> 3 files changed, 26 insertions(+)
>>
>> --
>> 2.17.1
>>
