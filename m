Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F385B98B0
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiIOKYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiIOKYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7728E0C6
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 03:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663237446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CfSbcmepWsIA1aUfLICLtdsOQUqYda//2mVwdPTKJrk=;
        b=KGTrBxQwhvoB29biK6lkm5EKCnFfaZVDEfnKwuUOaPMlxejYA3K+FmjZNyETvE5+tGZOSy
        dAzm4UG8ziWydSBsvnM13/cFt40m35Vb8srCBJEdnCuqNU/S3OaMOFPs1jX756tf7reS7E
        plF3X+wHIU/ToH2q6PFXQ1NPoIWgrrk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-28-MDtEGlplMmezek4tHQgYXQ-1; Thu, 15 Sep 2022 06:24:05 -0400
X-MC-Unique: MDtEGlplMmezek4tHQgYXQ-1
Received: by mail-wr1-f69.google.com with SMTP id g19-20020adfa493000000b0022a2ee64216so4670047wrb.14
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 03:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date;
        bh=CfSbcmepWsIA1aUfLICLtdsOQUqYda//2mVwdPTKJrk=;
        b=Xw8jwNRHxMFVYLCGMcRylaIKQufcGghk/uLGUoVc58gIkHj2ykQrFofpVMA/Md79CT
         8mKZp3fkNWR4WgDYAomg5tCMUKg0lF6L9wPfb1iHnwwnm4vaT/Z+OlLby7MIBMiTY/TN
         3mV1n1ocwH82aBh3De9sXRXBkwPgxvOl5MFgUrvRc/6MdJV4nVXPfcc8KCUwPY4Wi51b
         WAXBIl5+LwDhBSOU2RLOx7v2G0XQlI7XrjOQDalzdz6HYM4lySNSicludYlpQ5WNsC37
         sb2oi9Tebzc990N98eatZOElUFfVRoXos4kruOV8noDTPQ0873XMd/bWNBLBubR3+lqc
         D0kw==
X-Gm-Message-State: ACrzQf2lsdEI8Vy9ZOEu7Cn8VamYgk28dLNQ5HWXnLbqWB9AgHT2WH/r
        usVenRgWEWEM2NbXmFQSffXHTyx9MdW2RDXLeLUxQPSg3hUYCitlE+xqvp8PDfdGOVvGlK7TAhg
        ebBqlw+3xSczsjcYG
X-Received: by 2002:a5d:5850:0:b0:22a:cd4e:2ac3 with SMTP id i16-20020a5d5850000000b0022acd4e2ac3mr2769678wrf.568.1663237443682;
        Thu, 15 Sep 2022 03:24:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ddRUqyMGz29wGtwc3VBBA/sOM2gI4ghq/2Frh8bmQYGjGbNmOSmtfBkaI5s8FFQnEy4iwPw==
X-Received: by 2002:a5d:5850:0:b0:22a:cd4e:2ac3 with SMTP id i16-20020a5d5850000000b0022acd4e2ac3mr2769656wrf.568.1663237443281;
        Thu, 15 Sep 2022 03:24:03 -0700 (PDT)
Received: from gerbillo.redhat.com ([212.2.180.165])
        by smtp.gmail.com with ESMTPSA id m188-20020a1c26c5000000b003b33943ce5esm2229551wmm.32.2022.09.15.03.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 03:24:02 -0700 (PDT)
Message-ID: <7b630516987883ece2d02e26c4a20311c390c173.camel@redhat.com>
Subject: Re: [PATCH net] tun: Check tun device queue status in
 tun_chr_write_iter
From:   Paolo Abeni <pabeni@redhat.com>
To:     Liu Jian <liujian56@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org
Date:   Thu, 15 Sep 2022 12:24:01 +0200
In-Reply-To: <20220907010942.10096-1-liujian56@huawei.com>
References: <20220907010942.10096-1-liujian56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-09-07 at 09:09 +0800, Liu Jian wrote:
> syzbot found below warning:
> 
> ------------[ cut here ]------------
> geneve0 received packet on queue 3, but number of RX queues is 3
> WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_get_rxqueue net/core/dev.c:4611 [inline]
> WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> Modules linked in:
> CPU: 1 PID: 29734 Comm: syz-executor.0 Not tainted 5.10.0 #5
> Hardware name: linux,dummy-virt (DT)
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
> pc : netif_get_rxqueue net/core/dev.c:4611 [inline]
> pc : netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> lr : netif_get_rxqueue net/core/dev.c:4611 [inline]
> lr : netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> sp : ffffa00016127770
> x29: ffffa00016127770 x28: ffff3f4607d6acb4
> x27: ffff3f4607d6acb0 x26: ffff3f4607d6ad20
> x25: ffff3f461de3c000 x24: ffff3f4607d6ad28
> x23: ffffa00010059000 x22: ffff3f4608719100
> x21: 0000000000000003 x20: ffffa000161278a0
> x19: ffff3f4607d6ac40 x18: 0000000000000000
> x17: 0000000000000000 x16: 00000000f2f2f204
> x15: 00000000f2f20000 x14: 6465766965636572
> x13: 20306576656e6567 x12: ffff98b8ed3b924d
> x11: 1ffff8b8ed3b924c x10: ffff98b8ed3b924c
> x9 : ffffc5c76525c9c4 x8 : 0000000000000000
> x7 : 0000000000000001 x6 : ffff98b8ed3b924c
> x5 : ffff3f460f3b29c0 x4 : dfffa00000000000
> x3 : ffffc5c765000000 x2 : 0000000000000000
> x1 : 0000000000000000 x0 : ffff3f460f3b29c0
> Call trace:
>  netif_get_rxqueue net/core/dev.c:4611 [inline]
>  netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
>  do_xdp_generic net/core/dev.c:4777 [inline]
>  do_xdp_generic+0x9c/0x190 net/core/dev.c:4770
>  tun_get_user+0xd94/0x2010 drivers/net/tun.c:1938
>  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
>  call_write_iter include/linux/fs.h:1960 [inline]
>  new_sync_write+0x260/0x370 fs/read_write.c:515
>  vfs_write+0x51c/0x61c fs/read_write.c:602
>  ksys_write+0xfc/0x200 fs/read_write.c:655
>  __do_sys_write fs/read_write.c:667 [inline]
>  __se_sys_write fs/read_write.c:664 [inline]
>  __arm64_sys_write+0x50/0x60 fs/read_write.c:664
>  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>  el0_svc_common.constprop.0+0xf4/0x414 arch/arm64/kernel/syscall.c:155
>  do_el0_svc+0x50/0x11c arch/arm64/kernel/syscall.c:217
>  el0_svc+0x20/0x30 arch/arm64/kernel/entry-common.c:353
>  el0_sync_handler+0xe4/0x1e0 arch/arm64/kernel/entry-common.c:369
>  el0_sync+0x148/0x180 arch/arm64/kernel/entry.S:683
> 
> This is because the detached queue is used to send data. Therefore, we need
> to check the queue status in the tun_chr_write_iter function.
> 

Sorry for the late reply. We need a suitable fixes tag pointing to the
commit introducing the issue.

While at that, please also specify the target tree in the subj (-net)

Thanks!

Paolo

