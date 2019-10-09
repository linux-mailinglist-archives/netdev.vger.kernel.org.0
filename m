Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC685D09D1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfJII2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:28:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJII2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:28:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B8BC61AC6; Wed,  9 Oct 2019 08:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609712;
        bh=HbZdDa2cOuuT9V7lXu+I+zSgZiv78NTVmAzMtH+i/9M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=K538711DcIhJnteovFc+JdlEiNz8SUHYidnlAfp6Gb6qnSJLjSrdb0KxuwRZTs9un
         qbNbyEa5+iBx05gnGWeqMUAgou/imCNgEdL7pjPwGoMvuJmxCGUUxP5KPN0EBq1gjN
         2/6yqPonn1gb4mVOr/qJnYmgBEugoGNhAeaymc6M=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2CF80602A9;
        Wed,  9 Oct 2019 08:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609710;
        bh=HbZdDa2cOuuT9V7lXu+I+zSgZiv78NTVmAzMtH+i/9M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=GwhbOQpX0nN5FqRep6gJ9G4j4uj/jE9vs51Jc0GzV/UNTdLpTeil51JcZK7RCUC5+
         1cDMabGFzmeYpTrD6YwB1NuEAgerDcnT5UwjE+ZD854Baes9OxLIFpTp3iaHDpIlSY
         PLPzDV2rpsAlgvABiJ8bHVRiPDMnaUApMuKBx9dw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2CF80602A9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlegacy: make array interval static, makes object smaller
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191007134113.5647-1-colin.king@canonical.com>
References: <20191007134113.5647-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082832.7B8BC61AC6@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:28:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array interval on the stack but instead make it
> static. Makes the object code smaller by 121 bytes.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>  167797	  29676	    448	 197921	  30521	wireless/intel/iwlegacy/common.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>  167580	  29772	    448	 197800	  304a8	wireless/intel/iwlegacy/common.o
> 
> (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

55047fb783e0 iwlegacy: make array interval static, makes object smaller

-- 
https://patchwork.kernel.org/patch/11177531/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

