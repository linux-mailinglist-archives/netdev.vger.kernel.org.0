Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041139B71C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405065AbfHWTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:35:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43807 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391410AbfHWTfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:35:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id h15so9847389ljg.10;
        Fri, 23 Aug 2019 12:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aw3zWTPY1Pke/iOZ2U1o3XSdWURhVQgfZ0MVHQIKkKg=;
        b=Xgabrn6LL5ii377noxysSOEasJ+Oe11TxeuTDk0407tRi7YMTDMJghg8lTrVJ2n7bJ
         aqUR4dgUl/gLarJl4EzDHgrxD0P13c4hrfS2hEWNCFczJHvLT7jS0hgX817VVls2tzVi
         Lsg0ZbZ/KhegObqfEum4hA+BOcnNPWcc1ZME91JMlcqKpNj1yQtoEXRkH1hg6d2fgsHy
         Sr6J5Axhu/vTtx6Fe+SrnXZLjHYpWbBuQVw9y+hHhRpAf7Wq+/YdBtjoy0H2/I6y2WDL
         MFvT+zCOZhpkSXGuzJZfTaksExIivK2kEH34JUmTAyJjMxVp7hnsbeqlNcVLO3boeKMD
         ipLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aw3zWTPY1Pke/iOZ2U1o3XSdWURhVQgfZ0MVHQIKkKg=;
        b=lm6pdfN/G/MVX4MqWSSJZEVMZsxmgWLQMGd8BUGJsHEFDJ5DG3zAPXbgZmES+ILAUw
         WvaP5n9Ka4UXFHeeg+fcrQUjyVjD3Fe/aNhqABZ+yha4et6hPYDK4VRCd7nr1xrNPyEf
         u4DODQCSGAT3O83CkDtj8mEHMq1nV8MuNp73jQoQSmAU49snOtvxcIeexTOnKCI3ENKX
         3eOP4TF1W9PztYlc74tS+nCavBd5UPgtPJc4bVg8LkvrAi8orCPYuNjur+0hD8X+de9b
         8OrBOJ/3SpRkh3u8n4Esp7DbyPwxNULfdjcsIiybQBbsz9DOkmCTUGt0MPlfB0bZIV+i
         OLeA==
X-Gm-Message-State: APjAAAVk14LfxxdgHI/pXvFJ6yIWCFFvWAi1dDPn9Hb0BktJuA0rKx1J
        sq95pmFM19c55A43ERo7H2z5NUGg17jh38VD0zY=
X-Google-Smtp-Source: APXvYqyu5XocSpMCv9Ma3zoKfOodjMtuyXKtqzOvcYasJ6a10KwB5/pdgE+yCvCBAmtozRI4n93M0cplMxbj/gV57fs=
X-Received: by 2002:a2e:9252:: with SMTP id v18mr3917894ljg.93.1566588919507;
 Fri, 23 Aug 2019 12:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com> <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
 <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
 <20190813170829.c3lryb6va3eopxd7@willie-the-truck> <CAKwvOdk4hca8WzWzhcPEvxXnJVLbXGnhBdDZbeL_W_H91Ttjqw@mail.gmail.com>
 <CANiq72mGoGpx7EAVUPcGuhVkLit8sB3bR-k1XBDyeM8HBUaDZw@mail.gmail.com> <CANiq72nUyT-q3A9mTrYzPZ+J9Ya7Lns5MyTK7W7-7yXgFWc2xA@mail.gmail.com>
In-Reply-To: <CANiq72nUyT-q3A9mTrYzPZ+J9Ya7Lns5MyTK7W7-7yXgFWc2xA@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 23 Aug 2019 21:35:08 +0200
Message-ID: <CANiq72nfn4zxAO63GEEoUjumC6Jwi5_jdcD_5Xzt1vZRgh52fg@mail.gmail.com>
Subject: Re: [PATCH 12/16] arm64: prefer __section from compiler_attributes.h
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Enrico Weigelt <info@metux.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:12 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Btw, I guess that is the Oops you were mentioning in the cover letter?

Pinging about this...

Cheers,
Miguel
