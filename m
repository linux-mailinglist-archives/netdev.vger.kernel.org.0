Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30E1353A31
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhDEAQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhDEAQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:16:43 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50760C061756;
        Sun,  4 Apr 2021 17:16:38 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id g38so10874521ybi.12;
        Sun, 04 Apr 2021 17:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OVvztDvgrvzKuODIaNCcyWB5/1r0S8OTEYJE9jDz8E=;
        b=S3Bc+GdqRNFE3OLAF5A6IHVF5MBOLXeCKFhSHiQlJMKcScZOpvhe2qakuiJq04b0D/
         Usf+eB2EH9SLoAjnzgC4G2AQQEWJJOqd7L289opGF5oCN0qpixr98tSLWhTudrnZycfC
         nZYeClxeUDX4H3Vnk7a/G5UdDFe/iDJYpodJ8Ioef4IC1GIHDW6LV/+aY2FUUG8R3VGV
         LFkPrwHdE9O2ukCc10boX9kCUSyXC8tE2xpVMppO1EwKs0/EQZlUBvH2YmcJyc9yvpUk
         IynBVyMJwTTRFBrmE8DZnph/fSgIDwQnG4xyEmwgWI6Uqeo/wSSz2aFlXOt7w2QYqE88
         eqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OVvztDvgrvzKuODIaNCcyWB5/1r0S8OTEYJE9jDz8E=;
        b=oJjRAAy9f9BXhi34W2j0fKmz0i4AoO4JE5nRLblSHOk/0H0N2WBwIE6A7JztAQZtC9
         wy89vPQWg6uyLuFX0wADnvVXldqsB5sBXCW/lFg6X2fg3Q38dszEnYKqf417qgMkJHKK
         +S8OgL6uN/VUeKSBy3/1Oh8U6G27yGfcvhygy3XLyaBqSWRI9fsRuLLTwWsLmj3ZZtgG
         KSbp86fQ8WsnfRfLEn06dw+Sv8lV3oK/awMNPVabXzTTK/cHJ8weyDkTFuxHY6gBJi8S
         sdY5YHh6Bk35hHGn55xHRNch8V1xzjHp0pzeVkha0LbCTw1BAsgSEeE5GFxB0RLGdsWF
         b0NQ==
X-Gm-Message-State: AOAM532IigjSZHX2SX6H8jvigYxG1Q3JFbc6Eit+evzGButMW1vS1Vp7
        +3SIIxi8NEnMA7oO8qApEq+MDcY7dmtkvoEEUBE=
X-Google-Smtp-Source: ABdhPJyu8nJVIkfKwQJUPVBPwkF80o/DiuO33mH9K3DfVRBNhDna/9R3cIBjEjf8rwxQ1DLQDE0Vxck+ecZhXosTva8=
X-Received: by 2002:a25:d87:: with SMTP id 129mr22991641ybn.260.1617581796896;
 Sun, 04 Apr 2021 17:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <ME4P282MB1174C26FCD8E61817960F596C0789@ME4P282MB1174.AUSP282.PROD.OUTLOOK.COM>
In-Reply-To: <ME4P282MB1174C26FCD8E61817960F596C0789@ME4P282MB1174.AUSP282.PROD.OUTLOOK.COM>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 4 Apr 2021 17:16:26 -0700
Message-ID: <CAEf4BzZyyQLchpK9OjH3A5N5-eKNBq0t7p2fvuPbGVty3gFh5g@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix KERNEL_VERSION macro
To:     Hengqi Chen <chenhengqi@outlook.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 4, 2021 at 2:53 AM Hengqi Chen <chenhengqi@outlook.com> wrote:
>
> Add missing ')' for KERNEL_VERSION macro.
>
> Signed-off-by: Hengqi Chen <chenhengqi@outlook.com>
> ---

The fix looks good, thank you. But your patch didn't make it into
bpf/netdev patchworks instance ([0]) most probably due to too long CC
list. Can you please re-send with just maintainers and bpf@ and
netdev@ mailing lists in to/cc.

Also for bpf and bpf-next tree, we ask to specify the tree with [PATCH
bpf-next] prefix, so when re-submitting please adjust as well. Thanks.

  [0] https://patchwork.kernel.org/project/netdevbpf/list/

>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index cc2e51c64a54..b904128626c2 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -51,7 +51,7 @@
>  #endif
>
>  #ifndef KERNEL_VERSION
> -#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c))
> +#define KERNEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c)))
>  #endif
>
>  /*
> --
> 2.25.1
>
