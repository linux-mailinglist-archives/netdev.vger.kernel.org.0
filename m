Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371B5C323F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbfJALTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:19:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfJALTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:19:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A75D36014B; Tue,  1 Oct 2019 11:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569928752;
        bh=TBrp107vqvrm5nw0Dhs+vhjDes58fG5CBnoGfgq8iXI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VlXmjYoFUICdyB08W+dyJtvJIibcEmbJeznAgp567xSEcSHFhVFqh4kgmyHKDFnZX
         aapgFOwWYW3SHtISGkJVVB3HA3/CAFoA3a4c3IfiDeOLvaYZUqpX/2pmEcEVxh+h1X
         mK63UvmTF4CAszgawXTW41g90305LNcpCQHdNRY8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18BE8601D4;
        Tue,  1 Oct 2019 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569928751;
        bh=TBrp107vqvrm5nw0Dhs+vhjDes58fG5CBnoGfgq8iXI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=i/277xzREeUwLrLvgJRl7K3i3RaG8xSFWuw2pL4BELv8bKW64Bf5YlJiykvAyIN2v
         csY63r99jCRCIWjYLYKavWg0j2RJQXAiYWpsw1vnPrxjLI1vwT+3gWPfs2cknQKJKZ
         +fHDdkV/vJl4LcUyNEfncdNOZ7qKE1/u3eEjedxg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 18BE8601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k_hw: fix uninitialized variable data
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190926225604.9342-1-efremov@linux.com>
References: <20190926225604.9342-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Denis Efremov <efremov@linux.com>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Denis Efremov <efremov@linux.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001111912.A75D36014B@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 11:19:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Efremov <efremov@linux.com> wrote:

> Currently, data variable in ar9003_hw_thermo_cal_apply() could be
> uninitialized if ar9300_otp_read_word() will fail to read the value.
> Initialize data variable with 0 to prevent an undefined behavior. This
> will be enough to handle error case when ar9300_otp_read_word() fails.
> 
> Fixes: 80fe43f2bbd5 ("ath9k_hw: Read and configure thermocal for AR9462")
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

80e84f36412e ath9k_hw: fix uninitialized variable data

-- 
https://patchwork.kernel.org/patch/11163437/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

