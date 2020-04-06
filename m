Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C9A19F64F
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgDFNCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:02:15 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:15198 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728118AbgDFNCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:02:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586178134; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=9tdkGmLU02zbWVLGYy5PSq5hUqznxpWzvhiGLCd+WxU=; b=EwooMF7PXTkRFceRtqT27OtJNFGgjEuFKla58jqxrLbbctsixGOnTXNe4+UYmPPxQDsqyQHd
 nq++8JIgVWKW4sLygjzOoGU7mASFU4fMO0FHpHd31WtaTtIn3kuZARJCRuMcMHiTtBUFWNF4
 BuWv7QmJ4ySx2Hg05HXOfFlG3Ug=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b2855.7f0ef81547d8-smtp-out-n03;
 Mon, 06 Apr 2020 13:02:13 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75195C433F2; Mon,  6 Apr 2020 13:02:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28F6BC433D2;
        Mon,  6 Apr 2020 13:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28F6BC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <pradeepc@codeaurora.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: thermal: Fix build error without CONFIG_THERMAL
References: <20200403083414.31392-1-yuehaibing@huawei.com>
Date:   Mon, 06 Apr 2020 16:02:07 +0300
In-Reply-To: <20200403083414.31392-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Fri, 3 Apr 2020 16:34:14 +0800")
Message-ID: <87mu7ozs1c.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> writes:

> drivers/net/wireless/ath/ath11k/thermal.h:45:1:
>  warning: no return statement in function returning non-void [-Wreturn-ty=
pe]
> drivers/net/wireless/ath/ath11k/core.c:416:28: error:
>  passing argument 1 of =E2=80=98ath11k_thermal_unregister=E2=80=99 from i=
ncompatible pointer type [-Werror=3Dincompatible-pointer-types]
>
> Add missing return 0 in ath11k_thermal_set_throttling,
> and fix ath11k_thermal_unregister param type.

These are warnings, no? "build error" and "compiler warning" are
different things, the former breaks the whole build which is super
critical, but I'll queue this to v5.7 nevertheless. And I'll change the
title to:

ath11k: fix compiler warning without CONFIG_THERMAL

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
