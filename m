Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70DE2EB433
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbhAEUaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbhAEUaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:30:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC13422D6F;
        Tue,  5 Jan 2021 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609878566;
        bh=a0mWvDPNXdfTfBlt37PZE5Ql+c7SzMY0Seo28mhGpeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RUh/SSLENJ4UDiYsY612qbyZ/WwZfP2oLzXs1vyRoJVrSS8CJI0tq6VlM+jeVCBge
         rw7F8a229RUvRCfN1vu34VZj5NRUoYinP2k7pLuVJv1z6vIOG5YChkmlxUAImT/hpj
         OhEja+v7luWzZz/rBv4nCy1/XT+vvOGUry6J9eFyKP41n9eTiuWpsCDhLjb9gB98HJ
         2KlM7ZsZe6l0cRIt/69/yaNBQquZl7QVjoKpgAmRhI4WkQGaDZDnnTyZJFxtRGr4B9
         +RRBIhrUJyppwFO6yvb3aa/J36FFg/EZUb+9I0dJ+B+ZO1sorPXgK2jJ0C3v4vqY8m
         bdvoCFUPlCMCA==
Date:   Tue, 5 Jan 2021 12:29:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [net] cxgb4: advertise NETIF_F_HW_CSUM
Message-ID: <20210105122924.5bc636cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210105165749.16920-1-rohitm@chelsio.com>
References: <20210105165749.16920-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 22:27:49 +0530 Rohit Maheshwari wrote:
> advertise NETIF_F_HW_CSUM instead of protocol specific values of
> NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. This change is added long
> back in other drivers. This issue is seen recently when TLS offload
> made it mandatory to enable NETIF_F_HW_CSUM.
> 
> Fixes: 2ed28baa7076 ("net: cxgb4{,vf}: convert to hw_features")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Ugh, commit ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM
is disabled") is buggy, it should probably use NETIF_F_CSUM_MASK.
Can you fix that instead?
