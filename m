Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0997597818
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbiHQUfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242039AbiHQUfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:35:25 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20131.outbound.protection.outlook.com [40.107.2.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6506A99F1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 13:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpYOmyTk6FcTZJyPpKJkDmcR3w25fKEa541dopOocrTaW8IUyjRxpC+zcstcm/hkcb79xp0ToErfVS1w/DkpcAFz8nZnOVoKHBM8cWXpZqiGsVCqHgPKBB571JerEoiwn7JqNiUrZllLbUbyySUY7sYgL3c1kCihXdqOAx787HpjT2kYxe+4AcY/e68Q0slkJyiG0ou0qSPyENLeDBeLdZHpPLigTmxe56lGNq/xPaasae9oR0X5yCl/D4rAJiFAss41aCnsdkzeaJ8kgz57tndF56RUWqDkNxoZe3XonyKODDLUruTbbS7qd1lsmHYFiW0Bnf4Yp3OZLCVKjagkLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n76fcIQyDCIiA+3aclNImXvSVzOY6TD70qamQd4QXT4=;
 b=bNw1PUkOkndHCKw+7fUW/JT85zH7tIMRro2mUPn3Ot/5terSZ3srVIp2HcqsfTva7Sa9d7WSdA/16F3DYtYcuvAOCuUOFJr3qe9DxAcxTbA5JAwsAigUOdPO1wCHBqy98Xyzo1pC4Xhtu2l6OKaQSpw+oxkmxyY+9dyC2c3EIeUq4WBO5VbQ5IG69VxJ3s8c4ge+NfuSAUVx/N0LbJ9rlUgndDVgdbBnH1j+IHk0RxTlvoLBTepKhc9Y7rJZL81kRypPHo6ivPq9RZDGXq4se1G18BVnCpBNomKvfn4SNQqv/JoPxQBEVMI1njwW4rLYbPC7+E6AxJx5coO5I7RACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n76fcIQyDCIiA+3aclNImXvSVzOY6TD70qamQd4QXT4=;
 b=qWoHcQdBOXVdz+9Fgu3bUSNeMsTojaFdl02TO/cvZQw18Cdw+iHj20wkKyh/U/FFvbClED6W5PxL6LN1zbYq0RDKiRzANQySMkE8Ucd16EyzjjzH5ObMVMTn8wCIhE8akdvPbLSAm1Bin5gxgMn7QnBeITIOD5GOIP2c53XBzBnxlO17gJn1WNz4iflNKCkQxPV48ukqfZcXMR25lUCgA5dnVEFHnezEAxrDzfxYEc30tUIkQkZ4nLQTDEZ3ODGEK0vLf2UGpNuG/I0PlX6gmFTIHez6CcNS/IOHzjwZGJuUsEFwRDrwtcT/8896Da2usoERPhCCl2y6R8xTg/BIIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by VI1PR08MB4208.eurprd08.prod.outlook.com (2603:10a6:803:ec::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 17 Aug
 2022 20:35:22 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4%6]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 20:35:22 +0000
Message-ID: <bc6f197b-37a5-89ea-1311-16f93b5cefed@virtuozzo.com>
Date:   Wed, 17 Aug 2022 23:35:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [ovs-dev] [PATCH net-next 0/1] openvswitch: allow specifying
 ifindex of new interfaces
To:     Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org
Cc:     dev@openvswitch.org, brauner@kernel.org, edumazet@google.com,
        avagin@google.com, alexander.mikhalitsyn@virtuozzo.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        ptikhomirov@virtuozzo.com, Aaron Conole <aconole@redhat.com>
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
 <38c9c698-6304-dfa8-7b79-a1cb1e00860b@ovn.org>
Content-Language: en-US
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <38c9c698-6304-dfa8-7b79-a1cb1e00860b@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0103.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::44) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6431500-8a0c-443f-ff83-08da809001c3
X-MS-TrafficTypeDiagnostic: VI1PR08MB4208:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMOsZTqHlwB8hBjlB1KeGseDoVtEhwfilg8w05U7tySQiTSZjcXchJkX9nS0HbKJeTgfTNzFUtEPgvvfEjO0ran/+2niAdc/vgyEpkTMoXpUDsqNO3dw/bnIn4vwt7iH41pak9kfsZtgJAqzo5y8tr3qWxYFOTP8GIRqyzBHsk4R70E+4hVb8c7z+4TT+VI/QjPpgvEkWFL4WRZ9J0mxZkET/c2cWAXl43tkcbWSAo1NAoDPKfo+Ak4jlvIE/FoLEenF+uSKby0b1ZDYoeNB65PPVf2u0ET+/W/MJK3IJcZJlE/H/6ccSBgYUCZuIq3n6xWAUA/qhfniXGZ/YJGW7bs7RBmpRzWwdQBjpC9yYVtOEfSl248PxhQHfJ8JoTAW3YfAPLYMTMPQals2aTYNrtttF82d3BBkwRDRV1VzjAjG6TWWBpAM0VQ0cqgwqhx2k/bN6ZW8CdXn5kDOrIy4YmOb0NnZUVM29NRmDjYXl8V1eRaABDxsjyv110UbTgdNbWF+yinxQt4hF+Yae71zROsJPm1vQPhMosluEm10pyydCTofIhwG1EreK1fj2EeM7P/qr5IyJEWBOg2OtwDfcXgNPv+/3jLMkmCytD2YSug91DlgZ/DkPf78w/dYcBEdWDe2CMR45zqCnKla6YmtOiSTCWBGmgOWX6xgy38BvjFVFh0eHFSx+EJ6lRA+KxO87UW1rUkaZWmWLrV8Uv7twGHELSox0mnKcFNaklXCCQjO9kqxxxQmGvg1jA9y0DHaCnDcD8IN/wBi+rSZe83Rjti/v0lLxB0V9Ejj+DHwC/zTEuTURTu9Vg1w9aMaeRAu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(39850400004)(136003)(31686004)(31696002)(86362001)(38100700002)(83380400001)(316002)(66476007)(66556008)(478600001)(8676002)(8936002)(44832011)(966005)(2616005)(26005)(2906002)(6666004)(53546011)(6486002)(6512007)(4326008)(186003)(5660300002)(7416002)(6506007)(36756003)(66946007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QS96cDNXaWg0RU9OVW9kL0ZiMlBzTmJjMjM4dzhXOU1XeXNRY2VHVGEvYklw?=
 =?utf-8?B?eUZkaDk2bzlsYk9GdTRxY0ZhT1hrY1lXS2NvRWZrb25lakFJakJSOVkvajFU?=
 =?utf-8?B?VHJSRjRMWVFVMXVXVjFQUm5nSll0cXJjSnd2U0ErN2NUVU1wUEJqeWtrdnEz?=
 =?utf-8?B?MC9zZnhEaURkTGhSa2VKWjltMlJkYTREaEthUmdyOVlaeUpDZ2ZtUW1XYTZY?=
 =?utf-8?B?WU4zMVI4MGxtRWp1TStZcjd6Z2FVNUgvaDh6bjNYbnpBaG5jV2hwVjhkY2Fr?=
 =?utf-8?B?djR0em1iM0xvTTA3QUkvenVoVmZDY2EwMUpTUGk1WUcxUmQzUDdlWXY0cysv?=
 =?utf-8?B?amgrYmVKdGFMUlYvc2lLbXl2ZmRxTk1xUVhlMGRyc1dGaHA3bXg4TEI1WEJT?=
 =?utf-8?B?bFlPSWV5alM2NU85OG5NTE9BR0Q5VzJicklNVkthYld0ME5TUkVxOUoxUlFE?=
 =?utf-8?B?UEtyKy9PWVhRYWRla3lOUHZYdEFPRzVDMWxXYmtEL1JmbStuVTNNZDZOVlR0?=
 =?utf-8?B?Y0VQRmZIU21KNU1jSHBPSjJFTE9KOFEvTDNNRDFHNlFVQ2JCZi91NXpZaFhy?=
 =?utf-8?B?VGZBRzFCYjJ5Q0ErcmNaZFBUdlRtWHordFlBblhlUCtFbHJTMElFQmtzdStZ?=
 =?utf-8?B?eHlKbUhFT2lKMVY3RVNzcm1RL2xZekFEVTJJSVJHOWVJZ00zYjB0dCtKRysw?=
 =?utf-8?B?VCs4bG0zSlpaakIzOGo4SC9pcE9xREJnOUxuTUFZT2lJeS9jU0F4RXFUM3Fu?=
 =?utf-8?B?V0loMEJoRFJBN01Dam1OZDM2bUovejJETDVOSXQrRWt2bWt1OG9HeGRZaUhW?=
 =?utf-8?B?OXI4cDMrQk0xVkd2Qzhpb0QwaU5QNndhem5laUtDNlQvL3FkWkFzYzI3OE9T?=
 =?utf-8?B?ZUFlc3NlSHFZa0VDTk8wWlBzY1NMWCsvR1pxR1ptR1YvSzdRWGk4Q0NvTG83?=
 =?utf-8?B?WllBNG0zUkVUYUs2TC9QRVdTK1dYZmJqUDA2b0p5a0NVUnRzOHJPb2JrWEtU?=
 =?utf-8?B?MDBQblJHcnViQUQ4ZW8rbUpFZjBQL25Gc2xpYmFSMWw5UHF0VnVacVVUVi9M?=
 =?utf-8?B?L09HMEhtbk9qTktzcjJscU9mNGcwOHVKSENFWnI2emt2M2hDTWEycFE0dmlH?=
 =?utf-8?B?V3YwcW52d24zckVaQjZWenRIOS9vT3lFYkUvcERDSzV6NjVUd1h6clJjdCtD?=
 =?utf-8?B?TlRZMzFnZE5PNjJGSkdNK21kSTZiaHZPMHdRVXRFODc0ZkxXZEhwb3NnR1JW?=
 =?utf-8?B?dml1QkRxTkJjMFV4cDRoQlJJVktYTDM4OEYwR2JFZEVQbEIvQVYrbXI1SWE0?=
 =?utf-8?B?TlNtRmM2K3dhZVhPS3BWZXVjZU1pTllGUUdNdHJsSXBwYjdrUTkvUjdkN2JE?=
 =?utf-8?B?cHFITlZsU3R0VUZHaCtlV0paVHVIN29kS1B2UWcvdXh0U202eXFRdVhMaHI4?=
 =?utf-8?B?ZkhPTTB3Y01PZFdYUzNpc0UwQnRVOE4yWi9aYUxja09NbVZ1ZXhhMVZmZHdk?=
 =?utf-8?B?MUlwZ0JzWmZESEtqb1V1UWUrZVVxQjB0MHlDdmJLanFMUmR6VU80ZVgvaXV0?=
 =?utf-8?B?ZUFEWjRaVHV3WWY2RHI1b3MzazJkSHVmZXRQMEVhSTRuUCtBM01vS01FQjZs?=
 =?utf-8?B?RXRRVnFWejgxdDlHRVlWemxOTjhGb1c5ZWJyRmJPUU1lSG1FeE9rNyt0VFlq?=
 =?utf-8?B?eTExaGg1UENMa2dGQ3V4VmFDQzZIWlZyQlF4dkJFenpJRFRUOXNVNGQwWUVX?=
 =?utf-8?B?VksyMGRLYU5nZnB4eWVWMnI4WkRXLzd3cTAxaFpRTUhXcWFWK09BbFdOWktR?=
 =?utf-8?B?Zmd6OGZxbkFBVkpHTTdEY1R4QUFvMjVacW80ZDU4UWo5Unh2ZkxXRnN4UlVl?=
 =?utf-8?B?N0xDWDZSN3g5cW1MWGlpL2lpcks4aFZ3RUJLV3lTMmJPZm40bndRdHZ5enhH?=
 =?utf-8?B?SCt2UEh5MWNtUmJ3NkpMVzU1NWhaWExwdEZCcC90R0ppcE5YNzEvM2lwZmJr?=
 =?utf-8?B?eFJsS3lGYWV3TDNGcngyYmYzRjV4RFdkdlQzYWNsRm1UbXc1NGVUZ1VHNUU4?=
 =?utf-8?B?a1RlUzVJMnJ0ZkQ2aGludmlJQTBxSmZ4VSt0QVFpWlNwR2hTUVdWZ1krOEFX?=
 =?utf-8?B?aU1vMXlTSUx1c2dPb0pscmtFWHRvL0NUZTh2WHozdXBoTFpUdnI4dmVRT2pu?=
 =?utf-8?B?MEE9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6431500-8a0c-443f-ff83-08da809001c3
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 20:35:22.0864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4cerj7/kwp2woF3e29ooq2V/7spwxcyGkVeYDFg5txhNfvW3wcJoNNw9B19OpmYc0x/YuP1FP1GhPpspHfJfKUSWx2OI3mPjivZsT9oWq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4208
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/22 21:19, Ilya Maximets wrote:
> On 8/17/22 14:49, Andrey Zhadchenko via dev wrote:
>> Hi!
>>
>> CRIU currently do not support checkpoint/restore of OVS configurations, but
>> there was several requests for it. For example,
>> https://github.com/lxc/lxc/issues/2909
>>
>> The main problem is ifindexes of newly created interfaces. We realy need to
>> preserve them after restore. Current openvswitch API does not allow to
>> specify ifindex. Most of the time we can just create an interface via
>> generic netlink requests and plug it into ovs but datapaths (generally any
>> OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
>> do not support selecting ifindex.
> 
> Hmm.  Assuming you restored network interfaces by re-creating them
> on a target system, but I'm curious how do you restore the upcall PID?
> Are you somehow re-creating the netlink socket with the same PID?
> If that will not be done, no traffic will be able to flow through OVS
> anyway until you remove/re-add the port in userspace or re-start OVS.
> Or am I missing something?
> 
> Best regards, Ilya Maximets.

Yes, CRIU is able to restore socket nl_pid. We get it via 
NDIAG_PROTO_ALL netlink protocol requests (see net/netlink/diag.c)
Upcall pid is exported by get requests via OVS_VPORT_ATTR_UPCALL_PID.
So everything is fine here.

I should note that I did not test *complicated* setups with 
ovs-vswitchd, mostly basic ones like veth plugging and several 
containers in network. We mainly supported Weave Net k8s SDN  which is 
based on ovs but do not use its daemon.

Maybe if this is merged and people start use this we will find more 
problems with checkpoint/restore, but for now the only problem is 
volatile ifindex.

Best regards, Andrey Zhadchenko
> 
>>
>> This patch allows to do so.
>> For new datapaths I decided to use dp_infindex in header as infindex
>> because it control ifindex for other requests too.
>> For internal vports I reused OVS_VPORT_ATTR_IFINDEX.
>>
>> The only concern I have is that previously dp_ifindex was not used for
>> OVS_DP_VMD_NEW requests and some software may not set it to zero. However
>> we have been running this patch at Virtuozzo for 2 years and have not
>> encountered this problem. Not sure if it is worth to add new
>> ovs_datapath_attr instead.
>>
>>
>> As a broader solution, another generic approach is possible: modify
>> __dev_change_net_namespace() to allow changing ifindexes within the same
>> netns. Yet we will still need to ignore NETIF_F_NETNS_LOCAL and I am not
>> sure that all its users are ready for ifindex change.
>> This will be indeed better for CRIU so we won't need to change every SDN
>> module to be able to checkpoint/restore it. And probably avoid some bloat.
>> What do you think of this?
>>
>> Andrey Zhadchenko (1):
>>    openvswitch: allow specifying ifindex of new interfaces
>>
>>   include/uapi/linux/openvswitch.h     |  4 ++++
>>   net/openvswitch/datapath.c           | 16 ++++++++++++++--
>>   net/openvswitch/vport-internal_dev.c |  1 +
>>   net/openvswitch/vport.h              |  2 ++
>>   4 files changed, 21 insertions(+), 2 deletions(-)
>>
> 
