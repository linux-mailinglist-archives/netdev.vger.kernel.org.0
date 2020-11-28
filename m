Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F018B2C743E
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgK1Vtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:50 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:36441 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbgK1Slo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 13:41:44 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ca0b12c3;
        Sat, 28 Nov 2020 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=VxXDsIepi+eAd4xKb3U67HkBsHg=; b=Yc0hZL
        6jx7GcAZ9Zc+ZKaMPi/AwDBReO8Kg+hbdIgLsby4m64EpN3IWfCCrjhNVSk/Rqev
        Mu9gByATG7yn1gtWEPBID+O8VbrVX/+2dgeEpvHOMJmXEblJu8Zufa+7aKVcJ/Iw
        +ChYqqi9xZzzLuPixz/5crETi0eRgJqPmr+NRFY+w+srP/78zIoQjerKkLqf9w24
        vuHzu2YvtC+w0iklspKkcMmk0uv2wqYkn2ll3i4jBXnXAsrzW46JViHc/1zhf38Y
        rKanxXX6hhpSRPtuSU+K26h67XWsFWkW5Ct6dTO3qhxZaUsftO5j7INFdtqiFhpY
        rIlTnLtW7m6z2q7w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4a4d0eca (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 28 Nov 2020 13:09:04 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id e81so7011644ybc.1;
        Sat, 28 Nov 2020 05:14:20 -0800 (PST)
X-Gm-Message-State: AOAM530qYvHsg2yrzSbMCAgkDFxCj2TATba1Pgw2Kpa36AjhdIHCJzfC
        7kubtgYf9lP3f6oOnnKfwS+jnV0TI9AHhEfPXCM=
X-Google-Smtp-Source: ABdhPJzhpzpgqWtgM7qicLRbtzJzCdlKXMymfS4WuyC7aFryeXdSo+3zP9Yndl2qJmFaSFc5yZt4Oub26GQMTcJIL6U=
X-Received: by 2002:a5b:2c6:: with SMTP id h6mr14695421ybp.306.1606569259874;
 Sat, 28 Nov 2020 05:14:19 -0800 (PST)
MIME-Version: 1.0
References: <20201128084639.149153-1-masahiroy@kernel.org>
In-Reply-To: <20201128084639.149153-1-masahiroy@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 28 Nov 2020 14:14:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9o7uLRRD91nAie48nM=ogNuV9-cwwQcW1dSVSXhjCfWsw@mail.gmail.com>
Message-ID: <CAHmME9o7uLRRD91nAie48nM=ogNuV9-cwwQcW1dSVSXhjCfWsw@mail.gmail.com>
Subject: Re: [PATCH v2] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 9:48 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").
>
> A lot of warn_unused_result wearings existed in 2006, but until now
> they have been fixed thanks to people doing allmodconfig tests.
>
> Our goal is to always enable __must_check where appropriate, so this
> CONFIG option is no longer needed.
>
> I see a lot of defconfig (arch/*/configs/*_defconfig) files having:
>
>     # CONFIG_ENABLE_MUST_CHECK is not set
>
> I did not touch them for now since it would be a big churn. If arch
> maintainers want to clean them up, please go ahead.
>
> While I was here, I also moved __must_check to compiler_attributes.h
> from compiler_types.h

For the wireguard test harness change:

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
