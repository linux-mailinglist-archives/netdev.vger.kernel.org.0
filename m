Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372C63C132
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 04:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390260AbfFKCTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 22:19:32 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:46776 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbfFKCTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 22:19:32 -0400
Received: by mail-lj1-f175.google.com with SMTP id v24so5552947ljg.13
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 19:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R0dmOVUTOICVuPwMd/Xk3EQwNDwUM0NAxPkwX9e5V6Y=;
        b=dlR1shXGAALE5XVB7FMCZoqFpqvOkKJ9NU1UbFb/TGFyCyDmakAmSbxp32x36durOp
         A0fSz6Gb4e9ZBpIh6x/qmR6TVC9ygT1aBOodmLxAuGHd3zF+wyFYmUCBMjSZENtPs+cL
         x30yXPnw0alznTGqid8V/ilp97GfnhnjlnXyxrptsEisGurxMspTEghenhibMDX+WQiu
         p+5mvfG39rvpDTXfv+k3OqtJ88nHFSrIwuSq2wPoyyNkesSGiu3gWPXPvgLuvy/bb0rl
         QeD/3we07fWc/uWGa66PjM5eje/XTqv0SkO//xTgGknlw1bZ1Dlkcejb/vI1KWGCmNLz
         9c8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R0dmOVUTOICVuPwMd/Xk3EQwNDwUM0NAxPkwX9e5V6Y=;
        b=EH2aGT67zlW/nKMEnp+AhY9pNM782vXzb5GfJRqirC0bZTDf6Iq4rvIsDblP/VEiW6
         6a09xiSh+Xm0m+MIEW7tE3nL98EA4Rb9sfeZ5jWO9gok/1P0ZgyQYBZVny/0UQ4l7UvC
         PCW1eysyw0q3AeB4XmO+/Rmihzs9b2vzYiBum71c9FpwygxH6gvMUzeJZJH0gqv+n20g
         IN0zH7c4WWqVFiQ1LOP+VsMn10xgtHdkikJlUn7Ue1y8k3kNEFdJap1Ea8Dv9e1+h0cc
         FCzkFRIuCY9HsfMKOszgsFdxOaCEhsZhHvMN2SgjlMbrNYTroKwZdFEUV2kNgTCj5k3q
         kaEw==
X-Gm-Message-State: APjAAAWyZ/M1PiLv43tS8wskkDbzwL0kTQBXIKU0qGpaWQGUFBfimlt6
        ZhzeJUqMFGGMAVnKluNhB+LMlTHyD7hW+R5kpArdQ5uYrRvd2w==
X-Google-Smtp-Source: APXvYqzrEk6Z9T43ZQDNMHWim9MM/h5rOuYVqoMxHRphaLnAeRKYZ2Y+D9HcCuQwZGA11z8mvxpUyXCKtOfp8kQyZWI=
X-Received: by 2002:a05:651c:92:: with SMTP id 18mr11186681ljq.35.1560219569439;
 Mon, 10 Jun 2019 19:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
 <CADVnQymPcJJ-TnsNkZm-r+PrhxHjPLLLiDhf3GjeBjSTGJwbkw@mail.gmail.com> <CAHx7fy5bSghKONyYSW-4oXbEKLHUxYC7vE=ZiKLXUED-iuuCdw@mail.gmail.com>
In-Reply-To: <CAHx7fy5bSghKONyYSW-4oXbEKLHUxYC7vE=ZiKLXUED-iuuCdw@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 10 Jun 2019 22:19:12 -0400
Message-ID: <CADVnQy=P=P1iPxrgqQ1U5xwY7Wj3H54XF1sfTyi92mQkLgjb6g@mail.gmail.com>
Subject: Re: tp->copied_seq used before assignment in tcp_check_urg
To:     Zhongjie Wang <zwang048@ucr.edu>
Cc:     Netdev <netdev@vger.kernel.org>, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 7:48 PM Zhongjie Wang <zwang048@ucr.edu> wrote:
>
> Hi Neal,
>
> Thanks for your reply. Sorry, I made a mistake in my previous email.
> After I double checked the source code, I think it should be tp->urg_seq,
> which is used before assignment, instead of tp->copied_seq.
> Still in the same if-statement:
>
> 5189     if (tp->urg_seq == tp->copied_seq && tp->urg_data &&
> 5190         !sock_flag(sk, SOCK_URGINLINE) && tp->copied_seq != tp->rcv_nxt) {
> 5191         struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
> 5192         tp->copied_seq++;
> 5193         if (skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq)) {
> 5194             __skb_unlink(skb, &sk->sk_receive_queue);
> 5195             __kfree_skb(skb);   // wzj(a)
> 5196         }
> 5197     }
> 5198
> 5199     tp->urg_data = TCP_URG_NOTYET;
> 5200     tp->urg_seq = ptr;
>
> It compares tp->copied_seq with tp->urg_seq.
> And I found only 1 assignment of tp->urg_seq in the code base,
> which is after the if-statement in the same tcp_check_urg() function.
>
> So it seems tp->urg_seq is not assigned to any sequence number before
> its first use.
> Is that correct?

I agree, it does seem that tp->urg_seq is not assigned to any sequence
number before its first use.

AFAICT from a quick read of the code, this does not matter. It seems
the idea is for tp->urg_data and tp->urg_seq to be set and used
together, so that tp->urg_seq is never relied upon to be set to
something meaningful unless tp->urg_data has also been verified to be
set to something (something non-zero).

I suppose it might be more clear to structure the code to check urg_data first:

  if (tp->urg_data && tp->urg_seq == tp->copied_seq &&

...but in practice AFAICT it does not make a difference, since no
matter which order the expressions use, both conditions must be true
for the code to have any side effects.

> P.S. In our symbolic execution tool, we found an execution path that
> requires the client initial sequence number (ISN) to be 0xFF FF FF FF.
> And when it traverse that path, the tp->copied_seq is equal to (client
> ISN + 1), and compared with 0 in this if-statatement.
> Therefore the client ISN has to be exactly 0xFF FF FF FF to hit this
> execution path.
>
> To trigger this, we first sent a SYN packet, and then an ACK packet
> with urgent pointer.

Does your test show any invalid behavior by the TCP endpoint? For
example, does the state in tcp_sock become incorrect, or is some
system call return value or outgoing packet incorrect? AFAICT from the
scenario you describe it seems that the "if" condition would fail when
the receiver processes the ACK packet with urgent pointer, because
tp->urg_data was not yet set at this point. Thus it would seem that in
this case it does not matter that tp->urg_seq is not assigned to any
sequence number before being first used.

cheers,
neal
