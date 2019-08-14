Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92BB8DE29
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfHNT4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:56:45 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45274 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfHNT4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:56:45 -0400
Received: by mail-qt1-f195.google.com with SMTP id k13so14217221qtm.12;
        Wed, 14 Aug 2019 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ww+ukQWhq8T3zW2D5eMGHhBPEXg0kxg6O6YWVSbyLu0=;
        b=Z5im4LRUTbqe71draDujv36ynaR5I7qnWRFDXujjJOzy8/wD1b7rPasp8FZ0ASV+FK
         2TOMISmoOdJ7DuiiaFYlzb9BQAokUydp8ZyR4t3xhk1tZM5T4q89XGdp4vgvIz3wTBGN
         ffr//kJA2Xy3cDRAURvIvGO8qv4/ro/22riaw2Bg/9dDRcetRHknLSh58Jf+0KNGPA6v
         lgx6bGTaXn0l4GBe5ERN9ErTjrki/EPLWVrJ2B3fH2L2nj5WJoF9oQPcTGGr3zqbYi0M
         dkSVvFrCEYMsPitD6HZNUOztYWReG85PTV3FVlII6yFD012SQJAF12TPOqyl9lHBi811
         DFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ww+ukQWhq8T3zW2D5eMGHhBPEXg0kxg6O6YWVSbyLu0=;
        b=gOIXH6EXbEq99u27/TqlAWtgJW640zSSJoqOG3WixZrPqD4BNwu83PMHGzIEczf1Pz
         Aj0W4PUBaIh8G8CZ7gRMFz1Hxj4YBaeXVVyZrSRImK+OgYqCCKuZAiTVnFtJlrAQpEcH
         TI6KhURiF43fNfbxoVX5B04Kvj3BOSpOhfOlYrPoahFC4osbNV5zcbEb0vZ+yDyoPnY0
         qrosby1lVpnfpzYMPGHe063un0TGD/UTNiwJcesEzZJDkLIdp97TaiVIJhSGWUszZe1f
         2MoCZLtQUaR4b7Zqmq/sqakTSEAwEDPmeDaQ5TtSAR9YCBPSvAhUrg4cf8qsd5WIB7As
         9rsQ==
X-Gm-Message-State: APjAAAVaDSh7YV2zmipsJT3Uc4M6gA5bG0sFvd16OfOQPP8lVms1Opez
        DVc9os4hhPe70aiVLwdyqCMKIOm2RIW/ei/TL8c=
X-Google-Smtp-Source: APXvYqxXSTAWwijyc9NlManHFj6IVa/Msxv4XU2yOuIwifQOSvJEefJBpvrsS3zKqV4PuA0PJ50+m8sLy2gTt5qDjGs=
X-Received: by 2002:ac8:488a:: with SMTP id i10mr891426qtq.93.1565812603868;
 Wed, 14 Aug 2019 12:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org> <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
 <20190814092403.GA4142@khorivan>
In-Reply-To: <20190814092403.GA4142@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 12:56:32 -0700
Message-ID: <CAEf4BzbyAHkL5pFoBCKPY7ia3voj7t2OkFDNKYqdyE1Fiuy4nQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get __NR_mmap2
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 2:24 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Tue, Aug 13, 2019 at 04:38:13PM -0700, Andrii Nakryiko wrote:
>
> Hi, Andrii
>
> >On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
> ><ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> That's needed to get __NR_mmap2 when mmap2 syscall is used.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  tools/lib/bpf/xsk.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >> index 5007b5d4fd2c..f2fc40f9804c 100644
> >> --- a/tools/lib/bpf/xsk.c
> >> +++ b/tools/lib/bpf/xsk.c
> >> @@ -12,6 +12,7 @@
> >>  #include <stdlib.h>
> >>  #include <string.h>
> >>  #include <unistd.h>
> >> +#include <asm/unistd.h>
> >
> >asm/unistd.h is not present in Github libbpf projection. Is there any
>
> Look on includes from
> tools/lib/bpf/libpf.c
> tools/lib/bpf/bpf.c
>

Yeah, sorry for the noise. I missed that this is system header that's
expected to be present, not internal kernel header, parts of which we
need to re-implement for Github projection. Never mind my concerns.


> That's how it's done... Copping headers to arch/arm will not
> solve this, it includes both of them anyway, and anyway it needs
> asm/unistd.h inclusion here, only because xsk.c needs __NR_*
>
>
> >way to avoid including this header? Generally, libbpf can't easily use
> >all of kernel headers, we need to re-implemented all the extra used
> >stuff for Github version of libbpf, so we try to minimize usage of new
> >headers that are not just plain uapi headers from include/uapi.
>
> Yes I know, it's far away from real number of changes needed.
> I faced enough about this already and kernel headers, especially
> for arm32 it's a bit decency problem. But this patch it's part of
> normal one. I have couple issues despite this normally fixed mmap2
> that is the same even if uapi includes are coppied to tools/arch/arm.
>
> In continuation of kernel headers inclusion and arm build:
>
> For instance, what about this rough "kernel headers" hack:
> https://github.com/ikhorn/af_xdp_stuff/commit/aa645ccca4d844f404ec3c2b27402d4d7848d1b5
>
> or this one related for arm32 only:
> https://github.com/ikhorn/af_xdp_stuff/commit/2c6c6d538605aac39600dcb3c9b66de11c70b963
>
> I have more...
>
> >
> >>  #include <arpa/inet.h>
> >>  #include <asm/barrier.h>
> >>  #include <linux/compiler.h>
> >> --
> >> 2.17.1
> >>
>
> --
> Regards,
> Ivan Khoronzhuk
