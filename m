Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CCA41276D
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhITUqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhITUoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 16:44:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83BDC0745C8;
        Mon, 20 Sep 2021 10:20:44 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y4so15360651pfe.5;
        Mon, 20 Sep 2021 10:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mBPISm7x2Gv3h8aiMAOFekEdGOOszqA/C0eurnhbxs=;
        b=OMyFclhhcbS5Ui2H2lDSiqbOUhRO9EFOnfjmkLmLeebqqAu1OtYzVNvKK54XJa8yeh
         ljKGmo9SdHA1yc7eAaJIyYJRXpTf58qX/Iwf3AspITdDFML3UnKIBecl3b1OEeZ3GfOg
         c/ZV7sG25faWvgCvqbiMXhXE0UULHUNbOJ83cGO2jI6FtclW8F3IWSVbaULeU6JyMfkJ
         R1kBNPpyJqcnnJqPO5Zcz8ZdRzEZNSuw7UG3pviD7puy1Bi9Ss+wOXeVzKAFBirofhfI
         remjaMO1Rdr90MtH5AwblF+8D+WYqAcZt6VlqBEnFsBv+EjD3iz9xbHDp+YQSnqYnDBp
         4fCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mBPISm7x2Gv3h8aiMAOFekEdGOOszqA/C0eurnhbxs=;
        b=rdXGn0HXLeaVYlfc+vL36qX8DSArVaOcTdF+9mY7mX/6oBc95sinEyZvhcsOYY57TT
         gyKjPJ31QkNxpopbB7zvsO0ie8PdeHtIeX/sfeaOT0uNlaxLXvSsxT0o7ZW85szJKEig
         i1/wqha3RRARaFowLzz5j2uR29X/a7ORJPaNaQCfM38ZBxrltmuI7XbhizjhybOE0ZeO
         cBlugzTqTLGkfXojBG7F6p7yaIXZfem17NLo5upZHghzPsGaI3+OAuUB3L1r1nZsTecb
         L06rQCXqWSsi6QeBdEAyEDOC72HAUypDcWWYrUnR6dvr9VPbOTdMKrh0EQrYan3m5rNr
         CAeQ==
X-Gm-Message-State: AOAM531jxOklkuBbiDKe1mnK7sLbK59LEs21hJEqJ8t9/Ni+tUZYbtix
        cu9ocl10ui19i2/zRjQZiyGIPqBrQ7YGSYW/Jqs=
X-Google-Smtp-Source: ABdhPJymgRiIiD7Ze2FdQXo5mvdFxq+752HiviuNEPxwyC5vFCvI3r6FgGV7DFEVsrf3yQqqLErS8VzBylcHMLVnX8Q=
X-Received: by 2002:a63:7012:: with SMTP id l18mr24208010pgc.167.1632158444457;
 Mon, 20 Sep 2021 10:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210914143515.106394-1-yan2228598786@gmail.com>
 <CAM_iQpWLPvSmZD4CTmzSoor04xfdkvZuDhF=_CCaumT7XiaN7g@mail.gmail.com> <20210920131550.658eda95@oasis.local.home>
In-Reply-To: <20210920131550.658eda95@oasis.local.home>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 10:20:33 -0700
Message-ID: <CAM_iQpVVbwN+uzxPbJabvju0CzxcFUosy0_xN=X9anA+wtiUVQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: tcp_drop adds `SNMP` and `reason` parameter for tracing
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Yonghong Song <yhs@fb.com>,
        Zhongya Yan <2228598786@qq.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 10:15 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 20 Sep 2021 09:54:02 -0700
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> > Also, kernel does not have to explain it in strings, those SNMP
> > counters are already available for user-space, so kernel could
> > just use SNMP enums and let user-space interpret them. In many
> > cases, you are just adding strings for those SNMP enums.
>
> The strings were requested by the networking maintainers.
>
>   https://lore.kernel.org/all/CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com/

I think you misunderstand my point. Eric's point is hex address
vs. string, which I never disagree. With SNMP enum, user-space
can easily interpret it to string too, so at the end you still get strings
but not from kernel. This would at least save a handful of strings
from vmlinux, especially if we expand it beyond TCP.

Thanks.
