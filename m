Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE6F108D81
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfKYMCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:02:52 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:52762
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbfKYMCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574683371;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=z05eV/FaCW+MjIgQc7d1cmaIUFV3/DRVHnHkzXMroCA=;
        b=OBeQd3oqLK026hOUymyIoM5F2mb1K3QFDsh7qSCEIZIXttUffQPFI2Vzh2t9xXWM
        jyq7RqPk7tTjzOzS8LpJ6Hfr+kpvhpBiSDKmS5zb5X0Vn/zlr2x121uBloxVMXyzuje
        iDj/QQ3f2HjWlbmUpBEFChkcbSKC0PEVzJ61gm5s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574683371;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=z05eV/FaCW+MjIgQc7d1cmaIUFV3/DRVHnHkzXMroCA=;
        b=Xd3xHjTqMKA315fi0az72GaYOkIc/dLtlqDobZSh9oX5GyW0EYTyd26GWY4YnWC3
        xGiV/MkeLYcY2C2VpLw3sOSh4pKZqSY4pKRj6LJVzFkqk5QvMEgsmESRk0/CFQ9BW9C
        4qs4tkMq6xHiy/38LJpUJOtvSlVnqQknC3D08LWE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 01470C447B6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Fix qmi init error handling
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191113154016.42836-1-jeffrey.l.hugo@gmail.com>
References: <20191113154016.42836-1-jeffrey.l.hugo@gmail.com>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea27166f3-88061552-0765-4651-8b88-013cc0541d4d-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 12:02:51 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeffrey Hugo <jeffrey.l.hugo@gmail.com> wrote:

> When ath10k_qmi_init() fails, the error handling does not free the irq
> resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
> (re-)register irqs which are already registered.
> 
> Fix this by doing a power off since we just powered on the hardware, and
> freeing the irqs as error handling.
> 
> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f8a595a87e93 ath10k: Fix qmi init error handling

-- 
https://patchwork.kernel.org/patch/11242133/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

