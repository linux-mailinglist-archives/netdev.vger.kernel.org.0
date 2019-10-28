Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753B2E6CC9
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 08:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfJ1HRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 03:17:06 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:39440 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730751AbfJ1HRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 03:17:06 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id A3DCE60EFBC;
        Mon, 28 Oct 2019 08:17:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1572247022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GpScNA8k1wNynPH+2njANhiKTtFuRG/+CoTwLULQUMU=;
        b=Z2OfiMrOL9ZuQSbl5Y5PfE3jj8D/dJHYYnSrGfNykqXTg8Hn+od9ZCtFcczuOn6l81KZ71
        0RZ0D5CnvdfX6RN/yHD7doRpkMl1h/OrUdqc+PU/L22Cc1KYAtghkloLVK7cnhDw225ed3
        9yBtoF0hOEig9jRK9QHbR8wgq/V2JFM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Oct 2019 08:17:02 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        hkallweit1@gmail.com, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 wireless-drivers 0/2] fix mt76x2e hangs on U7612E
 mini-pcie
In-Reply-To: <cover.1572204430.git.lorenzo@kernel.org>
References: <cover.1572204430.git.lorenzo@kernel.org>
Message-ID: <5c6bdfd65ae3178cff2f55233e9e8465@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.10.2019 20:53, Lorenzo Bianconi wrote:
> Various mt76x2e issues have been reported on U7612E mini-pcie card [1].
> On U7612E-H1 PCIE_ASPM causes continuous mcu hangs and instability and
> so patch 1/2 disable it by default.
> Moreover mt76 does not properly unmap dma buffers for non-linear skbs.
> This issue may result in hw hangs if the system relies on IOMMU.
> Patch 2/2 fix the problem properly unmapping data fragments on
> non-linear skbs.
> 
> Changes since v2:
> - fix compilation error if PCI support is not compiled
> 
> Changes since v1:
> - simplify buf0 unmap condition
> - use IS_ENABLED(CONFIG_PCIEASPM) instead of ifdef CONFIG_PCIEASPM
> - check pci_disable_link_state return value
> 
> [1]:
> https://lore.kernel.org/netdev/deaafa7a3e9ea2111ebb5106430849c6@natalenko.name/
> 
> 
> Lorenzo Bianconi (2):
>   mt76: mt76x2e: disable pcie_aspm by default
>   mt76: dma: fix buffer unmap with non-linear skbs
> 
>  drivers/net/wireless/mediatek/mt76/Makefile   |  2 +
>  drivers/net/wireless/mediatek/mt76/dma.c      |  6 ++-
>  drivers/net/wireless/mediatek/mt76/mt76.h     |  6 ++-
>  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
>  drivers/net/wireless/mediatek/mt76/pci.c      | 46 +++++++++++++++++++
>  5 files changed, 58 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/pci.c

So, works fine for me. Checked with 5.3 and additional include fix I've 
mentioned previously.

With that, for the whole series feel free to add:

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

Thank you.

-- 
   Oleksandr Natalenko (post-factum)
