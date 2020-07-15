Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40316220A2A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbgGOKhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:37:15 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:14411 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731206AbgGOKhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:37:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594809432; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=pYgx74LtrBLVD12x3ELyZuAqEdnOVxhRlDanXsj1kC8=;
 b=HxrHT6LxVCaQib/TGJoj59jcY7DvMJ4G4oMX9lB7o3Pg0crBu4RsUdiInBArTV+x77+3xMnj
 8Hom20rAVj3h1idrhMWhO/reeaoUJBEA3GwGm1VR89DggRuPPrZT7IFGvzsgT/95FknQqtO3
 brNWhQeJ7rBnY8LdwsV4p39XQJ4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f0edc4db35196d59d5e5301 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:37:01
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5B429C43449; Wed, 15 Jul 2020 10:37:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 639D1C433CA;
        Wed, 15 Jul 2020 10:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 639D1C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/16] b43: Remove uninitialized_var() usage
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200620033007.1444705-5-keescook@chromium.org>
References: <20200620033007.1444705-5-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715103701.5B429C43449@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:37:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], just initialize this variable to NULL.
> No later NULL deref is possible due to the early returns outside of the
> (phy->rev >= 7 && phy->rev < 19) case, which explicitly tests for NULL.
> 
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Fixes: 58619b14d106 ("b43: move under broadcom vendor directory")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

2 patches applied to wireless-drivers-next.git, thanks.

800e7a205a0f b43: Remove uninitialized_var() usage
f8279dad4e36 rtlwifi: rtl8192cu: Remove uninitialized_var() usage

-- 
https://patchwork.kernel.org/patch/11615573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

