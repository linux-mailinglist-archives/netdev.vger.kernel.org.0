Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C31C461C
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfJBDUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:20:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35427 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfJBDUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:20:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id m15so24572872qtq.2;
        Tue, 01 Oct 2019 20:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3efpfs9sL1/jMPSW+62FKUauwr4+fAsqJKtdAl4Znuk=;
        b=OOnxpEhNAewa4hDSxdaIuGOMrRwwISKvSnNw/D/bO+aQn5BWbAQxtzznvLW9Eh9pup
         N3RNjc2mcJmzCojIF1aMtWZwkkUg+TCdNBrsXzGDaYgQAAP9alE6JaFWTg1LV2y7iSLm
         euecTyJrb68l8FGWN0TsCQMRbtnJ1SEEUdiprZ/0y7UwC1sUekqGEEskFRwvtEEd6a3s
         e83Hc/AEK9KPRpvqaYi+QVZEHWW0Rx2h3Ji6ZO+LKGLx4bVXYyhil0jGdzKQnQpmYx67
         NwJImDtWql4ihaitq+RfoQSjgNOT1j+c/V3xfxDNiv7WLi+1Qm0qlrIScGSN9k5bfX29
         2iaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3efpfs9sL1/jMPSW+62FKUauwr4+fAsqJKtdAl4Znuk=;
        b=Y0OwNSJSy+rxcXOeTiExsTPljI2/PMpeq6RUlyl++lUY6j8/ZQsbBbnWh5aGE5CYiM
         prQuEyBsWgK4bvxdxoRqLLRWJXR8YofCWDeo5Y5bOjZv/M16HCmF4HVzcru/e8EjfzOv
         0Z4PQjgMl5sfgHwY+HaXnIcgoIDN/qf4IT34/Q3SCCzcO2Xf3UkFXD9Y/FLTo8080Z7t
         Usr4NUzlyvbPiaF1Xogf9bJMoI0lUApBszJB861+uXa2bG9j/DfH5Q0V9VaFakxMgmHp
         HJRzcdjuLWdQSr6w2Cl1JyASWEJk8lSmzahbbx0WZAnv1f0HHYOlfJZlKfmcElB4S3S9
         3u7w==
X-Gm-Message-State: APjAAAWADIzxr7hcAB/QnhnwP1NAOa8Mu9IEU2fu0ZM5kJ0h3/bFTLyz
        V6wFc6V1KHJlZ3VPKzjgQlOK6rXN8HKrubAZ4PY=
X-Google-Smtp-Source: APXvYqzOm2BoB9dmMXQqhBxSToBiMgwzyvrvr6ybB7GR7rW1AYzevtXVB1nJAt4rbKfkIuonpEm5+19tVuMwd/v9v4s=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr1862596qtn.117.1569986418840;
 Tue, 01 Oct 2019 20:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191001173728.149786-1-brianvv@google.com> <20191001173728.149786-3-brianvv@google.com>
In-Reply-To: <20191001173728.149786-3-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 20:20:07 -0700
Message-ID: <CAEf4BzYxs6Ace8s64ML3pA9H4y0vgdWv_vDF57oy3i-O_G7c-g@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: test_progs: don't leak server_fd
 in test_sockopt_inherit
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 10:40 AM Brian Vazquez <brianvv@google.com> wrote:
>

I don't think there is a need to add "test_progs:" to subject, "
test_sockopt_inherit" is specific enough ;)

> server_fd needs to be close if pthread can't be created.

typo: closed

>
> Fixes: e3e02e1d9c24 ("selftests/bpf: test_progs: convert test_sockopt_inherit")
> Cc: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
> index 6cbeea7b4bf16..8547ecbdc61ff 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
> @@ -195,7 +195,7 @@ static void run_test(int cgroup_fd)
>
>         if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
>                                       (void *)&server_fd)))
> -               goto close_bpf_object;
> +               goto close_server_fd;
>
>         pthread_mutex_lock(&server_started_mtx);
>         pthread_cond_wait(&server_started, &server_started_mtx);
> --
> 2.23.0.444.g18eeb5a265-goog
>
