Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29C11ACA55
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898200AbgDPNks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2898167AbgDPNko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:40:44 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBBBC061A0C;
        Thu, 16 Apr 2020 06:40:43 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id f13so2053141ybk.7;
        Thu, 16 Apr 2020 06:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+FTxnb1SbF3l6f2HRSoVhs1qVsC4S/0hf0CM8kyAOOY=;
        b=EdcH+dWl3unZRbOq2+w6f6bJpyha77vf9JTSti2BOfhZMK495Y6szJrVP6/n8TzdFD
         HEWgD9y+m6a/x4vR/8GFubM87Mt5Rhz5RcERr15ed+KNKY8pqKOsCBO/PfgeXHuNyE/o
         V5horba89yDNfX44wRqYxFVKfWavbzTTKgtIjceW38apAkiVXKjPoJkY9rRY4URhA/eY
         q9IcG88zIchgOQkBsHdYpMmiq6GcwJfEjMNwXkMzMnq7c7e6YYXMcu11TJ+MrYH/SngF
         OR6H90ZORBhI7KsofrGW1vN2g1RKsUh7upOKzhtzsCkjUyQ5cVHbWZ454CPP5oYGJAHp
         Jdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+FTxnb1SbF3l6f2HRSoVhs1qVsC4S/0hf0CM8kyAOOY=;
        b=Fm9f0FjJ0rxEqRISc0grKz/OZ+btyPSmb1m5X4L2TzElqhYkJfXmzTdFZvcNwN/fqO
         MeozXxoXRnxjrHhIrNBkkGgFoEb2QAi5RT8Ae9BFOf7jqzJmdRBtyyNTRlMIp851V/+1
         qkdQwjyhSO2nh2eteDwETWRTxRYfbd5tPq4B6Z7aoDgI+/nEX4uREgPR78YjqAH6nne/
         9prMZu3B041UFZkppYUUAWCjPO1xa62aCWNKymcn0bE5KgDxUZnuyOoNjYaNn0rfmgoa
         DKhSCSQl3H27doHQ0fRor6AkweqPBWzuUJWs0AHaHnygeR0xMwOZIJT3/qmRSGVGmtd5
         BNzg==
X-Gm-Message-State: AGi0Pua1buU4i6S6i3Q7gJrc9mQokvxHZMpwwvM6DcVhDT+J8eyVAbPr
        IYSHyIHCTzoUuOfXr79yMFpaDWabn+UtNQbGO9k=
X-Google-Smtp-Source: APiQypJakW3ZFcDGjfwOFPNEPeIOKgZXKt96uuOtmmwmQZ/5Sc+e3wzdV4eH+fyex8AXApQgNU1oKuSwsaQKPC0wfSQ=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr17523747ybm.129.1587044443057;
 Thu, 16 Apr 2020 06:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200411231413.26911-9-sashal@kernel.org> <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm> <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com> <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com> <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com> <20200416000009.GL1068@sasha-vm>
In-Reply-To: <20200416000009.GL1068@sasha-vm>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 16 Apr 2020 16:40:31 +0300
Message-ID: <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
To:     Sasha Levin <sashal@kernel.org>
Cc:     Edward Cree <ecree@solarflare.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 3:00 AM Sasha Levin <sashal@kernel.org> wrote:
> I'd maybe point out that the selection process is based on a neural
> network which knows about the existence of a Fixes tag in a commit.
>
> It does exactly what you're describing, but also taking a bunch more
> factors into it's desicion process ("panic"? "oops"? "overflow"? etc).

As Saeed commented, every extra line in stable / production kernel
is wrong. IMHO it doesn't make any sense to take into stable automatically
any patch that doesn't have fixes line. Do you have 1/2/3/4/5 concrete
examples from your (referring to your Microsoft employee hat comment
below) or other's people production environment where patches proved to
be necessary but they lacked the fixes tag - would love to see them.

We've been coaching new comers for years during internal and on-list
code reviews to put proper fixes tag. This serves (A) for the upstream
human review of the patch and (B) reasonable human stable considerations.

You are practically saying that for cases we screwed up stage (A) you
can somehow still get away with good results on stage (B) - I don't
accept it. BTW - during my reviews I tend to ask/require developers to
skip the word panic, and instead better explain the nature of the
problem / result.

>>> This is great, but the kernel is more than just net/. Note that I also
>>> do not look at net/ itself, but rather drivers/net/ as those end up with
>>> a bunch of missed fixes.

>>drivers/net/ goes through the same DaveM net/net-next trees, with the
>> same rules.

you ignored this comment, any more specific complaints?

> Let me put my Microsoft employee hat on here. We have driver/net/hyperv/
> which definitely wasn't getting all the fixes it should have been
> getting without AUTOSEL.

> While net/ is doing great, drivers/net/ is not. If it's indeed following
> the same rules then we need to talk about how we get done right.

I never [1] saw -stable push requests being ignored here in netdev.
Your drivers have four listed maintainers and it's common habit by
commercial companies to have paid && human (non autosel robots)
maintainers that take care of their open source drivers. As in commercial
SW products, Linux has a current, next and past (stable) releases, so
something sounds as missing to me in your care matrix.

[1] actually I do remember that once or twice out of the 2020 times we asked,  a
patch was not sent to -stable by the sub-system maintainer mistake
which he fixed(..) later
