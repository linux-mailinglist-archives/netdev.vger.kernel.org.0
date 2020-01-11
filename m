Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2861383B5
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 22:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgAKVeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 16:34:21 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42838 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731454AbgAKVeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 16:34:21 -0500
Received: by mail-ot1-f66.google.com with SMTP id 66so5489329otd.9;
        Sat, 11 Jan 2020 13:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sb6sLp8tTZmL45LLevwIiTHPVG1Ee1MFPZQXhwxy/xI=;
        b=T0ziqqbX0CbPYlZWnlapZ9Cb0XddRNoItae/6DLLwGgbDJkqxCKUOg285BJIYm919r
         1s1zgDJEBqTeFVBucYCKsbHYHWxaIMhRktsFuQ0FcB1aVLEb3H+kjwQoGombTVKnBQgI
         1MkpMdywmsbjtECj5o1y8RWSA/7Y4RJT939p484SRsK3WFJjIhEsk9BRyEa31djoCZMS
         UTLQDRey9fagV5RhA0Mx313TKU0wkFgm+sobXI8IQgJBF5AhRbjJuP7yCW688qnRbsBy
         Oi5cfW6x8YutoPiuVM+R7Gl7LMjfs6YMveFbH4upjSJ1Z3AJshxvSIkoE1a0191UZBFN
         hKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sb6sLp8tTZmL45LLevwIiTHPVG1Ee1MFPZQXhwxy/xI=;
        b=EqXoX8Cmwj33nbAcsUHgsVxKqIcXEKlZZnFJfH0VFIhQEng7lHCjR2uFieu33Kfwxf
         F5axL1kBFGqexnzAHO7Ubn5PS+SvCJrXLiPMf+HjLW52MPhm3FVvQ2XPD2p7UsR55Exr
         4Mxt7zI2R7gw8LqQvKTMpw+wtepA/ufuC0u1w2vyFkhHgSjft6is6Nlxfk/vs2YJiv7w
         SY1OIWLSSvtc1FM/1uq6sSIUWzZOPkuTFFJx6+vexwLPR7wT8RbtwWtYdODRruqPc+jX
         r8X3Hz+oajdkyFKI6J0gQUtxHhqjLD+Taa4+kivgXw66erT7n8Ty1y3Ma7Qyi/hY8u2n
         HliQ==
X-Gm-Message-State: APjAAAXKTz4gaPiFF4lzL64Slx/sM1i3rJfQjQRU1+qq8qzGzStLfz+d
        FpxH4KX41R+nYNmWAM1qq+JW6eeSv+/2dQRHXS4=
X-Google-Smtp-Source: APXvYqwbei5a+C3nFp5SXBnSnskwCBcpZwpfz2aaKzl2fQeyNxBx/Yyg1MieSMF7kBDLyANYObtfhT/Q+/4stW2mWlY=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr7647879ots.319.1578778460547;
 Sat, 11 Jan 2020 13:34:20 -0800 (PST)
MIME-Version: 1.0
References: <000000000000af1c5b059be111e5@google.com> <CAM_iQpVHAKqA51tm5LjbOZnUd6Zdb9MsRyAoCsYt0acXDQA=gw@mail.gmail.com>
 <20200111211349.GG795@breakpoint.cc>
In-Reply-To: <20200111211349.GG795@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Jan 2020 13:34:09 -0800
Message-ID: <CAM_iQpUux2f9uXLkpg-gcXjrq3F0H-1v7_r=zbOQK8FoNS6JPQ@mail.gmail.com>
Subject: Re: general protection fault in xt_rateest_put
To:     Florian Westphal <fw@strlen.de>
Cc:     syzbot <syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 1:13 PM Florian Westphal <fw@strlen.de> wrote:
> The fix is incomplete,  net/ipv4/netfilter/arp_tables.c:cleanup_entry()
> doesn't init *net either.
>
> Are you working on a fix already?
>
> Otherwise I can handle this.

I am not. Please go ahead.

Thanks!
