Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2A302141
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbhAYEja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbhAYEiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 23:38:54 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F81C061574
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 20:38:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c128so9522880wme.2
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 20:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EGka/ttc0CCRC+Phnexh4qtng/pFVEdxxtLPu7dGKRY=;
        b=Qhc5iowjfxiAP4UH8hrRsDErLri/nqnTBL1SBXEgBsJbXfco2A+cQDyvfJl2n+dF3I
         OU4QWB1Qs8a0HvSJFvJoBdIQFC6T6HZdLBbWqSxqblNzX0SMizGSKl6zSJwfWtKJBjoi
         fTvmJHHmbXSwXgCojL8S1sXe43rV8E8KcQXasm3my99Uz/gSvxjq/3/clCXZAihAE7Mz
         6EmjYCWMRrGc5KCK/u/Ptx2IPz3IA+/zI1f6isV2TWG2kXF8oj6uSJ5onM4F8OOPolgU
         0RGYdkheNkW32dNu4GyDuKzHyJisuZQly/cm1BI4lojVT8KjwPGfQA0dM7WsknO0BUec
         Rl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EGka/ttc0CCRC+Phnexh4qtng/pFVEdxxtLPu7dGKRY=;
        b=Hgp6VCEA8EzDDzl83O0hstx+Xjqr71jRenoO1/WaXPuDuD/TjGFTiSGXwodcLgvYdO
         kz2ztE3TyVie6Ty0HmEQwYOeISwiLDluQd9mthV4iDziCF9hRUm7zmJvU+LtXIko6gpl
         MtwDkSrbSsz6UNVgLood5rotX4IyP/W95nilfXWLPCcFfiZE2MDuje14hT1fAc4GhYJI
         DiEiBcWxw962FeYzyDoXIhGRrLndzeUErpui07hJYEQnQSQdBEqejvkrPI7/yqZAFCcK
         PukwiL1tmjYn+NH6eGTrP26YxxDCADMigQdRt8vg56OEHxS875/WCqZnNv0HyCTIomem
         J0iA==
X-Gm-Message-State: AOAM530wkBqVv++ga7G8Tm9GXMpREdgWf2LKYHJXJjrK5zGs+zSW5HDT
        AUwiqHvLKDLgYhQLU1bcMmUypx8qafarakq7Hx8=
X-Google-Smtp-Source: ABdhPJwedVIqCi7CRMIn7FRWfkB0xCnE8O+l2Hzvfhep77ugsXWJ4Il4FmbXvWjEaQfCgemUoCt+75CzvTgtvluxuaM=
X-Received: by 2002:a1c:e2c3:: with SMTP id z186mr4094812wmg.144.1611549493137;
 Sun, 24 Jan 2021 20:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20210121061710.53217-1-ljp@linux.ibm.com> <20210121061710.53217-3-ljp@linux.ibm.com>
 <20210123210928.30d79969@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123210928.30d79969@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Sun, 24 Jan 2021 22:38:02 -0600
Message-ID: <CAOhMmr4r0OvSvbr68B8483mwJKtm=8BjiYUQa3gtin8ajZQ-5w@mail.gmail.com>
Subject: Re: [PATCH net 2/3] ibmvnic: remove unnecessary rmb() inside ibmvnic_poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 11:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 21 Jan 2021 00:17:09 -0600 Lijun Pan wrote:
> > rmb() was introduced to load rx_scrq->msgs after calling
> > pending_scrq(). Now since pending_scrq() itself already
> > has dma_rmb() at the end of the function, rmb() is
> > duplicated and can be removed.
> >
> > Fixes: ec20f36bb41a ("ibmvnic: Correctly re-enable interrupts in NAPI polling routine")
> > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
>
> rmb() is a stronger barrier than dma_rmb()

Yes. I think the weaker dma_rmb() here is enough.
And I let it reuse the dma_rmb() in the pending_scrq().

>
> also again, I don't see how this fixes any bugs

I will send to net-next if you are ok with it.
