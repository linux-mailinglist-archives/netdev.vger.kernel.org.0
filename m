Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A932357F7
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHBPOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:14:37 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:46321 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725853AbgHBPOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:14:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596381275; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=MN8hv/xfsAGGdQUHt7lfq4izDzLjyVfS5K7dU+XV1Pw=;
 b=WXL2ygTmkQJ3Y5yE+eyd7SG9ikg8b8IDWtsineD63rz7iWcI+xPyexkaCo/55GXtJ0AMBJqE
 nzwFKkgqPADKQEyoMk5wT0HIzTgk/ajWB1fBUB9ZjLBvtPhhy1/3Y3AT9uGs1jtPL/3jdljk
 ja780rxqyTfZnvtWMKh0COcxcuI=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5f26d846849144fbcb489de3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:14:14
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A7508C433CA; Sun,  2 Aug 2020 15:14:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6038C433C6;
        Sun,  2 Aug 2020 15:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B6038C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] rt2x00: pci: use generic power management
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200717110928.454867-1-vaibhavgupta40@gmail.com>
References: <20200717110928.454867-1-vaibhavgupta40@gmail.com>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802151414.A7508C433CA@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:14:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:

> Drivers using legacy PM have to manage PCI states and device's PM states
> themselves. They also need to take care of configuration registers.
> 
> With improved and powerful support of generic PM, PCI Core takes care of
> above mentioned, device-independent, jobs.
> 
> The callbacks make use of PCI helper functions like
> pci_save/restore_state(), pci_enable/disable_device() and
> pci_set_power_state() to do required operations. In generic mode, they are
> no longer needed.
> 
> Change function parameter in both .suspend() and .resume() to
> "struct device*" type. Use dev_get_drvdata() to get drv data.
> 
> The .suspend() callback is invoking rt2x00lib_suspend() which needs to be
> modified as generic rt2x00pci_suspend() has no pm_message_t type argument,
> passed to it, which is required by it according to its declaration.
> Although this variable remained unused in the function body. Hence, remove
> it from the function definition & declaration.
> 
> rt2x00lib_suspend() is also invoked by rt2x00usb_suspend() and
> rt2x00soc_suspend(). Thus, modify the functional call accordingly in their
> function body.
> 
> Earlier, .suspend() & .resume() were exported and were used by the
> following drivers:
>     - drivers/net/wireless/ralink/rt2x00/rt2400pci.c
>     - drivers/net/wireless/ralink/rt2x00/rt2500pci.c
>     - drivers/net/wireless/ralink/rt2x00/rt2800pci.c
>     - drivers/net/wireless/ralink/rt2x00/rt61pci.c
> 
> Now, we only need to bind "struct dev_pm_ops" variable to
> "struct pci_driver". Thus, make the callbacks static. Declare an
> "extern const struct dev_pm_ops" variable and bind PM callbacks to it. Now,
> export the variable instead and use it in respective drivers.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

560a218d1ce6 rt2x00: pci: use generic power management

-- 
https://patchwork.kernel.org/patch/11669881/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

