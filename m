Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1527B2542EC
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgH0J7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:59:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15506 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgH0J7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 05:59:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598522352; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fhMcbUOYh9p7lWF3+leL4Aq7EqLUoprRCTvF3e6oeDw=;
 b=YqkAGqnoXqCxsTUoGTgJPXKlSihsIubpfaVHanax3q12dHLpFR8DTA+jC1Z80ByVizZhNbPG
 65co7u6rHmd2fmgjmZWyv8iK7VeSukczMyObb6crYcTswC4GQ8GELiW5WQ1nAponK2sfNdWQ
 fV6rCvEmlD6z2kS8wP2yBme5R3Q=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f4783ed797ad9909bb13617 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 09:59:09
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 630E9C433A1; Thu, 27 Aug 2020 09:59:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F49FC433CA;
        Thu, 27 Aug 2020 09:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F49FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Clean up some err and dbg messages
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200819071853.113185-1-christophe.jaillet@wanadoo.fr>
References: <20200819071853.113185-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827095908.630E9C433A1@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 09:59:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> The error message if 'pci_set_consistent_dma_mask()' fails is misleading.
> The function call uses 32 bits, but the error message reports 64.
> 
> Moreover, according to the comment above 'dma_set_mask_and_coherent()'
> definition, such an error can never happen.
> 
> So, simplify code, axe the misleading message and use
> 'dma_set_mask_and_coherent()' instead of 'dma_set_mask()' +
> 'dma_set_coherent_mask()'
> 
> While at it, make some clean-up:
>    - add # when reporting allocated length to be consistent between
>      functions
>    - s/consistent/coherent/
>    - s/unsigned int/u32/ to be consistent between functions
>    - align some code
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-drivers-next.git, thanks.

5f8a3ed38bec mwifiex: Clean up some err and dbg messages

-- 
https://patchwork.kernel.org/patch/11723131/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

