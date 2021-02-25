Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D74325891
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhBYVXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBYVXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 16:23:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB4C061574;
        Thu, 25 Feb 2021 13:23:00 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k22so3911890pll.6;
        Thu, 25 Feb 2021 13:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7idWs05fnTffEO4Y7GUhv4Yg+y4ek4A9KbBDSRyIo0=;
        b=SQ9/6Xoj8LTioRdjbuwc993okXXw7kNZuQVYxXwYxvniRHCofDP+fUjnyiexjnB+wL
         6CzQ39E3ByGSTb/1RRDg5O9PAYbhwC/QVUzDycjOwg3fVjq5aNjgpFqNgfQBBgMJ0i/j
         PbiHdyeyaOlZUq/IsGjh3YJX11zq3npHWL5Y6R3P2mw0qQ3pDgaTMwlMXqLNS1b0EHL5
         +Z+Fs3F9oYW3eYaqXCJ9rQET0u0POKmZvUqT+/4JGnwN7Iux7dT4tyQA6eJVLXaE1x37
         tjiV8JMjvlfVKv4sPZGwc4LHbZ5v6cTxGnkiLYLPQtcPgnCvArxJXMIAz57AHqAIXlJf
         1KHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7idWs05fnTffEO4Y7GUhv4Yg+y4ek4A9KbBDSRyIo0=;
        b=qrl5T3nHe5XCBHfSqvheiP5ODaqZMVXLY04Oumr5NiUfSuQk5lQgiAgSG4SiaNT0bw
         N01fVe/o/FSvaEnfjYQVpw9mxOm+KrodvPJ2PcYCZrX/b6UTLrMrMUkYOvc7+h2fXyLI
         6m1I0dXmU6LWyYNqE9U8KRFWsubsjhZCSRxj1R0bzfGQ/VqBQA4C+jlSUOn7TlsRGfRm
         SAwmazU9cKeLl1npzRwHSlFCaiMEHaJjrzHWN0azlgSY28Qd+RI8kiqrVrcX9dt+aSyw
         h/YlTU5MDy1gv/tD+Cm3Ve4Z6qZA3/QDX+Um+vg2cBe63Mf2REIZiQZ88ANejgJAxMlV
         vTig==
X-Gm-Message-State: AOAM533LP0WxzCCa4Y5uuLcgoB9ZNxTj+YGXyRAOVib6WnRvdXYS2u/+
        o+IvWM+BS7TGYMKAukn7kEY2ZJ/NBPTX/Axnwog=
X-Google-Smtp-Source: ABdhPJzIXz1dNBjzxTzid6KNY7VGNKLejAys/CnaETOEILP1w4KnT3cnUj9lWWjddJJpGkVCbHqmpQwBvgPv328crmo=
X-Received: by 2002:a17:90a:72c4:: with SMTP id l4mr364556pjk.52.1614288180455;
 Thu, 25 Feb 2021 13:23:00 -0800 (PST)
MIME-Version: 1.0
References: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
In-Reply-To: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 25 Feb 2021 13:22:49 -0800
Message-ID: <CAM_iQpV0NCoJF-qS1KPB+VE3FSMfGBH_SL-OxhMO-k0pGUEhwA@mail.gmail.com>
Subject: Re: [PATCH] net: bridge: Fix jump_label config
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 8:03 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>
> HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
> 'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
> of HAVE_JUMP_LABLE.
>
> Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Hmm, why do we have to use a macro here? static_key_false() is defined
in both cases, CONFIG_JUMP_LABEL=y or CONFIG_JUMP_LABEL=n.

Thanks.
