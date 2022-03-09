Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F34D29B9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiCIHvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiCIHvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:51:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEDE150414;
        Tue,  8 Mar 2022 23:50:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cy5GGFEUrjAoPr3txEj75rYP1HldFWyuB0Dg3ireIyiAQQR8CmeHZz1OEl+7t5ktbFFqr994BP85AxE23+pYKcRtCwmfB0nwuyx+bzHcZhdHJcqIrv6dbLyg9h74fl/ZO7D40nMkTAiaqlnzGPrf1LeJptF9mJl7D5vwzcKIiKqDrrSYGm5G5/59bAcF0JYDm5419E3ZZQc0caOJNgXd07xSkApKw8haZk+2ZAiYDD9hsTA28B+VFp4fpwEBmCH2vANsuor1Ihxgk6Hj6yfnXV3jbpE210MWGHsnjDgxkJ+B3VB31G2vUyNhLsnXEN1oZUWjA/DBwww3/KsjCunDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbQZhC2GGtkv8EnqBZTr0Ux24+UwdY/FwnDOSeS9EV8=;
 b=Lpkd5GesnUb+K8ielbDFL9d/sBNNjxUNGqPdSd6x1CxbGmCuSzfxtngmRSPGceX0T6HLu+mdu80VPn8vgrT2aGXSjNx0jDCWCEyf8OmW4vctCzGFGBRoMVW5j9ImTmzGlmPqOmoIbUy8xwI3k/ki1bI3TW8SHv1Eodfysu1wSfZF/jR1BSdhHAO22L5SkIXTyci2oFMQAEWiVJQSwrRPVz3Wkj7NgptFELsflMKS19DADKvDchIg8OtSp+0DRt7is7YMwGrjbE+k9IWBtIluXN5s8X8WuRS6T5xzQf5iYL+lrIpxcWzFrmV0A0ds+dkY3cVeRhXwEj3DorAeLhixvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbQZhC2GGtkv8EnqBZTr0Ux24+UwdY/FwnDOSeS9EV8=;
 b=Tve/5hW1sFGP0PFbNJqQcVSx+nuy87vgRC0fcR8g2QZtM17UcpH+kpVLsOD/vwU/+DwggJHyQ3cmL9npAMghDkqDILW3n/dXqc3guxE7bbfYXJfZLm0caAywhuI1prTVOwlUujYcKUEWVxj8yBdbhfaXuWMJeCmz0x8AL7R+Km6JcFJIN53viPXzmVeNNon2dcoJqUVufPf5jaEoLNCxKRHhPrWta0s4BS58ARGS00gBvk0HSqr7fV2XEjaxOFh2lKxSOMJapud/qPXmCy7QmB79owZV8xNRMXf12fEhQZbJA7LMqXuaO+iiLLeOTDflP0vW9wUEPq/IQesSLQqtrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DS7PR12MB5814.namprd12.prod.outlook.com (2603:10b6:8:76::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.17; Wed, 9 Mar 2022 07:50:08 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 07:50:08 +0000
Message-ID: <81250230-a845-b03f-6600-b716c02f5137@nvidia.com>
Date:   Wed, 9 Mar 2022 09:49:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
 <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
 <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
 <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
 <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
 <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
 <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
 <20220308081731.3588b495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6f0feae8-ecb4-ca1d-133e-1013ce9e8b4f@ovn.org>
 <20220308121617.3f638793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220308121617.3f638793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0234.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::31) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 315a53e1-2b00-435a-cb30-08da01a16e3d
X-MS-TrafficTypeDiagnostic: DS7PR12MB5814:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5814E203B208E6139F6A1D14B80A9@DS7PR12MB5814.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7Ek00ASqswZ70VqFWqM3iiSufVFWxpk9pCdsiAiSXChqYSL51B/pN498FzTmxZvaXyaC4HrBUxE8fj9U0a1mQz46Y9yFj1JdtRUbqT/P3LrsqI1vXEWUMCMiJI23T9t60UcHDsxyUr8AryIdqIoFwDaf+OeV0rDH1VZWBKcS1gX8ao9Z1Nj6KYlnGGmfeVX1mRN72xjgStMCbDhmbrtpBH93rKsdyiPHYwmkBa4x6DuQ0/bZ5rcHStfJJhyp4t+ffHjYEqye9JBZVhfXKsCgDzaSME5xEsi/qqY8ajh0AmXasDCaUiVbBa4ygb7gxeHq1/151XZhCsNCOFBJBIXPpyQ+mT3NSE02Y43dh+nB31ID36G5FavpqfK2uqoBrGPcr23+Q1WCAsBUeJnOMeWzQa4H1MmdbAF0F52K2IXfbL0GdqiLL8G5dvK/PAM4H2blyAkiBbT0+mjPLk4786DI/mPzvd7HhkKCccYZ5xbr7g2XF/OkDMd3oDWIHtAyFIw/y3qet7vM4XfZPHUj70KKyWy1u1crx0OrzOV9TOGGS0sFt2j2Zux2ebCUHvEr3x7HOpKjA3du0BCfM+lolcf4o4hfFO3b0VsTTyQQbSaat2qFTdNxQkLHrRvFWMemBZA5Rtsb7pjQ/gTjOP4MMZbj+Y5xuu8doFNJMZHa2LdMmbTBZ7pLXpMA84qkVUM3Fq3nvSQd+sBByYMackv514aTdXV3jBMyoJ4/QB2AzISuRKEPCvkpnLOBh6A7tNlmzdtIvLg4GXzIf9ic8+hchMT1tQ1tpWCuBbmFvzo1HoOyERhlrKFKWFKVrITINEQ7Ynv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(45080400002)(2906002)(53546011)(8676002)(6486002)(966005)(38100700002)(86362001)(6506007)(6666004)(31696002)(36756003)(508600001)(31686004)(4326008)(2616005)(186003)(26005)(8936002)(7416002)(316002)(66476007)(66556008)(66946007)(5660300002)(83380400001)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXl6eUoyK0JXZVBXSm82WjE2bWFlMVF0NnR3NWdwZnVrRThsMFNBOWZIVHAx?=
 =?utf-8?B?RUlSL3I0MkZscGI4MFQ0Z3F3bjB5dkZMU09BK3ZqU25abDh2MWJFM28xenh2?=
 =?utf-8?B?U2lYUlRNL0pIQnZZK254NE4xVkIvdEhXOHZER3lzbWg2YTYvenN6OWh6eDQr?=
 =?utf-8?B?cUl3b2hROWNYTXR4SVdlajJxdUdNQk5IRE1kamNKRjRja2ttZFdUNDlrS1hQ?=
 =?utf-8?B?ZU5PMHRXWndhNzEwcTEyR0ZRQ1Y3NUJWYzVKVU4rZTk1QTN1aEVhLzA2RHhj?=
 =?utf-8?B?Tm9nTW0zTTNwOWZJclhzY1UvWnJBSGhCdFBrc0FsclUvUVZyNGU5YVF5ZnFP?=
 =?utf-8?B?NzZ2NjN0WUgzOW9JdS9sZ1JMTWNyUUpQKys3S213Mit0THN1M2hlSGQ4OWUz?=
 =?utf-8?B?S01zb3dmVjcvdXFnSEhFNk9yNHZVa0pmb2lxQjJXYmViMHl5U3VNNy9QaTc4?=
 =?utf-8?B?bmI0SFR1QVpGNEJlZXVDYlhWcUFhMGE1MHlUTnhDYjErOVFNMkVobVlWQ20v?=
 =?utf-8?B?b0FhRWFvSm1tdlFkRzd5R3cxUUJuZmJ2aXprYzdFdndmOFVsNzdQcmxTM2FQ?=
 =?utf-8?B?cXYrVmEwTkpSYVdjL3VFaUtod0c3azY1bnpmYmNZZmdQWWt5M3VwelBkUFRF?=
 =?utf-8?B?TEoyMVlteUNZMTdscjFGYW9SVWpNcWNxUWhCQ25hbU9VcGRmRTNrUS9zd0x6?=
 =?utf-8?B?TkVkUVA5RjdTRXBhb3orSGVOVExHOTVGdGJyTldkWUNxN0hDUUZGVU16Wm15?=
 =?utf-8?B?OFJ3TDkvdnZheWsxWGpUYUxMSENkWDk3UEx4Zm1zWUkvWFBiWURtejVsa1pL?=
 =?utf-8?B?ZS9QWmlJUE5ONG1YMi9YOHBNNlYwclBxV0dIdUcxTDRvSXgySWFrVTNFQ0NN?=
 =?utf-8?B?Wjg3ZCtCS05ucm5rZ3NXaGpOTzErUXN5WXI4Ti9kTm8yaGxLRGEwODZ2YTRI?=
 =?utf-8?B?UFMrRFNDWWR2V3VEKytMSGJ2SUFCaTJDWC81SVdIWHBTM3RrSXZSdk5hR1Z1?=
 =?utf-8?B?eXY3QTUvKzdkeVp5cnFpTG9GaGpmNHE4VytXdmNmZDA4bFFvSThWWTYyaEhH?=
 =?utf-8?B?T0U3V0tKQ1NVREM1bCt1VVFmS1cva0xrSWppSDYwR2ZWSFIrM3ZmSjdaUXpE?=
 =?utf-8?B?TWdmRUVqL3hQQy9RWUQveG51TFREQmFmNGpBS2NaaXRuOXVYU2ZiVmZlVUhL?=
 =?utf-8?B?S0ZjeUJjcVJ1NkRrNFEzU21KUXRqUFdac0l1MkpHQmozZnlIMFNUejRpZXFO?=
 =?utf-8?B?eC9MT2RUeTZSeWRkbHZ1NytYSzh4bEJKWlpwVmxud2dEMkF5NUlwV0l2c3gr?=
 =?utf-8?B?bXJsQ2hnb0plbWFjbmxwM05UcWF3Q1RyY0tsTnYyNWs0dkVXK2s1U3c3UlJP?=
 =?utf-8?B?aE5NdUhibVFKRjB0UVVZa2R3Q3gxR0JkWmF6UmM4OTRXMHlGL21SNFE4eGsr?=
 =?utf-8?B?WVpuVU1QNElZZUh3eW5WU2dMNkJwOW9UYlM1cy9CYkQ4YXRmM0wvRXI5UlY5?=
 =?utf-8?B?dEplbi8wS21GVGRKd0kvK0VROG8zR0srejdiMzJZUUhhblJFV1VZWnNqUWFI?=
 =?utf-8?B?L1BsNzFFQ3o0bWFSaCtzc3FxNVNVd0xhbUhTbFBpN3JDM0xlM1UxVWVZZUJ5?=
 =?utf-8?B?Sm9ZZVdiNG9TV003bDQ5K1NkS0Q1c0VpVHlFcnlIU2tzU0JZM28vZStSMGFu?=
 =?utf-8?B?eGkrei9zc0ZkT0lZeWZDWU1wRy9OWnV3NkN4bEJBTmIyZHI4YTJaMjJoR2ZZ?=
 =?utf-8?B?RG1QQVJWemhzbi9lWFNXbjdWOUplRGN0MUUzaFBNdFZmZmdmcUQ0UmN6OVVU?=
 =?utf-8?B?M0tmbzMreTk2WWkvbng2VC9GdUIxSGdiOXF1SzdxNlk3a0RGREhFUWdJNms2?=
 =?utf-8?B?WHdyQ0xPSFBNOWZvN3pWK2J1aXRXSkcwNFBidURFbFhkNGxXb09zNnIzMFNn?=
 =?utf-8?B?Sjk0WjlNUHRZWk41QUxjbm1iQkN4SXJhYkthdFRXblg1OUpUUmJlUEJzY21D?=
 =?utf-8?B?dVRTZEI5R09Jcy8yRWp1Zm9LL3dJTVpFRlVDdm1WL055UHdHVEt6TjJlczVw?=
 =?utf-8?B?b3lFZ3lQazVNYnJSb2xlcEh4bERncEFBNytJVllYR05MOXVIQ3R0K0s2U0FS?=
 =?utf-8?Q?qaGI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315a53e1-2b00-435a-cb30-08da01a16e3d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 07:50:07.9915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBMpHeoZCLhi4SB1THwBBIruxMMTrJyF+6otmv9yhQeMOui/6ClmT88wwuMGnIRW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5814
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-03-08 10:16 PM, Jakub Kicinski wrote:
> On Tue, 8 Mar 2022 20:33:12 +0100 Ilya Maximets wrote:
>> On 3/8/22 17:17, Jakub Kicinski wrote:
>>> On Tue, 8 Mar 2022 15:12:45 +0100 Ilya Maximets wrote:
>>>> Yes, that is something that I had in mind too.  The only thing that makes
>>>> me uncomfortable is OVS_KEY_ATTR_TUNNEL_INFO = 30 here.  Even though it
>>>> doesn't make a lot of difference, I'd better keep the kernel-only attributes
>>>> at the end of the enumeration.  Is there a better way to handle kernel-only
>>>> attribute?
>>>
>>> My thought was to leave the kernel/userspace only types "behind" to
>>> avoid perpetuating the same constructs.
>>>
>>> Johannes's point about userspace to userspace messages makes the whole
>>> thing a little less of an aberration.
>>>
>>> Is there a reason for the types to be hidden under __KERNEL__?
>>> Or someone did that in a misguided attempt to save space in attr arrays
>>> when parsing?
>>
>> My impression is that OVS_KEY_ATTR_TUNNEL_INFO was hidden from the
>> user space just because it's not supposed to ever be used by the
>> user space application.  Pravin or Jesse should know for sure.
> 
> Hard to make any assumptions about what user space that takes
> the liberty of re-defining kernel uAPI types will or will not
> do ;) The only way to be safe would be to actively reject the
> attr ID on the kernel side. Unless user space uses the same
> exact name for something else IMHO hiding the value doesn't
> afford us any extra protection.
> 
>>>> I agree with that.
>>>
>>> Should we add the user space types to the kernel header and remove the
>>> ifdef __KERNEL__ around TUNNEL_INFO, then?
>>
>> I don't think we need to actually define them, but we may list them
>> in the comment.  I'm OK with either option though.
>>
>> For the removal of ifdef __KERNEL__, that might be a good thing to do.
>> I'm just not sure what are the best practices here.
>> We'll need to make some code changes in user space to avoid warnings
>> about not all the enum members being used in 'switch'es.  But that's
>> not a problem.
> 
> Presumably only as the headers are updated? IOW we would not break
> the build for older sources?
> 
>> If you think that having a flat enum without 'ifdef's is a viable
>> option from a kernel's point of view, I'm all for it.
>>
>> Maybe something like this (only checked that this compiles; 29 and
>> 30 are correct numbers of these userspace attributes):
> 
> It's a bit of an uncharted territory, hard to say what's right.
> It may be a little easier to code up the rejection if we have
> the types defined (which I think we need to do in
> __parse_flow_nlattrs()? seems OvS does its own nla parsing?)
> 
> Johannes, any preference?
> 
>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>> index 9d1710f20505..86bc951be5bc 100644
>> --- a/include/uapi/linux/openvswitch.h
>> +++ b/include/uapi/linux/openvswitch.h
>> @@ -351,11 +351,19 @@ enum ovs_key_attr {
>>   	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
>>   	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
>>   	OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
>> -	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>>   
>> -#ifdef __KERNEL__
>> -	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>> -#endif
>> +	/* User space decided to squat on types 29 and 30.  They are listed
>> +	 * below, but should not be sent to the kernel:
>> +	 *
>> +	 * OVS_KEY_ATTR_PACKET_TYPE,   be32 packet type
>> +	 * OVS_KEY_ATTR_ND_EXTENSIONS, IPv6 Neighbor Discovery extensions
>> +	 *
>> +	 * WARNING: No new types should be added unless they are defined
>> +	 *          for both kernel and user space (no 'ifdef's).  It's hard
>> +	 *          to keep compatibility otherwise. */
>> +	OVS_KEY_ATTR_TUNNEL_INFO = 31,  /* struct ip_tunnel_info.
>> +					   For in-kernel use only. */
>> +	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>>   	__OVS_KEY_ATTR_MAX
>>   };

so why not again just flat enum without ifdefs and without values
commented out? even if we leave values in comments like above it doesn't
mean the userspace won't use them by mistake and send to the kernel.
but the kernel will probably ignore as not being used and at least
there won't be a conflict again even if by mistake.. and it's easiest
to read.

>>   
>> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
>> index 8b4124820f7d..315064bada3e 100644
>> --- a/net/openvswitch/flow_netlink.c
>> +++ b/net/openvswitch/flow_netlink.c
>> @@ -346,7 +346,7 @@ size_t ovs_key_attr_size(void)
>>   	/* Whenever adding new OVS_KEY_ FIELDS, we should consider
>>   	 * updating this function.
>>   	 */
>> -	BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 30);
>> +	BUILD_BUG_ON(OVS_KEY_ATTR_MAX != 32);
>>   
>>   	return    nla_total_size(4)   /* OVS_KEY_ATTR_PRIORITY */
>>   		+ nla_total_size(0)   /* OVS_KEY_ATTR_TUNNEL */
>> ---
>>
>> Thoughts?
>>
>> The same change can be ported to the user-space header, but with
>> types actually defined and not part of the comment.  It may look
>> like this: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpastebin.com%2Fk8UWEZtR&amp;data=04%7C01%7Croid%40nvidia.com%7C3f34544168c14459f44608da01408358%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637823673860054963%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=HYfuir9d21MFFxPibJz%2FppfxsylDMLz0CZIOcSCLQQw%3D&amp;reserved=0  (without IPV6_EXTHDRS yet).
>> For the future, we'll try to find a way to define them in a separate
>> enum or will define them dynamically based on the policy dumped from
>> the currently running kernel. In any case no new userspace-only types
>> should be defined in that enum.
> 
