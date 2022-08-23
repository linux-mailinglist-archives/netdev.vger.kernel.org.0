Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9821659E8FA
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344138AbiHWRQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343805AbiHWRP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:15:28 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2126.outbound.protection.outlook.com [40.107.21.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A46ACA08
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:50:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ez6M/VJ7nGfQ+aBUVe8Bt4Ld+PhvtA89L1h9l0hGRn0sMWL0IIXvbrNd0yd0Me6bPh2sPI/W7ugpgWGybGX77VO+ZV0Md/n1rlaXGpjrCBIN1pWZGQMm+VLWe568cZSipdtKtsqKGLEROPwhKMo15w/ISeV2MeBAbmHv1ylfayIAgmWv2auc+hIfDvuzLKVIswuoZKLzCGhVhsx0VBcwKhhouBwarDDYvld9k8yBHK4d6mgpsvEi4nxMfxA9Jy1FxnlCZVTjSj0yKHCoia2LSqvwq5JTjFfSDTdK8t2NMGWBEcpuJCkGRsOWJu0h5mgNCc1DhaOFLEUW6PTF5aBh1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1V1L/onKKUXKDDT0FY+0QtDe0xZrtaYmmFSzLhXgV4=;
 b=Wf+MIyrQjHXJCAyv1C3i6kgCgvp3j7IP9szevA9q19Bge8MslRMJEuv6QnqyLubXSP+V9toJ2ScPRXCWpRY1ZFASWrE3RgyQgAqxqSHMBXP7Dqxm1qSkD+NBHaWeMOgyWy/Aetwyukm1XEDD2J0VjHSfKqJjDfDYd9jCuce8leEGMl8mypY7ikGxIzOJhQt7g2XHT05qpNrvcSQNI0rybDJ2EawohyN/my3ySSIs7Q0/K0u+8LT/O8/QRoYEhVOV2GLH6IrBCK5rgLvSCuNwm12/W95k9+45jRecrIostV7eeyfpYOCwzKIO2TMRE44udW+hU0bKcgq41CgzOSnoRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1V1L/onKKUXKDDT0FY+0QtDe0xZrtaYmmFSzLhXgV4=;
 b=N/PyNBF0CgqwMsuW8Trv8z6Cvw50BM8r6qk1b01Vp276FYmdfcOZm49zB/d47XCJQYdknAS+vKpKgyc6bCfkKnXWYpbCG3R8GVTTpoTUnNL17wROD3YF05UTu8fG6Y1V96L/pmSn6c5mGBU5bBwF3NrKiaFflxTajmMeC+i0UbOOpgfhTEunicqIQX6ust+Q3zjqIpWGEIxyO7qhz/4oU6VysXHq3OVB4q7ISGnCs/HOUsEGYC0udfAVdITXdeXImISs+sGYbFWrwk6T5uj4LpA7IDMEklIeRbH04+EGhlmqXl7Od8JbUR453L0HRk1arxR0ZFiZ3HT8Iikd6echsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AM4PR0802MB2291.eurprd08.prod.outlook.com (2603:10a6:200:5e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Tue, 23 Aug
 2022 13:50:24 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4%6]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 13:50:24 +0000
Message-ID: <0989bea9-beb3-3eb1-eb55-3438f980d973@virtuozzo.com>
Date:   Tue, 23 Aug 2022 16:50:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH net-next v2 1/3] openvswitch: allow specifying ifindex of
 new interfaces
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org, aconole@redhat.com
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
 <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
 <20220822183715.0bf77c40@kernel.org>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220822183715.0bf77c40@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::6) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82874139-bfd8-4075-b26a-08da850e6dd5
X-MS-TrafficTypeDiagnostic: AM4PR0802MB2291:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61YhxXzi08c2wuuXLywoMxvhPg9GAazqaq1CP2wpNzVJEuOwfI2njQ1NOxDTquE7OCGD/gCyAd/sbyRln1W6m7QXyyQINcGaF7O4lQv1G62tNOWBXC2JaMpWpNQ2bel8BK8qG5SEW4g+gLuf/BEdV1yn2wFpjAVgseK+jyPkIT244DoZ5c2UV6CF9e/K/D74WUaVqzVlEp6u7ZMMSl0KSli9sb0kIsGIZw1sLiEqydFtD9qKaeZsSQ1PFbvjuTK9JuTfWQYfu4KNTDHFazkGC18SwaWIqYzE+36eUtbOyppVylh5YU5GZmtFv7DldshEuAfUm7UG8324OkVU+9eUu55zuhJlv7urSk2ZG5TD/6RfblUapRIRGle4CUm+DjVfzQKchEvcjHv5vGSD9YDqgLD+jmWFyrQaMFSRpPchiV8AsnyIDnluPGJkiXI89HP3XB3Nn/oUUxaWPneJE/OugCHbFFw2/lsC7XFOESvkR09X6j8bTLhBOM/Cn1/EnPWeixlOwQABWhfhPg3/kBy5uuyDx3rqyfhyegs6Tdusmzq7X4u9Y5b0dN9cbP4jktoVmj0y9tKzwv7LZ06+Ea1Qxs5dvrbEz8GI5/7iuxT0sR8MRonN966rTW/MRCoZbS/Vmzis1FkXUfnthsYEn8cS8s+3tKLt1rYhVvKqlT+7IRFdlVkgyrUDfSV8jkZnecE5w/OfnsvqbtRJeFMOeHd9ujL54degnurzgms/l6HOJKNLOdLadU/t2KnK55CCt2Chq1WZGPN0nZYPYESCA/3FGTUezNxTbazZpAjtfgW1+1k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39840400004)(366004)(396003)(346002)(376002)(6512007)(2616005)(186003)(83380400001)(8676002)(4326008)(5660300002)(6486002)(31686004)(36756003)(41300700001)(478600001)(53546011)(26005)(44832011)(6506007)(7416002)(6666004)(86362001)(31696002)(6916009)(316002)(66476007)(2906002)(8936002)(38100700002)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVZEMUt6bytOemJJbmx2b0VQaUxCL0t5bitPVXZvbTdJczVzTld3MHZSL3I2?=
 =?utf-8?B?SVFDa2gxbmZCNVdreHRuZzY5VlVGdkNGR0dPOXljV3JvYlBaRVlzZ3pEc28y?=
 =?utf-8?B?bjZNT2d3cFBWMVoxK3FZQVZFcW55ZzM5SDQzbEdaclk0dFphSWZEUkpzSWpP?=
 =?utf-8?B?cFFZNDBFRUlPcmI3T0ZyQzB0QmdUbjBjRGpnSVU1bWM3RnVXNjBuK25VT1Nh?=
 =?utf-8?B?aGh1RDZxbVRDbHA4VjlOS0YwSldDdXdtR2xtUmkrUnA1d0pqbzF6eTFpalVX?=
 =?utf-8?B?ai9SSUczTWl5SUk4T2VFWEVmNXo4OVdPZVp1UWhBNEZ0NXQyajRKNEdsbFhr?=
 =?utf-8?B?ajRNb1V3OEVkczdlMytGS3Y2SmNPc3VIa0xaM3A2MDRHL09KQ2FzYkFVTFZP?=
 =?utf-8?B?cllFZENTYmNtZlhrcEcvckNyN2oxVU05NndlQzVWdXFnUWJIMGdHd0ZQOVZz?=
 =?utf-8?B?VjZHUDhGSE10S29UQytLd3ZibkZnajdjNkVmV0wydlZqUUF1R1dIM3BSMG1y?=
 =?utf-8?B?VXQvOVBNRmNKbkFEdExuelZqNW1nU0JPa09rQW1ubUpFVHVncWQxY0I2akU2?=
 =?utf-8?B?eTVoSTMzTFJxdUhlbUhrR3JHQllHWlMzRzlkS0Y3UFRHWHJHSDdTcHdoWU1p?=
 =?utf-8?B?TXlyd055cWFSM3piNGZ4THM5dGtjaWZIOTIvcm1aNjhwenpaRjJxdHFZay9M?=
 =?utf-8?B?d014SzQ2cm5ITUJUUnhNa3QvaUdoM2VtaVhNdTRpZitOWXI0dTNsYWxjOTYw?=
 =?utf-8?B?N0JaNXBZbVRwdkQxVTNDODNOeStCdmg3K1hjSkdmaGYwZ0c2OHZNNnkrdW90?=
 =?utf-8?B?VUpPejJOYkYrcm10VllldXVkSm5GRDFnUGkzRHZWSlBFLzk0V0I3blg2ZUlz?=
 =?utf-8?B?U3E1WlMzUXdocVVXSWp4QThob1NteU5Ka05pTVdkRmNod2FaMS9LKzUxdnRw?=
 =?utf-8?B?UDlUTHlFbTlna1pkRnRQQTc3cU55STVvbXRHbGlBeTA4N1Ruc0JtRUpqeXFF?=
 =?utf-8?B?UzRGdW42MkJVTHU3Z3IvTkV0ZlJaUW9wcnRtdS9kYlFoUnVoSm5mZ1pXWnVr?=
 =?utf-8?B?MXpQMlBubHBKT2lIUXRmT3B0RW12dDdQdVU4VWRKT0JQTnYxU0tmaFBydWMw?=
 =?utf-8?B?cFArTVBWc0pCUnZBS3pxVGM1VkJwL0JEdGJnZFV4UHIzWTVQNHJ5dEZnYXJT?=
 =?utf-8?B?eE1paDRLMU5ibjdvd0EyYzJ1dWZORC9XMDVHT3JYL2pydVppY240OVRwS2ll?=
 =?utf-8?B?bGJGTDFxWElpVXpKa3U0SnVjOEd4KzY4Sk8zZzFvRlpQTmdBeVBaMXhSZ1lO?=
 =?utf-8?B?Ulh5MEFhZDlPVUxZOERDTTVrbHBkNXdhekhKaFhiaUtoS2VaRitjWXI5MzlM?=
 =?utf-8?B?OTgzdjJXTFhIUnpiWDV4MWl2ckxGdC9xNHl5WlE4U3UvNDZaK01tUjJSSFJL?=
 =?utf-8?B?RXVqNUNtWWVway9SU2NtemxEYkM0d2d0VUNlUmhtazRjdy9NZXN6NXlKRFdz?=
 =?utf-8?B?SkQvRlJaeE1rM1IzNUVRa0tidXhPL1ZzczduY3FEQVhjc3QvOHNNVXAyc2hE?=
 =?utf-8?B?QlFJQlVCMk5ZRy9Ec1BJNXEyQXpWcGJreUV4NWhZWUNER3BmZXJYTHhzN2hq?=
 =?utf-8?B?cWUzVnRBL3ZNbnJkWldQUWp6ZWhoMUpmM0daV0lKeS9oTHJXL1JVd2o2TUVG?=
 =?utf-8?B?NFhXQ2NVeG4zaXpPYlRoVkk1WE1kZjdmRXIzaGt3MytJQUYrK0NrS1Y3anpC?=
 =?utf-8?B?dXIrb1BIVzRvaFBEdzF5ektEYkQyL0dFbjhFckNOWGl2bDBZOWFTOG1XL1Nz?=
 =?utf-8?B?UUNpQlhsaXdoc0pvUjNiKzJTUGtnUFczVWxZLzdmY0lPVmtZa1NReldwNkI2?=
 =?utf-8?B?MzBZM3R1SXRWZFFJdkpRdHlqS2NvdGQ1NWZiTFliei9pQlRUYkZzeCtySHV2?=
 =?utf-8?B?YVE3YmpJMlV1WDQvbG1kMlE5dlJCY0ppV3dweU5LTFpJM2duSFk0K3lLVDNV?=
 =?utf-8?B?UjVZd1lVMzBKOWx6YWc4QXBjUjdWL3NEMjhwRExvSzRjN09mOUFzeTFLVkJN?=
 =?utf-8?B?cUNVQmk3clFTRWxlRnEwYU5ldzBqVjBmTGs3WFJOTEVKWXJDbEQ2RVd1cmZn?=
 =?utf-8?B?d09HQzdDVVR1eTB5N3ZJcCtIZXI5N1ZHeFdvbDdOZWVhdUQ4Yk5uOUxzbGdF?=
 =?utf-8?B?MkE9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82874139-bfd8-4075-b26a-08da850e6dd5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 13:50:24.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogImJPDngM5IuZGAtP5WWjVugWM50HU/kPLn1eI8GLROB8BvhPtmBskpj3UVeTNF1QTCfPNmvWUMT28g6NzEhI8UYHB9Sb3h7hXyf3TjMio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2291
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review!

On 8/23/22 04:37, Jakub Kicinski wrote:
> On Fri, 19 Aug 2022 18:30:42 +0300 Andrey Zhadchenko wrote:
>> CRIU is preserving ifindexes of net devices after restoration. However,
>> current Open vSwitch API does not allow to target ifindex, so we cannot
>> correctly restore OVS configuration.
>>
>> Use ovs_header->dp_ifindex during OVS_DP_CMD_NEW as desired ifindex.
>> Use OVS_VPORT_ATTR_IFINDEX during OVS_VPORT_CMD_NEW to specify new netdev
>> ifindex.
> 
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -1739,6 +1739,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>   	struct vport *vport;
>>   	struct ovs_net *ovs_net;
>>   	int err;
>> +	struct ovs_header *ovs_header = info->userhdr;
>>   
>>   	err = -EINVAL;
>>   	if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
>> @@ -1779,6 +1780,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>   	parms.dp = dp;
>>   	parms.port_no = OVSP_LOCAL;
>>   	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
>> +	parms.desired_ifindex = ovs_header->dp_ifindex;
> 
> Are you 100% sure that all user space making this call initializes
> dp_ifindex to 0? There is no validation in the kernel today that
> the field is not garbage as far as I can tell.
> 
> If you are sure, please add the appropriate analysis to the commit msg.

I am not sure that *all* users set dp_ifindex to zero. At least I do not 
know about them. Primary ovs userspace ovs-vswitchd certainly set to 
zero, others like WeaveNet do it too. But there can be more?
What is the policy regarding this? I can add a new attribute, it is not 
hard.

> 
>>   	/* So far only local changes have been made, now need the lock. */
>>   	ovs_lock();
>> @@ -2199,7 +2201,10 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>   	if (!a[OVS_VPORT_ATTR_NAME] || !a[OVS_VPORT_ATTR_TYPE] ||
>>   	    !a[OVS_VPORT_ATTR_UPCALL_PID])
>>   		return -EINVAL;
>> -	if (a[OVS_VPORT_ATTR_IFINDEX])
>> +
>> +	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
>> +
>> +	if (a[OVS_VPORT_ATTR_IFINDEX] && parms.type != OVS_VPORT_TYPE_INTERNAL)
>>   		return -EOPNOTSUPP;
>>   
>>   	port_no = a[OVS_VPORT_ATTR_PORT_NO]
>> @@ -2236,12 +2241,19 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>   	}
>>   
>>   	parms.name = nla_data(a[OVS_VPORT_ATTR_NAME]);
>> -	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
>>   	parms.options = a[OVS_VPORT_ATTR_OPTIONS];
>>   	parms.dp = dp;
>>   	parms.port_no = port_no;
>>   	parms.upcall_portids = a[OVS_VPORT_ATTR_UPCALL_PID];
>>   
>> +	if (parms.type == OVS_VPORT_TYPE_INTERNAL) {
>> +		if (a[OVS_VPORT_ATTR_IFINDEX])
> 
> You already validated that type must be internal for ifindex
> to be specified, so the outer if is unnecessary.
> 
> It's pretty common in netlink handling code to validate first
> then act assuming validation has passed.
> 
>> +			parms.desired_ifindex =
>> +				nla_get_u32(a[OVS_VPORT_ATTR_IFINDEX]);
>> +		else
>> +			parms.desired_ifindex = 0;
>> +	}
>> +
>>   	vport = new_vport(&parms);
>>   	err = PTR_ERR(vport);
>>   	if (IS_ERR(vport)) {
> 
>> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
>> index 9de5030d9801..24e1cba2f1ac 100644
>> --- a/net/openvswitch/vport.h
>> +++ b/net/openvswitch/vport.h
>> @@ -98,6 +98,8 @@ struct vport_parms {
>>   	enum ovs_vport_type type;
>>   	struct nlattr *options;
>>   
>> +	int desired_ifindex;
> 
> Any chance this field would make sense somewhere else? you're adding
> a 4B field between two pointers it will result in a padding.
> 
> Also you're missing kdoc for this field.

Sure, will fix all the above in next version.

> 
>>   	/* For ovs_vport_alloc(). */
>>   	struct datapath *dp;
>>   	u16 port_no;
> 
