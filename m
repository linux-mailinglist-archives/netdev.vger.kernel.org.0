Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F21105CC4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUWm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:42:57 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:34808 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKUWm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:42:57 -0500
Received: by mail-lj1-f173.google.com with SMTP id 139so5112929ljf.1
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 14:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8qEica35zSD8CLFkAzTdP5b2yA1UHaYhIN45RaePhs4=;
        b=WXDU3Z23r+XAgu+1BaGOxdoOfk//wqWYcKgn+mQxrVRBMbAmoiw0wlD6Z34OsNMu/A
         R2Nt1vgafRteBpRc/jc7WOsYG0VlbT60OvRuXnlxXnfF+KJw4saMeMG4VMtfgqsLQ3gG
         9bRiM25yK7JAKsq6f0MOt+gTn/6/nqHiE6mazMD997f3YN++ElG0mNcjBrEsFRBVljnM
         /EqK0rPKcafkZLkEy3hnrYRv4Cvk41sXAz1Jjsrhr/wEfUAgN2m6tB7xluzm/ASsneeI
         PlA+IImqmBWkXVea7KKW0D+cowmIDEEEf44/Pku/x6aSFp5MqsZF5gpTHL3wN7t91EYX
         lcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8qEica35zSD8CLFkAzTdP5b2yA1UHaYhIN45RaePhs4=;
        b=SFV2dlpDNm11gHqGGHwGsvJa0JFG43JGbxyhASes7PM3oLAgXs851JOU4rDoJxEOia
         VrSYgVrnT6T45NOdqV51lWw0bcEoWZpj95JfTLPMkwMnrqlkP5J3Xt/Qsh494BVzA6J0
         g6WBDijzfyEqTJv6EwHUeLYWUWb9rKn89Zdws5RfXERdk8z+HiLnn15rKIqeYhtM9kHO
         iBiWATNtS2zvKihWirVKci6D6d388kbVyA/o/wjByhXzoN7TCRI8MvnESxdO9zmpqXtQ
         sSaL2QAn+PI8tKkO0BRkEvPyFVstavQb/QIAqhclH0lpy9cz39D21kUAqmq1uoTCDipQ
         Pm5w==
X-Gm-Message-State: APjAAAU/b+X4NWUdQc5/w3LoC4Cg9CHZNqWvrrE3i9oTYYx/5cQJclvc
        tNJtQeVsbAT3H9SQhmz0VuDyiA==
X-Google-Smtp-Source: APXvYqzWb1xzIRiLEelXqcXwbHuPPGVd86JM1mJGYLuQNQA8vXhOcY4R+Axdj6HxTxXyTIYV+TUqfw==
X-Received: by 2002:a2e:98c6:: with SMTP id s6mr8815139ljj.235.1574376174441;
        Thu, 21 Nov 2019 14:42:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z22sm1908901ljm.92.2019.11.21.14.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 14:42:54 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:42:46 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Henry Tieman <henry.w.tieman@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 13/15] ice: Implement ethtool ops for channels
Message-ID: <20191121144246.04adde1a@cakuba.netronome.com>
In-Reply-To: <20191121074612.3055661-14-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
        <20191121074612.3055661-14-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 23:46:10 -0800, Jeff Kirsher wrote:
> +	curr_combined = ice_get_combined_cnt(vsi);
> +
> +	/* these checks are for cases where user didn't specify a particular
> +	 * value on cmd line but we get non-zero value anyway via
> +	 * get_channels(); look at ethtool.c in ethtool repository (the user
> +	 * space part), particularly, do_schannels() routine
> +	 */
> +	if (ch->rx_count == vsi->num_rxq - curr_combined)
> +		ch->rx_count = 0;
> +	if (ch->tx_count == vsi->num_txq - curr_combined)
> +		ch->tx_count = 0;
> +	if (ch->combined_count == curr_combined)
> +		ch->combined_count = 0;
> +
> +	if (!(ch->combined_count || (ch->rx_count && ch->tx_count))) {
> +		netdev_err(dev, "Please specify at least 1 Rx and 1 Tx channel\n");
> +		return -EINVAL;
> +	}
> +
> +	new_rx = ch->combined_count + ch->rx_count;
> +	new_tx = ch->combined_count + ch->tx_count;

The combined vs individual count logic looks correct to me which is not
common, so nice to see that!

> +	if (new_rx > ice_get_max_rxq(pf)) {
> +		netdev_err(dev, "Maximum allowed Rx channels is %d\n",
> +			   ice_get_max_rxq(pf));
> +		return -EINVAL;
> +	}
> +	if (new_tx > ice_get_max_txq(pf)) {
> +		netdev_err(dev, "Maximum allowed Tx channels is %d\n",
> +			   ice_get_max_txq(pf));
> +		return -EINVAL;
> +	}
> +
> +	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
> +
> +	if (new_rx)
> +		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);

But I don't see you doing a netif_is_rxfh_configured() check, which is
supposed to prevent reconfiguring the RSS indirection table if it was
set up manually by the user.

This is doubly sad, because I believe that part of RSS infrastructure
was added by Jake Keller from Intel, so it should be caught by your
internal review, not to say tests.. :(

> +	return 0;
> +}
