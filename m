Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2188C2918BE
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgJRSCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 14:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJRSCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 14:02:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 080B72067C;
        Sun, 18 Oct 2020 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603044141;
        bh=feic7OW+VyP07n6rT5G/mGbcB8BcQOi+AE4DjgEgk6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SFUkMrYbqy37cPD+xvHHi7ZHxclEIpncPW4y2Dfx+jP0PVB7ruBl4tZHkN1puZlaM
         bkqwxatBQNBFBj+0InP4RNxuL8G+o/G9nrJyustINrWj7Zah0arrlrdnAdIPCio9H5
         3w9TGpzyinrqzhFnN+myr9ys4ONK24Wl+cHKoD2A=
Date:   Sun, 18 Oct 2020 11:02:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Remove __napi_schedule_irqoff?
Message-ID: <20201018110219.1b635ad9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <92aed1ab-efa3-c667-7f20-8a2b8fc67469@gmail.com>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
        <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
        <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
        <20201018101947.419802df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <92aed1ab-efa3-c667-7f20-8a2b8fc67469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 19:57:53 +0200 Heiner Kallweit wrote:
> > Dunno how acceptable this is to run in an IRQ handler on RT..
>  
> If I understand this code right then it's not a loop that actually
> waits for something. It just retries if the value of n->state has
> changed in between. So I don't think we'll ever see the loop being
> executed more than twice.

Right, but WCET = inf. IDK if that's acceptable.
