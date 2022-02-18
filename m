Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966FA4BC21A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239957AbiBRVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:31:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239945AbiBRVbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:31:33 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500AB178958;
        Fri, 18 Feb 2022 13:31:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c6so14872960edk.12;
        Fri, 18 Feb 2022 13:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gOpAL1FPR1vBK++ssCUfqZ5qhe0h7v7ypcgYHRaBHRc=;
        b=ZgrfO5hIj6k3fB/NvjiGwGJVqeHzU32gasUKL3vtw8WIfPrr50EdaVOnd9gnp/N0j2
         YWS1WVywYtQFd45fzxxP9mZsMomcVx4I5pByUkcqJv85fbAXlXH6gDHahPyEveAVTyHl
         nzCfwtGgeeJwN9a6CA03aYzroH5Ij6N6Y/Bn6Ym/m9Whc77OCLxio9Gf42DUl9L/xp+k
         kcZn4JLsx1VibSqaWe63Bs3/abTFHBNsIzwBGkYem564HsRVvy3bCzajjRX50+9/MaJH
         8XmQaT5RRTNB5a4014NoyjA37AxCf8G+5WO7hrKX6p16skAJgf285VQrGNxJ2qVRwgwx
         ITqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gOpAL1FPR1vBK++ssCUfqZ5qhe0h7v7ypcgYHRaBHRc=;
        b=gKikQBzwmr6wlq1/3LrJwE9/UZel1keLwuc3ewSDJbi4qs51skvo2N8I0V1YAaRwcy
         8bUWwL78L5BJvdh18JeLqKq9OS727Ty/BUFKsTSyJjCskDQSsqAGLWlIY6uiQnKPwE1q
         jZYjoM33YCvAZfJpcq/Ren5vgNcvt61eaF8mEELD0hO/Dj4PNkYGhMSAffMdl+w7CnCf
         /1bWchmHRVbZ/iQ+zRvwbQxxqKRaNcqxW9+3UqXcOikB0JFteMSmyvkCe3yG/AY6opqM
         JB9bhItoqmkqcFC+rzubqgEFAWcc5rfFhPk9r9pvJASpKgXjoAavfb9ylabzyTIUGQNF
         448w==
X-Gm-Message-State: AOAM533PkbUEzbpnOaj14lf+st/x0FeWvlTboYIi3Qo+hfsamdBstw5v
        /jbwqZz4KSKX11ZMfrQXqJawKjPzv+twG7lbMYs=
X-Google-Smtp-Source: ABdhPJyEXRJiunNMtAWvzGM7nptyut6nLlOjCbUvLBhqrz99Fl/NERtWo9ZK9gILLbq4bQjDvKt6qPcV3lfBb5JRZmE=
X-Received: by 2002:a50:becc:0:b0:410:a35f:c5a7 with SMTP id
 e12-20020a50becc000000b00410a35fc5a7mr10360733edk.170.1645219874884; Fri, 18
 Feb 2022 13:31:14 -0800 (PST)
MIME-Version: 1.0
References: <20220207235714.1050160-1-jeffreyji@google.com> <20220207195139.77d860cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207195139.77d860cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
Date:   Fri, 18 Feb 2022 13:31:03 -0800
Message-ID: <CACB8nPmnJA7FYFZtRgF_RASOGZhCEFHcK3n0zbtT4OJ61gkrug@mail.gmail.com>
Subject: Re: [PATCH v7 net-next] net-core: add InDropOtherhost counter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, I'll remove the MIB counters & instead add counters to
rtnl_link_stats64 and rtnl_link_stats, does that sound right? But keep
the sbk_free_drop_reason


On Mon, Feb 7, 2022 at 7:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  7 Feb 2022 23:57:14 +0000 Jeffrey Ji wrote:
> > From: jeffreyji <jeffreyji@google.com>
> >
> > Increment InDropOtherhost counter when packet dropped due to incorrect dest
> > MAC addr.
> >
> > An example when this drop can occur is when manually crafting raw
> > packets that will be consumed by a user space application via a tap
> > device. For testing purposes local traffic was generated using trafgen
> > for the client and netcat to start a server
> >
> > example output from nstat:
> > \~# nstat -a | grep InMac
> > Ip6InDropOtherhost                  0                  0.0
> > IpExtInDropOtherhost                1                  0.0
> >
> > Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> > with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> > counter was incremented.
>
> As far as I can tell nobody objected to my suggestion of making this
> a netdev counter, so please switch to working on that. Thanks.
