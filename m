Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEF924CE03
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHUGbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgHUGbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:31:46 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40F0C061385;
        Thu, 20 Aug 2020 23:31:45 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id i10so481567ybt.11;
        Thu, 20 Aug 2020 23:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y7CnQ43knVpw8jT9GDPqGRZu+4r4FWZskBB7+2K5rVc=;
        b=RpBZYrRfzsp9NUSqUglclmHsa95JMVyfrDQhmRNxQsuaQqrhKK+HZogs625wqUSlfK
         dbScB0aDoF85H4RxbakrJrVpDJiMmoHGNe4J9gPOayzKoMp6zy51zfZM/F7GDj7IRSTp
         /R6iWd0q0HhqhB/QxxaifQAI9ds+6yg1iXh/tEpurWVSF9z32ZhY8zOXJfWlSqA2dtXN
         JIyjgDFNELH0Yu66eQtjl0vzjxzbCZYmlpDRL/yTsZX9qVWZSSH+ciYDyTrd0JnxjW1D
         N1fFQk2ehBoSCi6RKBEtF2pGAgT/bRHCQCiLIQvvpgjAQnaCrbBNq4yhNR9b01asOHuF
         9AWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y7CnQ43knVpw8jT9GDPqGRZu+4r4FWZskBB7+2K5rVc=;
        b=pSXVZOs9dOC08+xEhI8Zt6A7zKmwwKC8E5PMLSJiABK3J4Oo1lVyVBQ/N00Qg04gLN
         xyBCWn06BIFlZsTWhe+HpPGw5tbTXY4rWWpL8jy8HYjJm3nLGU7OpLA3Mvl24R4+nh+y
         ZLTJWqmUIPhoDuGVfjSgDIiRi/pf0LQ6Ts3pDO+GsAXsENPgLctmj/JbbAyWilg8qpxW
         OOodBm8xnHR3BET3jI8dVwOUdeu2FLE+EP1ea22X6eX/x5GhpNrDSSA7GP8/WmfYxBne
         GaUl8v6BhW2bec/umBNDFnfG/ECRI6BRoKWwhBWuqT59/aWhv8pAd6+CFFswsUEkSeOK
         izxw==
X-Gm-Message-State: AOAM5327SkFlQwjmWV4iMaT9tONuFVDGALHTapin7ODoiX1I7JWEqw0f
        gRCkZE4HM1dtPnaxxh2vPa/vDmtu6Wj2rc2cgKLIY8vVOxE=
X-Google-Smtp-Source: ABdhPJxIN/wtdPmlZdifU0G1f+g2tLU0OSKSzS4uhZJbxKfTLmelnhAWzK65Cd+2APTxGP8bHbW8XtxJsk7a/MsuFHE=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr1700257ybe.510.1597991505198;
 Thu, 20 Aug 2020 23:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200820224917.483062-1-yhs@fb.com> <20200820224917.483128-1-yhs@fb.com>
In-Reply-To: <20200820224917.483128-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Aug 2020 23:31:34 -0700
Message-ID: <CAEf4BzZ32inDH2MhLFv5o8PiQ9=4EGR0C75Ks6dWzHjVsgozAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: implement link_query for bpf iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
>
> This patch implemented bpf_link callback functions
> show_fdinfo and fill_link_info to support link_query
> interface.
>
> The general interface for show_fdinfo and fill_link_info
> will print/fill the target_name. Each targets can
> register show_fdinfo and fill_link_info callbacks
> to print/fill more target specific information.
>
> For example, the below is a fdinfo result for a bpf
> task iterator.
>   $ cat /proc/1749/fdinfo/7
>   pos:    0
>   flags:  02000000
>   mnt_id: 14
>   link_type:      iter
>   link_id:        11
>   prog_tag:       990e1f8152f7e54f
>   prog_id:        59
>   target_name:    task
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |  6 ++++
>  include/uapi/linux/bpf.h       |  7 ++++
>  kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  7 ++++
>  4 files changed, 78 insertions(+)
>

[...]

> +
> +static int bpf_iter_link_fill_link_info(const struct bpf_link *link,
> +                                       struct bpf_link_info *info)
> +{
> +       struct bpf_iter_link *iter_link =
> +               container_of(link, struct bpf_iter_link, link);
> +       char __user *ubuf = u64_to_user_ptr(info->iter.target_name);
> +       bpf_iter_fill_link_info_t fill_link_info;
> +       u32 ulen = info->iter.target_name_len;
> +       const char *target_name;
> +       u32 target_len;
> +
> +       if (ulen && !ubuf)
> +               return -EINVAL;
> +
> +       target_name = iter_link->tinfo->reg_info->target;
> +       target_len =  strlen(target_name);
> +       info->iter.target_name_len = target_len + 1;
> +       if (!ubuf)
> +               return 0;

this might return prematurely before fill_link_info() below gets a
chance to fill in some extra info?

> +
> +       if (ulen >= target_len + 1) {
> +               if (copy_to_user(ubuf, target_name, target_len + 1))
> +                       return -EFAULT;
> +       } else {
> +               char zero = '\0';
> +
> +               if (copy_to_user(ubuf, target_name, ulen - 1))
> +                       return -EFAULT;
> +               if (put_user(zero, ubuf + ulen - 1))
> +                       return -EFAULT;
> +               return -ENOSPC;
> +       }
> +
> +       fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
> +       if (fill_link_info)
> +               return fill_link_info(&iter_link->aux, info);
> +
> +       return 0;
> +}
> +

[...]
