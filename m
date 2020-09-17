Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C28726E808
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIQWQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIQWQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 18:16:09 -0400
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37C02087D;
        Thu, 17 Sep 2020 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600380969;
        bh=cxR9RkHGDfJRHI28coowKoqSeOzEIZJS/Y1YnxG3P4o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Raz2hDsQ8K0KW8wx4R8xfgpt6NVNp1QzJNMBW4Mu1M9y5rKOTdN+TzSExVpFzpiUO
         PVKlO6Y29y5Qomn3hkPeMtMXQuut+B0aYP+JSKGdQpYcfJgl47/yfrZOogLIxy2Rw6
         ZPgsUMOhjceb/djd9eFnrM8KVXwngodKJJyCXbzI=
Received: by mail-lj1-f172.google.com with SMTP id n25so3389168ljj.4;
        Thu, 17 Sep 2020 15:16:08 -0700 (PDT)
X-Gm-Message-State: AOAM532VaIxC+dhDPGrUDnREziD7O5ztsW9dRAJxX8mFqPep3Y9Tt3LD
        Vz9SAIjBv3Zgm7d4ljdiLxEC9X78OXU7NeTJWjw=
X-Google-Smtp-Source: ABdhPJxZuSr7hD4F9yfrsK3etn8sGULf01qZ4/6UFnfzzi8UY19YPrvzznrINZiOwtgDlWJU3pcewET78yjBH6DIPTE=
X-Received: by 2002:a2e:9cd5:: with SMTP id g21mr3724939ljj.27.1600380967139;
 Thu, 17 Sep 2020 15:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200916204453.2003915-1-kafai@fb.com>
In-Reply-To: <20200916204453.2003915-1-kafai@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Sep 2020 15:15:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5ARmNB9wosUPa_xs_gb5jKnZLhOssSXyvhcPhMAKKVYg@mail.gmail.com>
Message-ID: <CAPhsuW5ARmNB9wosUPa_xs_gb5jKnZLhOssSXyvhcPhMAKKVYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Use hlist_add_head_rcu when linking to local_storage
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 9:57 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The local_storage->list will be traversed by rcu reader in parallel.
> Thus, hlist_add_head_rcu() is needed in bpf_selem_link_storage_nolock().
> This patch fixes it.
>
> This part of the code has recently been refactored in bpf-next
> and this patch makes changes to the new file "bpf_local_storage.c".
> Instead of using the original offending commit in the Fixes tag,
> the commit that created the file "bpf_local_storage.c" is used.
>
> A separate fix has been provided to the bpf tree.
>
> Fixes: 450af8d0f6be ("bpf: Split bpf_local_storage to bpf_sk_storage")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
