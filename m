Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A204E2C946B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389202AbgLABJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389185AbgLABJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:09:09 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F542073C;
        Tue,  1 Dec 2020 01:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606784909;
        bh=m0VnsJSV0+4I4HjkB61YuddBBSfnEG7sdCtU4UkO/e8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1aC1/W4GCNekv7vcAea1P9BOnSuPpMHz/Xj2TaIWy0uW9T71hPG4DFDCEKXNab3mH
         0INy80fF1w4HYHKcdUGYrYSPJOsVSjd1AlkLnXs/mUlcnvXhW0Ulh6saumWA6O9+Yy
         7mTAic3owp5nfFLNmm0pshq9Jn+bMEYa/cFGNtp8=
Date:   Mon, 30 Nov 2020 17:08:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Mario Limonciello <mario.limonciello@dell.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        sasha.neftin@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
Message-ID: <20201130170827.14d5e84a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130212907.320677-2-anthony.l.nguyen@intel.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
        <20201130212907.320677-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 13:29:04 -0800 Tony Nguyen wrote:
> From: Mario Limonciello <mario.limonciello@dell.com>
> 
> S0ix for GBE flows are needed for allowing the system to get into deepest
> power state, but these require coordination of components outside of
> control of Linux kernel.  For systems that have confirmed to coordinate
> this properly, allow turning on the s0ix flows at load time or runtime.

Please CC PCI, power management, (and ACPI?) people on the next version
of this change.

Alex's suggestion of ethtool flags is definitely an improvement, but
it'd be even better if we didn't have to add PCI/PM specific knobs 
to networking APIs.
