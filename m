Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D80412BD0
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348579AbhIUCiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344752AbhIUCO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:14:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EBBC09B056
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:31:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so104962pjb.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCI+dwLK0kWL/6b3AEDy1gjunCmBBosDhWlhnEbopa4=;
        b=VbffzBgPjDiDQhwpar/31zifCBQOnuI8WPWggE1lqz2ey5vZjN69V9/hd7coQ09Xib
         r1Lm/esf3ulSIxIzaQg9sv6YZtAMcPKXNoFMIpuE2Y1snrCYkfFKBC6xxumtcRmceg70
         9YSWa+H6JBjaCbvFurNxwHhF2fa+xdayCM09ShGZ00R1XHl5JPu4fL7SQmNeSfC8oGqn
         i01yqe+DQN0xn3jucAoVcKAcMVZTueJcukdOPMYzzaTlaK52C5T5MwrD9PRnqMnW9HkY
         l4zWhojSxE70+PJBAMmlhbwgHib9Ndpsl3G6O65SalEeuHK9ZJI/ufF+wwMSKU1MeDJb
         01JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCI+dwLK0kWL/6b3AEDy1gjunCmBBosDhWlhnEbopa4=;
        b=326MbNeomT7qHUvQfT1TmCxsItBuFjCFku0cxFrn06nSnAE2GaPs4TfpZArqwbVwSa
         yDhhHAvhE0c5eEH4BG0LcExDQ9CjIt4B6W/1ZbH+F1ykNMah57GArX8dER+GpZ6ZLJOR
         CWUm+dNAMtotMRu7LOsSxvHMEphE2cCoOmEb+gksBJol2eJPHMY6Gc20UeNu/Tny5q4A
         wFF2PX+lk9nfDqfgmjxDNVQ7fE5CGlwVU31nVzu0+Wyxk91KymcC05OGtciJCRV4GcRf
         l/+CVlTuKmDfURiKqR15+mHKxdvfuZ34nSgx+KNCka2sQ+IPuRyyLRbUWtGl94S65WZ6
         76vg==
X-Gm-Message-State: AOAM531CQ1ljSjbzMzN5kYcuam3qAEfyNJtEcU+GRE/IwvrUXWA7cj5O
        FcULy0pgDpbZH1OCArVnAdKJKxq6mUmqUqwccEg0B1ql
X-Google-Smtp-Source: ABdhPJycTASPqbs9O9+PRxx8oOWORtJsNn32elhk24uPKsQG1hjbgGW2AQl7g5kGpYYgO2iV5WT9/XONVQAgK0g0xxQ=
X-Received: by 2002:a17:903:102:b0:13a:66a8:f28 with SMTP id
 y2-20020a170903010200b0013a66a80f28mr23879291plc.62.1632162682500; Mon, 20
 Sep 2021 11:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
In-Reply-To: <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 11:31:11 -0700
Message-ID: <CAM_iQpW53DGw5bXNXot4kV3qSHf5wgD33AFU3=zz0b69mJwNkw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: sched: drop ct for the packets toward
 ingress only in act_mirred
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> nf_reset_ct() called in tcf_mirred_act() is supposed to drop ct for
> those packets that are mirred or redirected to only ingress, not
> ingress and egress.

Any reason behind this? I think we at least need to reset it when
redirecting from ingress to egress as well? That is, when changing
directions?

Thanks.
