Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A869211330
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgGATDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgGATDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 15:03:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B052082F;
        Wed,  1 Jul 2020 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593630193;
        bh=HayvkUDJT4Gv2QQPoaKzX/7x+d+mNpbEtDfUyh8OjaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xw50GqiL60Bw7oO/9DUrJ0lOn4EToqzuSCddhn/lwM7drzzbgKLRmsk3hQQK4ONyS
         GUFyRa9t9InLMNHRi2QwVfKMO3qskXjxF1pPZdy/Zic91erbFQwUyPp3hVYQVfLQg/
         p1Y7jioQqVMZ9MQYLPqCMP4UnJOWuGGqvPJ+8Rfo=
Date:   Wed, 1 Jul 2020 12:03:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 01/15] sfc: support setting MTU even if not
 privileged to configure MAC fully
Message-ID: <20200701120311.4821118c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <db235d46-96b0-ee6d-f09b-774e6fd9a072@solarflare.com>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
        <db235d46-96b0-ee6d-f09b-774e6fd9a072@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 15:51:25 +0100 Edward Cree wrote:
> Unprivileged functions (such as VFs) may set their MTU by use of the
>  'control' field of MC_CMD_SET_MAC_EXT, as used in efx_mcdi_set_mtu().
> If calling efx_ef10_mac_reconfigure() from efx_change_mtu(), the NIC
>  supports the above (SET_MAC_ENHANCED capability), and regular
>  efx_mcdi_set_mac() fails EPERM, then fall back to efx_mcdi_set_mtu().

Is there no way of checking the permission the function has before
issuing the firmware call?
