Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6093414622
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfEFIY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:24:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfEFIY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:24:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0349460E41; Mon,  6 May 2019 08:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557131096;
        bh=CcStSjrO0gVGsOcZ+KnnAXuOwgsmdjWUfXEyxrzscwE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TPr27RmGJaEbJjwIbWL28kN1dLHSGJWLGaDb83v4W3h7WTje6INgnb2t1DtGLtTR/
         0X6dlULTaVMEtebKtKowTNasii11czcYJ1yWF85zXXJvF23QAgU9klY3ecTuyifhtO
         divp09Q5LeTLA9VMXEdd8zke+XpVWy+axtm6vmTI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (37-136-65-53.rev.dnainternet.fi [37.136.65.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA7DF60741;
        Mon,  6 May 2019 08:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557131095;
        bh=CcStSjrO0gVGsOcZ+KnnAXuOwgsmdjWUfXEyxrzscwE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i1KkOMmbsX4M0yNhzHTOAjfoTNmSJvMmW5iv3BFydA0Jyaj8ui26Ei/HiGiD3L4II
         PesZcD4LdQ8dXyyM3SSqcFO1w0Do/MCZIY6E5ENf3Ykp7zXTaarEo9HQkLr2+0+XCA
         jcr8MQLiAy+EF/TmcBG7xieW/bzFTNnIjizLpubY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA7DF60741
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ath9k: Return an error when ath9k_hw_reset() fails
References: <20190504100815.19876-1-baijiaju1990@gmail.com>
        <e47117d6-f918-1dd0-834e-d056534bfead@gmail.com>
Date:   Mon, 06 May 2019 11:24:51 +0300
In-Reply-To: <e47117d6-f918-1dd0-834e-d056534bfead@gmail.com> (Heiner
        Kallweit's message of "Sat, 4 May 2019 13:02:25 +0200")
Message-ID: <87zho0uh0s.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> On 04.05.2019 12:08, Jia-Ju Bai wrote:
>> ath9k_hw_reset() in ath9k_start() can fail, and in this case, 
>> ath9k_start() should return an error instead of executing the 
>> subsequent code.
>> 
> Such mechanical patches w/o understanding the code are always
> problematic. Do you have any proof that this error is fatal?
> I think it is not, else we wouldn't have this line:
> ah->reset_power_on = false;
> Also you should consider that a mutex and a spinlock are held.
> Maybe changing the error message to a warning would be more
> appropriate. But this I would leave to somebody being more
> familiar with this driver.

A very good point, thanks Heiner! I will drop this unless someone
familiar with ath9k says that this is ok.

-- 
Kalle Valo
