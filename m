Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CD7267C3B
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 22:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgILUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 16:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgILUWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 16:22:39 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12C1C061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 13:22:38 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i1so13906586edv.2
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 13:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TaWHG3+kwxHGF9n2Vz1ElQEbLpVnZUWuvYL2EGrYgVw=;
        b=rbYH5xRBql4r+rggl0/TVBWIf2/lTi15twjy3NhW4vfKqChFtzRzzSKZs+1KS1Vcg6
         KXwYr1IwJg3yNAhGIUDrE1EVY0d3DvsKrVvFPoDZ0hCid6WUbEGWb8Vf5Xh2hJONDzN5
         E+owh6+YBwFwN26KOBE/odw4JwEWb1htTTCu/obgekCycEdvlyMCDZksNpcJCSyhlQAY
         JC0gbkP78oxYGI8/1vr0LQwblgIEBV3yVSChnkYBgGoOi2kapf8wnK0Tty+gNv6Lm1AS
         IuVhC7eMw+xrSY2ZHfVQJuuzFjt4bzpmEftjsE91NwEi6tQ20uen8yuz/gGOZSzanHGt
         QLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TaWHG3+kwxHGF9n2Vz1ElQEbLpVnZUWuvYL2EGrYgVw=;
        b=Y//L0aTcpikQBQmkLxyBDgg9OMVC3Q+Ii6W8F+B/CxuOKHaAmRZfGJJDy9mYtvZ2YI
         dCW7iAlz6kzy0xOzW53pEsCxCmCzsYXekMoCHJCwBeE5+a4nulhmBxdmFZ8nFuUe+4KO
         PL38mPLQF/tuaS2hbWooJFqiBA5I54a6V4Xz45UTnE1PKQBA95rOoC8oo1rllEHOmpqW
         IpmpoW4cl/02fHqz62AQBnp7WdyMqnoB1ivpb/Ezu/R0suGR252eYioBiF8tK3F3OGo7
         W7uf4RJ0N97tT9VUmHleFTdp6wAf7iV2Fld7CpwEpPIO+Sk2ux4gyqDYr2rthMDLzTcK
         nIuQ==
X-Gm-Message-State: AOAM531wJZ23Ggsux2EwrhNbYWFbHZ3eaMvSoSILhwXV7hNXvG75/6Bv
        LqKW9luW9JHS3pmhct8Hnl8NOdxxNtoK7CeL4drjRv+y2Jg=
X-Google-Smtp-Source: ABdhPJzc4QTVqSnvtCEXi1UHvDVYFe0v7ezzL3robh904ulJSlAKDm5KdpyHGXKMiKd7/9kqBzVPY30jo6L96jeRQmc=
X-Received: by 2002:a50:fb98:: with SMTP id e24mr9749603edq.130.1599942157392;
 Sat, 12 Sep 2020 13:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200912193629.1586-1-hauke@hauke-m.de>
In-Reply-To: <20200912193629.1586-1-hauke@hauke-m.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 12 Sep 2020 22:22:26 +0200
Message-ID: <CAFBinCDGiQ9GJQ5Ykvu-h6WCidCuBuA5b_8dZsjX88JB-F+KOA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] net: lantiq: Fix bugs in NAPI handling
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hauke,

On Sat, Sep 12, 2020 at 9:36 PM Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> This fixes multiple bugs in the NAPI handling.
many thanks!
These fix the TX hang that I could reproduce by simply starting iperf3
on a lantiq board.

Is the plan to have these patches applied to net or net-next?
Having them in the net tree would be great so these can be backported
to 5.4 (which is what OpenWrt uses)

> Hauke Mehrtens (4):
>   net: lantiq: Wake TX queue again
>   net: lantiq: use netif_tx_napi_add() for TX NAPI
>   net: lantiq: Use napi_complete_done()
>   net: lantiq: Disable IRQs only if NAPI gets scheduled
for all four:
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>


Thank you!
Martin
