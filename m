Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93E16C943C
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 14:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjCZM26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjCZM25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 08:28:57 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FAE6A68
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 05:28:56 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-54184571389so121268967b3.4
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 05:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1679833736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2UziUQS8rYrYDQ0kYBZWtD5AofLFmdm6EIJr26Gpzjo=;
        b=wxntmiTy3AlmLaf3H49KVHs1TcIiD7/q0VEZAcBx60ntDc9veWH9dJnn5BpmOkcUB1
         LNuigN36ms8eMDa8r6RZGrk25ncPHwMkCDh1Um670lVuy4zCpHjslv0jaJfstEKNCPVx
         xQhTYhtjgW0g/IzIi5nrYyiSQa1M6cvu4OM/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679833736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2UziUQS8rYrYDQ0kYBZWtD5AofLFmdm6EIJr26Gpzjo=;
        b=u+8jGZTsHir3zDSUFh34ir6FAi6oEAuTmc03NpX30ljkIhiATMGEWKH4owIGFgXRqj
         yu3tpIFcnTGRzQbGI4jG7CLNJLNjBAeI7BzvgWSUwJ3A/2khlpO1iRJuQP/szIXrUzFH
         nL1/j7s5oFsw+blwNrP30pLm9VeJOofNxVRW3ZKgEaHV64ZsDDojbryGxw6aspPDNw1f
         Ea1+3bmQxg9vgqdJSX2BMHTiZree49uS3AqMYAs3X1rpI3CsEZqiK6OLDwqFjB/1DwDU
         mDzF7+YpEFvF2qZja8ViWozu7WDq+LmF/x2TXmqvCOIozPLd+QXrZ4bMIR+NkNmz0mnC
         JWaw==
X-Gm-Message-State: AAQBX9doyDmyqX/kkUBwwq4KlRt5xMoK1Skj52B/WTCCXRIJLAoI3Yqm
        KFSmUVD8sTDOXH42r2BBLaAUAujqHbcdqYkTPBezRw==
X-Google-Smtp-Source: AKy350aNUXd/EeDV5yvwKIbqmA6xrP8ic8IEkMWqLZMTUhiNUwR6Il/FhyVgJ2KqlNWG08pX1YNMbHkMQ0JAFjQsMP8=
X-Received: by 2002:a81:af60:0:b0:544:b8c2:3cf4 with SMTP id
 x32-20020a81af60000000b00544b8c23cf4mr3894165ywj.1.1679833735979; Sun, 26 Mar
 2023 05:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230315181902.4177819-1-joel@joelfernandes.org> <20230315181902.4177819-5-joel@joelfernandes.org>
In-Reply-To: <20230315181902.4177819-5-joel@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Sun, 26 Mar 2023 08:28:45 -0400
Message-ID: <CAEXW_YR7njsiRxZtGpUftBQ0hFOzfzsLGQwfrgPwanucO8wATw@mail.gmail.com>
Subject: Re: [PATCH v2 05/14] net/sysctl: Rename kvfree_rcu() to kvfree_rcu_mightsleep()
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 2:19=E2=80=AFPM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
>
> The kfree_rcu() and kvfree_rcu() macros' single-argument forms are
> deprecated.  Therefore switch to the new kfree_rcu_mightsleep() and
> kvfree_rcu_mightsleep() variants. The goal is to avoid accidental use
> of the single-argument forms, which can introduce functionality bugs in
> atomic contexts and latency bugs in non-atomic contexts.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: David S. Miller <davem@davemloft.net>

Could anyone from the networking side Ack this patch so we can take it for =
6.4?

Eric or David?

 - Joel

> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  net/core/sysctl_net_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 74842b453407..782273bb93c2 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -177,7 +177,7 @@ static int rps_sock_flow_sysctl(struct ctl_table *tab=
le, int write,
>                         if (orig_sock_table) {
>                                 static_branch_dec(&rps_needed);
>                                 static_branch_dec(&rfs_needed);
> -                               kvfree_rcu(orig_sock_table);
> +                               kvfree_rcu_mightsleep(orig_sock_table);
>                         }
>                 }
>         }
> @@ -215,7 +215,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table *ta=
ble, int write,
>                                      lockdep_is_held(&flow_limit_update_m=
utex));
>                         if (cur && !cpumask_test_cpu(i, mask)) {
>                                 RCU_INIT_POINTER(sd->flow_limit, NULL);
> -                               kfree_rcu(cur);
> +                               kfree_rcu_mightsleep(cur);
>                         } else if (!cur && cpumask_test_cpu(i, mask)) {
>                                 cur =3D kzalloc_node(len, GFP_KERNEL,
>                                                    cpu_to_node(i));
> --
> 2.40.0.rc1.284.g88254d51c5-goog
>
