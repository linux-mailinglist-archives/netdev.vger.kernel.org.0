Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427B41F17F2
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 13:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgFHLi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 07:38:59 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:36424 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729561AbgFHLi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 07:38:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591616335; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=UlNfDGogKCJ2Hte3WfYZUyoDNhoWUwvyIBaQzivZeyg=; b=pY9K81crIXaKvri2Dj/J2kiyKCzV1V1H5KtIXdNwrdBqYhFzJnWPWqQIPf+vQVPH2FHeK/PJ
 NETBQ99XZWOzDSbmIMfhN8gf8ujJ6QQf4H4XzDK5OuTwlW9bdE3Pnz39IVzbOgtNQjSyHdR3
 fBpP5KAsmPbS7iyFAHienypTFe0=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n12.prod.us-east-1.postgun.com with SMTP id
 5ede234a8bec5077688023ce (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Jun 2020 11:38:50
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B8DF7C433A1; Mon,  8 Jun 2020 11:38:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 920A6C433CA;
        Mon,  8 Jun 2020 11:38:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 920A6C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Evan Green <evgreen@chromium.org>
Cc:     Govind Singh <govinds@qti.qualcomm.com>, kuabhs@google.com.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        Michal Kazior <michal.kazior@tieto.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: Acquire tx_lock in tx error paths
References: <20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid>
Date:   Mon, 08 Jun 2020 14:38:43 +0300
In-Reply-To: <20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid>
        (Evan Green's message of "Thu, 4 Jun 2020 10:59:11 -0700")
Message-ID: <87v9k1iy7w.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Evan Green <evgreen@chromium.org> writes:

> ath10k_htt_tx_free_msdu_id() has a lockdep assertion that htt->tx_lock
> is held. Acquire the lock in a couple of error paths when calling that
> function to ensure this condition is met.
>
> Fixes: 6421969f248fd ("ath10k: refactor tx pending management")
> Fixes: e62ee5c381c59 ("ath10k: Add support for htt_data_tx_desc_64
> descriptor")

Fixes tag should be in one line, I fixed that in the pending branch.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
