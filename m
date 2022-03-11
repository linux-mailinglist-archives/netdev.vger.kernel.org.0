Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C620D4D5A44
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 06:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244730AbiCKFJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 00:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241284AbiCKFJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 00:09:24 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B519C1AAFC8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:08:22 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2db569555d6so81230747b3.12
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DvdLV8rq2FF8hPEROf+vv4+XK58dbBQ5M812YBEfN6I=;
        b=Zl0cm39l+W4htAT6fdKG3yobP/Z16v2w+L6uDbPJQqEfXFofgLJsbn3NG5vIsbEsmB
         BaYx1OS0EGDijoGf2xgSEuiTXWx7PSjon1SOXWXjyhBTBLJe9wiLHWE6XL+zAGpxd0Wm
         ayr9ZZoWf+k115jK3Tba6pMorw0P6cOFq/J0fQRoy1cPvVj35Oa4WuorFCbcCQ2ueKGO
         FfTc30vJkH1k99U3zYqprezSh9dCF+xMW4RMBtpi3kxZ13WUMyRo8qMeeyuqUk9JV5wG
         WeSs1AorfGJyZiHPALhI1WdwlhSupMlZ2MS+VYmgJ8UXIgxAFWs1wwlTi86BURnlZwsY
         LA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvdLV8rq2FF8hPEROf+vv4+XK58dbBQ5M812YBEfN6I=;
        b=CtiaOK+rFX5iOGwgd+dxpSJEkxyUH+GJKymLhfLOv2YaxjqCdrWfU/n9ZtE4WO012E
         7lsqBE4GIiLKRLKBT/FK/TwNoI6WzPyz3/M5AqXFdDvvpL4CgjpfEPcfkkz33jHz9OZA
         zbd5VWoENt3cfnkvNgpFbIOu0jgPq5fczOW7ljSghq2jOUHgM+AJvKriMUSZJUxdod6+
         SCaLBO7vrdqre7jyTBHcEgL+68Okrq6crvP7yk1o4ei/ukzD+Xf9kVC71aJYZZnCgK7M
         jvyAYw1p26LTjzJlkEMsv8ECtjeY35mdyi5w0JRkKwX64RnzSN+8R+OJRfyZAHPZRv6v
         i2QQ==
X-Gm-Message-State: AOAM533YL9zElpDCRikRMJfzzoaH5gGmoW4B9cP982tX7igG92TAFLlX
        VrrEC6aACex2tnAKHq8zqHXwFV4/CLeT1xlUbEprs377qdSXgw==
X-Google-Smtp-Source: ABdhPJyo01MqhJCDp3hQqtWwWe4pAn1BnF3dzy5bYOndMJV78wTzgtvEZ78UhLvsVtxT61eR2cw+Jrdbmvg0Ww5tO4M=
X-Received: by 2002:a0d:d596:0:b0:2db:fc7f:990e with SMTP id
 x144-20020a0dd596000000b002dbfc7f990emr6775219ywd.47.1646975301528; Thu, 10
 Mar 2022 21:08:21 -0800 (PST)
MIME-Version: 1.0
References: <20220310165243.981383-1-eric.dumazet@gmail.com> <20220310210120.3f068bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310210120.3f068bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Mar 2022 21:08:10 -0800
Message-ID: <CANn89iKFXk2wTfZzSNhdd-BEwJ5vP84Jg+d4BFJ8Fde6_qKAHQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net: add per-cpu storage and net->core_stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>,
        Paolo Abeni <pabeni@redhat.com>
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

On Thu, Mar 10, 2022 at 9:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Mar 2022 08:52:43 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Before adding yet another possibly contended atomic_long_t,
> > it is time to add per-cpu storage for existing ones:
> >  dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler
> >
> > Because many devices do not have to increment such counters,
> > allocate the per-cpu storage on demand, so that dev_get_stats()
> > does not have to spend considerable time folding zero counters.
> >
> > Note that some drivers have abused these counters which
> > were supposed to be only used by core networking stack.
> >
> > v3: added a READ_ONCE() in netdev_core_stats_alloc() (Paolo)
> >
> > v2: add a missing include (reported by kernel test robot <lkp@intel.com>)
> >     Change in netdev_core_stats_alloc() (Jakub)
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: jeffreyji <jeffreyji@google.com>
> > Reviewed-by: Brian Vazquez <brianvv@google.com>
> > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
>
> > +             for_each_possible_cpu(i) {
> > +                     core_stats = per_cpu(p, i);
>
> IDK if this is just sparse being silly or an actual problem but
> apparently the right incantation is:
>
>                         core_stats = &per_cpu(*p, i);


Hmm,,, I think it is a typo, I would normally have used

core_stats = per_cpu_ptr(p, i);

Let me double check.
