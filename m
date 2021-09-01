Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BA53FD270
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 06:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241851AbhIAEkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 00:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237454AbhIAEkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 00:40:09 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36065C061575;
        Tue, 31 Aug 2021 21:39:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c17so1566601pgc.0;
        Tue, 31 Aug 2021 21:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yISD6zbJMEg8SOarLxXFr8MDsktqtHxZ9raJtXS00WU=;
        b=s/2RdvscRFBqyZOg0YiptwbzJ3qdMYQj4QJESaZdggn8vDlVZgtoQmK/XpR6+QGmD0
         h9jZngvGbOlt7dqi1Avjz1IWtv6nPXEcZh6efYdvtJkuW5ejoDUpxytDFV7C1UrezPMR
         iOAb9sVh5/wieJK4FQCL6o7/xhRiLq9jOQsCoQ1SjyRgk7gs8T1ZmtolpMrBV8LbnkgO
         JXipFL+V/GSDvNUOFepQnreNtEzWHQT4mdWLGEvI+0sULrA1lLD1m6cCedhnayMXFwOL
         eNvwGXVOA7pYiVQJqxmRlM3R9r/bkvMPGFBhhdTuBxZCIAx0oBmDQmx6TNIIHrVoH6si
         JgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yISD6zbJMEg8SOarLxXFr8MDsktqtHxZ9raJtXS00WU=;
        b=D9/N+IVV+aegK9ZPcfBDwptfZt7wcz66OVdDLsPGeSO/aD8WTTGl2+LOUya4S5+kUZ
         v+wWqTVd8/AJ3gOCHd7ojbVieAmvcSHOnuSTY3mFkqGtSa1geb6BbG+7xqYkW/L73JX5
         f6OfGC6p7piaV7f5An9ykeFx0UhcHDosKlAcIF5TY7A82boZiwd8USUsTUUQ/TAVSAmE
         hfe7EnZKdt7fVO+4XMBVURlvneOyeAS2FS9NAkotBQLqR4KWjVpHHJ4rnQFEAqQENdq9
         FPikzkB8bOcglkyQF/MVN+Wrb8P9Suhl23mpa1UW4qQFK/3+joIkYz2MpYYHnz4xEZOa
         veQA==
X-Gm-Message-State: AOAM532Gq9I+1PL/w4+Kh6Jyscgdz97vQZbBqbL+IF3ktbyK+IInbvpE
        Ez/E7bcJDrd67fz7MH86lFHDl3q7qtPaJkjQvn4=
X-Google-Smtp-Source: ABdhPJxVcC3hwz7uEERytGFM7oFyXn8EoMo936CVowqtbgg30Zv+zuWhXfowsRfCzxhaKNdgH8Ra/8danBrQnvgWv9o=
X-Received: by 2002:a63:2bc5:: with SMTP id r188mr30097078pgr.179.1630471152782;
 Tue, 31 Aug 2021 21:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com> <20210824234700.qlteie6al3cldcu5@kafai-mbp>
In-Reply-To: <20210824234700.qlteie6al3cldcu5@kafai-mbp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 31 Aug 2021 21:39:01 -0700
Message-ID: <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
> Please explain more on this.  What is currently missing
> to make qdisc in struct_ops possible?

I think you misunderstand this point. The reason why I avoid it is
_not_ anything is missing, quite oppositely, it is because it requires
a lot of work to implement a Qdisc with struct_ops approach, literally
all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
WIth current approach, programmers only need to implement two
eBPF programs (enqueue and dequeue).

Thanks.
