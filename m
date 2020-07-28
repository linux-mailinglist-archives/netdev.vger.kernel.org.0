Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2367022FEAD
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgG1A7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG1A7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 20:59:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B17820809;
        Tue, 28 Jul 2020 00:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595897977;
        bh=TiJ2nFSx8p/oc0Ub+qEvsRg4KkH6dx4FIb4AaU6zuZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HPgGTKhzVQIqJlZQWf9fKC4GGP9qR0R8UsSCWCT/3EY8DjfyGXgByhvnZKpA4nZdc
         m7BpwZpRfN8W7w2+7Mbv9KMl5AfhqJx7utGWzEFtvdO3h8NhtuhNfB5eo7fcmUGMoE
         vwpdHw6XA/woh3W9ihuMpvHSl5WhOqNBk7bk+9yQ=
Date:   Mon, 27 Jul 2020 17:59:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC 09/13] devlink: Add enable_remote_dev_reset
 generic parameter
Message-ID: <20200727175935.0785102a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595847753-2234-10-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-10-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 14:02:29 +0300 Moshe Shemesh wrote:
> The enable_remote_dev_reset devlink param flags that the host admin
> allows device resets that can be initiated by other hosts. This
> parameter is useful for setups where a device is shared by different
> hosts, such as multi-host setup. Once the user set this parameter to
> false, the driver should NACK any attempt to reset the device while the
> driver is loaded.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

There needs to be a devlink event generated when reset is triggered
(remotely or not).

You're also missing failure reasons. Users need to know if the reset
request was clearly nacked by some host, not supported, etc. vs
unexpected failure.
