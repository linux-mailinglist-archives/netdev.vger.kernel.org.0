Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444D35FFBE5
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 22:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJOU1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 16:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJOU1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 16:27:01 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26484476FF
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 13:27:00 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k3so9247031ybk.9
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 13:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mS8XGtqd3i/pk7URDEoiQ34L/lpb4BogfvC0QODXjc4=;
        b=dwdL4K9pRB9tgFet7f7vkNfdIBpt8C0Lj7H1w9Q6g+d+D9kAO8YuHXByo7dCdPWkj/
         dWJKhJxi3mYnrcFxahkQTvX/H0r+TSU9o3T4KEtXiKKN4G64iBbWLxwQaQ2QYymqOoTf
         n9g1m56tAU42EkcyTM/vnC7AWgWiQ3Ce73ewbrVQvhleAS6JgOvbOERa3WQESZ7lxC53
         4kfqLgLa9RCvw2XaBq6SJj+QAyLBilMVDhz1cUAcDH7HW7Yrwhj/URm15dI0UG17aBtW
         nRu+OiFlOu1MWc7QTc76Yk63GwD42QQHOX87u5+9/nl8Jfdlvydske96dNSDrpidJV0Y
         b9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mS8XGtqd3i/pk7URDEoiQ34L/lpb4BogfvC0QODXjc4=;
        b=WbqxDy0enwt/z3WvvMwLrG21m/t0Y73EOgxmYGBHz3kniII26V/5CM7ErSM4vQ0Srp
         o5FC08uwR8IYkv1K4JWH9pRHMRO2NFt+GDy4LAi4rZUrbDluSClNjKd77wlk0Ep4dc8G
         0/riGENetCngmVXP4a7B65vXGob289fw8azjaEg6WTXmbhRIPMjrNG0Q9qHHt8R//Ard
         1QEa5KI4qdKBlxF6Dbl9SAzQrgC7CgxWtEfpxzgQP+//GGYhBC+Ik6KM/L/FHv/0gJP/
         hUHVtDqZf8PI3/P83CjKPMH2xSfNULyQqurO6+CqgiSA18gjZgDDt249jBg8/DZEAAwI
         5i9g==
X-Gm-Message-State: ACrzQf2W6QWFFoPt8GrI4hcAmb1u6uJoEjlTBZiyFw5VUfY77GCzlF2b
        fTWjs/0wkqbwzwNJKPoczvv/a4Pcm3bAalhCHWnpW8d4MS4=
X-Google-Smtp-Source: AMsMyM6TpoCQc+8Yf7RgpQ7w8fNS/RPrKY3wwmxKembXmvCWXgCqdO9SFDcNRLr0kipN0CTA826iCVitjzJsROJnT7U=
X-Received: by 2002:a25:84c9:0:b0:6bd:5074:bc30 with SMTP id
 x9-20020a2584c9000000b006bd5074bc30mr3377208ybm.55.1665865619165; Sat, 15 Oct
 2022 13:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iKJpWK9hWLPhfCYNcVUPucpgTf7s_aYv4uiQ=xocmE5WA@mail.gmail.com>
 <20220928221514.27350-1-yepeilin.cs@gmail.com> <634b1304.c80a0220.cedc6.e007@mx.google.com>
In-Reply-To: <634b1304.c80a0220.cedc6.e007@mx.google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 15 Oct 2022 13:26:48 -0700
Message-ID: <CANn89iLrKnzYUt-bkXA9pVsviw2+RM3tWO==ZYy-yHR_1Uz+9w@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     cong.wang@bytedance.com, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, peilin.ye@bytedance.com,
        yepeilin.cs@gmail.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 1:07 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Sep 29, 2022 at 09:19:34AM -0700, Eric Dumazet wrote:
> > Second patch adding the tracing point once in the helper ?
> >
> > Alternatively, why not add the tracepoint directly in the called
> > functions (we have few of them),
> > instead of all call points ?
>
> Why do we want to give implementations of sk_data_ready() freedom
> to not to call this trace_sk_data_ready()?
>
> Thanks.

I proposed an alternative. Choose one, but not the one you do not like :/

The first proposition was to split the patch in a more logical way.

I think we have less sk_data_ready() functions than call sites, so
code size would be smaller,
but this is probably something we care about enough.
