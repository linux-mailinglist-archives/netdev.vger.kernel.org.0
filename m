Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CA23B924
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgHDKzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:55:47 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:12824 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729586AbgHDKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:55:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596538544; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=NGq0DCBsLcz21PG3KWrMgTLdFyeLDn7XuUR8AHEhbkk=; b=Nfjt7ag6Gw2w3v9W+s0QdITh4Zyla+UT24F7RXeRo8x+Rj7I6QqMDOTT3f23N72WESXpsQjX
 80PGe5/d0auFA1Euo6S0VNgNs9h7BeJiu0cq6wl5nekfMVarcaV4Qm2ACgyTk02B+c33MTHx
 UIzXrwTS2XuEJjp9iANOySSGWFo=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-east-1.postgun.com with SMTP id
 5f293eaf2c24b37bbec0363e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 04 Aug 2020 10:55:43
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DBE37C433CA; Tue,  4 Aug 2020 10:55:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1D74C433C9;
        Tue,  4 Aug 2020 10:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1D74C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-08-02
References: <20200802190136.CB524C433CA@smtp.codeaurora.org>
        <20200803.161852.1328879920773355611.davem@davemloft.net>
        <87r1sncavb.fsf@codeaurora.org>
Date:   Tue, 04 Aug 2020 13:55:35 +0300
In-Reply-To: <87r1sncavb.fsf@codeaurora.org> (Kalle Valo's message of "Tue, 04
        Aug 2020 07:07:20 +0300")
Message-ID: <87imdyadeg.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> David Miller <davem@davemloft.net> writes:
>
>> From: Kalle Valo <kvalo@codeaurora.org>
>> Date: Sun,  2 Aug 2020 19:01:36 +0000 (UTC)
>>
>>> here's a pull request to net-next tree, more info below. Please let me know if
>>> there are any problems.
>>
>> There are many several non-trivial mt76 conflicts, can you please sort
>> this out and send me another pull request?
>
> Yeah, I noticed the same and I tried to explain how to fix those in the
> signed tag:
>
> ----------------------------------------------------------------------
> This pull request causes conflicts in four files in
> drivers/net/wireless/mediatek/mt76/mt7615/, here is how I fixed those:
>
> * usb.c: take the hunk which uses mt7663_usb_sdio_tx_*() functions
>
> * mt7615.h: remove either one of the duplicate (and identical) enum tx_pkt_queue_idx
>
> * mt7615.h: take the hunk which has mt7615_mutex_acquire/release() functions
>
> * main.c: take the hunk which uses mt7615_mutex_acquire/release()
>
> * mac.c: take the hunk which uses is_mmio
> ----------------------------------------------------------------------
>
> By following those instructions it shouldn't take more than few minutes
> to fix the conflicts.
>
> Or would you prefer that I fix those differently, for example by pulling
> net-next to wireless-drivers-next before I send the pull request? Just
> let me know what you prefer.

After thinking a bit more I realised that the easiest is that if I merge
wireless-drivers to wireles-drivers-next and fix the conflict then, and
after that send you a new pull request.

So please drop this pull request, I'll send you a new one shortly.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
