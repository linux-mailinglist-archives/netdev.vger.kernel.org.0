Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2FB63FF64
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiLBELw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiLBELu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:11:50 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4050D11D9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 20:11:48 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id z192so4702747yba.0
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 20:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qsLZ9QinNJ5AzcCVDj65lKVRt2q6QVkrs/mM5EuxNrg=;
        b=TnZDrkbdoVV/k8MLXd4HqS3nDGVgQlltXR3BGEz/poNjNWBa7YcHHQG2DsJ2FEaGOO
         rsJI7FGEoVg+9pyS1CRAuWNg0SVEiflBRLRhZypltUyyBKZT+JjUC+g2KsxkX5zC+OzU
         P/01s67yI9VM2/u8+J/GA6i6iiHhmqgfYNW8/9yj60cJVNe83Q4waOmUVJSP6TwG/K4b
         Ns2IwPcivfVqu008GC1i1WkRqF/XFoqoXhAv+bRvOkRDMBLlVBDoISuCcoaOlPIXRY/9
         R1Au42ujcBhV+hGd99Rwk+fd0gcCAl7pGBI8E4WqcrtjIU3VRN5exTviQxkOwNjEu9bb
         ruDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qsLZ9QinNJ5AzcCVDj65lKVRt2q6QVkrs/mM5EuxNrg=;
        b=UIE1FOf15+ECArvnnDSweK3dM2tteb33Q/0NJzeFBDWYCuOv2xg659XW3iCyB8qKzP
         48OOtYMSSh8WD+l8w3mwwAoFleLyonL/hIQyfzuzMNrty9A3hHuRr0we3CJIz/HEwTJF
         SaIE7CTWXBoZ7IGfQcdNXBwY7HkaZczJBSfIWSjFneKl4W/8IDOADAN266j+78wX3ZP2
         HAVOj40Gb9Dm/Laysh8SXuME0NBKC+yyTQJw2ZWV2c4TWWM48TpAnZOMVK3VJTxQChZ9
         gGM00I5/HYeOk64FxKYI/JXBdaWNDHpHucrjatOaQ1fCcawV94kBZIkT/TiATcqSUywA
         DZPw==
X-Gm-Message-State: ANoB5pnYUSvfPk3ZmWYvwkJiBV7AhuVCUxkcxEpi2GoB0JB7TjZGjHqz
        wmBHLnlCornAl7Oz71n6FK+py4+qKlhrsep3bCiyuEE+2svnWWY5
X-Google-Smtp-Source: AA0mqf4Pu+uoaoe/rykm9fS3616W670EnDT64BWobgwiXPf8xRmmv3lgh154rHDL/QPe40vpvKBzRZ57j6TsEeF23zo=
X-Received: by 2002:a25:2546:0:b0:6f0:b332:f35e with SMTP id
 l67-20020a252546000000b006f0b332f35emr40284066ybl.55.1669954307781; Thu, 01
 Dec 2022 20:11:47 -0800 (PST)
MIME-Version: 1.0
References: <1669817512-4560-1-git-send-email-george.kennedy@oracle.com>
 <CALs4sv2ZfT1SAYY0oOYhrBBCjsG_th5g=QtSsbKJnPbW8faQ+w@mail.gmail.com>
 <CANn89iL9obgd==tdp9DgdxXk78UvzF6D4J1OeihB1kx9_U4oZw@mail.gmail.com> <99adf483-ae89-8010-4689-fd50a77ff023@oracle.com>
In-Reply-To: <99adf483-ae89-8010-4689-fd50a77ff023@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Dec 2022 05:11:36 +0100
Message-ID: <CANn89iL18gPus7YWMMX_UFg9PSxAv0SkWTjLYCPhncOCEKrWuQ@mail.gmail.com>
Subject: Re: [PATCH] net: check for dev pointer being NULL in
 dev_hard_header() to avoid GPF
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        harshit.m.mogalapalli@oracle.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 1, 2022 at 9:44 PM George Kennedy <george.kennedy@oracle.com> wrote:
>
>
>
> On 12/1/2022 2:25 PM, Eric Dumazet wrote:
> > On Thu, Dec 1, 2022 at 2:16 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
> >> On Wed, Nov 30, 2022 at 7:43 PM George Kennedy
> >> <george.kennedy@oracle.com> wrote:
> >>> The dev pointer can be NULL in dev_hard_header(). Add check for dev being
> >>> NULL in dev_hard_header() to avoid GPF.
> >>>
> >>> general protection fault, probably for non-canonical address
> >>>      0xdffffc0000000046: 0000 [#1] PREEMPT SMP KASAN NOPTI
> >>> KASAN: null-ptr-deref in range [0x0000000000000230-0x0000000000000237]
> >>> CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.1.0-rc7+ #2
> >>> Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+20659+3dcf7c70
> >>> Workqueue: mld mld_ifc_work
> >>> RIP: 0010:macvlan_hard_header (./include/linux/netdevice.h:3057
> >>>      (discriminator 4) drivers/net/macvlan.c:594 (discriminator 4))
> >>> RSP: 0018:ffff888103d377d0 EFLAGS: 00010212
> >>> RAX: dffffc0000000000 RBX: ffff88801cf1a000 RCX: 0000000000000000
> >>> RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000230
> >>> RBP: ffff88801e8ef328 R08: 0000000000000000 R09: 0000000000000060
> >>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88801f0497c0
> >>> R13: 0000000000000000 R14: ffff888045187c98 R15: 0000000000000060
> >>> FS:  0000000000000000(0000) GS:ffff888106c80000(0000)
> >>>      knlGS:0000000000000000
> >>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> CR2: 00007fbf3f1c1840 CR3: 0000000014e36000 CR4: 00000000000006e0
> >>> Call Trace:
> >>>   <TASK>
> >>> neigh_connected_output (./include/linux/netdevice.h:3060
> >>>      net/core/neighbour.c:1595)
> >>> ip6_finish_output2 (./include/net/neighbour.h:546
> >>>      net/ipv6/ip6_output.c:134)
> >>> ip6_finish_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206)
> >>> ip6_output (./include/linux/netfilter.h:291 net/ipv6/ip6_output.c:227)
> >>> NF_HOOK.constprop.0 (./include/net/dst.h:445
> >>>      ./include/linux/netfilter.h:302)
> >>> mld_sendpack (net/ipv6/mcast.c:1824)
> >>> mld_send_cr (net/ipv6/mcast.c:2122)
> >>> mld_ifc_work (net/ipv6/mcast.c:2655)
> >>> process_one_work (kernel/workqueue.c:2294)
> >>> worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
> >>> kthread (kernel/kthread.c:376)
> >>> ret_from_fork (arch/x86/entry/entry_64.S:312)
> >>>   </TASK>
> >>> Modules linked in:
> >>> Dumping ftrace buffer:
> >>>     (ftrace buffer empty)
> >>> ---[ end trace 0000000000000000 ]---
> >>>
> >>> Fixes: 0c4e85813d0a ("[NET]: Wrap netdevice hardware header creation.")
> >>> Reported-by: syzkaller <syzkaller@googlegroups.com>
> >>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> >>> ---
> >>>   include/linux/netdevice.h | 2 +-
> >>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >>> index eddf8ee270e7..9b25a6301fa5 100644
> >>> --- a/include/linux/netdevice.h
> >>> +++ b/include/linux/netdevice.h
> >>> @@ -3054,7 +3054,7 @@ static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
> >>>                                    const void *daddr, const void *saddr,
> >>>                                    unsigned int len)
> >>>   {
> >>> -       if (!dev->header_ops || !dev->header_ops->create)
> >>> +       if (!dev || !dev->header_ops || !dev->header_ops->create)
> > Do  you have a repro ?
> See syzkaller repros attached.
>
> > This patch will not prevent a crash later I think.
>
> The repro ran overnight without failure with the patch applied.

Yes, but the patch is hiding a potential bug that might show up with
other 'repros'



>
> >
> > Please fix the root cause, thanks !
>
> Will try.

Thanks, having a repro definitely should help to find the real bug.

I took a look at macvlan , and could not see how vlan->lowerdev  could
be NULL in the first place.

>
> Thanks,
> George
> >
> >>>                  return 0;
> >> net_device being NULL during eth header construction? seems like a
> >> more serious issue?
> >> If it indeed is a genuine scenario I think a better description is needed...
> >>
> >>>          return dev->header_ops->create(skb, dev, type, daddr, saddr, len);
> >>> --
> >>> 2.31.1
> >>>
