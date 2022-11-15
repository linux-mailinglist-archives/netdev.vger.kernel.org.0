Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA8962916C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiKOFPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKOFPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:15:11 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FC8B7F3;
        Mon, 14 Nov 2022 21:15:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+3V0W6qKY8+RvDAach13ssfI08BAiT98OIPDa5LNXeiET/6gmNBzKc4MHI2EomjBZMzbMjNGWbTtNRsmNs4HBOab6lPY9whJRCmZF7c1NEiJj7FaVMs2ruL3PA3K+MQgjeSUKQFS63i0xKX5nZZvaKQBu2J/Et8z3cTUXb5P0YrKXuPf/j/LzWLrJq2HS2GYGuyAh6JUSPHP+k626y5sVqEN/WcYb8SaRSUmKGR8UaCo4eomahLlcOclAk6vziYBpGO0FSEq+n5CA4Yj4EdQjjrBWJRpinMgr7aYhiaycc+EEvC5RqEkSnCigPCSquCQumRJilWD2hQyaQXSXuj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUyJkQjyz7RuseywJJ2tgRqqpMgliU/NIVa2hnXpFsY=;
 b=WXNTtCh/xHHEP9WvvPWiWoc8c1U4q6dSolbFOtoThkkY8HhSp5b8RNrU8ypVAudllQuRGZBhf6d/rR2P1viXvhXyi1eIjNUf/nYwL5xlMOQXl9vBI8OMiO3XpzGlO1tiiTq49kmv8pSi0H4b5hqggpUEQCYEQfYMtc+S4T+6dJ2sLuNLKo469pN1yvPrbSI4+4SlEvV89kcoCkxiGzrGdF1+lbe0o+2JpM466n3n3eGWlbfz+M9tBpHRR2urLGUojOh5+CvJHhp5jkPcdnolK+ARWoF/cQgxzqD0G/ScxG9W0IrscbNH5bnpo4falOAGtRFcvVpWI+QwSxaOOA+jBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ionos.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUyJkQjyz7RuseywJJ2tgRqqpMgliU/NIVa2hnXpFsY=;
 b=ioX9J7ibUoTqQh6cPNN/cDMwqoMTdl4bqTFI42/dGG1K7Ly8QAOLN+npnYe9c8Pi13le2xWMsI/Dw77WLOz2nDLTdlZC/Nz43/17T3qdMrrEK2HExWp8BtAHJlvkgz9ROvVSBEfUI/G5J/mbe+RzLSQHxElJ/Q+HtkLk98xGm/7NMZ+kM1giP70kyQLmIuwMo7B8kS7AVnr5ANJcT1rmWyNHBjvz1lO2f/BoruiLQ8jvLlGscR9gR6LwLP8YEj6mlpnkka6YHspDo5C9BpnsZ6TSkYjaic6tyJJeX/peklthGO5CnZOhDfWSPvlJyAS1jPNbWxe3Jgo9Hr1i4KhczQ==
Received: from MW2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:907:1::26)
 by CH2PR12MB5017.namprd12.prod.outlook.com (2603:10b6:610:36::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 05:15:08 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::5f) by MW2PR16CA0049.outlook.office365.com
 (2603:10b6:907:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13 via Frontend
 Transport; Tue, 15 Nov 2022 05:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Tue, 15 Nov 2022 05:15:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 14 Nov
 2022 21:14:56 -0800
Received: from [172.27.1.68] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 14 Nov
 2022 21:14:53 -0800
Message-ID: <82a62c6c-1616-ebb4-6308-ce56ec176cf3@nvidia.com>
Date:   Tue, 15 Nov 2022 07:14:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
To:     Jinpu Wang <jinpu.wang@ionos.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, Shay Drory <shayd@nvidia.com>
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal>
 <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
 <Y0foGrlwnYX8lJX2@unreal>
 <CAMGffEnWmVb_qZFq6_rhZGH5q1Wq=n5ciJmp6uxxE6JLctywng@mail.gmail.com>
 <CAMGffEmY6SGPg8KMMFCFKtv4wiF1VOtVnA7JPnXhz5LKrJsiJA@mail.gmail.com>
Content-Language: en-US
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <CAMGffEmY6SGPg8KMMFCFKtv4wiF1VOtVnA7JPnXhz5LKrJsiJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|CH2PR12MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: eb78ff44-aba4-4806-7a03-08dac6c85cf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SB82ZLxVWscEuIDGaYhqST69+6RdODIcAt5M418sIur3/OSD3cpvMJu9vGiu5kmD7xJmfWDCICPDMZ9lj92AnBbubaUCjvEDzijj6z4cz38LrduEZyJu1b+d/sFDzkkYqIKpBg1BgnMe3eTXeoX6/oCO/+YpLYc4cJFjsnPWCNEklXQTKCaerImwTXBFwkWMcYWo7bcJsTFcmSC7aYbASQYaPlPqPOFm3CrsNUUgcKSZ7FxHwaCFKGtd5EsL64bFloORqKNUtWBUwn+7+3xoQ1lWIPqjBUXBR5/f/28CFrnZZAG3l4HbIl1lMLkkS4PiPnr/qFvKdii0Mqym6CAgT30eK9ygqKf4GAIKCMJguOt0tLvEbFh6GVRxqachwqB9+QfVbXE/VHSCcxsvV2puUo+Yny1jOP+BDfq3TZRqn9pLT57bMKc2ql+oGn3He+eLMpHLXQzSGYfHk5i8umygfERDFtEIvfr8qin9SKMgLe7LEZouyNzkDtM4r2MWRO5/hsWsI7DWG8MW+kPqXrp+acMRRhBX+gGLm3JgNesL/Wv4Fe162pW7IAGdk6g363MGqX23MCrU1aPnnUlsqE+mWtEygJGX5AT3Z5o7SevHcEngItUoNLfseJLY8WV41zCd4Trm4n2640Qe0hHA6/czB+HHTct0gTga8r6UXtLwoWivrZmJ8yPmcPzTp8zKv6zFGIs+gUCVWLaChE2K2DDXGJI1n1uirBN0znk5lZIbL4REVpqqwxjvuWENQ6zcTkCFZryiUcdIBAXDxF5bk0eSSojUES0g/61nqxeWOojSTDS+SBhFsI1MTzmys139tnG0
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36840700001)(40470700004)(46966006)(107886003)(31686004)(40480700001)(82310400005)(426003)(47076005)(478600001)(36860700001)(54906003)(110136005)(16576012)(316002)(70586007)(70206006)(26005)(53546011)(8676002)(36756003)(4326008)(41300700001)(2616005)(8936002)(186003)(40460700003)(16526019)(7636003)(5660300002)(82740400003)(336012)(356005)(83380400001)(31696002)(86362001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 05:15:08.0497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb78ff44-aba4-4806-7a03-08dac6c85cf1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5017
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/9/2022 11:51 AM, Jinpu Wang wrote:
> On Mon, Oct 17, 2022 at 7:54 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>> On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
>>> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
>>>> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>>>>> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
>>>>>> Hi Leon, hi Saeed,
>>>>>>
>>>>>> We have seen crashes during server shutdown on both kernel 5.10 and
>>>>>> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
>>>>>>
>>>>>> All of the crashes point to
>>>>>>
>>>>>> 1606                         memcpy(ent->out->first.data,
>>>>>> ent->lay->out, sizeof(ent->lay->out));
>>>>>>
>>>>>> I guess, it's kind of use after free for ent buffer. I tried to reprod
>>>>>> by repeatedly reboot the testing servers, but no success  so far.
>>>>> My guess is that command interface is not flushed, but Moshe and me
>>>>> didn't see how it can happen.
>>>>>
>>>>>    1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
>>>>>    1207         INIT_WORK(&ent->work, cmd_work_handler);
>>>>>    1208         if (page_queue) {
>>>>>    1209                 cmd_work_handler(&ent->work);
>>>>>    1210         } else if (!queue_work(cmd->wq, &ent->work)) {
>>>>>                            ^^^^^^^ this is what is causing to the splat
>>>>>    1211                 mlx5_core_warn(dev, "failed to queue work\n");
>>>>>    1212                 err = -EALREADY;
>>>>>    1213                 goto out_free;
>>>>>    1214         }
>>>>>
>>>>> <...>
>>>>>> Is this problem known, maybe already fixed?
>>>>> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
>>> Sorry it is 5.15.32
>>>
>>>>> Is it possible to reproduce this on latest upstream code?
>>>> I haven't been able to reproduce it, as mentioned above, I tried to
>>>> reproduce by simply reboot in loop, no luck yet.
>>>> do you have suggestions to speedup the reproduction?
>>> Maybe try to shutdown during filling command interface.
>>> I think that any query command will do the trick.
>> Just an update.
>> I tried to run "saquery" in a loop in one session and do "modproble -r
>> mlx5_ib && modprobe mlx5_ib" in loop in another session during last
>> days , but still no luck. --c
>>>> Once I can reproduce, I can also try with kernel 6.0.
>>> It will be great.
>>>
>>> Thanks
>> Thanks!
> Just want to mention, we see more crash during reboot, all the crash
> we saw are all
> Intel  Intel(R) Xeon(R) Gold 6338 CPU. We use the same HCA on
> different servers. So I suspect the bug is related to Ice Lake server.
>
> In case it matters, here is lspci attached.


Please try the following change on 5.15.32, let me know if it solves the 
failure :

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c 
b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index e06a6104e91f..d45ca9c52a21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
                 cmd_ent_get(ent);
         set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);

+       cmd_ent_get(ent); /* for the _real_ FW event on completion */
         /* Skip sending command to fw if internal error */
         if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
                 u8 status = 0;
@@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
                 return;
         }

-       cmd_ent_get(ent); /* for the _real_ FW event on completion */
         /* ring doorbell after the descriptor is valid */
         mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << 
ent->idx);
         wmb();
@@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct 
mlx5_core_dev *dev, u64 vec, bool force
                                 cmd_ent_put(ent); /* timeout work was 
canceled */

                         if (!forced || /* Real FW completion */
-                           pci_channel_offline(dev->pdev) || /* FW is 
inaccessible */
-                           dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+                            mlx5_cmd_is_down(dev) || /* No real FW 
completion is expected */
+                            !opcode_allowed(cmd, ent->op))
                                 cmd_ent_put(ent);

                         ent->ts2 = ktime_get_ns();

> Thx!
