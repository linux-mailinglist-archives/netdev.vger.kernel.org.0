Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1679CD46FB
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfJKRy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:54:56 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42157 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbfJKRy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:54:56 -0400
Received: by mail-lf1-f65.google.com with SMTP id c195so7631578lfg.9
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LgOWyC4KuQvhExdqsSsy/AfsFX2Dxg7AbZdsgfAmHWQ=;
        b=Q2UkfBZSP0S9e/7OB3SF+XNURSwl+NMXpb0vpdXJQjsdW/6qutIw5uECnuvQSRhIfS
         ceZtY1Swy2zbGPAzUqBps7PsUDeS/0EuPPnU0Fy92rdos/7lz0dqKIiPx08pFFvzsTUD
         k3cf62WY2m182EbDTriMmjsXhjGoXoDCawAIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LgOWyC4KuQvhExdqsSsy/AfsFX2Dxg7AbZdsgfAmHWQ=;
        b=B9VKeyg/u0DWOUysDs2K+n7Xs4AFeXyS2GGaQQLSO5GJABearhRmqdMltvUCwTqQyG
         QllX6N43Nohv4T+l72AOpN1d4VJ1lkPIwv96QfVuXJZ9bp9DvqeVDglAXcUPiOpleqO7
         XtMoXvWU+V53RI1mlPaDCCpKAI1jXmzR3LcH8QqCkuH1Ue6hbjaqqsToHrDNOqBGDCGp
         kj2tT2Skb3ZE5RcED9CUfR/VmCPMJz8O2IriUTcWPSm0LRRzMrSO2M9J3XqzRH5bx09e
         MGGNtsEv6JN26VFU5+SzmKQRbpFEbS1rjoSP9aktNu7wpf1ITIKox4G+z0rnru8HWGyg
         3+5w==
X-Gm-Message-State: APjAAAUZaVthmqcVVHDMgIDg7JVkgxCh7p4WFfeUhArJAKJ4BTwRLwe4
        1gOqiSAci5zj5QCrIQ/jba/h+AaucUs=
X-Google-Smtp-Source: APXvYqwVIkMFmaOPPOxal96AJmAFpH5QmyWty1VHjfgpuMbncohoMwOTKpaJE2pKjEwdlN4ijcGwsA==
X-Received: by 2002:a19:fc14:: with SMTP id a20mr10110863lfi.76.1570816494082;
        Fri, 11 Oct 2019 10:54:54 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id t16sm2019943ljj.29.2019.10.11.10.54.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2019 10:54:53 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id a22so10703684ljd.0
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 10:54:53 -0700 (PDT)
X-Received: by 2002:a2e:6a04:: with SMTP id f4mr9892356ljc.97.1570816006661;
 Fri, 11 Oct 2019 10:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570292505.git.joe@perches.com> <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
 <9fe980f7e28242c2835ffae34914c5f68e8268a7.camel@perches.com>
In-Reply-To: <9fe980f7e28242c2835ffae34914c5f68e8268a7.camel@perches.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 11 Oct 2019 10:46:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1T1m-su8zK5LeESoz_Pgf1-4hnjr516NiDLNyb4USug@mail.gmail.com>
Message-ID: <CAHk-=wi1T1m-su8zK5LeESoz_Pgf1-4hnjr516NiDLNyb4USug@mail.gmail.com>
Subject: Re: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
To:     Joe Perches <joe@perches.com>
Cc:     linux-sctp@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Shawn Landden <shawn@git.icu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:43 AM Joe Perches <joe@perches.com> wrote:
>
> Shouldn't a conversion script be public somewhere?

I feel the ones that might want to do the conversion on their own are
the ones that don't necessarily trust the script.

But I don't even know if anybody does want to, I just feel it's an option.

              Linus
