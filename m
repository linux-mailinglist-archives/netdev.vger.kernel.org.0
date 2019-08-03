Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B6880416
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 05:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbfHCCmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 22:42:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44154 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387492AbfHCCmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 22:42:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so73977004edr.11;
        Fri, 02 Aug 2019 19:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o1vMxhl+4Xe8qt/aHo+GhoXoYmWQszbPFJSU0NitREQ=;
        b=VvHc2KZkDBdebb6X8/gGkQvTDaYUvh/XU5tP/42xt6NVPTfjJOyNyL7/9fNgAZrgih
         4bryokS8g7RSJX8RY9r/PeWkPp029rbVwLGpnPHk9eJjZJaAERVj/a/Qz044hf+rfumc
         8phV03Gl/qpN2BKLJUZlHL+psH+2XaTBVG5UVIGmhXKk8atykWK4GNYigxYmyYFZPmnT
         DBsENi0ZOO8AfcUmET3/yFiCQi+/ZGrB2YQ1Hp6cEGTCFRI9AhDpnDYIkTwvweQ5g8dZ
         LwWvPDUdixr4iznREIccOOtKVx8W2x1PG8RCDWlKjfu2EslcUlR5c6fmhizqCJCR3Txh
         Xb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o1vMxhl+4Xe8qt/aHo+GhoXoYmWQszbPFJSU0NitREQ=;
        b=ogt5up4vX/Glo3QVlnXztfmlllrFnOtV5AOwhWO1PZGyaqJVm/Sk/BeNKkdZx3mB67
         4sHcAMLaE1Oq04P97uz1KGGYmwduaupBYHagl7H71MTKxhoND/Ksu1s1+4bryNhW7YWg
         +K/AeJOgoMhqvk5lZBy4rbp+3doxYFeZQ+uNGQ+lfNNxGv4EtrS7t8/WXTqNFzKbZ9ev
         s01K0X9IXHOlo0Z9Yb+y2IEY4wIFPoHev+p3iTgabTeIUGe7QB/JJfG6huln0qZzjoCr
         hXXtpQ/qA8irI5LEjTPwVZQnXa270DATAu2JgFOkPDK/2h6PIjL23WBXiTL9/8cL3zpg
         IsxA==
X-Gm-Message-State: APjAAAWnV38dtcVntxBKky+sRGsLX/kMApM6UMCvBNCdU/1NMUKu/0Zz
        uw4bxF3/o8/Vt4COt3+mo9fFJTIyioRjnqoOK+k=
X-Google-Smtp-Source: APXvYqwz6jft7qzAaK2FHh0KFWud0KyfK29vGPe8vQ99QQ21veviaWlDirto/7DeK2h37wXASAXva3yGfsaunlGCWg8=
X-Received: by 2002:a17:906:32c2:: with SMTP id k2mr15739979ejk.147.1564800162874;
 Fri, 02 Aug 2019 19:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190802121020.1181-1-hslester96@gmail.com> <CANhBUQ1chO0Q6wHJwbKMvp6LkD7qLBRw57xwf1QkBAKaewHs5w@mail.gmail.com>
 <47bb83d0111f1132bbf532c16be483c5efbe839f.camel@mellanox.com>
In-Reply-To: <47bb83d0111f1132bbf532c16be483c5efbe839f.camel@mellanox.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sat, 3 Aug 2019 10:42:31 +0800
Message-ID: <CANhBUQ1wZPinWicu2c_VZjpTtP_9+AxB=7zn+ymPyYVo_rsxZQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx4_core: Use refcount_t for refcount
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed <saeedm@mellanox.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=883=E6=
=97=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=882:38=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, 2019-08-03 at 00:10 +0800, Chuhong Yuan wrote:
> > Chuhong Yuan <hslester96@gmail.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=882=
=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=888:10=E5=86=99=E9=81=93=EF=BC=
=9A
> > > refcount_t is better for reference counters since its
> > > implementation can prevent overflows.
> > > So convert atomic_t ref counters to refcount_t.
> > >
> > > Also convert refcount from 0-based to 1-based.
> > >
> >
> > It seems that directly converting refcount from 0-based
> > to 1-based is infeasible.
> > I am sorry for this mistake.
>
> Just curious, why not keep it 0 based and use refcout_t ?
>
> refcount API should have the same semantics as atomic_t API .. no ?

refcount API will warn when increase a 0 refcount.
It regards this as a use-after-free.
