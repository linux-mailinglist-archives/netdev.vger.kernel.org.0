Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E375E1BCCA9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgD1TqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgD1TqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:46:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 356CB21835;
        Tue, 28 Apr 2020 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588103183;
        bh=+2VWgEuDpi6pXMSehuOBHcB3Cn46qEpp/NjHvGltuMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rRvwk29UYucfBJqlITTQpJ+eUbJtebtiMLk34Kzsk/SG1Jy6ji3cZwOrNor80Oxz6
         w9lfUO6KnTprQ+jXQ7OaQkwHF3sNDZxP19WJnK4yBVxQkjsUzilbWlu4KQW0ZvVtRv
         ErgZ2j9ImqTJVxCej8tumekVBEEWBsronJiVFRts=
Date:   Tue, 28 Apr 2020 12:46:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V2 net-next 11/13] net: ena: move llq configuration from
 ena_probe to ena_device_init()
Message-ID: <20200428124621.0ce3dc5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428072726.22247-12-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
        <20200428072726.22247-12-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 07:27:24 +0000 sameehj@amazon.com wrote:
> +	ena_dev->mem_bar = devm_ioremap_wc(&pdev->dev,
> +					   pci_resource_start(pdev, ENA_MEM_BAR),
> +					   pci_resource_len(pdev, ENA_MEM_BAR));

Is there anything that'd undo the mapping in case of reset?

The use of devm_ functions outside of probe seems questionable.
