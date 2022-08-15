Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA13594DC7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344437AbiHPA11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 20:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355192AbiHPA0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 20:26:35 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DCF4D838;
        Mon, 15 Aug 2022 13:34:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so7742972pjf.5;
        Mon, 15 Aug 2022 13:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=4KBjvCyqweA/YX6s5FrlHJFUw4QF4lCn5nqOQumUNOw=;
        b=n7wjnkSjZc1R11i26aCHTFhm74vZ8nzR9cXmhqbIckThGcJwEbsNfn0yV54qtZY/aA
         3754Wn+6H4TQ/KYOC6p+fWd1hFCRjZgh8a+5hypTteu8iZiY9VzQymDfIdktlyVPjyIG
         bFXqUv97O4zemEtV1538vosbA6PIRXK2HIb2m5JGaEJV01domLWcDGkxsCjCOlTZF9uy
         /URJnyuvJfrpvx6obJoe42NfPRQxaMogFFImYSbep1347D3/i7RRT0EgcIkcMQ/XUAJn
         m5qnorABzZVhiWEK4fk3BjC3N0xItDOHL+utn71Os/nV1ahcNywlz9dYRl4cxp59HSqQ
         iVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=4KBjvCyqweA/YX6s5FrlHJFUw4QF4lCn5nqOQumUNOw=;
        b=e2vGH6tKNrxfTdYahFDNvpEn6qcOLaBGK39KK5uHegBdviT4pMp8hm/QoemobnS8dZ
         aIpGPCvTNpkbyB64Dm8G58DQ0zDZysu4zHod9qHQtl3TycPSAwlCvaZFZuFxCLgZZkHQ
         eQLb8+DShCSqN8k4j4LuG9LpmF+yrT2ygRthKtRSNmVBhfcRiie8uGRHsRH4ilw+L0Zs
         foM3qStKHx9xuHAKpMPDLoan8uXCIeWDNq2DJbRRxbDnlTylh8+y1nK9I8Ca+L7M/vx2
         Qd+goctm62yWpk8wj/M2kSaFNnirN15tcvdMEeH6fO7CPBWOhY9Cc2S4KxDAgzl3CXjH
         qhRg==
X-Gm-Message-State: ACgBeo0kIWQwf7PTks69i1codmDuFFCD3Dovvfm+pqM6rk52L2UV2l5p
        QTIp9b+4h1IbxMzrobzkDXI=
X-Google-Smtp-Source: AA6agR56UkQzLgBD2aEpa9hh8Hb8XpBeAwQQqChCNJu6bckZm5Rn+ApILdQPknCukpG3U0gTJGgNkA==
X-Received: by 2002:a17:90a:a416:b0:1f7:3b5f:1cd1 with SMTP id y22-20020a17090aa41600b001f73b5f1cd1mr20111586pjp.216.1660595669422;
        Mon, 15 Aug 2022 13:34:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 128-20020a620586000000b0052baa22575asm6934652pff.134.2022.08.15.13.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 13:34:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Aug 2022 13:34:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        Andres Freund <andres@anarazel.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, c@redhat.com
Subject: Re: [PATCH] virtio_net: Revert "virtio_net: set the default max ring
 size by find_vqs()"
Message-ID: <20220815203426.GA509309@roeck-us.net>
References: <20220815090521.127607-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815090521.127607-1-mst@redhat.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 05:16:50AM -0400, Michael S. Tsirkin wrote:
> This reverts commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7.
> 
> This has been reported to trip up guests on GCP (Google Cloud).  Why is
> not yet clear - to be debugged, but the patch itself has several other
> issues:
> 
> - It treats unknown speed as < 10G
> - It leaves userspace no way to find out the ring size set by hypervisor
> - It tests speed when link is down
> - It ignores the virtio spec advice:
>         Both \field{speed} and \field{duplex} can change, thus the driver
>         is expected to re-read these values after receiving a
>         configuration change notification.
> - It is not clear the performance impact has been tested properly
> 
> Revert the patch for now.
> 
> Link: https://lore.kernel.org/r/20220814212610.GA3690074%40roeck-us.net
> Link: https://lore.kernel.org/r/20220815070203.plwjx7b3cyugpdt7%40awork3.anarazel.de
> Link: https://lore.kernel.org/r/3df6bb82-1951-455d-a768-e9e1513eb667%40www.fastmail.com
> Link: https://lore.kernel.org/r/FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE%40anarazel.de
> Fixes: 762faee5a267 ("virtio_net: set the default max ring size by find_vqs()")
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Andres Freund <andres@anarazel.de>

I ran this patch through a total of 14 syskaller tests, 2 test runs each on
7 different crashes reported by syzkaller (as reported to the linux-kernel
mailing list). No problems were reported. I also ran a single cross-check
with one of the syzkaller runs on top of v6.0-rc1, without this patch.
That test run failed.

Overall, I think we can call this fixed.

Guenter

---
syskaller reports:

Reported-and-tested-by: syzbot+2984d1b7aef6b51353f0@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b9175e0879a7749
dashboard link: https://syzkaller.appspot.com/bug?extid=2984d1b7aef6b51353f0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11949fc3080000

Reported-and-tested-by: syzbot+2c35c4d66094ddfe198e@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cb39b084894e9a5
dashboard link: https://syzkaller.appspot.com/bug?extid=2c35c4d66094ddfe198e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=163e20f3080000

Reported-and-tested-by: syzbot+97f830ad641de86d08c0@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=f267ed4fb258122a
dashboard link: https://syzkaller.appspot.com/bug?extid=97f830ad641de86d08c0
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=146c8e5b080000

Reported-and-tested-by: syzbot+005efde5e97744047fe4@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cb39b084894e9a5
dashboard link: https://syzkaller.appspot.com/bug?extid=005efde5e97744047fe4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=106c8e5b080000

Reported-and-tested-by: syzbot+9ada839c852179f13999@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b9175e0879a7749
dashboard link: https://syzkaller.appspot.com/bug?extid=9ada839c852179f13999
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=118756f3080000

Reported-and-tested-by: syzbot+382af021ce115a936b1f@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=e656d8727a25e83b
dashboard link: https://syzkaller.appspot.com/bug?extid=382af021ce115a936b1f
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=135f650d080000

Reported-and-tested-by: syzbot+24df94a8d05d5a3e68f0@syzkaller.appspotmail.com

Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.0-rc1
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b9175e0879a7749
dashboard link: https://syzkaller.appspot.com/bug?extid=24df94a8d05d5a3e68f0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12758a47080000
