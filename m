Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE62F17B8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbhAKOLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbhAKOLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:11:01 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE04C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:10:20 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q1so3527539ion.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p4gPS85WgcBWEG/vIrqLTp4qv3D2OF2vDVOi1Ibtz6I=;
        b=EV8n6JNN89ERFhRhorVPSVozDeYdI7RTS4rgbKSUJL/IHJB184UTzDrqRHUtE2qTYy
         Cv+sddzRViExLEOxdVp0IywFi/eTgmhu0ZMD2RnUSgg/A7tBej+X8GEGA/SZyGSfoKJR
         MwDXBCj4plivlq/MPsmw6zl6yUl9oI6AWHbkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p4gPS85WgcBWEG/vIrqLTp4qv3D2OF2vDVOi1Ibtz6I=;
        b=pv/f49CoBSZzzb3BZyWhdPar3EBNyhrzR7xmYj066phRpAVKUdFyfG6QrlNg2oBa0V
         SVmc8/Uw3rGbqZ1jtAo54osNS1C8hiIYTE8yajYgxyzrLitHcu6Z1i9prk7FjFFHErvz
         3R9yXckJsGQMnJS3Dd3zZOr1xDHH+dDkEyhxqWnffCcD5InJnXJ/PnMDUNhNWUsxOatM
         8PsC88Z5eBldRIJF7NnRAZrY8D+//Gwyugy3h2zHr1adM2eN48FhAJ9LHfMSek1COXu8
         1Tdg4KTaLUDv4fgl5IC5zj29lwGKSJUnyQ9Vu5Egmw5Ez1YT6nn8BsHAvTzF3oTvE437
         44KQ==
X-Gm-Message-State: AOAM531BfE263SaXrNY48eqT/jEInHoAzbTnEnbJAQ8VNtjBFsoKPxbW
        PmsOgNcPhy1WkLziv/hs1jGQDw==
X-Google-Smtp-Source: ABdhPJy1KzFoGbvpiGbbUlaipTCcpTvuyCaOibXXdPLvb7H/99xSqCM6ZIveX2yrHC4mVKgoVuevrQ==
X-Received: by 2002:a6b:5018:: with SMTP id e24mr14472331iob.184.1610374220053;
        Mon, 11 Jan 2021 06:10:20 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d5sm15111985ilf.33.2021.01.11.06.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 06:10:19 -0800 (PST)
Subject: Re: [PATCH net] net: ipa: modem: add missing SET_NETDEV_DEV() for
 proper sysfs links
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        aleksander@aleksander.es, andrewlassalle@chromium.org,
        Alex Elder <elder@kernel.org>
References: <20210106100755.56800-1-stephan@gerhold.net>
 <20210107184623.297798ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <5ffb23fe-2764-b940-1154-db774e29abe0@ieee.org>
Date:   Mon, 11 Jan 2021 08:10:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107184623.297798ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 8:46 PM, Jakub Kicinski wrote:
> On Wed,  6 Jan 2021 11:07:55 +0100 Stephan Gerhold wrote:
>> At the moment it is quite hard to identify the network interface
>> provided by IPA in userspace components: The network interface is
>> created as virtual device, without any link to the IPA device.
>> The interface name ("rmnet_ipa%d") is the only indication that the
>> network interface belongs to IPA, but this is not very reliable.
>>
>> Add SET_NETDEV_DEV() to associate the network interface with the
>> IPA parent device. This allows userspace services like ModemManager
>> to properly identify that this network interface is provided by IPA
>> and belongs to the modem.
>>
>> Cc: Alex Elder <elder@kernel.org>
>> Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
>> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> 
> Alex, can we get an ack?

Too late, but this looks good.  Thank you for applying it.
I don't always spot messages not "To:" me.  I still need to
improve my mail filtering.  Sorry about that.

					-Alex

