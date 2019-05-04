Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3E11397D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfEDLfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:35:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46548 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEDLfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:35:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id n2so4020150pgg.13
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fUeT1szSZocCYADzBMYe9ZpgYdjX1NCkTft/NbEat5w=;
        b=B8kzpTI9EIiEazky3RNQuO703Id+7Nv1p/PtKZVYMqsU8RSjGFHohOFtFPqZOknrWx
         PA37Xl/dtgUW/qbx/+w3YbAMwAglRZ6wW1SL5XsKsB07tRHkbpJ/eQWCiFe/k4yrYQGP
         v0PaevFGI3IuicN8rSr3n6Id97o15Kkm+kbWuGNgML+HGF8oR1eKTgpCym7n3+SqLtA6
         eqkXUn26BS66bqZzBTIaEKeehX8qbML3DnQuBa1qg6wZXyFlUE1RhuIZ9f9xYqIEUHPV
         a4qa3wqjKREaqCnoHRcqSW1xPMnpM/2hjPRl6QX4L1RGxSPjHtjVdIw3Zd+wPzIMGUFf
         ed1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fUeT1szSZocCYADzBMYe9ZpgYdjX1NCkTft/NbEat5w=;
        b=IxqC/Wk6X7JT38KTQSNpj8mupxqkW/3Mdpk3U4b/Dhk2zQWUa9lybqvhlBr3MJSzlX
         e2ctL6Y9gHLMBgqrApxJaEdGj59CJtP73DQXPraoqufVGEYUL0kODiLpcXGO9pmSXuWc
         du1QKrCk8FyaKdks/r9OBPjij0oirCYPinJ2MCV3bz1IS/NYDAcyN4S1KhlC4wVMXSLp
         /22bmJYPXnKC/q5+ZuB5AGAodx4xoteJJ4ViQXp3vfQTeLjXpS2f8uArorKozeR4ErsK
         H6crLHoA+/1qcBhReRtJ/IyKKuFfAnYDSzY3vQE0ipfhU/2tDLPnlqe48VWS0Q4/Nv7H
         H7uQ==
X-Gm-Message-State: APjAAAWrDp6tCOpojqgi2EAvf1B+P1NUZYS7M5ORDzuSv3weTw+7tds6
        DZUNOH3ffCkoJGqmx5zBUQ7CIQ==
X-Google-Smtp-Source: APXvYqwTZUnUDCh5ElMHbi7T0zKmCoOQ1/Ooz80LI40kDFlWw+hqS7/7IBzyjPPfsp5NUJZKXwn63g==
X-Received: by 2002:aa7:8186:: with SMTP id g6mr19142772pfi.126.1556969738834;
        Sat, 04 May 2019 04:35:38 -0700 (PDT)
Received: from cakuba.netronome.com (ip-174-155-149-146.miamfl.spcsdns.net. [174.155.149.146])
        by smtp.gmail.com with ESMTPSA id e13sm6253736pfi.130.2019.05.04.04.35.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 04 May 2019 04:35:38 -0700 (PDT)
Date:   Sat, 4 May 2019 07:35:22 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alice Michael <alice.michael@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Piotr Marczak <piotr.marczak@intel.com>,
        Don Buchholz <donald.buchholz@intel.com>
Subject: Re: [net-next v2 11/11] i40e: Introduce recovery mode support
Message-ID: <20190504073522.3bc7e00d@cakuba.netronome.com>
In-Reply-To: <20190503230939.6739-12-jeffrey.t.kirsher@intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
        <20190503230939.6739-12-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 May 2019 16:09:39 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
> 
> This patch introduces "recovery mode" to the i40e driver. It is
> part of a new Any2Any idea of upgrading the firmware. In this
> approach, it is required for the driver to have support for
> "transition firmware", that is used for migrating from structured
> to flat firmware image. In this new, very basic mode, i40e driver
> must be able to handle particular IOCTL calls from the NVM Update
> Tool and run a small set of AQ commands.

What's the "particular IOCTL" you speak of?  This patch adds a fake
netdev with a .set_eeprom callback.  Are you wrapping the AQ commands
in the set_eeprom now?  Or is there some other IOCTL here?

Let me repeat my other question - can the netdev you spawn in
i40e_init_recovery_mode() pass traffic?

> These additional AQ commands are part of the interface used by
> the NVMUpdate tool.  The NVMUpdate tool contains all of the
> necessary logic to reference these new AQ commands.  The end user
> experience remains the same, they are using the NVMUpdate tool to
> update the NVM contents.

IOW to update FW users still need your special tool, but they can use
ethtool -f to.. change the app-specific (DPDK) parser profiles?  Joy :)

> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
> Tested-by: Don Buchholz <donald.buchholz@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
