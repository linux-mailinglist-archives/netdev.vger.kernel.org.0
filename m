Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8663BB89A
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhGEIKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:10:53 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:17588 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhGEIKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 04:10:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625472496; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=RW8fyJsH303IPqDUiCLh0NYuRGV6pL/uvwf96HsVGEI=; b=mJBikMHPxONsxg6zjWw3n3p6lSZ+KdwiDpYoH8ni9dAb3Zl6U7/ixycunHHr1D2msBxFzK+Q
 vzPbSTLpGXdBEBzsqy6SRbOJfoPXHc0Vr5ekCQWECLsnCFDDuml096J1c+Wlp/+QzCYQBpeh
 P2s9PFAIU8xnyKRDW/ps30CeG6Y=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60e2bdecad0600eede24b251 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 05 Jul 2021 08:08:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CA222C433D3; Mon,  5 Jul 2021 08:08:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C1DBC433D3;
        Mon,  5 Jul 2021 08:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3C1DBC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Brian Norris <briannorris@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 04/24] rtw89: add debug files
In-Reply-To: <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de> (Oleksij
        Rempel's message of "Fri, 2 Jul 2021 19:57:40 +0200")
References: <20210618064625.14131-1-pkshih@realtek.com>
        <20210618064625.14131-5-pkshih@realtek.com>
        <20210702072308.GA4184@pengutronix.de>
        <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
        <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 05 Jul 2021 11:08:07 +0300
Message-ID: <87k0m5i3o8.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oleksij Rempel <o.rempel@pengutronix.de> writes:

> On Fri, Jul 02, 2021 at 10:08:53AM -0700, Brian Norris wrote:
>> On Fri, Jul 2, 2021 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>> > On Fri, Jun 18, 2021 at 02:46:05PM +0800, Ping-Ke Shih wrote:
>> > > +#ifdef CONFIG_RTW89_DEBUGMSG
>> > > +unsigned int rtw89_debug_mask;
>> > > +EXPORT_SYMBOL(rtw89_debug_mask);
>> > > +module_param_named(debug_mask, rtw89_debug_mask, uint, 0644);
>> > > +MODULE_PARM_DESC(debug_mask, "Debugging mask");
>> > > +#endif
>> >
>> >
>> > For dynamic debugging we usually use ethtool msglvl.
>> > Please, convert all dev_err/warn/inf.... to netif_ counterparts
>> 
>> Have you ever looked at a WiFi driver?
>
> Yes. You can parse the kernel log for my commits.
>
>> I haven't seen a single one that uses netif_*() for logging.
>> On the other hand, almost every
>> single one has a similar module parameter or debugfs knob for enabling
>> different types of debug messages.
>> 
>> As it stands, the NETIF_* categories don't really align at all with
>> the kinds of message categories most WiFi drivers support. Do you
>> propose adding a bunch of new options to the netif debug feature?
>
> Why not? It make no sense or it is just "it is tradition, we never do
> it!" ? 
>
> Even dynamic printk provide even more granularity. So module parameter looks
> like stone age against all existing possibilities.

I'm all for improving wireless driver debugging features, but let's
please keep that as a separate thread from reviewing new drivers. I
think there are 4-5 new drivers in the queue at the moment so to keep
all this manageable let's have the review process as simple as possible,
please.

Using a module parameter for setting the debug mask is a standard
feature in wireless drivers so it shouldn't block rtw89. If we want a
generic debug framework for wireless drivers, an rfc patch for an
existing upstream wireless driver is a good way to get that discussion
forward.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
