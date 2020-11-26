Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE12C4E26
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 06:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgKZFDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 00:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgKZFDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 00:03:51 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B1FC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 21:03:49 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e8so581001pfh.2
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 21:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2zHJlzYcyS/w2x9nGriTjYukozvQ53PldyF6Ow2Y6rs=;
        b=lZxavCOFI4q3mwlWE4D+W8tXXRAMBpkuk5KaRZ6xbwiBLALeFxvOi35k6rRKPjg5JP
         wHV6NwShB+L1IprO7ABZpcsr7NmLXokmVRjBWb14ghIMwxmVzFnmg740jRsVOqDsgvbc
         KJ0UY6GP5GQHbMFGk1ZHOId2Tx95sFrr2WkbWEVUv3IVRdj86//aHPvhAw+Kt4ncGcrj
         gb/BX1+n5l6SojkpnzhPgk6nrzVmHVSY0uyqFnbWUXoFXH8B6aLfEFt19kex/c3t7DkX
         TM7nwViZ6roYlzTJ2ZCTDgbtxRaMHzAxQjo8wKBqqyobMGiHF4rRFma/fJmG76DSVPWy
         FV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2zHJlzYcyS/w2x9nGriTjYukozvQ53PldyF6Ow2Y6rs=;
        b=n8uM5EzSa86B1Ag5jiTaZfy1Rqvkd8cmjkfjKqVso0LtW+zjX3EIzmISuqs56zF/X6
         vLh+f+4VlCziH2l8qmSJqBZo1yBkIsQxLTZCrvetViNy1Puzfz4uy/y2RfJoUJ+9M3oF
         RJJWuysBNUeyVlzm1W/Lp8JRG/YU+ldW5lekBGLtXzfElJd2FJrlNbWfR5ns+IRmr8r9
         9TdxHJqlVQyAA00XzVpYLSlduenXJxDaxgSlUTrxV2rnPht59k/MLkwGeJAaifrjNSDr
         oxZ2fpSi1R3jczeu5CQteyER7qfLKy4Hx8TaoD8Uz6RSKxKgKIagtMcku5Teul1WTgfX
         UtjQ==
X-Gm-Message-State: AOAM532BddoeNvGZT7YRDAIeL2EqdlqqXlgb+j+kNVCuP2IkvUrhWt2h
        32H7dH+/ZvvqUspKo1euQIVA9vii/KhTm+pixl8=
X-Google-Smtp-Source: ABdhPJxhX8T0Dui99468NvNdfrB7jlr56FLyoYKM0CnIyaWpMAg5/DkIH757+YWZQAFKeNYz5HJv0agt0FrC6rP4zjQ=
X-Received: by 2002:aa7:985b:0:b029:197:e5a1:a317 with SMTP id
 n27-20020aa7985b0000b0290197e5a1a317mr1390992pfq.10.1606367029047; Wed, 25
 Nov 2020 21:03:49 -0800 (PST)
MIME-Version: 1.0
References: <1606276883-6825-1-git-send-email-wenxu@ucloud.cn>
 <1606276883-6825-4-git-send-email-wenxu@ucloud.cn> <20201125111109.547c6426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125111109.547c6426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 25 Nov 2020 21:03:37 -0800
Message-ID: <CAM_iQpWO=vvw_iK9KaQAzEULXzUmmQWxs8xzNsXhTj3i4WcnbQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 11:11 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 25 Nov 2020 12:01:23 +0800 wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> >
> > Currently kernel tc subsystem can do conntrack in cat_ct. But when several
> > fragment packets go through the act_ct, function tcf_ct_handle_fragments
> > will defrag the packets to a big one. But the last action will redirect
> > mirred to a device which maybe lead the reassembly big packet over the mtu
> > of target device.
> >
> > This patch add support for a xmit hook to mirred, that gets executed before
> > xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> > The frag xmit hook maybe reused by other modules.
> >
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
>
> LGMT. Cong, Jamal still fine by you guys?

Yes, I do not look much into detail, but overall it definitely looks good.
This is targeting net-next, so it is fine to fix anything we miss later.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
