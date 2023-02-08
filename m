Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FC168EDA5
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBHLRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBHLRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:17:01 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47222B285;
        Wed,  8 Feb 2023 03:16:20 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id f10so20244727qtv.1;
        Wed, 08 Feb 2023 03:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IvyJfuofP+eu7wtEjzV8NYt8dzi5Ep7kIlhpJmN6FaU=;
        b=H/VV21JJP+KC9vqLw+MWiNtVdG9jAz5wQ3I7YDOdIuMoySyfN/uP9HbxbMimBcjsBR
         0ocBsS7gOEW8MSuZj0O3vkaPykSajrocw+rSQG2eumE571D+Gn40oQ4VZcq4vxPu6VRA
         Cys4QzCFmCFJgNTY2hhFOphqr/lGgfrLgqIo3qqeBe0TeuF3UxZ/EZxR5ppbT6lIGcTf
         SMTNKQX6kkHYNEdjLewSK/2/eMfZFUTNTf6y/5TmJ+7SoVdUBqCG85Cvs2VIc8OkJBMC
         7vC4gOAgUmVj90bVGZKnFxb5k3BdSnOqJiDwOTRiq+FV2ijgkC7m8ClZpu05IXbrXCWS
         BLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvyJfuofP+eu7wtEjzV8NYt8dzi5Ep7kIlhpJmN6FaU=;
        b=KPRv/aCxoFJFjERkJAT2/zNzE0N/fK0KYc6JDhDfAU83RWkF7j2rxZQRXduAt3S4xV
         v7xXl33GH6qp1/q4AVi9niIEB+Pydo6f5D5GQNZQPn077wwCd+hG3qp3xAv3EJQ5U8eS
         Bt8mV9FYGHdiP+MyOQFY5/i9GQ8b4ZjVbba1c/qOI2ikZhyUOwQHYR71OoTpGsgVEwdZ
         JHDY8ylTy3u7+1Vhsrt+MMNijerhHj3gU+vybXoaUXP45iq9eO4A8jDbzGa4Yy50W1sW
         R4VsZXIORT/SWemwvyfKoGkR1uJv1FPREbxHqp//izrUIrMWNI6ux6qVX4aa1k3GOco9
         d0fw==
X-Gm-Message-State: AO0yUKVJUBwpVn6x9R3kTqtX/YmEDcAnQKFpiSSchRLjtlOcqqB6kyD4
        +Z7hsROV6esOYZ/Ztnx2IfndJrkNt/Aq1/gep6uLQe1NUJc=
X-Google-Smtp-Source: AK7set/eT7RpoYx7oT9rJ9zmzNA60SXeZbeDGbYNv26KsbmCglFcAxnIHY7ZIC6qa8RurPs6byddjOueh8hvlVrCZRQ=
X-Received: by 2002:ac8:5a4a:0:b0:3b9:ceb2:210b with SMTP id
 o10-20020ac85a4a000000b003b9ceb2210bmr1741672qta.287.1675854965641; Wed, 08
 Feb 2023 03:16:05 -0800 (PST)
MIME-Version: 1.0
References: <20230206161314.15667-1-andriy.shevchenko@linux.intel.com> <20230207202945.155c6608@kernel.org>
In-Reply-To: <20230207202945.155c6608@kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 8 Feb 2023 13:15:29 +0200
Message-ID: <CAHp75VcQmL4REigquKZwuQmOovcOhjQ8A+Ri8U0D5YEL4v83cQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] string_helpers: Move string_is_valid() to
 the header
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net,
        Andy Shevchenko <andy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
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

On Wed, Feb 8, 2023 at 6:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon,  6 Feb 2023 18:13:12 +0200 Andy Shevchenko wrote:
> > +static inline bool string_is_valid(const char *s, int len)
> > +{
> > +     return memchr(s, '\0', len) ? true : false;
> > +}
>
> I was tempted to suggest adding a kdoc, but perhaps the function
> doesn't have an obvious enough name? Maybe we should call the helper
> string_is_terminated(), instead?

Sure.

-- 
With Best Regards,
Andy Shevchenko
