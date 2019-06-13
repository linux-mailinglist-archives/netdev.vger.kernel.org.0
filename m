Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0DA43E37
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389374AbfFMPsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:48:17 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42005 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732210AbfFMPsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:48:02 -0400
Received: by mail-lf1-f68.google.com with SMTP id y13so15456990lfh.9
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 08:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MhxG2VWV0PUqNmkC6UYengHNix8YULmmoQX86iMuI1Q=;
        b=HwzQ0rH3HntP0X1Ut+3aziFTUNyu7eZWshFffAcbuEQadz4P6sC2snoDJGp4KSyvu2
         Kig7hRqtroYC7jNl67KKgqHxE423RPSnEeZfbHsd+gLto0eo7V3yt/GGwc+21qgO0c3A
         GIH+62EGfN0eHFV/TMnqz5oJqV2MDDVZaYpN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MhxG2VWV0PUqNmkC6UYengHNix8YULmmoQX86iMuI1Q=;
        b=t2KaoYVqi3w+eKI8T74GHsBp9LJAk9lUeJgcccoWkkqYnIb5Z4suwH2KzJpdN6YgT4
         HJdDMz/Pi+m/uYi9ogBAwC603Yc8Dit0QXR4rqbhI+uPFLniY2pxm9xDHCIki4BpIUm5
         OPmutNFTZldBchTgwmXI5Lp+nqekPLZ97sOiUEoJzl4ibIM4FSgU9WcrXppKQ2eY2Rzr
         B8+3oCJgHJVWPkz/x332YCO+tbAsQWFr2eIIb6jVcaTT9P65LsOhc+z5r4VsVFw/8qux
         IC1xA46oSTWPdVSe3qMBxKNOH9gD3c7jDbnyz0dk6sYxM97BthvdAQ+dFbfK1CCbSCEO
         0xqQ==
X-Gm-Message-State: APjAAAX4c5AulMDIUkpl4D+vOMufD8vXC7aCkpcfXrMPJEeCZPC0DaST
        3eSz3JLOQmZrGGxmGaeQIa/DPz4nHZdBT1jc3Pak4g==
X-Google-Smtp-Source: APXvYqzrRigc/QwtHv0h+SK0yPrIqLoP/sTRt4T7cb0mR/3kmBMhY1s0fNVfrmh2vHW4vI1uCiYqipwR2/fMUdkpn8I=
X-Received: by 2002:a19:c383:: with SMTP id t125mr38852030lff.89.1560440880394;
 Thu, 13 Jun 2019 08:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190613112709.7215-1-afabre@cloudflare.com> <20190613154152.GA9636@mini-arch>
In-Reply-To: <20190613154152.GA9636@mini-arch>
From:   Arthur Fabre <afabre@cloudflare.com>
Date:   Thu, 13 Jun 2019 16:47:49 +0100
Message-ID: <CAOn4ftu8dv4rOei=Janw8bRMGLM5bganNGjp3nLUof82Z9vSiQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: selftests: Fix warning in flow_dissector
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kselftest@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah yes good catch. I guess it hasn't made it into bpf-next yet.

On Thu, Jun 13, 2019 at 4:41 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/13, Arthur Fabre wrote:
> > Building the userspace part of the flow_dissector resulted in:
> >
> > prog_tests/flow_dissector.c: In function =E2=80=98tx_tap=E2=80=99:
> > prog_tests/flow_dissector.c:176:9: warning: implicit declaration
> > of function =E2=80=98writev=E2=80=99; did you mean =E2=80=98write=E2=80=
=99? [-Wimplicit-function-declaration]
> >   return writev(fd, iov, ARRAY_SIZE(iov));
> >          ^~~~~~
> >          write
> >
> > Include <sys/uio.h> to fix this.
> Wasn't it fixed already?
>
> See
> https://lore.kernel.org/netdev/20190528190218.GA6950@ip-172-31-44-144.us-=
west-2.compute.internal/
>
> > Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/=
tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > index fbd1d88a6095..c938283ac232 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > @@ -3,6 +3,7 @@
> >  #include <error.h>
> >  #include <linux/if.h>
> >  #include <linux/if_tun.h>
> > +#include <sys/uio.h>
> >
> >  #define CHECK_FLOW_KEYS(desc, got, expected)                         \
> >       CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) !=3D 0,          =
 \
> > --
> > 2.20.1
> >
