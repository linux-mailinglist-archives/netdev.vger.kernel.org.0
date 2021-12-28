Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1BE480D1F
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhL1VCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhL1VCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:02:42 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28321C061574;
        Tue, 28 Dec 2021 13:02:42 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bq20so43742603lfb.4;
        Tue, 28 Dec 2021 13:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dt9CXasnk9PIgbcivdQVB6XtSwuQfSI3t6oImYWBzNo=;
        b=bo7+m1NH/V6Kcm0kBa6EghKnKim+5KC0KiXfd+reE3NRJxIy1snuCmWBzgMxBXM1mf
         FgteJZVx7GInbq7h4HXWHVbWiU8wjPro8akCRwUhe9eYZ/7rk5UViBmaI9prRVG5J1Y4
         UegTxlHV4t70Azf2dNHiuLyKwOY0iVFTbA/OfK3cV46tGDOwsOXlN0U+JUrY6sOepOTs
         OLAv3ZGvYeCn/QSAA8d4fjH+h/lTSpCOROiTuhNE1dmmB6lk6GEo6tMX+N367M58XgYE
         1I4hQcHpStaYu8U8nSPwux9wX9CsWAG/VJ5mNofzByPm0IYI80vXTLWcyzDOHvmMESTD
         a8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dt9CXasnk9PIgbcivdQVB6XtSwuQfSI3t6oImYWBzNo=;
        b=RhCSDpwRh1MJqLPEOseM87WnQfMm7fSEc2CpJNk/7sy9YAtxEuUCGqanIkmPRvj2hG
         uZzeaxhOnqzgVbi3KrmeYJtjgpSLlFlpfk9KasHEnUw8Z+X6uxhBCLVN8WXkNRXsFxDh
         ZqZXCzRRFfa0uTM25v5UGfAPRQaLmLOQPrk1sZ3sPG/8/tgS7X0T/9sQs4c/3ccaeIRF
         yJ6CxicOoLqu+znwH5pGRKL/OUOn5h9l5b9V6jrXgcriV9AHCJuSF24Im0EIIRP6XaFc
         e+XckZYyv9g/Aut17vJPcO3CXuysLRHFKAomRSF5DcV4vQ82WUvdVHT6kdE+5fzZYNeg
         kM2w==
X-Gm-Message-State: AOAM531ScQbr0HK8hv/N+TbtTdWmHHwpwk9Cea5rR5BBq6Yhd7z3K/ZQ
        zIXhvcVJpxUaZPIoE/IuNNpLYG9eVQ/kAjGlDq6gfJTCOzM=
X-Google-Smtp-Source: ABdhPJw4vbvQNTZ+e3b0r0P5JkNug8I4q9aCVpxRgPgpVWtwSN8AnxCM1Qgl0WzSeBngfSjJ+DgYvza4EwOfg1xJZ8o=
X-Received: by 2002:ac2:5238:: with SMTP id i24mr21128618lfl.467.1640725360019;
 Tue, 28 Dec 2021 13:02:40 -0800 (PST)
MIME-Version: 1.0
References: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
In-Reply-To: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
From:   Tamir Duberstein <tamird@gmail.com>
Date:   Tue, 28 Dec 2021 16:02:29 -0500
Message-ID: <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com>
Subject: Re: [PATCH] net: check passed optlen before reading
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Errant brace in the earlier version.

From 8586be4d72c6c583b1085d2239076987e1b7c43a Mon Sep 17 00:00:00 2001
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 28 Dec 2021 15:09:11 -0500
Subject: [PATCH v2] net: check passed optlen before reading

Add a check that the user-provided option is at least as long as the
number of bytes we intend to read. Before this patch we would blindly
read sizeof(int) bytes even in cases where the user passed
optlen<sizeof(int), which would potentially read garbage or fault.

Discovered by new tests in https://github.com/google/gvisor/pull/6957 .

Signed-off-by: Tamir Duberstein <tamird@gmail.com>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 60f1e4f5be5a..c51d5ce3711c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1020,6 +1020,9 @@ static int do_rawv6_setsockopt(struct sock *sk,
int level, int optname,
        struct raw6_sock *rp = raw6_sk(sk);
        int val;

+       if (optlen < sizeof(val))
+               return -EINVAL;
+
        if (copy_from_sockptr(&val, optval, sizeof(val)))
                return -EFAULT;

-- 
2.34.1.448.ga2b2bfdf31-goog

On Tue, Dec 28, 2021 at 3:18 PM Tamir Duberstein <tamird@gmail.com> wrote:
>
> From 52e464972f88ff5e9647d92b63c815e1f350f65e Mon Sep 17 00:00:00 2001
> From: Tamir Duberstein <tamird@gmail.com>
> Date: Tue, 28 Dec 2021 15:09:11 -0500
> Subject: [PATCH] net: check passed optlen before reading
>
> Add a check that the user-provided option is at least as long as the
> number of bytes we intend to read. Before this patch we would blindly
> read sizeof(int) bytes even in cases where the user passed
> optlen<sizeof(int), which would potentially read garbage or fault.
>
> Discovered by new tests in https://github.com/google/gvisor/pull/6957.
>
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>
> ---
>  net/ipv6/raw.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 60f1e4f5be5a..547613058182 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -1020,6 +1020,9 @@ static int do_rawv6_setsockopt(struct sock *sk,
> int level, int optname,
>         struct raw6_sock *rp = raw6_sk(sk);
>         int val;
>
> +       if (optlen < sizeof(val)) {
> +               return -EINVAL;
> +
>         if (copy_from_sockptr(&val, optval, sizeof(val)))
>                 return -EFAULT;
>
> --
> 2.34.1.448.ga2b2bfdf31-goog
