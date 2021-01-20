Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83D22FC545
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbhATABr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729777AbhATAA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 19:00:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1C423108;
        Wed, 20 Jan 2021 00:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611100819;
        bh=bSGITyn7tusjnywC+IJy8UrWrLPveSA07/uROsShyQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OvMDEytowkB0yocxa5HqDw5OOd9XHCQZSSGhIpMGRETmCeVeffcrxJlqmlSxMDTL3
         7/A5Z0zqUXR2nDSVvCKyGmiZyiSbqLqBDDtFz2BFoZS1Iv0TDvBpFqipcW+Y5UFFPG
         Wy2ipN1pHmxlGHD1LG6gjn9RnsUfrm7b3jC/bXyqWIQmlxbxKK0JslDAme+HrHcEi+
         wpLEmTd7yJhqY7gIViG3etM3wnK2WCXWWRQFTNdy81qDC9VIZWV1O+Ec003ZbDL5Yt
         WEQBXikvkb63RsNdtnj/aqqEw8L3f8L7+fLJj7GuiwPmjd2e5/n2c4c8m06wuAQKy5
         YxZy52Lrvl1ZA==
Date:   Tue, 19 Jan 2021 16:00:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net] net: Disable NETIF_F_HW_TLS_RX when RXCSUM is
 disabled
Message-ID: <20210119160017.000eaafd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210117151538.9411-1-tariqt@nvidia.com>
References: <20210117151538.9411-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 17:15:38 +0200 Tariq Toukan wrote:
> With NETIF_F_HW_TLS_RX packets are decrypted in HW. This cannot be
> logically done when RXCSUM offload is off.
> 
> Fixes: 14136564c8ee ("net: Add TLS RX offload feature")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Boris Pismenny <borisp@nvidia.com>

Applied, but it's not 100% equivalent to Tx. For Rx we _can_
efficiently fall back to SW.
