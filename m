Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F5F1C78B0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgEFRwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgEFRwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:52:12 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D88C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 10:52:12 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x73so2108546lfa.2
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 10:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3iDM/PlD1cl2Emprrc8UkVlx+lvpjZ6KITj+kMZS4vU=;
        b=Onj6RpBSdppxiHflDIfnU8/+fh2nF8mikY4k8DOvMwZvX/ZFfIXNMSG/+sP3oK2sr9
         mIhcfJjCn3ECmIQwwRaGtud3qgvzJv+DPfXc8ePIDpNWfdp4Yhjfmi+BT3ywIKw7jV7e
         fK1DuRTDXTp/q9VjTTMWhXsXHEy4B8ih7FSH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3iDM/PlD1cl2Emprrc8UkVlx+lvpjZ6KITj+kMZS4vU=;
        b=oxCfA5FlsPqlYboy8nZei3X8H17qf4xYCXaEtYnM63EsqTdI7kVU3QUhXbceVtvPUm
         d9IXY19EQLsOs86i6n5XRaYuzNpoeQ2HzqhmUGoHprm7L/rVky1VgpGE51SLaNYj1QDc
         wMMZtfsPgyqm5FDu5dpewvYcI3dmVEo7VxfX29ed2G6C8MWw3kmKakerKqBvsEy4PQ+s
         ffpzYF4QSl00Qdcx3jbTSfNpfkYQJy+E0iE9vF6VNYdstyleBSRfo3Kk9290UUweNz1V
         G1J99WMGu9NvufaGgT1C/SJx+zTAoeshNXNCHGzspvldH1TI0DA2uPdvG/qmbHe00tPp
         yzyw==
X-Gm-Message-State: AGi0PuaD9v1xc/dW2B4U7a+RJHVsSvgzg8xEsLCfi7UUmD1RJeNSAGlc
        ZKE7s/aTHqaWnOdhSAzFfUSuqAL/020=
X-Google-Smtp-Source: APiQypJkW4211GW2dnan3HC54g9b99nCnkNFJdCScPkzQBjAh+Lz5Y5LKjurgutyrkWjFYNhNsatNg==
X-Received: by 2002:a05:6512:10d0:: with SMTP id k16mr6038434lfg.71.1588787529700;
        Wed, 06 May 2020 10:52:09 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id 134sm577590lfj.20.2020.05.06.10.52.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 10:52:08 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id l19so3317535lje.10
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 10:52:08 -0700 (PDT)
X-Received: by 2002:a2e:8512:: with SMTP id j18mr5893926lji.201.1588787527821;
 Wed, 06 May 2020 10:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200506062223.30032-1-hch@lst.de> <20200506062223.30032-16-hch@lst.de>
In-Reply-To: <20200506062223.30032-16-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 May 2020 10:51:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi6E5z_aKr9NX+QcEJqJvSyrDbO3ypPugxstcPV5EPSMQ@mail.gmail.com>
Message-ID: <CAHk-=wi6E5z_aKr9NX+QcEJqJvSyrDbO3ypPugxstcPV5EPSMQ@mail.gmail.com>
Subject: Re: [PATCH 15/15] x86: use non-set_fs based maccess routines
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

On Tue, May 5, 2020 at 11:23 PM Christoph Hellwig <hch@lst.de> wrote:
>
> +#define arch_kernel_read(dst, src, type, err_label)                    \
> +       __get_user_size(*((type *)dst), (__force type __user *)src,     \
> +                       sizeof(type), __kr_err);                        \
..
> +#define arch_kernel_write(dst, src, type, err_label)                   \
> +       __put_user_size(*((type *)(src)), (__force type __user *)(dst), \
> +                       sizeof(type), err_label)

My private tree no longer has those __get/put_user_size() things,
because "unsafe_get/put_user()" is the only thing that remains with my
conversion to asm goto.

And we're actively trying to get rid of the whole __get_user() mess.
Admittedly "__get_user_size()" is just the internal helper that
doesn't have the problem, but it really is an internal helper for a
legacy operation, and the new op that uses it is that
"unsafe_get_user()".

Also, because you use __get_user_size(), you then have to duplicate
the error handling logic that we already have in unsafe_get_user().

IOW - is there some reason why you didn't just make these use
"unsafe_get/put_user()" directly, and avoid both of those issues?

              Linus
