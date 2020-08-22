Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7624E9C0
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgHVUTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgHVUTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:19:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C76C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 13:19:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p14so4906728wmg.1
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 13:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oo1n0p1iLW6sNpC9eC2YJ9Xtd528qwuVSx1ch1xZTRQ=;
        b=ieQZeetL0OKsMoNc78SgwWHq9XvmeDuFnhLxJ7C4Bdgz13ub+dV/IqpsAyf+X98hRz
         2SutMqF/6+HKwAvBI/lCtrSfCkkB2MdT6kqVkPW93OeQ0/71xJ8ZDVQ/DhUuGrj/vX4a
         bjpmphAHSVY6AclZwJ1T75DQ6izKT9P2AgRSrkviveUAQZSO8Ixm8Kl5FWuvEFiaLT9J
         yW0DAX6WT8YApCW8zGkbPwAvL5nQRQPPSHaJEQbEHE/6nOhZSFgykNEatzNGOVSESjO8
         MkSc/Zcj1pLnJ6Az1tI5kTZhBRE/+QvTUos+U9HnF84xStrXzeKzIrASUIdKp6oIoAIC
         4+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oo1n0p1iLW6sNpC9eC2YJ9Xtd528qwuVSx1ch1xZTRQ=;
        b=BvvEI32HIVjJnNknPMsm060eq3FwVowGGWbs4bbCOYLCejupRmi0i2wyoIINdwVBHg
         UHfwOWnivdRUcAum2pRRuNsDbB/g4ehkluY3eOMA8EUENu+7VAUrgc7Ll/QefSyJHIRA
         h1VntusAgbMerzW0+HzwjrIEKKufvLrnff3rHgbkHMZ2Pq1Vck7SVzglp7h35yQUgdBP
         WVFIKM+j8OVC/hGdAum6FtAj1vyIPWbOiLu/M276Cn2qJpqa6e/AYl1l6Vx5bcwDJI5x
         XQYLgtxUnZ519h9BJn5h03l+X7wxBDuIGgroQFPBKHxJDM6617cOcY5V8Mkeoi0L0QjI
         gxWQ==
X-Gm-Message-State: AOAM530sRK2nzUjn5CQm2ktghRd23VPg2RCEtCtiTgrIbiQVzMuCDkbI
        g/U7pqqDv8AEdDJpTVxqpjnjIrqDaSIzoUhIQwbMOQ==
X-Google-Smtp-Source: ABdhPJyYlJSS3RgFCGQAAz5xguxViXgNb8MdYGx6bvt+R/b/JM59tQypFCNz9vxuiOeHMbRvGGwMtuS9EbTJ1z2S2dY=
X-Received: by 2002:a7b:c15a:: with SMTP id z26mr8613243wmi.35.1598127580082;
 Sat, 22 Aug 2020 13:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200815182344.7469-1-kalou@tfz.net> <20200822032827.6386-1-kalou@tfz.net>
 <20200822032827.6386-2-kalou@tfz.net> <20200822.123650.1479943925913245500.davem@davemloft.net>
 <CAGbU3_nRMbe8Syo3OHw6B4LXUheGiXXcLcaEQe0EAFTAB7xgng@mail.gmail.com>
In-Reply-To: <CAGbU3_nRMbe8Syo3OHw6B4LXUheGiXXcLcaEQe0EAFTAB7xgng@mail.gmail.com>
From:   Pascal Bouchareine <kalou@tfz.net>
Date:   Sat, 22 Aug 2020 13:19:29 -0700
Message-ID: <CAGbU3_=ZywUOP1CKNQ6=P99SgX28_0iXSs81yP=vGFKv7JyMcQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: socket: implement SO_DESCRIPTION
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 12:59 PM Pascal Bouchareine <kalou@tfz.net> wrote:

> Would it make sense to also make UDIAG_SHOW_NAME use sk_description?
> (And keep the existing change - setsockopt + show_fd_info via
> /proc/.../fdinfo/..)


Ah,very wrong example - to be more precise, I suppose that'd be adding
a couple idiag_ext for sk_description and pid if possible instead
