Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18ADE4D8BCF
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243871AbiCNSea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiCNSe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:34:29 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A822655E;
        Mon, 14 Mar 2022 11:33:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9wz1hu4d+VT+UiwhFr7mE77dUj0NspPtomCChoo/z7sYlXI0kGRRN+FXy+72RpRVqZ5HcOq8zd9Ml00MpTXa4NpQoG1vvR5QCbspfTbSJnj4VEFnQ2W8af50rRyVcySZYoryblVF30KYVEa55I3Jui8i7TQcEbeY6emBvr78UxjpJwfysdgv3UhlE/BX6VttDNjt58KFm7oBhd3XDrjqGOYUx5b7sfnP2QBUB05RgMC5tUoeaeDqpntueTGuqO66sxvGeSZyJji4vrPaffR9uCPQd5pfF9KnJjAfMcH1B0c5OIaHQP48TalJODR+7/aYcvOn0ste8n0G7WjZIav+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQfg2FJIyKz4HLb9WpW5/dmxIcOZNmxmScvf4/7fHNs=;
 b=Q5gpUHlZMEjGSse7zO5YlA6LDEf7rpw3xsD4aoLcaOPy29z7kikHljdz/RHi/XCmpTwXg/qgKO3BfNUzpJFEI56sMivF1XicYG7N6aFR8oXuUxQgT3SabXuq+UXM21817V9xxgXyenCRQp1ZhbuI+7Pgl7MytvHjs5kinGSRllpJVNwGHzSI6biCDKc4+IjDOtAJzRYJR9n9E7bXKmS+MBzPx2samXuW384eXOFqCfob9hKk3s6Q3Y+uL6QQuRm072xOys8crzd/tvp7KqbFReCHu8cIwWU3SohwH6Mn+X9RgjkL1+7VqZyjOOrj3qqQekfIN15PImfaLBMdAR5R1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQfg2FJIyKz4HLb9WpW5/dmxIcOZNmxmScvf4/7fHNs=;
 b=dmNmWfN832y0s8RDKgwcDexWHxi0HHTr/B+4/HqXdAwkNFbKWvxyG9IQ7e5jVg2pcMbztTqeAP7+BZ1v8dn/cs86jifTTFQ0Jhse6wkZMFa4M7x+ftygHx/AR6kQyCU2ZH5x2+Spw+e9pjvX4M3sdt4+KkC2HIWMEudppFvPsicNRpt8Vwk57jQp7rqVGoTBkfTm86DydAXFvfIRD3daOjkf0Tq/Y5IcHlMDcyMBUbw/HexqLrQs61zvJhIUwqjQ1qMTXWdglIywnif1PjS328ZP0TSqgMO0K/bx/OreydGt+fEBkrentH6CE4t3RJwv5JaUjeiJjMl6+HzBpzIEAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 18:33:17 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::d812:d321:525f:2852]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::d812:d321:525f:2852%7]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 18:33:17 +0000
Message-ID: <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
Date:   Mon, 14 Mar 2022 20:33:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101
 Thunderbird/99.0
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
Content-Language: en-US
To:     Aaron Conole <aconole@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Maor Dickman <maord@nvidia.com>
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <f7ty21hir5v.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::16) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e51c2d-4633-44eb-5c2f-08da05e91b06
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153D18D02BE3EC70E5BF934B80F9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0rgkdLmuIh8fl7g7VhLCX97dwX2CavXa+rWEUjqze9UAo113YHA/EJdLpd5zd0/m5nEJpSRRXowQQ5m4Vh9OTF8f93+lDCjDcV3REMISRapaNkBZU6CvO1Em5e+CTZjdoPzYBwWRVswcUBWHvMkYLbCHt83mcwRARlkfnt0zG/x4/zlWLrKhwLJ0sZFk2W+UHmPt/Rhw8f07WafNRgtB1N3EnwwoLV5T4xu7awJpE4rhze3NA8KaQjy6vZGCMFUtJ/HmFZkwNMYS9V5JylugRcYLcKOhLNadEkAH79gQeB8sH/WNq71OAU7ssRBYZ/qn/3Y2H15cjWuI323BUbCUE2n42yLNrARo8xn4p+tbCs02M7fgldjemxpytEl7PkajDZJP+n46hNhKrTB5eAOzgnwq+U81g273f93zkUTGC2gBLXoAmqma8AMDO9JqCO1IKCefI4Kve1Or8D/iK8NktfrfHdsxOcs32hyzsC43IXfDM9xL/jZF8P7a8VXMNREvhRoNqPSSiwPvqrUMS4WIwnP3GdTKNvd2DoN6dzQM9R2zETg1zw1eEOedSCU/zdEvJwcVzmneLgKi45nUoEuYSzAKl3jaPaU5xqzegCDEesRDA+H858mXb2iEDerTJiip+hfmXwnO2GelvF0IjtVLIklhtIfEh6ml5sAztMkNyBEXxBhHqWOvI3YBf6orofu6g+brj1w/N8Y6jxwU77d1r03QMSFASjr48sKz9IFx/GC9vdraCp8vwfWaPXGx9EFZzXH/gJDndk1Z+PVig9ZiByi4ooR+nXwRAw6EWnex5l0oejvJjVN9a/3vzumZ9HUmH/IkQkchlXK0SFCJsZzcyf+vOS83OhjXEXXLFEq4BM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(66556008)(31696002)(38100700002)(107886003)(186003)(83380400001)(53546011)(6666004)(86362001)(2616005)(6506007)(6512007)(31686004)(26005)(36756003)(66946007)(508600001)(316002)(54906003)(110136005)(66476007)(8936002)(6486002)(7416002)(966005)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amlzZE1mdGFHQlhNYzMwOHlkVm11ZFhDMkdEZFordWFVR2UxcVJEWmIwWG1B?=
 =?utf-8?B?ZXFVaW1vd0FvM3piS3dmaGtHNkhaZkxFQml3VGtkclVUaEVlaDJLT3FWM1E0?=
 =?utf-8?B?cDcvdHJNVTlaZzRpTHM5SFpBQnpXZnVUTHBkYWtPUkVpQUtmaFoyeXJ3MXlt?=
 =?utf-8?B?MWcwTGNhT0VLRWV2RGhOZ0g1bWwzVXBnR2NQYVJpK3l5VzA2QkdaeHJBb1pR?=
 =?utf-8?B?Qmo5SFVqdElqZmNXSnhleVJaNEk0M2ZrK0dONGxySnRSazdzL3EyQVdieHZC?=
 =?utf-8?B?dGpESi9NaUNUSFhQMmpmcThrL2JKeW9ieSt3LzVkYXVtS1A5Z0NEYkhYNXFZ?=
 =?utf-8?B?ZzAyOE1uV1U4MS9IdWRpcTRxNHVvaDZmLzJRZ0Z0ZW41OU5Vemc3NU5udU5V?=
 =?utf-8?B?cTVSSHZIR1U4cS92WmpiV0p0c1FmMStaVUV5MURVQW5jSEJQeG1ldXNGbUtZ?=
 =?utf-8?B?Y3A0ZE5hK2F1R091UkRPOWZrUkpEOFZETW81bzFHakVXWmtuOFpTTWROQnlu?=
 =?utf-8?B?dytERHZCeGdyY3ZpU1NnMjh4b1NYSWhqMDhyMEJpTUEvSWJET01DcTJkYVgz?=
 =?utf-8?B?ZzRNUGs2dmVqZ05QNDA2QUxERjVpZ2RUbDFGRUdkMC9nSzFOZDlZU3NVcEo0?=
 =?utf-8?B?SGdqeW55c2F5cXJDOWgvRjdpNXJId3dJbkttcVRGOFB1ZWVMNkVkWU1tVFJp?=
 =?utf-8?B?djVyK1RPTUk4SHM2Z1VkWFdLRUdhRXJIVXpXYkZrUXZoTWw1enJKeDB0QS94?=
 =?utf-8?B?eUVseEdpSVRhNEVZek9oOHNGc1h5Ty9BQzNFQmE4TitTa3NCV0R6aEp3VkRw?=
 =?utf-8?B?cW8wWVlhTm1yTHVmUW5ldWVYWlFQVDBqUTNheFF4NzdnU2xydlE5WHJwaE9x?=
 =?utf-8?B?UmptMGMwMHM1MG5Ycm9zVWN3OUR6c3BQeXU0TUZtM1pocG1vVVA2OEZkZ2hU?=
 =?utf-8?B?c21tRjRzQTdpK0g2aDZCNlhwb2xySnpLWEQ3cGpZa3pHYmpaYXFBUGpLd0VS?=
 =?utf-8?B?MWxyQUJjdm9YNnNjaUZMK3NLWUpQUnovcjVqdUZSUnRRaDAvbHFGNDZ3cStG?=
 =?utf-8?B?dGc1YTZvbk5pSnNIT0xhSEZBdWRMbytaYXVqMEtmRVVpWEtCaFFPNWtJYzJT?=
 =?utf-8?B?ODF6QWFTYnBYZEdwOEZlc2VianNaT015c2haOXo3bVRWdXc1LzBqNWZydjkz?=
 =?utf-8?B?ZlJPYzhmT1lPcUNyc3R2NmhXTmh3TmtTT0YrOUdKTmZNbjh4a1VKWlJ0SHoz?=
 =?utf-8?B?S09HV0lEbXorOHZ1YWFnN0JKWkpFQ3A3VzZxRk9xQm0ySitIQVVNdjlmc1g2?=
 =?utf-8?B?UXVjRHlSUTdIQ2RDN0tCVDdwUUJvU0N5RCtVd2xuR1g3dEhPOEZNc3pmSUw0?=
 =?utf-8?B?YktVWVZoR1AwZHVFT0pXWE9tc0ZEVUVWQXpNSUVnV3dxYjJkcTR6ejdGazJn?=
 =?utf-8?B?dUdWMzNhZGU3K0haNEJCUUVZTDMxRWFGOVgzV1pxTDNhUzRNQ1FLODJxSUdW?=
 =?utf-8?B?L3FJQ3VEWVlOTUQvT2xtSHh4YnJtQVpMbVJHbkphbTByRWpjbG0vV3FnR2E2?=
 =?utf-8?B?Tmk5UldJYzNaU2xaeC9XQzlrMHJBcDlOVXozNHlvWmM2d2gyMGU3RDB5K1VQ?=
 =?utf-8?B?SEI5OUY5SERmMWJWU0hwVHBXMmh0UnVsS1l3Ykd6TFBXWkkxMllranBZYnZp?=
 =?utf-8?B?Lytod0RlaUcrdnUwdjMzMzAvRTRnMjM5VXg2czI5TUhWK05BSXBvaExoaWp1?=
 =?utf-8?B?aXZUQm9zYWs2MHQwRndDN1lTcWhMdjN1SzFqYXAxZXNyTEIzM1ZJdG5JQWZD?=
 =?utf-8?B?MWJtMlZ2alBjK2VJRmxhZnUvVG9ldVNBTStud3hReGtYRkRQOEV5NGZGbk1N?=
 =?utf-8?B?RnZCa3daMkFTL2lzVWJ1dUt1U3JmcGIvc0VaeGx4eFl0Y09zQ1FRWUpidXps?=
 =?utf-8?Q?PIyecXuXYav7yfEUJxdKTzV6sQzT9fg+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e51c2d-4633-44eb-5c2f-08da05e91b06
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 18:33:17.1528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGU2ZzvECreoC3VT+/KqsFLSeeipHFMQrWLO/6QnkII7U3GsVXZulJPdB3A9Md8b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-03-10 8:44 PM, Aaron Conole wrote:
> Ilya Maximets <i.maximets@ovn.org> writes:
> 
>> Few years ago OVS user space made a strange choice in the commit [1]
>> to define types only valid for the user space inside the copy of a
>> kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
>> added later.
>>
>> This leads to the inevitable clash between user space and kernel types
>> when the kernel uAPI is extended.  The issue was unveiled with the
>> addition of a new type for IPv6 extension header in kernel uAPI.
>>
>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
>> older user space application, application tries to parse it as
>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
>> malformed.  Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
>> every IPv6 packet that goes to the user space, IPv6 support is fully
>> broken.
>>
>> Fixing that by bringing these user space attributes to the kernel
>> uAPI to avoid the clash.  Strictly speaking this is not the problem
>> of the kernel uAPI, but changing it is the only way to avoid breakage
>> of the older user space applications at this point.
>>
>> These 2 types are explicitly rejected now since they should not be
>> passed to the kernel.  Additionally, OVS_KEY_ATTR_TUNNEL_INFO moved
>> out from the '#ifdef __KERNEL__' as there is no good reason to hide
>> it from the userspace.  And it's also explicitly rejected now, because
>> it's for in-kernel use only.
>>
>> Comments with warnings were added to avoid the problem coming back.
>>
>> (1 << type) converted to (1ULL << type) to avoid integer overflow on
>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>
>>   [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pipeline")
>>
>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com
>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
>> Reported-by: Roi Dayan <roid@nvidia.com>
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
> 
> Acked-by: Aaron Conole <aconole@redhat.com>
> 



I got to check traffic with the fix and I do get some traffic
but something is broken. I didn't investigate much but the quick
test shows me rules are not offloaded and dumping ovs rules gives
error like this

recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no)(bad 
key length 2, expected -1)(00 00/(bad mask length 2, expected -1)(00 
00), packets:2453, bytes:211594, used:0.004s, flags:S., 
actions:ct,recirc(0x2)

