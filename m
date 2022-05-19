Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E952D14B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbiESLSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237319AbiESLSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:18:51 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6205FB0421
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:18:48 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f4so8475306lfu.12
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atyGWgYrO2SecYohFwMCiN3J3bKDbG49XwpQdrYfUIE=;
        b=q5wxTuQmIyRFcV2VwJRDDAK/A1pgJB2e6g4V+CpLQM0Y/HDj+x68ULl4LZvWPm6RB9
         c7ojXx8Tz94aJU6ogJliccvI2cmzqC3OEcjTHdZtJP0sNpp0S1G1BcTSxzgJv5nrLXpG
         WVs7IqQvorJhIIE1ex42eXckpdD0gQVXf2yOPpE1tsbDDwO9j55Tf8YYZ+Cw7M9z5Mdl
         LkuFFIdghz/jMb3oZHYe9nYZWnrC4ee2QxtOwERvRo1tWUQlziHgzpYp+PBu4VZcfymR
         nroggDCx3cf7zPekjpdGhEWopfh3lttqWlFk0OWsz6DkBu9G5NTbCK6dnBwwSdd2twsa
         0Y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atyGWgYrO2SecYohFwMCiN3J3bKDbG49XwpQdrYfUIE=;
        b=gb8m5O5fprrQefzh1F2Fqe5AIQIDe0JqlWeG9vh4aNwvllBbx5eWxtYAX+5szwjSv/
         fWyOeMt0KyqrYwi95rdDfmWgQ563mwRXKRkw988FtOrA7B5YJwPonWt56lPbXwoaB6Mu
         6NFOC803tJtQcrIAfFsfnnZkGeTbIXPCqTt/JLHltmoxeUqaNIwglHjla29u2Teh1dCd
         Uiz6CS09uLTnW+dpM/UVmeT8SAq5bn69ae29UJcrtzvsn5GqD0lh2VyK4xnRugqXYwzI
         O9AXT5EcGYYR9jmNMovJJ9K4Rx9Ybd8iWzsNdI9tTbnrbOMqhPqef7iL54wjb/oMkN5l
         j8Dg==
X-Gm-Message-State: AOAM5323WK8Qy1M4/QwRzoUANlyn53hhPX0P9Kg7d1WFM/poFmQ6R6SR
        8mUhSvvPuCmtxHujjKoEVJ2YhzxBTqU7Z2Z0rSTDjg==
X-Google-Smtp-Source: ABdhPJyr/7mZBn65Lxwhnxkm/V33ORzPdJ9mSXzb980IJhKah84Msdv4tK6Whuz1/2Vu1EW10x1fpWstq7BLWrZ56ts=
X-Received: by 2002:a05:6512:3b84:b0:473:a5e5:165a with SMTP id
 g4-20020a0565123b8400b00473a5e5165amr3010327lfv.417.1652959126436; Thu, 19
 May 2022 04:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c54420059e4f08ff@google.com> <0000000000009cd20305d3ad7e8d@google.com>
In-Reply-To: <0000000000009cd20305d3ad7e8d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 19 May 2022 13:18:35 +0200
Message-ID: <CACT4Y+baaFENUbUCYq7x6aGXucyhy86Fy8UeFDHWSxDpvbda6Q@mail.gmail.com>
Subject: Re: [syzbot] WARNING in dev_change_net_namespace
To:     syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        dsahern@kernel.org, ebiederm@xmission.com, edumazet@google.com,
        eric.dumazet@gmail.com, fw@strlen.de,
        harshit.m.mogalapalli@oracle.com, hawk@kernel.org,
        jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        saiprakash.ranjan@codeaurora.org, songliubraving@fb.com,
        suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com,
        tonymarislogistics@yandex.com, will@kernel.org,
        yajun.deng@linux.dev, yhs@fb.com
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

On Tue, 21 Dec 2021 at 21:03, syzbot
<syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit f123cffdd8fe8ea6c7fded4b88516a42798797d0
> Author: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Date:   Mon Nov 29 17:53:27 2021 +0000
>
>     net: netlink: af_netlink: Prevent empty skb by adding a check on len.
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=168acc95b00000
> start commit:   990f227371a4 Merge tag 's390-5.9-2' of git://git.kernel.or..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=21f0d1d2df6d5fc
> dashboard link: https://syzkaller.appspot.com/bug?extid=830c6dbfc71edc4f0b8f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101761e2900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: net: netlink: af_netlink: Prevent empty skb by adding a check on len.
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable, let's close the bug:

#syz fix:
net: netlink: af_netlink: Prevent empty skb by adding a check on len.
