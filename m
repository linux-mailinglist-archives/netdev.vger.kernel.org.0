Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70514C9C19
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiCBD0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiCBD0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:26:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0A64A3D1
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 19:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dC7e+Xd88s6llyJuUud0s6amru7WllKVwH34u8qTRbcU6qvR21Ia4wtBJdnPrJ7VdyTd8wLbGwTkAcjwmesG74NUT/uctyi7gx/Kj6fSzfJy04ogvNn6NtzsfEdAzybKffs9spp6BY/WKfLYn1zvln/yj1XbEIGMKP6atMlmSc9snc75XM/+Y4D67EM7jFSf84DdnM2WDF/R6cuibZo6zZgecv6jTq7KmHYkgRlDvHXaWeC715aE8IlqjSXfN3n6lrL8CTb7TnJQVJFtDCrJO2P4athFW7QBYsZUrWAZfHRZeMAFYe45Qs9w3i/n+VGfHl9ooQgh3O+MsFMVKB87DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fx8dLzHN1arnM+XUw84dgYsCh5y6o5GFu6pASQ5j6o8=;
 b=Vzqf61xh7bfrkcsfx5g/xVpk97/mPYK8uN3Yxmku6GJIgtt8++QXAWPKsa21z+16L9EEmUJvq3zUf5POnz9LiDvc7/+LZjiE2IkKMLHqK7ruNejflpOG0a6dRoAWa9bcgRfDoin/6Jqvp1NA7awGCXrq8Tj+fQgPdt9+fvENCmwIjq5pbrLqdg+5K67aeZ+6vKRrJYPP3DDa8ZTjjJyeeETjDyXQVnzQMg6yPM22g1zJS3tn80WSm99KueEn8WCaKmUPlSz0VaxrJffSPimxThxl+3RIxfb/TkqXfzfy6DM2ldgdHU2+qIJPznQVen2BD1iwWqJ6ClJKKuXliJ0s3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fx8dLzHN1arnM+XUw84dgYsCh5y6o5GFu6pASQ5j6o8=;
 b=Kl+UpU+OnU787YgWc5RjnGSmGmU2eZ0954oJki5GWoa/TC/P1IU5JMXbWWldQJHJAeV5IrhdKuFs6R5lP+uVwYY31mUv43Xw9NVpJY8woEVyjJaLmeeOPEfBRSR6MQ033v95Q60MvqTMk0pFZzL1TTV6iOxmU6xj9TIfmePECve/7NT3ijd0I0Qdt6CiW+QeQtXka6AiY81CGOT6kNXESytn/ifw6L+0UIic1lC0sJL+87Q+L9mQBC0n6vOdo9zS3A1pn0jFBVoT+LjNqQcXEfjFm922C/E7xLj0sTKboVJz90oAJmCBGcUqX+hqeP0pJ6oEfXjAfiwzyMf4iaHkLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by DM6PR12MB4283.namprd12.prod.outlook.com (2603:10b6:5:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 03:25:47 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 03:25:47 +0000
Message-ID: <2e9a48b9-66cf-3908-7236-4e81be0dcecb@nvidia.com>
Date:   Tue, 1 Mar 2022 19:25:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <Yh5NL1SY7+3rLW5O@shredder>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <Yh5NL1SY7+3rLW5O@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0160.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::15) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 680338b3-302d-4899-4dce-08d9fbfc57c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4283:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4283B8E7131CEDBACB58AEBDCB039@DM6PR12MB4283.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DKU0w6b3VYYC3RJ8grcbRvVRP8+K1zP3V8fQfI7+d8E0QY305+xKiouGTSFbz1jqCRVWSXgAwPyI6fu2gCwZDJ0Z9abSvAEI+NEa8lJjUsl9jW9f9fI+VVp0Dj43s418c/bkRg5ecz1lO7eU1veU6R8KhexuLXT+Ab75ypo2wDFUe6TFBLBqEYSGR9Mw0uInPsoR21hc/tv0wLAgnNY4a5aWIIPMprsKXpXO2oPzwpj0EDBF7aYvszOCwKw5z9m1nuSt4VY9odYp5IplWPim4mGF/jHTbCOkutfhumlVBEMNGDbuhTkZjE+yHK6kRK8V6Ffps6u2RRIhr83oq+705ie5xe2XCRlqcK8m9r9eBYz1L/c+tb/hnH3Mofq1V0jhPnyLMSLLKZyODxYlKZdymYrdll6eQJgAa6fLAwPzhmQS87pmuECd5Y0SLxXjwauzzjg+5LJOT49mU8F2dgdRXZmQRPPEYinmYYFqGGZ3vXuPM2VRThRw7beA9lriRhO6rgNNktjjKGVKJMIxAEUM3po8Fs6xXvtKdditWA0iKZCJVQ3XcRGZExMA8vAReMEZtsx/4xZ/YJqg0qLq7CikERvIA6zLvJpZQEXHaw6DxRuTUltSI1/uUcFgT8VRT+gWiTEPCwLfeHUtvgil8GYS4Ov9SGmslKAGVCWGzLnHkkeyz6PkCCWjQrvamKGkPyjghjzbvDJr0UOvNX7jSSzZJSOthKKER5P50X+q2gcNdy9o39CFBGJYyWO+VJveEdfc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(86362001)(5660300002)(316002)(7416002)(31696002)(66476007)(8676002)(66946007)(66556008)(4326008)(2616005)(2906002)(186003)(26005)(8936002)(38100700002)(53546011)(36756003)(6506007)(6486002)(83380400001)(508600001)(54906003)(110136005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1NGaytEV0VzYzVNeTY0c3VjZkVLd0pINFphYStISEZ2Sk1Qb1RQTUNWbFRh?=
 =?utf-8?B?cXptUldTYkVLVmlONmJtKzZQcitEaUI4NUlQYjF4MzY1eFhMOVQ1N01VTEtU?=
 =?utf-8?B?VUdqaGkxSFNFcFRtRHlaSUlkekJmOG92UU82b2FyYmFvWUFGZFFQdy9UNHc3?=
 =?utf-8?B?TlRlOVNPSDRKdWlWTm1nazBwVXl6dkpHd3o5NTBTM1FGUENFZC9sMnJMNjZT?=
 =?utf-8?B?dmJnb2Z2WXpGejJEcmcwRldDUjU1SzZhNEZQV3RyVHliMEd0K2V3QXgrWWNT?=
 =?utf-8?B?U0NnVnhwL0MrUm1pOWpJdnlZNllDVmpscmdaVWx1djAvcHpsdVM1YXlUK2d3?=
 =?utf-8?B?M3lhNEgrdlFTYWVuM05EaEdmQ3dUVzRMUi9TbW1NUjN6WDZXTk0xTnVpaUJr?=
 =?utf-8?B?ZldjVU1GN3hLS2swYW1ReUlIT1p3c0ZadjJZQitoVFpFNFZYK2xlMmZHQzFj?=
 =?utf-8?B?VTdvcFBySVNJNUp3Qm5KRGRYdGtmRWNQdlZheTVBZE9BM3BoN2szbjNlVThE?=
 =?utf-8?B?bDNDNStmK3FZR0cwYUlXdUtCN2FhazhQVnhxREdUeE1jTStpR2VHOWI2L0t4?=
 =?utf-8?B?K0ZpbkhOWkpvdFVyVkhEZTl4bEdycmdnZXhaNzRWM0xwZVNzWDRaUCtUUXJJ?=
 =?utf-8?B?WWd3VWd6QkZlZDE5NGFOaTQ2T3ljdHpxcVJWSGNkODVUNzhpdUpZekNHa2FN?=
 =?utf-8?B?N1hLWDJVeGhWMlMrR3M4ZE1WVUlVSHEyU29TRHJNYzRORHFDdWF5Mmk3c1Q2?=
 =?utf-8?B?eE96SlJNcmNzcXJoVGFJanNBeFRUbXR0ZzZWTUplZkpvZmQ3a2EwajN4WWdV?=
 =?utf-8?B?M0p3NVlrZm1wWkVleXhybXhYUmhGdDRsRlpkbmswbVZoaUtGbFBXMlJ5Z0VR?=
 =?utf-8?B?VWVIc0lvUlBUVlB2V3JCVVdPMFErNTdIbDZzVVB5Y0V0c2FmVUl6MG5tQzNj?=
 =?utf-8?B?dk1JL3BSR2syN1V0VDJwVWFDaE9zN25NczYvSlZ2eFFxbXI1T1kzQjFENnl0?=
 =?utf-8?B?K05IVkJacWRNNHFJOW51NldmUWJrZTVSZU5ZU2ZySm5lczR3eU01K0pMOVY0?=
 =?utf-8?B?QVM4UEJsT0JwM01UWEk3SWVTRXJGeUFXUXdzL0RQYmVBekFEQ210UnNDa1dM?=
 =?utf-8?B?OFlxS1c2MFVFL0Z3NENsSG14ZWttWE5HSTJwVnJNWEpXRWZ6MVlqeUhFZURh?=
 =?utf-8?B?dnpRSXJFMVNVZHo1Y2xEbHRYTmlqYVRHQ3BIUkJZYktGYzlFMmxNUjJlaDVn?=
 =?utf-8?B?QmVBZk83OHZvVXZ4Ti96V2hqNUFCZkMrSlZZMTlNQWJVUWZTRVkxaDRLd2pF?=
 =?utf-8?B?ZCtuWUNsTUZwbjgwOUlqREQ5SFYzUERYUUQzNkVuUE9hSnp0RnBDSlI1aWg5?=
 =?utf-8?B?VjlrcjVpMll4YUVQbE1rUEZZakY0am5kVExEbmdndHUvMW84QnFLL21IUVZW?=
 =?utf-8?B?SEdRNWQyNzg1OGx6anliczlFZkErLzVwNkdaSnljcm0rYmw3MFJXY2x0elcr?=
 =?utf-8?B?MDE4VklhaUFLd0g2bXowd1dLRDhSUnR0MURMRlhodVdJTCt2akRmSkU5c05K?=
 =?utf-8?B?UFVUSTI0VWFKOXl3QXdQYzRXbGRTdmhpWllQNUJ6YW5sUll2elFXamdsZzYy?=
 =?utf-8?B?QjFLVmJqbkZoQi9ldnFzRk9xOFRjcGU5NjJkM2I2M3VoZnZNUHB0NC93R2gx?=
 =?utf-8?B?UGR5Mzc4clpyRUcvYXpqSVRXdld0OWZTWEQ1TFFUeHNteE5Sa0tFMkVlam9m?=
 =?utf-8?B?MWZkL1hUV2VFZ1VOSkpiajdoMC83bzhIeHpyZURoZWEwWHBjajBGaWdtT1Bs?=
 =?utf-8?B?Q3lCS05hMFJTb2tteCtpc2E1V1VKYXNkalJ2eks5QSsvZ2hZajErRHloNUZT?=
 =?utf-8?B?U0gwVlRGcUJXT2UvRHQ4dzJmK01FNVFDUXk5R2crZ2d5c2JndzZXT1RFNDYw?=
 =?utf-8?B?c2VBOXdvY3dObEwxZk5IMFZkWC9lSVpEMEhTNDU1RzBEYVMrZW95WGdEZ1Rn?=
 =?utf-8?B?b0NyR2JIVTY5Lzh0ZzR1WkFzOFBzNGpnMXI2dFJRWlYvK1NhWW1pS0d4Z1lw?=
 =?utf-8?B?U3FhMnZmZW5tV3BaMndXcVErTHNWenZYcTJ6NXNJMDdoY2FJd01zT3l1Rldi?=
 =?utf-8?B?bGoxdUcraXNaY1RLd1BIdFBlbUpqMTBZZXBWSy9SMmUvRWNxWTJ0TFh2M3Z0?=
 =?utf-8?Q?Puw0825KIvkOVO2khtoVi3s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 680338b3-302d-4899-4dce-08d9fbfc57c1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 03:25:47.4127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETmZWoy4pfxvk7/PUFEUJzAjDW0zT2Vl+plSpbeAY/9c96MLnv0NSc/uI7JFV+u0kPSro8U01wRat+X6OCezeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4283
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/1/22 08:43, Ido Schimmel wrote:
> On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
>> This patch implements the bridge flag local_receive. When this
>> flag is cleared packets received on bridge ports will not be forwarded up.
>> This makes is possible to only forward traffic between the port members
>> of the bridge.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
>> ---
>>   include/linux/if_bridge.h      |  6 ++++++
>>   include/net/switchdev.h        |  2 ++
> Nik might ask you to split the offload part from the bridge
> implementation. Please wait for his feedback as he might be AFK right
> now
>
>>   include/uapi/linux/if_bridge.h |  1 +
>>   include/uapi/linux/if_link.h   |  1 +
>>   net/bridge/br.c                | 18 ++++++++++++++++++
>>   net/bridge/br_device.c         |  1 +
>>   net/bridge/br_input.c          |  3 +++
>>   net/bridge/br_ioctl.c          |  1 +
>>   net/bridge/br_netlink.c        | 14 +++++++++++++-
>>   net/bridge/br_private.h        |  2 ++
>>   net/bridge/br_sysfs_br.c       | 23 +++++++++++++++++++++++
> I believe the bridge doesn't implement sysfs for new attributes
>
>>   net/bridge/br_vlan.c           |  8 ++++++++
>>   12 files changed, 79 insertions(+), 1 deletion(-)
> [...]
>
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index e0c13fcc50ed..5864b61157d3 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>   		break;
>>   	}
>>   
>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
>> +		local_rcv = false;
>> +
> I don't think the description in the commit message is accurate:
> "packets received on bridge ports will not be forwarded up". From the
> code it seems that if packets hit a local FDB entry, then they will be
> "forwarded up". Instead, it seems that packets will not be flooded
> towards the bridge. In which case, why not maintain the same granularity
> we have for the rest of the ports and split this into unicast /
> multicast / broadcast?
>
> BTW, while the patch honors local FDB entries, it overrides host MDB
> entries which seems wrong / inconsistent.

+1


