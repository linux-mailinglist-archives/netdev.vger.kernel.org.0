Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E92A4732BB
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 18:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbhLMRLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 12:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhLMRLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 12:11:44 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79AAC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 09:11:43 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id m24so11609685pls.10
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 09:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KOtAHfGzoHHo3bSS2PdTzeHj5JcFxh/qLlgSQQNeuAE=;
        b=LHBMZgzM2Uyg07lM1j1GVcgRewOLXany0OvEQl3IN7Ow/XAikx/rCZHByaja09sEP6
         uxtQGsmwtTUKjXYy/5zLyVP3wJgEH4mKdvKanUa1pKzJDJA9C+/48dNMdEBgxzemaMhL
         oCN+hcmSKip7hP45qImWnBSFwbLFvZ4j3QsUfYTjoO5dH/V5COs3b/I3Mp0YSHRATJLT
         20B/Ev3t8dz0LJ/0GRj29kR0kV3VQChbF62w5fPY3bpbYZJJwNXLrhpyLm1SgpuxXXn8
         VRrNu5lwZS4WuZz4qssU4WvmQm5drT/4JYZfYAaSWuNbu+IXUqlawpxa67FjnuO0hTTY
         5vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KOtAHfGzoHHo3bSS2PdTzeHj5JcFxh/qLlgSQQNeuAE=;
        b=lr2MOWFoVBNHkMn5Ui63cCnuFfVQXXkIepRPuOwVJhPWQrctNZyfkEn1mLb1pIt5vL
         T+Sjx3pzBl8ATU9oGbwA4BAE7c0hONZsQixFOYHPRiCLHLym4ERgfvaDM7yA28RHJZWQ
         ZyqCfNC0d+SskphyG/iJerxgCU2HfVVpE8zRaec/O2AAjnHhcuB6InT3V4TytpvbK8Cs
         oCoSh4vtAe3ilh4vq+FTcWmwZ7wS3gw0Ug2FKizemrYhOM+Si/8RhY6Lj2s3//TMuPlC
         /eQvJ8hElWbErC7pbjfRf79q7FOfSNNVehLHaY2eKWqkZtb2ZddzunB6Y+gI7fXLqKsL
         CbBQ==
X-Gm-Message-State: AOAM533CEBXcu9DVSnZy0yfeErbkZneGiE+DREwqdmlQdyI5JyL86r96
        bejDS1yjlj+6hybqmlmBK4c=
X-Google-Smtp-Source: ABdhPJwOQSQVDmZGtvDxiVXYsV4nI8zJYR4K/x2b104oHzSbD33yzW/MZgVV2YZ1JV7gkbhNszgrwA==
X-Received: by 2002:a17:90a:3e09:: with SMTP id j9mr45554499pjc.24.1639415503453;
        Mon, 13 Dec 2021 09:11:43 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id pf15sm7865006pjb.40.2021.12.13.09.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 09:11:42 -0800 (PST)
Date:   Mon, 13 Dec 2021 09:11:40 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211213171140.GB14706@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
 <20211213121045.GA14042@hoboy.vegasvil.org>
 <20211213123147.2lc63aok6l5kg643@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213123147.2lc63aok6l5kg643@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 02:31:47PM +0200, Vladimir Oltean wrote:

> With other drivers, all packets injected from the CPU port act as if in
> "god mode", bypassing any STP state. It then becomes the responsibility
> of the software to not send packets on a port that is blocking,
> except for packets for control protocols. Would you agree that ptp4l
> should consider monitoring whether its ports are under a bridge, and
> what STP state that bridge port is in?

Perhaps.  linuxptp TC mode will forward frames out all configured
interfaces.  If the bridge can't drop the PTP frames automatically,
then this could cause loops.

So if switch HW in general won't drop them, then, yes, the TC user
space stack will need to follow the STP state.

> I think this isn't even specific
> to DSA, the same thing would happen with software bridging:

(Linux doesn't support even SW time stamping on SW bridges, so you
can't have a TC running in this case.)

Thanks,
Richard
