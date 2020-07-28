Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32725231375
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgG1UEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgG1UEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:04:16 -0400
Received: from localhost (mobile-166-175-62-240.mycingular.net [166.175.62.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BEF22065C;
        Tue, 28 Jul 2020 20:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595966655;
        bh=HK9+5a3U0dOMIeI24gLVh05vN2DyqhK9yZq8rvNgwyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VbcJ1DiA/1z3TFiwQzadcYJoGqKMQKFyWA1TZUuqLqRlwKX7rO/akEgvZGFokCMRN
         iLc4KnCOvB22INR4XqzgZ79U+P8DSSsYd91wqgoXQ8UKR2Df3eTCb0c6hwoutzkPkZ
         ON8qZGEOWQxNKLvHnqbEdOo7ywhzhaXU+mgzxvJ0=
Date:   Tue, 28 Jul 2020 15:04:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] farsync: use generic power management
Message-ID: <20200728200413.GA1857901@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 09:58:10AM +0530, Vaibhav Gupta wrote:
> The .suspend() and .resume() callbacks are not defined for this driver.
> Still, their power management structure follows the legacy framework. To
> bring it under the generic framework, simply remove the binding of
> callbacks from "struct pci_driver".

FWIW, this commit log is slightly misleading because .suspend and
.resume are NULL by default, so this patch actually is a complete
no-op as far as code generation is concerned.

This change is worthwhile because it simplifies the code a little, but
it doesn't convert the driver from legacy to generic power management.
This driver doesn't supply a .pm structure, so it doesn't seem to do
*any* power management.

> Change code indentation from space to tab in "struct pci_driver".
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/net/wan/farsync.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
> index 7916efce7188..15dacfde6b83 100644
> --- a/drivers/net/wan/farsync.c
> +++ b/drivers/net/wan/farsync.c
> @@ -2636,12 +2636,10 @@ fst_remove_one(struct pci_dev *pdev)
>  }
>  
>  static struct pci_driver fst_driver = {
> -        .name		= FST_NAME,
> -        .id_table	= fst_pci_dev_id,
> -        .probe		= fst_add_one,
> -        .remove	= fst_remove_one,
> -        .suspend	= NULL,
> -        .resume	= NULL,
> +	.name		= FST_NAME,
> +	.id_table	= fst_pci_dev_id,
> +	.probe		= fst_add_one,
> +	.remove		= fst_remove_one,
>  };
>  
>  static int __init
> -- 
> 2.27.0
> 
