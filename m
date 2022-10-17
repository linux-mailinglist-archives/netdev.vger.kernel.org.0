Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD7601B3D
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 23:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiJQV0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 17:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJQV0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 17:26:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC8F7C1E7;
        Mon, 17 Oct 2022 14:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E18CB819D8;
        Mon, 17 Oct 2022 21:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61995C433D7;
        Mon, 17 Oct 2022 21:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666042003;
        bh=Jb3a7mjcOgsOP9FRukKfzN3dSsgM4aL7stno/Lo2Njs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e26ODJq01mHKxOQ6HxTBDvfLXVQMqyJC70gRGpNM7iLE5ojG7pVpElEyF04MJPNIE
         5a6BaCp5dpvgg2gBX3+uv5z3CYLqHDTN2iCJF3YEFO1phghtUDk9KEdBsjmWGdNJch
         ZgoOP9h4+3Ls/+GBTeFjrETiUOmKsBU9RqvSBObY2CldWZwLLtek91DFNci7ACJViP
         gtOr/+5lF6akaOf4hQ0sBzZf5BNgYH5TqmZpVm+I+BSlJ/2b7qnO+TqO+WMLuPy3n4
         pyywYbB1HWoh4ciILp5uvkeqw7pbeUWpqYmwhjrfqKdF1EU2M/VpeAI4pExaz2yotn
         gt+6bZlWgp5cA==
Date:   Mon, 17 Oct 2022 14:26:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        syzbot <syzbot+d0fd2bf0dd6da72496dd@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Andrew Jones <ajones@ventanamicro.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [syzbot] WARNING in c_start
Message-ID: <20221017142641.26fc370c@kernel.org>
In-Reply-To: <50e2ecf5-4b83-3ba1-70a2-796d988d4c0b@I-love.SAKURA.ne.jp>
References: <0000000000007647ec05eb05249c@google.com>
        <Y0nTd9HSnnt/KDap@zn.tnic>
        <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
        <Y0qfLyhSoTodAdxu@zn.tnic>
        <Y0sbwpRcipI564yp@yury-laptop>
        <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
        <Y0tafD7qI2x5xzTc@yury-laptop>
        <CAHk-=wihz-GXx66MmEyaADgS1fQE_LDcB9wrHAmkvXkd8nx9tA@mail.gmail.com>
        <50e2ecf5-4b83-3ba1-70a2-796d988d4c0b@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 11:54:01 +0900 Tetsuo Handa wrote:
> On 2022/10/17 2:52, Linus Torvalds wrote:
> > Anyway, since rc1 is fairly imminent, I will just revert it for now -
> > I don't want to have a pending revert wait until -rc2.  
> 
> Thank you, Linus.
> 
> Yury or Jakub, please send a revert request on commit 854701ba4c39 ("net: fix cpu_max_bits_warn()
> usage in netif_attrmask_next{,_and}"), for https://syzkaller.appspot.com/bug?extid=9abe5ecc348676215427
> says that boot is still failing.

Yup, we got that revert queued up. LMK if it's a show stopper 
otherwise it'll get to Linus on Thu.
