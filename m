Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F82232CB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 07:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgGQFMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 01:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgGQFMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 01:12:01 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229F2C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 22:12:01 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x9so6348784ila.3
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 22:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84WUE6XhfM+S2zXEyhxOAdpt/CWyunQ/iasOyg/SIwg=;
        b=ieMw8Xd4xqT2y0cnOFU7IwHRD8q7uBnB3AYgwA/o7FDtnX8+RpicYu+3HMA0bw/4bM
         6rGOATNAUI+9AJ9mn4yZJZH78Y7ve7a2jOWheoBhXvMsNTENab/mHTalPWunr7SSDpIp
         Et30vffrSmOFZoFPbCkflEk9+4oTXljZlq5ITrqX/BOWa3vq65D9IfDeT5q4Kb7EJZjv
         VKjoiN7PKoDi7g4L8waPg8fjfbuZeIvkZfA/VO+q1/GQTfBAvxKxbhd+QcJh3bm6ODZz
         mvocWq8R2vIhed5H1tMfcfUvKeCdLZrEt97qX6N2ujxLU3TKBhE0TCDWtUqa/Zg3w2ak
         6oeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84WUE6XhfM+S2zXEyhxOAdpt/CWyunQ/iasOyg/SIwg=;
        b=PlqqDhRWhnJdzOFht4MaN8aDZn+8io2njeOjSwi/0qx4Mr0iN2FEWCqV64CRrnMsnQ
         9EacqTq8cCrM0zsVvXY3LbnlJMyEvqcA0XF4QFNM6jTcW0S1uk1dbXLeO9Mu74uc9OkH
         w7f5xkvtgi8zdqVX/wuMdnBmYB3EyXGpbjS7SW9gL5aMz1rYWAfj5pr7g95h/SOiGEKb
         eUd701HcPGMo4Lofv4wsDwJdEJKm5JfrGg8wvZ0zKR+wNVIq/PBCqnPNMuo8qm0kkLIN
         MvtCNKsRpbPcUvZXjccv4knvq3L/o5naVNmKw23AzGZtxwr5OJgDE/orPmMymSuqPa0l
         ZVtA==
X-Gm-Message-State: AOAM532sHFkc9q3kr0nKkTazfANokjdef3JTr0DJXFzI+NPFb7kleiOw
        XumkK8ukhHqzQkz+hJDKkzByPTjtWIsUSNKWWbY=
X-Google-Smtp-Source: ABdhPJz6zSBBMiXEv3jO9uZ4Sy0byWswVJLj4+FSgeylnkBXMDyiKiLf/hp2mPZWCiunT3PAC6gStkGuOXnCyCkyXlk=
X-Received: by 2002:a05:6e02:128d:: with SMTP id y13mr7930312ilq.305.1594962720409;
 Thu, 16 Jul 2020 22:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
 <1594816689-5935-4-git-send-email-sbhatta@marvell.com> <20200716171109.7d8c6d17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716171109.7d8c6d17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 17 Jul 2020 10:41:49 +0530
Message-ID: <CALHRZupxX5Cbvb03s-xxA7gobjwo8cM7n4_-U6oGysU3R18-Bw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Jul 17, 2020 at 5:41 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 15 Jul 2020 18:08:09 +0530 Subbaraya Sundeep wrote:
> > @@ -1730,10 +1745,149 @@ static void otx2_reset_task(struct work_struct *work)
> >       if (!netif_running(pf->netdev))
> >               return;
> >
> > +     rtnl_lock();
> >       otx2_stop(pf->netdev);
> >       pf->reset_count++;
> >       otx2_open(pf->netdev);
> >       netif_trans_update(pf->netdev);
> > +     rtnl_unlock();
> > +}
> > +
>
> This looks unrelated, otherwise for the patches:
You mean the lock/unlock logic with this patch?
I can separate this out and put in another patch #4 if you insist.

Thanks,
Sundeep

>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
