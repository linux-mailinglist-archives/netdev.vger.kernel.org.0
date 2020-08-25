Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3F251218
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 08:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgHYGg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 02:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgHYGg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 02:36:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4642AC061574;
        Mon, 24 Aug 2020 23:36:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u128so6531847pfb.6;
        Mon, 24 Aug 2020 23:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1imp3+Ksc7RuV6xFYmD+POgYzK3oIgsJy+XwlfX1vWM=;
        b=QRP1hK7ZSNCvr8yONsKOqaVMMy8SLMGDLSJQZXMqISsQCowT1avtYcJD8nLL2z3JSM
         9u4RKw/319OGcfitYg6vzWzQ3JXOBHIGRsaFNolssKdsW7oLt0n5ZYD46k7TymZr9sle
         GjgXAIeBRQBIZ/AxJ8Hc8ySzGtFy+iij5FYEiZLMekfCrCd93MSHFtkc5j6qOg7L3OrG
         Yghok62XGvH/RLvemGcu9a5bdODx7jPKdkVrY2FKl9a/Xm/G6g8Shy1/oqxd1BAtFSjY
         3EWzopiTvWNiRRO/GQadTmErSPObfGfFqzxNSbJRKMtuKdp9qHFV+Pzee5lF90BLO+fY
         6xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1imp3+Ksc7RuV6xFYmD+POgYzK3oIgsJy+XwlfX1vWM=;
        b=EMbZl4Bpr/OE/EpvRGabhHR/A6uAiwEv36CF2E/OfpBOEQ/ZtRsVfwYvv9vUvD5Q5e
         tvVsYpf5KTExIJKr7N4NFsmB7TocO5+9pKo08aGhJFzJ+9gXAo6AX+JzF49SlMQXRXuz
         WykDAjLHbJM2/505/N9SlL6c96IhkCOXOF7ZZQ35UXbTq2qnEEPzlm0TpHub7iG/+A3S
         BPdtNG8xRtcz6VPpkws7ctRJff24HW59Jkud53rO9OFvNXU1Ol4mxcsqY7K3MxeFz6k2
         bIhQg3mB+p/exp/3Bsc11clew3l9p4GV+nfme3TykHr2E//e0NOD/bPcdoB0BX5fcPEV
         WH4A==
X-Gm-Message-State: AOAM530l8pYNjQ/Zm3nOVceeLwbTG6NzNczHfDfdcIN4TgKScp3MZP5K
        XcECw7XZOduTfq+oyKg4Ajg=
X-Google-Smtp-Source: ABdhPJxbg4sF0Lr6g1Mh0p09gnomcuIy8SBHXncnjZPUMeo6cn4NDTun5tIVj0oYys9mXexnhUzcyg==
X-Received: by 2002:a62:c541:: with SMTP id j62mr6898091pfg.257.1598337386778;
        Mon, 24 Aug 2020 23:36:26 -0700 (PDT)
Received: from ideapad ([157.32.253.94])
        by smtp.gmail.com with ESMTPSA id 131sm1628345pfw.167.2020.08.24.23.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 23:36:26 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:06:20 +0530
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_cmd()
Message-ID: <20200825063620.GA17052@ideapad>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <20200824111655.20a3193e@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824111655.20a3193e@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 11:16:55AM -0700, Jakub Kicinski wrote:
> On Sun, 23 Aug 2020 13:50:42 +0530 Himadri Pandya wrote:
> > Initialize the buffer before passing it to usb_read_cmd() function(s) to
> > fix the uninit-was-stored issue in asix_read_cmd().
> > 
> > Fixes: KMSAN: kernel-infoleak in raw_ioctl
> 
> Regardless of the ongoing discussion - could you please make this line
> a correct Fixes tag?
> 
> Right now integration scripts are complaining that it doesn't contain a
> valid git hash.
> 
> > Reported by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> > 
> 
> This empty line is unnecessary.
> 
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>

Thank you. I'll fix it.

Himadri
