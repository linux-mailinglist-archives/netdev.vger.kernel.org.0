Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2021E32D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgGMWsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgGMWsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:48:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 469BE20DD4;
        Mon, 13 Jul 2020 22:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594680525;
        bh=FlNkp6Zmw95XjPO6jO2mV0cNpBqCiy5YzKfBPXTdIXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OjmnsK/GBGdOE5eL32Y9ZKCotQ7/51lorJHA4CSBJI8BNohxYm1S16kzBVM/Dknp+
         hohik12CDi4bD5H+LSKely9ZE9ex58E5Rr+QZNFUjL7Xpf8kILxF/lMMzVtARAOfZu
         jHD5f0hTBIVMHJiSqebJ8nbfkXtkI5yNtPyFqNh8=
Date:   Mon, 13 Jul 2020 15:48:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Haiyue Wang <haiyue.wang@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Nannan Lu <nannan.lu@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Message-ID: <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 10:43:16 -0700 Tony Nguyen wrote:
> From: Haiyue Wang <haiyue.wang@intel.com>
> 
> The DCF (Device Config Function) is a named trust VF (always with ID 0,
> single entity per PF port) that can act as a sole controlling entity to
> exercise advance functionality such as adding switch rules for the rest
> of VFs.

But why? This looks like a bifurcated driver to me.

> To achieve this approach, this VF is permitted to send some basic AdminQ
> commands to the PF through virtual channel (mailbox), then the PF driver
> sends these commands to the firmware, and returns the response to the VF
> again through virtual channel.
> 
> The AdminQ command from DCF is split into two parts: one is the AdminQ
> descriptor, the other is the buffer (the descriptor has BUF flag set).
> These two parts should be sent in order, so that the PF can handle them
> correctly.
> 
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
> Tested-by: Nannan Lu <nannan.lu@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

