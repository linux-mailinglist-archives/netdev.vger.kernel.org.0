Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE769E9C5
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 22:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjBUVzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 16:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjBUVzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 16:55:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CB29439
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 13:55:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDGwjKqcwcHvInAR7pQJXFm8DWDgVTgj2jGHjmECxpQqkeX8DsWVb11KAH/+QgYEqbshd99sdBaxlv+EXKtXsJFCS5ts8WhYmD+YmYaLOlNrt4uTQcPa/N9hUBom44bGZ/BfakcpY+EWudHDARqWroukfr3DTrId7/GQlIImcMh06838UQDtvMhFrnpM0swf+ogfW3oVSQLDfIeV4QDWSYwh5WldSOhvSQiiRZShP6rPp74sT5QD00KBQNTsse0rF7Lhl0r9HcJTSJDbkdWrd4JGZRjeiqhWKfYq1PQe8NLo8lWHC/SsuX2J9mx6jdBT6GPPfxaCyRefSnTC/mnR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMdhUHPjmBPK/iUeetpn9g+T4qsH8mehEOZoodatB18=;
 b=Z+c52ulvMIkujtbr3dRbNIgDvEce8dX2sDSwr16SEa9VGcx5j0YSK/2kcN3Ip06Hp3XYsZAv1EibDaije0XEpNA9Rkq8HVOmdTmuVFzVT82SaRa13FpyOrHWBkq5F3K1M9/H7XBR7j3tDhtl8QbLCciOr2xBH7mpLHcSQh5Np/XtMMqtx8RfnxSnv4sieIX60PF0bpy3OyStXKepRzlHxjd+W8ImKRkXktHvVXXbGzMDTeuH3PdbdxYbU2bQzPgAJ61FxtzVZB70HGIZV2DYWGr3do/GmC49dsygRKFctEoInM2Z6CzV5aNCeccOHfFWrWcwq2fx8tBiahpDEM0XeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMdhUHPjmBPK/iUeetpn9g+T4qsH8mehEOZoodatB18=;
 b=jclRrvEKck+E5Bv8qehiCIFqJAiT4mYd5xkZ6zesT7rIW6WnfYPOe2kofAGJ3BIjzd4exRP+I9jtusmQQBVRc3X6F2vJRv39S2fGdZ+obpWkXIpcosv+vJGm59k1tEPLXo1sIwIeFPnPlu6+WMcVFH1X1w0khHzSOgLjTscLg70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA0PR12MB7676.namprd12.prod.outlook.com (2603:10b6:208:432::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Tue, 21 Feb 2023 21:55:32 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6111.018; Tue, 21 Feb 2023
 21:55:32 +0000
Message-ID: <069464cc-f821-49d0-a662-52bc6ab7880f@amd.com>
Date:   Tue, 21 Feb 2023 13:55:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3 net-next 01/14] devlink: add enable_migration parameter
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <20230217225558.19837-2-shannon.nelson@amd.com> <Y/Mtr6hmSOy9xDGg@nanopsycho>
 <98cd205b-fabe-a2ee-e9c0-51e269b78976@amd.com> <Y/S6N6pcbHSFdj11@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y/S6N6pcbHSFdj11@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:a03:338::7) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA0PR12MB7676:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b979f6f-14eb-4d8d-d9b0-08db14565a84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2f29Co2bEG0ndgoe63vtizMjjAJtCw7q+EO2Tsp06k3kpHY9y8poZoudxF8BO7C3pwh5UZZlKosYHw86g7yqjN8ZcMcM3N9Eg0IjzOZ0g5pF3DXoAq1ukjaRey6tY9RC1+4B9H3BzY/VBcc7GMqx5Wtrb7WXXrbe0E/TamEpR8qKRA9VbFuoG766TUCxcaLsotl7UERk40Jlg3rtsy/WIw4iIkTpdA8VuPgkpVBgAjakybO0L5JOXwr5/hqEAzLPkerWEviuEMR0T0Iv9kB8a1W6yMP4G2ZHMOzAGOeqW4UCfTMPMI+G2qJDoenVDGSGjnXCCzJLCSF4OIfo2rYmXrJaCTDWedPeOKpCOCVatoEpItg3r+Ko9mAIqC6FSDuCPnjPf+NnveHY/NseoPf9VsWg92FJk1NnnY7g3SQmOorA8xkazPtcCyReK5wFsV5lM3XVpyz2PukUhdN5v8JwOG/VrBgWx+hEC83AXm5o8Ze+8J3cZ8I2H02FWD70TS/i+uGzK5YjG7Pw68vwNPQnxFaZE+9KZkA2/2oB66gCtt9urFKcja5tZfAcl/DFP2vnZ8HgCtQrcf4ShxBILMM4d7dd60pZhnKug4xZoYTp5vfyBT6oKscGGro2hX/lLOfnK57/zWbTGBy9c9NfIti3ANGLRw26sajPK/epvNy76CMaBQsh6VO2DWuYapGjeC8eFAtZ/c4vZO8lTGrrLfwYOWTVXb2gI3cC1dhEjf/EeoE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199018)(36756003)(6506007)(6666004)(478600001)(6486002)(2616005)(53546011)(4326008)(316002)(186003)(41300700001)(8676002)(6512007)(66556008)(66946007)(66476007)(26005)(2906002)(5660300002)(38100700002)(8936002)(31696002)(44832011)(86362001)(83380400001)(6916009)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2Jmd0JZU2xuU0Vaand4YWhvNkVpRllIbWRjdk9HZXl3MW8xQzBmQVNWOExr?=
 =?utf-8?B?UStVMTJsbWVSeGtudThndDdlTEJ6cStVTUtZL3I3US9yS3NTWjh0NUJmZFhZ?=
 =?utf-8?B?N0t1QXN2N3hOS243ZjhyUTlJbnRIaS9aOXRuZWNad1pIa25hTnB4dVpsdDBP?=
 =?utf-8?B?bERnRjFWclljQXdKeHcxY3lFeTYxSWVhVFpvUml4dUVXM3E0eFU1MjhxSUVB?=
 =?utf-8?B?dVJsT2wzMVhaOHhCaFBZNnVXeGRxRmNlVkp1K010YmZSTWV0bnAzR2xISkhH?=
 =?utf-8?B?blV6SzZjYnordDEzQmpBdVZGVVRmcDAwZks0dHZOcGF0VWprWW9NYU9RWFYy?=
 =?utf-8?B?eDVSNGNnQWwrc3J0UmRQQzhITkFVaTdlZmNoSDVHc2ZpT3ZrUHVvd1g4cFBB?=
 =?utf-8?B?MXZDYW9MY1RIUzY0N2xnS1krMlQrbERjTzNtTXJWdFRRdjBRaFdOOHg4NGtG?=
 =?utf-8?B?dm4vMHN2S1hveCsvY3BHUmE3Vkt0dkpYKzBudmxGQ1V1UzBXQ3JPN1JZL2NN?=
 =?utf-8?B?NnFmZXgyMFFUY2d1Q3h2eTd1OURaV2EvdWd0T2pDSDlDdnZubm95WnZsTWNR?=
 =?utf-8?B?NWdib2x1Tnh3dDQ2YW52dXFINmZXTkRQbTd1RS8xbUtpSG10b1lHblNmUmZE?=
 =?utf-8?B?clZueXBiS1ZHT0xCUVBkTHV5QzdNUmhqeks5bGpjeStVL1JiZTN6VFNSdjdR?=
 =?utf-8?B?eWlRVExyVHZUUVVqazNzLzFRNmZwNkdXWGRLWXEybnhFVFpCdjgySkl5Z3Fw?=
 =?utf-8?B?UW1RWlhEaEZrcU9JVzVnWG0xR05ZMnUyNElXNm1CTGdvSkl5NkdUaWQ5N1ZO?=
 =?utf-8?B?Qy9aZi9QeUd3QkJLMWhIUkphdEVuYmt1R2NNNnUwZGJ0VTN6engrQ0dKaUh2?=
 =?utf-8?B?NndqREpFcWpTWFN0YjFHTmZ6ekNBWVRaY3JQc0xYV2N6YzBSdnhESHd3dzBR?=
 =?utf-8?B?cGp3cDRaZ29uaWRLY2JvWjRVUHE5d2d6K1BHNjVVMFZLc243MDR4QzFLQS9T?=
 =?utf-8?B?c01TUEtvbUNzL3hYSzhwV1lBdDFZYmFsdXJyUS9uTTUyR2JFRkFQK2RYZGZ5?=
 =?utf-8?B?OFB3SVZsUXNEUk1VcDVXUVRBVis1S0t3emJ1T2lNcytqd213M0NqYUdQam80?=
 =?utf-8?B?bm83Mm00Y1k0K0ljTUhiZHNCR3hncFNvckhPaXppM0RzeTUvSmhnNlo2dHY4?=
 =?utf-8?B?KzRXZkFjWGtWYndiNlZNM1JoVXZWdUs4dmk1RjVwSWN6QnEySzIxcjk1VW9m?=
 =?utf-8?B?WTZBelgrSzgvNVJVbGtIR3FRZUlaSFloNU1CNGhFeXJvVm5ZL0lIcGF0OXp1?=
 =?utf-8?B?b04xeGlDalJSamYvdXdkMTgyUHhkSVhkQkJFL0x5SVpYcWkvYnhvNk0vWExJ?=
 =?utf-8?B?R1Y2VW9XTDZnQ2JNL3k1d2Y3VkZMOVVubkJ3QnRVUzk2MVFMNXlkMitWVjk4?=
 =?utf-8?B?UUxBVEpXU3lQLy82NGZuM0svZWFlNjF1SXVaVnNBQ1Q0MkxjUU9iWmdLazdJ?=
 =?utf-8?B?cE9VT3AwMzVEVjFnUDFETnkzYTJCR1VwdHY5YW1wb29MZEk3b21aa0NMbWgw?=
 =?utf-8?B?VGlBK0lxbEFwck9DQTFNVTNsVm5zVHdBOU9Zekt3Wlk1R3pUME5STytYNUJa?=
 =?utf-8?B?RDNwaUJldndzaTI0RTRJOUgzUnZYcE5aZ0tidVNZSzNrSkYvRnRZN0pwVEJy?=
 =?utf-8?B?cEdWVkNIbGpKKzRJNjZjWmtXUlFXbGpyZEY3Tnl3ZXB0SkxaTG02S3VwK0pp?=
 =?utf-8?B?U2cwT2JJWmNJdDdJNk9zSHZTWllqajhoN3BGeE1rRHArOHdSMThHcERmMlBO?=
 =?utf-8?B?eEdwSnpXZ09WZU9PT3FSVnBUQTZ5VVZoOWEwY3RRN1pIeHNIUDBaQkd0dnFm?=
 =?utf-8?B?OURBcm5qZVU3dVdhTlorRU0rNmRtYVorempMM01TamVvcVhIcE8vZTJDZ1V2?=
 =?utf-8?B?aHN2OWhkTzQybXN2dHZlL0NGbTBYWjhWWDl2dmg2SlBKa0ZpVFpwUkxYbERN?=
 =?utf-8?B?dVgrTVVIN0pXaUI2Sk5Ta2drZmc5Q0RqanNPRWdxV2x0LzdTT3hUNWYzS3Zx?=
 =?utf-8?B?a1RrdVpMUUpxL1QrQXJTaHAwb1VYZHFQMllxN3NSSUMxdkEwOEkrbWlSSlNa?=
 =?utf-8?Q?wF+6n2xd7OopgRnU+ijniAiak?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b979f6f-14eb-4d8d-d9b0-08db14565a84
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 21:55:32.3487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/Qk2bHyZHs99gv8eSGA+zvzmxI2nY2j6ECXdB+ocHeFgYiyXBG0N57oOUKDxNOVlW5pHa+0ixdjAfdogiKs+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7676
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 4:33 AM, Jiri Pirko wrote:
> Tue, Feb 21, 2023 at 12:54:25AM CET, shannon.nelson@amd.com wrote:
>> On 2/20/23 12:22 AM, Jiri Pirko wrote:
>>> Fri, Feb 17, 2023 at 11:55:45PM CET, shannon.nelson@amd.com wrote:
>>>> Add a new device generic parameter to enable/disable support
>>>> for live migration in the devlink device.  This is intended
>>>> primarily for a core device that supports other ports/VFs/SFs.
>>>> Those dependent ports may need their own migratable parameter
>>>> for individual enable/disable control.
>>>>
>>>> Examples:
>>>>    $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
>>>>    $ devlink dev param show pci/0000:07:00.0 name enable_migration
>>>>    pci/0000:07:00.0:
>>>>      name enable_migration type generic
>>>>        values:
>>>>          cmode runtime value true
>>>>
>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>>
>>> Could you please elaborate why exactly is this needed?
>>>
>>>   From my perspective, the migration capability is something that
>>> is related to the actual function (VF/SF).
>>>
>>> When instantiating/configuring SF/VF, the admin ask for the particular
>>> function to support live migration. We have port function caps now,
>>> which is exactly where this makes sense.
>>>
>>> See DEVLINK_PORT_FN_CAP_MIGRATABLE.
>>
>> Hi Jiri,
>>
>> Thanks for your questions.  My apologies for not getting your name into the
>> To: list – a late Friday afternoon miss.
>>
>> This enable_migration flag is intended to be similar to the enable_vnet,
>> enable_rdma, and similar existing parameters that are used by other core
>> devices.
>>
>> Our pds_core device can be used to support several features (currently VFio
>> and vDPA), and this gives the user a way to control how many of the features
>> are made available in any particular configuration.  This is to be enabled to
>> turn on support for our pds_vfio client devices as a whole, not individually
>> port-by-port.  I understand FN_CAP_MIGRATABLE to be applied to an individual
>> devlink port, which could be used in conjunction with this once the general
>> feature is enable in pds_core.
> 
> Okay, that sounds legit. Could yout please extend the patch description
> with this? Thanks!

Will do - thanks.
sln

