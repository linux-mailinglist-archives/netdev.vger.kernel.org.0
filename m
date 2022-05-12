Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFD524E13
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354282AbiELNTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354278AbiELNTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:19:51 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7949252DC0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:19:46 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so6552320fac.9
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rnW1lNdXaHOrseNx+8VZQkCoh4hVp7eYD17JDIqBNtY=;
        b=oi7x1SH011n4JulssPJJ4GDfjqKYhSYQ0T1tiXB9tvhOy5Mdy+Z2PCzNAsF/7iEFCB
         ukYsBCXrB1SmnFjtouzUbdnGqEvBkCgNZ6K2pDdf9JUPG+14CPagbSXalfyEgPFuJ4Bq
         mXBGFNv1v8gnl+euHb+kBd3WEpGNNxHVvhWTyHlBXlUdlUsadWCM/Y6QowcbTg+Ijk7U
         rJVnJVj8st0ixwA+ZgS20uf/eDSDjA/9RKZXa8/aFYaMNnd/cdcNMU+eXVXdez2BFjaO
         adWE499AXKAD9+6tdp+EsvjFRq0Gtr3Ctt7xvI4uC8zJ9UXKQYgVs00vMMHTwynaf55c
         RNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rnW1lNdXaHOrseNx+8VZQkCoh4hVp7eYD17JDIqBNtY=;
        b=NR/7KNrCsMpq8ZhUOdHgM0Rr8MRVtez++GmJ4idDqKt6jmVC9Pmx8eQFf7oaikWpry
         2hnmWx03bbflNDZ9zYOWhrBxHxfpASVo4m3j0CRmemtb9nRYOsmtOhtwVFS1qvL/ERvC
         bfx+08W6otvN4w6Lf+uUOntNp0QXfJMrG7n5HQFEfFa4a7SlRgP+2twIZALLnH4+0lcj
         Iiy5KJ9FLAGPI3rHmGsqOIP4mknGT7OwGM1pHN5V+Q4pmdKoPFoB/QBWgBsgxK/esJWB
         UuuGlrFk1fACwztL9MoulGAJ52X1tkTqPQZGdiXJ7/smDOpwIhWCzDv4M2YkiT3rhSCF
         wMtw==
X-Gm-Message-State: AOAM532nc0e0aN8Fih/dis5ugAutX8xlJZuxxfZgsNao4WBe9OAyBrfC
        j92YXFaYqTB0LvUNLbTc9U+DKfvE3Ve1xfYMGOU5dQ==
X-Google-Smtp-Source: ABdhPJzJ9UCZzyIr9uCRxfqtNYldmP9u2JwxV1+G+hxFwMYyTA5WI0Koxn2yjLH38Pjz4Dugu1UDn8pxJ9yV+0b+L+A=
X-Received: by 2002:a05:6870:b61e:b0:ec:a426:bab5 with SMTP id
 cm30-20020a056870b61e00b000eca426bab5mr5478149oab.163.1652361585876; Thu, 12
 May 2022 06:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000004c57c005b0fc4114@google.com> <000000000000b15b3505d7d9e8ca@google.com>
In-Reply-To: <000000000000b15b3505d7d9e8ca@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 12 May 2022 15:19:34 +0200
Message-ID: <CACT4Y+YOJU91CLaNhFosG7koHPpz8U38nurXyboXb_9gGw=Fgg@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in usb_get_descriptor
To:     syzbot <syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com>
Cc:     brouer@redhat.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, eman.mohamed@rofaidarealestate.com,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        hdanton@sina.com, ingrassia@epigenesys.com, johan@kernel.org,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mathias.nyman@linux.intel.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        skhan@linuxfoundation.org, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Feb 2022 at 23:43, syzbot
<syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814
> Author: Shuah Khan <skhan@linuxfoundation.org>
> Date:   Tue Mar 30 01:36:51 2021 +0000
>
>     usbip: synchronize event handler with sysfs code paths
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1616e872700000
> start commit:   4fa56ad0d12e Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=144ecdb0be3abc07
> dashboard link: https://syzkaller.appspot.com/bug?extid=31ae6d17d115e980fd14
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12548d11d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec77e9d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: usbip: synchronize event handler with sysfs code paths

Based on subsystem and commit subject looks legit:

#syz fix: usbip: synchronize event handler with sysfs code paths
