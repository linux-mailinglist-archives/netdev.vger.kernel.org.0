Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EAA1A6B53
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbgDMRWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgDMRWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:22:47 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8214AC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:22:47 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j16so7980794oih.10
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hte6YmJ3WRkZVzx+YwinRCCNWLf/ZMtlU8hqonCurjo=;
        b=KDC/sIJL6Ra8Ui+FRLd2DHtL0F1pAetlMq54aVMgprdqxsLj1caHhE1a1zhN3dZKbc
         hgbrYeNAsZiwvdE8EVBPjI06ZJhuFaNLtmndgChu39LvKUbI1hBLw8T6f73vlb9QeDYu
         4aBkhp5rn58VZR2oy1x0V4IAWf1zxG+u+UhUGEw8NJX6wdE7R2HVFxkEoO8o+oKHCT2C
         P53cY5f5zCvw1XTS72ALkKTRIs5RhSGN2mVCOjRBpFYsfZPKzRRlZHAARlhrkmfop6y9
         tsrEgeAQ40cIctnfOUP43jmCluGzg/955z/Y2L95YLJtSpAFNMfZnmZLzs+yHobsxdzw
         WCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hte6YmJ3WRkZVzx+YwinRCCNWLf/ZMtlU8hqonCurjo=;
        b=IuVIoKXFglMoegYI92XFfpgX/CafezwFgT+F6n0WXXJTtdtjbeLMhw+bOWqZa2Gc8M
         sD4RKuhuNkonU43APN4iM1x9g8B6WiHmm2kTMamZioE5W2w0hd8ZhAG192812GmlPzif
         4gorIA5xqYpmIhwcWvY6YOH6NejfNNrJCP+mZgPScP08wL6KBy/hoCv0EPoILtGCIE17
         yghv70reymdb5okqvksU2ZsestRfHpEKcXy8MMGhMD+AdvJ2LWu4XFPRWFcSRxPcAbRi
         JeuZXSH2jgIE8rceYxthuFogUm+XAdbPxeoVDpq4RcQqyg7jEj3Yh7oaTxTINYri6wnd
         07UQ==
X-Gm-Message-State: AGi0PuZZ/2HTdcK+z1VCdv/azFbrRMZM6SYFXCJOXDyV+i9fGAbi3jkA
        FH9qtu6G9wi/Dxlf2UrXt/D/m8M9K9CPZDa7mog=
X-Google-Smtp-Source: APiQypJf1Nq1LnEKAJAuzrOqCGWodNXI3vK20aWrt4YZ6Z83ukdGDSyQunDQfzI4KlnBwXeo4B40C4xpqDg7ew2iF+8=
X-Received: by 2002:aca:d489:: with SMTP id l131mr12758912oig.5.1586798566780;
 Mon, 13 Apr 2020 10:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200412060854.334895-1-leon@kernel.org>
In-Reply-To: <20200412060854.334895-1-leon@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Apr 2020 10:22:33 -0700
Message-ID: <CAM_iQpUmX0+cACZdJaXvJjHWNXgi4-AWnsLAdtFA45=RpcRnOg@mail.gmail.com>
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 11:09 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@mellanox.com>
>
> In event of transmission timeout, the drivers are given an opportunity
> to recover and continue to work after some in-house cleanups.
>
> Such event can be caused by HW bugs, wrong congestion configurations
> and many more other scenarios. In such case, users are interested to
> get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
> netdevice in trouble.
>
> The dump stack printed later was added in the commit b4192bbd85d2
> ("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
> extra information, like list of the modules and which driver is involved.
>
> While the latter is already printed in "NETDEV WATCHDOG ... ", the list
> of modules rarely needed and can be collected later.
>
> So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
> large cluster setups.
...
>
> Fixes: b4192bbd85d2 ("net: Add a WARN_ON_ONCE() to the transmit timeout function")
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
