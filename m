Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB6724DBA7
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 18:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgHUQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 12:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgHUQpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 12:45:00 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C6C061573;
        Fri, 21 Aug 2020 09:45:00 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id u6so1370131ybf.1;
        Fri, 21 Aug 2020 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o2ZPSXoKQiAgvPofqJBjnMdYBbZ4MAbwhF7IQQ6Dw9Y=;
        b=FzSUj4/Q6+pY+Ld2kke9+/RxGFULDjpuOcFKWjKFhtIChhx/JMSenwHQn9kLvNVYs0
         3l07RLGvle4UwE+Q4MUOvubv53ldKifB4QFY8QuO6jqEnkXv0jrPwOn+EC5MwVxXBkt8
         jXXYepn773T4YIH8kWS3YySMXkul6OdbvaBd/8uePk9e5KoHwzQB4EUjsHY4nPy8Pz+O
         qm4SN4GLWw5h6EVRouO52rpAA6yASUxG78S0MO/3uV+PV22yuAq+8NPsZS8akOxKYAw4
         LB3IWk9Nva4TgXEB8nQ5OzLPnFS0b/PCf3cI7Bw4ncLy+8g6kcBLnnIG1+T2WBuWqwSi
         /iYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o2ZPSXoKQiAgvPofqJBjnMdYBbZ4MAbwhF7IQQ6Dw9Y=;
        b=Oywg5j2BidIi/O5AuQBIaumXRUsh9+e8ymi8NUItia3TnMyqWPAGf6soamOQnH9kkk
         1SiUGvWsKxr7YlAj3nhMuBan8WI+0fDcf586eQj+iK4VDaLZEpJ6RTqoE2i1FxVgxran
         S7wDci8skc/P4LtxhQAyYal9Lv6A+8MfAICy29/4FqqQPt8S/u1aoN30toG+S98KiYKr
         S64QX/wU9UgamRn8M0lNj36FcpiFSDzvHqSustkXfTZWH9GUnPsYokc/o8w9uy7xbckJ
         h7Ar9AnWkHIZJtxrKzUwIPGe7gpaHaDMY1F62p7Np8aSj+fhnUrp2Yo7hCEtF0O1rlSX
         Qu3Q==
X-Gm-Message-State: AOAM532D0wJef9vRYj7DPkOCXLFSx5JZLBE/K55xjihMMCYcebNalTXu
        VcnWXBoNSBS2NrmrQkyCy52iisodWzTDtxFuBK7QT6AU
X-Google-Smtp-Source: ABdhPJyoZDtihGJP47npsp2NTOEuIp0wDFzOZjLHaUMJSv/O0+wBlAFSNiPBMg3Xbdk3sv2G7pWTrjNFQdQDGPE4CpM=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr4649948ybe.510.1598028299749;
 Fri, 21 Aug 2020 09:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200820224917.483062-1-yhs@fb.com> <20200820224917.483128-1-yhs@fb.com>
 <CAEf4BzZ32inDH2MhLFv5o8PiQ9=4EGR0C75Ks6dWzHjVsgozAg@mail.gmail.com> <08982c2f-b9a8-3d30-9e4c-4f3f071a5a58@fb.com>
In-Reply-To: <08982c2f-b9a8-3d30-9e4c-4f3f071a5a58@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 09:44:48 -0700
Message-ID: <CAEf4BzbF_KURy4CusoCND6-agPc8SgFAtKDhcwYC8jP=L1M50Q@mail.gmail.com>
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

On Thu, Aug 20, 2020 at 11:42 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/20/20 11:31 PM, Andrii Nakryiko wrote:
> > On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> This patch implemented bpf_link callback functions
> >> show_fdinfo and fill_link_info to support link_query
> >> interface.
> >>
> >> The general interface for show_fdinfo and fill_link_info
> >> will print/fill the target_name. Each targets can
> >> register show_fdinfo and fill_link_info callbacks
> >> to print/fill more target specific information.
> >>
> >> For example, the below is a fdinfo result for a bpf
> >> task iterator.
> >>    $ cat /proc/1749/fdinfo/7
> >>    pos:    0
> >>    flags:  02000000
> >>    mnt_id: 14
> >>    link_type:      iter
> >>    link_id:        11
> >>    prog_tag:       990e1f8152f7e54f
> >>    prog_id:        59
> >>    target_name:    task
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            |  6 ++++
> >>   include/uapi/linux/bpf.h       |  7 ++++
> >>   kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
> >>   tools/include/uapi/linux/bpf.h |  7 ++++
> >>   4 files changed, 78 insertions(+)
> >>
> >
> > [...]
> >
> >> +
> >> +static int bpf_iter_link_fill_link_info(const struct bpf_link *link,
> >> +                                       struct bpf_link_info *info)
> >> +{
> >> +       struct bpf_iter_link *iter_link =
> >> +               container_of(link, struct bpf_iter_link, link);
> >> +       char __user *ubuf = u64_to_user_ptr(info->iter.target_name);
> >> +       bpf_iter_fill_link_info_t fill_link_info;
> >> +       u32 ulen = info->iter.target_name_len;
> >> +       const char *target_name;
> >> +       u32 target_len;
> >> +
> >> +       if (ulen && !ubuf)
> >> +               return -EINVAL;
> >> +
> >> +       target_name = iter_link->tinfo->reg_info->target;
> >> +       target_len =  strlen(target_name);
> >> +       info->iter.target_name_len = target_len + 1;
> >> +       if (!ubuf)
> >> +               return 0;
> >
> > this might return prematurely before fill_link_info() below gets a
> > chance to fill in some extra info?
>
> The extra info filled by below fill_link_info is target specific
> and we need a target name to ensure picking right union members.
> So it is best to enforce a valid target name before filling
> target dependent fields. See below, if there are any errors
> for copy_to_user or enospc, we won't copy addition link info
> either.
>

You are making an assumption that the caller doesn't know what time of
link it's requesting info for. That's not generally true. So I think
we just shouldn't make unnecessary assumptions and provide as much
information on the first try. target_name should be treated as an
optional thing to request, that's all.

> >
> >> +
> >> +       if (ulen >= target_len + 1) {
> >> +               if (copy_to_user(ubuf, target_name, target_len + 1))
> >> +                       return -EFAULT;
> >> +       } else {
> >> +               char zero = '\0';
> >> +
> >> +               if (copy_to_user(ubuf, target_name, ulen - 1))
> >> +                       return -EFAULT;
> >> +               if (put_user(zero, ubuf + ulen - 1))
> >> +                       return -EFAULT;
> >> +               return -ENOSPC;
> >> +       }
> >> +
> >> +       fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
> >> +       if (fill_link_info)
> >> +               return fill_link_info(&iter_link->aux, info);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >
> > [...]
> >
