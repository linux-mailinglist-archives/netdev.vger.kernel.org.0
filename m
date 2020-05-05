Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8C1C4E48
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 08:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEEGYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 02:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgEEGYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 02:24:06 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB53C061A0F;
        Mon,  4 May 2020 23:24:06 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f13so1295356qkh.2;
        Mon, 04 May 2020 23:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GvwSDAB+7oIwuMIZ/PrvZL92S9HZi97x7jooAff7kQw=;
        b=jby5PrHrX6uqJqq6qXgFM+fktRDSmnOmHbeo+A1THPbGTQejLGR3l0rWoyNvBpi79J
         pV+FTxgsEkfd3yytGtPedlu7vMwMaggWYMmvhtT0qQ1z99uUjkJJlqLKn6yjZmS9W6s5
         /c3W4QWJ5jMzhdxH5oW4IQvCQvaGKb0rPG64n8TEH+y4UO4g1iz+NIA+u1KK0tmS+U66
         Y4ZInBK5TOKpUVrrVK0C33W7IixPz3vHFTGmiurxeEzTlr5pH/UUbNdMRParueBifytX
         ZJ1H99Qq0NjsBG7zo3gDg0dh/VXuPD55v2P+FAaWcqsCivzM0agz8Lwp9UNYx0Dk5x2I
         x8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GvwSDAB+7oIwuMIZ/PrvZL92S9HZi97x7jooAff7kQw=;
        b=nB3VXLm+sEL+gIGa2gL0HZ/59sRiPRrEgn20K+ik679Fdeet1pCxa2QBjn36YuywPc
         DFIpXwgUIwYfFigq9R6uZh48rlKrtzFZSaTkL0bxas3PScgPKxNuON1szS7vJAuEi7bx
         diKknGunl4BQzvfngNgkc91o2eD/FtuZT+CTDbK9fCZgUxL7OliUvVccz0fwEWzCGvDr
         lfetVPJme5Nxe2FOXr6YzT++/2xwajJogg1OT0WsWbZtradznGTkGgDdax9EYfwxpmt8
         vW00zegjWm/xVcBfQsehDo8uvJEAJlGVs31IZ9qE8UoDu+x203gtNnzR1fRzCMxNHJjs
         3D2Q==
X-Gm-Message-State: AGi0PubTmbx4F6vuIPBSOZO3nFhYLEIqV5KA7uo3hdgqW+g7CYKxlQTO
        yu3r5pT9FUXS9I6NrzpeoUGeZbSd9aJUUbcjeHI=
X-Google-Smtp-Source: APiQypJuvtCDrYiHxDkvzjwUuU85I6Pz+JqkKaSTkMlwKZlqZMUE2l5Hl8S7k/qu/E661/lnME0dhpjxih7f2zlnU7U=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr1982255qka.39.1588659845139;
 Mon, 04 May 2020 23:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com> <20200504173430.6629-2-sdf@google.com>
In-Reply-To: <20200504173430.6629-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 May 2020 23:23:54 -0700
Message-ID: <CAEf4BzahmBZmffPq2xL8ca0TpQPNHZtdOnduhHoA=Ua7oy99Ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] selftests/bpf: generalize helpers to control
 backround listener
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 10:37 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Move the following routines that let us start a background listener
> thread and connect to a server by fd to the test_prog:
> * start_server_thread - start background INADDR_ANY thread
> * stop_server_thread - stop the thread
> * connect_to_fd - connect to the server identified by fd
>
> These will be used in the next commit.
>
> Also, extend these helpers to support AF_INET6 and accept the family
> as an argument.
>
> Cc: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/tcp_rtt.c        | 115 +--------------
>  tools/testing/selftests/bpf/test_progs.c      | 138 ++++++++++++++++++
>  tools/testing/selftests/bpf/test_progs.h      |   3 +
>  3 files changed, 144 insertions(+), 112 deletions(-)

Can this functionality be moved into a separate file, similar to
cgroup_helpers.{c.h}? This doesn't seem like helper routines needed
for most tests, so it doesn't make sense to me to keep piling
everything into test_progs.{c,h}.

[...]
