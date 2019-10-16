Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D475CD9BD6
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437190AbfJPU3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:29:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36679 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbfJPU3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:29:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so24096961qkc.3;
        Wed, 16 Oct 2019 13:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pjsbzqJi4QofWr6hfDLEGMxJ4eBqrwiepHhxIykIV2w=;
        b=vNVxT30KJy4SHjMAk0X8VD4q//AiNIxJOYMTxFDPJk8S6JrnigQLmOJ2g2W2J6qKQ7
         dCne4RF0QN5t4C0Vj+ThIguvOhInc+6IspkDuCjOV3Kh1eBxAfLtAVYzoufOkyC1shxH
         SAIido1ftQsVboqperyidk7I7w4L85sgItnfPA+E1Xd2OC5a03sNpJqPtMA36VG5rC/x
         UDDeEhW4D8qJH4L3LYAD66v8uHOj5Y8CEyLVGoHcQjeROI9o53o2qkPplBYRIq91l9cH
         hCqPuDkK/vVsvF2AmmpopELZw3E2AaeAlDz6CZZhRjmOcKaU4/Ez8oAfzD9eMR8BEBSM
         6ZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjsbzqJi4QofWr6hfDLEGMxJ4eBqrwiepHhxIykIV2w=;
        b=WetiXCEwbGeIo6RolxsRXe90ftV7URUh+ciNI3iyRzC2ML65ux7B0+G4P8SRFEG+y5
         PXEYpcI/to5Yb6wlnO9In0b9aCu3b+u7jOpkSVi9OvOxbsxZLVs0JHNdTki9CxaVEY0D
         IW+PoW5fMLzmRyTCZc9waZVScIqpYG8f7LqO31QllgC5fU8qbYSRv6etwB4Snm3+kP3R
         NVZyXyQTtjYUTy/aClqF5rt/hDHw5SB6Lvcde7tGBnmxlL/AwtneO6s3zyvBNAlqVEGD
         FWKTvYP47XrUod0K1m3nDcvIesBe3PtIAaMJuXnYI+JNZxGwTpmZEWbAvJ7GuFWXDeiT
         KA4A==
X-Gm-Message-State: APjAAAVL0YkJ2SRm2BaPuDf5L63IuO6Kzjt+BKsTGlSHo2zcRjkEJNTT
        BAjjSiqZ5z59F4fR/pSUSLoS8ZJ7d94923ytwi9z1UMt
X-Google-Smtp-Source: APXvYqwjkgMW/o3T/HcVQYU6B7hOpz76gsRx/Fj5IdAVWEPE9dirNwBHUQxF7nAy60iExhAISUTZg2bmIcOtGUIh4Sg=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr44970410qka.449.1571257781250;
 Wed, 16 Oct 2019 13:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191016085811.11700-1-jakub@cloudflare.com>
In-Reply-To: <20191016085811.11700-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 13:29:30 -0700
Message-ID: <CAEf4BzYUoGx9G6-8EYWReTamNGVmrOcWHEaqemRuv8+np1x17Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] scripts/bpf: Emit an #error directive known
 types list needs updating
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 6:21 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Make the compiler report a clear error when bpf_helpers_doc.py needs
> updating rather than rely on the fact that Clang fails to compile
> English:
>
> ../../../lib/bpf/bpf_helper_defs.h:2707:1: error: unknown type name 'Unrecognized'
> Unrecognized type 'struct bpf_inet_lookup', please add it to known types!
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  scripts/bpf_helpers_doc.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
> index 7df9ce598ff9..08300bc024da 100755
> --- a/scripts/bpf_helpers_doc.py
> +++ b/scripts/bpf_helpers_doc.py
> @@ -489,7 +489,7 @@ class PrinterHelpers(Printer):
>          if t in self.mapped_types:
>              return self.mapped_types[t]
>          print("")
> -        print("Unrecognized type '%s', please add it to known types!" % t)
> +        print("#error \"Unrecognized type '%s', please add it to known types!\"" % t)

My bad, this was intended to be printed to stderr, not to stdout
output. Can you please do a follow up patch turning this into eprint
instead?

This shouldn't be reported by Clang, rather by tool. And we should
ensure in libbpf's Makefile that bpf_helper_defs.h is deleted on
error. I'll do it a bit later, unless you'll beat me to it.

>          sys.exit(1)
>
>      seen_helpers = set()
> --
> 2.20.1
>
