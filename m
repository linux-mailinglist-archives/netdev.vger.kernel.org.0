Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C93247FB9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgHRHr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHRHr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:47:28 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F31DC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 00:47:28 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 9so15349924wmj.5
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 00:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVK0YNx24HcPHuTH3IaMolBAgD7pbv/QLfZZdQZaySk=;
        b=FF4U9KKcWZTLMAhLX4Fcxl2J7sLQbWeg20v/VEFr+XVuXDTQgsT52iJRq8aEZwoSIb
         7qVP3yIzdXkpaCXFb/mmNAQ0rfgV+8kgziuO+0RaVM/9E+XUjr5TVbeJRDW5y7jDoY9o
         W9cp2mcPIjJA1ClvA3rlWb9nWO4/HRUl1nRgBt1rmxLKhb3WxEyvDLK8fwn4FTuM+CiN
         bTjrKKCm2FvO9zXRzQ2ckBVI/zOcjFVZsjqecOHY2UyF8/e2VUhGZ2+/LWClaMtAkRcq
         SWwSBKxsn8ed7ey2jV3hb5fEN60KylIcFoVs3/cydfYKk51F4fYXPyUMy0R0aS4/a3qs
         A7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVK0YNx24HcPHuTH3IaMolBAgD7pbv/QLfZZdQZaySk=;
        b=hgN1mHcpdvXxXnEisu3MsTEu2roJC4Q1mZFTeMz48cQIO4fZNa8O7C1uUdy400so7x
         hFxv1tpHHNt4h5bhkCjDUygQdJPFuW5iM5dwNnK6biR0PvQr5DmakZFAxFeB+d1h90R/
         +UKu4ciOWzp3IOY6hYFbWOrAOTucCDXO6mKEb4C201k864IOva2I8RMHmq/c0/XFCSr8
         lou/MK5g+L/3b03Xl1ArmGxUQORg3qlLFM+0iINprjijhyhuLEFmzUNFEG06O4Us+WAB
         Ub8dbysyLBfvCuyeXmSvORD1L8U6sdfIigqdhmUUZIwGPCTBp6iHEUZVmonkzJIUyt9H
         XPrg==
X-Gm-Message-State: AOAM530WeHKij3i8HF/W5cb31Yd4Z2vbcQ5Fz6TtigpwFBCw7CkjUDvN
        RBqXLinzOkEtFvh5Ab8hGMlPhNP8RtafmZ1pyAk=
X-Google-Smtp-Source: ABdhPJyUV2WCVKcLeeLpo7C5hGjThNOcX1cdQWbvujoQbH876XD3+EG6g5FDSqDazQd7SR/9aFNcT2TGF7QlBY+uXbk=
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr17727495wma.122.1597736846757;
 Tue, 18 Aug 2020 00:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
 <6d7aa56a-5324-87c9-4150-b73be7e3c0a6@infradead.org> <CAM_iQpUEjZzW-e=h30KZVvg02ZZMRHZn9JExxgn6E=XyWsjzNQ@mail.gmail.com>
 <20200817.143939.248108433650303983.davem@davemloft.net> <CAM_iQpUZZeZ-RYr-+h=r2TV7evL5AuJXe5gcso14TtBE+U82fg@mail.gmail.com>
In-Reply-To: <CAM_iQpUZZeZ-RYr-+h=r2TV7evL5AuJXe5gcso14TtBE+U82fg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 18 Aug 2020 15:59:59 +0800
Message-ID: <CADvbK_erTeDHk_Mh911=3AhSnL1+YNXNau-sLgm_2_eMUixvjQ@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Cc:     David Miller <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:20 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Aug 17, 2020 at 2:39 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Cong Wang <xiyou.wangcong@gmail.com>
> > Date: Mon, 17 Aug 2020 13:59:46 -0700
> >
> > > Is this a new Kconfig feature? ipv6_stub was introduced for
> > > VXLAN, at that time I don't remember we have such kind of
> > > Kconfig rules, otherwise it would not be needed.
> >
> > The ipv6_stub exists in order to allow the troublesome
> > "ipv6=m && feature_using_ipv6=y" combination.
For certain code, instead of IS_ENABLE(), use IS_REACHABLE().

>
> Hmm, so "IPV6=m && TIPC=y" is not a concern here as you pick
> this patch over adding a ipv6_stub?
>
This is more a question for TIPC users.

Hi, Jon and Ying,

Have you met any users having "IPV6=m && TIPC=y" in their kernels?
