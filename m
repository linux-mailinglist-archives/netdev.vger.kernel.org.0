Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B3B3A7688
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhFOFhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOFhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 01:37:13 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECDEC061574;
        Mon, 14 Jun 2021 22:35:08 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p15so3584636ybe.6;
        Mon, 14 Jun 2021 22:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZSb20v3TQ4zzstf510FhyejuBC6NRGFH1dcyT2rRtEM=;
        b=t0B5/XMVM9BQF01hy2fvl8b+3PJwuILi+DeIipMGlsnfW++HPynCiYkg3xaj72a8JJ
         YSgIU+CBpNg/QEp9MiqTSRtFiakho2R+pnLiMtnNcVqZz63iVuw2M39KsAN0sjURQUwW
         eH5k32hGWX3iXxBFqePO2t5wtBxNSFVJnoJh/8J7MJCCqcrKOknPgYqN24keBK0aTvCv
         BJPJXVRgSmb+Yn8l1MtVCPWZ+yszHiT07KwOwUIuOA/NfCjYQoAgOO+A+yXi8PhgkCLx
         6SqwNIgLaFe+uWKPMLiGECT5wHVp6EpgLU5JjVzwnIXNvF3Sux/6xtmtbfdwQjy6zuzl
         zxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZSb20v3TQ4zzstf510FhyejuBC6NRGFH1dcyT2rRtEM=;
        b=aNQoK/bCgVSO5JaVrbEevrzMtV1RmvBT/MBT2Oe9yF1k02/Zg2IWbFWtTO6bhw5V39
         ahHDAqjMa9FUdgMLiGkemp28/PmpPI8SE5mhwKoZpCZBvJc8SsrslAybdhLj+tI1Fd1G
         kZMEZndaXnzKdPDFg8nMzkb4b6DvPdKNMR9RDW0Ur6gW87pK+66gV+H6XzZcbSrBkz0N
         DXOUX71rlpL6vFnDg4booBLvBcQYOWK6wLyk1LdQ2FDoY6YfbxgiymGS2JfbmcWmcsGf
         h620xKc7OqAd/dlBFU4dXpyBSQOYU/CJvJWzN5kphEVMUat8isKXPiG/1RCl5YEWtAF2
         4dJQ==
X-Gm-Message-State: AOAM530+KXyq1QnfeJp7M+wzHhuYYgBypJ8k/cwLUO33jCnSPIiOAM9/
        ZAOhLOQdRp/2FqOjalNy0SM/dL1KD/bx2zJ91ng=
X-Google-Smtp-Source: ABdhPJzYvnjv/qs4xYa79NKg6w/rKLQRt+EhNap3MO02PPME1wjuVeAqVvnuvXNWFub7hMwceklJX1UTQvDeec7ENn4=
X-Received: by 2002:a25:4182:: with SMTP id o124mr28745293yba.27.1623735307701;
 Mon, 14 Jun 2021 22:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <CAEf4Bzar4+HQ_0BBGt75_UPG-tVpjqz9YVdeBi2GVY1iam4Y2g@mail.gmail.com>
 <CAHn8xckZAwozmRVLDUuPv-gFCy9AaBC-3cKZ4iU4enfkN5my-g@mail.gmail.com>
In-Reply-To: <CAHn8xckZAwozmRVLDUuPv-gFCy9AaBC-3cKZ4iU4enfkN5my-g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Jun 2021 22:34:56 -0700
Message-ID: <CAEf4BzbHbGe6nca+RpUrCh3UT3+1tntzj+RK1aKZ4kdvep=49A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] XDP bonding support
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 5:25 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> On Thu, Jun 10, 2021 at 7:24 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jun 9, 2021 at 6:55 AM Jussi Maki <joamaki@gmail.com> wrote:
> > >
> > > This patchset introduces XDP support to the bonding driver.
> > >
> > > Patch 1 contains the implementation, including support for
> > > the recently introduced EXCLUDE_INGRESS. Patch 2 contains a
> > > performance fix to the roundrobin mode which switches rr_tx_counter
> > > to be per-cpu. Patch 3 contains the test suite for the implementation
> > > using a pair of veth devices.
> > >
> > > The vmtest.sh is modified to enable the bonding module and install
> > > modules. The config change should probably be done in the libbpf
> > > repository. Andrii: How would you like this done properly?
> >
> > I think vmtest.sh and CI setup doesn't support modules (not easily at
> > least). Can we just compile that driver in? Then you can submit a PR
> > against libbpf Github repo to adjust the config. We have also kernel
> > CI repo where we'll need to make this change.
>
> Unfortunately the mode and xmit_policy options of the bonding driver
> are module params, so it'll need to be a module so the different modes
> can be tested. I already modified vmtest.sh [1] to "make
> module_install" into the rootfs and enable the bonding module via
> scripts/config, but a cleaner approach would probably be to, as you
> suggested, update latest.config in libbpf repo and probably get the
> "modules_install" change into vmtest.sh separately (if you're happy
> with this approach). What do you think?

If we can make modules work in vmtest.sh then it's great, regardless
if you need it still or not. It's not supported right now because no
one did work to support modules, not because we explicitly didn't want
modules in CI.

>
> [1] https://lore.kernel.org/netdev/20210609135537.1460244-1-joamaki@gmail.com/T/#maaf15ecd6b7c3af764558589118a3c6213e0af81
