Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A062C6B0D
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732820AbgK0Rya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732804AbgK0Ry3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 12:54:29 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53502C0613D1;
        Fri, 27 Nov 2020 09:54:29 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id x17so5211164ybr.8;
        Fri, 27 Nov 2020 09:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R2n5HJcIf1w46ZD7sB3rPDuDX4FS8DO4ZIZINc4xU6w=;
        b=OiykdGxOzBE+EO44P+A5UjorUv8SkBOVtx1hSWToMdVhMS0EuHavtETJrMiQWh9n7b
         PKX0vDTbZ8Y4/V96O83mKPL8X6+PSurzFeJ6YSqjwPlmXe3uvkKDkoXURuRNcBs014DT
         UE5GhHA1I1n6Y0Mjc7IeEkYIfV/cSEboPkEbDthzfvAUfJ0tjtm2uMIfu3NMAU93khMo
         c31auu3FkiZk5Ieuf+LZVr14jgB4JtMBFAls70b/4qSiUf7K9ot317rDmGNijNep4Hgg
         8lgtYzL344rWo8FZdYfm+D0oFcIrx6QqB/kWNx4OldaS/hrSS03PVH6MF6lRM1XgKBe2
         GGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R2n5HJcIf1w46ZD7sB3rPDuDX4FS8DO4ZIZINc4xU6w=;
        b=Xhq+mzK7A6aEDeTH+XjahshFDq8NNk1t2lkppEGR6wGIm9HGGKNb2xBYblPjI0UrBy
         DHd5r8r5nRs3Tx+wz/xAgnNXpWnEJd+aj361dgqtcFuQBi85jvTBoCluD5rCLdusdPC8
         ShMOcxKoa3o7Wz5cUiJmcrW0ow6hgz45jE1o2cYIlv3nvczB3ueteQqE27W9REe66X71
         jNue9Ng30QZotAGrXNf3vjd+/Gagv590roSsCFVlhew0SWXX7C5mzpb70bJTPXHji8qw
         NKbULIWrHsbbZflgPrfPQIIcvbV5uEEwZoyyBQrLTFrWt3Y0xvBMAAaBqRaustcxpLQZ
         z/yQ==
X-Gm-Message-State: AOAM5319twE31ts9ldFN2/LCQyYsY/FR8PR8qPGAcD0wu5jjF+/c5UJq
        DbJgalhKiFoiLMzNVTHrodbEvCGXkln8X6ZnvSk=
X-Google-Smtp-Source: ABdhPJzR8o5uH/+EkUS6AGUpGVMVrM8tT5Dr3pIMPH4RFS7LU6IzqlyRYJnfwLtoWw8EsOEyyTowbsTMJwHyKYv/XLg=
X-Received: by 2002:a25:a4a1:: with SMTP id g30mr13618769ybi.195.1606499668367;
 Fri, 27 Nov 2020 09:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-2-weqaar.a.janjua@intel.com> <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
 <1bcfb208-dfbd-7b49-e505-8ec17697239d@intel.com> <CAPLEeBYnYcWALN_JMBtZWt3uDnpYNtCA_HVLN6Gi7VbVk022xw@mail.gmail.com>
 <9c73643f-0fdc-d867-6fe0-b3b8031a6cf2@fb.com>
In-Reply-To: <9c73643f-0fdc-d867-6fe0-b3b8031a6cf2@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Fri, 27 Nov 2020 17:54:02 +0000
Message-ID: <CAPLEeBZh+BEJp_k0bDQ8nmprMPqQ29JSEXCxscm5wAZQH81bAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: xsk selftests framework
To:     Yonghong Song <yhs@fb.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 at 04:19, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/26/20 1:22 PM, Weqaar Janjua wrote:
> > On Thu, 26 Nov 2020 at 09:01, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.=
com> wrote:
> >>
> >> On 2020-11-26 07:44, Yonghong Song wrote:
> >>>
> >> [...]
> >>>
> >>> What other configures I am missing?
> >>>
> >>> BTW, I cherry-picked the following pick from bpf tree in this experim=
ent.
> >>>     commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
> >>>     Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>>     Date:   Mon Nov 23 18:56:00 2020 +0100
> >>>
> >>>         net, xsk: Avoid taking multiple skbuff references
> >>>
> >>
> >> Hmm, I'm getting an oops, unless I cherry-pick:
> >>
> >> 36ccdf85829a ("net, xsk: Avoid taking multiple skbuff references")
> >>
> >> *AND*
> >>
> >> 537cf4e3cc2f ("xsk: Fix umem cleanup bug at socket destruct")
> >>
> >> from bpf/master.
> >>
> >
> > Same as Bjorn's findings ^^^, additionally applying the second patch
> > 537cf4e3cc2f [PASS] all tests for me
> >
> > PREREQUISITES: [ PASS ]
> > SKB NOPOLL: [ PASS ]
> > SKB POLL: [ PASS ]
> > DRV NOPOLL: [ PASS ]
> > DRV POLL: [ PASS ]
> > SKB SOCKET TEARDOWN: [ PASS ]
> > DRV SOCKET TEARDOWN: [ PASS ]
> > SKB BIDIRECTIONAL SOCKETS: [ PASS ]
> > DRV BIDIRECTIONAL SOCKETS: [ PASS ]
> >
> > With the first patch alone, as soon as we enter DRV/Native NOPOLL mode
> > kernel panics, whereas in your case NOPOLL tests were falling with
> > packets being *lost* as per seqnum mismatch.
> >
> > Can you please test this out with both patches and let us know?
>
> I applied both the above patches in bpf-next as well as this patch set,
> I still see failures. I am attaching my config file. Maybe you can take
> a look at what is the issue.
>
Thanks for the config, can you please confirm the compiler version,
and resource limits i.e. stack size, memory, etc.?

Only NOPOLL tests are failing for you as I see it, do the same tests
fail every time?

I will need to spend some time debugging this to have a fix.

Thanks,
/Weqaar

> >
> >> Can I just run test_xsk.sh at tools/testing/selftests/bpf/ directory?
> >> This will be easier than the above for bpf developers. If it does not
> >> work, I would like to recommend to make it work.
> >>
> > yes test_xsk.shis self contained, will update the instructions in there=
 with v4.
>
> That will be great. Thanks!
>
> >
> > Thanks,
> > /Weqaar
> >>
> >> Bj=C3=B6rn
