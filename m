Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DDD21D8BC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgGMOmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:42:00 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28376 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729918AbgGMOmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 10:42:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594651319; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=njq6ToEc9s/UCKrW6LoyB1yXjuQt4PugDt/wNabnWog=; b=gRf3asfSf2u09CNPEHTt37McXPlxONpVi6hrvmT9b1p+ZqXXAhIOFe+DFEWl+6gtQ/0wSt1I
 M5y93HHSxexMMAWdd7gPanZO5m0mgLYRltcloVB4UIsq6JpOLb2JwWwysCCgIB6OMgGRnkjc
 6IY8n+NulRBHlwgifZNUSSX8C34=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f0c72ad512812c070389aae (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 13 Jul 2020 14:41:49
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62636C43395; Mon, 13 Jul 2020 14:41:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D14A4C433C8;
        Mon, 13 Jul 2020 14:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D14A4C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1 0/2] ipw2x00: use generic power management
References: <20200629072525.156154-1-vaibhavgupta40@gmail.com>
Date:   Mon, 13 Jul 2020 17:41:44 +0300
In-Reply-To: <20200629072525.156154-1-vaibhavgupta40@gmail.com> (Vaibhav
        Gupta's message of "Mon, 29 Jun 2020 12:55:23 +0530")
Message-ID: <87a703xys7.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vaibhav Gupta <vaibhavgupta40@gmail.com> writes:

> Linux Kernel Mentee: Remove Legacy Power Management.
>
> The purpose of this patch series is to remove legacy power management callbacks
> from amd ethernet drivers.
>
> The callbacks performing suspend() and resume() operations are still calling
> pci_save_state(), pci_set_power_state(), etc. and handling the power management
> themselves, which is not recommended.
>
> The conversion requires the removal of the those function calls and change the
> callback definition accordingly and make use of dev_pm_ops structure.
>
> All patches are compile-tested only.
>
> Vaibhav Gupta (2):
>   ipw2100: use generic power management
>   ipw2200: use generic power management
>
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 31 +++++---------------
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 30 +++++--------------

amd ethernet drivers? That must be a copy paste error. But no need to
resend because of this.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
