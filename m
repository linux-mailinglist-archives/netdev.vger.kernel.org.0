Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C065124737E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbgHQS5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403968AbgHQS4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:56:19 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B1C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 11:56:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so18602358iow.11
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/W4ctnIzB9KFTO8HTi2/AwppHgGEcJOmkkTetbk8YEU=;
        b=HXQ70eOYzHCdDSVvcnt8hkxXuBVDtQV70b99Cr1+QpGnNy2IoJ8u1S34r/36YSkM3p
         tTOOmh8k+Y1h17TLApCwEA6wCmCVbD9HuOVR9G8kXnotrKy7aYeaGaSHAOZ+xwbDA6HO
         z06inGg/EvXe7FDcDAy2vQ0EDhonu7YwrnG80+sUDmmQvAiT/oOpQTD+gmQyG6DZ8wWd
         laEoCGq2FI9suOsjJQWEvVTacrNLjOaB6uiCWSZw3SGFn9XgmCNxvcKnF8gK2iaDbgsr
         Xs7YN1ZqV1f2/+HiVRcP+Xl5f/1lQ4aUTxVD7G8cQbLtD4rBMZyIsaGLA9QhfZW7VeB/
         d0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/W4ctnIzB9KFTO8HTi2/AwppHgGEcJOmkkTetbk8YEU=;
        b=XaxWsw+TLSqwJ8dInoRtZ00t9ofCznLW4uGJT+mFGsSzELp3jj4mgRUKDoEquONi9G
         tExFqbhRMbnJfvG6lG9M7D7XiLx6WTUU3CW1zKCQ00JnqmW1oJz1/o+2J5H4yvOo5VxS
         KpGGRN61r4OcQj+wK8Iat1IW+PFTb6uduEaw1PII6heWQjZl/k6glpYzViE/slN7cJVS
         Dq7rW0t60MEBGstUy7Gser1DCYc+eQ0pCvCgQ/7cagrkt4/rgFa0uolOjRLJTTvKbcLV
         rK/6SKmQGTLo+drnI8/FxOAFR+7DZ1vUgV2VdqGy+Mpomea2y1xWiUpsiH81yomRPmaG
         jprA==
X-Gm-Message-State: AOAM53115qzok+fWJM5FDSzZD/ILwJUpo/0LyTGUKhajv747eHpyEkl4
        5JXLwx9/rXehz6gIf6V3Z4Lw7eGH4Z9OTGM1jPU=
X-Google-Smtp-Source: ABdhPJw7vVUYKsICcGyB25z7UhUj4/89DTXl9MYClnJYgHLxajgI08AAZWKZdPw7lMHkmwcyTJ0nV/yYIfAkOQM0OOc=
X-Received: by 2002:a5d:9b86:: with SMTP id r6mr13433820iom.44.1597690566616;
 Mon, 17 Aug 2020 11:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
 <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
 <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com> <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org>
In-Reply-To: <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 11:55:55 -0700
Message-ID: <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 11:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 8/17/20 11:31 AM, Cong Wang wrote:
> > On Sun, Aug 16, 2020 at 11:37 PM Xin Long <lucien.xin@gmail.com> wrote:
> >>
> >> On Mon, Aug 17, 2020 at 2:29 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>
> >>> Or put it into struct ipv6_stub?
> >> Hi Cong,
> >>
> >> That could be one way. We may do it when this new function becomes more common.
> >> By now, I think it's okay to make TIPC depend on IPV6 || IPV6=n.
> >
> > I am not a fan of IPV6=m, but disallowing it for one symbol seems
> > too harsh.
>
> Hi,
>
> Maybe I'm not following you, but this doesn't disallow IPV6=m.

Well, by "disallowing IPV6=m" I meant "disallowing IPV6=m when
enabling TIPC" for sure... Sorry that it misleads you to believe
completely disallowing IPV6=m globally.

>
> It just restricts how TIPC can be built, so that
> TIPC=y and IPV6=m cannot happen together, which causes
> a build error.

It also disallows TIPC=m and IPV6=m, right? In short, it disalows
IPV6=m when TIPC is enabled. And this is exactly what I complain,
as it looks too harsh.

Thanks.
