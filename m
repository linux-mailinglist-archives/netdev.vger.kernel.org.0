Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF9C547DA9
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 04:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiFMCnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 22:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiFMCnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 22:43:39 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6D63337F;
        Sun, 12 Jun 2022 19:43:37 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b8so5313344edj.11;
        Sun, 12 Jun 2022 19:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUZpw0LopGjc0FjmXPxeWU9L6hvwiZttSZ8ZRDX50kI=;
        b=TpFDyiS2s1I3InqSYo4+CxTLgKRw9ZSzvWWVldgOy8MQhrsa3g5q9Ba8Xm53N8R4mz
         rS1Jy8ogN814wmB4ML3WYL3OFeA61dB1s+z1NRIJRrleQPUnvBDeuemygYSEx4f4uP8A
         OGOeFtUtiAc1vSQeng+Fazaqigh6JB4zwXQynQBhJWGXNbhLkRWeJBH6o8lTK3FlWYbl
         0ezDUct+wHCTcJMikPShyZZ4iD7gcvFMFREvBahPYlNo7EtnDj6YQyA8TfCxNrDEyRK7
         X36eUtMTZCMD0DSpf83VdQD+2Je9I0/rm5BsOoEiuRtae9Pbo1ZG1AlpvxR3QNoLnxNh
         9/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUZpw0LopGjc0FjmXPxeWU9L6hvwiZttSZ8ZRDX50kI=;
        b=PR1vyI47smMP015klPJpUO6leVk5AkQKQdpdU8shvqHNXoBCYYOzOno9NW35QablMF
         tgStaF0ngSnd11PZ3PM/eOgoDM1ZWlSx8xgORLnEyiVu8H0m/Fym7ZUzOicvvg/czIjj
         BcbLPVtrqcH0e5tZmcXBQpcrMM6ERKWw+M5kgCp/G3+f73LLLhUgzIjfE8Mjbj8Pi+7f
         6OEk8YdF+RagHD+r+oYQM/eZpmHO1KcJaHoz0hUa8tPHU3YffFBAHNaY8bCUftBzVlKo
         +IRvSyWjXhevvLBSBfNm7FUl/Iy5uuRHCVOdCw3gn8pZWwq/G65QZCLYGS9AFfHnZsuQ
         rP7A==
X-Gm-Message-State: AOAM5313J/oj6AXmlmucsgjN2gWF7z2UwXUCcGis3FY/bM1S8wDCcfRt
        rTlzkhxtz8UT8XHIrp7szxpNVsQQMhx7AN1gRcQ=
X-Google-Smtp-Source: ABdhPJyVgn8f9OWyOe0jpedEkgpDjBY7BGGJpgJbfyZ768+ya+RQtM3Jvm3BzpT1/IGaeFaG2PAK1BADDFHcEsWeSdk=
X-Received: by 2002:a05:6402:709:b0:431:3a54:5cbb with SMTP id
 w9-20020a056402070900b004313a545cbbmr47506349edx.355.1655088216420; Sun, 12
 Jun 2022 19:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220610034204.67901-1-imagedong@tencent.com> <20220610034204.67901-6-imagedong@tencent.com>
 <CANn89i+NV1DgxaQbqPu2o0Du-94gDkM8DUrX_DK7=AGqvvPKdg@mail.gmail.com>
In-Reply-To: <CANn89i+NV1DgxaQbqPu2o0Du-94gDkM8DUrX_DK7=AGqvvPKdg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 13 Jun 2022 10:43:25 +0800
Message-ID: <CADxym3Yy1hK7g670zW__yZUmtyH-aKYnckeJfGfKTDReopEgdA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/9] net: tcp: make tcp_rcv_state_process()
 return drop reason
To:     Eric Dumazet <edumazet@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
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

On Fri, Jun 10, 2022 at 4:56 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jun 9, 2022 at 8:45 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the return value of tcp_rcv_state_process() is treated as bool.
> > Therefore, we can make it return the reasons of the skb drops.
> >
> > Meanwhile, the return value of tcp_child_process() comes from
> > tcp_rcv_state_process(), make it drop reasons by the way.
> >
> > The new drop reason SKB_DROP_REASON_TCP_LINGER is added for skb dropping
> > out of TCP linger.
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > v3:
> > - instead SKB_DROP_REASON_TCP_ABORTONDATA with SKB_DROP_REASON_TCP_LINGER
> > ---
> >  include/net/dropreason.h |  6 ++++++
> >  include/net/tcp.h        |  8 +++++---
> >  net/ipv4/tcp_input.c     | 36 ++++++++++++++++++++----------------
> >  net/ipv4/tcp_ipv4.c      | 20 +++++++++++++-------
> >  net/ipv4/tcp_minisocks.c | 11 ++++++-----
> >  net/ipv6/tcp_ipv6.c      | 19 ++++++++++++-------
> >  6 files changed, 62 insertions(+), 38 deletions(-)
> >
>
> I am sorry, this patch is too invasive, and will make future bug fix
> backports a real nightmare.

Is there any advice to save this patch? Or should we just skip this
part (for now) ?

Thanks!
Menglong Dong
