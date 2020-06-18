Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975231FFDD6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbgFRWQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731898AbgFRWQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:16:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D40C0613F0
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:16:48 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b5so7546450iln.5
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1SwhXxxcqMA/2xg9WoRLda6uaTbILklISXGnrNM7z5g=;
        b=EV4OK8SyfSmB1iDadMyS6GSSAb/y8zP9pbU0Qq6cW8ldk3zk+IGjfY2mwBS7kzw4+U
         MueNz1lmVzja+fcXE6FnhayjVrm0XuFnJWBq6+5FDBnmi1hHaih73zql3UKX/jPFPBij
         cTvcS7wpwiveD7okKpYA13MpaMis17aHOXQ6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1SwhXxxcqMA/2xg9WoRLda6uaTbILklISXGnrNM7z5g=;
        b=NnepNpGeW0oVp3Eu6zwf7E7emrQeq+iCxDG0vllyojX4xkrlOWQflEQNLUJD4/u7Wq
         2FIoVpMaJ1aY3diEmEwwHBHwcdyYCJL1mq20IP6JIjP/m8n919dfkfA9RNdhTe/aEfd1
         JaJ5WYulvzAIDVqxuC5+yBHAUQdqbPbtvviCYfwf9p8JHFSGPXdIIZfmNsw/xsxPDgN5
         GO0eVLbfciQjVQ/kwLUhL+LUuqTgJLZIlWKSGVIqIU1iVUTsvp6nvYZMsIVnaQ/tyKht
         7KdmWxRXpCmHLy2VHXMjNNF5uBBFYdtmG+esMCZzAjFwiwlr1qCH5r4tEmZuCwAlpm0o
         iATg==
X-Gm-Message-State: AOAM533Ve52zZIY/RNkE7hwMzeBe957htfPhmK3ocwGMQxVzqwNtgS0y
        bRnII/zKz9fruC27iwaNm2DS6w==
X-Google-Smtp-Source: ABdhPJzNjXEHGSDFRIEtFgNEH0DkmyvOyUoU/9h2R+dUGaWvU4v5dYNDSJa/KV3ePKb8DIvlf17A1A==
X-Received: by 2002:a92:d9c1:: with SMTP id n1mr673192ilq.148.1592518607785;
        Thu, 18 Jun 2020 15:16:47 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id j80sm2256501ili.65.2020.06.18.15.16.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Jun 2020 15:16:47 -0700 (PDT)
Date:   Thu, 18 Jun 2020 22:16:45 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 00/11] Add seccomp notifier ioctl that enables adding
 fds
Message-ID: <20200618221644.GA31321@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200616032524.460144-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616032524.460144-1-keescook@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 08:25:13PM -0700, Kees Cook wrote:
> Hello!
> 
> This is a bit of thread-merge between [1] and [2]. tl;dr: add a way for
> a seccomp user_notif process manager to inject files into the managed
> process in order to handle emulation of various fd-returning syscalls
> across security boundaries. Containers folks and Chrome are in need
> of the feature, and investigating this solution uncovered (and fixed)
> implementation issues with existing file sending routines.
> 
> I intend to carry this in the seccomp tree, unless someone has objections.
> :) Please review and test!
> 
> -Kees
> 
> [1] https://lore.kernel.org/lkml/20200603011044.7972-1-sargun@sargun.me/
> [2] https://lore.kernel.org/lkml/20200610045214.1175600-1-keescook@chromium.org/
> 
> Kees Cook (9):
>   net/scm: Regularize compat handling of scm_detach_fds()
>   fs: Move __scm_install_fd() to __fd_install_received()
>   fs: Add fd_install_received() wrapper for __fd_install_received()
>   pidfd: Replace open-coded partial fd_install_received()
>   fs: Expand __fd_install_received() to accept fd
>   selftests/seccomp: Make kcmp() less required
>   selftests/seccomp: Rename user_trap_syscall() to user_notif_syscall()
>   seccomp: Switch addfd to Extensible Argument ioctl
>   seccomp: Fix ioctl number for SECCOMP_IOCTL_NOTIF_ID_VALID
> 
This looks much cleaner than the original patchset. Thanks.

Reviewed-by: Sargun Dhillon <sargun@sargun.me>

on the pidfd, change fs* changes.

> Sargun Dhillon (2):
>   seccomp: Introduce addfd ioctl to seccomp user notifier
>   selftests/seccomp: Test SECCOMP_IOCTL_NOTIF_ADDFD
> 
>  fs/file.c                                     |  65 ++++
>  include/linux/file.h                          |  16 +
>  include/uapi/linux/seccomp.h                  |  25 +-
>  kernel/pid.c                                  |  11 +-
>  kernel/seccomp.c                              | 181 ++++++++-
>  net/compat.c                                  |  55 ++-
>  net/core/scm.c                                |  50 +--
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 350 +++++++++++++++---
>  8 files changed, 618 insertions(+), 135 deletions(-)
> 
> -- 
> 2.25.1
> 
