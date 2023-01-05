Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9619465F0EA
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbjAEQN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjAEQNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:13:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E13B13EB2;
        Thu,  5 Jan 2023 08:13:52 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so2487837pjq.1;
        Thu, 05 Jan 2023 08:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3vxI9T+PDnmm1nPMoy2tO7dGP57NBsFXAmMZ66nzy9g=;
        b=WG2daSnTBfZYlJlTXuaEpcn0Dk5uXTi4g6L6xeMNxasW5LeazzGXEqhPWF+dP0s8wY
         aiEXyI/ny+dwZz7/TNZCSyZrsjmkuzUgAxk2HSChZKJ/LO1bH5CojXXS+Ok7XkzVxGTT
         PitO7mwGkHOmUeFtNKlg4wx3yaEtHSMUjlPrsosaTmAnbF+hv9VGdm2b15XHvqtV3zyC
         I6OMNvL9ccOblwH8QmT2WDzLCnW0Ao6YAS/CTw+hvStoZt3qybMaq4MG5axJQv+Z7OlJ
         kbdH6X5quZBiwVPuw2bPnugsS7AntzGIoU7DShIGnPWmerakahckYTUo0VCqSTko8T9d
         vQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3vxI9T+PDnmm1nPMoy2tO7dGP57NBsFXAmMZ66nzy9g=;
        b=cX3ofjD8yxYJyHM+To6cWSdc6C+GAeqFIEwInOB4KSxFG/1krpGijgiseI4kuqehcB
         8Z+gpZVXJLMpp6PGAlA9TSzNV8vZjPtUx/A36WeryBngR0Wa9msuKWEpx8wMU9oRQzLl
         hjT+E2nwKw+J3WJ7fK4n8tlT2fQlvS8Td5sOYpiFlyUMXpijPzATh4IMsdvL9iB+T8jq
         v16tl4f4uQVNsAoinSNPPw4R2BE9yFv5bVaR77FqsYxEov9qafbzn7OL4+0+Vxh4vIwG
         id+dWYkG1gS4ilQSpKyEXDB21DGzdTZNHA8naeJA4N882lvvZK62F4NIx74Xi9Lqh7L1
         guSw==
X-Gm-Message-State: AFqh2kp7gf2VmLnu3+V9XBHxGYryezF7gRQb3/qlCPidTBA45fPNPfAZ
        qJABljhNst1ke5PfzM156xK8EtsCi88CU9lh7Hk=
X-Google-Smtp-Source: AMrXdXsifKsfF7AO/EubJqjd7w6eaZifiG0bVWJGZp4mjcdNPqXDvFVI32RwKmbLq1eSYdNyiUECtrTZ0DEcSKb+TV0=
X-Received: by 2002:a17:902:728d:b0:190:c917:ab61 with SMTP id
 d13-20020a170902728d00b00190c917ab61mr3270623pll.93.1672935231982; Thu, 05
 Jan 2023 08:13:51 -0800 (PST)
MIME-Version: 1.0
References: <20230102150209.985419-1-lukma@denx.de> <Y7M+mWMU+DJPYubp@lunn.ch>
 <20230103100251.08a5db46@wsk> <20230105113712.2bf0d37b@wsk>
In-Reply-To: <20230105113712.2bf0d37b@wsk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 5 Jan 2023 08:13:40 -0800
Message-ID: <CAKgT0UfjtKL0_OxKpEt4CzA4MztXckkVxMZkQ85B11bYomfOOw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dsa: marvell: Provide per device information about
 max frame size
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 2:37 AM Lukasz Majewski <lukma@denx.de> wrote:
>
> Hi Andrew, Alexander,
>
> > Hi Andrew,
> >
> > > > @@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > > > dsa_switch *ds, int port) if
> > > > (chip->info->ops->port_set_jumbo_size) return 10240 -
> > > > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; else if
> > > > (chip->info->ops->set_max_frame_size)
> > > > -         return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > > ETH_FCS_LEN;
> > > > +         return (max_t(int, chip->info->max_frame_size,
> > > > 1632)
> > > > +                 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > > ETH_FCS_LEN); +
> > > >   return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > > >
> > >
> > > I would also prefer if all this if/else logic is removed, and the
> > > code simply returned chip->info->max_frame_size - VLAN_ETH_HLEN -
> > > EDSA_HLEN - ETH_FCS_LEN;
> > >
> >
> > So then the mv88e6xxx_get_max_mtu shall look like:
> >
> > WARN_ON_ONCE(!chip->info->max_frame_size)
> >
> > if (chip->info->ops->port_set_jumbo_size)
> > ...
> > else
> >     return chip->info->max_frame_size - VLAN_ETH_HLEN -
> >       EDSA_HLEN - ETH_FCS_LEN;
> >
> >
> > Or shall I put WARN_ON_ONCE to the mv88e6xxx_probe() function?
> >
> >
> > The above approach is contrary to one proposed by Alexander, who
> > wanted to improve the defensive approach in this driver (to avoid
> > situation where the max_frame_size callback is not defined and
> > max_frame_size member of *_info struct is not added by developer).
> >
> > Which approach is the recommended one for this driver?
>
> Is there any decision regarding the preferred approach to rewrite this
> code?

I would defer to what Andrew proposed since he has more experience
with the DSA code than I do.

Thanks,

- Alex
