Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426966E1022
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjDMOiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDMOix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:38:53 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3696D5241
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:38:51 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 891CE3F457
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681396728;
        bh=X4kAT0rL5ThCmBYSbgh/zubXsP0GX7YEMqUvRhK1pXI=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=N8d2HsdqC7Fh3QkKUf9IJlXnOeMoRTLPBYjSvm2dKD4mItC5wpewrF64Q2p87b/E+
         QBFjlgq985i3YzFL2OsUp/PfHtEJmq0E0vVVmzss0Z/WblAH3Z95yS8V5JmmQRAZ/a
         QGv6dw6KQZxc31Y9g0dVPFzL9kO4RK8hxx9QELIh9ZNJ+OlZKEwf1dJJECI2WnhMgf
         Of3I4GI/+RUP9mLQ5/2eQwCcIgJ3hubdoijYS+Sfxs4CsZX+AFcoCMNxWS3IF75Bnu
         jtX/vFAP2krkGVmeFkSsXEGUR88StLylwhY1K2bggqzjZ63c9FgW6gL7x2uulZKq8i
         vXNM0ZxyHP3Rw==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-54f97aac3d0so51706177b3.15
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396727; x=1683988727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4kAT0rL5ThCmBYSbgh/zubXsP0GX7YEMqUvRhK1pXI=;
        b=QxiwnNmZQ9mOOICDMbYnduFcAV0Vn6MLSjEf01cbouVi8uPxtUaw2VHj6UZlBL9spI
         G5Os+48wO+k82vcO2Uo4kuH/+j3MUi/ojOTmdxAw4dZ1AQvLjxKuR6+sIPwJtBRu9Y7N
         rVY1JrEAwN0d+0w8uYsplQKNgsTAn1MCieqOPde9ZbRG5IEcrcPnzsHTTE6Mv8S0MI4O
         VCZwoYK34PA51qoS7GZrqT2Nt5qQHaSXWgAK1XHLbkWRMqiYAqxEdjFVNwubY+8RJhRQ
         4qUniCp8QCGpjURzuw99FQgrsZwvdFxEJ6cmppFCS980vDSnkLPTQ0OU9LOCORp/vRTv
         52/g==
X-Gm-Message-State: AAQBX9caK+raBK45PYM52r+vcH6CL5CaTV4lU8ME/G46po6rUl2yBktY
        tzCOKWAcY2nY+UMjMpdy0RLfSvQsv2UNDa6aUJkbQBhTd8OYmLF2OXgaQwptTnuSw03si6FJTGe
        dnBzfFyTn/kc1pQhpkuCu+i0wkGt+zowKbMr4HZ1ox8Uv9BR79A==
X-Received: by 2002:a81:4415:0:b0:54f:9e1b:971c with SMTP id r21-20020a814415000000b0054f9e1b971cmr1543618ywa.1.1681396727127;
        Thu, 13 Apr 2023 07:38:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350bUW5jFJ5LMk7+hETV10BLMcQ5bG69GeMAW8TnltznTEQ5Fc6ojtahmmyRWFbfX1EZ5DEW0r8L6cu9w4KKmRl0=
X-Received: by 2002:a81:4415:0:b0:54f:9e1b:971c with SMTP id
 r21-20020a814415000000b0054f9e1b971cmr1543599ywa.1.1681396726922; Thu, 13 Apr
 2023 07:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com> <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
In-Reply-To: <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 13 Apr 2023 16:38:35 +0200
Message-ID: <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/4] net: socket: add sockopts blacklist for
 BPF cgroup hook
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 4:22=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Thu, Apr 13, 2023 at 3:35=E2=80=AFPM Alexander Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
> > that bpf cgroup hook can cause FD leaks when used with sockopts which
> > install FDs into the process fdtable.
> >
> > After some offlist discussion it was proposed to add a blacklist of
>
> We try to replace this word by either denylist or blocklist, even in chan=
gelogs.

Hi Eric,

Oh, I'm sorry about that. :( Sure.

>
> > socket options those can cause troubles when BPF cgroup hook is enabled=
.
> >
>
> Can we find the appropriate Fixes: tag to help stable teams ?

Sure, I will add next time.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")

I think it's better to add Stanislav Fomichev to CC.

Kind regards,
Alex

>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> > Suggested-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
>
> Thanks.
