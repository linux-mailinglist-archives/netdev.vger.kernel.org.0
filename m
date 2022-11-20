Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B849631318
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 09:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiKTIjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 03:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKTIi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 03:38:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FA8140E7
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 00:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668933485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N3vbV+ztH5/Vvr0aVSjuKvkitpk+wLaTbt0iqubISsM=;
        b=i55Cob2M58pUl75uyaOGKGcvnBHd1uWzID4VT5yeBessT37Z8S6H7Kz06kUQuFlXmIl3Vc
        sP3z08+VIhfJoD02+p5uL5bIXNDFG5krx6SAgl5YDSOyuOH8PV0374oz6xBT9dEBvzWZUe
        rn2rxjrlqFiTqlbBuD+ZhgwWn01z3w4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-72SSQf7oPWSTaaU_dblttw-1; Sun, 20 Nov 2022 03:38:03 -0500
X-MC-Unique: 72SSQf7oPWSTaaU_dblttw-1
Received: by mail-pl1-f199.google.com with SMTP id m1-20020a170902db0100b00188eec2726cso7081404plx.18
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 00:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N3vbV+ztH5/Vvr0aVSjuKvkitpk+wLaTbt0iqubISsM=;
        b=Uh8gboL68VB9BHKjvJ4LpWR0zrUgSEoedWWjB/7ow7xhAML5XyMcMJqHCtxBbUgO6V
         uZXzD9U8hIsBp+kf12P7AE6htk7EGhMreK+GEqD0ZIDK8wBRV9OR2vlR6zADPhThKZu9
         f+YCXmwmrfMdxzYepyC8LvPMS9786VF8vbkpGMJeS0b9s8ILmcNr6JvmIEUC2iMTZVBc
         OHtk5bjTsJ4XEhvuCsLj4lIz471mBVKMbsypck1HoeNL7g66fY8BXxm/DQuDJ2QABhIG
         rGocjiiR0sNM9y8O09PQauGXlgby6qGNQ3Tpfx84sesZDbcFqh8D1biQVbZ9vJes+Eou
         C72Q==
X-Gm-Message-State: ANoB5png1rwwH+Yeoepd7Neg48RJjxOgn+lWHJ7Twrnip21EyCcRGU8S
        eiAwV1o3WTOrMKLhyy2CEZdFI0Yr6TlSURuoiZWXKOXtIRFUiGcyG4EJHzTEBABxVL97Ln/mxos
        bm70hud4iwfavFV/9
X-Received: by 2002:a17:903:40cb:b0:188:7dca:6f4a with SMTP id t11-20020a17090340cb00b001887dca6f4amr1992200pld.60.1668933482021;
        Sun, 20 Nov 2022 00:38:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Nd4nQxSB7+apOwSZYQOnx1kGg0VOQPy3ysl72rEjv+17g6Zdt6KNUYaCfhFWCAeR0I11B/g==
X-Received: by 2002:a17:903:40cb:b0:188:7dca:6f4a with SMTP id t11-20020a17090340cb00b001887dca6f4amr1992187pld.60.1668933481605;
        Sun, 20 Nov 2022 00:38:01 -0800 (PST)
Received: from localhost ([240d:1a:c0d:9f00:94be:c13b:981e:47e6])
        by smtp.gmail.com with ESMTPSA id b13-20020a170903228d00b00174d9bbeda4sm7045010plh.197.2022.11.20.00.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 00:38:01 -0800 (PST)
Date:   Sun, 20 Nov 2022 17:37:49 +0900 (JST)
Message-Id: <20221120.173749.1469001343691116558.syoshida@redhat.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] net: tun: Fix use-after-free in tun_detach()
From:   Shigeru Yoshida <syoshida@redhat.com>
In-Reply-To: <CANn89iJaCRMb-vSrBOV_zbjxq8Gpg7K3d031AECmEqSN-XWpkA@mail.gmail.com>
References: <20221119075615.723290-1-syoshida@redhat.com>
        <CANn89iJaCRMb-vSrBOV_zbjxq8Gpg7K3d031AECmEqSN-XWpkA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 28.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Sat, 19 Nov 2022 10:31:38 -0800, Eric Dumazet wrote:
> On Fri, Nov 18, 2022 at 11:56 PM Shigeru Yoshida <syoshida@redhat.com> wrote:
>>
>> syzbot reported use-after-free in tun_detach() [1].  This causes call
>> trace like below:
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in notifier_call_chain+0x1da/0x1e0
>> ...
>> Call Trace:
> 
> Please include a symbolic stack trace, I think syzbot has them.

Thank you so much for your comment.  I got it.

>>  <TASK>
>>  dump_stack_lvl+0x100/0x178
>>  print_report+0x167/0x470
>>  ? __virt_addr_valid+0x5e/0x2d0
>>  ? __phys_addr+0xc6/0x140
>>  ? notifier_call_chain+0x1da/0x1e0
>>  ? notifier_call_chain+0x1da/0x1e0
>>  kasan_report+0xbf/0x1e0
>>  ? notifier_call_chain+0x1da/0x1e0
>>  notifier_call_chain+0x1da/0x1e0
>>  call_netdevice_notifiers_info+0x83/0x130
>>  netdev_run_todo+0xc33/0x11b0
>>  ? generic_xdp_install+0x490/0x490
>>  ? __tun_detach+0x1500/0x1500
>>  tun_chr_close+0xe2/0x190
>>  __fput+0x26a/0xa40
>>  task_work_run+0x14d/0x240
>>  ? task_work_cancel+0x30/0x30
>>  do_exit+0xb31/0x2a40
>>  ? reacquire_held_locks+0x4a0/0x4a0
>>  ? do_raw_spin_lock+0x12e/0x2b0
>>  ? mm_update_next_owner+0x7c0/0x7c0
>>  ? rwlock_bug.part.0+0x90/0x90
>>  ? lockdep_hardirqs_on_prepare+0x17f/0x410
>>  do_group_exit+0xd4/0x2a0
>>  __x64_sys_exit_group+0x3e/0x50
>>  do_syscall_64+0x38/0xb0
>>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> The cause of the issue is that sock_put() from __tun_detach() drops
>> last reference count for struct net, and then notifier_call_chain()
>> from netdev_state_change() accesses that struct net.
>>
>> This patch fixes the issue by calling sock_put() from tun_detach()
>> after all necessary accesses for the struct net has done.
>>
>> Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
>> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> 
> Please add a Fixes: tag, once you identified which commit added this bug.

I got it too.  I'll send v2 patch.

Thanks,
Shigeru

>> ---
>>  drivers/net/tun.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 7a3ab3427369..ce9fcf4c8ef4 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>>                 if (tun)
>>                         xdp_rxq_info_unreg(&tfile->xdp_rxq);
>>                 ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
>> -               sock_put(&tfile->sk);
>>         }
>>  }
>>
>> @@ -702,6 +701,11 @@ static void tun_detach(struct tun_file *tfile, bool clean)
>>         if (dev)
>>                 netdev_state_change(dev);
>>         rtnl_unlock();
>> +
>> +       if (clean) {
>> +               synchronize_rcu();
>> +               sock_put(&tfile->sk);
>> +       }
>>  }
>>
>>  static void tun_detach_all(struct net_device *dev)
>> --
>> 2.38.1
>>
> 

