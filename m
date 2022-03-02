Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA6D4CA098
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiCBJYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiCBJYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:24:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B40083C490
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646213009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=foExQQknn5+ykqqTjNflz4MN/o7z8a5WlPaDeSuniwY=;
        b=gY+U/zbS5+BSbpai/wKQWnCSZ/Ts7KfaAmlZCnn0JEI5exDNHu7Yk6t9JHDywxcXR8vSLS
        4PpISRc5cF7XScvZ6ZI8/UosJfmQAAx5IIzmzYpSGPcaFHSSQMkcazLdYofj+Qg0aYcjPE
        2xeI2WT+LdSIquCyPu+iokgJkuF1IEw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-P6so0qXqP2-5ezaju7P0jQ-1; Wed, 02 Mar 2022 04:23:29 -0500
X-MC-Unique: P6so0qXqP2-5ezaju7P0jQ-1
Received: by mail-qt1-f199.google.com with SMTP id j7-20020ac84407000000b002de72c633b2so847826qtn.13
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 01:23:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=foExQQknn5+ykqqTjNflz4MN/o7z8a5WlPaDeSuniwY=;
        b=l5OzWvp5H5NxQ4PzON9BaaRbUynYyF0MEMBEWachC2YHd2b/4u6uXe7OCzJvAa7Ji6
         u7BdCFwnOfBIemdVwzwbygpscw4MgczSzP3f3xsWytcf9aqWv8TFUQ6077rye1+8CxDB
         PHE6Ig2IC9ng7kkuLPEc5VMI2loqpsBq+hQmsy6eikTckAT8jzdWfDJwBtS2PLPMz1A6
         WeWWn3IbC6u8CUNYX3l9jFwx7xqY8f4SZCVRKP3qv0UbJaTycctA9tDM6dsWrUCVUpUk
         VztgKnkHQc3idYqzlom/5oiv8TrqTqkmhnyJMiiR5d/2XzPJMBneZ3jIHsnEdrPgsAYV
         r5rg==
X-Gm-Message-State: AOAM533rU4WA2v1PhS9i/+SII8CcCVtL/OW4yzF25raTuOgxojh9yrU1
        FTh5XjCbgopyhYkg5NOpFF4EAfsVKroP9FOhd9zWpdaOMFNF3BOewUkU9N9v/yBR3W/6KBoilmT
        44P5Xjo3LYRcJmZQu
X-Received: by 2002:a05:622a:1714:b0:2de:755c:2c81 with SMTP id h20-20020a05622a171400b002de755c2c81mr22707086qtk.685.1646213008240;
        Wed, 02 Mar 2022 01:23:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqqlqDsysgnT4+ZcaC5E/HrMnr0i5bndO6omkJInksarmdfs77V4QCgirdVpSITO1M/a7bLA==
X-Received: by 2002:a05:622a:1714:b0:2de:755c:2c81 with SMTP id h20-20020a05622a171400b002de755c2c81mr22707073qtk.685.1646213008009;
        Wed, 02 Mar 2022 01:23:28 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id b17-20020ae9eb11000000b0064917bda713sm7733701qkg.85.2022.03.02.01.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 01:23:27 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:23:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        syzbot <syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] kernel BUG in vhost_get_vq_desc
Message-ID: <20220302092321.rfyht3xhyybpohkw@sgarzare-redhat>
References: <00000000000070ac6505d7d9f7a8@google.com>
 <0000000000003b07b305d840b30f@google.com>
 <20220218063352-mutt-send-email-mst@kernel.org>
 <Yh8q9fzCQHW2qtIG@google.com>
 <20220302091807.uyo7ycd6yw6cx7hd@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220302091807.uyo7ycd6yw6cx7hd@sgarzare-redhat>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:18:07AM +0100, Stefano Garzarella wrote:
>On Wed, Mar 02, 2022 at 08:29:41AM +0000, Lee Jones wrote:
>>On Fri, 18 Feb 2022, Michael S. Tsirkin wrote:
>>
>>>On Thu, Feb 17, 2022 at 05:21:20PM -0800, syzbot wrote:
>>>> syzbot has found a reproducer for the following issue on:
>>>>
>>>> HEAD commit:    f71077a4d84b Merge tag 'mmc-v5.17-rc1-2' of git://git.kern..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=104c04ca700000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3140b17cb44a7b174008
>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1362e232700000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11373a6c700000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
>>>>
>>>> ------------[ cut here ]------------
>>>> kernel BUG at drivers/vhost/vhost.c:2335!
>>>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>>>> CPU: 1 PID: 3597 Comm: vhost-3596 Not tainted 5.17.0-rc4-syzkaller-00054-gf71077a4d84b #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
>>>> Code: 00 00 00 48 c7 c6 20 2c 9d 8a 48 c7 c7 98 a6 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 b7 59 28 fd e9 74 ff ff ff e8 5d c8 a1 fa <0f> 0b e8 56 c8 a1 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
>>>> RSP: 0018:ffffc90001d1fb88 EFLAGS: 00010293
>>>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>>>> RDX: ffff8880234b0000 RSI: ffffffff86d715c3 RDI: 0000000000000003
>>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
>>>> R10: ffffffff86d706bc R11: 0000000000000000 R12: ffff888072c24d68
>>>> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888072c24bb0
>>>> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 0000000000000002 CR3: 000000007902c000 CR4: 00000000003506e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> Call Trace:
>>>>  <TASK>
>>>>  vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
>>>>  vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>>>>  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>>>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>>>
>>>I don't see how this can trigger normally so I'm assuming
>>>another case of use after free.
>>
>>Yes, exactly.
>
>I think this issue is related to the issue fixed by this patch merged 
>some days ago upstream: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
>
>>
>>I patched it.  Please see:
>>
>>https://lore.kernel.org/all/20220302075421.2131221-1-lee.jones@linaro.org/T/#t
>>
>
>I'm not sure that patch is avoiding the issue. I'll reply to it.

My bad, I think it should be fine, because vhost_vq_reset() set 
vq->private_data to NULL and avoids the worker to run.

Thanks,
Stefano

