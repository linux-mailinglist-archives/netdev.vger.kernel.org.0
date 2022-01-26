Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9449D2F1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiAZT7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiAZT7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:59:04 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECEDC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:59:04 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id c6so2080788ybk.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67a2H9idUvwiZTDBijK/0HyXUXggNrXtSV8cwOBFVTc=;
        b=EGoBWWxHsND75q0nLPKSpO/fUuHd05r18BYvYsqmv4TD1wxzJxJ3X2tHKYumPwpxqW
         QzENBYArlGlJDdzPxlskSTWtvev1M9wrkbdxQYgQ06rDTTTHhGRq9BeMVA2DJdW5lZt+
         syC+IIDgOitz1eHQ+D5Eq1lg5Q8B13Lw1KYH32zaQuaOd2vRNiXR65OrLEHfIwwH+WV5
         gbhV+O1hZDtYlk/1+c0YYnIPGuH93AMveuG5S3oK+xv29aK4cXkx26EGIk1FgMgMhUrn
         SltbyyJ1nGNPX5SXkTG07SBRJWJdEqLf3eoAxG6pHBeOaLLQlULR/EVHm75NBDfIiSKh
         V3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67a2H9idUvwiZTDBijK/0HyXUXggNrXtSV8cwOBFVTc=;
        b=Rt6N7hLWNIQk8ROUJLYtAtvTNLKH3Ys8lNewkBWrEIxGJGy01bWLKn24VaXCQ+Qwwi
         W/nhrDZIDuotX4/rembiKcuBkZaEVNpKO0SMPRM3eL1iw0etB/SBTYzk5hDK0bH9wdMI
         a6fgQrDUy1NM2iUez9JPbGvwqUdBY7FiVjAXBjNbmpVk7mFSMxK3sJvNa9ZPqy4UqC6x
         7so4cqGXpahXFPiI6+k341dGnXeH+DclpM8Iv6n6kPcQQlbw0TwgPgmy/adlngc/VcYh
         n4QHjC7BrUOHG+Sw66rzLo9LCbvZMVDu+wT806cGZS1Exao8Vx49c7BbnqakDuMRlHzO
         xDIA==
X-Gm-Message-State: AOAM530PTsGeFEHagEncHlo1m+Qvy9/eKVFBqQbpHM/rsr5nVR8K7LD6
        HC1YbvaHtfUcJ9JtmYBKNmGiKfGgCN551N9w3YBkTUv5
X-Google-Smtp-Source: ABdhPJxbDSSFIyTnujUX5XN52QopX7x6VeHOHFfrfORNjm1g91niHvE7ORDYDGHekwdMVHCs6ygJrqWbAgkjpEBEEu0=
X-Received: by 2002:a25:e011:: with SMTP id x17mr772459ybg.254.1643227143341;
 Wed, 26 Jan 2022 11:59:03 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-2-xiangxia.m.yue@gmail.com> <87k0fn2pht.fsf@intel.com> <CAMDZJNX=gEL0z13QA65Aw11Cp5Mik4HLtMLZUYO0-mppuKsuyg@mail.gmail.com>
In-Reply-To: <CAMDZJNX=gEL0z13QA65Aw11Cp5Mik4HLtMLZUYO0-mppuKsuyg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 26 Jan 2022 11:58:52 -0800
Message-ID: <CAM_iQpWcqPEhX6QMDycJWSkvKhhSs7OGmgqEi+yUj0BMDAWk3w@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 9:03 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> Yes, I think this is key. In k8s, we can not control the priority of
> applications in Pod. and I think 2/2 patch

Why not? Please be more specific.

> can provide more mechanisms to select queues from a range.

Well, you just keep ignoring eBPF action which provides
literally infinitely more choices than yours. So, you want more
choices but still refuse using eBPF action, what point are you
trying to make?

Thanks.
