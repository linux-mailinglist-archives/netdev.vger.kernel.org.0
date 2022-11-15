Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FD3629F35
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbiKOQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiKOQl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:41:29 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA46C2B244;
        Tue, 15 Nov 2022 08:41:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NROPYEcLjxdmfE7Wh/9ZKbTqfQLxNfjcQBK5mJ8yS4JnqIi5BtRmh4QCBhpaPDy5WZJdo3F1p0M45GUat+8iUWLV3bFWyOBvyDP/qmrsGpMhrC9VWacp6d+IsLGYai1CH285qheLmOAg8eJPkbZbMviR18X/7VuP8QHO1QdhxBraW1SME4mNn6bU3L3HSY5hJBdzbP6ZleiuR+de3KkFp/vZOoDL0KQF19lLS85M7RBae4vYN9JgFyovL9xKrHTo+JjfyVxcnz4cRlSY3UR23V3lQHCT0QDr6Uk8FywELv0GzXXZpjae/9c7sMHu2qAqOryUf9n6J+p5Sw18+a2+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcsN6qpZuyeB8fBjpL9R4hzP9Hg9rxoPoTtdCg4mpB8=;
 b=Z6L9sKLdZhBtTAhgeCMeOJtEmjh3qktjY4tWqiqV1j5fyiNCcHTjeuUgr83g6EhlnkPrdD8bbpRFCaOEJ0OoafeWnoFg6W7KmDKZFGTLrtJm4LzxkI6mbw8rGKjuLtNXyj4+zNaWzmzGti5a6jHwnxbXCTlFLgSInt7xOehuAct4ktqVgnlPrgfH+Rd9feejKAJ+WTuHo/Lqief6+m3G27aKSm/N0j753wL6evqDQTAGvxALFEQ7M+3tFVCpb86TRjXorcLrbzVv0K1iiTR61Yv9VubEmIjmV9OBDuaOZD3M7Q//8UcGaOfW4zoDjTEXX7/4dteSxHxiEpWJ1xek1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ionos.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcsN6qpZuyeB8fBjpL9R4hzP9Hg9rxoPoTtdCg4mpB8=;
 b=QomQQWbjSHEqtfk26QowIVBR7jLodjkfpVN/ZHFvi09YmKKrSNPJHTaVSG5EOepQsYAX4VP+y0165dMrt324tlz53vvWH5F+Uid6IW4Uhezh/Dzp1ts7lBN2ko0tCB+nnhRHtKcC/S43oeagerI1JVTj7jSH4BR3lWsymUlTDZIzmkfzeIfz7hrvcdpc8syWQBEUv1q68kYpBPjXaLrJPooQUa9IBoStOLAOH2lxo1WoTjjbcn8G6yx6IpCCDLBehlDf0qdXcYWUcmn9kmW58ZGyxXyX73pGP3EPs5cBctB9jhhhF9o3PCQKjtZ9X4TatwZGZovFsUUvikRYvLyWCQ==
Received: from BL1PR13CA0211.namprd13.prod.outlook.com (2603:10b6:208:2bf::6)
 by PH8PR12MB7350.namprd12.prod.outlook.com (2603:10b6:510:216::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 16:41:26 +0000
Received: from BL02EPF0000EE3D.namprd05.prod.outlook.com
 (2603:10b6:208:2bf:cafe::28) by BL1PR13CA0211.outlook.office365.com
 (2603:10b6:208:2bf::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Tue, 15 Nov 2022 16:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000EE3D.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Tue, 15 Nov 2022 16:41:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 08:41:09 -0800
Received: from [172.27.11.234] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 08:41:06 -0800
Message-ID: <54c10b62-5d53-a3a5-48bb-74552e976067@nvidia.com>
Date:   Tue, 15 Nov 2022 18:41:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
Content-Language: en-US
To:     Jinpu Wang <jinpu.wang@ionos.com>
CC:     Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>,
        "RDMA mailing list" <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, Shay Drory <shayd@nvidia.com>
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal>
 <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
 <Y0foGrlwnYX8lJX2@unreal>
 <CAMGffEnWmVb_qZFq6_rhZGH5q1Wq=n5ciJmp6uxxE6JLctywng@mail.gmail.com>
 <CAMGffEmY6SGPg8KMMFCFKtv4wiF1VOtVnA7JPnXhz5LKrJsiJA@mail.gmail.com>
 <82a62c6c-1616-ebb4-6308-ce56ec176cf3@nvidia.com>
 <CAMGffEk5=BWNVROHs185WfNH0DRiGpdQnS7aSgD74yjhT803tw@mail.gmail.com>
 <CAMGffEkaZUDLfXQXK239Nt-DSxqkZpbC=8zUeubv0pxLuoMcZw@mail.gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <CAMGffEkaZUDLfXQXK239Nt-DSxqkZpbC=8zUeubv0pxLuoMcZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3D:EE_|PH8PR12MB7350:EE_
X-MS-Office365-Filtering-Correlation-Id: 9305436e-856a-4215-28eb-08dac7283cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrwvWb1zTBTjGupuNQpmgF0mU3VQgATP7Jdra2MfPyndMHK36juScEty/caGZoAqRmPoP50ctYmCP0+nyhiied89gXeiiEvwKQVP1ozJDLXm+67vi0fA2Nrl4rtIww4QW5TIHs6+SNG+h+SlfOToysxrjFHMNiq/MhgGC/Edfwltb/6noGE1kq5eZtuzZLNctRhsbw4ehef0q49UjWe0fgN/rLLHS0jV942/wCMS7zr9yuuYgrkb3XsE0Nv0DqfvTXWuUG4mbt3/+SNlxIO1REWwI6Rl8D4oJ2E/qsXJ+b4kGctj+Hc3weEM/comObSndyJYKHHNAuiGAw+XApmkOVXDV/yo/1PrnjXTrUCRrumUpUWH454YBVrIsPIe1HIM3Wk7h1HJukK2qKAOPSj1X1r/vyb4gHE42R5jdS+6laVqyJtO9kprx1UB78eD/irPxNuP7992qo8SQSXJUwbNWetf0gUEktQiUdvgYRP+iKI/zjnJuU3a1aoyBHXCHGTvh6VoicTFCoBdINTfxV2RSS8fTS+AdHizZktzY8E5DdWSdqJaujbWcn0WNDboIHGa1VIsHMqDieYxH3QQ5hUejxqjP0yk3D7XuuQ95MPSJW0PLjOsW3t3qJAzltf7xOaRG6p1zNGmszn4HqMkJzCsxOfbnG5d7XmO9P1EyGlRMBCxH43I2q6r5Mc/KdUtSe35JXJb8GLC3UyyvOLu3upVNHWuTYDS7fe5fZDVAgcWvjrLU5Znz2ey03zcCyH6qgeZRaugXpMOvFzdBiurQEAhX0xIq/3WnqY7l+1iErE8lBWDcWE/hK3u6G5jcz+QZXK+
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(36860700001)(6916009)(54906003)(316002)(2906002)(16576012)(47076005)(4326008)(16526019)(83380400001)(41300700001)(40460700003)(336012)(186003)(5660300002)(2616005)(53546011)(8936002)(40480700001)(36756003)(426003)(8676002)(31686004)(70586007)(26005)(70206006)(82310400005)(478600001)(107886003)(31696002)(82740400003)(86362001)(7636003)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 16:41:25.9331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9305436e-856a-4215-28eb-08dac7283cee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/15/2022 5:08 PM, Jinpu Wang wrote:
> On Tue, Nov 15, 2022 at 6:46 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>> On Tue, Nov 15, 2022 at 6:15 AM Moshe Shemesh <moshe@nvidia.com> wrote:
>>>
>>> On 11/9/2022 11:51 AM, Jinpu Wang wrote:
>>>> On Mon, Oct 17, 2022 at 7:54 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>>>>> On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
>>>>>> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
>>>>>>> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>>>>>>>> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
>>>>>>>>> Hi Leon, hi Saeed,
>>>>>>>>>
>>>>>>>>> We have seen crashes during server shutdown on both kernel 5.10 and
>>>>>>>>> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
>>>>>>>>>
>>>>>>>>> All of the crashes point to
>>>>>>>>>
>>>>>>>>> 1606                         memcpy(ent->out->first.data,
>>>>>>>>> ent->lay->out, sizeof(ent->lay->out));
>>>>>>>>>
>>>>>>>>> I guess, it's kind of use after free for ent buffer. I tried to reprod
>>>>>>>>> by repeatedly reboot the testing servers, but no success  so far.
>>>>>>>> My guess is that command interface is not flushed, but Moshe and me
>>>>>>>> didn't see how it can happen.
>>>>>>>>
>>>>>>>>     1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
>>>>>>>>     1207         INIT_WORK(&ent->work, cmd_work_handler);
>>>>>>>>     1208         if (page_queue) {
>>>>>>>>     1209                 cmd_work_handler(&ent->work);
>>>>>>>>     1210         } else if (!queue_work(cmd->wq, &ent->work)) {
>>>>>>>>                             ^^^^^^^ this is what is causing to the splat
>>>>>>>>     1211                 mlx5_core_warn(dev, "failed to queue work\n");
>>>>>>>>     1212                 err = -EALREADY;
>>>>>>>>     1213                 goto out_free;
>>>>>>>>     1214         }
>>>>>>>>
>>>>>>>> <...>
>>>>>>>>> Is this problem known, maybe already fixed?
>>>>>>>> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
>>>>>> Sorry it is 5.15.32
>>>>>>
>>>>>>>> Is it possible to reproduce this on latest upstream code?
>>>>>>> I haven't been able to reproduce it, as mentioned above, I tried to
>>>>>>> reproduce by simply reboot in loop, no luck yet.
>>>>>>> do you have suggestions to speedup the reproduction?
>>>>>> Maybe try to shutdown during filling command interface.
>>>>>> I think that any query command will do the trick.
>>>>> Just an update.
>>>>> I tried to run "saquery" in a loop in one session and do "modproble -r
>>>>> mlx5_ib && modprobe mlx5_ib" in loop in another session during last
>>>>> days , but still no luck. --c
>>>>>>> Once I can reproduce, I can also try with kernel 6.0.
>>>>>> It will be great.
>>>>>>
>>>>>> Thanks
>>>>> Thanks!
>>>> Just want to mention, we see more crash during reboot, all the crash
>>>> we saw are all
>>>> Intel  Intel(R) Xeon(R) Gold 6338 CPU. We use the same HCA on
>>>> different servers. So I suspect the bug is related to Ice Lake server.
>>>>
>>>> In case it matters, here is lspci attached.
>>>
>>> Please try the following change on 5.15.32, let me know if it solves the
>>> failure :
>> Thank you Moshe, I will test it on affected servers and report back the result.
> Hi Moshe,
>
> I've been running the reboot tests on 4 affected machines in parallel
> for more than 6 hours,  in total did 300+ reboot, I can no longer
> reproduce the crash. without the fix, I was able to reproduce 2 times
> in 20 reboots.
> So I think the bug is fixed.


Great !

> I also did some basic functional test via RNBD/IPOIB, all look good.
> Tested-by: Jack Wang <jinpu.wang@ionos.com>
> Please provide a formal fix.


Will do.

Thanks!

>
> Thx!
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>> b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>> index e06a6104e91f..d45ca9c52a21 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>> @@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
>>>                   cmd_ent_get(ent);
>>>           set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
>>>
>>> +       cmd_ent_get(ent); /* for the _real_ FW event on completion */
>>>           /* Skip sending command to fw if internal error */
>>>           if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
>>>                   u8 status = 0;
>>> @@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
>>>                   return;
>>>           }
>>>
>>> -       cmd_ent_get(ent); /* for the _real_ FW event on completion */
>>>           /* ring doorbell after the descriptor is valid */
>>>           mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 <<
>>> ent->idx);
>>>           wmb();
>>> @@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct
>>> mlx5_core_dev *dev, u64 vec, bool force
>>>                                   cmd_ent_put(ent); /* timeout work was
>>> canceled */
>>>
>>>                           if (!forced || /* Real FW completion */
>>> -                           pci_channel_offline(dev->pdev) || /* FW is
>>> inaccessible */
>>> -                           dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
>>> +                            mlx5_cmd_is_down(dev) || /* No real FW
>>> completion is expected */
>>> +                            !opcode_allowed(cmd, ent->op))
>>>                                   cmd_ent_put(ent);
>>>
>>>                           ent->ts2 = ktime_get_ns();
>>>
>>>> Thx!
