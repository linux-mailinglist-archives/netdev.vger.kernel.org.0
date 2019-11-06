Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BD7F212F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfKFV6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:58:37 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36645 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfKFV6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 16:58:37 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so15816726lja.3;
        Wed, 06 Nov 2019 13:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qQDxOhCp7zemAOlkm6SneBgb53l55OqmRCOBdMxvSog=;
        b=MJo5CdjpdKcuVZqr4ofywByQhyIoO4iOG/aqySxbiVQzzxiP6v7lJJZ0kDm5b/vxvD
         Ac1AID8VO4WpEdW6mIcLAbU4qADoezrcNFWhhRciVhJrSvuxsW8CUV6D9t8r1ucdsVho
         vTbOWmR0AoGZ8xq0MAQ0N0zV5nuDC4A1nofzr+HHkuX65p1mXfvPDAoyu1duukP2rDMT
         f47DojQuewcVJ1UNRKu+XFT0qFl2tgzdSXnuD5Kq/b5OdzsoROw/hvpfuuLbTlIdt9UX
         NRaghsBB1BT/SJqvU/4zGRFs/kS6TwNyWIr5LZwnbIjda44j+/+pf9YDt+urRYnw8hiS
         cEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qQDxOhCp7zemAOlkm6SneBgb53l55OqmRCOBdMxvSog=;
        b=ZGNxgC4jrM27gmKywWN8RGSeRPtE292y0cIRNvQhcfUDuaxU+mx5wnjjFXxPT1VnaW
         UfA5hDYe46DD4gxi6FmP9sA2FOE8Z4HOx6w7ENgaHkTHMI8I58ZKfKbGwkAR91771KyU
         Nl2Y21yA/OdliPyfEA4cHUFnM5i35fZFPgUP8jAFWHbKG2P6JfIZdIIOV7UOC1vFC6Ix
         1X+iG2YcTVD7P9VIpfuNUhwkNv3793+mxrRWuejZQ6dd1UdjyK1xUnOO8/jeCMfyG0r5
         gy7fo8Vbhi3MAHgiuCm8qoFHoSf2yQdXpNqyxrDj6Y12AdO7ae9yPijllve+kcM9gY0D
         IcPQ==
X-Gm-Message-State: APjAAAWeMhVbehnxEkOsC7K55AhIIJs5Ncchcuxy3/q0ySnXd0+mN7JI
        OUdLFsLhad4NGyZFfXCGU2HjeuD8EMLF8yUQlPI=
X-Google-Smtp-Source: APXvYqxPL55CLYLKIvIrL7WZBSDZdtgEYY2U5g9u8XiaklJT+EzFzFIdg5dIpxVPBrCeJvx7ruIPhNk0k8BnYiegMvU=
X-Received: by 2002:a2e:7d17:: with SMTP id y23mr3629395ljc.228.1573077513659;
 Wed, 06 Nov 2019 13:58:33 -0800 (PST)
MIME-Version: 1.0
References: <20191106201500.2582438-1-andriin@fb.com> <bdc51aac-6d39-13a6-f50e-8fca3d329b4b@fb.com>
In-Reply-To: <bdc51aac-6d39-13a6-f50e-8fca3d329b4b@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Nov 2019 13:58:22 -0800
Message-ID: <CAADnVQ+EHbJ950L93Wa4ZxJDQ_PvPwv-re9+95GighudmN3iDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: simplify BPF_CORE_READ_BITFIELD_PROBED usage
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 1:21 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/6/19 12:15 PM, Andrii Nakryiko wrote:
> > Streamline BPF_CORE_READ_BITFIELD_PROBED interface to follow
> > BPF_CORE_READ_BITFIELD (direct) and BPF_CORE_READ, in general, i.e., just
> > return read result or 0, if underlying bpf_probe_read() failed.
> >
> > In practice, real applications rarely check bpf_probe_read() result, because
> > it has to always work or otherwise it's a bug. So propagating internal
> > bpf_probe_read() error from this macro hurts usability without providing real
> > benefits in practice. This patch fixes the issue and simplifies usage,
> > noticeable even in selftest itself.
>
> Agreed. This will be consistent with direct read where
> returning value will be 0 if any fault happens.
>
> In really rare cases, if user want to distinguish good value 0 from
> bpf_probe_read() returning error, all building macros are in the header
> file, user can have a custom solution. But let us have API work
> for common use case with good usability.
>
> >
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks

Yonghong, please trim your replies.
