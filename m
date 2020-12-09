Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF02D3DAC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgLIIlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:41:20 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:48527 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbgLIIlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:41:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607503259; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=RrM4bIzZ2fGvO4vBs9DF8kA4KkJ9a3AQeH6UER37Xro=; b=qO4/eRoplL3fqmBeZxDs7n5pkr7UPra/+keWva5jw4Rzn2kVF/Jwrv+m79toelAkT8rg7e7L
 pWxSSsbDc6iYUw+W2rgX7T8Go0okgoDUyWSInLH2pOtiuUX7RKAKLqo0vcxH63ct1C/9W8hT
 uKh/u/JKMlskR4WWiu8tJuYbf2s=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fd08d76a7e520c3aa91c1e7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Dec 2020 08:40:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 677B6C433C6; Wed,  9 Dec 2020 08:40:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D00A1C433C6;
        Wed,  9 Dec 2020 08:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D00A1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "lin ux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
References: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
Date:   Wed, 09 Dec 2020 10:40:10 +0200
In-Reply-To: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com> (Heiner
        Kallweit's message of "Wed, 9 Dec 2020 09:31:21 +0100")
Message-ID: <87360fcqz9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
> former one is declared as __must_check. However also some callers of
> pci_set_mwi() have a comment that it's an optional feature. I don't
> think there's much sense in this separation and the use of
> __must_check. Therefore remove pci_try_set_mwi() and remove the
> __must_check attribute from pci_set_mwi().
> I don't expect either function to be used in new code anyway.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> patch applies on top of pci/misc for v5.11

>  drivers/net/wireless/intersil/p54/p54pci.c    |  2 +-
>  .../intersil/prism54/islpci_hotplug.c         |  3 +--
>  .../wireless/realtek/rtl818x/rtl8180/dev.c    |  2 +-

For drivers/wireless:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
