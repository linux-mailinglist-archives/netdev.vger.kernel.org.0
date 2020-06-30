Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E743220EA20
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgF3ATb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgF3ATa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:19:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9961D20780;
        Tue, 30 Jun 2020 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593476370;
        bh=9qVCeHAHxaZVZSH/Vi5Wb0DoeBYZSLCEpzs84yBcdro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tYmX0Bu/WiUzqyLNKnS48cwzZjFsGdPZsLjrNBtM+uIuf6AbdWth45zkaz+LDcfuU
         dPpHoogGLv/s23JgTHRG94QK+L5mBooGpJDog1x0sludgGO3xQokyDgg5GHi02tg0q
         +mvawro/6o62Ld++o+PKVoY0QvD4FWw8/Sm8sC7U=
Date:   Mon, 29 Jun 2020 17:19:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Guedes <andre.guedes@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of
 ptp_tx_skb
Message-ID: <20200629171927.7b2629c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <159347562079.35713.11550779660753529150@shabnaja-mobl.amr.corp.intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
        <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com>
        <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <159346389229.30391.2954936254801502352@rramire2-mobl.amr.corp.intel.com>
        <20200629151117.63b466c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <159347562079.35713.11550779660753529150@shabnaja-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 17:07:00 -0700 Andre Guedes wrote:
> > What if timeout happens, igc_ptp_tx_hang() starts cleaning up and then
> > irq gets delivered half way through? Perhaps we should just add a spin
> > lock around the ptp_tx_s* fields?  
> 
> Yep, I think this other scenario is possible indeed, and we should probably
> protect ptp_tx_s* with a lock. Thanks for pointing that out. In fact, it seems
> this issue can happen even with current net-next code.
> 
> Since that issue is not introduced by this patch, would it be OK we move forward
> with it, and fix the issue in a separate patch?

Fine by me.
