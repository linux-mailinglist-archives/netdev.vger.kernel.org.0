Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE38B63875F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKYKWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiKYKWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:22:36 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E64FBC32
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:22:32 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-142b72a728fso4631419fac.9
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dFk4/TyXFVH4omq0MKPCZJW7VRN5MWFd1VLeZHQ4myQ=;
        b=O13X7eQnbmmZ5OZqc1v+Nq5wiHmRFlOakztg4v4kVKzbkp9A2YhxSxn700wHfwQgHj
         jtL4ZvMsa4P4eCx3kHERQVZdyN5zMzG56fIXBLxVYZQ4xAUnftJ8E2hMwey7QHEHYTBy
         wp9WzqOq0Gq/2vaXu/AjhjkkuOFzNZ1N/QzaxJ4OEbwT0srBV76yrEy8VyGdoNUgoBlZ
         UAj99FE9mas+xMxsdohu26gc/ZjZ2KrH/RfUmuZznSQM71QlIJCwRGw9Cc54yyF3L140
         9OyC6ojt8/4ZJ28HRhAXVPwy3kxFwYw3Sp6rS36NcIB8kLmQbASBByv40OmbsOI0KC6F
         AfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dFk4/TyXFVH4omq0MKPCZJW7VRN5MWFd1VLeZHQ4myQ=;
        b=X/J1z16C6Ptb8Lgth2LVYq+yImv/ABI1eACzoztVdlqErjTddOBH91CRDx20XqVg7P
         ZRXrqG3rQfqkEjKUIBiv7DxA0UaStBYxBvnXyCQrgnHU7WXrzQ/aTzUGxWOodWyrLlzm
         XsifTOj6CR+MPX5nqBp0WBxNF6G3GybBiw3RHVH0zwbxoeKPKFcLY0woba/Z+j4h39XK
         9biCybe76z7ZlomJ7aXxRZC2th3gZNXw3Z5f47Nxk/8eP+TxD8jezdm376ox49dGa9XG
         yUdd2xsYau6UQZMzlnGsm7MlABfU8mnijsxXYXxPANjM3VGzxX8g0QuB5pMr+wnbi2Qm
         NDCA==
X-Gm-Message-State: ANoB5pkCoDdaz/Khewp5MgfXh0sDNFRhzYCYsbhc08g04iQT+Pw+4joz
        LYDW1bxvEICa0bXfdVdPu9nC0kHnk4/uwF42FF6Tyg==
X-Google-Smtp-Source: AA0mqf4iZUnbBKSrM1flPegAiAXqzZPEmIYY3e6KEyG/6IvzCjm2R7eG2INLEOUcWbubEOlM2BPZ3p+zihoAbed/kJI=
X-Received: by 2002:a05:6870:b689:b0:13c:7d1c:5108 with SMTP id
 cy9-20020a056870b68900b0013c7d1c5108mr11030408oab.282.1669371751235; Fri, 25
 Nov 2022 02:22:31 -0800 (PST)
MIME-Version: 1.0
References: <000000000000706e6f05edfb4ce0@google.com> <Y3uULqIZ31at0aIX@hog>
 <20221121171513.GB704954@gauss3.secunet.de> <Y3vwpcJcUgqn22Fw@hog> <20221122062657.GE704954@gauss3.secunet.de>
In-Reply-To: <20221122062657.GE704954@gauss3.secunet.de>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 25 Nov 2022 11:22:20 +0100
Message-ID: <CACT4Y+b4xCFFjNKQ51q_JsvbkVNFpG3YBnK4iarcD+u0-Nsobg@mail.gmail.com>
Subject: Re: [syzbot] linux-next test error: general protection fault in xfrm_policy_lookup_bytype
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        syzbot <syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022 at 07:27, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Mon, Nov 21, 2022 at 10:41:57PM +0100, Sabrina Dubroca wrote:
> > 2022-11-21, 18:15:13 +0100, Steffen Klassert wrote:
> > > On Mon, Nov 21, 2022 at 04:07:26PM +0100, Sabrina Dubroca wrote:
> > > > 2022-11-21, 05:47:38 -0800, syzbot wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    e4cd8d3ff7f9 Add linux-next specific files for 20221121
> > > > > git tree:       linux-next
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1472370d880000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=a0ebedc6917bacc1
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=bfb2bee01b9c01fff864
> > > > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > > >
> > > > > Downloadable assets:
> > > > > disk image: https://storage.googleapis.com/syzbot-assets/b59eb967701d/disk-e4cd8d3f.raw.xz
> > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/37a7b43e6e84/vmlinux-e4cd8d3f.xz
> > > > > kernel image: https://storage.googleapis.com/syzbot-assets/ebfb0438e6a2/bzImage-e4cd8d3f.xz
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > Reported-by: syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com
> > > > >
> > > > > general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
> > > > > KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
> > > > > CPU: 0 PID: 5295 Comm: kworker/0:3 Not tainted 6.1.0-rc5-next-20221121-syzkaller #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > > > > Workqueue: ipv6_addrconf addrconf_dad_work
> > > > > RIP: 0010:xfrm_policy_lookup_bytype.cold+0x1c/0x54 net/xfrm/xfrm_policy.c:2139
> > > >
> > > > That's the printk at the end of the function, when
> > > > xfrm_policy_lookup_bytype returns NULL. It seems to have snuck into
> > > > commit c39f95aaf6d1 ("xfrm: Fix oops in __xfrm_state_delete()"), we
> > > > can just remove it:
> > > >
> > > > diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> > > > index 3a203c59a11b..e392d8d05e0c 100644
> > > > --- a/net/xfrm/xfrm_policy.c
> > > > +++ b/net/xfrm/xfrm_policy.c
> > > > @@ -2135,9 +2135,6 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
> > > >  fail:
> > > >   rcu_read_unlock();
> > > >
> > > > - if (!IS_ERR(ret))
> > > > -         printk("xfrm_policy_lookup_bytype: policy if_id %d, wanted if_id  %d\n", ret->if_id, if_id);
> > > > -
> > > >   return ret;
> > >
> > > Hm, this was not in the original patch. Maybe my tree was not
> > > clean when I applied it. Do you want to send a patch, or should
> > > I just remove it?
> >
> > Go ahead, I guess it's more convenient for you.
>
> I just did a forced push to remove that hunk.

Let's tell syzbot about the fix, so that it reports similarly looking
crashes in future:

#syz fix: xfrm: Fix oops in __xfrm_state_delete()
