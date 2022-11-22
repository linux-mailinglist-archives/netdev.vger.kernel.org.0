Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D4A633471
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiKVEbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiKVEba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:31:30 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D42251B;
        Mon, 21 Nov 2022 20:31:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxHIwsQFETqZ+ZBu6C4ZmIWfLUrvhXr1Wgq+KpMZiLegN9szEuf14c+9y7vdRKGMczi0UROV3uviaiQXESAtwAVJz1IzNWah2undVeeIVlDR3NxjTWqadudx2EQgJxLk0RdxjsffhRVgHntSB8MkIfSP60mh6GBCvZ0kIjEqL+psFtUEGblw23zrS7hRYhrKi3TlBFTVkpAhIAyUdQuRrEee12DAWjMhSdk66lJJFZRXWAO8hJ2lSaF+rJC/jrVOAZ1oE/EBtsoEEkscZXs8DGnb6bMXJhX6c0vIvIpuqq20bugiA60Ioo5A2nKi/YMCrv+lE0NZyPJdJEmrUqEN5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQnhue+SvU/Gz597+XrQVMwLqZm9MYNnRkicvnX4O+s=;
 b=T+gSV6b+xEwQoXmHVN7XlRJkyW6pzADhbGDVtMYqzJOX5LXOk1HLFM/+5kuNiAay2W02l3pVphGJD08HpstLPAShQacW6j3bGgF/Kdz29Uj4aJbqe/3VhkRv9rmyvQfpytgDLRJGXxin99++3EntAf/7QehOjWwYUZ/VXH33718sXKel9SdJ1JGYOyIN+civxXUGF8MgGs3O/2I932x7GDnon/4GCS3Asfg4oj5ezNOl9UHxst/AEcdT+wv3KHzTPYCoTfgHaUhjkN32bAG2QDJ191Y6Ws/b3yKlKEv+Ch4vuaPSMCjEcKr9sX6o4FzgvKMPjAkw6uBXWkNv1ht9Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ionos.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQnhue+SvU/Gz597+XrQVMwLqZm9MYNnRkicvnX4O+s=;
 b=tXBvDLFXN3ohZG0AHx0kY3Yt5LFynauFDGX3sd7nR6nBB39woqIebQzvvSGXItw7be7zHRLu4b5YtNITiBW0cTjnOK/wS+qsJwNK+w0ztIqwUV2kmYJNvnYBFIdiBF23B9Popxp5sy6FK5lLK4SMEfvzLk+/yAhb2opkcNNLNq9bN0R+s3JErIyyKKpKpjWQWVPnnqeY0AgnnLx+a0koxu6J3hOI4YaYJ+MDlgMgbCj03NKEhpVfp9GQN/QEi/dZmWLeAzeG6famT59aEKugGpTxBV3dYdmq4KGalWTimukOzYpypjqYDC5wdLuGJ5O5nWGSmE00Jn1EUbCHKNfh5A==
Received: from MW2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:907::23) by
 SA1PR12MB7224.namprd12.prod.outlook.com (2603:10b6:806:2bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 04:31:27 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::c) by MW2PR16CA0010.outlook.office365.com
 (2603:10b6:907::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9 via Frontend
 Transport; Tue, 22 Nov 2022 04:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Tue, 22 Nov 2022 04:31:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 21 Nov
 2022 20:31:12 -0800
Received: from [172.27.1.11] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 21 Nov
 2022 20:31:09 -0800
Message-ID: <51b8abeb-f3de-7a3b-ece0-d5e2fd057bba@nvidia.com>
Date:   Tue, 22 Nov 2022 06:31:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
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
 <54c10b62-5d53-a3a5-48bb-74552e976067@nvidia.com>
 <CAMGffEk8_1AYbfcamfn9BCxDCvOaTm1ndNsVYsn+hz3GRH9B6w@mail.gmail.com>
Content-Language: en-US
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <CAMGffEk8_1AYbfcamfn9BCxDCvOaTm1ndNsVYsn+hz3GRH9B6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|SA1PR12MB7224:EE_
X-MS-Office365-Filtering-Correlation-Id: dd963d34-2818-4d22-4943-08dacc426b90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tn/zhDUukGxN9PjzbCKeuoapQcYuYGDnYIi1SEI6jIapwhP7aL3qtGyFNLbL0UX1kP3mh4QFF6cTnlfp/GbO671fja5KtFv7Drqe95zaUHcQYIaji8FS1cj4J4iEKbIXXwVAUW+XtZq1MvvUGyhgbmPi4bifaRB2JZlTDjVIq7TIEGNGceV3P3nvI2Jes6GO93DblknQuZdXhvQH2LvCCbx6FgYAbHmjd9IjJusibgmMZjin1j3hgcyskYDktPeUCsYhQoRXQf1RICQgTwFZyPFHMLDmXde6PVxmVXVIclHfRL4MKsBfVJL9FQhAgcep/mmeYlqzyHC8kRvsFUU0mkMw10e+LE+adH19QZLgauHZnyAQMMDppJhn4lIXZLoPpIdacQZZv7ODgFpzAfJPWYLoXMDoZ17uhRPFZeif7AEJEIQEcaqv8MVvKQqcBT5zuOKWKQa+6f1PN7FONaw+i42rcYHeaMsfSM84GwBGz7Vchrg4IOoh7GO+BceTcAAnQahWoAhQ5Ax7GBSjR999UH8sEtrEX5NjZY9sIuw3br+AYmtPl9j8Iv3HAieTxk3N9JEVMROAodbkp6lUULcyi5+KZmPe0dEWcD7SCIERC0VwRnTx6kzZhgUWHWjU0namwIgKuigDza2oIyivuj9NYV8GgmEyqNcGuE9uxD8W5mmJaSzwiC5F/q5vKT/oCc9vBMIgCRX77wqK87fBSaUAtrGTrcoj/N1hPRyBvnwfid0=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(107886003)(86362001)(31696002)(6666004)(40480700001)(2906002)(31686004)(70586007)(40460700003)(53546011)(2616005)(54906003)(316002)(16576012)(26005)(4326008)(426003)(70206006)(8676002)(6916009)(5660300002)(83380400001)(478600001)(36756003)(336012)(47076005)(186003)(356005)(7636003)(36860700001)(41300700001)(82740400003)(16526019)(8936002)(82310400005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 04:31:26.9153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd963d34-2818-4d22-4943-08dacc426b90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7224
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/21/2022 11:11 AM, Jinpu Wang wrote:
> External email: Use caution opening links or attachments
>
>
> On Tue, Nov 15, 2022 at 5:41 PM Moshe Shemesh <moshe@nvidia.com> wrote:
>>
>> On 11/15/2022 5:08 PM, Jinpu Wang wrote:
>>> On Tue, Nov 15, 2022 at 6:46 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>>>> On Tue, Nov 15, 2022 at 6:15 AM Moshe Shemesh <moshe@nvidia.com> wrote:
>>>>> On 11/9/2022 11:51 AM, Jinpu Wang wrote:
>>>>>> On Mon, Oct 17, 2022 at 7:54 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>>>>>>> On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
>>>>>>>> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
>>>>>>>>> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>>>>>>>>>> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
>>>>>>>>>>> Hi Leon, hi Saeed,
>>>>>>>>>>>
>>>>>>>>>>> We have seen crashes during server shutdown on both kernel 5.10 and
>>>>>>>>>>> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
>>>>>>>>>>>
>>>>>>>>>>> All of the crashes point to
>>>>>>>>>>>
>>>>>>>>>>> 1606                         memcpy(ent->out->first.data,
>>>>>>>>>>> ent->lay->out, sizeof(ent->lay->out));
>>>>>>>>>>>
>>>>>>>>>>> I guess, it's kind of use after free for ent buffer. I tried to reprod
>>>>>>>>>>> by repeatedly reboot the testing servers, but no success  so far.
>>>>>>>>>> My guess is that command interface is not flushed, but Moshe and me
>>>>>>>>>> didn't see how it can happen.
>>>>>>>>>>
>>>>>>>>>>      1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
>>>>>>>>>>      1207         INIT_WORK(&ent->work, cmd_work_handler);
>>>>>>>>>>      1208         if (page_queue) {
>>>>>>>>>>      1209                 cmd_work_handler(&ent->work);
>>>>>>>>>>      1210         } else if (!queue_work(cmd->wq, &ent->work)) {
>>>>>>>>>>                              ^^^^^^^ this is what is causing to the splat
>>>>>>>>>>      1211                 mlx5_core_warn(dev, "failed to queue work\n");
>>>>>>>>>>      1212                 err = -EALREADY;
>>>>>>>>>>      1213                 goto out_free;
>>>>>>>>>>      1214         }
>>>>>>>>>>
>>>>>>>>>> <...>
>>>>>>>>>>> Is this problem known, maybe already fixed?
>>>>>>>>>> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
>>>>>>>> Sorry it is 5.15.32
>>>>>>>>
>>>>>>>>>> Is it possible to reproduce this on latest upstream code?
>>>>>>>>> I haven't been able to reproduce it, as mentioned above, I tried to
>>>>>>>>> reproduce by simply reboot in loop, no luck yet.
>>>>>>>>> do you have suggestions to speedup the reproduction?
>>>>>>>> Maybe try to shutdown during filling command interface.
>>>>>>>> I think that any query command will do the trick.
>>>>>>> Just an update.
>>>>>>> I tried to run "saquery" in a loop in one session and do "modproble -r
>>>>>>> mlx5_ib && modprobe mlx5_ib" in loop in another session during last
>>>>>>> days , but still no luck. --c
>>>>>>>>> Once I can reproduce, I can also try with kernel 6.0.
>>>>>>>> It will be great.
>>>>>>>>
>>>>>>>> Thanks
>>>>>>> Thanks!
>>>>>> Just want to mention, we see more crash during reboot, all the crash
>>>>>> we saw are all
>>>>>> Intel  Intel(R) Xeon(R) Gold 6338 CPU. We use the same HCA on
>>>>>> different servers. So I suspect the bug is related to Ice Lake server.
>>>>>>
>>>>>> In case it matters, here is lspci attached.
>>>>> Please try the following change on 5.15.32, let me know if it solves the
>>>>> failure :
>>>> Thank you Moshe, I will test it on affected servers and report back the result.
>>> Hi Moshe,
>>>
>>> I've been running the reboot tests on 4 affected machines in parallel
>>> for more than 6 hours,  in total did 300+ reboot, I can no longer
>>> reproduce the crash. without the fix, I was able to reproduce 2 times
>>> in 20 reboots.
>>> So I think the bug is fixed.
>>
>> Great !
>>
>>> I also did some basic functional test via RNBD/IPOIB, all look good.
>>> Tested-by: Jack Wang <jinpu.wang@ionos.com>
>>> Please provide a formal fix.
>>
>> Will do.
> Hi Moshe,
> A gentle ping, when will you send the fix?
>
> Thanks!

Hi, it is part of Saeed's mlx5 fixes patchset.

He sent it a couple of hours ago.

>
>> Thanks!
>>
>>> Thx!
>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>>>> b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>>>> index e06a6104e91f..d45ca9c52a21 100644
>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>>>>> @@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
>>>>>                    cmd_ent_get(ent);
>>>>>            set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
>>>>>
>>>>> +       cmd_ent_get(ent); /* for the _real_ FW event on completion */
>>>>>            /* Skip sending command to fw if internal error */
>>>>>            if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
>>>>>                    u8 status = 0;
>>>>> @@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
>>>>>                    return;
>>>>>            }
>>>>>
>>>>> -       cmd_ent_get(ent); /* for the _real_ FW event on completion */
>>>>>            /* ring doorbell after the descriptor is valid */
>>>>>            mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 <<
>>>>> ent->idx);
>>>>>            wmb();
>>>>> @@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct
>>>>> mlx5_core_dev *dev, u64 vec, bool force
>>>>>                                    cmd_ent_put(ent); /* timeout work was
>>>>> canceled */
>>>>>
>>>>>                            if (!forced || /* Real FW completion */
>>>>> -                           pci_channel_offline(dev->pdev) || /* FW is
>>>>> inaccessible */
>>>>> -                           dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
>>>>> +                            mlx5_cmd_is_down(dev) || /* No real FW
>>>>> completion is expected */
>>>>> +                            !opcode_allowed(cmd, ent->op))
>>>>>                                    cmd_ent_put(ent);
>>>>>
>>>>>                            ent->ts2 = ktime_get_ns();
>>>>>
>>>>>> Thx!
