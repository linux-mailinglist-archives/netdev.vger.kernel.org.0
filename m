Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AA73D1E7A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 08:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhGVGIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:08:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:50771 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230340AbhGVGIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1626936557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=N48dOTHBTYwvXU4s2tmJZSlmVI20r7P7qLDrdIvP3uY=;
        b=jPNwAEGTCS4FoCINcUnDsS6qDQvag4zaYyBNu2InZa6mt622GtKgXSpVK7usRDwuv4UHYs
        lsrJO0ZhBQWEzYQn7gR1pbgVb6GDQ/1QGHjY095Xs5jwiHx1woEr0ZOL8+YL5BaXJtng0P
        saawD0sg4NnHyzMISQlm0PVIB9hnugw=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-ZYhGARVMOFO1Gzph-MHKlA-1; Thu, 22 Jul 2021 08:49:15 +0200
X-MC-Unique: ZYhGARVMOFO1Gzph-MHKlA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV8moDHZpy60GgqXSilHy7IohMlhDjjc26T3mBc5xzI+XBz8MiHy/lx06CUEpE+SWXgHw0gjP1wcWi+gLbr25BOJz7/0nzUHNIiPwZ6H1/dOGSmes3uNrMz1IBVjKpG8eMMEdBtS+z5dR8/j6B8fHyCf1Rpi3vctGIghppOBOybEm2hLqUjRhQfleTHQFxJb96iFGn94Q1zPi7xIfoyx5qM7mS77+tLYGc1xMnjeT3EbBL/J6UOb9jVPnDGb5FEJwfkFq5Nq9QSCKjECFs4VdH1icp/wVt0eq95TDBPEbGFLHmym38jQBzgGwsLvp/GY9Q0Kqi2G7AgZK5/zw5ElSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N48dOTHBTYwvXU4s2tmJZSlmVI20r7P7qLDrdIvP3uY=;
 b=LDfkbs5Qz1H6V+wWnAODXBAQSYYeTaIkkX4n+ujRh79QdgUJX+MUldy2ue/HrtOO3q2oL62mqspqVSqlsSAPnopew1iZrd/Wn5azp/wYCdrPjxVHv8Cm7xdlRXxvoeLB90hjGS6XzvY3LPL7ljPl40AiPQFHeLB1RzasF+Xm4tvCek4RPSSaVZD2nGYc+x0odUoUUMkDVJfoC6+kM9hiUKmXiJl7UogjANGUdxivUCWy4PPM7u/w2e8iXy/8EmtQX+SI1hdgv1Gyu4ZTHcF4erGt18NMzPKJnJxwo8pY4UciBBjpg1ECCWwGS6hreXtjPefPr5k9ke/zEf/XpxXNUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by DBBPR04MB7577.eurprd04.prod.outlook.com (2603:10a6:10:206::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Thu, 22 Jul
 2021 06:49:14 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::15a5:fd5d:a44d:8a3c]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::15a5:fd5d:a44d:8a3c%9]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 06:49:14 +0000
Date:   Thu, 22 Jul 2021 14:49:04 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Majd Dibbiny <majd@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: BUG: double free of mlx5_cmd_work_ent during shutdown
Message-ID: <YPkU4HZwKMf9kuBH@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: AM0PR02CA0073.eurprd02.prod.outlook.com
 (2603:10a6:208:154::14) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (27.242.198.174) by AM0PR02CA0073.eurprd02.prod.outlook.com (2603:10a6:208:154::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24 via Frontend Transport; Thu, 22 Jul 2021 06:49:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438acffa-f205-40b4-7d62-08d94cdcd150
X-MS-TrafficTypeDiagnostic: DBBPR04MB7577:
X-Microsoft-Antispam-PRVS: <DBBPR04MB7577A998D77883F43E22F2B3BFE49@DBBPR04MB7577.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3D1yqeQ5+50XWQdwzEjqwU48P0aLwqFw+TbL9BbC9cSH5CU8J/R4yliIjAgqu4SZSyGrKzNFOCcMAZURs6ApzP0GCBOFiBenrm/6gDmGWtlPtzNKebT8Q4FRKSQxcl0XdZUG5C0gL1aaCetzEOu8R89oGPhAzTMTPKgYa7a2cqHk8vpM/oNMqPXT53fHQJ7GCiQEtFoM8G9llnb7c1iv3RzbvPZf9YZ+xcD7EUry/PJ0fj9x1QvRtgoubO2hGqY7bsUvtpPw6MuI3vQ1EURcadamWpVxGMkuZ5fRw2oDwOiEmjGepYuK6xZ5y7vzQm/MnSjStNfcZUlSHPG+cFP9gZiG8JWQlVJ2yCGMegpdtuQdhZtLOMaC/S7ujgCgkUoyFkSKL98uc0n8ZyXItBCeGp2az7vtWayWQxsVWA3E6G/+/UbpgK1nXoW2GwlT9BJFMweRNOf8fCHJakNBEr9XaPMteeJ8l9v6hv3z7m7qs2YOl4OZJ69BHDUFFuek/bC0YmEDB5+RNJYziipL/uI5QtMPkJV0eki3P9Vm1b+OCdHIinmzCZy7wAcwDue0pwWu3Z62e4ef5MGIPFHqprAHAycvzzm7B3FyHemfEJvPwQ+PFRAdRzAJeF/BRoV/bptyMKAIUzlqhqfhR/Txe3Uwbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(186003)(6496006)(956004)(30864003)(8676002)(66556008)(110136005)(38100700002)(54906003)(316002)(5660300002)(33716001)(26005)(4326008)(66476007)(66946007)(8936002)(86362001)(6666004)(9686003)(45080400002)(508600001)(83380400001)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXJTTjUyUXZqWGFjWTVjWTRVdURRd2p3K21LZnM3V1pjR2JQQWRTcXVWcmp2?=
 =?utf-8?B?TUhzWjNndmpHb3BtdmdJcjI2dnpvQ0s0Wnc0ZkRCZi9FcFBxcHZOU28wK3Rn?=
 =?utf-8?B?eW9JbUlqRTZCTGQvUitGOEVpTFc1OXNtdThuTUxUN3EyOEkvK0JnWllPUml0?=
 =?utf-8?B?VFRvUm1TaEFuTm1rUUtYOStLZk53Yzh5V3dhcjM5YjhwN3BrLys5RStYYXVt?=
 =?utf-8?B?RGJ3aTA3Sy9XN0hIZjhuVkhnL2lvYm5FUXg0cnV4ODBFSEt5c24xODRzaUVR?=
 =?utf-8?B?MzJUWFhKdHBFTXNqeWxUUUxJRU8vWHhFa0FFeThpaUNrOXJnWW5pdU5vb0gv?=
 =?utf-8?B?djZuLytvaG9VZ3ZieEt6MkdrbEp2S1FLVGdCWi83T1orWE9JeGJjNERLUmpl?=
 =?utf-8?B?MEZlMnZqaTFCQ0dETDZwb1JXOWhPaUR0Z0h0UjJmOE5na0dmVGtQTWxaZElW?=
 =?utf-8?B?ck53K1FrV0lnbFYvQjVlcVc2UzBOVjhPN21DV09vNlZNL2VRTHJVV0lnNWZk?=
 =?utf-8?B?ek9oVkdtek5rdkFqNzg1aXhaZEV0MnhJUUhhWU1HS2dabmpVWU1jN1ZkRjhz?=
 =?utf-8?B?VHJDd084WFVjZWZvRVBFaFIybk1yOHdUUHRTWnRKOXYzUEIvM1ptUys5bWV2?=
 =?utf-8?B?SXcwS1hpWFNQMDVEckhqUzlyUno2Q2M4cnNXNmQvMmFSMVMxdFpNdXhaUmpT?=
 =?utf-8?B?QmIwMURKdWJzNGF5VXdsVmtsWXFSVkk3RHhDVkxqYW1kelNVbG9DWmZTNnVx?=
 =?utf-8?B?NWVJL1BSQmZUMnhyaTgxeXBZNjBMZWlUaE1qV2M0ZHpZK3pYczkwVER5SVht?=
 =?utf-8?B?ZVBramRHZkVYWVJrcVlGVHhlaWJZdWd1WW5ld0xzZGNIM2xsL0d1TkpycnhQ?=
 =?utf-8?B?ZE1KL3YxZFFmdElNVHU2ZXBCNlkyRmFDSnZCUXF6RVMxbUhoZjZtVi9ib1JN?=
 =?utf-8?B?WFkzcGFTaHduWW4yb212RjRqN3pVYTVFSkJOVnRkNm96bWRGTmVlVTk0NHVJ?=
 =?utf-8?B?YlRjYTdUYjQ3TmpVWVBGTFVBM2tmT2ZwQytJTzA2M3RtUXc2S0NmTlhFU0Zy?=
 =?utf-8?B?ZHBoVnhSdUVBbkNLRGprcnhuNlEwbDg3VHpYejBqVTVQcDVtTjVDalhzMGpY?=
 =?utf-8?B?cXdWZVhwenlQcThPeTJEM0FOR2tGRktST0M3cjc4Um9WY0Z3R1pDK3pmWWh1?=
 =?utf-8?B?YUZhR3VSaVJ4SUluU0hRQzBDS0JRcEFjNHQyekxydVpocCtyUW94K2Vqa1VX?=
 =?utf-8?B?YXlNRHVqR2RNd2ZNNnphQUVBTXJwTHdudmhuWTZwdmxIVnJHMGVKN1FqRWw2?=
 =?utf-8?B?N2krajJmS2NXVmF6QjUxZmh4RjV5dzNXTmoreFZ0NU50VEpZTzVJV0dUYkkv?=
 =?utf-8?B?RnR4V2pkZ1BzcGhaVXdUZVY2RGdURU5NWHpPZnk5Umt0WkV6azFmNVQvb2ll?=
 =?utf-8?B?RG1aNHVqNjI1QlJqRnc5Mmt0N1BzZnJPOTk3MlVZclpoWXlCSVYrNHhldjlO?=
 =?utf-8?B?MUFSUjU0NzE5SlNKcVUrQ3oxOGxyeGl6ZDVabFR6VG4zKzNpS1pTRjVtYmFL?=
 =?utf-8?B?QVQzRG5BRzl6RHA4cUg0NlRGR0p3RGhmb0w4d1dPQlRDTUxVSzFyUnhWK1c3?=
 =?utf-8?B?YzBSVk9Vem1nYmFFT2NZUUdpc2VVTnIzQTlzOGRqNmdoQkgxcmF5M2tiVnpn?=
 =?utf-8?B?S0ZuNm43eUFpaTRBR3RXdyt3T2ZYTW91VlBVaUp6QzMxdWtRcG9aU1JZdUNt?=
 =?utf-8?Q?DlSVpVx3DhKKZHi2vSj2tG4uMkRG/9m9HocOvui?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438acffa-f205-40b4-7d62-08d94cdcd150
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 06:49:14.6845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzM4doxwUNPPiTUrqbLeqezw92iBjteePw0tSPcpcQ4p2V+eKGKPVDjzaa8RjJHyMx4Fq/DhJ1/+mNBjqoYrKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When force teardown is used (for devices that doesn't support fast
teardown), mlx5_cmd_force_teardown_hca() sends out a TEARDOWN_HCA command,
wait for the command to complete, and call cmd_ent_put() from the
following stack.

    cmd_exec() {
        // ...
        out_free:
            cmd_ent_put(ent); // HERE
        out:
            return err;
    }
      mlx5_cmd_exec_polling()
        mlx5_cmd_force_teardown_hca()
          shutdown()

However, there's another path which cmd_ent_put() is called for the same
command from the async events chain.

    mlx5_cmd_comp_handler() {
        for (i = 0; i < (1 << cmd->log_sz); i++) {
            if (test_bit(i, &vector)) {
                // ...
                if (!forced || /* Real FW completion */
                    pci_channel_offline(dev->pdev) || /* FW is inaccessible */
                    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
                    cmd_ent_put(ent); // HERE
        // ...
    }
      cmd_comp_notifier()
        notifier_call_chain()
          atomic_notifier_call_chain()
            mlx5_eq_async_int()
              notifier_call_chain()
                atomic_notifier_call_chain()
                  mlx5_irq_int_handler()

This leads to to "refcount_t: underflow; use-after-free" warning during
shutdown.

---

Here's the stack trace on v5.13-based kernel with KASAN enabled.
(Line number doesn't exactly match though)

    systemd-shutdown[1]: Rebooting with kexec.
    kvm: exiting hardware virtualization
    sd 0:0:0:0: [sda] Synchronizing SCSI cache
    mlx5_core 0000:0a:00.1: Shutdown was called
    mlx5_try_fast_unload:1629: mlx5_core 0000:0a:00.1: mlx5_try_fast_unload:1629:(pid 4959): force teardown firmware support=1
    mlx5_try_fast_unload:1630: mlx5_core 0000:0a:00.1: mlx5_try_fast_unload:1630:(pid 4959): fast teardown firmware support=0
    mlx5_cmd_fast_teardown_hca:330: mlx5_core 0000:0a:00.1: mlx5_cmd_fast_teardown_hca:330:(pid 4959): fast teardown is not supported in the firmware
    dump_command:805: mlx5_core 0000:0a:00.1: dump_command:805:(pid 4647): cmd[0]: start dump
    dump_command:814: mlx5_core 0000:0a:00.1: dump_command:814:(pid 4647): cmd[0]: dump command TEARDOWN_HCA(0x103) INPUT
    dump_buf:272: cmd[0]: 000: 07000000 00000010 00000000 00000000
    dump_buf:272: cmd[0]: 010: 01030000 00000000 00000001 00000000
    dump_buf:272: cmd[0]: 020: 00000000 00000000 00000000 00000000
    dump_buf:272: cmd[0]: 030: 00000000 00000000 00000010 3fc50001
    dump_buf:279: 
    dump_command:848: mlx5_core 0000:0a:00.1: dump_command:848:(pid 4647): cmd[0]: end dump
    cmd_work_handler:1003: mlx5_core 0000:0a:00.1: cmd_work_handler:1003:(pid 4647): writing 0x1 to command doorbell
    dump_command:805: mlx5_core 0000:0a:00.1: dump_command:805:(pid 4647): cmd[0]: start dump
    mlx5_core 0000:0a:00.1: mlx5_cmd_comp_handler:1613:(pid 0): Command completion arrived after timeout (entry idx = 0).
    dump_command:814: mlx5_core 0000:0a:00.1: dump_command:814:(pid 4647): cmd[0]: dump command TEARDOWN_HCA(0x103) OUTPUT

    cmd_ent_put(00000000fbaea4c6) will be called in mlx5_cmd_comp_handler:1615 for TEARDOWN_HCA(0x103), polling 1, ret 0
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    any_notifier:148: mlx5_core 0000:0a:00.1: any_notifier:148:(pid 0): Async eqe type MLX5_EVENT_TYPE_CMD, subtype (0)
    ==================================================================
    BUG: KASAN: use-after-free in dump_command+0x9d9/0xa40 [mlx5_core]
    Read of size 4 at addr ffff8881120620e0 by task kworker/u96:0/4647
    
    CPU: 10 PID: 4647 Comm: kworker/u96:0 Tainted: G            E     5.14.0-rc1-1-default+ #7 6ab45f24446e456129f9451daed46c2a2aa80406
    Hardware name: Dell Inc. PowerEdge T320/0FDT3J, BIOS 2.9.0 01/08/2020
    Workqueue: mlx5_cmd_0000:0a:00.1 cmd_work_handler [mlx5_core]
    Call Trace:
     dump_stack_lvl+0x57/0x72
     print_address_description.constprop.0+0x1f/0x140
     ? dump_command+0x9d9/0xa40 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     kasan_report.cold+0x7f/0x11b
     ? dump_command+0x9d9/0xa40 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     dump_command+0x9d9/0xa40 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? seqcount_lockdep_reader_access.constprop.0+0x84/0x90
     ? seqcount_lockdep_reader_access.constprop.0+0x84/0x90
     mlx5_cmd_comp_handler+0x498/0x13e0 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? lock_release+0x1ea/0x6c0
     ? mlx5_cmd_check+0x2f0/0x2f0 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? lockdep_hardirqs_on_prepare+0x278/0x3e0
     ? seqcount_lockdep_reader_access.constprop.0+0x84/0x90
     ? cmd_work_handler+0xfa2/0x19a0 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? __cond_resched+0x15/0x30
     cmd_work_handler+0xfa2/0x19a0 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? cmd_comp_notifier+0x90/0x90 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? lock_is_held_type+0xe0/0x110
     ? lockdep_hardirqs_on_prepare+0x278/0x3e0
     process_one_work+0x8b2/0x14c0
     ? lock_release+0x6c0/0x6c0
     ? pwq_dec_nr_in_flight+0x260/0x260
     ? rwlock_bug.part.0+0x90/0x90
     worker_thread+0x544/0x12d0
     ? get_cpu_entry_area+0x13/0x20
     ? __kthread_parkme+0xa5/0x130
     ? process_one_work+0x14c0/0x14c0
     kthread+0x349/0x410
     ? _raw_spin_unlock_irq+0x24/0x40
     ? set_kthread_struct+0x100/0x100
     ret_from_fork+0x22/0x30
    
    Allocated by task 4959:
     kasan_save_stack+0x1b/0x40
     __kasan_kmalloc+0x7c/0x90
     cmd_exec+0x6f0/0x1740 [mlx5_core]
     mlx5_cmd_exec_polling+0x1f/0x40 [mlx5_core]
     mlx5_cmd_force_teardown_hca+0xfc/0x200 [mlx5_core]
     shutdown+0x2e7/0x3b3 [mlx5_core]
     pci_device_shutdown+0x75/0x110
     device_shutdown+0x2ce/0x5e0
     kernel_kexec+0x57/0xb0
     __do_sys_reboot+0x284/0x2f0
     do_syscall_64+0x5c/0xc0
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    
    Freed by task 0:
     kasan_save_stack+0x1b/0x40
     kasan_set_track+0x1c/0x30
     kasan_set_free_info+0x20/0x30
     __kasan_slab_free+0xec/0x120
     slab_free_freelist_hook+0x90/0x1b0
     kfree+0xd1/0x410
     mlx5_cmd_comp_handler.cold+0x138/0x16c [mlx5_core]
     cmd_comp_notifier+0x72/0x90 [mlx5_core]
     atomic_notifier_call_chain+0xdd/0x1c0
     mlx5_eq_async_int+0x34c/0x8f0 [mlx5_core]
     atomic_notifier_call_chain+0xdd/0x1c0
     irq_int_handler+0x11/0x20 [mlx5_core]
     __handle_irq_event_percpu+0x264/0x640
     handle_irq_event+0x10b/0x270
     handle_edge_irq+0x21a/0xbe0
     __common_interrupt+0x72/0x160
     common_interrupt+0x7b/0xa0
     asm_common_interrupt+0x1e/0x40
    
    Last potentially related work creation:
     kasan_save_stack+0x1b/0x40
     kasan_record_aux_stack+0xa5/0xb0
     insert_work+0x44/0x280
     __queue_work+0x4b7/0xc50
     queue_work_on+0x8d/0x90
     cmd_exec+0xfac/0x1740 [mlx5_core]
     mlx5_cmd_exec_polling+0x1f/0x40 [mlx5_core]
     mlx5_cmd_force_teardown_hca+0xfc/0x200 [mlx5_core]
     shutdown+0x2e7/0x3b3 [mlx5_core]
     pci_device_shutdown+0x75/0x110
     device_shutdown+0x2ce/0x5e0
     kernel_kexec+0x57/0xb0
     __do_sys_reboot+0x284/0x2f0
     do_syscall_64+0x5c/0xc0
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    
    The buggy address belongs to the object at ffff888112062000
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 224 bytes inside of
     1024-byte region [ffff888112062000, ffff888112062400)
    The buggy address belongs to the page:
    page:000000008b314a5c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x112060
    head:000000008b314a5c order:3 compound_mapcount:0 compound_pincount:0
    flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
    raw: 002ffff800010200 ffffea00041e3a00 0000000500000005 ffff888100042dc0
    raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
    page dumped because: kasan: bad access detected
    
    Memory state around the buggy address:
     ffff888112061f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
     ffff888112062000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    >ffff888112062080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                           ^
     ffff888112062100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff888112062180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================
    Disabling lock debugging due to kernel taint
    dump_buf:272: cmd[0]: 000: 07000000 00000010 00000000 00000000
    dump_buf:272: cmd[0]: 010: 01030000 00000000 00000001 00000000
    dump_buf:272: cmd[0]: 020: 00000000 00000000 00000000 00000001
    dump_buf:272: cmd[0]: 030: 00000000 00000000 00000010 3fc50000
    dump_buf:279: 
    dump_command:848: mlx5_core 0000:0a:00.1: dump_command:848:(pid 4647): cmd[0]: end dump
    mlx5_cmd_comp_handler:1648: mlx5_core 0000:0a:00.1: mlx5_cmd_comp_handler:1648:(pid 4647): command completed. ret 0x0, delivery status no errors(0x0)
    wait_func:1102: mlx5_core 0000:0a:00.1: wait_func:1102:(pid 4959): err 0, delivery status no errors(0)

    cmd_ent_put(00000000fbaea4c6) will be called in mlx5_cmd_invoke:1178 for TEARDOWN_HCA(0x103), polling 1, ret 0
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    ------------[ cut here ]------------
    refcount_t: underflow; use-after-free.
    WARNING: CPU: 2 PID: 4959 at lib/refcount.c:28 refcount_warn_saturate+0xaa/0x140
    Modules linked in: af_packet(E) bridge(E) stp(E) llc(E) iscsi_ibft(E) iscsi_boot_sysfs(E) rfkill(E) mlx5_core(E) intel_rapl_msr(E) intel_rapl_common(E) sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) mgag200(E) coretemp(E) kvm_intel(E) drm_kms_helper(E) kvm(E) syscopyarea(E) sysfillrect(E) ipmi_ssif(E) sysimgblt(E) joydev(E) fb_sys_fops(E) dcdbas(E) cec(E) tg3(E) nls_iso8859_1(E) iTCO_wdt(E) nls_cp437(E) irqbypass(E) rc_core(E) libphy(E) intel_pmc_bxt(E) mei_me(E) ipmi_si(E) vfat(E) i2c_algo_bit(E) mlxfw(E) efi_pstore(E) fat(E) ipmi_devintf(E) iTCO_vendor_support(E) pcspkr(E) pci_hyperv_intf(E) ipmi_msghandler(E) psample(E) tiny_power_button(E) mei(E) lpc_ich(E) wmi(E) button(E) drm(E) fuse(E) configfs(E) hid_microsoft(E) ff_memless(E) hid_generic(E) usbhid(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) ghash_clmulni_intel(E) aesni_intel(E) crypto_simd(E) cryptd(E) ehci_pci(E) ehci_hcd(E) usbcore(E) sg(E) efivarfs(E)
    CPU: 2 PID: 4959 Comm: kexec Tainted: G    B       E     5.14.0-rc1-1-default+ #7 6ab45f24446e456129f9451daed46c2a2aa80406
    Hardware name: Dell Inc. PowerEdge T320/0FDT3J, BIOS 2.9.0 01/08/2020
    RIP: 0010:refcount_warn_saturate+0xaa/0x140
    Code: e9 0c b5 02 01 e8 be 45 f9 00 0f 0b eb d5 80 3d d7 0c b5 02 00 75 cc 48 c7 c7 e0 f0 a4 ad c6 05 c7 0c b5 02 01 e8 9e 45 f9 00 <0f> 0b eb b5 80 3d b5 0c b5 02 00 75 ac 48 c7 c7 a0 f1 a4 ad c6 05
    RSP: 0018:ffff8881593b79d8 EFLAGS: 00010286
    RAX: 0000000000000000 RBX: ffff888112062214 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffed102b276f2d
    RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
    R10: ffffed102b276eca R11: 0000000000000001 R12: 0000000000000000
    R13: 0000000000000000 R14: ffff888159585908 R15: ffff8881079fa080
    FS:  00007f8846e63740(0000) GS:ffff8881d3700000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007f884700b670 CR3: 0000000112ef0004 CR4: 00000000001706e0
    Call Trace:
     cmd_exec+0xda6/0x1740 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? cb_timeout_handler+0xa0/0xa0 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? mark_held_locks+0x9e/0xe0
     mlx5_cmd_exec_polling+0x1f/0x40 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     mlx5_cmd_force_teardown_hca+0xfc/0x200 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     ? mlx5_cmd_teardown_hca+0xd0/0xd0 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     shutdown+0x2e7/0x3b3 [mlx5_core 159b773d3cc25877247f038573d06bc052f8250f]
     pci_device_shutdown+0x75/0x110
     device_shutdown+0x2ce/0x5e0
     kernel_kexec+0x57/0xb0
     __do_sys_reboot+0x284/0x2f0
     ? poweroff_work_func+0x90/0x90
     ? lockdep_hardirqs_on_prepare+0x278/0x3e0
     ? kasan_quarantine_put+0x8e/0x1e0
     ? lockdep_hardirqs_on+0x77/0xf0
     ? kasan_quarantine_put+0x8e/0x1e0
     ? lock_is_held_type+0xe0/0x110
     ? slab_free_freelist_hook+0x90/0x1b0
     ? __fput+0x2a1/0x780
     ? lock_is_held_type+0x53/0x110
     ? rcu_read_lock_sched_held+0x3f/0x80
     ? lockdep_hardirqs_on_prepare+0x278/0x3e0
     ? call_rcu+0x5b2/0xa80
     ? lock_is_held_type+0x53/0x110
     ? lockdep_hardirqs_on_prepare+0x278/0x3e0
     ? syscall_enter_from_user_mode+0x21/0x70
     do_syscall_64+0x5c/0xc0
     ? lockdep_hardirqs_on_prepare+0x278/0x3e0
     ? lockdep_hardirqs_on+0x77/0xf0
     ? do_syscall_64+0x69/0xc0
     ? do_syscall_64+0x69/0xc0
     ? lock_is_held_type+0x53/0x110
     ? irqentry_exit_to_user_mode+0xa/0x40
     ? asm_exc_page_fault+0x8/0x30
     ? lockdep_hardirqs_on+0x77/0xf0
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    RIP: 0033:0x7f8846faa0d7
    Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 69 ad 0c 00 f7 d8 64 89 02 b8
    RSP: 002b:00007fffeb69d648 EFLAGS: 00000206 ORIG_RAX: 00000000000000a9
    RAX: ffffffffffffffda RBX: 0000561e00f46520 RCX: 00007f8846faa0d7
    RDX: 0000000045584543 RSI: 0000000028121969 RDI: 00000000fee1dead
    RBP: 00007f8847076600 R08: 000000000000000b R09: 0000000000000000
    R10: 00007f8846ebe0d8 R11: 0000000000000206 R12: 0000561dffc738fe
    R13: 0000561dffc73905 R14: 00007fffeb69d7a0 R15: 00000000ffffffff
    irq event stamp: 11228
    hardirqs last  enabled at (11227): [<ffffffffad2dde14>] _raw_spin_unlock_irq+0x24/0x40
    hardirqs last disabled at (11228): [<ffffffffad2c9f39>] __schedule+0x1229/0x2300
    softirqs last  enabled at (11162): [<ffffffffab3bd94e>] __irq_exit_rcu+0x12e/0x170
    softirqs last disabled at (11157): [<ffffffffab3bd94e>] __irq_exit_rcu+0x12e/0x170
    ---[ end trace 151c2ed42dd09eaf ]---
    cmd_exec:1864: mlx5_core 0000:0a:00.1: cmd_exec:1864:(pid 4959): err 0, status 0
    mlx5_core 0000:0a:00.1: mlx5_cmd_force_teardown_hca:313:(pid 4959): teardown with force mode failed, doing normal teardown
    mlx5_try_fast_unload:1654: mlx5_core 0000:0a:00.1: mlx5_try_fast_unload:1654:(pid 4959): Firmware couldn't do fast unload error: -5
    mlx5_wait_for_pages:739: mlx5_core 0000:0a:00.1: mlx5_wait_for_pages:739:(pid 4959): Waiting for 0 pages
    mlx5_wait_for_pages:752: mlx5_core 0000:0a:00.1: mlx5_wait_for_pages:752:(pid 4959): All pages received
    dump_command:805: mlx5_core 0000:0a:00.1: dump_command:805:(pid 4647): cmd[0]: start dump
    dump_command:814: mlx5_core 0000:0a:00.1: dump_command:814:(pid 4647): cmd[0]: dump command DESTROY_FLOW_TABLE(0x931) INPUT
    dump_buf:272: cmd[0]: 000: 07000000 00000040 00000001 347e4400
    dump_buf:272: cmd[0]: 010: 09310000 00000000 00000000 00000000
    dump_buf:272: cmd[0]: 020: 00000000 00000000 00000000 00000000
    dump_buf:272: cmd[0]: 030: 00000000 00000000 00000010 40de0001


Best,
Shung-Hsi Yu

