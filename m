Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42803366583
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhDUGiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbhDUGiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:38:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B8C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 23:37:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id p12so28824317pgj.10
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 23:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKnb0/Wp1/KdttL9yRw7SGhgV9gm7UJrbe7pDdJcB2s=;
        b=cIAvj+b0oXS8z+hy/4HNj1PYtUcxooUaIh2OMKj8qMOJwpV9A8KgmLFYhQGW80sgmX
         h9CVBOsAvaK1VeAoKiFAFYTjnO2uUJVN/YVPUX52tMiCz1fMy+Yd6e9HhmmgM7THzD3V
         DLIDj3lmado+iU4GY84E59KkyZSzVjUmFFDhGqK1NawYcmB8jHEDSsd1EavLbXj4JDcQ
         yMsJ5UBWaZc+rDTuiYjNOl0lJXrWtQakuXdWWziukdoXxjyXTikOIHq9/zP6iQucrKwL
         zTdrRaBAU8XXMszmeRW39N+RbhixibAuziHkCyqM1M7jfHXn0tKXvJs/fWcSI3+oZlAH
         9uEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKnb0/Wp1/KdttL9yRw7SGhgV9gm7UJrbe7pDdJcB2s=;
        b=sS9LxNkFPi4/sknXtwO71bSGy3iQCBYDi+h7RQDeK52npf5IaNbhEwrJIYoYPC39Vo
         9JX4GwsdjJcxYoz3/UTzB5RnCCV7yhzUNkaTBJMv/a58u1sL8oC8uDdTFOzsfKdRe0me
         /akhr3euigtPrl6iwUFNEuQt9tHReIUA+v2QF17yHe7PPtm3+uNwYMpr/gMwyb2+LRx6
         OltSmtKALo401cbZY7+HQZ/BMcswSBvcJVORWIbeUqpkYen+lyrl4E061qvStdilnbyW
         dGFgLdyVT6pwsdRriufAEEC8/0a0wxZ0dsosu/5po5IQ1gpAZ+2aGYbYCgcNny/KVZt8
         HEsQ==
X-Gm-Message-State: AOAM5328iwLGYI0xjjBuKntEnBq0vXdvaelmzran0JpUtR3SIEPB3cC/
        +RDTni49pA4GmHtlfhWHC0ljRTmJrivRqa2Nwn3Y9w==
X-Google-Smtp-Source: ABdhPJzY+O+wn3KsiwnyK8jf305Cuddgx+uwIvGe7FkkOxZ2PTS3ZBUG1XnFCslPF/PRHNZ1rrBym668hxUkLlbeApI=
X-Received: by 2002:a63:ff0a:: with SMTP id k10mr20944841pgi.303.1618987046493;
 Tue, 20 Apr 2021 23:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210421035616.14540-1-jarvis.w.jiang@gmail.com>
In-Reply-To: <20210421035616.14540-1-jarvis.w.jiang@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 21 Apr 2021 08:46:08 +0200
Message-ID: <CAMZdPi9pqS15ABWMpGOZ35-wvfGL4z=NRMrN_Az3nZvmmEKSWQ@mail.gmail.com>
Subject: Re: [PATCH v1] net: Qcom WWAN control driver: fix the rx_budget was
 eaten incorrectly
To:     Jarvis Jiang <jarvis.w.jiang@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jarvis,

On Wed, 21 Apr 2021 at 05:57, Jarvis Jiang <jarvis.w.jiang@gmail.com> wrote:
>
> mhi_wwan_rx_budget_dec() should check the value of mhiwwan->rx_budget
> before the decrement, not the value after decrement.
>
> When mhiwwan->rx_budget = 1, mhi_wwan_rx_budget_dec() will always return
> false, which will cause the mhi_wwan_ctrl_refill_work() not to queue rx
> buffers to transfer ring any more, and rx will be stuck.
>
> This patch was tested with Ubuntu 20.04 X86_64 PC as host
>
> Signed-off-by: Jarvis Jiang <jarvis.w.jiang@gmail.com>

Thanks for the patch, but a similar change for this issue has just
been merged in net-next (a926c025d56b net: wwan: mhi_wwan_ctrl: Fix RX
buffer starvation).

Regards,
Loic
