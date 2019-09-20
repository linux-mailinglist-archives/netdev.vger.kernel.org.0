Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8BAB8AB9
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 08:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408264AbfITGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 02:07:41 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:46338 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404689AbfITGHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 02:07:40 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id B02075E2A21;
        Fri, 20 Sep 2019 08:07:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1568959656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jH9gXNPbxi1W8r9+ABp+AurJWFHZfRBG5DgXPnFMReM=;
        b=R9vkVfECkjWSsgJppG8rxM736W3JpEs0gyNHlOeP0NxqIY0mOrOvG1NPEa47TciTF5yJgn
        iXHnMmXPi2bRWXfTDVLJTOu/Z9m5PGlhve07S4wTYUxY7KZVJ41HZusrpioYhwwA+Hy3hi
        99j9FqMlDBd163Sq7SiuIBav94PyaoA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Sep 2019 08:07:36 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-mediatek@lists.infradead.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt76x2e hardware restart
In-Reply-To: <c6d621759c190f7810d898765115f3b4@natalenko.name>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
 <c6d621759c190f7810d898765115f3b4@natalenko.name>
Message-ID: <9d581001e2e6cece418329842b2b0959@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=arc-20170712; t=1568959656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jH9gXNPbxi1W8r9+ABp+AurJWFHZfRBG5DgXPnFMReM=;
        b=Lx7RSi2KM1izZeY1DlaZvsDfXcqIgMn13kACMSo+n2mRDTFq4BW1IrmUEyYwUuLiSl6bHi
        n1IhBPgJP6HMQhhtOmR2koeCh1eYP5P7bjkpF9dD3iujiiZuoEvYApZxGjdWfiugxVwjjk
        Pk49jnuQ/xyCGUfVowZo0qwtKO/q/Ug=
ARC-Seal: i=1; s=arc-20170712; d=natalenko.name; t=1568959656; a=rsa-sha256;
        cv=none;
        b=ltZH82cvZTCqUIZu17K+MZfElr0UyGtpOPdJxJdgkRBXBvIjnN1O85JL7EmLGgGuHw9V7e
        UOYX4cwyH2BJlW8ziD7E+9pWCcf6uH4vcDACi99Y5K6OgL7A7Hj1rG3uTUQjAbzDWpq5qu
        7tC9mxbub4DHtQorgIALBd8B7hEj3yo=
ARC-Authentication-Results: i=1;
        vulcan.natalenko.name;
        auth=pass smtp.auth=oleksandr@natalenko.name smtp.mailfrom=oleksandr@natalenko.name
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.09.2019 23:22, Oleksandr Natalenko wrote:
> It checks for TX hang here:
> 
> === mt76x02_mmio.c
> 557 void mt76x02_wdt_work(struct work_struct *work)
> 558 {
> ...
> 562     mt76x02_check_tx_hang(dev);
> ===

I've commented out the watchdog here ^^, and the card is not resetted 
any more, but similarly it stops working shortly after the first client 
connects. So, indeed, it must be some hang in the HW, and wdt seems to 
do a correct job.

Is it even debuggable/fixable from the driver?

-- 
   Oleksandr Natalenko (post-factum)
