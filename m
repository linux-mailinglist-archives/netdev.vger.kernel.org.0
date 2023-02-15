Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AEE698799
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjBOWAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBOWAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:00:49 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C56B454
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:00:48 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id c2so218520qtw.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gzhk79EXAVpgasss7GkpiHFOiLik50UZyg5ITzXKYpE=;
        b=mI+wTz4V3fLdCIVsSckVzJkS09vqA8KEBAFA5G7m3PcvRzmgf3E5koBgex/wrZ4uOL
         2kHm6+lWuwNxMb2uqvTPCZxnJ3w0rBH6iKNC0AwtfUcqP0idBKXgdKZkgiCK9jpmuC2o
         cjn1hfLT6bktuUgAD5Kdj0ChYNiY1oF0RxTYKQAKz9sEzaKAZdOeMUp+KMa+ubDSky6n
         OiY4+fpCxibt/2CAFmz/6UjXRdwT+wThfDb1/RcyWHqBUsV/0FDIh7XzaBUZgYtlch6K
         zWXtzqQvhC9x209gJ4HwtMVPSeobw2W80Wdtnz6cP5/Fk1PKtiAKBlSLpeevSrkFxcoh
         JJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzhk79EXAVpgasss7GkpiHFOiLik50UZyg5ITzXKYpE=;
        b=NJSVHeoXKI505iADQP9zQ39NKef71WD7LOZmPPpvKabWiU0gTkzXjGph1uo8+ERCZl
         QfAv9XV7RwBdrnzaF2MV3JSsISLwE+AjAQLXx3YDWSN36vMoFue5loHsn/Qu4BqEGpdg
         XxccXBBOYRcEorUatidPzAYOzAQt03yofIim/JqSrd7I0O535+oAxyhTsaHWaGW6kSYC
         E+p58Od88dSgWYzIJuMllIfV/FENWpmSSDswsAMbLv6mU8744zdNqXX9Ux0gza6CVs5C
         wUr5AbW2Ow43XPFrFaz7z/ekw4BrWvkK2EAkX6N/RA0abB8C1E1LNdXlUHODoJXcj6iG
         48PA==
X-Gm-Message-State: AO0yUKXeVeLLp45K/oht+3v/KQBQ6EL701J47vQQInnX68J3ymhlczi+
        yWyv8HsyFu+5H4CG+CaHo84=
X-Google-Smtp-Source: AK7set/prvfpHScABI2Jn4q32xcn0aNJFe84iqtxBbTbN12zYwN4R0mMNYUh+pXjvwFvXy8Ccoij7A==
X-Received: by 2002:ac8:5c01:0:b0:3b8:6aff:9b58 with SMTP id i1-20020ac85c01000000b003b86aff9b58mr5967548qti.35.1676498447649;
        Wed, 15 Feb 2023 14:00:47 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id d7-20020a05622a15c700b003b7e8c04d2esm14111921qty.64.2023.02.15.14.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:00:47 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id F27FC4C2908; Wed, 15 Feb 2023 14:00:45 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:00:45 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v12 1/8] net/sched: Rename user cookie and act
 cookie
Message-ID: <Y+1WDepPHWQ9JzE9@t14s.localdomain>
References: <20230215211014.6485-1-paulb@nvidia.com>
 <20230215211014.6485-2-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215211014.6485-2-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 11:10:07PM +0200, Paul Blakey wrote:
> struct tc_action->act_cookie is a user defined cookie,
> and the related struct flow_action_entry->act_cookie is
> used as an handle similar to struct flow_cls_offload->cookie.
> 
> Rename tc_action->act_cookie to user_cookie, and
> flow_action_entry->act_cookie to cookie so their names
> would better fit their usage.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
