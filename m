Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CF4545035
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbiFIPJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiFIPJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:09:28 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1C0F45C9
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:09:26 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c144so15413682qkg.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADHjY3SHXEBPLJO0n3GQmEYpl9o6dZBV1HcMhBv5F2M=;
        b=VwTtBts/jwqYFulzibQ7sRUR0luC2hYOgAWmLVHQcXVIeosBREPHLZy0JsWm2rsmL1
         e3H/+EHj03au5dVX//9nBbbfhEiDOgs+hIEwsXwW8T31D3UaS6jth0z17179JkPURG4Q
         m0e7Wllc/KOKOQnd0AXHXhH5XucDNr5jKMYo51mtgdYa1UznGyETBgtjmpA0WS+fmYMw
         Xnc2H4ELDgcW/DZhjgDqgLjcHU5ViR7SnE0FjvrVDYW4+t6Gjs3SQcpRs/OrQ3Uz2HDt
         osfzmLYECOMHZOTTdlGRxFE5NLG2xoI3sK3fzmlypfAl1PKT/Hnb5ektkGqMA1pVFbhb
         zqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADHjY3SHXEBPLJO0n3GQmEYpl9o6dZBV1HcMhBv5F2M=;
        b=SDwtg9seuBuX0/POpPm/A65qkQ+SvBhveWXlWN+12E3HoGBOmhbal8UXwFWYiqRab1
         zGqsQDTF3Ets7bdKLCTcXaWE7nIi6BERD8ksMatktvHpA4FoPNkjZXDY/1AYYfFmIoln
         CbIUO1s7Gnfo5MBiMQSpJlbdEPKb+y/hZUtAuTQQHaufQmGSsIjf7NTRvy3Rlqh+6pM+
         1ymLkIYbCxWSr3Zf9fByI9tcOkIiXEQ2kSRG96CTiR72PJnq/THeHlRIZanP1quBUIKE
         9G0ZefPAE3iYUbzb/XefEuYq+NeELRMqzh+0z9i7vmP76qHhmBiNseEMAL3BXDKUeBEG
         YgmQ==
X-Gm-Message-State: AOAM533cj4K8n1f0vucqKQwuTlPID92aTii1Pvk8j74yhdEkUbugLELK
        xQs+bH2ldLQr2UGLSTnYCB4S9udnr75fnq+HrseKDQ==
X-Google-Smtp-Source: ABdhPJz1JBB8zrYUKaijheHHzSDCnBvjSmAwqSTFfWKmOsr4EYEulF9FTxIxTiwlIl/wU8Pl6PgbCo8vYZG6cGIS1Hk=
X-Received: by 2002:a05:620a:25cd:b0:699:c467:fab0 with SMTP id
 y13-20020a05620a25cd00b00699c467fab0mr26691025qko.395.1654787365421; Thu, 09
 Jun 2022 08:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-5-eric.dumazet@gmail.com> <CADVnQynuQjbi67or7E_6JRy3SDznyp+9dT-hGbnAuqOSVJ+PUA@mail.gmail.com>
 <CALvZod78+NA+x4Fd2rwytCyf4rBQd8aGbWa=-kQ=zFGGTjcp-w@mail.gmail.com>
In-Reply-To: <CALvZod78+NA+x4Fd2rwytCyf4rBQd8aGbWa=-kQ=zFGGTjcp-w@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 9 Jun 2022 11:09:09 -0400
Message-ID: <CADVnQynhMUCYMSO5BopDEuhaDPia7vEAtMnmT0aNwh0cfxNDnQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 11:07 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Thu, Jun 9, 2022 at 7:46 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > /
> >
> >
> > On Thu, Jun 9, 2022 at 2:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > We plan keeping sk->sk_forward_alloc as small as possible
> > > in future patches.
> > >
> > > This means we are going to call sk_memory_allocated_add()
> > > and sk_memory_allocated_sub() more often.
> > >
> > > Implement a per-cpu cache of +1/-1 MB, to reduce number
> > > of changes to sk->sk_prot->memory_allocated, which
> > > would otherwise be cause of false sharing.
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > ---
> > >  include/net/sock.h | 38 +++++++++++++++++++++++++++++---------
> > >  1 file changed, 29 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index 825f8cbf791f02d798f17dd4f7a2659cebb0e98a..59040fee74e7de8d63fbf719f46e172906c134bb 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -1397,22 +1397,48 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
> > >         return !!*sk->sk_prot->memory_pressure;
> > >  }
> > >
> > > +static inline long
> > > +proto_memory_allocated(const struct proto *prot)
> > > +{
> > > +       return max(0L, atomic_long_read(prot->memory_allocated));
> > > +}
> > > +
> > >  static inline long
> > >  sk_memory_allocated(const struct sock *sk)
> > >  {
> > > -       return atomic_long_read(sk->sk_prot->memory_allocated);
> > > +       return proto_memory_allocated(sk->sk_prot);
> > >  }
> > >
> > > +/* 1 MB per cpu, in page units */
> > > +#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> > > +
> > >  static inline long
> > >  sk_memory_allocated_add(struct sock *sk, int amt)
> > >  {
> > > -       return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
> > > +       int local_reserve;
> > > +
> > > +       preempt_disable();
> > > +       local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> > > +       if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
> > > +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> > > +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> > > +       }
> > > +       preempt_enable();
> > > +       return sk_memory_allocated(sk);
> > >  }
> > >
> > >  static inline void
> > >  sk_memory_allocated_sub(struct sock *sk, int amt)
> > >  {
> > > -       atomic_long_sub(amt, sk->sk_prot->memory_allocated);
> > > +       int local_reserve;
> > > +
> > > +       preempt_disable();
> > > +       local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> > > +       if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
> > > +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> > > +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> >
> > I would have thought these last two lines would be:
> >
> >                __this_cpu_add(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> >                atomic_long_sub(local_reserve, sk->sk_prot->memory_allocated);
> >
> > Otherwise I don't see how sk->sk_prot->memory_allocated) ever
> > decreases in these sk_memory_allocated_add/sk_memory_allocated_sub
> > functions?
> >
> > That is, is there a copy-and-paste/typo issue in these two lines? Or
> > is my understanding backwards? (In which case I apologize for the
> > noise!)
>
> local_reserve is negative in that case and adding a negative number is
> subtraction.

Yes, sorry about that. In parallel Soheil just pointed out to me OOB
that the code is correct because at that point in the code we know
that local_reserve is negative...

Sorry for the noise!

neal
