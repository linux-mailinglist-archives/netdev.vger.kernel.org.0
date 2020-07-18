Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C39224D4B
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgGRRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 13:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgGRRUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 13:20:14 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E5DC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 10:20:14 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so14072320eje.1
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 10:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W56zHe/1mrHHqIt5x0QfmbeXnwkFvIgw/sYyts7J+24=;
        b=ayL6ulpQ6nAIPU8f/ucF2erXz0XQN7xh08++PLlWNuxHWuUD0vW6HbrTqYehqoguLC
         kqJismYBFOJFtMivI4XTDTjAsjNM4wMfF1dW6Z60IcrARoUiOcAzCrzpIoZYG2k9HwKn
         kT9bIjXJajJ+VfiJiWyre7lUvQr1fkFBCxJojMvNszEgo/mLFp9tEkkv3bnvJMkZbf8t
         n/jeuAI+EpHYkup3iBD5GQwFFqS4RySXa5LLdAPFi1jrOBTYLtzbXo9/UhTDFUgnxVUt
         yfTbFZBoMukgC9uyTLA4qfwbxVQm5BrgvnCtIRZmbldyaLldeEnNtQ8qcoP6JLwmFsZr
         BIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W56zHe/1mrHHqIt5x0QfmbeXnwkFvIgw/sYyts7J+24=;
        b=KSfGAV6x0i6fnAH2zdT4mbDSMXRFbskU9gWbK/31F/bVyxfRaElJsaIyraOepCYgwq
         TQCz/yB3baU0K6nSb3g1QRBBxbTRug4OJ4KFTYw0yubWTsuPLqL7KRwDPHGZhbSIC9Mw
         h8d/I7rT5v8BMyvIxFxHUeAcb8B1YLGkei5dnqVIKGzUzzfXT/o/ThkBOUlSZ9CL/xD1
         6o4jPAsnUo1nTkUwvSk7L77VnJv8LipBzKt/TK3aOP75sQHW715He0kQX67hHWGSeu3i
         swQbnI5iZgcyJ+YRi3NvFG6qfS6WWlcIkqDskcToFu3XzlawzrHDFGjYTR8z8xnDA5yc
         1T0Q==
X-Gm-Message-State: AOAM532DrPfbRmft8sEIrs4cJD67IE1Xv6fsB8rtP5UWn6XZRDYMROpd
        BgIdJzmOT3jBVt2WnmUl7GBrbFee
X-Google-Smtp-Source: ABdhPJy151hczcC2V2d2bwuQHhYxQ/pCy7yzPdB6jDQ/h6RZzF5RvCuakPV7n7TBtyTXuIqHoZjiZA==
X-Received: by 2002:a17:906:1414:: with SMTP id p20mr13489231ejc.247.1595092812603;
        Sat, 18 Jul 2020 10:20:12 -0700 (PDT)
Received: from [192.168.0.108] ([86.120.182.99])
        by smtp.gmail.com with ESMTPSA id b11sm11884883edw.76.2020.07.18.10.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 10:20:12 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/6] enetc: Add interrupt coalescing support
To:     Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
 <1595000224-6883-6-git-send-email-claudiu.manoil@nxp.com>
 <20200717123239.1ffb5966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <3852bad5-76ca-170c-0bd5-b2cc2156bfea@gmail.com>
Date:   Sat, 18 Jul 2020 20:20:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717123239.1ffb5966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.07.2020 22:32, Jakub Kicinski wrote:
> On Fri, 17 Jul 2020 18:37:03 +0300 Claudiu Manoil wrote:
>> +	if (ic->rx_max_coalesced_frames != ENETC_RXIC_PKTTHR)
>> +		netif_warn(priv, hw, ndev, "rx-frames fixed to %d\n",
>> +			   ENETC_RXIC_PKTTHR);
>> +
>> +	if (ic->tx_max_coalesced_frames != ENETC_TXIC_PKTTHR)
>> +		netif_warn(priv, hw, ndev, "tx-frames fixed to %d\n",
>> +			   ENETC_TXIC_PKTTHR);
> 
> On second thought - why not return an error here? Since only one value
> is supported seems like the right way to communicate to the users that
> they can't change this.
> 

Do you mean to return -EOPNOTSUPP without any error message instead?
If so, I think it's less punishing not to return an error code and 
invalidate the rest of the ethtool -C parameters that might have been
correct if the user forgets that rx/tx-frames cannot be changed.
There's also this flag:
	.supported_coalesce_params = .. |
				     ETHTOOL_COALESCE_MAX_FRAMES |
				     ..,
needed for printing the preconfigured values for the rx/tx packet 
thresholds, and this flag basically says that the 'rx/tx-frames'
parameters are supported (just that they cannot be changed... :) ).
But I don't have a strong bias for this, if you prefer the return
-EOPNOTSUPP option I'll make this change, just let me know if I got
it right.

>> +	if (netif_running(ndev) && changed) {
>> +		/* reconfigure the operation mode of h/w interrupts,
>> +		 * traffic needs to be paused in the process
>> +		 */
>> +		enetc_stop(ndev);
>> +		enetc_start(ndev);
> 
> Is start going to print an error when it fails? Kinda scary if this
> could turn into a silent failure.
> 

enetc_start() returns void, just like enetc_stop().  If you look it up
it only sets some run-time configurable registers and calls some basic
run-time commands that should no fail like napi_enable(), enable_irq(), 
phy_start(), all void returning functions. This function doesn't 
allocate resources or anything of that sort, and should be kept that 
way. And indeed, it should not fail. But regarding error codes there's
nothing I can do for this function, as nothing inside it generates any 
error code.
