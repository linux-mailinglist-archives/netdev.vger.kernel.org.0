Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571902CFF68
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgLEV6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgLEV6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:58:00 -0500
Date:   Sat, 5 Dec 2020 13:57:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607205439;
        bh=CqWDHF4URNlGdU/EFHAnOJNBlo9WNFYKiZ+AgeLeFnM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=d8iEUbTJiRWBaJDnvdQYuvnaewYti+5lw48qBzEIv6Cn8dU/3KDG5YfLNaTn+OaWh
         Ea1lmg33zOtHHvU0+KUN6Yd8h28Vt9x9rImsqQrrHTxLJHVcKSd7u7GuHvp2QJrUz7
         v/0OFzdJZvrsBio+nZy2rDJ5kjNoj4lSYX1oZ9juQGcx32s8FE7q8dzdLPRF+uiz19
         8ZutfjCudQgO2V9rum/owL9EKSdhl+IxR2u9wTX4QbGCewXecW9Dnl66O4sv0vw80m
         AQn7S71TjN/uUTrpRf9z/8KvYSN+CT9UyEa15YdpwgXDQRV7z0egGdaJG1Xb2T+D1I
         teIqZ0idExyNQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH 1/1 v3 net-next] ptp: Add clock driver for the
 OpenCompute TimeCard.
Message-ID: <20201205135718.34f11845@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204035128.2219252-2-jonathan.lemon@gmail.com>
References: <20201204035128.2219252-1-jonathan.lemon@gmail.com>
        <20201204035128.2219252-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 19:51:28 -0800 Jonathan Lemon wrote:
> +static int __init
> +ptp_ocp_init(void)
> +{
> +	int err;
> +
> +	err = pci_register_driver(&ptp_ocp_driver);
> +	return err;
> +}
> +
> +static void __exit
> +ptp_ocp_fini(void)
> +{
> +	pci_unregister_driver(&ptp_ocp_driver);
> +}
> +
> +module_init(ptp_ocp_init);
> +module_exit(ptp_ocp_fini);

FWIW if you want to send a follow up you can replace all this with:

module_pci_driver(ptp_ocp_driver);
