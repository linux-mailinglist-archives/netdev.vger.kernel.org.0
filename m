Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15910545223
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344802AbiFIQjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344805AbiFIQjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:39:07 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A720A286832
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:39:05 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id y187so22345472pgd.3
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCZZTWSIJGRvUl0kZ42exwZrRfBEVnQ19L/6dfUzHhM=;
        b=Izwe6JSG3M1No4nCcvVwVW5qwg1QEanD5157ybf7DwKY5PyzLVloWxCCTxecEXxhax
         ak46FAj1cL2v++JdsXZxHgBWCDvIZuC/RYQ8BR6zLsjbUIeqfk1rBvLMdGtxS+QRsAUF
         2liJTSTXrGaJ9p5nfoUr5YpAxawiT/tZe0FFOg286900yqJj74wmycG3gprNZviCUGZX
         GMJmpPuQzpwSbe2fmn9UQvkWcGQHpLb9irKS9FMbNtkfH/tTYRzkZpoMqZOv1mOoECDl
         zbAsq5OfwZCkpSZRxXSMPKQmTL2aqA+tn2DIMpEdDJ+dutquJyrni8T2k35htdi95t3B
         BjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCZZTWSIJGRvUl0kZ42exwZrRfBEVnQ19L/6dfUzHhM=;
        b=ZbLcYLXrilqwPiND4XN76hfAYSHBqqIHCHo5hdx7l8JgKxuoS4FgCSten8wTcHwvpg
         GkVZmNI3wM2AFc7s4g/fEhMdeRfaRE8GUeo3Knk7fx+g6mbfpZVzPMHe2dgKaxf2YUA7
         1laJUn39e/FP0So+BHjFlulMhaCrDixNyjM0bofRRcvi8xSevPhALdNGBB/L6RLI/bcz
         95RXtPocvzdK8ZSjblaPx73NXzwqEFNDu/cFwNy3VMC3sjO+3WuQbS9Exw7mug4YwLOf
         yt/7BSYsdW+WFxKrC6DBU0iS5FXuwqNQLWQEJ1mYQ2YajJXEPa77uxV/ntkegJ7iOJF9
         ViRw==
X-Gm-Message-State: AOAM5320SVD/8X1nVTklyY5UPLgjTW6L51SHuQRi8dS7Av7nVRRwLpXM
        4T5eAoeLd6T7CbSqeIjbvxDfbmoNup2/hvA8wR7BlQ==
X-Google-Smtp-Source: ABdhPJzFYaobhOw2+NEapFgLQJ7TDR/t2BzP8i0SB1s4I0uGiGqQfGGP0XhOZTT+9YsJXhTlGLG3smw2kjpacAxnkSI=
X-Received: by 2002:a63:86c3:0:b0:3fd:9c06:ee37 with SMTP id
 x186-20020a6386c3000000b003fd9c06ee37mr21000905pgd.357.1654792745018; Thu, 09
 Jun 2022 09:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-8-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-8-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 09:38:54 -0700
Message-ID: <CALvZod4nzUmy2N575hVxaKR6DK-UavQvZtEprto6NEQu8otGFw@mail.gmail.com>
Subject: Re: [PATCH net-next 7/7] net: unexport __sk_mem_{raise|reduce}_allocated
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
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

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> These two helpers are only used from core networking.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
