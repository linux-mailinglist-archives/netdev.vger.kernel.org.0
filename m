Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA8B350832
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbhCaU2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbhCaU2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:28:32 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDF4C061574;
        Wed, 31 Mar 2021 13:28:31 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v107so17524854ybi.9;
        Wed, 31 Mar 2021 13:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1j1PU+MK+vPPNX2JOYj8fQyXXoleBhkUFPOd0Ew7WA=;
        b=itZ9gmZztMqO0iElY1EUDIGEstqsIUKWgZcI4UEdxEoeJKyzK7P3Ls7zByiT27aqSN
         wzlLrmodMQ0cSDg55q8LvyMPYEqelBJdm+veis1skvRzsZ4p4PPZFQhiySm+Wp1eBshU
         uV+WQGPKIWeCDEcZebkT25MbCR3AZKOK8IE87tLDlDXuHo6ER+iD9+POZdX3hxVMvyb9
         4KZVraGuYvqZFW4DbqjU93fSOS+XWaRuYjo5H67tPRK8uKq0dCYTSDqoX09r8fLI2K7W
         R7lQZDiavc9kEO/0xGlrQ1VinNXCPo0aqSulYa91FQJqFu/Mljd9p5w9gviY5rBzSEkW
         KJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1j1PU+MK+vPPNX2JOYj8fQyXXoleBhkUFPOd0Ew7WA=;
        b=GI28XKRG8KSUEg5bNOf+yI7ei2GvbiqNqZm8Rixe0HOfGG+ysTWzeCYejIQarkX99y
         N60Q2ArnZG3Jib8/tuMlXOWPr7JSo1FkQUdfOKQgpagBzuxictBVL6PcgQO9emIGdGkw
         wpYoT9KFwNIHjLWvBlIKFVlvoxsXpX2T+97f+GrZZwptCYxvdOho+ubYvzyA6lSt6GC8
         nhper8kMNY0+37c3bOV3/kZDGXVGcAPbX7GkhDS7l3svHC9RbPun3PXw+gNUf3eEIXQs
         dbaB5lr9S0EUE+tYXsBTxMCf1bZqBu3zh/5+/68BoIAnRslLQMp+VNgxvqoKQSyLVcXi
         f6FQ==
X-Gm-Message-State: AOAM530JYki48LQHTcHUDzr1Sghmh9rElQs9tb6zAjhDPrFfb9dkszV7
        T/7RMMX8hSYk5Y6e1lcxhIWJ2ef1TYI4XtbrBwQ=
X-Google-Smtp-Source: ABdhPJxdxeFOiyURPQSIMmnoW9px9Ns7MkwNO5/ovEcTOx5n2D2VwxHDuJJVnrsJklemQ6IBONO00/ewQ4BH2Frcq/k=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr6695693ybb.510.1617222510954;
 Wed, 31 Mar 2021 13:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210329223143.3659983-1-sdf@google.com>
In-Reply-To: <20210329223143.3659983-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Mar 2021 13:28:20 -0700
Message-ID: <CAEf4Bzbd4GnWVvLNUHJJL_EnncgthFi_z6ar+tELgdVKxH4DUQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] tools/resolve_btfids: Fix warnings
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 3:34 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> * make eprintf static, used only in main.c
> * initialize ret in eprintf
> * remove unused *tmp
>
> v3:
> * remove another err (Song Liu)
>
> v2:
> * remove unused 'int err = -1'
>
> Cc: Song Liu <song@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Just in case the bot skips this one. Applied to bpf-next.

[...]
