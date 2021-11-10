Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E83B44C1D6
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhKJNIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhKJNIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:08:36 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCD3C061764;
        Wed, 10 Nov 2021 05:05:48 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so10396643edv.1;
        Wed, 10 Nov 2021 05:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KPNsZzc2E1+3l/gXAViN6JbSjy2RMoZISYhUaEliIWM=;
        b=ZhtKVXJzgF4OPgvd7zg+7pyIF3fsZtApKls2ZBzNTD9LuSYl2JUj1rwhNLVCNEx+5J
         b9IF4WYdJsry61oRL0Vs+pFmCtMsdEU6NwyB9tR4gTXoQyD3mEDvCsgjvClsxCcaTkC1
         Q1Kg+741ZWsTLi8ZKDvuKWkQPiYMgZ6kkqywtWKvnCdngOmz0yi+R0ndQX2PdNKW2teU
         /QOe+fkTimpLOwhPfMS+3+G1mwLXOKHoXzyCRLoJ3lHEHDDIAcigtmktUB+Xbx2CTKgu
         FJVXqKCnlH3G4IKcYqDwy9/iQLtjlR3cWEsLeIgtAI4uz7ki9pYOPLFt/nLyILGj9c90
         Odgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KPNsZzc2E1+3l/gXAViN6JbSjy2RMoZISYhUaEliIWM=;
        b=X0ctfqbMZJVVrqfePAo2FhiL33lL2sGnaCm2XUlj1RHagzbQ1rRpL7NHIk2kTSF+Y5
         67Y5sY6B++/MsYhTVrqiDgRJ+JZeY/k6kOX7Gn1YPAN0BnFD86hilFGM8bGxKCka6/8s
         bXvZ/hzakfp1cVP11C40lENtZkctycs5ENQujVDFoDJDXRMZoE1mEjRAOFSjbArw0JIk
         5xXTwLpIsUDvfWJsRkCPaMbAsOkCUXeSad1xDSdKnje/SUmcVz1tfpdaRk79KuKtkDF6
         pOcwpEizOHccjfixeX6X7OrL7nUMQkPk1zxJ8qV2ESWKiKjGBoXSjs90GuarYk4tx28p
         ChyA==
X-Gm-Message-State: AOAM532DEOu5fI04YoK6Nl5dJtQQabYHHlpqsLkU0VB5PMz8DENL588g
        7J7VK6LI8dwEq6hUMw8e06Q=
X-Google-Smtp-Source: ABdhPJwCgJ5JBt/MqNqQTPwVO3uGq+lNe+wjuaOf8NmyRRHB2Qo64jC7H8Bt3fnmHTVEQ4Az7CMmlQ==
X-Received: by 2002:a05:6402:35c2:: with SMTP id z2mr21577281edc.135.1636549547417;
        Wed, 10 Nov 2021 05:05:47 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id p6sm12631327edx.60.2021.11.10.05.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 05:05:46 -0800 (PST)
Date:   Wed, 10 Nov 2021 15:05:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
Message-ID: <20211110130545.ga7ajracz2vvzotg@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf>
 <87ee7o8otj.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee7o8otj.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Wed, Nov 10, 2021 at 08:14:32AM +0100, Kurt Kanzenbach wrote:
> Hi Vladimir,
> 
> On Tue Nov 09 2021, Vladimir Oltean wrote:
> >> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
> >> +{
> >> +	struct b53_device *dev = ds->priv;
> >> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
> >> +	struct sk_buff *clone;
> >> +	unsigned int type;
> >> +
> >> +	type = ptp_classify_raw(skb);
> >> +
> >> +	if (type != PTP_CLASS_V2_L2)
> >> +		return;
> >> +
> >> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
> >> +		return;
> >> +
> >> +	clone = skb_clone_sk(skb);
> >> +	if (!clone)
> >> +		return;
> >> +
> >> +	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state)) {
> >
> > Is it ok if you simply don't timestamp a second skb which may be sent
> > while the first one is in flight, I wonder? What PTP profiles have you
> > tested with? At just one PTP packet at a time, the switch isn't giving
> > you a lot.
> 
> PTP only generates a couple of messages per second which need to be
> timestamped. Therefore, this behavior shouldn't be a problem.
> 
> hellcreek (and mv88e6xxx) do the same thing, simply because the device
> can only hold only one Tx timestamp. If we'd allow more than one PTP
> packet in flight, there will be correlation problems. I've tested with
> default and gPTP profile without any problems. What PTP profiles do have
> in mind?

First of all, let's separate "more than one packet in flight" at the
hardware/driver level vs user space level. Even if there is any hardware
requirement to not request TX timestamping for the 2nd frame until the
1st has been acked, that shouldn't necessarily have an implication upon
what user space sees. After all, we don't tell user space anything about
the realities of the hardware it's running on.

So it is true that ptp4l is single threaded and always polls
synchronously for the reception of a TX timestamp on the error queue
before proceeding to do anything else. But writing a kernel driver to
the specification of a single user space program is questionable.
Especially with the SOF_TIMESTAMPING_OPT_ID flag of the SO_TIMESTAMPING
socket option, it is quite possible to write a different PTP stack that
handles TX timestamps differently. It sends event messages on their
respective timer expiry (sync, peer delay request, whatever), and
processes TX timestamps as they come, asynchronously instead of blocking.
That other PTP stack would not work reliably with this driver (or with
mv88e6xxx, or with hellcreek).

> > Is it a hardware limitation?
> 
> Not for the b53. It will generate status frames for each to be
> timestamped packet. However, I don't see the need to allow more than one
> Tx packet per port to be timestamped at the moment.
> 
> Thanks,
> Kurt


