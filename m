Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB466AB54
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjANMVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjANMVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:21:49 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81F27A90
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:21:48 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-4d4303c9de6so169290777b3.2
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1XRB9Z8Nuy71yiH8EPDjVXeUBRtoHs+NvP31YvwCoe8=;
        b=rVYa2xWKYMSKdIlDPT4CH9fgwT3e3nv/iSO1D3Gp2bbhoVgxm/GV8aOZvZDeZW5tLA
         whvdK5uSGxpa4Ui3U2wqXOSntAlD257c4hPdQk/r3oXW2a/PRycAoYPEkcJL+kKyZDmQ
         4iJMWkfIUuRLX9NGd3IiY0A44Qd2V60Wsu70ym3tiH3ouy92Q9/dHSoUuli8ie08w1sr
         hgeznc+rYnWlRJsJ66Rs50hiHySjWkOqHYACxzBob34VhdcH4UQWsCa7jKTAzFxOdLat
         iddW9DhgkRd5rJKqhCqpE+sCuoW1yZxfbZuc/h2eBLkB6X53oXSsXAoGgc0EqMPp0d4n
         jzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XRB9Z8Nuy71yiH8EPDjVXeUBRtoHs+NvP31YvwCoe8=;
        b=3W3s6RuexZixvitNAdTPv8EeDQ+PGvhZUSZjw1YZ7KahByBgGpbuDNsZciJQKaFUzT
         DeD2ncrQf51DKYdvoqDxUDjArEL+KfNnWtqLtCuPUBTuj1GqvjZxJMJslffgEr/6CuK0
         Qc259/fv1ts/SH8JFQnSy/Mfgbu1yMSoBRtiXbKG4RSvnwvylMUZ5WYhJqLSe8roFvNu
         p9Zny4yqPR3N0hZUw5MPPUOIghSNkPne8TtXFaqToxJKwg1Lyy9GFMMlsBnb2yAbq3je
         Ye4bauKUvLahVShrQoXSnA1Db3lrnhz74Qg0tFnmOkKHYeHJcpQuTgW7oe47FkIyl/iw
         /+og==
X-Gm-Message-State: AFqh2koTlUst6xXNz0o5KQ3gciDT7V7sh6x4Vx3o6qv5aPCzJutgPrZ6
        Pr6XNmBluoQCopXDBh5Uu5dDlN4wyLEly8/E1Gncug==
X-Google-Smtp-Source: AMrXdXsAkZiQ9nvWwuLDJi+xSWAqG3UFx5K8zjZMZ/bDUk0Unojd4EwuFYzbXAGl3mgImYtsPOlrj/VTnzTT7RtLIlI=
X-Received: by 2002:a81:6d85:0:b0:3f2:e8b7:a6ec with SMTP id
 i127-20020a816d85000000b003f2e8b7a6ecmr3222938ywc.332.1673698907680; Sat, 14
 Jan 2023 04:21:47 -0800 (PST)
MIME-Version: 1.0
References: <20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it>
 <CANn89iJekPT_HsJ6vfQf=Vk8AXqgQjoU=FscBHGVSRcvdfaKDA@mail.gmail.com> <CAEih1qWQf1JK4vbdzcTb1yXADxTV4+AqtJkvnK1T895obUTtOQ@mail.gmail.com>
In-Reply-To: <CAEih1qWQf1JK4vbdzcTb1yXADxTV4+AqtJkvnK1T895obUTtOQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 14 Jan 2023 13:21:36 +0100
Message-ID: <CANn89iJCphvKBWcV1iGdTe9OXWiv1gQCTub60b1v2qi=pYLoSw@mail.gmail.com>
Subject: Re: [PATCH v2] inet: fix fast path in __inet_hash_connect()
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Sat, Jan 14, 2023 at 1:18 PM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> On Fri, 13 Jan 2023 at 13:16, Eric Dumazet <edumazet@google.com> wrote:
> > 1) Given this path was never really used, we have no coverage.
> >
> > 2) Given that we do not check inet_ehash_nolisten() return code here.
>
> It seems there are a bunch of call sites where inet_ehash_nolisten() return
> code is not checked, thus I didn't think of it to be a problem.
>
> >
> > I would recommend _not_ adding the Fixes: tag, and target net-next tree
> >
> > In fact, I would remove this dead code, and reduce complexity.
> >
>
> This makes a lot of sense. I can post a v3 patch completely removing
> the fast path.
>
> However, this patch's v1 was already reviewed by
> Kuniyuki Iwashima <kuniyu@amazon.com>, v2 is a nit, if posting a v3
> I think I should remove the Reviewed-by: since it would completely
> change the patch, but what is the preferred fix?
>

Yes, remove it, and Kuniyuki will review it again, thanks.
