Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5197D09D6
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfJII3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:29:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfJII3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:29:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9AF8D61A2A; Wed,  9 Oct 2019 08:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609740;
        bh=/+ADSHdMe9QqRvPmDWo/EMVMC8TdUcAE1DWYnBOuPh0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BvmQ6tkeZGmczKgcchKZgIZVrWZ1q6FVoWo0tVNy2c5gR1mTy16eouiV/y+0A8CB7
         6ZcBVlFufE1VfmdPRX9PK62ceKIe3aqo3YaiaN23Rj0EcE4MyQQkKECS7otTdCb4Ex
         fMRkCQYqMuQbWX6K8/uZ2+VV0cfqGbXssuRBbXiA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6110960EA5;
        Wed,  9 Oct 2019 08:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609740;
        bh=/+ADSHdMe9QqRvPmDWo/EMVMC8TdUcAE1DWYnBOuPh0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KhmuRxUVHcS3EuaFI11ln2kvtxwy3vs84uaIDnAM6AEkm/pJ68T32fBXF9A2f/9vn
         Cbb3KZTq/c3ATk5zgfl5+aM1sddESPztXO5TAbB90gzdC1RANodKEOdvYHBeiUIyex
         8x3TXxcbPBAsDOm4zNOssSxASN9NNnW3oMa55B6M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6110960EA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: make arrays static, makes object smaller
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191007135313.8443-1-colin.king@canonical.com>
References: <20191007135313.8443-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082900.9AF8D61A2A@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:29:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate const arrays on the stack but instead make them
> static. Makes the object code smaller by 60 bytes.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   15133	   8768	      0	  23901	   5d5d	realtek/rtl8xxxu/rtl8xxxu_8192e.o
>   15209	   6392	      0	  21601	   5461	realtek/rtl8xxxu/rtl8xxxu_8723b.o
>  103254	  31202	    576	 135032	  20f78	realtek/rtl8xxxu/rtl8xxxu_core.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   14861	   9024	      0	  23885	   5d4d	realtek/rtl8xxxu/rtl8xxxu_8192e.o
>   14953	   6616	      0	  21569	   5441	realtek/rtl8xxxu/rtl8xxxu_8723b.o
>  102986	  31458	    576	 135020	  20f6c	realtek/rtl8xxxu/rtl8xxxu_core.o
> 
> (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Chris Chiu <chiu@endlessm.com>

Patch applied to wireless-drivers-next.git, thanks.

314bf64d1266 rtl8xxxu: make arrays static, makes object smaller

-- 
https://patchwork.kernel.org/patch/11177577/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

