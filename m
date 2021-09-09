Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76617405CD9
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhIISZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 14:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbhIISZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 14:25:56 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D89C061574;
        Thu,  9 Sep 2021 11:24:46 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id v10so5732675ybq.7;
        Thu, 09 Sep 2021 11:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KzqhAoSAPM6bZ1hCV3tRQyqH8rphFgNmfKLy7TWm2X0=;
        b=btqKcU2HmL2BiBkmMCBIvNpTv3lp9pBtN8nj0oQXXN9kB8pVTrF67gKDwMu0IePTNd
         jDaITWvzAkaqLUwPqlPHdoX736EqOp86F/6mKgPcS1L8RHkQ+6wnMe/PXXXRtLWqIB10
         6PFrRpiZG4DMZWlJwO+rZ+ikO+Kg7cOBQVo5IkWY+OIUmAoteirWygMpeJaum5J0j24h
         cL/DFO/LF86L6SqpdxKV1zyCpp/aCtnJ4q5oGY9ZsiEHIWza0NujaOZvcuUZkG1HExIR
         Xy53lvrxe/aN/7FMr4lJq1ZsLItpPeWOUYM3rM3Z0uRPYMXiuF5P3nxL/mLSIactNFbB
         uVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KzqhAoSAPM6bZ1hCV3tRQyqH8rphFgNmfKLy7TWm2X0=;
        b=gINDvb1dCN5vNostt8CFEJhC7oCREspsaxA23Vn4JZqUOspa9bojhv2FmyvTH04jXD
         vvejSV8CmqrZyY04iMOlhcbApxtuXDcL1yysEA3d2yWFx+z15jqo2ilPumsiaKXkwwFK
         YPk2GfinV+93NL+6xE4DCmMjNirr4T3TNaLjFr6gQnuepJE4NJhAtiXa1vrG8O49+KpO
         Ixh7sQ5u3DFhsVbxmrPF5D2tCGbYK/SaMFFbPv3+jMSm5ncnQi2qktWkoGNXg5ikg+6N
         ZHeVZVZCbPEKKVhQW4+1c5RIPQwyml0Omsl/cS02nOE0WvypkiR6XxVSzDANMnJ8Ov2w
         s51A==
X-Gm-Message-State: AOAM531Tmzg5EfNt2doTEpkVqrJ4YxggGuc8XNO9eivPsUMzhuNFCbhf
        AGTrP/a7tT1chpsBLNtUcYaspW8AlgrJC/ydjwI=
X-Google-Smtp-Source: ABdhPJxvIPKE9S4snyMEjt+/biIRqw07FXYDwejFlVyDe8Kayu7VSZp6pM8XTr34PIDjaezpZlF81t4UbKNVvyTDw4k=
X-Received: by 2002:a25:3604:: with SMTP id d4mr5260859yba.4.1631211885893;
 Thu, 09 Sep 2021 11:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <1e9ee1059ddb0ad7cd2c5f9eeaa26606f9d5fbbf.1631189197.git.daniel@iogearbox.net>
 <6196fbdd4e40a07f18669cd08b29c5016776067b.1631189197.git.daniel@iogearbox.net>
In-Reply-To: <6196fbdd4e40a07f18669cd08b29c5016776067b.1631189197.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Sep 2021 11:24:34 -0700
Message-ID: <CAEf4BzZMan5TCZoey2JJvAevs5WYFQyOuuy+niOvxUpGAXXTMw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/3] bpf, selftests: Add cgroup v1 net_cls classid helpers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        tj@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Martynas Pumputis <m@lambda.lt>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 5:13 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Minimal set of helpers for net_cls classid cgroupv1 management in order
> to set an id, join from a process, initiate setup and teardown. cgroupv2
> helpers are left as-is, but reused where possible.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/cgroup_helpers.c | 118 +++++++++++++++++--
>  tools/testing/selftests/bpf/cgroup_helpers.h |  16 ++-
>  2 files changed, 122 insertions(+), 12 deletions(-)
>

[...]
