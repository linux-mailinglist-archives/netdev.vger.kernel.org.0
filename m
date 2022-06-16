Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973FB54DA38
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 08:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358948AbiFPGHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 02:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358961AbiFPGHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 02:07:36 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13DC273D
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:07:29 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x38so495587ybd.9
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mL86IaHA+S4vAf9EpUoLnEYqyO2ENLMymhT80zVPCu4=;
        b=I1+CFQ0BuCdS9DRIbdHylJvfOT7poqjhmDgcbJNcsLCCNLFOtr8DsgrKT12U4tpDMg
         W0Mm7XbJgAzo8NUsKIZd8arUtQk+BvVOxdvWGRw4ytjcSNjaJoEg1t8bvrJHRelOi7+u
         315thjTcg62ibZnpopMAxDEQ6L2DsTjWff7x5HyfUjFmVOO8LOlnIuBNOM2Z8QqIeJNt
         USgE85Qhr4wBidPzed3yaZiB8fs64UJlDQe1Cb7QZ0dSxW/kaDrp6L7ujHhmZUR3blPi
         f/B+PACP7N6LwcpzfWS6L+HG1Rwcf7Sh3LCXUTJsbulaQMAd77kOaE9agQxROfj5GZXf
         vtrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mL86IaHA+S4vAf9EpUoLnEYqyO2ENLMymhT80zVPCu4=;
        b=akGMY0Qf4MC/n3LhIKwKXUYTAcmwr7m9UutFn+9ixEQplTk6lE8GebuENVaAuT6YVV
         LKf8bUFpJGSsAomERJc6r5cCFAm5uHZ+p7vI5TJ4Yjgp8gCbdV00t9QL3oRbO/utCgmq
         RcH09aImlGkast3My5O9Clnu4+dzyrjgti+e14dutboDmFfnojxpr095rHHvu5cSPVtL
         tWlS7W0ItN2gHsrG5V/aFIyq+ZXGnT/hjmf4Dm5E1xUbRDSM72arU/r+paP42a1FMxUs
         hMdBu6PwMtIT9RJI4CP6KWi159HaOfWpGBu/MjZMMDoyI47fd7fA84QNC79vPKVH20R7
         G2+w==
X-Gm-Message-State: AJIora+1LkmKdg/otaktwL9FfNL/76PQ9OKNKPyXHXS4EHDbGof0vvoV
        Exclrzld1h91S7gnCnepZM/Zaq6cdJ4kW2s212mwog==
X-Google-Smtp-Source: AGRyM1vhkjErgOMQ9i7p/mPq61AeLEord5cK4Tds6LBxb+VlngLldaQW6zFUZOg6sLW4Ra/aOu23fVsF18i7LwKFzlQ=
X-Received: by 2002:a25:aa32:0:b0:65c:af6a:3502 with SMTP id
 s47-20020a25aa32000000b0065caf6a3502mr3795772ybi.598.1655359648753; Wed, 15
 Jun 2022 23:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
 <20220615.125642.858758583076702866.davem@davemloft.net> <CANn89iKie9pgj8mjXGrgpH0XL3Ehfad61kCJ8rGdOk4GoR=o+g@mail.gmail.com>
In-Reply-To: <CANn89iKie9pgj8mjXGrgpH0XL3Ehfad61kCJ8rGdOk4GoR=o+g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Jun 2022 23:07:17 -0700
Message-ID: <CANn89i+ReVNn93+EvQ1PvctEAy9uEQUDQgTpRUNhCiAuqNLxaw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] tcp: final (?) round of mem pressure fixes
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>
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

On Wed, Jun 15, 2022 at 11:00 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jun 15, 2022 at 4:56 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Tue, 14 Jun 2022 10:17:32 -0700
> >
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > While working on prior patch series (e10b02ee5b6c "Merge branch
> > > 'net-reduce-tcp_memory_allocated-inflation'"), I found that we
> > > could still have frozen TCP flows under memory pressure.
> > >
> > > I thought we had solved this in 2015, but the fix was not complete.
> > >
> > > v2: deal with zerocopy tx paths.
> >
> > Does not apply cleanly to net, please respin.
> >
> > Thank you.
>
> I was targeting net-next tree for this old bug, and planning to
> prepare stable backports.

This was because in net-next we got rid of SK_MEM_QUANTUM, and to
limit merge conflicts.

>
> Tell me if you prefer to respin to net tree, probably later today
> because I am traveling.
>
> Thanks.
