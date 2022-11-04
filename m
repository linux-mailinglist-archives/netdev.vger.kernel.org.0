Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C14861A554
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 00:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiKDXFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 19:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiKDXFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 19:05:54 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E799D7F;
        Fri,  4 Nov 2022 16:05:52 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z18so9682403edb.9;
        Fri, 04 Nov 2022 16:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mN54KKsHo4XMlW8Cy/FqV30oFk3ZH7yAvbdzcrknG6k=;
        b=Cxio1z00cNocZA0FXAlMAsPTI1uAi3T+jqU04XLyknb5PWFf7isppClOng7V0he2Nt
         rMy99yUPVF7wnDrSKAOj5nxU9Dp96Q7KXPk66SwhLBHLjfbIY3CswpJlV1HiN1Lbd1CT
         +5r9vvndMMxWv6jCjNLoOnO64sl0UFY8GjoODqgvWl+jy+pZ9WwytsrheIQTf58XZxHw
         g52lDNIFQ6lIjBfwFO9oxPZAuXAZ03Mt7Q33d9v3zCy25//Pfj70ad8BvuSqDbGLsjc+
         DaIBHpVwZ46Ka+T4VLAonROWrXyrEyw1Of4VH4JbK81ndk3WVs7HrsPa35O5M//D0owf
         SY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mN54KKsHo4XMlW8Cy/FqV30oFk3ZH7yAvbdzcrknG6k=;
        b=Gyh+N5azYi0G1B5LD0WEt3zChItZhTkP5ka8TOMHn1lOge36ZKnbX3eHgyZpaf9myv
         JxVjCsjFkF/Wd/RivlKTMZerZ+ypO4v5IflJlz/OKVtgOiECDu6atNnzvI8//dxi9/IP
         qEhv27E97ImjjF44fNBOiiemR/hOB/V7pb1FjBxvlOj+zHnoQRgRphHqQF7KF4eOwbpq
         YxqaikuTFzb0Z4UGHhLm12zDv0glhuuVc21d1cXfGuLTmgFLPRNsvFqyP5rCzWJEyHjB
         ceWoJi4b/K+/3RQ4iWFSjXG9AvrakgXeNvF0YfNu/tFSqDit8qTLaj05CY1rsgS4Uup5
         gH7g==
X-Gm-Message-State: ACrzQf2UtUW7Y6K4lXm4+GBhIhHthzR8vOYNNxT+l3sEl3ouuHCMkVnB
        fzHvk0Y7LaJaxPwQxo8PGSHKj75/doK1tBqT5tE=
X-Google-Smtp-Source: AMsMyM68nNj3s9W/PHSKKGY1ohl7omYL5fipU5jIwRmq1czF41xnk5F9G0RWOOUiOqVV2J6yaXs4BaY1ZzG8u7VbXY0=
X-Received: by 2002:aa7:c504:0:b0:461:122b:882b with SMTP id
 o4-20020aa7c504000000b00461122b882bmr38809561edq.14.1667603150932; Fri, 04
 Nov 2022 16:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009da4c705dcb87735@google.com> <0000000000002227cf05ecace68c@google.com>
In-Reply-To: <0000000000002227cf05ecace68c@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Nov 2022 16:05:39 -0700
Message-ID: <CAEf4BzY03FkV8DsN=rGp_V1aCZhWYE7dBy2CJCUYbr775VPhag@mail.gmail.com>
Subject: Re: [syzbot] WARNING in check_map_prog_compatibility
To:     syzbot <syzbot+e3f8d4df1e1981a97abb@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        martin.lau@linux.dev, memxor@gmail.com, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, sdf@google.com,
        song@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 4, 2022 at 3:50 PM syzbot
<syzbot+e3f8d4df1e1981a97abb@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 34dd3bad1a6f1dc7d18ee8dd53f1d31bffd2aee8
> Author: Alexei Starovoitov <ast@kernel.org>
> Date:   Fri Sep 2 21:10:47 2022 +0000
>
>     bpf: Relax the requirement to use preallocated hash maps in tracing progs.
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1599d319880000
> start commit:   200e340f2196 Merge tag 'pull-work.dcache' of git://git.ker..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1b664fba5e66c4bf
> dashboard link: https://syzkaller.appspot.com/bug?extid=e3f8d4df1e1981a97abb
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165415a7080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1716f705080000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: bpf: Relax the requirement to use preallocated hash maps in tracing progs.
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: bpf: Relax the requirement to use preallocated hash maps in
tracing progs.
