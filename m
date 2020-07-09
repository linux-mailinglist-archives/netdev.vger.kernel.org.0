Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DB021A8D4
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGIUWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:22:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBAA20720;
        Thu,  9 Jul 2020 20:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594326123;
        bh=OYeLKoMNjHxFXK9TIPTsit7mcIDOCixLaNguIZpV818=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MzrNU8+Xg7jU+oDz9fhB1lzx/9X5jyqNBpmvV2b15u9crM1qCHJ1Fm/ISEYTR6NlE
         NZKoDkZ/XlxT2eKqIihC1TqQ6XK9W4uSwFFEMbWGrYt9GgxiVJOxZukyjVfVg+gT8L
         EP+gqihd5ZGbMtX47VXTElanLORzLWgyobU3uDMk=
Date:   Thu, 9 Jul 2020 13:22:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V1 net-next 5/8] net: ena: add support for traffic
 mirroring
Message-ID: <20200709132200.60db5881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594321503-12256-6-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
        <1594321503-12256-6-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 22:05:00 +0300 akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Add support for traffic mirroring, where the hardware reads the
> buffer from the instance memory directly.
> 
> Traffic Mirroring needs access to the rx buffers in the instance.
> To have this access, this patch:
> 1. Changes the code to map and unmap the rx buffers bidirectionally.
> 2. Enables the relevant bit in driver_supported_features to indicate
>    to the FW that this driver supports traffic mirroring.
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

Any more information? You map rx buffers bidirectionally, doesn't mean
the instance doesn't modify the buffer causing the mirror to see a
modified frame..  Does the instance wait somehow for the mirror to be
done, or is the RX completion not generated until mirror operation is
done?
