Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A922044D4
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgFVXzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbgFVXzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 19:55:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E96920727;
        Mon, 22 Jun 2020 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592870154;
        bh=0kGYy318AdlNd6TOCI7uqneeoydZ70dPUoy4wBc/b8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aSSk3TyYymDzz97vq0zPzn6rGS7pCDZTLNUpICMlRnzHl9Y5w+Uwod2wafIxvNYrk
         zYCJYahXbW685ocb9uH+TXD0EvQufenLtzzx//jx4K0QeRLJ19hZuePmvlKvB3rIDm
         HcqrKLc5fcL1P81mtVbqt7umYmH6hxI96BlLwejc=
Date:   Mon, 22 Jun 2020 16:55:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 4/9] i40e: detect and log info about pre-recovery
 mode
Message-ID: <20200622165552.13ebc666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200622221817.2287549-5-jeffrey.t.kirsher@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
        <20200622221817.2287549-5-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 15:18:12 -0700 Jeff Kirsher wrote:
> +static inline bool i40e_check_fw_empr(struct i40e_pf *pf)
> +{

> +}

> +static inline i40e_status i40e_handle_resets(struct i40e_pf *pf)
> +{
> +	const i40e_status pfr = i40e_pf_loop_reset(pf);

> +
> +	return is_empr ? I40E_ERR_RESET_FAILED : pfr;
> +}

There is no need to use the inline keyword in C sources. Compiler will
inline small static functions, anyway.

Same thing in patch 8.
