Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526B83FB30F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhH3JW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbhH3JWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:22:24 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55142C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:21:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q14so21434905wrp.3
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k5xSVWlcX0fz/M/m+pP95YJaeHSg1k4Ol76eZiXwi2Q=;
        b=E6AX0z+PnCul1OXE/dEKPXo3tDaf+rT1grAA64qnSB7d6BYjkGWZx3W1xH4dyFx3Mn
         CmV3EZJA0gZmmCEdZjObKtfgx3B3PgdD8R3qVdusta6jcW478mawPyDmP9bu3ihEUHzR
         nap9KgXIsnEedDNvsXkW9wHXZ0mdTFGYH/bTGXJV6ZK9sTSw+gQTy2dClrvdf7Pu88gt
         BY6ughBiP4JE7Jyq1YME4cjyMDHXDOdQdgST7UzamrtSw4ZE+ep62Ld8QrdSZ5hpQUaP
         gSBuHJwD0Ts+zlHHITe0v+DkQ+W5PC3KA9RTtO4MGuKtVf84Rii0w5qr+ZQel94wCAUr
         yaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k5xSVWlcX0fz/M/m+pP95YJaeHSg1k4Ol76eZiXwi2Q=;
        b=tMlymeqVzKS3EvlgslwIAUjhYME6dckR2X+D8z//AfQ96S7oZNbEyMOFbdpKY1JFOp
         AHL8u+MnwcyobvTmfMHDlzkdi6LM7kv8CUzxYaGeUGrBFAkGOu9uiujsCpmV/HcRpwx7
         RdaE+cSZ+DmvxRscC2fK8lE2ySDCQwFoCkf24CtBOBFdE84GkYrqfsK5UkUJn28YcEFG
         VdnCAB4XrxkhW6NxiMLquVoSHOBDAzlbAGXYfdlCqsCrTIsMDUF5uylji2sLxGK1M+MC
         XIswuKcAqzwtwJRlUsr/sgvTCBUhjEeLeT8/Mm8UqDKuF76mCYg00MqYw8kQES0JQ/FV
         v+Dg==
X-Gm-Message-State: AOAM533wffClbrHqcoERcwDIGBnCzAOmSzWHOE61qrGMjImEf+1IG2x/
        w09RBNlZ/c+W2r1kdZE3EVY=
X-Google-Smtp-Source: ABdhPJwFVNGWpNfO+f1ud1z4JszMeS14th86VtXLDmfRhemGdZKX8/JeONXC6NvLPbgBaW/qn5mtIA==
X-Received: by 2002:adf:e745:: with SMTP id c5mr23979065wrn.321.1630315289858;
        Mon, 30 Aug 2021 02:21:29 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id 138sm9550110wmb.7.2021.08.30.02.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 02:21:29 -0700 (PDT)
Date:   Mon, 30 Aug 2021 12:21:28 +0300
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
Message-ID: <20210830092128.he5itvsbysvbaa5u@skbuf>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <20210830090003.h4hxnb5icwynh7wk@skbuf>
 <20210830091813.GA24951@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830091813.GA24951@noodle>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 12:18:13PM +0300, Boris Sukholitko wrote:
> Hi Vladimir,
>
> On Mon, Aug 30, 2021 at 12:00:03PM +0300, Vladimir Oltean wrote:
> [snip]
> >
> > It is very good that you've followed up this discussion with a patch:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/
> >
> > I don't seem to see, however, in that discussion, what was the reasoning
> > that led to the introduction of a new TCA_FLOWER_KEY_ORIG_ETH_TYPE as
> > opposed to using TCA_FLOWER_KEY_ETH_TYPE?
>
> While trying to implement the plan from:
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/#24263965
>
> I've came upon the conclusion that it is better to make new orig_ethtype key
> rather than reusing TCA_FLOWER_KEY_ETH_TYPE name. The changes I've
> proposed there seem of a dubious value now. IMHO, of course :)
>
> >
> > Can you explain in English what is the objective meaning of
> > TCA_FLOWER_KEY_ORIG_ETH_TYPE, other than "what I need to solve my problem"?
>
> The orig part in the name means that the match is done on the original
> protocol field of the packet, before dissector manipulation.
>
> > Maybe an entry in the man page section in your iproute2 patch?
>
> Yes, sure, good catch! I'll send V2 of the iproute2 patch shortly.
>
> >
> > How will the VLAN case be dealt with? What is the current status quo on
> > vlan_ethtype, will a tc-flower key of "vlan_ethtype $((ETH_P_PPP_SES))"
> > match a VLAN-tagged PPP session packet or not, will the flow dissector
> > still drill deep inside the packet? I guess this is the reason why you
> > introduced another variant of the ETH_TYPE netlink attribute, to be
> > symmetric with what could be done for VLAN? But I don't see VLAN changes?
>
> For VLAN, I intend to add [c]vlan_orig_ethtype keys. I intend to send those
> (to-be-written :)) patches separately.

Wait a minute, don't hurry! We haven't even discussed offloading.
So if I am writing a driver which offloads tc-flower, do I match on
ETH_TYPE or on ORIG_ETH_TYPE? To me, the EtherType is, well, the EtherType...
