Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B701968BC10
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjBFLue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjBFLuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:50:32 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E321A6
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 03:50:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6r54PiqlMckCOjqYSO1VqFmX5qnaxoXLdz/XouaN/AlEsBUbJTmFos2Fep/7QNCt0NTT0UqbZnhFBWSc94igrI+lIjScvITilfLF7rjqpoGsN+GYhI8AlbwiVuM1ittx7NXxOCtvW2xkZF1xP2nQgWY+5Kw+hYOowDuDxNxGlQSYfbN8WYYF1wLrh1eFd2un28RMPYHBGpxLW/8wbWw2j0VfwyRBZU634ysNIedh16XNNr4xTttuLZUIyAzYAQuJHJBUb3H8jlk6UOWBmL/sxT4UJeO4zrjAxo6siLc/8Fng3FwPD5su5EzCof/kHUbzHSN87+wZ3cyvscvmfQHJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmNzi+/xwym5TUng4yMYYr2vZnysdL3/Je9oe1y9vF0=;
 b=IDZjdpM5WEIisieRvaQfuwN/4bH+/SuAooyBLB5c5faax0JXQO9WuxU9mN79zvES1MtbbTt99o0JKTwJQTFVVXdUzn/AoCvtQ46u/s/k+TekV9fIprA39IWUfomPhZ1WLXori06T19Wrlc8x8hc3VqGo2iAmDYv4Q7j8bZFufuB1yILWew1+XfMlgjvUs7w5qbPpbi/OAdTL1OwF6GPWMdtZeSHPdT4yeREK977wmLhwpz/odaiWtTNosC52ab4WNKcCZP/aUzI8UUNG9TDRr7o2zwPhTa/1JttZGmcKVd0+6KlQpBONKVBnskIJXce449Jx9no71tH7UrJ0/m1UOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmNzi+/xwym5TUng4yMYYr2vZnysdL3/Je9oe1y9vF0=;
 b=PXsuD7s0ZQmTGgeXVElGccq5VDCijQy12Da7SgIAQiICEmb/krhBJnVbnfsWj0sBwpghn371AYaDRlzxQydNjTRMSLO1WkkgK/aY1p4qETnFifM7D8JSgHiZjpvlM9Dw5VxBSaXsBEEOyGf1ioMM6CtBN0mxgM4P43VR1YSPNBoZjpQwRdvKbpbB68CyH2YC+sOHwZhUw77isCHQRLiEZxdSrIdntZ2GuHfwqjextRV16nUZm0LrZVMOUVNR+GDlu4EMZ05wm7a2mzVf+ySHJiPyWFKl57nWnJHOAX0HdT/vqN/ij5Ak4JKFPR0aoFtgMh7oThq8vpFXmr2+nXR6eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 MW3PR12MB4540.namprd12.prod.outlook.com (2603:10b6:303:52::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 11:50:29 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518%10]) with mapi id 15.20.6064.024; Mon, 6 Feb 2023
 11:50:29 +0000
Message-ID: <09159601-16a1-b4ca-4cb0-9c27bc2847d5@nvidia.com>
Date:   Mon, 6 Feb 2023 13:50:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2 2/9] net/sched: act_pedit, setup offload
 action for action stats query
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
 <20230205135525.27760-3-ozsh@nvidia.com> <Y+DbNFogMZWPPhNB@corigine.com>
 <CAM0EoM=OMfEP=qHjcNQFOKvr=gxoVd-2X8fCWhqoCf6CFsYhuw@mail.gmail.com>
 <CAM0EoMk-uFE+vi-mNV5n=2qKuVxTTete+us_jCqQBUeKTyCYWg@mail.gmail.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <CAM0EoMk-uFE+vi-mNV5n=2qKuVxTTete+us_jCqQBUeKTyCYWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::20) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|MW3PR12MB4540:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a372420-cf4b-4d08-4524-08db083857f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PDDWmbWRk8nY5ckLf4wQQjfbys6mZExotYNRvNWwJsAL7zy8/QFRq6ttQ7YvvI9uRfn4cOCk2HUWGEz3r5RXs1pfOGM9TUIJYyFGFtccLeqrd56vKfCJk9SDaqBnlmmxJ7zIStc8qzmc50FfDmBjpWWZHp/xhotvxPsX2iJKTep3Wk2x/kukCmd0uByFoYbMuM51htx3gg83OPxrYucDne37GgeIS5ZJpXJD39p023X2PVbUdLLRLQ/6K9MePZpqgPI18bevDsBywJWR5tS6JwKffwmXM7fzy5bFGA22wERln2YtHZ+rQjLdVe4js7iGBpFhzwnGfkN0yC/QATjfuLQLPNNOUjnXYNOJdd0uQEkO+pXAKU78dBV+YFi6KKfAIsdnLlEtxTF0n02JLXP1YsliYd4mVvCwxSoQPDsNu3EPLvlf0qo0MeNicAjjZX8hG1EdIYJJrTfkQHFbcvN+sl7Tb2kbLJ1IdrbkWLrrddk/DZoYeremSXPsbaZoMpEgt70nwFuQwvsyLFvZEIl6Er9nBAY+swfXeX9s807IQObcWkm6yv2zeEu3aLfjYmUgSlYw8NSkRfgV5gnsfxJVxzgWjM6HHBRtKyisDWjKAE79rBdO4laJRQqGh3jX4rSXYYCpOIWuKkJH4NwFnRPqqlpE6lURefpcK9rW6Cnfn0GsdIcgcyHEFF5BBmfYbxEpr0bnndSNFXo21ircdTjIcpMViPq0Cr4bwNFh50w5PPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199018)(186003)(36756003)(6666004)(6506007)(6512007)(26005)(53546011)(38100700002)(110136005)(54906003)(316002)(5660300002)(8936002)(41300700001)(2906002)(2616005)(8676002)(66476007)(31696002)(83380400001)(4326008)(66556008)(66946007)(478600001)(86362001)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REg3OUc5Z1AyZEdPcWh4TzRTTEd5VnUySkxaQ1owbjdwb2dabk1CcDdESHFL?=
 =?utf-8?B?aVk1czlUeGluMlBEbzVxcFFHU2FUZmFDdUZDM1NxV2w2UlhUN3VraEVuc1BU?=
 =?utf-8?B?OGpuZ1FqM3BTaC9wMnJXMGdQZ2xJTUYzWHB6QWh4Q3BUWXBMK3k2cWYzMWZY?=
 =?utf-8?B?R25PejhzemFhNmFtT2JKYndhSFg1ekZKZGw0K1JCbE5hZnM3dTJmamh5MDdU?=
 =?utf-8?B?MU9tenBhRS9NU1N0YWtKb0t4UllDdlNuK1BEZnVMYzkzOFFyQUFIdU93UURB?=
 =?utf-8?B?OXhJNjZSSldDSTl5aU5UUEFrbXFDUHRCYW84OThUUHdOQktEdldNeUdMZVFF?=
 =?utf-8?B?VFE5QmlZMFVCNGxZb3lOMFpNTFl5ODVjSUUvUmkwQzd6YzBGT05MWnc3K0xi?=
 =?utf-8?B?Wi83ZERYTHpGYkV1REgvS3dEN0diSXNLa3dyYnRiUFNkRkVObDZXVVFld2lU?=
 =?utf-8?B?akw1WnBQc2FMblltZlYxQjlRazJ1LzIwYlpVWSt5ajZsaHBIWE9iZElkQWtv?=
 =?utf-8?B?UzdiYWFZMVlVY0NXclEwUTdYeVVGY2ZnSDE1QUM0dEMwR1QxTlZaSEFSNlFW?=
 =?utf-8?B?eFl5TzFIa3l1dVozbVpEbjloZXJCU0VRSnVFTFloRzNrRWlNWGhLUDFHbEhB?=
 =?utf-8?B?L3ZkUTM4SjYxbmRGVlBOOTNtaG12SDBMZzR3T0tDZENNTkpmeTh0V1hXNlln?=
 =?utf-8?B?QXVNaTdPN3ZxckJ3SkdTcWU0aGRQZzc5ZElaMjAzOXpVRDNrVVRZNDljdUJq?=
 =?utf-8?B?MXdaWjZERG5MajJ2ck5rMS8wM0tQMWdqVXN3Z3hiTE1rR3BsTmVtb3IzbjZj?=
 =?utf-8?B?UkNsREVOcVBtelhUOERXV0dwZVgxY2NDK0lsWG5kOXhmY3IwWnJzdXk1NnR2?=
 =?utf-8?B?blh3ZThhSE9IalU2aHpOVWN3aVh2bm91bHEyeDFrbXczSFE3NkowUUtGS0lD?=
 =?utf-8?B?N1UzK0o4MGhVbndiUFhnT2RrdFdnSE9xeWgwdjBSWWVlNmUySlQra3N4WTNy?=
 =?utf-8?B?MEpqTFUwemJWc3pHaXZFSnoyUklDM3h6YlFwbHcwL2RPWUNhdjlHbTZqUEZ3?=
 =?utf-8?B?V2tIOWRxTFovU1E2bUpuZjg4dlBNdzNybVh5MldISFNScTVtR3h0c3YxZ05k?=
 =?utf-8?B?Z2o3TVZOc21KUHJTNmlaTDJuVGlTSE5jZGVFUzFiWVIxdkJXQ1ZKU0VjUVBU?=
 =?utf-8?B?cVJPYlNnRE5NZ09EanV1enBjQ2FYWlA0QjBWYUlPam5FQ2JpZDFBWDdhd2ht?=
 =?utf-8?B?b09jbDNKS3VLZDhoSDBTL2NOZmhVUWhGOElabjZha2pLSVdNQWROcmlCMXZL?=
 =?utf-8?B?NWtFOGxERlp3UDdHNnhZOThuTG52dEFqUTJ6aFJ3SXRaWFdYcWZ1T3ZBTktj?=
 =?utf-8?B?OXJBYzFKakgzeHl1SUtYSGlIRTNZZnFobEE0aXJxNFBjQWdxMDF0dGVEeHND?=
 =?utf-8?B?aEx0TklXRGJWOFcyU3d1Z1VNZFVPUmo0UFJveW1SUU1xUkNXb2RrcGo0WC9C?=
 =?utf-8?B?L3crcmRBNHIvcnJYYkg0UHZzMWZ4VlM4UHBOSUx0SEUwTmlUd2dFWkFTTTFj?=
 =?utf-8?B?ZUJoaVZ3cDQ4K1BoQ0xzRXo4OU9RRHNZOC9kN0FpanIrakx6dFNZNHpoRjY0?=
 =?utf-8?B?V2h6Z285SDBtTlNhanUvOVZGdDlFTW9EeFVMMWI1U1VXT2g0ZFQrdE9QZTlG?=
 =?utf-8?B?dlJ6NEJqR2dabFJQZWtSbjREWExZYjJMUWhldy9ieXEwWXgvUDlzR0NBdWVo?=
 =?utf-8?B?bGYzTXhHYXZqS05PZEFZMzV0c0ErTkliZG9Ec3JMV2NxWUR2aUhEeU5Venk0?=
 =?utf-8?B?MDNMRkJLejQxTmJsUkdQM3BjakZ0dTdCQkhNVlh2ODFFbDNPNG5mZk9icW56?=
 =?utf-8?B?QUI4ZzVSajBpZ0s1a21URVNsUGg1V0w5QkZGR2h6dDBWQ3k5R3E5MGt3WWFy?=
 =?utf-8?B?VEVGdWNPekp4ZEVSekZISXF4a2c0bEp0VGNET0c0OEFrQ1NNQW1TMCtMczc1?=
 =?utf-8?B?SjJVeWZ0VFNQWGM1bTRGQ050YnVXWTB2OGo0aTFtQ1FFZXNiZ1BLeGhibFND?=
 =?utf-8?B?YXlVTlVnUG1VU0NUWlJLNDlOZ3o2V25yM2JzaVpzSW9RK1JtUUlxMWd5bytF?=
 =?utf-8?Q?PU/FNAvgCPPBm1SbMxb5U6Se8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a372420-cf4b-4d08-4524-08db083857f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 11:50:29.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHrB5DsQdMjalRSO66wMKF7BFtTw8o+T6ifI2j68NyJu02c7JnctnEDeriPV6nTG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4540
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I will fix this

On 06/02/2023 13:49, Jamal Hadi Salim wrote:
> Never mind - of course it does ;->
>
> cheers,
> jamal
>
> On Mon, Feb 6, 2023 at 6:48 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> Does it have to be?
>>
>> cheers,
>> jamal
>>
>> On Mon, Feb 6, 2023 at 5:49 AM Simon Horman <simon.horman@corigine.com> wrote:
>>> On Sun, Feb 05, 2023 at 03:55:18PM +0200, Oz Shlomo wrote:
>>>> A single tc pedit action may be translated to multiple flow_offload
>>>> actions.
>>>> Offload only actions that translate to a single pedit command value.
>>>>
>>>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>>>>
>>>> ---
>>>> Change log:
>>>>
>>>> V1 -> V2:
>>>>      - Add extack message on error
>>>>      - Assign the flow action id outside the for loop.
>>>>        Ensure the rest of the pedit actions follow the assigned id.
>>>> ---
>>>>   net/sched/act_pedit.c | 28 +++++++++++++++++++++++++++-
>>>>   1 file changed, 27 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>>>> index c42fcc47dd6d..dae88e205cb1 100644
>>>> --- a/net/sched/act_pedit.c
>>>> +++ b/net/sched/act_pedit.c
>>>> @@ -545,7 +545,33 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
>>>>                }
>>>>                *index_inc = k;
>>>>        } else {
>>>> -             return -EOPNOTSUPP;
>>>> +             struct flow_offload_action *fl_action = entry_data;
>>>> +             u32 cmd = tcf_pedit_cmd(act, 0);
>>>> +             u32 last_cmd;
>>>> +             int k;
>>>> +
>>>> +             switch (cmd) {
>>>> +             case TCA_PEDIT_KEY_EX_CMD_SET:
>>>> +                     fl_action->id = FLOW_ACTION_MANGLE;
>>>> +                     break;
>>>> +             case TCA_PEDIT_KEY_EX_CMD_ADD:
>>>> +                     fl_action->id = FLOW_ACTION_ADD;
>>>> +                     break;
>>>> +             default:
>>>> +                     NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
>>>> +                     return -EOPNOTSUPP;
>>>> +             }
>>>> +
>>>> +             for (k = 1; k < tcf_pedit_nkeys(act); k++) {
>>>> +                     cmd = tcf_pedit_cmd(act, k);
>>>> +
>>>> +                     if (cmd != last_cmd) {
>>> Hi Oz,
>>>
>>> Is last_cmd initialised for the first iteration of this loop?
>>>
>>>> +                             NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
>>>> +                             return -EOPNOTSUPP;
>>>> +                     }
>>>> +
>>>> +                     last_cmd = cmd;
>>>> +             }
>>>>        }
>>>>
>>>>        return 0;
>>>> --
>>>> 1.8.3.1
>>>>
