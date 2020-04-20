Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDE51B0EDA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgDTOs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgDTOs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:48:58 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E831C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:48:58 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id j14so8173486lfg.9
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RlFdSvoFllWDGwqxS0hSeAyRnZIZx9f+vMY2WXpSoc=;
        b=RRJoS2j0UplGkmZwuz0Qmlp2V+OXV3rCS/eL64qSgDNF+EkCWKDWs0lpQ/g3v0R26C
         eXp2V6XEtJPc3dbad2IjUUO/JfDOYjnwgQ/pUe7AL90OhwZ21gsAQRFB33OZCQx1mLI5
         ntOob4WvwMBkskN7+oaPu5GSnRuiMfPtVIFTzFECDo90nitcbXLnnTSM7rqdyr40l1s1
         boEnAjsMBre2iOUdB9LGZks1MlC0cjGURYHWkHH3njSAT3OG18+z3lD64gGe5x+N84EF
         t2JQz3qVJuWDgrcxZ2G5rgOk9+n609pyaEbvb8CFokFF/vXV4P3gBYqb/9GcuGtCj3Qd
         gSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RlFdSvoFllWDGwqxS0hSeAyRnZIZx9f+vMY2WXpSoc=;
        b=gzc752nbsPoeuHit1pF0Yt/MacwTQZcDu2RQwsCKPtKNOXJko6Of5/EGi4hburBWIr
         84HdAq1TVwvrYZkZfAHgzAqO1xVf+l1VBSkrVS07yYAyvKSINztcSntqcvSWS8w3XqS6
         tuKzzTVuazgtp0ojqyqLFMJEmcQukdCbqpIsUba+4EFYzZ9NtRuoIS+8BcE3XxsSY6tN
         99vLHXRCHW+yDm4zsKH4QhsghOoCMLM1XBzH0rEQwG/IeU1T0XZWXOLAFKQxRyTs1m99
         Pry5Tfg1a6C6B8XZNwYVZrdHdmSkg3+ZkBiHchIIPPEfU2nXbjaWs8rXTEeh/xmtfHTU
         QihQ==
X-Gm-Message-State: AGi0PubSnDJa0abN5nuwk+UxHBqpzbkUndYGeEhEr+25V0U6FoyjiHfM
        Mjv0ZnCEl5JwKpE0EtQ21we7jsS6xqKqn+eyco0=
X-Google-Smtp-Source: APiQypLTEHuiXa99Rq6meXQYAqv3axWy8NRvKmB9XAYCQyVwcUatZk9h4Itv3Hy/lIwGIPHAbFBVZjNJXXSYZou1NZY=
X-Received: by 2002:a05:6512:54e:: with SMTP id h14mr10807667lfl.56.1587394136787;
 Mon, 20 Apr 2020 07:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200420131145.20146-1-ap420073@gmail.com> <20200420143502.GO6581@nanopsycho.orion>
In-Reply-To: <20200420143502.GO6581@nanopsycho.orion>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 20 Apr 2020 23:48:45 +0900
Message-ID: <CAMArcTVofrveSpe7hzc62C19yukDFgAAN9qX_p39_DBuviRTLg@mail.gmail.com>
Subject: Re: [PATCH net v2] team: fix hang in team_mode_get()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 at 23:35, Jiri Pirko <jiri@resnulli.us> wrote:
>

Hi Jiri,
Thank you for the review.

> Mon, Apr 20, 2020 at 03:11:45PM CEST, ap420073@gmail.com wrote:
>
> [...]
>
>
> >diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> >index 4004f98e50d9..4f1ccbafb961 100644
> >--- a/drivers/net/team/team.c
> >+++ b/drivers/net/team/team.c
> >@@ -465,8 +465,11 @@ EXPORT_SYMBOL(team_mode_unregister);
> >
> > static const struct team_mode *team_mode_get(const char *kind)
> > {
> >-      struct team_mode_item *mitem;
> >       const struct team_mode *mode = NULL;
> >+      struct team_mode_item *mitem;
>
> Remove this unrelated move from the patch.
>

Okay, I will send a v3 patch.
Thanks a lot!
Taehee Yoo
