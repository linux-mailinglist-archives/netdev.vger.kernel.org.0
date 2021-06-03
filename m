Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA2D399E24
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFCJxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:53:12 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:21801 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhFCJxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 05:53:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622713887; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=poSSyi8cMM0a7SyTqY0avbbxnfzwDuJlj6c4rORP8Qo=; b=srvQ+5Q9mS65CIzGqViOKJQKgItYLfMhEFeTGogwJtKB9hoIQmVci5goqZW2KoFyZgYM3o/7
 YLKxbB76I56DQreMa5NdHL3NcDQIgbNxppmy9JhHv8nvRjb9KgUOx13XYBTxel+gwiYQacel
 0fBgVduOMvlzhvsb8EjvwnnaQaM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60b8a6092eaeb98b5e46cb6c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Jun 2021 09:51:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F1DCFC433D3; Thu,  3 Jun 2021 09:51:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C3EFC433D3;
        Thu,  3 Jun 2021 09:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2C3EFC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     chris.chiu@canonical.com
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8xxxu: unset the hw capability HAS_RATE_CONTROL
References: <20210531090254.86830-1-chris.chiu@canonical.com>
        <20210531090254.86830-2-chris.chiu@canonical.com>
Date:   Thu, 03 Jun 2021 12:51:00 +0300
In-Reply-To: <20210531090254.86830-2-chris.chiu@canonical.com> (chris chiu's
        message of "Mon, 31 May 2021 17:02:53 +0800")
Message-ID: <878s3r1dkr.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chris.chiu@canonical.com writes:

> From: Chris Chiu <chris.chiu@canonical.com>
>
> The HAS_RATE_CONTROL hw capability needs to be unset for the rate
> control of mac80211 to work. Since the ieee80211_start_tx_ba_session
> is started by the method .get_rate of rate_control_ops. We need to
> unset it so the ampdu can be handled by mac80211.

The commit log is not really describing in detail _why_ you are doing
this. Switching the rate control from hardware/firmware to mac80211 is a
major change and I want to see a good explanation why this is the right
thing to do and does not cause any regressions.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
