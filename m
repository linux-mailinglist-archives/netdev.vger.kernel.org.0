Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E942338A3
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgG3TEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgG3TEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:04:12 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B2AC061574;
        Thu, 30 Jul 2020 12:04:12 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id m200so10837148ybf.10;
        Thu, 30 Jul 2020 12:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X5HUKfRMrtzs7dcM+5i3OnbYxJs7/ceslheaYcPXAhE=;
        b=h8BVyPqMQwEw3kG67/klDfqXOtepNjPZC2j3hnwJAz8K2LPFK6eqaYvAeFHD9Gop3G
         VdqVrAHyPOdRdaoLQ29mn4S1qyRrz5+EQOHi5Na2HeH/PiGQBzlv5B4qZqoOh30GW/G2
         Kai0Q9hq429/TLmcU5SUdjR8F5aXNWTkW2g/vbuo+I3Id8KmRzcw1URULAxuEPQMaORl
         /iX2I8LOK/t0oZru7b4tC5bXVxHlZAqeMr+j+P25N8DXqDVZX7Er65r4tIDb915L0/3F
         cTubq7eLGwJM5LlrOhtkzu8dCvvglpoB8CEL/kbr7BXk5dX0iZAeM+vWF8NZE/MqxIi8
         1CQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X5HUKfRMrtzs7dcM+5i3OnbYxJs7/ceslheaYcPXAhE=;
        b=Cmbj/RPphD9HB5Gpf8aH5CgUZku62r6T3UiC8ILauVVUB7vrMqtJGpDYCmZhLtStUp
         m9rZ6r63SYtbS+XLETh8zag5diH/LMpJ+/kCUug5FyrZHSdAIapW3AJWU9J5u8tzuv3Z
         bW00RekElYvT8+6L77r62td7f5xFRUbvxl9W7J/nPET+5Ys9MuNOVv50/xCmUMYx75u1
         NCeEFpPYTpnzh3nTf/GIYKZdIu6J448+F8ClMbwjTjxbd6y5ruXym3V2WBob+MPV+WlO
         ZBxT+5CLu/hxNQ92veQEkR/yAAIZRyNgYavGOXonktPWbf4aFlLi5ZftrNxxXGlsOUTl
         TBkw==
X-Gm-Message-State: AOAM532+SfKaK3smpRMxodJTVIsdz6pZ9GJWbPWCloxOqfvWR35WUVTG
        68MUV2Q3tquNez7x1HxtjiYlo1s4ykZGcPHGruHmmw==
X-Google-Smtp-Source: ABdhPJzQMB6Rk7p5PYpdeoUXstHOLW6+Y8s/wuAuqWamheDI9P755t7CPMUZ5/4FiuncC6jfpZbPz4hYpk+1iixkDqY=
X-Received: by 2002:a25:824a:: with SMTP id d10mr552970ybn.260.1596135851397;
 Thu, 30 Jul 2020 12:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200729230520.693207-1-andriin@fb.com> <20200729230520.693207-2-andriin@fb.com>
 <E5C327CB-962D-46B9-9816-29169F62C4EF@fb.com>
In-Reply-To: <E5C327CB-962D-46B9-9816-29169F62C4EF@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jul 2020 12:03:59 -0700
Message-ID: <CAEf4BzZsYoBZjsSKgQ-+OYRCa=Xn1EVwmdjGM5FG5oZv7_9vkw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: add support for forced LINK_DETACH command
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:43 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add LINK_DETACH command to force-detach bpf_link without destroying it. It has
> > the same behavior as auto-detaching of bpf_link due to cgroup dying for
> > bpf_cgroup_link or net_device being destroyed for bpf_xdp_link. In such case,
> > bpf_link is still a valid kernel object, but is defuncts and doesn't hold BPF
> > program attached to corresponding BPF hook. This functionality allows users
> > with enough access rights to manually force-detach attached bpf_link without
> > killing respective owner process.
> >
> > This patch implements LINK_DETACH for cgroup, xdp, and netns links, mostly
> > re-using existing link release handling code.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> The code looks good to me. My only question is, do we need both
> bpf_link_ops->detach and bpf_link_ops->release?

I think so. release() is mandatory for final clean up, after the last
FD was closed, so every type of bpf_link has to implement this.
detach() is optional, though, and potentially can do different things
than release(). It just so happens right now that three bpf_linkl
types can re-use release as-is (with minimal change to netns release
specifically for detach use case). So I think having two is better and
more flexible.

>
> Thanks,
> Song
>
> [...]
