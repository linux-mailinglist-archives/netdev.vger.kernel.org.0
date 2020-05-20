Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11C1DA79E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgETCAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 22:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgETCAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 22:00:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C05620708;
        Wed, 20 May 2020 02:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589940029;
        bh=/ARJmCX4Iyhnm69tSmCYn4J4+VuEQhIBjrbBcAc5Xjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ThDqh31y9fS/ccSfQ8lB+osktIk0VZ1VjseHlt/rniGaH1kFnvU5dW9c4TsaKSH19
         nqre8L73n1KnEunnZTOuavxOXggT5Lj/ahFVzrR+a0z4A+j7GfUhjvIpD58+CdbHf0
         OcxfNTWp1cQ1hDCRPPNFxp2tHwaPZ5bE0azXeegY=
Date:   Tue, 19 May 2020 19:00:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
Message-ID: <20200519190026.5334f3c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 17:04:05 -0700 Jeff Kirsher wrote:
> This series contains updates to igc only.
> 
> Sasha cleans up the igc driver code that is not used or needed.
> 
> Vitaly cleans up driver code that was used to support Virtualization on
> a device that is not supported by igc, so remove the dead code.
> 
> Andre renames a few macros to align with register and field names
> described in the data sheet.  Also adds the VLAN Priority Queue Fliter
> and EType Queue Filter registers to the list of registers dumped by
> igc_get_regs().  Added additional debug messages and updated return codes
> for unsupported features.  Refactored the VLAN priority filtering code to
> move the core logic into igc_main.c.  Cleaned up duplicate code and
> useless code.

No automated warnings :)

It's a little strange how both TCI and ETYPE filters take the queue ID.
Looking at the code it's not immediately clear which one take
precedence. Can I install two rules for the same TCI and different ETYPE
or vice versa?
