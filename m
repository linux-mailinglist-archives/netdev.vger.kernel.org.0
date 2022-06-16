Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B84854DA7E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 08:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358682AbiFPGYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 02:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbiFPGYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 02:24:14 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED62237C6
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:24:13 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-317710edb9dso4830517b3.0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBTDIiidxiGPacHBnzCPhaTwdJJ+7f5cc/VqDUVONRo=;
        b=XrpSxZErqhnq3NQWvC8DcoHqifz3mZJzm/QdguNpAAsH/UWZZx1Tv21HoShfdd8B3J
         KJmbuKgn4V9R7HqmY9ppCeiqKIDahAw3VjxKJtJ2+ECvjYYOVbteFVBJGHCYMCbzU8Zf
         ep59J492kZ5OxGJWdt2Mwp1lD90ggBamwLAwwuXW+ExmCT+nJRUie+2ztDTWQKj7Wng+
         CFG4YW+pYaP/ZuenSXy5CIRblchyo4pNu0vkMDyvjfVtKryMuyKGXMfg0RfTL5vETWON
         XuNOXvV7K6wmsGDvgyfp9VVgkt1LQR0BWIQKjVfcY9VNyGCUFicwG0e5uVpZg1RBX8ij
         ifZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBTDIiidxiGPacHBnzCPhaTwdJJ+7f5cc/VqDUVONRo=;
        b=pJQ5sKx0+0JdSYDgEHDTjhSed0cBbRYmp70hPRU7rmxzX7LiLJ9tEI0QgiMVRYd3fZ
         EOp/1i66L4D/3FyNf7FX0qP7E9NRZMKv4C/THTDJl7++gw2nIeIzmn5yims1cPDnx9y0
         F0SM9y9b6nVNWIXKWwtSBPuSk3FJ6zdjxnc1Mt6DqZrJ/QlaV028ct4ni1FR+WDszMX0
         cgKxqkOS00DjCG5AWKvLOgYFJIY6ZbvurlPOyl70r32bYd8dVynbqqE+OezNEQ7MFLIO
         VvyL9Uq8aVFH+a87yPr5SSON/1tZOl+4f7y3CIgeA7DuoPOl0sgoaY2hRwpm18ZNzUFL
         oteQ==
X-Gm-Message-State: AJIora8cLoDG+vDyH63ZqnzBtE8rFz71JGx3yaVqYGy+J/OZt7ol2zib
        GgsWvWWDR2Eo98ZzFqdzWYpNcpEbQikpYe8uIaSSZA==
X-Google-Smtp-Source: AGRyM1sngVtDT/3uiGUlYGn99sOZWbCdFjjIHXapojOB40+P+fsVXoN7YQhP9nvDC/LvjRO4Juw16sGcv3Ouw2Yvmdg=
X-Received: by 2002:a81:4811:0:b0:30c:8021:4690 with SMTP id
 v17-20020a814811000000b0030c80214690mr3897981ywa.47.1655360652655; Wed, 15
 Jun 2022 23:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
In-Reply-To: <20220615193213.2419568-1-joannelkoong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Jun 2022 23:24:01 -0700
Message-ID: <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
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

On Wed, Jun 15, 2022 at 12:32 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> This reverts:
>
> commit d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> commit 538aaf9b2383 ("selftests: Add test for timing a bind request to a port with a populated bhash entry")
> Link: https://lore.kernel.org/netdev/20220520001834.2247810-1-kuba@kernel.org/
>
> There are a few things that need to be fixed here:
> * Updating bhash2 in cases where the socket's rcv saddr changes
> * Adding bhash2 hashbucket locks
>
> Links to syzbot reports:
> https://lore.kernel.org/netdev/00000000000022208805e0df247a@google.com/
> https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
>
> Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---


Do we really need to remove the test ? It is a benchmark, and should
not 'fail' on old kernels.
