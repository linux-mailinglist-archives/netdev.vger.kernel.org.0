Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705FC1C0DAD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 07:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgEAFQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 01:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgEAFQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 01:16:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D13C035494;
        Thu, 30 Apr 2020 22:16:04 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so1655149lja.13;
        Thu, 30 Apr 2020 22:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D00DqwLp1pIkCBQPFGQl7gIJVCS8/hRa1H7R7PcZvC0=;
        b=KCHL0GWQjV+/Vcy6mMKmvihoMXLEC1KLzWhotLuUqEhNq1BCETeBtFuU0xquauOwQW
         PKf2wIk5/m/wKKS2YKd5PyMgR8f9uTHNg+Q7tulGlUwO6BmuX5VTJBE0Q4MLc2Yk++az
         6BzbmTU9isVBiJIucl3uFdzOpzJxf40dD8TJG0aWPRjseCZjsjS5hgbCKZDwFgqlWu5w
         swDucdz3ti+cUoNMouMDmbVFAryxKuCEae9Iy4V7+my9YaGKCiTEte3VS9ga2vrUw+Rl
         CEWwnJWQpu63K/8AfUwl5En80amp+kVWvTH7BpXkTSVzFspPG/vRzwfiSJCJoCc69S9W
         TJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D00DqwLp1pIkCBQPFGQl7gIJVCS8/hRa1H7R7PcZvC0=;
        b=W8kYA62Ytp8M8RkmGUEu8UzkEBQbsb9uWn+mlQUAY/I4oz0ShVnCWnLUisGqdLnpdA
         XkZR4iLjggBU0io0qGEcVXSXG04fwwCZE+8kbrYhraySRR1yFtb5B7a69bvFKQsYWo/i
         zPJRtowI8KOsuT5oxnmHLEDqyRkMvtmi0YUG+OGyzhoIBg1RH/sA7BC4GhWH0m3uLM66
         OpNRcZ0Id97aKggWQOWiSMryjAbYcNa5j2BT/TcdutPhwcLTGcxbOad7pb2lCpA00WY0
         s3LvUXdxU+GvVqXSWTFm3Ns5PU4Y6H/78lW8x5V2EROhT2hMfSPJD2Xs1cOOgJxuXT6R
         7Brg==
X-Gm-Message-State: AGi0PuYah0f8pZjgJUECVr6bg9bV9I+lmhttj8d4XGVKO8LmonhWujtz
        XitcGwtNWVHH4jr37jY0FQrcdwUdSraBXYVhTvX88w==
X-Google-Smtp-Source: APiQypKi4WrKP2xDoGnVXIC/UwV7doDPgLzDNy1snvMiqG21XF1URHfcuQljZvH54wwj5brVMztQOnS98yRF5Go25XA=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr1431017ljo.212.1588310163069;
 Thu, 30 Apr 2020 22:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAK7LNARHd0DXRLONf6vH_ghsYZjzoduzkixqNDpVqqPx0yHbHg@mail.gmail.com>
 <CAADnVQ+RvDq9qvNgSkwaMO8QcDG1gCm-SkGgNHyy1gVC3_0w=A@mail.gmail.com> <CAK7LNAQ5NMZWrQ_1yk+_-06zrmYMOcKvNnuX=u1sReuy6wg9Gw@mail.gmail.com>
In-Reply-To: <CAK7LNAQ5NMZWrQ_1yk+_-06zrmYMOcKvNnuX=u1sReuy6wg9Gw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 Apr 2020 22:15:51 -0700
Message-ID: <CAADnVQKymMnEs0jFg8-qZLXS5n0DxMrqhmwQ17Do=TKd+niqhw@mail.gmail.com>
Subject: Re: BPFilter: bit size mismatch between bpfiter_umh and vmliux
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 9:06 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Hi Alexei,
>
> On Wed, Apr 29, 2020 at 1:14 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > >
> > > At least, the build was successful,
> > > but does this work at runtime?
> > >
> > > If this is a bug, I can fix it cleanly.
> > >
> > > I think the bit size of the user mode helper
> > > should match to the kernel bit size. Is this correct?
> >
> > yes. they should match.
> > In theory we can have -m32 umh running on 64-bit kernel,
> > but I wouldn't bother adding support for such thing
> > until there is a use case.
> > Running 64-bit umh on 32-bit kernel is no go.
>
>
> Thanks for the comments.
>
>
> This issue will be fixed by this:
> https://patchwork.kernel.org/patch/11515997/
>
> and the Makefile will be cleaned up by this:
> https://patchwork.kernel.org/patch/11515995/
>
>
> They are parts of the big series of Makefile cleanups.
> So, I will apply the whole to kbuild tree.

thank you.
I saw the patches, but didn't have time to test or comment on them.
To be fair umh logic was bit rotting a bit, but that will change soon.
