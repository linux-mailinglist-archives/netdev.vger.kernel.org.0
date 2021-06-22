Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1CB3B0600
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFVNny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhFVNny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:43:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F507C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:41:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso1811259pjp.5
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EhfwKeXUYq8ed7D9hwUno8W2/7pVvzq8AkJc0N5Fs6M=;
        b=Yyb0/Hb/s18ORD4iurDRurK4pGkMqxX1Rx5Wy2N+1hqIvyW4MhKtH5NwHaJsSWceiE
         EPwZdy/WPhSvwRuVivFlza/AQQUhQXzEmqrsQzis7CRsf8ldeii+26T14ZNgE91OiYzs
         fJiJQoiqygZJo56ncqsTiEtRuhLzkSNW+f+dVQeI4fOj+d8XQautyUjyLfyI/ZGiKcin
         s/AdLpywXFJIWxIFt8IbvTPHx7lBKJVh78dzETBGRwTymHM/RCa2j9quF02TWKWzTqiq
         jMopAWkeh5r5jhabJkF4ZyEkcJ3fHdD/vRR96lG8tF6Zm9FMUyz+lyLpB/WnbbpGbbIr
         ly4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EhfwKeXUYq8ed7D9hwUno8W2/7pVvzq8AkJc0N5Fs6M=;
        b=Ujoso7UzyRUI8weHswASBcmjD12hck2hnFmWcYGnCVWwkrJ9ajzm4jvTKSogGk0hrG
         EX1mn12kRwLnjIxOKeGxFyOxhd97z84yKqnbdrX1PaK7SXBP1xU85+QHV0UfSvTI+5Iz
         Ag7K2WgQiW0YQZm3PCROj7BYraHPNEYdxd8vu2XmAz4zmQGw8jzX+p/w1uX65myG7Eh2
         TfIAeM89rJ5VKWk5TncVU8+9IVp373+pvXpbeVruJox6D2ZH1X9Y9nCk4XBTav5fUqGk
         F1xqpqcUW63tsnFDjKstIq+EIcZYXrsUzimAFOTKq/3Yp74GB+SE1raAUnmk7Z9z4xYz
         iJ7g==
X-Gm-Message-State: AOAM530mF6Ed9EgYwtT9Pnq9gVehh+Aw4MQ1CMqTelrn99xft5DO9gwF
        lXcR1FuRVwdMwc0UrH34sn390tjp/LYSkE435x2dXw==
X-Google-Smtp-Source: ABdhPJxVcMyKuMlIetuYBKMDFD2v5g7uQ3fJSYCJSwwRxbuFO14tb5Gl35vdyq21OHYZrj38S6eYBi+ex6NhffjnIbc=
X-Received: by 2002:a17:902:d482:b029:127:37f7:e8ad with SMTP id
 c2-20020a170902d482b029012737f7e8admr1289643plg.49.1624369296945; Tue, 22 Jun
 2021 06:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com> <20210621225100.21005-6-ryazanov.s.a@gmail.com>
In-Reply-To: <20210621225100.21005-6-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 15:50:29 +0200
Message-ID: <CAMZdPi8-26+qzwYFV5AErbTbFZ78ArF_omCOq450+WuV5Rx81g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 05/10] wwan: core: remove all netdevs on ops unregistering
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 at 00:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> We use the ops owner module hold to protect against ops memory
> disappearing. But this approach does not protect us from a driver that
> unregisters ops but forgets to remove netdev(s) that were created using
> this ops. In such case, we are left with netdev(s), which can not be
> removed since ops is gone. Moreover, batch netdevs removing on
> deinitialization is a desireable option for WWAN drivers as it is a
> quite common task.
>
> Implement deletion of all created links on WWAN netdev ops unregistering
> in the same way that RTNL removes all links on RTNL ops unregistering.
> Simply remove all child netdevs of a device whose WWAN netdev ops is
> unregistering. This way we protecting the kernel from buggy drivers and
> make it easier to write a driver deinitialization code.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
