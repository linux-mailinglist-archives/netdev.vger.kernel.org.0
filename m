Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D622254CCE8
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244124AbiFOP3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356487AbiFOP2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:28:52 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B0221A2
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:28:39 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id x187so12177415vsb.0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qtkq5lpCZFJCMeDk8RhNExFiQZaa0Llj/UH0UcMPsi4=;
        b=b1cT0lyYm0P//twR6B4+wMC1EnpQcM8xZ/3cfnjbczXnP20OFkXOSehfYqxhH4PuUp
         0IlRqRBLTsTjTloiDj7M+ct9SIG3ayq91UB6wgpOm2swGJTMT2c44paYYUNCusKBfLr5
         eN7RdbB24EWnj039HQaPevOfZhkXmWn71pxLFoMvrbHoXXVS7fOf6AK5vuhm47it+Pym
         EGs9snFb3xRrVALzWlSKKjWJmDr+YIzwTNx56QIVpxeWQhyqJLGSMWHfqInaF8/6Jl6J
         pTjW3doGQXpkqijCfJqVAHdjGzxHVknzXcQB6oHTZHLMKJOtTQndVlYTnXBlCUIXMZEf
         xhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qtkq5lpCZFJCMeDk8RhNExFiQZaa0Llj/UH0UcMPsi4=;
        b=WauKf/2YxG8PAyzFvzizAzcPsiDPxkMQ9LTT/UamMbXr0v0K0ZN0jRGDvMJ0xccm5M
         7CXOrvoRTbXCgSrYnUOxYccGl0s/gTFBFiwUtlEpLUlLVkDZwWoyD58pi7jmXSwnSTjJ
         A2cbhzOgaFn0MB1rP97XHV+5PJ4HMjmCnzNy2z8MxxKikikxhd5Hlr6MYJCGR/qCwoZB
         teEUIrCYWeXBsgZLtTK7JrNTuLBdR6NfR00izYDK11KxEYokUkSt60vZ8JUgU4t9jtdu
         jiC3PCqsYl2bv+qxD+MTa1jrklYCFtlcdHHvYDAWbV1NWQDPLPqh6VHTTto5ZZ8KSKEc
         br4Q==
X-Gm-Message-State: AJIora+mjEjxAInjraA5tIUizkI+7OCXfHbUNRELJ4bdKJM0fJ0IHIYu
        6lnsTCEsg/pIhJiPB/Ye9JmzeL+uiUgKYR05Or8=
X-Google-Smtp-Source: AGRyM1v1vm5OG6+LD0gGfugPScZaPZ3hLpDaH1kOi74G/K2W7xY/wKfC1sHx4HG5C8XY8rquYMpVUjMiM068l7JerUw=
X-Received: by 2002:a67:f28d:0:b0:34b:a293:a6fe with SMTP id
 m13-20020a67f28d000000b0034ba293a6femr4751359vsk.26.1655306918264; Wed, 15
 Jun 2022 08:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
 <20220609105725.2367426-3-wangyuweihx@gmail.com> <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org>
In-Reply-To: <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Wed, 15 Jun 2022 23:28:27 +0800
Message-ID: <CANmJ_FNXSxPtBbESV4Y4Zme6vabgTJFSw0hjZNndfstSvxAeLw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce interval_probe_time
 for periodic probe
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, wangyuweihx <wangyuweihx@gmail.com>
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

On Tue, 14 Jun 2022 at 17:10, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> > @@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
> >       [NDTPA_ANYCAST_DELAY]           = { .type = NLA_U64 },
> >       [NDTPA_PROXY_DELAY]             = { .type = NLA_U64 },
> >       [NDTPA_LOCKTIME]                = { .type = NLA_U64 },
> > +     [NDTPA_INTERVAL_PROBE_TIME]     = { .type = NLA_U64, .min = 1 },
>
> shouldn't the min be MSEC_PER_SEC (1 sec minimum) ?

thanks, I will make it match the option ;)

> >
> > +static int neigh_proc_dointvec_jiffies_positive(struct ctl_table *ctl, int write,
> > +                                             void *buffer, size_t *lenp,
> > +                                             loff_t *ppos)
>
> Do we need the proc entry to be in jiffies when the netlink option is in ms?
> Why not make it directly in ms (with _ms similar to other neigh _ms time options) ?
>
> IMO, it would be better to be consistent with the netlink option which sets it in ms.
>
> It seems the _ms options were added later and usually people want a more understandable
> value, I haven't seen anyone wanting a jiffies version of a ms interval variable. :)
>

It was in jiffies because this entry was separated from `DELAY_PROBE_TIME`,
it keeps nearly all the things the same as `DELAY_PROBE_TIME`,
they are both configured by seconds and read to jiffies, was `ms` in
netlink attribute,
I think it's ok to keep this consistency, and is there a demand
required to configure it by ms?
If there is that demand, we can make it configured as ms.

> > +{
> > +     struct ctl_table tmp = *ctl;
> > +     int ret;
> > +
> > +     int min = HZ;
> > +     int max = INT_MAX;
> > +
> > +     tmp.extra1 = &min;
> > +     tmp.extra2 = &max;
>
> hmm, I don't think these min/max match the netlink attribute's min/max.

thanks, I will make it match the attribute ;)

>
> > +
> > +     ret = proc_dointvec_jiffies_minmax(&tmp, write, buffer, lenp, ppos);
> > +     neigh_proc_update(ctl, write);
> > +     return ret;
> > +}
> > +
> >  int neigh_proc_dointvec(struct ctl_table *ctl, int write, void *buffer,
> >                       size_t *lenp, loff_t *ppos)
> >  {
> > @@ -3658,6 +3683,9 @@ static int neigh_proc_base_reachable_time(struct ctl_table *ctl, int write,
> >  #define NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(attr, name) \
> >       NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_userhz_jiffies)
> >
> [snip]
> Cheers,
>  Nik

Thanks,
Yuwei Wang
