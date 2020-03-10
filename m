Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F85180AB8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCJVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgCJVng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 17:43:36 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B13222C3;
        Tue, 10 Mar 2020 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583876616;
        bh=qNP+FW/I+TLxnWBrzvqxTeOUd1RVImA8owJrzMv0s+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sI4gy5a98SUousQ6Ne2BnTyxNlgj2tG+UsbXrEhLYbGZJmos/NxVQump2xMW5Ryg0
         /JwgjWupSPiHRSnsrYsfbVp/RyXuQl2OREyilv05/g8/YcyEbS7bNsTh0stmn8rQvC
         EHmX1n41JRS6n/pdnM+ZhF5qmgsxGx9B2m7Ye8gs=
Date:   Tue, 10 Mar 2020 14:43:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Sunil Goutham <sgoutham@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: Re: [PATCH net-next 1/6] octeontx2-pf: Enable SRIOV and added VF
 mbox handling
Message-ID: <20200310144334.3fcbd4a8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1583866045-7129-2-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
        <1583866045-7129-2-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 00:17:20 +0530 sunil.kovvuri@gmail.com wrote:
> @@ -1313,6 +1701,61 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	return err;
>  }
>  
> +static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
> +{
> +	struct net_device *netdev = pci_get_drvdata(pdev);
> +	struct otx2_nic *pf = netdev_priv(netdev);
> +	int ret;
> +
> +	if (numvfs > pf->total_vfs)
> +		numvfs = pf->total_vfs;

Core should do this kind of checking for you, please remove.
