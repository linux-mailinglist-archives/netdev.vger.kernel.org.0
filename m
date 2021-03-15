Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0933C81D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhCOVEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232554AbhCOVEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 17:04:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A07064F0F;
        Mon, 15 Mar 2021 21:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615842263;
        bh=x6Ohr4zUVOCkc743v0YentVjOUBbKdxY7XevXk90cvU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KS7agi6oU4iZA+spwB31n9VHGw+fDwLmx4+5tNfqQZvzeDrnSkRRxseBpaWSBZZLe
         TVLCquYEDF93OML78sUTaOw+pS5aXL9E+pU6KVw24TxfxfNH6rV28d8Ihdb2PssyZ1
         qV/LbCCYellBXAoRjtXGW92yGUbx4S6y1Yeuz9jYOTL/ApIk2+9q+V7/UIQQQeDMft
         b7xGBYUCXH1Nu+GhdYXoj5yWlh4+nfuT5PhgSISmm35UvJSCterr5PqjJcNIq2OOIr
         nt0yoG4mhuvblEGE6NFTJxp2AIm7Q5c39ibIUpgaoKUKTZ5uG/8J6wNeKMJzsy9jB+
         2nkVz5MfeF6Pg==
Date:   Mon, 15 Mar 2021 14:04:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Chen Yu <yu.c.chen@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        kai.heng.feng@canonical.com, rjw@rjwysocki.net,
        len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 1/2] e1000e: Leverage direct_complete to speed
 up s2ram
Message-ID: <20210315140422.7a3d3bb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315190231.3302869-2-anthony.l.nguyen@intel.com>
References: <20210315190231.3302869-1-anthony.l.nguyen@intel.com>
        <20210315190231.3302869-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 12:02:30 -0700 Tony Nguyen wrote:
> +static __maybe_unused int e1000e_pm_prepare(struct device *dev)
> +{
> +	return pm_runtime_suspended(dev) &&
> +		pm_suspend_via_firmware();

nit: I don't think you need to mark functions called by __maybe_unused
     as __maybe_unused, do you?

The series LGTM although I don't know much about PM.
