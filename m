Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D5E4EF48
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 21:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfFUTOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 15:14:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41992 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfFUTOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 15:14:08 -0400
Received: by mail-qk1-f195.google.com with SMTP id b18so5224920qkc.9
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 12:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RC5Crv3M74pkwVk/bqvIU2GX/DDqRCkWJPYP/+X4yy0=;
        b=odDIQ1FrGH3sKkyao1gjcmVY0z1ZH+I7QpsndZVXP37kwDIZ32k8SgPVwMpq5OeSMf
         7cGGceoLHjUeHelZcEU4rjaszh/b4YJrN6bDF0uKpaLq0iTttgfF+AzQziilACTc13BM
         vkFHS58tCNzO+Fty3uKO4yCvWnomRLPZnUGqECZXg2tTh2EqT3KkgytNZSafCEJfmqQX
         pzo1cN6pOwEZtmdZkplM1/9kg/yafklUsVYHNTl8PYdkl4kMGWaFA5ecFVor6TA8VET7
         NEa3+K5voy3J0lhV8KNESXSdBnmhdmzisV+ZHmrkDidJSpRTO/7xbHOhD7eNZ0UtmqjE
         IaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RC5Crv3M74pkwVk/bqvIU2GX/DDqRCkWJPYP/+X4yy0=;
        b=Ge7ykHuLuAAgMbtl4PeKwxsZ2fm0FPqUKA6kxSQy8ltv7BBpbDT2G0l65nne97B2dP
         hGWbvx9P9w9PFSkGgn88Qsw+MMj+TORl+Iu+hzw9Py+gL6AMm9yVd+bFlb4pDeJiLrW2
         gbv81/g1ClMwTxfjxoFTsThluLpFrX0idOrlomYo/oXOghetsghgwDpTLv5s6x/U38u6
         hUpyNAJf4z66RklQOaxGKgrnVowzmiiDvOsvbOHkkA1KRAMT0sZEH4Kr8RaDj40szVPP
         +/Atpf3Gs0vDWCBASD0TgqefAJZ8al9MtACPtLyaBoZ5W5DyHJpuT4Htl8OkbXFSeb65
         fg1w==
X-Gm-Message-State: APjAAAWsqYuRUzUvJ/CmAbouELdHzwqDmF09miLPyJP+QWzCjRxeibi3
        HaV6rabmgriTIu24vEo/Bk4yMVvKWOQ7pfijT1G+SKsOJ0Y=
X-Google-Smtp-Source: APXvYqxunAJ2W70XlOianuTrbzxzGflMERyLdvPbmZjaY/Yh0nFumOziHDrEprMt3YsGul/e0DvQgAWBGH1IBWxUpDg=
X-Received: by 2002:a37:a095:: with SMTP id j143mr7329652qke.449.1561144447117;
 Fri, 21 Jun 2019 12:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <49d3ddb42f531618584f60c740d9469e5406e114.1561130674.git.echaudro@redhat.com>
In-Reply-To: <49d3ddb42f531618584f60c740d9469e5406e114.1561130674.git.echaudro@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jun 2019 12:13:56 -0700
Message-ID: <CAEf4BzZsmH+4A0dADeXYUDqeEK9N_-PVqzHW_=vPytjEX1hqTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add xsk_ring_prod__free() function
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 8:26 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> When an AF_XDP application received X packets, it does not mean X
> frames can be stuffed into the producer ring. To make it easier for
> AF_XDP applications this API allows them to check how many frames can
> be added into the ring.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  tools/lib/bpf/xsk.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..86f3d485e957 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -95,6 +95,12 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
>         return r->cached_cons - r->cached_prod;
>  }
>
> +static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)

This is a very bad name choice. __free is used for functions that free
memory and resources. One function below I see avail is used in the
name, why not xsk_ring_prog__avail?

> +{
> +       r->cached_cons = *r->consumer + r->size;
> +       return r->cached_cons - r->cached_prod;
> +}
> +
>  static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
>  {
>         __u32 entries = r->cached_prod - r->cached_cons;
> --
> 2.20.1
>
