Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083123B9DA5
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhGBIor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:44:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:54380 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhGBIor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 04:44:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625215335; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=w3yBGSGoQ8cNaUpst5+zJFm90DXtuz3EZYf+rk4KsIk=; b=L+lEnrrV9QlBDJCCvkS8LF6wwI6JTKRIhHfkIhrtZ+nr3lOXw6uIHfOj+Se8eYncfaINLoyB
 rDYnvdPdpfxnWBslgCH2JKMZfGpkNeTEk/nJQb+0RG5s8ocOtO7aFnf3W/8j7RbgaS9Q2U+M
 L+nQLttZUdzw3xJnCvCsjJDLPd8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60ded15eec0b18a7455b8bec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 02 Jul 2021 08:42:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 570D9C4323A; Fri,  2 Jul 2021 08:42:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6DB36C433D3;
        Fri,  2 Jul 2021 08:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6DB36C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     chris.chiu@canonical.com
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu
In-Reply-To: <20210701163354.118403-1-chris.chiu@canonical.com> (chris chiu's
        message of "Fri, 2 Jul 2021 00:33:54 +0800")
References: <20210701163354.118403-1-chris.chiu@canonical.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 02 Jul 2021 11:41:58 +0300
Message-ID: <87v95thzu1.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chris.chiu@canonical.com writes:

> From: Chris Chiu <chris.chiu@canonical.com>
>
> There will be crazy numbers of interrupts triggered by 8188cu and
> 8192cu module, around 8000~10000 interrupts per second, on the usb
> host controller. Compare with the vendor driver source code, it's
> mapping to the configuration CONFIG_USB_INTERRUPT_IN_PIPE and it is
> disabled by default.
>
> Since the interrupt transfer is neither used for TX/RX nor H2C
> commands. Disable it to avoid the confusing interrupts for the
> 8188cu and 8192cu module which I only have for verification.

The last paragraph is not entirely clear for me, can you elaborate it
more? What do you mean with "confusing interrupts"? And is this fixing
an actual user visible bug or are you just reducing the number of
interrupts?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
