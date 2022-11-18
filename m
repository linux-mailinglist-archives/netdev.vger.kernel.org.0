Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08762F115
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbiKRJX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241341AbiKRJXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:23:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF2270B;
        Fri, 18 Nov 2022 01:23:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5Uo5CGqKsfWjaH5T8YYsf8ufSy/qLGXonm+tuiuExaf8RuWXZyf80IMQeY5m/0b9q6JqhtyiXE4Q7gBpS+mR0J9eX7bItZmLcN9uhKZNye1+KCNmSeY2Y9D9LcYRbfDE8Ze09eRyzbLyzkHESww04BwqwyLteZ4e9u4hkvODWkT+thcsCZslH+PgTfHCrpA96jLdTNSGT351FA70M97G2RoL8Db/PoFFmphuEv+gO5M2pK+kA/fUfmADMYGSZKUo5jDtgfYJEvBp9soOkfsZqSpxvjQSJH086WkTy/oKHhJ/hHeiqHV2oCmRMHxQiik4a8vFu3xMSoPLqRiPKD3Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZiiosEHrVr1ogifR8orN7Jgbvfj/zSGUsErfbUiP8k=;
 b=PkzNw+go8V8b5Mgezs34lL1d+auNkz0E6WNLae8WjSPmWSWC++mkI3ll1imceyfFr/qS8LGF3/qNYRf4pvNI0fc970PGDm2F4hI5Z2nh7BU6Nx0X3A6GTZvY+SX7+2eeixdBUBI8uWb6IowdIw3BXOd1EjtmHSed90DNBiK4Q7SwKpf+qoB04GtAJzqnr9T+5N8tZzMi8ci8aatGgfbMoDgCHmUlHdrbfylAtgSep52Q+XLpUIo72vBSy95IuVJzggual0UCrNJYoS65U7mNbxKZfn1OqvvPN3RUXrOHR9aXRjP3OLIzcnROCe+MtbGYHo8BFglyBOGsp9OrtP2vSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZiiosEHrVr1ogifR8orN7Jgbvfj/zSGUsErfbUiP8k=;
 b=GewsYnBO/7YmWcMQTYUiXj+imI4tZER4QEsUvaW0V0qc+Gve1q0nf62eKs7mqP8TkeM5G5roLqOytxYAJE0tMv302Gg0/sI+DLfQgiOLu+PG94LRMKdbWp79JAqLpyJqIhuBgkzhjy9qLTXzj7UkAJY3pK/nOWwJFyBkYsnRCsaZuDth0e9AQav+qSFOQRcDk9Q1NJ3B6NtCVQMa514II9pJbyZKkhPLj++e3ebdXtNNYg8pSRDtXGHOU2Xv+rqZ+XQxdpqXh8ZugYKsrT4X1G7Ij/uCPplel+BinOjQ/lsn7diU5cGX3ZcC/XnUf2KF5CMTN/LWYDAU5J9MJF+joQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY8PR12MB7339.namprd12.prod.outlook.com (2603:10b6:930:51::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.20; Fri, 18 Nov 2022 09:23:19 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::8edd:6269:6f31:779e]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::8edd:6269:6f31:779e%5]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 09:23:19 +0000
Message-ID: <fb2d6c81-7c89-dd8f-5e95-b4f5dd654c42@nvidia.com>
Date:   Fri, 18 Nov 2022 09:23:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Content-Language: en-US
To:     Bhadram Varka <vbhadram@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>
Cc:     "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
 <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0381.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::8) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CY8PR12MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c6088ce-ecde-4865-5919-08dac946880c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRvUb+tohtExQzUGkiAD1jI+JpzNu5fKoXE6XqaEZOHZ+AsCfDpQzX6BfLil0ulJxgcdowiC2twVDhgbeOn/c1EzmTNt1in2OWteS2BfTgHOQem5bEe+J+C+A3D9PtlDUrVYW82WC0s1bsZjwbxnjHHPCK4m7/UAEpYiMaf27nubkMGaw+3IJRS3+BssADJw5a+xKcZ2y3+1VxlyRsziIh41/SJlFIM1MblxUTwMTEgG4WJMdKtNjGBYursEYwwu3/Kqf6rWSR/0fbMwRZI+4RGx7dux0GThaVzFXtDO50+QAlcRq5ZMh7XsiqGTD9xoTxHkX/b5u9YwdOdp/aXyRep7LKA1+sf9qCopP1kZ6d4f1MQGFNeXYFA8hjbNNMK40eKMIIfoUHYc78j9m2S88r5gorXXHFgsS8F91WlQ0Azuk6B8BtpmTTGlrUiRTQqHQTGfCHEGogksVtGDVOKXzTnC9qQNTyfCM+AKQmAunb5QxDNkOiy7rB3uOI6qHktwrEyws/hbe7gkWZBTkuMgVfYZRD8zAYVy+SkWUaTX9OXPnTZD4lGdHZfAvYb1+L+X5vHfm0p/H3AiuI2WNk2LFE59/S/fK52exTT3D6FGObDXPv1svDNdBSZ//1g21VLSTl1pXrn4PlIZiYGuP+2NxweH1dL7MMfpzam8CCM+SPaovAo12oYeJwR5IkVXf7TPhq7zXNNl6qQbQjTSpdvhTdrNQS8HbEhrbp2CXMb6UBBNole+yYpAVTYm/KAKuH1u12TreER4OnQzxjRVpvgGoY7Wq6bMz3DMAIh5U/B3hqph6VWtdWt7MKSppm4qaSn9iCkMTN2EqmMPD8eJXt0XPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(31686004)(86362001)(36756003)(31696002)(38100700002)(316002)(921005)(6636002)(54906003)(6506007)(53546011)(6486002)(966005)(478600001)(6666004)(2616005)(110136005)(41300700001)(2906002)(7416002)(5660300002)(8936002)(186003)(66946007)(66556008)(8676002)(6512007)(66476007)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG5DdTRaN0xJREZFMVROK1lkUTRmazcrWTI4S0J5NHovS1FPbkxOZUJ6K1ZP?=
 =?utf-8?B?a2dNd0ZNR1BJZHBPRzVjUEIyQk9WdzlFczM4azBiU1FvWlRqb1hmMGN2dEhn?=
 =?utf-8?B?MWFKMFdhOWQrNDllOXF3VS9WdVBJaHhNaGlHYTQ0Q3d4Rm9nbVV1S3oxTHRH?=
 =?utf-8?B?UG1nTS85MWhZdG5iRFBnanlpMnFTNDVSSjZ6WDRiYytwZXZCWVJoNDhsRlEy?=
 =?utf-8?B?S3Bkcml1cXUzZCtONUVrY2UwY3E4eGxMamgvU1dhOGl1U0RhUW1rdzc1M3lI?=
 =?utf-8?B?NmVNRnRuRVNsa01TZ21XUDlROUU4Y1A5TU1QQUlDZHdzOUJ1Vk5OM2l3RTBs?=
 =?utf-8?B?endyTUJNSmFSUXJLa0Y3OXNWQldWMElQVWxkR3NwUTdkZVo5ZGhmWkFlS1o4?=
 =?utf-8?B?RzJDWWd3bHZsUm0xNjlHbHQxSDNwVVdlRUYyK2tWOWJnUjRJaFhZTUJLVXo4?=
 =?utf-8?B?ZmZTcDBySUxWQ2FDS1hGZ3FncjMxOTFMYnh6aG9GL3RHeUFTWG5oaG5VbTlB?=
 =?utf-8?B?TVhlNEV4Q1FwZWk5UkIvT0UyWWlLVXpXZG9GL3ViMUQxNUd2S2U4RUlMb2xQ?=
 =?utf-8?B?SWV0YkFpemY3RitPY1NZeVcxQ3NHdm4zWXlzKzBVV0ZDUm5FcHA0TlQ5cG5o?=
 =?utf-8?B?dmRHRDZmWGplaTRGSk8yMGNicDd3TWQ0MFpDS09nY2dyR2pJZ3ZvSDNaUUE5?=
 =?utf-8?B?WEwxc1o0KzlDT3JRNDBDL3VqS3RvWDNTUzhITHNLOWg1WFFiZEQzeXN5aXpm?=
 =?utf-8?B?QmtvZ2dUWHFVNjc3TmtGaFZVZjFRQmcweHNsa1NtaDEydng5VXU4VnNLUjhU?=
 =?utf-8?B?eGxFYXN5eUs1bkI0SmxGR2tGNklCUHhCTlFYd2J1cG4rM3lKYkpnRlZUcmEv?=
 =?utf-8?B?dERhck5iS3JZRWI5YmQ2ZlEvZDJ3QTAxaWhSSlpYaUwrN3RDajNRNHUxWXVQ?=
 =?utf-8?B?Y1lFOUt3ZGNlMVRRUVRTMkhSNUtkeklFcUppU2pYaVNaQzZNQWE2eGJPaTBo?=
 =?utf-8?B?d3VUR0JOQlJwK2p0MlBHYmtNYjVMOFYyWDJqaHA0aFJGY1VZdGdtTksrYitu?=
 =?utf-8?B?THVtSGlhYkozcDUyYkFCbFFuYmJFQnVRaUcyUUxiTW5RVmVHdTk3clJ2WEJw?=
 =?utf-8?B?S0U4ZW8wU2MycENYMW5HVE9xODFpcC9td3VvV1RxbDBMdXk3TDhhdUdQVTVR?=
 =?utf-8?B?aFgvNlMyV2VzK1NTbG55K3A2eEJmb2ZVOUlBN2xhQnE4V3dvRHFMVXZENWp2?=
 =?utf-8?B?NXh2L1hnN2RmS1ZXTWJFWEVKMlQ5cGt3WXkydXFROStsWjdsWCtIblpBSlNJ?=
 =?utf-8?B?SnZ5dWt4QWVLUUN6d002TXk3Vm1BZzlWUnFjcXdQMmdIWkhyT2ZWUlpYbndN?=
 =?utf-8?B?QUliejQyVHZTa2pRUUhHd1E0dmJpUjBGWjNGcDdQZHUwYlE4aklKaUw0STF3?=
 =?utf-8?B?U25OTHF4NkhnSVl3ZEYwUXZ5bFJ5TmRuWWp3NnlJOXNBeHM2cy8vdjZyeXlP?=
 =?utf-8?B?WGdwbHR3NnNUVTdLbmF4OEhwL0l1OXEwa2JTOXBMTnIxNXlGWkdkUmVPdnMy?=
 =?utf-8?B?R09JMWxwa3Rjd3ZpK3RnVlVhYklrN3FvVmZ3OC90SVVIWDlVLzVzSWJITTR3?=
 =?utf-8?B?cldnbDhaM3FiOU9NT1pJVXI4cGN0TFptNlRuazlwSSs0aHkzNndieTRqb2Er?=
 =?utf-8?B?NFkyNHRuRGlOWGhvNmF5b2RPVUt6V3lKZFNOQmVJUlJocS84bUhaRkEyNEpS?=
 =?utf-8?B?V1UrMlo0WVJIMW1kOW55a1BoSUhIVjgxWS9RVXJIeWQ0Q2hWWkFobFp1d2ow?=
 =?utf-8?B?ajN1bUIybXZHWE1HdzlvSjRZUkVhSUw5WHZ4QWQ2MStJcjVaWDU4UWJHcFRZ?=
 =?utf-8?B?amZDQkhZZzhxdFdPNEFJcENSdm1qU0JQeHlrR2YvY3NrLzJ6cGlVWFhEQVIw?=
 =?utf-8?B?RjRVSDBBbWYzQ1pWL3NPTzNYeHV5ZXJIdm1nNUxaWWE0dCt2c3NmVzRPZE1D?=
 =?utf-8?B?TFp2dmFwbnFncGFiSTM0d3A1ZWRnT2RPbHNQaXFnQ0Rwdi9JWVlxMWZYU1o2?=
 =?utf-8?B?aUVsN1Q4ZUl3Wk9JUmlIamdWUU9DV0hTSUZGcGlJVGkzbW9HbDVCc2RQRHhu?=
 =?utf-8?B?SUVpUlpSZTZOOThmNDVLbGlMQXVkOXVkWU5uQkhTVlZYY2krTGVJNVFLZE8r?=
 =?utf-8?B?M2UzejAxanVINFVzcFIxcFlPZ08zQWtCRDR1dk4vdk5hQkUrclBxWWUvSGtL?=
 =?utf-8?B?bWV4Zjd2VWNlOEhQMnZ3T2FRaW1BPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6088ce-ecde-4865-5919-08dac946880c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 09:23:19.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXcoZ2pvidC2Mb/SG/AMpSemSdJnRB69hklBfQ3k/7K3BwIXZV09H/xMsSc8QvajOJGNpzLHf8XJmbJJhdYMMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7339
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 12/10/2022 05:56, Bhadram Varka wrote:

...

>> You should be modeling this as a proper PCS driver and have a 'pcs-handle'
>> property pointing to it in your Device Tree.
>>
>> The configuration you are doing here is probably working the first time you
>> bring-up the network device but I doubt it works across system
>> suspend/resume states where power to the GMAC and PCS is lost, it also
>> begs the question of which mediums this was tested with and whether
>> dynamic switching of speeds and so on is working?
>> --
> 
> For Tegra234, there is UPHY lanes control logic inside XPCS IP which is memory-mapped IP (not part of the MAC IP).
> mgbe_uphy_lane_bringup performs UPHY lane bring up here. Here MGBE/XPCS works in XFI mode.
> 
> Agree that lane bring down logic is not present interface down/suspend paths. Will update the changes accordingly.
> One more thing is that UPHY lane bring should happen only after the line side link is up. This also will make the changes.
> Please let me know if I miss anything here.


An updated version of this has now been posted [0]. It should have been 
marked as 'V5'. We have tested suspend/resume and verified that it is 
working. We are hoping to get this into Linux v6.2 if not too late. Let 
me know if you have any concerns.

Thanks
Jon

[0] 
https://lore.kernel.org/linux-tegra/20221118075744.49442-1-ruppala@nvidia.com/T/#t

-- 
nvpublic
