Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3E607E6E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 20:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJUSxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 14:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJUSxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 14:53:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4D32681ED
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 11:53:46 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n130so4330471yba.10
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 11:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WpUHQ3H2dxiw8WYhyzGCQZNfs2uYsqjIQqTj/d0xOKY=;
        b=SkfJyFOI7pZcn7NohaH2rj/ApDcBFOQehX8ecSSnjNf8Hcr0k4n8t5c4dzlyLHXpV7
         4PefvFXYx1//rzTI2zoUgnJDy1gnXEn6F7kUCPo2bcltE3X8XJGJRD1aiJOWWqBQbPJ+
         xg6UkWLIBGVWS4tIzYyWjwaWa9engwXfyWGW0NDwRn7zGwip8AKNMeultGWoNh6JSRpQ
         S0xOZ7x/dgXUHlNeU6qPE2mONVpA6UaGVXuQmMjZ/+tLX6k/UV0QvRTL25F5dKdt97il
         EWI1fIEH+nScZtX9TmbCoNUeFMG5LFi1w92hgi/CYzyUONJx3lSv2COzTTW6hwTL6BuS
         ekpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpUHQ3H2dxiw8WYhyzGCQZNfs2uYsqjIQqTj/d0xOKY=;
        b=hj2GP5eBxU1h7brHXlPiVAv3Sa5dQODF8s8uywR3X0F+d1a2vzJBLV2ZP+/h+Nda58
         54XSjvqEuuRq/juUwZlU1qiwjVzecSdL7go1H1/OEHIQZGFrchzODQObU6VGCrImBv9/
         zk0AGBUzvX6jbP/z92cYOQn4X5CFkwWx/9jWz8aVHmTLfhU5idMEBbd1enBjnop1dR8/
         wlSj3OnJkocbb8LwMYAftTich9Uq4f/yT/SY7h/kiB70GSoIB3ldQ6bRM8pl6C9eqTi0
         M4KTd74fzWa8vThahYQopwVZpETJ6Ky5/7b02RPH1N4FTgMRK5vp6hi+YyZ3kXpc/tF9
         Chpg==
X-Gm-Message-State: ACrzQf2GJZ6vZF9b5SbYoEUIrLwvLmcqbQwYQ+GACvQwMTDc0wBo9H8F
        K5LksiISAG59MxRtcrf0lPOdIn1ZsLVPq3XoLyGbeQ==
X-Google-Smtp-Source: AMsMyM71+BYw9shNnKfi1Byoox99nMcFvj0839B2OdMAhfmt0u05s/4TsJ0/MN17SJiRC515mQ9OJh07X9F5l41VxGY=
X-Received: by 2002:a05:6902:110d:b0:670:b10b:d16e with SMTP id
 o13-20020a056902110d00b00670b10bd16emr18166784ybu.259.1666378425263; Fri, 21
 Oct 2022 11:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221021160304.1362511-1-kuba@kernel.org> <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
 <CANn89iKTi5TYyFOOpgw3P0eTi1Gqn4k-eX+xRTX78Q4sAunm2Q@mail.gmail.com>
 <CALvZod5di3saFdDJ1cwFDgvLPmnEJ7XB9P8YBTJ3uzfBKAFi3Q@mail.gmail.com> <20221021104016.407cbda9@kernel.org>
In-Reply-To: <20221021104016.407cbda9@kernel.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 21 Oct 2022 11:53:34 -0700
Message-ID: <CALvZod6TXxp9nXuPcWD1Vhi6jvxyWeAOrwXvDfTTxYC9RviWhQ@mail.gmail.com>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, cgroups@vger.kernel.org,
        roman.gushchin@linux.dev, weiwan@google.com, ncardwell@google.com,
        ycheng@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 10:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 21 Oct 2022 09:34:20 -0700 Shakeel Butt wrote:
> > > > How about just using gfp_any() and we can remove gfp_memcg_charge()?
> > >
> > > How about keeping gfp_memcg_charge() and adding a comment on its intent ?
> > >
> > > gfp_any() is very generic :/
>
> That was my thinking, and I'm not sure what I could put in a comment.
> Wouldn't it be some mix of words 'flags', 'memory', 'cgroup' and
> 'charge'... which is just spelling out the name of the function?
>
> I mean:
>
>         /* Alloc flags for passing to cgroup socket memory charging */
>
> does not add much value, right?

Yeah I agree. Let's just go with the original patch.

You can add:

Acked-by: Shakeel Butt <shakeelb@google.com>
