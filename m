Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90BC6ADA1E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjCGJUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjCGJT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:19:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0C787A10;
        Tue,  7 Mar 2023 01:19:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYCFTSHmhz9TIsBbL6UiOj5ZxRXRyYRv89NFu5bU4YqgfrUcgFHcxvYHyNAzLAAhqr7udeRAnl3WWejfmxEKfMGUcfAjk0dNv8xiogO4uGaDpAKfR+78+JXJOrNMY1NLHR9k3wacmLbte+TuM9vFR6O/3MqW1TcINyC72J5o36fE7KVnqU85drGPF+B8s8QA8nnABFUm6nBDNZikxNdRUk61KLbNiF5PmSw4p6d0AqqDvdazyqcoS1YhqZ5T1ZdgbhNdkpw80rgDgIQst7D6jQFIl50NsCuSkF2auXKh1NyQBGfENhPM54zK2A7eUAdm8dTOz5Vj7HqE1fptau5SuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rnzF9QRp6Jvn+VpRJ2Mwr+SCMtKXllPrhGcUx32CZs=;
 b=GqB+KxfXg5gT7l7Sv5Rw0xu6R9b2jHozxsIgPbs30o0uSM4nxTgwgsY9pzkjpjlldkp788blsBfjAyDljNEozAejKCAwVklboBs2A1Jl5Q5NlYhlukm5OTxSf3njtxwGLT9fhSd65OnMfY3glXKz0MJjhPEQ1Uv3efreovOBXZVnKVT8UlkV7NkrYLzPsNJ7F/BfahmZwT1b14QFispI/L/loMgMNvxheHvB2v1n1VzfSitzOhbWf3OwVtIzbgaII/yEDgiDQk3u5shjg32lUBg9uGQ1Fg8ta8pkrcLJLZJj77jQIZCG8TNQVT69yiOlrigem8lzT6k9GnSJTt9wjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rnzF9QRp6Jvn+VpRJ2Mwr+SCMtKXllPrhGcUx32CZs=;
 b=CeAOXVkD4u68LlOVriHSGiTkf1CFbUvQBjg08nn5xxrBas4jarQdLxRirVIad0bGeNXGPAtQ/cPwizTmhSyvQk6uHnHrqgxOYRPLDfV8yJIyxwjUpvwHEpVzvp3t3tyFqj+yszdKorCc3jjT9ynoqQ/7nzbreRVrhha+jWlFq0D4rzwYm03nPGgWEss21m68YnCP9CTJ366RhPAKvZ8u0/xNrlBuOsUl/FgM+C/5b3eNIwAC1AzSgcorYKSIwJKq9iaa7E4bvSaNY6I8T5/A38/TRCcHHR6ZJEAznWbZ04zLWQJYRqsO4rP2OYVcfYIyCgq6Ijulg+9Ct4hTGM14Og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 09:19:51 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 09:19:51 +0000
Message-ID: <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
Date:   Tue, 7 Mar 2023 17:19:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW
 offload support
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0109.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::25) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ad9e80e-d8bd-4dfd-a52d-08db1eed1b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5aK7BgdWLhrbDINC9zUPeZ2it0FAL5kQnonZai7OWVA71omUrEByJ6UAOE8MjFV91f0wNBOiIZ13MZosQRKbNuOnVodZtrUzGrp0oEr+KU7K1FehVlaVt1j+2dyy7Ek7l1k4/BBmG6hB0z318NbvqS5yuscm5p2JWttqZJRch0yIlOX2CdYSJoESYQ7GOzHfVmWflV5P9sn8MQB3plfxBmo9iL+sruRPZ4UiYZX5F7qS+vs45NH8g7nPEhwc/AYCC2rU0uUTZ39NB7J+fiI9EuutAeeNaKVcrzXXWt5IJ2f7gyURZXU6pry/X2Ac4VRTsFz01iYD8kdsr/CDxMFm5Hm1gLsa1UtBP549Zeej4+MQ41klw7QvHTnnNGQfDZHENn7LXTiM7LD5iiTVTknw/FNOZ8DM0OhUdilGi8+aac2mPtXyH1NlImWnqm4fKNiucunwztYFVq81XJH+5vVuWPI4cfoA8upXxSwRs7vGUjgND4FxQ+gZLcb+HAiLVMpWpw9njmw2j6enwdzn/IToJht0Lr9pepquaF8yfW8/7YDARwKQcX2F0R1UKPAfqUgtHtCH9tn9hqSs0cQcdgDFQB/FmmSwZm25cslPayOP1VrlCXdMRPhEbrUWhUWVi2qoX461hswAqo7LHEU/pRVanYmsM4QXMl9rV3EkqMygRuRtXhuBhwWcLBKPlyFcVxbmYwfZeQQ4NZxn1pcfIQ7VcaBnlT+zXBYRT5iWnNtMmwg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(41300700001)(66946007)(2616005)(53546011)(6512007)(6506007)(83380400001)(26005)(186003)(38100700002)(316002)(31696002)(478600001)(4326008)(8676002)(66556008)(6916009)(66476007)(36756003)(6666004)(86362001)(6486002)(107886003)(2906002)(31686004)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2NaNVJEbVFQOE16TEYxdUhXSXF3RDV3dUppeUVTbXNOYkl4Tm1yRHUyUDZF?=
 =?utf-8?B?UlE2UDVyQ0xjY2E5TEhaVHJ4a2xYdFlPS1lMSncrMkU0SHJ2RzJoQjVwVzJw?=
 =?utf-8?B?WmlsaWh6ZnpDUDVtZkNkSTNHZTZ6RTZpN1M4eXlFajYrNmRTZVEwSUhQZ2N6?=
 =?utf-8?B?WGpMWlBObE1HWVF3T3JSb1kzUWlJYnpkMmxCMTZ4RHpZRGxQOGxMZ2FzODdN?=
 =?utf-8?B?R1RhOHpsalZzNnJ2MnQzYmpUSS9yZk1jUVlZVnJFR1YybmdQV3FWbHlEeVVI?=
 =?utf-8?B?OTJBVjVjYVNXTlUxc1VSRUZ1Qkk4UWxHSjBlcitkejJMY3FYSlZJd3Z1Kzdr?=
 =?utf-8?B?d3lNZWdzK2hPaEtKUW9RZnR2MWE4NGpGL3hYYmo2VFFOdVN2NnFaRmVlendN?=
 =?utf-8?B?T0lrRXBRTWl2QVVidzF3QmxjQlo0bVU1eS9hREtRMU9ieDY4dldGS2JBbFNm?=
 =?utf-8?B?WlNzSkxGVHk1bTlleFR0bXQzamVDNnJQV3hmeTFkVVJUbmNmcXdVUWhpa1RN?=
 =?utf-8?B?L0JZRk5ldnZFL1lPOTZaOWRDdERXdXI5K2hUdXdmT3JPemJLMU44Z1d1VGQ3?=
 =?utf-8?B?bVpZVnNWdm5xcDRicStib1dCcHIzMHJxUDVqaTRpZFNhR3p5SnI2YWJPcTFU?=
 =?utf-8?B?b1hLOUVGeXRiS0psMk9VVndZTURTM0JqSTEreVdTeHRub2xQUllKblZpL2hu?=
 =?utf-8?B?Q01IWmI0S2Jwd1AwRWgxS3RrTWV3TjNieVF1SW1GMENwN3VQZDI3RW5WaXdx?=
 =?utf-8?B?YTR4MkdjcmhkclZvMzdneGxLbE91M2d0dS80V2JvUlFxUjY4aElSTHg4RzNt?=
 =?utf-8?B?TldDZTZIdlpqdkhDTjVlWCtSTVpEZ2w0OWM4eXRoL0ZlUUpnS3d4ZkpoN0Ji?=
 =?utf-8?B?UEJaSmYybDNLQ0J6cllwcHRDV3dJbFJaSjFZUVRscUZCMXNEOXovbnc3ei9F?=
 =?utf-8?B?ai9DcVI4ZVQ1bEdXbnJTSzloaHc2MXJUUkV4azJmeWZUSXZhbElHWFA1OXVZ?=
 =?utf-8?B?eWJoaW93eVJCZVJKaHRmZ3lYdWZVSFFPL2cyVWtaZ0N3WVNhUXEvRWFOTzdE?=
 =?utf-8?B?THo3NHRuZVRPR3FZSHptZ0dVRmhsSUFHS2FicjUrSWN1Tjl2TVgvV3NDeDZT?=
 =?utf-8?B?TytCV2lqajU3Z1BIbnppQUMxVFNjbmJkUHptNVNIOVplRTE0QVJFSGVSKzVP?=
 =?utf-8?B?Z3dXUlN4RWdxUTN1MTQydnBCVVhLZDdaZjlnaXFsR1NNZDlBWmVyellIQU9I?=
 =?utf-8?B?a3BOczdEcEw3cXNoLzZlY1RrRFFoaThEajNvZURlVXhSMTB5OUpHQjFxUDY1?=
 =?utf-8?B?Q2ZmaXpxMytCTElJLzZPSFZlOWw3TTNhVjN1WVl1Zmk4YUY4TFUzZnR3SVUv?=
 =?utf-8?B?Z0h2aFRqc3VFVkRoZm5iQ3JJc0hveFRiSCt1TG9KamE4MmxzNjh6ZVZ5WjhY?=
 =?utf-8?B?eDJYNW5ES2FyN0ZJSzNmVHlqbE1hbElDbkV6Rk1tY2ErTDA2UVl6WG1oLzFo?=
 =?utf-8?B?aGljRSt3NktteEtEeWhmL2pIRCtjdFRJYlhKam5RQzRKSHpMNUMwNFI2d1Z3?=
 =?utf-8?B?em9TODAwSDJuN0xWenZhYjdNQUJqelJuOFNzTzR3Y3NCMjlRNEpwNWlic201?=
 =?utf-8?B?bWkvMEtGUzBiRkhDMk9vYktHZDJwMFdqVUY0NmxXS0dKT1JZeGE2ZmUxOW83?=
 =?utf-8?B?NmxPUURiQXIzZjFheVJ1emFReTJsWnl0MjFQSWJsS0FXU0t6NkpGcU5ONnU0?=
 =?utf-8?B?akRRMmNmMitnc2ZRZC80elhtUWc0QjhFR2dDS1YycE5XZGl2SlZSUG9Eek8w?=
 =?utf-8?B?Vno5MGFRbllQckxrSUdaUVlZblUrdkVIVmg3TTQ3elZsTzhHMGVmU0FlSHFo?=
 =?utf-8?B?L2tNZEMzNzFxbUJWeWhjWmVac3p0cVM5OTZ3WnBrSVpVYzNZcUNpeStVMHIv?=
 =?utf-8?B?ZHYxa012SEE5WlVEd3lhYWh6bDB2SnF2eEFjcVE5bzBYb0ZyNWdPaUlHMXpE?=
 =?utf-8?B?M2RBeHArcTF0Ty9UYVJaRFhXMzJUbjRhV01xV1llT3RycldNWktrQi9hUFNI?=
 =?utf-8?B?a2VkSFJYTUVLR0p2cGZlMW95TVM2eXpUK3Zpd2JyTnZhVWNuZzJRVDd0ZzZj?=
 =?utf-8?Q?Uclgu3vN9gx3MVHCHVFpfRMzC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad9e80e-d8bd-4dfd-a52d-08db1eed1b09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 09:19:51.5256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXH0cHVgMM7IkffirpU0YNWwxE5pgA9eb5QQnP9TNBu7bYwDl3G8olcEZmSM6KxR8szV6p6MxuH32R+p2EuG4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/6/2023 10:47 PM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Mon, 6 Mar 2023 05:02:58 +0200
>
>> Patch-1: Remove unused argument from functions.
>> Patch-2: Expose helper function vxlan_build_gbp_hdr.
>> Patch-3: Add helper function for encap_info_equal for tunnels with options.
>> Patch-4: Add HW offloading support for TC flows with VxLAN GBP encap/decap
>>          in mlx ethernet driver.
>>
>> Gavin Li (4):
>>    vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
>>      vxlan_build_gpe_hdr( )
>> ---
>> changelog:
>> v2->v3
>> - Addressed comments from Paolo Abeni
>> - Add new patch
>> ---
>>    vxlan: Expose helper vxlan_build_gbp_hdr
>> ---
>> changelog:
>> v1->v2
>> - Addressed comments from Alexander Lobakin
>> - Use const to annotate read-only the pointer parameter
>> ---
>>    net/mlx5e: Add helper for encap_info_equal for tunnels with options
>> ---
>> changelog:
>> v3->v4
>> - Addressed comments from Alexander Lobakin
>> - Fix vertical alignment issue
>> v1->v2
>> - Addressed comments from Alexander Lobakin
>> - Replace confusing pointer arithmetic with function call
>> - Use boolean operator NOT to check if the function return value is not zero
>> ---
>>    net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
>> ---
>> changelog:
>> v3->v4
>> - Addressed comments from Simon Horman
>> - Using cast in place instead of changing API
> I don't remember me acking this. The last thing I said is that in order
> to avoid cast-aways you need to use _Generic(). 2 times. IIRC you said
> "Ack" and that was the last message in that thread.
> Now this. Without me in CCs, so I noticed it accidentally.
> ???

Not asked by you but you said you were OK if I used cast-aways. So I did the

change in V3 and reverted back to using cast-away in V4.

>> v2->v3
>> - Addressed comments from Alexander Lobakin
>> - Remove the WA by casting away
>> v1->v2
>> - Addressed comments from Alexander Lobakin
>> - Add a separate pair of braces around bitops
>> - Remove the WA by casting away
>> - Fit all log messages into one line
>> - Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
>> ---
>>
>>   .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
>>   .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
>>   .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
>>   .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
>>   drivers/net/vxlan/vxlan_core.c                | 27 +------
>>   include/linux/mlx5/device.h                   |  6 ++
>>   include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
>>   include/net/vxlan.h                           | 19 +++++
>>   8 files changed, 149 insertions(+), 51 deletions(-)
>>
> Thanks,
> Olek
