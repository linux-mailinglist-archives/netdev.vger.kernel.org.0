Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3502049DB
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgFWG0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbgFWG0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:26:52 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62969C061573;
        Mon, 22 Jun 2020 23:26:52 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z1so14587635qtn.2;
        Mon, 22 Jun 2020 23:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vzMD4uGdl9FVaiWnEw7ikb0beIiwyp0SgjOR4bYqbMw=;
        b=hWH7VpIwXga+j63s+IqiCMTy9RHqjG3ijUzKMSG+rKl86NfHPExkc00OAOeC16bfec
         hj9oqyCLRr1L8aHyXW72TZo30Tn0MSqm2o9jmMEYGRmNv6UFS997UKfJGP/dbz331YkM
         zJ2aMn0Ykgmc7sH/5TYQ4tmUb0zDkkAdntM42Ufvd3JdaKYrw8bHZa+224GgUNtDEv1R
         7RA6/arLoW0fywGcVqKq1/qul+c31lUJSCQZgok/YAC1MMneRDTirB8rpVYN9sWZywwZ
         zru0u1qrZc7Q+eNVLGFbh6/0eeNNVI6eGA9TxJOAApqsOAfonSJBGQvSWvR5TJMYhN3J
         g/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzMD4uGdl9FVaiWnEw7ikb0beIiwyp0SgjOR4bYqbMw=;
        b=tLIBNinL3Gb1Acp0g/zA3RFA7TsK6jA2tCy41mGFROGvAZOtKoIdrvUbdh92wK9/n8
         Wj8fDtZVj9LMHIiEZfDaV5LYolg5vgmgyNR68X3obga+tdWA0wW3cOIGXcYi6E6+JHZi
         dxE1nsrQsEJozfBNiXu+X36AzHfDDZkzjIsjoxqf5Am/+hbzHedIRTBb16r8K0Di9Rca
         AXVr97mRdCmJUoYpfAdFSRZ3O5ZvZGcXXC/OK/S7fJD0gUIMCkwM8Qatkmvn9SLTK1U1
         QMqmgXy3xSn/2HX8rjBcX46FveVcpI3U+uJTp0yBhrnB6NqMpcg8k6j0yZ+iAwcND8uC
         4G2w==
X-Gm-Message-State: AOAM531JoyiVnwZk1VMOr37c0hdhrcjNgN90b6QwDFZJv8WWJhBsWejL
        6iI7M4SvVAlohYJg9ZGYkkvng8VG3oaFR95cT7s=
X-Google-Smtp-Source: ABdhPJwO2EJIDOZ9Nitmd6RqC+qEXskdJiV9hh4mZ3UuWNfy5BgooSES5T7ff1nuXC23Bujicfe1Iu4L8GtoBKlVn/g=
X-Received: by 2002:ac8:4cc9:: with SMTP id l9mr6151186qtv.59.1592893611560;
 Mon, 22 Jun 2020 23:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200622160300.636567-1-jakub@cloudflare.com> <20200622160300.636567-4-jakub@cloudflare.com>
In-Reply-To: <20200622160300.636567-4-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:26:40 -0700
Message-ID: <CAEf4BzbjnLYmJRJjFMz3H5HJa8pnD27JACHK36jZUyGDkVzzMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf, netns: Keep a list of attached bpf_link's
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 9:04 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> To support multi-prog link-based attachments for new netns attach types, we
> need to keep track of more than one bpf_link per attach type. Hence,
> convert net->bpf.links into a list, that currently can be either empty or
> have just one item.
>
> Instead of reusing bpf_prog_list from bpf-cgroup, we link together
> bpf_netns_link's themselves. This makes list management simpler as we don't
> have to allocate, initialize, and later release list elements. We can do
> this because multi-prog attachment will be available only for bpf_link, and
> we don't need to build a list of programs attached directly and indirectly
> via links.
>
> No functional changes intended.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/net/netns/bpf.h    |  2 +-
>  kernel/bpf/net_namespace.c | 42 +++++++++++++++++++++-----------------
>  2 files changed, 24 insertions(+), 20 deletions(-)
>

[...]
