Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47B4D36F6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiCIQrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbiCIQqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:46:14 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E3C12B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:41:33 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2dc242a79beso29347077b3.8
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 08:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BKX4i6UhtdbagXTE8rWIuHmxawiMbBsl+I43GhvcqbE=;
        b=OAuioVH8750WTiZVd1Ja/GXYr46ZF1gxUkv4c/rj/5TQgcapPJzRvjXxLP7c4TpGCT
         GFJ8ZD0KVQNzJqmAh6WYbSTqjgSxbLUrcJ82M7+R7j5cHTegQ5/P9htbDv8mXbD7TjnM
         UlnJY9V5TtqH+moG/GcQpdLJiGU4NL8GdnNRE7Qs0xGMhBM8An29ki1owm4aJrc6xzdr
         mj2WH2OuJbJPCiIruuFDTJxJ8BmwSeF0JF6zQYIu/P3wifyMxkt5iRZbose/OqZ8G8AI
         /s2+ZU19/BUdkoAYMuuczqy8ZkC7WlkrMLNSvPUT3j+uwRsSgeU67im/EIAC+PZg3IId
         4h1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BKX4i6UhtdbagXTE8rWIuHmxawiMbBsl+I43GhvcqbE=;
        b=6jnRpB1NsPBNiU5fmbABUnBghMicOi+eNA3jXi+AZTZFI+da3KnnQIJAqtmUN6AL5R
         MXe7fMc4DMfWn6ZMmYJguN/nSj2dEjdMdwdFvGH4hB8Gz7leWlOppZntlbWP+cXaoz0+
         XZBwacWM7/GtywMsS+bUmAGOv5BfYhrKE8Yh6WcZV9Xy0lmaEGsRHfYob8SYcUbdh0DS
         D+vgPyrMz6yVOCAf026Kh/8OpaqsS15Gh21xJbDIMDlw/Sy/f0Bcw+BScdTQz7ELlONS
         lUNfI9GCWRylxMEGFm+xfKCEmgoglzYiWkcuXmStXkbxIbBCiOWdBBHYYhlWHpOmkxMo
         HeOw==
X-Gm-Message-State: AOAM533R2N8DQEfh6QFQLSDuv8+ixnT62WrXRMXGqzgW4mM/DMJI8vER
        rIRU+J9yhO2Va7ZTSU3xcjh5Jlv/BLM6Py3glFqiRQ==
X-Google-Smtp-Source: ABdhPJwAs4XpdV35RXepIGWvBpWRbX0/Q9vTJwfWIt9Y4+4qCniz1Af2o5VxYhnfU3bYgS1wv/yMI9i1hd8cydEtTAo=
X-Received: by 2002:a0d:dd85:0:b0:2dc:5589:763a with SMTP id
 g127-20020a0ddd85000000b002dc5589763amr559815ywe.278.1646844092652; Wed, 09
 Mar 2022 08:41:32 -0800 (PST)
MIME-Version: 1.0
References: <20220309122012.668986-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220309122012.668986-1-vladimir.oltean@nxp.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Mar 2022 08:41:21 -0800
Message-ID: <CANn89iKQt2jB8WthN9h+rTogNYjULznyccLXMHhLiv__Qyygyw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tcp: fix shim definition of tcp_inbound_md5_hash
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
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

On Wed, Mar 9, 2022 at 4:20 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> When CONFIG_TCP_MD5SIG isn't enabled, there is a compilation bug due to
> the fact that the static inline definition of tcp_inbound_md5_hash() has
> an unexpected semicolon. Remove it.
>
> Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks!
