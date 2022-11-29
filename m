Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3396463C646
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiK2RQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbiK2RQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:16:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99715663E1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:16:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1lJR2jGZxPlXE9dUekb+X4xxcvJsQ6Axo6HkVGN7gLspnI8zPNKXCTebWQe1r8XZ2w+vSiQcbpO1huvqxB9y91B6lp0IJLvYz8nfPyKoTeq31c8fakP3FS+5WM0O0bR/r6u/COI0NhOi9auLywvSuKknGrAekO/quf53uNoUpBwZi4+o3fybYR0jngTGqV/Ldbaw0oxnCZ54TKev79tPcHSOcNxFLmsyGLjwlIdUfOyET8fSVLGHLEiCNO+SJR6rJvVc1oPxoEE++WKB/0mdyb1YRIbDEjZpsSRX5M2lzYUccwzd6vcWtXxJjvPBzRonZ94Og/XFcf+/5bgQ984OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEvcU0oscRNPyUJPSAobpwiOeAyRvxZqTG8g+IK0SFM=;
 b=Xx6uynS1DPHl+BiMMTERih2qtoZaC35HdT6KUJ738z8nGfiE2s8Tc++Ql/Hg4NErYwXgR02VVQl5/cyqeAsQuVWhkhHxBbbbwyNX1C+bBlWffIspe43P0OypVXtUVkDrMwFerhiHa+SJmnDlkVBV37Z9I0DJjuvIq/sScrzIIC9uc3zhrME6hfuJvYTOsrvuRI2jeZBVQcarJLvwmG+2rgSQLRDKqF2zIEXxBkklXvmLrHyGt0i/ZvQqMLESU9+53C/9ZmkSc7y90pnkUmHoc/MGnjMFB0rjhoq4+zAx4aiJCjs/e2eKLDG6/E27v7AFRfF/u5d7no+kJyAMySRXyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEvcU0oscRNPyUJPSAobpwiOeAyRvxZqTG8g+IK0SFM=;
 b=0W6WNKZZ4RsUz9oqhdWIY7/50AsAwlUmUnAwXlQ1JCTj0oSHiy7oPVdq12QDjJ85MrgWemREtnub80kLcmBMiu4ta4I/CWHli89HCsvY7UB5/EkEnNZxgJk8wOfKIwx4TzMNOu5kQX6GYJz53Yc7utuSGXfXmCRVAS6A3fHWpYs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 17:16:50 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 17:16:50 +0000
Message-ID: <16a2a2a7-eab0-94a3-28a5-958175aca957@amd.com>
Date:   Tue, 29 Nov 2022 09:16:47 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Shannon Nelson <snelson@pensando.io>,
        netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
 <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com> <Y4U8wIXSM2kESQIr@lunn.ch>
 <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com> <Y4VEZj7KQG+zSjlh@lunn.ch>
 <20221128153922.2e94958a@kernel.org> <Y4XNPtIVgkWsbA79@nanopsycho>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <Y4XNPtIVgkWsbA79@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: 6228c1f2-270b-4959-ac4d-08dad22d8089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiITVzjlqcV3IHkc7GZSJ4rmmo/bPlon6E/BsM5GysK9cK49I6m6gU0DAfwwPSnx0ZjEbeiTfxdz2atlLRNnAbM4+dWAikHFwfv5JNyodpfbxQmxlPIQqxRmHMuhKZMUgJGfXkCt8+QpRbD7rD9xp/JhNylS3aiggQ9M/dscRo1EYWLWh0AsdHv7HMnx3nXhfQ1PnUbQHXiUNlPB922AkdNE2qa82lUlXDgCip2GH9etFanRWCoOvhUvZLgN0mY4BdmIUp/FvtYlRBBx9xwFntjWumHMSv6zmQ+fujg5C/RP+31HajL6+sIEhl7WIC6c1nObKg8ABiWvd3yJktMIIxoJHHLq9ieIP5LPy4bdw3RrV2yd4wHD4uezCNpFMNK2Id+dhyW7DnnS92081djhZTAlC+SJlx2v2M2vgm6QEwWyHa+HKZfOU0SPBnNvmfZbjFsE+ON4Q33RxSIAYO7d1GO8klbZGb6yT3YaITVb0SY2Jceb2Ku0dmuBAyCwHiMI1eDjpWaG3kXDSqjh8Q3sr3hr4t5MzxlLFhe//ItK7U230HoPzIZuKgSmUq+RVYFCvLvBNVb/IRukshDUcwzTFjVHpub2OZOorRr3odHpmpBcHHIWpFgJbwANlfeD7V6tblKpYnGe3MeR03XrOieLkHej96xyfkoVaH4KzU0vvM1z5Q3MhtqwYapCp/JEKDWa6+S5XYmvR5m4WSHKh8k+3MF5KiI5TOFLcKR1uT5w2eA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(478600001)(316002)(2906002)(6486002)(110136005)(36756003)(54906003)(66946007)(6666004)(38100700002)(26005)(6506007)(6512007)(53546011)(31696002)(2616005)(186003)(7416002)(4744005)(5660300002)(41300700001)(8936002)(66556008)(31686004)(66476007)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDZuZzJuUTVvb1dHVm5tRHpwdjFvMDNDTHFzQ3g3T2hROWVVYUlQOUVCTUxG?=
 =?utf-8?B?Vmc5bFFQNm5HZ0l6R0VTOWwwTlo2ZVIvWm41M2xtWTl0RkVmaVpJTkZrM3Vr?=
 =?utf-8?B?NTNnZHJtT0FhYWtHTzRSczJQUCtwdDZrUzYvWGVTZVByV2tGRHdCVFRINTJN?=
 =?utf-8?B?YTZnUVFPT3VHeVhQVWZXV0dzRzhWQ3NmdDIxQm1HOXdjenhsNWlKRFFkdnlI?=
 =?utf-8?B?ajQwdWlnYTVoREZaWnZYTVlQalk0cWpoamxHaFhPUlVYbmVqb1FDS2d6dHFD?=
 =?utf-8?B?NkpvQU9mSzdPRW01OEZsTEc0OWk5cjRGRXhEMHMraUNub2Nud1B0dzNaNmM2?=
 =?utf-8?B?cklIVGNUTXZjNm15RjR1RWUzTnI1RnRtV2lLekZIVVI3OTdXZHFZU3U0NnNY?=
 =?utf-8?B?dDAreWhCOEpWNHFqUjhrL3dBWUV2eDM0cHFxZHlINlh1NzRzOFo0U0QvRytq?=
 =?utf-8?B?U1BkdndYN0NOT3pnZlRxTDQ0UkNYOUdUSjNYNDFxVk5HTUdjK2V3cUFXdWp3?=
 =?utf-8?B?enIzRFc5SHJmT1h0bHJoNmVVK2ZFYURSUTMvOXBCcUhlY2kxN1IzWG5qdXpO?=
 =?utf-8?B?YnM5Uit6UExBeUR3N2FBYXRjcVpUdy9SbU9sZGlGcVRGY09qaFI2YVR5SDBw?=
 =?utf-8?B?YTc5eEpvK1JPeDE5bDZoL0NvaTBPWDZWZXByeXRuelpQcjlVZDVlaVp5S0FY?=
 =?utf-8?B?VUNvR1lqL1lhSmNrUFpRT2pZSmNXb2hCOEE3alYzenk5a2piWlZLU2g4cDY2?=
 =?utf-8?B?dHNXZ0tSMHo4dTR3eTBTTlppTDBQTGR6ckhMcUFaU0VLcHpzeWhLTEV0eW1O?=
 =?utf-8?B?M042MUx1OWcyaGxtZHlEWDJKNVF3ZTR1UHpMby9Td3Z3S1Jtc25VemYzZDh2?=
 =?utf-8?B?RUloRURPU2xMM05yK3dCdHFpQWRGRmRWSWVOZ2ZETXB3TVJjQjRtM0xrK0Ew?=
 =?utf-8?B?V2xZeEUyQVZoVmZLR0lBY2hMQUtGaEpGazlrY1ZnT1daQi82emRXZEVKRzVG?=
 =?utf-8?B?Z1BhNEVOaHMvZW53UUVGbU4zYXoyKzIyMk9Femk1SFFiZVVzMXR6cVVnVjlz?=
 =?utf-8?B?cjNhSHN3eGRpbklXWi9UU2FDOGhST1ZMU3hSSlRSWlZ3TlN2Y21VQU1RUExN?=
 =?utf-8?B?V0dPRnMrWEVRTzYwSDd0bTR4M1FvL0NEK0Z6RnJyeUFlM0FCT0R2cnV5UTVU?=
 =?utf-8?B?S0h3NTMwL3pOZ1JzYkdiL2xlWnVjTllMSjhIZC9JYnVLTm5vWWNZZHN6SzBa?=
 =?utf-8?B?WnNBbENjdU5pUlhIMG95aU9LWHFZM2t5ejQ1S29rTkJaVHFHdnh2dWcrallx?=
 =?utf-8?B?QTdaSWRtWnprQjJsYjMxU0daYXhVYlQybDN4dUU5RnFhVG4rdy9mMDZaejZa?=
 =?utf-8?B?VkN2MG5xYVVzblp1UlVhczFLN3JkODhRUEt6SCtKYmdBdnY4Sk44Zk9MSHJ6?=
 =?utf-8?B?MStnTDdzS2pkcjdnZnhSMEFzNjE3NkIzOUNiV2JpdjBCNjBXVkpYbldlTmdK?=
 =?utf-8?B?NGxDZzRmYkhCSTVvU1FuQUVac0V3Vm85azhmOUw4T0ZwbGJYRE1YNnAzSXFU?=
 =?utf-8?B?OC9GTjVhYUMzUUNEbEE4V3hiTFRHY1V3SUlkTDhLeWlhMUxOVGN2ZEtHN2F6?=
 =?utf-8?B?eDFJVmVndW9XMElTZmM2dXdQNUs2bmZWU0ZJMUtXVVZtQmJHMmdtUEFka1h5?=
 =?utf-8?B?WFV1Q2p1TnBzWnRKcDZ2V0Q3UVRHbnVsLzJ4bC8zcUluU1hIY0JNYlpSTW1v?=
 =?utf-8?B?WUF2cWR0bnJuOEZVQU5OQVB5S3Zkdll6dDdSWjZJYi9KWGhMbzQwYkE1eDZo?=
 =?utf-8?B?UzZsTFZ0SXpXZTVqNUhQelVvRFBqZ0xVbFM3S1lOQ25aK1NkZUhodlJsMGgz?=
 =?utf-8?B?VnpoRzFyY1N5bEpDYlhoMGpzbnluK3RkOEVpMEZtRTZ1Sy9VYnRpUDJKcHA2?=
 =?utf-8?B?SnVSOGpBdnNoSGk0TFVYWUpKY1lKU29PWFlFOGt1WlYvK3VFVy9YOWFqTDhT?=
 =?utf-8?B?ckNCcDM3UFhOWWRONG4wSm1OcHZyb0RweDhzKzhqZWhmRnBvQWp5RGtuMmpj?=
 =?utf-8?B?TUlZeTVqZHI5bmVvYUNTRy9xMWsvazlhNEdkdWppR0Y1NFdqTHhjZ0FIc2tp?=
 =?utf-8?Q?QPI7Y5Z7QMOBhN1PBbuVRFIag?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6228c1f2-270b-4959-ac4d-08dad22d8089
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 17:16:49.9307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3TwRm1tF9Vi7prC6efZi0/f11rmNISTBSkjK+kLTIUY1QRBLBc50asuJ3lRmb8pe1+R3CWv8o93Z6fU6cZ/jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 1:13 AM, Jiri Pirko wrote:
> Tue, Nov 29, 2022 at 12:39:22AM CET, kuba@kernel.org wrote:
>> On Tue, 29 Nov 2022 00:29:42 +0100 Andrew Lunn wrote:
>>>> How about:
>>>>     DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_MIGRATION
>>>
>>> Much better.
>>
>> +1, although I care much less about the define name which is stupidly
>> long anyway and more about the actual value that the user will see
> 
> We have patches that introduce live migration as a generic port function
> capability bit. It is an attribute of the function.
> 

Thanks Leon and Jiri, we'll keep an eye out for it.

sln
