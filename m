Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4969622BE04
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgGXGUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:20:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18866 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgGXGUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 02:20:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595571637; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=wpgiKVEVOy257fAZ9OYY5jzv7k05sfpXH/PP7UcI1WI=; b=iYtmhc2zHPEEk0C7TOmq6lydGnltOlIwjLmzd7vENp0q2pUd5R7mxRpdzDLW26uqKuGYQQ99
 Hb7LaCCyNoQMA5s5E7EN25jnNLL58ebGKCdJWWklbHf8s2PvIx+XSpPf2WfVs7DzboqBJn69
 GSe4v3RvQEapUfFWlNtpLvtJWrw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-east-1.postgun.com with SMTP id
 5f1a7db3e3bee125102603fd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Jul 2020 06:20:35
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C6FE5C433AF; Fri, 24 Jul 2020 06:20:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [183.83.71.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36547C433CA;
        Fri, 24 Jul 2020 06:20:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36547C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <dianders@chromium.org>, <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org> <20200721172514.GT1339445@lunn.ch> <f6d93d76-9e59-c257-9318-31c71df28018@gmail.com> <002e01d6611e$0d8ac640$28a052c0$@codeaurora.org> <fdedf787-1bb0-601c-0959-6f1bfb38e5d7@gmail.com>
In-Reply-To: <fdedf787-1bb0-601c-0959-6f1bfb38e5d7@gmail.com>
Subject: RE: [RFC 0/7] Add support to process rx packets in thread
Date:   Fri, 24 Jul 2020 11:50:27 +0530
Message-ID: <000201d66182$8989a3b0$9c9ceb10$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwJNiRkqAuFxkXgCc1QR8AEP4g0AqRNlhKA=
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Florian Fainelli <f.fainelli@gmail.com>
> Sent: Friday, July 24, 2020 12:33 AM
> To: Rakesh Pillai <pillair@codeaurora.org>; 'Andrew Lunn'
> <andrew@lunn.ch>
> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> kernel@vger.kernel.org; kvalo@codeaurora.org; johannes@sipsolutions.net;
> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> dianders@chromium.org; evgreen@chromium.org
> Subject: Re: [RFC 0/7] Add support to process rx packets in thread
> 
> On 7/23/20 11:21 AM, Rakesh Pillai wrote:
> >
> >
> >> -----Original Message-----
> >> From: Florian Fainelli <f.fainelli@gmail.com>
> >> Sent: Tuesday, July 21, 2020 11:35 PM
> >> To: Andrew Lunn <andrew@lunn.ch>; Rakesh Pillai
> <pillair@codeaurora.org>
> >> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; kvalo@codeaurora.org;
> johannes@sipsolutions.net;
> >> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> >> dianders@chromium.org; evgreen@chromium.org
> >> Subject: Re: [RFC 0/7] Add support to process rx packets in thread
> >>
> >> On 7/21/20 10:25 AM, Andrew Lunn wrote:
> >>> On Tue, Jul 21, 2020 at 10:44:19PM +0530, Rakesh Pillai wrote:
> >>>> NAPI gets scheduled on the CPU core which got the
> >>>> interrupt. The linux scheduler cannot move it to a
> >>>> different core, even if the CPU on which NAPI is running
> >>>> is heavily loaded. This can lead to degraded wifi
> >>>> performance when running traffic at peak data rates.
> >>>>
> >>>> A thread on the other hand can be moved to different
> >>>> CPU cores, if the one on which its running is heavily
> >>>> loaded. During high incoming data traffic, this gives
> >>>> better performance, since the thread can be moved to a
> >>>> less loaded or sometimes even a more powerful CPU core
> >>>> to account for the required CPU performance in order
> >>>> to process the incoming packets.
> >>>>
> >>>> This patch series adds the support to use a high priority
> >>>> thread to process the incoming packets, as opposed to
> >>>> everything being done in NAPI context.
> >>>
> >>> I don't see why this problem is limited to the ath10k driver. I expect
> >>> it applies to all drivers using NAPI. So shouldn't you be solving this
> >>> in the NAPI core? Allow a driver to request the NAPI core uses a
> >>> thread?
> >>
> >> What's more, you should be able to configure interrupt affinity to steer
> >> RX processing onto a desired CPU core, is not that working for you
> >> somehow?
> >
> > Hi Florian,
> > Yes, the affinity of IRQ does work for me.
> > But the affinity of IRQ does not happen runtime based on load.
> 
> It can if you also run irqbalance.


Hi Florian,

Is it some kernel feature ?  Sorry I am not aware of this ?
I know it can be done in userspace.

> --
> Florian

