Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF863631BA
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhDQSCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:02:14 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:49303 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbhDQSCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 14:02:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618682506; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=oGRlOSXczuP0DJCaBHzbDqORGAinXBLa+Yc9c3vGhJg=;
 b=Lg1QmFCTmeeZVI6ZauvtBQU3gb9LdL87UMJ3RhVLy/deUfR1dEaSIl4KdxmFFbi7Thzk9Zhn
 sR6O5kHi6xOWHFcdeLMz1QdczQxdTTdhDMzVchTODu8tr/96MUYaIc4baatqs+QJddmGxYGm
 RAcHOuyUq9LjlWWdsAQV7PxaspA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 607b2285c39407c327a875d3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 18:01:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F29E0C43460; Sat, 17 Apr 2021 18:01:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA67CC433F1;
        Sat, 17 Apr 2021 18:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA67CC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 4/5] libertas: avoid -Wempty-body warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210322104343.948660-4-arnd@kernel.org>
References: <20210322104343.948660-4-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jason Yan <yanaijie@huawei.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417180140.F29E0C43460@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 18:01:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building without mesh supports shows a couple of warnings with
> 'make W=1':
> 
> drivers/net/wireless/marvell/libertas/main.c: In function 'lbs_start_card':
> drivers/net/wireless/marvell/libertas/main.c:1068:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  1068 |                 lbs_start_mesh(priv);
> 
> Change the macros to use the usual "do { } while (0)" instead to shut up
> the warnings and make the code a litte more robust.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

01414f8882f9 libertas: avoid -Wempty-body warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210322104343.948660-4-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

