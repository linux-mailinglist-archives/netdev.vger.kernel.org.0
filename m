Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0246547A633
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbhLTIqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbhLTIqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:46:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC610C06173E;
        Mon, 20 Dec 2021 00:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8604B80E18;
        Mon, 20 Dec 2021 08:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E35AC36AE9;
        Mon, 20 Dec 2021 08:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639990007;
        bh=WzI0C34NvEDOEyNj+7GbTv7iAdUUSLBIH0O1Gq2K6u4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qxO9mQkDVgrm39oGRllxgrdZJsyyZgIGilQ+TMbRc16ah8N9agAWYS1Ez88lmS+qi
         0hSb8HaPCCwpIUFQYNSsd4WAs2NpkoFi7IlNxh4xYPURjN63jVp3fgiWHRf3jep3kW
         I1VGrzX1HF6iJL9E5GTMBROldgrji43oah6rc9vq7h39+VZQqAMXN/WEY/qh8vsg61
         I9jWHc3nVOJZ+XulR30tBo6VUTAUmd9nKxx6zX4WDiYhun5t4+hBii+vRa8Id+LiFa
         AogfRXrtl3u0+FwBPTM9qMc1Bldd6ovx+eqpFVsWYUQPMb/1SSQudhJ52RuJxJXfjo
         g+UqQbN8idNyw==
From:   Kalle Valo <kvalo@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Claudiu.Beznea@microchip.com, Ajay.Kathat@microchip.com,
        adham.abozaeid@microchip.com, davem@davemloft.net,
        devicetree@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v5 1/2] wilc1000: Add reset/enable GPIO support to SPI driver
References: <20211215030501.3779911-1-davidm@egauge.net>
        <20211215030501.3779911-2-davidm@egauge.net>
        <d55a2558-b05d-5995-b0f0-f234cb3b50aa@microchip.com>
        <9cfbcc99f8a70ba2c03a9ad99f273f12e237e09f.camel@egauge.net>
        <87zgp1c6lz.fsf@codeaurora.org>
        <938a54814087ca8c4b4011c2f418e773baf2b228.camel@egauge.net>
Date:   Mon, 20 Dec 2021 10:46:43 +0200
In-Reply-To: <938a54814087ca8c4b4011c2f418e773baf2b228.camel@egauge.net>
        (David Mosberger-Tang's message of "Thu, 16 Dec 2021 08:26:22 -0700")
Message-ID: <87bl1bmznw.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> writes:

> On Thu, 2021-12-16 at 10:10 +0200, Kalle Valo wrote:
>> David Mosberger-Tang <davidm@egauge.net> writes:
>> 
>> > > > +       } else {
>> > > > +               gpiod_set_value(gpios->reset, 1);       /* assert RESET */
>> > > > +               gpiod_set_value(gpios->enable, 0);      /* deassert ENABLE */
>> > > 
>> > > I don't usually see comments near the code line in kernel. Maybe move them
>> > > before the actual code line or remove them at all as the code is impler enough?
>> > 
>> > You're kidding, right?
>> 
>> I agree with Claudiu, the comments are not really providing more
>> information from what can be seen from the code. And the style of having
>> the comment in the same line is not commonly used in upstream.
>
> The code is obvious if you think of 1 as "assert" and 0 as "deassert".  It looks
> utterly wrong if you think of 1 as outputting 3.3V and 0 as outputting 0V.

Yeah, I guess for people who are more hardware orientated that looks
wrong :)

> But if you insist, I'll remove the comments.

I don't insist removing the comments, but please move them to their own
line so that the style is consistent.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
