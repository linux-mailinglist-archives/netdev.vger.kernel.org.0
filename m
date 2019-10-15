Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25ECD7B01
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfJOQQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:16:53 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34798 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfJOQQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:16:52 -0400
Received: by mail-lj1-f193.google.com with SMTP id j19so20911114lja.1
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 09:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Mxk+Wx7DBRWAItFriOGDg8287W/Km/OXrRlXd/sfSuk=;
        b=ZEIMKnTqbmCbUHxlevy2Q3QkL6Vn2hA2SImGas6O+FBL85pXTNT5v3UK7pXhorDQj4
         H8ukVExRa8kzLlAo8ye4jXO1FonkgIO+0iXeXoBf6zzNS+xNIxFmsLezRLwDbtBbA9SU
         mEIRZmcw0FGPB1HZOvRa/inMVrU5SNabHwR4/B2LuseK8QKNCxnBZu0l1ZlpZt+ch6E4
         wJyaURB1Bu0rnXOxBpi3CdeowyBJ0Nq9KI4Tel9ZLTT2KAUC2tqFXaBU1qeEdnm6tMLW
         6o1C0kq+24tbmTLBvKdbI+L3+KydF01+MMiMObCxyQn2uJwKt1PgpS5ik4O3w6VsdidV
         9ZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Mxk+Wx7DBRWAItFriOGDg8287W/Km/OXrRlXd/sfSuk=;
        b=aA9jlARrSa5sgipTwFAwK7BaI+zlaTZncbDrIe09Hvc9vLLAK5OsBgKkXA7a+UfHgT
         flEAe2MHnBJHYrzJeEowB5+rrK53vvwJyRrvZut6rK20k0HMw+JIqxbbxCkutKeMuN5I
         adLu1QmmMGaY3OIkN/VbVF2TDOGnsNKHeUx0CiAOMcg8kVpe8dIJipxy69zBaj+Pi1yX
         GEz8VicdF21eCfFZBv1WcfDYKxqjxPdXj+KENc+7yCZXvf0ISbbiA0rw/o+eRzFY5pbu
         fWxm+ZSQPHKwEbreOPYu8AVt+FqeU0+IntdSZ6NuJck9Y7jOwdEZErJavsJPUPfQe8M7
         IsXQ==
X-Gm-Message-State: APjAAAWgIAEwE1b75RgpUJUfzGDkqHXIxH4yD8Cp9rOn79a2FYwmklTW
        tp+ThbUCH5XDW1vRuJeBipUCRA==
X-Google-Smtp-Source: APXvYqxubMYZ0x2MK2JVRP27XGEwNh9IrCExtJWpcMVw214R9IuLahJGJq61Kt5Sul4BS7kIV1KXqw==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr10991863ljk.147.1571156210561;
        Tue, 15 Oct 2019 09:16:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v6sm5117278ljh.66.2019.10.15.09.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 09:16:50 -0700 (PDT)
Date:   Tue, 15 Oct 2019 09:16:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Winslow <swinslow@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Johan Hovold <johan@kernel.org>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH v9 4/7] nfc: pn533: Split pn533 init & nfc_register
Message-ID: <20191015091642.6f49dd8f@cakuba.netronome.com>
In-Reply-To: <20191015095124.GA17778@lem-wkst-02.lemonage>
References: <20191008140544.17112-1-poeschel@lemonage.de>
        <20191008140544.17112-5-poeschel@lemonage.de>
        <20191009174023.528c278b@cakuba.netronome.com>
        <20191015095124.GA17778@lem-wkst-02.lemonage>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 11:51:24 +0200, Lars Poeschel wrote:
> > > -	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
> > > -					   priv->ops->tx_header_len +
> > > -					   PN533_CMD_DATAEXCH_HEAD_LEN,
> > > -					   priv->ops->tx_tail_len);
> > > -	if (!priv->nfc_dev) {
> > > -		rc = -ENOMEM;
> > > -		goto destroy_wq;
> > > -	}
> > > -
> > > -	nfc_set_parent_dev(priv->nfc_dev, parent);
> > > -	nfc_set_drvdata(priv->nfc_dev, priv);
> > > -
> > > -	rc = nfc_register_device(priv->nfc_dev);
> > > -	if (rc)
> > > -		goto free_nfc_dev;  
> > 
> > Aren't you moving too much out of here? Looking at commit 32ecc75ded72
> > ("NFC: pn533: change order operations in dev registation") it seems like
> > IRQ handler may want to access the data structures, do this change not
> > reintroduce the problem?  
> 
> Yes, you are right, there could be a problem if an irq gets served
> before the driver is registered to the nfc subsystem.
> Well, but the purpose of this patch is exactly that: Prevent use of nfc
> subsystem before the chip is fully initialized.
> To address this, I would not change the part above, but move the
> request_threaded_irq to the very bottom in pn533_i2c_probe, after the
> call to pn53x_register_nfc. So it is not possible to use nfc before the
> chip is initialized and irqs don't get served before the driver is
> registered to nfc subsystem.
> Thank you for this!
> I will include this in v10 of the patchset.

You can run nfc_allocate_device() etc. early, then allocate the IRQ,
and then run nfc_register_device(), would that work? Is that what you
have in mind?
