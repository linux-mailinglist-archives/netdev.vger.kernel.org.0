Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEF53FB3AF
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 12:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbhH3KOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 06:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbhH3KOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 06:14:44 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22695C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 03:13:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d26so21720020wrc.0
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 03:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h2pRaNFC4Ln7JRtVnXR05CSIsXjPmGy1aZzjMoaVAi4=;
        b=k4hYt0IFVU62UmVUArmz9a075YFs0goVEwUcipx4NDSSGYnL9yKaBLxKwnY/S/xzID
         VTDyoJKjrdpWiBpMB6KZYJpNSVUmlo9eNX49T0DUL0eFDN9F7znC5lTelRILQNZh+BL+
         6/aB04xs1oJAn+vry29t+m6rBBx+35mKa4olKB8p9SdcQfAxeZGaAFyaSY0m8mnA+y7c
         yVEUd6xjT/CA+j5HwO9x0xnaE62KGHwwANC63Jgxxdn1q76gReYckUE1UWSu/4kBCHhH
         cltONOdkO+z3Qrak7ODkS45lJ0YET6UqYAflG0MMmvSfUYZUfng80LeF1W0tmyJ9hDdV
         NLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h2pRaNFC4Ln7JRtVnXR05CSIsXjPmGy1aZzjMoaVAi4=;
        b=hBdgV8B6iuUO6dFzI0A6L8xC+adVI/lm4hteQsxT5mVgfybbWi+4J+LqRvFps3KULm
         E1l4US3mvpHhGKkg+XS0KpOVCx8778pYond3H+xTgWq9wcwNiHmyn3rS8rbxs6l6YPmS
         d+lIhRlGTN1yEROEaBp1EuLwaztEww6atMxmfoRRi3nEpypwcN33jFrSjoAIWsx/dZGb
         Lg0SnqQWLJAR6RVj5MOXyWw0+2750kFlkr6h5/7eUiClDpKbRrTMdLzlgnpk5uMiMAct
         nxt82xLGs2/CmH8wSMrDBlmVqc9x/iWpdLSisFNe2d9J5+r+GsQNqA61qEdesf8wvvRn
         7mqw==
X-Gm-Message-State: AOAM533xbT/sDYQrkFkWf2bbOYRpENOQt1pBERtXzxsfIfSGH0LFfj4w
        2kedsq3I/KuA4027FXC7bTU=
X-Google-Smtp-Source: ABdhPJwIXVOCAOyrhz1PUSPc5Byt/FPl8LkR6hLqPeZZL4Yx+EI6AkMgDl7peJAKPJ1EP8tNvrqsKg==
X-Received: by 2002:a5d:4647:: with SMTP id j7mr25321417wrs.149.1630318429595;
        Mon, 30 Aug 2021 03:13:49 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id f7sm18961524wmh.20.2021.08.30.03.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 03:13:49 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:13:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
Message-ID: <20210830101348.r4775xsymbhzcl7m@skbuf>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <20210830090003.h4hxnb5icwynh7wk@skbuf>
 <20210830091813.GA24951@noodle>
 <20210830092128.he5itvsbysvbaa5u@skbuf>
 <20210830094240.GB24951@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830094240.GB24951@noodle>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 12:42:40PM +0300, Boris Sukholitko wrote:
> On Mon, Aug 30, 2021 at 12:21:28PM +0300, Vladimir Oltean wrote:
> > On Mon, Aug 30, 2021 at 12:18:13PM +0300, Boris Sukholitko wrote:
> > > Hi Vladimir,
> > >
> > > On Mon, Aug 30, 2021 at 12:00:03PM +0300, Vladimir Oltean wrote:
> > > [snip]
> > > >
> > > > It is very good that you've followed up this discussion with a patch:
> > > > https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/
> > > >
> > > > I don't seem to see, however, in that discussion, what was the reasoning
> > > > that led to the introduction of a new TCA_FLOWER_KEY_ORIG_ETH_TYPE as
> > > > opposed to using TCA_FLOWER_KEY_ETH_TYPE?
> > >
> > > While trying to implement the plan from:
> > >
> > > https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/#24263965
> > >
> > > I've came upon the conclusion that it is better to make new orig_ethtype key
> > > rather than reusing TCA_FLOWER_KEY_ETH_TYPE name. The changes I've
> > > proposed there seem of a dubious value now. IMHO, of course :)
> > >
> > > >
> > > > Can you explain in English what is the objective meaning of
> > > > TCA_FLOWER_KEY_ORIG_ETH_TYPE, other than "what I need to solve my problem"?
> > >
> > > The orig part in the name means that the match is done on the original
> > > protocol field of the packet, before dissector manipulation.
> > >
> > > > Maybe an entry in the man page section in your iproute2 patch?
> > >
> > > Yes, sure, good catch! I'll send V2 of the iproute2 patch shortly.
> > >
> > > >
> > > > How will the VLAN case be dealt with? What is the current status quo on
> > > > vlan_ethtype, will a tc-flower key of "vlan_ethtype $((ETH_P_PPP_SES))"
> > > > match a VLAN-tagged PPP session packet or not, will the flow dissector
> > > > still drill deep inside the packet? I guess this is the reason why you
> > > > introduced another variant of the ETH_TYPE netlink attribute, to be
> > > > symmetric with what could be done for VLAN? But I don't see VLAN changes?
> > >
> > > For VLAN, I intend to add [c]vlan_orig_ethtype keys. I intend to send those
> > > (to-be-written :)) patches separately.
> >
> > Wait a minute, don't hurry! We haven't even discussed offloading.
> > So if I am writing a driver which offloads tc-flower, do I match on
> > ETH_TYPE or on ORIG_ETH_TYPE? To me, the EtherType is, well, the EtherType...
>
> AFAIK, the offloads are using basic.n_proto key now. This means matching
> on the innermost protocol (i.e. after stripping various tunnels, vlan
> etc.). Notice, how the offload driver has no access to the original
> 'protocol' setting.
>
> ORIG_ETH_TYPE if given, asks to match on the original protocol as it
> appears in the unmodified packet. This gives the offload driver writers
> ability to match on it if the need arises.

That is correct. The fact that drivers offload EtherType matching based
on basic.n_proto seems wrong in the sense that it does not line up with
what the software dissector does, even though it is the best that the
API offers them, and most probably matches the intention.

And in the case of vlan_ethtype and cvlan_ethtype, I see that these are
passed along to the offloading driver through the same basic.n_proto,
which is... interesting?

But nonetheless, can you please make a compelling argument for introducing
a new set of ORIG netlink attributes instead of using the ones that exist?
Even if you don't implement the ORIG netlink attributes for VLAN, which
is fine if you don't need them, it would be good if you could document
your thought process, walk the reader through the solution as far as you've
explored it even if only mentally. Rewrite the commit message is what
I'm saying. You might stop responding to emails one day, and the changes
need to speak for themselves. My main complaint is that too little is
said, too much is being implied. This is not only you btw, but you
should not add to that situation.
