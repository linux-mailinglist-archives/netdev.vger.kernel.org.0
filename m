Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620C52454E8
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 01:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgHOX2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 19:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgHOX2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 19:28:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F11C061786;
        Sat, 15 Aug 2020 16:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=+3j2NurwPM3LLxrk7n9WlrLr+R8X2st82AXnLII/9mU=; b=nfcU3KdFM6J0gPxwsYn2MRpRm1
        s+7c5u7qwtC0zIRgKB3w5F8WU3Ie+Dt3I4QaaGi1S3BXh6RK2kwaZr9DVtadYV2ncmE/2sgMpmpTL
        Ay/5x82fad558fGdrGD620aYgXQEEQW2u329vd53uxVNNLcXbixQykR75oOoGliUqLBFYXI/xuCH+
        u48fdJy4gSaOPr2UgsUaQ4ptVUj47Kx7US4pNRkiSHzr0+WFfSxJLOcir1c/B1zb/rCPnNAPW8Pvr
        BZ4HvzQMFigvbfjjBysOBHD31CU/oSeUQb7chrq/SCu9pR+H+pO7wugRFCwzTNbqLGz8Z79nEFnAu
        l8Hixq4g==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k75b0-0004qk-Or; Sat, 15 Aug 2020 23:28:19 +0000
Subject: Re: [PATCH v5 5/6] can: ctucanfd: CTU CAN FD open-source IP core -
 platform/SoC support.
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>
References: <cover.1597518433.git.ppisa@pikron.com>
 <4ceda3a9d68263b4e0dfe66521a46f40b2e502f7.1597518433.git.ppisa@pikron.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <73e3dad8-9ab7-2f8f-312c-1957b4572b08@infradead.org>
Date:   Sat, 15 Aug 2020 16:28:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4ceda3a9d68263b4e0dfe66521a46f40b2e502f7.1597518433.git.ppisa@pikron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/20 12:43 PM, Pavel Pisa wrote:
> diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
> index e1636373628a..a8c9cc38f216 100644
> --- a/drivers/net/can/ctucanfd/Kconfig
> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
>  	  PCIe board with PiKRON.com designed transceiver riser shield is available
>  	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
>  
> +config CAN_CTUCANFD_PLATFORM
> +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> +	depends on OF

Can this be
	depends on OF || COMPILE_TEST
?

> +	help
> +	  The core has been tested together with OpenCores SJA1000
> +	  modified to be CAN FD frames tolerant on MicroZed Zynq based
> +	  MZ_APO education kits designed by Petr Porazil from PiKRON.com
> +	  company. FPGA design https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.
> +	  The kit description at the Computer Architectures course pages
> +	  https://cw.fel.cvut.cz/b182/courses/b35apo/documentation/mz_apo/start .
> +
>  endif


-- 
~Randy

