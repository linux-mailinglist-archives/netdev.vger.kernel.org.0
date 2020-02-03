Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C740415110D
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgBCUdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:33:43 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34173 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgBCUdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:33:42 -0500
Received: by mail-ot1-f65.google.com with SMTP id a15so14987118otf.1;
        Mon, 03 Feb 2020 12:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GQ4U+YXAWR+1bgsw2pgVAqxYtocJASYPniZ3B9G2x4c=;
        b=abQ+GYCFbu+Xn58JN+D1PFRJkEDcBZSO4UUT5Q2fxuxaUd8v4RM0YQYHsdGYFnqRot
         VbRbyHVHVFot7dHY17/cdSTAZ/qjVYoyrZnqabNqXWREdlEe3XnrORE7CUDC3aV5+1in
         nDt2PDxfh1lrkzqQHA+xLXAW20o0sMEJDMFz2aN3+qu41w864Ls6ifrJ/ypdr+re+kPG
         UpsyXElCCi8H8gB3g/opxU7LyzfEDpGJq6zwH8P1o1sWTf8dx/BS57TkDy8D6BhpdIjd
         8zup5eS9rtj2i2AGLj7RmdM18oM7h62s8OA3EX9zg3YvFq5xzcxzZYWJiJoLPYW4ytYJ
         0pzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GQ4U+YXAWR+1bgsw2pgVAqxYtocJASYPniZ3B9G2x4c=;
        b=ohIuCuybkx9oBiXKlhnd1jqsnkTXdlnmsnxGqxLdPTsKcKBbYby4M0SFCtIzKLueM0
         +o5JH8nE05QgJhMJ9UPaU0FiRS/KcAX69gVLAwYe2ItcUxulHRdF/pcDae0+/slzZDky
         wUTX7m0F/Hv31hL2g+k6DaN66LRWdTXthB+3VKvFtIMdS5m28gcQZsi0zQDHOlmID8YK
         ty2tOJZ8wualB60QjzkBdLUH/wICXz2TwtHe6LBAejSikKnBBq2ug1Ns+0fJO+9P+QFc
         bNu22fTVbnHL1C9oKfHUouehV6ugV3/00VFrvdx9OnzIPDY3hU3FYqAuHaXi3UdfqN/3
         vR1A==
X-Gm-Message-State: APjAAAVFizUfv6ImU7vAwuazzEX+2LEKS+2R9C69fjPZYP+Gd5CR5DHZ
        piwCz2u+u8r5Kb/hic/GySqDAmSBozchndn1qZ4=
X-Google-Smtp-Source: APXvYqyEcNFqhS9JnvYt2BzNTYgMDSOWs+FAaBBM+wP0S6VpNJNjjeoKvclWp5b9t2iQsT4P/67CDvDIJ+/eX39S2m8=
X-Received: by 2002:a9d:53c4:: with SMTP id i4mr20051104oth.48.1580762021874;
 Mon, 03 Feb 2020 12:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20200131065647.joonbg3wzcw26x3b@kili.mountain>
 <CAM_iQpUYv9vEVpYc-WfMNfCc9QaBzmTYs66-GEfwOKiqOXHxew@mail.gmail.com>
 <20200203083853.GH11068@kadam> <CAM_iQpWu=EuAj709=wL0ZgbLvFgBbaaVZcMjYm0ZmTeLJ7nkCg@mail.gmail.com>
In-Reply-To: <CAM_iQpWu=EuAj709=wL0ZgbLvFgBbaaVZcMjYm0ZmTeLJ7nkCg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 3 Feb 2020 12:33:30 -0800
Message-ID: <CAM_iQpVrckjFViizKZH+S=8GC_3T5Gm1vTAUeFkpmqJ_A66x1Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: prevent a use after free
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 11:58 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Feb 3, 2020 at 12:39 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > Why is that better?
>
> Because it is designed to be used in this scenario,
> as it defers the free after RTNL unlock which is after
> sch_tree_unlock() too.

Just in case of misunderstanding: I am _not_ suggesting to
use rtnl_kfree_skbs() to workaround this use-after-free,
rtnl_kfree_skbs() still has to be called after qdisc_pkt_len(),
at least for readability, despite that it could indeed
workaround the bug.

Thanks.
