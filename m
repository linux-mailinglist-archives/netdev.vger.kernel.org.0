Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5723F0420
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhHRNDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 09:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbhHRNDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 09:03:03 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF9DC061764;
        Wed, 18 Aug 2021 06:02:29 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id f15so2127287ilk.4;
        Wed, 18 Aug 2021 06:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MkYUY8hRWwEu70DXUFF8siW38IO889EQpcP0JG9olHM=;
        b=p816tpeNXiyVNrHjM3CLMARaTaQ9Q1DNkBPMF5S/QiTyS8TtyNuS4uSDtOvWYkZ9DD
         KQs/VrSCx51qbgHOlhlqY+ZKamKhLS30a7nBa0Wn0WLKywG5EDsLvKzBc8Q5yqbovwVx
         JjTa60sLtZoqpUSmCE3n0/wVzWzMxMTWIHpNstWexLoJOQJ+OxMi+XyB3QXEwvmEN+f/
         wXa6Legda4Ugp7uCGvf3V1ZSw2wJsDe8AJmzt4yb1ib7Fzm5YmC5TfAcZFARVI54/XV+
         DmeEiBYBUtdGwSDq+flIDrO71sP+aqrSrFvrxjsUFvpe0gY8Pan4eGGNA/tuXNtoplKZ
         TcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MkYUY8hRWwEu70DXUFF8siW38IO889EQpcP0JG9olHM=;
        b=qgyZfoyFiYiTL5aNMFzViUyirAFPjdNqfFHKkBf2bU/EzmJ+wTdpbyu9Bw+i8VKva/
         q6TeUZ04Df5USQcNsP2npho0jlnK14yN0B7oYgW5AX9IE3RdEtaU08GFL8607ZVHQ9jb
         /T1P2sc/WgsxFLOUpyh9hiXoqYQgpXmKo4TpAJxm9xgSoRQft7DePq4SODjn3aZgGkF+
         LSnCXL52DPQOr+7zuENVVeevW+yVYj2A4BB1F3ZmYqsdZqp8FseYuhpwtt+GujmZpOBV
         xQbsiIeP4na7mUt8mIC4fk6mMovDg8N9BMTYwpvKhYF+WpKZBSvJde+Zbf6Th3/YxDB/
         YjFA==
X-Gm-Message-State: AOAM531yjGirPqgC5Pmy+20FI+k64n1Y2TiZqUuaCOD8E2IjMCINULZu
        TV+cQofOABemlc0ZqbSBZQLtOVxR9l3het95/us=
X-Google-Smtp-Source: ABdhPJzz3GCPM+tS9a6+M7GfZUygskgS+S/HcxGkyNlHvv5PJSFF8ixpr8ONuLYhcpUTCbKIGIlu3ps94hS6aZMTaMM=
X-Received: by 2002:a92:b711:: with SMTP id k17mr6012067ili.247.1629291748768;
 Wed, 18 Aug 2021 06:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-26-keescook@chromium.org>
In-Reply-To: <20210818060533.3569517-26-keescook@chromium.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 18 Aug 2021 15:02:17 +0200
Message-ID: <CANiq72mQQuwfpFdxeJQoKnfpUFSPuakHRm8RC+eH-xECBjwDkw@mail.gmail.com>
Subject: Re: [PATCH v2 25/63] compiler_types.h: Remove __compiletime_object_size()
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Will Deacon <will@kernel.org>, Marco Elver <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 8:14 AM Kees Cook <keescook@chromium.org> wrote:
>
> Since all compilers support __builtin_object_size(), and there is only
> one user of __compiletime_object_size, remove it to avoid the needless
> indirection. This lets Clang reason about check_copy_size() correctly.

Sounds good to me, the indirection is making things more complex than
they need to be.

Reviewed-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
