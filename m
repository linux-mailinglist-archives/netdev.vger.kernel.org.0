Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8D1C4D78
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 06:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgEEE4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 00:56:21 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:25766 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgEEE4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 00:56:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588654580; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=PV7sEq8EmjCcuJpfW06q3OmdCQ5IpxPI2EjjZQwRIPw=; b=rgFe5dJ+dkpvCdcLwJLdPk3BJuQTuZ5qYzcYqJySGTtHvob4imSnFE78yXlMNmYvCEiN3UF8
 CFOW1/EuPSMrWp8lPIFNfJmoYfh9El7Y/LkW8Ob9dQG24ZEcXKHFnDJ6Rvo+yhJTRk55bfhw
 /apZg5Z+Rim28Lq7HmYvaMB495Q=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb0f1ea.7f3176e90500-smtp-out-n05;
 Tue, 05 May 2020 04:56:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 56675C433F2; Tue,  5 May 2020 04:56:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D601C433D2;
        Tue,  5 May 2020 04:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D601C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kazior <michal.kazior@tieto.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 04/15] ath10k: fix gcc-10 zero-length-bounds warnings
References: <20200430213101.135134-1-arnd@arndb.de>
        <20200430213101.135134-5-arnd@arndb.de>
        <49831bca-b9cf-4b9a-1a60-f4289e9c83c0@embeddedor.com>
        <87368flxui.fsf@codeaurora.org>
        <69f5c551-01ab-3b90-01a1-42514cd58f60@embeddedor.com>
Date:   Tue, 05 May 2020 07:56:03 +0300
In-Reply-To: <69f5c551-01ab-3b90-01a1-42514cd58f60@embeddedor.com> (Gustavo A.
        R. Silva's message of "Mon, 4 May 2020 11:09:21 -0500")
Message-ID: <87d07jdlp8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> On 5/4/20 06:54, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
>> 
>>> Hi Arnd,
>>>
>>> On 4/30/20 16:30, Arnd Bergmann wrote:
>>>> gcc-10 started warning about out-of-bounds access for zero-length
>>>> arrays:
>>>>
>>>> In file included from drivers/net/wireless/ath/ath10k/core.h:18,
>>>>                  from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
>>>> drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
>>>> drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
>>>>  1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
>>>>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
>>>>  1676 |  struct htt_tx_fetch_record records[0];
>>>>       |                             ^~~~~~~
>>>>
>>>> The structure was already converted to have a flexible-array member in
>>>> the past, but there are two zero-length members in the end and only
>>>> one of them can be a flexible-array member.
>>>>
>>>> Swap the two around to avoid the warning, as 'resp_ids' is not accessed
>>>> in a way that causes a warning.
>>>>
>>>> Fixes: 3ba225b506a2 ("treewide: Replace zero-length array with flexible-array member")
>>>> Fixes: 22e6b3bc5d96 ("ath10k: add new htt definitions")
>>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>>> ---
>>>>  drivers/net/wireless/ath/ath10k/htt.h | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
>>>> index e7096a73c6ca..7621f0a3dc77 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/htt.h
>>>> +++ b/drivers/net/wireless/ath/ath10k/htt.h
>>>> @@ -1673,8 +1673,8 @@ struct htt_tx_fetch_ind {
>>>>  	__le32 token;
>>>>  	__le16 num_resp_ids;
>>>>  	__le16 num_records;
>>>> -	struct htt_tx_fetch_record records[0];
>>>> -	__le32 resp_ids[]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
>>>> +	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
>>>> +	struct htt_tx_fetch_record records[];
>>>>  } __packed;
>>>>  
>>>>  static inline void *
>>>>
>>>
>>> The treewide patch is an experimental change and, as this change only applies
>>> to my -next tree, I will carry this patch in it, so other people don't have
>>> to worry about this at all.
>> 
>> Gustavo, why do you have ath10k patches in your tree? I prefer that
>> ath10k patches go through my ath.git tree so that they are reviewed and
>> tested.
>> 
>
> I just wanted to test out a mechanical change. I will remove it from my tree
> now and will send a patch to you so you can apply it to your ath.git tree.

Great, thanks.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
