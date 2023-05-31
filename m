Return-Path: <netdev+bounces-8592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F0CD724ACF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F25F51C20B50
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DAE22E32;
	Tue,  6 Jun 2023 18:07:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A619915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:07:45 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574E0170C;
	Tue,  6 Jun 2023 11:07:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b00ecabdf2so59814615ad.2;
        Tue, 06 Jun 2023 11:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686074863; x=1688666863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0hwtS5mthE8ORedBA1IkEsymrNnIIr+qtD7JhNdJ7w=;
        b=fP1GIQiYsHnBQrUBQV50NFEYS+Zq6mc5rTj7EuUMmqjRx4VOlQYOasfdfo8PRdmm8A
         6+d3PjamJge99/hYGpPAL6zjl15x4hVfptCaHjUeLTkloLl5IkF4ovKJTOh9+PW3sBOs
         3mexo1kETdbnIVh+wbuATXPzuVz1bxRo3JDzg0Tg7CUK2CcFF0BmiPEt6oEDKdZtNX/y
         Uz5pMbKPM2wUk/yC4jK5OIabtK70fUdjuAKIXw6XhDK5dstKqrAbdXlYHraIkBIRgn0C
         4xN28kvKzlbENCk9nUS7OhimhaMhTu5JpHYZfhnPimt32qHEeoy3Q77etXePz9xKV1ey
         pbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686074863; x=1688666863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0hwtS5mthE8ORedBA1IkEsymrNnIIr+qtD7JhNdJ7w=;
        b=UhIQVdzkN8MRp8ZE3zx0kcJ/pMsX8pulwHsQ4mxKqtG+8veyb8uW2UzrZEOJUg2/N0
         /0D5eoijDM5NyUueeFIyvh4RSrXeGHGJk07ggzPb2+Wsl4vw2m/ICO8XOqW0PgEB2OS/
         dP5QCwoPEmW9hqJQ51lzeXwFfwEpRrfXcDz4t8IRYo4KnQoN5yZdHzUBV1F/9lm864UW
         D3JExR5qQDST7tl2GNLB5s+H6h2V+RherwrCQKP8Gfr4o50Ko4RdII3bjX4QXVU1clC3
         aqLpQZ0HqeHGNSQ/Us36BwL2zCBSS6jR1ajt67SglATpbM+yVAx+Mb84EHTna1mIkMak
         PeSw==
X-Gm-Message-State: AC+VfDyLk4xL/6qfrsQV+WNUG/sCHnQEUzTIXQzfK13kijVcJNrNH7Eg
	daeMr5y/G+brjpxmM2kJvK4=
X-Google-Smtp-Source: ACHHUZ4KwpeZHnZv9+45bTIb7AnMOtp7aX/KdzGdJpRkMYWVQYklkc+60/cQY9TUFMMcMYvH1ufXPA==
X-Received: by 2002:a17:902:e742:b0:1b2:194b:9ce9 with SMTP id p2-20020a170902e74200b001b2194b9ce9mr3271917plf.44.1686074862578;
        Tue, 06 Jun 2023 11:07:42 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902a70700b001ae5cc15655sm8850788plq.5.2023.06.06.11.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 11:07:42 -0700 (PDT)
Date: Wed, 31 May 2023 21:10:23 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v3 0/8] virtio/vsock: support datagrams
Message-ID: <ZHe3v8PHcIdFk+R5@bullseye>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
 <2830ac58-fd77-7e5f-5565-eb47dd027d81@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2830ac58-fd77-7e5f-5565-eb47dd027d81@sberdevices.ru>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:42:06PM +0300, Arseniy Krasnov wrote:
> Hello Bobby!
> 
> Thanks for this patchset, really interesting!
> 
> I applied it on head:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b
> 
> And tried to run ./vsock_test (client in the guest, server in the host), I had the following crash:
> 
> Control socket connected to 192.168.1.1:12345.                          
> 0 - SOCK_STREAM connection reset...                                     
> [    8.050215] BUG: kernel NULL pointer derefer                         
> [    8.050960] #PF: supervisor read access in kernel mode               
> [    8.050960] #PF: error_code(0x0000) - not-present page               
> [    8.050960] PGD 0 P4D 0                                              
> [    8.050960] Oops: 0000 [#1] PREEMPT SMP PTI                          
> [    8.050960] CPU: 0 PID: 109 Comm: vsock_test Not tainted 6.4.0-rc3-gd707c220a700
> [    8.050960] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14
> [    8.050960] RIP: 0010:static_key_count+0x0/0x20                      
> [    8.050960] Code: 04 4c 8b 46 08 49 29 c0 4c 01 c8 4c 89 47 08 89 0e 89 56 04 4f
> [    8.050960] RSP: 0018:ffffa9a1c021bdc0 EFLAGS: 00010202              
> [    8.050960] RAX: ffffffffac309880 RBX: ffffffffc02fc140 RCX: 0000000000000000
> [    8.050960] RDX: ffff9a5eff944600 RSI: 0000000000000000 RDI: 0000000000000000
> [    8.050960] RBP: ffff9a5ec2371900 R08: ffffa9a1c021bd30 R09: ffff9a5eff98e0c0
> [    8.050960] R10: 0000000000001000 R11: 0000000000000000 R12: ffffa9a1c021be80
> [    8.050960] R13: 0000000000000000 R14: 0000000000000002 R15: ffff9a5ec1cfca80
> [    8.050960] FS:  00007fa9bf88c5c0(0000) GS:ffff9a5efe400000(0000) knlGS:00000000
> [    8.050960] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033        
> [    8.050960] CR2: 0000000000000000 CR3: 00000000023e0000 CR4: 00000000000006f0
> [    8.050960] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    8.050960] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    8.050960] Call Trace:                                              
> [    8.050960]  <TASK>                                                  
> [    8.050960]  once_deferred+0xd/0x30                                  
> [    8.050960]  vsock_assign_transport+0xa2/0x1b0 [vsock]               
> [    8.050960]  vsock_connect+0xb4/0x3a0 [vsock]                        
> [    8.050960]  ? var_wake_function+0x60/0x60                           
> [    8.050960]  __sys_connect+0x9e/0xd0                                 
> [    8.050960]  ? _raw_spin_unlock_irq+0xe/0x30                         
> [    8.050960]  ? do_setitimer+0x128/0x1f0                              
> [    8.050960]  ? alarm_setitimer+0x4c/0x90                             
> [    8.050960]  ? fpregs_assert_state_consistent+0x1d/0x50              
> [    8.050960]  ? exit_to_user_mode_prepare+0x36/0x130                  
> [    8.050960]  __x64_sys_connect+0x11/0x20                             
> [    8.050960]  do_syscall_64+0x3b/0xc0                                 
> [    8.050960]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5                
> [    8.050960] RIP: 0033:0x7fa9bf7c4d13                                 
> [    8.050960] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 48
> [    8.050960] RSP: 002b:00007ffdf2d96cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000a
> [    8.050960] RAX: ffffffffffffffda RBX: 0000560c305d0020 RCX: 00007fa9bf7c4d13
> [    8.050960] RDX: 0000000000000010 RSI: 00007ffdf2d96ce0 RDI: 0000000000000004
> [    8.050960] RBP: 0000000000000004 R08: 0000560c317dc018 R09: 0000000000000000
> [    8.050960] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [    8.050960] R13: 0000560c305ccc2d R14: 00007ffdf2d96ce0 R15: 00007ffdf2d96d70
> [    8.050960]  </TASK>  
> 
> 
> I guess crash is somewhere near:
> 
> old_info->transport->release(vsk); in vsock_assign_transport(). May be my config is wrong...
> 
> Thanks, Arseniy

Thanks Arseniy!

I now see I broke the tests, but did't break the stream/dgram socket
utility I was using in development.

I'll track this down and include a fix in the next rev.

I should have warned this v3 is pretty under-tested. Being unsure if
some of the design choices would be accepted at all, I didn't want to
waste too much time until things were accepted at a high level.

Best,
Bobby

