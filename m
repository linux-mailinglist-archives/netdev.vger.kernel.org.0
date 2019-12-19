Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1806125BF4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 08:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfLSHTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 02:19:51 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42338 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfLSHTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 02:19:51 -0500
Received: by mail-il1-f196.google.com with SMTP id a6so3983210ili.9;
        Wed, 18 Dec 2019 23:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2q1FSVa0f0doX2zqGek/GvgcDuVqa0Hn/ySsyVBQz0=;
        b=USvFYSD6j8zTDVlATeosS2EVD5T9VCMsAsX7ZZ2va5uvbVfgjY3sONdIEkmP4KtlLv
         5H78xGP3fj67/ZFIAkrLX1lPCo5vHc3Kx6+v6VpPA/Oo74nJRSW2HR/DRuFt0bas8vr1
         FFsaKqvZQNTHzhQy/1k3IPXmy+G4asuMRyRGHYCSN5vT5W69bUzfjjsRgzKWBdgvxw4g
         kO8x49vTU3q80Xbze5YG4HmzJrhhZnrfCUSHzoShHHWWL0V7i1+S4M3yXKC35I1hvw1/
         fyiqskaHuSCZG48KEh1YZSws6L7zm7eFIz8g9LSBkVFDuisueGS1iS5S80UPg6+sJZ40
         W+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2q1FSVa0f0doX2zqGek/GvgcDuVqa0Hn/ySsyVBQz0=;
        b=YlxK6Frv0JugofnM/QwPLnwQ+LIuWtHjw9HXQjuL/AMAtkwDytz56Ns4EdljWCbu5a
         yHnRb/C+iWmug8r1rjmJxtkdqR7KvNSsLpH6am5KsSvXPxaFsTuAIHWOb7NNtxBWgJGk
         NHGXMqpNL3cTCatAFwsdeu4n+BEd1NUHFEMumLNhKZaIBJbTBdALfYWmX3Q+B+xf/sFx
         CXoTQ0U0epU2H9yMbwp2wrbLBqtM38OI0Mj2f/CZMXNLwY1tuFwltXvlXUEUBYUjkAnu
         2OVR3lfxAx/ISV2HxZ5Ve7wFc+/UtR1Hdl+cdW6TdfyiPqMTyShZ90YG9LG9uPbL3aWR
         gKBQ==
X-Gm-Message-State: APjAAAWXIZOjNOWrQKraGslXQZItJVZjnE88Jv7b2+JQ1BHCBoHKXuKO
        MqitMhCxw9uVitrItAmuhikx8I34Mp/ZaVknnbE=
X-Google-Smtp-Source: APXvYqyanWekuKTJhhtIfFxahrI2aaOAgb4Gy6Eh4ntVV1xAG0wxgxVtU9vayqWnf6UMXoNBr9o7Kfedxwp3vnybATk=
X-Received: by 2002:a92:60f:: with SMTP id x15mr5634735ilg.181.1576739990395;
 Wed, 18 Dec 2019 23:19:50 -0800 (PST)
MIME-Version: 1.0
References: <20191219013534.125342-1-epeer@juniper.net>
In-Reply-To: <20191219013534.125342-1-epeer@juniper.net>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 18 Dec 2019 23:19:14 -0800
Message-ID: <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
To:     Edwin Peer <epeer@juniper.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added cc to bpf@vger.kernel.org.
For bpf related patches, please cc bpf@vger.kernel.org which is major
place for bpf discussions.

On Wed, Dec 18, 2019 at 6:16 PM Edwin Peer <epeer@juniper.net> wrote:
>
> Being able to load, verify and test BPF programs in unprivileged
> build environments is desirable. The two phase load and then
> test API makes this goal difficult to achieve, since relaxing
> permissions for BPF_PROG_TEST_RUN alone would be insufficient.
>
> The approach taken in this proposal defers CAP_SYS_ADMIN checks
> until program attach time in order to unencumber BPF_PROG_LOAD.

I like the idea to *test* bpf program in unprivileged mode as sudo always
has some risk to break the development server.

Have you tried your patch with some bpf programs? verifier and jit  put some
restrictions on unpriv programs. To truely test the program, most if
not all these
restrictions should be lifted, so the same tested program should be able to
run on production server and vice verse.

>
> Edwin Peer (2):
>   bpf: defer capability checks until program attach
>   bpf: relax CAP_SYS_ADMIN requirement for BPF_PROG_TEST_RUN
>
>  include/linux/filter.h |  3 ++-
>  kernel/bpf/syscall.c   | 27 +++++++++++++++++----------
>  2 files changed, 19 insertions(+), 11 deletions(-)
>
> --
> 2.24.1
