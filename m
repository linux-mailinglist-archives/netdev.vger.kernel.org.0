Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C976B521B66
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244962AbiEJOOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 10:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343971AbiEJOLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 10:11:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B35AAE04
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:45:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x18so16787919plg.6
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjc6PfFrSQortCgG9GxXghDMK5FYTEjIw0LOemqQcCU=;
        b=FSqyTGvtT5BzaNJ0cEzaJ9nEZlF4IdkKy5VKAbKJ7VJxxTVXT6tG7p6K0fQnQFpmoU
         C0zLLsgjLRB07p6+YP0ZCw8uwxBwd2eo6BN1SfxV29oU8IgszqFJTYo4R7mukOzq+5lq
         7CyMeWgdT0zjj/37BxHKcjat/NjLVN7k7oIPNCnq6357NX5HQ7/w+pZYSHYQSTLmmJjv
         qJWt9bG3Nzl67Stmy5FJ3N7nJJp9/4B4ueV6KrJl5DFAhAKqsHdbtyEUq1krFFxuHsoW
         j3WjAA1RKYIv2jDr8FsS6o1UT5Cj0NU9YQTZHZ0PGqhAQwcdBrbGCkpvvVXPfSsJ7FjT
         VBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjc6PfFrSQortCgG9GxXghDMK5FYTEjIw0LOemqQcCU=;
        b=GD7fBWznMSBVzcXCo7qZuora8qpQIFKTRu6GpqUEu8fNMU6SNmbz549O+Oam8igiWR
         xT9GvHjKFGjtrZST8PA2brA+uKQwiDywMgA1/qJ6WNWazNb6hqa6tdcB2ET+dV3BBW0q
         a3F4UIKLY+rIHQACuSVLF7tBBKyrKA0jo9EPynU29Qt/KGvqDMc2SYBurcbK1VOoEp57
         l5vypSoyoLAbclcw35J8sadoVs4aBWPUiJmP0umNXyNZ9PL4DnmhmZoVY5MAub3ABUr3
         wzoxQ+gsrnwChqc1x05c6njNyR7jg8IsATshX1OBgXZAYHumEIDGAAD/YR3hkjNJp1GF
         rv+g==
X-Gm-Message-State: AOAM530k2iQftwtxHYSQIdKvPgZ+STjRDjaQsmouAQJEwqy5At89aBzn
        +goV4sjJKeyPVvXqgba83SXPhg==
X-Google-Smtp-Source: ABdhPJzbTkXxf13uKqE3E/u2nciMx07tOwqoGcEiwvBA1d3qlqf8g9bNdOQxD/pzZ6vQ2S0YM16GhA==
X-Received: by 2002:a17:902:8605:b0:15d:10dc:1c6f with SMTP id f5-20020a170902860500b0015d10dc1c6fmr21105344plo.4.1652190326941;
        Tue, 10 May 2022 06:45:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o10-20020a170903300a00b0015e9d4a5d27sm2013473pla.23.2022.05.10.06.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 06:45:26 -0700 (PDT)
Date:   Tue, 10 May 2022 13:45:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+0c6da80218456f1edc36@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mlevitsk@redhat.com, netdev@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vinicius.gomes@intel.com, viro@zeniv.linux.org.uk,
        xiyou.wangcong@gmail.com
Subject: Re: [syzbot] INFO: task hung in synchronize_rcu (3)
Message-ID: <Ynpsc7dRs8tZugpl@google.com>
References: <000000000000402c5305ab0bd2a2@google.com>
 <0000000000004f3c0d05dea46dac@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000004f3c0d05dea46dac@google.com>
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 2d08935682ac5f6bfb70f7e6844ec27d4a245fa4
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Fri Apr 15 00:43:41 2022 +0000
> 
>     KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16dc2e49f00000
> start commit:   ea4424be1688 Merge tag 'mtd/fixes-for-5.17-rc8' of git://g..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=442f8ac61e60a75e
> dashboard link: https://syzkaller.appspot.com/bug?extid=0c6da80218456f1edc36
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1685af9e700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b09df1700000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()
