Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD83F911F7
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 18:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfHQQgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 12:36:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38498 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfHQQgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 12:36:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so4487184wrr.5;
        Sat, 17 Aug 2019 09:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4cEMxn7er9j4dg2TP+x6yIJDg+7kL5dIBFjDoqaNgeI=;
        b=u4bsS1b0PumHOXivyM1WLD2HpWejbtpwawIw+LTFbp/AlriQdS910MOu6PC7p/L1Qj
         Qq0GCqSvd+KLbZRJDOyW5kcjtoeYs5EKGS42rUyMEZOm4tSgjPN/sC9t/K15a5zvRo81
         OYwqgyzeLKh9qGTp69YBgSVtiExFGyNRd4UAxAtZ0ryrOPWdkQOly5V3FrVDO4e2PLF7
         oM0BTeXYKEquRwyaOzo1h5PYfDNlZszEfyg9WlJuUzGJe2ArhzWRduopbDFu6EXXs9hr
         10uxKdEYOe4kABFiwoWOld95ybT+mg6OAZTdxVY3POd85Z7JTs24RneCVJGxxINtH6gg
         a9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4cEMxn7er9j4dg2TP+x6yIJDg+7kL5dIBFjDoqaNgeI=;
        b=NgtXVpGVgcxN0tcU0N28okUsUWHbzW4yYJPAoxAHkOedIkthzZFFHSWj/rpkwPp5AJ
         KGWVHlHs/GMbJe8F4VVQMJkqrZxJuX2jS8p6OImJTGJH+KOt7LEQpXCaVcMhGxSEceKY
         KHu2qIi4rTH+vilNZFdfJz6dob0eYFhZ2CTTuvLV9KmXOHO1gu+1gouQLhVU/BHVBe4b
         0eJeS80e7Zj94P+lyFtNwvzbrzW5qFH2DjDqCA3u6YSYNdWLjL44dsckaCxAnrix1afq
         CvNM1JMRI5FVyRl8h1I2UgPgB8pvys0ibxepmZTu6BZej8LXNTMo1SwbaG5ZZfbs5Kb9
         6+nA==
X-Gm-Message-State: APjAAAXJSN0Fl0z9z8e1LE/aHvmtj5nM2ho9Tp9aSgtQ195XrKn+j6au
        /nshDtb/gdnRTC40IsuvVophDHRO
X-Google-Smtp-Source: APXvYqw5plpGftFlaDQue+g35lZmFuRF60W2rXD+zgaiBW37WM9k355K+DvzOFpkmnLqX439XQVd9Q==
X-Received: by 2002:a5d:664a:: with SMTP id f10mr17399226wrw.90.1566059770352;
        Sat, 17 Aug 2019 09:36:10 -0700 (PDT)
Received: from [192.168.8.147] (129.171.185.81.rev.sfr.net. [81.185.171.129])
        by smtp.gmail.com with ESMTPSA id g2sm17761457wru.27.2019.08.17.09.36.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 09:36:09 -0700 (PDT)
Subject: Re: 5.3-rc3-ish VM crash: RIP: 0010:tcp_trim_head+0x20/0xe0
To:     Sander Eikelenboom <linux@eikelenboom.it>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <27aebb57-0ca9-fba3-092f-39131ad2b648@eikelenboom.it>
 <4d803565-b716-42ab-1db8-3dcade91e939@gmail.com>
 <674de4ab-c37f-7787-f95a-3ae0f52bc196@eikelenboom.it>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <59dd3497-6d08-1e0e-7a4f-b121b850a24f@gmail.com>
Date:   Sat, 17 Aug 2019 18:35:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <674de4ab-c37f-7787-f95a-3ae0f52bc196@eikelenboom.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/19 10:24 AM, Sander Eikelenboom wrote:
> On 12/08/2019 19:56, Eric Dumazet wrote:
>>
>>
>> On 8/12/19 2:50 PM, Sander Eikelenboom wrote:
>>> L.S.,
>>>
>>> While testing a somewhere-after-5.3-rc3 kernel (which included the latest net merge (33920f1ec5bf47c5c0a1d2113989bdd9dfb3fae9),
>>> one of my Xen VM's (which gets quite some network load) crashed.
>>> See below for the stacktrace.
>>>
>>> Unfortunately I haven't got a clear trigger, so bisection doesn't seem to be an option at the moment. 
>>> I haven't encountered this on 5.2, so it seems to be an regression against 5.2.
>>>
>>> Any ideas ?
>>>
>>> --
>>> Sander
>>>
>>>
>>> [16930.653595] general protection fault: 0000 [#1] SMP NOPTI
>>> [16930.653624] CPU: 0 PID: 3275 Comm: rsync Not tainted 5.3.0-rc3-20190809-doflr+ #1
>>> [16930.653657] RIP: 0010:tcp_trim_head+0x20/0xe0
>>> [16930.653677] Code: 2e 0f 1f 84 00 00 00 00 00 90 41 54 41 89 d4 55 48 89 fd 53 48 89 f3 f6 46 7e 01 74 2f 8b 86 bc 00 00 00 48 03 86 c0 00 00 00 <8b> 40 20 66 83 f8 01 74 19 31 d2 31 f6 b9 20 0a 00 00 48 89 df e8
>>> [16930.653741] RSP: 0000:ffffc90000003ad8 EFLAGS: 00010286
>>> [16930.653762] RAX: fffe888005bf62c0 RBX: ffff8880115fb800 RCX: 000000008010000b
>>
>> crash in " mov    0x20(%rax),%eax"   and RAX=fffe888005bf62c0 (not a valid kernel address)
>>
>> Look like one bit corruption maybe.
>>
>> Nothing comes to mind really between 5.2 and 53 that could explain this.
>>
>>> [16930.653791] RDX: 00000000000005a0 RSI: ffff8880115fb800 RDI: ffff888016b00880
>>> [16930.653819] RBP: ffff888016b00880 R08: 0000000000000001 R09: 0000000000000000
>>> [16930.653848] R10: ffff88800ae00800 R11: 00000000bfe632e6 R12: 00000000000005a0
>>> [16930.653875] R13: 0000000000000001 R14: 00000000bfe62d46 R15: 0000000000000004
>>> [16930.653913] FS:  00007fe71fe2cb80(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000
>>> [16930.653943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [16930.653965] CR2: 000055de0f3e7000 CR3: 0000000011f32000 CR4: 00000000000006f0
>>> [16930.653993] Call Trace:
>>> [16930.654005]  <IRQ>
>>> [16930.654018]  tcp_ack+0xbb0/0x1230
>>> [16930.654033]  tcp_rcv_established+0x2e8/0x630
>>> [16930.654053]  tcp_v4_do_rcv+0x129/0x1d0
>>> [16930.654070]  tcp_v4_rcv+0xac9/0xcb0
>>> [16930.654088]  ip_protocol_deliver_rcu+0x27/0x1b0
>>> [16930.654109]  ip_local_deliver_finish+0x3f/0x50
>>> [16930.654128]  ip_local_deliver+0x4d/0xe0
>>> [16930.654145]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
>>> [16930.654163]  ip_rcv+0x4c/0xd0
>>> [16930.654179]  __netif_receive_skb_one_core+0x79/0x90
>>> [16930.654200]  netif_receive_skb_internal+0x2a/0xa0
>>> [16930.654219]  napi_gro_receive+0xe7/0x140
>>> [16930.654237]  xennet_poll+0x9be/0xae0
>>> [16930.654254]  net_rx_action+0x136/0x340
>>> [16930.654271]  __do_softirq+0xdd/0x2cf
>>> [16930.654287]  irq_exit+0x7a/0xa0
>>> [16930.654304]  xen_evtchn_do_upcall+0x27/0x40
>>> [16930.654320]  xen_hvm_callback_vector+0xf/0x20
>>> [16930.654339]  </IRQ>
>>> [16930.654349] RIP: 0033:0x55de0d87db99
>>> [16930.654364] Code: 00 00 48 89 7c 24 f8 45 39 fe 45 0f 42 fe 44 89 7c 24 f4 eb 09 0f 1f 40 00 83 e9 01 74 3e 89 f2 48 63 f8 4c 01 d2 44 38 1c 3a <75> 25 44 38 6c 3a ff 75 1e 41 0f b6 3c 24 40 38 3a 75 14 41 0f b6
>>> [16930.654432] RSP: 002b:00007ffd5531eec8 EFLAGS: 00000a87 ORIG_RAX: ffffffffffffff0c
>>> [16930.655004] RAX: 0000000000000002 RBX: 000055de0f3e8e50 RCX: 000000000000007f
>>> [16930.655034] RDX: 000055de0f3dc2d2 RSI: 0000000000003492 RDI: 0000000000000002
>>> [16930.655062] RBP: 0000000000007fff R08: 00000000000080ea R09: 00000000000001f0
>>> [16930.655089] R10: 000055de0f3d8e40 R11: 0000000000000094 R12: 000055de0f3e0f2a
>>> [16930.655116] R13: 0000000000000010 R14: 0000000000007f16 R15: 0000000000000080
>>> [16930.655144] Modules linked in:
>>> [16930.655200] ---[ end trace 533367c95501b645 ]---
>>> [16930.655223] RIP: 0010:tcp_trim_head+0x20/0xe0
>>> [16930.655243] Code: 2e 0f 1f 84 00 00 00 00 00 90 41 54 41 89 d4 55 48 89 fd 53 48 89 f3 f6 46 7e 01 74 2f 8b 86 bc 00 00 00 48 03 86 c0 00 00 00 <8b> 40 20 66 83 f8 01 74 19 31 d2 31 f6 b9 20 0a 00 00 48 89 df e8
>>> [16930.655312] RSP: 0000:ffffc90000003ad8 EFLAGS: 00010286
>>> [16930.655331] RAX: fffe888005bf62c0 RBX: ffff8880115fb800 RCX: 000000008010000b
>>> [16930.655360] RDX: 00000000000005a0 RSI: ffff8880115fb800 RDI: ffff888016b00880
>>> [16930.655387] RBP: ffff888016b00880 R08: 0000000000000001 R09: 0000000000000000
>>> [16930.655414] R10: ffff88800ae00800 R11: 00000000bfe632e6 R12: 00000000000005a0
>>> [16930.655441] R13: 0000000000000001 R14: 00000000bfe62d46 R15: 0000000000000004
>>> [16930.655475] FS:  00007fe71fe2cb80(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000
>>> [16930.655502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [16930.655525] CR2: 000055de0f3e7000 CR3: 0000000011f32000 CR4: 00000000000006f0
>>> [16930.655553] Kernel panic - not syncing: Fatal exception in interrupt
>>> [16930.655789] Kernel Offset: disabled
>>>
> 
> Hi Eric,
> 
> Got another VM crash, with a slightly different stacktrace this time around.
> Still networking though.
> 
> --
> Sander
> 
> [112522.697498] general protection fault: 0000 [#1] SMP NOPTI
> [112522.697555] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-rc4-20190812-doflr+ #1
> [112522.697592] RIP: 0010:skb_shift+0x63/0x430
> [112522.697608] Code: bc 00 00 00 48 03 8f c0 00 00 00 f6 41 03 08 74 07 48 83 79 28 00 75 d0 8b 8e bc 00 00 00 48 03 8e c0 00 00 00 48 85 f6 74 0a <f6> 41 03 08 0f 85 09 03 00 00 49 89 fd 8b bf bc 00 00 00 41 89 



crash in "testb  $0x8,0x3(%rcx)"  with RCX==fffe8880117da6c0

Same strange looking address on x86_64

I have no idea.

> [112522.697673] RSP: 0018:ffffc900000039b0 EFLAGS: 00010286
> [112522.697693] RAX: 00000000000005a0 RBX: ffff8880117fb800 RCX: fffe8880117da6c0
> [112522.697721] RDX: 00000000000005a0 RSI: ffff8880117fb800 RDI: ffff88800ae58000
> [112522.697748] RBP: ffffc900000039e8 R08: 000000000004cfe0 R09: 00000000000005a0
> [112522.697775] R10: 00000000000005a0 R11: ffff8880117fb800 R12: 0000000000000000
> [112522.697803] R13: 00000000c95a98c2 R14: 0000000000000000 R15: ffff88800ae58000
> [112522.697839] FS:  0000000000000000(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000
> [112522.697869] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [112522.697895] CR2: 00007f9210d8e078 CR3: 000000000b660000 CR4: 00000000000006f0
> [112522.697925] Call Trace:
> [112522.697938]  <IRQ>
> [112522.697951]  tcp_sacktag_walk+0x2af/0x480
> [112522.697967]  tcp_sacktag_write_queue+0x34d/0x820
> [112522.697986]  ? ip_forward_options.cold.0+0x1c/0x1c
> [112522.698007]  tcp_ack+0xb8c/0x1230
> [112522.698023]  ? tcp_event_new_data_sent+0x4a/0x90
> [112522.698043]  tcp_rcv_established+0x14c/0x630
> [112522.698064]  tcp_v4_do_rcv+0x129/0x1d0
> [112522.698081]  tcp_v4_rcv+0xac9/0xcb0
> [112522.698099]  ip_protocol_deliver_rcu+0x27/0x1b0
> [112522.698119]  ip_local_deliver_finish+0x3f/0x50
> [112522.698139]  ip_local_deliver+0x4d/0xe0
> [112522.698155]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
> [112522.698177]  ip_rcv+0x4c/0xd0
> [112522.698194]  __netif_receive_skb_one_core+0x79/0x90
> [112522.698215]  netif_receive_skb_internal+0x2a/0xa0
> [112522.698237]  napi_gro_receive+0xe7/0x140
> [112522.698255]  xennet_poll+0x9be/0xae0
> [112522.698271]  net_rx_action+0x136/0x340
> [112522.698288]  __do_softirq+0xdd/0x2cf
> [112522.698304]  irq_exit+0x7a/0xa0
> [112522.698321]  xen_evtchn_do_upcall+0x27/0x40
> [112522.698340]  xen_hvm_callback_vector+0xf/0x20
> [112522.698359]  </IRQ>
> [112522.698373] RIP: 0010:native_safe_halt+0xe/0x10
> [112522.698392] Code: 48 8b 04 25 c0 6b 01 00 f0 80 48 02 20 48 8b 00 a8 08 75 c4 eb 80 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d 54 fb 41 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 44 fb 41 00 f4 c3 90 90 41 55 41 54
> [112522.699522] RSP: 0018:ffffffff82a03e90 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff0c
> [112522.699552] RAX: 0001a54800000000 RBX: 0000000000000000 RCX: 0000000000000001
> [112522.699580] RDX: 0000000002b9f9b6 RSI: 0000000000000087 RDI: 0000000000000000
> [112522.699608] RBP: 0000000000000000 R08: 000000001eb5c3cb R09: ffffffff82a08460
> [112522.699634] R10: 000000000002e46e R11: 0000000000000000 R12: 0000000000000000
> [112522.699662] R13: 0000000000000000 R14: ffffffff8326e0a0 R15: 0000000000000000
> [112522.699692]  default_idle+0x17/0x140
> [112522.699709]  do_idle+0x1ee/0x210
> [112522.699726]  cpu_startup_entry+0x14/0x20
> [112522.699743]  start_kernel+0x4e9/0x50b
> [112522.699760]  secondary_startup_64+0xa4/0xb0
> [112522.699780] Modules linked in:
> [112522.699829] ---[ end trace 3b8db3603485e952 ]---
> [112522.699850] RIP: 0010:skb_shift+0x63/0x430
> [112522.699866] Code: bc 00 00 00 48 03 8f c0 00 00 00 f6 41 03 08 74 07 48 83 79 28 00 75 d0 8b 8e bc 00 00 00 48 03 8e c0 00 00 00 48 85 f6 74 0a <f6> 41 03 08 0f 85 09 03 00 00 49 89 fd 8b bf bc 00 00 00 41 89 d4
> [112522.699938] RSP: 0018:ffffc900000039b0 EFLAGS: 00010286
> [112522.699959] RAX: 00000000000005a0 RBX: ffff8880117fb800 RCX: fffe8880117da6c0
> [112522.699986] RDX: 00000000000005a0 RSI: ffff8880117fb800 RDI: ffff88800ae58000
> [112522.700013] RBP: ffffc900000039e8 R08: 000000000004cfe0 R09: 00000000000005a0
> [112522.700041] R10: 00000000000005a0 R11: ffff8880117fb800 R12: 0000000000000000
> [112522.700067] R13: 00000000c95a98c2 R14: 0000000000000000 R15: ffff88800ae58000
> [112522.700111] FS:  0000000000000000(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000
> [112522.700140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [112522.700165] CR2: 00007f9210d8e078 CR3: 000000000b660000 CR4: 00000000000006f0
> [112522.700201] Kernel panic - not syncing: Fatal exception in interrupt
> [112522.702992] Kernel Offset: disabled
> 
> 
