Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307932218A6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGOX4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOX4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 19:56:23 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF358C061755;
        Wed, 15 Jul 2020 16:56:22 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so2160337lfh.11;
        Wed, 15 Jul 2020 16:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytaQpjODZuVc9Uee/kDsjo9BU4qmKPZ1VYeboHHtxL4=;
        b=VDCK8h3PuFrQReXAOTfw/wHDHpdvNIn8ePbjwm7JbA26N1u8UPy65tYk5xEgxJKaPB
         cooyAQrfADo+ROZoiYuyRJFrLTgZi9K0sAA6f7974Ns+op48LKoEE/mhVAqsD3Oy02ia
         q9+4ZW7x9Ap3lq5AZY7iK4Yob7ufP9/yqtv70ikKDZ8GIgeLLVtAao6iRvR20Vik51d/
         ZYV+g/b1oVMMEZAzkAU6Du/z2YRwDf4MKqngedlh01wJg84wy/1rFmsga17VOqXjOPdM
         kCe82PQjEZJGgLX4hHNX/H+ASKEGYeJkj97T5fi02twGjruNlOyv6VHwMEbmN/bnIP/q
         GwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytaQpjODZuVc9Uee/kDsjo9BU4qmKPZ1VYeboHHtxL4=;
        b=L9MuAIZzdrKiLfi2sPrZjvS+DRK5lMDdIi1CJCPJdWBgiVU24e84qlXyRGEMJriJcU
         2l3xd9MZ/j5OfXlhuntwVHp8YzGieqcPUwL1IysFwjWa2Gwaia0vhKaANen5Wdd7RzuG
         QPdaQgeQ5ptAA46qVW6s6pLLMlKFpVc+RrX6a0eM0loXBIULJg+OXfCqI3CAyIzWAoDR
         WbeAs/lJkChr1wuUPfQGF5qIg/DdRNIh/sgZcLIWuF74DLr5lQHEuBahJRUekDmMK3V0
         Bde2aAsjI8uyDgF9JfflDhM5dGY0/e/cwY4/psZcuIEc/c5bCcl8P5YpHucIYWw7IU1t
         75QQ==
X-Gm-Message-State: AOAM53167quJy145l6H2KiLRsyxJPA1B1MDtfXsmNW3E8RnMmLU950zr
        KhYg9eCrApQBj/DGRG7MnRVCVQU5Vcq+K7olJ8w=
X-Google-Smtp-Source: ABdhPJxqrdPXTYhPVUIZH6RA95WWKE+R5yWn+lMc/yD6TxZXdMSazcJkFIU6n86S2cxr0vhGEY3pFBmf4X6z6wR/eVc=
X-Received: by 2002:ac2:425a:: with SMTP id m26mr685820lfl.73.1594857381134;
 Wed, 15 Jul 2020 16:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200702014001.37945-1-alexei.starovoitov@gmail.com> <e348c97b-bd8c-c24f-9287-f1c5341ddd4d@fb.com>
In-Reply-To: <e348c97b-bd8c-c24f-9287-f1c5341ddd4d@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jul 2020 16:56:10 -0700
Message-ID: <CAADnVQ+Tc30JvwjZ-sbmmViMyaCb3HAS9f4RQ8utjfS8FnLOOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add bpf_prog iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 10:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/1/20 6:40 PM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > It's mostly a copy paste of commit 6086d29def80 ("bpf: Add bpf_map iterator")
> > that is use to implement bpf_seq_file opreations to traverse all bpf programs.
>
> Thanks for implementing bpf iter for bpf_progs!
>
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > No selftests?!
> > They're coming as part of "usermode_driver for iterators" set.
> > This patch is trivial and independent, so sending it first.
>
> Okay. Ack only with a few nits.
> Acked-by: Yonghong Song <yhs@fb.com>

Thanks for the review. Will be fixed in the next version.
