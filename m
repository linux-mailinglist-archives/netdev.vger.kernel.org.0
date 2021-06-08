Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2FA39ED74
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFHEZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhFHEZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:25:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43D7C061574
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 21:23:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v13so9925222ple.9
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 21:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=23xXcExaBA0F4qdO0hM21zJQMO2ogSgobhGUIkD3kD0=;
        b=TNIVaDTU/IuKv8+Z+eWo5LpWT144NW0a5lKecxwhF6qePF/88g0imzqmaIW8WdkeKI
         gRVsQXxuBk7TODW0SFH4MHJSJLdbda4mOiHD+HU5ALr2GSSZ5mdIBHqnBSJWYDBVmn0L
         mXgDyGSgy/7aRFpfVG74uFgkuVTFJayy0UiEiBHXMOw1hwjC3vXUW6GKt3D1mIj/Dwf2
         JA/EYsFdgRzdUEGHRzHzW59Ji/ToLfQlmTN1blsDg1eJjCUKN0Vo5N6ufwJ6WaFradY8
         H7aJEuXEv/d1up7v65vBW/D92KsU7iodFWtHFcpwZLooovIQnAUt9EPOKP7w/+FQLDu/
         hl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=23xXcExaBA0F4qdO0hM21zJQMO2ogSgobhGUIkD3kD0=;
        b=MS3wK511MRfowTJn2c2q+5we/zCskEBCVqXXvDrkwZUpqJaNmYEZxzF8kTGRDMA8Zs
         vKfZCVgJ6twX4brjOeF5wSbQGufXECgmU62qBVUOZsuqVx7NNLDqkmtTSsCedTc07m3B
         SkCFnl6aF4RUGghjm8XGGlGxrNmf6P7lBA0UlR27lnp288qFsv+rxVq0bBcda3l+bghX
         RkcEbRoqvvOuNe4MihrxjtBzn8ibtAUhTc3gOATUg6OjaT1vAqJQFyS3ilHBMrz8Z2hD
         YQcumG2xSAGMRByXc7T20jCXTRFYxkFXr4F0ToBPPN8yFmiVgdQnkjR27hZQ83VOqHqy
         WCHA==
X-Gm-Message-State: AOAM532cClXtBIf2JGSOkrdilIFa7HT5NHV3dYUsQZq9B4JF8wKmTUAd
        za6SkWj07cR/rS0RAg/l2kC3dL7JuIrR0MVxQso=
X-Google-Smtp-Source: ABdhPJw2ohWaVbWFSXmWVtO2aUj0XMMP048S0LThlZUT+8QCP6qXbBttraQ8lR+ZwNsX/rqTZoZ52kW8Zh1cHUv7zKA=
X-Received: by 2002:a17:902:b288:b029:111:4a4f:9917 with SMTP id
 u8-20020a170902b288b02901114a4f9917mr12241576plr.70.1623126182341; Mon, 07
 Jun 2021 21:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAM6ytZoLkndXUaBxDDk36y_QW3JfNwtksQm3XAdUk+GLr28rEw@mail.gmail.com>
In-Reply-To: <CAM6ytZoLkndXUaBxDDk36y_QW3JfNwtksQm3XAdUk+GLr28rEw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 7 Jun 2021 21:22:51 -0700
Message-ID: <CAM_iQpUpQ_b5UbKRA+crSmhYeDN8PFE-KaBOp9je-zOkhg=3Kg@mail.gmail.com>
Subject: Re: CAP_NET_ADMIN check in tc_ctl_action() makes it not allowed for
 user ns root
To:     tianyu zhou <tyjoe.linux@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 1, 2021 at 1:17 AM tianyu zhou <tyjoe.linux@gmail.com> wrote:
>
> Hi, from commit "net: Allow tc changes in user
> namespaces"(SHA:4e8bbb819d1594a01f91b1de83321f68d3e6e245) I learned
> that "root in a user namespace may set tc rules inside that
> namespace".
>
> I do see the CAP_NET_ADMIN check in tc_* functions has changed from
> capable() to ns_capable() (which is now in term of
> netlink_ns_capable())
>
> However, in function tc_ctl_action(), the check for CAP_NET_ADMIN is
> still netlink_capable which does not allow user ns root to pass this
> check.
>
> static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
>              struct netlink_ext_ack *extack)
> {
>     ...
>     if ((n->nlmsg_type != RTM_GETACTION) &&
>         !netlink_capable(skb, CAP_NET_ADMIN))
>         return -EPERM;
>     ...
> }
>
> So is this a check missing changing for user ns?

It seems so, I do not see TC action is any different with other
TC objects here. So feel free to send a patch.

Thanks.
