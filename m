Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4663DE35D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 02:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhHCAI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 20:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhHCAI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 20:08:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD6C061764;
        Mon,  2 Aug 2021 17:08:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j1so27419353pjv.3;
        Mon, 02 Aug 2021 17:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hnWZQqtS4cs6S2eqLlexSQq+7EoZ7X5M8SRSYOU4pSg=;
        b=fa9MN6mrs7i6nnx9UkVP//SvAd4Lpxw2vszy+gNUuNmEbGA4gPhMsTCzseTry+F9JA
         9KUIDsbNNqZon2DqmmpXXXuYfOyiLRBWrZ0eLUt1/1OxAuHG3HW1pbgH7dkB/zl6vXYX
         hbM5xEg9XsQ8tZNHnpZzm3eQr3GUFkKm2VLmPVI06fJxz7CM6fMaZ0KPq6YeMdwV32n5
         nAG8nhxTuypwryQ9UqbxoDeplUE7ZGbXmGn0s2O6c2/0uWsC+Tjx3uqO/3kOe+wOrEd2
         h3ECjjXCaDUwQh9Ozd76QF7f/2/oMi9qvBJrUGOtqwexcoSUUFe5SgWqcQEgyuGJi08u
         nKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnWZQqtS4cs6S2eqLlexSQq+7EoZ7X5M8SRSYOU4pSg=;
        b=XgB3kUiF0VMPOQFdpmIIjNnBD295rxd7KJBZos3NWk9pIJTjS3k9y9uOUPXFYn73ru
         ajrbgfyGr7s1bhf4hViUPImIz+eMXwXqrSgfJO7hh5npvFAsLp3xStEE7fLw7lnWIXIB
         gQiE9w7IlMHlherVlh/poAQVOqkAuEseAe/iplJFFAGZ1UGGZx1EU8AvuMhvhJJaLTA0
         aU4/ba0ADYPSunRyBxZAUeuv6LnpWlHelpZyqxx+HX1d/Qai3cAfhlRd0pYX/r6e34tq
         qBXBwS+6ew4OlqyksGPyMF5e3myUaW6JVhsYVSPT15yIxd4M+YqBWcUeu+LvztZI5qJA
         Mgbg==
X-Gm-Message-State: AOAM532OipxC0PHTEi54YEIdrhmgty7VAT12vvOau2ugvoBFQraOtutT
        Lgtr6NxKX3UkzJ8QvVVR8CS4cv8rV6e9TqlQn3g=
X-Google-Smtp-Source: ABdhPJx6IA17rcZlw2ovaA9RVa6EBb8E+UvzFg4a17ZqxRkhWYJVzFkIU5ChOqjKvCcpAa5aOBVenEhHesExDGA4PNs=
X-Received: by 2002:a63:d704:: with SMTP id d4mr791229pgg.179.1627949292197;
 Mon, 02 Aug 2021 17:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
 <672e6f13-bf58-d542-6712-e6f803286373@iogearbox.net>
In-Reply-To: <672e6f13-bf58-d542-6712-e6f803286373@iogearbox.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 2 Aug 2021 17:08:01 -0700
Message-ID: <CAM_iQpUb-zbBUGdYxCwxBJSKJ=6Gm3hFwFP+nc+43E_hofuK1w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/sched: sch_ingress: Support clsact
 egress mini-Qdisc option
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 2:11 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> NAK, just use clsact qdisc in the first place which has both ingress and egress
> support instead of adding such hack. You already need to change your scripts for
> clsact-on, so just swap 'tc qdisc add dev eth0 ingress' to 'tc qdisc add dev eth0
> clsact' w/o needing to change kernel.

If we were able to change the "script" as easily as you described,
you would not even see such a patch. The fact is it is not under
our control, the most we can do is change the qdisc after it is
created by the "script", ideally without interfering its traffic,
hence we have such a patch.

(BTW, it is actually not a script, it is a cloud platform.)

Thanks.
