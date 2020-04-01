Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E926719AC90
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 15:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbgDANSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 09:18:39 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37995 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732651AbgDANSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 09:18:39 -0400
Received: by mail-lf1-f65.google.com with SMTP id c5so20432945lfp.5;
        Wed, 01 Apr 2020 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gas058aqK6+R/Ga1N9ekMQIN3LpYhng+FzKXcG+s1xo=;
        b=MxAcpSTXhRRPml3perHEIkhBVICR+NnBhA+nk6CnYL8HJ7PiuaVnTX3sEclcUac7G3
         BZNRonT8GMtc3uMkYJLgvB+Cxb4WUWYDs94cYf8WRyk5z8nmTkisW1BV7k/sWkdtW460
         xHK6gw1yJEL2xcncljcOihooVW6Gjim9kyLhsI8GfPIjmzlgE1lugZhKyuLYGuytnVtf
         y+1HSJdPGfNwjrvczHpo8xRmx1L2uQbkClP3EVzOmeYW+3teWTB8dDBgxynbYAmsEur+
         ZX63MwB+y1masuUq4gV+irp5A7vFUnqGWSF0kewhXVIWAh38zVzUL26ryyWUG2l9xslZ
         Gfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gas058aqK6+R/Ga1N9ekMQIN3LpYhng+FzKXcG+s1xo=;
        b=LHFqazMD/0DXQ50EjopnC9ggCfYWRO96V7hFPfTLUPAiVTY4IZmOQMa2kOaw4LMbSC
         bHb7tRWqOgFOMhhga4dEX5asEKUNc8b9RHJACUiK892akArhLMxjGf6qyYzijjxl+DoJ
         //NJ5i3S3AZISF7RcexR7mGg24I1xYTHvhuochLGUcev4dylpSKEyyk1gXU2uVuv46sX
         MCbevO/EEfRpyhmSzvTTWJqrudDG3QQSyAOx4YSoDDV9ftfwhfNCL+85YthYu4EDB2Oo
         bxc4zX16ir8IRxWcBn3lY89QtulQA1LUyg8XDpRehbpC2UqzjISx0YbE+lzRAgrVn+0T
         3VUA==
X-Gm-Message-State: AGi0Pubje69LAmz6mZJ3dEbJ0/jyppoAdciV0XVD6e3c8JsS8uWk1v/Q
        5bBRubrc0H79oaO6mVmaPJaJuclCfjl1b+t1Ap4=
X-Google-Smtp-Source: APiQypKvOPXALPD3SSV84Pz/SnUWcazAupS1BDPa+13hD4YVMP9IRrZj6C/ODuwzqTq+oio/Qu+jPtU/Sdqh60+hl54=
X-Received: by 2002:ac2:4a72:: with SMTP id q18mr15020714lfp.10.1585747116686;
 Wed, 01 Apr 2020 06:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-10-ndesaulniers@google.com> <48smMS2jDxz9sT6@ozlabs.org>
In-Reply-To: <48smMS2jDxz9sT6@ozlabs.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 1 Apr 2020 15:18:25 +0200
Message-ID: <CANiq72kT9iYueBp58PXKgLCvBU+2PsgJ9VJ1xOVTw-srdwHtgA@mail.gmail.com>
Subject: Re: [PATCH 10/16] powerpc: prefer __section and __printf from compiler_attributes.h
To:     Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Geoff Levand <geoff@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Wed, Apr 1, 2020 at 2:53 PM Michael Ellerman
<patch-notifications@ellerman.id.au> wrote:
>
> On Mon, 2019-08-12 at 21:50:43 UTC, Nick Desaulniers wrote:
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>
> Applied to powerpc next, thanks.

Missed this one from August, thanks Nick for this cleanup!

Michael, you already picked it up, but you may have my:

Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
