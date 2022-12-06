Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFEF644A55
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiLFRfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiLFRfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:35:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C16A32BB4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 09:35:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9aM8BMzRKd05PsBiiQDiA971n8ENQYLdKsfXfPyUQyX1p+1ylZ/8SKNx7yNawxyT/mLHQTwZPz0FPkN8jjuHW4QhSQHaK93bOBFbiY0XPSZ6yZ6+00/nyXoTckm9R/k6vXHzoOM1OTUIoNeOcGkUGA+U4LSsZ1U7l0I3SlVSgaLEINpF/fkliYE8KaeT62BGDiM2yiHhl5KnoPdzddTLU7dpoaOsFdlEIVf7//O/SjbHz4tEfTEemVEfFBVK4SLjm6EUpWx8b/jAbo5aYKSDxpcmrQi3dPw03vuRF47EjEcnYN4tcsHBgYXQ0SGnKBv12qbHTRpyK6Y7I2ZSnnzCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcsBDEOtJU61DmfxO6nsN4q0qfEOOclImUtsuN+vl08=;
 b=OJC+4FJ9hN0vzKdXkMejMF3foEmfdWVcSpuZSmnAPbTnVi/zFrXaZtxSm7PsfKGzy0gS386QSzsZnzHHn2UYAxlN7Ii7iSK6QmijCy8Db2ObMYbTQlT7j8Xqkr3dP7Ez8S7G/JIKvIvgq6OZaQHlv8nE7U7LdW823KBSdvHjH1oy7PYUqa9zyzDWLHBhBEya5u2G7LoC36bH4Tr/XI4463e+Kt1bbhmQRuQb5zrip4p472LTJ0Od0yleq+1cbM9Vp4sFTclXs1pnaDWHCv+NCqtV7auDDP+aJmuyxbIp5Z2Yv31JSxa+mFeBWkj5Fr5mibXLdTp0cVy6EZDt7K9boA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcsBDEOtJU61DmfxO6nsN4q0qfEOOclImUtsuN+vl08=;
 b=J2O3jovLwF+Lm8EaT4u9yOSffhCvcdI8CmiT49z2Q1j5RO7rhm+B3B4uyoBt6ZTjl0YckZTS2SCCC4V84Fg3+Pq5HkumxANtBPk3exScKEJ7rx8VqDHHVL4um4dB6G6cJMdbbNdAaBzUwlblksk75C1AvUlaTYCq/8VlqkhVqI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BY5PR12MB4856.namprd12.prod.outlook.com (2603:10b6:a03:1d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 17:35:36 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 17:35:36 +0000
Message-ID: <a5c5b1f9-60e9-6e82-911e-03e56ff42da1@amd.com>
Date:   Tue, 6 Dec 2022 09:35:32 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [patch net-next 1/8] devlink: call
 devlink_port_register/unregister() on registered instance
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205152257.454610-2-jiri@resnulli.us>
 <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com> <Y47yMItMuOfCrwiO@nanopsycho>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <Y47yMItMuOfCrwiO@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::37) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BY5PR12MB4856:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bcac95b-d4a2-4f30-afd6-08dad7b0488a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KACrH16EDzg5LlfrPo/jZwiOpkmTjYDl2I1lXqrYqUnzyNP3nxuvZjFUP1x8c7t1CDEB1u0o8cxnP3nRqLAy2ZdChj+ykGa4WOoNcYf3uFD/93kFbTO0tzFripCebihNDT0ueElGjnFCO65Dq6SEyMAJxyLVSpf8LgHTZFTghSih3wbjqclH0nBKuM7pl9qvrAb0mA23kDfY6buUh2K/jYnXBMtDrLbgM/vQ5l8wAl/H+xN9gxuk9Mcr7OWebVibNs3MSwzsgsb/TdT1SolpA2a5nmcxsZWWOY/NsbW+GLhqdwx7K+mDTLErqBNGsLcM9u7uerlGSkDX+vDIQ8WopSWgTnzHPo5ZjdOtsSkIXXoHGQIxj59+tiHwwcBBXsQqo9tqOmjtQe7spQ3PFoUs0UAU4Rty4b+hjXGlH4X6XSE9+0vQUIXwCv7zEx8CJkW9GCBWhljjWtxP7u8LBNOMDOFP4NvH2gmmquXSRtG6Fs/S8J8c6IpTWMkItZDgAKA7bh7pb3dwV5HAQNMIGABkVv6BECkDqeA3F4wOKVMraoxk8QQRXiO4/uAXa+46WOn077kDu1ZcmpjCwV0pm+AdBtJtxZ8VDLgA6tnzi4CUk9MpzSEBDJbqYjod9zohTpNC+r/F/JH+3++IlG2xAf08vd4vaJPCTs5asgvr11N1V7d8IvxQUfSS27jqY/otaLWIHXVt8UxaB7KCQ2419d4dJu2GmpqYvjbe4WVCJv1/UVE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199015)(6506007)(83380400001)(2906002)(6916009)(31696002)(186003)(6512007)(26005)(2616005)(316002)(41300700001)(4744005)(53546011)(7416002)(5660300002)(36756003)(8936002)(66946007)(66476007)(66556008)(31686004)(6486002)(478600001)(8676002)(4326008)(38100700002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3lEL2xGWnlCVExBRWpWZGE5Z0xHNkgxTDZYSnl6TWRMaHN6UzZTckpPRE5P?=
 =?utf-8?B?cDllVndKTmJJTXNHOWpydVFSWmxsZUt1VHBla1RnaFZjSWNmUDMvU0hEWEU2?=
 =?utf-8?B?TDE4UElWOThkOC91L2g1dkFMOVpDeC9yQUF1KzFub3NVRUNYVWtCTG1YTUw2?=
 =?utf-8?B?VUV4ZnRXYmY5Sk9RNUZlUmVIU0d5MlhmbEZoTEFFdlYvNC9oVldHaFZ3VFFC?=
 =?utf-8?B?QWNzSkEwM2tBSkIyL29SekFyS2U5bnJUc2JBUk5rSnVWcll1Z2NFN28vN0Yz?=
 =?utf-8?B?UjBRZTducTZtUUNReU4vS1VseXJGemFRdDBzMmhmWlZJa2pwM2x0aFhYZEkz?=
 =?utf-8?B?d2RTaWcrUG5UTkd6aFN5Ymk0Uk5HRzF4UVJHczlOODJCQ0tIaU45NUs3cHN6?=
 =?utf-8?B?aVhMWHNyTlVWNk9VWVhkV05Oc1pUaVRYR2tleElSUDAzcHFmZ0ZVTHpsSlpn?=
 =?utf-8?B?ajUyeEdZVEM0SUNTSmo1aGRDVGJlMjhROGc4b3lNb1ZQd3ZwcVE2eGJSeTNX?=
 =?utf-8?B?OGZCSkhsS2RyMVBaYjliUlZ2NFo5dEVMZlM1VisvWTJwQWpwR1cyVDFwdFJ3?=
 =?utf-8?B?eWRqdXBRZFJmWmJKTTJUK2VhaHFnZ3Q1b1FVMUVycFVMNXBlNE9HTEV1Z3lE?=
 =?utf-8?B?dDd2ZGtVckhaRjZaSDFpb3FMZEhPNGtJZThuRHRaWjEzaUZWNXAyTyt5TjJU?=
 =?utf-8?B?akM0Mi9JejV1MWdSOEQvUmtVMitrMXRJNHV5ckFWNmQ4K2x4RVoySlFTem9t?=
 =?utf-8?B?dzNhZGRlcGhBUGdVQ24ydE9aUkYzbXhoVHFuenRGRE1vMEZzbTlTT1NuVzVX?=
 =?utf-8?B?NUQrVmpKSis0cjBkWGExQS8xUnh0czcwWndacWVtZVErS2dKS29ZN2xIcnRo?=
 =?utf-8?B?MzVhdyswc1l5Qy9nZ1RjbFQxTW1Udmk0VEVmNTdzVjloN0MwSHlSejk4cEND?=
 =?utf-8?B?dU12d3dESDBMRk1NMmZZdm00SjZKODNQT09CZjZKKzVXVVIra1hXU2h5aVBQ?=
 =?utf-8?B?SWdyNXBzZDNLRi8xeWVIaVpsa0FUcXA3YTc3YjNWV1Rjc2FFZFJuRTN0Z0Iz?=
 =?utf-8?B?NFJ6STJZWk9qaEs3T0h4azh4Z0g1Yk5yOXkzcDBEenRrQlNHUFVrQ2hlcjlM?=
 =?utf-8?B?UEFoeHVWekE4R1o5RFhSdENmbTQ0T3JCdzN6b1R3NzQwWGJJTHozSXg3bExi?=
 =?utf-8?B?OXZFNWNDUG5rYkdNYVBxV0pDQ0xtSlNpWXR4amVtejQ4ejkyWXBQKzVaWThj?=
 =?utf-8?B?b2NBMnN0cCtJZEZoWkhxcW0rR3MxT0dFT29UVWMyZ0lIWDB1TjRFa2VSeURV?=
 =?utf-8?B?cTNMOEY3WTN5TDhSTFE0UjV1Q3llb2FuSzR0NTFrSTA0NGNkaFNZQWxVekFk?=
 =?utf-8?B?bTlxVFpHdU91VmdHaHlKV0IwUVBGdkd5VW95TUxSVW5MUHBFWjc2UXFHdWp0?=
 =?utf-8?B?QTlZMjZ6SmhsdUtSbVBwdzBtWE44cHBMRnZxdVkvYlRGRGxmc0ZiT1VuSzkz?=
 =?utf-8?B?Ym9GNG5EalBjQk5kSW5pNnd3eXhTZ2pOelhXVHB0MnR5NnZsM01FdWpXb1BD?=
 =?utf-8?B?bU1Yb05XSXBlYkJCN0tDRFNnMFhpcFN6UkhCVmlBVDlQRlBsTnJhMW9LTitm?=
 =?utf-8?B?UHpVMTNjbGZOMHU0N1BIT1VFeFRsTm84TkJJNE96RUFneEFabkhjT0w2ZkhB?=
 =?utf-8?B?Q3R3M0tuM2hESjlwZ1UyanNkMFNwYXhlSmQ3THpUOGorVm4rZVNleFUwRGRq?=
 =?utf-8?B?bEcyOStSQjJyZU8vYmJ1V1JTYjF3dWpUcVM4K1E3YzRSNDZCbVZqYXBlTFpi?=
 =?utf-8?B?VWQwdEJxbW92dGE1TU94c0NKNWVDaGN2ZVkwOHh2eDAxeTdPMHB2MW1CYTFp?=
 =?utf-8?B?N3FtWnFDMVVadkEwdk4zTCtIY1ZITy9aRzZlVkhaVHpqclNQWWRmR2lIbWFS?=
 =?utf-8?B?bjU2ZHVBSVpQbmNYeEI1QU9lMzl5Qk5EMEMxZUZselFtdG1RY281cHBqdnRI?=
 =?utf-8?B?Y0xsb1ZLczVObjN3Mm5SVWlqNHN5Q2xqVkU1UW9DRnJJcDZudzlIRXlZMU0r?=
 =?utf-8?B?a1hwNWNjUGVhWEw3aDlzRVNBeTdJUHpsUGt3MThsRHFyMDlyYU9ESmZqZHZn?=
 =?utf-8?Q?G7XAr84VgrBg3UTMv1ivVK4Xg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcac95b-d4a2-4f30-afd6-08dad7b0488a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 17:35:35.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvgnZBf1jUnzAy7/ta5fgUArw3j5dXvtG0943JtEkQ3hcFWLaLw2o5OFhmUPMhiiEFjIj36Jamrmg0xknk/3Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4856
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 11:41 PM, Jiri Pirko wrote:
> Tue, Dec 06, 2022 at 12:55:32AM CET, shnelson@amd.com wrote:
>> On 12/5/22 7:22 AM, Jiri Pirko wrote:
>>>
>>> From: Jiri Pirko <jiri@nvidia.com>
>>>
>>> Change the drivers that use devlink_port_register/unregister() to call
>>> these functions only in case devlink is registered.


>>
>> I haven't kept up on all the discussion about this, but is there no longer a
>> worry about registering the devlink object before all the related
>> configuration bits are in place?
>>
>> Does this open any potential issues with userland programs seeing the devlink
>> device and trying to access port before they get registered?
> 
> What exactly do you have in mind? Could you please describe it?

It looks like this could be setting up a race condition that some 
userland udev automation might hit if it notices the device, looks for 
the port, but doesn't see the port yet.  Leon's patch turned this around 
so that the ports would show up at the same time as the device.

sln

