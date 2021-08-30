Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07073FB2DC
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhH3JFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhH3JFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:05:18 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96504C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:04:24 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g138so8273675wmg.4
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TZpIWlCMgPekk04pgZybV6SMuOfIVXtY+flM1+wtRQI=;
        b=njC3Qu7uUiW0l0Y4RTncccarF0ZzZ97Htfx3acSqs3IwJdUKo/1W1fwaYyMjSFGMAc
         mwnBuvPPCukswUWmiSRTgGVdPzPi90Nh/elm2dyyYwnix3vC6m0j4g1QOUbPnoPe1pl3
         HbuI5Ua4A7YaflQlNtM2t0GIc/oT82sMFdRt4Q5PePzvt/K664aHooNaV+Xv+E3J8uON
         gi/AvE8rre166gfGE12f4x10ocokAsBzsQTWsj4I9akfNM4pPHEuuvRMm+h3PtuWXjAy
         Wtyk5rr0FEFyp6UIsQQY5PJB93XLeB597EG0+syb5VuGfzM155sC4TeTymSNhZC1vFn6
         rnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TZpIWlCMgPekk04pgZybV6SMuOfIVXtY+flM1+wtRQI=;
        b=MsDS2G4quzGmUzvjaean2ATbSnsOr/6B8vV0+SqQDKK/ZJgSE2KqqnzhuznMZ6nvmS
         FiH1SBxmhd+HgFXGAnEMV6+CZPA1kBaDgb4WFlTFWGAAOcyVmshd23qp9FVMX4YY1C++
         G5CTkzo4sMDbPgm8pDDqVHbIWj4IlfrTx8ClDtvXIoW2uX1a3VCepopY/JZCAnVzJbcV
         QpP4qSh5R3qTkrtu9QMSr4au8hmAs9LFO3EzAxZ61u3AB/dZOAaANff8rQJ5Y+i2qUTl
         Zf3HebGzJxwb0o93iUK0FrlqHIUbYW/NdU33bvFKh2QTXvJIQdc2SWF97AVGDBcemIry
         szzg==
X-Gm-Message-State: AOAM5305OMS4AtXzlTYvlDjx0y0U5cbMpKc2Yu8Qgfsi3gzO91UIL169
        XiuEmsCTF3Kgb00IVUp9ol0=
X-Google-Smtp-Source: ABdhPJzQjGu08swZ3qnEqMMZHuj/4k75Ao+IgwxNQ18IpRZoPfMhJHR7AuX6vZ1IxnL5B/ts0PpcQQ==
X-Received: by 2002:a7b:ce87:: with SMTP id q7mr9986183wmj.126.1630314263208;
        Mon, 30 Aug 2021 02:04:23 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id d124sm13053750wmd.2.2021.08.30.02.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 02:04:22 -0700 (PDT)
Date:   Mon, 30 Aug 2021 12:04:21 +0300
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
Message-ID: <20210830090421.ju5zz7iuxqbgqhob@skbuf>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <20210830090003.h4hxnb5icwynh7wk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830090003.h4hxnb5icwynh7wk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 12:00:03PM +0300, Vladimir Oltean wrote:
> I don't seem to see, however, in that discussion, what was the reasoning
> that led to the introduction of a new TCA_FLOWER_KEY_ORIG_ETH_TYPE as
> opposed to using TCA_FLOWER_KEY_ORIG_ETH_TYPE?

Typo, of course, I meant "as opposed to TCA_FLOWER_KEY_ETH_TYPE".
