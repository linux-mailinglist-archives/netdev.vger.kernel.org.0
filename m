Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D72DDBAE
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgLQW6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:58:06 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:41422 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbgLQW6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 17:58:06 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id AE28313C2B0;
        Thu, 17 Dec 2020 14:57:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com AE28313C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608245845;
        bh=wKglh9KlDBoYb5sTHp2Zpmla8eV1kaQDIWTUPzEfRyo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cS/WEcr87wlLHpBF0id46WWTxCo51XmGYj77Tvo56pnMTrdwLdNB1MtH4HaHyOAjN
         k+8SxCI7rDeTEcSIPDsVOXRHUWtq7yCy9xsWK0ZvwduUSkfRkXuifou+H8Ku+zn8yO
         vDCDCIgoHcJwGiTSQV/1oN9T5wv6BwL5dbn9uSl4=
Subject: Re: [PATCH 0/3] mac80211: Trigger disconnect for STA during recovery
To:     Brian Norris <briannorris@chromium.org>
Cc:     Youghandhar Chintala <youghand@codeaurora.org>,
        johannes@sipsolutions.net, ath10k@lists.infradead.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, pillair@codeaurora.org
References: <20201215172113.5038-1-youghand@codeaurora.org>
 <18dfa52b-5edd-f737-49c9-f532c1c10ba2@candelatech.com>
 <X9vaqxub2F/8YPT8@google.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <6cec8a4c-620f-093d-2739-7eafe89cd79a@candelatech.com>
Date:   Thu, 17 Dec 2020 14:57:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <X9vaqxub2F/8YPT8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/20 2:24 PM, Brian Norris wrote:
> On Tue, Dec 15, 2020 at 10:23:33AM -0800, Ben Greear wrote:
>> On 12/15/20 9:21 AM, Youghandhar Chintala wrote:
>>> From: Rakesh Pillai <pillair@codeaurora.org>
>>>
>>> Currently in case of target hardware restart ,we just reconfig and
>>> re-enable the security keys and enable the network queues to start
>>> data traffic back from where it was interrupted.
>>
>> Are there any known mac80211 radios/drivers that *can* support seamless restarts?
>>
>> If not, then just could always enable this feature in mac80211?
> 
> I'm quite sure that iwlwifi intentionally supports a seamless restart.
>  From my experience with dealing with user reports, I don't recall any
> issues where restart didn't function as expected, unless there was some
> deeper underlying failure (e.g., hardware/power failure; driver bugs /
> lockups).
> 
> I don't have very good stats for ath10k/QCA6174, but it survives
> our testing OK and I again don't recall any user-reported complaints in
> this area. I'd say this is a weaker example though, as I don't have as
> clear of data. (By contrast, ath10k/WCN399x, which Rakesh, et al, are
> patching here, does not pass our tests at all, and clearly fails to
> recover from "seamless" restarts, as noted in patch 3.)
> 
> I'd also note that we don't operate in AP mode -- only STA -- and IIRC
> Ben, you've complained about AP mode in the past.

I complain about all sorts of things, but I'm usually running
station mode :)

Do you actually see iwlwifi stations stay associated through
firmware crashes?

Anyway, happy to hear some have seamless recovery, and in that case,
I have no objections to the patch.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
