Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4964321526C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgGFGNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbgGFGNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:13:18 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4DAC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 23:13:18 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id j202so18459943ybg.6
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMwksCpJ1nWC3WQQUpYSonmNl1qEOQ5RfMrCvK1LxN8=;
        b=l0qEoBfcIrsZDghhZC6HHEbkM7/u27QFaYekYyUn2F8oWO3wFX4paelm+kR6QqfPnj
         3qWxg+hZ+jjjjEl+F9SlpP2FX+lHme8Z52qHnE+pn4gX4onGh6h/oSK2gOeQ+x9Inl4e
         f9bOKPE2xrkauSE4/rNKWylfQbl2XUCXRy24N7D4pX1FbSzjdWBDvoyxXxIzkOPNuPI/
         TKJUcPwKXY+BH/CMEw6+77XELbIQophBd8cZ/HN5nSZ+OtzkdA1C0f36GdMG7ymv+FpC
         Jo51Qn/Gx9VTIoJcS72Eo8NlGpH4yeavNwJgK4RxocGUXlbfIKi05q/+MisCgJJRq2Ql
         Firg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMwksCpJ1nWC3WQQUpYSonmNl1qEOQ5RfMrCvK1LxN8=;
        b=YoS/fdye1gTu7HMG8D9L6uYjrpL3by/ntlz1MOoBtaCISPTUonwbZVaLtq41rbGJYv
         DEB2RlQ0M73PhKKQg7sD1vChoUg6DvfafcrHy85WTvUwHU3i12XtLGaOQFLBUcCl85CJ
         VDBQLU1L+WmyyyVb+4Q2axK/cFv+byb1DXzbvY5zU+uE0DSkTFoS03ZNQPP+PEJJqcnD
         YbUPvkZo2bx7UcEiMNKShpojgUk0qLVPLunQfGSAUFCbpVYnNFcmr+tpyGBU7Ec9zcSa
         85xzGxiWbzDi01r/lVPbYw9AYM1S5MYjbAQSQ+GUMvkZEd6KkQC7SwJ+DU4Oh2QetGz4
         y0pg==
X-Gm-Message-State: AOAM532iSPMsoUBWpxW9w8N8rJGrH0V7DEcaohhwe0gnkfGV+5ptnWB/
        1aquUL18npcPQ5oyBYiF1WcVaJoUOgkYT8MJDqE=
X-Google-Smtp-Source: ABdhPJxaZdqRqjprm0gtu/9Vl+HazX5oa2BT1QNQJEbBbKTpA29if7BTEMW07kelBdHjSbD7Z08sGZon5BYdU/BgpP0=
X-Received: by 2002:a25:fc1d:: with SMTP id v29mr6041642ybd.329.1594015997527;
 Sun, 05 Jul 2020 23:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221923.650779-1-saeedm@mellanox.com> <20200702221923.650779-6-saeedm@mellanox.com>
 <CAJ3xEMgjLDrHh5a97PTodG7UKbxTRoQtMXxdYDUKBo9qGzdcrA@mail.gmail.com> <20200705071911.GA148399@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20200705071911.GA148399@mtl-vdi-166.wap.labs.mlnx>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Mon, 6 Jul 2020 09:13:06 +0300
Message-ID: <CAJ3xEMje5d_Ffn05jDfY--jwNb9QZn8yS8MJcmy8zdxWzyc=FQ@mail.gmail.com>
Subject: Re: [net 05/11] net/mlx5e: Hold reference on mirred devices while
 accessing them
To:     Eli Cohen <eli@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 10:19 AM Eli Cohen <eli@mellanox.com> wrote:
>
> On Fri, Jul 03, 2020 at 12:33:58PM +0300, Or Gerlitz wrote:
> > On Fri, Jul 3, 2020 at 1:24 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> > > From: Eli Cohen <eli@mellanox.com>
> > >
> > > Net devices might be removed. For example, a vxlan device could be
> > > deleted and its ifnidex would become invalid. Use dev_get_by_index()
> > > instead of __dev_get_by_index() to hold reference on the device while
> > > accessing it and release after done.
> >
> > So if user space app installed a tc rule and then crashed or just
> > exited without
> > uninstalling the rule, the mirred (vxlan, vf rep, etc) device could
> > never be removed?
>
> Why do you think so? I decrease ref count, unconditionally, right after
> returning from mlx5e_attach_encap().

so what are we protecting here against? someone removing the device
while the tc rule is being added?

why do it in the driver and not higher in the tc stack? if I got you
correctly, the same problem can
happen for sw only (skip-hw) rules
