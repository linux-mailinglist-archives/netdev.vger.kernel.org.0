Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F753D25A4
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhGVNnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:43:31 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55442
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232245AbhGVNn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:43:27 -0400
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 862503F23F
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626963841;
        bh=P0qDlMspeYqIZjdjTmfpis+M+pz1rOhE47cm5cuxJKU=;
        h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=KokhWssS8/M5MdbHrPvtfBTxKsgYLJr37sxxLI+fQK/AD6Y56u7ETdPsTv8cf5pnZ
         4mMCc1rlfyBQ1shhX9mV5E6ogvRqiqs9QK1vb4ZiX1NJJ3cDE1DrASCOKTfC+x05OX
         RimfcbHQGj88lYsXqjVNhk8Nj5nKB4p8X1x3STbCXjMQJDnJmus4b4yjDZgqgUyXfK
         TA4TkrH8+Xtrvat7q2c4b0ZMZ3G26FR7emM5xgeaC5xvpKMIefCDsLsWWzvd3O1OTD
         DEkH3KzKn2KJ8lU2keGmzaTtb0xWIWsNFZMVpWvWKQc2Qgy7uODNiRDTUgooKuWWGi
         OSqZkuN1Lqzlg==
Received: by mail-ej1-f70.google.com with SMTP id g6-20020a1709063b06b029051a448bab28so1864611ejf.17
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P0qDlMspeYqIZjdjTmfpis+M+pz1rOhE47cm5cuxJKU=;
        b=kNGrNOorrbtw4af/Ex5b/dI+aeh9+0pgHjC7eudK6U/cycF/FY1TEMGOLQAQyqROAK
         0uCvN6TueHHI9LN/NKqQkFyB195OdiYmiNAluTczAW1KKtqTsrBRpKHDTKZ7oSgS5OT6
         5bmB5sueTGIgcpRHAfmvCgt88WDL9H+0eVvN8UgJtsO4+5/c4Gj8AU73wlppg5zesVe3
         DgCEU6ubtDEcYJwsJ4aKusoQvN3eHr8N4rGukaMpjFKIbp2ZwJQSFAP/1PViv5bxTN/r
         FyWDSBIwF/8yJdjWwXkXNz952jKy9A8Gg7x51hCwWrYJ7Spv+DlCdlcuqWo1Ua8c7tl/
         JGbw==
X-Gm-Message-State: AOAM533NjNfyW/UQ+wBPuXa1QIDZYwTrnn0Qrh1ggnxnKvX5UJjLYuH2
        lnUmRzDcwoWWovzrJGbKXw2V+9cPQ23MNWypHoBo6KFtuAXD739QYJ1xgRXp0wdSVNVTNCUgh0l
        eIBQWg1R2BG5PA4jFrRCrAe+pS56IDX7MZQ==
X-Received: by 2002:a17:906:1956:: with SMTP id b22mr165353eje.410.1626963840103;
        Thu, 22 Jul 2021 07:24:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzA9+NQG2gMi4eD/StwlK61DPuFa6D0yWXs/oPEjaLvkYA/bhODtdHXvZVUGQ8SvejmysFPqw==
X-Received: by 2002:a17:906:1956:: with SMTP id b22mr165318eje.410.1626963839635;
        Thu, 22 Jul 2021 07:23:59 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id o26sm12459408edt.18.2021.07.22.07.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 07:23:58 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in port100_probe
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     Thierry Escande <thierry.escande@collabora.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrey Konovalov <andreyknvl@gmail.com>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
Message-ID: <374a13ef-d795-bff5-1d51-f8fad0e45df7@canonical.com>
Date:   Thu, 22 Jul 2021 16:23:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2021 16:20, Krzysztof Kozlowski wrote:
> On 22/06/2021 17:43, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of git://git.kernel.org/pub..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13e1500c300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
>> dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1792e284300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad9d48300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com
>>
>> INFO: task kworker/0:1:7 blocked for more than 143 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/0:1     state:D stack:25584 pid:    7 ppid:     2 flags:0x00004000
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>>  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
>>  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
>>  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
>>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
>>  usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
>>  usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
>>  hub_port_connect drivers/usb/core/hub.c:5276 [inline]
>>  hub_port_connect_change drivers/usb/core/hub.c:5416 [inline]
>>  port_event drivers/usb/core/hub.c:5562 [inline]
>>  hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5644
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
>>  process_scheduled_works kernel/workqueue.c:2338 [inline]
>>  worker_thread+0x82b/0x1120 kernel/workqueue.c:2424
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> INFO: task kworker/1:2:3367 blocked for more than 143 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/1:2     state:D stack:25552 pid: 3367 ppid:     2 flags:0x00004000
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>>  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
>>  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
>>  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
>>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
>>  usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
>>  usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
>>  hub_port_connect drivers/usb/core/hub.c:5276 [inline]
>>  hub_port_connect_change drivers/usb/core/hub.c:5416 [inline]
>>  port_event drivers/usb/core/hub.c:5562 [inline]
>>  hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5644
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
>>  process_scheduled_works kernel/workqueue.c:2338 [inline]
>>  worker_thread+0x82b/0x1120 kernel/workqueue.c:2424
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> INFO: task kworker/1:3:4871 blocked for more than 144 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/1:3     state:D stack:25584 pid: 4871 ppid:     2 flags:0x00004000
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>>  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
>>  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
>>  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
>>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
>>  usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
>>  usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
>>  hub_port_connect drivers/usb/core/hub.c:5276 [inline]
>>  hub_port_connect_change drivers/usb/core/hub.c:5416 [inline]
>>  port_event drivers/usb/core/hub.c:5562 [inline]
>>  hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5644
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
>>  process_scheduled_works kernel/workqueue.c:2338 [inline]
>>  worker_thread+0x82b/0x1120 kernel/workqueue.c:2424
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> INFO: task kworker/1:0:8456 blocked for more than 144 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/1:0     state:D stack:25936 pid: 8456 ppid:     2 flags:0x00004000
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>>  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
>>  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
>>  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
>>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
>>  usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
>>  usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
>>  hub_port_connect drivers/usb/core/hub.c:5276 [inline]
>>  hub_port_connect_change drivers/usb/core/hub.c:5416 [inline]
>>  port_event drivers/usb/core/hub.c:5562 [inline]
>>  hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5644
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
>>  process_scheduled_works kernel/workqueue.c:2338 [inline]
>>  worker_thread+0x82b/0x1120 kernel/workqueue.c:2424
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> INFO: task kworker/1:1:8462 blocked for more than 145 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/1:1     state:D stack:25960 pid: 8462 ppid:     2 flags:0x00004000
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>>  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
>>  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
>>  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
>>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
>>  usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
>>  usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
>>  really_probe+0x291/0xf60 drivers/base/dd.c:576
>>  driver_probe_device+0x298/0x410 drivers/base/dd.c:763
>>  __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
>>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
>>  __device_attach+0x228/0x4b0 drivers/base/dd.c:938
>>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
>>  device_add+0xbe0/0x2100 drivers/base/core.c:3324
>>  usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
>>  hub_port_connect drivers/usb/core/hub.c:5276 [inline]
>>  hub_port_connect_change drivers/usb/core/hub.c:5416 [inline]
>>  port_event drivers/usb/core/hub.c:5562 [inline]
>>  hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5644
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
>>  process_scheduled_works kernel/workqueue.c:2338 [inline]
>>  worker_thread+0x82b/0x1120 kernel/workqueue.c:2424
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> INFO: task syz-executor195:8751 blocked for more than 145 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor195 state:D stack:28016 pid: 8751 ppid:  8448 flags:0x00000004
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5285
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7d4/0x10c0 kernel/locking/mutex.c:1104
>>  misc_open+0x55/0x4a0 drivers/char/misc.c:107
>>  chrdev_open+0x266/0x770 fs/char_dev.c:414
>>  do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>>  do_open fs/namei.c:3361 [inline]
>>  path_openat+0x1c0e/0x27e0 fs/namei.c:3494
>>  do_filp_open+0x190/0x3d0 fs/namei.c:3521
>>  do_sys_openat2+0x16d/0x420 fs/open.c:1187
>>  do_sys_open fs/open.c:1203 [inline]
>>  __do_sys_openat fs/open.c:1219 [inline]
>>  __se_sys_openat fs/open.c:1214 [inline]
>>  __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
>>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x402af7
>> RSP: 002b:00007ffc0cb8ab80 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00000000200000c0 RCX: 0000000000402af7
>> RDX: 0000000000000002 RSI: 000000000048803b RDI: 00000000ffffff9c
>> RBP: 000000000048803b R08: 00007ffc0cb8ac68 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
>> R13: 00007ffc0cb8ccdc R14: 0000000000000036 R15: 00007ffc0cb8cce0
>> INFO: task syz-executor195:8758 blocked for more than 145 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor195 state:D stack:28144 pid: 8758 ppid:  8447 flags:0x00000004
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5285
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7d4/0x10c0 kernel/locking/mutex.c:1104
>>  misc_open+0x55/0x4a0 drivers/char/misc.c:107
>>  chrdev_open+0x266/0x770 fs/char_dev.c:414
>>  do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>>  do_open fs/namei.c:3361 [inline]
>>  path_openat+0x1c0e/0x27e0 fs/namei.c:3494
>>  do_filp_open+0x190/0x3d0 fs/namei.c:3521
>>  do_sys_openat2+0x16d/0x420 fs/open.c:1187
>>  do_sys_open fs/open.c:1203 [inline]
>>  __do_sys_openat fs/open.c:1219 [inline]
>>  __se_sys_openat fs/open.c:1214 [inline]
>>  __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
>>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x402af7
>> RSP: 002b:00007ffc0cb8ab80 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00000000200000c0 RCX: 0000000000402af7
>> RDX: 0000000000000002 RSI: 000000000048803b RDI: 00000000ffffff9c
>> RBP: 000000000048803b R08: 00007ffc0cb8ac68 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
>> R13: 00007ffc0cb8ccdc R14: 0000000000000036 R15: 00007ffc0cb8cce0
>> INFO: task syz-executor195:8778 blocked for more than 146 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor195 state:D stack:28144 pid: 8778 ppid:  8445 flags:0x00000004
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5285
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7d4/0x10c0 kernel/locking/mutex.c:1104
>>  misc_open+0x55/0x4a0 drivers/char/misc.c:107
>>  chrdev_open+0x266/0x770 fs/char_dev.c:414
>>  do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>>  do_open fs/namei.c:3361 [inline]
>>  path_openat+0x1c0e/0x27e0 fs/namei.c:3494
>>  do_filp_open+0x190/0x3d0 fs/namei.c:3521
>>  do_sys_openat2+0x16d/0x420 fs/open.c:1187
>>  do_sys_open fs/open.c:1203 [inline]
>>  __do_sys_openat fs/open.c:1219 [inline]
>>  __se_sys_openat fs/open.c:1214 [inline]
>>  __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
>>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x402af7
>> RSP: 002b:00007ffc0cb8ab80 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00000000200000c0 RCX: 0000000000402af7
>> RDX: 0000000000000002 RSI: 000000000048803b RDI: 00000000ffffff9c
>> RBP: 000000000048803b R08: 00007ffc0cb8ac68 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
>> R13: 00007ffc0cb8ccdc R14: 0000000000000036 R15: 00007ffc0cb8cce0
>> INFO: task syz-executor195:8784 blocked for more than 146 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor195 state:D stack:28144 pid: 8784 ppid:  8446 flags:0x00000004
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5285
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7d4/0x10c0 kernel/locking/mutex.c:1104
>>  misc_open+0x55/0x4a0 drivers/char/misc.c:107
>>  chrdev_open+0x266/0x770 fs/char_dev.c:414
>>  do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>>  do_open fs/namei.c:3361 [inline]
>>  path_openat+0x1c0e/0x27e0 fs/namei.c:3494
>>  do_filp_open+0x190/0x3d0 fs/namei.c:3521
>>  do_sys_openat2+0x16d/0x420 fs/open.c:1187
>>  do_sys_open fs/open.c:1203 [inline]
>>  __do_sys_openat fs/open.c:1219 [inline]
>>  __se_sys_openat fs/open.c:1214 [inline]
>>  __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
>>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x402af7
>> RSP: 002b:00007ffc0cb8ab80 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00000000200000c0 RCX: 0000000000402af7
>> RDX: 0000000000000002 RSI: 000000000048803b RDI: 00000000ffffff9c
>> RBP: 000000000048803b R08: 00007ffc0cb8ac68 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
>> R13: 00007ffc0cb8ccdc R14: 0000000000000036 R15: 00007ffc0cb8cce0
>> INFO: task syz-executor195:8792 blocked for more than 146 seconds.
>>       Not tainted 5.13.0-rc6-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor195 state:D stack:28144 pid: 8792 ppid:  8442 flags:0x00004004
>> Call Trace:
>>  context_switch kernel/sched/core.c:4339 [inline]
>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5285
>>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>>  __mutex_lock+0x7d4/0x10c0 kernel/locking/mutex.c:1104
>>  misc_open+0x55/0x4a0 drivers/char/misc.c:107
>>  chrdev_open+0x266/0x770 fs/char_dev.c:414
>>  do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>>  do_open fs/namei.c:3361 [inline]
>>  path_openat+0x1c0e/0x27e0 fs/namei.c:3494
>>  do_filp_open+0x190/0x3d0 fs/namei.c:3521
>>  do_sys_openat2+0x16d/0x420 fs/open.c:1187
>>  do_sys_open fs/open.c:1203 [inline]
>>  __do_sys_openat fs/open.c:1219 [inline]
>>  __se_sys_openat fs/open.c:1214 [inline]
>>  __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
>>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x402af7
>> RSP: 002b:00007ffc0cb8ab80 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00000000200000c0 RCX: 0000000000402af7
>> RDX: 0000000000000002 RSI: 000000000048803b RDI: 00000000ffffff9c
>> RBP: 000000000048803b R08: 00007ffc0cb8ac68 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
>> R13: 00007ffc0cb8ccdc R14: 0000000000000036 R15: 00007ffc0cb8cce0
>>
>> Showing all locks held in the system:
>> 3 locks held by kworker/0:0/5:
>> 5 locks held by kworker/0:1/7:
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
>>  #1: ffffc90000cc7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
>>  #2: ffff8880215bc220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #2: ffff8880215bc220 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c1/0x4330 drivers/usb/core/hub.c:5590
>>  #3: ffff8880143f6220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #3: ffff8880143f6220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>>  #4: ffff88802d51b1a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #4: ffff88802d51b1a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>> 1 lock held by khungtaskd/1643:
>>  #0: ffffffff8bf79620 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6333
>> 5 locks held by kworker/1:2/3367:
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
>>  #1: ffffc90003027da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
>>  #2: ffff8880214df220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #2: ffff8880214df220 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c1/0x4330 drivers/usb/core/hub.c:5590
>>  #3: ffff888019014220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #3: ffff888019014220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>>  #4: ffff8880190171a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #4: ffff8880190171a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>> 5 locks held by kworker/1:3/4871:
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
>>  #1: ffffc9000b01fda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
>>  #2: ffff88802168b220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #2: ffff88802168b220 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c1/0x4330 drivers/usb/core/hub.c:5590
>>  #3: ffff88802d05d220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #3: ffff88802d05d220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>>  #4: ffff8880190131a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #4: ffff8880190131a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>> 1 lock held by in:imklog/8343:
>>  #0: ffff8880147e6870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
>> 5 locks held by kworker/1:0/8456:
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
>>  #1: ffffc900016cfda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
>>  #2: ffff8880216c3220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #2: ffff8880216c3220 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c1/0x4330 drivers/usb/core/hub.c:5590
>>  #3: ffff88802d059220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #3: ffff88802d059220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>>  #4: ffff888030fe51a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #4: ffff888030fe51a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>> 5 locks held by kworker/1:1/8462:
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>>  #0: ffff8880198c2d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
>>  #1: ffffc900016dfda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
>>  #2: ffff88823bc62a20 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #2: ffff88823bc62a20 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c1/0x4330 drivers/usb/core/hub.c:5590
>>  #3: ffff888030fe7220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #3: ffff888030fe7220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>>  #4: ffff8880190151a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
>>  #4: ffff8880190151a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4b0 drivers/base/dd.c:913
>> 1 lock held by syz-executor195/8751:
>>  #0: ffffffff8c99e6e8 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
>> 1 lock held by syz-executor195/8758:
>>  #0: ffffffff8c99e6e8 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
>> 1 lock held by syz-executor195/8778:
>>  #0: ffffffff8c99e6e8 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
>> 1 lock held by syz-executor195/8784:
>>  #0: ffffffff8c99e6e8 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
>> 1 lock held by syz-executor195/8792:
>>  #0: ffffffff8c99e6e8 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
>> 2 locks held by syz-executor195/8814:
>>  #0: ffffffff8c99e6e8 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
>>  #1: ffffffff8be49fe8 (system_transition_mutex){+.+.}-{3:3}, at: snapshot_open+0x3b/0x2a0 kernel/power/user.c:54
>>
>> =============================================
>>
>> NMI backtrace for cpu 1
>> CPU: 1 PID: 1643 Comm: khungtaskd Not tainted 5.13.0-rc6-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:79 [inline]
>>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>>  check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
>>  watchdog+0xd48/0xfb0 kernel/hung_task.c:294
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> Sending NMI from CPU 1 to CPUs 0:
>> NMI backtrace for cpu 0
>> CPU: 0 PID: 4850 Comm: systemd-journal Not tainted 5.13.0-rc6-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0033:0x7fbb9961e46c
>> Code: d1 49 89 e1 31 d2 41 b8 10 00 00 00 41 89 f6 49 89 e7 e8 57 fc ff ff 85 c0 41 89 c4 0f 88 5f ff ff ff 48 8b 04 24 4c 8b 40 08 <4d> 85 c0 0f 84 bb 00 00 00 49 83 f8 0f 0f 87 e1 00 00 00 e8 6c 7b
>> RSP: 002b:00007ffc2e6bdca0 EFLAGS: 00000202
>> RAX: 00007fbb96c1b798 RBX: 000000000016c798 RCX: 000000000016c798
>> RDX: 0000000000000000 RSI: 0000000000000010 RDI: 00005570395fa120
>> RBP: 00005570395f9e80 R08: 0000000000001608 R09: 00005570395fa120
>> R10: 00007ffc2e6cf090 R11: 00007fbb96da6658 R12: 0000000000000001
>> R13: 00007ffc2e6bdd18 R14: 0000000000000006 R15: 00007ffc2e6bdca0
>> FS:  00007fbb999308c0 GS:  0000000000000000
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
> 
> Cc: Thierry, Alan, Andrey,
> 
> The issue is reproducible immediately on QEMU instance with
> USB_DUMMY_HCD and USB_RAW_GADGET. I don't know about real port100 NFC
> device.
> 
> I spent some time looking into this and have no clue, except that it
> looks like an effect of a race condition.
> 
> 1. When using syskaller reproducer against one USB device (In the C
> reproducer change the loop in main() to use procid=0) - issue does not
> happen.
> 
> 2. With two threads or more talking to separate Dummy USB devices, the
> issue appears. The more of them, the better...
> 
> 3. The reported problem is in missing complete. The correct flow is like:
> port100_probe()
> port100_get_command_type_mask()
> port100_send_cmd_sync()
> port100_send_cmd_async()
> port100_submit_urb_for_ack()
> port100_send_complete()
> [   63.363863] port100 2-1:0.0: NFC: Urb failure (status -71)
> port100_recv_ack()
> [   63.369942] port100 2-1:0.0: NFC: Urb failure (status -71)
> 
> and schedule_work() which completes and unblocks port100_send_cmd_sync
> 
> However in the failing case (hung task) the port100_recv_ack() is never
> called. It looks like USB core / HCD / gadget does not send the Ack/URB
> complete.
> 
> I don't know why. The port100 NFC driver code looks OK, except it is not
> prepared for missing ack/urb so it waits indefinitely. I could try to
> convert it to wait_for_completion_timeout() but it won't be trivial and
> more important - I am not sure if this is the problem. Somehow the ACK
> with Urb failure is not sent back to the port100 device. Therefore I am
> guessing that the race condition is somwhere in USB stack, not in
> port100 driver.
> 
> The lockdep and other testing tools did not find anything here.
> 
> Anyone hints where the issue could be?

Also syzbot report for pn533 NFC (and its code) looks very similar:
https://lore.kernel.org/lkml/00000000000053e5bb05c7983666@google.com/

Best regards,
Best regards,
Krzysztof
