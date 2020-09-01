Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA124258AEC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgIAJDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:03:48 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:43295 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbgIAJDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:03:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598951027; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Oe/mAJbGLEYEvHBdYOsb7AGn7B8PA1zzDH2N9F8Jb30=;
 b=jbVGqPKFMIHzePABZDz1T73ooii8Fj83Gu0tmntEtYDjepKxpUdynnsRphYZED4AYY64n0Eh
 X2kyiVlIIkzoAMCXKEA1TSHGHwcMdu6/LYdJU+20QkQFEY0/4+rWtvl8toc4K5pUGqtLhV9M
 J74Jua0ALGJrLV7zbiKX7I4nDyk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f4e0e57947f606f7e523e3c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:03:19
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F875C433CA; Tue,  1 Sep 2020 09:03:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DA470C433C6;
        Tue,  1 Sep 2020 09:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DA470C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [01/28] hostap: Mark 'freq_list' as __maybe_unused
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200819072402.3085022-2-lee.jones@linaro.org>
References: <20200819072402.3085022-2-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Jouni Malinen <j@w1.fi>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901090318.3F875C433CA@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:03:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> 'freq_list' is used in some source files which include hostap.h, but
> not all.  The compiler complains about the times it's not used.  Mark
> it as __maybe_used to tell the compiler that this is not only okay,
> it's expected.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/net/wireless/intersil/hostap/hostap_80211_tx.c:9:
>  drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
>  In file included from drivers/net/wireless/intersil/hostap/hostap_main.c:31:
>  drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
>  In file included from drivers/net/wireless/intersil/hostap/hostap_proc.c:10:
>  drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
>  In file included from drivers/net/wireless/intersil/hostap/hostap_hw.c:50,
>  from drivers/net/wireless/intersil/hostap/hostap_cs.c:196:
>  At top level:
>  drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
>  In file included from drivers/net/wireless/intersil/hostap/hostap_hw.c:50,
>  from drivers/net/wireless/intersil/hostap/hostap_pci.c:221:
>  At top level:
>  drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
>  In file included from drivers/net/wireless/intersil/hostap/hostap_hw.c:50,
>  from drivers/net/wireless/intersil/hostap/hostap_plx.c:264:
>  At top level:
>  drivers/net/wireless/intersil/hostap/hostap.h:11:19: warning: ‘freq_list’ defined but not used [-Wunused-const-variable=]
> 
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

10 patches applied to wireless-drivers-next.git, thanks.

34537d4924ba hostap: Mark 'freq_list' as __maybe_unused
470d48c1c4c6 rsi: Fix some kernel-doc issues
2fc4c9ff1606 rsi: File header should not be kernel-doc
9833f5034597 libertas_tf: Demote non-conformant kernel-doc headers
25ced81e288d wlcore: cmd: Fix some parameter description disparities
9554663b8c57 libertas_tf: Fix a bunch of function doc formatting issues
6182abd858f7 iwlegacy: debug: Demote seemingly unintentional kerneldoc header
debdbb0c1b20 hostap: hostap_ap: Mark 'txt' as __always_unused
e2eb189e7660 cw1200: wsm: Remove 'dummy' variables
f696d724358c libertas: Fix 'timer_list' stored private data related dot-rot

-- 
https://patchwork.kernel.org/patch/11723193/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

