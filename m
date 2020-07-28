Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC05230200
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgG1FrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgG1FrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:47:17 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A144621D95;
        Tue, 28 Jul 2020 05:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595915237;
        bh=qaTaq8Zfiec/SysD6CW7W71Vn7qAmrNYsR1c7ErTEQE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JPKCPuBHT9PNSZDfSkpYSU1Lwcjb9YnYSPCQWLZXKaaadBPnd5gXtE0Y3ZocORvsC
         6jHhHW/NxIDCbxyzaj9HQJUljlBEBp4o81YkqGH8FDd6zCq1hrJnyYe730aNHM0eRz
         dJQx5CfTmo0jaHF1uITDmG63afX4qQW+eY2fXx/c=
Received: by mail-lj1-f177.google.com with SMTP id x9so19777224ljc.5;
        Mon, 27 Jul 2020 22:47:16 -0700 (PDT)
X-Gm-Message-State: AOAM530HkDwj6Ww/kSjVx6Aslg5Ij0VR2o2+bJXzuGjPYw7cleh2b8ID
        GHrT3L8V27O8VlavlCAigQl9qqx5VyI8sE7yq6E=
X-Google-Smtp-Source: ABdhPJyzkiEMwJ4rAbnZzFJ5hvFxoKM2cOBCCAXqEQzukrJJfzMXKWWBguqlYFZXJhOaNTCS1Dt2MgbalWFNoeGj3WA=
X-Received: by 2002:a2e:8707:: with SMTP id m7mr11093793lji.350.1595915234960;
 Mon, 27 Jul 2020 22:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-28-guro@fb.com>
In-Reply-To: <20200727184506.2279656-28-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:47:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7jWztOVeeiRNBRK4JC_MS41qUSxzEDMywb-6=Don-ndA@mail.gmail.com>
Message-ID: <CAPhsuW7jWztOVeeiRNBRK4JC_MS41qUSxzEDMywb-6=Don-ndA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 27/35] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:26 PM Roman Gushchin <guro@fb.com> wrote:
>
> Remove rlimit-based accounting infrastructure code, which is not used
> anymore.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
[...]
>
>  static void bpf_map_put_uref(struct bpf_map *map)
> @@ -541,7 +484,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
>                    "value_size:\t%u\n"
>                    "max_entries:\t%u\n"
>                    "map_flags:\t%#x\n"
> -                  "memlock:\t%llu\n"
> +                  "memlock:\t%llu\n" /* deprecated */

I am not sure whether we can deprecate this one.. How difficult is it
to keep this statistics?

Thanks,
Song
