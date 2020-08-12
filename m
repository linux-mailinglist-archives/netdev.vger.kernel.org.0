Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F4D242403
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLCTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgHLCTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 22:19:35 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1847FC06174A;
        Tue, 11 Aug 2020 19:19:35 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i10so520497ybt.11;
        Tue, 11 Aug 2020 19:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1bVfsreZpWFdCZaRw99diS9Jg0LPYJBgsnwoI+PktU=;
        b=FpQczdBoRP7cVFml5t+val3pYz/7DcoaPh+3jsFET+2p2KNEHaNpUY1kQvWBmVk4Ff
         JAl0tonnD5mksj6JBTz9h3i7eNssaMNFsQigpy7CB6U7EIOHiuHWrM+0YTvNS04in/Xs
         dW9ZMeFX2zBeFx3/x87yX8Xbaw/Y/Ne2dKzUL8H86SvHPttBI+4fUxUoQLt8O2Qg0nNe
         VdtCSlUj+FbXOPkEvwBNBsxy1V3B+sA8C1Ufjt4ynxHZfYvCYWFO1v9aYOlOBtuW7eOj
         J5J+8n/Nu7iI5qP1uBg6z7L0fkqR8wdtjsNqnoqrjoLhX2FlASguGyX50knc+pnew4Gw
         hvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1bVfsreZpWFdCZaRw99diS9Jg0LPYJBgsnwoI+PktU=;
        b=NsnRPBaXkHiIYW0Z262hWTFryH0096eMzlKv5ViMmh3CsjXfcFDBQ+u85OxQVgy1tx
         Ebsafxq6lwdxm+A+UAjz7Xuhs2iF8t0fsb6Zb/abZ3lNl8Rmz9lf3EpSX0F5Pi0XgRyv
         5rNQ4qnz4wir0LHwRjT9NPN+0FPEJW9RoNRytq74nJCujE6Ivyl5m0NlFQHW5FjGYE1l
         vZAS2FPAWyLFhXEpIsBJEd7puWs2vZ8jFVIsON/USfNvsh01Ai1BLvigoOYby0z1UEfW
         meUanzxJN3J9pEFQSKh2DmH0tX197J8h+GzhTz36MImIw2xBglM05JfptxRHpk2Qn8iN
         H19g==
X-Gm-Message-State: AOAM531Q0yfsfgqFcYj1yowrKdIExXwgkilYocDmLmZF3Xs3fZPQTZm2
        rSuBDTmEJVbqWzxSPCSy/lMrxFaCzrVitoUPH7HJ3X+g
X-Google-Smtp-Source: ABdhPJxdESV38bMimv8eahpAiyV3s1/lT1KB7X3KOIIOL37wm29EF35az6qHYuXkVqHZ7dUw5AWvATccxzftQT/UUuA=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr55243795ybg.347.1597198774354;
 Tue, 11 Aug 2020 19:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200722064603.3350758-1-andriin@fb.com> <20200722064603.3350758-4-andriin@fb.com>
 <20200811181403.GH184844@google.com>
In-Reply-To: <20200811181403.GH184844@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Aug 2020 19:19:23 -0700
Message-ID: <CAEf4BzbXLg2EogSt1+oqmKY54E1gcVo3FLpY78p9jUrBQST_yA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program
 attachment logic
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 11:14 AM <sdf@google.com> wrote:
>
> On 07/21, Andrii Nakryiko wrote:
> > Further refactor XDP attachment code. dev_change_xdp_fd() is split into
> > two
> > parts: getting bpf_progs from FDs and attachment logic, working with
> > bpf_progs. This makes attachment  logic a bit more straightforward and
> > prepares code for bpf_xdp_link inclusion, which will share the common
> > logic.
> It looks like this patch breaks xdp tests for me:
> * test_xdping.sh
> * test_xdp_vlan.sh
>
> Can you please verify on your side?
>
> Looking at tools/testing/selftests/bpf/xdping.c I see it has:
> static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
>
> And it attaches program two times in the same net namespace,
> so I don't see how it could've worked before the change :-/
> (unless, of coarse, the previous code was buggy).

Ok, so according to the old logic, XDP_FLAGS_UPDATE_IF_NOEXIST flag is
only checked if new program fd is not -1. So if we are installing a
new program and specify XDP_FLAGS_UPDATE_IF_NOEXIST, we'll be allowed
to do this only if there is no BPF program already attached. But we
are uninstalling program, then XDP_FLAGS_UPDATE_IF_NOEXIST is ignored
and we are allowed to uninstall any BPF program.

I can easily fix this by moving the XDP_FLAGS_UPDATE_IF_NOEXIST check
inside `if (new_prog) {}` section. I'm not sure which semantics was
actually originally intended. Maybe XDP folks can chime in here?
