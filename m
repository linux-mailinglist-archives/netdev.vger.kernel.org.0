Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A1257CF39
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiGUPey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiGUPef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:34:35 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE32D83211;
        Thu, 21 Jul 2022 08:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V50SiPb/F3m0tpJBzUDyYd7xIsTFJYPJwc52yPUlCESERyfEBxQaChTSjF6IOGXtJeoqvJ6510h62mSJJvNK9hD8aqkQ9SU2paQR6F3SKPntifieWyD5uBA8+JFTTuGh13yiRhL+jlTBC/c2Mhl0RWZrobeZ+gvSFoPGsXTBIP9ys3kMPOyXY0psgHS8vL1GHRw/Zf6B+8BTlEILUvmZtaa4CLghEM6TDNQ3o/ySIQSHRLLyGwViY6mKILjBYpEWBePvpLNYmNIAbVaBN+RlQKQ0eYzNcdv/YdgZqWqgcE0ZMegKgEy18P9B97gfdMvK66oCl7dMmUNdc9hz4B9X0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLMdYSbx/YXTG3LJaZN1WEDbP9qcQhLtSnOw3zOsEPs=;
 b=UlXAIkn0iLq3o8RMB15SY1XaWvOdXLzxSe5DSxFSqcJPWxDyWW8geiCJgibAWjHalSBgPphc7YYtqXQ2DgdeIhKw3waMiYtjuBY7nvwZ8rTDWHQmMOlBL0gWfq9m+tlwM3f4P+oAzlFvFrkgbECUlV83L2vtmDfSDJ8SG71LAxp4fkzExSUyOd3QiG1WPeUPPSXId/8P/Wi/nOgx/kIOKRe2oXLSeWigJ3areB67NDouMQ/rRZz10cm4Oo6/WI9iaQ3zPiW+OVUVWDp3bfv0S3mYw3gfZeek5jjZP9P9Ab4Dabd0JpbyjSNO7kOLezS6R4+M2DrxzQGS6hTbfsENrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLMdYSbx/YXTG3LJaZN1WEDbP9qcQhLtSnOw3zOsEPs=;
 b=hgTzBzRcDoN11srqtbSX1vE8HEhHnyRkk9zhg4zAltEVIpg5aU2+ZiD7uZqHybZSGL0WAZc6DyT0mNO1n+K3Yp2e0I8XYmT4ZX9XDSp90uZm3+BGU9O5V9sFXvIevz8WSzZIVaiLqmwWxZy2zA9IY54UmdCVAsf5Rgh38CqphSB/IOSDJM5He6qYChLbLVkBVOkNctlPh/3Z3D7tQqnInXeBUrBgUVfcSRluSfq/EhAXEQcl9bHhyBsSiK5WUrrDhkrYhWCQScNTtaU2I1MAhVBshCaOUJkLFw6yNo03ViIPTzSsuaxRlLYbb3LjJo7mz/v7ma0WcwjyJ6NmTnbI1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4076.eurprd03.prod.outlook.com (2603:10a6:5:36::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:34:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:34:09 +0000
Subject: Re: [PATCH net-next v3 20/47] net: fman: Store initialization
 function in match data
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-21-sean.anderson@seco.com>
 <VI1PR04MB580745EF94973A1468C9FE80F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <3d490504-c03d-f418-cec2-c976831a224f@seco.com>
Date:   Thu, 21 Jul 2022 11:34:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB580745EF94973A1468C9FE80F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0297.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 002010fb-a693-498b-6bd1-08da6b2e7499
X-MS-TrafficTypeDiagnostic: DB7PR03MB4076:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYNxNTSNIgRDeCQVhxO6I5Si8S0koQ04Q5wEUSHcaYLIQiNfRV9tOnaIbCybq7rrvPDRLTtbiihFmpRPSRwJZzxaMl4uwp0zuftGuMpSA3Fw+AOJvHAddexIqJOz/ABCcen0zoOLxoylA6CoXGz9Tbx6mRWNGRYNv7FZRWkR78mDClBwbCzWnQkp+RaFK32GL4ulUmzkUuCUsKKHqabY7etMqonTU9b7gNLJYcfjPD0QGgl/uFTNpZAwLmz8kPCcpKJFKFq5QpL5wM/VJkrJ/XtqBuicFmLupO08D6ZfgQnsZ7irQtpxWIs/QzSDSJrWbXhz8w1eKv6lKETepPJQT07T4nAzhVwVWFSrsoP21eHCoW6BLlfgHjxAl7cI3/t6n3k722yq8aZkJekRnS2W5QkZPk6z/qKE7/g/2n5DghSvzKRpzzqcr1RzKj8VoMG+tMVkM7mHIGL5i0PZO+XUYvfTxieMd3zL3wB+xoqA4mhfzvf9HArav+KULR7/9jGmGikd0qD8sv5Gz87Y6Mg7Wkp/VCcnWaAhamuDXrYHnidfCdqvnGCjuHh7hZYnIcxvtKDSBYa++2oZCxViPVnJ1Gx8jvUehd2hRkdU6uBYXu0RfhoizUr+uSdXUiTz1vYOdIITCYLfWoTiadk5RN2Id6jVq4ptOa308uYFANzqIbdsNgEjYS55TTotr+TjZmH/l4DE2XkMVCYUidJ31Fu1Kyer5UOL/EGzQuQxzsr36Hu49ANH/Zps9JHfkFvyGzZoW486dK38qdBaVUiVvuBFP8OoQAPJ3lWbzU2lWeLyGG8bh240rIXjG9jhV1HKEQSDRWyEaYF2JpHxN0mNm7VmHkgSbw3Q6ift/xXMUy5AOKZ3tbrWOOAR6/qc2gmx9CEH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(376002)(39850400004)(366004)(86362001)(31696002)(83380400001)(38350700002)(38100700002)(4326008)(8676002)(66476007)(66946007)(66556008)(316002)(54906003)(52116002)(6512007)(44832011)(53546011)(5660300002)(26005)(6506007)(6666004)(8936002)(2906002)(36756003)(2616005)(41300700001)(110136005)(186003)(6486002)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG96OHcwNkRhajVrQi9GMHBDRkRTSFNINFloeGpWdHpIci9uV0kzak5PVUtS?=
 =?utf-8?B?RFRzeUNXd1JFTndjR1UySElTWlp5ejFHRVlvVlB1TXU0TWtFNnJnRWhnVHli?=
 =?utf-8?B?T0V5S0hRSXJlaG92VDhiWURXaVQzR3cxTUF2WXlNUUtZcHNzYmZERlJ5d0lz?=
 =?utf-8?B?L29YVTFnMTB6aGw4ZlJLNGhhalUxbzJNVmVPcHFpMkk2Sk12S1BsbUpsSTFH?=
 =?utf-8?B?aVZXc2JlV29oS1k0Ty9Kei8waVlSTDFZM0xEOWVGMm1FUXZ1bmlCQXQ5bkw4?=
 =?utf-8?B?T0YzU0JVWE9jQjhqVmY5ZVpWSTRzMDFyMDlNbGYwR0xmTWJOajQ0RWJkWk42?=
 =?utf-8?B?Wjd3RTB0WVRXZEVhNllUVlVIOUh3eXZXS3dmRVUyK3QvQWR4QUpSMVQwK3BV?=
 =?utf-8?B?dm9kUEFiN05iQ3dPcmlLemNuNjNwMGllQkJVMEFjNEh0WTdoODg1QWllcGxr?=
 =?utf-8?B?MzhkUUFzanNJUm1kQy90N3l5SU1udTRvYmFYalE5LzJMVzZXM3NEd01icVNq?=
 =?utf-8?B?blYxdjVkRENLQnJFajVXYnpDbWYrSVF6L1h1MzhoYm03bFJOUkNxQWp1YXFp?=
 =?utf-8?B?MFdxMmFINmVvT1BDSFM3Rll3V2xHb3BhazUrcWM0cTdMOXYwa3dPNWxCbGs1?=
 =?utf-8?B?ZXZ1VUhQUlVSeFRVeTVpVHk4NWdjUTJqblF6dGpCOHV2ZmhwazlaTjVJU0VF?=
 =?utf-8?B?WkhlYi9BMXNQbmRoeFZhZndsdklucjI5aUdZckRDT3NYVEhVUm0rZ3daU2RV?=
 =?utf-8?B?aSsyclR2MnlnZFNudGJ1ZHFCR1lkWlJKdlpuU0tkREVDWlVPcFRMaVU2UlJO?=
 =?utf-8?B?LzBlRmRDWG5td25pR2ZwZzlvQkNPQnZtN3pOcWdXbldOYmF4VEx3RGc1c2kz?=
 =?utf-8?B?RGNuWDdyK0Z2S1NWYmczTS9EdnRJcjBwdDlzemdNUlJubFJsWGVUUzZXV1U1?=
 =?utf-8?B?TWZLTElkcE9xV2srTCsreFRQM1VILzFQMExZYXFPU1REVEhzemJjQlQyc2xC?=
 =?utf-8?B?aUpjNVVETVpIZVFWbWNELzViQmhvZDNMMnhtekVwL0ZiRnRUVlBjUTRVanJt?=
 =?utf-8?B?Wm5zcGtKWHhxM2d2ampCWFBsd3RFWE9qaDE2WDFOY2VsWG5oelpFYjNLOTNT?=
 =?utf-8?B?NUN3SkM1SUNISmZOdXFya1RDejNheitET3crK0pIcmoybHd6aGhVc3BGTUtP?=
 =?utf-8?B?ZmZVdHJoVHI3WEUzYUlSSTNsNkVhVXVFZnJjaXZEb1pxQ2RQZTFkQWlLbjhF?=
 =?utf-8?B?Y3ZoZDM1emVSbVZtaW1WTWZ4YUtTZUp4RkIzOCsrRUVuSk56Y1l0T1RheDBO?=
 =?utf-8?B?dU1yREE2cDZibllVajVLNmNTbjdRUjM1ZkVQclVkMmJ2Nkw5cE9PT3JvODE0?=
 =?utf-8?B?MkVzL2ZVQzJQT3lsdEtVNTc1cXh5MFU0UFhmQ3JkOUY4dHZMZmxQdlBYSDl5?=
 =?utf-8?B?K2N3N2hxTGNlaDBYN1FRVXVIc3FzaU1HNlJab2hlUFJka2hsNGdad3dqN2Ra?=
 =?utf-8?B?bUJPVUp2S3MrYVBuK3p0NU9Ya3duYmhOUW50MWk4ODdJWUJyaWhPYStCQXhN?=
 =?utf-8?B?c3FIR1dzTTZiQWN3NFp1NWxkSWNlZVIyZzlXT1lqVTJ2Y0hOd211UmErNVdG?=
 =?utf-8?B?dVhiSkdPbEJrRGQwNHZHMlNueE9RL3FiaFZpbUVZY25wNEZlWE1uOEF6RTBK?=
 =?utf-8?B?K2tyTXdlbGJpMUZQUHh6dm9PaUd4M0sreXkvd0N3T2RHd3dIY3I5WUI2dUV5?=
 =?utf-8?B?aG9iUExQUFB3RlZpck5aNWZ6NHE0bEVuc0RaS3djeGZvOHd3c0IwTU5oNjhn?=
 =?utf-8?B?dS9vRDdLQTBZakovbUZ3c1Noa1hVYzk4MC8rWlNRaEs4dEliUG5NcTU3M2dF?=
 =?utf-8?B?YTJEUXhmaVdPL1hBRVFrT2ZETWpUbkNBNWl1UUc3b1hudXptRGIyeVB2ajJQ?=
 =?utf-8?B?cllQYWc3R3crUVpBdzFDTlpIWDB0QnpDaGNWRnFzcWtFcGR4WTdUK0ZuMVR2?=
 =?utf-8?B?RXdvem1PSi9tTlk1N3FlSkpOUEM2blRqVW1sRy9ocUdLNHVoRGFXVVFCVXZj?=
 =?utf-8?B?eUc4azYwTmlsbDJhS1VNZmdOTDhCMXVCZGh4SUlnSGRKa1Nudy90cXBJNFJG?=
 =?utf-8?B?N3ZGUnFLcUdzVnNTYlVtU3EwaHIvd2lsZFY2TUFaN2srdXR0ZWhOcHZTdk9V?=
 =?utf-8?B?UkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002010fb-a693-498b-6bd1-08da6b2e7499
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:34:09.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYABBiKkquTTJkPXaAMs/HDv/3jqmdmveEo15lD2tRSw+zPMrGnRvsLCHYbsc8Ij0YhM3tYvH9hp1syiybZhnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 8:51 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 0:59
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>
>> Subject: [PATCH net-next v3 20/47] net: fman: Store initialization function in
>> match data
>> 
>> Instead of re-matching the compatible string in order to determine the
>> init function, just store it in the match data. This also move the setting
>> of the rest of the functions into init as well. 
> 
> This last sentence can be rephrased to be clearer. Maybe something like:
> The separate setup functions aren't needed anymore. Merge their content
> into init as well.

You're right, this is not really clear. I will revise the wording.

--Sean

>> To ensure everything
>> compiles correctly, we move them to the bottom of the file.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> Acked-by: Camelia Groza <camelia.groza@nxp.com>
> 
