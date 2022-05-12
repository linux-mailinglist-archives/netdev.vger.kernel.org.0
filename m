Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E70524E36
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354407AbiELN0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354357AbiELN0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:26:42 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE7C49F97
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:26:36 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-edeb6c3642so6616585fac.3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qXYGHJV7s/qc8a2bttGMmvI6F9hk+zqKIrq4cJ0DmU=;
        b=p5qo31Endpk0PNn9e3rHVmQRh3VEa3O+meW4Q3NJCquH/Bm4gLrkYGb1x+F+vr7niZ
         fYnIba2uOcs1Mp4BRPiMc/BzFDOPCpiPIoo/Pfvc/RzY1k+KZf15Fpa4ioTFzJa+cfME
         laxB9eNk8zRL8kYdh7hrekiB0RSi+H2isqG1wMpPiAQJgCFdlck0g2RU0kPdPu2HpDB0
         d1l/hnCcOzfh2I+JFwbCtPM683VJgw2Dnn8T7IegJqIzc4gPZ1QQnzajBbZwucJ940B1
         FIzaqIF+EDSX9LkV2zQwBPOM1sAVIA74Vm6E0cg4+5wCR5h/S3M4tqfXZea/Mu3xvluy
         clfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qXYGHJV7s/qc8a2bttGMmvI6F9hk+zqKIrq4cJ0DmU=;
        b=F6rgt9CAKIFmqNvkFrn/ulGU7SZTiUUjd8TgZxZP2dG9hoUj7bySlpHotE7Ll5DIzI
         Y+exbc5Qv2FCaqIKjHrrT2Eh+9dBLUEmUhn/lc68z9iSabj0djiH3qbK/K+fjT6x9Mvb
         jglOtkYnahNmf9duAlgg2s5LbQoYpkHLsZj4N5e2dRqA6ayW0wlPj9paNmUNvThSich9
         DgVzlh5DOAmDH5ntv3uwwI5CJMvk03OTYvUCA9d+pueiFjvhxdwgmbCHeo4sMT0IiNMp
         NKXzhZV8ZMtUmMTXCd89h7KHEMNCpa3HoLsZsx5I5r9DVYKsMCgrRAxTj4KC05izOq/U
         znYQ==
X-Gm-Message-State: AOAM531dVhA4HdzECzfkdA0Az2uIlgT8+JGVV5JpV6eXYHnaRtp9MTpq
        gNU+lGqSp2TZoBtIKngjU8aH8KbotknN4b5yacTaEA==
X-Google-Smtp-Source: ABdhPJxa1sYZ9ij0YDVXf2N9J+toT0J5aHixWE1j06eRnE3ey2ZaFodcwSgEd8WzFVTLnKccj4vh5912hBbCQAH4Efc=
X-Received: by 2002:a05:6870:d254:b0:db:12b5:da3 with SMTP id
 h20-20020a056870d25400b000db12b50da3mr5505714oac.211.1652361995905; Thu, 12
 May 2022 06:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001779fd05a46b001f@google.com> <0000000000006574b705dbe3533f@google.com>
In-Reply-To: <0000000000006574b705dbe3533f@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 12 May 2022 15:26:25 +0200
Message-ID: <CACT4Y+afw6PR=8iKbg8iT0y2+hef8fxDxA4u6aNQjG9Gjser9Q@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in linkwatch_event (2)
To:     syzbot <syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com>
Cc:     allison@lohutok.net, andrew@lunn.ch, aviad.krawczyk@huawei.com,
        axboe@kernel.dk, davem@davemloft.net, gregkh@linuxfoundation.org,
        hdanton@sina.com, io-uring@vger.kernel.org,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linyunsheng@huawei.com, luobin9@huawei.com, netdev@vger.kernel.org,
        pabeni@redhat.com, phind.uet@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, xiaoguang.wang@linux.alibaba.com
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

On Tue, 5 Apr 2022 at 09:38, syzbot
<syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 563fbefed46ae4c1f70cffb8eb54c02df480b2c2
> Author: Nguyen Dinh Phi <phind.uet@gmail.com>
> Date:   Wed Oct 27 17:37:22 2021 +0000
>
>     cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1048725f700000
> start commit:   dd86e7fa07a3 Merge tag 'pci-v5.11-fixes-2' of git://git.ke..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e83e68d0a6aba5f6
> dashboard link: https://syzkaller.appspot.com/bug?extid=96ff6cfc4551fcc29342
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11847bc4d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1267e5a0d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Looks possible:

#syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
