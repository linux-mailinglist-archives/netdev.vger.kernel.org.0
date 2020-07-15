Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CBB220A38
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgGOKjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:39:19 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:14411 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgGOKjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:39:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594809558; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=lAvnqX/ZVMt/mESdc2pgjD3f4/qNilQWsHcdnTWed+w=;
 b=uOVzAsDJ4qMdUU0/U/35LkW9Qt3aN35eNwrwUJs6Lhwo1YU8E12iCyiPxLElcGSSJHksTL/G
 +9OmHuKK6oQc+8E4HcRPx1G9o6PNg7OHL5Ho8cBbUoWiKqs4/jo4QEwYgdigXtkPRCqCxcxa
 CFl3a5HfnbEHp6xuvqoeOZepaNM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n17.prod.us-east-1.postgun.com with SMTP id
 5f0edcd3d3d65084226d1d09 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:39:15
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B89A0C433A0; Wed, 15 Jul 2020 10:39:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9C855C433C6;
        Wed, 15 Jul 2020 10:39:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9C855C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] adm8211: use generic power management
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200629035031.169670-1-vaibhavgupta40@gmail.com>
References: <20200629035031.169670-1-vaibhavgupta40@gmail.com>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715103913.B89A0C433A0@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:39:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:

> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states.
> 
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
> 
> In the case of adm8211, after removing PCI helper functions, .suspend()
> and .resume() became empty-body functions. Hence, define them NULL and
> use dev_pm_ops.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

04bceecdf1e8 adm8211: use generic power management

-- 
https://patchwork.kernel.org/patch/11632321/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

