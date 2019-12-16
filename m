Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830D81215AD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbfLPSXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:23:48 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33344 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731580AbfLPSTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:19:53 -0500
Received: by mail-qk1-f193.google.com with SMTP id d71so4147774qkc.0;
        Mon, 16 Dec 2019 10:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bw9AtwUBEToIbGXQOuZTfxn3HP4b1RzcJoAgplBWH2c=;
        b=cH3p/ut94iaUViO3y6KSqV/aq/x4Rn73X0jksVn0LK2n9cPrIc+V0pEPbzUdeyHGml
         u9aqjkgCfxMA/FTtPVcEB00vnG25Ut1eD/D05A52OjDRkscktTxR+gFJWZH5aALTuwz5
         Tts0cBhxS6F7cF65RCW33UfiaMdSm9S9wykAGbjuXk/AwElaY03py4wbXW8tOE4NSlfI
         /bOU9DkEyHnZRKy8gO2Cy7r3IzJYVOQ2g+vBL4m+BVpOqUyBgAm8a8GX0mLBL8jW5ygJ
         JaZfUSX81x3CsMAvfHJd0ssZU9NoKkjW3xPATmlppjvkQEx+sJIB9W5QZROABFxionGv
         nryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bw9AtwUBEToIbGXQOuZTfxn3HP4b1RzcJoAgplBWH2c=;
        b=GJJVwZHs6wQLIDDuHshzxtGx9/jYpFgR44zxe3WSc9uL2MWyooxEyvHPvUalWOpj8b
         H22Jh1RaiiPgLZedFJIMAlVtDAIAniC7hxGAw9iSlzAeX2OIZDPk6ITOH0mLuU8sZPHm
         IuGSMHQCCGW17Hb1RxMuDg4/AnB9B+R9C5MZN8zWewb84GBklIq6XRCcixYGQEqixpPA
         iGOa11WBPnn781mrS58bVcXL2k1uzYeZMiqhohGPga+UsWrBhm99IQGiinGr5L8mMHVq
         bZOTnYTjTtkVlhvi48fVVHNhwbPRmXOsLBRUWdIv7kTJLWs0MC4cUrFwEb4XRzTDLvc3
         hMHA==
X-Gm-Message-State: APjAAAVI/AEU62sNs6NLBHBZoCNp/ZttpmI3ECvi0ktdCChdIv6AtTim
        dqxghcEbr1yNusvmI1xiCH7iGDezsglyT3mkDmI=
X-Google-Smtp-Source: APXvYqwJpt3UQMEjQS85Yx5PyPIijZpDnPfaLMLs2iNueOb9WoyL5nKMdZY7eJ5tDzg51LiccfXVf/XmgTJm2amIfrc=
X-Received: by 2002:a37:a685:: with SMTP id p127mr610490qke.449.1576520391767;
 Mon, 16 Dec 2019 10:19:51 -0800 (PST)
MIME-Version: 1.0
References: <20191214014710.3449601-1-andriin@fb.com> <20191214014710.3449601-3-andriin@fb.com>
 <20191216124347.GB14887@linux.fritz.box>
In-Reply-To: <20191216124347.GB14887@linux.fritz.box>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Dec 2019 10:19:40 -0800
Message-ID: <CAEf4BzbQFPX7=QLPAv-A4FtK=bVQaA+=gbSJ1DEQ4y-bfY+ffw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern variables
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 4:43 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
> [...]
> > Config file itself is searched in /boot/config-$(uname -r) location with
> > fallback to /proc/config.gz, unless config path is specified explicitly
> > through bpf_object_open_opts' kernel_config_path option. Both gzipped and
> > plain text formats are supported. Libbpf adds explicit dependency on zlib
> > because of this, but this shouldn't be a problem, given libelf already depends
> > on zlib.
>
> Hm, given this seems to break the build and is not an essential feature,
> can't we use the feature detection from tooling infra which you invoke
> anyway to compile out bpf_object__read_kernel_config() internals and return
> an error there? Build could warn perf-style what won't be available for
> the user in that case.
>
> https://patchwork.ozlabs.org/patch/1210213/

libz is a dependency of libelf, so this doesn't really add any new
dependencies. Everywhere where libbpf could be built, both libelf and
libz should be present already. Unfortunately now that libz is
directly used by libbpf, though, it needs to be specified explicitly
in compiler invocation, which I missed for samples/bpf, sorry about
that.

>
> Also, does libbpf.pc.template need updating wrt zlib?

Yeah, wasn't aware of it, will post a follow-up patch adding -lz there. Thanks!
