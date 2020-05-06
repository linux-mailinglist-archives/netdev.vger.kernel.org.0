Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABCC1C6C1E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgEFIor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:44:47 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:50029 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728984AbgEFIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:44:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754686; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=A0uHUic2syQujRpdYODhDdBPb69QIhvyQafAGfZ0Y/U=;
 b=RA/So7DzEtb7J9YK0yaa2JDrQGtvvkuIzSxSVdtbyUseQknLGlBkHIpvnKWEyd2yNPuD43F/
 2fZ+l1Jjvq5eF+Xqyssa9ZZnEOapwhHAqPqf6OTpxQ+ohBE4jaYvSprEHn2rcxefuZst9DSM
 oCTC4rt1TsBOkm3nCx8pdMTZS10=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb278fa.7f72dee7dea0-smtp-out-n03;
 Wed, 06 May 2020 08:44:42 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A123EC433BA; Wed,  6 May 2020 08:44:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28297C433BA;
        Wed,  6 May 2020 08:44:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28297C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas_tf: avoid a null dereference in pointer priv
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200501173900.296658-1-colin.king@canonical.com>
References: <20200501173900.296658-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Steve deRosier <derosier@cal-sierra.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084442.A123EC433BA@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:44:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently there is a check if priv is null when calling lbtf_remove_card
> but not in a previous call to if_usb_reset_dev that can also dereference
> priv.  Fix this by also only calling lbtf_remove_card if priv is null.
> 
> It is noteable that there don't seem to be any bugs reported that the
> null pointer dereference has ever occurred, so I'm not sure if the null
> check is required, but since we're doing a null check anyway it should
> be done for both function calls.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: baa0280f08c7 ("libertas_tf: don't defer firmware loading until start()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

049ceac308b0 libertas_tf: avoid a null dereference in pointer priv

-- 
https://patchwork.kernel.org/patch/11523055/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
