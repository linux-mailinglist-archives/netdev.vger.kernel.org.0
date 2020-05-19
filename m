Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57451D9CEF
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgESQgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgESQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:36:35 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7DDC08C5C1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:36:35 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id e125so96192lfd.1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z16ZFiLRHWlE76l/Nnyd5FZZ2VSBLxmf0lz5LDCxbPs=;
        b=UORYpGfRWpAQPT7Eim9FPjPnn5GKxiDiyP2S+AQw0QYKUVeSC2Y2buNVi8EbpRkorO
         IcT1mnMe0MchbGIuyrDccORk12Xm6v8WUDLE8lpsgynSHzLIn9GW5XFMJoAg1fWLV4X4
         DbGGa/kxryZV9vtywESRiuCWoDlSmVvuwa5YA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z16ZFiLRHWlE76l/Nnyd5FZZ2VSBLxmf0lz5LDCxbPs=;
        b=nkPIuCVtrOg5fuQXjLkmplSj+NX+BRKYVNM7yRKIpItE2e8Mr/tV7eeUZJwju4Ti8t
         svrNnGyAyV6XCnTTTCjp1W9X6TrbhdSHM1GcmVGtR2u4ZetcwhqqvNiRj4nZljj74xdh
         cq2e3iOYZcXu4rKdwlbDruTAr3kUfcbCFvw7yaJTVtainWWKftXGz7VRfhERL0ecagVC
         V3CVs3WF0R2jrLoYF2Kys4l73szLE3jwFK7gSiyXrEreik5a5Jcofp4co4heCpWC6D5K
         XTfEIU4BKhZD3qlEcVEUka3jgkp8y0Bd0BB5iWDP39FGLdZBatsR2T2GIOT1qCc6kDKG
         w9FA==
X-Gm-Message-State: AOAM533JBnJkYNkoLdCSjKArsbn4eB+DeJLwrtWdUT6t9MMYKqy6D7Ql
        csp2ALKG0iS+/SmWTxgzmLphwJTrV8A=
X-Google-Smtp-Source: ABdhPJzoVnkxncIZUbDj8JOOqQSu+A/NozPEz/vdL+BSP4t19zo/m/UJCUuxWE8IK+6PV9VuNmiAzg==
X-Received: by 2002:a05:6512:411:: with SMTP id u17mr3750323lfk.106.1589906193296;
        Tue, 19 May 2020 09:36:33 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id k22sm60583ljj.85.2020.05.19.09.36.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:36:32 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id u15so443629ljd.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:36:32 -0700 (PDT)
X-Received: by 2002:a05:651c:1183:: with SMTP id w3mr156059ljo.265.1589906191917;
 Tue, 19 May 2020 09:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-12-hch@lst.de>
 <CAHk-=wjm3HQy_awVX-WyF6KrSuE1pcFRaNX_XhiLKkBUFUZBtQ@mail.gmail.com> <20200519161418.GA26545@lst.de>
In-Reply-To: <20200519161418.GA26545@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 May 2020 09:36:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjcmfe__pphtjGzLMJ2kFN0ZTRZQJQVunRxL+9E2Xki=Q@mail.gmail.com>
Message-ID: <CAHk-=wjcmfe__pphtjGzLMJ2kFN0ZTRZQJQVunRxL+9E2Xki=Q@mail.gmail.com>
Subject: Re: [PATCH 11/20] bpf: factor out a bpf_trace_copy_string helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 9:14 AM Christoph Hellwig <hch@lst.de> wrote:
>
> I don't think we need it as the case of
>
>         case 'a':
>         case 'b':
>                 do_stuff();
>                 break;
>
> has always been fine even with the fallthough warnings.  And the
> rest of the stuff gets removed by cpp..

You're right. I read it as a fallthrough because as a human it looks
like there's code in there between, but yeah, the compiler won't
actually ever see it.

So scratch that objection.

              Linus
