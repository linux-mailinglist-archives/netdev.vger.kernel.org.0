Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0386E2171
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfJWRJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:09:22 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46675 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbfJWRJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:09:22 -0400
Received: by mail-lf1-f66.google.com with SMTP id t8so16694861lfc.13;
        Wed, 23 Oct 2019 10:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XUx8mAjfc4FNj3mN4GeU+7ckSmMcs87Tvc70MWHpxzg=;
        b=X5rWQekCf373fwk9I72lTudIA+OanhJvLTebV1EADo4SbBREhFThiUiyMdNZEkqtEp
         9kvLClUKk42C7TIy7Fvn+r2PGmLKv6fVUhwEU8LA3awBr7Z6ly6H4EyxbCoXDh47S5Hc
         m5xVbCRW7x0K7zjRPrypYIBlxE0uNiBZ9G5q2/vBeL+VUNEhGAy61Wiyi2BzS0ae+b6G
         HY3aKN46e01MQ6alb4DnI9ycF1l7RxNS6om/3HEnI/o3KdQOImdLOYeSXOhMP5MCP/CH
         9munwYsTuVMAZbqMIncuc8rS/7gBTLoRwWQbX0MrmQu61AvWwXaCx/ef+tKczk4/fpfU
         NKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XUx8mAjfc4FNj3mN4GeU+7ckSmMcs87Tvc70MWHpxzg=;
        b=V/cEI7NRkXhCDjGtqyFbhoG89YrorKXzCELY/YRNQKlbrNxTNJkuj5SNy/o8e6T7+O
         WtTyiiPoYc5okyVCbOoerrf1/o8xUpqHSPaW1ds2nQhvurmF03rQfunqlIAhxCOk9/x5
         8ldjz4GWiELd3zedCgpJtUzHeebeQgmj3nLWTsFytGr1JvmFIYp9YqDSXTpHSFsb62WO
         nI93t+klvM5ev+3XglUvKi65PbVJ1noHTlXVEM9VJ6YM9Cgpv26tMjihfvgW9sLHS9vk
         LGdeLJNfTRxGxbuHBPY85C5cSOmvHkHFOgUgpOPI0NBW9/SMUg6MoZr7Iu3AE0O4lXp0
         h66w==
X-Gm-Message-State: APjAAAXfog2sxDi8/O5m+yzEl6w3JfwUsZf7sUbVPXMwubQtJp/ycDAN
        +0cqoaeRBjeYU+fALbdXw3P8vWQBU5ttRLDfX7E=
X-Google-Smtp-Source: APXvYqw/CkLuQCR1Vz/2ZgRqJdpfOOCv0kJ1wAiZFJkprwltJySbOd/0oFDTi5sD43PWVhCAdFCjIEqc75A+zUFZFiA=
X-Received: by 2002:a19:10:: with SMTP id 16mr15896882lfa.100.1571850560199;
 Wed, 23 Oct 2019 10:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191023060913.1713817-1-andriin@fb.com>
In-Reply-To: <20191023060913.1713817-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Oct 2019 10:09:08 -0700
Message-ID: <CAADnVQKAksPVLO3yroxa2ObWZXKw9JN5XZoObevv_4tB_cg+8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: move test_section_names into
 test_progs and fix it
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 11:18 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Make test_section_names into test_progs test. Also fix ESRCH expected
> results. Add uprobe/uretprobe and tp/raw_tp test cases.
>
> Fixes: dd4436bb8383 ("libbpf: Teach bpf_object__open to guess program types")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
