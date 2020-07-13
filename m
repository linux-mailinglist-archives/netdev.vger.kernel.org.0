Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128BC21E380
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGMXH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgGMXH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 19:07:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27DA2065F;
        Mon, 13 Jul 2020 23:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594681678;
        bh=MshLuR6yLw+sCHk6KdKzTX7yQmLky8v8v4ten+nPUCI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cHMR0/4SjePrc95g8mtmwq6FzGfiaZqwE7OMb8amIb44n6WvrG7ySX99sDZNm2krA
         jbOae6lcJkGAVIC0ewkUyMgS/1KVk8i50vV0gOcKG0ZVm34STGHUzh/SkTlnuod1JH
         Iejaiz8NZcdnNzDp67ZMiS4KUDF+ViGMqeYPHCSs=
Date:   Mon, 13 Jul 2020 16:07:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200713160756.5bd76e1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
        <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 12:32:16 +0100 Edward Cree wrote:
> +static int __init ef100_init_module(void)
> +{
> +	int rc;
> +
> +	pr_info("Solarflare EF100 NET driver v" EFX_DRIVER_VERSION "\n");
> +
> +	rc = efx_create_reset_workqueue();
> +	if (rc)
> +		goto err_reset;
> +
> +	rc = pci_register_driver(&ef100_pci_driver);
> +	if (rc < 0) {
> +		pr_err("pci_register_driver failed, rc=%d\n", rc);
> +		goto err_pci;
> +	}
> +
> +	return 0;
> +
> +err_pci:
> +	efx_destroy_reset_workqueue();
> +err_reset:
> +	return rc;
> +}
> +
> +static void __exit ef100_exit_module(void)
> +{
> +	pr_info("Solarflare EF100 NET driver unloading\n");

efx_destroy_reset_workqueue(); ?

> +	pci_unregister_driver(&ef100_pci_driver);
> +}
