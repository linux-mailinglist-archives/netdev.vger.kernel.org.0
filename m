Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4970D6C7AE9
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjCXJMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCXJMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:12:20 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5891DBAD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:12:19 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id i7-20020a056e021b0700b0031dc4cdc47cso840307ilv.23
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679649139;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xa6cPJxdtQSnna0xqHCmCayWpi2ePeYQchAotaGPYRc=;
        b=2g9bMQFUyejMNAJi7QlM0QDDcM3aetpf/fHt3CsIWerZVbO/Lm2WtulvJ8YWBLF5sl
         yjg7GElk8ZUtOuIQQ3qclBzFHDK534sRVHrWbBxkwhl8DrHbr55HA9ZkO6IPBoArPjmf
         ZxyvrXXB43C+Cqr3K9NX0QatNFmwxXYRLBso2bcpLyeijndX3iOYO7UBjnqLUbhoEZNV
         XFRR8RZMlUW25tcHkms8EbFV4ERIBa/kaYhc23304+NeqUpFjOUm2lPYBge7/gm5MBAF
         COIJ9VmFl4VxdB821i11VR0GXIZXpFOpQGvpXF5vulqF+rylB1CkcNYMdVidTaOUU42J
         CKUA==
X-Gm-Message-State: AO0yUKW37bZQdeFhOZuBKEJ6q+/S8UQCW8wvKdsoxiTk3oFWeCZt9oXP
        /krH6QTRg/yEbZBc+trJ/DxnfVbepn6lsiEfwu0lEFLKxjuQ
X-Google-Smtp-Source: AK7set+YVLkN81/TSa+kOl9UXO+R6l+gdava5D+ne0NuX1VS6u8zvSz21vB9lr4PCjBdOEUNrT0FZLCf8cGF6F92Dojr1D8nj6WD
MIME-Version: 1.0
X-Received: by 2002:a5d:9446:0:b0:753:2ab8:aff7 with SMTP id
 x6-20020a5d9446000000b007532ab8aff7mr789747ior.1.1679649139064; Fri, 24 Mar
 2023 02:12:19 -0700 (PDT)
Date:   Fri, 24 Mar 2023 02:12:19 -0700
In-Reply-To: <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000480a6c05f7a1ca68@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in virtio_transport_purge_skbs
From:   syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>
To:     avkrasnov@sberdevices.ru, bobby.eshleman@bytedance.com,
        bobby.eshleman@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, oxffffaa@gmail.com, pabeni@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

net/vmw_vsock/vsock_loopback.c:155:21: error: 'struct vsock_loopback' has no member named 'pkt_list_lock'
net/vmw_vsock/vsock_loopback.c:157:23: error: 'struct vsock_loopback' has no member named 'pkt_list_lock'


Tested on:

commit:         fff5a5e7 Merge tag 'for-linus' of git://git.armlinux.o..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
dashboard link: https://syzkaller.appspot.com/bug?extid=befff0a9536049e7902e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15ed6191c80000

