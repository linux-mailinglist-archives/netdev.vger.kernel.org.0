Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8FC694C9F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBMQ0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBMQ0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:26:00 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0CE5252
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:25:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsefGEUhw0TOmoSnpFbQUe1ztrKnICdMXkE2sOodJ4ScDo4J72fn3RlcTM7vePajOR959Vpa76vXOYVoPUP/Ym2412GNS8Qqla3UlIBYkMIEmxJ9pf3gFsxtgQPmNpcuMvtrXknmLMbW5zv27p2zYi1PFd4zHlQ1RiHI+ELgsG3XE/MUOj/Urz0RpOK0KNiXJe2k4KSYr5hVYcY5usQmlA3tCM9cDjDUL3YL0s4ATZuenFUYCjp7WO1QLQ5kk39KP60dCxb9tt7krlV6wspwHB5J9WZ605jXB5WJchzEA1O+bl66cNXZt3+PM9qIi+vGOdJe2N8/IGym4dbQmRr+cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Htr1/LG7qT+oKRV3B8Dt9t57yk8DpxRvT73KOoUn8w=;
 b=dlnQfxEG9ogw/jc/QGIMpIKmE1vZIBxhCkLXTdjQ8aviYQb23B4apVeCpHtB8Zt/E7t30Yavd5q0gIaUL2MoLh7/PqWrsdjnsKkT37pSOIj44NsRPnI7V9iL5OJiUFGTxL1l9EAcKZumARIHQGOfyUU0MFfo69w4GVac1aJciGdjVeV/Rg6Nm/Kkvb4v+l+Aj4zGeRBF/mNfVL9VGLN2FM9aFRWYJ0YyBJ9nCgjxvoOYPrFs+jHRB9oDJyHYM3u/b1Zsx1Oz5eZGObBNlcJYCytlTYEmM3Cdjx6DeYYyCpyttbB75hhQAXCqLbfrfZrD7KTWph4fFkQRmk6emnaHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Htr1/LG7qT+oKRV3B8Dt9t57yk8DpxRvT73KOoUn8w=;
 b=O+3+bSIgvS1wB9ene6Og9RTBWeFsUCEHvj6BG0U3oHBdxxhOwfRVu7R3/0GXhlWqFDPKDzSn92O0hN0IDYOczxgEZ+fvTc79kqfld81ssRFpU0EgB0CFFgdJDPA7aeYJqH8qnwbf7a/ZJqm+YTRqhI2P8rGjxdDA6uWCjCZAwB5ifT/crhBO+Yg9RLGA/itHmmF3KFNZeMJ8yVpoG98c4uJz2xhhEJ4Qv1fZO3vtWKXkLBj6eFtYzZtL7peCYQgORSvkElGurEWqETsHuGT578KRCDXXPg5o4fpR/1YhkRZgtuzxYwj9c8fxauxMpLgwJyz1fs+YCWopY8g+fd3VDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 16:25:26 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 16:25:25 +0000
Message-ID: <237cde33-022a-5d1c-d949-19773542f86b@nvidia.com>
Date:   Mon, 13 Feb 2023 18:25:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v9 0/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230210015607.xjq2gorwpg4q3zxv@t14s.localdomain>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <20230210015607.xjq2gorwpg4q3zxv@t14s.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0289.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::6) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 25183f35-1320-4ecb-7e4e-08db0ddee961
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxIS525YOJLRRAFMi4fW1floQcBOR3z13r7AY2Lf1p5ZHoA4Q91gGGYaM3ioLsV9gq+r3F9n90SFeEC/OmvtJc+xUFCI67SII20xxDmOkHk530/GaJ4u4iGBMYdl+J3+p0tFtrc5GQzn3KXSk/jMttPAWZFNBp9wSfJlZHYx/gLjN0TNHrLpEiVU4dCG8b296nniOgjxgxN6eEdjz4t2YNWcgHQgmSSVFtKu4TRGFxRJ+luHOY0UbAaGgfLH/MBNn29Ef7tZkqrYLhIo7+T7CdHBcjY3058gBX2NzOGL/Ni4mhRaTPiIFSCgOiLZzBD9WvDP9X3/h+GhxC8OarYEvCe1OwQxJvFw6dMrocRqkdmzBkciF/MHbmPelIqgbv4BhjQKyZ/58XeKKPemWQJtGtlz57UNQWksK8HW6wcFHEQRO3UtQBgAngomQJbhcaTVx9bkp7fv08FrUGL9FHGbbPdxtBe+OQUaadwN1cjDryv+yXdHCtBoShQZyvKr4prbVcvNLPdeO3VIcqxIZwn7exWBuEh1ORxL/9FXGCGMrwE5GJ2AOz6ooaxpmEW5HeJly1aCicX/WM4Wmt5aABFJBWBgKQuecf5biYdK7fm1zR4LqVqoa3mrkky3LEcWqMOJAGCo/+cvqQBFdzTMn1xlNsgdOsl8OK3tNLccioRLtCu/xmeOZBTHqV5lXNY7EMwtmN9S3RrAS3RpWUs6TQ9+YUYBsfAtBTQErE06OJ8dphA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199018)(31696002)(2616005)(66946007)(6666004)(478600001)(6486002)(186003)(6512007)(26005)(6506007)(66476007)(8676002)(66556008)(53546011)(41300700001)(4326008)(54906003)(316002)(6916009)(83380400001)(38100700002)(107886003)(5660300002)(8936002)(36756003)(2906002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGsxczRBQ1NiL0NmUmpveVVZRmRMeU9RM2Vva1plY1BQK2ZOTjZ5VVAyNEhY?=
 =?utf-8?B?SVRHSTlnTEhja04rQUxnc1VMUjZXU003OFFOb1R5OCsyQ2hPakV5QXJ2eWkr?=
 =?utf-8?B?alp4YzkvR0laNytYUjkxNzQySzdpM1JwZDVEekxyU1B5Z2FiQzd2RWttZC9N?=
 =?utf-8?B?Z2cwZ2FYdzNQN2F0aGlDRkEzbDdaK1BPdVRqNkFzaUo2cE56VkI5QXNMQjVx?=
 =?utf-8?B?dEViY1EyeU5XUmU5eUpaSzNLRVVRSjFRZlQwZk1LSDcrVjk0NUtmcHVicnFE?=
 =?utf-8?B?NTVQL1lkRXRvbTlobTFHQU4vd2h6S21NMW5mTmpINHVVOTJXczNRNlQwdmFR?=
 =?utf-8?B?MTdhY1lZWDl3STBsTkZWSHlQMm84LzFPVlBWMEQ1MlFlYTdzQmFLbHdhNjlk?=
 =?utf-8?B?c2VqUDFCdGlHRmlyU2QzUmZpK0E2VnA2aFRMTE1vUzlNUGxxTzBmM043NXJ2?=
 =?utf-8?B?djBwdWU4dkdUZWdGMXdVTEZSVkZPUnZjWS9BT3RUYVY4U1ZoMmI4WG10Ujkz?=
 =?utf-8?B?QW5HM1NpTmp0UEc1L2dNY01ZVGFQZk5mNTNPYW9uaWVVbGQwZ3labzdyZXdK?=
 =?utf-8?B?bEVFNHlVdlkwVXFVbFJGUFFhUnRtRzYzZzVYK0thekZWMjBEeWRVYndnRWlt?=
 =?utf-8?B?Y2VHU0gxNUlRWHFWMzRqSGtkMXFIbTN2QmVYSnNFWUtHV1orTXFlWnFYN1pM?=
 =?utf-8?B?c2o0dWZ4VmtlbDhGUno1VktscDUxOENyYXAwK2dEVnFHVzRwblJEeU1zNElJ?=
 =?utf-8?B?TmNUblpNQ0J0SFd5bjBXSVlSL0l6R3lsaDdlWUxFbVFyd3I3Y05nTmJIdHlK?=
 =?utf-8?B?V1RZSjBKd1gxdUttdXVnYW9MWXFLcWNMVW01VnUyMWpMQnZrTDNKTWNja2Fm?=
 =?utf-8?B?U2xrcHdPaFUwZGF0dUR5bzVGVDRyQTdwenFGa1RMcWNOV2pvbXJrSlF0Q0Fx?=
 =?utf-8?B?TXplOThSQVE5TTI5VFpxZ091SXAyZGcxTWpubHhPVy9pc1FIRTJzalNrWjdQ?=
 =?utf-8?B?RW5kcGxKVzJiRWRuWnladUNJK2NVSVJEWUlQQmFuMjBQRGVadEQwVFYya0N0?=
 =?utf-8?B?QTh5R2VOK1RCanBNNXBpSHJSbllBRkdVNFdzSTl6VE0rQ0crekFNS2kycDBG?=
 =?utf-8?B?N2NaNjA1WEt6UllFQzJTNzRoamtDd0tZMGNsdWRkYVowa2szVlZPUWVoWnJx?=
 =?utf-8?B?c1BDVjA3TU5vR0liYU9OUnRQR0IwWk1jSzFXbFdUeUZ0NUFkQmNNSXR2TElH?=
 =?utf-8?B?alhPQ2NxRGVoWE5KRXZmYkR0bHZrUURJSjhPRDFiOHdibTVyZFduNXAzbSti?=
 =?utf-8?B?dUxIaDJBeWdTSUlnbTlhUWk4dEF4eTNTMWQ4OHFJWi9ZUk9XVGVHZHlZVStU?=
 =?utf-8?B?NnR0bkVUN3pHOW1RWGh4WG5YQ1pwdXQvZlUwSE1vam1ZWG9XZ1pEM3l0c0xy?=
 =?utf-8?B?SitZKzBnUjR1OHR1ZWZUK3NHV21ma1ZUcTJmNWs4ZmNWOHdsMzNJeUc4cXcw?=
 =?utf-8?B?aThWL1Z6TnR3NEZCcFh2VFhoUEpSZVpDcEdFYXFRRVJwNVhMVnZ6T0dham1G?=
 =?utf-8?B?Y0pLKzVqZnlsTVVmMG8xZDRKZ2Y3cVVqYmpxWjhUM2ppcy9wL1ZwRjZ4d2F3?=
 =?utf-8?B?U0RtTk1XUWFYS1pyb1hiYWQ5UjAwVkEzQnliS1cxOGI3MmVaTHJRKzFiNGU4?=
 =?utf-8?B?WnUvNjNpYW5PNUpaNUhFWDdwSnhXemR0K3JDcVU5K01SdmdXY1NKdEFtTkJS?=
 =?utf-8?B?RmhtaWRpUGhFSExpalB6ZUlKRXZvbnNWZThyUEJNQTdIVHhXYmpoZlNoZUpJ?=
 =?utf-8?B?WEN4NlNqNWVaVWhwaUp3R25taEtoYzdNVjlqVXcvbW9iL3FTbzkwSUxhNmNu?=
 =?utf-8?B?OFBvbkw1OHpJSTRtOUNjZ2FReHMvaXRlOVh5V3VYcjlJdm1GTjFnWnRYRDM2?=
 =?utf-8?B?RUdLakZDWU9RY2RMK2hzbEk4K2RuZHlFYWtXM29UUWZMVWI1MmxkeWN6UHFi?=
 =?utf-8?B?allvS2xQMGFSQ2hMSm9QTkhUMEV6VnlJWE5tSDluRld1MjJ3S2M2QmYvV1lz?=
 =?utf-8?B?MjF1d2tHYVF6MElKNWVLNmtKRXR1YitoSklVSDI3a2EwYTRWeFkyZGxpRjlE?=
 =?utf-8?Q?3dND/mZkD1/gmX8OuOEPn9MvJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25183f35-1320-4ecb-7e4e-08db0ddee961
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 16:25:25.5406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwi9N0vdoPwci9fVSbU8sTQ0H72EPHkytHljoCid9CcWrjecY001FY+qWvzWZ5HYdH8kRwOk22mfDg5NLDg/Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/02/2023 03:56, Marcelo Ricardo Leitner wrote:
> Hi,
> 
> On Mon, Feb 06, 2023 at 07:43:56PM +0200, Paul Blakey wrote:
>> Hi,
>>
>> This series adds support for hardware miss to instruct tc to continue execution
>> in a specific tc action instance on a filter's action list. The mlx5 driver patch
>> (besides the refactors) shows its usage instead of using just chain restore.
>>
>> Currently a filter's action list must be executed all together or
>> not at all as driver are only able to tell tc to continue executing from a
>> specific tc chain, and not a specific filter/action.
>>
>> This is troublesome with regards to action CT, where new connections should
>> be sent to software (via tc chain restore), and established connections can
>> be handled in hardware.
>>
>> Checking for new connections is done when executing the ct action in hardware
>> (by checking the packet's tuple against known established tuples).
>> But if there is a packet modification (pedit) action before action CT and the
>> checked tuple is a new connection, hardware will need to revert the previous
>> packet modifications before sending it back to software so it can
>> re-match the same tc filter in software and re-execute its CT action.
>>
>> The following is an example configuration of stateless nat
>> on mlx5 driver that isn't supported before this patchet:
>>
>>   #Setup corrosponding mlx5 VFs in namespaces
>>   $ ip netns add ns0
>>   $ ip netns add ns1
>>   $ ip link set dev enp8s0f0v0 netns ns0
>>   $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
>>   $ ip link set dev enp8s0f0v1 netns ns1
>>   $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
>>
>>   #Setup tc arp and ct rules on mxl5 VF representors
>>   $ tc qdisc add dev enp8s0f0_0 ingress
>>   $ tc qdisc add dev enp8s0f0_1 ingress
>>   $ ifconfig enp8s0f0_0 up
>>   $ ifconfig enp8s0f0_1 up
>>
>>   #Original side
>>   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
>>      ct_state -trk ip_proto tcp dst_port 8888 \
>>        action pedit ex munge tcp dport set 5001 pipe \
>>        action csum ip tcp pipe \
>>        action ct pipe \
>>        action goto chain 1
>>   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>      ct_state +trk+est \
>>        action mirred egress redirect dev enp8s0f0_1
>>   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>      ct_state +trk+new \
>>        action ct commit pipe \
>>        action mirred egress redirect dev enp8s0f0_1
>>   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
>>        action mirred egress redirect dev enp8s0f0_1
>>
>>   #Reply side
>>   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
>>        action mirred egress redirect dev enp8s0f0_0
>>   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
>>      ct_state -trk ip_proto tcp \
>>        action ct pipe \
>>        action pedit ex munge tcp sport set 8888 pipe \
>>        action csum ip tcp pipe \
>>        action mirred egress redirect dev enp8s0f0_0
>>
>>   #Run traffic
>>   $ ip netns exec ns1 iperf -s -p 5001&
>>   $ sleep 2 #wait for iperf to fully open
>>   $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
>>
>>   #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
>>   $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
>>          Sent hardware 9310116832 bytes 6149672 pkt
>>          Sent hardware 9310116832 bytes 6149672 pkt
>>          Sent hardware 9310116832 bytes 6149672 pkt
> 
> I see Jamal had asked about stats on the other version, but then no
> dependency was set. I think we _must_ have a dependency of this
> patchet on the per-action stats one. Otherwise the stats above will
> get messy.  Without the per-action stats, the last one is replicated
> to the other actions. But then, will hw count the packet that it did
> only the first action? I don't see how it would, and then for the all
> but first one the packet will be accounted twice.
> 
> With this said, it would be nice to provide a sample of how the sw and
> hw stats would look like _after_ this patchset as well.
> 
> Btw I'll add my Reviewed-by tag to the per-action stats one in a few.


This patchset actually doesn't need to rely on the per actions stats 
because the driver is still reordering the action list so CT will be 
first and the example in cover letter will be rejected because it can't 
be reordered. Then we are still doing all (CT and the rest) or nothing.

But we wanted to confirm the API before committing the rest of the 
driver patches since its has a lot of refactors so we split it to two 
series - API, then only MLX5 DRIVER. This is just the API with a bare 
minimal driver change to just use the API. From tc user perspective 
nothing changed here.

So do we first continue with this (after i fix your suggestions), and 
then we'll submit the rest, or should I rebase on the per action stats, 
add even more mlx5 patches here which are mostly not relevant, since I 
think we are ok with the API changes.


> 
>>
>> A new connection executing the first filter in hardware will first rewrite
>> the dst port to the new port, and then the ct action is executed,
>> because this is a new connection, hardware will need to be send this back
>> to software, on chain 0, to execute the first filter again in software.
>> The dst port needs to be reverted otherwise it won't re-match the old
>> dst port in the first filter. Because of that, currently mlx5 driver will
>> reject offloading the above action ct rule.
>>
>> This series adds supports partial offload of a filter's action list,
> 
> We should avoid this terminology as is, as it can create confusion. It
> is not that it is offloading action 1 and not action 2. Instead, it is
> adding support to a more fine grained miss to sw. Perhaps "support for
> partially executing in hw".
> 
>> and letting tc software continue processing in the specific action instance
>> where hardware left off (in the above case after the "action pedit ex munge tcp
>> dport... of the first rule") allowing support for scenarios such as the above.
>>
>> Changelog:
>> 	v1->v2:
>> 	Fixed compilation without CONFIG_NET_CLS
>> 	Cover letter re-write
>>
>> 	v2->v3:
>> 	Unlock spin_lock on error in cls flower filter handle refactor
>> 	Cover letter
>>
>> 	v3->v4:
>> 	Silence warning by clang
>>
>> 	v4->v5:
>> 	Cover letter example
>> 	Removed ifdef as much as possible by using inline stubs
>>
>> 	v5->v6:
>> 	Removed new inlines in cls_api.c (bot complained in patchwork)
>> 	Added reviewed-by/ack - Thanks!
>>
>> 	v6->v7:
>> 	Removed WARN_ON from pkt path (leon)
>> 	Removed unnecessary return in void func
>>
>> 	v7->v8:
>> 	Removed #if IS_ENABLED on skb ext adding Kconfig changes
>> 	Complex variable init in seperate lines
>> 	if,else if, else if ---> switch case
>>
>> 	v8->v9:
>> 	Removed even more IS_ENABLED because of Kconfig
>>
>> Paul Blakey (7):
>>    net/sched: cls_api: Support hardware miss to tc action
>>    net/sched: flower: Move filter handle initialization earlier
>>    net/sched: flower: Support hardware miss to tc action
>>    net/mlx5: Kconfig: Make tc offload depend on tc skb extension
>>    net/mlx5: Refactor tc miss handling to a single function
>>    net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
>>    net/mlx5e: TC, Set CT miss to the specific ct action instance
>>
>>   .../net/ethernet/mellanox/mlx5/core/Kconfig   |   4 +-
>>   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
>>   .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
>>   .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  39 +--
>>   .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
>>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
>>   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 280 ++++++++++++++++--
>>   .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  23 +-
>>   .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
>>   .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
>>   include/linux/skbuff.h                        |   6 +-
>>   include/net/flow_offload.h                    |   1 +
>>   include/net/pkt_cls.h                         |  34 ++-
>>   include/net/sch_generic.h                     |   2 +
>>   net/openvswitch/flow.c                        |   3 +-
>>   net/sched/act_api.c                           |   2 +-
>>   net/sched/cls_api.c                           | 213 ++++++++++++-
>>   net/sched/cls_flower.c                        |  73 +++--
>>   18 files changed, 602 insertions(+), 327 deletions(-)
>>
>> -- 
>> 2.30.1
>>
