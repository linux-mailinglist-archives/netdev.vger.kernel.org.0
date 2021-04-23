Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0D368B4F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhDWCzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhDWCzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:55:35 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D679C061574;
        Thu, 22 Apr 2021 19:54:59 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a13so374113ljp.2;
        Thu, 22 Apr 2021 19:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5K98nvKsNElBT84+XHVrTqC9Zq6pKBjLv9acZFs4AJI=;
        b=Z0s7P0LsCLNOl9gGBwjrnObgiHIRLjkCJsjBSETGxtUq9VXZXs8HOeP43WRKYY0k/C
         +GluB3WtHp6MiCjz6K55/hGQ8sXjz9l/qIWrar4WajnqdMqxoZXYnKmwGsUzqTOUd2b9
         eo4doIkNULv2byPh2JN5Ley/z+3Z1/pBcZ8PlbQ83T4HS3ZlddJZu688UWJxcyFptpIs
         Vh1DitXDw/7OGhkfy+9ko5PKDAtOgKubCC4FeVQkXtACVyqTmcPuol9dGxzubxLCH+G+
         zXhy8nFf8rs1CSX7ibYZs08by+phWnL1wUo+rTuyMFmn0bfn42Gc0ePUsdIw1mq12NdU
         /ygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5K98nvKsNElBT84+XHVrTqC9Zq6pKBjLv9acZFs4AJI=;
        b=ZdzYy7Y7/gUfvQsnZa0hH5FoUHNESYWVuRU6bkBFPLvFzevyZ+J9FVTgXTotQbZlTK
         FdSlDaMAgE1qrd1UOscHI7FdW8m7LJli2CG09ADkbAT/kSaerG/89ESVGqNsGJKFzgzQ
         xzGzR0kcVpS05HDcI4Uk+62p1wsCqaMpxhGG40rD26t2GzA7lZvhbyte8Y8cHMhyHn+V
         CmFFQr7sqjxfpNgAek2CxQkrjuXhKHdWIOMLd2yQ7wbLuq8dY3gq/fdCYjYuBzzYV/Xg
         oNh7Kd51x/35LZIwLJXIEmUx3LWxzoG/wiubQpQnj0wRIAa66WZbkIwbnVUdvz0GpRpY
         8ARQ==
X-Gm-Message-State: AOAM533RNsJNhABHhkuZcUEsNhDvcZrGIQ8G7qV7kClHC36AVzy3pJP4
        J296KFMptf8LrbfGleH/xjcR21WG7uZ5GgR6dtg=
X-Google-Smtp-Source: ABdhPJwXD50f8AEakLftCOyzo5XBuNVLr2oc4lgf23o4hdPJxNwDSGT9Zx5wtXKIFPONwjlLEHl0Ui0TO5esY1UqUr0=
X-Received: by 2002:a05:651c:2001:: with SMTP id s1mr1293863ljo.236.1619146497966;
 Thu, 22 Apr 2021 19:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
In-Reply-To: <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 22 Apr 2021 19:54:46 -0700
Message-ID: <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 11:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 9:50 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > > It should never fail, but if it does, it's better to know about this rather
> > > than end up with nonsensical type IDs.
> >
> > So this is defensive programming. Maybe do another round of
> > audit of the callers and if you didn't find any issue, you
> > do not need to check not-happening condition here?
>
> It's far from obvious that this will never happen, because we do a
> decently complicated BTF processing (we skip some types altogether
> believing that they are not used, for example) and it will only get
> more complicated with time. Just as there are "verifier bug" checks in
> kernel, this prevents things from going wild if non-trivial bugs will
> inevitably happen.

I agree with Yonghong. This doesn't look right.
The callback will be called for all non-void types, right?
so *type_id == 0 shouldn't never happen.
If it does there is a bug somewhere that should be investigated
instead of ignored.
The
if (new_id == 0) pr_warn
bit makes sense.
My reading that it will abort the whole linking process and
this linker bug will be reported back to us.
So it's good.
