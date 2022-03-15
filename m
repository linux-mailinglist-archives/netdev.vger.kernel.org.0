Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13044D9831
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbiCOJzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346951AbiCOJyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:54:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7C960D3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnZotHBd6hTbcguscNiRWUoiAv4a+8HcbvFRNNPol7tmDDoD2GgQT4atGaFaA/l+uF6p1TW/5OgWL1iNl5O9Fg1tB/PfmZev+7dej+gjBixo9ETwuSAFiEqDTymDABs9AEQlF5p7xhjX4zGlZDXQT5vhU1o9lfeQ7nmw6bV3wYmq+7ljycjrxLZHNKsC+9uNeE5WjvNL1M2yHzEj1geAGgLFgWO1skfJE7QLika9CKiGYwYOyR50+7Q/AG3t22v0sim6VE3z/3G1aXACnQBjoIQCmV7ji57CxQY9je9hCg1WpFXRRWzDHo2+rMCipzwIc3ycKPjAD7dfyMASV4/AXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQrJn/Me5lvd1YMSa4YBUqe+1BzlD6ONTE2cZQdJ/Vo=;
 b=Ah8s0YAn2WqZIbP3uW0yfoi03Nw0SaCPE3py2BoDqaWAP64SbzpBsVfDz8XYFYyfaBmbOPq/k36GxqGglwEkYybJruElEptVO4yxZZcxx6nnWmxATV2Z+8QepR8e3PNz24Y80UG6W8eu32dhKTEbmyuh+/rRkDanoXoLtOOLklcpXR5ydG6FQ6JWTNH3uw4mjbYZx8IyR63+M+X9JGnU+oolYabH9vM8u8urLVBWxIWVa2RBUirigjaukUOsD4q1HDqk3A8LuMGlPlDMHB6lNDzEFIVxt3y6IQ5efDGQKv3dT63QU+xhWLGImNW2SAP6Z8p2yMzPvit2R/bK+IWzcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQrJn/Me5lvd1YMSa4YBUqe+1BzlD6ONTE2cZQdJ/Vo=;
 b=kD7ph7BTioyl+OO5M63RqAOjhgKP0Ue9pltcxAlNdpdaoqNsYYoIMXJgrZBu5BtJS+HKnlyE5wjT8zJkSzjhoObn0wtEH3At+fnHwNRY8jw4hyP3euSr2PSGC9Y6Yk7wYMF4xMVKrgwtwMRukxoiXZIzsgSR/iBQpieDNuwpWHjvY1RE088MeYpgGjhCyMbBb0Ab46j2A0nNfD5OQUA5lroL4wNEQY62aLETpnGFK4tnlmnL57a1RZ0KBuHMG2ZABdZizic7zF+Y63nB0IKrURIV+QBCBCTjyPlnGmrt0DxFRRI5vHmjBL315yhdLU2i98RisSx0KQnmFNIFrMOHfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 09:53:27 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::d812:d321:525f:2852]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::d812:d321:525f:2852%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 09:53:27 +0000
Message-ID: <9e8bf9f7-38e9-8bb8-b568-873288a011ca@nvidia.com>
Date:   Tue, 15 Mar 2022 11:53:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101
 Thunderbird/99.0
Subject: Re: [PATCH net-next 1/3] net/sched: add vlan push_eth and pop_eth
 action to the hardware IR
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
 <20220309130256.1402040-2-roid@nvidia.com>
 <20220314220200.0b53e7a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220314220200.0b53e7a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0301CA0010.eurprd03.prod.outlook.com
 (2603:10a6:206:14::23) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77c9b2de-2de3-4dd8-1ab8-08da0669a728
X-MS-TrafficTypeDiagnostic: DM6PR12MB4106:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB41067147C3339364A41AEB81B8109@DM6PR12MB4106.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kk31eMY9xXyQW6LfTxmANX3cZdzAhHa3/hanZPCrWX79rMbSQ/NJD2sY0XnsFrZG8MvkB2ylVHml9b6bfuUF0K6rcLQaPgZF87WVk/iRwaw1DyWROHyg+IOBMgOdDonUj/HKYOjtVCRLlO/MA7fQspwJ0JXeB4WBJZgISdgXiDplZr6Fud7e5XJiYbPDRrmpeJ/d+dKgtAemhIXfxRqZyCXRH4LJT/ICiDNi+YYW6gofAWpXP7s89uh5zX18urVmQIWH8BaousAUQjUDmaNC/YCot/QNM7o0Ek1AdPtjwtwkPEyGdY66r/g6irJ0pUyNkvhMb7haBKnLaN0dTo+7kO8h6lh4PcsbsW7YCdwkab6SMxTynxkATyexXdt8MTVKY8w1675OYVV/oanvx/bR7gsvy1bBbtjNvb4ZB4sO+9JRjip1stDu+ouK4K3V68+BiyfI1L8o2RB5xtAy2JaXixiuSe/UEgnYNS/X7tkG7ltk/p4D/tubNgurANIjeSP1gasrOBdak3NlYsB/WfGZ8aOlJQ0xbKT/2qcJILhLl7CLcF9BAxxK3Yeaeth1Lb6r//OMmmoPBLMI27q1D07Yj6B2N/bf1AtbLcAexJRkfDHZndV/XS8aUPOyV3AgCWb+0zZoSBNS0Qy0Se0hsmDYd4obQ2t62BysHwb51eKZAwNObXYkkWFdLFs9FX5KMJ7qbhYCXQT5Us/9gfXm2Onk9zBsylnc9NT7CiHD1Hc2qWSaVF3g4TsQQRt9Jf7HBi1H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(36756003)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(5660300002)(6916009)(54906003)(8936002)(83380400001)(107886003)(6666004)(186003)(26005)(508600001)(31696002)(6512007)(6486002)(86362001)(2906002)(53546011)(6506007)(38100700002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enIvb0VBUElkWHFKQnJhdVBlWEc0WmFZUFdoWjFZT3c0UDUyT1F0N25DTDVn?=
 =?utf-8?B?U0xoYjYxbCtNQzdFQkZGR1lLZlN5YzdmYWJWalNHR3VzVWpUdGxtQm9wakhT?=
 =?utf-8?B?enU2T1R2djZvSTIxa1JtUVJ2UnBhaE13S1haNDA0KzJ1Z1JaYTkweVQyYXFY?=
 =?utf-8?B?S1VRbW5oZURIZCtyeE1rUEdBNU1QK1NQWi9BaVRzUHBWUWVvVDVPME00d3pu?=
 =?utf-8?B?cXdHeEw0TDlSK0tzVGZHVkxXZ2FJM1NQRmhYdzlFeTlNZWRBdlNyc3l2WDYv?=
 =?utf-8?B?eS9ENjJQUDA2dGZoVEVBUWJhQzZWa3RrZEVHK29qQk9iV0liOUpGTHd4WXFY?=
 =?utf-8?B?UTE3TUVSK2ttSTNjbHVTaHM1S3dUV1R1Ymppbko4N1o3RDBPQWl3YndHZEpS?=
 =?utf-8?B?MEtKQkhkMkxSMEVLdGV0QUlRUFl0d2Zla1dTSGxoSXl4ZGk5SzI0cDArRXJS?=
 =?utf-8?B?VjFmbDh0SmoxMmZxd1VEK2h5WGpFZzVIZ0VUTVNjM3RNaitHeUcyazhMdWhW?=
 =?utf-8?B?NUZ1WWhDR2QwcmlXREdXc2NtejdZSTRUUnFPUXNadmJLcmJ4T2RNdnJNMGR3?=
 =?utf-8?B?eTRsb3VtMHg2bG1LaWgxSUhDN0xhRExOeG5TZ3ptenp0cGxwOS9tdWtDVzVy?=
 =?utf-8?B?ZFUyN0NkQjFUU2dDUTFIaHNNcXZscHVtM09jenNFd1UrQlk1V0lxOVhTMHNs?=
 =?utf-8?B?VFdmMlNCK0g5S3VkZG5BNkFvM2ZLbTZ0MS9pcVJWTk9USUhWOGJXVU5ZcWMx?=
 =?utf-8?B?dEZhaVdORXVXT1dBZFJOZWtYUk9PQ0dIUTloYnIrbDJKLzdzRmVOYm03RFk4?=
 =?utf-8?B?ck9xV280RWxJQWE3Tk16U1ZFdXlTUUpncnQ0Q2VMYy9uZThOdHFWM1V2ak1q?=
 =?utf-8?B?eGJoRFZocGY4ZDVsR0d0SmRER0h3ZXl3SXQyMGt3bm9kMmZuM0RtQkR5dGFa?=
 =?utf-8?B?MWl6WUhOakFxbUplbVhHOGlBc1k3MDFwMmQrcmxWUTVoVEllbjMzdWhpRXJU?=
 =?utf-8?B?ZHU0OStlY0ZscjRxMFlaQSt3ZGFpWkw5YUlZT0hEbUovOEhLaG5VSndiS0kz?=
 =?utf-8?B?V3RCQTJBVGZLdmhrZXFweVlTRG1wS3pMT0R0MWpzaDgvb3h3a3g2MkFnOFcx?=
 =?utf-8?B?VG5MSHdsSUZCSGd4eDFUQmtKQXdqZFMrZHJJU0VqTzcyQzdjSFJSMW1hczhq?=
 =?utf-8?B?MEs4SzBEaDRrRTVXbTNmWFI4L3UxckpTU0N1WW5NWTBFMlNHd0dxb1BNTitt?=
 =?utf-8?B?eldydkhDQldQRXYwZnJybkNOdXd3VW4xempSMnV6d3ZKdGR6d0ZMTkR0SDhy?=
 =?utf-8?B?OEpTc1FpMjFIK3lkWUIyVmJ5dnRlTmthdlRHREkzNXBna2wzMTZzditseGZ0?=
 =?utf-8?B?RThBQTZwdkxPbUNEZWJNOUlobDRaZDJOYzYvSUNSQkZpY0tJWllXSjk0R1pK?=
 =?utf-8?B?UWkwN2h0eFlPMy9RZzJqaTBzU1FST2Vxa0F6THBCa2dwRUlMaklWaEJQVFJL?=
 =?utf-8?B?dzlVRTBsSmlvd0RZMmJnWXlrUnJwSnF1NXNhQ0o5SHZORFM3bUgvN3lkNGZs?=
 =?utf-8?B?NTIyODJGd0hhRlF2ZG03YmlmaDJmNVNlZXFRalprODdFWGFYaWNWL01CVzUx?=
 =?utf-8?B?SkxhdXZNbklLb1hKdTB2ZUpWN2IwVjFvZFZ1bkhJdDNRVElQenBUMlZjLzE5?=
 =?utf-8?B?VVh0dUR0MHlNMFNNZmM2a2dpRVltYW9GN1BDYVZxR0JFd2Zublg5R3NtRG9p?=
 =?utf-8?B?VGlnQkJNSkZmQmRRYlJQN0RDemdRQSswd2Nia1d5MnFoZDgxYktjeEp3c1l3?=
 =?utf-8?B?SFg2VFZVMDVwU0pyT1BWN05nc1F1VE51M1NtYUxIOU1ERjJ0cThSWm5YYnFP?=
 =?utf-8?B?bTFGek5ETUVZeEhKeWltcHl4N0xMb1dFaEwvc0NRNUVLcHliYkpLVnFYZzRU?=
 =?utf-8?Q?XqMCUqNF2ORKFJKpWBkM/5fTDV5xkHog?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c9b2de-2de3-4dd8-1ab8-08da0669a728
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:53:27.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4e1OzS4GM4oIXVAmqoXWSrYQlClX5ya55HW8zC3gBfr+iQ3aqpcheyCbTIpxG9t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
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



On 2022-03-15 7:02 AM, Jakub Kicinski wrote:
> Sorry for the late review.
> 
> On Wed, 9 Mar 2022 15:02:54 +0200 Roi Dayan wrote:
>> @@ -211,6 +213,8 @@ struct flow_action_entry {
>>   			__be16		proto;
>>   			u8		prio;
>>   		} vlan;
>> +		unsigned char vlan_push_eth_dst[ETH_ALEN];
>> +		unsigned char vlan_push_eth_src[ETH_ALEN];
> 
> Let's wrap these two in a struct, like all other members here,
> and add the customary comment indicating which action its for.
> 

ok.

>>   		struct {				/* FLOW_ACTION_MANGLE */
>>   							/* FLOW_ACTION_ADD */
>>   			enum flow_action_mangle_base htype;
>> diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
>> index f94b8bc26f9e..8a3422c70f9f 100644
>> --- a/include/net/tc_act/tc_vlan.h
>> +++ b/include/net/tc_act/tc_vlan.h
>> @@ -78,4 +78,18 @@ static inline u8 tcf_vlan_push_prio(const struct tc_action *a)
>>   
>>   	return tcfv_push_prio;
>>   }
>> +
>> +static inline void tcf_vlan_push_dst(unsigned char *dest, const struct tc_action *a)
>> +{
>> +	rcu_read_lock();
>> +	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_dst, ETH_ALEN);
>> +	rcu_read_unlock();
>> +}
>> +
>> +static inline void tcf_vlan_push_src(unsigned char *dest, const struct tc_action *a)
>> +{
>> +	rcu_read_lock();
>> +	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_src, ETH_ALEN);
>> +	rcu_read_unlock();
>> +}
> 
> The use of these two helpers separately makes no sense, we can't push
> half a header. It should be one helper populating both src and dst, IMO.

ok.
