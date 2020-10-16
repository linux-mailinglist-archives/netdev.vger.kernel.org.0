Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A285928FFE9
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 10:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390153AbgJPIXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 04:23:54 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:41030 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394568AbgJPIXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 04:23:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602836632; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ogih4ttt21IhnMbpr4r7Ie0P2Iu9q+S+qfDsHdjfTpI=; b=l2axuc3EWuQCRrTaYTMXp7eub3uvYXxlwkprV9eoviND2uQUJbVk4R7lt/QcnVrAnyGruYbW
 9KFgUW/9YcxVivj03A52Yf73qPwKfclgHLxhCorIntrSJmruo1HMyKLxmx0uIgNB+/qR3Eoj
 sDhOuPJ33KA2w9qMyvOAPZhEHK8=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f895898588858a304539124 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 16 Oct 2020 08:23:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30CC4C43385; Fri, 16 Oct 2020 08:23:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F48DC433CB;
        Fri, 16 Oct 2020 08:23:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F48DC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi devices
References: <20200924151910.21693-1-srini.raju@purelifi.com>
        <20200928102008.32568-1-srini.raju@purelifi.com>
        <20200930051602.GJ3094@unreal> <87d023elrc.fsf@codeaurora.org>
        <20200930095526.GM3094@unreal>
        <1449cdbe49b428b7d16a199ebc4c9aef73d6564c.camel@sipsolutions.net>
        <20200930104459.GO3094@unreal>
Date:   Fri, 16 Oct 2020 11:23:45 +0300
In-Reply-To: <20200930104459.GO3094@unreal> (Leon Romanovsky's message of
        "Wed, 30 Sep 2020 13:44:59 +0300")
Message-ID: <87blh2y3xq.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky <leon@kernel.org> writes:

> On Wed, Sep 30, 2020 at 12:11:24PM +0200, Johannes Berg wrote:
>> On Wed, 2020-09-30 at 12:55 +0300, Leon Romanovsky wrote:
>> > On Wed, Sep 30, 2020 at 11:01:27AM +0300, Kalle Valo wrote:
>> > > Leon Romanovsky <leon@kernel.org> writes:
>> > >
>> > > > > diff --git a/drivers/net/wireless/purelifi/Kconfig
>> > > > b/drivers/net/wireless/purelifi/Kconfig
>> > > > > new file mode 100644
>> > > > > index 000000000000..ff05eaf0a8d4
>> > > > > --- /dev/null
>> > > > > +++ b/drivers/net/wireless/purelifi/Kconfig
>> > > > > @@ -0,0 +1,38 @@
>> > > > > +# SPDX-License-Identifier: GPL-2.0
>> > > > > +config WLAN_VENDOR_PURELIFI
>> > > > > +	bool "pureLiFi devices"
>> > > > > +	default y
>> > > >
>> > > > "N" is preferred default.
>> > >
>> > > In most cases that's true, but for WLAN_VENDOR_ configs 'default y'
>> > > should be used. It's the same as with NET_VENDOR_.
>> >
>> > I would like to challenge it, why is that?
>> > Why do I need to set "N", every time new vendor upstreams its code?
>>
>> You don't. The WLAN_VENDOR_* settings are not supposed to affect the
>> build, just the Kconfig visibility.
>
> Which is important to me, I'm keeping .config as minimal as possible
> to simplify comparison between various builds.

IIRC the 'default y' is to avoid breaking when updating from an old,
pre-vendor, kernel config (for example with 'make oldconfig'), otherwise
all wireless drivers would have been disabled without a warning. But as
wireless vendors were introduced back in 2015 in v4.5-rc1 I don't think
we need to worry about that anymore. But I would like to keep this
behaviour consistent across all vendors, so they all should be changed
at the same time in one patch.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
