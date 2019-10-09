Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8DBD1C2D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbfJIWtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:49:10 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44044 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730815AbfJIWtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:49:09 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so4106376ljj.11;
        Wed, 09 Oct 2019 15:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHjWwqWXsAoaMWH3nFPRAmOyjteP4UWyRPHEWny0YHE=;
        b=MpU7Gc2ZhlrxOzRtW/Zpvbdpj/1Y2inmDQ5utuRRENmcWZmC7Wf8X3R2bKFEKqhAOj
         4jtDgkUrz4eyTLf1xiXNbsqomUIGcd1jLKdCvULzBCLnQiqR4j6cS4/ZfX7WuGqhvE1W
         3klPqb5QTCLNcMfySr6q0GRVm0Ivxnf7SO6N/XFJrJhQD9I/Z/eInX0O0yByJlF0WPzZ
         YM/wEGMdoRvj3Evkx7jKR4TlP2xyMHzuWWM5Z6NCdj7t2ykO+0ggV6Kicrqe3gSDL+lU
         cAtqgWU4Zk9RCjzDxlgK9e3cI8dYLq6gRCkGz0h1eCIZ+MJ1ipllwSgQw4JJlUpaZIVz
         ZTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHjWwqWXsAoaMWH3nFPRAmOyjteP4UWyRPHEWny0YHE=;
        b=P6bDpQ0APIZsVtsyAoz2PK3B7jwGSVO8L0qLSGTUa0ZzM7HtjqIGLnms/XlYXm/oJA
         +KvQ0uNyn5eOHpD+XbIF5F5EdUxLCcme7bWs6IOrFqbp5F/titHfLTbIbzk0BgsCmYEB
         EvkW1Ji9ZV2TPcLaJ7f+pqPrXIUgXTo6YUaFLkxc9djk4Celz9Sk28w3o0k0Q9Y9KiS2
         7NiOysYqoCR/Vem/zY/Y9S/9WwmuJk5CUkqSDClDq8OPmOvcUrnLucSVCtXSjfCBB+zt
         JKSL0oWP7epgevOBYqQOY4UhM6uIcaS6Ne6mMIQp0lzNvuhiH2y8WgVZby3t6TziMvB1
         HFzw==
X-Gm-Message-State: APjAAAV5lfqneymJSaiof7XGaRiG5m6TMnVdWKo1tZFPk95BuPWUFQkW
        63yk5ElZvAyWZHGDnK+n5oB0gyM7LH6mzdbvEw4=
X-Google-Smtp-Source: APXvYqyYFVKhfJgkBLM+FG8JpPoNMl7il25wV/lkiHuiAUHcpBVcSBs97/Oozk0E/tnXyIzdqBlKARxsOAuVgtlVWvE=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr3944269lji.142.1570661347632;
 Wed, 09 Oct 2019 15:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191008231009.2991130-1-andriin@fb.com>
In-Reply-To: <20191008231009.2991130-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Oct 2019 15:48:55 -0700
Message-ID: <CAADnVQLYmzJhhkJknYHBaf0LEWq75VfT6cCg-QEj8UfcE8uBGg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fix BTF-to-C converter's padding generation
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 4:12 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Fix BTF-to-C logic of handling padding at the end of a struct. Fix existing
> test that should have captured this. Also move test_btf_dump into a test_progs
> test to leverage common infrastructure.

Applied.
But I see some build weirdness.
Probably due to some previous patches.
Parallel build in selftests/bpf/ is not always succeeding.
For this particular set. New progs/*.c files failed to build the first time.
