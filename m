Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E84679FE2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjAXRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbjAXROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:14:25 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3265E45BC7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:14:23 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id r71so7373078iod.2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VLXAoy+VMSpKCL3Hup/HJE0uJlr4RTfVEJCBn9VGcpM=;
        b=YxtFNxMB4k6TQvNJe9GQinwYxPGMK4lLWbI9P/vtPiJZQNc085f45pfboDS5DmaCmJ
         2Fuem+DsjTyuxeQ77wF7SKqFXPpduaygsdWMg/lDbx+3dAH73IvKOsSMg0WB/LkxnS9A
         GagK/5naN3NZ/+iGye0GU8bQlw8INJ6dMldY+isJ0wK+LVLQBQBE06+sECfbKI6EPKsh
         IGFwWvSb79DYKohU1XbycdvPOy4gGXDkXD+HIhlUVkZCKtGpQV+Q0ilrrts36wjPLtOH
         5bvXkBmtCbpqFOgP/NYbTZmWcuzksn0UAKOUEuiNdx3ZbY2vplTpeMTejy9CTt52VQ1C
         lH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLXAoy+VMSpKCL3Hup/HJE0uJlr4RTfVEJCBn9VGcpM=;
        b=5O0uDUxQY0SkUI50p3H7uwCQbZRajI0tGX9VpUuL3B/AOl9GgUYwlqo7LA+YZp54vj
         XE8l9WrPhuStXVDbU+0416e5mNA2xgEw8l8jIBF7ZWDKKoXJ2CQ/ViQvsktOVP1ZPu/G
         hqL3ai8fgDm2IfJskp1axcRvcEvMxd6orKnuh22DSm3VxKt13pPP1JgpYB+9GKiuxTaS
         Yd8lOdNvTU8Tc0BPSntSe237mgG9Y48WOWm/U1T01GZPfNy6sIiLB/HwoIzD34zrF8mc
         r2tOcmRXbkkPNsTuQ50gdOIzG7P7Rt2Anzj2SKKFTPAQRLUd0Oeta+sd4y1UGmNfZg7G
         4oJw==
X-Gm-Message-State: AFqh2kqCH14vZFILMDbU9S89xxStWEwAbZxU0P9tXqMqGBTowh37SFrh
        sw9jxO4tQ0QZOPy35vZEAUFYiojE/1stlW1N12hc0w==
X-Google-Smtp-Source: AMrXdXsFvogPFk+a5kaAWAEWgADXq1aR+azC3t6rizt15U0NNDlsRxjQjP0MrZqObwykj6nKUIaW9ctUm5X6ur4QaQ8=
X-Received: by 2002:a02:cc24:0:b0:389:af9:4860 with SMTP id
 o4-20020a02cc24000000b003890af94860mr3221285jap.164.1674580462172; Tue, 24
 Jan 2023 09:14:22 -0800 (PST)
MIME-Version: 1.0
References: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com> <20221221-sockopt-port-range-v6-1-be255cc0e51f@cloudflare.com>
In-Reply-To: <20221221-sockopt-port-range-v6-1-be255cc0e51f@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 18:14:09 +0100
Message-ID: <CANn89iLE-2O8ZJGv+TqrPt+kh-ku8JdkyA4qtR=RKitt7rgrAA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>,
        Leon Romanovsky <leon@kernel.org>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
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

On Tue, Jan 24, 2023 at 2:36 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Users who want to share a single public IP address for outgoing connections
> between several hosts traditionally reach for SNAT. However, SNAT requires
> state keeping on the node(s) performing the NAT.
>
> A stateless alternative exists, where a single IP address used for egress
> can be shared between several hosts by partitioning the available ephemeral
> port range. In such a setup:
>
> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
>
> Reviewed-by: Marek Majkowski <marek@cloudflare.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
