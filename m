Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132C710B63C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfK0Szq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:55:46 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39101 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfK0Szq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:55:46 -0500
Received: by mail-lj1-f194.google.com with SMTP id e10so16467616ljj.6;
        Wed, 27 Nov 2019 10:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2fxjJCT0Umg1tlImdCr24IAuRODORNzU/xb+VTe56+s=;
        b=vB0sSz4Y3YAKbLheatrpW/t/+AmJKdS3Xw309nuiHS2dDapGmmIvkxmmVJh+fXi5Dg
         gdqWAXpnG/oR+Olt4234Gf5zH4vB13ma3SqQN0iXy4AE2P9dH3V+HtXEnDYvq9Edo7vK
         fUeKEGhOFQz7TvHBuTvANCEQRi+7ZpjHI0+yBPMe8yYxAHb/Ffti/Tw0t9UnbJkP2ywc
         mMWN2BG+lux1uXbxUvTFo+CNncF3DbNvkL27neD5AqN7+YEPUyyYUX7tDGW+cGnrc7qo
         SBolkr047wGfIw1vOOxwhEhJ+ovL1XUgLtRjnc409Hae1rHQr3u5Bh0bYzV4u0nu/YLE
         DcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2fxjJCT0Umg1tlImdCr24IAuRODORNzU/xb+VTe56+s=;
        b=L10slxmjE/emQtYA6ApDAFimi6wml2jJDzfzE+wF/otRwxNtM7b009ifGRt411tr/W
         3/tR8kowcdPwvcakpyku/EDIV42uPGhMOYpu/3hAv/kSdsD9Y/NXYCeLsUIrxMuBZcg3
         taorUurwidMSdZianuy5F7dZtUXLx90LmQZ5WDxwrj3kqaBbLlqd+z9GguYIiLnVcWac
         po2FRYUQh6F4QiPzwvR39Et5l3weC5Q0XAM4Wk7MgZwSr1FyONVx9VmiyHJ57AVvTBGW
         2WhGXrO2CvhafdeljilXDNNNIzAT39bVWMJv4YxoubAhHyRC+cjs4B0FhvAUrhuzCBwX
         m/PQ==
X-Gm-Message-State: APjAAAUoC13vAuOTlbFn1lmbPcmG8ENbrZt1nUqCzSF0tpHRZULz6NoX
        3qXjSORuzeCaDRLZd2FWDLaBQGVAzUc3ubOowK8=
X-Google-Smtp-Source: APXvYqy2+d9ffng76tXB3kAzE96084n2upvu0rGFZzj8xbsKSZjCFw7TgmR1zGNmC+E4lMOzs72DmDKZeBUnT173n50=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr32610245lji.142.1574880942555;
 Wed, 27 Nov 2019 10:55:42 -0800 (PST)
MIME-Version: 1.0
References: <20191126190450.GD29071@kernel.org> <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org> <20191127134553.GC22719@kernel.org>
 <CAADnVQKkEqhdTOxytVbcm1QnBcf4MQ+q4KYaHzsuqkq3r=X-VA@mail.gmail.com> <20191127184526.GB4063@kernel.org>
In-Reply-To: <20191127184526.GB4063@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 10:55:31 -0800
Message-ID: <CAADnVQLs-=f8E8ahiW7F+_Qb1JiR4-7tXwVNbdyH1FF04RrOHA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use PRIu64 for sym->st_value to fix build on
 32-bit arches
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:45 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Wed, Nov 27, 2019 at 08:39:28AM -0800, Alexei Starovoitov escreveu:
> > On Wed, Nov 27, 2019 at 5:45 AM Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > >
> > > Another fix I'm carrying in my perf/core branch,
>
> > Why in perf/core?
> > I very much prefer all libbpf patches to go via normal route via bpf/net trees.
> > We had enough conflicts in this merge window. Let's avoid them.
>
> Humm, if we both carry the same patch the merge process can do its magic
> and nobody gets hurt? Besides these are really minor things, no?

I thought so too, but learned the hard lesson recently.
We should try to avoid that as much as possible.
Andrii's is fixing stuff in the same lines:
https://patchwork.ozlabs.org/patch/1201344/
these two patches will likely conflict. I'd rather have them both in bpf tree.
What is the value for this patch in perf tree?
To fix the build on 32-bit arches, right?
But how urgent is it? Can you wait few days until this one and other
libbpf fixes
land via bpf/net trees?
