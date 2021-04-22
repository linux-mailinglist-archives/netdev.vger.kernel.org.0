Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC3367F57
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 13:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhDVLNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 07:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhDVLNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 07:13:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7713C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 04:13:07 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id p67so26492139pfp.10
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 04:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/sgOrIaIWrgvxK7PfDqinJmI0vkOK0Ek1DzaFNO00UA=;
        b=e3duh6PwIavOy9cRpGuxXe9OzSmfdDEe/jbl9VCJ0qbTIj4vYLgNLtBnyTAfym8ILV
         9TB+XJrzV1ABcemn5UJjHY11YLOEyIMxb61sFt0KY8+WfAev7GdxXyphLS5rF+sLbxGu
         y+N6WJdOaujwazgeYShuyi+vpL71YWtakX5XiTIxC4i2Zzj9TD2A4DH0cZ/8nIgVdxSI
         8jR8mak+2O20V+oYv9J0SzL6s4vQlHxTOPtuDXvGIbxw7Ux0/hfelmgwR574sKiZmABv
         MqnkZixCszHwOU0dNPdrP1idKF24/mB6+9QPX3kULJ53XkA8a66053kMCr6/0VhOhH+I
         EhGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/sgOrIaIWrgvxK7PfDqinJmI0vkOK0Ek1DzaFNO00UA=;
        b=BGEpc8kd0l2oBQ4b1BHNNcATSfmbNyBAYCgjWm9p1ZnjJRiCqtrz33vpHDfd7FUcIH
         pa/9D+yRl99YL3Fk2zqAnTdyr29U/r441c7QYGqguvYAl2JUELbayTa++0d4LROyzd5A
         WFwlT5H0chdEZcNHFMdrvWi5rIKZ6ju8/qA1uhTqFlNgiFNJrTW39IB6cbPp2E0NKUTz
         9kR6nc2Wta+XvqczrP+uVsB+YUubQ5Mqk07ZV8uEg6iei6zWTiKJQxm9wnAT3ELrIn57
         EXUtPKpwdSc98SkTxoT44Qo6u0TocChoHj7UFVypeQnOzaMeWgU9iyQACsoc+yCqr1t+
         gi5A==
X-Gm-Message-State: AOAM530h64NIzxvBnV2nyopYCWQep0zLiW6AzpOeMPJaQ1QmkqaVIQBd
        g3ALXdxEIqitlSuO8NbTph15ZktH61wqYx+zw1I4yA==
X-Google-Smtp-Source: ABdhPJzCU5mzf+dx1XmCiGmAj0QROiQGTxgGNWI7KBQj5QJY7oIS4WM4Jv9GXeeK+raL4ZzgU480gBg2dxR4seugxzU=
X-Received: by 2002:aa7:8c47:0:b029:25c:8bbd:908 with SMTP id
 e7-20020aa78c470000b029025c8bbd0908mr2906081pfd.54.1619089987323; Thu, 22 Apr
 2021 04:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org> <YIFUvMCCivi62Rb4@unreal>
In-Reply-To: <YIFUvMCCivi62Rb4@unreal>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 22 Apr 2021 13:21:47 +0200
Message-ID: <CAMZdPi8fMu-Be4Rfxcd3gafyUhNozV0RS3idS_eF6gjYW3E9qw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: core: Return poll error in case of
 port removal
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Thu, 22 Apr 2021 at 12:49, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Apr 22, 2021 at 11:43:34AM +0200, Loic Poulain wrote:
> > Ensure that the poll system call returns error flags when port is
> > removed, allowing user side to properly fail, without trying read
> > or write. Port removal leads to nullified port operations, add a
> > is_port_connected() helper to safely check the status.
> >
> > Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  drivers/net/wwan/wwan_core.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > index 5be5e1e..c965b21 100644
> > --- a/drivers/net/wwan/wwan_core.c
> > +++ b/drivers/net/wwan/wwan_core.c
> > @@ -369,14 +369,25 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
> >       return ret;
> >  }
> >
> > +static bool is_port_connected(struct wwan_port *port)
> > +{
> > +     bool connected;
> > +
> > +     mutex_lock(&port->ops_lock);
> > +     connected = !!port->ops;
> > +     mutex_unlock(&port->ops_lock);
> > +
> > +     return connected;
> > +}
>
> The above can't be correct. What prevents to change the status of
> port->ops right before or after your mutex_lock/mutex_unlock?

Nothing, this is just to protect access to the variable (probably
overkill though), which can be concurrently nullified in port removal,
and to check if the event (poll wake-up) has been caused by removal of
the port, no port operation (port->ops...) is actually called on that
condition. If the status is changed right after the check, then any
subsequent poll/read/write syscall will simply fail properly.

Regards,
Loic
