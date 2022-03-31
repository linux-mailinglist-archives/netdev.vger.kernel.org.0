Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754154ED7E5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiCaKpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiCaKpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:45:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BD1D3DDCA
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648723441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vj6g3gUSYO2QDZVoTiKffZeF2Z9UD7UuSg72XYT1ggQ=;
        b=NzBtD4h96L6EXnGvhrk5mc7Dj3UboDVuhaAQ6CPBwWbGRI18Wv7bFlmSkNE/KqNtyJbbNt
        g2wZkjM6cadzHmqJ7GAel8CeG6+hRV3JGlJqDJjoo0QHNTCbf4I9Dwp8M+2r1Dj0D1MtPk
        FNRsr2bKs5IEZNJGK95+ekQBMv9wzCs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-WmE9B63WNZeeYTdqwdL8OA-1; Thu, 31 Mar 2022 06:44:00 -0400
X-MC-Unique: WmE9B63WNZeeYTdqwdL8OA-1
Received: by mail-wm1-f72.google.com with SMTP id q186-20020a1c43c3000000b0038ce534d9e2so7518017wma.0
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vj6g3gUSYO2QDZVoTiKffZeF2Z9UD7UuSg72XYT1ggQ=;
        b=yqd2UocdoYcWGJ0OB+aBDD0shld/3KDbg/tKwqY4SAlB4d5Hp1r8+2aedAlmcI3g1h
         03NIeNYTfOf+O9l+U7NlLQeno77NlyPfomxJrEU4GgtN4k4Mnn1yVxrOM+bSgOE1nAwj
         k6IZe1XJdfd3r8wgbSikbhic9Ru5U0jdZ3fQotgVivk34azrjdVU5mUgKkGvpVF7KRX0
         QaIhewpPNNF3y8zvU4Zpgqd5u4rLXYUmIKmr+63nHgR0A310voUscfTkLTUHahbvMcdY
         kim0fu3hFyazEP9YdI7z45Fvagfx9QUh20d2xL1uvdYJXIeYUXxymi0XOjN+5lR0B1cW
         62mA==
X-Gm-Message-State: AOAM533Rf0CHOrUQioywcRaIN0a9G/kYrJGSkDuaizjM2UzgXAfqmN81
        CljHECKtunDbj/7b7CbhBXfwsgEG2gQmaHPwSpKmYEQc4eGEOnHId6KzUGBoyeQvS8EIa6AJl1I
        c09CpiPHPfNRb3Vl7
X-Received: by 2002:adf:ef11:0:b0:205:b266:68eb with SMTP id e17-20020adfef11000000b00205b26668ebmr3781276wro.310.1648723438635;
        Thu, 31 Mar 2022 03:43:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVmlsJ78MuJ48AMUdhjhN4QW1Ues+U0LGGCks+vl01aUMeGLtKbA7PrMxkj70FCxZI6jczrA==
X-Received: by 2002:adf:ef11:0:b0:205:b266:68eb with SMTP id e17-20020adfef11000000b00205b26668ebmr3781266wro.310.1648723438388;
        Thu, 31 Mar 2022 03:43:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-142.dyn.eolo.it. [146.241.243.142])
        by smtp.gmail.com with ESMTPSA id o14-20020a5d47ce000000b00203e0a21c16sm23333978wrc.3.2022.03.31.03.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 03:43:57 -0700 (PDT)
Message-ID: <4de651adc35341c5fa99db54b9295d4845648563.camel@redhat.com>
Subject: Re: [PATCH net] rxrpc: fix some null-ptr-deref bugs in server_key.c
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 31 Mar 2022 12:43:56 +0200
In-Reply-To: <164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk>
References: <164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-30 at 15:22 +0100, David Howells wrote:
> From: Xiaolong Huang <butterflyhuangxx@gmail.com>
> 
> Some function calls are not implemented in rxrpc_no_security, there are
> preparse_server_key, free_preparse_server_key and destroy_server_key.
> When rxrpc security type is rxrpc_no_security, user can easily trigger a
> null-ptr-deref bug via ioctl. So judgment should be added to prevent it
> 
> The crash log:
> user@syzkaller:~$ ./rxrpc_preparse_s
> [   37.956878][T15626] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   37.957645][T15626] #PF: supervisor instruction fetch in kernel mode
> [   37.958229][T15626] #PF: error_code(0x0010) - not-present page
> [   37.958762][T15626] PGD 4aadf067 P4D 4aadf067 PUD 4aade067 PMD 0
> [   37.959321][T15626] Oops: 0010 [#1] PREEMPT SMP
> [   37.959739][T15626] CPU: 0 PID: 15626 Comm: rxrpc_preparse_ Not tainted 5.17.0-01442-gb47d5a4f6b8d #43
> [   37.960588][T15626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> [   37.961474][T15626] RIP: 0010:0x0
> [   37.961787][T15626] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> [   37.962480][T15626] RSP: 0018:ffffc9000d9abdc0 EFLAGS: 00010286
> [   37.963018][T15626] RAX: ffffffff84335200 RBX: ffff888012a1ce80 RCX: 0000000000000000
> [   37.963727][T15626] RDX: 0000000000000000 RSI: ffffffff84a736dc RDI: ffffc9000d9abe48
> [   37.964425][T15626] RBP: ffffc9000d9abe48 R08: 0000000000000000 R09: 0000000000000002
> [   37.965118][T15626] R10: 000000000000000a R11: f000000000000000 R12: ffff888013145680
> [   37.965836][T15626] R13: 0000000000000000 R14: ffffffffffffffec R15: ffff8880432aba80
> [   37.966441][T15626] FS:  00007f2177907700(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> [   37.966979][T15626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   37.967384][T15626] CR2: ffffffffffffffd6 CR3: 000000004aaf1000 CR4: 00000000000006f0
> [   37.967864][T15626] Call Trace:
> [   37.968062][T15626]  <TASK>
> [   37.968240][T15626]  rxrpc_preparse_s+0x59/0x90
> [   37.968541][T15626]  key_create_or_update+0x174/0x510
> [   37.968863][T15626]  __x64_sys_add_key+0x139/0x1d0
> [   37.969165][T15626]  do_syscall_64+0x35/0xb0
> [   37.969451][T15626]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   37.969824][T15626] RIP: 0033:0x43a1f9
> 
> Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
> Tested-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> Link: http://lists.infradead.org/pipermail/linux-afs/2022-March/005069.html

It looks like we can add a couple of fixes tag to help stable teams:

Fixes: d5953f6543b5 ("rxrpc: Allow security classes to give more info on server keys")
Fixes: 12da59fcab5a ("xrpc: Hand server key parsing off to the security class")

Does the above looks good to you?

Thanks!

Paolo

