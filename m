Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A94B23BF05
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgHDRrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 13:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgHDRrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 13:47:32 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797A1C06174A;
        Tue,  4 Aug 2020 10:47:32 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s16so29334557ljc.8;
        Tue, 04 Aug 2020 10:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BqSl7wUw+Tmy5AorEagl4sekRhDwxdT5n+KH7p5fts=;
        b=IC0B/Ex8cP8+r/xNTELDlSBrriR74xRxy8P6+iaDtJOYf9Gjpiiu/8M/J/Z+gLvZSr
         wYC4JBiqqR0hIaBY6qDX8XkKq6kYhQQy8Yvav01nphPXG3gEchse+sBl0f7j0RCTA3Q4
         xPIjnmb/xU8iqTmTeZSC8XfdZKYyGGWhrNye/c+S7o5Yz8qOUtvMmWjJHtyK0Ch0fUvV
         e+lLrBWhc79lnxEiVXUOwBShsQsCzhoVZDRHOFcIkesUEZbJlf9jVLRbyJKudQU+rzn9
         es6O+wSRj7+w3+puvyc0T5OOdE7svVJksG8TvdigstyzC00ka3vRCte/k9hveBXvT8ZG
         iU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BqSl7wUw+Tmy5AorEagl4sekRhDwxdT5n+KH7p5fts=;
        b=ir5apXq9i/+3WA+kNNfZLnPPCwGqosjwl53J83NMBBJgBbXoEKqqmWvoEPnlxHQun4
         UqPY6cO4YGRIT3g39zjIWzjasxdLRYSAPa6APhydcgJQoEjH2R8uvU1g0crm52PLIlhf
         musjvRo1bw4YJYSEajRr6uEaF2XAJ9mNRNlXQccWVNcMlM8CEqXIKhe8BUI8s1vKMiXG
         Zk2Ls5hIfnFbF0s8cAVzXQf7aN6yxHhEmWV0ol1hUAIYREatHu2Hb4Y+acaLGpzitn4T
         h4hjGYbEeRJ8Kld/G9yS59n8O7cRPmYkMyUMBl4MbInm+Cc4w6oa4MDsqKYlKTcFSUmK
         W4pw==
X-Gm-Message-State: AOAM530bQ0yYfjlJtvk7kOX0cmzafDXeYoQPxKJ+2MZVRCkdYJUkxWE6
        fwp8VEtCmfC+DLQmlGfTwM4cHXUFNujgKBerNkQ=
X-Google-Smtp-Source: ABdhPJw0f+LbDrjh5woZ+z04zyzC9atu63q41yW7Li5YJjbf3+UZap73Sh6iBMtroASADI29/KgJ18d/vgb57+akrls=
X-Received: by 2002:a2e:8816:: with SMTP id x22mr11562569ljh.304.1596563250791;
 Tue, 04 Aug 2020 10:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <1595792274-28580-1-git-send-email-ilial@codeaurora.org>
 <20200726194528.GC1661457@lunn.ch> <20200727.103233.2024296985848607297.davem@davemloft.net>
In-Reply-To: <20200727.103233.2024296985848607297.davem@davemloft.net>
From:   Ilia Lin <ilia.lin@gmail.com>
Date:   Tue, 4 Aug 2020 20:47:18 +0300
Message-ID: <CA+5LGR1KwePssqhCkZ6qT_W87fO2o1XPze53mJwjkTWtphiWrA@mail.gmail.com>
Subject: Re: [PATCH] net: dev: Add API to check net_dev readiness
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, ilial@codeaurora.org, kuba@kernel.org,
        jiri@mellanox.com, edumazet@google.com, ap420073@gmail.com,
        xiyou.wangcong@gmail.com, maximmi@mellanox.com,
        Ilia Lin <ilia.lin@kernel.org>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and David,

Thank you for your comments!

The client driver is still work in progress, but it can be seen here:
https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/drivers/platform/msm/ipa/ipa_api.c#n3842

For HW performance reasons, it has to be in subsys_initcall.

Here is the register_netdev call:
https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/drivers/platform/msm/ipa/ipa_v3/rmnet_ipa.c#n2497

And it is going to be in the subsys_initcall as well.

Thanks,
Ilia



On Mon, Jul 27, 2020 at 8:32 PM David Miller <davem@davemloft.net> wrote:
>
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sun, 26 Jul 2020 21:45:28 +0200
>
> > I also have to wonder why a network device driver is being probed the
> > subsys_initcall.
>
> This makes me wonder how this interface could even be useful.  The
> only way to fix the problem is to change when the device is probed,
> which would mean changing which initcall it uses.  So at run time,
> this information can't do much.
