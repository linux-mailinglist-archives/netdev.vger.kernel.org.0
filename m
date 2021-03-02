Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD27532A31C
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381875AbhCBIrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445144AbhCBC4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:56:43 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ACBC061788;
        Mon,  1 Mar 2021 18:56:02 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f20so20171149ioo.10;
        Mon, 01 Mar 2021 18:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/iU+4MCfDOZKJqdyJrM0gfu7fMW1rxZzEA8By+aoPI=;
        b=fofpuf54tNID7ojunPZi8cAg3fKWUhTBIostlMtbptISKhMsU03ycwudk1iBBcpujG
         QSfkI01LfoQxF6j72v7OlxjldYcW+WIGpCdcnxpoejOREsIUVAMUj6J1OFdiqJ+u4ZHr
         f9rA8bCKMbxefXkI5jyP72R/PJ7NQuFx/w8FOWTd7bqIH0yT9fVmCTt0FbeqOon/mPxA
         rchD8Wqhpq4SUgXc9U6TtVBpCxz4zt/E1iD6o9tCsY8ms4KRAlmqC3KaJLqUmENN+eIR
         mrx2D3Skem9VwIACf1CDyCBUQpsTBUSojxLX7cJsbUhEvWV/pXz8pbI+pz9dsDOcf7Zt
         5NEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/iU+4MCfDOZKJqdyJrM0gfu7fMW1rxZzEA8By+aoPI=;
        b=mbmvGBKjq6B35F6ro1K8adN0pFa/SDAIp85ac7ho5MUnDkUz0ZJUWzlCADcUPxH4qX
         g3+L/hmXV43HPRJqBuy9eCP+dcr/vi0M6r+3/DLx6D9NwPDBRcUyc0xEJ2AP7MA/Rrb5
         6lrImtwx09j9+GFbe+OlZ/qPCbt6oJjCuA3oM7X81A8eaHE70me7/yY78vCHujahuls/
         keX+foJZdQARj1eFwTyy7kZL0UHJRz4MquMYAU7c3sLNiFuuCfZQH3oM17o61jgVu1pk
         lWi5pIvpCGMuH/1nWGOOpd5hK+CXZVfLGF+OWcWm/D7yZAJ/KA/hfcd93ZKJsp9dJyDC
         ns4Q==
X-Gm-Message-State: AOAM531VwpF/EywwAdXKifWhpqi2zz9bmA+OewLtREG38hm9YLO8g/nk
        Pk0PQxP/IEaAouFjW3/GBlIsi1UA3oJ2S+C3XsQ=
X-Google-Smtp-Source: ABdhPJwqpFM+0OqWvmoSVEZdsnnteDFQItJgeJAHaSAVioKlWRvNw1lvx/tqf6Q9Lc/rPUNX/1uc8IvTajMPMohMW10=
X-Received: by 2002:a02:b893:: with SMTP id p19mr19211711jam.68.1614653762507;
 Mon, 01 Mar 2021 18:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20210301041550.795500-1-ztong0001@gmail.com> <20210301150840.mqngl7og46o3nxjb@pengutronix.de>
In-Reply-To: <20210301150840.mqngl7og46o3nxjb@pengutronix.de>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Mon, 1 Mar 2021 21:55:51 -0500
Message-ID: <CAA5qM4Di1J7oPK3JrP8o++JUoBqkQ-wDzmwrBaT+9mmpCgK+=w@mail.gmail.com>
Subject: Re: [PATCH] can: c_can: move runtime PM enable/disable to c_can_platform
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 2:49 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 28.02.2021 23:15:48, Tong Zhang wrote:
> > Currently doing modprobe c_can_pci will make kernel complain
> > "Unbalanced pm_runtime_enable!", this is caused by pm_runtime_enable()
> > called before pm is initialized in register_candev() and doing so will
>
> I don't see where register_candev() is doing any pm related
> initialization.
>
> > also cause it to enable twice.
>
> > This fix is similar to 227619c3ff7c, move those pm_enable/disable code to
> > c_can_platform.
>
> As I understand 227619c3ff7c ("can: m_can: move runtime PM
> enable/disable to m_can_platform"), PCI devices automatically enable PM,
> when the "PCI device is added".

Hi Marc,
Thanks for the comments. I thinks you are right -- I was mislead by the trace --
I have corrected the commit log along with the indent fix in v2 patch.
Thanks again for your help,
- Tong

>
> Please clarify the above point, otherwise the code looks OK, small
> nitpick inline:
