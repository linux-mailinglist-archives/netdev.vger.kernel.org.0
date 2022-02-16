Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CCF4B7DB0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbiBPCnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:43:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbiBPCnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:43:52 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7988FBA49;
        Tue, 15 Feb 2022 18:43:40 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id d10so1308684eje.10;
        Tue, 15 Feb 2022 18:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDJssklYQD1n4k3ObsN0bw+9i+I4dsggbJJR//VLJ20=;
        b=Zl1xm3D354LVEdk6A1RDC5V8EuHE+coeR6zi4f0ARUyC12YBR5vOArEE//4Cxtn5dO
         qvndiWQPdZjG/DshCt1bSFTLc3Uaw/nW6gR5jGrwlVvJ4nt74WaIuvevEnojDkK43bZu
         fnq2ND1g5TP0M5VqS0orFL5ClL2EHaeOu6aPBtOgTE8Oy7Rhrfj41XoFk6vyzX/TrWxS
         wsBGMaDKnQlYQm3SViOfnND/9w1pqDBt31O+4A40ijW1hj8rjwMVDkmzAtt11XC6cuZW
         NHEwGGp3PQefrt8IjH1Qhk6UFcphAIMTHBsbc1r8Vy1eYQK0FUA5NSfCl0h+hQZjtj1B
         gfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDJssklYQD1n4k3ObsN0bw+9i+I4dsggbJJR//VLJ20=;
        b=XWFemS6nOlz5cmPfIqG4iW4g+LOUPP2UcGeIyKLNUp9LiJT92cxk+QJbEANztztPKO
         7aQ2I9zZ0Ez0UdSos1qfbBofFlDROcbIz5z5YCHSBhza+RY2k180+lgiiRs37D+LiFAC
         UxpChbbCuolR/XSHg5bI/GwTxthPyDpwfn1IKcVzzLQYBJ+/G2JHdB8rd+M05XDdgy6T
         FbWW/exqe0uGwdMRyRAe1cPU4lHYBRMvhXuEUKmJAR0fn6I+gSt/ep8i78Hh4eefLe9g
         R0R/9J5vVYBXjfsMw8rr9gEVlmbrblvMLDb1iFEJNJgv+Wm0BZiHIHnazjH5hZyNCnxD
         yQbg==
X-Gm-Message-State: AOAM532ZJkUnuU4zfzZAPI7p+SPGl/+Y2NSWhdXj3g3eUzMjAIqVUnBQ
        yRAuDDOVWAcABCrqwS1OgV0sf38iBgqr3RQVSp0=
X-Google-Smtp-Source: ABdhPJxkhm7FKRBh+yyBJ1rNwZFW3Xhyw+ayQ2oppPG4d4kbp1nasELqUQ+uZz+N2pXbirXgW6PySSHKLyIXoVl2hko=
X-Received: by 2002:a17:906:4cd2:b0:6c8:7a90:9c7 with SMTP id
 q18-20020a1709064cd200b006c87a9009c7mr612436ejt.439.1644979419568; Tue, 15
 Feb 2022 18:43:39 -0800 (PST)
MIME-Version: 1.0
References: <20220215112812.2093852-1-imagedong@tencent.com>
 <20220215112812.2093852-2-imagedong@tencent.com> <CANn89iLWOBy=X1CpY+gvukhQ-bb7hDWd5y+m46K7o5XR0Pbt_A@mail.gmail.com>
 <f626571a-30de-5549-a73e-aaef874d3c36@kernel.org>
In-Reply-To: <f626571a-30de-5549-a73e-aaef874d3c36@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Feb 2022 10:38:28 +0800
Message-ID: <CADxym3ZS1Fva1CcYo3Lyj2wy2t-FRE51eZB-fESybwiBdKSWVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/19] net: tcp: introduce tcp_drop_reason()
To:     David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 2:47 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 2/15/22 10:34 AM, Eric Dumazet wrote:
> >> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> >> index af94a6d22a9d..e3811afd1756 100644
> >> --- a/net/ipv4/tcp_input.c
> >> +++ b/net/ipv4/tcp_input.c
> >> @@ -4684,10 +4684,19 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
> >>         return res;
> >>  }
> >>
> >> -static void tcp_drop(struct sock *sk, struct sk_buff *skb)
> >> +static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
> >> +                           enum skb_drop_reason reason)
> >>  {
> >>         sk_drops_add(sk, skb);
> >> -       __kfree_skb(skb);
> >> +       /* why __kfree_skb() used here before, other than kfree_skb()?
> >> +        * confusing......
> >
> > Do not add comments like that if you do not know the difference...
> >
> > __kfree_skb() is used by TCP stack because it owns skb in receive
> > queues, and avoids touching skb->users
> > because it must be one already.
>
> and it bypasses kfree_skb tracepoint which seems by design.

Do you mean it shouldn't be traced here?
According to my understanding, __kfree_skb() was used in the
beginning as skb->users aren't touched by TCP. Later,
tcp_drop() was introduced to record drop count to the socket.

Considering the skb is indeed dropped and no other event is triggered,
is it ok to trigger the kfree_skb tracepoint?

Thanks!
Menglong Dong
