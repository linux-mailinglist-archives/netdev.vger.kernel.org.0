Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226B220A32
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgGOKix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:38:53 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:12646 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728223AbgGOKiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:38:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594809531; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=lmuj4L635dOFeW6CLqdMxBr0KmO6bVimi9ks4elW24c=;
 b=I69gEldR+8uLwtuzdRt1Cp5BNiJb8xIeXyZ/GkzygDm/L27pTTAPzu3X4FHlbZ+eRGsMsrxQ
 bV6x9sQ4twMa1/sRfNACQSRixRQiGmb5dMcvBUn9WAQkjM3ue7lynTopiPRL+zLCKbNT9jCE
 5ohepSi8tczT+Px0jkXLBFQGYcE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f0edc972991e765cd7226da (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:38:15
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1A992C433A1; Wed, 15 Jul 2020 10:38:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC775C433CA;
        Wed, 15 Jul 2020 10:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC775C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] rtl818x_pci: use generic power management
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200623094454.12427-1-vaibhavgupta40@gmail.com>
References: <20200623094454.12427-1-vaibhavgupta40@gmail.com>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        skhan@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715103815.1A992C433A1@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:38:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:

> Earlier, drivers had to manage the device's power states, and related
> operations, themselves. With the generic approach, these are done by PCI
> core.
> 
> The only driver-specific jobs, .suspend() and .resume() doing were invoking
> PCI helper functions pci_save/restore_state() and
> pci_set_power_state(). This is not recommeneded as PCI core takes care of
> that. Hence they became empty-body functions, thus define them NULL.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

ef6425107ccc rtl818x_pci: use generic power management

-- 
https://patchwork.kernel.org/patch/11620213/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

