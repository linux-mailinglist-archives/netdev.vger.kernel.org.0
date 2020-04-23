Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085DD1B54ED
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgDWGtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:49:19 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:15471 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726822AbgDWGtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 02:49:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587624557; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=o+wVZ0HdkKdgihK3M0H7Bb0gg28lZpceeXg+Uha9THY=; b=fTguEEyXbAp6HI8vpUYdAApe7xWJi68A5MWwiYvVKtUcnboVq+LB5yODlLtlWYMPyXKZYTkr
 +7Zab7Kjixs1lciai0rxYp+fFBDfUBkk1w+r+mlBZT1pSfnqaim7wZGJu3brhv1W+OGYobtL
 OKM9qVb0/x04DFibAyQzuGOXsug=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ea13a60.7f5db181c688-smtp-out-n03;
 Thu, 23 Apr 2020 06:49:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CF365C43636; Thu, 23 Apr 2020 06:49:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC586C433CB;
        Thu, 23 Apr 2020 06:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC586C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 2/2] rtw88: Use udelay instead of usleep in atomic context
References: <20200423063811.2636-1-kai.heng.feng@canonical.com>
        <20200423063811.2636-2-kai.heng.feng@canonical.com>
Date:   Thu, 23 Apr 2020 09:49:01 +0300
In-Reply-To: <20200423063811.2636-2-kai.heng.feng@canonical.com> (Kai-Heng
        Feng's message of "Thu, 23 Apr 2020 14:38:10 +0800")
Message-ID: <87h7xan1cy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> It's incorrect to use usleep in atomic context.
>
> Switch to a macro which uses udelay instead of usleep to prevent the issue.
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

This fixes a regression, right? So there should be a Fixes line.

Also I can't take this until patch 1 is in my tree. And I don't know who
takes iopoll.h patches.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
