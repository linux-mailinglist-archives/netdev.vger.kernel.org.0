Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3189D1BC8A6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgD1SeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729622AbgD1SeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 14:34:23 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCEAC03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 11:34:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 7so1364374pjo.0
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 11:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d8J9/+H1aJgIU0iPd3k8kUXfWA6cvbV7BCbp34hUMis=;
        b=PzZLYwaag6VROB6/jTlW9RHPa3Znmxxj1gxVDF7bKVaHEe7DgmI6oiMixvFxC0hifr
         6AF8PGrk53GEMQ2uvcLzz3tI9y6/4PYq8kHzbjRPRIjS+cqFJCnOlLMmxdtHPHCQTetS
         rY9cdvBZM1YJK3ZB6JqBBSWL6fq8YJap+HZZkKlX6Xu1QVzE54vkzpuw2khc0Bfwu+1/
         e1R+H9YvIHUv+u5g7rByKatPq1NJikTUOYTQ7eLDvr0JUW+MNOD19ptMr14AMCOoevYW
         jyjAxHQzyIrOk/0iPRnrkpFhUlEvmaqOesnOkoASIrNQZLh6Z9a6eXSwSh/WDEDBNNlD
         Gz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d8J9/+H1aJgIU0iPd3k8kUXfWA6cvbV7BCbp34hUMis=;
        b=cE/utW8LnywkX3ZrNlER19o5rVMhBjJ2hatBuaeanZF3zSrSBuTVcFmQvKAcbtmtfg
         4dwbuoxZaGyvVVq2vRTAn6nkeubIVFH/wqdi92MxtH27rAIS5MijE3F8eMUVxSa3UFKA
         TIyNn0ltbfoSpJBNBiNlz/UBEmjkviFgLnzVyqscsvpgb/T432iJJ/PuOfEeru9ksWvt
         /01Jym+TZx/SvphAFxcdkTaQYhrf5xByoM5LxjQ/S8PS/xIixdy7cu61c9cTp+4YoGCX
         ez/OtoLm0T56CEwjY5iJGJ3YdOfLC7PU5AeiJLeIvpe2uuEWWcDQVd2UHO5d+apQPgi6
         ernQ==
X-Gm-Message-State: AGi0Pubu/BaJnyPY+t8eaQfJrGfN3+ywzaM2wt5rbKRwzgn5iijrFYVS
        PVxBfeS2LdJpbVgLGXvYxmOX+TUXNB4SGKL9mdsTBg==
X-Google-Smtp-Source: APiQypK4DziNhv8yRj8qmx9ucMaNvJnzarNstlH/ET2gZdf27UdoomqisWjZrSKO9zFfc0EmggwKCgxi0dJ9zlfGZ2Y=
X-Received: by 2002:a17:902:988e:: with SMTP id s14mr29496990plp.179.1588098862653;
 Tue, 28 Apr 2020 11:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200428174221.2040849-1-natechancellor@gmail.com>
In-Reply-To: <20200428174221.2040849-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 28 Apr 2020 11:34:11 -0700
Message-ID: <CAKwvOd=cb-dyWGeMoCE4+zdgA1R=t=QPkzU9EGiCtgdzXke_cw@mail.gmail.com>
Subject: Re: [PATCH] dpaa2-eth: Use proper division helper in dpaa2_dbg_ch_show
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:43 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building arm32 allmodconfig:
>
> ERROR: modpost: "__aeabi_uldivmod"
> [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!
>
> frames and cdan are both of type __u64 (unsigned long long) so we need
> to use div64_u64 to avoid this issues.
>
> Fixes: 460fd830dd9d ("dpaa2-eth: add channel stat to debugfs")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1012
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Don't forget reported by tags to show some love to our bots! Thanks
for the patch.
Reported-by: kernelci.org bot <bot@kernelci.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> index 80291afff3ea..0a31e4268dfb 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> @@ -139,7 +139,7 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
>                            ch->stats.dequeue_portal_busy,
>                            ch->stats.frames,
>                            ch->stats.cdan,
> -                          ch->stats.frames / ch->stats.cdan,
> +                          div64_u64(ch->stats.frames, ch->stats.cdan),
>                            ch->buf_count);
>         }
>
>
> base-commit: 0fd02a5d3eb7020a7e1801f8d7f01891071c85e4
> --
> 2.26.2
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200428174221.2040849-1-natechancellor%40gmail.com.



-- 
Thanks,
~Nick Desaulniers
