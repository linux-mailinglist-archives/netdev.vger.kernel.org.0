Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F03E9BA8
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 02:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhHLAiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 20:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhHLAiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 20:38:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A5FC061765;
        Wed, 11 Aug 2021 17:37:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so12459708pjn.4;
        Wed, 11 Aug 2021 17:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=StXGEEaO3J89Q/FLgyHySFHiYB5i+vkOOpoNcAu6ar8=;
        b=nEsfKDIkAdtVIQLspGwzcHuZWmWCkL/MbTOi+WuQUJ4j5OGK5+FF8RhnicEDfDSWEf
         9FBoZZa2181kDbFCNJAxiJSK2RyhlFPmU1d3kFrNE5cgUCsVGxrkegysoInoYbAM5yZr
         pusI5HZMsNiWhct5HMtXFGVDrGuA9VZJkjCm6hwERCQfIPfT6M+fKZDkrdDfxY/wh2H/
         0dlTeR+OsM6O5iC9oRbJ8GdOvNnlzO4Agus/rZ4vl06nyTNMXfN3f4IJf5Px0vc8H14w
         xyxVG4mBqGg61RgmzdQqQtWJY4xq+Gm826bx3fgObWjviprqShWN+H8oTVm6l2lffT3Q
         rEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=StXGEEaO3J89Q/FLgyHySFHiYB5i+vkOOpoNcAu6ar8=;
        b=DCnaeAFW51Qv6x5MaG5wEjv610zCs5Y0N9CVjGYEriGjF+08MYlKTghl57WSCnccjq
         U/zeIfNvodQamEBAg9wp0h2p/ZUgRa1IeSIFj9jXWu5slkSe2OlO09hKLZSjaWOn3RB+
         dmbHh9piTthq0M8U33VURVFfbePA/jQLWuXEEldcHhlfnZDAfZNdXxZRU1ba1KIviMqT
         cTlQo2/d3+yqc2jYw+Ji2qEd1rMs/TLsQ+HbwA4r5a06m5w4r/6of69ajhAIg0QrhabC
         d5LoWwPYABIjqhChNcSTzJSJQS/up2Bhup/NM/NI8R49uUxtgba73ylTYet2g0h8cEnp
         8UFQ==
X-Gm-Message-State: AOAM530Gg9lFHSyAP6pvi/GwPz//Mwv05ywvRtsidfn72redDSust1SB
        3tKA1lebcZYGk81wdSmsSWO1ZeJxD6ZerMuvFxA=
X-Google-Smtp-Source: ABdhPJxvxZe0FtrcozQ3ShfuCDoH1+S5soDD1uv/8BUEm1nE7moZrBdafbPVPwTYqo9N7JCixVaiFuOtH2esME1ZnFo=
X-Received: by 2002:a65:6812:: with SMTP id l18mr1308320pgt.428.1628728666535;
 Wed, 11 Aug 2021 17:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com> <20210811212257.l3mzdkcwmlbbxd6k@kafai-mbp>
 <CAM_iQpUorOGfdthXe+wkAhFOv8i2zFhBgF0NUBQEBMkGYTavuw@mail.gmail.com> <20210811230827.24x5ovwqk6thqsan@kafai-mbp>
In-Reply-To: <20210811230827.24x5ovwqk6thqsan@kafai-mbp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 11 Aug 2021 17:37:35 -0700
Message-ID: <CAM_iQpV42D3HHESF62tmUHn=gB-a-6fqiRJGYaoVp0HyRH=xEA@mail.gmail.com>
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint trace_ip_queue_xmit()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 4:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> Some of the function names are hardly changed.

This is obviously wrong for two reasons:

1. Kernel developers did change them. As a quick example,
tcp_retransmit_skb() has been changed, we do have reasons to only trace
__tcp_retransmit_skb() instead.

2. Even if kernel developers never did, compilers can do inline too. For
example, I see nothing to stop compiler to inline tcp_transmit_skb()
which is static and only calls __tcp_transmit_skb(). You explicitly
mark bpf_fentry_test1() as noinline, don't you?

I understand you are eager to promote ebpf, however, please keep
reasonable on facts.

Thanks.
