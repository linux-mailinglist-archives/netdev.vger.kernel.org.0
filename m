Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221B6EC755
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfKAROZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:14:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKAROY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:14:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55F4B1512960E;
        Fri,  1 Nov 2019 10:14:24 -0700 (PDT)
Date:   Fri, 01 Nov 2019 10:14:21 -0700 (PDT)
Message-Id: <20191101.101421.100734709965388023.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, ndanilov@marvell.com
Subject: Re: [PATCH net-next 03/12] net: atlantic: refactoring pm logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f7a1c4805413b5aa808881da5698aebd395739c0.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
        <f7a1c4805413b5aa808881da5698aebd395739c0.1572610156.git.irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 10:14:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Fri, 1 Nov 2019 12:17:16 +0000

> -static int aq_pci_suspend(struct pci_dev *pdev, pm_message_t pm_msg)
> +static int aq_suspend_common(struct device *dev, bool deep)
>  {
> -	struct aq_nic_s *self = pci_get_drvdata(pdev);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct aq_nic_s *nic = pci_get_drvdata(pdev);

Reverse christmas-tree here please, you don't use pdev other than here
in the declarations so you can just go:

> +	struct aq_nic_s *nic = pci_get_drvdata(to_pci_dev(dev));

> -static int aq_pci_resume(struct pci_dev *pdev)
> +static int atl_resume_common(struct device *dev, bool deep)
>  {
> -	struct aq_nic_s *self = pci_get_drvdata(pdev);
> -	pm_message_t pm_msg = PMSG_RESTORE;
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct aq_nic_s *nic = pci_get_drvdata(pdev);
> +	int ret;

Likewise.
