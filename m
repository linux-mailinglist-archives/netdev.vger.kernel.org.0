Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925681ADF95
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 16:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgDQOMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 10:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730750AbgDQOMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 10:12:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD9CC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 07:12:42 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r26so3173416wmh.0
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 07:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/44fHfeT0vfmqhRxiWIYSCEjdEg71ubrEYZTwq/vFU=;
        b=pr7+2QAzLU6nf8lQveKbv6rbRbzzpUcojJjZq5v4dclZyTpiF20yVUwMGvkpvsJgA/
         0J1QskvvJyT+lKm1/IjvbW8xRm5pkQAiDBbBHhGrVj2kuJpPGlBsgxixxCUKxhHym68H
         4Ugev9p701PVpBntOl5PHcS8X0BqfXfTl7UwzD5VsONtzhnVo9/VmeMZLotszThcL7oz
         rVjBVzVgBf38u3bTvI56POX6QdIgGKuYRbJhLLyUS2JTzYbNXBv5rksoPhCdRv5B+Kqu
         VJQd1xhfqIzIMKilzFf5WSp87v1FQ7QVmBwTJdBydfY7D0v28iCCtK3Y7A99eUYiqXii
         +ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/44fHfeT0vfmqhRxiWIYSCEjdEg71ubrEYZTwq/vFU=;
        b=DzSxPor0MdGoym7cK4MiYFc+RbcutxkUKEIsLaP6Ekhw2Z74hHqbAmOhPVk1TlwKb0
         g3/3JpVTeWErfB/mrfXfJ1AYE31vMd8kk3IVcKkuyxFUwkq5cfYeSJpWhDWbdr9ggF7z
         LZxu9OfZHNrG3OgvqKRAhNi9ETXkgLwgjYCkz0mwXMczo13l8jeZeTy7IORbEJ4se8/C
         HCPfyx+Y6LfzWeVqtXpazGGJx/KwIeDiiCe61BSOAdbSMSyGpJNrIzLPU8pV9JITx4Yd
         BfuEl1D/tNWvd9bfyuDOMDzJhy6uONwjxfkfcBiBjyhPPj4U2IPLh/BZF/x1qTXK4Igf
         rNIw==
X-Gm-Message-State: AGi0Pubn1yPV23UsR26dQWPUJPLb0wpak2Syf3t/aiYLd+Ku9neBMP+0
        EEtDITioC13CI+9IBRe3zKlQbMGk5leDkDD/pU2r6w==
X-Google-Smtp-Source: APiQypLESx/dLglELb11vlwRBoKMT1Gug76xJ93Gg87GkcgLk2dXFoXkTe3u37qKqqt4PpROoLrHroUMfWobD+rH0fw=
X-Received: by 2002:a7b:c1c4:: with SMTP id a4mr3743420wmj.86.1587132760509;
 Fri, 17 Apr 2020 07:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200417141023.113008-1-edumazet@google.com>
In-Reply-To: <20200417141023.113008-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 17 Apr 2020 10:12:04 -0400
Message-ID: <CACSApvbQ-Gbi3UOq_=eB3L3-3abruFiN5_7xfCPRJifTzWQZDw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: cache line align MAX_TCP_HEADER
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
>
> TCP stack is dumb in how it cooks its output packets.
>
> Depending on MAX_HEADER value, we might chose a bad ending point
> for the headers.
>
> If we align the end of TCP headers to cache line boundary, we
> make sure to always use the smallest number of cache lines,
> which always help.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice! Thank you!

> ---
>  include/net/tcp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 5fa9eacd965a4abd6a4dd5262fa0d439aa9fe64e..dcf9a72eeaa6912202e8a1ca6cf800f7401bf517 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -51,7 +51,7 @@ extern struct inet_hashinfo tcp_hashinfo;
>  extern struct percpu_counter tcp_orphan_count;
>  void tcp_time_wait(struct sock *sk, int state, int timeo);
>
> -#define MAX_TCP_HEADER (128 + MAX_HEADER)
> +#define MAX_TCP_HEADER L1_CACHE_ALIGN(128 + MAX_HEADER)
>  #define MAX_TCP_OPTION_SPACE 40
>  #define TCP_MIN_SND_MSS                48
>  #define TCP_MIN_GSO_SIZE       (TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)
> --
> 2.26.1.301.g55bc3eb7cb9-goog
>
