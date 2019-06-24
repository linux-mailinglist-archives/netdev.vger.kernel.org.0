Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D5951C11
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfFXUNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:13:09 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36541 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfFXUNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:13:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id p15so15931660qtl.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 13:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zyRSJOm/djzljajnRCj44ez4ZIyWMQL79GBrVfOHNTc=;
        b=Q8VADBu1Wgc4aXktuyM3RdTWbXEXGRF2EAnfGn07ScnjtXeT0UUWHH2QLyAYgoZ/EN
         GXeGd1PB0mX4OxlRs0p02XewKztoDAlltYGVm/XZIvMNHLyvwcHtbeROUjWOhGfbUPWz
         w7e8HZclfk8eQHWL/SIob4Zf4t82xmENUJxtAaL6RI1uXU2Rjjv9wSlvNvwwQWRtH6Ka
         mILflyZmMMIT71NDEQBYU+jESWDBqHAbYb/CBlw78XTjSOGSfPaboZ2nXbl6lEvRryo2
         uFA1JcHSyFlGrdAq5gGsBqeZ8F0rXu133d3lUdAiqjM5LNiSGlmpTTyfGZ6UqJwM9LIk
         U4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zyRSJOm/djzljajnRCj44ez4ZIyWMQL79GBrVfOHNTc=;
        b=oMPRqLEbpO8WSsJPNzX4eKJLSh4zko2XfXy+pOaWCSAaxxodauaCFSrSUSY9oXAK2v
         cXVel5DwZHybX8wpTWCQQSFs1uKQOASybg5SnjJIy9/5kFOe735R0XogVAULcIrMCSO4
         EZVY5viuMSpQD6fm1iHOxWc6pe1kLMjkTBySJcpfKX7qXfy16/x09GinThgjaIj2Wizu
         cf8tlsF1GWYD9sKVYxw1i51Vm4sPGR0H4VCiP7irolDQmmxFCFvzTbiHrKw59t3tTlP6
         F52UkBkP5VR4qkk2kQRL6teNv/d8PuDUTKXUJcA3jdtJryghmF2gEcLUymswd4p8NGNC
         VaWw==
X-Gm-Message-State: APjAAAVah9aNdKihrTt+vk0AP9bEDFfIYxuYWgnydPFpV4vz9YEmCcLJ
        yLLHSDq+krPOcFQpsHAiyXhTtOkGwUk=
X-Google-Smtp-Source: APXvYqzqK6cQlMJq8oZtQqVGVO4aTVc2Ivob3Mt3aQkhOlQr/GHaZ0FEuOnEZZ48/ru4bigLXggHtw==
X-Received: by 2002:ac8:319d:: with SMTP id h29mr50015283qte.6.1561407187755;
        Mon, 24 Jun 2019 13:13:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f6sm5764787qkk.79.2019.06.24.13.13.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 13:13:07 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:13:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190624131304.78c1a4a9@cakuba.netronome.com>
In-Reply-To: <65461426-92d8-cd87-942d-1fd82bd64fe4@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-3-snelson@pensando.io>
        <20190620215430.GK31306@lunn.ch>
        <65461426-92d8-cd87-942d-1fd82bd64fe4@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jun 2019 15:22:22 -0700, Shannon Nelson wrote:
> >> +static int identity_show(struct seq_file *seq, void *v)
> >> +{
> >> +	struct ionic *ionic = seq->private;
> >> +	struct identity *ident = &ionic->ident;
> >> +	struct ionic_dev *idev = &ionic->idev;
> >> +
> >> +	seq_printf(seq, "asic_type:        0x%x\n", idev->dev_info.asic_type);
> >> +	seq_printf(seq, "asic_rev:         0x%x\n", idev->dev_info.asic_rev);
> >> +	seq_printf(seq, "serial_num:       %s\n", idev->dev_info.serial_num);
> >> +	seq_printf(seq, "fw_version:       %s\n", idev->dev_info.fw_version);
> >> +	seq_printf(seq, "fw_status:        0x%x\n",
> >> +		   ioread8(&idev->dev_info_regs->fw_status));
> >> +	seq_printf(seq, "fw_heartbeat:     0x%x\n",
> >> +		   ioread32(&idev->dev_info_regs->fw_heartbeat));  
> > devlink just gained a much more flexible version of ethtool -i. Please
> > remove all this and use that.  
> Yes, we intend to add a devlink interface, it just isn't in this first 
> patchset, which is already plenty big.

Please take this out of your patch set, we can't be expected to merge
debugfs implementation of what has proper APIs :/
