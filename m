Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4049283767
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgJEON3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:13:29 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:33803 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgJEON3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:13:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601907208; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ivNqpv3yu7yxdbxdKQrjC25RCIfxdWN76uDFvPf85LU=; b=eN5qeadbvZjjgirmF8wTVkXQUOa0YkrHvo0yNJVQuYGfSADhYlBR+jHXXY6MGUkY+9yjPlhh
 J9XdB6TP2lD/1XEHo1lhzqVgOa9IUlRBchxB6zmsnPrxhLajpGF8LdfmvtEPgiwvaSxjIa8O
 BkxBRDFHI7dPgw2MX6nGSL0tC9g=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f7b29eb4fce93c117aa3430 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 05 Oct 2020 14:12:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1B977C433FF; Mon,  5 Oct 2020 14:12:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E27FC433C8;
        Mon,  5 Oct 2020 14:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E27FC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Status of orinoco_usb
References: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
        <20201002113725.GB3292884@kroah.com>
        <20201002115358.6aqemcn5vqc5yqtw@linutronix.de>
        <20201002120625.GA3341753@kroah.com>
Date:   Mon, 05 Oct 2020 17:12:54 +0300
In-Reply-To: <20201002120625.GA3341753@kroah.com> (Greg Kroah-Hartman's
        message of "Fri, 2 Oct 2020 14:06:25 +0200")
Message-ID: <877ds4damx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Fri, Oct 02, 2020 at 01:53:58PM +0200, Sebastian Andrzej Siewior wrote:
>> On 2020-10-02 13:37:25 [+0200], Greg Kroah-Hartman wrote:
>> > > Is it possible to end up here in softirq context or is this a relic?
>> > 
>> > I think it's a relic of where USB host controllers completed their urbs
>> > in hard-irq mode.  The BH/tasklet change is a pretty recent change.
>> 
>> But the BH thingy for HCDs went in v3.12 for EHCI. XHCI was v5.5. My
>> guess would be that people using orinoco USB are on EHCI :)
>
> USB 3 systems run XHCI, which has a USB 2 controller in it, so these
> types of things might not have been noticed yet.  Who knows :)
>
>> > > Should it be removed?
>> > 
>> > We can move it out to drivers/staging/ and then drop it to see if anyone
>> > complains that they have the device and is willing to test any changes.
>> 
>> Not sure moving is easy since it depends on other files in that folder.
>> USB is one interface next to PCI for instance. Unless you meant to move
>> the whole driver including all interfaces.
>> I was suggesting to remove the USB bits.
>
> I forgot this was tied into other code, sorry.  I don't know what to
> suggest other than maybe try to fix it up the best that you can, and
> let's see if anyone notices...

That's what I would suggest as well.

These drivers for ancient hardware are tricky. Even if there doesn't
seem to be any users on the driver sometimes people pop up reporting
that it's still usable. We had that recently with one another wireless
driver (forgot the name already).

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
