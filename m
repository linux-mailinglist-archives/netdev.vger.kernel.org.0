Return-Path: <netdev+bounces-5806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B624A712CE6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7110228198D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD9C28C3E;
	Fri, 26 May 2023 18:55:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE627700
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:55:38 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A21C13D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:55:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so10225e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685127335; x=1687719335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+I6E2+/xyMIRJ7E7KWkruQCNPnRbSv/rBisG3Yul5k=;
        b=yYOyRzK7dBWY/xYBt1IqltL1yOPWvqma4h1bT0wKEpbbpjU6SKOim34uyw52H2z8O0
         rpOR04jJ++TGmuP7zsqrh1sXsDyDGzTHZ/2pv2cFPMqLZg9GZr+B7WPZ5brt7Xo0FrTZ
         nl5dp1TycSUlyEIa580JLwnXrqdnCUytQ2YMQ5sGeISd26GeYZHIB43Pey8x7IDd361c
         Kv6eSjyRHZ9sorYqe98acErMOC4GLywCt0Q22atq/EFR13H35ZRjpOwr5T5LIafP5mXM
         P9LNRS5ZML98fAMi69pgT7ybA6CpMDmkI8xUwaOnUxbjMi0hCog2AhmmaUKQWQnWzcUt
         h1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685127335; x=1687719335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u+I6E2+/xyMIRJ7E7KWkruQCNPnRbSv/rBisG3Yul5k=;
        b=LY4Ddn5m+PA0H4h7xfaZyRvSQMU70BfP2eGt+R3F81b1bqFrpYEuAwA2fg5TOw5pSt
         uGBuODZfIsTnJfzzH+6IniY0Lt/AXKd6fYXzkZ0Djx1LdjUkfzL8vK7qto51dze1gOaw
         zSSs0ZM7dQFgLBFB1lXlBqxjtTPPYwb/3v9yiKijhWbOCfF4SrwjKYUG3T5fQ1shg7Dx
         vdLI4p/gs417Saak0h7YG8ctcdVS1yipIbftVN0DT9M+UdL9gb52Juo+mHfdR3XdMPjX
         7LVqX+YPXGD9PmzxGD472hWTxsBIX0/jbkNMpGI3vY89rxkV8Si8f9hLvSQXaILoBmHU
         +Xjw==
X-Gm-Message-State: AC+VfDxoGtIaCi8BxWFe+eRkRjvZuVhD/nimkfFbfeSvcY0xO+mDWhHd
	mYhtctBQqIyYaXUvb76sT51CjTzOFMSxMstaMXedrw==
X-Google-Smtp-Source: ACHHUZ7GUwkd34rsrfd/aOh7lgNNONDlY3q6vc6EKzNvFsXYDYeiPouIK6FV+BjUyw6+UANf0B25z5jMopZX9yqLwvU=
X-Received: by 2002:a05:600c:3b17:b0:3f1:73b8:b5fe with SMTP id
 m23-20020a05600c3b1700b003f173b8b5femr19605wms.3.1685127334583; Fri, 26 May
 2023 11:55:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
 <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
 <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
 <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
 <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
 <CANn89i+u8jvfSQAQ=_JY0be56deJNhKgDWbqpDAvfm-i34qX9A@mail.gmail.com>
 <CAHk-=wh16fVwO2yZ4Fx0kyRHsNDhGddzNxfQQz2+x08=CPvk_Q@mail.gmail.com>
 <CANn89iJ3=OiZEABRQQLL6z+J-Wy8AvTJz6NPLQDOtzREiiYb4Q@mail.gmail.com> <CAHk-=whZ23EHnBG4ox9QpHFDeiCSrA2H1wrYrfyg3KP=zK5Sog@mail.gmail.com>
In-Reply-To: <CAHk-=whZ23EHnBG4ox9QpHFDeiCSrA2H1wrYrfyg3KP=zK5Sog@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 20:55:22 +0200
Message-ID: <CANn89iJgRLPR_53vrd2zfYiU5ejcVWACtH6h_JPnvte6eSGOLg@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 8:33=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, May 26, 2023 at 10:51=E2=80=AFAM Eric Dumazet <edumazet@google.co=
m> wrote:
> >
> > Hmmm
> >
> > [   25.532236] RIP: 0010:0xffffffffa5a85134
> > [   25.536173] Code: Unable to access opcode bytes at 0xffffffffa5a8510=
a.
>
> This was the other reason I really didn't want to use alternatives on
> the conditional branch instructions. The relocations are really not
> very natural, and we have odd rules for those things. So I suspect our
> instruction rewriting simply gets this wrong, because that's such a
> nasty pattern.
>
> I really wanted my "just hardcode the instruction bytes" to work. Not
> only did it get me the small 2-byte conditional jump, it meant that
> there was no relocation on it. But objtool really hates not
> understanding what the alternatives code does.
>
> Which is fair enough, but it's frustrating here when it only results
> in more problems.
>
> Anyway, I guess *this* avoids all issues. It creates an extra jump to
> a jump for the case where the CPU doesn't have ERMS, but I guess we
> don't really care about those CPUs anyway.
>
> And it avoids all the "alternative instructions have relocations"
> issues. And it creates all small two-byte jumps, and the "rep movsb"
> fits exactly on that same 2 bytes too. Which I guess all argues for
> this being what I should have started with.
>
> This time it *really* works.
>

Indeed, this one is working and fixes the issue for me, thanks a lot !

New numbers look similar to 6.3 ones.

Tested-by: Eric Dumazet <edumazet@google.com>

 Performance counter stats for 'taskset 02 ./tcp_mmap -H 2002:a05:6608:297:=
:':

          2,833.29 msec task-clock                       #    0.970
CPUs utilized
             1,065      context-switches                 #  375.888
/sec
                 1      cpu-migrations                   #    0.353
/sec
               128      page-faults                      #   45.177
/sec
    10,297,389,329      cycles                           #    3.634
GHz
     7,213,189,594      instructions                     #    0.70
insn per cycle
     1,220,821,121      branches                         #  430.884
M/sec
        10,430,907      branch-misses                    #    0.85% of
all branches

       2.921180547 seconds time elapsed

       0.005304000 seconds user
       2.478561000 seconds sys

