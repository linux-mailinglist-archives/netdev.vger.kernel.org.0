Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80748FA46
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfHPFQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:16:20 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34700 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHPFQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:16:19 -0400
Received: by mail-lj1-f195.google.com with SMTP id x18so4232490ljh.1;
        Thu, 15 Aug 2019 22:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXT56wysrSUKT0mrZs1SZsEmms88zrluxlXTsaKbuCw=;
        b=kDSc6L3xsrMjEexDgEG7IBJJuFT2T/v846y+amyRWBkRInSNhF52xBVOvPO6MACEyF
         wT3hXV8YBn1JTgAymE+IVXwIIZlHOLbDE8EGS38Bod/ekyYQvD2cwXDU9ZEJeg1MXgn7
         n7gj3rQiq/cS7/gfhk+yH07AgWFGZYZfdyTY0zHiA+v1hWQgMyyqXiKRzFXC05oTdA7Y
         VyZKDOx8FgQQwjrTnLDankfFlTfEQjUhP4MitReZ/OiYl6KSqW+EFNML1RDVDTHh0zJr
         cyZP/KrmvJQzwUWFyXX+ysQ73SyhCAqoEo95Nx7v9n0OT8VDPAZONWcip6oHeOeVulau
         0F7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXT56wysrSUKT0mrZs1SZsEmms88zrluxlXTsaKbuCw=;
        b=TGwYR55u9MyXuV5aW5JfqIFdUk70GjloYj0q5X6Rm/2H0f+D1x2TBvRkv9ufz/d4Iy
         ARs1LV0sT4oIAFiFr948uicp2W5U68RPz+YXy+s55B6M4CIH329ooBAI0gHE9PVznOsm
         u0/e4zev9AldV7fHZe4GQxs2aSThmeCYqp9spkcqpxO7hotovnbCB3mGmr41TiIpYosn
         KWc8a8avm2C9jFkdx1q6bIf0ua/WTaiqX+qnXCGkg0n7QizC/pI6ow314fi45KjuRuFJ
         lOrOMExEUe4EEohC785XYhvWZutwUv+NRYoDM0SyVX3ZZWgNiXpXtK/LI83k0+wRWK+g
         jeEQ==
X-Gm-Message-State: APjAAAUMfpNkXSbzikXF1tK4JymYxP8098h+VcQN/IeY99q1AFCsZqzH
        xwWPQmTE7W2d587cEmjQCgZzqCsefP1qSmN+odoGXw==
X-Google-Smtp-Source: APXvYqzqZ4Qx86aACw9yZh7/lTrjsdYjL6aRwZS74hkZUt90oVG4d4E/63Om/IKiIbXKvlWaSw9WRYmdtVqomXwoV1E=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr2839746ljc.210.1565932577762;
 Thu, 15 Aug 2019 22:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-3-sdf@google.com>
 <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
 <CAEf4BzaE-KiW1Xt049A4s25YiaLeTH3yhgahwLUdpXNjF1sVpA@mail.gmail.com>
 <20190814195330.GL2820@mini-arch> <CAEf4BzaEJcTKV6s8cVinpJcBStvs2LAJ+obNjevw54EOQq1QdQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaEJcTKV6s8cVinpJcBStvs2LAJ+obNjevw54EOQq1QdQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Aug 2019 22:16:06 -0700
Message-ID: <CAADnVQ+Bz6R17bassdr3xOR7rhbuw-HbdXYu-hHkxE8S2WiNrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: test_progs: test__skip
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 1:01 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> >
> > Let me know if you see a value in highlighting test vs subtest skip.
> >
> > Other related question is: should we do verbose output in case
> > of a skip? Right now we don't do it.
>
> It might be useful, I guess, especially if it's not too common. But
> Alexei is way more picky about stuff like that, so I'd defer to him. I
> have no problem with a clean "SKIPPED: <test>/<subtest> (maybe some
> reason for skipping here)" message.

Since test_progs prints single number for FAILED tests then single number
for SKIPPED tests is fine as well.
