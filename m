Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C054CA06E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbiCBJTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiCBJTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:19:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAB028E196
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646212698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/k2VmYz+o3cpXUbtVkQoEKWCQmbl907XuCsT2KacOa0=;
        b=LEOhn9uji6ELdXC8EsGQGIEhehXlMywrSquFSOCI1ONn8IRfE23C0iUB4aDpZulYBEPgyl
        mIjhcu/etxnB5+c1Orw7WK9SIkVuKYK9CyjhHm+NBqLdVbuKlRSWuxAcU0JOvtvjtvMtKQ
        GEw9IY2OkxE2F+47geV3Tcj0svba1Rs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-0ly6aR0iOxKrxpfVGeE1dA-1; Wed, 02 Mar 2022 04:18:17 -0500
X-MC-Unique: 0ly6aR0iOxKrxpfVGeE1dA-1
Received: by mail-qk1-f197.google.com with SMTP id a15-20020a05620a066f00b0060c66d84489so672443qkh.19
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 01:18:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/k2VmYz+o3cpXUbtVkQoEKWCQmbl907XuCsT2KacOa0=;
        b=GYzax52eYAV5c4JEWuCYIkb1hhF1v+fOfgy29xIowe313+6lnbgEY+LVlWhQFwYLM6
         IWJr7dTPQBpJ/N8vuA4hKDZxY1mjdtderpugO0J3+dDZO66TTtstqNWcDryR3vCrFvJg
         jHrCflOHfLl3w8p659x3vvHY2Q+ckmtEI6z4Xl1+NmnUJ+HabXmsPUBlQejCdon5mzHl
         xQmTtMQBbtz3Osy5NYBq9H4BwfmpZmtiKsQNHZZ8di4mwxzORbxX5vKKQveWl57VU40a
         BpF2wC5EozkdCt0wBkvl5V4Zy5UJ0iEtXuT1oHRVXkE4CFZSWjbAIbJycvqfaLGgqQY/
         6DNg==
X-Gm-Message-State: AOAM530el7sDbWB//NU3ly8E6H90Lyha8HxvR191UvP21D3Z0okMXdBt
        44nfaEC5PtbPAuiC9Aygf5JQ311nJvd6kZfKXppnaLYHs1fDd4Jpz1RDhcCjMMEHx+z7X3Kh/qE
        d0l1fgJH5aQyN0dOr
X-Received: by 2002:a0c:d991:0:b0:432:c0c0:a6c5 with SMTP id y17-20020a0cd991000000b00432c0c0a6c5mr16665684qvj.23.1646212697392;
        Wed, 02 Mar 2022 01:18:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjYadbC0ZzXIcUVFlYssKE6/+21ynY+c3z8ydk8SARiLY20dVrDd2uNAQv/wlX6S8u2FOpWQ==
X-Received: by 2002:a0c:d991:0:b0:432:c0c0:a6c5 with SMTP id y17-20020a0cd991000000b00432c0c0a6c5mr16665675qvj.23.1646212697118;
        Wed, 02 Mar 2022 01:18:17 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id f7-20020a05622a104700b002d4b318692esm10885790qte.31.2022.03.02.01.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 01:18:16 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:18:07 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        syzbot <syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] kernel BUG in vhost_get_vq_desc
Message-ID: <20220302091807.uyo7ycd6yw6cx7hd@sgarzare-redhat>
References: <00000000000070ac6505d7d9f7a8@google.com>
 <0000000000003b07b305d840b30f@google.com>
 <20220218063352-mutt-send-email-mst@kernel.org>
 <Yh8q9fzCQHW2qtIG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yh8q9fzCQHW2qtIG@google.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 08:29:41AM +0000, Lee Jones wrote:
>On Fri, 18 Feb 2022, Michael S. Tsirkin wrote:
>
>> On Thu, Feb 17, 2022 at 05:21:20PM -0800, syzbot wrote:
>> > syzbot has found a reproducer for the following issue on:
>> >
>> > HEAD commit:    f71077a4d84b Merge tag 'mmc-v5.17-rc1-2' of git://git.kern..
>> > git tree:       upstream
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=104c04ca700000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=3140b17cb44a7b174008
>> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1362e232700000
>> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11373a6c700000
>> >
>> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> > Reported-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
>> >
>> > ------------[ cut here ]------------
>> > kernel BUG at drivers/vhost/vhost.c:2335!
>> > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>> > CPU: 1 PID: 3597 Comm: vhost-3596 Not tainted 5.17.0-rc4-syzkaller-00054-gf71077a4d84b #0
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> > RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
>> > Code: 00 00 00 48 c7 c6 20 2c 9d 8a 48 c7 c7 98 a6 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 b7 59 28 fd e9 74 ff ff ff e8 5d c8 a1 fa <0f> 0b e8 56 c8 a1 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
>> > RSP: 0018:ffffc90001d1fb88 EFLAGS: 00010293
>> > RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>> > RDX: ffff8880234b0000 RSI: ffffffff86d715c3 RDI: 0000000000000003
>> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
>> > R10: ffffffff86d706bc R11: 0000000000000000 R12: ffff888072c24d68
>> > R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888072c24bb0
>> > FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > CR2: 0000000000000002 CR3: 000000007902c000 CR4: 00000000003506e0
>> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> > Call Trace:
>> >  <TASK>
>> >  vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
>> >  vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>> >  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>>
>> I don't see how this can trigger normally so I'm assuming
>> another case of use after free.
>
>Yes, exactly.

I think this issue is related to the issue fixed by this patch merged 
some days ago upstream: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9

>
>I patched it.  Please see:
>
>https://lore.kernel.org/all/20220302075421.2131221-1-lee.jones@linaro.org/T/#t
>

I'm not sure that patch is avoiding the issue. I'll reply to it.

Thanks,
Stefano

