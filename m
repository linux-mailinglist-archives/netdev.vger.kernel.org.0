Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D223A4B32BA
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiBLCiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:38:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLCiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:38:54 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F6A2DAB8
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:38:52 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e140so10907370ybh.9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bn50Emyh6hgqfELDmONqxQjp7OSvqhW8Cz4X00opirE=;
        b=Rxeigm5Iw9ZvqvN7ZoGKEoBzx8xmJQCBvNt4g/zxxgnOIWmeFend4H7qAILRgoNioi
         nST9FmYR1woNxltVw5qi0Ez3wlKkZmyG2SNs8N+XyTl2lzSFtFhlX2mRE0Er5l6YWGX9
         eptUELrSPHZ59DIf+kCHqdWRpQgXEbCBYvmgixtbr4E0wL0zFt8FeVKpQpmwegitqinO
         WQrVJe8I4Tkvx5W8B1BJI6IMz6jvujIOCKL2UETP5x98YODHPPD9XQyawID9S630TqYo
         w52KCwP+fMQ2fnyvBrjYPtOOqEgyF5//w8Khsmo3ZqjnUiuZtq6WWXo+84AZbii+IW2J
         xPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bn50Emyh6hgqfELDmONqxQjp7OSvqhW8Cz4X00opirE=;
        b=ug2wphrNVXoTss7An5QXpNkvChWRwwBBJvdzlHl13QaZnP/1vkpO9TMUbaLmpW5vMD
         LF6ahLHr4vc5SRwkakA6cW/ORQkipEsD+barO82Q0xnnVykhM+SEISe4t9eHPe6mMa/L
         U3dVOvfSGPbiMYJNaI76VDxr5Sqryk183myh+qRrkXhyfg84uQThMNsBLBy9etgHKRgo
         HmSbQ3XaeF+dHrDALNJ/TzSZNWfI4eUmU16JN36lt8xx0lBilfrEsb+lCmKr4/LkEuWC
         PPcPhlxwSqp1QOQt/PICDY7szuEH1DIDvnsX1o8YwSOO1wgy0N9q/ez5XdmLk2X4Bscw
         pdPw==
X-Gm-Message-State: AOAM531mcqPjlTRjr8BJeAv3jzrMSsakmhkPFMXglIl/DOcMU+GaJ4UZ
        GH/IPJZzKYYtregLAiHKtqwJ5edE8abLGddXurpsEA==
X-Google-Smtp-Source: ABdhPJy8ApNF4IPTduk2+78CqK5tky3/OMekmPDmrK4G5jbFpQYAbnbgNo4DKo77MqIGPuqV4xSPcmg9eMUncccTnR4=
X-Received: by 2002:a81:e345:: with SMTP id w5mr4857707ywl.32.1644633530810;
 Fri, 11 Feb 2022 18:38:50 -0800 (PST)
MIME-Version: 1.0
References: <20220210214231.2420942-1-eric.dumazet@gmail.com> <20220211155739.66f5483b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211155739.66f5483b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Feb 2022 18:38:39 -0800
Message-ID: <CANn89iK+0E2n5r6TWOt32RBey=nJ6f75+SFAvRqskjGfSHT4hA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] ipv6: remove addrconf reliance on loopback
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 3:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 13:42:27 -0800 Eric Dumazet wrote:
> > Second patch in this series removes IPv6 requirement about the netns
> > loopback device being the last device being dismantled.
>
> Great!
>
> > This was needed because rt6_uncached_list_flush_dev()
> > and ip6_dst_ifdown() had to switch dst dev to a known
> > device (loopback).
> >
> > Instead of loopback, we can use the (hidden) blackhole_netdev
> > which is also always there.
> >
> > This will allow future simplfications of netdev_run_to()
>
> Should I take a stab at it, or is it on your todo list, anyway?

I have not started this yet, I will be happy to review your patches, thanks !
